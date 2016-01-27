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
1.1 -   Michal Bluj             29/07/2015      MDO Objects related changes
**********************************************************************/
public with sharing class uw_BETUtil {

	//available search types in applications
	public static final String brandSearch='brandSearch';
	public static final String categorySearch='categorySearch';
	public static final String keywordSearch='keywordSearch';

    public static final String CLEAR_FILTERS = 'Clear filter';
    public static final String CATEGORIES = 'Categories';
    public static final String BRANDS = 'Brands';

    private uw_BETUtil(){}

	/*******************************************************************
	Purpose: Method return filters for bet used in search page  
	Parameters: [String,String]
	Returns: [String]
	Throws [Exceptions]: [optional] 
	********************************************************************/
    public static List<uw_BETWrapper.FilterLineItemWrapper> getFiltersForBet(String brandId, String categoryId){
        System.debug('Entering getFiltersForBet : ' + brandId + ', ' + categoryId);
        List<uw_BETWrapper.FilterLineItemWrapper> filterInfoList = new List<uw_BETWrapper.FilterLineItemWrapper>();
        
        List<uw_BETWrapper.FilterOptions> categoryFilterOptions=new List<uw_BETWrapper.FilterOptions>();
        categoryFilterOptions.add(new uw_BETWrapper.FilterOptions('',CLEAR_FILTERS));

        for(MDO_Category__c category : BET_MasterDataService.getAllAvailableCategories()){
            categoryFilterOptions.add(new uw_BETWrapper.FilterOptions(category.id,category.name));
        }       

        String categoriesSelectedValue = categoryId == null ? '' : categoryId;
        filterInfoList.add(new uw_BETWrapper.FilterLineItemWrapper(CATEGORIES,false,categoryFilterOptions,categoriesSelectedValue));
            
        List<uw_BETWrapper.FilterOptions> brandFilterOptions=new List<uw_BETWrapper.FilterOptions>();
        brandFilterOptions.add(new uw_BETWrapper.FilterOptions('',CLEAR_FILTERS));

        if(!String.isBlank(categoryId)){
            for(MDO_Brand__c brand : BET_MasterDataService.getAllAvailableUniqueBrandsForCategory(categoryId)){
                brandFilterOptions.add(new uw_BETWrapper.FilterOptions(brand.id,brand.name));
            }
        }
 
        String brandsSelectedValue = brandId == null ? '' : brandId;
        filterInfoList.add(new uw_BETWrapper.FilterLineItemWrapper(BRANDS,false,brandFilterOptions,brandsSelectedValue));
        System.debug('Exit getFiltersForBet : ' + filterInfoList);
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
        if(compData.categoryMigrated){
            bet.Inoplan_Project__c = null;
        } else {
            bet.IPM_Project__c = null;
        }
        bet.Category_Group__c = compData.categoryGroup;
        bet.Product_Category__c = compData.category;
        bet.Brand_Position__c = compData.brandpositioning;
        bet.Product_Brand__c = compData.brand;
        //bet.Is_Fabric_Conditioners__c = compData.fabricConditionerCategory;
        System.debug('Exit moveComponentDataToBET : ' + bet);
        return bet;
    }

    private static List<String> validateIPMBetFields(uw_BET__c betObject){
        List<String> errors = new List<String>();
        if(String.isBlank(betObject.name)){
            errors.add(Label.BET_BetNameMandatory);
        }
        if(String.isBlank(betObject.ownerId)){
            errors.add(Label.BET_BetOwnerMandatory);
        }
        if(String.isBlank(betObject.Category_Group__c)){
            errors.add(Label.BET_BetCategoryGroupMandatory);
        }
        if(String.isBlank(betObject.Product_Category__c)){
            errors.add(Label.BET_BetCategoryMandatory);
        }
        if(String.isBlank(betObject.Brand_Position__c)){
            errors.add(Label.BET_BetBrandPositionMandatory);
        }
        if(betObject.Launch_Date__c == null){
            errors.add(Label.BET_LaunchDateMandatory);
        }
        return errors;
    }

    public static List<String> validateBET(uw_BET__c betObject, BET_CategoryComponentData compData){
        System.debug('Entering validateBET : ' + betObject + ', ' + compData);
        List<String> errors = validateIPMBetFields(betObject);
        //FabricConditioner begin
        if(String.isBlank(betObject.Inoplan_Project__c) && !compData.categoryMigrated && !compData.fabricConditionerCategory && !String.isBlank(betObject.Product_Category__c)){
            errors.add(Label.BET_InoplanProjectMandatory);
        }
        //FabricConditioner end
        System.debug('Exit validateBET : ' + errors);
        return errors;
    }
}