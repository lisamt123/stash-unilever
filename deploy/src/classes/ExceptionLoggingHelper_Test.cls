/*****************************************************************************
 * @Description: Test class for ExceptionLoggingHelper
   @Author: Cognizant
   @Created Date:18/09/2015 
*/


@isTest
public class ExceptionLoggingHelper_Test {
     public static User platformUser;
     public static List<IPM_Project__c> projectList;
     public static List<IPM_Project__c> ipmProjectList = new List<IPM_Project__c>();
     
     /***********************************
    * @Description: Test Data Creation
    * *********************************/

    @testSetup static void projectSetUp() 
    {
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        Set<Id> companyCardId = new Set<Id>();        
        for(IPM_Company_Card__c temp : companyCardList){
            companyCardId.add(temp.Id);
        }
        List<IPM_Company_Card__c> ipmCompanyCardList = [Select id from IPM_Company_Card__c where id in : companyCardId]; 
        system.assertEquals(ipmCompanyCardList.size(), 3, 'Company card not created properly.');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{platformUser});
          
        System.runAs(platformUser)
        {
        	projectList = IPM_TestFactory_Helper.projectSetUp(1,platformUser);	
            insert projectList;
        }
          
        Set<Id> projectIdList = new Set<Id>();        
        for(IPM_project__c temp : projectList){
            projectIdList.add(temp.Id);
        }        
        ipmProjectList = [Select id from IPM_Project__c where id in : projectIdList];  
        system.assertEquals(ipmProjectList.size(),1,'Projects are not created');
    }
    
     static void initializeData(){ 
     	Set<String> projectNameSet = new Set<String>{'TestComments1'};
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];  
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser});
        System.runAs(globalUser)
        {  
	     	IPM_Project__c ipmProjectToUpdate= [Select Id, Name from IPM_Project__c where Name in:projectNameSet];
	        ipmProjectToUpdate.Name = 'Updated IPM Project';
	        update ipmProjectToUpdate;
	        IPM_Project__c testProject = [Select id, name from IPM_Project__c where id = : ipmProjectToUpdate.Id];
	        system.assert(testProject.Name == 'Updated IPM Project', 'IPM project not updated properly');
	        
	        delete ipmProjectToUpdate;
	        List<IPM_Project__c> ipmProjectToDelete= [Select Id, Name, isDeleted from IPM_Project__c where Id=: ipmProjectToUpdate.Id ];
	        system.assertEquals(ipmProjectToDelete.size(), 0,  'IPM project not deleted properly');
	        
	        undelete ipmProjectToUpdate;
	        system.assert(ipmProjectToUpdate.Id != null, 'IPM project not undeleted properly');
        }
    }
    
    static void initializeData1(){
        Set<String> projectNameSet = new Set<String>{'TestComments1'};
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser});  
        System.runAs(globalUser)
        {
	        IPM_Project__c ipmProjectToUpdate= [Select Id, Name from IPM_Project__c where Name in:projectNameSet];
	        ipmProjectToUpdate.Name = 'Updated IPM Project';
	        update ipmProjectToUpdate;
	        IPM_Project__c testProject = [Select id, name from IPM_Project__c where id = : ipmProjectToUpdate.Id];
	        system.assert(testProject.Name == 'Updated IPM Project', 'IPM project not updated properly');
	        
	        delete ipmProjectToUpdate;
	        List<IPM_Project__c> ipmProjectToDelete= [Select Id, Name, isDeleted from IPM_Project__c where Id=: ipmProjectToUpdate.Id ];
	        system.assertEquals(ipmProjectToDelete.size(), 0,  'IPM project not deleted properly');
	        
	        //creating exception
	        delete ipmProjectToUpdate;
	        system.assert(ipmProjectToUpdate.id == null, 'IPM project not deleted properly');
        }
        
    }
    
    static testmethod void testinitializeExceptionLog(){
        test.startTest();
        initializeData();
        test.stopTest();
    }
    
    static testmethod void testcreateErrorLog(){
        try{
            test.startTest();
            initializeData1();
            test.stopTest();
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'ExceptionLoggingHelper_Test', 'testCreateErrorLog', 
            ex.getMessage(), ex, IPM_ConstantUtils.ERROR, null, null, null, null);
            //system.assert(ExceptionLoggingHelper.exceptionlogList.size() > 0, 'Exception not created successfully');
        }
    }
    
    
}