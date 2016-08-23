/*************************************************************************************
Name : BET_TestUtils

Purpose : Utility class for Unit Test purpose

History

VERSION  AUTHOR                			DATE        DETAIL   Description
1.0      m.bluj@polsource.com  			17-07-2015  Initial
1.1      piotr.czechusmki@gmail.com    	05-08-2015  Add instance methods
*************************************************************************************/
@isTest
public class BET_TestUtils {

	public static final String DIVISION_CAT_TYPE_NAME = 'TestCategory Sub Division 2';
	public static final String CATEGORY_TYPE_NAME = 'TestCategory';
	public static final String CATEGORY_TYPE_CAT_GROUP = 'Category Group';
	public static final String CATEGORY_TYPE_SUBDEVISION2 = 'Sub Division 2';
	public static final String CATEGORY_TYPE_CATEGORY = 'Category';

	public static final String MDO_STATUS_ACTIVE = 'Active';
	public static final String TEST_USER_EMAIL = 'm.bluj@polsource.com';
	public static final String USER_LOCAL = 'en_US';
	

	/************************************************************
		Purpose: Method creates BET record used in unit test classes
		Parameters:
		Returns: BET record
		Throws: -
	*************************************************************/
	public static uw_BET__c getTestBet(){
		MDO_Brand__c brand = new MDO_Brand__c();
		brand.name = 'battle Axe';
		brand.status__c = MDO_STATUS_ACTIVE;
		insert brand;
          
		MDO_Category__c cgroup = new MDO_Category__c();
		cgroup.name='TestCategoryGroup';
		cgroup.category_type__c = CATEGORY_TYPE_CAT_GROUP;
		cgroup.status__c = MDO_STATUS_ACTIVE;
		insert cgroup;

		MDO_Category__c sdivcategory = new MDO_Category__c();
		sdivcategory.name = DIVISION_CAT_TYPE_NAME;
		sdivcategory.category_type__c = CATEGORY_TYPE_SUBDEVISION2;
		sdivcategory.parent_id__c = cgroup.id;
		sdivcategory.status__c = MDO_STATUS_ACTIVE;
		insert sdivcategory;

		MDO_Category__c category = new MDO_Category__c();
		category.name = CATEGORY_TYPE_NAME;
		category.category_type__c = CATEGORY_TYPE_CATEGORY;
		category.parent_id__c = sdivcategory.id;
		category.status__c = MDO_STATUS_ACTIVE;
		insert category;

        uw_Inoplan_Project__c inoProject = new uw_Inoplan_Project__c();
        inoProject.name = 'No Inoplan Project' + Math.random();
        insert inoProject;
              
        uw_BET__c bet = new uw_BET__c();
        bet.Product_Brand__c = brand.Id;
        bet.Product_Category__c = category.Id;
        bet.Brand_Position__c = createBrandPosition(category).id;
        bet.Category_Group__c = cgroup.id;
        bet.Status__c = 'First release';
        bet.Inoplan_Project__c = inoProject.id;
        bet.Name = 'UTAxeBrExp_' + Math.random();
        System.debug('Exit getTestBet : ' + bet);
        return bet;
	}

