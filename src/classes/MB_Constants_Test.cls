/***************************************************************
Class Name: MB_Constants_Test.cls
Copyright © 2016 Salesforce

Purpose:
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test class For TEM app.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       30/05/2016        test class For TEM app
***************************************************************/

@IsTest
public with sharing class  MB_Constants_Test {
  static testMethod void testMBConstantsClass(){
  Test.startTest();
  
  String usageTypeData = MB_Constants.Usage_Type_Data;
  String usageTypeCalls = MB_Constants.Usage_Type_Calls;
  String usageTypeMessaging = MB_Constants.Usage_Type_Messaging;
  String usageTypeiPass = MB_Constants.Usage_Type_iPass;

  System.assertEquals(usageTypeData,'Data');  
  System.assertEquals(usageTypeCalls,'Calls');  
  System.assertEquals(usageTypeMessaging,'Messaging');  
  System.assertEquals(usageTypeiPass,'iPass');  

  Test.stopTest();
  }
}