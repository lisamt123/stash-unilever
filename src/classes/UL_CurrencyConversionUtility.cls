/**********************************************************************
 Name: UID_SetExchangeRateHandler() 
 Copyright © 2016 Salesforce 
 ====================================================== 
 ====================================================== 
 Purpose: 
 1. A utility class used for setting of exchange rate 
	entries to passed objects as well as calculating the
	correct values to be used in Roll-up summary    
 ====================================================== 
 ====================================================== 
 History 
 ------- 
 VERSION AUTHOR DATE DETAIL Description 
 1.0 5/4/2016 INITIAL DEVELOPMENT
 ***********************************************************************/

public class UL_CurrencyConversionUtility {
    
    private static final String CURRENCY_ISO_CODE = 'CurrencyISOCode';
    private static final String CURRENCY_EUR = 'EUR';
    private static final String CURRENCY_USD = 'USD';
    
    
    public static List<sObject> relateExchangeRates(List<sObject> sObjectList) {

        /*
         * CODE Logic:
         * 0 - Parameter Passed is SObjectList
         * 1 - Determine the SObjectiveType
         * 2 - Query Custom Metadata using SObjectiveType
         * 3 - Query Exchange Rate
         * 4.1 - LOOP Custom Metadata
         * 	4.2 - LOOP SObjectList
         * 	 4.3 - LOOP Exchange Rate
         * 	 4.4 - Check if SObject's Date is >= START DATE AND <= END DATE
         * 			- If True, add Exchange Rate Id to SObject
         * 5 - Return SObjectList
         * 
         * Custom Metadata - 2 entries
         * SObject - 100 entries
         * 	- Find the earlies date (June 1) and the latest date (July 31) - range of 60
         * EXR - 365 entries
         * 		- reduce the range to 60 
         * 2 * 100 * 365 = 73000
         * 2 * 100 * 60 = 12000
         * 100 * 60 = 6000
         * 100 = 100
         * 
         * OUR Implementation for UID Order Product
         * cfm meta - 1 entry
         * sobjectlist - 100 entries
         * EXR - 2 entries (2015, 2016)
         * 
         * 1 * 100 * 2 = 200
         * 
         */
        
        
        //Get sObjectType
        String sObjType = String.valueOf(sObjectList.getSObjectType());
        
        //Query Custom Metadata
        List<UL_Currency_Field_Mapping__mdt> cfmMetaList = [SELECT UL_sObject__c, 
                                                    			UL_Source_Field__c, 
                                                    			UL_Date_Field__c, 
                                                    			UL_Exchange_Rate__c,
                                                            	UL_Category__c
															FROM UL_Currency_Field_Mapping__mdt
															WHERE UL_sObject__c = :sobjType];
        
        //Create Year Date Set && Category Set 
        Set<String> yearSet = new Set<String>();
        //Added
        Set<String> categorySet = new Set<String>();
        
        for(UL_Currency_Field_Mapping__mdt cfmMeta : cfmMetaList) {
        	for(sObject sObj : sObjectList) {
            	Date dateField = Date.valueOf(sObj.get(String.valueOf(cfmMeta.UL_Date_Field__c)));
                yearSet.add(String.valueOf(dateField.year()));
                //Added
                String categoryField = String.valueOf(sObj.get(String.valueOf(cfmMeta.UL_Category__c)));
                categorySet.add(categoryField);
        	}
        }
        
        //Query Exchange Rate
        List<UL_Exchange_Rate__c> exRateList = [SELECT Id,
                                                 			UL_Start_Date__c,
                                                 			UL_End_Date__c                                                 			
                                                 	FROM UL_Exchange_Rate__c
                                               		WHERE UL_Year__c IN : yearSet
                                               			AND UL_Category__c IN : categorySet];
		System.debug('yearSet: ' + yearSet);
        System.debug('categorySet: ' + categorySet);
        System.debug('categorySet: ' + exRateList);
        System.debug('sObjectList: ' + sObjectList);
        
        for(UL_Currency_Field_Mapping__mdt cfmMeta : cfmMetaList) {
        
            for(sObject sObj : sObjectList) {
            	//Date dateField = (Date) sObj.get(String.valueOf(cfmMeta.UL_Date_Field__c));
            	Date dateField = Date.valueOf(sObj.get(String.valueOf(cfmMeta.UL_Date_Field__c)));

				//outerExRateMap.
                
                for(UL_Exchange_Rate__c exRate : exRateList) {
                    
                    //normal case Jan 1, 2015 - Dec 31, 2015
                    //month - June 15, 2015
                    // June 15                        Jan 1
                    if(dateField >= exRate.UL_Start_Date__c
                       								//   Dec 31
                                && dateField <= exRate.UL_End_Date__c ) {
                    	sObj.put(String.valueOf(cfmMeta.UL_Exchange_Rate__c), exRate.Id);
                    }
                    //EDGE case
                    //date is in the future
                    //date is in the far past
                }				
        	}
        }
        
        return sObjectList;
    }    
    
