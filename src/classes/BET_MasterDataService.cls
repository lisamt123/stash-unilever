/*************************************************************************************
Name : BET_MasterDataService

Purpose : Data access service for BET Master Data Objects

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-07-2015  Initial
*************************************************************************************/
/* Without sharing is used due to this is service class used by external system */
public without sharing class BET_MasterDataService{

	public static final String LAUNDRY = 'Laundry';

	private BET_MasterDataService(){}

	/************************************************************
		Purpose: Method retrieves all Master Data category groups
		Parameters: -
		Returns: List of MDO_Category__c objects
		Throws: -
	*************************************************************/

	public static List<sObject> getBETCategoryGroups(){
		System.debug('Entering getBETCategoryGroups');
		List<sObject> categoryGroups = [select id,name from MDO_Category__c where category_type__c = 'Category Group' and status__c = 'Active' order by name asc];
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
		 	categories = [select id,name from MDO_Category__c where parent_id__r.parent_id__c =: categoryGroup and category_type__c = 'Category' and status__c = 'Active' order by name asc];
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
		List<MDO_BrandPosition__c> positions = [Select id, name from MDO_BrandPosition__c where id in (select brand_position_id__c from MDO_BrandPositions__c where product_category_id__c in: categoryAndSubs and status__c = 'Active') and status__c = 'Active' order by name asc];		
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
			List<MDO_Category__c> firsAndSecondSublevels = [select id from MDO_Category__c where (parent_id__r.parent_id__c =:category and parent_id__r.parent_id__r.status__c = 'Active') or (parent_id__c =: category and parent_id__r.status__c = 'Active')];
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
		List<sObject> brands = [select id,name from MDO_Brand__C where id in (select brand_id__c from MDO_BrandPositions__c where brand_position_id__c =:position and status__c = 'Active' ) and status__c = 'Active' order by name asc];
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
			MDO_Category__c categoryGroup = [select id,name from MDO_Category__c where id=:recordId and category_type__c = 'Category Group' and status__c = 'Active'];
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
			MDO_Category__c category = [select id,name from MDO_Category__c where id=:recordId and category_type__c = 'Category' and status__c = 'Active'];
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
			MDO_BrandPosition__c position = [select id,name from MDO_BrandPosition__c where id=:recordId and status__c = 'Active'];
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
		List<MDO_Category__c> categories = [select id,name,parent_id__r.parent_id__c from MDO_Category__c where parent_id__r.parent_id__r.category_type__c = 'Category Group' and parent_id__r.parent_id__r.status__c = 'Active' and category_type__c = 'Category' and status__c = 'Active' order by name asc];
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
		List<MDO_Brand__c> uniqueBrands = new List<MDO_Brand__c>();
		if(!String.isBlank(categoryId)){
			Set<String> categoryAndSubs = getSubCategoriesForGivenCategory(categoryId);
			List<MDO_BrandPosition__c> positions = [Select id, name from MDO_BrandPosition__c where id in (select brand_position_id__c from MDO_BrandPositions__c where product_category_id__c in: categoryAndSubs and status__c = 'Active') and status__c = 'Active'];
			Set<String> uniqueNames = new Set<String>();
			for(MDO_Brand__C bObject : [select id,name from MDO_Brand__c where id in (select brand_id__c from MDO_BrandPositions__c where brand_position_id__c in :positions and status__c = 'Active') and status__c = 'Active' order by name,id asc]){
				if(!uniqueNames.contains(bObject.name)){
					uniqueBrands.add(bObject);
					uniqueNames.add(bObject.name);
				}
			}
		}
		System.debug('Exit getAllAvailableUniqueBrandsForCategory : ' + uniqueBrands);
		return uniqueBrands;
	}

	/************************************************************
		Purpose: Method checks if there is valid relation between category and categroy group created
		Parameters: Id categoryId, Id categoryGroupId
		Returns: true if relation is valid;
	*************************************************************/
	public static Boolean isValidRelationWithCategoryAndCategoryGroup(Id categoryId, Id categoryGroupId){
		if(categoryId == null || categoryGroupId == null) {
			return false;
		}
		List<MDO_Category__c> category = [select id from MDO_Category__c where id =: categoryId and parent_id__r.parent_id__c =: categoryGroupId and category_type__c = 'Category' and status__c = 'Active'];
		return !category.isEmpty();
	}

	/************************************************************
		Purpose: Method checks if there is valid relation between category and brandposition created
		Parameters: Id brandpositionId, Id category
		Returns: true if relation is valid;
	*************************************************************/
	public static Boolean isValidRelationWithBrandPositionAndCategory(Id brandpositionId, Id category){
		if(brandpositionId == null || category == null) {
			return false;
		}
		Set<String> categoryAndSubs = getSubCategoriesForGivenCategory(String.valueOf(category));
		List<MDO_BrandPosition__c> positions = [Select id, name from MDO_BrandPosition__c where id in (select brand_position_id__c from MDO_BrandPositions__c where product_category_id__c in: categoryAndSubs and status__c = 'Active') and id =:brandpositionId and status__c = 'Active'];
		return !positions.isEmpty();
	}

	public static Boolean isFabricConditionersCategory(Id categoryId){
		return LAUNDRY == getCategoryName(categoryId);
	}

}