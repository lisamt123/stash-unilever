@isTest
private class BET_ManageMembersController_Test3 {      
    // New test methods for checking missing setup data and user privileges
    static testMethod void checkPrivilegesAndMissingData() {
        BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET('UT_BET', true);
        BET_ManageMembersSettings__c betMembersSettings = new BET_ManageMembersSettings__c();
        
        betMembersSettings.Name = 'BETManageMembersConfig';
        betMembersSettings.ManagerRole__c = 'Manager'; 
        betMembersSettings.MemberRole__c = 'Member';
        betMembersSettings.ExternalRole__c = 'External Agency User';
        betMembersSettings.ApprovedStatus__c = 'Approved';
        betMembersSettings.DeniedStatus__c = 'Denied';
        betMembersSettings.ToolkitAccessLevel__c = 'Toolkit Experience (Toolkit only)';
        betMembersSettings.ExternalAccessLevel__c = 'External View (Chatter group only)';
        betMembersSettings.InternalUserRecordType__c = 'InternalUserDummyValue';
        betMembersSettings.BET_Member_Object_Name__c = 'uw_BET_Team_Member__c';
        
        insert betMembersSettings;          
        PageReference pageRef = Page.BET_ManageMembers;
        //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('bet',betWrapper.BET.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(betWrapper.BET);
        //system.assert(sc != null);
        
        system.runAs(BET_TestingHelper.getDefaultNotMember()) {
            BET_ManageMembersController controller = new BET_ManageMembersController(sc);
            System.assertEquals(null, controller.BETTeamMember.recordTypeId);
            System.assertEquals(betWrapper.BET.Name, controller.getBetName());
            System.assertEquals(false, controller.hasModifyAccess);
            System.assertEquals(null, controller.approveRequest());
            System.assertEquals(null, controller.setRole());
            System.assertEquals(null, controller.denyRequest());
            System.assertEquals(null, controller.addMember());
            System.assertEquals(null, controller.deleteMember());            
        }

    }
    static testMethod void checkPrivileges() {
        BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET('UT_BET', true);
        User u = [SELECT Id FROM User WHERE Id =: Userinfo.getUserId() LIMIT 1];
        betWrapper.addUserAsMember(u, 'Manager');
        Id memberId = [SELECT id FROM uw_BET_Team_Member__c WHERE Team_Member__c =: u.Id LIMIT 1].Id;
        BET_ManageMembersSettings__c betMembersSettings = new BET_ManageMembersSettings__c();
        
        betMembersSettings.Name = 'BETManageMembersConfig';
        betMembersSettings.ManagerRole__c = 'Manager'; 
        betMembersSettings.MemberRole__c = 'Member';
        betMembersSettings.ExternalRole__c = 'External Agency User';
        betMembersSettings.ApprovedStatus__c = 'Approved';
        betMembersSettings.DeniedStatus__c = 'Denied';
        betMembersSettings.ToolkitAccessLevel__c = 'Toolkit Experience (Toolkit only)';
        betMembersSettings.ExternalAccessLevel__c = 'External View (Chatter group only)';
        betMembersSettings.InternalUserRecordType__c = 'InternalUser';
        betMembersSettings.BET_Member_Object_Name__c = 'uw_BET_Team_Member__c';
        
        insert betMembersSettings;          
        PageReference pageRef = Page.BET_ManageMembers;
        //PageReference pageRef = new PageReference('/apex/BET_ManageMembers');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('bet',betWrapper.BET.Id);
        Apexpages.currentPage().getParameters().put('memberId', memberId);
        Apexpages.currentPage().getParameters().put('role', 'Member');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(betWrapper.BET);
        //system.assert(sc != null);
        
        system.runAs(u) {
            BET_ManageMembersController controller = new BET_ManageMembersController(sc);
            System.assertEquals(null, controller.setRole());
            System.assertEquals(true, controller.myPrivilegesChanged);            
        }

    }
}