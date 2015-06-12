public without sharing class IPMFinancialTriggerHandler{

    private static String PL_TYPE_GROSS = 'Gross';
    private static String PL_TYPE_INCREMENTAL = 'Incremental';
    private static String YEAR_TYPE_INNOVATION = 'Innovation';
    private static String YEAR_TYPE_CALENDAR = 'Calendar';

    private static String DEFAULT_FINANCIAL_RECORDTYPE;
    private static String CONSOLIDATED_FINANCIAL_RECORDTYPE;

    private static String TYPE_GLOBAL = 'Global';
    private static String TYPE_REGIONAL = 'Regional';
    private static String TYPE_LOCAL = 'Local';

    private List<IPM_Financial_Year__c> lstInsertFinancialYears;
    private List<IPM_Financial_Year__c> lstUpdateFinancialYears;

    private Map<String, IPM_Financial__c> mapUpsertConsolidatedFinancials;
    private Map<String, IPM_Financial__c> mapAllConsolidatedFinancials;

    private Map<String, String> mapGlobalConsolidatedFinancials;
    private Map<String, String> mapRegionalConsolidatedFinancials;

    private Set<String> setFinancialExternalIds;

    public void onAfterInsert(List<IPM_Financial__c> newFinancials){
        lstInsertFinancialYears = new List<IPM_Financial_Year__c>();

        For(IPM_Financial__c financial : newFinancials)
            processIPMFinancialYears(financial);
        
        if(lstInsertFinancialYears.size()>0)
            Database.insert(lstInsertFinancialYears);
    }

    private void processIPMFinancialYears(IPM_Financial__c ipmFinancial){
        String externalId = ipmFinancial.Financial_External_ID__c;

        //Y0
        lstInsertFinancialYears.add(processFinancialYear(externalId, 'Y0', '0', YEAR_TYPE_INNOVATION, NULL));
        lstInsertFinancialYears.add(processFinancialYear(externalId, 'Y0', '0', YEAR_TYPE_CALENDAR, NULL));
        
        //Rest of the Years
        For(integer i=1; i<=Integer.valueOf(ipmFinancial.Project_Sustainability_Period__c); i++){
            lstInsertFinancialYears.add(processFinancialYear(externalId, 'Y'+i, ''+i, YEAR_TYPE_INNOVATION, PL_TYPE_GROSS));
            lstInsertFinancialYears.add(processFinancialYear(externalId, 'Y'+i, ''+i, YEAR_TYPE_INNOVATION, PL_TYPE_INCREMENTAL));

            Integer calendarYear = ipmFinancial.Target_Launch_Date__c.year() + i - 1;
            lstInsertFinancialYears.add(processFinancialYear(externalId, ''+calendarYear, ''+i, YEAR_TYPE_CALENDAR, PL_TYPE_GROSS));
            lstInsertFinancialYears.add(processFinancialYear(externalId, ''+calendarYear, ''+i, YEAR_TYPE_CALENDAR, PL_TYPE_INCREMENTAL));
        }
    }
    
    private IPM_Financial_Year__c processFinancialYear(String financialExternalId, String yearName, String index, String yearType, String plType){
        IPM_Financial_Year__c financialYear = new IPM_Financial_Year__c(
            IPM_Financial__r = new IPM_Financial__c(Financial_External_ID__c = financialExternalId),
            External_Id__c = getFinancialYearExternalId(financialExternalId, yearName, yearType, plType),
            Name = yearName,
            Year__c = index,
            Year_Type__c = yearType,
            PL_Type__c = plType
       );
        return financialYear;
    }
    
    private String getFinancialYearExternalId(String financialExternalId,  String yearName, String yearType, String plType){
        return financialExternalId + '_' + yearName + '_' + yearType + '_' + plType;
    }


    public void onBeforeDelete(Map<Id, IPM_Financial__c> mapOldFinancials){
        List<IPM_Financial__c> lstFinancials = getFinancials(mapOldFinancials.keySet());
        //initialiseConsolidation(null, mapOldFinancials);
    }
    
    public void onAfterUpdate(Map<Id, IPM_Financial__c> mapNewFinancials, Map<Id, IPM_Financial__c> mapOldFinancials){
        List<IPM_Financial__c> lstFinancials = getFinancials(mapNewFinancials.keySet());

        //Manage Financial Year Updates for DEFAULT Financials
        For(IPM_Financial__c financial : lstFinancials){
            For (IPM_Financial_Year__c finYear : financial.IPM_Financial_Years__r){
                finYear.Charter_Approved__c = financial.Charter_Approved__c;
                finYear.Contract_Approved__c = financial.Contract_Approved__c;
                finYear.MR_Approved__c = financial.MR_Approved__c;
                finYear.MD_Approved__c = financial.MD_Approved__c;
                
                finYear.Copy_Global_to_Regional__c = financial.Copy_Global_to_Regional__c;
                finYear.Copy_Global_to_Local__c = financial.Copy_Global_to_Local__c;
                finYear.Copy_Local_to_Regional__c = financial.Copy_Local_to_Regional__c;
                finYear.Copy_Regional_to_Local__c = financial.Copy_Regional_to_Local__c;

                finYear.Volume_Unit_Global__c = financial.Volume_Unit_Global__c;
                finYear.Volume_Unit_Regional__c = financial.Volume_Unit_Regional__c;
                finYear.Volume_Unit_Local__c = financial.Volume_Unit_Local__c;
                
                lstUpdateFinancialYears.add(finYear);
            }
            
            processSustainabilityPeriod(financial, mapOldFinancials.get(financial.Id), financial.IPM_Financial_Years__r);
        }
        
        initialiseConsolidation(mapNewFinancials, mapOldFinancials);
    }

    private List<IPM_Financial__c> getFinancials(Set<Id> setFinancialIds){
        lstInsertFinancialYears = new List<IPM_Financial_Year__c>();
        lstUpdateFinancialYears = new List<IPM_Financial_Year__c>();
        
        List<IPM_Financial__c> lstFinancials = [SELECT Id, Financial_External_ID__c, Charter_Approved__c, Contract_Approved__c, MR_Approved__c, MD_Approved__c, Copy_Global_to_Regional__c, Copy_Global_to_Local__c, Copy_Local_to_Regional__c, Copy_Regional_to_Local__c,  Global_External_Id__c, Regional_External_Id__c, Volume_Unit_Global__c, Volume_Unit_Regional__c, Volume_Unit_Local__c, Project_Sustainability_Period__c, Target_Launch_Date__c, 
                                                        (SELECT Id, External_Id__c, Charter_Approved__c, Contract_Approved__c, MR_Approved__c, MD_Approved__c, Copy_Global_to_Regional__c, Copy_Global_to_Local__c, Copy_Local_to_Regional__c, Copy_Regional_to_Local__c, Volume_Unit_Global__c, Volume_Unit_Regional__c, Volume_Unit_Local__c 
                                                            FROM IPM_Financial_Years__r)
                                                    FROM IPM_Financial__c
                                                    WHERE Id IN: setFinancialIds];

        mapGlobalConsolidatedFinancials = new Map<String, String>();
        mapRegionalConsolidatedFinancials = new Map<String, String>();

        setFinancialExternalIds = new Set<String>();
        For(IPM_Financial__c financial : lstFinancials){
            String globalExternalId = financial.Global_External_Id__c + '_CONSOLIDATED';
            mapGlobalConsolidatedFinancials.put(financial.Id, globalExternalId);
            setFinancialExternalIds.add(globalExternalId);

            String regionalExternalId = financial.Regional_External_Id__c + '_CONSOLIDATED';
            mapRegionalConsolidatedFinancials.put(financial.Id, regionalExternalId);
            setFinancialExternalIds.add(regionalExternalId);
        }

        return lstFinancials;
    }
    
    private void initialiseConsolidation(Map<Id, IPM_Financial__c> mapNewFinancials, Map<Id, IPM_Financial__c> mapOldFinancials){
        DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Consolidated').getRecordTypeId();

        //Consolidate Financials
        getConsolidatedFinancials(setFinancialExternalIds);
        mapUpsertConsolidatedFinancials = new Map<String, IPM_Financial__c>();
        
        if(mapNewFinancials != null){
            for(IPM_Financial__c ipmFinancial : mapNewFinancials.values()){
                if(ipmFinancial.RecordtypeId == DEFAULT_FINANCIAL_RECORDTYPE){
                    consolidateFinancials(ipmFinancial, mapOldFinancials.get(ipmFinancial.Id), TYPE_GLOBAL);
                    consolidateFinancials(ipmFinancial, mapOldFinancials.get(ipmFinancial.Id), TYPE_REGIONAL);
                }
            }
        } else {
            for(IPM_Financial__c ipmFinancial : mapOldFinancials.values()){
                if(ipmFinancial.RecordtypeId == DEFAULT_FINANCIAL_RECORDTYPE){
                    consolidateFinancials(null, ipmFinancial, TYPE_GLOBAL);
                    consolidateFinancials(null, ipmFinancial, TYPE_REGIONAL);
                }
            }
        }

        if(mapUpsertConsolidatedFinancials.size() > 0)
            Database.upsert(mapUpsertConsolidatedFinancials.values(), IPM_Financial__c.Financial_External_ID__c, false);

        if (lstUpdateFinancialYears.size()>0)
            Database.update(lstUpdateFinancialYears);

        if (lstInsertFinancialYears.size()>0)
            Database.insert(lstInsertFinancialYears);
    }
    
    private void processSustainabilityPeriod(IPM_Financial__c newFinancial, IPM_Financial__c oldFinancial, List<IPM_Financial_Year__c> lstExistingFinancialYears){
        Set<String> setExistingFinancialYears = new Set<String>();
        For(IPM_Financial_Year__c existingFinancialYear : lstExistingFinancialYears)
            setExistingFinancialYears.add(existingFinancialYear.External_ID__c);

        //Change from 3 TO 5
        Integer newSustainabilityPeriod = Integer.valueOf(newFinancial.Project_Sustainability_Period__c);
        Integer oldSustainabilityPeriod = Integer.valueOf(oldFinancial.Project_Sustainability_Period__c);

        if(newSustainabilityPeriod > oldSustainabilityPeriod){
            Integer difference = newSustainabilityPeriod - oldSustainabilityPeriod;
            Integer lastCalendarYear = newFinancial.Target_Launch_Date__c.year() + Integer.valueOf(oldFinancial.Project_Sustainability_Period__c) - 1;
            For(Integer i=1; i<=difference; i++){
                Integer calendarYear = lastCalendarYear + i;
                Integer index = oldSustainabilityPeriod + i;
                if(!setExistingFinancialYears.contains(getFinancialYearExternalId(newFinancial.Financial_External_ID__c, 'Y'+index, YEAR_TYPE_INNOVATION, PL_TYPE_GROSS))){
                    lstInsertFinancialYears.add(processFinancialYear(newFinancial.Financial_External_ID__c, 'Y'+index, ''+index, YEAR_TYPE_INNOVATION, PL_TYPE_GROSS));
                    lstInsertFinancialYears.add(processFinancialYear(newFinancial.Financial_External_ID__c, 'Y'+index, ''+index, YEAR_TYPE_INNOVATION, PL_TYPE_INCREMENTAL));

                }
                if(!setExistingFinancialYears.contains(getFinancialYearExternalId(newFinancial.Financial_External_ID__c, ''+calendarYear, YEAR_TYPE_CALENDAR, PL_TYPE_GROSS))){
                    lstInsertFinancialYears.add(processFinancialYear(newFinancial.Financial_External_ID__c, ''+calendarYear, ''+index, YEAR_TYPE_CALENDAR, PL_TYPE_GROSS));
                    lstInsertFinancialYears.add(processFinancialYear(newFinancial.Financial_External_ID__c, ''+calendarYear, ''+index, YEAR_TYPE_CALENDAR, PL_TYPE_INCREMENTAL));
                }
            }
        }
    }

    private void getConsolidatedFinancials(Set<String> setFinancialExternalIds){
        CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Consolidated').getRecordTypeId();
        
        String queryString = 'SELECT ';
        //IPM Financial
        For (String field : Schema.SObjectType.IPM_Financial__c.fields.getMap().KeySet()){
            if (field != 'Id')
                queryString+= field + ', ';
        }
        queryString+= 'Id FROM IPM_Financial__c WHERE RecordtypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE';
        queryString+= ' AND Financial_External_ID__c IN: setFinancialExternalIds';
        
        mapAllConsolidatedFinancials = new Map<String, IPM_Financial__c>();
        For(IPM_Financial__c consollidatedFinancial : Database.query(queryString))
            mapAllConsolidatedFinancials.put(consollidatedFinancial.Financial_External_ID__c, consollidatedFinancial);

    }

    private void consolidateFinancials(IPM_Financial__c newFinancial, IPM_Financial__c oldFinancial, String consolidationType){
        String newConsolidatedFinExtId;
        String oldConsolidatedFinExtId;
        if(consolidationType == TYPE_GLOBAL){
            if(newFinancial != null)
                newConsolidatedFinExtId = mapGlobalConsolidatedFinancials.get(newFinancial.Id);
            oldConsolidatedFinExtId = mapGlobalConsolidatedFinancials.get(oldFinancial.Id);
        
        } else if(consolidationType == TYPE_REGIONAL){
            if(newFinancial != null)
                newConsolidatedFinExtId = mapRegionalConsolidatedFinancials.get(newFinancial.Id);
            oldConsolidatedFinExtId = mapRegionalConsolidatedFinancials.get(oldFinancial.Id);

        }

        IPM_Financial__c newConsolidatedFinancial = new IPM_Financial__c();
        if(newFinancial != null){
            newConsolidatedFinancial = mapAllConsolidatedFinancials.get(newConsolidatedFinExtId);
            if(mapUpsertConsolidatedFinancials.containsKey(newConsolidatedFinExtId))
                newConsolidatedFinancial = mapUpsertConsolidatedFinancials.get(newConsolidatedFinExtId);

        }

        IPM_Financial__c oldConsolidatedFinancial = mapAllConsolidatedFinancials.get(oldConsolidatedFinExtId);
        if(mapUpsertConsolidatedFinancials.containsKey(oldConsolidatedFinExtId))
            oldConsolidatedFinancial = mapUpsertConsolidatedFinancials.get(oldConsolidatedFinExtId);

        consolidateFinancialRecord(newFinancial, newConsolidatedFinancial, oldFinancial, oldConsolidatedFinancial);
    }
    
    private void consolidateFinancialRecord(IPM_Financial__c newFinancial, IPM_Financial__c newConsolidatedFinancial, IPM_Financial__c oldFinancial, IPM_Financial__c oldConsolidatedFinancial){
        processConsolidation(newFinancial, newConsolidatedFinancial, oldFinancial, oldConsolidatedFinancial, 'BIC');
        processConsolidation(newFinancial, newConsolidatedFinancial, oldFinancial, oldConsolidatedFinancial, 'CAPEX');
        processConsolidation(newFinancial, newConsolidatedFinancial, oldFinancial, oldConsolidatedFinancial, 'NPV');
        processConsolidation(newFinancial, newConsolidatedFinancial, oldFinancial, oldConsolidatedFinancial, 'Payback');
        processLastSaved(newConsolidatedFinancial, oldConsolidatedFinancial);
    }
    
    private void processConsolidation(IPM_Financial__c newFinancial, IPM_Financial__c newConsolidatedFinancial, IPM_Financial__c oldFinancial, IPM_Financial__c oldConsolidatedFinancial, String fieldName){
        Set<String> fieldSufixes = new Set<String>{TYPE_GLOBAL, TYPE_REGIONAL, TYPE_LOCAL};
        Decimal value;
        For(String suffix : fieldSufixes){
            if(newFinancial != null){
                //NEW Consolidated Financial
                if(mapUpsertConsolidatedFinancials.containsKey(newConsolidatedFinancial.Financial_External_ID__c))
                    newConsolidatedFinancial = mapUpsertConsolidatedFinancials.get(newConsolidatedFinancial.Financial_External_ID__c);
                Object newValueObject = newConsolidatedFinancial.get(fieldname + '_' + suffix + '__c');
                if(newValueObject == null)
                    value = (Decimal) newFinancial.get(fieldname + '_' + suffix + '__c');
                else
                    value = (Decimal) newConsolidatedFinancial.get(fieldname + '_' + suffix + '__c') + (Decimal) newFinancial.get(fieldname + '_' + suffix + '__c');
    
                newConsolidatedFinancial.put(fieldname + '_' + suffix + '__c', value);
                mapUpsertConsolidatedFinancials.put(newConsolidatedFinancial.Financial_External_ID__c, newConsolidatedFinancial);
            }

            //OLD Consolidated Financial
            if(mapUpsertConsolidatedFinancials.containsKey(oldConsolidatedFinancial.Financial_External_ID__c))
                oldConsolidatedFinancial = mapUpsertConsolidatedFinancials.get(oldConsolidatedFinancial.Financial_External_ID__c);
            value = (Decimal) oldConsolidatedFinancial.get(fieldname + '_' + suffix + '__c') - (Decimal) oldFinancial.get(fieldname + '_' + suffix + '__c');
            oldConsolidatedFinancial.put(fieldname + '_' + suffix + '__c', value);
            
            mapUpsertConsolidatedFinancials.put(oldConsolidatedFinancial.Financial_External_ID__c, oldConsolidatedFinancial);
        }
    }

    private void processLastSaved(IPM_Financial__c newConsolidatedFinancial, IPM_Financial__c oldConsolidatedFinancial){
        Set<String> fieldSufixes = new Set<String>{TYPE_GLOBAL, TYPE_REGIONAL, TYPE_LOCAL};
        For(String suffix : fieldSufixes){
            if(newConsolidatedFinancial != null){
                //NEW Consolidated Financial
                newConsolidatedFinancial.put('Last_Saved_' + suffix + '__c', System.now());
                newConsolidatedFinancial.put('Last_Saved_By_' + suffix + '__c', UserInfo.getUserId());
                mapUpsertConsolidatedFinancials.put(newConsolidatedFinancial.Financial_External_ID__c, newConsolidatedFinancial);
            }

            //OLD Consolidated Financial
            oldConsolidatedFinancial.put('Last_Saved_' + suffix + '__c', System.now());
            oldConsolidatedFinancial.put('Last_Saved_By_' + suffix + '__c', UserInfo.getUserId());
            mapUpsertConsolidatedFinancials.put(oldConsolidatedFinancial.Financial_External_ID__c, oldConsolidatedFinancial);
        }
    }
    
}