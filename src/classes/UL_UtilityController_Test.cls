@isTest(SeeAllData=false)
private class UL_UtilityController_Test{

    @testSetup
    private static void userData(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        //Create user
        User u = new User(Alias = 'standt', 
                          Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing', 
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', 
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', 
                          UserName='standarduserUKSO@testorg.com',
                          ACCL__Sales_Org__c ='UK SO');
      insert u;
    }
    
   //Test method while landing into the page
    @isTest
    private static void checkUserSalesOrgPositive(){    
        user u =[Select Id, Name,ACCL__Sales_Org__c from User where Email ='standarduser@testorg.com' limit 1];        
        String salesorg = null;
        System.runAs(u){  
            salesorg = UL_UtilityController.usersSalesOrg();
        }
        system.assertequals('UK SO',salesorg);
    }
   /* @isTest
    private static void checkUserSalesOrgNegative(){
       user u =[Select Id, Name,ACCL__Sales_Org__c from User where Email ='standarduser@testorg.com' limit 1];  
            u.ACCL__Sales_Org__c = 'AR01';     
       update u;
        String salesorg = null;
        System.runAs(u){  
            salesorg = UL_UtilityController.usersSalesOrg();
        }
        system.assertNotEquals('UK SO',salesorg);
       }
    */
}