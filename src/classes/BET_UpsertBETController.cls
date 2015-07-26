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

	public String selectedBrand {get;set;}

	public uw_Bet__c betobject = new uw_Bet__c();

	public String categoryGroupName{
		get{
			String name = BET_MasterDataService.getCategoryGroupName(categoryName);
			return name == null ? 'Missing' : name;
		}
		set{
			categoryGroupName = value;
		}
	}

	public String catName{
		get{
			String name = BET_MasterDataService.getCategoryName(cat);
			return name == null ? 'Missing' : name;
		}
		set{
			catName = value;
		}
	}

	public String brandPositionName{
		get{
			String name = BET_MasterDataService.getBrandPositionName(brandPosition);
			return name == null ? 'Missing' : name;
		}
		set{
			brandPositionName = value;
		}
	}


	public BET_UpsertBETController() {}

	public uw_Bet__c getBetobject(){
		betobject.ownerId = owner;
		betobject.Launch_Date__c = targetLaunchDate;
		return betobject;
	}

	/************************************************************
        Purpose: Method retrieves brand list for given brand position
        Parameters: -
        Returns: List of brand objects
        Throws: -
    *************************************************************/
	public List<SelectOption> getBrands(){
		return getSelectOptionsForList(BET_MasterDataService.getBETBrandsForGivenPositioning(brandPosition));
	}

	/************************************************************
        Purpose: Method builds unique option list from given record list
        Parameters: -
        Returns: List of unique option objects
        Throws: -
    *************************************************************/
	private List<SelectOption> getSelectOptionsForList(List<sObject> records){
		List<SelectOption> values = new List<SelectOption>{new SelectOption('','--None--')};
		Set<String> unique = new Set<String>();
		for(sObject mdo : records){
			if(!unique.contains((String)mdo.get('name'))) {
				unique.add((String)mdo.get('name'));
				values.add(new SelectOption((String)mdo.get('id'),(String)mdo.get('name')));
			}
		}
		return values;
	}

	/************************************************************
        Purpose: Action method fired when new BET is created
        Parameters: -
        Returns: new Page Reference
        Throws: -
    *************************************************************/
	public PageReference upsertBet(){
		try{
			uw_Bet__c newBET = buildBETObject();
			upsert newBET;
			return new PageReference(cback+'?id='+newBET.id);
		}catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception Saving BET record'+e));
		}
		return null;
	}

	/************************************************************
        Purpose: - Method builds BET object from parameters and values provided via form
        Parameters: -
        Returns: - new BET object
        Throws: -
    *************************************************************/
	private uw_Bet__c buildBETObject(){
		uw_Bet__c newBET = new uw_Bet__c();
		newBET.name = projectName;
		newBet.ownerId = getBetobject().ownerId;
		newBet.IPM_Project__c = projectIdentifier;
		newBet.Launch_Date__c = betobject.Launch_Date__c;
		newBet.Category_Group__c = categoryName;
		newBet.Product_Category__c = cat;
		newBet.Brand_Position__c = brandPosition;
		newBet.Product_Brand__c = selectedBrand;
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
		return new PageReference(cback);
	}

	/************************************************************
        Purpose: Method sends alert when BET creation is skipped
        Parameters: -
        Returns: -
        Throws: -
    *************************************************************/
	private void sendAlertWhenSkipped(){

	}
}