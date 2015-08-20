/**********************************************************************
Name: BET_ManageMembersContoller
Copyright © 2014 Unilever.
======================================================
==========================================================
Purpose: Apex controller to manage BET members
Used in: BET_ManageMembers VisualForce page
==========================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          12/12/2014      INITIAL DEVELOPMENT
1.1-    Blessy Voola            28 Apr 2015   T0: Fix for the issue: If a user is already added to chatter group, when trying to 
                                                 add the same user to the bet associated it is showing error
1.2    Kendre Dnyaneshwar       27 Apr 2015   T1: Modified the query in getmembers method to remove delete button for BET 
                                                 owner                                      
***********************************************************************/

public without sharing class BET_ManageMembersController {
    public uw_BET_Team_Member__c BETTeamMember {get;set;}
    public String betId {get;set;}
    public String recordId {get;set;}
    //public Id recordTypeId {get;set;}
    //public String role {get;set;}
    private String ManagerRole;
    private String MemberRole;
    private String ExternalRole;
    private String ApprovedStatus;
    private String DeniedStatus;
    private String ToolkitAccessLevel;
    private String ExternalAccessLevel;
    private String InternalUserRecordType;
    private String BETMemberObjectName;

    public Boolean myPrivilegesChanged {get; protected set;}

    private String setEmailAdd {get;set;}
    private String setErrorMessage{get;set;}//T02 - T&C functional gap1 
    public String inviteSent{get;set;}

    public Boolean hasModifyAccess {get; protected set;}

    //private String pageURL;
    public class MyDMLException extends Exception{}    
    /*****************************************************************************************
    Purpose: Constructor - Initializes BETMember record for adding a new member. 
             Record type is set to InternalUser
    Parameters: ApexPages StandardController
    Returns: Void
    Throws [Exceptions]: [optional]
    ******************************************************************************************/   
    public BET_ManageMembersController(ApexPages.StandardController controller) {
       String pageURL = ApexPages.currentPage().getUrl();
       System.Debug('PAGE URL: ' + pageURL);
       betId = ApexPages.currentPage().getParameters().get('bet');
       
       BET_ManageMembersSettings__c BETManageMembersConfig = BET_ManageMembersSettings__c.getValues('BETManageMembersConfig');
       ManagerRole = BETManageMembersConfig.ManagerRole__c;
       MemberRole = BETManageMembersConfig.MemberRole__c;
       ExternalRole = BETManageMembersConfig.ExternalRole__c;
       ApprovedStatus = BETManageMembersConfig.ApprovedStatus__c;
       DeniedStatus = BETManageMembersConfig.DeniedStatus__c;
       ToolkitAccessLevel = BETManageMembersConfig.ToolkitAccessLevel__c;
       ExternalAccessLevel = BETManageMembersConfig.ExternalAccessLevel__c;
       InternalUserRecordType = BETManageMembersConfig.InternalUserRecordType__c;
       BETMemberObjectName = BETManageMembersConfig.BET_Member_Object_Name__c;

       hasModifyAccess = BET_CommonService.canModify(betId);
       myPrivilegesChanged = false;

       BETTeamMember = new uw_BET_Team_Member__c();
       List<RecordType> recordTypeIdList = [SELECT Id FROM RecordType WHERE SobjectType = :BETMemberObjectName and Name = :InternalUserRecordType LIMIT 1];
       if ( recordTypeIdList.size() == 0 ) {
           System.Debug('No RecordType found');
           return;
       }     
       //recordTypeId = recordTypeIdList[0];
       BETTeamMember.recordTypeId = recordTypeIdList[0].Id;
    }

    /*****************************************************************************************
    Purpose: Returns the name of the BET
    Parameters: void
    Returns: List of BET Members
    Throws [Exceptions]: [optional]
    ******************************************************************************************/  
    public String getBetName() {
        System.Debug('getBetName Bet ID: ' + betId);
        
        List<uw_BET__c> betList = [SELECT Id, Name FROM uw_BET__c WHERE Id = :betId LIMIT 1];
        if ( betList.size() == 0 ) {
             System.Debug('No BET found');
             return null;
        }
        
        return betList[0].Name;
    }
    
    /*****************************************************************************************
    Purpose: Returns the pending membership requests for a BET
    Parameters: void
    Returns: List of BET Members
    Throws [Exceptions]: [optional]
    ******************************************************************************************/  
    public List<uw_BET_Team_Member__c> getPendingRequests() {
        return [SELECT Id, Name, Team_Member__r.Name, Team_Member__r.Title, Team_Member__r.SmallPhotoUrl, Pending_Request__c, Request_Status__c FROM uw_BET_Team_Member__c WHERE BET__c = :betId AND Pending_Request__c = true];
    }
    
    /*****************************************************************************************
    Purpose: Returns the existing members for a BET
    Parameters: void
    Returns: List of BET Members
    Throws [Exceptions]: [optional]
    ******************************************************************************************/ 
   public List<uw_BET_Team_Member__c> getMembers() {
    /*    
    return [SELECT Id, Name, Team_Member__c, Team_Member__r.Name, Team_Member__r.Title, Team_Member__r.SmallPhotoUrl, Role__c, email__c FROM uw_BET_Team_Member__c WHERE BET__c = :betId AND Pending_Request__c != true AND Request_Status__c != :DeniedStatus]; 
    */ 
    /* T1 Start */
    return [SELECT Id, Name, IsOwner__c, Team_Member__c, Team_Member__r.Name, Team_Member__r.Title, Team_Member__r.SmallPhotoUrl, Role__c, email__c FROM uw_BET_Team_Member__c WHERE BET__c = :betId AND Pending_Request__c != true AND Request_Status__c != :DeniedStatus]; 
    /* T1 End */
    }
    
    /* 
     public List<selectOption> getRoles() {
         List<selectOption> options = new List<selectOption>();
         Schema.DescribeFieldResult fieldResult =
                uw_BET_Team_Member__c.Role__c.getDescribe();             
         List<Schema.PicklistEntry> picklistEntryList = fieldResult.getPicklistValues();
        
         for( Schema.PicklistEntry picklistEntry : picklistEntryList)
         {
              options.add(new SelectOption(picklistEntry.getLabel(), picklistEntry.getValue()));
         }       
         return options;
    }
    */
    
    /*****************************************************************************************
    Purpose: Approve requests for a BET
             It also creates BETShare, CollaborationGroupMember and EntitySubscription records
             to support Chatter related actions and BET sharing.
             In addition, it triggers a workflow to send an email to the user that the request has been approved.
    Parameters: void
    Returns: PageReference to the original page
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    public PageReference approveRequest() {
        if(!hasModifyAccess){
            return null;
        }
         //String accessLevel;
         
         System.Debug('Approve Request: ' + recordId);
         List<uw_BET_Team_Member__c> betMemberList = [SELECT Id, Name, Role__c, Team_Member__c, BET__c, BET__r.Studio_Chatter_Group__c FROM uw_BET_Team_Member__c WHERE Id = :recordId AND BET__c = :betId];
         if ( betMemberList.size() == 0 ) {
             System.Debug('Bet Member record not found: ' + recordId);
             return null;
         }
         uw_BET_Team_Member__c betMember = betMemberList[0];
         // Clear Pending Request
         betMember.Pending_Request__c = false;  
         betMember.Request_Status__c = ApprovedStatus;
         
         System.Debug('Role: ' + betMember.Role__c);
         
         String accessLevel = (betMember.Role__c.equalsIgnoreCase(ManagerRole) == true ) ? 'Edit' : 'Read';
         uw_BET__Share betShare = createBETShare(betMember.Team_Member__c, accessLevel, betMember.BET__c);
         
         CollaborationGroupMember cgm = createCollaborationGroupMemberRecord(betMember);
         
         EntitySubscription entitySubscription = createEntitySubscription(betMember);
         
         // Create a savepoint for database transaction
         Savepoint sp = Database.setSavepoint();
         try {
             // Force DML exception for test
             if ( Test.isRunningTest()) {
                  if ( betMember.Role__c == 'ThrowDMLException' ) throw new MyDMLException();        
            }
            update betMember;
            insert betShare;
            insert cgm;
            insert entitySubscription;
         }
         catch (Exception e) {
            System.Debug('Insert or Update Exception: ' + e.getMessage() + 'BET Member Id: ' + betMember.Id); 
            Database.rollback(sp);
            return null;
         }
                
         return null;
    }
    
    /*****************************************************************************************
    Purpose: Deny requests for a BET
             It triggers a workflow to send an email to the user that the request has been denied.
    Returns: PageReference to the original page
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    public PageReference denyRequest() {
        if(!hasModifyAccess){
            return null;
        }

         System.Debug('Deny Request: ' + recordId);    
         List<uw_BET_Team_Member__c> betMemberList = [SELECT Id, Name FROM uw_BET_Team_Member__c WHERE Id = :recordId AND BET__c = :betId];
         if ( betMemberList.size() == 0 ) {
             System.Debug('Bet Member record not found: ' + recordId);
             return null;
         }
         uw_BET_Team_Member__c betMember = betMemberList[0];
         
         // Clear Pending Request
         betMember.Pending_Request__c = false;  
         // Set Request Denied to true - trigger an email workflow
         betMember.Request_Status__c = DeniedStatus;
         
         // Update BET_Member__c record
         try { 
            update betMember;
         }
         catch (Exception e) {System.Debug('Update Exception for BET Share record: ' + e.getMessage() + 'BET Member Id: ' + betMember.Id); return null;}
         
         return null;
         
    } 
    
    /*****************************************************************************************
    Purpose: Set role for a BET member (Member or Manager)
             It also changes the settings for CollaborationGroupMember (Standard or Admin)
             and for BETShare (Edit or Read access)
    Returns: PageReference to the original page
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    public PageReference setRole() {
        if(!hasModifyAccess){
            return null;
        }

         String memberid = Apexpages.currentPage().getParameters().get('memberId');
         String role = Apexpages.currentPage().getParameters().get('role');
         System.Debug('Member ID: ' + memberid);
         System.Debug('Role: ' + role);
         
         uw_BET_Team_Member__c betMember = new uw_BET_Team_Member__c();
         betMember.Id = memberid;
         betMember.Role__c = role;
         
         CollaborationGroupMember cgm = updateCollaborationGroupMember(betid, memberid);
         uw_BET__Share betShare = updateBETShare(betId, memberid);
         
         If ( cgm != null ) {
           if (role.equalsIgnoreCase(ManagerRole)){
               cgm.CollaborationRole = 'Admin';
           }else {                
               cgm.CollaborationRole = 'Standard';
           }
         } 
         
         If ( betShare != null ) {
           if (role.equalsIgnoreCase(ManagerRole)){
               betShare.AccessLevel = 'Edit';
           }else {                
               betShare.AccessLevel = 'Read';
           }
         }
         
         Savepoint sp = Database.setSavepoint();
         // Update BET_Member__c record
         try { 
            // Force DML exception for test
            if ( Test.isRunningTest()) {
                  if ( betMember.Role__c == 'ThrowDMLException' ) throw new MyDMLException();        
            }
            update betMember;
            if ( cgm != null ) update cgm;
            if ( betShare != null) update betShare;
            if ( myPrivilegesChanged ) {
                hasModifyAccess = BET_CommonService.canModify(betId);
            }

         }
         catch (Exception e) {
             System.Debug('Update Exception for BET Share record: ' + e.getMessage() + 'BET Member Id: ' + betMember.Id); 
             Database.rollback(sp);
             return null;
         }
                 
         return null;
    }
    
     public Boolean isUserExist(uw_BET_Team_Member__c teamMember) {
         List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id FROM uw_BET_Team_Member__c WHERE BET__c = :teamMember.BET__c AND Team_Member__c = :teamMember.Team_Member__c];
         //if ( teamMemberList.size() == 0 ) {
         //     return false;
         //}
         //else {
         //      return true;
         //}
         
         return ( teamMemberList.size() == 0 ) ? false : true;
     }
     
    /*****************************************************************************************
    Purpose: Create a new a BET member (Member or Manager)
             It also creates BETShare, CollaborationGroupMember and EntitySubscription records
             to support Chatter related actions and BET sharing.
    Returns: PageReference to the original page
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    public PageReference addMember() {
        if(!hasModifyAccess){
            return null;
        }
         //String PageURL = '/apex/BET_ManageMembers' + '?bet=' + betId;
         //System.Debug('PageUrl: '  + PageURL);
         //PageReference pageRef = new PageReference(pageURL);
         //pageRef.setRedirect(true);
         System.Debug('addMember is invoked');
         System.Debug('BETMember: ' + BETTeamMember.Team_Member__c);
         System.Debug('BETMember: ' + BETTeamMember.Role__c);
         System.Debug('BETMember: ' + BETTeamMember.email__c);
         //System.Debug('PageUrl: '  + pageRef.getUrl());
         
         if (BETTeamMember.Team_Member__c == null && BETTeamMember.email__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You should select an internal or an external user.')); 
            BETTeamMember.Team_Member__c = null;
            BETTeamMember.email__c = null;
            return null;
         }
         
         if (BETTeamMember.Team_Member__c != null && BETTeamMember.email__c != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You should select either an internal or an external user. The two types of users cannot be added at once.')); 
            BETTeamMember.Team_Member__c = null;
            BETTeamMember.email__c = null;
            return null;
         }
    
         if ( BETTeamMember.email__c != null ) {
             System.Debug('External User + Email is given.');
             addExternalUser(BETTeamMember.email__c);
             BETTeamMember.Team_Member__c = null;
             BETTeamMember.email__c = null;
             return null;
             //return pageRef;
         }
                                
         BETTeamMember.BET__c = betId;
         BETTeamMember.BETEnabled__c = true;
         BETTeamMember.Access_Level__c = ToolkitAccessLevel;
         
         if ( isUserExist(BETTeamMember) ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'User already exists.')); 
            BETTeamMember.Team_Member__c = null;
            BETTeamMember.email__c = null;
            return null;
         }
      
         Savepoint sp = Database.setSavepoint();
         try {
            if ( Test.isRunningTest()) {
                  if ( BETTeamMember.Request_Status__c == 'DMLExceptionBeforeInsert' ) throw new MyDMLException();        
            }
            insert BETTeamMember;
         }
         catch (Exception e) {
             System.Debug('New BETMEmber Insert Exception: ' + e.getMessage());
             Database.rollback(sp);
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Cannot add User to the group.'));
             BETTeamMember.Team_Member__c = null;
             BETTeamMember.email__c = null;
             return null;
             //return pageRef;
         }
         
         List<uw_BET_Team_Member__c> betMemberList = [SELECT Id, Name, Role__c, Team_Member__c, BET__c, BET__r.Studio_Chatter_Group__c FROM uw_BET_Team_Member__c WHERE Id = :BETTeamMember.Id AND BET__c = :betId];
         if ( Test.isRunningTest()) {
                  if ( BETTeamMember.Request_Status__c == 'DMLExceptionAfterInsert' ) betMemberList.clear();        
         } 
         if ( betMemberList.size() == 0 ) {
             System.Debug('Bet Member record not found: ' + recordId);
             Database.rollback(sp);
             BETTeamMember.Team_Member__c = null;
             BETTeamMember.email__c = null;
             return null;
             //return pageRef;
         }
         uw_BET_Team_Member__c betMember = betMemberList[0];

         String accessLevel = (betMember.Role__c.equalsIgnoreCase(ManagerRole) == true ) ? 'Edit' : 'Read';
         uw_BET__Share betShare = createBETShare(betMember.Team_Member__c, accessLevel, betMember.BET__c);
         /*T0-Begin To check if member to add is already added to chatter group associated to BET*/
         Id memid = betMemberList[0].Team_Member__c;
         id cgid =betMemberList[0].Bet__r.Studio_Chatter_Group__c;
         List<CollaborationGroupMember> cglist=[select id from CollaborationGroupMember where CollaborationGroupId =:cgid and Memberid=:memid];
       /*T0-End*/
         EntitySubscription entitySubscription = createEntitySubscription(betMember);
         
         try {
            if ( Test.isRunningTest()) {
                  if ( BETTeamMember.Request_Status__c == 'DMLExceptionBETShareInsert' ) throw new MyDMLException();        
            }
            /*T0-Begin*/
             if(cglist.size()==0){
                  CollaborationGroupMember cgm =  createCollaborationGroupMemberRecord(betMember); 
          insert cgm;
         }
         /*T0-End*/
            insert betShare;
//              insert cgm;
            insert entitySubscription;
         }
         catch (Exception e) {
             System.Debug('New BETMEmber Insert Exception: ' + e.getMessage());
             Database.rollback(sp);
             BETTeamMember.Team_Member__c = null;
             BETTeamMember.email__c = null;
             return null;
             //return pageRef;
         }
//         BETTeamMember.Team_Member__c = null;
//         BETTeamMember.email__c = null;
            Id recordTypeId = BETTeamMember.recordTypeId;
            BETTeamMember = new uw_BET_Team_Member__c();
            BETTeamMember.recordTypeId = recordTypeId;
         return null;
         //return pageRef;
    }
    
    
    
    
    Public Boolean deleteMem(){
    System.Debug('Deletemem method called');
     
        List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Name, Role__c, BET__c, BET__r.Studio_Chatter_Group__c, Team_Member__c FROM uw_BET_Team_Member__c WHERE Id = :recordId AND BET__c = :betId];
        if ( teamMemberList.size() == 0 ) {
            System.Debug('TeamMemberList is empty');
           // return null;
        }
         uw_BET_Team_Member__c teamMember = teamMemberList[0];
        CollaborationGroupMember cgm = deleteCollaborationGroupMember(teamMember); 
        
    if(teamMember.Team_Member__c==Userinfo.getUserId()){
    System.Debug('If block executed');
    return true;
    }
    else
    {
    return false;
    }
    return null;
    }
    /*****************************************************************************************
    Purpose: Delete a BET member 
             It also deletes BETShare, CollaborationGroupMember and EntitySubscription records
             that support Chatter related actions and BET sharing.
    Returns: PageReference to the original page
    Throws [Exceptions]: [optional]
    ******************************************************************************************/ 
    public PageReference deleteMember() {
        if(!hasModifyAccess){
            return null;
        }
        System.Debug('delete member method called');
        // recordId = BET_Member Id
        System.Debug('Record Id: ' + recordId);
         
        uw_BET__Share betShare = deleteBETShare(betId, recordId);
        
        List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Name, Role__c, BET__c, BET__r.Studio_Chatter_Group__c, Team_Member__c FROM uw_BET_Team_Member__c WHERE Id = :recordId AND BET__c = :betId];
        if ( teamMemberList.size() == 0 ) {
            System.Debug('TeamMemberList is empty');
            return null;
        }
        
        uw_BET_Team_Member__c teamMember = teamMemberList[0];
        CollaborationGroupMember cgm = deleteCollaborationGroupMember(teamMember); 
        
        EntitySubscription entitySubscription = deleteEntitySubscription(teamMember);
        
        // Create a savepoint for database transaction
        Savepoint sp = Database.setSavepoint();
        try {
           // Force DML exception for test
           if ( Test.isRunningTest()) {
                  if ( teamMember.Role__c == 'ThrowDMLException' ) throw new MyDMLException();        
           }
           delete teamMember;
           if ( betShare != null ) delete betShare;
           if ( cgm != null) delete cgm;
           if ( entitySubscription != null ) delete entitySubscription;
        } catch (Exception e) {
             System.Debug('Update Exception for BET Share record: ' + e.getMessage() + 'BET Member Id: ' + teamMember.Id); 
             Database.rollback(sp);
             return null;
        }
         
        return null;
    }
    
    /*****************************************************************************************
    Purpose: Support method to create a BETShare object 
    Returns: BETShare object 
    Throws [Exceptions]: [optional]
    ******************************************************************************************/ 
    private uw_BET__Share createBETShare(Id userId, String accessLevel, Id betId) {
         // Create BET Share Record   
         uw_BET__Share betShare = new uw_BET__Share();
         betShare.UserOrGroupId = userid;
         betShare.AccessLevel = accessLevel;
         betShare.ParentId = betId;
    
         return betShare; 
    }
    
    /*****************************************************************************************
    Purpose: Support method to create a CollaborationGroupMember object 
    Returns: CollaborationGroupMember object
    Throws [Exceptions]: [optional]
    ******************************************************************************************/ 
    private CollaborationGroupMember createCollaborationGroupMemberRecord(uw_BET_Team_Member__c teamMember) {
        CollaborationGroupMember cgm = new CollaborationGroupMember();
        cgm.CollaborationGroupId = teamMember.Bet__r.Studio_Chatter_Group__c;
        cgm.MemberId = teamMember.Team_Member__c;
        cgm.NotificationFrequency = 'N';
        if (teamMember.Role__c.equalsIgnoreCase(ManagerRole)){
            cgm.CollaborationRole = 'Admin';
        }else {                
            cgm.CollaborationRole = 'Standard';
        }     
                
        return cgm;
    }
    
   /*****************************************************************************************
    Purpose: Support method to create an EntitySubscription object 
    Returns: EntitySubscription object
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    private EntitySubscription createEntitySubscription(uw_BET_Team_Member__c teamMember) {
        EntitySubscription entitySubscription = new EntitySubscription();
        entitySubscription.SubscriberId = teamMember.Team_Member__c;
        entitySubscription.ParentId = teamMember.Bet__c;
        
        return entitySubscription;
        
    }
    
    /*****************************************************************************************
    Purpose: Support method to delete a BETShare object 
    Returns: BETShare object 
    Throws [Exceptions]: [optional]
    ******************************************************************************************/ 
    private uw_BET__Share deleteBETShare(String betId, String memberId) {
        List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Team_Member__c FROM uw_BET_Team_Member__c WHERE Id = :memberId AND BET__c = :betId];
        if ( teamMemberList.size() == 0 ) {
             System.Debug('No BET TeamMember found');
             return null;
        }
        uw_BET_Team_Member__c teamMember = teamMemberList[0];
        
        List<uw_BET__Share> betShareList = [SELECT Id FROM uw_BET__Share WHERE parentId = :betId AND userOrGroupId = :teamMember.Team_Member__c LIMIT 1]; 
        if (betShareList.size() == 0 ) {
           System.Debug('No BET Share is found');
           return null;
        }
        
        return betShareList[0];
    }
    
    /*****************************************************************************************
    Purpose: Support method to delete a CollaborationGroupMember object 
    Returns: CollaborationGroupMember object
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    private CollaborationGroupMember deleteCollaborationGroupMember(uw_BET_Team_Member__c teamMember) {
        Id chatterGroupId = teamMember.BET__r.Studio_Chatter_Group__c;
        List<CollaborationGroupMember> cgmList = [SELECT Id FROM CollaborationGroupMember WHERE CollaborationGroupId =: chatterGroupId AND memberId=:teamMember.Team_Member__c];
        if ( cgmList.size() == 0 ) {
           System.Debug('No CollaborationGroupMember found.');
           return null;
        }
        
        return cgmList[0];
    }
    
    /*****************************************************************************************
    Purpose: Support method to delete an EntitySubscription object 
    Returns: EntitySubscription object
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    private EntitySubscription deleteEntitySubscription(uw_BET_Team_Member__c teamMember) {
        List<EntitySubscription> entitySubscriptionList = [Select Id,SubscriberId,ParentId from EntitySubscription where SubscriberId=:teamMember.Team_Member__c and ParentId=:betId LIMIT 1];
        if ( entitySubscriptionList.size() == 0 ) {
           System.Debug('No CollaborationGroupMember found.');
           return null;
        }
        
        return entitySubscriptionList[0];        
    }
    
    /*****************************************************************************************
    Purpose: Support method to update a CollaborationGroupMember object 
    Returns: CollaborationGroupMember object
    Throws [Exceptions]: [optional]
    ******************************************************************************************/
    private CollaborationGroupMember updateCollaborationGroupMember(Id betId , Id memberId) {
         List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Team_Member__c, Role__c, BET__c, BET__r.Studio_Chatter_Group__c FROM uw_BET_Team_Member__c WHERE Id = :memberId AND BET__c = :betId];
         if ( teamMemberList.size() == 0 ) {
             System.Debug('BET Team Member not found');
             return null;
         }
         
         uw_BET_Team_Member__c teamMember = teamMemberList[0];
         Id chatterGroupId = teamMember.BET__r.Studio_Chatter_Group__c;
         
         System.Debug('UPDATE CGM ChatterGroup: ' + chatterGroupId);
         System.Debug('UPDATE CGM TeamMember: ' + teamMember.Team_Member__c);
         List<CollaborationGroupMember> cgmList = [SELECT Id FROM CollaborationGroupMember 
                                         WHERE CollaborationGroupId = :chatterGroupId
                                         AND MemberId = :teamMember.Team_Member__c];
         if (cgmList.size() == 0) {
             System.Debug('No CollaborationGroupMember found');
             return null;
         }
         
         CollaborationGroupMember cgm = cgmList[0];
         
         return cgm;
    }
    
    /*****************************************************************************************
    Purpose: Support method to update a BETShare object 
    Returns: BETShare object 
    Throws [Exceptions]: [optional]
    ******************************************************************************************/ 
    private uw_Bet__Share updateBetShare (String betId, String memberId) {
         List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Team_Member__c FROM uw_BET_Team_Member__c WHERE Id = :memberId AND BET__c = :betId];
         if ( teamMemberList.size() == 0 ) {
             System.Debug('No BET TeamMember found');
             return null;
         }
         uw_BET_Team_Member__c teamMember = teamMemberList[0];
         
         if(teamMember.Team_Member__c == Userinfo.getUserId()) {
            myPrivilegesChanged = true;
         } else {
            myPrivilegesChanged = false;
         }
         List<uw_BET__Share> betShareList = [SELECT Id FROM uw_BET__Share WHERE parentId = :betId AND userOrGroupId = :teamMember.Team_Member__c LIMIT 1];
         
         if ( betShareList.size() == 0 ) {
             System.Debug('No BETShare found');
             return null;
         }
         
         return betShareList[0];
    }

    private Boolean checkEmail(String emailAddEntered){  
        Profile chatterExternalProfile = [SELECT Id FROM Profile WHERE Name='Chatter External User' LIMIT 1];

        if (emailAddEntered == null) {
            setErrorMessage = 'The extenal user email address is blank. Please enter a value.';
            return false;
        }else if (emailAddEntered.trim().equals('')) {
            setErrorMessage = 'The extenal user email address is blank. Please enter a value.';
            return false;
        }else if (emailAddEntered.trim().contains('@unilever.com')) {// T02 check if agent email id belongs to unilever employee
            setEmailAdd = emailAddEntered.trim();
            //check if there is already an user in the system.
            List<User> nonAgent = [SELECT id, email,IsActive, Name FROM user where email =:setEmailAdd AND profileID != :chatterExternalProfile.Id limit 1];
            if (nonAgent.size()>0) {
                if(nonAgent[0].IsActive){
                    setErrorMessage='This email id belongs to an existing internal Unilever user: '+nonAgent[0].Name +' who already has a Chatter account. Please add them as an internal member to your BET from the Manage Members page';
                }else if (!nonAgent[0].IsActive) {
                    setErrorMessage = 'This email id belongs to an existing Unilever internal user: '+nonAgent[0].Name+', who\'s Chatter account is currently locked. Please contact marketing@unilever.com to request this account be re-activated.';
                }  
            }else{
                setErrorMessage = setEmailAdd+' does not have a Chatter account. Please contact marketing@unilever.com to request an account for them. Once the user has an account, please add them as an internal member to your BET from the Manage Members page.';
            }
            return false;
        }else{
            setEmailAdd = emailAddEntered.trim();
            return true;
        }
    }

    private List<User> isExistingExternalUser() {
        Profile chatterExternalProfile = [SELECT Id FROM Profile WHERE Name='Chatter External User' LIMIT 1];
        List<User> userList = [SELECT Id, IsActive FROM User WHERE email= :setEmailAdd AND ProfileId=:chatterExternalProfile.Id];
        return userList ; 
    }

    private Boolean isExistingPendingUser() {
        Boolean exists = false;
        List<uw_BET_Team_Member__c> tms = [SELECT Id, Invite_Pending__c, Email__c, Team_Member__c, Team_Member__r.Name, Name, Role__c, StudioEnabled__c, BETEnabled__c, IsOwner__c, Editing__c 
                                            FROM uw_Bet_Team_Member__c WHERE Email__c = :setEmailAdd AND Invite_Pending__c = true 
                                            AND BET__c = : betId];
        return !uw_HelperMethods.listIsNull(tms);           
    }

    /*****************************************************************************************
    Purpose: Support method to create an External BET user (Chatter only) - new version based on previous application. @author: Maciej Krol
    Returns: void
    Throws [Exceptions]: [optional]
    ******************************************************************************************/ 
    private void addExternalUser(String emailAddress) {
        Id addId;
        Boolean handAddToCollaborationGroup = false;
        Boolean isPending = false;
        Boolean skipCreation = false;
        inviteSent = '';

        if (! checkEmail(emailAddress)) {
            Apexpages.Message m = new apexpages.Message(ApexPages.Severity.ERROR, setErrorMessage);
            apexpages.addMessage(m);
            return;
        }else{
            List<User> userList = isExistingExternalUser();
            if ((userList != null) && (userList.size() > 0) ) {
                if(!userList[0].isActive){
                    Apexpages.Message m = new apexpages.Message(ApexPages.Severity.ERROR, setEmailAdd +' is an existing user (External Agent) but inactive at the moment. Please send an email to marketing@unilever.com for further clarification.');
                    apexpages.addMessage(m);  
                    return;  
                }else{
                    handAddToCollaborationGroup = true;
                    addId = userList[0].Id;
                }
            }else if (isExistingPendingUser()){
                inviteSent = 'Note: '+ emailAddress + ' has already been invited';
                skipCreation = true;
            }else{
                List<uw_BET__c> betList = [SELECT Id, Name, Studio_Chatter_Group__c FROM uw_BET__c WHERE Id = :betId LIMIT 1];
                if ( betList.size() == 0 ) {Apexpages.Message m = new apexpages.Message(ApexPages.Severity.ERROR, 'No BET found');return;}

                uw_Terms_Conditions__c tnc = new uw_Terms_Conditions__c();
                tnc.Status__c = 'New';
                tnc.Invitee_Email__c = setEmailAdd;
                tnc.Invite_Expires__c = System.now().addDays(14); 
                tnc.Bet_Name__c = betList[0].Name;
                tnc.uw_BET__c = betId;
                tnc.Studio_Chatter_Group__c = betList[0].Studio_Chatter_Group__c;
                tnc.Action_On_Accept__c = 'Send Invite';
                try{
                    insert tnc;
                }catch(exception e){return;}

                uw_TokenHelper th = new uw_TokenHelper();
                th.taCId = tnc.id;
                String encoded = th.encode();
                String encodedForURL = th.makeTokenForURL(encoded);
                
                tnc.Invite_Token__c = encodedForURL;
                tnc.Status__c = 'Send';
                update tnc;
                
                EntitySubscription eSub = new EntitySubscription();
                eSub.SubscriberId = Userinfo.getUserId(); 
                eSub.ParentId = tnc.Id;
                insert eSub;
                                         
                inviteSent = 'Invite has been sent to '+setEmailAdd;
                isPending = true;      
            }

            if (skipCreation == false) {
                userList = isExistingExternalUser();
                if ((userList != null) && (userList.size() > 0) ) {
                    addId = userList[0].Id;
                } else {
                    addId = null;
                }

                uw_Bet_Team_Member__c tm = new uw_Bet_Team_Member__c();
                tm.Role__c = ExternalRole;
                tm.BET__c = betId;
                tm.Team_Member__c = addId;
                tm.BETEnabled__c = false;
                tm.Access_Level__c  = ExternalAccessLevel; 
                tm.Invite_Pending__c = isPending;

                if (isPending) {
                    tm.email__c = setEmailAdd;
                }

                Savepoint sp = Database.setSavepoint();
                try {
                    insert tm;
                }catch (Exception e) {Database.rollback(sp);return;}
                if (handAddToCollaborationGroup) {
                    List<uw_BET_Team_Member__c> betMemberList = [SELECT Id, Name, Role__c, Team_Member__c, BET__c, BET__r.Studio_Chatter_Group__c FROM uw_BET_Team_Member__c WHERE Id = :tm.Id AND BET__c = :betId];
                    if ( betMemberList.size() == 0 ) {return; }

                    uw_BET_Team_Member__c betMember = betMemberList[0];

                    CollaborationGroupMember cgm =  createCollaborationGroupMemberRecord(betMember);
                    try {
                        insert cgm;
                    }
                    catch (Exception e) {apexpages.addMessage(new apexpages.Message(ApexPages.Severity.ERROR, 'Create External TeamMember CollaborationGroup Member Insert  Exception. ' + e.getMessage())); return; }

                    if (cgm != null){
                        inviteSent = 'Agency user '+setEmailAdd+' added to Studio';
                    }else {
                        inviteSent = 'Note: '+ setEmailAdd + ' is already a member';
                    }
                }  
            }
            setEmailAdd = '';
        }
    }
    
    /*****************************************************************************************
    Purpose: Support method to create an External BET user (Chatter only)
    Returns: void
    Throws [Exceptions]: [optional]
    ******************************************************************************************/ 
    /* Istvan version
    private void addExternalUser (String emailAddress) {
         Profile chatterExternalProfile = [SELECT Id FROM Profile WHERE Name='Chatter External User' LIMIT 1];
         List<User> userList = [SELECT Id,IsActive FROM User WHERE email=:emailAddress AND ProfileId=:chatterExternalProfile.Id AND isActive = true];
         if ( userList.size() == 0 ) {
            //Apexpages.Message m = new apexpages.Message(ApexPages.Severity.ERROR, 'There is no active Chatter user with this email address.'); 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There is no active Chatter user with this email address.')); 
            System.Debug('UserList is empty for External User');
            return;
         }
    
         User user = userList[0];
         uw_BET_Team_Member__c teamMember = new uw_BET_Team_Member__c();
         
         teamMember.BETEnabled__c = false;
         teamMember.Role__c = ExternalRole;
         teamMember.Access_Level__c = ExternalAccessLevel;
         teamMember.email__c = emailAddress;
         teamMember.BET__c = betId;
         teamMember.Team_Member__c = user.Id;
         
         if ( isUserExist(teamMember) ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'User already exists.')); 
            return;
         }
         
         Savepoint sp = Database.setSavepoint();
         try {
            insert teamMember;
         }
         catch (Exception e) {
            System.Debug('Create External TeamMember Insert Exception. ' + e.getMessage());
            Database.rollback(sp);
            return;
         }
         
         List<uw_BET_Team_Member__c> betMemberList = [SELECT Id, Name, Role__c, Team_Member__c, BET__c, BET__r.Studio_Chatter_Group__c FROM uw_BET_Team_Member__c WHERE Id = :teamMember.Id AND BET__c = :betId];
         if ( betMemberList.size() == 0 ) {
             System.Debug('Bet Member record not found: ' + recordId);
             return;
         }
         uw_BET_Team_Member__c betMember = betMemberList[0];
         //System.Debug('Create CollaborationGroupMember before: ' + betMember.Id);
         CollaborationGroupMember cgm =  createCollaborationGroupMemberRecord(betMember);
         //System.Debug('Create CollaborationGroupMember after: ' + betMember.Id);
         try {
            insert cgm;
         }
         catch (Exception e) {
            System.Debug('Create External TeamMember CollaborationGroup Member Insert  Exception. ' + e.getMessage());
            Database.rollback(sp);
            return;
         }
    }
    */
}