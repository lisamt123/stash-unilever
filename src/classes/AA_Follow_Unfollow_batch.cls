global with sharing class AA_Follow_Unfollow_batch implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        // fetching Agent app user ids    
        String query = 'SELECT UserId__c FROM aa_Agent_App_User_Preference__c where Auto_follow__c=true';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<aa_Agent_App_User_Preference__c> scope)
    {   
    	// Calling the static method   
        AA_Follow_Unfollow_class.ExecuteFollowUnFollow(scope);  
    }  
    global void finish(Database.BatchableContext BC)
    {
        // setting last batch job run time to limit the query in batch execution 
        aa_agent_app_custom_setting__c  objCS = [SELECT id FROM aa_agent_app_custom_setting__c WHERE name = 'Follow Batch Last Run Time'];
        objCS .Value__c = String.valueOf(dateTime.now()) ;
        Update objCS;
    }
}