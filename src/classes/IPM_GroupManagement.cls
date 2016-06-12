/*********************************************************************************************************
    @Description : This class is used for Queue Creation & Queue member assignment on New project creation
    @Created Date: 30/06/2014
    @Author: Cognizant
    @Referenced: IPM_GroupManagement
**********************************************************************************************************/
//considering API enable features
//class should be run without sharing because we are creating/updating queue 
global without sharing class  IPM_GroupManagement {
    
   public static List<Group> grpList;//list of group 
   public static string className=IPM_GroupManagement.class.getname();//Get class name
   
    /****************************************************************************************
    @Description : This method is used to create a new group on new project creation
    *****************************************************************************************/
    public static void queueCreation(set<ID> projectidSet)
    {    
            grpList=new List<Group>(); 
            List<IPM_Project__c> projList=new List<IPM_Project__c>();
            string projidstr;
            projList=[SELECT Id,IPM_Project_Name__c,OwnerId, IPM_Technical_Project_Leader__r.id, IPM_Project_Gatekeeper__r.id, IPM_Project_Leader__r.id, 
                    Deputy_Project_Leader__r.id FROM IPM_Project__c WHERE Id in:projectidSet LIMIT 50000];
            
            if(projList != null & !projList.isEmpty()){
                for(IPM_Project__c p:projList){
                    projidstr = p.id;
                    //we tried with 18 digits id to add as queue name but it was failing.so we have queue name as combination of "IPM_" and project id with 15 digits. 
                    //while updating project name we are changing queue name as well                    
                    Group grp = new Group(Name=IPM_ConstantUtils.IPM_IPMNNAME+projidstr.Substring(0,15), Type = IPM_ConstantUtils.IPM_QUEUE);  
                    grpList.add(grp);
                } 
            }
            
            if(grpList != null & !grpList.isEmpty()){
                try{
                insert grpList;
                }catch(Exception ex){
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className,
                                                       IPM_ConstantUtils.IPM_QUEUE_CRNT_METHOD,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM);   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));                                  
                }
                Set<id> grpidSet = new Set<id>();
                for(Group grp:grpList){
                    grpidSet.add(grp.id);
                }
                GroupQueueUpdate(grpidSet,projectidSet);    
            }
            
      } 
      
          
    /****************************************************************************************
    @Description : This method is used to create a new queue & assignmed members to the queue
    *****************************************************************************************/
      
      @future
      public static void GroupQueueUpdate(set<id> Setgrpid, set<ID> projectidSet)
      {
          List<IPM_Project__c> projList=new List<IPM_Project__c>([SELECT Id,IPM_Project_Name__c,OwnerId, 
                                            IPM_Technical_Project_Leader__r.id, IPM_Project_Gatekeeper__r.id,
                                            IPM_Project_Leader__r.id, Deputy_Project_Leader__r.id FROM IPM_Project__c 
                                            WHERE Id in:projectidSet LIMIT 50000]);
          
          Map<String,Set<string>> QueueMemberIdMap = new Map<String,Set<string>>();
          Set<string> QueueMemberSet;
          string projectidstr;
            
            if(projList != null & !projList.isEmpty()){
                for(IPM_Project__c p:projList){
                     QueueMemberSet = new Set<string>();
                     projectidstr = p.Id;
                     
                     if(p.IPM_Technical_Project_Leader__r.id !=null){
                        QueueMemberSet.add(p.IPM_Technical_Project_Leader__r.id);
                     }
                     
                     if(p.IPM_Project_Gatekeeper__r.id !=null){
                        QueueMemberSet.add(p.IPM_Project_Gatekeeper__r.id);
                     }
                     
                     if(p.IPM_Project_Leader__r.id !=null){
                        QueueMemberSet.add(p.IPM_Project_Leader__r.id);
                     }
                     
                     if(p.Deputy_Project_Leader__r.id !=null){
                        QueueMemberSet.add(p.Deputy_Project_Leader__r.id);
                     }
                     projectidstr = p.Id;
                     QueueMemberIdMap.put(IPM_ConstantUtils.IPM_IPMNNAME+projectidstr.Substring(0,15),QueueMemberSet);
                }
            }
          
          
          list<QueueSobject>queueList=new List<QueueSobject>();
          list<GroupMember> memberList = new List<GroupMember>();
          grpList=[SELECT Id,Name FROM Group WHERE id IN: Setgrpid LIMIT 50000];
          if(grpList != null & !grpList.isEmpty()){
              for(Group grp:grpList){
                    
                    QueueSobject mappingObject_Project = new QueueSobject(QueueId = grp.Id, SobjectType = IPM_ConstantUtils.IPM_PROJECTOBJECT);
                    queueList.add(mappingObject_Project);
                    QueueSobject mappingObject_Financial = new QueueSobject(QueueId = grp.Id, SobjectType = IPM_ConstantUtils.IPM_FINANCEOBJECT);
                    queueList.add(mappingObject_Financial);
                    QueueSobject mappingObject_Bosscard = new QueueSobject(QueueId = grp.Id, SobjectType = IPM_ConstantUtils.IPM_BOSSCARDOBJECT);
                    queueList.add(mappingObject_Bosscard);
                    QueueSobject mappingObject_Country = new QueueSobject(QueueId = grp.Id, SobjectType = IPM_ConstantUtils.IPM_COUNTRYOBJECT);
                    queueList.add(mappingObject_Country);
                    QueueSobject mappingObject_Rollout = new QueueSobject(QueueId = grp.Id, SobjectType = IPM_ConstantUtils.IPM_ROLLOUTOBJECT);
                    queueList.add(mappingObject_Rollout);
                    QueueSobject mappingObject_SectionContent = new QueueSobject(QueueId = grp.Id, SobjectType = IPM_ConstantUtils.IPM_DOCUMENTSECTIONCONTENT);
                    queueList.add(mappingObject_SectionContent);                      
                    
                    if(QueueMemberIdMap.containskey(grp.Name)){
                        for(string memid:QueueMemberIdMap.get(grp.Name)){
                            GroupMember member = new GroupMember();
                            member.UserOrGroupId = memid;
                            member.GroupId = grp.Id;  
                            memberList.add(member);
                        }                                       
                    }
                    
                }
          }
          
          if(queueList!=null && !queueList.isEmpty()){
             if (Test.isRunningTest()) {
                // start new context via system.runAs() for the same user for test code only
                System.runAs(IPM_TestFactory_Helper.createUserAdmin(false)) {
                insert queueList;
                }
            } else {
                // in non-test code insert normally
                try{
                    insert queueList;
                 }catch(Exception ex){//running in future method, so we are not displaying any error in UI but create a log so system admin can track it
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className,
                                                       IPM_ConstantUtils.IPM_QUEUE_UPDATE_METHOD,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM); 
                }
          }
         }
          
          if(memberList!=null && !memberList.isEmpty()){ 
            if (Test.isRunningTest()) {
                // start new context via system.runAs() for the same user for test code only
                System.runAs(IPM_TestFactory_Helper.createUserAdmin(false)) {
                    insert memberList;
            }
            } else {
                // in non-test code insert normally
                try{
                    insert memberList;
                }catch(Exception ex){//running in future method, so we are not displaying any error in UI but create a log so system admin can track it
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className,
                                                       IPM_ConstantUtils.IPM_QUEUE_UPDATE_METHOD,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM); 
                }
          }
         }
          
          
     }
      
                
    /*************************************************************************************************
    @Description : This method is used to update the name of the queue to inline it with project name
    **************************************************************************************************/
      
      public static void groupNameUpdate(Set<Id> projectId)
      {
         Set<string> queuename = new Set<string>();
         string projectidstr;
                          
         for(string projid:projectId){
            projectidstr = projid;
            queuename.add(IPM_ConstantUtils.IPM_IPMNNAME + projectidstr.Substring(0,15));           
         }  
         grpList=[SELECT Id,Name FROM Group WHERE NAME IN: queuename LIMIT 50000];
          
          for(IPM_Project__c proj:[SELECT Id,Name,IPM_Project_Name__c,OwnerId FROM IPM_Project__c WHERE Id IN:projectId LIMIT 50000]){
              for(Group g:grpList){
                  projectidstr = proj.Id;
                  if(g.Name.equals(IPM_ConstantUtils.IPM_IPMNNAME+projectidstr.Substring(0,15))){
                      g.Name=IPM_ConstantUtils.IPM_IPMNNAME+proj.Name;
                      
                  }
              }
          }
          
          if(grpList!=null && !grpList.isEmpty()){ 
            if (Test.isRunningTest()) {
                // start new context via system.runAs() for the same user for test code only
                System.runAs(IPM_TestFactory_Helper.createUserAdmin(false)) {
                update grpList;
            }
            } else {
                // in non-test code insert normally
                try{
                    update grpList;
                }catch(Exception ex){//running in future method, so we are not displaying any error in UI but create a log so system admin can track it
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className,
                                                       IPM_ConstantUtils.IPM_QUEUE_UPDATENAME_METHOD,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM); 
                }
            }
          }
          
      } 
      
    /*********************************************************************
    @Description : This method is used to update the members of the queue
    **********************************************************************/
      
      @future
      public static void groupmemberupdate(Set<id>projidset){
        Set<id>grpidset = new Set<id>();
        Map<String,Set<string>> QueueMemberIdMap = new Map<String,Set<string>>();
        Map<id,string> QueueMemberIdNameMap = new Map<id,string>(); 
        Set<string> QueueMemberSet;
                
        List<IPM_Project__c> projList=new List<IPM_Project__c>([SELECT Id,owner.type,IPM_Project_Name__c, IPMProject_Span__c, OwnerId,IPM_Global_Project_Id__c, IPM_Golbal_Project_OwnerId__c, IPM_Technical_Project_Leader__r.id, 
                                            IPM_Project_Gatekeeper__r.id, IPM_Project_Leader__r.id, Deputy_Project_Leader__r.id, 
                                            (Select name, id, IPM_User__r.id from IPM_Project_Resources__r ) FROM 
                                            IPM_Project__c WHERE id IN:projidset or IPM_Parent_Project__c IN:projidset or IPM_Parent_Project__r.IPM_Parent_Project__c IN:projidset LIMIT 50000]);
            
            
            if(projList!=null && !projList.isEmpty()){  
                for(IPM_Project__c p:projList){
                    id queueid = p.IPM_Golbal_Project_OwnerId__c;
                    if(QueueMemberIdMap.containskey(queueid)){
                         QueueMemberSet = new Set<string>();
                         QueueMemberSet = QueueMemberIdMap.get(queueid);
                         if(p.IPM_Technical_Project_Leader__r.id !=null){
                         QueueMemberSet.add(p.IPM_Technical_Project_Leader__r.id);}
                         
                         if(p.IPM_Project_Gatekeeper__r.id !=null){
                         QueueMemberSet.add(p.IPM_Project_Gatekeeper__r.id);}
                         
                         if(p.IPM_Project_Leader__r.id !=null){
                         QueueMemberSet.add(p.IPM_Project_Leader__r.id);}
                         
                         if(p.Deputy_Project_Leader__r.id !=null){
                         QueueMemberSet.add(p.Deputy_Project_Leader__r.id);}
                         
                         
                         QueueMemberIdMap.put(queueid,QueueMemberSet);
                                            
                     }
                     else{
                         QueueMemberSet = new Set<string>();
                        
                         if(p.IPM_Technical_Project_Leader__r.id !=null){
                         QueueMemberSet.add(p.IPM_Technical_Project_Leader__r.id);}
                         
                         if(p.IPM_Project_Gatekeeper__r.id !=null){
                         QueueMemberSet.add(p.IPM_Project_Gatekeeper__r.id);}
                         
                         if(p.IPM_Project_Leader__r.id !=null){
                         QueueMemberSet.add(p.IPM_Project_Leader__r.id);}
                         
                         if(p.Deputy_Project_Leader__r.id !=null){
                         QueueMemberSet.add(p.Deputy_Project_Leader__r.id);}
                        
                         
                         QueueMemberIdMap.put(queueid,QueueMemberSet);
                         grpidset.add(queueid);
                         
                         if(p.owner.type != 'Queue'){
                         	string tempid = p.id;
                         	QueueMemberIdNameMap.put(queueid,IPM_ConstantUtils.IPM_IPMNNAME+tempid.Substring(0,15));                          	
                         }      
                            
                     }
                     
                     for(IPM_Project_Resource__c projres:p.IPM_Project_Resources__r){
                         if(projres.IPM_User__r.id != null){ 
                            
                            QueueMemberIdMap.get(queueid).add(projres.IPM_User__r.id);
                        }  
                     } 
                     
                                     
                }
            }
            
        
        Map<id, Group> grpmap = new Map<id,Group>([SELECT Id,Name FROM Group WHERE (id IN: grpidset or Name IN:QueueMemberIdNameMap.values()) LIMIT 50000]);
        list<GroupMember> memberdeleteList = new List<GroupMember>([SELECT Id, UserOrGroupId, GroupId FROM GroupMember WHERE GroupId IN: grpmap.keyset() LIMIT 50000]);
		Map<string, Group> grpNamemap = new Map<string,Group>();
			
		for(Group grp:grpmap.values()){
			grpNamemap.put(grp.Name,grp);
		}
			     
        
        if(grpmap != null && !grpmap.isEmpty()){
            if(memberdeleteList!=null && !memberdeleteList.isEmpty()){
                try{
                    delete memberdeleteList;
                }catch(Exception ex){
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className,
                                                       IPM_ConstantUtils.IPM_GRP_MEM_UPDATE_METHOD,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM); 
                }  
            }
                  
            list<GroupMember> memberList = new List<GroupMember>();           
           
           
            if(QueueMemberIdMap.keyset() != null){
                for(id grpid:QueueMemberIdMap.keyset()){
                                      
                    if(grpmap.containskey(grpid)){
                         for(string memid:QueueMemberIdMap.get(grpid)){
                            GroupMember member = new GroupMember();
                            member.UserOrGroupId = memid;
                            member.GroupId = grpId;                         
                            memberList.add(member);                                                
                        }
                    }
                                      
                    if(QueueMemberIdNameMap.containskey(grpid) && grpNamemap.containskey(QueueMemberIdNameMap.get(grpid))){
                         for(string memid:QueueMemberIdMap.get(grpid)){
                            GroupMember member = new GroupMember();
                            member.UserOrGroupId = memid;
                            member.GroupId = grpNamemap.get(QueueMemberIdNameMap.get(grpid)).id;                         
                            memberList.add(member); 
                                                
                        }
                    }   
                                        
                }
            }
            
            if(memberList!=null && !memberList.isEmpty()){ 
                   if (Test.isRunningTest()) {
                    // start new context via system.runAs() for the same user for test code only
                    System.runAs(IPM_TestFactory_Helper.createUserAdmin(false)) {
                    insert memberList;
                }
                } else {
                    // in non-test code insert normally
                    try{
                        insert memberList;
                        
                    }catch(Exception ex){//running in future method, so we are not displaying any error in UI but create a log so system admin can track it
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className,
                                                       IPM_ConstantUtils.IPM_GRP_MEM_UPDATE_METHOD,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM); 
                }   
              }

            }
        }
        
      }
    /*********************************************************************
    @Description : This method is used to delete queue
    **********************************************************************/
          
    @future
    public static void deleteQueue(Set<id>Queueidset){
        List<Group>grpsList=[SELECT Id,Name FROM Group WHERE id IN: Queueidset LIMIT 50000];
        
        if(grpsList!=null && !grpsList.isEmpty()){
            try{
                delete grpsList;
                    
                }catch(Exception ex){//running in future method, so we are not displaying any error in UI but create a log so system admin can track it
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className,
                                                       'deleteQueue',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM); 
                }
        }

    }

}