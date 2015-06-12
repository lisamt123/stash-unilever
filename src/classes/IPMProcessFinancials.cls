public without sharing class IPMProcessFinancials{
    static String GATE_CHARTER = 'Charter';
    static String GATE_CONTRACT = 'Contract';
    static String GATE_MARKET_READY = 'Market Ready';
    static String GATE_MARKET_DEPLOYMENT = 'Market Deployment';

    static String PROJECT_SPAN_GLOBAL = 'Global';
    static String PROJECT_SPAN_REGIONAL = 'Regional';
    static String PROJECT_SPAN_LOCAL = 'Local';

    static String STATUS_APPROVED = 'Approved';

    static String NO_CHANGE = 'NoChange';

    static String REGIONAL_ROLLOUT_RECORDTYPE;
    static String DEFAULT_FINANCIAL_RECORDTYPE;
    static String CONSOLIDATED_FINANCIAL_RECORDTYPE;
    
    private List<IPM_Financial__c> lstUpsertFinancials;
    private List<IPM_Project_Rollout__c> lstUpsertLocalRollouts;
    private List<IPM_Country__c> lstUpdateCountries;
    
    public IPMProcessFinancials(){
        REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Regional Rollout').getRecordTypeId();
        DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Consolidated').getRecordTypeId();
    }

    @future
    public static void processDocumentApprovalFinancials(Set<Id> setProjectDocumentIds){
        List<IPM_Project_Document__c> lstProjectDocuments = [SELECT Id, Name, IPM_Document_Status__c, IPM_GateDocuments__c, IPM_Project__c, IPM_Project__r.IPMProject_Span__c, IPM_Project__r.IPM_Project_Name__c
                                                                FROM IPM_Project_Document__c
                                                                WHERE Id IN: setProjectDocumentIds];

        IPMProcessFinancials handler = new IPMProcessFinancials();
        handler.updateProjectDocumentFinancials(lstProjectDocuments);
    }
    
    public void updateProjectDocumentFinancials(List<IPM_Project_Document__c> lstProjectDocuments){
        system.debug('-----------------------------------------lstProjectDocuments: ' + lstProjectDocuments);
        lstUpsertFinancials = new List<IPM_Financial__c>();
        lstUpsertLocalRollouts = new List<IPM_Project_Rollout__c>();
        lstUpdateCountries = new List<IPM_Country__c>();

        Set<Id> setCharterProjectIds = new Set<Id>();

        Set<String> setContractFinExtIds = new Set<String>();
        Set<Id> setContractProjectIds = new Set<Id>();

        Set<String> setMarketReadyFinExtIds = new Set<String>();
        Set<Id> setMarketReadyProjectIds = new Set<Id>();

        Set<String> setMarketDeploymentFinExtIds = new Set<String>();
        Set<Id> setMarketDeploymentProjectIds = new Set<Id>();

        For(IPM_Project_Document__c projectDocument : lstProjectDocuments){
            system.debug('-----------------------------------------projectDocument: ' + projectDocument);
            if (projectDocument.IPM_Document_Status__c == STATUS_APPROVED){
                String projectId = projectDocument.IPM_Project__c;
                if(projectId.length() > 15)
                    projectId = projectId.subString(0,15);

                String consolidatedFinancialExternalId = projectDocument.IPM_Project__r.IPM_Project_Name__c + '_CONSOLIDATED';
                
                //Charter Document Approved
                if(projectDocument.IPM_GateDocuments__c == GATE_CHARTER)
                    setCharterProjectIds.add(projectId);
                
                //Contract Document Approved
                else if(projectDocument.IPM_GateDocuments__c == GATE_CONTRACT){
                    if ((projectDocument.IPM_Project__r.IPMProject_Span__c == PROJECT_SPAN_GLOBAL) 
                            || (projectDocument.IPM_Project__r.IPMProject_Span__c == PROJECT_SPAN_REGIONAL)){
                        setContractFinExtIds.add(consolidatedFinancialExternalId);
                    } else {
                        setContractProjectIds.add(projectId);
                    }
                }
                
                //Market Ready Document Approved
                else if(projectDocument.IPM_GateDocuments__c == GATE_MARKET_READY){
                    if ((projectDocument.IPM_Project__r.IPMProject_Span__c == PROJECT_SPAN_GLOBAL) 
                            || (projectDocument.IPM_Project__r.IPMProject_Span__c == PROJECT_SPAN_REGIONAL)){
                        setMarketReadyFinExtIds.add(consolidatedFinancialExternalId);
                    } else {
                        setMarketReadyProjectIds.add(projectId);
                    }
                }

                //Market Deployment Document Approved
                else if(projectDocument.IPM_GateDocuments__c == GATE_MARKET_DEPLOYMENT){
                    if ((projectDocument.IPM_Project__r.IPMProject_Span__c == PROJECT_SPAN_GLOBAL) 
                            || (projectDocument.IPM_Project__r.IPMProject_Span__c == PROJECT_SPAN_REGIONAL)){
                        setMarketDeploymentFinExtIds.add(consolidatedFinancialExternalId);
                    } else {
                        setMarketDeploymentProjectIds.add(projectId);
                    }
                }
            }
        }
        
        if (setCharterProjectIds.size() > 0)
            processCharterFinancials(setCharterProjectIds);
            
        if((setContractFinExtIds.size() > 0)
                || (setMarketReadyFinExtIds.size() > 0)
                || (setMarketDeploymentFinExtIds.size() > 0))
            processParentFinancials(setContractFinExtIds, setMarketReadyFinExtIds, setMarketDeploymentFinExtIds);

        if((setContractProjectIds.size() > 0)
                || (setMarketReadyProjectIds.size() > 0)
                || (setMarketDeploymentProjectIds.size() > 0)){}
            processLocalFinancials(setContractProjectIds, setMarketReadyProjectIds, setMarketDeploymentProjectIds);
        
        if(lstUpsertFinancials.size() > 0)
            Database.upsert(lstUpsertFinancials, IPM_Financial__c.Financial_External_ID__c, true);

        if(lstUpsertLocalRollouts.size() > 0)
            Database.upsert(lstUpsertLocalRollouts, IPM_Project_Rollout__c.IPM_Rollout_Project__c);
        
        if(lstUpdateCountries.size() > 0)
            update lstUpdateCountries;
    }

    private void processCharterFinancials(Set<Id> setCharterProjectIds){
        system.debug('-----------------------------------------setCharterProjectIds: ' + setCharterProjectIds);
        For(IPM_Project_Rollout__c regionalRollout : [SELECT Id, IPM_Rollout_Project__c, 
                                                            (SELECT Id, Name, Regional_Project__c, Charter_Approved__c, Copy_Global_to_Regional__c, Copy_Global_to_Local__c, Financial_External_Id__c, Project_Sustainability_Period__c  
                                                                FROM IPM_Financials__r),
                                                            (SELECT Id, Name, IPM_Rollout_Project__c, Target_Launch_Date__c, KeyMCO__c, Calculated_Sustainability_Period__c, Regional_Project__c  
                                                                FROM Local_Rollouts__r)
                                                        FROM IPM_Project_Rollout__c
                                                        WHERE IPM_Project__c IN: setCharterProjectIds
                                                            AND RecordTypeId =: REGIONAL_ROLLOUT_RECORDTYPE]){
            system.debug('-----------------------------------------regionalRollout: ' + regionalRollout.IPM_Rollout_Project__c);
            For (IPM_Financial__c financial : regionalRollout.IPM_Financials__r){
                system.debug('-----------------------------------------financial: ' + financial.Financial_External_ID__c);
                system.debug('-----------------------------------------financial.Regional_Project__c: ' + financial.Regional_Project__c);
                if(financial.Regional_Project__c == null){
                    String externalId = financial.Financial_External_Id__c;
                    
                    financial.Regional_Project__r = new IPM_Project__c(IPM_Project_Name__c = regionalRollout.IPM_Rollout_Project__c);
                    financial.Charter_Approved__c = TRUE;
                    financial.Copy_Global_to_Regional__c = TRUE;
                    financial.Copy_Global_to_Local__c = TRUE;
                    financial.Financial_External_Id__c = externalId;
                    lstUpsertFinancials.add(financial);
                }
            }


            For (IPM_Project_Rollout__c localRollout : regionalRollout.Local_Rollouts__r){
                system.debug('-----------------------------------------localRollout: ' + localRollout.IPM_Rollout_Project__c);
                system.debug('-----------------------------------------localRollout.Regional_Project__c: ' + localRollout.Regional_Project__c);
                if(localRollout.Regional_Project__c == null){
                    localRollout.Regional_Project__r = new IPM_Project__c(IPM_Project_Name__c = regionalRollout.IPM_Rollout_Project__c);
                    lstUpsertLocalRollouts.add(localRollout);
                    
                    if(!localRollout.KeyMCO__c){
                        lstUpsertFinancials.add(
                            new IPM_Financial__c(
                                Regional_Project__r = new IPM_Project__c(IPM_Project_Name__c = regionalRollout.IPM_Rollout_Project__c),
                                RecordtypeId = DEFAULT_FINANCIAL_RECORDTYPE,
                                Financial_External_ID__c = localRollout.IPM_Rollout_Project__c,
                                Target_Launch_Date__c = localRollout.Target_Launch_Date__c,
                                Project_Sustainability_Period__c = localRollout.Calculated_Sustainability_Period__c,
                                Charter_Approved__c = TRUE
                            )
                        );
                    }
                }
            }
        }

        //GLOBAL Consolidated Financial
        For(IPM_Financial__c financial : [SELECT Id, Name, Charter_Approved__c, Financial_External_Id__c 
                                            FROM IPM_Financial__c
                                            WHERE Parent_Project__c IN: setCharterProjectIds
                                                AND Regional_Project__c =: NULL
                                                AND IPM_Project_Rollout__c =: NULL]){
            String externalId = financial.Financial_External_Id__c;
            
            financial.Charter_Approved__c = TRUE;
            financial.Copy_Global_to_Regional__c = TRUE;
            financial.Copy_Global_to_Local__c = TRUE;
            financial.Financial_External_Id__c = externalId;
            lstUpsertFinancials.add(financial);
        }

        //Countries
        For(IPM_Country__c ipmCountry : [SELECT Id, IPM_Regional_Project__c, Local_Rollout__r.Regional_Rollout_External_Id__c
                                            FROM IPM_Country__c
                                            WHERE IPM_Project__c IN: setCharterProjectIds]){
            if(ipmCountry.IPM_Regional_Project__c == null){
                ipmCountry.IPM_Regional_Project__r = new IPM_Project__c(IPM_Project_Name__c = ipmCountry.Local_Rollout__r.Regional_Rollout_External_Id__c);
                lstUpdateCountries.add(ipmCountry);
            }
        }
        
    }

    private void processParentFinancials(Set<String> setContractFinExtIds, 
                                            Set<String> setMarketReadyFinExtIds, 
                                            Set<String> setMarketDeploymentFinExtIds){
        Set<String> setParentFinExtIds = new Set<String>();
        if(setContractFinExtIds.size() > 0)
            setParentFinExtIds.addAll(setContractFinExtIds);

        if(setMarketReadyFinExtIds.size() > 0)
            setParentFinExtIds.addAll(setMarketReadyFinExtIds);

        if(setMarketDeploymentFinExtIds.size() > 0)
            setParentFinExtIds.addAll(setMarketDeploymentFinExtIds);
        
        For(IPM_Financial__c financial : [SELECT Id, Name, Financial_External_Id__c, Contract_Approved__c, MR_Approved__c, MD_Approved__c 
                                            FROM IPM_Financial__c
                                            WHERE Financial_External_Id__c IN: setParentFinExtIds]){
            String externalId = financial.Financial_External_Id__c;
            if(setContractFinExtIds.contains(externalId))
                financial.Contract_Approved__c = TRUE;

            if(setMarketReadyFinExtIds.contains(externalId))
                financial.MR_Approved__c = TRUE;

            if(setMarketDeploymentFinExtIds.contains(externalId))
                financial.MD_Approved__c = TRUE;
            
            lstUpsertFinancials.add(financial);
        }
    }

    private void processLocalFinancials(Set<Id> setContractProjectIds, 
                                            Set<Id> setMarketReadyProjectIds, 
                                            Set<Id> setMarketDeploymentProjectIds){
        Set<Id> setParentProjectIds = new Set<Id>();
        if(setContractProjectIds.size() > 0)
            setParentProjectIds.addAll(setContractProjectIds);

        if(setMarketReadyProjectIds.size() > 0)
            setParentProjectIds.addAll(setMarketReadyProjectIds);

        if(setMarketDeploymentProjectIds.size() > 0)
            setParentProjectIds.addAll(setMarketDeploymentProjectIds);
        
        For(IPM_Financial__c financial : [SELECT Id, Name, Local_Project__c, Financial_External_Id__c, Contract_Approved__c, MR_Approved__c, MD_Approved__c 
                                            FROM IPM_Financial__c
                                            WHERE Local_Project__c IN: setParentProjectIds]){
            String localProjectId = financial.Local_Project__c;
            
            if(localProjectId != NULL){
                if(setContractProjectIds.contains(localProjectId))
                    financial.Contract_Approved__c = TRUE;

                if(setMarketReadyProjectIds.contains(localProjectId))
                    financial.MR_Approved__c = TRUE;

                if(setMarketDeploymentProjectIds.contains(localProjectId))
                    financial.MD_Approved__c = TRUE;
                
                lstUpsertFinancials.add(financial);
            }
        }
    }

    @future
    public static void processProjectFinancials(Set<String> setTrimmedProjectIds, Set<String> setSustainabilityPeriod){
        IPMProcessFinancials handler = new IPMProcessFinancials();
        handler.updateProjectFinancials(setTrimmedProjectIds, setSustainabilityPeriod);
    }
    
    public void updateProjectFinancials(Set<String> setTrimmedProjectIds, Set<String> setSustainabilityPeriod){
        Map<String, String> mapProjectSustainabilityPeriod = new Map<String, String>();
        For(String sustainabilityString : setSustainabilityPeriod){
            String projectId = sustainabilityString.subString(0, sustainabilityString.indexOf('_'));
            String newSustainabilityPeriod = sustainabilityString.subString(sustainabilityString.indexOf('_') + 1, sustainabilityString.lastIndexOf('_'));
            String oldSustainabilityPeriod = sustainabilityString.subString(sustainabilityString.lastIndexOf('_') + 1, sustainabilityString.length());
            
            if(newSustainabilityPeriod == oldSustainabilityPeriod)
                mapProjectSustainabilityPeriod.put(projectId, NO_CHANGE);
            else
                mapProjectSustainabilityPeriod.put(projectId, newSustainabilityPeriod);
        }
        
        List<IPM_Project__c> lstProjects = [SELECT Id, Name, IPM_Project_Name__c, IPMProject_Span__c, IPM_Target_Launch_Dates__c, Sustainability_Period__c, IPM_Project_Type__c, 
                                                    (SELECT Id, Financial_External_ID__c,Project_Sustainability_Period__c
                                                        FROM IPM_Financials_Consolidated__r
                                                        WHERE RecordtypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE),
                                                    (SELECT Id, Financial_External_ID__c,Project_Sustainability_Period__c
                                                        FROM IPM_Financials_Regional__r
                                                        WHERE RecordtypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE)
                                                FROM IPM_Project__c
                                                WHERE Id IN: setTrimmedProjectIds];
        
        List<IPM_Financial__c> lstUpsertFinancials = new List<IPM_Financial__c>();
        Map<String, IPM_Financial__c> mapExistingConsolidatedFinancials = new Map<String, IPM_Financial__c>();
        for(IPM_Project__c ipmProject : lstProjects) {
            For(IPM_Financial__c ipmExistingFinancial : ipmProject.IPM_Financials_Consolidated__r)
                mapExistingConsolidatedFinancials.put(ipmExistingFinancial.Financial_External_ID__c, ipmExistingFinancial);

            For(IPM_Financial__c ipmExistingFinancial : ipmProject.IPM_Financials_Regional__r)
                mapExistingConsolidatedFinancials.put(ipmExistingFinancial.Financial_External_ID__c, ipmExistingFinancial);
        }
        
        for(IPM_Project__c eachproject : lstProjects) {
            //Add new Consolidated Financial
            if(eachproject.IPM_Project_Type__c == 'Original' && eachproject.IPM_Target_Launch_Dates__c != null){
                String externalId = eachproject.IPM_Project_Name__c + '_CONSOLIDATED';
                if(!mapExistingConsolidatedFinancials.containsKey(externalId)){
                    IPM_Financial__c newConsolidatedFinancial = new IPM_Financial__c(
                                                                        //Parent_Project__c = eachproject.Id,
                                                                        RecordtypeId = CONSOLIDATED_FINANCIAL_RECORDTYPE,
                                                                        Financial_External_ID__c = externalId,
                                                                        Target_Launch_Date__c = eachproject.IPM_Target_Launch_Dates__c,
                                                                        Project_Sustainability_Period__c = eachProject.Sustainability_Period__c
                                                                    );
                    if(eachproject.IPMProject_Span__c == 'Global')
                        newConsolidatedFinancial.Parent_Project__c = eachproject.Id;
                    else if(eachproject.IPMProject_Span__c == 'Regional')
                        newConsolidatedFinancial.Regional_Project__c = eachproject.Id;
                    lstUpsertFinancials.add(newConsolidatedFinancial);
                }
            }
        }

        //Sustainability Period
        For(IPM_Financial__c existingFinancial : [SELECT Id, Financial_External_Id__c, Global_Project_Id__c, Project_Sustainability_Period__c
                                                    FROM IPM_Financial__c
                                                    WHERE Global_Project_Id__c IN: setTrimmedProjectIds]){
            if(mapProjectSustainabilityPeriod.get(existingFinancial.Global_Project_Id__c) != NO_CHANGE){
                existingFinancial.Project_Sustainability_Period__c = mapProjectSustainabilityPeriod.get(existingFinancial.Global_Project_Id__c);
                lstUpsertFinancials.add(existingFinancial);
            }
        }

        if(lstUpsertFinancials.size() > 0)
            Database.upsert(lstUpsertFinancials, IPM_Financial__c.Financial_External_ID__c, true);
        
    }
}