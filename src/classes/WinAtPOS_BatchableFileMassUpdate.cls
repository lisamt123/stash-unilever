/**********************************************************************
Name: WinAtPOS_BatchableFileMassUpdate
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Batchable class which resposible for populating values for file__c 
object records 

============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          01/12/2014     INITIAL DEVELOPMENT
**********************************************************************/

global class WinAtPOS_BatchableFileMassUpdate implements Database.Batchable<sObject>,Database.Stateful {
    
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
      String query='select id,Feed_ID__c,File_Size_Bytes__c from File__c where Feed_ID__c != null and File_Size_Bytes__c = null';  
      return Database.getQueryLocator(query);
   }
	
   /*******************************************************************
	Purpose: Method processing file update 
	Parameters: [Database.BatchableContext BC,List<sObject> scope]
	********************************************************************/ 
   global void execute(Database.BatchableContext BC, List<sObject> scope){
     List<File__c> filesToUpdate=new List<File__c>();
     Map<String,File__c> feedMapForFile=new Map<String,File__c>();  
     totalFilesToPorcess +=scope.size();  
     for(File__c f : (List<File__c>)scope){
         feedMapForFile.put(f.Feed_ID__c,f);
     }
     //update file size only if list of files to update is not empty  
     if(feedMapForFile.keySet().size()>0){
         for(FeedItem fItem : [SELECT ContentFileName,ContentSize,ContentType,Id,Type FROM FeedItem where Type='ContentPost' and id in : feedMapForFile.keySet()]){
             if(feedMapForFile.containsKey(fItem.id)){
                 File__c tmpFile=feedMapForFile.get(fItem.id);
                 tmpFile.File_Size_Bytes__c=fItem.ContentSize;
                 filesToUpdate.add(tmpFile);
             }
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
       mail.setSubject('WinAtPOS_BatchableFileMassUpdate finished processing');
       String emailBody='WinAtPOS_BatchableFileMassUpdate finished processing below results:\n';
       emailBody += 'Total files to process: '+totalFilesToPorcess+'\n';
       emailBody += 'Total files which were processed: '+totalFilesWhichWereProcessed+'\n';
       mail.setPlainTextBody(emailBody);
       if(!Test.isRunningTest()){Messaging.sendEmail(new LIST<Messaging.SingleEmailMessage> {mail});}
   }
}