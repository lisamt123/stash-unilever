public with sharing class PQN_singleEntryScreen{
    public PQN_Pallet_Quality_Non_Conformance__c pqn{get; set;}
    public PQN_Supplier__c sup{get;set;}
    public boolean immediate{get; set;}
    Id pqnId;
    public PQN_singleEntryScreen(ApexPages.StandardController controller){
        immediate=true;
        pqn = new PQN_Pallet_Quality_Non_Conformance__c();
        pqnId = Apexpages.currentpage().getparameters().get('id');
        if(pqnId!=null){
            pqn = [select id,Reporting_DC__c,Region__c,DC_Country__c,MCO__c,Cluster__c,Sub_Cluster__c,Delivery_Note_Number__c,Description__c,
                    Product_Name__c,Product_Group__c,Product_Category__c,SKU__c,Supplier_type__c,Supplier__c,Supplier_Number__c,Non_compliance_reason_code__c,
                    Number_of_Pallets_Per_SKU_Non_Compliant__c,Date_Pallet_Received__c,Comments__c,Days_Left_Before_Freeze__c 
                    from PQN_Pallet_Quality_Non_Conformance__c where id=: pqnId];    
        }
        
    }
    
    public void validate(){
    
        try{
               
               String skuName =Apexpages.currentPage().getParameters().get('skuName');
               String suppName =Apexpages.currentPage().getParameters().get('suppName');
               String losName =Apexpages.currentPage().getParameters().get('losName');
               
               system.debug(losName+'********');
               if(skuName.length()>0){
                   List<PQN_Pallet_Quality_Non_Conformance__c > xPQNCList= [select id,Product_Category__c,Product_Name__c,Product_Group__c,SKU__c from PQN_Pallet_Quality_Non_Conformance__c where SKU__c=:skuName Limit 1];
                   if(xPQNCList.size()>0){
                       for(PQN_Pallet_Quality_Non_Conformance__c  xP: xPQNCList){
                       
                           pqn.Product_Category__c = xP.Product_Category__c;
                           pqn.Product_Name__c = xP.Product_Name__c ;
                           pqn.Product_Group__c = xP.Product_Group__c;
                           immediate=false;
                       }
                   }else{
                       pqn.Product_Category__c = '';
                       pqn.Product_Name__c = '' ;
                       pqn.Product_Group__c = '';
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Product Found.');
                       ApexPages.addMessage(myMsg);
                   }
                   
               }else{
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'SKU is null.');
                   ApexPages.addMessage(myMsg);
               }
              List<PQN_Supplier__c> PQNList_Sup= new List<PQN_Supplier__c>();
              system.debug('sssssssssss'+pqn.Supplier__c);
               PQNList_Sup= [select id,Name from PQN_Supplier__c where Name=:suppName ];
                if(PQNList_Sup.isempty()){               
                   ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Supplier is not found.');
                   ApexPages.addMessage(myMsg1);
                   
                }
                
                Map<string,PQN_Pallet_Loss_Tree__c> lossCodes = PQN_Pallet_Loss_Tree__c.getAll();
                set<integer> setlosscodes = new set<integer>();
                for(PQN_Pallet_Loss_Tree__c p: lossCodes.values()){
                    setlosscodes.add(integer.valueof(p.Loss_Code__c)); 
                    system.debug(setlosscodes);   
                }
                if (!setlosscodes.contains(integer.valueof(losName)))
                {
                   ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'LossCode is not found.');
                   ApexPages.addMessage(myMsg1);
                }
                
                   
       }
        catch(Exception e){
            
        }
        //return null;
    }
    
    public pagereference savePQN(){
           
     
        
        try{
            if(pqn!=null){
            
               
   
                String clone = apexpages.currentpage().getparameters().get('clone');
                if (clone == '1'){
                    PQN_Pallet_Quality_Non_Conformance__c pqn1 = new PQN_Pallet_Quality_Non_Conformance__c();
                    pqn1 = pqn;
                    pqn1.Id = null;
                    Insert pqn1;
                }else{
                    upsert pqn;
                }
                
                
                
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
            PageReference pqnhomePage = page.PQN_home;
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