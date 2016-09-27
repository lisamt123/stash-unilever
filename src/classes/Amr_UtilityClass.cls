public with sharing class Amr_UtilityClass {
    

    public Amr_UtilityClass(){
       
    }
    
    
/*  public Set<MDO_BrandPositions__c> brandPostitionValues(String Category){
    
        List<MDO_BrandPositions__c> brandPositionLst = [select brand_position_id__r.name,product_category_id__r.name from MDO_BrandPositions__c where product_category_id__r.name = :Category limit 50000];
        Set<MDO_BrandPositions__c> brandPostitionSet = new Set<MDO_BrandPositions__c>();
        
        brandPostitionSet.addAll(brandPositionLst);
        
        return brandPostitionSet;
    } */

    public Set<MDO_BrandPosition__c> brandPostitionValues(String Category){
    
        List<MDO_BrandPosition__c> brandPositionLst = [Select id, name from MDO_BrandPosition__c where id in (select brand_position_id__c from MDO_BrandPositions__c where product_category_id__c in: Category and status__c = 'Active') and status__c = 'Active' limit 50000];
        Set<MDO_BrandPosition__c> brandPostitionSet = new Set<MDO_BrandPosition__c>();
        
        brandPostitionSet.addAll(brandPositionLst);
        
        return brandPostitionSet;
    }


    
 /* public Set<MDO_BrandPositions__c> brandValues(String Category,String brandPosition){
        List<MDO_BrandPositions__c> brandValues = [select brand_id__r.name,brand_position_id__r.name,product_category_id__r.name from MDO_BrandPositions__c where brand_position_id__r.name = :brandPosition AND product_category_id__r.name =:Category limit 50000];
        Set<MDO_BrandPositions__c> brandSet = new Set<MDO_BrandPositions__c>();
        brandSet.addAll(brandValues);
        return brandSet;
    } */

    public Set<MDO_Brand__C> brandValues(String brandPosition){
        List<MDO_Brand__C> brandValues = [select id,name from MDO_Brand__C where id in (select brand_id__c from MDO_BrandPositions__c where brand_position_id__c =:brandPosition and status__c = 'Active' ) and status__c = 'Active' limit 50000];
        Set<MDO_Brand__C> brandSet = new Set<MDO_Brand__C>();
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