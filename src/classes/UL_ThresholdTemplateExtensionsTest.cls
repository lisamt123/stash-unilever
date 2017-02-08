/***************************************************************
Name: UL_ThresholdTemplateExtensionsTest()
Copyright © 2016 Salesforce
======================================================
Purpose:
Test class for the extension controller-UL_ThresholdTemplateExtensions.
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Chandrababu Naidu    12/29/2016        INITIAL DEV       Copy promotion for Soco in Sprint-3.
*****************************************************************/
@istest
public class UL_ThresholdTemplateExtensionsTest {
    /*******************************************************************
    Purpose: Test class for new workflow threshold template
    Version: 1.0
    Parameters: N/A
    Returns: N/A
    Throws N/A
    ********************************************************************/
    static testmethod void newWorkflowTemplate(){
     UL_Workflow_Threshold_Template__c workflowTemplate = new UL_Workflow_Threshold_Template__c();
     workflowTemplate.UL_Active__c=true;
     workflowTemplate.UL_TemplateDescription__c = ul_utility.PROMOTION_STATUS;
     list<ProcessDefinition> process = [SELECT Name,id FROM ProcessDefinition where state =:ul_utility.status_active and TableEnumOrId=:Schema.SObjectType.ACCL__Promotion__c.getName() limit 1];
       workflowTemplate.UL_Workflow__c = process[0].name;
       workflowTemplate.UL_Next_Status__c = process[0].name;
     database.insert(workflowTemplate);
     ApexPages.StandardController scont = new ApexPages.StandardController(workflowTemplate);
     UL_ThresholdTemplateExtensions thresholdExt = new UL_ThresholdTemplateExtensions(scont);
      test.startTest();
     thresholdExt.editClick();
     thresholdExt.cancel1();
     thresholdExt.save();
     thresholdExt.onLoadPage();
     thresholdExt.getApprovalProcessSteps();
        test.stopTest();
 }
 /*******************************************************************
    Purpose: Test class for new workflow threshold template
    Version: 1.0
    Parameters: N/A
    Returns: N/A
    Throws N/A
    ********************************************************************/
    static testmethod void newWorkflowTemplatewithoutDesc(){
     UL_Workflow_Threshold_Template__c workflowTemplate = new UL_Workflow_Threshold_Template__c();
     workflowTemplate.UL_Active__c=true;
     list<ProcessDefinition> process = [SELECT Name,id FROM ProcessDefinition where state =:ul_utility.status_active and TableEnumOrId=:Schema.SObjectType.ACCL__Promotion__c.getName() limit 1];
       workflowTemplate.UL_Workflow__c = process[0].name;
     database.insert(workflowTemplate);
     ApexPages.StandardController scont = new ApexPages.StandardController(workflowTemplate);
     UL_ThresholdTemplateExtensions thresholdExt = new UL_ThresholdTemplateExtensions(scont);
      test.startTest();
     thresholdExt.editClick();
     thresholdExt.cancel1();
     thresholdExt.save();
     thresholdExt.onLoadPage();
     thresholdExt.getApprovalProcessSteps();
        test.stopTest();
 }
    /*******************************************************************
    Purpose: Test class for existing workflow threshold template
    Version: 1.0
    Parameters: N/A
    Returns: N/A
    Throws N/A
    ********************************************************************/
    static testmethod void editWorkflowTemplate(){ 
      UL_Workflow_Threshold_Template__c workflowTemplate = new UL_Workflow_Threshold_Template__c();
      workflowTemplate.UL_Active__c=true;
      workflowTemplate.UL_TemplateDescription__c = ul_utility.PROMOTION_STATUS;
       list<ProcessDefinition> process = [SELECT Name,id FROM ProcessDefinition where state =:ul_utility.status_active and TableEnumOrId=:Schema.SObjectType.ACCL__Promotion__c.getName() limit 1];
       workflowTemplate.UL_Workflow__c = process[0].name;
       workflowTemplate.UL_Next_Status__c = process[0].name;
       database.insert(workflowTemplate);
       System.currentPageReference().getParameters().put('id', workflowTemplate.id);
       ApexPages.StandardController scont = new ApexPages.StandardController(workflowTemplate);
       UL_ThresholdTemplateExtensions editThresholdExt = new UL_ThresholdTemplateExtensions(scont);
        test.startTest();
         editThresholdExt.editClick();
         editThresholdExt.cancel1();
         editThresholdExt.save();
         editthresholdExt.onLoadPage();
         editThresholdExt.getApprovalProcessSteps();
        test.stopTest();
   }
}