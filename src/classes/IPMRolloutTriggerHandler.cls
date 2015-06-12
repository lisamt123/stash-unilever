public class IPMRolloutTriggerHandler{
    
    private String REGIONAL_ROLLOUT_RECORDTYPE;
    private String LOCAL_ROLLOUT_RECORDTYPE;
    private String DEFAULT_FINANCIAL_RECORDTYPE;
    private String CONSOLIDATED_FINANCIAL_RECORDTYPE;
    
    private static String GLOBAL_PROJECT = 'Global';
    private static String REGIONAL_PROJECT = 'Regional';
    
    private Map<String, IPM_Financial__c> mapUpsertFinancials;
    
    private List<IPM_Country__c> lstDeleteCountries;
    private List<IPM_Financial__c> lstDeleteFinancials;
    private List<IPM_Project_Rollout__c> lstDeleteRollouts;
    

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         ipmRolloutTriggerHandler()
      Type:         CONSTRUCTOR
    --------------------------------------------------------------------------------------------------------------------- */
    public ipmRolloutTriggerHandler(){
        REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Regional Rollout').getRecordTypeId();
        LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Local Rollouts').getRecordTypeId();
        DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Consolidated').getRecordTypeId();

        mapUpsertFinancials = new Map<String, IPM_Financial__c>();
        
        lstDeleteCountries = new List<IPM_Country__c>();
        lstDeleteFinancials = new List<IPM_Financial__c>();
        lstDeleteRollouts = new List<IPM_Project_Rollout__c>();
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         processDelete()
      Type:         METHOD
      Parameters:   List<IPM_Project_Rollout__c> lstProjectRollouts
      Description:  Used to process deletion of Rollout Records
    --------------------------------------------------------------------------------------------------------------------- */
    public void processDelete(List<IPM_Project_Rollout__c> lstProjectRollouts){
        Set<String> setRegionalRolloutNames = new Set<String>();
        Set<String> setLocalRolloutNames = new Set<String>();
        Set<String> setCurrentRolloutIds = new Set<String>();
        
        Set<String> setFinancialExternalIds = new Set<String>();

        For(IPM_Project_Rollout__c projectRollout : lstProjectRollouts){
            setCurrentRolloutIds.add(projectRollout.Id);
            
            if(projectRollout.RecordTypeId == REGIONAL_ROLLOUT_RECORDTYPE)
                setRegionalRolloutNames.add(projectRollout.IPM_Rollout_Project__c);
            else{
                setRegionalRolloutNames.add(projectRollout.Regional_Rollout_External_Id__c);
                setLocalRolloutNames.add(projectRollout.IPM_Rollout_Project__c);
            }
        }
        
        
        Map<String, List<IPM_Project_Rollout__c>> mapRegionalLocalRollouts = new Map<String, List<IPM_Project_Rollout__c>>();
        For(IPM_Project_Rollout__c regionalRollout : [SELECT Id, IPM_Rollout_Project__c,
                                                            (SELECT Id,IPM_Rollout_Project__c,KeyMCO__c FROM Local_Rollouts__r),
                                                            (SELECT Id,Financial_External_Id__c FROM IPM_Financials__r)
                                                        FROM IPM_Project_Rollout__c
                                                        WHERE IPM_Rollout_Project__c IN: setRegionalRolloutNames]){
            //REGIONAL ROLLOUT BEING DELETED
            if(setCurrentRolloutIds.contains(regionalRollout.Id)){
                //Add All Local Rollouts which are not being deleted
                For (IPM_Project_Rollout__c localRollout : regionalRollout.Local_Rollouts__r){
                    if(!setCurrentRolloutIds.contains(localRollout.Id))
                        lstDeleteRollouts.add(localRollout);
                }
                
                For(IPM_Financial__c ipmFinancial : regionalRollout.IPM_Financials__r){
                    if(ipmFinancial.Financial_External_Id__c == regionalRollout.IPM_Rollout_Project__c + '_CONSOLIDATED')
                        lstDeleteFinancials.add(ipmFinancial);
                }
            }
            //REGIONAL ROLLOUT NOT BEING DELETED
            else {
                Set<String> setLocalRolloutIds = new Set<String>();
                Set<String> setNonKeyRolloutIds = new Set<String>();
                For (IPM_Project_Rollout__c localRollout : regionalRollout.Local_Rollouts__r){
                    setLocalRolloutIds.add(localRollout.Id);
                    if(localRollout.KeyMCO__c){
                        if(setCurrentRolloutIds.contains(localRollout.Id))
                            setFinancialExternalIds.add(localRollout.IPM_Rollout_Project__c);
                    } else
                        setNonKeyRolloutIds.add(localRollout.Id);
                }
                
                //ALL Local Rollouts being deleted
                if(setCurrentRolloutIds.containsAll(setLocalRolloutIds)){
                    lstDeleteRollouts.add(regionalRollout);
                } 
                //Not All Local Rollouts being deleted - Check for Non Key
                else if(setCurrentRolloutIds.containsAll(setNonKeyRolloutIds)) {
                    setFinancialExternalIds.add(regionalRollout.IPM_Rollout_Project__c + '_NONKEY');
                }
            }
        }
        
        For(IPM_Project_Rollout__c localRollout : [SELECT Id, IPM_Rollout_Project__c,
                                                            (SELECT Id FROM IPM_Countries_Local__r)
                                                        FROM IPM_Project_Rollout__c
                                                        WHERE IPM_Rollout_Project__c IN: setLocalRolloutNames]){
            lstDeleteCountries.addAll(localRollout.IPM_Countries_Local__r);
        }
        
        For(IPM_Financial__c ipmFinancial : [SELECT Id FROM IPM_Financial__c WHERE Financial_External_Id__c IN: setFinancialExternalIds])
            lstDeleteFinancials.add(ipmFinancial);


        if(lstDeleteCountries.size() >0)
            Database.delete(lstDeleteCountries, false);

        if(lstDeleteFinancials.size() >0)
            Database.delete(lstDeleteFinancials, false);

        if(lstDeleteRollouts.size() >0)
            Database.delete(lstDeleteRollouts, false);

    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         processInsert()
      Type:         METHOD
      Parameters:   List<IPM_Project_Rollout__c> lstProjectRollouts
      Description:  Used to process insertion of Rollout Records
    --------------------------------------------------------------------------------------------------------------------- */
    public void processInsert(List<IPM_Project_Rollout__c> lstProjectRollouts){
        system.debug('--------------------------------------- lstProjectRollouts: ' + lstProjectRollouts);
        For (IPM_Project_Rollout__c projectRollout : lstProjectRollouts){
            if(projectRollout.RecordTypeId == REGIONAL_ROLLOUT_RECORDTYPE){
                IPM_Financial__c newFinancial;
                String externalId = projectRollout.IPM_Rollout_Project__c + '_CONSOLIDATED';
                system.debug('--------------------------------------- newFinancial externalId: ' + externalId);
                if(mapUpsertFinancials.containsKey(externalId))
                    newFinancial = mapUpsertFinancials.get(externalId);
                else
                    newFinancial = new IPM_Financial__c(
                        Parent_Project__c = projectRollout.IPM_Project__c,
                        IPM_Project_Rollout__c = projectRollout.Id,
                        RecordtypeId = CONSOLIDATED_FINANCIAL_RECORDTYPE,
                        Financial_External_ID__c = externalId,
                        Target_Launch_Date__c = projectRollout.Target_Launch_Date__c,
                        Project_Sustainability_Period__c = projectRollout.Calculated_Sustainability_Period__c
                    );
                
                mapUpsertFinancials.put(externalId, newFinancial);
            } else {
                IPM_Financial__c newFinancial;
                String externalId = getFinancialExternalId(projectRollout);
                system.debug('--------------------------------------- newFinancial externalId LOCAL: ' + externalId);
                if(mapUpsertFinancials.containsKey(externalId))
                    newFinancial = mapUpsertFinancials.get(externalId);
                else
                    newFinancial = new IPM_Financial__c(
                        RecordTypeId = DEFAULT_FINANCIAL_RECORDTYPE,
                        Financial_External_ID__c = externalId,
                        Target_Launch_Date__c = projectRollout.Target_Launch_Date__c,
                        Project_Sustainability_Period__c = projectRollout.Calculated_Sustainability_Period__c
                    );
                    
                if(projectRollout.Regional_Project__c != null)
                    newFinancial.Regional_Project__c = projectRollout.Regional_Project__c;
                else
                    newFinancial.IPM_Project_Rollout__c = projectRollout.Regional_Rollout__c;
                
                mapUpsertFinancials.put(externalId, newFinancial);
            }
        }
        
        if (mapUpsertFinancials.size() > 0){
            Database.upsert(mapUpsertFinancials.values(), IPM_Financial__c.Financial_External_Id__c);
        }
    }
    
    private String getFinancialExternalId(IPM_Project_Rollout__c projectRollout){
        if(projectRollout.Regional_Project__c != null && projectRollout.Regional_Rollout__c == null)
            return projectRollout.IPM_Rollout_Project__c;
        else if (projectRollout.KeyMCO__c)
            return projectRollout.IPM_Rollout_Project__c;
        else
            return projectRollout.Regional_Rollout_External_Id__c + '_NONKEY';
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         processInsert()
      Type:         METHOD
      Parameters:   List<IPM_Project_Rollout__c> lstProjectRollouts
      Description:  Used to process insertion of Rollout Records
    --------------------------------------------------------------------------------------------------------------------- */
    public void processUpdate(Map<Id, IPM_Project_Rollout__c> mapNewProjectRollouts, Map<Id, IPM_Project_Rollout__c> mapOldProjectRollouts){
        mapUpsertFinancials = new Map<String, IPM_Financial__c>();
        lstDeleteFinancials = new List<IPM_Financial__c>();
        
        Set<String> setDeleteFinancialExternalIds = new Set<String>();

        Set<String> setRegionalRolloutNames = new Set<String>();
        For(IPM_Project_Rollout__c projectRollout : mapNewProjectRollouts.values()){
            if(projectRollout.RecordTypeId == REGIONAL_ROLLOUT_RECORDTYPE)
                setRegionalRolloutNames.add(projectRollout.IPM_Rollout_Project__c);
            else
                setRegionalRolloutNames.add(projectRollout.Regional_Rollout_External_Id__c);
        }

        Map<String, Boolean> mapNonKeyFinancialExists = new Map<String, Boolean>();
        Map<String, Boolean> mapDeleteNonKeyFinancial = new Map<String, Boolean>();

        For(IPM_Project_Rollout__c regionalRollout : [SELECT Id, IPM_Rollout_Project__c,
                                                            (SELECT Id,IPM_Rollout_Project__c,KeyMCO__c FROM Local_Rollouts__r),
                                                            (SELECT Id,Financial_External_Id__c FROM IPM_Financials__r)
                                                        FROM IPM_Project_Rollout__c
                                                        WHERE IPM_Rollout_Project__c IN: setRegionalRolloutNames]){
            mapNonKeyFinancialExists.put(regionalRollout.IPM_Rollout_Project__c, false);
            For(IPM_Financial__c ipmFinancial : regionalRollout.IPM_Financials__r){
                if(ipmFinancial.Financial_External_Id__c == regionalRollout.IPM_Rollout_Project__c + '_NONKEY')
                    mapNonKeyFinancialExists.put(regionalRollout.IPM_Rollout_Project__c, true);
            }

            mapDeleteNonKeyFinancial.put(regionalRollout.IPM_Rollout_Project__c, true);
            For(IPM_Project_Rollout__c localRollout : regionalRollout.Local_Rollouts__r){
                if(!localRollout.KeyMCO__c)
                    mapDeleteNonKeyFinancial.put(regionalRollout.IPM_Rollout_Project__c, false);
            }
        }

        For(IPM_Project_Rollout__c newRollout : mapNewProjectRollouts.values()){
            if(newRollout.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE){
                IPM_Project_Rollout__c oldRollout = mapOldProjectRollouts.get(newRollout.Id);

                //IF WAS KEY BEFORE
                if(oldRollout.KeyMCO__c && !newRollout.KeyMCO__c){
                    //DELETE Key Financial
                    setDeleteFinancialExternalIds.add(getFinancialExternalId(oldRollout));
                    
                    //Check if new NONKEY financial is needed
                    if(!mapNonKeyFinancialExists.get(newRollout.Regional_Rollout_External_Id__c)){
                        IPM_Financial__c newFinancial;
                        String externalId = getFinancialExternalId(newRollout);
                        if(mapUpsertFinancials.containsKey(externalId))
                            newFinancial = mapUpsertFinancials.get(externalId);
                        else
                            newFinancial = new IPM_Financial__c(
                                IPM_Project_Rollout__c = newRollout.Regional_Rollout__c,
                                RecordTypeId = DEFAULT_FINANCIAL_RECORDTYPE,
                                Financial_External_ID__c = externalId,
                                Target_Launch_Date__c = newRollout.Target_Launch_Date__c,
                                Project_Sustainability_Period__c = newRollout.Calculated_Sustainability_Period__c
                            );
                        
                        mapUpsertFinancials.put(externalId, newFinancial);
                    }
                }
                //IS KEY NOW
                else if(!oldRollout.KeyMCO__c && newRollout.KeyMCO__c){
                    //Check if Non Key financial needs to be deleted
                    if(mapDeleteNonKeyFinancial.get(newRollout.Regional_Rollout_External_Id__c))
                        setDeleteFinancialExternalIds.add(getFinancialExternalId(oldRollout));
                        
                    //Insert key financial
                    IPM_Financial__c newFinancial;
                    String externalId = getFinancialExternalId(newRollout);
                    if(mapUpsertFinancials.containsKey(externalId))
                        newFinancial = mapUpsertFinancials.get(externalId);
                    else
                        newFinancial = new IPM_Financial__c(
                            IPM_Project_Rollout__c = newRollout.Regional_Rollout__c,
                            RecordTypeId = DEFAULT_FINANCIAL_RECORDTYPE,
                            Financial_External_ID__c = externalId,
                            Target_Launch_Date__c = newRollout.Target_Launch_Date__c,
                            Project_Sustainability_Period__c = newRollout.Calculated_Sustainability_Period__c
                        );
                    
                    mapUpsertFinancials.put(externalId, newFinancial);
                }
            }
        }
        
        Database.delete([SELECT Id FROM IPM_Financial__c WHERE Financial_External_Id__c IN: setDeleteFinancialExternalIds]);

        if (mapUpsertFinancials.size() > 0){
            Database.upsert(mapUpsertFinancials.values(), IPM_Financial__c.Financial_External_Id__c);
        }
    }
}