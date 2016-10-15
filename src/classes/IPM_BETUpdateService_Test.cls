/**
    @Description: Test IPM_BETUpdateService
    @Author: Cognizant Technology
    @Date: 7/7/2015
**/

@isTest
private class IPM_BETUpdateService_Test{
     
     static uw_BET__c bet;
     
     static IPM_Project__c project;
     
     static List<IPM_BET_Valid_Categories__c> betvalidCategories ;
     
     static User runningUser=IPM_TestFactory_Helper.createUser(false); 
     
     static final   string CAT_NAME ='Household Care' ;

    /*Contains all common data for BET testing*/
    static void betDataInitializer(){
    
    		
        	bet = BET_TestUtils.getTestBet();
        
        	insert bet; 
        
        	system.assertEquals(1 , [Select count() from uw_BET__c where Id=:bet.Id ],'Failed to insert BET record.');
        
        	project = IPM_TestFactory_Helper.createOriginalProjectList(true,1)[0];
        
        	betvalidCategories = new List<IPM_BET_Valid_Categories__c>();
        
        	betvalidCategories.add(new IPM_BET_Valid_Categories__c(Name = CAT_NAME ));
        
        	insert betvalidCategories;
        
        	system.assertEquals(1 , [Select count() from IPM_BET_Valid_Categories__c where Name =: CAT_NAME ] , 'Failed to insert category  records.');      
        
        	MDO_Category__c category = IPM_TestFactory_Helper.createMDOCategory(false);
        
        	category.Name = 'Household Care';
        
        	insert category;
        
        	system.assertEquals(1 , [Select count() from MDO_Category__c where Id =: category.Id ] , 'Failed to insert MDO category  records.');      
    
   	
    }
    
    /*Test method to test Return IPM method*/    
    static testmethod void testReturnIPM(){
        System.runAs(runningUser){
            betDataInitializer();
            project.bet__c = bet.id;
            update project;
            
            system.assertEquals(bet.id , [Select bet__c  from IPM_Project__c  where Id =: project.Id ].bet__c , ' Failed to update BET on project. ');      
            
            Test.startTest();
            List< IPM_BETWrapper > wrapperList = IPM_BETUpdateService.returnIPM(bet.id);
            Test.stopTest();
            
            system.assertEquals(project.Id,wrapperList[0].projectId,'Wrapper list with the specified project not created.');
            
        }
    }
    
    /*Test method to test Return IPM method when id is null*/    
    static testmethod void testReturnIPMNegative(){
        System.runAs(runningUser){
            try
            {
            	Test.StartTest();
                IPM_BETUpdateService.returnIPM(null);
                Test.StopTest();
            }
            catch(Exception e)
            {
                Boolean expectedExceptionThrown =  e.getMessage().contains(System.label.IPM_BETIdNullMsg) ? true : false;
                System.AssertEquals(expectedExceptionThrown, true,'BET id null message not thrown');
            } 
        }
    }
    
    /*Test method to test check cateogry method*/ 
    static testmethod void testcategoryCheck(){
        insert runningUser;
        
        system.assertEquals(1 , [Select count()  from User  where Id =: runningUser.Id ] , ' Failed to create user record ');      
        
        Id IPMNGBasicId = [Select Id from PermissionSet where name = 'IPMNG_Basic'].Id;
        Id IPMProjectLeaderId = [Select Id from PermissionSet where name = 'IPM_ProjectLeader'].Id;
        PermissionSetAssignment psaIPMNG = new PermissionSetAssignment(PermissionSetId = IPMNGBasicId, AssigneeId = runningUser.Id);
        PermissionSetAssignment psaProjectLeader = new PermissionSetAssignment(PermissionSetId = IPMProjectLeaderId, AssigneeId = runningUser.Id);
        insert new List < PermissionSetAssignment > {
            psaIPMNG, psaProjectLeader
        };
        
        system.assertEquals(2 , [Select count()  from PermissionSetAssignment  where  AssigneeId =: runningUser.Id AND (PermissionSetId =: IPMProjectLeaderId  OR PermissionSetId =: IPMNGBasicId )] , ' Failed to assign permission sets');      
        
        System.runAs(runningUser){
            betDataInitializer();
            MDO_Category__c cat = [select id from MDO_Category__c where name = : project.IPM_Category_Text__c limit 1];
            Test.startTest();
            boolean isAvailable = IPM_BETUpdateService.categoryCheck(cat.id);
            Test.stopTest();
            
            system.assertEquals(true , isAvailable ,'Failed to set flag isAvailable .');

        } 
    }
    /*Test method to test check cateogry method when category is null*/ 
    static testmethod void testcategoryCheckNegative(){
        System.runAs(runningUser){
            betDataInitializer();
            project.IPM_Category_Text__c = null;
            update project;
           
            system.assertEquals(project.IPM_Category_Text__c , [Select IPM_Category_Text__c  from IPM_Project__c  where Id =: project.Id ].IPM_Category_Text__c , ' Failed to clear IPM_Category_Text__c on project. ');      
            
            try{
                Test.startTest();
                IPM_BETUpdateService.categoryCheck(project.IPM_Category_Text__c);
                Test.stopTest();
                
            }
            
            catch(Exception e){
            	
                Boolean expectedExceptionThrown =  e.getMessage().contains(System.label.IPM_CategoryNameNotNull) ? true : false;
                
                system.AssertEquals(true, expectedExceptionThrown,'Expected exception not thrown.');
                
            }
        }
    }
    
