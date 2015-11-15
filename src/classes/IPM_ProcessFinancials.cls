/**
* @author       Cognizant (Vipul)
* @date         27/04/2015
* @description  This class is used for processing financials
*/
public without sharing class IPM_ProcessFinancials{

    private List<IPM_Financial__c> lstUpsertFinancials; //List of IPM_Financial__c record to be upserted
    private List<IPM_Project_Rollout__c> lstUpsertLocalRollouts; //List of IPM_Project_Rollout__c (Local Rollouts) record to be upserted
    private List<IPM_Country__c> lstUpdateCountries; //List of IPM_Country__c record to be updated
    
    private static String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId(); //Regional Rollout Recordtype Id
    private static String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId(); //Local Rollout Recordtype Id
    private static String CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId(); //Consolidated Financial Recordtype Id
    
    private static final String NO_CHANGE = 'NoChange'; //String Literal to identify if there is no change in the sustainability period

    private static final String CLASS_NAME = 'IPM_ProcessFinancials'; //Class Name for Exception Logging

    /*******************************************************************************************************
    * @description                  Future method to process financials upon Gate Document Approval
    * @param setProjectDocumentIds  Set of Project Document Ids
    * @return                       NONE
    */
    
    public static void processDocumentApprovalFinancials(Set<Id> setProjectDocumentIds)
    { 
        List<IPM_Project_Document__c> lstProjectDocuments = [SELECT Id, Name, IPM_Document_Status__c, IPM_GateDocuments__c, IPM_Project__c, IPM_Project__r.IPMProject_Span__c, IPM_Project__r.IPM_Project_Name__c
                                                                FROM IPM_Project_Document__c
                                                                WHERE Id IN: setProjectDocumentIds];
        IPM_ProcessFinancials handler = new IPM_ProcessFinancials();
        handler.updateProjectDocumentFinancials(lstProjectDocuments);
    }
    
    /*******************************************************************************************************
    * @description                  Method to update Project Document financials
    * @param lstProjectDocuments    List of Project Documents to be processed
    * @return                       NONE
    */
    public void updateProjectDocumentFinancials(List<IPM_Project_Document__c> lstProjectDocuments){
        try{
            lstUpsertFinancials = new List<IPM_Financial__c>(); //Financial record 
            lstUpsertLocalRollouts = new List<IPM_Project_Rollout__c>(); // local rollout
            lstUpdateCountries = new List<IPM_Country__c>();
    
            Set<Id> setCharterProjectIds = new Set<Id>();
    
            Set<String> setContractFinExtIds = new Set<String>();
            Set<Id> setContractProjectIds = new Set<Id>();
    
            Set<String> setMarketReadyFinExtIds = new Set<String>();
            Set<Id> setMarketReadyProjectIds = new Set<Id>();
    
            Set<String> setMarketDeploymentFinExtIds = new Set<String>();
            Set<Id> setMarketDeploymentProjectIds = new Set<Id>();
    
            // for document approval
            For(IPM_Project_Document__c projectDocument : lstProjectDocuments){
                if (projectDocument.IPM_Document_Status__c == IPM_ConstantUtils.STATUS_APPROVED && projectDocument.IPM_Project__c != null){
                    String projectId = projectDocument.IPM_Project__c;
                    if(projectId.length() > 15)
                        projectId = projectId.subString(0,15);
    
                    String consolidatedFinancialExternalId = projectDocument.IPM_Project__r.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
                    
                    //Charter Document Approved
                    if(projectDocument.IPM_GateDocuments__c == IPM_ConstantUtils.CHARTER_GATE)
                        setCharterProjectIds.add(projectId);
                    
                    //Contract Document Approved
                    else if(projectDocument.IPM_GateDocuments__c == IPM_ConstantUtils.CONTRACT_GATE){
                        if ((projectDocument.IPM_Project__r.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL) 
                                || (projectDocument.IPM_Project__r.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)){
                            setContractFinExtIds.add(consolidatedFinancialExternalId);
                        } else {
                            setContractProjectIds.add(projectId);
                        }
                    }
                    
                    //Market Ready Document Approved
                    else if(projectDocument.IPM_GateDocuments__c == IPM_ConstantUtils.MARKET_READY_GATE){
                        if ((projectDocument.IPM_Project__r.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL) 
                                || (projectDocument.IPM_Project__r.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)){
                            setMarketReadyFinExtIds.add(consolidatedFinancialExternalId);
                        } else {
                            setMarketReadyProjectIds.add(projectId);
                        }
                    }
    
                    //Market Deployment Document Approved
                    else if(projectDocument.IPM_GateDocuments__c == IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE){
                        if ((projectDocument.IPM_Project__r.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL) 
                                || (projectDocument.IPM_Project__r.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)){
                            setMarketDeploymentFinExtIds.add(consolidatedFinancialExternalId);
                        } else {
                            setMarketDeploymentProjectIds.add(projectId);
                        }
                    }
                }
            }
            
            if (setCharterProjectIds != NULL && !setCharterProjectIds.isEmpty())
                processCharterFinancials(setCharterProjectIds);
                
            if((setContractFinExtIds != NULL && !setContractFinExtIds.isEmpty())
                    || (setMarketReadyFinExtIds != NULL && !setMarketReadyFinExtIds.isEmpty())
                    || (setMarketDeploymentFinExtIds != NULL && !setMarketDeploymentFinExtIds.isEmpty()))
                processParentFinancials(setContractFinExtIds, setMarketReadyFinExtIds, setMarketDeploymentFinExtIds);
                processLocalFinancials(setContractProjectIds, setMarketReadyProjectIds, setMarketDeploymentProjectIds);
            
            if(lstUpsertFinancials != NULL && !lstUpsertFinancials.isEmpty())
                Database.upsert(lstUpsertFinancials, IPM_Financial__c.Financial_External_ID__c, true);
    
            if(lstUpsertLocalRollouts != NULL && !lstUpsertLocalRollouts.isEmpty())
                Database.upsert(lstUpsertLocalRollouts, IPM_Project_Rollout__c.IPM_Rollout_Project__c);
            
            if(lstUpdateCountries != NULL && !lstUpdateCountries.isEmpty())
                update lstUpdateCountries;
            
        } catch (Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                            'updateProjectDocumentFinancials',ex.getMessage(),ex, 'Error', null, null, null, null);
                             
        }
    }

    /*******************************************************************************************************
    * @description                  Method to process Charter Document Financials
    * @param setCharterProjectIds   Set of Project Documents to be processed
    * @return                       NONE
    */
    private void processCharterFinancials(Set<Id> setCharterProjectIds){
        List<IPM_Project_Rollout__c> lstRegionalRollout = new List<IPM_Project_Rollout__c>();
        lstRegionalRollout = [SELECT Id, IPM_Rollout_Project__c, 
                                                            (SELECT Id, Name, Regional_Project__c, Charter_Approved__c, Copy_Global_to_Regional__c, Copy_Global_to_Local__c, Financial_External_Id__c, Project_Sustainability_Period__c  
                                                                FROM IPM_Financials__r),
                                                            (SELECT Id, Name, IPM_Rollout_Project__c, Target_Launch_Date__c, KeyMCO__c, Calculated_Sustainability_Period__c, Regional_Project__c  
                                                                FROM Local_Rollouts__r)
                                                        FROM IPM_Project_Rollout__c
                                                        WHERE IPM_Project__c IN: setCharterProjectIds
                                                            AND RecordTypeId =: REGIONAL_ROLLOUT_RECORDTYPE];
        For(IPM_Project_Rollout__c regionalRollout : lstRegionalRollout){
            For (IPM_Financial__c financial : regionalRollout.IPM_Financials__r){
                if(financial.Regional_Project__c == null){
                    String externalId = financial.Financial_External_Id__c;
                    
                    financial.Regional_Project__r = new IPM_Project__c(IPM_Project_Name__c = regionalRollout.IPM_Rollout_Project__c);
                    financial.Charter_Approved__c = TRUE;
                    financial.Financial_External_Id__c = externalId;
                    
                    if(!externalId.contains(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT)){
                        financial.Copy_Global_to_Regional__c = TRUE;
                        financial.Copy_Global_to_Local__c = TRUE;
                    }
                    
                    lstUpsertFinancials.add(financial);
                }
            }


            For (IPM_Project_Rollout__c localRollout : regionalRollout.Local_Rollouts__r){
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
                                Charter_Approved__c = TRUE,
                                Added_At_Stage__c = localRollout.Added_At_Stage__c
                            )
                        );
                     
                     System.debug('@@@@@@@@@@@@@@@@@@@@@@@@ financial External Id@@@@@@@@@@@@@@@@'+localRollout.IPM_Rollout_Project__c);
                    
                    }
                }
            }
        }

        //GLOBAL Consolidated Financial
        //29july2015
        
         List<IPM_Project__c> lstPrj = new List<IPM_Project__c>();
         lstPrj = [SELECT Id ,IPM_Project_Type__c FROM IPM_Project__c WHERE Id IN: setCharterProjectIds];
         System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@prject type before global consoldation financial@@@@@@@@@@@'+lstPrj);                                           
                                                
        
        List<IPM_Financial__c> lstFinancial = new List<IPM_Financial__c>();
        lstFinancial = [SELECT Id, Name, Charter_Approved__c, Financial_External_Id__c 
                                            FROM IPM_Financial__c
                                            WHERE Parent_Project__c IN: setCharterProjectIds
                                                AND Regional_Project__c =: NULL
                                                AND IPM_Project_Rollout__c =: NULL];
        For(IPM_Financial__c financial : lstFinancial){
            String externalId = financial.Financial_External_Id__c;
            
            financial.Charter_Approved__c = TRUE;
            //financial.Copy_Global_to_Regional__c = TRUE;
            //financial.Copy_Global_to_Local__c = TRUE;
            financial.Financial_External_Id__c = externalId;
            lstUpsertFinancials.add(financial);
        }

        //Countries
        List<IPM_Country__c> lstIpmCountry = new List<IPM_Country__c>();
        lstIpmCountry = [SELECT Id, IPM_Regional_Project__c, Local_Rollout__r.Regional_Rollout_External_Id__c
                                            FROM IPM_Country__c
                                            WHERE IPM_Project__c IN: setCharterProjectIds];
        
        For(IPM_Country__c ipmCountry : lstIpmCountry){
            if(ipmCountry.IPM_Regional_Project__c == null){
                ipmCountry.IPM_Regional_Project__r = new IPM_Project__c(IPM_Project_Name__c = ipmCountry.Local_Rollout__r.Regional_Rollout_External_Id__c);
                lstUpdateCountries.add(ipmCountry);
            }
        }
        
    }

    /*******************************************************************************************************
    * @description                          Method to process Charter Document Financials
    * @param setContractFinExtIds           Set of Project Documents to be processed
    * @param setMarketReadyFinExtIds        Set of Project Documents to be processed
    * @param setMarketDeploymentFinExtIds   Set of Project Documents to be processed
    * @return                               NONE
    */
    private void processParentFinancials(Set<String> setContractFinExtIds, 
                                            Set<String> setMarketReadyFinExtIds, 
                                            Set<String> setMarketDeploymentFinExtIds){
        Set<String> setParentFinExtIds = new Set<String>();
        if(setContractFinExtIds != NULL && !setContractFinExtIds.isEmpty())
            setParentFinExtIds.addAll(setContractFinExtIds);

        if(setMarketReadyFinExtIds != NULL && !setMarketReadyFinExtIds.isEmpty())
            setParentFinExtIds.addAll(setMarketReadyFinExtIds);

        if(setMarketDeploymentFinExtIds != NULL && !setMarketDeploymentFinExtIds.isEmpty())
            setParentFinExtIds.addAll(setMarketDeploymentFinExtIds);
        
        List<IPM_Financial__c> lstFinancial = new List<IPM_Financial__c>();
        lstFinancial = [SELECT Id, Name, Financial_External_Id__c, Contract_Approved__c, MR_Approved__c, MD_Approved__c 
                                            FROM IPM_Financial__c
                                            WHERE Financial_External_Id__c IN: setParentFinExtIds];
        For(IPM_Financial__c financial : lstFinancial){
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

    /*******************************************************************************************************
    * @description                          Method to process Local Project Financials
    * @param setContractProjectIds          Set of Projects to be processed
    * @param setMarketReadyProjectIds       Set of Projects to be processed
    * @param setMarketDeploymentProjectIds  Set of Projects to be processed
    * @return                               NONE
    */
    private void processLocalFinancials(Set<Id> setContractProjectIds, 
                                            Set<Id> setMarketReadyProjectIds, 
                                            Set<Id> setMarketDeploymentProjectIds){
        Set<Id> setParentProjectIds = new Set<Id>();
        if(setContractProjectIds != NULL && !setContractProjectIds.isEmpty())
            setParentProjectIds.addAll(setContractProjectIds);

        if(setMarketReadyProjectIds != NULL && !setMarketReadyProjectIds.isEmpty())
            setParentProjectIds.addAll(setMarketReadyProjectIds);

        if(setMarketDeploymentProjectIds != NULL && !setMarketDeploymentProjectIds.isEmpty())
            setParentProjectIds.addAll(setMarketDeploymentProjectIds);
        
        List<IPM_Financial__c> lstFinancial = new List<IPM_Financial__c>();
        lstFinancial = [SELECT Id, Name, Local_Project__c, Financial_External_Id__c, Contract_Approved__c, MR_Approved__c, MD_Approved__c 
                                            FROM IPM_Financial__c
                                            WHERE Local_Project__c IN: setParentProjectIds];
        For(IPM_Financial__c financial : lstFinancial){
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

    /*******************************************************************************************************
    * @description                          Future Method to process Project Financials
    * @param setTrimmedProjectIds           Set of Trimmed (15 char ids) Projects to be processed
    * @param setSustainabilityPeriod        Set of Sustainability Period changes
    * @return                               NONE
    */
    
    public static void processProjectFinancials(Set<String> setTrimmedProjectIds, Set<String> setSustainabilityPeriod)
    {
        IPM_ProcessFinancials handler = new IPM_ProcessFinancials();
        System.debug('@@@@@@@@ processProjectFinancials@@@@@@@@@@@@@@@');
        handler.updateProjectFinancials(setTrimmedProjectIds, setSustainabilityPeriod);
    }
    
    /*******************************************************************************************************
    * @description                          Method to update Project Financials
    * @param setTrimmedProjectIds           Set of Trimmed (15 char ids) Projects to be processed
    * @param setSustainabilityPeriod        Set of Sustainability Period changes
    * @return                               NONE
    */
    public void updateProjectFinancials(Set<String> setTrimmedProjectIds, Set<String> setSustainabilityPeriod)
    {
        System.debug('@@@@@update project fianancial@@@@');
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
            
        List<IPM_Project__c> lstProjects = [SELECT Id, Name, IPM_Project_Name__c, IPMProject_Span__c, IPM_Target_Launch_Dates__c, Sustainability_Period__c, IPM_Project_Type__c, IPM_Phase__c, 
                                                    (SELECT Id, Financial_External_ID__c,Project_Sustainability_Period__c
                                                        FROM IPM_Financials_Consolidated__r
                                                        WHERE RecordtypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE),
                                                    (SELECT Id, Financial_External_ID__c,Project_Sustainability_Period__c
                                                        FROM IPM_Financials_Regional__r
                                                        WHERE RecordtypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE)
                                                FROM IPM_Project__c
                                                WHERE Id IN: setTrimmedProjectIds];
        
        System.debug('@@@@@@@@@@@@@@query result @@@@@@@@@@@@@@@ '+lstProjects);
        
        
        List<IPM_Financial__c> lstUpsertFinancials = new List<IPM_Financial__c>();
        Map<String, IPM_Financial__c> mapExistingConsolidatedFinancials = new Map<String, IPM_Financial__c>(); //consolidated Record
        
        for(IPM_Project__c ipmProject : lstProjects) {
            For(IPM_Financial__c ipmExistingFinancial : ipmProject.IPM_Financials_Consolidated__r)
                mapExistingConsolidatedFinancials.put(ipmExistingFinancial.Financial_External_ID__c, ipmExistingFinancial);

            For(IPM_Financial__c ipmExistingFinancial : ipmProject.IPM_Financials_Regional__r)
                mapExistingConsolidatedFinancials.put(ipmExistingFinancial.Financial_External_ID__c, ipmExistingFinancial);
        }
        //if condition on 29 july 2015    
        for(IPM_Project__c eachproject : lstProjects) {
            //Add new Consolidated Financial
            if((eachproject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL) && eachproject.IPM_Target_Launch_Dates__c != null){
                String externalId = eachproject.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE; // need to create external id
                if(!mapExistingConsolidatedFinancials.containsKey(externalId)){
                    IPM_Financial__c newConsolidatedFinancial = new IPM_Financial__c(
                                                                        //Parent_Project__c = eachproject.Id,
                                                                        RecordtypeId = CONSOLIDATED_FINANCIAL_RECORDTYPE,
                                                                        Financial_External_ID__c = externalId,
                                                                        Target_Launch_Date__c = eachproject.IPM_Target_Launch_Dates__c,
                                                                        Project_Sustainability_Period__c = eachProject.Sustainability_Period__c,
                                                                        Added_At_Stage__c = eachProject.IPM_Phase__c
                                                                    );
                    if(eachproject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
                        newConsolidatedFinancial.Parent_Project__c = eachproject.Id;
                    else if(eachproject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                        newConsolidatedFinancial.Regional_Project__c = eachproject.Id;
                    
                    lstUpsertFinancials.add(newConsolidatedFinancial);
                }
            }
              
           // for default Fiancial Record creation 31july 2015 (eachproject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL && eachproject.IPM_Target_Launch_Dates__c != null)
     
         else if((eachproject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL && eachproject.IPM_Target_Launch_Dates__c != null)){
                 String externalId = eachproject.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_DEFAULT;
                 System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@inside else if@@@@@@@@@@@');
                 String val = '3';
                 IPM_Financial__c newDefaultFinancial = new IPM_Financial__c(
                                                                        RecordtypeId = DEFAULT_FINANCIAL_RECORDTYPE,
                                                                        Financial_External_ID__c = externalId,
                                                                        Target_Launch_Date__c = eachproject.IPM_Target_Launch_Dates__c,
                                                                        Project_Sustainability_Period__c = val,
                                                                        Added_At_Stage__c = eachProject.IPM_Phase__c
                                                                    );
           
                 System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@prject type default without checking span consoldation financial@@@@@@@@@@@'+newDefaultFinancial);          
           
           // NEW GLOBAL AND REGINAL SHould get created without any relationship so change this code later for independent project creation 
           if(eachproject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
                        newDefaultFinancial.Parent_Project__c = eachproject.Id; // creating lookup for finance n projecty
           else if(eachproject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                        newDefaultFinancial.Regional_Project__c = eachproject.Id;
           // check for local and put project
           lstUpsertFinancials.add(newDefaultFinancial);
         }
            
             System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@project list added @@@@@@@@@@@'+lstUpsertFinancials);  
       
        // 31july2015 
        }//for end 
    
    
        //Sustainability Period
        List<IPM_Financial__c> lstExistingFinancial = new List<IPM_Financial__c>();
        lstExistingFinancial = [SELECT Id, Financial_External_Id__c, Global_Project_Id__c, Regional_Project__c, Project_Sustainability_Period__c
                                                    FROM IPM_Financial__c
                                                    WHERE Global_Project_Id__c IN: setTrimmedProjectIds 
                                                        OR Regional_Project__c IN: setTrimmedProjectIds];
        For(IPM_Financial__c existingFinancial : lstExistingFinancial){
            //Global Original Projects
            if(mapProjectSustainabilityPeriod.containsKey(existingFinancial.Global_Project_Id__c)){
                if(mapProjectSustainabilityPeriod.get(existingFinancial.Global_Project_Id__c) != NO_CHANGE){
                    existingFinancial.Project_Sustainability_Period__c = mapProjectSustainabilityPeriod.get(existingFinancial.Global_Project_Id__c);
                    lstUpsertFinancials.add(existingFinancial);
                }
            }
            //Regional Original Projects
            else{
                String trimmedRegionalProjectId = existingFinancial.Regional_Project__c;
                if(trimmedRegionalProjectId != null && trimmedRegionalProjectId != '' && trimmedRegionalProjectId.length() > 15)
                    trimmedRegionalProjectId = trimmedRegionalProjectId.subString(0,15);
                
                if(mapProjectSustainabilityPeriod.containsKey(trimmedRegionalProjectId)){
                    if(mapProjectSustainabilityPeriod.get(trimmedRegionalProjectId) != NO_CHANGE){
                        existingFinancial.Project_Sustainability_Period__c = mapProjectSustainabilityPeriod.get(trimmedRegionalProjectId);
                        lstUpsertFinancials.add(existingFinancial);
                    }
                }
            }
        }
    
        if(lstUpsertFinancials != NULL && !lstUpsertFinancials.isEmpty())
        {
            Database.upsert(lstUpsertFinancials, IPM_Financial__c.Financial_External_ID__c, false);
        }
    }
}