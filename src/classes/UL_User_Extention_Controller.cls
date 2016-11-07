public with sharing class UL_User_Extention_Controller{
public list<user> userlist{set;get;}
public UL_User_Extention_Controller(ApexPages.StandardController stdController){

UL_Approval_Threshold__c at1 = (UL_Approval_Threshold__c)stdController.getRecord();

UL_Approval_Threshold__c  at= [select id,UL_Career_Level__c,UL_Sales_Organization__r.Name  from UL_Approval_Threshold__c where id=:at1.id];
System.debug('----'+at);
<!--userlist = [Select Name,UL_Career_Level__c, ACSFUL001__Sales_Organization__c from User where UL_Career_Level__c=:at.UL_Career_Level__c And ACSFUL001__Sales_Organization__c=:at.UL_Sales_Organization__r.Name];
-->
System.debug(''+userlist);

}
}