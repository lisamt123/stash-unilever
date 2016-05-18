/**********************************************************************
Purpose: Helper class for AccountTrigger.
History :
VERSION AUTHOR         DATE          DETAIL Description
1.0     Accenture    11/May/2016     Created for accountInsert 
***********************************************************************/

public with sharing class NAFS_AccountHelper {
    
    //Purpose: To Populate Zone,Region,Territory and account Number Fields On account object for Operator
    public static void insertAccount(List<account> listNewTrigger,boolean isAfter,boolean isBefore)
    { 
       if(isBefore){ 
            Set<Id> ownerIds = new Set<Id>();
            Map<Id, List<Account>> ownersAccounts = new Map<Id, List<Account>>();
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId(); 
            List<Account> listOfNewAccounts = new List<Account>();  
            for(Account newAccount : listNewTrigger){
                    ownerIds.add(newAccount.OwnerId);
                    if(ownersAccounts.containsKey(newAccount.OwnerId)){
                        listOfNewAccounts = ownersAccounts.get(newAccount.OwnerId);
                    }    
                    listOfNewAccounts.add(newAccount);
                    ownersAccounts.put(newAccount.OwnerId, listOfNewAccounts);
            }
            
            //For getting account owner user infomation Zone,territory,Zone
            List<User> listUser= [SELECT Id, NFS_Region__c,NFS_Territory__c,NFS_Zone__c FROM User WHERE Id IN :ownerIds];
            for(User userInfo : listUser){
                if(userInfo!=null){
                        for(Account userAccount : ownersAccounts.get(userInfo.id)){
                            System.debug('currentaccountrecordtypeis=='+accountRecordTypeId);
                            if(userAccount.RecordTypeid==accountRecordTypeId && userAccount.RecordTypeid!=null){
                                userAccount.NFS_Region__c = userInfo.NFS_Region__c;
                                userAccount.NFS_Territory__c = userInfo.NFS_Territory__c;
                                userAccount.NFS_Zone__c = userInfo.NFS_Zone__c;
                            }
                        }
                }
            }
       }
       //Purpose: updated AccountNumber with GFS_Customer_Number__c
       if(isAfter){
           List<account> newAccountList = new List<Account>();
             for(Account newAccounts:listNewTrigger){
                // Condition for the Account Number to be populated
                if(newAccounts.Type=='Operator'){
                   Account instAccount = new Account();
                   instAccount.id=newAccounts.id;
                   instAccount.AccountNumber = 'ACC-OP-' + newAccounts.GFS_Customer_Number__c;
                   newAccountList .add(instAccount);
                }
             }
             try{
                 if(!newAccountList.isEmpty()){
                     update newAccountList ;
                 }
             }
             Catch(DmlException e){
                 System.debug( 'The following exception has occurred: '+e.getMessage() );
                 ExceptionLoggingHelper.createErrorLog(userInfo.getUserId(), 'NAFS_AccountHelper', 'insertAccount', e.getMessage(), e, '', '', '', 0,'Food Solution');
             }
        }
   }//Method end
}