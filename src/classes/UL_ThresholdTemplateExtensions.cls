/***************************************************************
Name: UL_ThresholdTemplateExtensions()
Copyright © 2016 Salesforce
======================================================
Purpose:
Extension Controller for Visualforce page-UL_WorkflowThresholdTemplatePage.
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Chandrababu Naidu    01/12/2016        INITIAL DEV       Create\edit Workflow Threshold Templates.
*****************************************************************/
public without sharing class UL_ThresholdTemplateExtensions {
    public boolean viewMode{get;set;}
    public boolean editMode{get;set;}
    public UL_Workflow_Threshold_Template__c thrtemp{get;set;} 
    public list<selectoption> approvalProcessList{get;set;}
    public list<selectoption> approvalProcessSteps{get;set;}
    static final string Activ = 'Active';
    static final string promid = 'id';
    
    Map<String,id> approvalids;
    
    Id id;
    set<String> stepNames;
    /*******************************************************************
    Purpose: Constructor
    Version: 1.0
    Parameters: N/A
    Returns: N/A
    Throws N/A
    ********************************************************************/
  public UL_ThresholdTemplateExtensions(ApexPages.StandardController stdController){
     this.thrtemp=(UL_Workflow_Threshold_Template__c)stdController.getRecord();
      id = ApexPages.currentPage().getParameters().get(promid);
      approvalids = new Map<String,id>();
      stepNames = new set<String>();
      approvalProcessSteps = new list<selectoption>();
      if(id==null){
          viewMode = false;
          editMode = true;    
      }
      else{
          viewMode = true;
          editMode = false;
      }
     
    }
    /*******************************************************************
    Purpose: Load all the Promotion object related approval processes 
    Version: 1.0
    Parameters: N/A
    Returns: N\A
    Throws N/A
    ********************************************************************/
    public void onLoadPage(){
       approvalProcessList = new list<selectoption>();
     
      for(ProcessDefinition process : [SELECT Name,id FROM ProcessDefinition where state=:Activ and TableEnumOrId=:Schema.SObjectType.ACCL__Promotion__c.getName() limit :(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
      approvalids.put(process.name,process.id);
               SelectOption custOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                custOption.setValue(process.name);
                custOption.setLabel(process.name);
          approvalProcessList.add(custOption);
      }
      
      for(ProcessInstanceNode processsteps : [select processnodename from ProcessInstanceNode where ProcessInstanceId in (select id FROM ProcessInstance where processdefinitionid=:approvalids.get(thrtemp.UL_Workflow__c)) limit:(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
          stepNames.add(processsteps.processnodename);
      }
       
       for(String steps : stepNames){
          SelectOption custOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                custOption.setValue(steps);
                custOption.setLabel(steps);
          approvalProcessSteps.add(custOption);
       }
    }
    /*******************************************************************
    Purpose: On Edit Workflow Threshold template
    Version: 1.0
    Parameters: N/A
    Returns: N\A
    Throws N/A
    ********************************************************************/
    public void editClick(){
        try{
            viewMode = false;
            editMode = true;
        }
        catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
    /*******************************************************************
    Purpose: On cancel Workflow Threshold template
    Version: 1.0
    Parameters: N/A
    Returns: Page reference with id
    Throws N/A
    ********************************************************************/
    public pagereference cancel1(){
        try{
        viewMode = true;
        editMode = false;
        if(id==null){
          Schema.DescribeSObjectResult result = UL_Workflow_Threshold_Template__c.sObjectType.getDescribe();
          PageReference pageRef = New PageReference(UL_Utility.FORWARD_SLASH + result.getKeyPrefix() + UL_Utility.RECORD_OPEN_PARAM);
          pageref.setRedirect(true);
          return pageRef;
        }
        else{
            return null;
        }
        }
        catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
            return null;
        }
    }
    /*******************************************************************
    Purpose: On save Workflow Threshold template
    Version: 1.0
    Parameters: N/A
    Returns: Page reference with id
    Throws N/A
    ********************************************************************/
    public pagereference save(){
        try{
            database.upsert(thrtemp);
            viewMode = true;
            editMode = false;
            pagereference pageref = new PageReference(UL_Utility.FORWARD_SLASH + thrtemp.id);
            pageref.setRedirect(true);
            if(id==UL_Utility.NULL_ID){
                return pageref;
            }
            else
            {
                return null;
            }
        }
        catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
            return null;
        }
    }
    /*******************************************************************
    Purpose: Get approval process and steps for Promotion object dynamically
    Version: 1.0
    Parameters: N/A
    Returns: N\A
    Throws N/A
    ********************************************************************/
    public void getApprovalProcessSteps(){
        try{
            stepNames = new set<String>();
            approvalProcessSteps = new list<selectoption>();
           
            for(processnode processsteps : [select description from processnode where processdefinitionid=:approvalids.get(thrtemp.UL_Workflow__c) limit:(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
              stepNames.add(processsteps.description);
            }
            for(String steps : stepNames){
              SelectOption custOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
              custOption.setValue(steps);
              custOption.setLabel(steps);
              approvalProcessSteps.add(custOption);
                
            }
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
}