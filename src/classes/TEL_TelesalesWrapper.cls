public class TEL_TelesalesWrapper {
    
    // Wrapper class to display accounts.
    public class DisplayAccounts{
        
        @AuraEnabled public Boolean isSelected; 
        @AuraEnabled public String  accountId;
        @AuraEnabled public String 	accountName;
        @AuraEnabled public String 	accType;
        @AuraEnabled public String 	accSegment;
        @AuraEnabled public String 	accSubSegment;
        @AuraEnabled public Boolean hasAccCampaign; 	// Indicates if the account is related to campaign. 
        @AuraEnabled public String 	accountCampaign; 	// Indicates the name of campaign related to the account. 
        
        public DisplayAccounts(){
            isSelected 		= false;
            hasAccCampaign	= false;
        }
    }
    
    // Wrapper class to hold product data
    public class ProductInfo {
        
        @AuraEnabled public String  lostOrderMessage {get; set;}
        @AuraEnabled public String  opportunityId {get; set;}
        @AuraEnabled public String  productId {get; set;}
        @AuraEnabled public Boolean isSelected {get; set;}
        @AuraEnabled public String  name {get; set;}
        @AuraEnabled public String  price {get; set;}
        @AuraEnabled public Integer amount {get; set;}
        @AuraEnabled public String  campaignName {get; set;}
        @AuraEnabled public Boolean activeCampaign {get; set;}
        @AuraEnabled public String  lastOrderAmount {get; set;}
        @AuraEnabled public String  closeDate {get; set;}
        
    }
    
    // Wrapper class to display products info.
    public class DisplayProducts{
        
        @AuraEnabled public Boolean isSelected {get; set;}
        @AuraEnabled public String  productId;
        @AuraEnabled public String  productName;
        @AuraEnabled public String 	productFamily;
        @AuraEnabled public String  productCategory;
        @AuraEnabled public String 	productCode;
        
        // Handler account info related to OppGen component. 
        public DisplayProducts(){
            
            isSelected 		= false;
            productId	 	= '';
            productName 	= '';
            productFamily 	= '';
            productCategory = '';
            productCode		= '';
        }
    }
}