public without sharing class IPMFinancialYearTriggerHandler{

    private transient Map<String, IPM_Financial_Year__c> mapUpsertFY;
    private Map<String, IPM_Financial_Year__c> mapAllConsolidatedFinancialYears;

    private Map<String, String> mapGlobalConsolidatedFY;
    private Map<String, String> mapRegionalConsolidatedFY;

    private static String DEFAULT_FINANCIAL_RECORDTYPE;
    private static String CONSOLIDATED_FINANCIAL_RECORDTYPE;

    private static String VOLUME_UNIT_TONS = 'Total Tons';
    private static String VOLUME_UNIT_000_UNITS = 'Total \'000 Units';

    private static String PL_TYPE_GROSS = 'Gross';
    private static String PL_TYPE_INCREMENTAL = 'Incremental';
    private static String YEAR_TYPE_INNOVATION = 'Innovation';
    private static String YEAR_TYPE_CALENDAR = 'Calendar';
    
    private static String TYPE_GLOBAL = 'Global';
    private static String TYPE_REGIONAL = 'Regional';
    private static String TYPE_LOCAL = 'Local';
    
    public void onAfterUpdate(Map<Id, IPM_Financial_Year__c> mapNewFinancialYears, Map<Id, IPM_Financial_Year__c> mapOldFinancialYears){
        DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Consolidated').getRecordTypeId();
        
        if(DEFAULT_FINANCIAL_RECORDTYPE.length() > 15)
            DEFAULT_FINANCIAL_RECORDTYPE = DEFAULT_FINANCIAL_RECORDTYPE.subString(0,15);

        if(CONSOLIDATED_FINANCIAL_RECORDTYPE.length() > 15)
            CONSOLIDATED_FINANCIAL_RECORDTYPE = CONSOLIDATED_FINANCIAL_RECORDTYPE.subString(0,15);

        mapGlobalConsolidatedFY = new Map<String, String>();
        mapRegionalConsolidatedFY = new Map<String, String>();

        Set<String> setFinancialExternalIds = new Set<String>();

        For(IPM_Financial_Year__c financialYear : mapNewFinancialYears.values()){
            String globalExternalId = financialYear.Global_External_Id__c + '_CONSOLIDATED';
            mapGlobalConsolidatedFY.put(financialYear.Id, globalExternalId);
            setFinancialExternalIds.add(globalExternalId);

            String regionalExternalId = financialYear.Regional_External_Id__c + '_CONSOLIDATED';
            mapRegionalConsolidatedFY.put(financialYear.Id, regionalExternalId);
            setFinancialExternalIds.add(regionalExternalId);
        }

        //Consolidate Financials
        getConsolidatedFinancialYears(setFinancialExternalIds);
        mapUpsertFY = new Map<String, IPM_Financial_Year__c>();
        for(IPM_Financial_Year__c financialYear : mapNewFinancialYears.values()){
            if(financialYear.Financial_RecordtypeId__c == DEFAULT_FINANCIAL_RECORDTYPE){
                consolidateFinancials(financialYear, mapOldFinancialYears.get(financialYear.Id), TYPE_GLOBAL);
                consolidateFinancials(financialYear, mapOldFinancialYears.get(financialYear.Id), TYPE_REGIONAL);
            }
        }

        if(mapUpsertFY.size() > 0)
            Database.upsert(mapUpsertFY.values(), IPM_Financial_Year__c.External_ID__c, false);

    }

    private void getConsolidatedFinancialYears(Set<String> setFinancialExternalIds){
        String queryString = 'SELECT ';
        //IPM Financial
        For (String field : Schema.SObjectType.IPM_Financial_Year__c.fields.getMap().KeySet()){
            if (field != 'Id')
                queryString+= field + ', ';
        }
        queryString+= 'Id FROM IPM_Financial_Year__c WHERE Financial_External_ID__c IN: setFinancialExternalIds';
        
        mapAllConsolidatedFinancialYears = new Map<String, IPM_Financial_Year__c>();
        For(IPM_Financial_Year__c consollidatedFinancialYear : Database.query(queryString))
            mapAllConsolidatedFinancialYears.put(consollidatedFinancialYear.External_ID__c, consollidatedFinancialYear);

    }

    private void consolidateFinancials(IPM_Financial_Year__c newFinancialYear, IPM_Financial_Year__c oldFinancialYear, String consolidationType){
        String newConsolidatedFinExtId;
        String oldConsolidatedFinExtId;
        if(consolidationType == TYPE_GLOBAL){
            newConsolidatedFinExtId = mapGlobalConsolidatedFY.get(newFinancialYear.Id);
            oldConsolidatedFinExtId = mapGlobalConsolidatedFY.get(oldFinancialYear.Id);
        
        } else if(consolidationType == TYPE_REGIONAL){
            newConsolidatedFinExtId = mapRegionalConsolidatedFY.get(newFinancialYear.Id);
            oldConsolidatedFinExtId = mapRegionalConsolidatedFY.get(oldFinancialYear.Id);

        }

        String newConsolidatedFYExtId = getFinancialYearExternalId(newConsolidatedFinExtId, newFinancialYear.Name, newFinancialYear.Year_Type__c, newFinancialYear.PL_Type__c);
        String oldConsolidatedFYExtId = getFinancialYearExternalId(oldConsolidatedFinExtId, oldFinancialYear.Name, oldFinancialYear.Year_Type__c, oldFinancialYear.PL_Type__c);

        IPM_Financial_Year__c newConsolidatedFY = mapAllConsolidatedFinancialYears.get(newConsolidatedFYExtId);
        IPM_Financial_Year__c oldConsolidatedFY = mapAllConsolidatedFinancialYears.get(oldConsolidatedFYExtId);

        if(mapUpsertFY.containsKey(newConsolidatedFYExtId))
            newConsolidatedFY = mapUpsertFY.get(newConsolidatedFYExtId);

        if(mapUpsertFY.containsKey(oldConsolidatedFYExtId))
            oldConsolidatedFY = mapUpsertFY.get(oldConsolidatedFYExtId);
        
        if(newConsolidatedFY == null && newFinancialYear.Year_Type__c == YEAR_TYPE_CALENDAR){
            //Create new Financial Year
            Integer index = Integer.valueOf(newFinancialYear.Name) - oldFinancialYear.Target_Launch_Date__c.year() + 1;
            newConsolidatedFY = new IPM_Financial_Year__c(
                IPM_Financial__r = new IPM_Financial__c(Financial_External_ID__c = newConsolidatedFinExtId),
                External_Id__c = newConsolidatedFYExtId,
                Name = newFinancialYear.Name,
                Year__c = '' + index,
                Year_Type__c = newFinancialYear.Year_Type__c,
                PL_Type__c = newFinancialYear.PL_Type__c
            );
        }

        consolidateFinancialRecord(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY);
    }
    
    private void consolidateFinancialRecord(IPM_Financial_Year__c newFinancialYear, IPM_Financial_Year__c newConsolidatedFY, IPM_Financial_Year__c oldFinancialYear, IPM_Financial_Year__c oldConsolidatedFY){
        processConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY, 'Advertising_Promotions');
        processConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY, 'Gross_Profit');
        processConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY, 'Turnover');
        processConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY, 'Profit_Before_Overheads');
        processVolumeConsolidation(newFinancialYear, newConsolidatedFY, oldFinancialYear, oldConsolidatedFY);
    }

    private void processConsolidation(IPM_Financial_Year__c newFinancialYear, IPM_Financial_Year__c newConsolidatedFY, IPM_Financial_Year__c oldFinancialYear, IPM_Financial_Year__c oldConsolidatedFY, String fieldName){
        Set<String> fieldSufixes = new Set<String>{TYPE_GLOBAL, TYPE_REGIONAL, TYPE_LOCAL};
        Decimal value;
        For(String suffix : fieldSufixes){
            //NEW Consolidated Financial Year
            if(mapUpsertFY.containsKey(newConsolidatedFY.External_ID__c))
                newConsolidatedFY = mapUpsertFY.get(newConsolidatedFY.External_ID__c);
            Object newValueObject = newConsolidatedFY.get(fieldname + '_' + suffix + '__c');
            if(newValueObject == null)
                value = (Decimal) newFinancialYear.get(fieldname + '_' + suffix + '__c');
            else
                value = (Decimal) newConsolidatedFY.get(fieldname + '_' + suffix + '__c') + (Decimal) newFinancialYear.get(fieldname + '_' + suffix + '__c');

            newConsolidatedFY.put(fieldname + '_' + suffix + '__c', value);
            mapUpsertFY.put(newConsolidatedFY.External_ID__c, newConsolidatedFY);

            //OLD Consolidated Financial Year
            if(mapUpsertFY.containsKey(oldConsolidatedFY.External_ID__c))
                oldConsolidatedFY = mapUpsertFY.get(oldConsolidatedFY.External_ID__c);
            value = (Decimal) oldConsolidatedFY.get(fieldname + '_' + suffix + '__c') - (Decimal) oldFinancialYear.get(fieldname + '_' + suffix + '__c');
            oldConsolidatedFY.put(fieldname + '_' + suffix + '__c', value);
            
            mapUpsertFY.put(oldConsolidatedFY.External_ID__c, oldConsolidatedFY);
        }
    }

    private void processVolumeConsolidation(IPM_Financial_Year__c newFinancialYear, IPM_Financial_Year__c newConsolidatedFY, IPM_Financial_Year__c oldFinancialYear, IPM_Financial_Year__c oldConsolidatedFY){
        Set<String> fieldSufixes = new Set<String>{TYPE_GLOBAL, TYPE_REGIONAL, TYPE_LOCAL};
        Decimal value;
        For(String suffix : fieldSufixes){
            String newVolumeUnit = (String) newFinancialYear.get('Volume_Unit_' + suffix + '__c');
            String oldVolumeUnit = (String) oldFinancialYear.get('Volume_Unit_' + suffix + '__c');

            //NEW Consolidated Financial Year
            if(mapUpsertFY.containsKey(newConsolidatedFY.External_ID__c))
                newConsolidatedFY = mapUpsertFY.get(newConsolidatedFY.External_ID__c);
            Object newValueObject = newConsolidatedFY.get('Volume_' + suffix + '__c');
            if(newValueObject == null){
                if((newVolumeUnit == VOLUME_UNIT_TONS) && (oldVolumeUnit == VOLUME_UNIT_TONS)){
                    value = (Decimal) newFinancialYear.get('Volume_' + suffix + '__c');
                    newConsolidatedFY.put('Volume_Tons_' + suffix + '__c', value);
                
                } else if((newVolumeUnit == VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == VOLUME_UNIT_000_UNITS)){
                    value = (Decimal) newFinancialYear.get('Volume_' + suffix + '__c');
                    newConsolidatedFY.put('Volume_' + suffix + '__c', value);

                }else if((newVolumeUnit == VOLUME_UNIT_TONS) && (oldVolumeUnit == VOLUME_UNIT_000_UNITS)){
                    value = (Decimal) newFinancialYear.get('Volume_' + suffix + '__c');
                    newConsolidatedFY.put('Volume_Tons_' + suffix + '__c', value);

                }else if((newVolumeUnit == VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == VOLUME_UNIT_TONS)){
                    value = (Decimal) newFinancialYear.get('Volume_' + suffix + '__c');
                    newConsolidatedFY.put('Volume_' + suffix + '__c', value);

                }
                
            } else {

                if((newVolumeUnit == VOLUME_UNIT_TONS) && (oldVolumeUnit == VOLUME_UNIT_TONS)){
                    value = (Decimal) newConsolidatedFY.get('Volume_Tons_' + suffix + '__c') + (Decimal) newFinancialYear.get('Volume_' + suffix + '__c');
                    newConsolidatedFY.put('Volume_Tons_' + suffix + '__c', value);
                
                }else if((newVolumeUnit == VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == VOLUME_UNIT_000_UNITS)){
                    value = (Decimal) newConsolidatedFY.get('Volume_' + suffix + '__c') + (Decimal) newFinancialYear.get('Volume_' + suffix + '__c');
                    newConsolidatedFY.put('Volume_' + suffix + '__c', value);

                }else if((newVolumeUnit == VOLUME_UNIT_TONS) && (oldVolumeUnit == VOLUME_UNIT_000_UNITS)){
                    value = (Decimal) newConsolidatedFY.get('Volume_Tons_' + suffix + '__c') + (Decimal) newFinancialYear.get('Volume_' + suffix + '__c');
                    newConsolidatedFY.put('Volume_Tons_' + suffix + '__c', value);

                }else if((newVolumeUnit == VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == VOLUME_UNIT_TONS)){
                    value = (Decimal) newConsolidatedFY.get('Volume_' + suffix + '__c') + (Decimal) newFinancialYear.get('Volume_' + suffix + '__c');
                    newConsolidatedFY.put('Volume_' + suffix + '__c', value);

                }
                
            }

            mapUpsertFY.put(newConsolidatedFY.External_ID__c, newConsolidatedFY);

            //OLD Consolidated Financial Year
            if(mapUpsertFY.containsKey(oldConsolidatedFY.External_ID__c))
                oldConsolidatedFY = mapUpsertFY.get(oldConsolidatedFY.External_ID__c);

            if((newVolumeUnit == VOLUME_UNIT_TONS) && (oldVolumeUnit == VOLUME_UNIT_TONS)){
                value = (Decimal) oldConsolidatedFY.get('Volume_Tons_' + suffix + '__c') - (Decimal) oldFinancialYear.get('Volume_' + suffix + '__c');
                oldConsolidatedFY.put('Volume_Tons_' + suffix + '__c', value);

            }else if((newVolumeUnit == VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == VOLUME_UNIT_000_UNITS)){
                value = (Decimal) oldConsolidatedFY.get('Volume_' + suffix + '__c') - (Decimal) oldFinancialYear.get('Volume_' + suffix + '__c');
                oldConsolidatedFY.put('Volume_' + suffix + '__c', value);

            }else if((newVolumeUnit == VOLUME_UNIT_TONS) && (oldVolumeUnit == VOLUME_UNIT_000_UNITS)){
                value = (Decimal) oldConsolidatedFY.get('Volume_' + suffix + '__c') - (Decimal) oldFinancialYear.get('Volume_' + suffix + '__c');
                oldConsolidatedFY.put('Volume_' + suffix + '__c', value);

            }else if((newVolumeUnit == VOLUME_UNIT_000_UNITS) && (oldVolumeUnit == VOLUME_UNIT_TONS)){
                value = (Decimal) oldConsolidatedFY.get('Volume_Tons_' + suffix + '__c') - (Decimal) oldFinancialYear.get('Volume_' + suffix + '__c');
                oldConsolidatedFY.put('Volume_Tons_' + suffix + '__c', value);

            }
            
            mapUpsertFY.put(oldConsolidatedFY.External_ID__c, oldConsolidatedFY);
        }
    }
    
    private String getFinancialYearExternalId(String financialExternalId, String yearName, String yearType, String plType){
        return financialExternalId + '_' + yearName + '_' + yearType + '_' + plType;
    }
}