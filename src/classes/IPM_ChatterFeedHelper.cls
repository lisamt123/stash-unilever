/**
    Purpose: Business logic resides in this class Chatter Notification class to fire notifications.
    Author: Cognizant Technology
    @Date: Dec 2014
    Justification:Devops approved Without Sharing. This resolves issue while running test classes in preprod on the Entity Subscription object (more than 100000 rows) 
                  and getting non selective query error
**/
public without sharing class IPM_ChatterFeedHelper {
    
    /* The constant variables which helps in contextual messagings of the chatter message.
     * The names are pretty much self-explanatory, needs no further elucidations.
    */
    private static final String CLASS_NAME = IPM_ChatterFeedHelper.class.getName(); //Class Name for Exception Logging
    private static final String CREATED= ' has been created!';
    private static final String CHANGED=' has changed ';
    private static final String REGIONAL_ROLLOUT_ADDED_STR1 = ' will be automatically created in IPM Navigator when ';
    private static final String REGIONAL_ROLLOUT_ADDED_STR2= ' passes Charter.';
    private static final String REGIONAL_ROLLOUT_ADDED_STR5='If you are not the correct  Regional Project Leader, then please notify the Global Project Leader ';
    private static final String REGIONAL_ROLLOUT_ADDED_STR3= ' as the Regional Project Leader. The Regional rollout ';
    private static final String REGIONAL_ROLLOUT_ADDED_STR4= ' project scope. You have been added to ';
    private static final String FAST_TRACK_STATUS_STR=' has changed the Fast Track status of project ';
    private static final String TO_FAST_TRACK_STR =' to Fast track';
    private static final String TO_NOT_FAST_TRACK_STR =' to Not Fast track';
    private static final String FINANCIALS_STR1='The financials for ';
    private static final String FINANCIALS_STR2=' projects and ';
    private static final String FINANCIALS_STR3=' are no longer aligned. Please contact your BD/BB Finance partner to re-align the business cases';
    private static final String FINANCIALS_STR5=' are succesfully aligned.';
    private static final String PLANNED_STR='Planned ';

    private static Set<Id> projectIds= new Set<Id>();
    private static Map<Id, String> subjectIdMessageMap = new Map<Id, String>();
    private static Map<Id,Set<Id>> subjectIdMentionIdMap = new Map<Id,Set<Id>>();
    private static Set<Id> mentionId = new Set<Id>();
    
    
    /*******************************************************************************************************
    * @description: Intermediate method to return a customised key map for the users being already subscribed.
    * @param1 - parentIds: The list of IPM_Project_Resource__c object
    * @Returns : Returns the map of the customised key with boolean values being subscribed or not accordingly
    */
    public static Map<String, Boolean> getSubscribedUser(Set<Id> parentIds) {
        
        parentIds.remove(null);
        Map<String, Boolean> parentSubscriberMapToReturn = new Map<String, Boolean>(); //var to return
        if(parentIds != null && !parentIds.isEmpty())
        {
        EntitySubscription[] subscriptionList = [SELECT 
                                                   ParentId, SubscriberId FROM EntitySubscription
                                                   WHERE ParentId IN :parentIds ORDER BY CreatedDate DESC LIMIT 499];
        for(Id eachProject : parentIds) {
            for(EntitySubscription eachSubscription : subscriptionList) {
                if(eachProject == eachSubscription.ParentId) {
                    String key = eachProject + IPM_ConstantUtils.HYPHEN_DELIMITER + eachSubscription.SubscriberId;
                    parentSubscriberMapToReturn.put(key, true);
                }
            }
        }
        }
        
        return parentSubscriberMapToReturn;
    }
    
    /*******************************************************************************************************
    * @description: This method will post to the chatter feed depending on the user being added to the project
    * @param1 - recordUserMap: Customised key of the map which stores the user records projects wise
    * @param2 - postText: The message to be posted.
    */
    public static void postChatterUpdateToRecord(Map<Id, Set<Id>> recordUserMap, String postText) {
        
        for(Id eachRecord : recordUserMap.keySet()) {
           subjectIdMessageMap.put(eachRecord,postText);
           subjectIdMentionIdMap.put(eachRecord,recordUserMap.get(eachRecord));
        }
        
        IPM_ChatterUtils.postChatterFeedWithMention(recordUserMap.keySet(),subjectIdMessageMap,subjectIdMentionIdMap);
    }
    
    /*******************************************************************************************************
    * @description: this method is being called from taskhelper class which posts to record with given messages dynamically.
    * @param1 - projectOwnerMap: Map to store project sObject with project owner wise
    * @param2 - pResourceDetails: The map which stores the team member wise data & the dynamic post message.
    */
    public static void postChatterUpdateToUser(Map<Id, IPM_Project__c> projectOwnerMap, Map<Id, String> pResourceDetails) {
       Set<Id> userIds=  new Set<Id>();             
       for(Id eachProject : projectOwnerMap.keySet()) {
            String postText = getPostMessage(projectOwnerMap.get(eachProject).Name, pResourceDetails.get(eachProject));
            mentionId.add(projectOwnerMap.get(eachProject).IPM_Project_Leader__c);
           subjectIdMessageMap.put(UserInfo.getUserId(),postText);
           subjectIdMentionIdMap.put(UserInfo.getUserId(),mentionId);
           userIds.add(UserInfo.getUserId());
        }
         IPM_ChatterUtils.postChatterFeedWithMention(userIds,subjectIdMessageMap,subjectIdMentionIdMap);
    }
    /*******************************************************************************************************
    * @description: Prepares the dynamic message
    * @param1 - projectName: Name of the project
    * @param2 - projectMessage: The message.
    * @returns : Dynamic message
    */
    public static String getPostMessage(String projectName, String projectMessage) {
        
        String msgToReturn = projectName;
        msgToReturn +=  IPM_ConstantUtils.IPM_SPACE+Label.IPM_User_Changed_Roles+IPM_ConstantUtils.IPM_SPACE; //ext constant variable
        msgToReturn += projectMessage;
        
        return msgToReturn;
    }
    
    /*******************************************************************************************************
    * @description: Brings together the data from the team project resources.
    * @param1 - newProjectResources: List of the IPM_Project_Resource__c object
    * @returns : list of team members project wise.
    */
    public static Map<Id, Set<Id>> getProjectUserMap(IPM_Project_Resource__c[] newProjectResources) {
        
        Map<Id, Set<Id>> projectUserMapToReturn = new Map<Id, Set<Id>>();//var to return
        for(IPM_Project_Resource__c eachPResource : newProjectResources) {
            if(!projectUserMapToReturn.containsKey(eachPResource.IPM_Project__c)) {
                set<Id> tmpSet = new Set<Id>();
                tmpSet.add(eachPResource.IPM_User__c);
                projectUserMapToReturn.put(eachPResource.IPM_Project__c, tmpSet);
            } else {
                projectUserMapToReturn.get(eachPResource.IPM_Project__c).add(eachPResource.IPM_User__c);
            }
        }
        
        return projectUserMapToReturn;
    }
    
    /*******************************************************************************************************
    * @description: Builds subcription object
    * @param1 - follower: id of the follower
    * @param2 - toFollow: id of the record to follow
    * @returns : sObject detail for EntitySubscription
    */
    public static EntitySubscription buildSubscriptionObj(Id follower, Id toFollow) {
        
        EntitySubscription subToReturn = new EntitySubscription();//var to return
        subToReturn.SubscriberId = follower;
        subToReturn.ParentId = toFollow;
        return subToReturn;
    }
    /*******************************************************************************************************
    * @description: Implicit method to check if the user is already subscribed to a record or not
    * @param1 - projectUserMap: project User map which stores ids of the users project wise
    * @returns : Customised key of the map with bool value
    */
    private static Map<String, Boolean> checkExistingSubscriber(Map<Id, Set<Id>> projectUserMap) {
        
        Map<String, Boolean> existingProjectUserMap = new Map<String, Boolean>(); //var to return
        //find out if this user is any team member currently in the project
        IPM_Project__c[] ipmTeam = [SELECT IPM_Project_Leader__c, IPM_Technical_Project_Leader__c, Deputy_Project_Leader__c, 
                                                   IPM_Finance_Lead__c, IPM_Project_Gatekeeper__c,
                                           (SELECT IPM_User__c FROM IPM_Project_Resources__r)
                                               FROM IPM_Project__c 
                                               WHERE Id IN :projectUserMap.keySet() LIMIT:IPM_ConstantUtils.MaxLimit];
   
        for(IPM_Project__c eachProject : ipmTeam) {
            for(IPM_Project_Resource__c eachResource : eachProject.IPM_Project_Resources__r) {
                String key = eachProject.Id + IPM_ConstantUtils.HYPHEN_DELIMITER + eachResource.IPM_User__c;
                existingProjectUserMap.put(key, true);
            }
            //Also add if the user is any project member currently in the project
            if(eachProject.IPM_Project_Leader__c != null) {
                String key = eachProject.Id + IPM_ConstantUtils.HYPHEN_DELIMITER + eachProject.IPM_Project_Leader__c;
                existingProjectUserMap.put(key, true);
            }
            if(eachProject.IPM_Technical_Project_Leader__c != null) {
                String key = eachProject.Id + IPM_ConstantUtils.HYPHEN_DELIMITER + eachProject.IPM_Technical_Project_Leader__c;
                existingProjectUserMap.put(key, true);
            }
            if(eachProject.IPM_Project_Gatekeeper__c != null) {
                String key = eachProject.Id + IPM_ConstantUtils.HYPHEN_DELIMITER + eachProject.IPM_Project_Gatekeeper__c;
                existingProjectUserMap.put(key, true);
            }
            if(eachProject.Deputy_Project_Leader__c != null) {
                String key = eachProject.Id + IPM_ConstantUtils.HYPHEN_DELIMITER + eachProject.Deputy_Project_Leader__c;
                existingProjectUserMap.put(key, true);
            }
            if(eachProject.IPM_Finance_Lead__c != null) {
                String key = eachProject.Id + IPM_ConstantUtils.HYPHEN_DELIMITER + eachProject.IPM_Finance_Lead__c;
                existingProjectUserMap.put(key, true);
            }
        }
        
        return existingProjectUserMap;
    }
    /*******************************************************************************************************
    * @description: This will auto unfollow the user to the project when its removed from the team.
    * @param1 - newProjectResources: List of the IPM_Project_Resource__c objects
    */
    public static void autoUnFollowTeamMembers(IPM_Project_Resource__c[] newProjectResources) {
        
        Map<Id, Set<Id>> projectUserMap = getProjectUserMap(newProjectResources); //output of the implicit method
        removeFollowingEntities(projectUserMap);
    }
    /*******************************************************************************************************
    * @description: Being called from the above method which prepares EntitySUbscription records and deletes
    * @param1 - projectUserMap: map which stores the user data projectwise
    */
    private static void removeFollowingEntities(Map<Id, Set<Id>> projectUserMap) {
        
        Set<Id> projects = new Set<Id>();
        EntitySubscription[] subsribingEntitiesToDelete = new list<EntitySubscription>(); //subentities to delete
        Map<String, Boolean> existingProjectUserMap = checkExistingSubscriber(projectUserMap);
        for(Id eachProject : projectUserMap.keySet()) {
            for(Id eachUser : projectUserMap.get(eachProject)) {
                String key = eachProject + IPM_ConstantUtils.HYPHEN_DELIMITER + eachUser;
                if(!existingProjectUserMap.containsKey(key)) {
                    projects.add(eachProject);
                }
            }
        }
        
        List<EntitySubscription> subscriptionList = [SELECT SubscriberId,ParentId FROM EntitySubscription 
                                                        WHERE ParentId = :projects
                                                        ORDER BY CreatedDate DESC
                                                        LIMIT 499];
        for(Id eachProject : projectUserMap.keySet()) {
            for(EntitySubscription eachEntity : subscriptionList) {
                String key = eachProject + IPM_ConstantUtils.HYPHEN_DELIMITER + eachEntity.SubscriberId;//customised key
                if(!existingProjectUserMap.containsKey(key)) {
                    subsribingEntitiesToDelete.add(eachEntity);
                }
            }
        }
   
        try{
            //To Check CRUD
            if(EntitySubscription.sObjectType.getDescribe().isDeletable()){
                delete subsribingEntitiesToDelete;
            }   
        }
        catch(exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), CLASS_NAME, 'removeFollowingEntities', ex.getMessage(),ex, IPM_ConstantUtils.ERROR_STR, null, null, null, null);
            if(ApexPages.currentPage() != null){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() + IPM_ConstantUtils.NEXT_LINE_STRING + ex.getStackTraceString()));
            } 
        }
    }
    /*******************************************************************************************************
    * @description: This method is being called whenever a user is being removed from the project level
    * @param1 - projectUserMap: map which stores the user data projectwise
    */
    public static void autoUnFollowProjectMembers(Map<Id, Set<Id>> projectUserMap) {
        
        removeFollowingEntities(projectUserMap);
    }
    
     /**
    @Description: Method which checks if the user being changed in the context or not
    @param1 - oldField: old sobject in the context
    @param2 - newField: new sobject in the context
    @return: Boolean value returns true if its changed.
    **/
    public static void manageChatterFollowMembers(Map<Id,IPM_Project__c> newProjectMap,Map<Id,IPM_Project__c> oldProjectMap) 
    { 
        Map<Id,Set<Id>> projectUsersToFollowMembers = new Map<Id,Set<Id>>(); 
        Map<Id,Set<Id>> projectUsersToUnFollowMap = new Map<Id,Set<Id>>(); 
            
            
        for(IPM_Project__c incomingProject : newProjectMap.values())
        { 
            IPM_Project__c oldProject = null;
            
            Set<Id> memebersToFollow = new Set<Id>();
            Set<Id> memebersToUnFollow = new Set<Id>();
    
            if(oldProjectMap !=null && oldProjectMap.containsKey(incomingProject.Id))
            {
                oldProject = oldProjectMap.get(incomingProject.Id);
            }
            List<String> apiNames = new List<String> {'IPM_Project_Leader__c','IPM_Technical_Project_Leader__c','IPM_Project_Gatekeeper__c',
                'Deputy_Project_Leader__c','IPM_Finance_Lead__c'};
            
            for(String apiName : apiNames)
            {
                if(oldProject == null && incomingProject.get(apiName) != null)
                {
                    memebersToFollow.add((Id)incomingProject.get(apiName));
                }
                else if(oldProject!=null && incomingProject.get(apiName) !=oldProject.get(apiName) )
                {
                    if(incomingProject.get(apiName) != null)
                    {
                        memebersToFollow.add((Id)incomingProject.get(apiName));
                    }
                    if(oldProject.get(apiName) !=null)
                    {
                        memebersToUnFollow.add((Id)oldProject.get(apiName));
                    }
                }
            }
            
            
            if(!memebersToUnFollow.isEmpty())
            {
                projectUsersToUnFollowMap.put(incomingProject.Id,memebersToUnFollow);
            }
            
            if(!memebersToFollow.isEmpty())
            {
                projectUsersToFollowMembers.put(incomingProject.Id,memebersToFollow);
            }
        }
        
        IPM_ChatterFeedHelper.autoUnFollowProjectMembers(projectUsersToUnFollowMap);
        
        IPM_WithoutSharingHelper.autoFollowProjectMembers(projectUsersToFollowMembers);
    }
    
    
     
    
      /**************************************************************
    * @description: If a project is updated to a Fast Track project,he will get a chatter feed.
      @param1 updatedProjects : List of Fast Track Projects
    */
    
    public static void notifyProjectIsFasttrack(List<IPM_Project__c> updatedProjects){
        clearData();
        Set<Id> fasttrackProjects = new Map<Id,IPM_Project__c>(updatedProjects).keySet();
        String posttext;
        for(IPM_Project__c eachProject:[Select IPM_Project_Name__c,IPM_Project_Leader__r.Name,IPM_Fast_Track_Project__c from IPM_Project__c where id in :fasttrackProjects LIMIT:IPM_ConstantUtils.MaxLimit])
        {
          projectIds.add(eachProject.id);
          if(eachProject.IPM_Fast_Track_Project__c)
          {
            posttext=eachProject.IPM_Project_Leader__r.Name+IPM_ConstantUtils.IPM_SPACE+FAST_TRACK_STATUS_STR+eachProject.IPM_Project_Name__c+TO_FAST_TRACK_STR;
          }
          else{
            posttext=eachProject.IPM_Project_Leader__r.Name+IPM_ConstantUtils.IPM_SPACE+FAST_TRACK_STATUS_STR+eachProject.IPM_Project_Name__c+TO_NOT_FAST_TRACK_STR;
          }
            subjectIdMessageMap.put(eachProject.id,posttext);
         }
                IPM_ChatterUtils.postChatterFeedWithMention(projectIds, subjectIdMessageMap, null );
                clearData();
        
    }
    
    /**************************************************************
    * @description: Sends out a chatter notification when IPM Project name changes.
      @param1 updatedProjects : List of Fast Track Projects
    */
    public static void notifyProjectNameChange(List<IPM_Project__c> updatedProjects){
        clearData();
         for(IPM_Project__c eachProject:updatedProjects){
           projectIds.add(eachProject.id);
           subjectIdMessageMap.put(eachProject.id,Label.IPM_Project_Name_Change + IPM_ConstantUtils.EMPTY_STRING_DELIMITER + eachProject.IPM_Project_Name__c);
        }
            IPM_ChatterUtils.postChatterFeedWithMention(projectIds, subjectIdMessageMap, null);
            clearData();
    } 
    
     /**************************************************************
    * @description: Sends out a chatter notification when IPM Project is created
      @param1 updatedProjects : List of new Projects
    */
    public static void notifyProjectCreated(List<IPM_Project__c> updatedProjects){
        
        clearData();
         for(IPM_Project__c eachProject:updatedProjects){
           projectIds.add(eachProject.id);
           subjectIdMessageMap.put(eachProject.id,eachProject.IPM_Project_Name__c + CREATED);
        }
        if(IPM_CheckRecursive.runOnce()) {
            IPM_ChatterUtils.postChatterFeedWithMention(projectIds, subjectIdMessageMap, null);
        }
            clearData();
            Map<Id, Set<Id>> usersMap = getProjectUsersMap(updatedProjects, null, true);
            IPM_WithoutSharingHelper.autoFollowProjectMembers(usersMap);
             
    } 
    
    /**************************************************************
      @description:If a Finance Member added to rollout plan
      @param1 updatedProjects : Rollout plan
         */
    public static void notifyFinanceMemberAddedToRollout(List<IPM_Project_Rollout__c> updatedRollouts){
        clearData();
        String postext;
        List<IPM_Project_Rollout__c> rolloutDetails = [Select Name,Finance_Member__c,IPM_Project__c,IPM_Project__r.IPM_Project_Leader__r.Name 
        from IPM_Project_Rollout__c where id IN :updatedRollouts LIMIT:IPM_ConstantUtils.MaxLimit];
        
          for(IPM_Project_Rollout__c eachRollout:rolloutDetails)
            {   
                 mentionId = new Set<Id>();
                 mentionId.add(eachRollout.Finance_Member__c);
                 projectIds.add(eachRollout.IPM_Project__c);
                 subjectIdMentionIdMap.put(eachRollout.IPM_Project__c,mentionId);  
                 postext = IPM_ConstantUtils.EMPTY_STRING_DELIMITER+System.Label.IPM_Finance_Member_Add +IPM_ConstantUtils.IPM_SPACE+eachRollout.Name+ System.Label.IPM_Finance_Member_Msg 
                 +IPM_ConstantUtils.IPM_SPACE+eachRollout.IPM_Project__r.IPM_Project_Leader__r.Name;
                 subjectIdMessageMap.put(eachRollout.IPM_Project__c,postext); 
            }    
                IPM_ChatterUtils.postChatterFeedWithMention(projectIds, subjectIdMessageMap, subjectIdMentionIdMap );
                clearData();
    } 
    
     /**************************************************************
      @description:If a task is assigned to a assignee,he will get an @mention and a chatter feed
      @param1 newProjects : newly created project
   */
    public static void notifyAssigneeTaskAssigned(List<IPM_Task__c> newTasks){
        
            Set<Id> newTaskIds = new Map<Id,IPM_Task__c>(newTasks).keySet();
           
            for(IPM_Task__c eachTask: [Select IPM_Project__c,IsSystemGenerated__c,IPM_Assignee__c,IPM_Project__r.IPM_Project_Name__c from IPM_Task__c 
            where id IN :newTaskIds and IsSystemGenerated__c = true LIMIT:IPM_ConstantUtils.MaxLimit]){
                 if(eachTask.IPM_Assignee__c != null){
                        mentionId.add(eachTask.IPM_Assignee__c);
                   }
                   projectIds.add(eachTask.IPM_Project__c);
                   subjectIdMentionIdMap.put(eachTask.IPM_Project__c,mentionId);
                   subjectIdMessageMap.put(eachTask.IPM_Project__c,String.format(Label.IPM_Task_Assign_Text1,new List<String>{eachTask.IPM_Project__r.IPM_Project_Name__c}));
               
            }
            
                IPM_ChatterUtils.postChatterFeedWithMention(projectIds, subjectIdMessageMap, subjectIdMentionIdMap );
    }
    
    
     /**************************************************************
      @description:Post chatter if Local and regional financial is misaligned
      @param1 newProjects : updated projects 
   */
     public static void postChatterIfLocalRegionalMisaligned(Set<Id> newProjIds )
     {
         clearData();
         set<Id> mentionIdLocal = new set<Id>();
         set<Id> mentionIdRegional = new set<Id>();
         
         List<IPM_Financial__c> regionalFins = new List<IPM_Financial__c>();
         regionalFins = [Select Id, Name, Misaligned__c, Misaligned_Date__c, Target_Launch_Date__c, Regional_Project__c, Regional_Project__r.Name, 
                        Regional_Project__r.Deputy_Project_Leader__c,Regional_Project__r.IPM_Finance_Lead__c,Regional_Project__r.IPM_Project_Leader__c,Regional_Project__r.IPM_Target_Launch_Dates__c, Local_Project__c, 
                        Local_Project__r.Deputy_Project_Leader__c,Local_Project__r.IPM_Project_Leader__c,Local_Project__r.IPM_Finance_Lead__c,Local_Project__r.Name, Local_Project__r.IPM_Target_Launch_Dates__c from IPM_Financial__c 
                        where (Regional_Project__c IN : newProjIds or Global_Project_Id__c IN : newProjIds 
                                                or Local_Project__c IN : newProjIds) and recordtype.Name =: IPM_ConstantUtils.DEFAULT_FINANCIAL_RT Limit: IPM_ConstantUtils.MaxLimit];
                        
         for(IPM_Financial__c fin: regionalFins ){    
            if(fin.Misaligned__c && (fin.Regional_Project__c != NULL && fin.Local_Project__c != NULL )){
                 
                       projectIds.add(fin.Regional_Project__c); 
                       mentionIdRegional.add(fin.Regional_Project__r.IPM_Finance_Lead__c);
                       mentionIdRegional.add(fin.Regional_Project__r.IPM_Project_Leader__c);
                       mentionIdRegional.add(fin.Regional_Project__r.Deputy_Project_Leader__c);
                       mentionIdRegional.remove(null);
                       subjectIdMentionIdMap.put(fin.Regional_Project__c,mentionIdRegional);
                       subjectIdMessageMap.put(fin.Regional_Project__c,FINANCIALS_STR1+fin.Regional_Project__r.Name+FINANCIALS_STR2+fin.Local_Project__r.Name+FINANCIALS_STR3 );
                   
                       projectIds.add(fin.Local_Project__c);
                       mentionIdLocal.add(fin.Local_Project__r.IPM_Finance_Lead__c);
                       mentionIdLocal.add(fin.Local_Project__r.IPM_Project_Leader__c);
                       mentionIdLocal.add(fin.Local_Project__r.Deputy_Project_Leader__c);
                       mentionIdLocal.remove(null);
                       subjectIdMentionIdMap.put(fin.Local_Project__c,mentionIdLocal);
                       subjectIdMessageMap.put(fin.Local_Project__c,FINANCIALS_STR1+fin.Regional_Project__r.Name+FINANCIALS_STR2+fin.Local_Project__r.Name+FINANCIALS_STR3 );
                 
            }
            if(!fin.Misaligned__c && (fin.Regional_Project__c != NULL && fin.Local_Project__c != NULL)){
                      
                       projectIds.add(fin.Regional_Project__c);
                       mentionIdRegional.add(fin.Regional_Project__r.IPM_Finance_Lead__c);
	                   mentionIdRegional.add(fin.Regional_Project__r.IPM_Project_Leader__c);
	                   mentionIdRegional.add(fin.Regional_Project__r.Deputy_Project_Leader__c);
	                   mentionIdRegional.remove(null);
	                   subjectIdMentionIdMap.put(fin.Regional_Project__c,mentionIdRegional);
	                   subjectIdMessageMap.put(fin.Regional_Project__c,FINANCIALS_STR1+fin.Regional_Project__r.Name+FINANCIALS_STR2+fin.Local_Project__r.Name+FINANCIALS_STR5);
	                     
                       projectIds.add(fin.Local_Project__c);
                       mentionIdLocal.add(fin.Local_Project__r.IPM_Finance_Lead__c);
                       mentionIdLocal.add(fin.Local_Project__r.IPM_Project_Leader__c);
                       mentionIdLocal.add(fin.Local_Project__r.Deputy_Project_Leader__c);
                       mentionIdLocal.remove(null);
                       subjectIdMentionIdMap.put(fin.Local_Project__c,mentionIdLocal);
                       subjectIdMessageMap.put(fin.Local_Project__c,FINANCIALS_STR1+fin.Regional_Project__r.Name+FINANCIALS_STR2+fin.Local_Project__r.Name+FINANCIALS_STR5);
            }
        }
        if(IPM_CheckRecursive.runOnce()) {
                IPM_ChatterUtils.postChatterFeedWithMention(projectIds,subjectIdMessageMap,subjectIdMentionIdMap); 
        }
          clearData();
        
     }
    
     /**************************************************************
      @description:Post chatter if Local and regional TLD is misaligned
      @param1 newProjects : updated projects 
   */
   public static void postChatterIfLocalRegionalTLDMisaligned(List<IPM_Project__c> updatedProjects){
     clearData();
     String chatterPostMessage ='';
     Map<Id, Set<Id>> projectIdUserSetMap = new Map<Id, Set<Id>>(); 
     subjectIdMessageMap = new map<id,string>();
     List<IPM_Project__c> tldUpdatedProjects = [SELECT IPMProject_Span__c,id,IPM_Project_Leader__c,Deputy_Project_Leader__c,IPM_Finance_Lead__c,IPM_Project_Name__c,
                                IPM_Parent_Project__r.IPM_Project_Leader__c,IPM_Parent_Project__r.Deputy_Project_Leader__c,
                                IPM_Parent_Project__r.IPM_Finance_Lead__c,IPM_Parent_Project__r.IPM_Project_Name__c,
                                Rollout_Plan_Target_Launch_Date__c,IPM_Target_Launch_Dates__c
                                FROM IPM_Project__c
                                WHERE id IN :updatedProjects
                                LIMIT:IPM_ConstantUtils.MaxLimit];
                                  
     for(IPM_Project__c localProj : tldUpdatedProjects)
     {
       if(IPM_ConstantUtils.PROJECT_SPAN_LOCAL.equalsIgnoreCase(localProj.IPMProject_Span__c) && localProj.Rollout_Plan_Target_Launch_Date__c != null && localProj.IPM_Target_Launch_Dates__c != null &&
         localProj.Rollout_Plan_Target_Launch_Date__c != localProj.IPM_Target_Launch_Dates__c)
       {
            projectIds.add(localProj.id);
            projectIds.add(localProj.IPM_Parent_Project__c);    
            
            Set<Id> regionalUserSet = new Set<Id> ();
            regionalUserSet.add(localProj.IPM_Parent_Project__r.IPM_Project_Leader__c);
            regionalUserSet.add(localProj.IPM_Parent_Project__r.Deputy_Project_Leader__c);
            regionalUserSet.add(localProj.IPM_Parent_Project__r.IPM_Finance_Lead__c);
            regionalUserSet.add(localProj.IPM_Parent_Project__r.IPM_Finance_Lead__c);
             
            regionalUserSet.remove(null);
            Set<Id> localUserSet = new Set<Id> ();
            localUserSet.add(localProj.IPM_Project_Leader__c);
            localUserSet.add(localProj.Deputy_Project_Leader__c);
            localUserSet.add(localProj.IPM_Finance_Lead__c);
            localUserSet.add(localProj.IPM_Finance_Lead__c);
            
            localUserSet.remove(null);     
            projectIdUserSetMap.put(localProj.IPM_Parent_Project__c,regionalUserSet);
            projectIdUserSetMap.put(localProj.id,localUserSet);
                
            chatterPostMessage=System.label.IPM_Target_Launch_Date_Msg+IPM_ConstantUtils.IPM_SPACE+localProj.IPM_Project_Name__c+
            IPM_ConstantUtils.IPM_SPACE+System.Label.IPM_TLD_Misaligned+IPM_ConstantUtils.IPM_SPACE+localProj.IPM_Parent_Project__r.IPM_Project_Name__c;
                
            subjectIdMessageMap.put(localProj.IPM_Parent_Project__c,chatterPostMessage); 
            subjectIdMessageMap.put(localProj.id,chatterPostMessage);     
                
         }
     }
     IPM_ChatterUtils.postChatterFeedWithMention(projectIds,subjectIdMessageMap,projectIdUserSetMap); 
     clearData();
           
    } 
    
    /**************************************************************
      @description:Post chatter if financial is modified
      @param1 newProjects : updated financials 
   */
    public static void postChatterIfBusinessCaseSaved(List<IPM_Financial__c> updatedFinancials){
     clearData(); 
     
     Set<Id> financialSet = new Set<Id>();
     Map<ID,String> financialMap = new Map<Id,String>();
      for(IPM_Financial__c eachFin:updatedFinancials)
      {
            projectIds.add(eachFin.Local_Project__c);
            projectIds.add(eachFin.Regional_Project__c);
        projectIds.add(eachFin.Global_Project_Id__c);
            
            financialSet.add(eachFin.id);
            
            projectIds.remove(null);
            if(eachFin.Local_Project__c != null || eachFin.Regional_Project__c != null || eachFin.Global_Project_Id__c != null)
            {
                subjectIdMessageMap.put(eachFin.Local_Project__c,IPM_ConstantUtils.BUSINESS_CASE_SAVED);
                subjectIdMessageMap.put(eachFin.Regional_Project__c,IPM_ConstantUtils.BUSINESS_CASE_SAVED);
                subjectIdMessageMap.put(eachFin.Global_Project_Id__c,IPM_ConstantUtils.BUSINESS_CASE_SAVED);
            }
            financialMap.put(eachFin.id,IPM_ConstantUtils.BUSINESS_CASE_SAVED);
            for(Id key:subjectIdMessageMap.keySet()){
                if(key == null)
                {
                    subjectIdMessageMap.remove(key);
                }
            }
     }
     if(IPM_CheckRecursive.runOnce()) {
     
     IPM_ChatterUtils.postChatterFeedWithMention(projectIds, subjectIdMessageMap, null);
     IPM_ChatterUtils.postChatterFeedWithMention(financialSet, financialMap, null);
     }
     clearData();
    }
    
      /**************************************************************
      @description:Post chatter if Regional rollout added to plan
      @param1 newProjects : updated projects 
   */
    @InvocableMethod
    public static void postChatterRegionalRolloutAddedToPlan(List<IPM_Project_Rollout__c> newRollouts){
        String posttext;
        String phaseToCompare;
        Set<Id> rolloutIds = new Map<Id,IPM_Project_Rollout__c>(newRollouts).keySet();
        Set<Id> rolloutProjectIds = new Set<Id>();
        for(IPM_Project_Rollout__c eachProj:newRollouts)
        {
          rolloutProjectIds.add(eachProj.IPM_Project__c);
        }
        
        List<IPM_Project_Rollout__c> newRollout = [Select IPM_Project__c,Name,Finance_Member__r.Name,IPM_Regional_PL__r.Name,IPM_Project__r.IPM_Category_Text__c,
        IPM_Project__r.IPM_Brand_Positioning__c,Market_Cluster_Name__c,IPM_Project__r.IPM_Project_Description__c,IPM_Regional_PL__c,IPM_Project__r.IPMProject_Span__c,
        IPM_Project__r.IPM_Project_Leader__r.Name,IPM_Project__r.IPM_Phase__c,IPM_Project__r.IPM_Temporary_Phase__c,IPM_Project__r.IPM_Project_Name__c,
        IPM_Project__r.IPM_Target_Launch_Dates__c, IPM_Project__r.Upcoming_Milestone_Due_Date__c 
        from IPM_Project_Rollout__c where id in :rolloutIds LIMIT:IPM_ConstantUtils.MaxLimit];
        
        List<IPM_Milestone__c> milestoneList = [Select IPM_Type_of_gate__c,IPM_Phase__c,IPM_Planned_Date__c from IPM_Milestone__c where IPM_Project__c in :rolloutProjectIds LIMIT:IPM_ConstantUtils.MaxLimit];
        
        for(IPM_Project_Rollout__c eachRollout: newRollout)
            {
                if(Test.isRunningTest())
                 {
                    phaseToCompare = eachRollout.IPM_Project__r.IPM_Temporary_Phase__c;
                 }   
                else 
                {
                    phaseToCompare = eachRollout.IPM_Project__r.IPM_Phase__c;
                }    
                    
                if(System.Label.IPM_GLOBAL.equalsIgnoreCase(eachRollout.IPM_Project__r.IPMProject_Span__c) && IPM_ConstantUtils.PHASE_IDEAS.equalsIgnoreCase(phaseToCompare))
                {
                    projectIds.add(eachRollout.IPM_Project__c);
                    mentionId.add(eachRollout.IPM_Regional_PL__c);
                    subjectIdMentionIdMap.put(eachRollout.IPM_Project__c,mentionId);
                    posttext = IPM_ConstantUtils.IPM_SPACE +eachRollout.Market_Cluster_Name__c +IPM_ConstantUtils.IPM_SPACE+Label.IPM_Included_In +IPM_ConstantUtils.IPM_SPACE +eachRollout.IPM_Project__r.IPM_Project_Name__c; 
                    posttext +=REGIONAL_ROLLOUT_ADDED_STR4 +  eachRollout.IPM_Project__r.IPM_Project_Name__c + REGIONAL_ROLLOUT_ADDED_STR3 + eachRollout.Name + REGIONAL_ROLLOUT_ADDED_STR1;
                    posttext +=eachRollout.IPM_Project__r.IPM_Project_Name__c + REGIONAL_ROLLOUT_ADDED_STR2 + IPM_ConstantUtils.NEXT_LINE_STRING;
                    posttext +=REGIONAL_ROLLOUT_ADDED_STR5+eachRollout.IPM_Project__r.IPM_Project_Leader__r.Name+ IPM_ConstantUtils.NEXT_LINE_STRING;   
                    posttext += eachRollout.Name + IPM_ConstantUtils.NEXT_LINE_STRING;
                    posttext += Label.IPM_Project_Lead+ IPM_ConstantUtils.Colon + eachRollout.IPM_Regional_PL__r.Name + IPM_ConstantUtils.NEXT_LINE_STRING;
                    posttext += Label.IPM_CATEGORY+ IPM_ConstantUtils.Colon + eachRollout.IPM_Project__r.IPM_Category_Text__c + IPM_ConstantUtils.NEXT_LINE_STRING; 
                    posttext += Label.IPM_Brand + eachRollout.IPM_Project__r.IPM_Brand_Positioning__c + IPM_ConstantUtils.NEXT_LINE_STRING;
                    if(eachRollout.IPM_Project__r.IPM_Project_Description__c != null)
                    {
                        posttext += Label.IPM_DescriptionLabel+IPM_ConstantUtils.BLANK+ eachRollout.IPM_Project__r.IPM_Project_Description__c +IPM_ConstantUtils.NEXT_LINE_STRING;
                    }
                    else{
                        posttext += Label.IPM_DescriptionLabel+IPM_ConstantUtils.NEXT_LINE_STRING;
                    }
                    
                    String currGate = IPM_Utils.phaseGateDocumentMap.get(eachRollout.IPM_Project__r.IPM_Phase__c);
                    Datetime upcomingMilestoneDueDate=null; //NO SONAR : If the current milestone date is not set, then need to display blank or null value 
                    for(IPM_Milestone__c eachMilestone:milestoneList)
                    {
                      if(eachMilestone.IPM_Planned_Date__c != null && eachMilestone.IPM_Phase__c == eachRollout.IPM_Project__r.IPM_Phase__c && currGate.equalsIgnoreCase(eachMilestone.IPM_Type_of_gate__c))
                      {
                        upcomingMilestoneDueDate=datetime.newInstance(eachMilestone.IPM_Planned_Date__c.year(),eachMilestone.IPM_Planned_Date__c.month(),eachMilestone.IPM_Planned_Date__c.day());
                        }
                    
                    }
                    if(upcomingMilestoneDueDate != null)
                    {
                      posttext += PLANNED_STR+currGate+IPM_ConstantUtils.Colon+ upcomingMilestoneDueDate.format('dd MMMM yyyy') +IPM_ConstantUtils.NEXT_LINE_STRING;
                    }
                    else{
                      posttext += PLANNED_STR+currGate+IPM_ConstantUtils.Colon+IPM_ConstantUtils.NEXT_LINE_STRING;
                    }  
                    
                    Datetime targetLaunchDate=datetime.newInstance(eachRollout.IPM_Project__r.IPM_Target_Launch_Dates__c.year(),eachRollout.IPM_Project__r.IPM_Target_Launch_Dates__c.month(),eachRollout.IPM_Project__r.IPM_Target_Launch_Dates__c.day());   
                    posttext += Label.IPM_TARGET_LAUNCH_DATE+IPM_ConstantUtils.Colon+ targetLaunchDate.format('yyyy MMMM') + IPM_ConstantUtils.NEXT_LINE_STRING;
                    subjectIdMessageMap.put(eachRollout.IPM_Project__c,posttext);
                }
          }
           IPM_ChatterUtils.postChatterFeedWithMention(projectIds, subjectIdMessageMap, subjectIdMentionIdMap );
    }   
    
     /**************************************************************
      @description:Post chatter if Document status is changed
      @param1 newProjects : updated projects 
   */
    public static void postChatterIfDocumentStatusChanged(List<IPM_Project_Document__c> updatedProjDocuments,List<IPM_Project_Document__c> oldProjDocuments){
        clearData();
        for(IPM_Project_Document__c oldDocument: oldProjDocuments)
        {
            for(IPM_Project_Document__c newDocument: updatedProjDocuments)
            {
                if(!IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED.equals(oldDocument.IPM_Document_Status__c) && IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED.equals(newDocument.IPM_Document_Status__c))
                 {
                    projectIds.add(newDocument.IPM_Project__c);
                    subjectIdMessageMap.put(newDocument.IPM_Project__c,newDocument.IPM_GateDocuments__c+IPM_ConstantUtils.BLANK+IPM_ConstantUtils.GD_PDF_POSTFIX+IPM_ConstantUtils.IPM_SPACE+
                    CHANGED+Label.IPM_From_Small +IPM_ConstantUtils.IPM_SPACE+oldDocument.IPM_Document_Status__c+IPM_ConstantUtils.IPM_SPACE+Label.IPM_To_Label+IPM_ConstantUtils.IPM_SPACE+
                    IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED);
                 }   
                 if(!IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED.equals(oldDocument.IPM_Document_Status__c) && IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED.equals(newDocument.IPM_Document_Status__c)
                 && (IPM_ConstantUtils.CHARTER_GATE.equals(newDocument.IPM_GateDocuments__c) || IPM_ConstantUtils.CONTRACT_GATE.equals(newDocument.IPM_GateDocuments__c)))
                 {
                    projectIds.add(newDocument.IPM_Project__c);
                    subjectIdMessageMap.put(newDocument.IPM_Project__c,newDocument.IPM_GateDocuments__c+IPM_ConstantUtils.BLANK+IPM_ConstantUtils.GD_PDF_POSTFIX+
                    IPM_ConstantUtils.IPM_SPACE+CHANGED+Label.IPM_From_Small +IPM_ConstantUtils.IPM_SPACE+oldDocument.IPM_Document_Status__c+IPM_ConstantUtils.IPM_SPACE+Label.IPM_To_Label+IPM_ConstantUtils.IPM_SPACE+IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED);
                 }   
                 if(!IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS.equals(oldDocument.IPM_Document_Status__c) && IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS.equals(newDocument.IPM_Document_Status__c)
                 && (IPM_ConstantUtils.CHARTER_GATE.equals(newDocument.IPM_GateDocuments__c) || IPM_ConstantUtils.CONTRACT_GATE.equals(newDocument.IPM_GateDocuments__c)))
                 {
                    projectIds.add(newDocument.IPM_Project__c);
                    subjectIdMessageMap.put(newDocument.IPM_Project__c,newDocument.IPM_GateDocuments__c+IPM_ConstantUtils.IPM_SPACE+Label.IPM_Gate_Approved_With_Edits);
                 }   
            }
        }    
            IPM_ChatterUtils.postChatterFeedWithMention(projectIds, subjectIdMessageMap, subjectIdMentionIdMap );
            clearData();
    }
    
      /**************************************************************
      @description: Get the user mapped to the respective projects
      @param1 newProjects : updated projects 
      @param1 oldProjectsMap : oldProjectsMap projects 
      @param1 Boolean : boolean follow value
   */
    public static Map<Id, Set<Id>> getProjectUsersMap(IPM_Project__c[] newProjects, Map<Id, IPM_Project__c> oldProjectsMap, Boolean isFollow) {
        
        Map<Id, Set<Id>> mapToReturn = new Map<Id, Set<Id>>(); //var to return
        for(IPM_Project__c eachproject : newProjects) {
            Set<Id> tmpStr = new Set<Id>();//temp variable to add the users.check all those users which are changed.
            if(isFollow && oldProjectsMap == null) {
                if(eachproject.IPM_Project_Leader__c != null) {
                    tmpStr.add(eachproject.IPM_Project_Leader__c);
                }
            
                if(eachproject.Deputy_Project_Leader__c != null) {
                    tmpStr.add(eachproject.Deputy_Project_Leader__c);
                }
                if(eachproject.IPM_Finance_Lead__c != null) {
                    tmpStr.add(eachproject.IPM_Finance_Lead__c);
                }
            }
            if(tmpStr != null && !tmpStr.isEmpty()) {
                mapToReturn.put(eachproject.Id, tmpStr);
            }
        }
        return mapToReturn;
    } 
    
     /**************************************************************
      @description: Clears the previous data
   */
   public static void clearData()
   {
       projectIds.clear();
       subjectIdMessageMap.clear();
       subjectIdMentionIdMap.clear();
   }
   
}
