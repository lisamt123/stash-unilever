/**
    Class for accessing Account objects for BFM Project regardless of sharing rules
*/
public without sharing class PQN_AccountDAO {
    public static List<Account> getAccountsWithDcCountry(String DcCountry){
        if(DcCountry != null){
            return [SELECT Name,BillingCountry,PQN_Country__c  FROM Account WHERE PQN_Country__c =:DcCountry];
        } else {
            return new List<Account>();
        }
    }
}