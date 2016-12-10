public with sharing class UL_DeliveryProfileController{
    
    private ApexPages.StandardController ctr;
    public UL_Delivery_Profile__c releatedRecord{set;get;}
    
    public UL_DeliveryProfileController(ApexPages.StandardController controller) {
        this.ctr = controller;
        releatedRecord = new UL_Delivery_Profile__c (); 
        String recId = System.currentPagereference().getParameters().get('Id');
        if(recId != null){
        releatedRecord = [SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, UL_Delivery_Profile_Name__c, UL_Account__c, UL_Sales_Organisation__c, UL_Shipment_Start_days__c, UL_Shipment_End_days__c, UL_Instore_End_days__c, UL_Valid_From__c, UL_Valid_Thru__c, UL_Product__c, UL_Planning_Level__c FROM UL_Delivery_Profile__c where id=:recId];
        }
         if(releatedRecord.UL_Valid_From__c == null && releatedRecord.UL_Valid_Thru__c == null){
                releatedRecord.UL_Valid_From__c = System.today();
                releatedRecord.UL_Valid_Thru__c =  date.parse('31/12/2099');
        }
        
    }
    public void shipmentEndDaysSet(){      
        releatedRecord.UL_Shipment_End_days__c = releatedRecord.UL_Instore_End_days__c;    
    }
    public void shipmentStartDaysSet(){      
       if(releatedRecord.UL_Shipment_Start_days__c!= null && releatedRecord.UL_Shipment_Start_days__c>0){
           releatedRecord.UL_Shipment_Start_days__c =  releatedRecord.UL_Shipment_Start_days__c - (2 * releatedRecord.UL_Shipment_Start_days__c);
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info, 'Shipment Start Date should be on or before In-Store Start Date!');
           ApexPages.addMessage(msg);
       }
    }   
    public PageReference save(){
            PageReference pref = null;
       try{
             if(validationForDays()){  
                mappingCustomer();
                Database.upsert(releatedRecord);
                Boolean saveAndNew = false;
                for(String key : Apexpages.currentPage().getParameters().keySet()){
                    if(key.contains('saveAndNew')){
                        saveAndNew = true;
                        break;
                    }
                }
                if(saveAndNew){
                    Apexpages.currentPage().setRedirect(true);
                    pref =  new PageReference('/'+ctr.getRecord().getSObjectType().getDescribe().getKeyPrefix()+'/e');
                }
                else{
                    pref = new PageReference('/'+releatedRecord.Id);
                    pref.setRedirect(true); 
                }                                   
             }
          }
          catch(Exception ex){
              ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
              ApexPages.addMessage(msg);
          }
    return pref ;
    }
    
    private boolean validationForDays(){
    boolean isChecked = true;
        if(releatedRecord.UL_Instore_End_days__c<releatedRecord.UL_Shipment_End_days__c ){
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Shipment End should be less than or equal to In-Store Duration ');
           ApexPages.addMessage(msg);
           isChecked  = false;
        }
        return isChecked ;
    }    
    
    private void mappingCustomer(){
        if(releatedRecord.UL_Planning_Level__c != null){
         List<UL_Planning_Level__c> planningRec = [Select id, UL_Customer__c from  UL_Planning_Level__c where id=:releatedRecord.UL_Planning_Level__c limit 1];
         releatedRecord.UL_Account__c= planningRec[0].UL_Customer__c ;
         }
    }
}