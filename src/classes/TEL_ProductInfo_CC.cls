/**********************************************************************
Name: TEL_ProductInfo_CC
Copyright © 2016 Unilever

Purpose:
Handles retrieval of products and creation of new opportunity line 
items on current opportunity.

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Diego Maranhão  22/11/2016  Class creation  
***********************************************************************/
public with sharing class TEL_ProductInfo_CC {
    
    //Static variables
    private static Map<String, String> productsPricebookEntryIdsMap;
    
    //Returns current Opportunity object
    @AuraEnabled
    public static Opportunity getOpportunity(String oppId) {
        return TEL_ProductInfo_CC_DAO.getOpportunity(oppId);
    } 
    
    //Returns open order products as a wrapper list(TEL_TelesalesWrapper.ProductInfo)
    @AuraEnabled
    public static List<TEL_TelesalesWrapper.ProductInfo> getOpenOrderProducts(Opportunity oppObjParam) {
        TEL_OpenProductOrder prodOpenOrder = new TEL_OpenProductOrder(oppObjParam);
        return prodOpenOrder.createWrapperProducts();
    }
    
    //Returns released/transmitted opportunity line items as a wrapper list(TEL_TelesalesWrapper.ProductInfo)
    @AuraEnabled
    public static List<TEL_TelesalesWrapper.ProductInfo> getClosedOrderProducts(Opportunity oppObjParam) {
        TEL_ClosedProductOrder prodClosedOrder = new TEL_ClosedProductOrder(oppObjParam);
        return prodClosedOrder.createWrapperProducts();
    }
    
    //Returns closed lost opportunity message(No related products) as a wrapper list(TEL_TelesalesWrapper.ProductInfo)
    @AuraEnabled
    public static List<TEL_TelesalesWrapper.ProductInfo> getLostOrderProducts() {
        TEL_LostProductOrder prodLostOrder = new TEL_LostProductOrder();
        return prodLostOrder.getWrapperProduct();
    }
    
    //Returns list with all products available for current user
    @AuraEnabled
    public static List<TEL_TelesalesWrapper.ProductInfo> getFullProductsList(String oppId) {
        TEL_FullProductsList fullProdList = new TEL_FullProductsList(oppId);
        return fullProdList.createWrapperProducts();
    }   
    
    //Returns a wrapper list(TelesalesWrapper.ProductInfo) with only selected products
    @AuraEnabled
    public static List<TEL_TelesalesWrapper.ProductInfo> getSelectedItems(String productsJSONList) {
        List<TEL_TelesalesWrapper.ProductInfo> selectedProductsList = new List<TEL_TelesalesWrapper.ProductInfo>();
        
        if(!String.isBlank(productsJSONList)) {
            List<TEL_TelesalesWrapper.ProductInfo> productsList = (List<TEL_TelesalesWrapper.ProductInfo>) System.JSON.deserialize(productsJSONList, List<TEL_TelesalesWrapper.ProductInfo>.class);
            for(TEL_TelesalesWrapper.ProductInfo prod : productsList) {
                if(prod.isSelected) {
                    selectedProductsList.add(prod);    
                }
            }
        }
        
        return selectedProductsList;
    }
    
    //Creates the ordered products as new opportunity line items on current opportunity
    @AuraEnabled
    public static void createOrder(String orderedProductsJSONList) {
        List<OpportunityLineItem> orderedOppLineItemsList = new List<OpportunityLineItem>();        
        
        if(!String.isBlank(orderedProductsJSONList)) { 
            List<TEL_TelesalesWrapper.ProductInfo> orderedProductsList = (List<TEL_TelesalesWrapper.ProductInfo>) System.JSON.deserialize(orderedProductsJSONList, List<TEL_TelesalesWrapper.ProductInfo>.class); 
            OpportunityLineitem oppLineItem;
            productsPricebookEntryIdsMap = getProductPricebookEntryMap(TEL_ProductInfo_CC_DAO.getPricebookEntry(orderedProductsList.get(0).opportunityId, getProductsIds(orderedProductsList))); 
            
            for(TEL_TelesalesWrapper.ProductInfo prod : orderedProductsList) {
                oppLineItem = new OpportunityLineitem();
                oppLineItem.OpportunityId = prod.opportunityId;
                oppLineItem.PricebookEntryId = productsPricebookEntryIdsMap.get(prod.productId);
                oppLineItem.Quantity = prod.amount;
                oppLineItem.TotalPrice = !String.isBlank(prod.price) ? (Double.valueOf(prod.price) * prod.amount) : 0;
                oppLineItem.TEL_Associated_Campaigns__c = !String.isBlank(prod.campaignName) ? prod.campaignName : '';
                orderedOppLineItemsList.add(oppLineItem);
            }
            
            TEL_ProductInfo_CC_DAO.createOppLineItems(orderedOppLineItemsList);
            
            Opportunity objOpp = TEL_ProductInfo_CC_DAO.getOpportunity(orderedProductsList.get(0).opportunityId);
            objOpp.StageName = Label.TEL_OppStageReleased;
            TEL_ProductInfo_CC_DAO.updateOppStage(objOpp);
        }
    }
    
    //Returns a list of products ids
    private static List<String> getProductsIds(List<TEL_TelesalesWrapper.ProductInfo> orderedWrapperList) {
        List<String> ids = new List<String>();
        for(TEL_TelesalesWrapper.ProductInfo prod : orderedWrapperList) {
            ids.add(prod.productId);
        }
        
        return ids;
    }
    
    //Returns a map with product id as its key and pricebookentry as its value
    private static Map<String, String> getProductPricebookEntryMap(List<PricebookEntry> pbeList) {
        Map<String, String> prodPbeMap = new Map<String, String>();
        if(!pbeList.isEmpty()) {
            for(PricebookEntry pbe : pbeList) {
                prodPbeMap.put(pbe.Product2Id, pbe.Id);
            }
        }
        return prodPbeMap;
    }

}