/**********************************************************************
Name: TEL_ClosedProductOrder
Copyright © 2016 Unilever

Purpose:
Handles Released/Transmitted opportunities

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Diego Maranhão  22/11/2016  Class creation  
***********************************************************************/
public with sharing class TEL_ClosedProductOrder {
    
    //Variables
    private List<OpportunityLineItem> oppLineItemsList;
    
    //Constructor
    //Populates oppLineItemsList based on given Opportunity
    public TEL_ClosedProductOrder(Opportunity oppObj) {
        this.oppLineItemsList = TEL_ProductInfo_CC_DAO.getOppLineitems(oppObj.Id);
    }
    
    //Creates List<TEL_TelesalesWrapper.ProductInfo> based on current opportunity line items
    public List<TEL_TelesalesWrapper.ProductInfo> createWrapperProducts() {
        List<TEL_TelesalesWrapper.ProductInfo> wrapperProdList = new List<TEL_TelesalesWrapper.ProductInfo>();
        TEL_TelesalesWrapper.ProductInfo wrapperProd;
        
        for(OpportunityLineItem oli : this.oppLineItemsList) {
            wrapperProd = new TEL_TelesalesWrapper.ProductInfo();
            wrapperProd.name = oli.Product2.Name;
            wrapperProd.amount = Integer.valueOf(oli.Quantity);
            wrapperProd.price = String.valueOf(oli.UnitPrice);
            wrapperProd.campaignName = oli.TEL_Associated_Campaigns__c;
            wrapperProdList.add(wrapperProd);
        }
        
        return wrapperProdList;
    }
}