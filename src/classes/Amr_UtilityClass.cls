public with sharing class Amr_UtilityClass {
    

    public Amr_UtilityClass(){
       
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
        List<MDO_Category__c>   categoryLst = [select name from MDO_Category__c  where category_type__c = 'Category' ORDER BY Name limit 50000];
        
        Set<MDO_Category__c> categorySet = new Set<MDO_Category__c>();
        categorySet.addAll(categoryLst);
        return categorySet;
    }
    
}