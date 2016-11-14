public with sharing class PQN_singleEntryScreen{
    public PQN_Pallet_Quality_Non_Conformance__c pqn{get; set;}
    Id pqnId;
    public PQN_singleEntryScreen(ApexPages.StandardController controller){
        pqn = new PQN_Pallet_Quality_Non_Conformance__c();
        pqnId = Apexpages.currentpage().getparameters().get('id');
        if(pqnId!=null){
            pqn = [select id,Reporting_DC__c,Region__c,DC_Country__c,MCO__c,Cluster__c,Sub_Cluster__c,Delivery_Note_Number__c,Description__c,
                    Product_Name__c,Product_Group__c,Product_Category__c,SKU__c,Suppliers__c,Supplier_type__c,Non_compliance_reason_code__c,
                    Number_of_Pallets_Per_SKU_Non_Compliant__c,Date_Pallet_Received__c,Comments__c,Days_Left_Before_Freeze__c 
                    from PQN_Pallet_Quality_Non_Conformance__c where id=: pqnId];    
        }
    }
    public pagereference savePQN(){
        try{
            if(pqn!=null){
                upsert pqn;
                //PageReference redirectPage = new PageReference('/'+pqn.id);
                PageReference redirectPage = page.PQN_Conformance_Detail_VF;
                redirectPage.setRedirect(true);
                redirectPage.getParameters().put('id',pqn.id);
                return redirectPage;
            }
        }
        catch(Exception e){
        
        }
        return null;
    }
    public pagereference cancelPQN(){
        if(pqn.id==null){
            PageReference pqnhomePage = new PageReference('/a0W/o');
            pqnhomePage.setRedirect(true);        
            return pqnhomePage;
        } 
        else{
            PageReference recordPage = page.PQN_Conformance_Detail_VF;
            recordPage.setRedirect(true);   
            recordPage.getParameters().put('id',pqn.id);     
            return recordPage;
        } 
        
        return null;
          
    }
}