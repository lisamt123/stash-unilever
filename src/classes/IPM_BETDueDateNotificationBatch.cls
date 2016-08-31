/******************************************** 
*@Author:Cognizant
*@Date:September 2015
*@Description : Sends chatter notification and mail when BET Due Date is 15 days approaching
* This class is set as Without Sharing as the Batch class needs to send Notifications to all
* eligible users irrespective of who schedules batch class. Ideally the bacth class wil be 
* scheduled by an Admin user.
* This class has been declared as Global as it implemets Databse.Batchable interface.
*********************************************/

global without sharing class IPM_BETDueDateNotificationBatch implements Database.Batchable<sObject>  {
    
    private static final integer DAY_VALUE = 15;
    private Integer dateValue = 0;
    private map<Id,String> projIdchatterMessageMap ;//contains project id as key and repective chatter message as value
    private Set<Id> projIdNewProjectsSet ;// set of project ids
    private map<Id,Set<Id>> subjectIdMentionIdSetMap ;//project id as key and respective PL's id set as value
    private Set<Id> projLeadSet ;//project leaders id set 
    private static final String DATEFORMAT='dd MMMM yyyy';
    
    global Database.QueryLocator start(Database.BatchableContext bC) {
        
        // Used in dynamic Query. 
        Date dueInFifteeneDays = system.today().addDays(15); // Milestones approaching due date in next 15 days. // variable used in query below NO SONAR
        
        String query = 'SELECT BET_MS_First_Release_Date__c,BET_MS_Final_Release_Date__c,Deputy_Project_Leader__c,IPM_Project_Leader__c,';
        query += 'IPM_Project_Name__c,Is_Archieved__c,IPM_Target_Launch_Dates__c,(SELECT IPM_Project_Leader__c from IPM_Projects__r) from IPM_Project__c ';
        query += 'WHERE BET_MS_First_Release_Date__c =: dueInFifteeneDays or BET_MS_Final_Release_Date__c =: dueInFifteeneDays';
        
        return Database.getQueryLocator(query);
    }
    
    /*excute method of batch class*/
    global void execute(Database.BatchableContext bC, List<IPM_Project__c> updatedProjectsList) {
        
        projIdchatterMessageMap = new map<Id,String>();
        projIdNewProjectsSet = new Set<Id>();
        subjectIdMentionIdSetMap = new map<Id,Set<Id>>();
        projLeadSet = new Set<Id>();
        
        if(updatedProjectsList != null && !updatedProjectsList.isEmpty())
        {   
            for(IPM_Project__c eachProject :updatedProjectsList)
            {
                // Used in dynamic Query. 
            	Datetime targetLaunchDate=datetime.newInstance(eachProject.IPM_Target_Launch_Dates__c.year(),eachProject.IPM_Target_Launch_Dates__c.month(),eachProject.IPM_Target_Launch_Dates__c.day());
                
                //post chatter feed for BET First release
                if(String.IsNotBlank(String.valueOf(eachProject.BET_MS_First_Release_Date__c)) && !eachProject.Is_Archieved__c)
                {
                	Datetime betFirstReleaseDate=datetime.newInstance(eachProject.BET_MS_First_Release_Date__c.year(),eachProject.BET_MS_First_Release_Date__c.month(),eachProject.BET_MS_First_Release_Date__c.day());
                    chatterFeedForBETRelease(eachProject,eachProject.BET_MS_First_Release_Date__c,IPM_ConstantUtils.BET_FIRST_RELEASE_MESSAGE_STR1 + targetLaunchDate.format(DATEFORMAT) + IPM_ConstantUtils.BET_FIRST_RELEASE_MESSAGE_STR2+betFirstReleaseDate.format(DATEFORMAT));
                }
                //post chatter feed for BET Final release
                if(String.IsNotBlank(String.valueOf(eachProject.BET_MS_Final_Release_Date__c)) && !eachProject.Is_Archieved__c)
                {
                	Datetime betFinalReleaseDate=datetime.newInstance(eachProject.BET_MS_Final_Release_Date__c.year(),eachProject.BET_MS_Final_Release_Date__c.month(),eachProject.BET_MS_Final_Release_Date__c.day());
                    chatterFeedForBETRelease(eachProject,eachProject.BET_MS_Final_Release_Date__c,IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1 + targetLaunchDate.format(DATEFORMAT) + IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR2+betFinalReleaseDate.format(DATEFORMAT));
                }
            } 
        }        
    }   
    /*finish method of batch class*/
    global void finish(Database.BatchableContext bC) {
    	
    	//sends an email for job status, after the job is completed.
    	  IPM_Utils.sendApexJobStatusMail(bC);
    }
    
    /*Check if the BET Milestone release date is in 15 days then post chatter feed */
    private void chatterFeedForBETRelease(IPM_Project__c eachProject,Date BETReleaseDate,string BETMessage)
    {
        if(eachProject != null && String.IsNotBlank(String.valueOf(BETReleaseDate)))
        {
            //calculates the days between today and BET Release date
            dateValue = Date.valueOf(System.today()).daysBetween(Date.valueOf(BETReleaseDate));
                
            //if it is in 15 days then get all the PLs 
            if(dateValue == DAY_VALUE && dateValue >0)
            {
                if(eachProject.IPM_Project_Leader__c != null )
                {
                    projLeadSet.add(eachProject.IPM_Project_Leader__c);
                }
                if(eachProject.Deputy_Project_Leader__c != null )      
                {
                    projLeadSet.add(eachProject.Deputy_Project_Leader__c);
                }
                for(IPM_Project__c relatedLeaders:eachProject.IPM_Projects__r){
                    projLeadSet.add(relatedLeaders.IPM_Project_Leader__c);
                }
                projIdNewProjectsSet.add(eachProject.id);
                subjectIdMentionIdSetMap.put(eachProject.id,projLeadSet);
                projIdchatterMessageMap.put(eachProject.id,IPM_ConstantUtils.COMMA+ eachProject.IPM_Project_Name__c +BETMessage);
                IPM_ChatterUtils.postChatterFeedWithMention(projIdNewProjectsSet, projIdchatterMessageMap, subjectIdMentionIdSetMap );
                projLeadSet.clear();  
            }
        }
    }
}