@isTest
public class DMS_Account_Test {

    private static testMethod void testTrigger(){
        Account account = DMS_SObjectInstance_Test.createAccount('ALTAMIRA',DMS_GlobalConstants.ACCOUNT_EXTERNAL_CODE, null, null, '01219000000CiAT', UserInfo.getUserId(),null, true);
        account.Name = 'Teste';
        
        database.update(account);
    }
}