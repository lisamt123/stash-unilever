/*********************************************************************************************************
    @Description: A Trigger handler class for the IPM_PRoject_Resource__c object. 
    THIS IS WITHOUT SHARING by purpose. Since the sharing is an async process and team members doesnt immediately get access to team member. 
    @Author: Cognizant Technology
    @Date: Oct 2014
**/

public with sharing class IPM_ProjectResourceTriggerHandler 
{ 
    List<ProjectResourceHistoryWrapper> lstPrjResourceHisWrapper;
    private transient static final String USER = ' User : ';
    private transient static final String NEW_ROLE = ' New Role : ';
    private transient static final String OPTION_ALL = 'All'; 
    
     
    public IPM_ProjectResourceTriggerHandler(){ //constructor
    }
    
    /*******************************************************************************************************
    * @description: Before Update context
    * @param1 - newProjectResources: The new list of the IPM_Project_Resource__c object
    * @param1 - oldProjectResources: The new list of the IPM_Project_Resource__c object
    */
    public void onBeforeUpdate(map<Id,IPM_Project_Resource__c>newResourceMap, map<Id,IPM_Project_Resource__c>oldResourceMap) {
        lstPrjResourceHisWrapper = new List<ProjectResourceHistoryWrapper>();
        
        for(IPM_Project_Resource__c eachPResource : newResourceMap.values()) {
           if(oldResourceMap.get(eachPResource.Id).IPM_Project_Role_Owner__c != eachPResource.IPM_Project_Role_Owner__c){
             lstPrjResourceHisWrapper.add(new ProjectResourceHistoryWrapper(eachPResource.IPM_Project__c, oldResourceMap.get(eachPResource.Id).IPM_User__c, eachPResource.IPM_User__c, eachPResource.IPM_Role_Type__c));
           }
        }
        
        trackProjectResourceAuditHistory(lstPrjResourceHisWrapper, IPM_ConstantUtils.HISTORY_UPDATED);
    }
    
    /*******************************************************************************************************
    * @description: Before Delete context
    * @param1 - oldProjectResources: The new list of the IPM_Project_Resource__c object
    */
    public void onBeforeDelete(IPM_Project_Resource__c[] oldProjectResources) {
        lstPrjResourceHisWrapper = new List<ProjectResourceHistoryWrapper>();
        for(IPM_Project_Resource__c eachPResource : oldProjectResources){
            lstPrjResourceHisWrapper.add(new ProjectResourceHistoryWrapper(eachPResource.IPM_Project__c, eachPResource.IPM_User__c, null, eachPResource.IPM_Role_Type__c));        
        } 
        trackProjectResourceAuditHistory(lstPrjResourceHisWrapper, IPM_ConstantUtils.HISTORY_DELETED);
    }
    
    /*******************************************************************************************************
    * @description: After insert context
    * @param1 - newProjectResources: The new list of the IPM_Project_Resource__c object
    */
    public void onAfterInsert(IPM_Project_Resource__c[] newProjectResources) {
        lstPrjResourceHisWrapper = new List<ProjectResourceHistoryWrapper>();

        list<IPM_Project_Resource__c> newPRList = new list<IPM_Project_Resource__c>(); //Select list which should contain only the owners in the team
        for(IPM_Project_Resource__c eachPResource : newProjectResources) {
            if(eachPResource.IPM_Project_Role_Owner__c) {
                newPRList.add(eachPResource);
            }
            lstPrjResourceHisWrapper.add(new ProjectResourceHistoryWrapper(eachPResource.IPM_Project__c, null, eachPResource.IPM_User__c, eachPResource.IPM_Role_Type__c));
        }
        if(IPM_CheckRecursive.runOnce() && newPRList!= null && !newPRList.isEmpty()) { // run only once and when newPRLIst is more than 0
            IPM_TaskHelper.reAssignFunctionalWiseTasks(newPRList);
        }
        
        trackProjectResourceAuditHistory(lstPrjResourceHisWrapper, IPM_ConstantUtils.HISTORY_INSERTED);

        //@@Design Review - Data Sharing Code for assigning project resource to queue.
        if(!system.isBatch() && !system.isFuture()){ 
          map<id,IPM_Project_Resource__c>oldProjectResourcesmap = new map<id,IPM_Project_Resource__c>();
          updateGroupMember(newProjectResources,oldProjectResourcesmap);
      }
    }
    
    /*******************************************************************************************************
    * @description: After update context
    * @param1 - newProjectResources: The new list of the IPM_Project_Resource__c object
    * @param2 - newProjectResourcesMap: The map of the new IPM_Project_Resource__c object
    * @param3 - oldProjectResources: The map of the old IPM_Project_Resource__c object
    */
    public void OnAfterUpdate(IPM_Project_Resource__c[] newProjectResources, Map<Id, IPM_Project_Resource__c> newProjectResourcesMap, 
                                Map<Id, IPM_Project_Resource__c> oldProjectResources) {
        // Used for on after update Purposes.
    }
    
    /*******************************************************************************************************
    * @description: future method to notify role change to Project Leaders
    * @param1 - userIds: Set of Ids or the users
    */
    @future
    public static void notifyRoleChangeToPLs(Set<Id> userIds) {
        
        IPM_Project_Resource__c[] pResourceList = [SELECT IPM_Project__c, IPM_Role__c, IPM_User__c 
                                                       FROM IPM_Project_Resource__c
                                                       WHERE IPM_User__c IN :userIds Limit 1000]; //retrieve details basing on the userids
        memberChangingRole(pResourceList);
    }
    
    /*******************************************************************************************************
    * @description: identification of those members who are changing roles on the project
    * @param1 - newProjectResources: The new list of the IPM_Project_Resource__c object
    */
    public static void memberChangingRole(IPM_Project_Resource__c[] newProjectResources) {
                                        
        //Map to store Team objects projects wise
        Map<Id, IPM_Project_Resource__c[]> pResourceRoleChangedMap = new Map<Id, IPM_Project_Resource__c[]>();
        Set<Id> userIds = new Set<Id>();//userids set
        for(IPM_Project_Resource__c eachPResource : newProjectResources) {
            if(!pResourceRoleChangedMap.containsKey(eachPResource.IPM_Project__c)) {
                IPM_Project_Resource__c[] tmpLst = new List<IPM_Project_Resource__c>();
                tmpLst.add(eachPResource);
                pResourceRoleChangedMap.put(eachPResource.IPM_Project__c, tmpLst);
            }else {
                pResourceRoleChangedMap.get(eachPResource.IPM_Project__c).add(eachPResource);
            }
            userIds.add(eachPResource.IPM_User__c);
        }
        
        Map<Id, IPM_Project__c> projectMap = IPM_Utils.getProjectDetails(pResourceRoleChangedMap.keySet());//Ext variable to store project map
        Map<Id, User> userDetailsMap = IPM_Utils.getUserDetailsMap(userIds); //Ext Variable to store user details in a map
        Map<Id, String> pResourceDetailsMap = new Map<Id, String>(); //team details map to store dynamic message to be posted.
        
        for(Id eachProject : pResourceRoleChangedMap.keySet()) 
        {
            Set<String> contextMsgList = new Set<String>();
            for(IPM_Project_Resource__c eachPResource : pResourceRoleChangedMap.get(eachProject)) 
            {
                String str = USER + userDetailsMap.get(eachPResource.IPM_User__c).Name + NEW_ROLE + eachPResource.IPM_Role__c;
                contextMsgList.add(str);
            }
            pResourceDetailsMap.put(eachProject, IPM_Utils.convertSetToString(contextMsgList));
        }
        IPM_ChatterFeedHelper.postChatterUpdateToUser(projectMap, pResourceDetailsMap);//post the notification
    }
    
    /*******************************************************************************************************
    * @description: After Un Delete context of the trigger
    * @param1 - newProjectResources: The new list of the IPM_Project_Resource__c object
    */
    public void onAfterUnDelete(IPM_Project_Resource__c[] newProjectResources) 
    {
        IPM_WithoutSharingHelper.autoFollowTeamMembers(newProjectResources);//auto subscribe back them to the project
    }
    
    /*******************************************************************************************************
    * @description: After Delete context of the trigger
    * @param1 - newProjectResources: The old list of the IPM_Project_Resource__c object
    */
    public void OnAfterDelete(IPM_Project_Resource__c[] oldProjectResources) 
    {
        //@@Desing Review - Data sharing update group members
        if(!system.isBatch() && !system.isFuture())
        {
            map<id,IPM_Project_Resource__c>oldProjectResourcesmap = new map<id,IPM_Project_Resource__c>();
            updateGroupMember(oldProjectResources,oldProjectResourcesmap);
        }
    }
    
    
    /*******************************************************************************************************
    * @description: After Update context of the trigger. If concerned fields of the IPM_Resource are modified then make the project ready for sync to ecodesign.
    * @param1 - oldProjectResources: The old list of the IPM_Project_Resource__c object
    ***********************************************************************************************************/
    public void setSyncProjectAftUpdate(Map<Id, IPM_Project_Resource__c> oldResourceMap,Map<Id, IPM_Project_Resource__c> newResourceMap) 
    {
        List<IPM_Project__c> toUpdateProjList = new List<IPM_Project__c>();
        List<IPM_Project__c> prevSyncedProjList = new List<IPM_Project__c>();
        Set<Id> projIdsSet = new Set<id>();
        Map<Id,List<IPM_Project_Resource__c>> projMembersMap =  new Map<Id,List<IPM_Project_Resource__c>>(); //Map of Project Id and Project Members
    
    for(IPM_Project_Resource__c projResource : newResourceMap.values())
    {
        if(projResource.IPM_Project__c != null)
        {
            for(FieldSetMember fsm : Schema.SObjectType.IPM_Project_Resource__c.fieldSets.IPM_Project_Resource_Field_Set_EcoDesign.getFields())
            {
                if (projResource.get(fsm.getFieldPath())!= null && oldResourceMap.get(projResource.id) != null 
                && oldResourceMap.get(projResource.id).get(fsm.getFieldPath()) != null && projResource.get(fsm.getFieldPath()) != oldResourceMap.get(projResource.id).get(fsm.getFieldPath())) 
                {
                    projIdsSet.add(projResource.IPM_Project__c);
                  
                    //to sync old project as well
                    if(fsm.getFieldPath() == IPM_ConstantUtils.IPM_PROJECTOBJECT && oldResourceMap.get(projResource.id) != null && oldResourceMap.get(projResource.id).IPM_Project__c != null )
                    {
                        projIdsSet.add(oldResourceMap.get(projResource.id).IPM_Project__c);//to Sync the previous project as well
                    }  
                }
            }
        }
    }
  
    //List of all Project records which have been previously synced to EcoDesign
    prevSyncedProjList = [SELECT Id,First_Sync_To_EcoDesign__c,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,
                             IPM_Phase__c,IPM_Answer_of_Q1__c,IPM_CompanyCardText__c,Project_Countries__c FROM IPM_Project__c WHERE Id IN :projIdsSet LIMIT 50000];
    
    projMembersMap = IPM_ProjectCountryDetails.getProjectIdMembersListMap(projIdsSet,OPTION_ALL);
    
    If(prevSyncedProjList!=null && !prevSyncedProjList.isEmpty())
    {
        for(IPM_Project__c prevSyncedProject : prevSyncedProjList )
        {
            if(IPM_ProjectCountryDetails.isProjectReadyToSyncToEcoDesign(prevSyncedProject))
            {
                //set status as ready only when the rollout is created and countires are there for the project
            	if(String.isNotBlank(prevSyncedProject.Project_Countries__c)){
            		prevSyncedProject.EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY;
            	}
            
                if(projMembersMap != null && !projMembersMap.isEmpty() && projMembersMap.get(prevSyncedProject.id) != null && !projMembersMap.get(prevSyncedProject.id).isEmpty())
                {
                    prevSyncedProject.Project_Members__c = IPM_ProjectCountryDetails.getProjectMembersNames(projMembersMap.get(prevSyncedProject.id));
                }
                toUpdateProjList.add(prevSyncedProject);
            } 
        }
    }
  
    //Update The List
    if(!toUpdateProjList.isEmpty())
    {
    	IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
        update toUpdateProjList; // Not including try , catch as when the transaction is failed roll back is handled at other class
        IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
      }

  }
  
  /*******************************************************************************************************
    * @description: After Insert Or Delete context of the trigger. If concerned fields of the IPM_Resource are modified then set status value on the parent Project as ready.
    * @param1 - ProjectResources: The old list OR New list of the IPM_Project_Resource__c object
    ***********************************************************************************************************/
    public void setSyncProjectAftInsertDelete(IPM_Project_Resource__c[] projectResources) 
    {
        List<IPM_Project__c> toUpdateProjList = new List<IPM_Project__c>();
        List<IPM_Project__c> prevSyncedProjList = new List<IPM_Project__c>();
        Set<Id> projIdsSet = new Set<Id>();
        Map<Id,List<IPM_Project_Resource__c>> projMembersMap =  new Map<Id,List<IPM_Project_Resource__c>>(); //Map of Project Id and semicolon seperated Project Members
    
        for(IPM_Project_Resource__c projResource : ProjectResources)
        {
            projIdsSet.add(projResource.IPM_Project__c);
        }
        prevSyncedProjList = [SELECT Id,First_Sync_To_EcoDesign__c,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,
                             IPM_Phase__c,IPM_Answer_of_Q1__c,IPM_CompanyCardText__c, Project_Countries__c FROM IPM_Project__c WHERE Id IN :projIdsSet LIMIT 50000];
    
        projMembersMap = IPM_ProjectCountryDetails.getProjectIdMembersListMap(projIdsSet,OPTION_ALL);
    
        if(prevSyncedProjList!=null && !prevSyncedProjList.isEmpty())
        {
            for(IPM_Project__c prevSyncedProject : prevSyncedProjList )
            {
                if(IPM_ProjectCountryDetails.isProjectReadyToSyncToEcoDesign(prevSyncedProject))
                {
                	//set status as ready only when the rollout is created and countires are there for the project
                	if(String.isNotBlank(prevSyncedProject.Project_Countries__c)){
                		prevSyncedProject.EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY;
                	}
                    
                    if(projMembersMap!=null && !projMembersMap.isEmpty() && projMembersMap.get(prevSyncedProject.id)!=null && !projMembersMap.get(prevSyncedProject.id).isEmpty())
                    {
                        prevSyncedProject.Project_Members__c = IPM_ProjectCountryDetails.getProjectMembersNames(projMembersMap.get(prevSyncedProject.id));
                    }
                    toUpdateProjList.add(prevSyncedProject);    
                } 
            }
        }
    
        //Update The List
        if(!toUpdateProjList.isEmpty())
        {
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
            update toUpdateProjList; // Not including try , catch as when the transaction is failed roll back is handled at other class
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;  
        }
    }     
  /*******************************************************************************************************
    * @description: method to update group members
    * @param1 - listProjectResources: The new/old list of the IPM_Project_Resource__c records
    * @param2 - mapoldprojResources: In update context old map of IPM_Project_Resource__c object else it will be blank
    */
    public void UpdategroupMember(list<IPM_Project_Resource__c> ProjectResources, Map<Id, IPM_Project_Resource__c> oldProjectResourcesmap) {
          //@@Desing Review - Data sharing update group members
          set<id> projidset = new Set<id>();
          set<string> projglobalidset = new Set<string>();
          Map<id,IPM_Project__c> projectmap =  new Map<id,IPM_Project__c>();
          Map<id,IPM_Project__c> projectGlobalmap = new Map<id,IPM_Project__c>();
                      
       for(IPM_Project_Resource__c projres:ProjectResources){
         if(system.trigger.isInsert || system.trigger.isDelete){
             projidset.add(projres.IPM_Project__c);
         }
         else if(system.trigger.isupdate && projres.IPM_User__c != oldProjectResourcesmap.get(projres.id).IPM_User__c){
             projidset.add(projres.IPM_Project__c);
           }
       } //FOR END       
       if(projidset != null && projidset.size()>0){
         projectmap = new Map<id,IPM_Project__c>([SELECT id,IPM_Parent_Project__r.IPM_Parent_Project__c,IPM_Global_Project_Id__c,IPM_Parent_Project__c FROM IPM_Project__c WHERE id IN:projidset or IPM_Parent_Project__c IN:projidset or IPM_Parent_Project__r.IPM_Parent_Project__c IN:projidset LIMIT 1000]);
         if(projectmap != null && projectmap.size()>0){ 
           for(IPM_Project__c proj:projectmap.values()){
             projglobalidset.add(proj.IPM_Global_Project_Id__c); 
             projglobalidset.add(proj.id);
             if(proj.IPM_Parent_Project__c!=null){
                projglobalidset.add(proj.IPM_Parent_Project__c);
             }
             if(proj.IPM_Parent_Project__r.IPM_Parent_Project__c!=null){
                projglobalidset.add(proj.IPM_Parent_Project__r.IPM_Parent_Project__c);   
             }
           }
           if(projglobalidset != null && projglobalidset.size()>0){
             projectGlobalmap = new Map<id,IPM_Project__c>([select id from IPM_Project__c where id IN: projglobalidset]);  
           }      
         }
         if(projectGlobalmap != null && projectGlobalmap.size()>0){  
              IPM_GroupManagement.groupmemberupdate(projectGlobalmap.keySet());  
         }
        }        
    }  
    
    /**
    @Description: This bulkified generic method will insert audit history of Project team members into IPM_Project_Resource_History__c object.
    @param lstPrjResourceHisWrapper:- List of Wrapper class to hold various attributes of Resource history to insert
    @sType:- Type of team member history. Either Inserted/Updated/Deleted.
    **/
    public static void trackProjectResourceAuditHistory(List<ProjectResourceHistoryWrapper> lstPrjResourceHisWrapper, String sType)
    {
      
        List<IPM_Project_Resource_History__c> lstPrjResourceHistoryToInsert = new List<IPM_Project_Resource_History__c>();
        IPM_Project_Resource_History__c prjResourceHistory;
     
        for(ProjectResourceHistoryWrapper resourceHistoryWrapper : lstPrjResourceHisWrapper)
        {
           prjResourceHistory = new IPM_Project_Resource_History__c();
           prjResourceHistory.IPM_Project__c = resourceHistoryWrapper.projectId;
           prjResourceHistory.Old_User__c = resourceHistoryWrapper.oldUserId;
           prjResourceHistory.New_User__c = resourceHistoryWrapper.newUserId;
           prjResourceHistory.User_Role__c = resourceHistoryWrapper.sUserRole;
           prjResourceHistory.Change_Date__c = System.now();
           prjResourceHistory.Changed_By__c = UserInfo.getUserId();
           prjResourceHistory.Type__c = sType;
           lstPrjResourceHistoryToInsert.add(prjResourceHistory);
        }
        insert lstPrjResourceHistoryToInsert;
    }

    
    //Wrapper class to hold various attributes of Resource history to insert
    public class ProjectResourceHistoryWrapper{
      Id projectId;
      Id oldUserId;
      Id newUserId;
      String sUserRole;
      
      public ProjectResourceHistoryWrapper(Id projectId, Id oldUserId, Id newUserId, String sUserRole){
        this.projectId = projectId;
        this.oldUserId = oldUserId;
        this.newUserId = newUserId;
        this.sUserRole = sUserRole;

      }
    }
}