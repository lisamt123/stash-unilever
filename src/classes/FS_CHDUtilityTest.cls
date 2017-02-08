/**********************************************************************
Purpose: Test class for FS_CHDUtility.
History :
VERSION           AUTHOR              DATE                         DETAIL Description
1.0              Accenture        2/December/2016                       Created
***********************************************************************/
@isTest
private class FS_CHDUtilityTest {
    private static testMethod void CHDTesttwo (){
        FS_UtilTestDataSetup testData=new FS_UtilTestDataSetup();
        User testUser=testData.createTestUser();        
        system.runAs(testUser){
            FS_CHD_GFCCode__c cust= new FS_CHD_GFCCode__c(Name='3380',Segment__c='Club, Cash & Carry');
            insert cust;
            RecordType rt=[select id,name from RecordType where SObjectType='Account'and Name='Operator'];
            List<Account> newacclist = new  List<Account>() ;
            Account acc2 = new Account();
            acc2 .name = 'FS Test Acc1';
            acc2 .RecordTypeId = rt.Id;
            acc2 .SubSegment__c='3380. Stores';
            newacclist.add(acc2 );
            insert newacclist;
            FS_Utility.getDefaults(newacclist );
        }
       
        FS_Utility.runOnceOppProduct();
        FS_Utility.runaccPlanOnce();
        FS_Utility.runObjOnce();
        FS_Utility.runOnceContractProduct();
       
        
        FS_Utility.runOnceOppProduct();
        FS_Utility.runaccPlanOnce();
        FS_Utility.runObjOnce();
        FS_Utility.runOnceContractProduct();
        
    }
}