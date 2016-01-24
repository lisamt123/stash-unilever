/**********************************************************************
Name:  CEC_AnonymiseConsumerHelper
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: An helper class to anonymise consumer data when retention date
is reached 
========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        Masood Ansari     Dec-2015      INITIAL DEVELOPMENT   

***********************************************************************/
public with sharing class CEC_AnonymiseConsumerHelper{
    //method to update account details
    public void updateAccountInformation(List<Account> accountList){
        
        List<Account> accountToUpdateList = new List<Account>();
        for(Account accountObj : accountList){
            accountObj.Salutation = null;
            accountObj.FirstName = null;
            accountObj.LastName = String.valueOf(accountObj.ID);
            accountObj.PersonEmail = null;
            accountObj.Phone = null;
            accountObj.PersonOtherPhone = null;
            accountObj.PersonMobilePhone = null;
            accountObj.PersonHomePhone = null;
            accountObj.BillingStreet = null;
            accountObj.PersonMailingStreet = null;
            accountObj.ShippingStreet = null;
            accountObj.Date_Anonymized__c = System.now();
            accountObj.Anonymise_check__c = false;
            accountToUpdateList.add(accountObj);
            System.debug('*****Account '+accountToUpdateList);
        }
        update accountToUpdateList;
        
    }
    
}