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
public SAM_QLINewButtonOverrideController(ApexPages.StandardController controller){
     retUrl = Apexpages.CurrentPage().getParameters().get('retURL');
    recordId = Apexpages.CurrentPage().getParameters().get(label.SAM_QLI_NewBtn_URL);
    requestLkId = Apexpages.CurrentPage().getParameters().get(label.SAM_QLI_NewBtn_URL+'_lkid');
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
                RecordType recordtypeId =[select id,Name from RecordType where sObjectType='SAM_Quote_Line_Item__c' AND Name='SAM Quote RW' limit 1] ;
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