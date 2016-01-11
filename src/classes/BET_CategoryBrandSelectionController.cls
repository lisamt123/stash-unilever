/*************************************************************************************
Name : BET_CategoryBrandSelectionController

Purpose : Controller for BET_CategoryBrandSelection visualforce component

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-07-2015  Initial
*************************************************************************************/

public with sharing class BET_CategoryBrandSelectionController {

	public String selectedCategoryGroup {get;set;}
	public String selectedCategory {get;set;}
	public String selectedBrandPositioning {get;set;}
	public String selectedBrand {get;set;}

	public Boolean categoryMigrated {get;set;}
	public Boolean categoryNotMigrated {get;set;}
	public Boolean fabricConditionerCategory {get;set;}

	public String fabricConditioner {get;set;}

	public static final String YES = 'Yes';
	public static final String NO = 'No';

	public Boolean getUserHasAccessToProject() {
		return bet == null || bet.id == null || bet.IPM_Project__c == null ? false : IPM_BETUpdateService.UserAccess(bet.id,bet.IPM_Project__c,UserInfo.getUserId());
	}

	//FabricConditioner begin
	private static Boolean fbEnabled = BET_FabricCoditioners__c.getOrgDefaults().Enabled__c;
	//FabricConditioner end

	public BET_CategoryComponentData compData {
		get{ 
			return compData;
		}
		set{
			compData = value;
			if(compData.categoryGroup != null && selectedCategoryGroup == null){
				selectedCategoryGroup =  compData.categoryGroup;
			}
			if(compData.category != null && selectedCategory == null){
				selectedCategory = compData.category;
			}
			if(compData.brandpositioning != null && selectedBrandPositioning == null) {
				selectedBrandPositioning = compData.brandpositioning;
			}
			if(compData.brand != null && selectedBrand == null) {
				selectedBrand = compData.brand;
			}
			if(categoryMigrated == null) {
				categoryMigrated = compData.categoryMigrated;
			}
			if(categoryNotMigrated == null) {
				categoryNotMigrated = compData.categoryNotMigrated;
			}
			//FabricConditioner begin
			if(fabricConditionerCategory == null){
				fabricConditionerCategory = fbEnabled ? compData.fabricConditionerCategory : false;
			}
			//FabricConditioner end
		}
	}

	public uw_BET__c bet {
		get{	
			return bet;
		}
		set{
			bet = value;
			//FabricConditioner begin
			if(bet != null && bet.id != null && bet.Is_Fabric_Conditioners__c){
				fabricConditioner = YES;
			} else {
				if(fabricConditioner != YES){
					fabricConditioner = NO;
				    bet.Is_Fabric_Conditioners__c = false;
				} else {
					bet.Is_Fabric_Conditioners__c = true;
				}
			}
			//FabricConditioner end
		}
	}

	/************************************************************
        Purpose: Component controller constructor
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	public BET_CategoryBrandSelectionController() {}

	/************************************************************
        Purpose: Action method fired after category is changed
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	public void onCategoryChange(){
		System.debug('Entering onCategoryChange : ' + selectedCategory + ', '+compData);

		categoryMigrated = String.isBlank(selectedCategory) ? false : IPM_BETUpdateService.CategoryCheck(selectedCategory);
		categoryNotMigrated = !categoryMigrated;
		compData.category = selectedCategory;
		selectedBrandPositioning = null;
		selectedBrand = null;

		//FabricConditioner begin
		if(fbEnabled) {
			fabricConditionerCategory = fbEnabled ? BET_MasterDataService.isFabricConditionersCategory(selectedCategory) : false;
			updateFabricData(fabricConditionerCategory);
		} else {
			fabricConditioner = NO;
		}
		//FabricConditioner end

		compData.brandpositioning = selectedBrandPositioning;
		compData.brand = selectedBrand;
	}

	//FabricConditioner begin
	@TestVisible
	private void updateFabricData(Boolean fabricConditionerCategory){
		compData.fabricConditionerCategory = fabricConditionerCategory;
		bet.Is_Fabric_Conditioners__c = fabricConditionerCategory;
		fabricConditioner = NO;
	}
	//FabricConditioner end

	/************************************************************
        Purpose: Action method fired after brand position is changed
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	public void onBrandPositioningChange(){
		System.debug('Entering onBrandPositioningChange : ' + selectedBrandPositioning + ', '+compData);
		compData.brandpositioning = selectedBrandPositioning;
	}

	/************************************************************
        Purpose: Action method fired after category group is changed
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	public void onCategoryGroupChange(){
		System.debug('Entering onCategoryGroupChange : ' + selectedCategoryGroup + ', '+compData);
		compData.categoryGroup = selectedCategoryGroup;

		categoryMigrated = false;
		categoryNotMigrated = false;
		selectedCategory = null;
		selectedBrandPositioning = null;
		selectedBrand = null;

		//FabricConditioner begin
		if(fbEnabled){
			fabricConditionerCategory = false;
			updateFabricData(fabricConditionerCategory);
		} else {
			fabricConditioner = NO;
		}
		//FabricConditioner end

		compData.category = selectedCategory;
		compData.brandpositioning = selectedBrandPositioning;
		compData.brand = selectedBrand;
	}

	/************************************************************
        Purpose: Action method fired after brand is changed
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	public void onBrandChange(){
		System.debug('Entering onBrandChange : ' + selectedBrand + ', '+compData);
		compData.brand = selectedBrand;
	}

	//FabricConditioner begin
	public void onFabricConditionersChange(){
		System.debug('Entering onFabricConditionersChange');
		bet.Is_Fabric_Conditioners__c = true;
		if(String.isBlank(fabricConditioner) || fabricConditioner == NO){
			bet.Is_Fabric_Conditioners__c = false;
		}
	}
	//FabricConditioner end

	/************************************************************
        Purpose: Action method fired after inoplan project is changed
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	public void onProjectChange(){
		compData.inoplanProject = bet.Inoplan_Project__c;
	}

    /************************************************************
        Purpose: Method retrieves list of available category groups
        Parameters: -
        Returns: List of option objects representing available category groups
        Throws: -
    *************************************************************/
	public List<SelectOption> getCategoryGroups(){
		return getSelectOptionsForList(BET_MasterDataService.getBETCategoryGroups());
	}

    /************************************************************
        Purpose: Method retrieves list of available categories
        Parameters: -
        Returns: List of option objects representing available categories
        Throws: -
    *************************************************************/
	public List<SelectOption> getCategories(){
		return getSelectOptionsForList(BET_MasterDataService.getBETCategoriesForGivenGroup(selectedCategoryGroup));
	}

    /************************************************************
        Purpose: Method retrieves list of available brand positions
        Parameters: -
        Returns: List of option objects representing available brand positions
        Throws: -
    *************************************************************/
	public List<SelectOption> getBrandPositionings(){
		return getSelectOptionsForList(BET_MasterDataService.getBETBrandPositioningsForGivenCategoryAndGroup(selectedCategory));
	}

    /************************************************************
        Purpose: Method retrieves list of available brands
        Parameters: -
        Returns: List of option objects representing available brands
        Throws: -
    *************************************************************/
	public List<SelectOption> getBrands(){
		return getSelectOptionsForList(BET_MasterDataService.getBETBrandsForGivenPositioning(selectedBrandPositioning));
	}

	//FabricConditioner begin
	public List<SelectOption> getFabricConditioners(){
		return new List<SelectOption>{new SelectOption(NO,NO),new SelectOption(YES,YES)};
	}
	//FabricConditioner end

	/************************************************************
        Purpose: Method builds unique option list from given record list
        Parameters: -
        Returns: List of unique option objects
        Throws: -
    *************************************************************/
	private List<SelectOption> getSelectOptionsForList(List<sObject> records){
		System.debug('Entering getSelectOptionsForList : ' + records);
		List<SelectOption> values = new List<SelectOption>{new SelectOption('','--None--')};
		Set<String> unique = new Set<String>();
		for(sObject mdo : records){
			if(!unique.contains((String)mdo.get('name'))) {
				unique.add((String)mdo.get('name'));
				values.add(new SelectOption((String)mdo.get('id'),(String)mdo.get('name')));
			}
		}
		System.debug('Exit getSelectOptionsForList : ' + values);
		return values;
	}

}