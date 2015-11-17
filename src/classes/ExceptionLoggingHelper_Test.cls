/*****************************************************************************
 * @Description: Test class for ExceptionLoggingHelper
   @Author: Cognizant
   @Created Date:18/09/2015 
*/


@isTest
public class ExceptionLoggingHelper_Test {
     static void initializeData(){   
     	IPM_Project__c ipmProject = IPM_TestFactory_Helper.createIPMProject(true);
        IPM_Project__c testPro = [Select id, name from IPM_Project__c where id = : ipmProject.Id];
        system.assert(testPro.Name == 'TestComments', 'IPM project not created properly');
        
        IPM_Project__c ipmProjectToUpdate= [Select Id, Name from IPM_Project__c where Id=: ipmProject.Id];
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
    
    static void initializeData1(){
        IPM_Project__c ipmProject = IPM_TestFactory_Helper.createIPMProject(true);
        IPM_Project__c testPro = [Select id, name from IPM_Project__c where id = : ipmProject.Id];
        system.assert(testPro.Name == 'TestComments', 'IPM project not created properly');
        
        IPM_Project__c ipmProjectToUpdate= [Select Id, Name from IPM_Project__c where Id=: ipmProject.Id];
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