public class VPM_GoldenDataController2 {

    public VPM_PurchasingRequests__c entity;
    //public VPM_PurchasingRequests__c pr{get;set;}
    public VPM_CommodityCode__c commodityCodeVar{get;set;}
    public VPM_PurchasingRequests__c purchReqVar{get;set;}   
   // public VPM_PurchasingRequests__c  vendorQuery{get;set;}
    public Id purid{get;set;}

    public VPM_GoldenDataController2(ApexPages.StandardController controller) {
        this.entity = (VPM_PurchasingRequests__c)controller.getRecord(); 
        purchReqVar = [SELECT Id, VPM_VendorType__c,VPM_TradePartnerType__c,VPM_Commodity__c , VPM_AdvancedFormSubmitted__c, VPM_FinanceApprovalRequired__c,
                      VPM_ProcurementApprovalRequired__c , VPM_Location__c, VPM_City__C,VPM_OrderingEmailAddress__c
                      from VPM_PurchasingRequests__c where Id =: entity.id];
        System.debug('@@purchReqVar ' + purchReqVar );      
        commodityCodeVar = [SELECT Id,VPM_Vendor_Type__c, VPM_Authorisation_Group__c from VPM_CommodityCode__c where id= :purchReqVar.VPM_commodity__c];
             
        purid = entity.id;
        
    }

     public void approvalMethod()
  {
      system.debug('@@pr.VPM_Location__c' + purchReqVar.VPM_Location__c) ;
      system.debug('@@pr.VPM_City__C' + purchReqVar.VPM_City__C) ;
        IF(string.isNotBlank(purchReqVar.VPM_Location__c) || string.isNotBlank(purchReqVar.VPM_City__C))
        {
          purchReqVar.VPM_AdvancedFormSubmitted__c='YES';  
          purchReqVar.VPM_FinanceApprovalRequired__c = true;
         }
      
      IF(string.isNotBlank(purchReqVar.VPM_OrderingEmailAddress__c) )
       {
          purchReqVar.VPM_AdvancedFormSubmitted__c='YES';  
          purchReqVar.VPM_ProcurementApprovalRequired__c = true;
         }
      
  }
    
    public PageReference saveRecord() {     
        System.debug('@@purchReqVar ' + purchReqVar );      
       system.debug('@@pr.VPM_Location__c' + purchReqVar.VPM_Location__c) ;
      system.debug('@@pr.VPM_City__C' + purchReqVar.VPM_City__C) ;
        /* comments  For new approval process */
        IF(string.isNotBlank(purchReqVar.VPM_Location__c) || string.isNotBlank(purchReqVar.VPM_City__C))
        {
          purchReqVar.VPM_AdvancedFormSubmitted__c='YES';  
          purchReqVar.VPM_FinanceApprovalRequired__c = true;
         }
      
      IF(string.isNotBlank(purchReqVar.VPM_OrderingEmailAddress__c) )
       {
          purchReqVar.VPM_AdvancedFormSubmitted__c='YES';  
          purchReqVar.VPM_ProcurementApprovalRequired__c = true;
         }
        IF((purchReqVar.VPM_VendorType__c)=='FRGT_Freight Vendor_G001')
        {
            purchReqVar.VPM_AdvancedFormSubmitted__c='YES'; 
            purchReqVar.VPM_FreightApprovalRequired__c=true;
        }
        else IF((purchReqVar.VPM_VendorType__c)=='RCT_Russian Customs Tax Vendor_G001')
        {
            purchReqVar.VPM_AdvancedFormSubmitted__c='YES'; 
            purchReqVar.VPM_RussianTaxApprovalRequired__c=true;
        }
        System.debug('@@purchReqVar ' + purchReqVar );  
        update commodityCodeVar;
       update purchReqVar;
       
       System.debug('@@purchReqVar ' + purchReqVar );   
       Pagereference pg =  new Pagereference('/'+entity.id); 
       pg.setRedirect(true);
       return pg;
    }
    
    public pagereference backToGoldenData1()
    {
    Pagereference pg =  new Pagereference('/apex/VPM_GoldenData1?id=' + entity.id); 
    pg.setRedirect(true);
    return pg;
    }
}