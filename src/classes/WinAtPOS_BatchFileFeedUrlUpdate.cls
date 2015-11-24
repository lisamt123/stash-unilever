/**********************************************************************
Name: WinAtPOS_BatchFileFeedUrlUpdate
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Batchable class which resposible for populating Feed_URL__c values for file__c 
object records 

============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          01/12/2014     INITIAL DEVELOPMENT
**********************************************************************/
global class WinAtPOS_BatchFileFeedUrlUpdate implements Database.Batchable<sObject>,Database.Stateful {
    global integer totalFilesToPorcess=0;
    global integer totalFilesWhichWereProcessed=0;
    global String errorsOccuredWhileFileUpdate='';
    global final String query;
    
    /*******************************************************************
	Purpose: Method return list of files 
	Parameters: [Database.BatchableContext BC]
	Returns: [Database.QueryLocator]
	Throws [Exceptions]: [optional] 
	********************************************************************/
	global Database.QueryLocator start(Database.BatchableContext BC){
      String query='select id,Feed_ID__c, Feed_Thumbnail_URL__c, Feed_URL__c,File_Size_Bytes__c from File__c where Feed_ID__c != null and Feed_URL__c = null limit 200';  
      return Database.getQueryLocator(query);
   }
	
   /*******************************************************************
	Purpose: Method processing file update 
	Parameters: [Database.BatchableContext BC,List<sObject> scope]
	********************************************************************/ 
   global void execute(Database.BatchableContext BC, List<sObject> scope){
     List<File__c> filesToUpdate=new List<File__c>();
     totalFilesToPorcess +=scope.size();  
     for(File__c f : (List<File__c>)scope){
         try{
            ConnectApi.FeedElement fi = ConnectApi.ChatterFeeds.getFeedElement(null, f.Feed_ID__c);      
            ConnectApi.ContentCapability ca = (ConnectApi.ContentCapability) fi.capabilities.content;
    
            f.Feed_URL__c = ca.downloadUrl;
            if (ca.renditionUrl != null) {
                f.Feed_Thumbnail_URL__c = ca.renditionUrl.replace('THUMB120BY90', 'THUMB720BY480');
            }
            filesToUpdate.add(f);
        }catch(Exception ex){
            errorsOccuredWhileFileUpdate += '\n there was problem with following file update: '+f.id+' rootCause:'+ex.getMessage();
        }
     }
     totalFilesWhichWereProcessed +=filesToUpdate.size();
     update filesToUpdate;
    }
	
   /*******************************************************************
	Purpose: Method executed when batch ending processing 
	Parameters: [Database.BatchableContext BC,List<sObject> scope]
	********************************************************************/  
   global void finish(Database.BatchableContext BC){
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       mail.setToAddresses(new List<String>{UserInfo.getUserEmail()});
       mail.setSubject('WinAtPOS_BatchFileFeedUrlUpdate finished processing');
       String emailBody='WinAtPOS_BatchFileFeedUrlUpdate finished processing below results:\n';
       emailBody += 'Total files to process: '+totalFilesToPorcess+'\n';
       emailBody += 'Total files which were processed: '+totalFilesWhichWereProcessed+'\n';
       emailBody += 'For below files update was not successfull:\n'+errorsOccuredWhileFileUpdate+'\n';
       mail.setPlainTextBody(emailBody);
       if(!Test.isRunningTest()){Messaging.sendEmail(new LIST<Messaging.SingleEmailMessage> {mail});}
   }

}