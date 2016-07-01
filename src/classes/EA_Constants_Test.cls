/*
Class Name: EA_Constants_Test
Author : Mindtree
Date: 11 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For EA_ConstantsClass.
*/
@IsTest
public class EA_Constants_Test{

  static testMethod void postive() {
      
      // EA_Constants ec = new EA_Constants(); // June 16 - SONAR Fix
      string str1 = EA_Constants.BADGE_BRONZ;
      System.assertEquals('Bronze', str1);
      
      string str2 = EA_Constants.BADGE_NEWBEE;
      System.assertEquals('Newbee', str2);
      
      string str3 = EA_Constants.SOBJECT_NAME;
      System.assertEquals('Everyday_Activity__c', str3);
      
      string str4 = EA_Constants.BADGE_SILVER;
      System.assertEquals('Silver', str4);
      
      string str5 = EA_Constants.BADGE_GOLD;
      System.assertEquals('Gold', str5);
      
      string str6 = EA_Constants.INVITATION_STATUS_ACCEPTED;
      System.assertEquals('Accepted', str6);
      
      string str7 = EA_Constants.INVITATION_STATUS_DECLINED;
      System.assertEquals('Declined', str7);
      
      string str8 = EA_Constants.INVITATION_STATUS_INVITED;
      System.assertEquals('Invited', str8);
      
      string str9 = EA_Constants.INVITATION_STATUS_SELF;
      System.assertEquals('Self', str9);
  }
  
 }