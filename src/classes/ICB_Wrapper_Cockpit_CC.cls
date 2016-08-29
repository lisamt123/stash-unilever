/**********************************************************************
Name: ICB_Wrapper_Cockpit_CC
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Wrapper class for lightning component ICB_Cockpit And ICB_CloseSale
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.0    	Antonio Raul 	09/08/2016  Class creation 
***********************************************************************/
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
    public Decimal quantityIce = 0;
    
    @AuraEnabled
    public Integer quantityMin = 0;
    
    @AuraEnabled
    public Integer quantityReturned = 0;
    
    @AuraEnabled
    public Decimal quantityTotal = 0;
    
    @AuraEnabled
    public String urlImage;
    
    @AuraEnabled
    public Boolean isDisabled = true;
}