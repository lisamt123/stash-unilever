/*************************************************************************************
Name : BET_TestUtils

Purpose : Utility class for Unit Test purpose

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-07-2015  Initial
*************************************************************************************/
public class BET_TestUtils {

	public static final String DIVISION_CAT_TYPE_NAME = 'TestCategory Sub Division 2';
	public static final String CATEGORY_TYPE_NAME = 'TestCategory';

	private BET_TestUtils (){}

	/************************************************************
		Purpose: Method creates BET record used in unit test classes
		Parameters:
		Returns: BET record
		Throws: -
	*************************************************************/
	public static uw_BET__c getTestBet(){
		MDO_Brand__c brand = new MDO_Brand__c();
		brand.name = 'battle Axe';
		insert brand;
          
		MDO_Category__c cgroup = new MDO_Category__c();
		cgroup.name='TestCategoryGroup';
		cgroup.category_type__c = 'Category Group';
		insert cgroup;

		MDO_Category__c sdivcategory = new MDO_Category__c();
		sdivcategory.name = DIVISION_CAT_TYPE_NAME;
		sdivcategory.category_type__c = 'Sub Division 2';
		sdivcategory.parent_id__c = cgroup.id;
		insert sdivcategory;

		MDO_Category__c category = new MDO_Category__c();
		category.name = CATEGORY_TYPE_NAME;
		category.category_type__c = 'Category';
		category.parent_id__c = sdivcategory.id;
		insert category;

        uw_Inoplan_Project__c inoProject = new uw_Inoplan_Project__c();
        inoProject.name = 'No Inoplan Project' + Math.random();
        insert inoProject;
              
        uw_BET__c bet = new uw_BET__c();
        bet.Product_Brand__c = brand.Id;
        bet.Product_Category__c = category.Id;
        bet.Category_Group__c = cgroup.id;
        bet.Status__c = 'First release';
        bet.Inoplan_Project__c = inoProject.id;
        bet.Name = 'AxeBrandExperience';
        System.debug('Exit getTestBet : ' + bet);
        return bet;
	}

	/************************************************************
		Purpose: Method creates BET record used in unit test classes
		Parameters: String,Id,Id,Id,Id,Id,String : betname, category group, category, brand, inoplanproject, ipmproject, status
		Returns: BET record
		Throws: -
	*************************************************************/
	public static uw_BET__c getTestBet(String name, Id categoryGroup, Id category , Id brand, Id inoplanproject, Id ipmProject, String status){
		System.debug('Exit getTestBet : ' + name + ', ' + categoryGroup + ', ' + category + ', '+brand + ', ' + inoplanproject + ', ' + ipmProject + ', '+ status);
		uw_BET__c bet = new uw_BET__c();
        bet.Product_Brand__c = brand;
        bet.Product_Category__c = category;
        bet.Category_Group__c = categoryGroup;
        bet.Status__c = status;
        bet.Inoplan_Project__c = inoplanproject;
        bet.IPM_Project__c = ipmProject;
        bet.Name = name;
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
		Parameters: MDO_Category__c object
		Returns: MDO Category record
		Throws: -
	*************************************************************/
	public static MDO_Category__c createCategory(MDO_Category__c categoryGroup){

		System.debug('Entering createCategory : ' + categoryGroup);

		MDO_Category__c sdivcategory = new MDO_Category__c();
		sdivcategory.name = DIVISION_CAT_TYPE_NAME;
		sdivcategory.category_type__c = 'Sub Division 2';
		sdivcategory.parent_id__c = categoryGroup.id;
		insert sdivcategory;

		MDO_Category__c category = new MDO_Category__c();
		category.name = CATEGORY_TYPE_NAME;
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
		Purpose: Method creates MDO Category record used in unit test classes
		Parameters: MDO_Category__c object and category name
		Returns: MDO Category record
		Throws: -
	*************************************************************/
	public static MDO_Category__c createCategory(MDO_Category__c categoryGroup,String categoryName){
		System.debug('Entering createCategory : ' + categoryGroup + ', ' + categoryName);

		MDO_Category__c sdivcategory = new MDO_Category__c();
		sdivcategory.name = CATEGORY_TYPE_NAME;
		sdivcategory.category_type__c = 'Sub Division 2';
		sdivcategory.parent_id__c = categoryGroup.id;
		insert sdivcategory;

		MDO_Category__c category = new MDO_Category__c();
		category.name=categoryName;
		category.category_type__c = 'Category';
		category.parent_id__c = sdivcategory.id;
		insert category;

		System.debug('Exit createCategory : ' + category);
		return category;
	}

	/************************************************************
		Purpose: Method creates MDO Brand Positions record used in unit test classes
		Parameters: MDO_Category__c object
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

	/************************************************************
		Purpose: Method creates MDO Brand record used in unit test classes
		Parameters: Brand name
		Returns: MDO Brand record
		Throws: -
	*************************************************************/
	public static MDO_Brand__c createBrand(String brandName){
		System.debug('Entering createBrand : ' + brandName);
		MDO_Brand__c brand = new MDO_Brand__c();
		brand.name = 'brandName';
		insert brand;
		System.debug('Exit createBrand : ' + brand);
		return brand;
	}
    
    /************************************************************
		Purpose: Method creates creates test data for Suggested Members Component
		Parameters: 
		Returns: 
		Throws: -
	*************************************************************/
    public static  void generateTestDataForSuggestedMembers(List<Id> suggested_MembersCtrl, List<Id> suggested_ManagersCtrl, List<BET_MemberBucketWrapper> user_bucketsCtrl){
        system.debug('Entring generateTestDataForSuggestedMembers with param @suggested_MembersCtrl:'+suggested_MembersCtrl
                     +'@suggested_ManagersCtrl:'+suggested_ManagersCtrl+'@user_bucketsCtrl:'+user_bucketsCtrl);
        Integer i = 0;
        BET_MemberBucketWrapper itemWrap = new BET_MemberBucketWrapper();
        
        
        for(User u : [Select id From User Limit 12]){
            
            if(Math.mod(i, 4) == 0){
                itemWrap = new BET_MemberBucketWrapper();
                itemWrap.GroupName ='Test User Gropup'+i;
                itemWrap.GroupUserIds = new List<Id>();
                user_bucketsCtrl.add(itemWrap);
                suggested_ManagersCtrl.add(u.id);
            }
			
            itemWrap.GroupUserIds.add(u.id);
            suggested_MembersCtrl.add(u.id);
            i++;
        }
        system.debug('Exiting generateTestDataForSuggestedMembers properties were set to @suggested_MembersCtrl:'+suggested_MembersCtrl
                     +'@suggested_ManagersCtrl:'+suggested_ManagersCtrl+'@user_bucketsCtrl:'+user_bucketsCtrl);
    }
    
    /************************************************************
		Purpose: Method creates creates test BET_Follow_Request__c record
		Parameters: 
		Returns: 
		Throws: -
	*************************************************************/
    public static  BET_Follow_Request__c createBetFollowRequest(id betId,String projectId){
        system.debug('Entring createBetFollowRequest with params @betId:'+betId+' @projectId:'+projectId);
        BET_Follow_Request__c testFollowRequest = new BET_Follow_Request__c();
        testFollowRequest.Brand_Experience_Toolkit__c = betId;
        testFollowRequest.Project_Id__c = projectId;
        testFollowRequest.Project_Lead__c = UserInfo.getUserId();
        system.debug('Exiting createBetFollowRequest following BetFollowRequest was created:'+testFollowRequest);
        return testFollowRequest;
    }
    
    

}