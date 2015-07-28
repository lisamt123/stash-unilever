/*************************************************************************************
Name : BET_TestUtils

Purpose : Utility class for Unit Test purpose

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-07-2015  Initial
*************************************************************************************/
public class BET_TestUtils {

	/************************************************************
		Purpose: Method creates BET record used in unit test classes
		Parameters:
		Returns: BET record
		Throws: -
	*************************************************************/
	public static uw_BET__c getTestBet(){
		System.debug('Entering getTestBet');
		uw_Brand__c brand = new uw_Brand__c();
        brand.Name = 'Axe';
        insert brand;
          
        uw_Inoplan_Project__c inoProject = new uw_Inoplan_Project__c();
        inoProject.name = 'No Inoplan Project' + Math.random();
        insert inoProject;
              
        uw_BET__c bet = new uw_BET__c();
        bet.uw_Brand__c = brand.Id;
        bet.Status__c = 'First release';
        bet.Inoplan_Project__c = inoProject.id;
        bet.Name = 'AxeBrandExperience';
        System.debug('Exit getTestBet : ' + bet);
        return bet;
	}

	/************************************************************
		Purpose: Method creates MDO Category record used in unit test classes
		Parameters: -
		Returns: MDO Category record
		Throws: -
	*************************************************************/
	public static MDO_Category__c createCategoryGroup(){
		System.debug('Entering createCategoryGroup');
		MDO_Category__c cgroup = new MDO_Category__c();
		cgroup.name='TestCategoryGroup';
		cgroup.category_type__c = 'Category Group';
		insert cgroup;
		System.debug('Exit createCategoryGroup : ' + cgroup);
		return cgroup;
	}

	/************************************************************
		Purpose: Method creates MDO Category record used in unit test classes
		Parameters: -
		Returns: MDO Category record
		Throws: -
	*************************************************************/
	public static MDO_Category__c createCategory(MDO_Category__c categoryGroup){

		System.debug('Entering createCategory : ' + categoryGroup);

		MDO_Category__c sdivcategory = new MDO_Category__c();
		sdivcategory.name='TestCategory';
		sdivcategory.category_type__c = 'Sub Division 2';
		sdivcategory.parent_id__c = categoryGroup.id;
		insert sdivcategory;

		MDO_Category__c category = new MDO_Category__c();
		category.name='TestCategory';
		category.category_type__c = 'Category';
		category.parent_id__c = sdivcategory.id;
		insert category;

		MDO_ProductCategorysubscriptions__c pcs = new MDO_ProductCategorysubscriptions__c();
		pcs.product_category_id__c=category.id;
		insert pcs;
		System.debug('Exit createCategory : ' + category);
		return category;
	}

	/************************************************************
		Purpose: Method creates MDO Brand Positions record used in unit test classes
		Parameters: 
		Returns: MDO Brand Positions record
		Throws: -
	*************************************************************/
	public static MDO_BrandPositions__c createBrandPositioning(MDO_Category__c category){
		System.debug('Entering createBrandPositioning : ' + category);
		MDO_Brand__c brand = new MDO_Brand__c();
		brand.name = 'battle Axe';
		insert brand;
		MDO_BrandPositions__c positioning = new MDO_BrandPositions__c();
		positioning.product_category_id__c = category.id;
		positioning.brand_id__c = brand.Id;
		insert positioning;
		System.debug('Exit createBrandPositioning : ' + positioning);
		return positioning;
	}

	/************************************************************
		Purpose: Method creates MDO Brand Position record used in unit test classes
		Parameters: 
		Returns: MDO Brand Position record
		Throws: -
	*************************************************************/
	public static MDO_BrandPosition__c createBrandPosition(MDO_Category__c category){
		System.debug('Entering createBrandPosition : ' + category);
		MDO_Brand__c brand = new MDO_Brand__c();
		brand.name = 'battle Axe';
		insert brand;

		MDO_BrandPosition__c position = new MDO_BrandPosition__c();
		position.name = 'position';
		insert position;

		MDO_BrandPositions__c positioning = new MDO_BrandPositions__c();
		positioning.product_category_id__c = category.id;
		positioning.brand_id__c = brand.Id;
		positioning.brand_position_id__c = position.id;
		insert positioning;
		System.debug('Exit createBrandPosition : ' + positioning);
		return position;
	}

}