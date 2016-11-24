public with sharing class PQN_Supplier_Popup_Ctlr {
    public String query {get; set;}
    public List<PQN_Supplier__c> xSuppliers{get; set;}
    public List<PQN_Pallet_Quality_Non_Conformance__c > xProducts{get; set;}
    public String objectName {get; set;}
    


    public PQN_Supplier_Popup_Ctlr (){
        query = apexpages.currentpage().getparameters().get('search_Name');
        objectName = apexpages.currentpage().getparameters().get('object_Name');
        string tempInput = '%' +query + '%';
        if(objectName=='product'){
            xProducts = [select id,Product_Category__c,Product_Name__c,Product_Group__c,SKU__c from PQN_Pallet_Quality_Non_Conformance__c where SKU__c Like :tempInput];

        }
        if(objectName=='supplier'){
            xSuppliers= [Select Id,Name,Supplier_Number__c,Supplier_Type__c from PQN_Supplier__c where Name Like :tempInput ];
        }
        

    }
         
    public PageReference runQuery(){
    
        string tempInput = '%' + query + '%';
        if(objectName=='product'){
                xProducts = [select id,Product_Category__c,Product_Name__c,Product_Group__c,SKU__c from PQN_Pallet_Quality_Non_Conformance__c where SKU__c Like :tempInput];
    
        }
        if(objectName=='supplier'){
            xSuppliers= [Select Id,Name,Supplier_Number__c,Supplier_Type__c from PQN_Supplier__c where Name Like :tempInput ];
        }
        PageReference pageRef = new PageReference('/apex/PQN_Supplier_Popup'); 
        return PageRef;
    
    }
    
         

}