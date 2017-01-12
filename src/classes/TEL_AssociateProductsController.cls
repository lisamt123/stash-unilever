public class TEL_AssociateProductsController {
    
    // Static Resources 
    private static Id 		CONST_PRODUCT_RECORD_TYPE; // Store the opportunity Telesales recordtype id.
    
    static{
        CONST_PRODUCT_RECORD_TYPE 	= ICB_RecordTypeMemory.getRecType('TEL_Campaign_Products__c', 'TEL_Telesales_Campaign_Product');
    }
    
    // Retrieve the products based on search param. 
    @AuraEnabled
    public static List<TEL_TelesalesWrapper.DisplayProducts> retrieveProducts(String family, Id campaignId){
        
        System.debug('Valor do family: '+family);
        System.debug('Valor do campaignId: '+campaignId);
        
        List<TEL_TelesalesWrapper.DisplayProducts> 	lstProducts 			= new List<TEL_TelesalesWrapper.DisplayProducts>(); // Wrapper list to return the search result. 
        List<Product2> 								lstProductsRetrieved 	= TEL_Product2DAO.getInstance().getActiveProductsByFamily(family, true); // Store the retrieved products wich will be used to link to campaign. 
        List<TEL_Campaign_Products__c> 				lstProductRelated		= TEL_CampaignProductDAO.getInstance().getCampaignProduct(campaignId); // Store the campaign product related to the campaign ID. 
        
        System.debug('Valor da lista lstProductsRetrieved: '+lstProductsRetrieved);
        System.debug('Valor da lista lstProductRelated: '+lstProductRelated);
        
        // Store the campaign products already linked to the campaign.  
        map<String, String> 						mapCampaignProducts 	= retrieveProductMap(lstProductRelated);
        
        System.debug('Valor da lista mapCampaignProducts: '+mapCampaignProducts);
        
        // Check if the account list return value. 
        if(lstProductsRetrieved != null && lstProductsRetrieved.size() > 0){
            for(Product2 prd : lstProductsRetrieved){
                if(!mapCampaignProducts.containskey(prd.Id)){
                    TEL_TelesalesWrapper.DisplayProducts prdDisplayed = new TEL_TelesalesWrapper.DisplayProducts();
                    prdDisplayed.productId 		= prd.Id;
                    prdDisplayed.productName	= prd.Name;
                    prdDisplayed.productFamily	= prd.Family;
                    prdDisplayed.productCode	= prd.ProductCode;
                    
                    lstProducts.add(prdDisplayed);
                }
            }
        }
        
        System.debug('Valor da lista lstProducts: '+lstProducts);
        return lstProducts; 
    }
    
    // Make the link between the campaign and related products. 
    @AuraEnabled
    public static void createPrdCampaign(String prdSelected, Id campaignId){
        System.debug('Valor da campaignId: '+campaignId);
        // Verify if there are account selected. 
        if(!string.isBlank(prdSelected)){
            
            List<TEL_TelesalesWrapper.DisplayProducts> 	lstProducts = (List<TEL_TelesalesWrapper.DisplayProducts>)System.JSON.deserialize(prdSelected, List<TEL_TelesalesWrapper.DisplayProducts>.class);
            List<TEL_Campaign_Products__c> 		    lstPrdCgn   = new List<TEL_Campaign_Products__c>();
            
            //Create an product campaign for each product selected. 
            for(TEL_TelesalesWrapper.DisplayProducts prd : lstProducts){
                if(prd.isSelected){
                    TEL_Campaign_Products__c 	cprd 	= new TEL_Campaign_Products__c();
                    cprd.TEL_Product_Name__c   			= prd.productId;
                    cprd.TEL_Campaign__c	 			= campaignId;
                    cprd.RecordTypeId				    = CONST_PRODUCT_RECORD_TYPE;
                    
                    lstPrdCgn.add(cprd);
                }
            }
            Database.upsert(lstPrdCgn);
        }
    }
    
    // Set the products used in the campaign products. 
    private static Map<String, String> retrieveProductMap(List<TEL_Campaign_Products__c> lstCampaignProduct) {
        
        // Store product ID retrieved to be used on campaign or products lists. 
        Map<String, String> mapProducts = new Map<String, String>();
        
        for(TEL_Campaign_Products__c cp : lstCampaignProduct) {
            mapProducts.put(cp.TEL_Product_Name__c, cp.TEL_Product_Name__c);
        }   
        
        return mapProducts;
    }
    
}