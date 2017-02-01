public with sharing class UL_IIBBTax_TriggerHandler {
    
    public static void overlapcheck (List<IIBBTax__c> IBBTaxList){
    	
    	try{
    		set <ID> allAcc = getallAccounts(IBBTaxList);
    		Map<Id, List<IIBBTax__c>> IIBBTaxAccounts = getIIBBAcounts(allAcc);

	    	for (IIBBTax__c tax : IBBTaxList){
	    		List <IIBBTax__c> currTaxList  = IIBBTaxAccounts.get(tax.Account__c);

	    		if (currTaxList != null ){
	    			for (IIBBTax__c currTax : currTaxList ){
	    				if (currTax.id <> tax.id && (currTax.Date_From__c <=  tax.Date_Thru__c && currTax.Date_Thru__c>= tax.Date_From__c )){
	    					system.debug ('Overlapping found betwee new tax:' + tax +  'and already existing one ' + currTax );
	    					tax.addError(System.Label.UL_DateOverlapingFound + ' ' +  currTax.Date_From__c  + ' - ' +  currTax.Date_Thru__c);
	    				}
	    			}
	    		}

	    	} 

    	} 
    	catch (Exception o){
    		UL_Utility.logError(o, UserInfo.getUserId());
    		}

    	
    }

    private static set <ID> getallAccounts(List<IIBBTax__c> taxList){
    	set <ID> accounts= new set<ID>(); 
    	for ( IIBBTax__c tax : taxList){
	    	accounts.add(tax.Account__c);	
	    } 
	    return accounts;
    }

    private static Map <Id, List<IIBBTax__c>> getIIBBAcounts(set <Id> acc){
    	Map <Id, List<IIBBTax__c>>  accounts= new Map <Id,List<IIBBTax__c>> (); 

    	for (IIBBTax__c tax :   [SELECT Id, Account__c, Date_From__c, Date_Thru__c FROM IIBBTax__c where Account__c in :acc  order by account__c  ]){
	    	List<IIBBTax__c> la = accounts.get(tax.Account__c);

	    	if (la ==null){
	    		la = new List <IIBBTax__c>();
	    		accounts.put(tax.Account__c, la);
	    	    		
	    	}
	    	la.add(tax);
	    }  
	    return accounts;
    }
}