/**
 * Name:        -   CTT_PostRefreshUserSetup
 * @description -   This class is for creating admin users in sandbox after refresh.
 * @Author      -   Prafull Choudhary    
 */
global class CTT_PostRefreshUserSetup implements SandboxPostCopy {
  
  global void runApexClass(SandboxContext context) {
      
      list<User> usersToCreate = new list<User>();
      //Query admin profile
      Profile admin = [Select Id 
                       FROM Profile
                       WHERE Name = 'System Administrator'];
                       
      //Its better to query custom setting than loop through 100s of records
      for(CTT_User_Setup_Details__c detail : [SELECT id, Sandbox_Name__c, First_Name__c, Last_Name__c, Email__c 
                                           FROM CTT_User_Setup_Details__c 
                                           WHERE Sandbox_Name__c =: context.sandboxName()
                                          ]){
          // Populate alias
          String alias = detail.Last_Name__c.length() >2 ? detail.Last_Name__c.substring(0,2) : detail.Last_Name__c;
          alias = detail.First_Name__c.substring(0,1) + alias;
          
          //Populate user record                              
          usersToCreate.add(new user(ProfileId         = admin.Id,
                                     FirstName         = detail.First_Name__c,
                                     LastName          = detail.Last_Name__c,
                                     Email             = detail.Email__c,
                                     alias             = alias,
                                     Username          = detail.Email__c + '.' + context.sandboxName() + 'adm',
                                     timezonesidkey    ='Europe/London',
                                     languagelocalekey ='en_US',
                                     localesidkey      ='en_GB',
                                     emailencodingkey  ='UTF-8'
                                     
                                    ));                                   
      }                                   
      
      //Create Users
      if(usersToCreate.size() > 0){
          insert usersToCreate;
      }
      
        
      
  }
}