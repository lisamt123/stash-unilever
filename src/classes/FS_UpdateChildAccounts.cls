/**********************************************************************
Purpose: Class used to update child accounts.
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    17/Jan/2017     Draft (FS-1590)
***********************************************************************/

Global class FS_UpdateChildAccounts {

  
    //(label='Update Child Accounts' description='')
   // @InvocableMethod(label='Update Child Accounts' description='Update Child Accounts')
  //  webservice static String updateChildAccounts(String accountID,Decimal FS_onInvoice,Decimal FS_offInvoice,Decimal FS_supplyCost) {
      
    webservice static String updateChildAccounts(String accountID) {
      
     
      Account accountParent=[select id,
                                        name,
                                        FS_Distributor_Type__c,
                                        FS_onInvoice__c,
                                        FS_offInvoice__c,
                                        FS_supplyCost__c                                  
                                 from account 
                                 where Id =:accountID];
                                 
      List<Account> accountList=[select id,
                                        name,
                                        FS_Distributor_Type__c,
                                        FS_onInvoice__c,
                                        FS_offInvoice__c,
                                        FS_supplyCost__c                                  
                                 from account 
                                 where ParentId =:accountID];
                                 //from account where FS_BuyingGroup__c =:accountID];
     
     if(accountList.size()>0)
     {
      
        for(Account varAccount:accountList)
        {
        //Condition to change the child
            varAccount.FS_offInvoice__c =accountParent.FS_offInvoice__c;
            varAccount.FS_onInvoice__c = accountParent.FS_onInvoice__c;  
            varAccount.FS_supplyCost__c = accountParent.FS_supplyCost__c;
        }
         
        try
        {
            update accountList;
            return 'Child Accounts updated successfully';
        }
        catch(Exception e)
        {
            return 'Some problem in updating account '+ e;
        }
         
     }
     else
     {
        return 'No child accounts for this account';
      }
      return 'Some problem in updating account';
    }
}