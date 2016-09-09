@isTest(SeeAllData = false)
public class IPM_BETSuggestedMembersController_Test {
    
    Static User runningUser;

    Static void initialSetup() {
        test.loadData(IPM_Project_Type__c.sobjectType, 'IPM_ProjectType');
        
        runningUser = IPM_TestFactory_Helper.createUser(true);
        User AdminUser = IPM_TestFactory_Helper.createUserAdmin(true);
        
        //to avoid mix dml error  ,we are assigning permission  set  using admin user 
        system.runAs(AdminUser) {
            Id IPMNGBasicId = [Select Id from PermissionSet where name = 'IPMNG_Basic'].Id;
            Id IPMProjectLeaderId = [Select Id from PermissionSet where name = 'IPM_ProjectLeader'].Id;
            PermissionSetAssignment psaIPMNG = new PermissionSetAssignment(PermissionSetId = IPMNGBasicId, AssigneeId = runningUser.Id);
            PermissionSetAssignment psaProjectLeader = new PermissionSetAssignment(PermissionSetId = IPMProjectLeaderId, AssigneeId = runningUser.Id);
            insert new List < PermissionSetAssignment > {
                psaIPMNG, psaProjectLeader
            };
        }
    }
    
    //test Method to  test updation of  bet on project
    static testMethod void testupdateBETonProject() {
        initialSetup();
        
        system.runAs(runningUser) {
            uw_bet__c bet = BET_TestUtils.getTestBet();
            insert bet;
            IPM_Project__c ipmProject = (IPM_TestFactory_Helper.createOriginalProjectList(true, 1))[0];
            
            Test.startTest();
             ipmproject.ipm_phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
             update ipmProject;
             PageReference pRef1 = new PageReference('/apex/IPM_BETSuggestedMembers?id=' + ipmProject.id + '&showMembers=true&BETId=' + Bet.id);
             ApexPages.currentPage().getParameters().put('BETId', Bet.id);
             ApexPages.currentPage().getParameters().put('id', ipmProject.id);
             Test.setCurrentPage(pRef1);
             IPM_BETSuggestedMembersController cont = new IPM_BETSuggestedMembersController();
             cont.updateBETonProject();
            Test.stopTest();
            
            system.assertEquals(bet.id, [select bet__c from IPM_Project__c where id = : ipmproject.id].bet__c, 'BET not updated on project');
        }
    }
    
     //test Method to  test updation of  BET on project through IPM_UpdateBETOnProject_Queueable class
    static testMethod void testAsyncUpdateBETonProject() {
        initialSetup();
        
        system.runAs(runningUser) {
            uw_bet__c bet = BET_TestUtils.getTestBet();
            insert bet;
            
            System.assertEquals(1 , [Select count()  from uw_bet__c where Id =:bet.Id] ,'Failed to create a BET record.');
            
            IPM_Project__c ipmProject = (IPM_TestFactory_Helper.createOriginalProjectList(true, 1))[0];
            
            System.assertEquals(1 , [Select count()  from IPM_Project__c where Id =:ipmProject.Id] ,'Failed to create a project record.');
            
            
             ipmproject.ipm_phase__c = IPM_ConstantUtils.PHASE_IDEAS;
             
             ipmproject.name ='ANZ2'; 
             
             update ipmProject; 
             
             System.assertEquals(ipmproject.name  , [Select name  from IPM_Project__c where Id =:ipmProject.Id].name ,'Failed to update the project phase.');
             
             IPM_UpdateBETOnProject_Queueable updateBETOnProjectQ = new IPM_UpdateBETOnProject_Queueable(); 
             updateBETOnProjectQ.betId =bet.id;
             updateBETOnProjectQ.projectId =ipmproject.id; 
             Test.startTest();
             System.enqueueJob(updateBETOnProjectQ);
             Test.stopTest();
            
            system.assertEquals(bet.id, [select bet__c from IPM_Project__c where id = : ipmproject.id].bet__c, 'The BET not updated on the project');
        }
    }

    // Negative test to check for the error message
    static testmethod void testupdateBETonProjectNegative() {
        initialSetup();
        system.runAs(runningUser) {
            Test.startTest();
            
            try {
                IPM_Project__c ipmProject = (IPM_TestFactory_Helper.createOriginalProjectList(true, 1))[0];
                PageReference pRef1 = new PageReference('/apex/IPM_BETSuggestedMembers?id=' + ipmProject.id + '&showMembers=true&BETId=' + null);
                ApexPages.currentPage().getParameters().put('BETId', 'InvalidId');
                ApexPages.currentPage().getParameters().put('id', ipmProject.id);
                Test.setCurrentPage(pRef1);
                IPM_BETSuggestedMembersController cont = new IPM_BETSuggestedMembersController();
                cont.updateBETonProject();
            } catch (Exception e) {
                Boolean expectedExceptionThrown = e.getMessage().contains(System.Label.IPM_BET_BETUpdate_failure_ErrMsg) ? true : false;
                System.AssertEquals(expectedExceptionThrown, true, 'Intended custom error message not thrown');
            }
            
            Test.stopTest();
        }
    }

}