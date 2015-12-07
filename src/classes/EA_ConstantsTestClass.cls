/*
Class Name: EA_ConstantsTestClass
Author : Mindtree
Date: 11 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For EA_ConstantsClass.
*/
@IsTest
public class EA_ConstantsTestClass{

  static testMethod void postive() {
      
      EA_Constants ec = new EA_Constants();
      string str1 = EA_Constants.BADGE_BRONZ;
      string str2 = EA_Constants.BADGE_NEWBEE;
      string str3 = EA_Constants.SOBJECT_NAME;
      string str4 = EA_Constants.BADGE_SILVER;
      string str5 = EA_Constants.BADGE_GOLD;
      string str6 = EA_Constants.INVITATION_STATUS_ACCEPTED;
      string str7 = EA_Constants.INVITATION_STATUS_DECLINED;
      string str8 = EA_Constants.INVITATION_STATUS_INVITED;
      string str9 = EA_Constants.INVITATION_STATUS_SELF;
      
      System.assertEquals('Self', str9);
  }
  
 }