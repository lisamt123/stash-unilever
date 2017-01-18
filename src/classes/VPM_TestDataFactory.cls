@isTest
public class VPM_TestDataFactory {

   public static user CreateUser(string Alias, string Email, string UserName, string Profile){
        
        Profile p = [SELECT Id FROM Profile WHERE Name =: Profile];
        User NewUser = new User(Alias = Alias, Email = Email,
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',     UserName = UserName);
        
        //Group gr = [Select Id From Group where DeveloperName='VPM_Procurement' AND Type='Queue' limit 1]; 
        
            
        return NewUser;
            
    }

      public static  VPM_CommodityApprover__c CreateCommodityApprover(id Approver1, id Approver2, string Country){
        
        VPM_CommodityApprover__c com = new VPM_CommodityApprover__c(
        VPM_Approver1__c = Approver1,
        VPM_Approver2__c = Approver2,
        VPM_Country__c=  Country
        );
        return com;
            
    }
    

}