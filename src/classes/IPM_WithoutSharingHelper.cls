/**
    Purpose: Helper class for all the mandatory without sharing business logic, purposely kept without sharing
    Author: Cognizant Technology
    @Date: Nov 2015
    This class has been specifically created to write general without sharing business logic. For e.g. the methods included in this 
    class require to insert subscription records for the object EntitySubscription. This needs mandatory without sharing.
**/
public without sharing class IPM_WithoutSharingHelper {
    
    private static final String AS_STR= ' as a ';
    private static final String ASSIGNED_STR =' You have been assigned to ';
    private static Set<Id> projectIds= new Set<Id>();
    private static Map<Id, String> subjectIdMessageMap = new Map<Id, String>();
    private static Map<Id,Set<Id>> subjectIdMentionIdMap = new Map<Id,Set<Id>>();
    private static Set<Id> mentionId = new Set<Id>();

/*******************************************************************************************************
    * @description: Whenever a team member is added to a project, this method will auto subscribe that user to the chatter feed of the project record.
    * @param1 - newProjectResources: The list of IPM_Project_Resource__c object
    */ 
    public static void autoFollowTeamMembers(IPM_Project_Resource__c[] newProjectResources) {
        projectIds= new Set<Id>();
        subjectIdMessageMap = new Map<Id, String>();
        subjectIdMentionIdMap = new Map<Id,Set<Id>>();
        String posttext;
        
        for(IPM_Project_Resource__c eachID: newProjectResources)
        {
            projectIds.add(eachID.IPM_Project__c);
        }

        Map<Id, IPM_Project__c> projNames = IPM_Utils.getProjectDetails(projectIds);
        for(IPM_Project_Resource__c eachResource:newProjectResources)
        {
            for(IPM_Project__c eachName:projNames.values())
            {
                if(eachName.id == eachResource.IPM_Project__c)
                {
                    if(!IPM_ConstantUtils.TEAM_GUEST.equalsIgnoreCase(eachResource.IPM_Role_Type__c))
                    {
                        posttext = ASSIGNED_STR+eachName.Name+AS_STR+
                        eachResource.IPM_Role_Type__c+System.Label.IPM_Check_The_Project;
                        subjectIdMessageMap.put(eachName.id,posttext);
                        mentionId.add(eachResource.IPM_User__c);
                        subjectIdMentionIdMap.put(eachName.id,mentionId);
                    }
                }   
            }   
        }
        //Also post to the project chatter about the user being added.
        IPM_ChatterUtils.postChatterFeedWithMention(projectIds, subjectIdMessageMap,subjectIdMentionIdMap);
        IPM_ChatterFeedHelper.clearData();
        
        Map<Id, Set<Id>> projectUserMap = IPM_ChatterFeedHelper.getProjectUserMap(newProjectResources); //output of the method
        Map<String, Boolean> projectSubscribedUsers = IPM_ChatterFeedHelper.getSubscribedUser(projectUserMap.keySet());
        List<EntitySubscription> subscriptionRecordsToCreate = new List<EntitySubscription>();//sub entities to create
        for(Id eachProject : projectUserMap.keySet()) {
            for(Id eachUser : projectUserMap.get(eachProject)) {
                String key = eachProject + IPM_ConstantUtils.HYPHEN_DELIMITER + eachUser;
                if(!projectSubscribedUsers.containskey(key)) {
                    subscriptionRecordsToCreate.add(IPM_ChatterFeedHelper.buildSubscriptionObj(eachUser, eachProject));
                } 
            }
        }
       
       if(!subscriptionRecordsToCreate.isEmpty())
       {
            insert subscriptionRecordsToCreate;
       }    
       
  }
  
  /*******************************************************************************************************
    * @description: There is a design flaw which has got some users lookup to the project object apart from the project resources.
    *               This method subscribes those users to the project record.
    * @param1 - projectUserMap: Customised key of the map which stores the user records projects wise
    * @Returns : Returns the map of the customised key with boolean values being subscribed or not accordingly
    */
    public static void autoFollowProjectMembers(Map<Id, Set<Id>> projectUserMap) {
        IPM_ChatterFeedHelper.clearData();
        String posttext;
        Set<Id> projIds= new Set<Id>();
        projIds.addAll(projectUserMap.keyset());
        
        List<IPM_Project__c> projectDetails = [select IPM_Project_Name__c,IPM_Project_Gatekeeper__c,IPM_Finance_Member__c,
        IPM_Technical_Project_Leader__c,IPM_Project_Leader__c,Deputy_Project_Leader__c from IPM_Project__c where id IN :projIds LIMIT:IPM_ConstantUtils.MaxLimit];

         for(Id eachRecord : projIds) 
         {
           for(IPM_Project__c eachProject :projectDetails)
           {
               if(eachRecord == eachProject.id)
               {   
                    if(projectUserMap.get(eachRecord).contains(eachProject.IPM_Project_Leader__c))  //&& eachProject.IPM_Project_Name__c != null
                    {
                        posttext = ASSIGNED_STR+ eachProject.IPM_Project_Name__c+AS_STR+
                        IPM_ConstantUtils.PROJECT_LEADER+IPM_ConstantUtils.IPM_SPACE+System.Label.IPM_Check_The_Project;
                    }
                    
                    if(projectUserMap.get(eachRecord).contains(eachProject.Deputy_Project_Leader__c))
                    {
                        posttext = ASSIGNED_STR+ eachProject.IPM_Project_Name__c+AS_STR+
                        IPM_ConstantUtils.TEAM_DEPUTY_PROJECT_LEADER+IPM_ConstantUtils.IPM_SPACE+System.Label.IPM_Check_The_Project;
                    }
                    
                    if(projectUserMap.get(eachRecord).contains(eachProject.IPM_Technical_Project_Leader__c))
                    {
                        posttext = ASSIGNED_STR+ eachProject.IPM_Project_Name__c+AS_STR+
                        IPM_ConstantUtils.TEAM_TECHNICAL_PROJECT_LEADER+IPM_ConstantUtils.IPM_SPACE+System.Label.IPM_Check_The_Project;
                    }
                    
                    if(projectUserMap.get(eachRecord).contains(eachProject.IPM_Finance_Member__c))
                    {
                        posttext = ASSIGNED_STR+ eachProject.IPM_Project_Name__c+AS_STR+
                        IPM_ConstantUtils.FINANCE_MEMBER_CONSTANT+IPM_ConstantUtils.IPM_SPACE+System.Label.IPM_Check_The_Project;
                    }
                    
                    if(projectUserMap.get(eachRecord).contains(eachProject.IPM_Project_Gatekeeper__c))
                    {
                        projectUserMap.remove(eachRecord); 
                    }
                    
                }   
            }
        }
        
        List<EntitySubscription> subscriptionRecordsToCreate = new List<EntitySubscription>();
        Map<String, Boolean> projectSubscribedUsers = IPM_ChatterFeedHelper.getSubscribedUser(projectUserMap.keySet());

        for(Id eachProject : projectUserMap.keySet()) {
            for(Id eachUser : projectUserMap.get(eachProject)) {
                String key = eachProject + IPM_ConstantUtils.HYPHEN_DELIMITER + eachUser;
                
                if(!projectSubscribedUsers.containskey(key)) {
                    subscriptionRecordsToCreate.add(IPM_ChatterFeedHelper.buildSubscriptionObj(eachUser, eachProject));
                } 
            }
        }
        
            if(subscriptionRecordsToCreate != null && !subscriptionRecordsToCreate.isEmpty())
            {
                insert subscriptionRecordsToCreate;
            }    
           
        IPM_ChatterFeedHelper.postChatterUpdateToRecord(projectUserMap, posttext);
    }
    
}