public with sharing class UL_PromotionSetIIBBTaxHandler{
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
*****************************************************************/
public static Map<Id,Decimal> promotionAnchorIIBBTax;
	private static set<ID> accounts = new set<ID>(); 
	private static set<ID> promotionTemplate = new set<ID>();

	public static void updateIIBBTax(List<ACCL__Promotion__c> newPromotions,Map<id,ACCL__Promotion__c> oldPromotionsMap){
		// Create Set of Anchor Accounts ID that relevant to check/ Update the IIBBTAX
		// Set Static Variable wit setIds
		

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
			//boolean iIBTaxesFound = false;
			decimal iIBTaxesFound = null;

			if (validPromotions.containskey(pr.Id)){
				//Check / Update IIBBTax
				//Check First the Anchor IIBBTax

				if(accountIIBBTaxes.containskey(pr.ACCL__Anchor_Account__c)){
				
					iIBTaxesFound = getTax(accountIIBBTaxes, pr.ACCL__Anchor_Account__c, pr, oldPromotionsMap );
					System.debug('IIBBTax  found for Anchor ' + pr.ACCL__Anchor_Account__c + '-- Tax :' + pr.UL_IIBB_Tax__c + ' Promotion ID: -- ' + pr.id);
					// Else Account Level1 of Anchor IIBbTax
					// to get tax of Anchor_Account.UL_Level_1__c
					/*if (iIBTaxesFound == null && accountIIBBTaxes.get(pr.ACCL__Anchor_Account__c).UL_Level_1__c != null){
						iIBTaxesFound = getTax(accountLevel1IIBBTaxes, accountIIBBTaxes.get(pr.ACCL__Anchor_Account__c).UL_Level_1__c, pr, oldPromotionsMap );
					
					}
					*/
					if(iIBTaxesFound == null && TopNodeTaxes.get(pr.ACCL__Sales_Org__c) != null){
						iIBTaxesFound = getTaxTop(pr, TopNodeTaxes.get(pr.ACCL__Sales_Org__c));
					}

				} //if(accountIIBBTaxes.containskey(pr.ACCL__Anchor_Account__c) {

					//Else No IIbb Tax Found Message / at least Log
				if (iIBTaxesFound == null ){
					//Setze pr.UL_IIBB_Tax__c = null
					pr.UL_IIBB_Tax__c = null;
					System.debug('IIBBTax NOT found for Anchor ' + pr.ACCL__Anchor_Account__c + ' -- Tax :' + pr.UL_IIBB_Tax__c + ' Promotion ID: -- ' + pr.id);
					// Schreibe Log oder Message 
				}
				
				//iIBTaxesFound = false;
				if(iIBTaxesFound != null){
					pr.UL_IIBB_Tax__c = iIBTaxesFound;
				}	
				iIBTaxesFound = null;	
			
		
			} //if (validPromotions.containskey(pr.Id)){
		} // for(ACCL__Promotion__c pr: newPromotions){
		System.debug('Final List Of Promotion to update' + newPromotions);	
		
		
	} // close Function  updateIIBBTax

	private static decimal getTax(Map<ID, Account> AccountMap, Id AccountID, ACCL__Promotion__c pr, Map<Id, ACCL__Promotion__c> oldPromotionsMap ){
		decimal iIBTaxesFound = null;

			if(AccountMap.containskey(AccountID)){
				if (AccountMap.get(AccountID).IIBBTaxes__r != null){
					for(IIBBTax__c tax : AccountMap.get(AccountID).IIBBTaxes__r){
						if (tax.Date_From__c <= pr.ACCL__Date_From__c && tax.Date_Thru__c >= pr.ACCL__Date_From__c ){
							iIBTaxesFound = tax.IIBB_Tax__c;
							
							System.debug('IIBBTax found for Account Level 1: '+ tax.Account__c +  'of Anchor ' + AccountID + ' -- Tax :' + tax.IIBB_Tax__c);
							
							if (oldPromotionsMap != null){
								if (oldPromotionsMap.get(pr.Id).UL_IIBB_Tax__c != tax.IIBB_Tax__c){
									iIBTaxesFound = tax.IIBB_Tax__c;
									System.debug('IIBBTax found  Account Level 1: '+ tax.Account__c +  'of Anchor ' + AccountID + ' -- Tax was changed from old :' + oldPromotionsMap.get(pr.Id).UL_IIBB_Tax__c);
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

	private static Map<ID, ACCL__Promotion__c> getPromotionTemplateIIBBTaxSetting(List<ACCL__Promotion__c> newPromotions, set<ID> promotionTemplateSet){
		Map<ID, ACCL__Promotion__c> promotionIIBBTAX = new Map<ID, ACCL__Promotion__c>();

		if(promotionTemplateSet.size()>0){
			promotionIIBBTAX = new Map<ID, ACCL__Promotion__c>([Select Id, Name , ACCL__Promotion_Template__c, 
																				ACCL__Promotion_Template__r.name, ACCL__Promotion_Template__r.UL_Consider_IIBB_Tax__c  
																				From ACCL__Promotion__c 
																  				Where ACCL__Promotion_Template__c in :promotionTemplateSet
																  				And ACCL__Promotion_Template__r.UL_Consider_IIBB_Tax__c = true]);
		
		}

		System.debug ('Valid Promotion for Considering of IIBB Taxes: -- '+ promotionIIBBTAX);
		return promotionIIBBTAX;
	}

	private static void getSetsOfAccountsAndPromotionTemplates(List<ACCL__Promotion__c>  newPromotions){
		for (ACCL__Promotion__c pr: newPromotions){
			if ( pr.ACCL__Anchor_Account__c != null ){
				accounts.add(pr.ACCL__Anchor_Account__c);
			}
			promotionTemplate.add(pr.ACCL__Promotion_Template__c);
		}
		System.debug (' Id ofs  accounts:--' + accounts);
		System.debug (' Ids of promotionTemplate:--' + promotionTemplate);


	}
	private static Map<Id,Account> getAnchorIIBBTaxes(){
		Map <Id,Account> accountIIBBTaxes = new Map <Id,Account>();
		if (accounts.size()>0){

			accountIIBBTaxes = new Map <Id,Account>([SELECT Id,   UL_Level_1__c, UL_Level_1__r.name,
																		(SELECT Id, Account__c, Date_From__c, Date_Thru__c, IIBB_Tax__c 
																		FROM IIBBTaxes__r) 
																	FROM Account
																	Where Id IN :accounts]);
			
			
			System.debug ('Anchor accountIIBBTaxes:--' + accountIIBBTaxes);
			// account acc = accountIIBBTaxes.get('0014C000005WAFuQAO');
			//List<IIBBTAX__c> tax = acc.IIBBTaxes__r;
			//System.debug ('Taxes for Anchor: -- '+ tax);
		}
		return accountIIBBTaxes;
	}

	private static Map <Id,Account> getAnchorAccountLevel1IIBBTaxes(Map<Id,Account> accountIIBBTaxes){
		set<ID> accountLevel1 = new set<Id>();
		for (Id accid:accountIIBBTaxes.keySet()){
			if (accountIIBBTaxes.get(accid).UL_Level_1__c != null){
				accountLevel1.add(accountIIBBTaxes.get(accid).UL_Level_1__c);
			}
		}
		// Create Map of Accounts with ID of Level1 Accounts of Anchor Accounts with Related List of IIBBTAX
		Map <Id,Account> accountLevel1IIBBTaxes = new Map <Id,Account>();
		if(accountLevel1.size()>0){
			 accountLevel1IIBBTaxes = new Map <Id,Account>([SELECT Id,  
																		(SELECT Id, Account__c, Date_From__c, Date_Thru__c, IIBB_Tax__c 
																		FROM IIBBTaxes__r) 
																	FROM Account
																	Where Id IN :accountLevel1]);
		}
		System.debug ('Anchor accountLevel1IIBBTaxes:--' + accountLevel1IIBBTaxes);

		return  accountLevel1IIBBTaxes;
	} 

	private static Map <String, List<Account>> getAnchorAccountTopNodeTaxes(){
		
		Map <String, List<Account>> TopNodeTaxes  = New Map <String, List<Account>> ();
		/*
		for(account acc:TopNodeAccounts){
				if(TopNodeTaxes.contenskey(acc.ACCL__Sales_Org__c)){
					TopNodeTaxes.get(acc.ACCL__Sales_Org__c).add(acc); 
				}else{
					TopNodeTaxes.put(acc.ACCL__Sales_Org__c)
				}
						
			}*/
		List<Account> TopNodeAccounts = [SELECT Id, ACCL__Sales_Org__c, 
														(SELECT Id, Account__c, Date_From__c, Date_Thru__c, IIBB_Tax__c 
														FROM IIBBTaxes__r) 
													FROM Account
													where UL_Customer_Hierarchy_Level__c = 'Level 1'
													order by ACCL__Sales_Org__c limit 1000];
		

		if(TopNodeAccounts.size()>0){
			for(account acc:TopNodeAccounts){
				List<Account> acclist = TopNodeTaxes.get(acc.ACCL__Sales_Org__c);
				if (acclist == null){
					acclist = new List<Account>();
					TopNodeTaxes.put(acc.ACCL__Sales_Org__c, acclist );	
				}
				acclist.add(acc);
				/*if(TopNodeTaxes.contenskey(acc.ACCL__Sales_Org__c)){
					TopNodeTaxes.get(acc.ACCL__Sales_Org__c).add(acc); 
				}else{
					TopNodeTaxes.put(acc.ACCL__Sales_Org__c)
				}
				*/		
			}
			
		} 

		return TopNodeTaxes;


	}
 // pr, TopNodeTaxes.get(pr.ACCL__Sales_Org__c
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
	/*
	private static findLevelAbove(){

 		/*Set<Id> parents = new set<Id>();
 		Set<Id> parentsTop = new set<Id>();
 		Map<>
 		//Id von Anchor, List of Parents Id of Parent, Decimal  = IIBBTax of Parent
 		Map<Id, Map<Id, Decimal>> anchorParentIIBBMap = new Map<Id, Map<Id, Decimal>(); 
 		if (newPromotionMap.keySet() ! = null){
 			list <ACCL__Account_Trade_Org_Hierarchy__c> hierarchyParentfirst = (SELECT Id, Name, ACCL__Child_Account__c,  ACCL__Parent_Account__c,  ACCL__Parent_Account__r.UL_Customer_Hierarchy_Level__c, ACCL__Valid_From__c, ACCL__Valid_Thru__c   
    												FROM ACCL__Account_Trade_Org_Hierarchy__r where ACCL__Child_Account__c  in newPromotionMap.keySet());
 			
 			
 			for ( ACCL__Account_Trade_Org_Hierarchy__c toh : hierarchyParentfirst ){
 				ACCL__Promotion__c prom = newPromotionMap.get(toh.ACCL__Child_Account__c)
 				if (toh.ACCL__Valid_From__c<=prom.Date_From__c && toh.ACCL__Valid_Thru__c >=prom.Date_From__c ){
 					if (toh.UL_Customer_Hierarchy_Level__c='Level 1'){
 						parentsTop.add(toh.ACCL__Parent_Account__c);
 						if (anchorParentIIBBMap.containsKey(toh.ACCL__Child_Account__c)){
 							if (anchorParentIIBBMap.get(toh.ACCL__Child_Account__c) ==null){
 							 	Map <Id, Decimal> parent = new Map <id, Decimal>();orParentIIBBMap = 
 							}
 						} 

 					}
 				}
 				parents.
 			}

 			for ( ACCL__Promotion__c anchor :newPromotion ){

 			}
		*/
		/*
		List <ACCL__Account_Trade_Org_Hierarchy__c> hierarchyParentfirst = (SELECT Id, Name, ACCL__Child_Account__c,  ACCL__Parent_Account__c,  ACCL__Parent_Account__r.UL_Customer_Hierarchy_Level__c, ACCL__Valid_From__c, ACCL__Valid_Thru__c   
    												FROM ACCL__Account_Trade_Org_Hierarchy__r where ACCL__Child_Account__c  = newPromotion.id
    												and ACCL__Valid_From__c <= newPromotion.Date_From__c  And ACCL__Valid_Thru__c >=newPromotion.Date_From__c);
 		
 		if (hierarchyParentfirst.size() >0){
 			
 		} 	


 	}
 		


		/*SELECT Id, Name, ACCL__Child_Account__c, ACCL__Child_Account__r.UL_Customer_Hierarchy_Level__c,ACCL__Parent_Account__c,  ACCL__Parent_Account__r.UL_Customer_Hierarchy_Level__c, ACCL__Valid_From__c, ACCL__Valid_Thru__c   
    FROM ACCL__Account_Trade_Org_Hierarchy__c
 where ACCL__Child_Account__c in ('')  */

	//}
	
}