	/************************************************************
		Purpose: Method creates BET record used in unit test classes
		Parameters: String,Id,Id,Id,Id,Id,String : betname, category group, category, brand, inoplanproject, ipmproject, status
		Returns: BET record
		Throws: -
	*************************************************************/
	public static uw_BET__c getTestBet(String namePrefix, Id categoryGroup, Id category , Id brand, Id inoplanproject, Id ipmProject, String status){
		System.debug('Exit getTestBet : ' + namePrefix + ', ' + categoryGroup + ', ' + category + ', '+brand + ', ' + inoplanproject + ', ' + ipmProject + ', '+ status);
		uw_BET__c bet = new uw_BET__c();
        bet.Product_Brand__c = brand;
        bet.Product_Category__c = category;
        bet.Category_Group__c = categoryGroup;
        bet.Status__c = status;
        bet.Inoplan_Project__c = inoplanproject;
        bet.IPM_Project__c = ipmProject;
        bet.Name = namePrefix + Math.random();
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
		cgroup.category_type__c = CATEGORY_TYPE_CAT_GROUP;
		cgroup.status__c = MDO_STATUS_ACTIVE;
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
		sdivcategory.category_type__c = CATEGORY_TYPE_SUBDEVISION2;
		sdivcategory.parent_id__c = categoryGroup.id;
		sdivcategory.status__c = MDO_STATUS_ACTIVE;
		insert sdivcategory;

		MDO_Category__c category = new MDO_Category__c();
		category.name = CATEGORY_TYPE_NAME;
		category.category_type__c = CATEGORY_TYPE_CATEGORY;
		category.parent_id__c = sdivcategory.id;
		category.status__c = MDO_STATUS_ACTIVE;
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
		sdivcategory.category_type__c = CATEGORY_TYPE_SUBDEVISION2;
		sdivcategory.parent_id__c = categoryGroup.id;
		sdivcategory.status__c = MDO_STATUS_ACTIVE;
		insert sdivcategory;

		MDO_Category__c category = new MDO_Category__c();
		category.name=categoryName;
		category.category_type__c = CATEGORY_TYPE_CATEGORY;
		category.parent_id__c = sdivcategory.id;
		category.status__c = MDO_STATUS_ACTIVE;
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
		brand.status__c = MDO_STATUS_ACTIVE;
		insert brand;
		MDO_BrandPositions__c positioning = new MDO_BrandPositions__c();
		positioning.product_category_id__c = category.id;
		positioning.brand_id__c = brand.Id;
		positioning.status__c = MDO_STATUS_ACTIVE;
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
		brand.status__c = MDO_STATUS_ACTIVE;
		insert brand;

		MDO_BrandPosition__c position = new MDO_BrandPosition__c();
		position.name = 'position';
		position.status__c = MDO_STATUS_ACTIVE;
		insert position;

		MDO_BrandPositions__c positioning = new MDO_BrandPositions__c();
		positioning.product_category_id__c = category.id;
		positioning.brand_id__c = brand.Id;
		positioning.brand_position_id__c = position.id;
		positioning.status__c = MDO_STATUS_ACTIVE;
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
		brand.name = brandName;
		brand.status__c = MDO_STATUS_ACTIVE;
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
        
        
        //for(User u : [Select id From User where isActive = true and profile.name = 'System Administrator' Limit 12]){
        for(User u : createUserSystemAdmin(12)){
            
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
    
    /************************************************************
		Purpose: Method creates creates test IPM_Project__c record
		Parameters: String project's name
		Returns: IPM_Project__c record
		Throws: -
	*************************************************************/
    public static IPM_Project__c createIPMProject(String projectName){
    	return createIPMProject (projectName, null, null, null);
    }

    /************************************************************
		Purpose: Method creates creates test IPM_Project__c record
		Parameters: String project's name
		Returns: IPM_Project__c record
		Throws: -
	*************************************************************/
    public static IPM_Project__c createIPMProject(String projectName, String extId, Id projectLead, Id deputyProjectLead){

    	List<IPM_Project__c> projects = IPM_TestFactory_Helper.createOriginalProjectList(false,1);
    	IPM_Project__c project = projects.get(0);
    	project.name=projectName;
    	project.IPM_Project_Name__c=projectName;
    	project.Project_External_ID__c 		= extId;
    	project.IPM_Project_Leader__c 		= projectLead;
    	project.Deputy_Project_Leader__c	= deputyProjectLead;
		project.IPM_Category_Group__c       = createCategoryGroup().id;
		project.IPM_Category_Text__c        = project.IPM_Category_Group__c;
		project.IPM_Brand_Positioning__c    = null;
    	insert project;

    	return project;
    }

    /************************************************************
		Purpose: Method creates creates test BET_Follow_Request__c record
		Parameters: uw_Bet__c bet, IPM_Project__c project
		Returns: BET_Follow_Request__c record
		Throws: -
	*************************************************************/
    public static BET_Follow_Request__c createApprovedFollowRequest(uw_Bet__c bet, IPM_Project__c project){
		return createBetFollowRequest(bet,project,BET_LinkingService.FOLLOW_STATUS_APPROVED);
    }

     /************************************************************
		Purpose: Method creates test system admin user
		Parameters: uw_Bet__c bet, IPM_Project__c project
		Returns: BET_Follow_Request__c record
		Throws: -
	*************************************************************/
    public static BET_Follow_Request__c createNewFollowRequest(uw_Bet__c bet, IPM_Project__c project){
		return createBetFollowRequest(bet,project,BET_LinkingService.FOLLOW_STATUS_NEW);
    }

    /************************************************************
		Purpose: Method creates creates test BET_Follow_Request__c record
		Parameters: uw_Bet__c bet, IPM_Project__c project
		Returns: BET_Follow_Request__c record
		Throws: -
	*************************************************************/
    public static User createUserSystemAdmin(){
    	Integer randNo = Integer.valueOf(Math.random() * 100000);
		User newUser = new User(alias = '' + randNo, 
								email = 'TestUsert@unittest.com',
								emailencodingkey = 'UTF-8',
								firstname = 'Test',
								lastname = 'ChatterAnswersCreateAccountTest',
								languagelocalekey = USER_LOCAL,
								localesidkey = USER_LOCAL, 
								profileid = [SELECT Name FROM Profile WHERE Name = 'System Administrator'].id,
								timezonesidkey = 'Europe/London',
								username = 'TestAdmin@unittest.com' + randNo);
		insert newUser;
		return newUser;
    }

    /************************************************************
		Purpose: Create test users
		Parameters: number of users to create
		Returns: List of Users
		Throws: -
	*************************************************************/
    public static List<User> createUserSystemAdmin(Integer iCount){
    	List<User> retVal = new List<User>();
    	Id sysAdminId = [SELECT id FROM Profile WHERE Name = 'System Administrator'].id;
    	Integer randNo = Integer.valueOf(Math.random() * 100000);

    	for (Integer i=0; i<iCount; i++){
			retVal.add( new User(alias = '' + randNo, 
							email = 'TestUsert@unittest.com',
							emailencodingkey = 'UTF-8',
							firstname = 'Test',
							lastname = 'BETUnitTest-' + randNo,
							languagelocalekey = USER_LOCAL,
							localesidkey = USER_LOCAL, 
							profileid = sysAdminId,
							timezonesidkey = 'Europe/London',
							username = 'TestAdmin@unittest.com' + randNo)
			);
			randNo++;
		}
		insert retVal;
		return retVal;
    }

    /************************************************************
		Purpose: Method creates creates test BET_Follow_Request__c record with given status
		Parameters: uw_Bet__c bet, IPM_Project__c project,String status
		Returns: BET_Follow_Request__c record
		Throws: -
	*************************************************************/
    private static BET_Follow_Request__c createBetFollowRequest(uw_Bet__c bet, IPM_Project__c project,String status){
    	BET_Follow_Request__c request  = createBetFollowRequest(bet.id,project.id);
    	request.Status__c = status;
		insert request;
		return request;
    }

    public List<MDO_Brand__c> liBrands = new List<MDO_Brand__c>();
 	public List<MDO_Category__c> liGroupCategories = new List<MDO_Category__c>(); 
 	public List<MDO_Category__c> liSubDevisions2= new List<MDO_Category__c>();
 	public List<MDO_Category__c> liCategories = new List<MDO_Category__c>();
 	public List<uw_Inoplan_Project__c>liInoplanProjects = new List<uw_Inoplan_Project__c>();
 	public List<uw_BET__c> liBets = new List<uw_BET__c>();

    /************************************************************
		Purpose: Method intialize records for BET - for tests
		Parameters: String project's name
		Returns: IPM_Project__c record
		Throws: -
	*************************************************************/
 	public void initBET(){
 		System.debug('Entring method initBET');
 		MDO_Brand__c brand = new MDO_Brand__c();
		brand.name = 'Omo';
		brand.status__c = MDO_STATUS_ACTIVE;
		insert brand;
		liBrands.add(brand);
          
		MDO_Category__c cgroup = new MDO_Category__c();
		cgroup.name='Home Care';
		cgroup.category_type__c = CATEGORY_TYPE_CAT_GROUP;
		cgroup.status__c = MDO_STATUS_ACTIVE;
		insert cgroup;
		liGroupCategories.add(cgroup);

		MDO_Category__c sdivcategory = new MDO_Category__c();
		sdivcategory.name = DIVISION_CAT_TYPE_NAME;
		sdivcategory.category_type__c = CATEGORY_TYPE_SUBDEVISION2;
		sdivcategory.parent_id__c = cgroup.id;
		sdivcategory.status__c = MDO_STATUS_ACTIVE;
		insert sdivcategory;
		liSubDevisions2.add(sdivcategory);

		MDO_Category__c category = new MDO_Category__c();
		category.name = CATEGORY_TYPE_NAME;
		category.category_type__c = CATEGORY_TYPE_SUBDEVISION2;
		category.parent_id__c = sdivcategory.id;
		category.mdm_id__c = ''+ Integer.valueOf(Math.random()*10000);
		category.status__c = MDO_STATUS_ACTIVE;
		insert category;
		liCategories.add(category);

        uw_Inoplan_Project__c inoProject = new uw_Inoplan_Project__c();
        String strRand = '' + Integer.valueOf(Math.random()*10000);
        inoProject.name = 'No Inoplan Project' + strRand;
        inoProject.Project_Id__c = '' + strRand;
        insert inoProject;
        liInoplanProjects.add(inoProject);

        uw_BET__c bet = new uw_BET__c();
        bet.Product_Brand__c = brand.Id;
        bet.Product_Category__c = category.Id;
        bet.Category_Group__c = cgroup.id;
        bet.Status__c = 'First release';
        bet.Inoplan_Project__c = inoProject.id;
        bet.Name = 'AxeBrandExperience_'+system.now();
        insert bet;
        liBets.add(bet);

        System.debug('Exit initBET ');

 	}

 	@isTest static void getTestBetTest(){
 		Test.startTest();
 		uw_bet__c bet = BET_TestUtils.getTestBet();
 		Test.stopTest();
 		System.assert(bet != null,'Bet should be created');
 	}

}