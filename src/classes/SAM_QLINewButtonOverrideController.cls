/********************************************************************
 Name:  SAM_QLINewButtonOverrideController()
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
   1.0   Name      28/07/2016        INITIAL DEVELOPMENT           
***********************************************************************/
public with sharing class SAM_QLINewButtonOverrideController{
    String retUrl;
    String recordId;
    String requestLkId;
    String requestType;
    public SAM_Request__c requestObj;
public SAM_QLINewButtonOverrideController(ApexPages.StandardController controller){
     retUrl = Apexpages.CurrentPage().getParameters().get('retURL');
    if(retUrl.removeStart('/').startsWith(label.SAM_Request_Object_name)){
        system.debug('retUrl.re1>>'+retUrl.removeStart('/'));
        requestObj = [select id,name,txt_Request_Type__c from SAM_Request__c where id =:retUrl.removeStart('/')];
        recordId = requestObj.name;
        requestLkId  = requestObj.id;
        requestType = requestObj.txt_Request_Type__c;
    }else{
        system.debug('retUrl.re2>>'+retUrl.removeStart('/'));
        List<SAM_Quote_Line_Item__c> qli = [select md_Request__r.name,md_Request__r.txt_Request_Type__c, md_Request__c from SAM_Quote_Line_Item__c where id=:retUrl.removeStart('/')];
        system.debug('qli>>>'+qli);
        if(qli != null && qli.size() > 0 ){
        	recordId = qli[0].md_Request__r.name;
        	requestLkId = qli[0].md_Request__c;
        	requestType = qli[0].md_Request__r.txt_Request_Type__c;
        }
    }
}

 /*******************************************************************
    Purpose: This method is used to redirect the page
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference redirectToPageNewItem() {  
             PageReference massPageUrl = null;
            try{
                RecordType recordtypeId ;
                if(requestType == 'SAM_RW_Non_Project_Request'){ 
                    recordtypeId =[select id,Name from RecordType where sObjectType='SAM_Quote_Line_Item__c' AND Name='SAM Non Proj Quote RW' limit 1] ;
                }
                else{
                    recordtypeId =[select id,Name from RecordType where sObjectType='SAM_Quote_Line_Item__c' AND Name='SAM Quote RW' limit 1] ;
                }
                String UrlLink ='';
                UrlLink = '/'+SAM_Quote_Line_Item__c.getSObjectType().getDescribe().getKeyPrefix()+'/e?'+label.SAM_QLI_NewBtn_URL+'='+recordId+'&'+label.SAM_QLI_NewBtn_URL+'_lkid='+requestLkId+'&retURL=%2F'+requestLkId+'&RecordType='+recordtypeId.id+'&nooverride=1';
                system.debug('UrlLink>>'+UrlLink);
                massPageUrl = new PageReference(UrlLink);
                massPageUrl.setRedirect(true);
                system.debug('massPageUrl>>>'+massPageUrl);  
            }catch(Exception e){
                system.debug(e.getMessage());
            } 
            return massPageUrl;
       
       }
    }