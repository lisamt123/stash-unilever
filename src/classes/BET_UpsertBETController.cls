/*************************************************************************************
Name : BET_UpsertBETController

Purpose : Controller class for BET_UpsertBETController

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  20-07-2015  Initial
*************************************************************************************/

public with sharing class BET_UpsertBETController {

	public Id projectIdentifier {get;set;}
	public String projectName {get;set;}
	public Id categoryName {get;set;}
	public Id cat {get;set;}
	public Id brandPosition {get;set;}
	public Id owner {get;set;}
	public Date targetLaunchDate {get;set;}
	public String projectDescription {get;set;}
	public String cback {get;set;}
	public String cbackskipped {get;set;}

	public String selectedBrand {get;set;}

	public Boolean fabricConditionerCategory {get;set;}

	public static final String MISSING_DATA_TEXT = 'Missing';

	public static final String INVALID_CATEGORY_GROUP_REL = 'Invalid category and category group relation';

	public static final String INVALID_POSITION_CATEGORY_REL = 'Invalid brand positioning and category relation';

	//FabricConditioner begin
    private static Boolean fbEnabled = BET_FabricCoditioners__c.getOrgDefaults().Enabled__c;
    //FabricConditioner end

	public String categoryGroupName{
		get{
			String name = BET_MasterDataService.getCategoryGroupName(categoryName);
			return name == null ? MISSING_DATA_TEXT : name;
		}
		set{
			categoryGroupName = value;
		}
	}

	public String catName{
		get{
			String name = BET_MasterDataService.getCategoryName(cat);
			//FabricConditioner begin
			fabricConditionerCategory = fbEnabled ? BET_MasterDataService.isFabricConditionersCategory(cat) : false;
			if(fbEnabled && fabricConditionerCategory){
				betobject.Is_Fabric_Conditioners__c = true;
			} else {
				betobject.Is_Fabric_Conditioners__c = fabricConditionerCategory;
			}
			//FabricConditioner end
			Boolean isRelationValid = true;
			if(name != null){
				isRelationValid = BET_MasterDataService.isValidRelationWithCategoryAndCategoryGroup(cat,categoryName);
			}
			if(isRelationValid){
				return name == null ? MISSING_DATA_TEXT : name;
			} else {
				return name + ' : ' + INVALID_CATEGORY_GROUP_REL;
			}
		}
		set{
			catName = value;
		}
	}

	public String brandPositionName{
		get{
			String name = BET_MasterDataService.getBrandPositionName(brandPosition);
			Boolean isRelationValid = true;
			if(name != null){
				isRelationValid = BET_MasterDataService.isValidRelationWithBrandPositionAndCategory(brandPosition,cat);
			}
			if(isRelationValid){
				return name == null ? MISSING_DATA_TEXT : name;
			} else {
				return name + ' : ' + INVALID_POSITION_CATEGORY_REL;
			}
		}
		set{
			brandPositionName = value;
		}
	}


	public BET_UpsertBETController() {}

	public uw_Bet__c betobject{
		get{
				if(betobject == null) {
					betobject = new uw_Bet__c();
				}
				if(betobject.ownerId == null){
					betobject.ownerId = owner;
				}
				if(betobject.Launch_Date__c == null){
					betobject.Launch_Date__c = targetLaunchDate;
				}
				if(betobject.name == null){
					betobject.name = projectName;
				}
				if(betobject.Description__c == null){
					betobject.Description__c = projectDescription;
				}
				return betobject;
			} set {
				betobject = value;
			}
	}

	/************************************************************
        Purpose: Method retrieves brand list for given brand position
        Parameters: -
        Returns: List of brand objects
        Throws: -
    *************************************************************/
	public List<SelectOption> getBrands(){
		System.debug('Entering getBrands : ' + brandPosition);
		List<SelectOption> options = getSelectOptionsForList(BET_MasterDataService.getBETBrandsForGivenPositioning(brandPosition));
		System.debug('Exit getBrands : ' + options);
		return options;
	}

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

	/************************************************************
        Purpose: Action method fired when new BET is created
        Parameters: -
        Returns: new Page Reference
        Throws: -
    *************************************************************/
	public PageReference upsertBet(){
		System.debug('Entering upsertBet');
		PageReference pageRef = null;
		try{
			uw_Bet__c newBET = buildBETObject();
			Boolean betNameExists = BET_COmmonService.checkIfBetExists(newBET);
			if(betNameExists){
				return addErrorMessage(Label.BET_NameExists);
			} else {
				upsert newBET;
				pageRef = new PageReference(cback+newBET.id);
			}
		}catch(Exception e){
			return addErrorMessage('Exception Saving BET record'+e);
		}
		System.debug('Exit upsertBet : ' + pageRef);
		if(pageRef != null) {
			pageRef.setRedirect(true);
		}
		return pageRef;
	}

	/************************************************************
        Purpose: method adds erroe message
        Parameters: String message
        Returns: PageReference
        Throws: -
    *************************************************************/
	public PageReference addErrorMessage(String msg){
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
		return null;
	}

	/************************************************************
        Purpose: - Method builds BET object from parameters and values provided via form
        Parameters: -
        Returns: - new BET object
        Throws: -
    *************************************************************/
	private uw_Bet__c buildBETObject(){
		System.debug('Entering buildBETObject');
		uw_Bet__c newBET = new uw_Bet__c();
		newBET.name = betobject.name;
		newBet.ownerId = betobject.ownerId;
		newBet.IPM_Project__c = projectIdentifier;
		newBet.Launch_Date__c = betobject.Launch_Date__c;
		newBet.Category_Group__c = categoryName;
		newBet.Product_Category__c = cat;
		newBet.Brand_Position__c = brandPosition;
		newBet.Product_Brand__c = selectedBrand;
		newBet.Description__c = betobject.Description__C;
		newBet.Is_Fabric_Conditioners__c = betobject.Is_Fabric_Conditioners__c;
		System.debug('Exit buildBETObject ' + newBet);
		return newBET;
	}

	/************************************************************
        Purpose: Action method fired when BET creation is skipped
        Parameters: -
        Returns: new Page Reference
        Throws: -
    *************************************************************/
	public PageReference skipForNow(){
		sendAlertWhenSkipped();
		return cbackskipped == null ? null : new PageReference(cbackskipped);
	}

	/************************************************************
        Purpose: Method sends alert when BET creation is skipped
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	private void sendAlertWhenSkipped(){
		System.debug('Entering sendAlertWhenSkipped');
	}
}