@istest
public with sharing class Core_CA_ChatterPostNavCont_Test {

 @TestVisible static String strClarity = 'Clarity';
 @TestVisible static String strStatus = 'Approver Added';
 @TestVisible static String strApp = 'APP';
 @TestVisible static String strApproved = 'Approved';

 public static Testmethod void Core_CA_PostNavContTest() {

  Core_Approval_Header__c objHeaderClr = new Core_Approval_Header__c(Name = 'testclarity1', Source_System__c = strClarity, Status__c = strStatus, Manager__c = Userinfo.getuserId(),
   Requested_By__c = Userinfo.getuserId(), Requested_For__c = Userinfo.getuserId());
  insert objHeaderClr;
  System.assert(objHeaderClr != null);

  Core_Approver_Details__c objApproverclr = new Core_Approver_Details__c(Interested_Party__c = Userinfo.getuserId(), Source_System__c = strClarity, Approval_Header__c = objHeaderClr.Id,
   Role__c = strApp, Status__c = strApproved, Action__c = 'REWO');
  insert objApproverclr;

  ApexPages.StandardController sc = new ApexPages.standardController(objApproverclr);
  Core_CA_ChatterPostNavigationController test = new Core_CA_ChatterPostNavigationController(sc);
    System.assert(test != null);


 }
}