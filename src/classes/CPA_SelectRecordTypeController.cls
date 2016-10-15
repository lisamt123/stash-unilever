/********************************************************************
 Name:  CPA_SelectRecordTypeController()
 Copyright © 2015  Unilever
 ======================================================
======================================================
Purpose:  This class has methods for record types                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR    DATE              DETAIL                 Description
   1.0   Name      03/04/2015        INITIAL DEVELOPMENT           
***********************************************************************/
public with sharing class CPA_SelectRecordTypeController { 
    
    public List<SelectOption> recordTypelist {get;set;}
    public String recordtypeId {get;set;}
    public String pworfId {get;set;}
    public String flagState{get;set;}
    public String objName {get;set;}
    public List<RecordType> schemeList{get;set;}
    public String titleText {get;set;}
    
    /*******************************************************************
    Purpose: Constructor to get pworf id and and flagstate from query string
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_SelectRecordTypeController() {
    
        pworfId = Apexpages.CurrentPage().getParameters().get('id');
        flagState= Apexpages.CurrentPage().getParameters().get('flag');
        recordTypelist = new List<SelectOption>();
        recordTypelist = getRecordTypeList();
        
    }
    
    /*******************************************************************
    Purpose: This method is used to fetch record type list
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public  List<SelectOption> getRecordTypeList() {
        schemeList = new List<RecordType>();
        List<SelectOption> optionsList = new List<SelectOption>();
        try {
        schemeList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where Name IN('CR Other','Standalone CR')] ;
            objName = findObjectNameFromRecordIdPrefix(pworfId );
        
            /*if(objName =='CPA_PWORF__c') {
                titleText = CPA_ConstantsForContractingAppClasses.PWO;
                schemeList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where Name IN('PWO','Standalone PWO')] ;
            } if(objName =='CPA_project_work_order__c')  {
               titleText = CPA_ConstantsForContractingAppClasses.CR;
                schemeList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where Name IN('CR Other','Standalone CR')] ;
            }if(objName =='CPA_PWORF__c' && flagState =='Loi') {
                titleText = CPA_ConstantsForContractingAppClasses.LOI;
                schemeList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where Name IN('LOI Other','LOI Submitted')] ;
            }*/
            if(!schemeList.isEmpty()) {
                //optionsList.add(new SelectOption('None','None'));
                for(RecordType schemeRs:schemeList) {
                    optionsList.add(new SelectOption(schemeRs.Id, schemeRs.Name));
                }   
                // optionsList.sort();
                return optionsList;
            }
        }catch (Exception e){
                system.debug('Error on Line no 69'+e.getMessage());
        }
        return new List<SelectOption>();
    }
    
    /*******************************************************************
    Purpose: This method is used to redirect the page
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference redirectToPageNewItem() {  
        String UrlLink ='';
       /* if(objName =='CPA_PWORF__c') {
            CPA_PWORF__c Rs= [Select Id,Name From CPA_PWORF__c Where Id=:pworfId];
            
            UrlLink = '/'+CPA_ConstantsForContractingAppClasses.CPA_PWO_OBJECT_ID +'/e?retURL='+Rs.Id+'&RecordType='+recordtypeId+Label.CPA_PWORF_Name_Filed_Id+'='+Rs.Name+Label.CPA_PWORF_Name_Filed_Id+'_lkid='+Rs.Id;
       
       }if(objName =='CPA_PWORF__c' && flagState =='Loi'){
        
            CPA_PWORF__c RsLoi= [Select Id,Name From CPA_PWORF__c Where Id=:pworfId];
            
            UrlLink = '/'+CPA_ConstantsForContractingAppClasses.CPA_LOI_ID+'/e?retURL='+RsLoi.Id+'&RecordType='+recordtypeId+Label.CPA_PWORF_LOI_Name_Filed_Id+'='+RsLoi.Name+Label.CPA_PWORF_LOI_ID_Filed_Id+'_lkid='+RsLoi.Id;
        
        }if(objName =='CPA_project_work_order__c'){   
        
            CPA_project_work_order__c Rscr= [Select Id,Name From CPA_project_work_order__c Where Id=:pworfId];
              if(Rscr!=null){
                  UrlLink = '/'+CPA_ConstantsForContractingAppClasses.CPA_CR_ID+'/e?retURL='+Rscr.ID+'&RecordType='+recordtypeId+Label.CPA_PWO_Name_Field_Id+'='+Rscr.Name+Label.CPA_PWO_Name_Field_Id+'_lkid='+Rscr.Id;
              }else{
                  UrlLink = '/'+CPA_ConstantsForContractingAppClasses.CPA_CR_ID+'/e?retURL='+Rscr.ID+'&RecordType='+recordtypeId+"&retURL=%2F"+CPA_ConstantsForContractingAppClasses.CPA_CR_ID;
              }
            
        }
        else {
            
        }*/
        //if(objName =='CPA_project_work_order__c'){   
        if(pworfId !=null && pworfId != ''){
            CPA_project_work_order__c Rscr= [Select Id,Name From CPA_project_work_order__c Where Id=:pworfId];
              if(Rscr!=null){
                  UrlLink = '/'+CPA_ConstantsForContractingAppClasses.CPA_CR_ID+'/e?retURL='+Rscr.ID+'&RecordType='+recordtypeId+Label.CPA_PWO_Name_Field_Id+'='+Rscr.Name+Label.CPA_PWO_Name_Field_Id+'_lkid='+Rscr.Id;
              }else{
                  UrlLink = '/'+CPA_ConstantsForContractingAppClasses.CPA_CR_ID+'/e?retURL='+CPA_ConstantsForContractingAppClasses.CPA_CR_ID+'&RecordType='+recordtypeId;
              }
        }else{
            UrlLink = '/'+CPA_ConstantsForContractingAppClasses.CPA_CR_ID+'/e?retURL='+CPA_ConstantsForContractingAppClasses.CPA_CR_ID+'&RecordType='+recordtypeId;
        }
            
            
       // }
        
        PageReference massPageUrl = new PageReference(UrlLink);
        massPageUrl.setRedirect(true);
            
        return massPageUrl;
    }
    /*******************************************************************
    Purpose: This method is used to redirect to the cancel page
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference cancelRedirect() {  
         
        String UrlLink = '/'+pworfId ;
        PageReference massPageUrl = new PageReference(UrlLink);
        massPageUrl.setRedirect(true);
            
        return massPageUrl;
    }
    
    /*******************************************************************
    Purpose: This method is used to find Object Name From Record Id Prefix
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }
}