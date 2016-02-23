public class ListContactAccount {
@AuraEnabled
    public static List<Contact> getContacts(){
        
        return[SELECT Id,Name FROM Contact LIMIT 8];
        
    }
    @AuraEnabled
    public static List<Account> getAccounts(){
        
        return [SELECT Id,Name FROM Account LIMIT 8];
        
    }
}