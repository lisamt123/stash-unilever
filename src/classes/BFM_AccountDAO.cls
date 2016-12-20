/**
    Class for accessing Account objects for BFM Project regardless of sharing rules
*/
public without sharing class BFM_AccountDAO {
    public static List<Account> getAccountsWithCNPJPrefix(String masterCNPJ){
        if(masterCNPJ != null){
            String cnpjPrefix = masterCNPJ.substring(0,8) + '%';
            return [SELECT CNPJ__c, Name 

                                    FROM Account 
                                    WHERE RecordType.DeveloperName = 'BFM_Carrier' 
                                        AND CNPJ__c LIKE :cnpjPrefix];
        } else {
            return new List<Account>();
        }
    }
}