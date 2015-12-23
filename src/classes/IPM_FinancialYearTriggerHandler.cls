/**
* @author       Cognizant (Vipul)
* @date         27/04/2015
* @description  This class is used for managing the trigger methods for IPM_Financial_Year__c object 
*/
public with sharing class IPM_FinancialYearTriggerHandler{
    public static boolean firstRun = true;
    
    private transient Map<String, IPM_Financial_Year__c> mapUpsertFY; //Map of IPM_Financial_Year__c records to be upserted
    private Map<String, IPM_Financial_Year__c> mapAllConsolidatedFinancialYears; //Map of ALL relevant consolidated IPM_Financial_Year__c records

    private Map<String, String> mapGlobalConsolidatedFY; //Map of GLOBAL consolidated IPM_Financial_Year__c records
    private Map<String, String> mapRegionalConsolidatedFY; //Map of REGIONAL consolidated IPM_Financial_Year__c records

    private static String DEFAULT_FINANCIAL_RECORDTYPE; //Recordtype Id for Default on IPM_Financial__c object
    private static String CONSOLIDATED_FINANCIAL_RECORDTYPE; //Recordtype Id for Consolidated on IPM_Financial__c object
    private static final String UPDATE_FINANCIAL_ACTION_STANDARD_STR='updateFinancialActionStandard';
    private static final String CLASS_NAME = IPM_FinancialYearTriggerHandler.Class.getName(); //Class Name for Exception Logging
    private static Boolean IS_RECURSSIVE = false;
    
    /*******************************************************************************************************
    * @description              Method to handle before delete Trigger context for IPM_Financial__c object
    * @param mapOldFinancials   Map of Trigger.old records
    * @return                   NONE
    */
    public void onBeforeDelete(Map<Id, IPM_Financial_Year__c> mapOldFinancialYears)
    {
        initialiseFYConsolidation(null, mapOldFinancialYears);
    }

    /*******************************************************************************************************
    * @description                  Method to handle after update Trigger context for 
    *                               IPM_Financial_Year__c object
    * @param mapNewFinancialYears   Map of Trigger.new records
    * @param mapOldFinancialYears   Map of Trigger.old records
    * @return                       NONE
    */
    public void onAfterUpdate(Map<Id, IPM_Financial_Year__c> mapNewFinancialYears, Map<Id, IPM_Financial_Year__c> mapOldFinancialYears)
    {
        initialiseFYConsolidation(mapNewFinancialYears, mapOldFinancialYears);
    }
    
    /*******************************************************************************************************
    * @description                      Method to initialise consolidation of financial year records
    * @param mapNewFinancialYears       Map of Trigger.new records
    * @param mapOldFinancialYears       Map of Trigger.old records
    * @return                           NONE
    */
    private void initialiseFYConsolidation(Map<Id, IPM_Financial_Year__c> mapNewFinancialYears, Map<Id, IPM_Financial_Year__c> mapOldFinancialYears){
        DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
        CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
        
        if(DEFAULT_FINANCIAL_RECORDTYPE.length() > 15){
        	DEFAULT_FINANCIAL_RECORDTYPE = DEFAULT_FINANCIAL_RECORDTYPE.subString(0,15);
        }

        if(CONSOLIDATED_FINANCIAL_RECORDTYPE.length() > 15){
        	CONSOLIDATED_FINANCIAL_RECORDTYPE = CONSOLIDATED_FINANCIAL_RECORDTYPE.subString(0,15);
        }

        mapGlobalConsolidatedFY = new Map<String, String>();
        mapRegionalConsolidatedFY = new Map<String, String>();

        mapUpsertFY = new Map<String, IPM_Financial_Year__c>();
        
        if(mapNewFinancialYears != null)
        {
            //Consolidate Financials
            getConsolidatedFinancialYears(mapNewFinancialYears.values());

            for(IPM_Financial_Year__c newFinancialYear : mapNewFinancialYears.values())
            {
                if(newFinancialYear.Financial_RecordtypeId__c == DEFAULT_FINANCIAL_RECORDTYPE)
                {
                    //Process Global Consolidation for Global Original Projects only
                    if(newFinancialYear.Global_External_Id__c != null && newFinancialYear.Global_External_Id__c != '')
                    {
                        consolidateFinancials(newFinancialYear, mapOldFinancialYears.get(newFinancialYear.Id), IPM_ConstantUtils.PROJECT_SPAN_GLOBAL);
                    }
                    
                    consolidateFinancials(newFinancialYear, mapOldFinancialYears.get(newFinancialYear.Id), IPM_ConstantUtils.PROJECT_SPAN_REGIONAL);
                }
            }
            
        }
        else{
            getConsolidatedFinancialYears(mapOldFinancialYears.values());
            
            for(IPM_Financial_Year__c oldFinancialYear : mapOldFinancialYears.values()){
                if(oldFinancialYear.Financial_RecordtypeId__c == DEFAULT_FINANCIAL_RECORDTYPE){
                    //Process Global Consolidation for Global Original Projects only
                    if(oldFinancialYear.Global_External_Id__c != null && oldFinancialYear.Global_External_Id__c != ''){
                    	consolidateFinancials(null, oldFinancialYear, IPM_ConstantUtils.PROJECT_SPAN_GLOBAL);
                    }
                    consolidateFinancials(null, oldFinancialYear, IPM_ConstantUtils.PROJECT_SPAN_REGIONAL);
                }
            }
        }

        if(mapUpsertFY != null && !mapUpsertFY.isEmpty()) {
            Database.upsert(mapUpsertFY.values(), IPM_Financial_Year__c.External_ID__c, false);
        }
    }
    
    /*******************************************************************************************************
    * @description                  Method to get relevant Consolidated Financial Years
    * @param lstFinancialYears      List of Financial Year Records to be processed
    * @return                       NONE
    */
    private void getConsolidatedFinancialYears(List<IPM_Financial_Year__c> lstFinancialYears)
    {
        Set<String> setFinancialExternalIds = new Set<String>();
        
        for(IPM_Financial_Year__c financialYear : lstFinancialYears)
        {
            if(financialYear.Global_External_Id__c != null && financialYear.Global_External_Id__c != '')
            {
                String globalExternalId = financialYear.Global_External_Id__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
                mapGlobalConsolidatedFY.put(financialYear.Id, globalExternalId);
                setFinancialExternalIds.add(globalExternalId);
            }

            if(financialYear.Regional_External_Id__c != null && financialYear.Regional_External_Id__c != '')
            {
                String regionalExternalId = financialYear.Regional_External_Id__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
                mapRegionalConsolidatedFY.put(financialYear.Id, regionalExternalId);
                setFinancialExternalIds.add(regionalExternalId);
            }
        }
    
        String queryString = 'SELECT ';
        //IPM Financial
        For (String field : Schema.SObjectType.IPM_Financial_Year__c.fields.getMap().KeySet()){
            if (field != 'Id'){
            	queryString+= field + ', ';
            }
        }
        queryString+= 'Id FROM IPM_Financial_Year__c WHERE Financial_External_ID__c IN: setFinancialExternalIds';
        
        mapAllConsolidatedFinancialYears = new Map<String, IPM_Financial_Year__c>();
        list<IPM_Financial_Year__c> lstFin = new  list<IPM_Financial_Year__c>();
        lstFin = Database.query(queryString);
        
        
        
        for(IPM_Financial_Year__c consollidatedFinancialYear : lstFin)
        {
            mapAllConsolidatedFinancialYears.put(consollidatedFinancialYear.External_ID__c, consollidatedFinancialYear);
        }

    }

    /*******************************************************************************************************
    * @description              Method to consiolidate financials
    * @param newFinancial       New Financial record
    * @param oldFinancial       Old Financial records
    * @param consolidationType  Consolidation type
    * @return                   NONE
    */
    private void consolidateFinancials(IPM_Financial_Year__c newFinancialYear, IPM_Financial_Year__c oldFinancialYear, String consolidationType){
        String newConsolidatedFinExtId = '';
        String oldConsolidatedFinExtId = '';
        if(consolidationType == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
        {
            if(newFinancialYear != null)
            {
                newConsolidatedFinExtId = mapGlobalConsolidatedFY.get(newFinancialYear.Id);
                
            }
            oldConsolidatedFinExtId = mapGlobalConsolidatedFY.get(oldFinancialYear.Id);
        } 
        else if(consolidationType == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
        {
            if(newFinancialYear != null)
            {
                newConsolidatedFinExtId = mapRegionalConsolidatedFY.get(newFinancialYear.Id);
            }
            oldConsolidatedFinExtId = mapRegionalConsolidatedFY.get(oldFinancialYear.Id);
        }

        //New Consolidated Financial
        String newConsolidatedFYExtId = '';
        IPM_Financial_Year__c newConsolidatedFY =  new IPM_Financial_Year__c();
        if(newFinancialYear != null)
        {
            newConsolidatedFYExtId = getFinancialYearExternalId(newConsolidatedFinExtId, newFinancialYear.Name, newFinancialYear.Year_Type__c, newFinancialYear.PL_Type__c);
                
            newConsolidatedFY = mapAllConsolidatedFinancialYears.get(newConsolidatedFYExtId);
            if(mapUpsertFY.containsKey(newConsolidatedFYExtId))
            {
                newConsolidatedFY = mapUpsertFY.get(newConsolidatedFYExtId);
            }
        }
        
        //Old Consolidated Financial
        String oldConsolidatedFYExtId = getFinancialYearExternalId(oldConsolidatedFinExtId, oldFinancialYear.Name, oldFinancialYear.Year_Type__c, oldFinancialYear.PL_Type__c);
        
        IPM_Financial_Year__c oldConsolidatedFY = mapAllConsolidatedFinancialYears.get(oldConsolidatedFYExtId);

        if(mapUpsertFY.containsKey(oldConsolidatedFYExtId)){
        	oldConsolidatedFY = mapUpsertFY.get(oldConsolidatedFYExtId);
        }
       
        if(newFinancialYear !=  null){
            if(newConsolidatedFY == null && newFinancialYear.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR){
                //Create new Financial Year
                Integer index;
                if(newFinancialYear.NameYearPLtype__c != IPM_ConstantUtils.Y0Calendar){
                	index = Integer.valueOf(newFinancialYear.Name) - oldFinancialYear.Target_Launch_Date__c.year() + 1;
                }
                  
                newConsolidatedFY = new IPM_Financial_Year__c(
                    IPM_Financial__r = new IPM_Financial__c(Financial_External_ID__c = newConsolidatedFinExtId),
                    External_Id__c = newConsolidatedFYExtId,
                    Name = newFinancialYear.Name,
                    Year__c = '' + index,
                    Year_Type__c = newFinancialYear.Year_Type__c,
                    PL_Type__c = newFinancialYear.PL_Type__c
                );
            }
        }

        consolidateFinancialRecord(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY);
    }
    
    /*******************************************************************************************************
    * @description                  Method to consiolidate financial records
    * @param newFinancialYear       New Financial Year record
    * @param newConsolidatedFY      New Consolidated Financial Year record
    * @param oldFinancialYear       Old Financial Year record
    * @param oldConsolidatedFY      Old Consolidated Financial Year record
    * @return                       NONE
    */
    private void consolidateFinancialRecord(IPM_Financial_Year__c newFinancialYear, IPM_Financial_Year__c newConsolidatedFY, IPM_Financial_Year__c oldFinancialYear, IPM_Financial_Year__c oldConsolidatedFY){
       // processConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY, IPM_ConstantUtils.FIELD_LITERAL_VOLUME);
       // processConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY, IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS);
       // processConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY, IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE);
        processConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY, IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS);
        processConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY, IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT);
        processConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY, IPM_ConstantUtils.FIELD_LITERAL_TURNOVER);
        processConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY, IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS);
        processVolumeConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY);
    }

    /*******************************************************************************************************
    * @description                  Method to process consolidation
    * @param newFinancialYear       New Financial Year record
    * @param newConsolidatedFY      New Consolidated Financial Year record
    * @param oldFinancialYear       Old Financial Year record
    * @param oldConsolidatedFY      Old Consolidated Financial Year record
    * @param fieldName              fieldname of the field to be consolidated
    * @return                       NONE
    */
    private void processConsolidation(IPM_Financial_Year__c newFinancialYear, IPM_Financial_Year__c newConsolidatedFY, IPM_Financial_Year__c oldFinancialYear, IPM_Financial_Year__c oldConsolidatedFY, String fieldName){
        IPM_Financial_Year__c newConsFY = newConsolidatedFY;
        IPM_Financial_Year__c oldConsFY = oldConsolidatedFY;
        Set<String> fieldSufixes = new Set<String>{IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, IPM_ConstantUtils.PROJECT_SPAN_REGIONAL, IPM_ConstantUtils.PROJECT_SPAN_LOCAL};
        Decimal value;
        for(String suffix : fieldSufixes){
            Object newValueObject = null;
        	String newFieldName = fieldname + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX;
            //NEW Consolidated Financial Year
            if(newFinancialYear != null && newConsFY != null){
                if(mapUpsertFY !=null && newConsFY != null && newFieldName != null && mapUpsertFY.containsKey(newConsFY.External_ID__c)) {
                    newConsFY = mapUpsertFY.get(newConsFY.External_ID__c);
                    newValueObject = newConsFY.get(newFieldName);
                }
                if(newValueObject == null){
            		value = (Decimal) newFinancialYear.get(newFieldName);
                }
                else{
                	value = (Decimal) newConsFY.get(newFieldName) + (Decimal) newFinancialYear.get(newFieldName);
                }
                newConsFY.put(newFieldName, value);
                mapUpsertFY.put(newConsFY.External_ID__c, newConsFY);
            }

            //OLD Consolidated Financial Year
            if(oldConsFY!=null) {
                 if(mapUpsertFY.containsKey(oldConsFY.External_ID__c)){
             		oldConsFY = mapUpsertFY.get(oldConsFY.External_ID__c);
                 }
                value = (Decimal) oldConsFY.get(newFieldName) - (Decimal) oldFinancialYear.get(newFieldName);
                oldConsFY.put(newFieldName, value);
                
                mapUpsertFY.put(oldConsFY.External_ID__c, oldConsFY);
            }
        }
    }

    /*******************************************************************************************************
    * @description                  Method to process consolidation for Volume
    * @param newFinancialYear       New Financial Year record
    * @param newConsolidatedFY      New Consolidated Financial Year record
    * @param oldFinancialYear       Old Financial Year record
    * @param oldConsolidatedFY      Old Consolidated Financial Year record
    * @return                       NONE
    */
    private void processVolumeConsolidation(IPM_Financial_Year__c newFinancialYear, IPM_Financial_Year__c newConsolidatedFY, IPM_Financial_Year__c oldFinancialYear, IPM_Financial_Year__c oldConsolidatedFY){
        IPM_Financial_Year__c newConsFY = newConsolidatedFY;
        IPM_Financial_Year__c oldConsFY = oldConsolidatedFY;
        Set<String> fieldSufixes = new Set<String>{IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, IPM_ConstantUtils.PROJECT_SPAN_REGIONAL, IPM_ConstantUtils.PROJECT_SPAN_LOCAL};
        Decimal value;
        for(String suffix : fieldSufixes){
            String newVolumeUnit;
            if(newFinancialYear != null){
            	newVolumeUnit = (String) newFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_UNIT + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            }
                
            String oldVolumeUnit = (String) oldFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_UNIT + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);

            //NEW Consolidated Financial Year
            if(newFinancialYear != null && mapUpsertFY != null && newConsFY != null){
                if(mapUpsertFY.containsKey(newConsFY.External_ID__c)){
                	newConsFY = mapUpsertFY.get(newConsFY.External_ID__c);
                }
                    
                Object newValueObject = newConsFY.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                if(newValueObject == null){
                    if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS)){
                        value = (Decimal) newFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                        newConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
                    
                    } else if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS)){
                        value = (Decimal) newFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                        newConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
    
                    }else if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS)){
                        value = (Decimal) newFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                        newConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
    
                    }else if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS)){
                        value = (Decimal) newFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                        newConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
                    }
                } else {
    
                    if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS)){
                        value = (Decimal) newConsFY.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) + (Decimal) newFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                        newConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
                    
                    }else if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS)){
                        value = (Decimal) newConsFY.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) + (Decimal) newFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                        newConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
    
                    }else if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS)){
                        value = (Decimal) newConsFY.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) + (Decimal) newFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                        newConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
    
                    }else if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS)){
                        value = (Decimal) newConsFY.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) + (Decimal) newFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                        newConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
                    }
                }
                mapUpsertFY.put(newConsFY.External_ID__c, newConsFY);
            }

            //OLD Consolidated Financial Year
            if(oldConsFY!=null) {
                if(mapUpsertFY.containsKey(oldConsFY.External_ID__c)){
                	oldConsFY = mapUpsertFY.get(oldConsFY.External_ID__c);
                }
                    
                if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS)){
                    value = (Decimal) oldConsFY.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) - (Decimal) oldFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                    oldConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
    
                }else if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS)){
                    value = (Decimal) oldConsFY.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) - (Decimal) oldFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                    oldConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
    
                }else if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS)){
                    value = (Decimal) oldConsFY.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) - (Decimal) oldFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                    oldConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
    
                }else if((newVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == IPM_ConstantUtils.VOLUME_UNIT_TONS)){
                    value = (Decimal) oldConsFY.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) - (Decimal) oldFinancialYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                    oldConsFY.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
                }
                
                mapUpsertFY.put(oldConsFY.External_ID__c, oldConsFY);
            }
        }
    }
    
    /*******************************************************************************************************
    * @description                  Method to generate IPM_Financial_Year__c external id
    * @param financialExternalId    Parent Financial External Id
    * @param yearName               Year Name
    * @param yearType               Year Type
    * @param plType                 P&L Name
    * @return                       Financial Year external Id
    */
    private String getFinancialYearExternalId(String financialExternalId, String yearName, String yearType, String plType){
        return financialExternalId + '_' + yearName + '_' + yearType + '_' + plType;
    }
    
    /*******************************************************************************************************
    * @description                  Method to update Financial Action Standards
    * @param newFinancialYear       New Financial Year record
    * @return                       NONE
    */
    public void updateFinancialActionStandard(Map<Id, IPM_Financial_Year__c> mapNewFinancialYears){
        try{
            List<IPM_Financial_Year__c> newFinYearList=new  List<IPM_Financial_Year__c>();
            List<IPM_Project_Document_Section_Content__c> projDocSecConList=new List<IPM_Project_Document_Section_Content__c>();
            Set<Id> projectIds=new Set<Id>();
            for(IPM_Financial_Year__c newFinYear:mapNewFinancialYears.values()){
                if((newFinYear.Financial_External_Id__c.contains(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE) || newFinYear.Financial_External_Id__c.contains(IPM_ConstantUtils.FINANCIAL_DEFAULT)) && (newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental || newFinYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross) && !newFinYear.Charter_Approved__c && (String.isBlank(newFinYear.Regional_External_Id__c) || (String.isBlank(newFinYear.Global_External_Id__c) && String.isNotBlank(newFinYear.Regional_External_Id__c)))){
                    newFinYearList.add(newFinYear);
                    projectIds.add(newFinYear.Global_Project_Id__c);
                }
            }
            if(projectIds!=null && !projectIds.isEmpty()){
                projDocSecConList=[SELECT Id,IPM_iTo_Action_Standard_Charter__c,IPM_Innov_Value_Share_Action_Charter__c,IPM_Inc_Value_Share_Action_Charter__c,IPM_gTO_Action_Standard_Charter__c,IPM_GM_Action_Standards_Charter__c,
                                   IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c,IPM_Content_Type__c,
                                   IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Phase__c
                                   FROM IPM_Project_Document_Section_Content__c
                                   WHERE IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c In:projectIds AND IPM_Content_Type__c=:IPM_ConstantUtils.FINANCIAL_ACTION_STANDARDS AND 
                                         IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Phase__c=:IPM_ConstantUtils.PHASE_IDEAS];  
            }
            for(IPM_Financial_Year__c finYear:newFinYearList){  
                for(IPM_Project_Document_Section_Content__c secContent:projDocSecConList){  
                    if(secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c==finYear.Global_Project_Id__c){
                        if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental){
                            secContent.IPM_Inc_Value_Share_Action_Charter__c=finYear.Value_Market_Share_Global__c;
                            secContent.IPM_iTo_Action_Standard_Charter__c=finYear.Turnover_Global__c;
                        }
                        if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross){
                            secContent.IPM_Innov_Value_Share_Action_Charter__c=finYear.Value_Market_Share_Global__c;
                            secContent.IPM_gTO_Action_Standard_Charter__c=finYear.Turnover_Global__c;
                            secContent.IPM_GM_Action_Standards_Charter__c=finYear.GM_of_TO_Global__c;
                        }
                    }
                }
            }
            if(projDocSecConList!=null && !projDocSecConList.isEmpty()){
                update projDocSecConList;
            }
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                UPDATE_FINANCIAL_ACTION_STANDARD_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
    }
}