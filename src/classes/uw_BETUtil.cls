/**********************************************************************
Name: uw_BETUtil
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Class is a placeholder for helper methods in BET application
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol          	01/12/2014     	INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class uw_BETUtil {
	//available search types in applications
	public static final String brandSearch='brandSearch';
	public static final String categorySearch='categorySearch';
	public static final String keywordSearch='keywordSearch';

	/*******************************************************************
	Purpose: Method return filters for bet used in search page  
	Parameters: [String,String]
	Returns: [String]
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static List<uw_BETWrapper.FilterLineItemWrapper> getFiltersForBet(String brandId, String categoryId){
        List<uw_BETWrapper.FilterLineItemWrapper> filterInfoList = new List<uw_BETWrapper.FilterLineItemWrapper>();
        
        List<uw_BETWrapper.FilterOptions> categoryFilterOptions=new List<uw_BETWrapper.FilterOptions>();
        categoryFilterOptions.add(new uw_BETWrapper.FilterOptions('','Clear filter'));

        Map<String,String> mapOfUniqCat = new Map<String,String>();
        for(BET_Category_Brands__c cat : [SELECT BET_Category__r.Name,BET_Category__c FROM BET_Category_Brands__c WHERE BET_Category__r.BET_Parent_Category__c != null ORDER BY BET_Category__r.Name ASC]){
            if(!mapOfUniqCat.containsKey(cat.BET_Category__c)){
                categoryFilterOptions.add(new uw_BETWrapper.FilterOptions(cat.BET_Category__c,cat.BET_Category__r.Name));
                mapOfUniqCat.put(cat.BET_Category__c,cat.BET_Category__r.Name);
            }    
        }        

        String categoriesSelectedValue = categoryId == null ? '' : categoryId;
        filterInfoList.add(new uw_BETWrapper.FilterLineItemWrapper('Categories', false,categoryFilterOptions,categoriesSelectedValue));
            
        List<uw_BETWrapper.FilterOptions> brandFilterOptions=new List<uw_BETWrapper.FilterOptions>();
        brandFilterOptions.add(new uw_BETWrapper.FilterOptions('','Clear filter'));

        Map<String,String> mapOfUniqBrand = new Map<String,String>();
        if(categoryId != null && categoryId != ''){
            //use where clause only when brandId is selected
            for(BET_Category_Brands__c brand: [SELECT BET_Brand__r.Name, BET_Brand__c from BET_Category_Brands__c where BET_Category__c = :categoryId ORDER BY BET_Brand__r.Name asc]){
                if(!mapOfUniqBrand.containsKey(brand.BET_Brand__c)){
                    brandFilterOptions.add(new uw_BETWrapper.FilterOptions(brand.BET_Brand__c,brand.BET_Brand__r.Name));
                    mapOfUniqBrand.put(brand.BET_Brand__c,brand.BET_Brand__r.Name);
                }
            }
        }
 
        String brandsSelectedValue = brandId == null ? '' : brandId;
        filterInfoList.add(new uw_BETWrapper.FilterLineItemWrapper('Brands', false,brandFilterOptions,brandsSelectedValue));
                    
        return filterInfoList;
    }

    /*******************************************************************
    Purpose: Method return filters for assets used in detail page  
    Parameters: [String, String, String]
    Returns: [List<uw_BETWrapper.FilterLineItemWrapper>]
    Throws [Exceptions]: [optional] 
    ********************************************************************/
    public static List<uw_BETWrapper.FilterLineItemWrapper> getFiltersForAsset(String mediaType, String country, String subFunctionType){
        List<uw_BETWrapper.FilterLineItemWrapper> filterInfoList = new List<uw_BETWrapper.FilterLineItemWrapper>();
        
        List<uw_BETWrapper.FilterOptions> mediaTypesFilterOptions = new List<uw_BETWrapper.FilterOptions>();
        mediaTypesFilterOptions.add(new uw_BETWrapper.FilterOptions('','All Media Types'));

        Schema.DescribeFieldResult fieldMediaType = uw_Asset__c.Media_Type__c.getDescribe();
        for(Schema.PicklistEntry f : fieldMediaType.getPicklistValues()) {
            if( !(subFunctionType == 'Brand Building' && f.getValue() == 'BET Presentation') ){
                mediaTypesFilterOptions.add(new uw_BETWrapper.FilterOptions(f.getValue(),f.getLabel()));
            }                         
        }
        String mediaTypesSelectedValue = mediaType == null ? '' : mediaType;
        filterInfoList.add(new uw_BETWrapper.FilterLineItemWrapper('MediaTypes', false,mediaTypesFilterOptions,mediaTypesSelectedValue));

        List<uw_BETWrapper.FilterOptions> countriesFilterOptions = new List<uw_BETWrapper.FilterOptions>();
        countriesFilterOptions.add(new uw_BETWrapper.FilterOptions('','All Countries'));

        Schema.DescribeFieldResult fieldCountries = uw_Asset__c.Country__c.getDescribe();
        for(Schema.PicklistEntry f : fieldCountries.getPicklistValues()) {
            countriesFilterOptions.add(new uw_BETWrapper.FilterOptions(f.getValue(),f.getLabel()));             
        }
        String countriesTypesSelectedValue = country == null ? '' : country;
        filterInfoList.add(new uw_BETWrapper.FilterLineItemWrapper('Countries', false,countriesFilterOptions,countriesTypesSelectedValue));      
                    
        return filterInfoList;
    }

    public static uw_BET__c moveComponentDataToBET(uw_BET__c bet,BET_CategoryComponentData compData){
        System.debug('Entering moveComponentDataToBET : ' + bet + ', ' + compData);
        bet.Inoplan_Project__c = compData.inoplanProject;
        bet.IPM_Project__c = compData.impProject;
        bet.Category_Group__c = compData.categoryGroup;
        bet.Product_Category__c = compData.category;
        bet.Brand_Position__c = compData.brandpositioning;
        bet.Product_Brand__c = compData.brand;
        return bet;
    }

    public static List<String> validateBET(uw_BET__c betObject){
        List<String> errors = new List<String>();
        
        if(String.isBlank(betObject.name)) errors.add(Label.BET_BetNameMandatory);
        if(String.isBlank(betObject.Category_Group__c)) errors.add(Label.BET_BetCategoryGroupMandatory);
        if(String.isBlank(betObject.Product_Category__c)) errors.add(Label.BET_BetCategoryMandatory);
        if(String.isBlank(betObject.Brand_Position__c)) errors.add(Label.BET_BetBrandPositionMandatory);
        
        return errors;
    }

    /*******************************************************************
	Purpose: Method resposible for paging search results 
    used for reports porpouse
	Parameters: [List<uw_BETWrapper.BetSearchItem> searchResults, Integer pageSize,Integer pageNumber]
	Returns: []
	Throws [Exceptions]: [optional] 
	********************************************************************/
    //public static List<uw_BETWrapper.BetSearchItem> getResultsForPage(List<uw_BETWrapper.BetSearchItem> searchResults, Integer pageSize,Integer pageNumber){
    //    System.Debug('*** BET getResultsForPage input parameter pageSize: ' + pageSize +' pageNumber: ' +pageNumber);
    //    if(!searchResults.isEmpty()){
    //        if(pageNumber<1){
    //            //set page on first page
    //            pageNumber=1;
    //        }
    //        Integer startIndex=pageSize*(pageNumber-1);
    //        system.debug('*** BET getResultsForPage start Index: '+startIndex);
    //        List<uw_BETWrapper.BetSearchItem> pagedResults=new List<uw_BETWrapper.BetSearchItem>();
    //        Boolean firstIteration=true;
    //        for(Integer i=startIndex;i<startIndex+pageSize;i++){
    //            if(searchResults.size() > i){
    //                pagedResults.add(searchResults[i]);
    //            }
    //        }
    //        System.Debug('*** BET getResultsForPage number of items which will be returned:' +pagedResults.size());
    //        return pagedResults;
    //    }else{
    //        //list of results is empty then return empty list
    //        return searchResults;
    //    }
    //}
}