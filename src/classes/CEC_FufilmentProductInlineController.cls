/**********************************************************************
Name:  CEC_FufilmentProductInlineController
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: This class is a controller for CEC_Fulfilment_Product_Inline VF
                 Page.
========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR                                DATE            DETAIL                   
1.0        Masood Ahmad Ansari           April-2016      INITIAL DEVELOPMENT   

***********************************************************************/

public with sharing class CEC_FufilmentProductInlineController {
    
    /* Case object */
    public cec_Fulfilment__c fulfilmentRecord {get; set;}
    /* Product Id */
    public String productId {get; set;}
    /* Product name */
    public String productName {get; set;}
    /* Product quantity */
    public Integer productQuantity {get; set;}
    public String errorMsg {get; set;}
    public String caseCountryCode {get;set;}
    public Boolean isApproved {get;set;}
    
    public CEC_FufilmentProductInlineController(ApexPages.StandardController controller) {        
        
        fulfilmentRecord = (cec_Fulfilment__c) controller.getRecord();
        
        if(fulfilmentRecord.Id != null){
        
            fulfilmentRecord = [Select Id, Retrieval_Id__c,Case__r.Country__r.Country__r.ISO_3166_1_Code__c,
                                Case__r.CEC_Product__c, Case__r.CEC_Product__r.Name, isApproved__c
                                FROM cec_Fulfilment__c WHERE Id =: fulfilmentRecord.Id];
            caseCountryCode = fulfilmentRecord.Case__r.Country__r.Country__r.ISO_3166_1_Code__c;
            isApproved = fulfilmentRecord.isApproved__c;
            productQuantity=1;
        }
    }
    
    public void saveList(){
        try {
            errorMsg = '';
            if (isApproved) {
                errorMsg = Label.CEC_ApprovedFulfilmentError;
            } else if(String.isNotBlank(productId)){
                CEC_Fulfilment_Product__c fulfilmentProduct = new CEC_Fulfilment_Product__c();
                fulfilmentProduct.Product__c = productId ;
                if(productQuantity== NULL || productQuantity == 0){
                    fulfilmentProduct.Product_Quantity__c = 1;   
                }else{
                    fulfilmentProduct.Product_Quantity__c = productQuantity;
                }
                fulfilmentProduct.Fulfilment_Id__c = fulfilmentRecord.id; 
                if (fulfilmentRecord.Retrieval_Id__c != null){
                    fulfilmentProduct.Retrieval_Id__c = fulfilmentRecord.Retrieval_Id__c;
                }
                
                insert fulfilmentProduct;               
                System.debug('@@@@@fulfilment id '+ fulfilmentProduct.id);
            }
        } catch (Exception e) {
            System.debug('Error in Saving the Fulfilment Product: ' + e.getMessage());
            errorMsg = e.getMessage();
        }
    }
}