    /*Test method to test userAccess method*/
    static testmethod void testuserAccess(){
        System.runAs(runningUser){
            betDataInitializer();
            project.bet__c = bet.id;
            project.IPM_Project_Leader__c=Userinfo.getUserId();
            update project;
            
            system.assertEquals(bet.id,[Select bet__c from IPM_Project__c where Id =:project.Id ].bet__c ,'Failed to update BET on project record');
            
            Test.startTest();
            Boolean hasAccess= IPM_BETUpdateService.userAccess(bet.id,project.id,project.IPM_Project_Leader__c);
            Test.stopTest();
            system.assertEquals(true,hasAccess,'Project leader does not have access');
        }
    }
    
    /*Test method to test user Access for Functional Team*/
    static testmethod void testUserAccessFunctionalTeam(){
    	
    	User usr = IPM_TestFactory_Helper.createUser(true);
    	
        System.runAs(runningUser){
            betDataInitializer();
            
            system.assertEquals(1,[Select count() from User  where Id =:usr.Id ],'Failed to create user record.');
            
            IPM_Project_Resource__c res = IPM_TestFactory_Helper.createIPMProjectResource(project.id,false);
            res.IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_BD;
            res.IPM_Project__c = project.Id;
            res.IPM_User__c = usr.id;
            insert res;
            
            system.assertEquals(1 , [Select count() from IPM_Project_Resource__c  where Id =:res.Id ],'Failed to create projectresource  record.');
            
            Test.startTest();
            Boolean hasAccess= IPM_BETUpdateService.userAccess(bet.id,project.id,usr.id);
            Test.stopTest();
           
            system.assertEquals(true,hasAccess,'Project resource does not have required  access.');
        }
    }
    
    /*Negative test for  userAccess method*/
    static testmethod void testuserAccessNegative(){
        System.runAs(runningUser){
            betDataInitializer();
            try{
                IPM_Project_Resource__c res = IPM_TestFactory_Helper.createIPMProjectResource(project.id,false);
                Test.startTest();
                IPM_BETUpdateService.userAccess(bet.id,project.id,res.id);
                Test.stopTest();
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains(System.label.IPM_IdsNotNullMsg) ? true : false;
                System.AssertEquals(true, expectedExceptionThrown,'None of the ids is Null');
            }
        }
    }
    
    /*Test method to test ipm_Wrapper method*/
    static testmethod void testipm_Wrapper(){ 
        System.runAs(runningUser){
            betDataInitializer();
            Test.startTest();
            IPM_BETWrapper wrapper = IPM_BETUpdateService.ipm_Wrapper(project.id);
            Test.stopTest();
            system.assertEquals(project.id,wrapper.projectId,'Wrapper record not created as expected');
        }
    }
    
    /*Negative test  for ipm_Wrapper method*/
    static testmethod void testipm_WrapperNegative(){
        System.runAs(runningUser){
            IPM_Project__c newProj = new IPM_PRoject__c();
            try{
                Test.startTest();
                IPM_BETUpdateService.ipm_Wrapper(newProj.id);
                Test.stopTest();
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains(System.label.IPM_ProjectNotRetrieved) ? true : false;
                
                System.AssertEquals(true, expectedExceptionThrown,' Failed to throw expected exception .');
                
            }
        }
    }
    
    /*Test method to test ipm_BETLinkingService on Approval */
    static testmethod void testipm_BETLinkingServiceApproval(){
        system.runAs(runningUser) {
            betDataInitializer();
            project.BET_Link_Requested__c = bet.id;
            project.BET_Link_Requested_on_Date__c = system.now();
            update project;
            
            system.AssertEquals(project.BET_Link_Requested__c, [Select BET_Link_Requested__c from IPM_Project__c where Id =:project.Id].BET_Link_Requested__c,' Failed to update requested BET link on project.');
            
            Test.startTest();
            IPM_BETUpdateService.ipm_BETLinkingService(project.id,bet.id,system.label.IPM_BET_Link_Approved);
            Test.stopTest();
            system.assertEquals([Select BET__c from  IPM_Project__c where id=:project.id].BET__c,project.BET_Link_Requested__c,'Failed to link Bet with  the project');
        }
    }
    
