/** 
    //S.M. 2016-03-12 - THIS CLASS IS NO LONGER USED!! 
    //Replaced as part of code refactoring

    About
    -----
    Description: Class Oblix_TR06SowMarketBrandPopulate
    Created for: Oblix Unilever Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : used as a fired class from Trigger  "Before insert, before update" to populate the correct Small and bug Category
                  		
            Functionnalities : 
                    
    Update History
    --------------    
*/ 
public with sharing class Oblix_TR06SowMarketBrandPopulate {
	
	//public static void PopulateBrandCategoriesforSOWHandler(Marketing_SOW__c sowTrigg, List<Marketing_SOW__c> lstMarketingSow){
	//	set<Id> setBrandsIds = new set<Id>();
	//	List<MDO_Brand__c> lstBrands = new List<MDO_Brand__c>();
	//	Map<Id, MDO_Category__c> MapBrandIdToCategory = new Map<Id, MDO_Category__c>();
		
		
	//	for(Marketing_SOW__c marketing : lstMarketingSow){
	//		if(marketing.Id == sowTrigg.Id){
	//			setBrandsIds.add(marketing.OblixBrand__c);
	//		}
	//	}
	//	List<MDO_CategoryBrands__c> lstBrandCategories = [Select Id, Name, brand_id__c, product_Category_Id__c, 
	//										product_Category_Id__r.parent_L2__c, product_Category_Id__r.Id
	//											from MDO_CategoryBrands__c where brand_id__c in : setBrandsIds];
	//	System.debug('###lstBrandCategories : '+lstBrandCategories);										
	//	if(!lstBrandCategories.isEmpty()){
	//		for(MDO_CategoryBrands__c categBrand : lstBrandCategories){
	//			if(!MapBrandIdToCategory.containsKey(categBrand.brand_id__c)){
	//				MapBrandIdToCategory.put(categBrand.brand_id__c, categBrand.product_Category_Id__r);
	//			}
	//		}	
	//	}
				
		
	//	for(Marketing_SOW__c market : lstMarketingSOW){
	//		if(market.Id == sowTrigg.Id){
	//			System.debug('###market : '+market);			
	//			if(MapBrandIdToCategory.get(market.OblixBrand__c) != null && market.BigOblixProductCategory__c == null && market.SmallProductCategory__c == null){
	//				System.debug('###MapBrandIdToCategory.get(market.OblixBrand__c) : '+MapBrandIdToCategory.get(market.OblixBrand__c));		
	//				market.BigOblixProductCategory__c = MapBrandIdToCategory.get(market.OblixBrand__c).parent_L2__c;
	//				market.SmallProductCategory__c = MapBrandIdToCategory.get(market.OblixBrand__c).Id;
 //               }else if (MapBrandIdToCategory.get(market.OblixBrand__c) == null){
	//				market.BigOblixProductCategory__c = null;
	//				market.SmallProductCategory__c  = null;
	//			}	
	//		}
			
	//	}
	//}
	
}