/***************************************************************
Class Name: CORE_Feedback_App_Controller.cls
Copyright © 2016 Salesforce

Purpose:
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Controller class For Feedback app.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       25/04/2016        controller class For Feedback app
***************************************************************/


public with sharing class CORE_Feedback_App_Controller{
  /*******************************************************************************************************
* @description This method returns whether the user has visited this app before or not.
* @param  appName
* @return string 
*/ 
  @AuraEnabled
   public static boolean findFeedbacks(String appName) {
       List<CORE_Feedback__c> feedbackList=[SELECT Id, Rate_Later_Date__c,Feedback_Date__c FROM CORE_Feedback__c WHERE User__c =:userinfo.getUserid() AND App_Name__c =:appName order by createddate  desc];
       
       if(feedbackList.size() ==1 )
        {
          return true;
        }
        else if(feedbackList.size() >= 2 && system.today() >=feedbackList[0].Rate_Later_Date__c )
        { 
          
          return true;
          
        }
        else if(feedbackList.size() >= 2 && system.today() < feedbackList[0].Rate_Later_Date__c) {
          return false;
       
        }
        else{
          CORE_Feedback__c newObj=new CORE_Feedback__c ( App_Name__c=appName,Feedback_Date__c=System.today(),Rate_Later_Date__c=System.today(),User__c=userinfo.getUserid());
          insert newObj;
          return false;
        }
    }

  /******************************************************************************************************
* @description This method Inserts a record in Feedback object.
* @param  appName,Rating, Feedback Comment
* @return boolean. 
*/
  @AuraEnabled
   public static boolean insertFeedback(String appName,Integer rating,String comment) {
      
      if((Integer)rating > 0 ){
         Date feedbackagainDate=Date.today().addDays((Integer)App_Feedback__c.getInstance(appName).Feedback_Again_Days__c);
         CORE_Feedback__c newObj=new CORE_Feedback__c ( App_Name__c=appName,Rating__c=(Integer)rating,Feedback_Comments__c=comment,Feedback_Date__c=System.today(),Rate_Later_Date__c=feedbackagainDate,User__c=userinfo.getUserid());
         insert newObj;
         return true;
      }
      if((Integer)rating <= 0 || (Integer)rating==0 || (Integer)rating ==null){
         Date feedbacklaterDate=Date.today().addDays((Integer)App_Feedback__c.getInstance(appName).Rate_Later_Days__c);
         CORE_Feedback__c newObj=new CORE_Feedback__c ( App_Name__c=appName,Feedback_Date__c=System.today(),Rate_Later_Date__c=feedbacklaterDate,User__c=userinfo.getUserid());
         insert newObj;
         return true;
      } 
     
     return false;
  }
}