    /*Test method to test ipm_BETLinkingService on rejection */
    static testmethod void testipm_BETLinkingServiceRejection(){
        system.runAs(runningUser) {
            betDataInitializer();
            project.BET_Link_Requested__c = bet.id;
            project.BET_Link_Requested_on_Date__c = system.now();
            update project;
            
            system.AssertEquals(project.BET_Link_Requested__c, [Select BET_Link_Requested__c from IPM_Project__c where Id =:project.Id].BET_Link_Requested__c,' Failed to update requested BET link on project.');
            
            Test.startTest();
            IPM_BETUpdateService.ipm_BETLinkingService(project.id,bet.id,system.label.IPM_BET_Link_Rejected);
            Test.stopTest();
            
            system.assertEquals(null,[Select bet__c from IPM_Project__c where id=:project.id ].bet__c ,'BET should not get  updated on project.');
            
            system.assertEquals(false,[Select BET_Update__c  from IPM_Project__c where id=:project.id ].BET_Update__c,'Checkbox should not be  true.');
        
        }
    }
    
    /*Negative test for  ipm_BETLinkingService */
    static testMethod void testipm_BETLinkingServiceNegative(){
        system.runAs(runningUser) {
            betDataInitializer();
            try{
                Test.startTest();
                IPM_BETUpdateService.ipm_BETLinkingService(project.id,bet.id,null);
                Test.stopTest();
            }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains(System.label.IPM_IdsApprovalNotNullMSg) ? true : false;
                
                System.AssertEquals(true, expectedExceptionThrown,'Expected exception not thrown.');
                
            }
        }
    }
    
    
    /*Test method to test updateIPM method */
    static testMethod void testupdateIPM(){
        system.runAs(runningUser) {
            betDataInitializer();
            
            bet.Status__c =  'First release';
            update bet;
            
            System.AssertEquals( bet.Status__c, [Select Status__c from uw_BET__c where Id =: bet.Id ].Status__c , 'Expected exception not thrown.');
            
            project.BET_First_Release_Missed__c=true;
            project.bet__c=bet.id;
            update  project; 
            
            System.AssertEquals( project.bet__c, [Select bet__c from IPM_Project__c  where Id =: project.Id ].bet__c , ' Failed to update project with BET.');
            
            BET_BETWrapper wrapper = new BET_BETWrapper(bet);
            List<String> updatedFields = new List<String>();
            updatedFields.add('Status');
            Test.startTest();
            IPM_BETUpdateService.updateIPM(bet.id,wrapper,updatedFields,userInfo.getUserId());
            Test.stopTest();
            System.assertEquals([Select BET_First_Release_Missed__c from IPM_project__c where id = : project.Id].BET_First_Release_Missed__c, false, 'Failed to reset BET_First_Release_Missed__c');
        }
    }
    
    /*Test method to test updateIPM method */
    static testMethod void updateBETMemberRequest(){
        system.runAs(runningUser) {
            betDataInitializer();
            set<id> projIds =  new Set<id>();
            projIds.add(project.id);
            IPM_Project__c proj = project = IPM_TestFactory_Helper.createIPMProject(true);
            
            System.AssertEquals( 1, [Select count() from IPM_Project__c  where Id =: proj.Id ] , 'Failed to create project.');
           
            projIds.add(proj.id);
            Test.startTest();
            IPM_BETUpdateService.updateBETMemberRequest(projIds);
            Test.stopTest();
            system.assertEquals(true,[Select Bulk_BET_Member_Request__c from IPM_Project__c where Id=:project.Id].Bulk_BET_Member_Request__c,'Bulk update not performed');
        }
    }
    
    
    /*Test method to test updateBETLink method */
    static testMethod void testupdateBETLink(){
        system.runAs(runningUser) {
            betDataInitializer();
            Test.startTest();
            IPM_BETUpdateService.updateBETLink(project.id,bet.id);
            Test.stopTest();
            system.assertEquals(bet.id,[Select BET__c from IPM_Project__c where Id=:project.Id].BET__c,'BET not updated');
        }
    }
    
    /*Negative test for updateBETLink */
    static testMethod void testupdateBETLinkNegative(){
        system.runAs(runningUser) {
            betDataInitializer();
            try{
                Test.startTest();
                IPM_BETUpdateService.updateBETLink(project.id,null);
                Test.stopTest();
            }
            catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains(Label.IPM_IdsNotNullMsg) ? true : false;
                
                System.AssertEquals(true, expectedExceptionThrown,'Expected exception not thrown.');
                
            }
            
        }
    }
}