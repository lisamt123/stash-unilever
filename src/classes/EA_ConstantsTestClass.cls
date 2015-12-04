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
  EA_ThemesDetails__c ea=new EA_ThemesDetails__c();
            ea.name='test.theme';
            ea.ThemeColorCode__c='test.color';
            ea.ThemeDescription__c='test.Desc';
            insert ea;
            System.assertEquals(ea.Name, 'test.theme');
            EA_BadgeDetails__c badge=new EA_BadgeDetails__c();
            badge.name='test1';
            badge.BadgeColor__c='blue';
            badge.BadgeSerial__c=1;
            badge.BadgeValue__c=2;
            insert badge;
             System.assertEquals(badge.Name, 'test1');
            }
            }