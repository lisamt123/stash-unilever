@isTest
public with sharing class UL_AccountTestFactory {

public final static String NAME = 'TestClass_Testing';

    public static Account defaultAccount;
    public static Account buildAccount(Integer nameSuffix) {
        Account account = new Account();
        account.ACCL__City__c = 'Test City';
        account.ACCL__Street__c = 'Test Street';
        account.Name = NAME+nameSuffix; 
        account.ACCL__Name_2__c = 'testX'+nameSuffix;
        return account;
    }

    public static Account buildDefaultCallTemplate() {
        return buildAccount(-1);
    }

    public static Account insertAccount(Integer nameSuffix){
        Account account = buildAccount(nameSuffix);
        insert account;
        return account;
    }

    public static Account getDefaultAccount() {
        if( defaultAccount == null ){
            defaultAccount = insertAccount( -1 );
        }
        return defaultAccount;
    }
    
    public static List<Account> buildAccounts( Integer numberOfAccounts ) {
        List<Account> accounts = new List<Account>();
        for(Integer i=0 ; i < numberOfAccounts ; i++){
            accounts.add(buildAccount(i));
        }
        return accounts;
    }

    public static List<Account> insertCallTemplates( List<Account> accounts){
        insert accounts;
        return accounts;
    }
    //Creating New method for Bulk Accpunt Insert
    public static List<Account> insertBulkAccounts( Integer numberOfAccounts) {
        List<Account> accList= buildAccounts(numberOfAccounts);
        insert accList;
        return accList;
    }
    public static List<Account> inserBulkAccountWithParentId(List<Account> accounts) {
        List<Account> accList = new List<Account>();
        for(Integer i=0; i< accounts.size(); i++){
            account acc =new account();
            acc.Name='Test Account with Parent';
            acc.ParentId=accounts[i].id;
            accList.add(acc);
        }
        return accList;
    }
    public static Account  getInsertedAccount(Id acID){
        defaultAccount = new Account();
        List<Account> acc= [Select a.ACCL__Name_2__c, a.Name, a.Id, a.Description, a.ACCL__Account_Number__c, a.AccountNumber 
                            From Account a where id = :acID limit 1 ];
        
        if (!acc.isEmpty()) {
            return acc[0];
        }
        return defaultAccount;
    }
    /*For covering Sales Org specific methods
       Author : avineesh.k.mishra
       created Date: 16-Aug-2016
    */
    public static Account getAccountWithSalesOrg(ACCL__Account_Template__c accTemp,Integer nameSuffix ) {
        Account account = new Account();
        account.ACCL__City__c = 'Test City';
        account.ACCL__Street__c = 'Test Street';
        account.Name = NAME+nameSuffix; 
        account.ACCL__Name_2__c = 'testX'+nameSuffix;
        account.ACCL__Account_Template__c = accTemp.Id;
        insert Account;
        return account;  
    }  
    
}