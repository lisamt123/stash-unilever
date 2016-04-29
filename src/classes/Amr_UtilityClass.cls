public with sharing class Amr_UtilityClass {
    
    public Map<String,Set<String>> categoryBrandPositionMap{get;set;}
    public Map<String,Set<String>> BrandPositionAndBrandMap{get;set;}
    
    public Amr_UtilityClass(){
        List<MDO_BrandPositions__c> brandPosLst = [select brand_id__r.name,brand_position_id__r.name,product_category_id__r.name from MDO_BrandPositions__c limit 50000];
        
        categoryBrandPositionMap = new map<String,Set<String>>();
        BrandPositionAndBrandMap = new map<String,Set<String>>();
        
        for(MDO_BrandPositions__c brandPostitionObj:brandPosLst){
            
            //Category and Brand Postion Map 
            if(!categoryBrandPositionMap.containsKey(brandPostitionObj.product_category_id__r.name) ){  
                 Set<String> BrandPostitionlst = new Set<String>();
                 BrandPostitionlst.add(brandPostitionObj.brand_position_id__r.name);
                 categoryBrandPositionMap.put(brandPostitionObj.product_category_id__r.name,BrandPostitionlst);
                
            }else{
                 Set<String> brandPos =  categoryBrandPositionMap.get(brandPostitionObj.product_category_id__r.name);
                 brandPos.add(brandPostitionObj.brand_position_id__r.name);
                 categoryBrandPositionMap.put(brandPostitionObj.product_category_id__r.name,brandPos);
                 
            }
            
            // band Postion and Brand Map
            String categoryBrandPositionValue = brandPostitionObj.brand_position_id__r.name +','+brandPostitionObj.product_category_id__r.name;
            if(!BrandPositionAndBrandMap.containsKey(categoryBrandPositionValue) ){ 
                 Set<String> BrandPostitionlst = new Set<String>();
                 BrandPostitionlst.add(brandPostitionObj.brand_id__r.name);
                 BrandPositionAndBrandMap.put(categoryBrandPositionValue,BrandPostitionlst);
                
            }else{
                 Set<String> brandPos =  BrandPositionAndBrandMap.get(categoryBrandPositionValue);
                 brandPos.add(brandPostitionObj.brand_id__r.name);
                 BrandPositionAndBrandMap.put(categoryBrandPositionValue,brandPos);
                
            }
            
        }
       
      
     
       
    }
    
    
    public Set<MDO_BrandPositions__c> brandPostitionValues(String Category){
    
        List<MDO_BrandPositions__c> brandPositionLst = [select brand_position_id__r.name,product_category_id__r.name from MDO_BrandPositions__c where product_category_id__r.name = :Category limit 50000];
        Set<MDO_BrandPositions__c> brandPostitionSet = new Set<MDO_BrandPositions__c>();
        
        brandPostitionSet.addAll(brandPositionLst);
        
        return brandPostitionSet;
    }
    
    public Set<MDO_BrandPositions__c> brandValues(String Category,String brandPosition){
        List<MDO_BrandPositions__c> brandValues = [select brand_id__r.name,brand_position_id__r.name,product_category_id__r.name from MDO_BrandPositions__c where brand_position_id__r.name = :brandPosition 
                                                   AND product_category_id__r.name =:Category limit 50000];
       Set<MDO_BrandPositions__c> brandSet = new Set<MDO_BrandPositions__c>();
       brandSet.addAll(brandValues);
       return brandSet;
    }
    
    public Set<MDO_Category__c> categoryValues(){
        List<MDO_Category__c>   categoryLst = [select name from MDO_Category__c ORDER BY Name limit 50000];
        
        Set<MDO_Category__c> categorySet = new Set<MDO_Category__c>();
        categorySet.addAll(categoryLst);
        return categorySet;
    }
    
}