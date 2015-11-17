/**
* @author       Cognizant (Vipul)
* @date         27/04/2015
* @description  This class is used for managing the trigger methods for IPM_Financial__c object 
*/
public without sharing class IPM_FinancialTriggerHandler{

    private static String DEFAULT_FINANCIAL_RECORDTYPE; //Recordtype Id for Default on IPM_Financial__c object
    private static String CONSOLIDATED_FINANCIAL_RECORDTYPE; //Recordtype Id for Consolidated on IPM_Financial__c object

    private List<IPM_Financial_Year__c> lstInsertFinancialYears; //List of IPM_Financial__c object records to be inserted
    private List<IPM_Financial_Year__c> lstUpdateFinancialYears; //List of IPM_Financial__c object records to be updated

    private Map<String, IPM_Financial__c> mapUpsertConsolidatedFinancials; //Map of IPM_Financial__c object records to be upserted
    private Map<String, IPM_Financial__c> mapAllConsolidatedFinancials; //Map of all relevant Consolidated IPM_Financial__c object records

    private Map<String, String> mapGlobalConsolidatedFinancials; //Map of all relevant GLOBAL Consolidated IPM_Financial__c object records
    private Map<String, String> mapRegionalConsolidatedFinancials; //Map of all relevant REGIONAL Consolidated IPM_Financial__c object records

    private Set<String> setFinancialExternalIds; //Set of Financial External Ids
    
    private static final String Y_LABEL = 'Y'; //Innovation Year Label Prefix
    
    private static final String CLASS_NAME = 'IPM_FinancialTriggerHandler'; //Class Name for Exception Logging

    /*******************************************************************************************************
    * @description          Method to handle after insert Trigger context for IPM_Financial__c object
    * @param newFinancials  List of Trigger.new records
    * @return               NONE
    */
    public void onAfterInsert(List<IPM_Financial__c> newFinancials)    
    {
        lstInsertFinancialYears = new List<IPM_Financial_Year__c>();
    
        for(IPM_Financial__c financial : newFinancials)
        {
            processIPMFinancialYears(financial);
        }
            
        if(lstInsertFinancialYears!=null && !lstInsertFinancialYears.isEmpty())
        {
            insert lstInsertFinancialYears;
        }
    }
    
    
    /*******************************************************************************************************
    * @description          Method to handle before insert Trigger context for IPM_Financial__c object
    * @param newFinancials  List of Trigger.new records
    * @return               NONE
    */
    public void onBeforeInsert(List<IPM_Financial__c> newFinancials)
    {
        //@@Design Review - Data Sharing - To update the ownerid of financial to project owner id
        Set<Id> projectIdset=new Set<Id>(); 
        Map<Id,IPM_Project__c>projectMap; 
          
        for(IPM_Financial__c finance:newFinancials)
        {
            if(finance.Parent_Project__c != null)
            {
                projectIdset.add(finance.Parent_Project__c);                       
            }else if(finance.Regional_Project__c!= null){
                projectIdset.add(finance.Regional_Project__c);  
                
            }else if(finance.Local_Project__c!= null){
                projectIdset.add(finance.Local_Project__c);    
            }
        }
        
        
        if(projectIdset != null && projectIdset.size() >0)
        {
            projectMap = new Map<Id,IPM_Project__c>([Select id, ownerid, IPM_Category_Text__c from IPM_Project__c where id IN:projectIdset]);
        }
        
        if(projectMap != null && projectMap.keyset().size() >0)
        {
            for(IPM_Financial__c finance:newFinancials)
            {                    
                if(finance.Parent_Project__c!=null && projectMap.containskey(finance.Parent_Project__c))
                {
                    finance.ownerid = projectMap.get(finance.Parent_Project__c).ownerid; 
                    finance.IPM_Category__c=projectMap.get(finance.Parent_Project__c).IPM_Category_Text__c;
                }else if(finance.Regional_Project__c!=null && projectMap.containskey(finance.Regional_Project__c))
                {
                    finance.ownerid = projectMap.get(finance.Regional_Project__c).ownerid; 
                    finance.IPM_Category__c=projectMap.get(finance.Regional_Project__c).IPM_Category_Text__c;
                }
                else if(finance.Local_Project__c!=null && projectMap.containskey(finance.Local_Project__c))
                {
                    finance.ownerid = projectMap.get(finance.Local_Project__c).ownerid; 
                    finance.IPM_Category__c=projectMap.get(finance.Local_Project__c).IPM_Category_Text__c;
                }   
            }
        }
    }

    /*******************************************************************************************************
    * @description          Method to process individual Financial Record
    * @param ipmFinancial   Passed IPM_Financial__c record
    * @return               NONE
    */
    private void processIPMFinancialYears(IPM_Financial__c ipmFinancial)
    {
        String externalId = ipmFinancial.Financial_External_ID__c;

        //Y0
        lstInsertFinancialYears.add(processFinancialYear(externalId, IPM_ConstantUtils.Y0_LABEL, IPM_ConstantUtils.Y0_YEARINDEX, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, NULL));
        lstInsertFinancialYears.add(processFinancialYear(externalId, IPM_ConstantUtils.Y0_LABEL, IPM_ConstantUtils.Y0_YEARINDEX, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, NULL));
        
        //Rest of the Years
        For(integer i=1; i<=Integer.valueOf(ipmFinancial.Project_Sustainability_Period__c); i++)
        {
            lstInsertFinancialYears.add(processFinancialYear(externalId, Y_LABEL+i, ''+i, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.PL_TYPE_GROSS));
            lstInsertFinancialYears.add(processFinancialYear(externalId, Y_LABEL+i, ''+i, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.PL_TYPE_INCREMENTAL));

            Integer calendarYear = ipmFinancial.Target_Launch_Date__c.year() + i - 1;
            lstInsertFinancialYears.add(processFinancialYear(externalId, ''+calendarYear, ''+i, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_GROSS));
            lstInsertFinancialYears.add(processFinancialYear(externalId, ''+calendarYear, ''+i, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_INCREMENTAL));
        }
    }
    
    /*******************************************************************************************************
    * @description                  Method to process individual Financial Year Record
    * @param financialExternalId    Parent Financial External Id
    * @param yearName               Year Name
    * @param index                  Year Index
    * @param yearType               Year Type
    * @param plType                 P&L Type
    * @return                       IPM_Financial_Year__c record for the passed Financial record
    */
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
    
    /*******************************************************************************************************
    * @description                  Method to process individual Financial Year External Id
    * @param financialExternalId    Parent Financial External Id
    * @param yearName               Year Name
    * @param yearType               Year Type
    * @param plType                 P&L Type
    * @return                       Financial Year External Id
    */
    private String getFinancialYearExternalId(String financialExternalId,  String yearName, String yearType, String plType){
        return financialExternalId + '_' + yearName + '_' + yearType + '_' + plType;
    }


    /*******************************************************************************************************
    * @description              Method to handle before delete Trigger context for IPM_Financial__c object
    * @param mapOldFinancials   Map of Trigger.old records
    * @return                   NONE
    */
    public void onBeforeDelete(Map<Id, IPM_Financial__c> mapOldFinancials)
    {
        getFinancials(mapOldFinancials.keySet());
        initialiseConsolidation(null, mapOldFinancials);
        
        //Write logic to process child record deletion - Salsforce Bug (https://success.salesforce.com/ideaView?id=08730000000BqSJ)
        Set<Id> setFinancialIds = mapOldFinancials.keySet();
        String queryString = 'SELECT ';
        For (String field : Schema.SObjectType.IPM_Financial_Year__c.fields.getMap().KeySet()){
            if (field != 'Id')
                queryString+= field + ', ';
        }
        queryString+= 'Id FROM IPM_Financial_Year__c WHERE IPM_Financial__c IN: setFinancialIds';
        Map<Id, IPM_Financial_Year__c> mapFinancialYears = new Map<Id, IPM_Financial_Year__c>((List<IPM_Financial_Year__c>) Database.query(queryString));

        IPM_FinancialYearTriggerHandler handler = new IPM_FinancialYearTriggerHandler();
        handler.onBeforeDelete(mapFinancialYears);
    }
    
    /*******************************************************************************************************
    * @description              Method to handle after update Trigger context for IPM_Financial__c object
    * @param mapNewFinancials   Map of Trigger.new records
    * @param mapOldFinancials   Map of Trigger.old records
    * @return                   NONE
    */
    public void onAfterUpdate(Map<Id, IPM_Financial__c> mapNewFinancials, Map<Id, IPM_Financial__c> mapOldFinancials)
    {
        
       List<IPM_Financial__c> IPM_FinancialQueryList =[Select Id, Name, Misaligned__c, MisalignmentDateTime__c, Target_Launch_Date__c, Regional_Project__c, Regional_Project__r.Name, 
                        Regional_Project__r.IPM_Target_Launch_Dates__c, Local_Project__c, 
                        Local_Project__r.Name, Local_Project__r.IPM_Target_Launch_Dates__c,Volume_Unit_Difference__c,NPV_Difference__c, IRR_Difference__c,
                         Payback_Difference__c,CAPEX_Difference__c,BIC_Difference__c,Total_FY_Difference__c from IPM_Financial__c 
                         where id in: mapNewFinancials.keyset() and Recordtype.Name =: 'Default' and  MisalignmentDateTime__c =: System.now() limit: IPM_ConstantUtils.MaxLimit];
       for(IPM_Financial__c financial : IPM_FinancialQueryList){
          List<IPM_Project__c> updatedProjects = new List<IPM_Project__c>();
            
            IF(( financial.Volume_Unit_Difference__c + financial.NPV_Difference__c + financial.IRR_Difference__c + financial.Payback_Difference__c + financial.CAPEX_Difference__c + financial.BIC_Difference__c + financial.Total_FY_Difference__c ) > 0){
                if(financial.Local_Project__c != null &&  financial.Misaligned__c){
                    updatedProjects.add(financial.Regional_Project__r);
                    updatedProjects.add(financial.Local_Project__r);
                    IPM_ChatterFeedHelper.postChatterIfLocalRegionalMisaligned(updatedProjects);
                }
            }else{
               if(financial.Local_Project__c != null && !financial.Misaligned__c){
                    updatedProjects.add(financial.Regional_Project__r);
                    updatedProjects.add(financial.Local_Project__r);
                    IPM_ChatterFeedHelper.postChatterIfLocalRegionalMisaligned(updatedProjects);
                }
            }
       }
       
       //Manage Financial Year Updates for DEFAULT Financials
       
        for(IPM_Financial__c financial : getFinancials(mapNewFinancials.keySet()))
        {
             For (IPM_Financial_Year__c finYear : financial.IPM_Financial_Years__r)
            {
                boolean isChanged = false;
                if(finYear.Charter_Approved__c != financial.Charter_Approved__c)
                {
                    finYear.Charter_Approved__c = financial.Charter_Approved__c;
                    isChanged = true;
                }
                
                if(finYear.Contract_Approved__c != financial.Contract_Approved__c)
                {
                    finYear.Contract_Approved__c = financial.Contract_Approved__c;
                    isChanged = true;
                }
                
                if(finYear.MR_Approved__c != financial.MR_Approved__c)
                {
                    finYear.MR_Approved__c = financial.MR_Approved__c;  
                    isChanged = true;
                }
                
                if(finYear.MD_Approved__c != financial.MD_Approved__c)
                {
                    finYear.MD_Approved__c = financial.MD_Approved__c;
                    isChanged = true;
                }
                
                if(finYear.Copy_Global_to_Regional__c != financial.Copy_Global_to_Regional__c)
                {
                    finYear.Copy_Global_to_Regional__c = financial.Copy_Global_to_Regional__c;
                    isChanged = true;
                }
                
                if(finYear.Copy_Global_to_Local__c != financial.Copy_Global_to_Local__c)
                {
                    finYear.Copy_Global_to_Local__c = financial.Copy_Global_to_Local__c;
                    isChanged = true;
                }
                
                if(finYear.Copy_Local_to_Regional__c != financial.Copy_Local_to_Regional__c)
                {
                    finYear.Copy_Local_to_Regional__c = financial.Copy_Local_to_Regional__c;
                    isChanged = true;
                }
                
                if(finYear.Copy_Regional_to_Local__c != financial.Copy_Regional_to_Local__c)
                {
                    finYear.Copy_Regional_to_Local__c = financial.Copy_Regional_to_Local__c;
                    isChanged = true;
                }
                
                if(finYear.Volume_Unit_Global__c != financial.Volume_Unit_Global__c)
                {
                    finYear.Volume_Unit_Global__c = financial.Volume_Unit_Global__c;
                    isChanged = true;
                }
                
                if(finYear.Volume_Unit_Regional__c != financial.Volume_Unit_Regional__c)
                {
                    finYear.Volume_Unit_Regional__c = financial.Volume_Unit_Regional__c;
                    isChanged = true;
                }
                
                if(finYear.Volume_Unit_Local__c != financial.Volume_Unit_Local__c)
                {
                    finYear.Volume_Unit_Local__c = financial.Volume_Unit_Local__c;
                    isChanged = true;
                }
                
                if(isChanged)
                {
                    lstUpdateFinancialYears.add(finYear);
                }
            }
            
            
            
            processSustainabilityPeriod(financial, mapOldFinancials.get(financial.Id), financial.IPM_Financial_Years__r);
        }
            
        initialiseConsolidation(mapNewFinancials, mapOldFinancials);
    }

    /*******************************************************************************************************
    * @description              Method to get Financcial records for the passed Financial Ids
    * @param setFinancialIds    Set of Financial Ids to be processed
    * @return                   List of IPM_Financial__c records
    */
    private List<IPM_Financial__c> getFinancials(Set<Id> setFinancialIds)
    {
        lstInsertFinancialYears = new List<IPM_Financial_Year__c>();
        lstUpdateFinancialYears = new List<IPM_Financial_Year__c>();
        
        List<IPM_Financial__c> lstFinancials = [SELECT Id, Financial_External_ID__c, Charter_Approved__c, Contract_Approved__c, MR_Approved__c, MD_Approved__c, Copy_Global_to_Regional__c, Copy_Global_to_Local__c, Copy_Local_to_Regional__c, Copy_Regional_to_Local__c,  Global_External_Id__c, Regional_External_Id__c, Volume_Unit_Global__c, Volume_Unit_Regional__c, Volume_Unit_Local__c, Project_Sustainability_Period__c, Target_Launch_Date__c, 
                                                        (SELECT Id, External_Id__c, Charter_Approved__c, Contract_Approved__c, MR_Approved__c, MD_Approved__c, Copy_Global_to_Regional__c, Copy_Global_to_Local__c, Copy_Local_to_Regional__c, Copy_Regional_to_Local__c, Volume_Unit_Global__c, Volume_Unit_Regional__c, Volume_Unit_Local__c 
                                                            FROM IPM_Financial_Years__r)
                                                    FROM IPM_Financial__c
                                                    WHERE Id IN: setFinancialIds LIMIT 50000];

        mapGlobalConsolidatedFinancials = new Map<String, String>();
        mapRegionalConsolidatedFinancials = new Map<String, String>();

        setFinancialExternalIds = new Set<String>();
        For(IPM_Financial__c financial : lstFinancials){
            if(financial.Global_External_Id__c != null && financial.Global_External_Id__c != ''){
                String globalExternalId = financial.Global_External_Id__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
                mapGlobalConsolidatedFinancials.put(financial.Id, globalExternalId);
                setFinancialExternalIds.add(globalExternalId);
            }

            String regionalExternalId = financial.Regional_External_Id__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
            mapRegionalConsolidatedFinancials.put(financial.Id, regionalExternalId);
            setFinancialExternalIds.add(regionalExternalId);
        }

        return lstFinancials;
    }
    
    /*******************************************************************************************************
    * @description              Method to initialise consolidation of financial business cases
    * @param mapNewFinancials   Map of Trigger.new records
    * @param mapOldFinancials   Map of Trigger.old records
    * @return                   NONE
    */
    private void initialiseConsolidation(Map<Id, IPM_Financial__c> mapNewFinancials, Map<Id, IPM_Financial__c> mapOldFinancials){
        DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
        CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();

        //Consolidate Financials
        getConsolidatedFinancials(setFinancialExternalIds);
        mapUpsertConsolidatedFinancials = new Map<String, IPM_Financial__c>();
        
        if(mapNewFinancials != null)
        {
            for(IPM_Financial__c newFinancial : mapNewFinancials.values())
            {
                if(newFinancial.RecordtypeId == DEFAULT_FINANCIAL_RECORDTYPE)
                {
                    //Consolidate Global Financials for Global Original Projects only
                    if(newFinancial.Global_External_Id__c != null && newFinancial.Global_External_Id__c != '')
                    {
                        consolidateFinancials(newFinancial, mapOldFinancials.get(newFinancial.Id), IPM_ConstantUtils.PROJECT_SPAN_GLOBAL);
                    }
                    
                    consolidateFinancials(newFinancial, mapOldFinancials.get(newFinancial.Id), IPM_ConstantUtils.PROJECT_SPAN_REGIONAL);
                }
            }
        } 
        else 
        {
            for(IPM_Financial__c oldFinancial : mapOldFinancials.values())
            {
                if(oldFinancial.RecordtypeId == DEFAULT_FINANCIAL_RECORDTYPE)
                {
                    //Consolidate Global Financials for Global Original Projects only
                    if(oldFinancial.Global_External_Id__c != null && oldFinancial.Global_External_Id__c != '')
                    {
                        consolidateFinancials(null, oldFinancial, IPM_ConstantUtils.PROJECT_SPAN_GLOBAL);
                    }
                    
                    consolidateFinancials(null, oldFinancial, IPM_ConstantUtils.PROJECT_SPAN_REGIONAL);
                }
            }
        }

        if(mapUpsertConsolidatedFinancials!=null && !mapUpsertConsolidatedFinancials.isEmpty())
            Database.upsert(mapUpsertConsolidatedFinancials.values(), IPM_Financial__c.Financial_External_ID__c, false);

        if (lstUpdateFinancialYears!=null && !lstUpdateFinancialYears.isEmpty())
            Database.update(lstUpdateFinancialYears);

        if (lstInsertFinancialYears!=null && !lstInsertFinancialYears.isEmpty())
            Database.insert(lstInsertFinancialYears);
    }
    
    /*******************************************************************************************************
    * @description                      Method to process change in sustainability period for the financials
    * @param newFinancial               New Financial record
    * @param oldFinancial               Old Financial records
    * @param lstExistingFinancialYears  List of Existing Financial Year records
    * @return                           NONE
    */
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
                if(!setExistingFinancialYears.contains(getFinancialYearExternalId(newFinancial.Financial_External_ID__c, 'Y'+index, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.PL_TYPE_GROSS))){
                    lstInsertFinancialYears.add(processFinancialYear(newFinancial.Financial_External_ID__c, 'Y'+index, ''+index, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.PL_TYPE_GROSS));
                    lstInsertFinancialYears.add(processFinancialYear(newFinancial.Financial_External_ID__c, 'Y'+index, ''+index, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.PL_TYPE_INCREMENTAL));

                }
                if(!setExistingFinancialYears.contains(getFinancialYearExternalId(newFinancial.Financial_External_ID__c, ''+calendarYear, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_GROSS))){
                    lstInsertFinancialYears.add(processFinancialYear(newFinancial.Financial_External_ID__c, ''+calendarYear, ''+index, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_GROSS));
                    lstInsertFinancialYears.add(processFinancialYear(newFinancial.Financial_External_ID__c, ''+calendarYear, ''+index, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_INCREMENTAL));
                }
            }
        }
    }

    /*******************************************************************************************************
    * @description                      Method to get consolidated financials for processing
    * @param setFinancialExternalIds    Set of Financial External Ids
    * @return                           NONE
    */
    private void getConsolidatedFinancials(Set<String> setFinancialExternalIds){
        CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
        
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

    /*******************************************************************************************************
    * @description              Method to consiolidate financials
    * @param newFinancial       New Financial record
    * @param oldFinancial       Old Financial records
    * @param consolidationType  Consolidation type
    * @return                   NONE
    */
    private void consolidateFinancials(IPM_Financial__c newFinancial, IPM_Financial__c oldFinancial, String consolidationType){
        String newConsolidatedFinExtId;
        String oldConsolidatedFinExtId;
        if(consolidationType == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
        {
            if(newFinancial != null)
            {
                newConsolidatedFinExtId = mapGlobalConsolidatedFinancials.get(newFinancial.Id);
            }
            
            oldConsolidatedFinExtId = mapGlobalConsolidatedFinancials.get(oldFinancial.Id);
        } 
        else if(consolidationType == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
        {
            if(newFinancial != null)
            {
                newConsolidatedFinExtId = mapRegionalConsolidatedFinancials.get(newFinancial.Id);
            }

            oldConsolidatedFinExtId = mapRegionalConsolidatedFinancials.get(oldFinancial.Id);
        }

        IPM_Financial__c newConsolidatedFinancial = new IPM_Financial__c();
        if(newFinancial != null)
        {
            newConsolidatedFinancial = mapAllConsolidatedFinancials.get(newConsolidatedFinExtId);
            
            if(mapUpsertConsolidatedFinancials.containsKey(newConsolidatedFinExtId))
            {
                newConsolidatedFinancial = mapUpsertConsolidatedFinancials.get(newConsolidatedFinExtId);
            }

        }

        IPM_Financial__c oldConsolidatedFinancial = mapAllConsolidatedFinancials.get(oldConsolidatedFinExtId);
        
        if(oldConsolidatedFinancial!=null)
        {
            if(mapUpsertConsolidatedFinancials.containsKey(oldConsolidatedFinExtId))
            {
                oldConsolidatedFinancial = mapUpsertConsolidatedFinancials.get(oldConsolidatedFinExtId);
            }

            consolidateFinancialRecord(newFinancial, newConsolidatedFinancial, oldFinancial, oldConsolidatedFinancial);
        }
    }
    
    /*******************************************************************************************************
    * @description                      Method to consiolidate financial records
    * @param newFinancial               New Financial record
    * @param newConsolidatedFinancial   New Consolidated Financial record
    * @param oldFinancial               Old Financial records
    * @param oldConsolidatedFinancial   Old Consolidated Financial record
    * @return                           NONE
    */
    
    private void consolidateFinancialRecord(IPM_Financial__c newFinancial, IPM_Financial__c newConsolidatedFinancial, IPM_Financial__c oldFinancial, IPM_Financial__c oldConsolidatedFinancial){
        processConsolidation(newFinancial, newConsolidatedFinancial, oldFinancial, oldConsolidatedFinancial, IPM_ConstantUtils.FIELD_LITERAL_BIC);
        processConsolidation(newFinancial, newConsolidatedFinancial, oldFinancial, oldConsolidatedFinancial, IPM_ConstantUtils.FIELD_LITERAL_CAPEX);
        processConsolidation(newFinancial, newConsolidatedFinancial, oldFinancial, oldConsolidatedFinancial, IPM_ConstantUtils.FIELD_LITERAL_NPV);
        processConsolidation(newFinancial, newConsolidatedFinancial, oldFinancial, oldConsolidatedFinancial, IPM_ConstantUtils.FIELD_LITERAL_PAYBACK);
        processLastSaved(newConsolidatedFinancial, oldConsolidatedFinancial);
    }
    
    /*******************************************************************************************************
    * @description                      Method to process consolidation
    * @param newFinancial               New Financial record
    * @param newConsolidatedFinancial   New Consolidated Financial record
    * @param oldFinancial               Old Financial records
    * @param oldConsolidatedFinancial   Old Consolidated Financial record
    * @param fieldName                  fieldname of the field to be consolidated
    * @return                           NONE
    */
    private void processConsolidation(IPM_Financial__c newFinancial, IPM_Financial__c newConsolidatedFinancial, IPM_Financial__c oldFinancial, IPM_Financial__c oldConsolidatedFinancial, String fieldName){
        IPM_Financial__c newConsFinancial = newConsolidatedFinancial;
        IPM_Financial__c oldConsFinancial = oldConsolidatedFinancial;
        
        Set<String> fieldSufixes = new Set<String>{IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, IPM_ConstantUtils.PROJECT_SPAN_REGIONAL, IPM_ConstantUtils.PROJECT_SPAN_LOCAL};
        Decimal value;
        
        For(String suffix : fieldSufixes)
        {
            if(newFinancial != null && newConsFinancial !=null)
            {
                //NEW Consolidated Financial
                if(mapUpsertConsolidatedFinancials!=null && mapUpsertConsolidatedFinancials.containsKey(newConsFinancial.Financial_External_ID__c))
                {
                    newConsFinancial = mapUpsertConsolidatedFinancials.get(newConsFinancial.Financial_External_ID__c);
                }
                
                Object newValueObject = newConsFinancial.get(fieldname + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                
                if(newValueObject == null)
                {
                    value = (Decimal) newFinancial.get(fieldname + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                }
                else
                {
                    value = (Decimal) newConsFinancial.get(fieldname + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) + (Decimal) newFinancial.get(fieldname + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                }
    
                newConsFinancial.put(fieldname + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
                mapUpsertConsolidatedFinancials.put(newConsFinancial.Financial_External_ID__c, newConsFinancial); 
            }
    
            //OLD Consolidated Financial
            if(oldConsFinancial!=null && mapUpsertConsolidatedFinancials.containsKey(oldConsFinancial.Financial_External_ID__c))
            {
                oldConsFinancial = mapUpsertConsolidatedFinancials.get(oldConsFinancial.Financial_External_ID__c);
            }
            
            if(oldConsFinancial!=null)
            {
                value = (Decimal) oldConsFinancial.get(fieldname + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) - (Decimal) oldFinancial.get(fieldname + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            
                oldConsFinancial.put(fieldname + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, value);
            
                mapUpsertConsolidatedFinancials.put(oldConsFinancial.Financial_External_ID__c, oldConsFinancial);
            }
        }
    }

    /*******************************************************************************************************
    * @description                      Method to process Last Saved data
    * @param newConsolidatedFinancial   New Consolidated Financial record
    * @param oldConsolidatedFinancial   Old Consolidated Financial record
    * @return                           NONE
    */
    private void processLastSaved(IPM_Financial__c newConsolidatedFinancial, IPM_Financial__c oldConsolidatedFinancial){
        Set<String> fieldSufixes = new Set<String>{IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, IPM_ConstantUtils.PROJECT_SPAN_REGIONAL, IPM_ConstantUtils.PROJECT_SPAN_LOCAL};
        For(String suffix : fieldSufixes){
            if(newConsolidatedFinancial != null) 
            {
                //NEW Consolidated Financial
                newConsolidatedFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_LAST_SAVED + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, System.now());
                newConsolidatedFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_LAST_SAVED_BY + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, UserInfo.getUserId());
                mapUpsertConsolidatedFinancials.put(newConsolidatedFinancial.Financial_External_ID__c, newConsolidatedFinancial);
            }

            //OLD Consolidated Financial
            oldConsolidatedFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_LAST_SAVED + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, System.now());
            oldConsolidatedFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_LAST_SAVED_BY + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, UserInfo.getUserId());
            mapUpsertConsolidatedFinancials.put(oldConsolidatedFinancial.Financial_External_ID__c, oldConsolidatedFinancial);
        }
    }
    
    /*******************************************************************************************************
    * @description                      Method to update Financial Action Standards at Charter
    * @param mapNewFinancials           New Consolidated Financial record
    * @return                           NONE
    */
    public void updateFinancialActionStandard(Map<Id, IPM_Financial__c> mapNewFinancials){
        CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
        List<IPM_Financial__c> newFinList=new List<IPM_Financial__c>();
        List<IPM_Project_Document_Section_Content__c> projDocSecConList=new List<IPM_Project_Document_Section_Content__c>();
        Set<Id> projectIds=new Set<Id>();
        for(IPM_Financial__c newFin:mapNewFinancials.values()){
            if(newFin.RecordtypeId == CONSOLIDATED_FINANCIAL_RECORDTYPE && newFin.Regional_Project__c==null && newFin.Local_Project__c==null && !newFin.Charter_Approved__c){
                newFinList.add(newFin);
                projectIds.add(newFin.Parent_Project__c);
            }
        }
        if(projectIds!=null && !projectIds.isEmpty()){
            projDocSecConList=[SELECT Id,IPM_IRR_Action_Standard_Charter__c,IPM_NPV_Action_Standard_Charter__c,IPM_Payback_Action_Standard_Charter__c,IPM_Content_Type__c,
                               IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c,
                               IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Phase__c
                               FROM IPM_Project_Document_Section_Content__c
                               WHERE IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c In:projectIds AND IPM_Content_Type__c='Financial Action Standards' AND
                                     IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Phase__c='Ideas'];
        }                  
        for(IPM_Financial__c fin:newFinList){
            for(IPM_Project_Document_Section_Content__c secContent:projDocSecConList){
                if(secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c==fin.Parent_Project__c){
                    secContent.IPM_Payback_Action_Standard_Charter__c=fin.Payback_Global__c;
                    secContent.IPM_IRR_Action_Standard_Charter__c=fin.IRR_Global__c;
                    secContent.IPM_NPV_Action_Standard_Charter__c=fin.NPV_Global__c;
                }
            }
        }
        if(projDocSecConList!=null && !projDocSecConList.isEmpty()){
            update projDocSecConList;
        }
    }
}