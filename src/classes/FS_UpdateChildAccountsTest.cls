@isTest(SeeAllData=false)
private class FS_UpdateChildAccountsTest{
    private static testMethod void UpdateChildAccounts(){
    
     FS_UtilTestDataSetup testData=new FS_UtilTestDataSetup();
        User testUser=testData.createTestUser();
         system.runAs(testUser){
         
            Test.startTest();
            RecordType rt=[select id,name from RecordType where SObjectType='Account'and Name='Operator'];
            Account accVar = new Account();
            accVar.name = 'FS Test Acc1';
            accVar.RecordTypeId = rt.Id;
            accVar.FS_Distributor_Type__c='Strategic';
            accVar.FS_onInvoice__c=6.3;
            accVar.FS_offInvoice__c=4.2;
            accVar.FS_supplyCost__c=1.43;
            insert accVar;
            
            FS_UpdateChildAccounts.updateChildAccounts(accVar.id);
            
            Account accVarChild = new Account();
            accVarChild.name = 'FS Test Child Record';
            accVarChild.RecordTypeId = rt.Id;
            accVarChild.FS_onInvoice__c=9.3;
            accVarChild.FS_offInvoice__c=7.2;
            accVarChild.FS_supplyCost__c=2.43;
            accVarChild.ParentId=accVar.id;
            insert accVarChild;
            Test.StopTest();
            
            FS_UpdateChildAccounts.updateChildAccounts(accVar.id);
       }    
    }
 }