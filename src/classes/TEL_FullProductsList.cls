public with sharing class TEL_FullProductsList {
    
    private Map<String, TEL_TelesalesWrapper.ProductInfo> productsMap;
    private Map<String, String> productsPriceMap;
    private List<String> productsIdsList;
    private List<Product2> productsList;
    private String oppId;
    
    public TEL_FullProductsList(String oppId) {
        this.oppId = oppId;
        this.productsList = [SELECT Id, Name, Family FROM Product2 LIMIT 1000];
        this.productsIdsList = createProductsIdsList();
        this.productsPriceMap = getPrices();
    }
    
    private List<String> createProductsIdsList() {
        List<String> ids = new List<String>();
        for(Product2 prod : productsList) {
            ids.add(prod.Id);
        }
        
        return ids;
    }
    
    private Map<String, String> getPrices() {
        Map<String, String> productsUnitPriceMap = new Map<String, String>();
        for(PricebookEntry pbEntry : TEL_ProductInfo_CC_DAO.getPrices(productsIdsList)) {
            productsUnitPriceMap.put(pbEntry.Product2Id, String.valueOf(pbEntry.UnitPrice));
        }
        
        return productsUnitPriceMap;
    }
    
    public List<TEL_TelesalesWrapper.ProductInfo> createWrapperProducts() {
        List<TEL_TelesalesWrapper.ProductInfo> productInfoWrapperList = new List<TEL_TelesalesWrapper.ProductInfo>();
        TEL_TelesalesWrapper.ProductInfo productInfoWrapper;
        
        for(Product2 prod : productsList) {
            productInfoWrapper = new TEL_TelesalesWrapper.ProductInfo();
            productInfoWrapper.opportunityId = this.oppId;
            productInfoWrapper.productId = prod.Id;
            productInfoWrapper.isSelected = false;
            productInfoWrapper.name = prod.Name;
            productInfoWrapper.price = this.productsPriceMap.get(prod.Id);
            productInfoWrapper.amount = 0;
            productInfoWrapper.campaignName = '';
            productInfoWrapper.activeCampaign = false;
            productInfoWrapper.lastOrderAmount = '';
            productInfoWrapper.closeDate = '';
            productInfoWrapperList.add(productInfoWrapper);
        }
        
        return productInfoWrapperList;
    }
    
}