/********************************************************************
 Name:  SAM_NewButtonRequestLineItemController()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose:  This class has methods for record types                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR    DATE              DETAIL                 Description
   1.0   Name      14/07/2016        INITIAL DEVELOPMENT           
***********************************************************************/
public with sharing class SAM_NewButtonRequestLineItemController{
    
        public List<RecordType> schemeList{get;set;}
        public String recordtypeId {get;set;}
        public String titleText {get;set;}
        public List<RecordType>recordTypeInfoList{get;set;}
        public SAM_Request__c requestObj;
        String retUrl;
        String recordId;
        String requestLkId;
        
        public SAM_NewButtonRequestLineItemController(ApexPages.StandardController controller){
            //Dinesh 26/7 - Encode the below line from XSS perspective. Also replace hard coded values with constants
            retUrl = Apexpages.CurrentPage().getParameters().get('retURL');
            if(retUrl.removeStart('/').startsWith(label.SAM_Request_Object_name)){
                requestObj = [select id,name from SAM_Request__c where id =:retUrl.removeStart('/')];
                recordId = requestObj.name;
                requestLkId  = requestObj.id;
            }else{
                SAM_Request_Line_Item__c rli = [select md_Request_ID__r.name, md_Request_ID__c from SAM_Request_Line_Item__c where id=:retUrl.removeStart('/')];
                recordId = rli.md_Request_ID__r.name;
                requestLkId = rli.md_Request_ID__c;
            }
            system.debug('requestObj >>>'+requestObj );
            recordTypeInfoList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where DeveloperName IN('SAM_IBM_RW','SAM_Microsoft_RW','SAM_Oracle_RW','SAM_Other_Product_RW','SAM_SAP_RW')] ;
        }
        
    /*******************************************************************
    Purpose: This method is used to fetch record type list
    Parameters: 
    Returns: List<SelectOption>
    Throws [Exceptions]: Exception
    ********************************************************************/
        public  List<SelectOption> getRecordTypeList() {
        
        schemeList = new List<RecordType>();
        List<SelectOption> optionsList = new List<SelectOption>();
        List<SelectOption> optionsOthersList = new List<SelectOption>();
        
        try {
            //Dinesh 26/7 - replace below hardcoded values with constants
            schemeList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where DeveloperName IN('SAM_IBM_RW','SAM_Microsoft_RW','SAM_Oracle_RW','SAM_Other_Product_RW','SAM_SAP_RW')] ;
           
            system.debug('schemeList !!'+schemeList );
            if(!schemeList.isEmpty()) {
                //optionsList.add(new SelectOption('None','None'));
                for(RecordType schemeRs:schemeList) {
                    if(schemeRs.DeveloperName.Contains('Other')){
                    optionsOthersList.add(new SelectOption(schemeRs.Id, schemeRs.Name));
                    }
                    else
                    {
                     optionsList.add(new SelectOption(schemeRs.Id, schemeRs.Name));
                    }
                }   
                // optionsList.sort();
                optionsList.AddAll(optionsOthersList);
                return optionsList;
            }
        }catch (Exception e){
                system.debug(e.getMessage());
        }
        return new List<SelectOption>();
    }
      /*******************************************************************
    Purpose: This method is used to redirect the page
    Parameters: 
    Returns: PageReference
    Throws [Exceptions]: Exception
    ********************************************************************/
    public PageReference redirectToPageNewItem() {  
             PageReference massPageUrl = null;
            try{
                
                String UrlLink ='';
                //UrlLink = '/'+SAM_Request_Line_Item__c.getSObjectType().getDescribe().getKeyPrefix()+'/e?'+label.SAM_RLI_NewBtn_URL+'='+requestObj.name+'&'+label.SAM_RLI_NewBtn_URL+'_lkid='+requestObj.id+'&retURL=%2F'+requestObj.id+'&RecordType='+recordtypeId+'&nooverride=1';
                
                UrlLink = '/'+SAM_Request_Line_Item__c.getSObjectType().getDescribe().getKeyPrefix()+'/e?'+label.SAM_RLI_NewBtn_URL+'='+recordId+'&'+label.SAM_RLI_NewBtn_URL+'_lkid='+requestLkId+'&retURL=%2F'+requestLkId+'&RecordType='+recordtypeId+'&nooverride=1';
                massPageUrl = new PageReference(UrlLink);
                massPageUrl.setRedirect(true);
                system.debug('massPageUrl>>>'+massPageUrl);
            }catch(Exception e){
                system.debug(e.getMessage());
            } 
            return massPageUrl;
       
       }
       
    /*******************************************************************
    Purpose: This method is used to redirect to the cancel page
    Parameters: 
    Returns: PageReference
    Throws [Exceptions]: Exception
    ********************************************************************/
    public PageReference cancelRedirect() {  
      PageReference massPageUrl = null;
      try{
      
          if(retUrl!=null){
          massPageUrl = new PageReference(retUrl);
          massPageUrl.setRedirect(true);
          }
      }catch(Exception e){
          system.debug(e.getMessage());
      }     
        return massPageUrl;
    }
}