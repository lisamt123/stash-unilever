public with sharing class BrandCategoryController_anjali {
	
	public Map<String,Set<String>> categoryBrandPositionMap{get;set;}
	public Map<String,Set<String>> BrandPositionAndBrandMap{get;set;}
	
	public BrandCategoryController_anjali(){
		List<MDO_BrandPositions__c>	brandPosLst = [select brand_id__r.name,brand_position_id__r.name,product_category_id__r.name from MDO_BrandPositions__c];
		
		categoryBrandPositionMap = new map<String,Set<String>>();
		BrandPositionAndBrandMap = new map<String,Set<String>>();
		
		for(MDO_BrandPositions__c brandPostitionObj:brandPosLst){
			
			//Category and Brand Postion Map 
			if(!categoryBrandPositionMap.containsKey(brandPostitionObj.product_category_id__r.name) ){	
				 Set<String> BrandPostitionlst = new Set<String>();
				 BrandPostitionlst.add(brandPostitionObj.brand_position_id__r.name);
				 categoryBrandPositionMap.put(brandPostitionObj.product_category_id__r.name,BrandPostitionlst);
				 system.debug('brand inside if'+brandPostitionObj.product_category_id__r.name);
			}else{
				 Set<String> brandPos =  categoryBrandPositionMap.get(brandPostitionObj.product_category_id__r.name);
				 brandPos.add(brandPostitionObj.brand_position_id__r.name);
				 categoryBrandPositionMap.put(brandPostitionObj.product_category_id__r.name,brandPos);
				 system.debug('brand inside else'+brandPostitionObj.product_category_id__r.name);
			}
			
			// band Postion and Brand Map
			if(!BrandPositionAndBrandMap.containsKey(brandPostitionObj.brand_position_id__r.name) ){	
				 Set<String> BrandPostitionlst = new Set<String>();
				 BrandPostitionlst.add(brandPostitionObj.brand_id__r.name);
				 BrandPositionAndBrandMap.put(brandPostitionObj.brand_position_id__r.name,BrandPostitionlst);
				 system.debug('brand inside if'+brandPostitionObj.brand_position_id__r.name);
			}else{
				 Set<String> brandPos =  BrandPositionAndBrandMap.get(brandPostitionObj.brand_position_id__r.name);
				 brandPos.add(brandPostitionObj.brand_id__r.name);
				 BrandPositionAndBrandMap.put(brandPostitionObj.brand_position_id__r.name,brandPos);
				 system.debug('brand inside else'+brandPostitionObj.brand_position_id__r.name);
			}
			
		}
	   
	   system.debug('===>map'+categoryBrandPositionMap);
	   system.debug('===>map===>'+BrandPositionAndBrandMap);
	   
	}
	
}