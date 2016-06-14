/***************************************************************
Class Name: CORE_Feedback_App_Controller_Test.cls
Copyright © 2016 Salesforce

Purpose:
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test class For CORE Feedback app controller.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       25/04/2016        Test class For CORE Feedback app controller
***************************************************************/

@isTest
public with sharing class CORE_Feedback_App_Controller_Test {
    @isTest 
    public static void findFeedbacksTest(){
        String appName1 = 'abc1';
        CORE_Feedback__c newObj1=new CORE_Feedback__c ( App_Name__c=appName1,Feedback_Date__c=System.today(),Rate_Later_Date__c=System.today(),User__c=userinfo.getUserid());
        insert newObj1;
    
        App_Feedback__c appFeedback1 =  new App_Feedback__c ( Name='abc1',Feedback_Again_Days__c= 90, Rate_Later_Days__c=60,Feedback_PopUp_Message__c='Popup message' );
        insert appFeedback1;
        
        String appName2 = 'abc2';
        CORE_Feedback__c newObj2=new CORE_Feedback__c ( App_Name__c=appName2,Feedback_Date__c=System.today(),Rate_Later_Date__c=System.today(),User__c=userinfo.getUserid());
        insert newObj2;

        CORE_Feedback__c newObj3=new CORE_Feedback__c ( App_Name__c=appName2,Feedback_Date__c=System.today(),Rate_Later_Date__c=System.today(),User__c=userinfo.getUserid());
        insert newObj3;
        
        App_Feedback__c appFeedback2 =  new App_Feedback__c ( Name='abc2',Feedback_Again_Days__c= 90, Rate_Later_Days__c=60,Feedback_PopUp_Message__c='Popup message' );
        insert appFeedback2;
        
        String appName3 = 'abc3';
        CORE_Feedback__c newObj4=new CORE_Feedback__c ( App_Name__c=appName3,Feedback_Date__c=System.today(),Rate_Later_Date__c=System.today()+1,User__c=userinfo.getUserid());
        insert newObj4;
        CORE_Feedback__c newObj5=new CORE_Feedback__c ( App_Name__c=appName3,Feedback_Date__c=System.today(),Rate_Later_Date__c=System.today(),User__c=userinfo.getUserid());
        insert newObj5;
            
        App_Feedback__c appFeedback3 =  new App_Feedback__c ( Name='abc3',Feedback_Again_Days__c= 90, Rate_Later_Days__c=60,Feedback_PopUp_Message__c='Popup message' );
        insert appFeedback3;
        
        Test.startTest();
        boolean app1 = CORE_Feedback_App_Controller.findFeedbacks('abc1');
        System.assertEquals(app1,true);
        
        boolean app2 = CORE_Feedback_App_Controller.findFeedbacks('abc2');
        System.assertEquals(app2,true);
        
        boolean app3 = CORE_Feedback_App_Controller.findFeedbacks('abc3');
        System.assertEquals(app3,false);
        
        boolean app4 = CORE_Feedback_App_Controller.findFeedbacks('abc4');
        System.assertEquals(app4,false);
        
        Test.stopTest();
    }
    
    @isTest 
    public static void insertFeedbackTest(){
        String appName1 = 'abc1';
        Integer rating1 = 4;
        String comment1= 'C1';
        App_Feedback__c appFeedback1 =  new App_Feedback__c ( Name='abc1',Feedback_Again_Days__c= 90, Rate_Later_Days__c=60,Feedback_PopUp_Message__c='Popup message' );
        insert appFeedback1;
        
        String appName2 = 'abc2';
        Integer rating2 = 0;
        String comment2= 'C2';
        App_Feedback__c appFeedback2 =  new App_Feedback__c ( Name='abc2',Feedback_Again_Days__c= 90, Rate_Later_Days__c=60,Feedback_PopUp_Message__c='Popup message' );
        insert appFeedback2;

        Test.startTest();
        
        boolean flag1= CORE_Feedback_App_Controller.insertFeedback('abc1',rating1,comment1);
        System.assertEquals(flag1,true);
        
        boolean flag2= CORE_Feedback_App_Controller.insertFeedback('abc2',rating2,comment2);
        System.assertEquals(flag2,true);
         
        Test.stopTest();    
    }
    
}