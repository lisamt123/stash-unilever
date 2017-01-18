/**********************************************************************  
Name:  Amr_UtilityClass_CC Copyright © 2015  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------   This is a utility class for AdManager Controller to get 
            MDO and Multi category/Brnad Poition/Brand data                                                       
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION   AUTHOR                        DATE              DETAIL                    Description    
 1.0       Mindtree                  04/02/2016      INITIAL DEVELOPMENT            CSR: 
 ***********************************************************************/
public with sharing class Amr_UtilityClass {
    

    public Amr_UtilityClass(){
       
    }
    
    
/*  public Set<MDO_BrandPositions__c> brandPostitionValues(String Category){
    
        List<MDO_BrandPositions__c> brandPositionLst = [select brand_position_id__r.name,product_category_id__r.name from MDO_BrandPositions__c where product_category_id__r.name = :Category limit 50000];
        Set<MDO_BrandPositions__c> brandPostitionSet = new Set<MDO_BrandPositions__c>();
        
        brandPostitionSet.addAll(brandPositionLst);
        
        return brandPostitionSet;
    } */

/*******************************************************************    
Purpose:  This method is used to get all MDO Brand Position list                                        
Parameters: brandPostitionValues(String)
Returns: It returns MDO Brand Position set data
********************************************************************/  
    public Set<MDO_BrandPosition__c> brandPostitionValues(String Category){
        
        Set<String> categoryAndSubs = subCategoriesForGivenCategory(category);
        List<MDO_BrandPosition__c> brandPositionLst = [Select id, name from MDO_BrandPosition__c where id in (select brand_position_id__c from MDO_BrandPositions__c where product_category_id__c in:categoryAndSubs and status__c = 'Active') and status__c = 'Active' order by name asc];
        Set<MDO_BrandPosition__c> brandPostitionSet = new Set<MDO_BrandPosition__c>();
        
        brandPostitionSet.addAll(brandPositionLst);
        
        return brandPostitionSet;
    }

    public static Set<String> subCategoriesForGivenCategory(String subcategory){
        
        Set<String> subcategories = new Set<String>{};
        if(!String.isBlank(subcategory)) {

            List<MDO_Category__c> subcategoryid = [select id from MDO_Category__c  where name =:subcategory ORDER BY Name limit 50000];
            
            List<MDO_Category__c> firsAndSecondSublevels = [select id from MDO_Category__c where (parent_id__r.parent_id__c =:subcategoryid and parent_id__r.parent_id__r.status__c = 'Active') or (parent_id__c =: subcategoryid and parent_id__r.status__c = 'Active')];
            subcategories.add(subcategory);
            for(MDO_Category__c cat : firsAndSecondSublevels){
                subcategories.add(cat.id);
            }
        }
        
        return subcategories;
    }
    
 /* public Set<MDO_BrandPositions__c> brandValues(String Category,String brandPosition){
        List<MDO_BrandPositions__c> brandValues = [select brand_id__r.name,brand_position_id__r.name,product_category_id__r.name from MDO_BrandPositions__c where brand_position_id__r.name = :brandPosition AND product_category_id__r.name =:Category limit 50000];
        Set<MDO_BrandPositions__c> brandSet = new Set<MDO_BrandPositions__c>();
        brandSet.addAll(brandValues);
        return brandSet;
    } */

/*******************************************************************    
Purpose:  This method is used to get all MDO Brand list based on selected Category and Brnad Position                                       
Parameters: brandValues(String, String)
Returns: It returns MDO Brand set data
********************************************************************/  
    public Set<MDO_Brand__C> brandValues(String Category,String brandPosition){

        List<String> brandposlist = new List<String>();
        List<MDO_BrandPosition__c> brandPositionid = [SELECT Id FROM MDO_BrandPosition__c WHERE Name =:brandPosition ORDER BY Name limit 50000];
        for(MDO_BrandPosition__c bp : brandPositionid){
            brandposlist.add(bp.id);
        }
        List<String> brandlist = new List<String>();
        List<MDO_BrandPositions__c> brandid =[select brand_id__c from MDO_BrandPositions__c where brand_position_id__c in :brandposlist and status__c = 'Active'];
        for(MDO_BrandPositions__c bps : brandid){
            brandlist.add(bps.brand_id__c);
        }
        List<MDO_Brand__C> brandValues = [select id,name from MDO_Brand__C where id in :brandlist and status__c = 'Active' limit 50000];
        Set<MDO_Brand__C> brandSet = new Set<MDO_Brand__C>();
        brandSet.addAll(brandValues);
        return brandSet;
    }

/*******************************************************************    
Purpose:  This method is used to get all MDO Category list                                        
Parameters: categoryValues(void)
Returns: It returns MDO Category set data
********************************************************************/        
    public Set<MDO_Category__c> categoryValues(){
        List<MDO_Category__c>   categoryLst = [select name from MDO_Category__c  where category_type__c = 'Category' ORDER BY Name limit 50000];
        
        Set<MDO_Category__c> categorySet = new Set<MDO_Category__c>();
        categorySet.addAll(categoryLst);
        return categorySet;
    }
    
    
// Multi Category start
/*******************************************************************    
Purpose:  This method is used to get all Multi brand position list                                        
Parameters: multiBrandPostitionValues(string)
Returns: It returns multi category set data
********************************************************************/     
    public Set<Amr_Multi_Brand_Positioning__c> multiBrandPostitionValues(String Category){
        
        Set<String> categoryAndSubs = multiSubCategoriesForGivenCategory(category);
        List<Amr_Multi_Brand_Positioning__c> brandPositionLst = [Select id, name from Amr_Multi_Brand_Positioning__c where id in (select Multi_Brand_Positioning__c from Amr_Multi_Brand_Positions__c where Multi_Category__c = :categoryAndSubs and status__c = 'Active') and status__c = 'Active' order by name asc];
        Set<Amr_Multi_Brand_Positioning__c> brandPostitionSet = new Set<Amr_Multi_Brand_Positioning__c>();
        
        brandPostitionSet.addAll(brandPositionLst);
        
        return brandPostitionSet;
    }

/*******************************************************************    
Purpose:  This method is used to get all Multi brand position list                                        
Parameters: multiBrandPostitionValues(string)
Returns: It returns multi category set data
********************************************************************/     
    public static Set<String> multiSubCategoriesForGivenCategory(String subcategory){
        
        Set<String> subcategories = new Set<String>{};
        if(!String.isBlank(subcategory)) {

            List<Amr_Multi_Category__c> categoryid = [select id from Amr_Multi_Category__c  where name =:subcategory and status__c = 'Active'];
            for(Amr_Multi_Category__c cat : categoryid ){
                subcategories.add(cat.id);
            }
        }
        return subcategories;
    }
   
/*******************************************************************    
Purpose:  This method is used to get all Multi Brand list                                        
Parameters: multiBrandValues(string, string)
Returns: It returns multi brand set data
********************************************************************/        
    public Set<Amr_Multi_Brand__c> multiBrandValues(String Category,String brandPosition){
        
        Set<String> subcategories = multiSubCategoriesForGivenCategory(Category);
        
        List<String> brandposlist = new List<String>();
        List<Amr_Multi_Brand_Positioning__c> brandPositionid = [SELECT Id FROM Amr_Multi_Brand_Positioning__c WHERE Name =:brandPosition ORDER BY Name limit 50000];
        for(Amr_Multi_Brand_Positioning__c bp : brandPositionid){
            brandposlist.add(bp.id);
        }
        
       
        List<String> brandlist = new List<String>();
        List<Amr_Multi_Brand_Positions__c> brandid =[select Multi_Brand__c from Amr_Multi_Brand_Positions__c where Multi_Brand_Positioning__c in :brandposlist and Multi_Category__c in :subcategories and status__c = 'Active'];
        for(Amr_Multi_Brand_Positions__c bps : brandid){
            brandlist.add(bps.Multi_Brand__c);
        }
        List<Amr_Multi_Brand__C> brandValues = [select id,name from Amr_Multi_Brand__c where id in :brandlist and status__c = 'Active'];
        Set<Amr_Multi_Brand__C> brandSet = new Set<Amr_Multi_Brand__C>();
        if(brandValues != NULL ){
        brandSet.addAll(brandValues);
        }
        return brandSet;
    }
    
/*******************************************************************    
Purpose:  This method is used to get all Multi category list                                        
Parameters: multiCategoryValues(void)
Returns: It returns multi category set data
********************************************************************/     
    public Set<Amr_Multi_Category__c> multiCategoryValues(){
        List<Amr_Multi_Category__c>   categoryLst = [select name from Amr_Multi_Category__c where status__c = 'Active' ORDER BY Name];
        
        Set<Amr_Multi_Category__c> categorySet = new Set<Amr_Multi_Category__c>();
        if(categoryLst != NULL){
            categorySet.addAll(categoryLst);
         }
        return categorySet;
    }
    
}