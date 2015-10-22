public with sharing class Oblix_TR06SowMarketBrandPopulate {
	
	public static void PopulateBrandCategoriesforSOW(List<Marketing_SOW__c> lstMarketingSow){
		set<Id> setBrandsIds = new set<Id>();
		List<MDO_Brand__c> lstBrands = new List<MDO_Brand__c>();
		Map<Id, MDO_Category__c> MapBrandIdToCategory = new Map<Id, MDO_Category__c>();
		
		
		for(Marketing_SOW__c marketing : lstMarketingSow){
			setBrandsIds.add(marketing.OblixBrand__c);
		}
		List<MDO_CategoryBrands__c> lstBrandCategories = [Select Id, Name, brand_id__c, product_Category_Id__c, 
											product_Category_Id__r.parent_L3__c, product_Category_Id__r.parent_L5__c   
												from MDO_CategoryBrands__c where brand_id__c in : setBrandsIds];
		if(lstBrandCategories.size()>0){
			for(MDO_CategoryBrands__c categBrand : lstBrandCategories){
				if(!MapBrandIdToCategory.containsKey(categBrand.brand_id__c)){
					MapBrandIdToCategory.put(categBrand.brand_id__c, categBrand.product_Category_Id__r);
				}
			}	
		}
				
		
		for(Marketing_SOW__c market : lstMarketingSOW){
			if(MapBrandIdToCategory.get(market.OblixBrand__c)!= null){
				market.BigOblixProductCategory__c = MapBrandIdToCategory.get(market.OblixBrand__c).parent_L3__c;
				market.SmallProductCategory__c = MapBrandIdToCategory.get(market.OblixBrand__c).parent_L5__c;
			}else{
				market.BigOblixProductCategory__c = null;
				market.SmallProductCategory__c  = null;
			}
		}
		
		
	}
}