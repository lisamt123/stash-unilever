public class ICB_Wrapper_Cockpit_CC {
    
    @AuraEnabled
    public Contact contactItem;
    
    @AuraEnabled
    public Opportunity oppItem;
    
    @AuraEnabled
    public OpportunityLineItem oppLineItem;
    
    @AuraEnabled
    public ICB_Inventory_Line_Item__c invetoryItem;
    
    @AuraEnabled
    public Boolean checkButton;
    
    @AuraEnabled
    public Boolean check;
    
    @AuraEnabled
    public Integer quantity = 0;
    
    @AuraEnabled
    public Decimal quantityIce;
    
    @AuraEnabled
    public Integer quantityMin;
    
    @AuraEnabled
    public Integer quantityReturned = 0;
    
    @AuraEnabled
    public String urlImage;
    
    @AuraEnabled
    public Boolean isDisabled = true;
}