    /*
     * Note: This method must be called only after records to be passed already 
     * have been paired with thier corresponding ExchangeRate lookup
     * Code Logic:
     * 1 - Determine sObjectType
     * 2 - Query Custom Metadata using sObjectType 
     * 3 - Query all active currencies of CurrencyType standard object
     */
    public static List<sObject> convertCurrencyAmounts(List<sObject> sObjectList) {
        //Get sObjectType
        String sObjType = String.valueOf(sObjectList.getSObjectType());
        
        //Query Custom Metadata
        List<UL_Currency_Field_Mapping__mdt> cfmMetaList = [SELECT UL_sObject__c, 
                                                    			UL_Source_Field__c, 
                                                    			UL_Date_Field__c, 
                                                    			UL_Exchange_Rate__c
															FROM UL_Currency_Field_Mapping__mdt
															WHERE UL_sObject__c = :sobjType];
        
        //Create Year Date Set
        Set<String> yearSet = new Set<String>();        
        for(UL_Currency_Field_Mapping__mdt cfmMeta : cfmMetaList) {
        	for(sObject sObj : sObjectList) {
            	Date dateField = Date.valueOf(sObj.get(String.valueOf(cfmMeta.UL_Date_Field__c)));
                yearSet.add(String.valueOf(dateField.year()));
        	}
        }
        
        //Query CurrencyType
        String queryCurrency = '';
        List<CurrencyType> currencyTypeList = [SELECT IsoCode
                                              	FROM CurrencyType
                                              	WHERE IsActive = true];
        for(CurrencyType curr : currencyTypeList) {
            queryCurrency = queryCurrency + 'UL_' + curr.IsoCode + '__c, ';
        }
        
        
        //Query Exchange Rate
        String query = 'SELECT Id, ' + queryCurrency + 'UL_Category__c FROM UL_Exchange_Rate__c WHERE UL_Year__c IN :yearSet';
        List<UL_Exchange_Rate__c> exchangeRateList = database.query(query);
        
        Map<Id, UL_Exchange_Rate__c> exchangeRateMap = new Map<Id, UL_Exchange_Rate__c>(exchangeRateList);
        
        for(UL_Currency_Field_Mapping__mdt cfmMeta : cfmMetaList) {
            for(sObject sObj : sObjectList) {
                
                Id exRateId = (Id) sObj.get(String.valueOf(cfmMeta.UL_Exchange_Rate__c));
                if(exRateId != null) {
                	//Roll Up Field name is Source Field + Currency ISO
            		String sourceField = String.valueOf(cfmMeta.UL_Source_Field__c);
					Decimal sourceEUR = 0;
                
                	String currIsoCode = String.valueOf(sObj.get(String.valueOf(CURRENCY_ISO_CODE)));
                
                
                	sObject exchangeRate = (sObject) exchangeRateMap.get(exRateId);
                
                    String exchangeRateFieldName = 'UL_' + currIsoCode + '__c';                
                
                	sourceEUR = (Decimal) sObj.get(sourceField) / (Decimal) exchangeRate.get(exchangeRateFieldName);
                
                	for(CurrencyType currType : currencyTypeList) {
                    	//Example values of rollUpField: UID_IOP_EUR__c, UID_IOP_USD__c
                    	String rollUpField = sourceField.replace('__c', '_' + currType.IsoCode + '__c');
                    
                    	exchangeRateFieldName = 'UL_' + currType.IsoCode + '__c';
                    	Decimal rateOfExchange = (Decimal) exchangeRate.get(exchangeRateFieldName);
                    
						sObj.put(rollUpField, sourceEUR * rateOfExchange);
                	}
            	}
            }
        }
        
        return sObjectList;
    }
}