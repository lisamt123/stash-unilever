/**********************************************************************
Name: BEN_KPIProgressReprtHandler Copyright © 2016 Salesforce 
======================================================
======================================================
Purpose: This class is controller class for Visualforce page BEN_KPIProgressReport
======================================================
======================================================
History
-------
VERSION     AUTHOR        DATE            DETAIL Description
V1.0         mahesh         25/01/2017    Visualforce page COntroller clazz
***********************************************************************/
public with sharing class BEN_KPIProgressReprtHandler {
    
    public Boolean renderBlock{get;set;}
    
    //To get the inputs for report.
    public List<SelectOption> getYearQuarter() {
        List<SelectOption> options = new List<SelectOption>();
        List<BEN_Category_Details__c> YearandQuarter = [select fml_Year_Quarter__c from BEN_Category_Details__c where pkl_Status__c='Approved' ORDER BY fml_Year_Quarter__c];
        Map<String, String> yqMap = new Map<String, String>();
        for(BEN_Category_Details__c ar : YearandQuarter){
           yqMap.put(ar.fml_Year_Quarter__c, ar.fml_Year_Quarter__c);
        }
        for(String key : yqMap.keySet()){
            options.add(new SelectOption(key,key));
        }
        return options;
    }
    
    public string YearQuarterSelected{get;set;}  
    
    //The method to call visualforce page where it renderAs PDF
    public PageReference getdownloadPage(){
        if(YearQuarterSelected== null || YearQuarterSelected == '[]'){
             ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Select atleast one input to get the report with Content: ' + 
                                                              YearQuarterSelected);
             ApexPages.addMessage(myMsg); 
        }
        
        renderBlock = true;
        PageReference printPageRef = Page.BEN_KPIProgressReport_Generator;
        Map<String, String> params = printPageRef.getParameters();
        params.put('YearQuarterSelected', YearQuarterSelected);
        params.put('renderAsVar', 'PDF');
        return printPageRef;
    }
    
    //The method to call Visualforce page and pass parametres to it.
    public PageReference getReport()
    {
        if(YearQuarterSelected== null || YearQuarterSelected == '[]'){
             ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Select atleast one input to get the report with content: ' + 
                                                              YearQuarterSelected);
             ApexPages.addMessage(myMsg); 
        }
        renderBlock = true;
        PageReference printPageRef = Page.BEN_KPIProgressReport_Generator;
        Map<String, String> params = printPageRef.getParameters();
        params.put('YearQuarterSelected', YearQuarterSelected);
        return null;
    }
}