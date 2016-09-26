/******************************************** 
*@Author:Cognizant
*@Date:September 2015
*@Description : Sends chatter notification when Department ,Category, Company, Function or Subfunction of user is changed.
*********************************************/

public with sharing class IPM_NotifyUsersRoleChanged {
    
    private static Set<Id> projectIds= new Set<Id>();
    private static Set<Id> mentionIds= new Set<Id>();
    private static Map<Id, Set<Id>> subjectIdMentionIdSetMap = new Map<Id, Set<Id>> ();
    private static Map<Id, String> subjectIdMessageMap = new Map<Id, String>();
    private static String posttext;
    private static final String CLASS_NAME = IPM_NotifyUsersRoleChanged.class.getName();
    private static final String EXECUTE_METHOD = 'notifyIfUserRoleChanged';
    private static final String ERROR_STR = 'Error';
    public static String excpMsg;
    
    /*Description:- @Invocable method will be called from process builder 'User changed roles'. 
                             This method will send chatter notification when Department ,Category, Company, Function or Subfunction of user is changed.
        @param userIdLst:- User for which Department ,Category, Company, Function or Subfunction is changed.
    */
    @InvocableMethod
    public static void notifyIfUserRoleChanged(List<Id> userIdLst) {
        Set<Id> changedUserIdSet = new Set<Id>();
        changedUserIdSet.addAll(userIdLst);
        
        try{
        Map<Id, IPM_Project__c> projectMap = new Map <Id, IPM_Project__c>([
                                      SELECT Id, IPM_Project_Leader__c, Deputy_Project_Leader__c, IPM_Technical_Project_Leader__c,IPM_Project_Gatekeeper__c, IPM_Finance_Lead__c,
                                      IPM_Project_Leader__r.Name, Deputy_Project_Leader__r.Name, IPM_Technical_Project_Leader__r.Name,IPM_Project_Gatekeeper__r.Name, IPM_Finance_Lead__r.Name
                                      FROM IPM_Project__c
                                      WHERE IPM_Project_Leader__c IN : changedUserIdSet
                                      OR Deputy_Project_Leader__c IN : changedUserIdSet
                                      OR IPM_Technical_Project_Leader__c IN : changedUserIdSet
                                      OR IPM_Project_Gatekeeper__c IN : changedUserIdSet Limit 50000
                                     ]);
                                     
        Map<Id,IPM_Project_Resource__c> prjResourceMap = new Map<Id, IPM_Project_Resource__c>([
                                            SELECT Id, IPM_User__c, IPM_User__r.Name, IPM_Project__c, IPM_Project__r.IPM_Project_Leader__c, IPM_Project__r.Deputy_Project_Leader__c
                                            FROM IPM_Project_Resource__c
                                            WHERE IPM_User__c IN : changedUserIdSet Limit 50000
                                        ]); 
                                        
        //Comment :- SOQL For loops are not used because those will be repeated for each execution of 'changedUserIdSet' for loop                                   
        for(Id userId : changedUserIdSet){
            
            for(IPM_Project__c project : projectMap.values()){
                String userName = '';
                if(userId == project.IPM_Project_Leader__c)
                {
                    prepareProjectIdNotificationData(project.Id, project.IPM_Project_Leader__r.Name, project.IPM_Project_Leader__c, project.Deputy_Project_Leader__c);
                }    
                
               		if(userId == project.IPM_Project_Leader__c)  
               		{
               			userName = project.IPM_Project_Leader__r.Name;
               		}	
                	else if(userId == project.Deputy_Project_Leader__c) 
                	{
                		userName = project.Deputy_Project_Leader__r.Name;
                	}
                	else if(userId == project.IPM_Technical_Project_Leader__c) 
                	{
                		userName = project.IPM_Technical_Project_Leader__r.Name;
                	}	
                	else if(userId == project.IPM_Project_Gatekeeper__c) 
                	{
                		userName = project.IPM_Project_Gatekeeper__r.Name;
                	}
                	else if(userId == project.IPM_Finance_Lead__c) 
                	{
                		userName = project.IPM_Finance_Lead__r.Name;
                	} 
                
                if(string.isNotBlank(userName))
                {
                	prepareProjectIdNotificationData(project.Id,userName, project.IPM_Project_Leader__c, project.Deputy_Project_Leader__c);
                } 
            }
            
            for(IPM_Project_Resource__c prjResource : prjResourceMap.values()){
                if( userId == prjResource.IPM_User__c){
                    prepareProjectIdNotificationData(prjResource.IPM_Project__c, prjResource.IPM_User__r.Name, prjResource.IPM_Project__r.IPM_Project_Leader__c, prjResource.IPM_Project__r.Deputy_Project_Leader__c);
                }
            }
        }//UserId for loop ends here    
        
        IPM_ChatterUtils.postChatterFeedWithMention(projectIds,subjectIdMessageMap,subjectIdMentionIdSetMap);
        
       }catch(System.Exception ex){ // Generalized exception
            excpMsg = ex.getMessage();
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,EXECUTE_METHOD,excpMsg,ex, ERROR_STR, null, null, null,null);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,system.label.IPM_System_Admin));         
        }     
    }
    
    /*Description: This method will prepare data fo sending chatter notifications.
    @param projectId:- Id of the project to notify for
    @param sUserName:- Username for which notification should be send
    @param notifyPLId:- PL of the project to notify to
    @param notifyDPLId:- Deputy PL of the project to notify to
    */
    private static void prepareProjectIdNotificationData(Id projectId, String sUserName, Id notifyPLId, Id notifyDPLId){
        projectIds.add(projectId);
        mentionIds= new Set<Id>();  
        mentionIds.add(notifyPLId);
        mentionIds.add(notifyDPLId);
        subjectIdMentionIdSetMap.put(projectId,mentionIds);
                    
        posttext = IPM_ConstantUtils.IPM_SPACE + sUserName + IPM_ConstantUtils.IPM_SPACE + System.Label.IPM_Not_Performing_Same_role;
        subjectIdMessageMap.put(projectId,posttext);
        posttext = null;
        
    }
	
}