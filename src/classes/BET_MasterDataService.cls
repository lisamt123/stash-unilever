/*************************************************************************************
Name : BET_MasterDataService

Purpose : Data access service for BET Master Data Objects

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-07-2015  Initial
*************************************************************************************/

public without sharing class BET_MasterDataService{

	/************************************************************
		Purpose: Method retrieves all Master Data category groups
		Parameters: -
		Returns: List of MDO_Category__c objects
		Throws: -
	*************************************************************/

	public static List<sObject> getBETCategoryGroups(){
		System.debug('Entering getBETCategoryGroups');
		List<sObject> categoryGroups = [select id,name from MDO_Category__c where category_type__c = 'Category Group' order by name asc];
		System.debug('Exit getBETCategoryGroups : ' + categoryGroups);
		return categoryGroups;
	}
	

	/************************************************************
		Purpose: Method retrieves all Master Data categories for given category group id
		Parameters: Id of related category group
		Returns: List of MDO_Category__c objects
		Throws: -
	*************************************************************/

	public static List<sObject> getBETCategoriesForGivenGroup(String categoryGroup){
		System.debug('Entering getBETCategoriesForGivenGroup : ' + categoryGroup);
		List<sObject> categories;
		if(String.isBlank(categoryGroup)) {
			categories = new List<sObject>(); 
		} else {
		 	categories = [select id,name from MDO_Category__c where parent_id__r.parent_id__c =: categoryGroup and category_type__c = 'Category' order by name asc];
		}
		System.debug('Exit getBETCategoriesForGivenGroup : ' + categories);
		return categories;
	}

	/************************************************************
		Purpose: Method retrieves all Master Data brand positions objects for given category id
		Parameters: Id of related category
		Returns: List of MDO_BrandPositions__c objects
		Throws: -
	*************************************************************/

	public static List<sObject> getBETBrandPositioningsForGivenCategoryAndGroup(String category){
		System.debug('Entering getBETBrandPositioningsForGivenCategoryAndGroup : ' + category);
		Set<String> categoryAndSubs = getSubCategoriesForGivenCategory(category);
		List<MDO_BrandPosition__c> positions = [Select id, name from MDO_BrandPosition__c where id in (select brand_position_id__c from MDO_BrandPositions__c where product_category_id__c in: categoryAndSubs) order by name asc];		
		System.debug('Exit getBETBrandPositioningsForGivenCategoryAndGroup : ' + positions);
		return positions;
	}


	/************************************************************
		Purpose: Method retrieves all 2 levels of subcategories for given category
		Parameters: Id of related category
		Returns: Set of categories ids
		Throws: -
	*************************************************************/
	private static Set<String> getSubCategoriesForGivenCategory(String category){
		System.debug('Entering getSubCategoriesForGivenCategory : ' + category);
		Set<String> subcategories = new Set<String>{};
		if(!String.isBlank(category)) {
			List<MDO_Category__c> firsAndSecondSublevels = [select id from MDO_Category__c where parent_id__r.parent_id__c =:category or parent_id__c =: category];
			subcategories.add(category);
			for(MDO_Category__c cat : firsAndSecondSublevels){
				subcategories.add(cat.id);
			}
		}
		System.debug('Exit getSubCategoriesForGivenCategory : ' + subcategories);
		return subcategories;
	}

	/************************************************************
		Purpose: Method retrieves all Master Data brands for given brand positioning id
		Parameters: Id of related brand positioning
		Returns: List of MDO_Brand__c objects
		Throws: -
	*************************************************************/

	public static List<sObject> getBETBrandsForGivenPositioning(String position){
		System.debug('Entering getBETBrandsForGivenPositioning : ' + position);
		List<sObject> brands = [select id,name from MDO_Brand__C where id in (select brand_id__c from MDO_BrandPositions__c where brand_position_id__c =:position) order by name asc];
		System.debug('Exit getBETBrandsForGivenPositioning : ' + brands);
		return brands;
	}

	/************************************************************
		Purpose: Method retrieves category group name for given id
		Parameters: Id of related category group
		Returns: String : groups name or null when there is not such record
		Throws: -
	*************************************************************/
	public static String getCategoryGroupName(Id recordId){
		System.debug('Entering getCategoryGroupName : ' + recordId);
		String categoryGroupName;
		try{
			MDO_Category__c categoryGroup = [select id,name from MDO_Category__c where id=:recordId and category_type__c = 'Category Group'];
			categoryGroupName = categoryGroup.name;
		}catch(Exception e){
			categoryGroupName = null;
		}
		System.debug('Exit getCategoryGroupName : ' + categoryGroupName);
		return categoryGroupName;
	}

	/************************************************************
		Purpose: Method retrieves category name for given id
		Parameters: Id of related category
		Returns: String : category name or null when there is not such record
		Throws: -
	*************************************************************/
	public static String getCategoryName(Id recordId){
		System.debug('Entering getCategoryName : ' + recordId);
		String categoryName;
		try{
			MDO_Category__c category = [select id,name from MDO_Category__c where id=:recordId and category_type__c = 'Category'];
			categoryName = category.name;
		}catch(Exception e){
			categoryName = null;
		}
		System.debug('Exit getCategoryName : ' + categoryName);
		return categoryName;
	}

	/************************************************************
		Purpose: Method retrieves brand name for given id
		Parameters: Id of related brand
		Returns: String : brand name  or null when there is not such record
	*************************************************************/
	public static String getBrandPositionName(Id recordId){
		System.debug('Entering getBrandPositionName : ' + recordId);
		String positionName;
		try{
			MDO_BrandPosition__c position = [select id,name from MDO_BrandPosition__c where id=:recordId];
			positionName = position.name;
		}catch(Exception e){
			positionName = null;
		}
		System.debug('Exit getBrandPositionName : ' + positionName);
		return positionName;
	}

	/************************************************************
		Purpose: Method retrieves all available categories
		Parameters: -
		Returns: List of MDO_Category__c objects
	*************************************************************/
	public static List<MDO_Category__c> getAllAvailableCategories(){
		System.debug('Entering getAllAvailableCategories');
		List<MDO_Category__c> categories = [select id,name from MDO_Category__c where parent_id__r.parent_id__r.category_type__c = 'Category Group' and category_type__c = 'Category' order by name asc];
		System.debug('Exit getAllAvailableCategories : ' + categories);
		return categories;
	}

	/************************************************************
		Purpose: Method retrieves all available brands for given category
		Parameters: Category identifier
		Returns: List of MDO_Brand__c objects
	*************************************************************/
	public static List<MDO_Brand__c> getAllAvailableUniqueBrandsForCategory(String categoryId){
		System.debug('Entering getAllAvailableUniqueBrandsForCategory : ' + categoryId);
		List<MDO_Brand__c> brands = new List<MDO_Brand__c>();
		if(!String.isBlank(categoryId)){
			Set<String> categoryAndSubs = getSubCategoriesForGivenCategory(categoryId);
			List<MDO_BrandPosition__c> positions = [Select id, name from MDO_BrandPosition__c where id in (select brand_position_id__c from MDO_BrandPositions__c where product_category_id__c in: categoryAndSubs)];
			brands = [select id,name from MDO_Brand__c where id in (select brand_id__c from MDO_BrandPositions__c where brand_position_id__c in :positions) order by name asc];
		}
		System.debug('Exit getAllAvailableUniqueBrandsForCategory : ' + brands);
		return brands;
	}

}