/***************************************************************
Name: UL_PromotionSetIIBBTax()
Copyright © 2017 Salesforce
======================================================
Purpose:
Helper class for Trigger for Promotion .
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Eleonora Dotz    10-01-2017        INITIAL DEV       Promotion trigger helper class.
2.0 		Eleonora Dotz    30-01-2017        coding performance due to nova suite
*****************************************************************/
public with sharing class UL_PromotionSetIIBBTaxHandler{

	public static Map<Id,Decimal> promotionAnchorIIBBTax;
	private static set<ID> accounts = new set<ID>(); 
	private static set<ID> promotionTemplate = new set<ID>();
	// P1 L 18, 
	
	/*******************************************************************
    Purpose: calculate / update IIBB Tax for promotions
    Version: 1.0
    Parameters: List<ACCL__Promotion__c> newPromotions,Map<id,ACCL__Promotion__c> oldPromotionsMap
    Returns: Void
    Throws N/A
    ********************************************************************/
	public static void updateIIBBTax(List<ACCL__Promotion__c> newPromotions,Map<id,ACCL__Promotion__c> oldPromotionsMap){
		try {

				getSetsOfAccountsAndPromotionTemplates(newPromotions);
				// create Map with Id of Promotion and appropriate Template with setting "Consider IIBBTAX" = true
				Map<ID, ACCL__Promotion__c> validPromotions = getPromotionTemplateIIBBTaxSetting(newPromotions, promotionTemplate );

				// Create Map of Anchor Accounts ID with Related List of IIBBTAX
				Map <Id,Account> accountIIBBTaxes = getAnchorIIBBTaxes();	
				
				// Create Map of Accounts with ID of Level1 Accounts of Anchor Accounts with Related List of IIBBTAX
				Map <Id,Account> accountLevel1IIBBTaxes = getAnchorAccountLevel1IIBBTaxes (accountIIBBTaxes); 

				Map <String, List<Account>> TopNodeTaxes = getAnchorAccountTopNodeTaxes();
				
				//main Logic
				for(ACCL__Promotion__c pr: newPromotions){
					
					decimal iIBTaxesFound = null;

					if (validPromotions.containskey(pr.Id)){

						if(accountIIBBTaxes.containskey(pr.ACCL__Anchor_Account__c)){
						
							iIBTaxesFound = getTax(accountIIBBTaxes, pr.ACCL__Anchor_Account__c, pr, oldPromotionsMap );
							//System.debug('IIBBTax  found for Anchor ' + pr.ACCL__Anchor_Account__c + '-- Tax :' + pr.UL_IIBB_Tax__c + ' Promotion ID: -- ' + pr.id);
							
							if(iIBTaxesFound == null && TopNodeTaxes.get(pr.ACCL__Sales_Org__c) != null){
								iIBTaxesFound = getTaxTop(pr, TopNodeTaxes.get(pr.ACCL__Sales_Org__c));
							}

						} //if(accountIIBBTaxes.containskey(pr.ACCL__Anchor_Account__c) {

							//Else No IIbb Tax Found Message / at least Log
						if (iIBTaxesFound == null ){
							//Setze pr.UL_IIBB_Tax__c = null
							pr.UL_IIBB_Tax__c = null;
							//System.debug('IIBBTax NOT found for Anchor ' + pr.ACCL__Anchor_Account__c + ' -- Tax :' + pr.UL_IIBB_Tax__c + ' Promotion ID: -- ' + pr.id);
						}
						
						if(iIBTaxesFound != null){
							pr.UL_IIBB_Tax__c = iIBTaxesFound;
						}	
						iIBTaxesFound = null;	
					
				
					} //if (validPromotions.containskey(pr.Id)){
				} // for(ACCL__Promotion__c pr: newPromotions){
				//System.debug('Final List Of Promotion to update' + newPromotions);	

			} catch (Exception o){
				 // logError(Exception ex, Id currentUserId)
				UL_Utility.logError(o, UserInfo.getUserId());
			}
	
	} 
// P2  L 85
	/*******************************************************************
    Purpose: Find IIBBTax of Anchor account of given promotion 
    Version: 1.0
    Parameters: Map<ID, Account> AccountMap, Id AccountID, ACCL__Promotion__c pr, Map<Id, ACCL__Promotion__c> oldPromotionsMap 
    Returns: Decimal
    Throws N/A
    ********************************************************************/
	private static decimal getTax(Map<ID, Account> AccountMap, Id AccountID, ACCL__Promotion__c pr, Map<Id, ACCL__Promotion__c> oldPromotionsMap ){
		decimal iIBTaxesFound = null;

			if(AccountMap.containskey(AccountID)){
				if (AccountMap.get(AccountID).IIBBTaxes__r != null){
					for(IIBBTax__c tax : AccountMap.get(AccountID).IIBBTaxes__r){
						if (tax.Date_From__c <= pr.ACCL__Date_From__c && tax.Date_Thru__c >= pr.ACCL__Date_From__c ){
							iIBTaxesFound = tax.IIBB_Tax__c;
							
							//System.debug('IIBBTax found for Account Level 1: '+ tax.Account__c +  'of Anchor ' + AccountID + ' -- Tax :' + tax.IIBB_Tax__c);
							
							if (oldPromotionsMap != null){
								if (oldPromotionsMap.get(pr.Id).UL_IIBB_Tax__c != tax.IIBB_Tax__c){
									iIBTaxesFound = tax.IIBB_Tax__c;
									//System.debug('IIBBTax found  Account Level 1: '+ tax.Account__c +  'of Anchor ' + AccountID + ' -- Tax was changed from old :' + oldPromotionsMap.get(pr.Id).UL_IIBB_Tax__c);
									break;
								}
							
							}else{
								iIBTaxesFound= tax.IIBB_Tax__c;
								break;
							}	
							
							
						}
						
					}
				}

			} // if(AccountMap.containskey(...)
		return iIBTaxesFound;
	} 
	/*******************************************************************
    Purpose: create Map of Promotion Templates with settings whether IIBB Tax should be calculated 
    Version: 1.0
    Parameters: (List<ACCL__Promotion__c> newPromotions, set<ID> promotionTemplateSet
    Returns:  Map<ID, ACCL__Promotion__c>
    Throws N/A
    ********************************************************************/
	private static Map<ID, ACCL__Promotion__c> getPromotionTemplateIIBBTaxSetting(List<ACCL__Promotion__c> newPromotions, set<ID> promotionTemplateSet){
		Map<ID, ACCL__Promotion__c> promotionIIBBTAX = new Map<ID, ACCL__Promotion__c>();

		if(promotionTemplateSet.size()>0){ 
		   //p2 L 122
		//According to Ketan Vinodrai was changed from creating a map using SOQL as Constructor to 
		// Using a loop to create a Map
			for(ACCL__Promotion__c prom :[Select Id, Name , ACCL__Promotion_Template__c, 
																					ACCL__Promotion_Template__r.name, ACCL__Promotion_Template__r.UL_Consider_IIBB_Tax__c  
																					From ACCL__Promotion__c 
																	  				Where ACCL__Promotion_Template__c in :promotionTemplateSet
																	  				And ACCL__Promotion_Template__r.UL_Consider_IIBB_Tax__c = true] ){
				promotionIIBBTAX.put(prom.Id, prom);
			}
		}
		//System.debug ('Valid Promotion for Considering of IIBB Taxes: -- '+ promotionIIBBTAX);
		return promotionIIBBTAX;
	}
//  p2 L 134
	/*******************************************************************
    Purpose: get all Ids of Anchor and promotion templates of given promotions 
    Version: 1.0
    Parameters: List<ACCL__Promotion__c>  newPromotions
    Returns:  void
    Throws N/A
    ********************************************************************/
    private static void getSetsOfAccountsAndPromotionTemplates(List<ACCL__Promotion__c>  newPromotions){
		for (ACCL__Promotion__c pr: newPromotions){
			if ( pr.ACCL__Anchor_Account__c != null ){
				accounts.add(pr.ACCL__Anchor_Account__c);
			}
			promotionTemplate.add(pr.ACCL__Promotion_Template__c);
		}
		//System.debug (' Id ofs  accounts:--' + accounts);
		//System.debug (' Ids of promotionTemplate:--' + promotionTemplate);
	}
	// P2 L 146
	/*******************************************************************
    Purpose: get Map of Anchors with IIBBtaxes 
    Version: 1.0
    Parameters: without
    Returns:  void
    Throws N/A
    ********************************************************************/
    private static Map<Id,Account> getAnchorIIBBTaxes(){
		Map <Id,Account> accountIIBBTaxes = new Map <Id,Account>();
		if (accounts.size()>0){
//p2 l 150
//According to Ketan Vinodrai was changed from creating a map using SOQL as Constructor to 
// Using a loop to create a Map
			for (Account acc: [SELECT Id,   UL_Level_1__c, UL_Level_1__r.name,
																		(SELECT Id, Account__c, Date_From__c, Date_Thru__c, IIBB_Tax__c 
																		FROM IIBBTaxes__r order by Date_From__c desc) 
																	FROM Account
																	Where Id IN :accounts]){
				accountIIBBTaxes.put(acc.Id, acc);
			}
			
		//	System.debug ('Anchor accountIIBBTaxes:--' + accountIIBBTaxes);

		}
		return accountIIBBTaxes;
	}
// p2 l 165
	/*******************************************************************
    Purpose: get Map of Anchors Level 1 with IIBBtaxes. But this method is obsolet 
    Version: 1.0
    Parameters: Map<Id,Account> accountIIBBTaxes
    Returns:  Map <Id,Account>
    Throws N/A
    ********************************************************************/
	private static Map <Id,Account> getAnchorAccountLevel1IIBBTaxes(Map<Id,Account> accountIIBBTaxes){
		set<ID> accountLevel1 = new set<Id>();
		for (Id accid:accountIIBBTaxes.keySet()){
			if (accountIIBBTaxes.get(accid).UL_Level_1__c != null){
				accountLevel1.add(accountIIBBTaxes.get(accid).UL_Level_1__c);
			}
		}
		// Create Map of Accounts with ID of Level1 Accounts of Anchor Accounts with Related List of IIBBTAX
		Map <Id,Account> accountLevel1IIBBTaxes = null; // = new Map <Id,Account>();

		if(accountLevel1.size()>0){
			accountLevel1IIBBTaxes = new Map <Id,Account>();
			for (Account acc : [SELECT Id, ACCL__Sales_Org__c, 
												(SELECT Id, Account__c, Date_From__c, Date_Thru__c, IIBB_Tax__c 
												FROM IIBBTaxes__r) 
								FROM Account
								Where Id IN :accountLevel1]){
				accountLevel1IIBBTaxes.put (acc.Id, acc);

			}
		}
		
		//  //p2 l 175
	
		//System.debug ('Anchor accountLevel1IIBBTaxes:--' + accountLevel1IIBBTaxes);

		return  accountLevel1IIBBTaxes;
	} 
//P2  L 186
	/*******************************************************************
    Purpose: get Map of account Level 1 belonging to different sales Orgs with IIBBtaxes 
    Version: 1.0
    Parameters: without
    Returns:  Map <String, List<Account>>  =>  SalesOrg , List of Top level Accounts
    Throws N/A
    ********************************************************************/
	private static Map <String, List<Account>> getAnchorAccountTopNodeTaxes(){
		
		Map <String, List<Account>> TopNodeTaxes  = New Map <String, List<Account>> ();
		//P1 L 198 , P2 Limit keywords

			for(account acc:[SELECT Id, ACCL__Sales_Org__c, 
														(SELECT Id, Account__c, Date_From__c, Date_Thru__c, IIBB_Tax__c 
														FROM IIBBTaxes__r) 
													FROM Account
													where UL_Customer_Hierarchy_Level__c =: Ul_Utility.LEVEL1
													order by ACCL__Sales_Org__c ]){
				List<Account> acclist = TopNodeTaxes.get(acc.ACCL__Sales_Org__c);
				if (acclist == null){
					acclist = new List<Account>();
					
				}
				acclist.add(acc);
				TopNodeTaxes.put(acc.ACCL__Sales_Org__c, acclist );	
			}			
		//} 
		return TopNodeTaxes;
	}

 // pr, TopNodeTaxes.get(pr.ACCL__Sales_Org__c  // P2 L 229
 	/*******************************************************************
    Purpose: get IIBBtaxes from Top Level account 
    Version: 1.0
    Parameters: ACCL__Promotion__c prom, List<Account> topAccount
    Returns:  decimal
    Throws N/A
    ********************************************************************/
	private static decimal getTaxTop(ACCL__Promotion__c prom, List<Account> topAccount){
		decimal tax = null;
		for (account acc : topAccount){
			if(acc.IIBBTaxes__r != null ){
				for (IIBBTax__c accTax : acc.IIBBTaxes__r){
					if(accTax.Date_From__c <= prom.ACCL__Date_From__c  && accTax.Date_Thru__c >= prom.ACCL__Date_From__c   ){
						tax = accTax.IIBB_Tax__c;
						break;
					}
				}
			}

			
		}
		return tax;
	}

}