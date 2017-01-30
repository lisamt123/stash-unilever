/**********************************************************************
Name: TEL_OpenProductOrder
Copyright © 2016 Unilever

Purpose:
Handles Pending Call/Scheduled Opportunity products exhibition logic

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.0    Diego Maranhão  22/11/2016  Class creation  
***********************************************************************/
public with sharing class TEL_OpenProductOrder {
    
    //Variables
    private Opportunity oppObj;
    private List<TEL_Campaign_Products__c> activeCampaignsProductsList;
    private List<OpportunityLineItem> oppLineItemsList;
    private Map<String, String> productsPriceMap;
    private Map<String, String> productsCampaignsMap;
    public List<TEL_TelesalesWrapper.ProductInfo> productInfoWrapperList;
    
    //Constructor
    public TEL_OpenProductOrder(Opportunity oppObj) {
        this.oppObj = oppObj;
        productInfoWrapperList = new List<TEL_TelesalesWrapper.ProductInfo>();
        activeCampaignsProductsList = getCampaignIds(TEL_ProductInfo_CC_DAO.getAccountCampaigns(oppObj.AccountId));
        oppLineItemsList = getOppLineItems(TEL_ProductInfo_CC_DAO.getMostRecentOpportunity(oppObj.AccountId));
        this.productsPriceMap = getPrices();
        this.productsCampaignsMap = new Map<String, String>();
        getAllCampaigns();
    }
    
    //Checks which TEL_Campaign_Accounts__c from given List<TEL_Campaign_Accounts__c>
    //are active and returns a List<TEL_Campaign_Products__c> based on their ids
    @TestVisible private List<TEL_Campaign_Products__c> getCampaignIds(List<TEL_Campaign_Accounts__c> accountCampaignsListParam) {
        if(!accountCampaignsListParam.isEmpty()) {
            List<String> activeCampaignsIds = new List<String>();
            for(TEL_Campaign_Accounts__c accCamp : accountCampaignsListParam) {
                if(accCamp.TEL_Campaign__r.IsActive) {
                    activeCampaignsIds.add(accCamp.TEL_Campaign__c);
                }
            }
            return TEL_ProductInfo_CC_DAO.getActiveCampaignsProducts(activeCampaignsIds);
        } else {
            return new List<TEL_Campaign_Products__c>();
        }
    }
    
    //Retrieves and returns a List<OpportunityLineItem> based on given List<Opportunity> parameter
    @TestVisible private List<OpportunityLineItem> getOppLineItems(List<Opportunity> opportunityListParam) {
        if(!opportunityListParam.isEmpty()) {
            return TEL_ProductInfo_CC_DAO.getOppLineitems(opportunityListParam.get(0).Id);
        } else {
            return new List<OpportunityLineItem>();
        }
    }
    
    //Retrieves prices for both products with active campaigns List<TEL_Campaign_Products__c>
    //and opportunity line items List<OpportunityLineItem> and returns a Map<String, String>
    //with its key being the Product2 id and its value the product price
    @TestVisible private Map<String, String> getPrices() {
        List<String> productsIds = new List<String>();
        for(TEL_Campaign_Products__c campProd : activeCampaignsProductsList) {
            productsIds.add(campProd.TEL_Product_Name__c);
        }
        for(OpportunityLineItem oppLineItem : oppLineItemsList) {
            productsIds.add(oppLineItem.Product2Id);
        }
        
        Map<String, String> productsUnitPriceMap = new Map<String, String>();
        for(PricebookEntry pbEntry : TEL_ProductInfo_CC_DAO.getPrices(productsIds)) {
            productsUnitPriceMap.put(pbEntry.Product2Id, String.valueOf(pbEntry.UnitPrice));
        }
        
        return productsUnitPriceMap;
    }
    
    //Creates and returns a List<TEL_TelesalesWrapper.ProductInfo> based on
    //class variables activeCampaignsProductsList List<TEL_Campaign_Products__c> 
    //and oppLineItemsList List<OpportunityLineItem>  
    public List<TEL_TelesalesWrapper.ProductInfo> createWrapperProducts() {
        TEL_TelesalesWrapper.ProductInfo productInfoWrapper;
        
        for(TEL_Campaign_Products__c campProd : activeCampaignsProductsList) {
            if(checkCampaignDuplicity(productInfoWrapperList, campProd)) {
                productInfoWrapper = new TEL_TelesalesWrapper.ProductInfo();
                productInfoWrapper.opportunityId = oppObj.Id;
                productInfoWrapper.productId = campProd.TEL_Product_Name__c;
                productInfoWrapper.isSelected = true;
                productInfoWrapper.name = campProd.TEL_Product_Name__r.Name;
                productInfoWrapper.price = productsPriceMap.get(campProd.TEL_Product_Name__c);
                productInfoWrapper.amount = 0;
                productInfoWrapper.campaignName = productsCampaignsMap.get(campProd.TEL_Product_Name__c);
                productInfoWrapper.activeCampaign = true;
                productInfoWrapper.lastOrderAmount = checkLastOrderAmount(campProd);
                productInfoWrapper.closeDate = oppObj.CloseDate.day() + '/' + oppObj.CloseDate.month() + '/' + oppObj.CloseDate.year();
                productInfoWrapperList.add(productInfoWrapper);
            }
        }
        
        for(OpportunityLineItem oppLineItem : oppLineItemsList) {
            if(checkDuplicity(activeCampaignsProductsList, oppLineItem)) {
                productInfoWrapper = new TEL_TelesalesWrapper.ProductInfo();
                productInfoWrapper.opportunityId = oppObj.Id;
                productInfoWrapper.productId = oppLineItem.Product2Id;
                productInfoWrapper.isSelected = false;
                productInfoWrapper.name = oppLineItem.Product2.Name;
                productInfoWrapper.price = productsPriceMap.get(oppLineItem.Product2Id);
                productInfoWrapper.amount = 0;
                productInfoWrapper.activeCampaign = false;
                productInfoWrapper.lastOrderAmount = oppLineItem.Quantity > 0 ? '' + oppLineItem.Quantity : '';
                productInfoWrapper.closeDate = oppObj.CloseDate.day() + '/' + oppObj.CloseDate.month() + '/' + oppObj.CloseDate.year();
                productInfoWrapperList.add(productInfoWrapper);
            }
        }
        
        return productInfoWrapperList;
    }
    
    //Checks if given TEL_Campaign_Products__c was on last order and if so
    //returns the amount ordered
    @TestVisible private String checkLastOrderAmount(TEL_Campaign_Products__c campProdParam) {
        for(OpportunityLineItem oppLineItem : oppLineItemsList) {
            if(oppLineItem.Product2Id == campProdParam.TEL_Product_Name__c 
               && oppLineItem.Quantity > 0) 
            {
                return '' + opplineItem.Quantity;
            }
        }
        return '';
    }
    
    //Receives a List<TEL_TelesalesWrapper.ProductInfo> and a TEL_Campaign_Products__c and 
    //checks if the product was already created on given wrapper list so that no 
    //products with active campaigns gets duplicated
    @TestVisible private Boolean checkCampaignDuplicity(List<TEL_TelesalesWrapper.ProductInfo> wrapperList, TEL_Campaign_Products__c campProd) {
        for(TEL_TelesalesWrapper.ProductInfo wrapperProd : wrapperList) {
            if(campProd.TEL_Product_Name__c == wrapperProd.productId) 
            {
                return false;
            }
        }
        return true;
    }
    
    //Receives a List<TEL_Campaign_Products__c> and a OpportunityLineItem and 
    //checks if the product was already created on given list so that no 
    //products gets duplicated
    private Boolean checkDuplicity(List<TEL_Campaign_Products__c> campProdListParam, OpportunityLineItem oppLineItemParam) {
        for(TEL_Campaign_Products__c campProdItem : campProdListParam) {
            if(oppLineItemParam.Product2Id == campProdItem.TEL_Product_Name__c) 
            {
                return false;
            }
        }
        return true;
    }
    
    //Concats, if there's more than one, all the campaign names for each product
    //populating a Map<String String> productsCampaignsMap with its key being the
    //product id and its value the concatenation
    @TestVisible private void getAllCampaigns() {
        String value;
        for(TEL_Campaign_Products__c campProd : activeCampaignsProductsList) {
            if(productsCampaignsMap.containsKey(campProd.TEL_Product_Name__c)) {
                value = productsCampaignsMap.get(campProd.TEL_Product_Name__c);
                value += '\n';
                value += campProd.TEL_Campaign__r.Name;
                productsCampaignsMap.put(campProd.TEL_Product_Name__c, value);
            } else {
                productsCampaignsMap.put(campProd.TEL_Product_Name__c, campProd.TEL_Campaign__r.Name);
            }
        }
    }
    
}