@isTest
private class test_userFeedbackCTRL {
    
    
    @testSetup 
    static void setup() {
        
        //set up prefix mapping
        
        Global_Object_Ownership__c GOO = new Global_Object_Ownership__c(Name='UID', Project__c='Unilever International', Enterprise_Architect__c=userinfo.getUserEmail());
        insert goo;
        
         // Create common test accounts
        List<CEC_BRAND_LOGO__C> performance = new List<CEC_BRAND_LOGO__C>();
        for(Integer i=0;i<2;i++) {
            performance.add(new CEC_BRAND_LOGO__C());
        }
        insert performance;
            
        // Create common test accounts
        List<UID_Stocked_Product__c> stockedProducts = new List<UID_Stocked_Product__c>();
        for(Integer i=0;i<2;i++) {
            stockedProducts.add(new UID_Stocked_Product__c());
        }
        insert stockedProducts;
        
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<2;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i));
        }
        insert testAccts;
    }

    
	
    static testMethod void testUserInfo() {
    	
        User currUser = userFeedbackCTRL.getUserInfo(userinfo.getUserId());
        
        system.assertEquals(currUser.name, userinfo.getName());
        
        
    }
    
    static testMethod void testCreatingFeedbackOnProjectStandardObject() {
    	//make sure 0 user works
        list<User_Feedback__c> feedback = userFeedbackCTRL.history(userinfo.getUserId());
        
        system.assertEquals(feedback.size(), 0);
        
        //without EA
        
        Account testAcct = [select id from Account LIMIT 1];
        
        User_Feedback__c UF = new User_Feedback__c();
        UF.Record_Id__c = testAcct.Id;
        UF.Type__c = 'Idea';
        UF.Goal__c = 'Keep Winning';
        UF.Feedback__c = 'This is a great feature';
        
        
        userFeedbackCTRL.insertFeedback(UF);
        
        feedback = userFeedbackCTRL.history(userinfo.getUserId());
        
        system.assertEquals(feedback.size(), 1);
        
        system.assertEquals(feedback[0].Enterprise_Architect__c, null);
        
        
       
        
    }
    
    static testMethod void testCreatingFeedbackOnProjectCustomObject() {
    	//make sure 0 user works
        list<User_Feedback__c> feedback = userFeedbackCTRL.history(userinfo.getUserId());
        
        system.assertEquals(feedback.size(), 0);
        
        //with EA
        UID_Stocked_Product__c stockedProducts = [select id from UID_Stocked_Product__c LIMIT 1];
        
        User_Feedback__c UF2 = new User_Feedback__c();
        UF2.Record_Id__c = stockedProducts.Id;
        UF2.Type__c = 'Idea';
        UF2.Goal__c = 'Keep Winning';
        UF2.Feedback__c = 'This is a great feature';
        
        
        userFeedbackCTRL.insertFeedback(UF2);
        
        feedback = userFeedbackCTRL.history(userinfo.getUserId());
        
        system.assertEquals(feedback.size(), 1);
        
        system.assertEquals(feedback[0].Enterprise_Architect__c, userinfo.getUserId());
        
        
    }
    
    static testMethod void testCreatingFeedbackOnUnknownCustomObject() {
    	//make sure 0 user works
        list<User_Feedback__c> feedback = userFeedbackCTRL.history(userinfo.getUserId());
        
        system.assertEquals(feedback.size(), 0);
        
        //with EA
        CEC_BRAND_LOGO__C stockedProducts = [select id from CEC_BRAND_LOGO__C LIMIT 1];
        
        User_Feedback__c UF2 = new User_Feedback__c();
        UF2.Record_Id__c = stockedProducts.Id;
        UF2.Type__c = 'Idea';
        UF2.Goal__c = 'Keep Winning';
        UF2.Feedback__c = 'This is a great feature';
        
        
        userFeedbackCTRL.insertFeedback(UF2);
        
        feedback = userFeedbackCTRL.history(userinfo.getUserId());
        
        system.assertEquals(feedback.size(), 1);
        
        system.assertEquals(feedback[0].Enterprise_Architect__c, null);
        
        
    }
    
   
    
}