public without sharing class PQN_Supplier_Popup_Ctlr {
    public String query {get; set;}
    public List<PQN_Supplier__c> xSuppliers{get; set;}
    public List<PQN_Pallet_Quality_Non_Conformance__c > xProducts{get; set;}
    public List<PQN_Pallet_Loss_Tree__c> xLosscode{get; set;}
    
    
    public String objectName {get; set;}
    


    public PQN_Supplier_Popup_Ctlr (){
        xLosscode = new List<PQN_Pallet_Loss_Tree__c >();
        query = apexpages.currentpage().getparameters().get('search_Name');
        objectName = apexpages.currentpage().getparameters().get('object_Name');
        string tempInput = '%' +query + '%';
        if(objectName=='Products'){
            xProducts = [select id,Product_Category__c,Product_Name__c,Product_Group__c,SKU__c from PQN_Pallet_Quality_Non_Conformance__c where SKU__c Like :tempInput];

        }
        if(objectName=='Suppliers'){
            xSuppliers= [Select Id,Name,Supplier_Alias__c,Supplier_Number__c,Supplier_Type__c from PQN_Supplier__c where Supplier_Alias__c Like :tempInput ];
        }
        if(objectName=='Loss Codes'){
            xLosscode= [SELECT Loss_Code__c,Loss_L1__c,Loss_L2__c,Loss_L3__c,Loss_L4__c,Name FROM PQN_Pallet_Loss_Tree__c order by Loss_Code__c];
        }
        

    }
         
    public PageReference runQuery(){
    
        string tempInput = '%' + query + '%';
        if(objectName=='Products'){
                xProducts = [select id,Product_Category__c,Product_Name__c,Product_Group__c,SKU__c from PQN_Pallet_Quality_Non_Conformance__c where SKU__c Like :tempInput];
    
        }
        if(objectName=='Suppliers'){
            xSuppliers= [Select Id,Name,Supplier_Alias__c, Supplier_Number__c,Supplier_Type__c from PQN_Supplier__c where Supplier_Alias__c Like :tempInput ];
        }
        
        PageReference pageRef = new PageReference('/apex/PQN_Supplier_Popup'); 
        return PageRef;
    
    }
    
         

}