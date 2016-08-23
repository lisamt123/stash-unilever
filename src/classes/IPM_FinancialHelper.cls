/******************************************************************************************************
* @Author Cognizant
* @Name IPM_FinancialHelper
* @CreateDate :  05/01/2016
* @Description:  This class is a Helper Class used by Financial Handler to perform operations like 
*   			 checking if consolidated fields changed,  Doing the actual consolidation.
*  				 Creating new Consolidated Financial Years based on Change in TLD
* 				 Create new Financial Years based on Sustainability Period.  
*   			 Creation relationship maps between Consolidated and associated Financials.
* @Version 1.0
******************************************************************************************************/

public with sharing class IPM_FinancialHelper 
{
    private static final Set<String> FIELD_SUFFIX = new Set<String>{IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, IPM_ConstantUtils.PROJECT_SPAN_REGIONAL, IPM_ConstantUtils.PROJECT_SPAN_LOCAL};
    
    private static final String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId(); //Recordtype Id for Default on IPM_Financial__c object
    private static final String CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
    private static final String Y_LABEL = 'Y'; //Innovation Year Label Prefix
    
    public static final Set<String> APPROVAL_FIELDSET = new Set<String>
        {
            'Charter_Approved__c','Contract_Approved__c','MR_Approved__c','MD_Approved__c' 
        };
    
    public static final Set<String> COPYOVER_FIELDSET = new Set<String>   
        {
            'Copy_Global_to_Regional__c','Copy_Global_to_Local__c','Copy_Regional_to_Local__c','Copy_Local_to_Regional__c'
        };
    
    
    public static final Set<String> FIELDS_TO_CONSOLIDATE = new Set<String>{   
            'BIC_Global__c','BIC_Regional__c','BIC_Local__c', 
            'CAPEX_Global__c','CAPEX_Regional__c','CAPEX_Local__c'  
        };
    
    public static final Set<String> VOLUME_FIELDS = new Set<String>{
            'Volume_Unit_Global__c','Volume_Unit_Local__c','Volume_Unit_Regional__c'
        };
    
    public static final String ACTIVE_FIELD = 'isActive__c';  
    
    public static final Set<String> ADDITIONAL_FIELDS = new Set<String> { 'IPM_Financial_Postfix__c'};
    
    public static Boolean SKIP_TRIGGER_EXECUTION = false;
    
    /*******************************************************************************************************
    * @description      Method to handle after insert Trigger context for IPM_Financial__c object. 
                        Creates Financial Year record whenever Financial Record is created.
                        
    * @param1 newFinancials  List of Trigger.new records
    * @param2 newFinancials  List of Trigger.new records
    * @return               NONE
    ********************************************************************************************************/
    public static void insertFinancialYears(List<IPM_Financial__c> newFinancials,Map<String,IPM_Financial_Year__c>  upsertFinancialYearMap)     
    {
        for(IPM_Financial__c financial : newFinancials)
        {
            processIPMFinancialYears(financial,upsertFinancialYearMap);
        }  
    }
	
	/*******************************************************************************************************
    * @description      Method to handle after update  Trigger context for IPM_Financial__c object. 
                        Deletes  Financial Year records falling before TLD of consolidated financials
                        
    * @param1 newFinancials  List of Trigger.new records
    * @return               NONE
    ********************************************************************************************************/
    public static void deleteFinancialYears(List<IPM_Financial__c> newFinancials)      
    {
        List<IPM_Financial_Year__c> deleteIPMFinancialYears = new List<IPM_Financial_Year__c>();
        for(IPM_Financial__c financial : [Select Id ,Target_Launch_Date__c ,( Select Id,Name from IPM_Financial_Years__r where Year_Type__c=:IPM_ConstantUtils.YEAR_TYPE_CALENDAR AND  (NOT Name like '%Y%')) from IPM_Financial__c where Id IN :newFinancials  AND recordtypeId =:Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Consolidated').getRecordTypeId()])
        {
            Integer tldYear =financial.Target_Launch_Date__c.year();
            for(IPM_Financial_Year__c finYear :financial.IPM_Financial_Years__r)
            {
            	if(tldYear > Integer.valueOf(finYear.name)) 
            	{
            	  deleteIPMFinancialYears.add(finYear);
            	}
            
            }
            
        }
        if(deleteIPMFinancialYears!=null && !deleteIPMFinancialYears.isEmpty()) 
        {
          delete deleteIPMFinancialYears;
        }  
    }
    
      /******************************************************************************************************************
    * @description                                  Used for Creating Consolidated Calendar Years whenever TLD is changed. 
    * @param1 targetLaunchChangedDateMap            Changed TLD Financial Map
    * @param2 financialDetailMap                    Queried List of Financial Records from DB    
    * @param3 targetLaunchChangedDateMap            Changed TLD Financial Map
    * @param4 upsertConsolidatedFinancialYearMap    Target Consolidated Financial Year Map.
    * @return               NONE
    *********************************************************************************************************************/ 
    
    public static void manageFinancialYears(Map<Id,IPM_Financial__c> targetLaunchChangedDateMap,Map<Id,IPM_Financial__c> financialDetailMap,Map<String,IPM_Financial_Year__c> upsertConsolidatedFinancialYearMap)
    {
        for(IPM_Financial__c financial : targetLaunchChangedDateMap.values())
        {
            if(financialDetailMap.containsKey(financial.Id) && financial.IPM_Project_Type__c != IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
            {
                IPM_Financial__c detailFinancial = financialDetailMap.get(financial.Id);
                
                String globalExternalId = detailFinancial.Global_External_Id__c;
                String regionalExternalId = detailFinancial.Regional_External_Id__c;
               
                //Rest of the Years
                for(integer i=1; i<=Integer.valueOf(detailFinancial.Project_Sustainability_Period__c); i++)
                {
                    Integer calendarYear = detailFinancial.Target_Launch_Date__c.year() + i - 1;
                    
                    // Add new Consolidated Years if Target Launch Date is Changed for any Default Financial.
                    if(globalExternalId !=null && !String.isBlank(globalExternalId))
                    { 
                        String calcGlobalExternalId = globalExternalId + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;    
                        
                        IPM_Financial_Year__c financialYearGross = processFinancialYear(calcGlobalExternalId, IPM_ConstantUtils.BLANK+calendarYear, IPM_ConstantUtils.BLANK+i, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_GROSS,CONSOLIDATED_FINANCIAL_RECORDTYPE, detailFinancial.Gate_Keeping_Model__c);
                        upsertConsolidatedFinancialYearMap.put(financialYearGross.External_Id__c,financialYearGross);
                        
                        IPM_Financial_Year__c financialYearIncremental = processFinancialYear(calcGlobalExternalId, IPM_ConstantUtils.BLANK+calendarYear, IPM_ConstantUtils.BLANK+i, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_INCREMENTAL,CONSOLIDATED_FINANCIAL_RECORDTYPE, detailFinancial.Gate_Keeping_Model__c);
                        upsertConsolidatedFinancialYearMap.put(financialYearIncremental.External_Id__c,financialYearIncremental);
                    }
                    
                    // Add new Consolidated Years if Target Launch Date is Changed for any Default Financial.
                    if(regionalExternalId !=null && !String.isBlank(regionalExternalId))
                    {
                        String calcRegionalExternalId = regionalExternalId + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;    
                  
                        IPM_Financial_Year__c financialYearGross = processFinancialYear(calcRegionalExternalId, IPM_ConstantUtils.BLANK+calendarYear, IPM_ConstantUtils.BLANK+i, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_GROSS,CONSOLIDATED_FINANCIAL_RECORDTYPE, detailFinancial.Gate_Keeping_Model__c);
                        upsertConsolidatedFinancialYearMap.put(financialYearGross.External_Id__c,financialYearGross);
                    
                        IPM_Financial_Year__c financialYearIncremental = processFinancialYear(calcRegionalExternalId, IPM_ConstantUtils.BLANK+calendarYear, IPM_ConstantUtils.BLANK+i, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_INCREMENTAL,CONSOLIDATED_FINANCIAL_RECORDTYPE, detailFinancial.Gate_Keeping_Model__c);
                        upsertConsolidatedFinancialYearMap.put(financialYearIncremental.External_Id__c,financialYearIncremental);
                    }
                }
            } 
        }
    }
    /***************************************************************************************************************
    * @description                  Method to process individual Financial Record and create Financial Year Records
    *								based on the TLD change.
    * @param1 ipmFinancial               Passed IPM_Financial__c record
    * @param2 upsertFinancialYearMap     Target Financial Year Map to be udpated.
    * @return               NONE
    ***************************************************************************************************************/
    private static void processIPMFinancialYears(IPM_Financial__c ipmFinancial,Map<String,IPM_Financial_Year__c>  upsertFinancialYearMap)
    {
        String externalId = ipmFinancial.Financial_External_ID__c;

        //Y0
        IPM_Financial_Year__c financialYear = null;
        financialYear = processFinancialYear(externalId, IPM_ConstantUtils.Y0_LABEL, IPM_ConstantUtils.Y0_YEARINDEX, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, NULL,ipmFinancial.recordTypeId, ipmFinancial.Gate_Keeping_Model__c);
        for(String fieldAPI : ADDITIONAL_FIELDS)
        {
            financialYear.put(fieldAPI,ipmFinancial.get(fieldAPI));    
        }
        
        upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
        
        financialYear = processFinancialYear(externalId, IPM_ConstantUtils.Y0_LABEL, IPM_ConstantUtils.Y0_YEARINDEX, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, NULL,ipmFinancial.recordTypeId, ipmFinancial.Gate_Keeping_Model__c);
        upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
        
        //Rest of the Years
        for(integer i=1; i<=Integer.valueOf(ipmFinancial.Project_Sustainability_Period__c); i++)
        {
            financialYear = null;
            financialYear = processFinancialYear(externalId, Y_LABEL+i, IPM_ConstantUtils.BLANK +i, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.PL_TYPE_GROSS,ipmFinancial.recordTypeId, ipmFinancial.Gate_Keeping_Model__c);
            upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
            
            financialYear = processFinancialYear(externalId, Y_LABEL+i, IPM_ConstantUtils.BLANK +i, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.PL_TYPE_INCREMENTAL,ipmFinancial.recordTypeId, ipmFinancial.Gate_Keeping_Model__c);
            upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
            
            Integer calendarYear = ipmFinancial.Target_Launch_Date__c.year() + i - 1;
            
            financialYear = processFinancialYear(externalId, IPM_ConstantUtils.BLANK+calendarYear, IPM_ConstantUtils.BLANK+i, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_GROSS,ipmFinancial.recordTypeId, ipmFinancial.Gate_Keeping_Model__c);
            upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
            
            financialYear = processFinancialYear(externalId, IPM_ConstantUtils.BLANK+calendarYear, IPM_ConstantUtils.BLANK+i, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_INCREMENTAL,ipmFinancial.recordTypeId, ipmFinancial.Gate_Keeping_Model__c);
            upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
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
    ********************************************************************************************************/
    private static IPM_Financial_Year__c processFinancialYear(String financialExternalId, String yearName, String index, String yearType, String plType,Id finRecordTypeId, String gateKeepingModel){
        IPM_Financial_Year__c financialYear = new IPM_Financial_Year__c(
            IPM_Financial__r = new IPM_Financial__c(Financial_External_ID__c = financialExternalId),
            External_Id__c = getFinancialYearExternalId(financialExternalId, yearName, yearType, plType),
            Name = yearName,
            Year__c = index,
            Year_Type__c = yearType,
            PL_Type__c = plType,
            IPM_AssociatedFinancialRecordTypeId__c = finRecordTypeId,
            isActive__c = true,
            Gate_Keeping_Model__c  = gateKeepingModel
       );
        return financialYear;
    }
    
    /************************************************************************************************************************* 
    * @description                  Starts the Consolidation Logic starting with comparing the fields which count against 
    								consolidation whether any of those fields changed. Creating a Map which contains 
    								Consolidated Record to associated Financial Record Mapping Invoking the Consolidation logic.
            
    * @param1 consolidationChangedFinancialList      Changed Financials in trigger Context 
    * @param2 oldFinancialMap                        Trigger.old financial Map         
    * @param3 financialDetailMap                     Contains Financial Records retrieved from DB for incoming Financials.               
    * @param4 upsertConsolidatedFinancialMap         Target Upsert Consolidated Map
    * @param5 fieldsToConsolidate                    Fields for which Condolidation Matters
    ***************************************************************************************************************************/
    
    public static void initializeConsolidation(List<IPM_Financial__c> consolidationChangedFinancialList,Map<Id,IPM_Financial__c> oldFinancialMap,Map<Id,IPM_Financial__c> financialDetailMap,Map<String,IPM_Financial__c> upsertConsolidatedFinancialMap,Set<String> fieldsToConsolidate) 
    {
        if(consolidationChangedFinancialList.isEmpty()){
        	return;
        }
        
        Map<String,Map<Id,sObject>> consolidatedToRelatedFinancialMap = new Map<String,Map<Id,sObject>>();
        Map<String,sObject> consolidatedFinancialMap = new Map<String,sObject>();
        
        Set<String> globalProjectIdSet = new Set<String>();
        Set<String> regionalProjectIdSet = new Set<String>();
        
        for(IPM_Financial__c financial : consolidationChangedFinancialList)
        {
            if(financialDetailMap.containsKey(financial.Id))
            {
                IPM_Financial__c newfinancial = financialDetailMap.get(financial.Id);
                
                if(!String.isBlank(newfinancial.Global_External_Id__c))
                {
                    globalProjectIdSet.add(newfinancial.Global_External_Id__c);
                }
                    
                if(!String.isBlank(newfinancial.Regional_External_Id__c)) 
                {
                    regionalProjectIdSet.add(newfinancial.Regional_External_Id__c);
                }
            }  
        }
    
        // Get the complete list of Financial Years from the prepared List of Regional and Global Project.
        String financialQuery = IPM_Utils.prepareSOQLQuery('IPM_Financial__c',true,new Set<String>{'IPM_Financial_Year__c'},false);
        String financialWhereClause = ' WHERE isActive__c = true AND (Global_External_Id__c in :globalProjectIdSet OR Regional_External_Id__c in :regionalProjectIdSet)';
        financialQuery = financialQuery + financialWhereClause;
        Map<Id,IPM_Financial__c> completeFinancialMap = new Map<Id,IPM_Financial__c>( (List<IPM_Financial__c>) database.query(financialQuery));    
                 
        for(IPM_Financial__c financial : completeFinancialMap.values()) 
        {          
            IPM_FinancialUtils.prepareConsolidatedToRelatedFinancials('IPM_Financial__c','Financial_External_ID__c',financial,consolidatedFinancialMap,consolidatedToRelatedFinancialMap,'Global_External_Id__c',financial.recordTypeId);
            IPM_FinancialUtils.prepareConsolidatedToRelatedFinancials('IPM_Financial__c','Financial_External_ID__c',financial,consolidatedFinancialMap,consolidatedToRelatedFinancialMap,'Regional_External_Id__c',financial.recordTypeId);
        }
        
        for(String consolidatedFinancialKey : consolidatedFinancialMap.KeySet())
        {
            sObject consolidatedFinancial = consolidatedFinancialMap.get(consolidatedFinancialKey);
            
            if(consolidatedToRelatedFinancialMap.containsKey(consolidatedFinancialKey))
            { 
                Map<Id,sObject> relatedDefaultFinancials = consolidatedToRelatedFinancialMap.get(consolidatedFinancialKey);    
                IPM_FinancialUtils.processConsolidation('IPM_Financial__c','Financial_External_ID__c',consolidatedFinancialKey,consolidatedFinancial,relatedDefaultFinancials,upsertConsolidatedFinancialMap,fieldsToConsolidate);    
            }
        }
    }
    
    /***********************************************************************************************************
    * @description                      		Method used to calculate financial based on the volume selection
    * @param volumeTypeChangedFinancialMap   	volume selection for Financial record
    * @param oldFinancial               		Old Financial records
    * @param financialDetailMap   				 Queried List of Financial Records from DB 
    * @return                           NONE
    *************************************************************************************************************/
        
    public static void updateFinancialYearVolumeType(Map<Id,IPM_Financial__c> volumeTypeChangedFinancialMap,Map<Id,IPM_Financial__c> oldFinancialMap,Map<Id,IPM_Financial__c> financialDetailMap,Map<String,IPM_Financial_Year__c> upsertFinancialYearMap)
    {
        if(volumeTypeChangedFinancialMap.isEmpty()){
        	return;
        }
        for(IPM_Financial__c financial : volumeTypeChangedFinancialMap.values())
        { 
            if(financialDetailMap.containsKey(financial.Id))
            {
                IPM_Financial__c  financialDetail = financialDetailMap.get(financial.Id);
                IPM_Financial__c  oldFinancial = oldFinancialMap.get(financial.Id);
    
                for(String suffix : FIELD_SUFFIX)
                {
                    // Get the Field API for the Volume Type Field
                    String volumeTypeAPIName = IPM_ConstantUtils.FIELD_LITERAL_VOLUME_UNIT + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX;
                    
                    String newVolumeType = (String)financialDetail.get(volumeTypeAPIName);
                    String oldVolumeType = (String)oldFinancial.get(volumeTypeAPIName);
                    
                    // Check if the Volume Type has Changed from before. IF Yes we need to update Financial Years as well.
                    if(newVolumeType != oldVolumeType)
                    {
                        IPM_FinancialUtils.updateVolumeStatistics(financialDetail,newVolumeType,suffix,upsertFinancialYearMap); 
                    }
                }
            }
        }
    }
   
    /***********************************************************************************************************
    * @description                      Method to process change in sustainability period for the financials
    * @param newFinancial               New Financial record
    * @param oldFinancial               Old Financial records
    * @param lstExistingFinancialYears  List of Existing Financial Year records
    * @return                           NONE
    ************************************************************************************************************/
    public static void processSustainabilityPeriod(Map<Id,IPM_Financial__c> changedSustainabilityMap,Map<Id,IPM_Financial__c> oldFinancialMap,Map<Id,IPM_Financial__c> financialDetailMap,Map<String,IPM_Financial_Year__c> upsertFinancialYearMap)
    {
        if(changedSustainabilityMap.isEmpty()){
        	return;
        }
        for(IPM_Financial__c financial : changedSustainabilityMap.values())
        {
            if(financialDetailMap.containsKey(financial.Id))
            {
                Set<String> setExistingFinancialYears = new Set<String>();
                
                IPM_Financial__c financialDetail = financialDetailMap.get(financial.Id);
                IPM_Financial__c oldFinancial = oldFinancialMap.get(financial.Id);
            
                for(IPM_Financial_Year__c existingFinancialYear : financialDetail.IPM_Financial_Years__r)
                {
                    setExistingFinancialYears.add(existingFinancialYear.External_ID__c);
                }
                
                //Change from 3 TO 5
                Integer newSustainabilityPeriod = Integer.valueOf(financialDetail.Project_Sustainability_Period__c);
                Integer oldSustainabilityPeriod = Integer.valueOf(oldFinancial.Project_Sustainability_Period__c);
                
                if(newSustainabilityPeriod > oldSustainabilityPeriod){
                    Integer difference = newSustainabilityPeriod - oldSustainabilityPeriod;
                    Integer lastCalendarYear = financialDetail.Target_Launch_Date__c.year() + Integer.valueOf(oldFinancial.Project_Sustainability_Period__c) - 1;
                    
                    for(Integer i=1; i<=difference; i++)
                    {
                        IPM_Financial_Year__c financialYear = null;
                        Integer calendarYear = lastCalendarYear + i;
                        Integer index = oldSustainabilityPeriod + i;
                        if(!setExistingFinancialYears.contains(getFinancialYearExternalId(financialDetail.Financial_External_ID__c, Y_LABEL+index, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.PL_TYPE_GROSS)))
                        {
                            financialYear = processFinancialYear(financialDetail.Financial_External_ID__c, Y_LABEL+index, IPM_ConstantUtils.BLANK+index, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.PL_TYPE_GROSS,financialDetail.recordTypeId, financialDetail.Gate_Keeping_Model__c);
                            upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
                            
                            financialYear = processFinancialYear(financialDetail.Financial_External_ID__c, Y_LABEL+index, IPM_ConstantUtils.BLANK+index, IPM_ConstantUtils.YEAR_TYPE_INNOVATION, IPM_ConstantUtils.PL_TYPE_INCREMENTAL,financialDetail.recordTypeId, financialDetail.Gate_Keeping_Model__c);
                            upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
                        }
                        
                         if(!setExistingFinancialYears.contains(getFinancialYearExternalId(financialDetail.Financial_External_ID__c, IPM_ConstantUtils.BLANK+calendarYear, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_GROSS))){
                            
                            financialYear = processFinancialYear(financialDetail.Financial_External_ID__c, IPM_ConstantUtils.BLANK+calendarYear, IPM_ConstantUtils.BLANK+index, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_GROSS,financialDetail.recordTypeId, financialDetail.Gate_Keeping_Model__c);
                            upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
                             
                            financialYear = processFinancialYear(financialDetail.Financial_External_ID__c, IPM_ConstantUtils.BLANK+calendarYear, IPM_ConstantUtils.BLANK+index, IPM_ConstantUtils.YEAR_TYPE_CALENDAR, IPM_ConstantUtils.PL_TYPE_INCREMENTAL,financialDetail.recordTypeId, financialDetail.Gate_Keeping_Model__c);
                            upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
                        }
                    }
                }
            }
        }
    }
    
    /*********************************************************************************************************************
    * @description                      Method to update Financial Action Standards at Charter based on project type it 
    									will add new financial or update consolidate financials
    * @param mapNewFinancials           New Consolidated Financial record
    * @return                           NONE
    * Business Logic: At Charter section 6.1 Business Case V/S Action Standard needs to be populated with IRR,ValueShare,ITO,GTO values from First Full Year of financials.
    				  The Below code updates those values from the Financial object into the Project DocumetnSection Content object when the Gate document IS Charter.
    				  From Contract Document Onwards, only the Results set at contract gets populated.Similary the logic extends till Market Ready Gate	
    **********************************************************************************************************************/
    public static void updateFinancialActionStandard(Map<Id, IPM_Financial__c> mapNewFinancials)
    {
        List<IPM_Financial__c> newFinList=new List<IPM_Financial__c>();
        List<IPM_Project_Document_Section_Content__c> projDocSecConList=new List<IPM_Project_Document_Section_Content__c>();
        Set<Id> projectIds=new Set<Id>();
        
        for(IPM_Financial__c newFin:mapNewFinancials.values())
        {
        	if(newFin.Financial_External_Id__c.contains(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE) && (String.isBlank(newFin.Regional_External_Id__c) || String.isBlank(newFin.Global_External_Id__c))  && !newFin.Charter_Approved__c)
            {            
                newFinList.add(newFin);
                if(String.isBlank(newFin.Global_External_Id__c))
                {
                	projectIds.add(newFin.Regional_Project__c);
                }
                else{
                	projectIds.add(newFin.Parent_Project__c);
                }
            }            
            else if(newFin.IPM_Project_Type__c!=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && newFin.RecordtypeId == DEFAULT_FINANCIAL_RECORDTYPE && newFin.Regional_Project__c==null && newFin.Local_Project__c==null && !newFin.Charter_Approved__c){
                newFinList.add(newFin);
                projectIds.add(newFin.Parent_Project__c);
            }
            else if(newFin.IPM_Project_Type__c!=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && newFin.RecordtypeId == DEFAULT_FINANCIAL_RECORDTYPE && newFin.Parent_Project__c==null && newFin.Local_Project__c==null && !newFin.Charter_Approved__c){
                newFinList.add(newFin);
                projectIds.add(newFin.Regional_Project__c);
            }
            else if(newFin.IPM_Project_Type__c!=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && newFin.RecordtypeId == DEFAULT_FINANCIAL_RECORDTYPE && newFin.Parent_Project__c==null && newFin.Regional_Project__c==null && !newFin.Charter_Approved__c){
                newFinList.add(newFin);
                projectIds.add(newFin.Local_Project__c);
            }
        }
            
        if(projectIds!=null && !projectIds.isEmpty())
        {
            projDocSecConList=[SELECT Id,IPM_IRR_Action_Standard_Charter__c,IPM_NPV_Action_Standard_Charter__c,IPM_Payback_Action_Standard_Charter__c,IPM_Content_Type__c,
                               IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c,
                               IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Phase__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Project_Type__c
                               FROM IPM_Project_Document_Section_Content__c
                               WHERE IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c In:projectIds AND IPM_Content_Type__c=:IPM_ConstantUtils.FINANCIAL_ACTION_STANDARDS AND
                                     IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Phase__c=:IPM_ConstantUtils.PHASE_IDEAS];
        }     
                     
        for(IPM_Financial__c fin:newFinList)
        {
            for(IPM_Project_Document_Section_Content__c secContent:projDocSecConList)
            {
                if(fin.Parent_Project__c!=null && secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c==fin.Parent_Project__c && fin.Regional_Project__c==null)
                {
                    secContent.IPM_Payback_Action_Standard_Charter__c=fin.Payback_Global__c;
                    secContent.IPM_IRR_Action_Standard_Charter__c=fin.IRR_Global__c;
                    secContent.IPM_NPV_Action_Standard_Charter__c=fin.NPV_Global__c;
                }
                else if(fin.Regional_Project__c!=null && secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c==fin.Regional_Project__c&& fin.Parent_Project__c ==null)
                {
                    secContent.IPM_Payback_Action_Standard_Charter__c=fin.Payback_Regional__c;
                    secContent.IPM_IRR_Action_Standard_Charter__c=fin.IRR_Regional__c;
                    secContent.IPM_NPV_Action_Standard_Charter__c=fin.NPV_Regional__c;
                }
                else if(secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Project_Type__c== IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL && fin.Local_Project__c!=null && secContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c==fin.Local_Project__c){
                    secContent.IPM_Payback_Action_Standard_Charter__c=fin.Payback_Local__c;
                    secContent.IPM_IRR_Action_Standard_Charter__c=fin.IRR_Local__c;
                    secContent.IPM_NPV_Action_Standard_Charter__c=fin.NPV_Local__c;
                }
            }
        }
            
        if(projDocSecConList!=null && !projDocSecConList.isEmpty())
        {
            update projDocSecConList;
        }
            
        /*Update BI on IPM Project from IPM Financial record*/
        newFinList=new List<IPM_Financial__c>();
        projectIds=new Set<Id>();
        for(IPM_Financial__c newFin : mapNewFinancials.values())
        {
            if(newFin.RecordtypeId == CONSOLIDATED_FINANCIAL_RECORDTYPE)
            {
                newFinList.add(newFin);
                projectIds.add(newFin.Parent_Project__c);
            }
            if(newFin.RecordtypeId == DEFAULT_FINANCIAL_RECORDTYPE)
            {
                newFinList.add(newFin);
                projectIds.add(newFin.Parent_Project__c);
            }
        }
        
        List<IPM_Project__c> projList=new List<IPM_Project__c>();
        if(projectIds!=null && !projectIds.isEmpty())
        {
            projList = [select id,BI__c from IPM_Project__c where id in : projectIds];
        }
        
        for(IPM_Financial__c fin:newFinList)
        {
            for(IPM_Project__c proj: projList)
            {
                if(proj.id==fin.Parent_Project__c)
                {
                    proj.BI__c = fin.Business_Impact_Global__c;
                }
            }
        }
        
        if(projList!=null && !projList.isEmpty())
        {
        	System.debug(LoggingLevel.ERROR,'Skip Trigger----->>>'+IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION);
            
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
            update projList;
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
            
            System.debug(LoggingLevel.ERROR,'Skip Trigger----->>>'+IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION);
        } 
    }
    
    /*******************************************************************************************************
    * @description                  Posts to Chatter if Financials are Misaligned. 
    * @param1 newFinancialList      incoming Trigger Context Financials    
    * @param2 financialDetailMap    DB specific Financial Values.             
    ********************************************************************************************************/
    
    public static void checkIfMisAligned(List<IPM_Financial__c> newFinancialList,Map<Id,IPM_Financial__c> financialDetailMap)
    {
        List<IPM_Financial__c> financialMisalignQuery = new List<IPM_Financial__c>();
        for(IPM_Financial__c ipmFinancials : newFinancialList) 
        {
            if(ipmFinancials.RecordTypeId == DEFAULT_FINANCIAL_RECORDTYPE && ipmFinancials.Misaligned__c) 
            { 
                financialMisalignQuery.add(ipmFinancials);
            }
        }
        
        Set<Id> updatedProjectsIdSet = new Set<Id>();
        
        for(IPM_Financial__c financial : financialMisalignQuery)
        {
            IF(( financial.Volume_Unit_Difference__c + financial.NPV_Difference__c + financial.IRR_Difference__c + financial.Payback_Difference__c + financial.CAPEX_Difference__c + financial.BIC_Difference__c + financial.Total_FY_Difference__c ) > 0)
            {
                if(financial.Local_Project__c != null &&  financial.Misaligned__c)
                {
                    updatedProjectsIdSet.add(financial.Regional_Project__c);
                    updatedProjectsIdSet.add(financial.Local_Project__c);            
                }
            }
            else
            {
               if(financial.Local_Project__c != null && !financial.Misaligned__c)
               {
                    updatedProjectsIdSet.add(financial.Regional_Project__c);
                    updatedProjectsIdSet.add(financial.Local_Project__c);
                }
            }
        }
       
    }
    
    
    /*******************************************************************************************************
    * @description          Method to handle before insert Trigger context for IPM_Financial__c object
    * @param newFinancials  List of Trigger.new records
    * @return               NONE
    ********************************************************************************************************/
    public static void updateFinanceCategory(List<IPM_Financial__c> newFinancials)
    {
        //@@Design Review - Data Sharing - To update the ownerid of financial to project owner id
        Set<Id> projectIdset=new Set<Id>(); 
        Map<Id,IPM_Project__c>projectMap = new Map<Id,IPM_Project__c>(); 
        
        for(IPM_Financial__c finance:newFinancials)
        {
            if(finance.Parent_Project__c != null)
            {
                projectIdset.add(finance.Parent_Project__c);                       
            }
            else if(finance.Regional_Project__c!= null)
            {
                projectIdset.add(finance.Regional_Project__c);  
                
            }
            else if(finance.Local_Project__c!= null)
            {
                projectIdset.add(finance.Local_Project__c);    
            }
            else if(finance.Global_Project_Id__c!= null)
            {
                projectIdset.add(finance.Global_Project_Id__c);    
            }
        }
        
        if(projectIdset != null && projectIdset.size() >0)
        {
            projectMap = new Map<Id,IPM_Project__c>([Select id, ownerid,IPM_Category_Text__c,IPM_ProjectGKM__c from IPM_Project__c where id IN:projectIdset]); 
        }
        
        if(projectMap != null && projectMap.keyset().size() >0)
        {
            for(IPM_Financial__c finance:newFinancials)
            {                    
                if(finance.Parent_Project__c!=null && projectMap.containskey(finance.Parent_Project__c))
                {
                    finance.ownerid = projectMap.get(finance.Parent_Project__c).ownerid; 
                    finance.IPM_Category__c=projectMap.get(finance.Parent_Project__c).IPM_Category_Text__c;
                    finance.Gate_Keeping_Model__c = projectMap.get(finance.Parent_Project__c).IPM_ProjectGKM__c;
                }
                else if(finance.Regional_Project__c!=null && projectMap.containskey(finance.Regional_Project__c))
                {
                    finance.ownerid = projectMap.get(finance.Regional_Project__c).ownerid; 
                    finance.IPM_Category__c=projectMap.get(finance.Regional_Project__c).IPM_Category_Text__c;
                    finance.Gate_Keeping_Model__c = projectMap.get(finance.Regional_Project__c).IPM_ProjectGKM__c;
                }
                else if(finance.Local_Project__c!=null && projectMap.containskey(finance.Local_Project__c))
                {
                    finance.ownerid = projectMap.get(finance.Local_Project__c).ownerid; 
                    finance.IPM_Category__c=projectMap.get(finance.Local_Project__c).IPM_Category_Text__c;
                    finance.Gate_Keeping_Model__c = projectMap.get(finance.Local_Project__c).IPM_ProjectGKM__c;
                } 
                else if(finance.Global_Project_Id__c!=null && projectMap.containskey(finance.Global_Project_Id__c))
                {
                    finance.ownerid = projectMap.get(finance.Global_Project_Id__c).ownerid; 
                    finance.IPM_Category__c=projectMap.get(finance.Global_Project_Id__c).IPM_Category_Text__c;
                    finance.Gate_Keeping_Model__c = projectMap.get(finance.Global_Project_Id__c).IPM_ProjectGKM__c;
                } 
                  
            }
        } 
    }
    
    /***************************************************************************************************************
        *  @description     This method retrieves local and regional financials and financial year records.
                            Once retrieved the financial year's name & external id fields will be updated with 
                            financial's Target Launch Date.  
                            
           @param1     changedFinancialMap      :    Financial Changed Map 
           @param2     oldFinancialMap          :    Trigger.Old Context Map
           @paramm3    financialDetailMap       :    DB Specific Financial Data
           @paramm4    upsertFinancialYearMap   :    Target Financial Year Map to be upserted.
           @paramm5    financialToChangedFeilds :    List of Financial Fields which changed.
    ***************************************************************************************************************/
    public static void copyOverFinancialFields(Map<Id,IPM_Financial__c> changedFinancialMap,Map<Id,IPM_Financial__c> oldFinancialMap,Map<Id,IPM_Financial__c> financialDetailMap,Map<String,IPM_Financial_Year__c> upsertFinancialYearMap,Map<Id,Set<String>> financialToChangedFeilds)
    {
        if(changedFinancialMap.isEmpty()){
        	return;
        }
        
        for(Id financialID : changedFinancialMap.KeySet()) 
        {
            IPM_Financial__c changedFinancialDetail = financialDetailMap.get(financialID);
            
            if(financialToChangedFeilds.containsKey(financialID))
            {
                for(String fieldAPI : financialToChangedFeilds.get(financialID))
                {
                    for(IPM_Financial_Year__c financialYear : changedFinancialDetail.IPM_Financial_Years__r)
                    {
                        financialYear.put(fieldAPI,changedFinancialDetail.get(fieldAPI));
                        upsertFinancialYearMap.put(financialYear.External_Id__c,financialYear);
                    }
                }
            }
        } 
                   
    }
    
    /***********************************************************************************************************
	    *  @description     This method retrieves local and regional financials and financial year records.
						    Once retrieved the financial year's name & external id fields will be updated with 
						    financial's Target Launch Date.
						      
	       @param1     targetLaunchChangedDateMap :    Target Launch date Changed Map 
	       @param2     financialDetailMap :            Financial Db Map
	       @paramm3    updateFinancialYearMap :        Target Udpate Financial Map
	*************************************************************************************************************/
	
    public static void updateFinancialYearTables(Map<Id,IPM_Financial__c> targetLaunchChangedDateMap,Map<Id,IPM_Financial__c> financialDetailMap,Map<Id,IPM_Financial_Year__c> updateFinancialYearMap) 
    {
        Set<String> fYearExternalIds = new Set<String>();
        Set<String> updatedfYearExternalIds = new Set<String>(); 
                                                                    
        for(IPM_Financial__c ipmFinancial: financialDetailMap.values()) 
        {
        	if(ipmFinancial.recordTypeId != CONSOLIDATED_FINANCIAL_RECORDTYPE)
        	{
	            for(IPM_Financial_Year__c ipmFinancialYear : ipmFinancial.IPM_Financial_Years__r) 
	            {
	            	if(ipmFinancialYear.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && 
	            		( ipmFinancialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL || ipmFinancialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS ) )
	            	{
	                	fYearExternalIds.add(ipmFinancialYear.External_Id__c);
	            	}
	            }
        	}
        }
                                                                        
        for( IPM_Financial__c ipmFinancial: financialDetailMap.values())
        {
        	if(ipmFinancial.recordTypeId != CONSOLIDATED_FINANCIAL_RECORDTYPE)
        	{
        		Date tmpTLD = ipmFinancial.Target_Launch_Date__c;	
        		Integer startYear = tmpTLD.year();
        		String yearName = '';
            	
            	List<IPM_Financial_Year__c> financialYearList = ipmFinancial.IPM_Financial_Years__r;
            	if(!financialYearList.isEmpty()) 
	            {
	                for(IPM_Financial_Year__c ipmFinancialYear : financialYearList) 
	                {
	                    if(ipmFinancialYear.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && 
	                    	( ipmFinancialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL || ipmFinancialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS ) ) 
	                    {
	                        // update year 1 and exteral id fields
	                        if( ipmFinancialYear.Year__c==IPM_ConstantUtils.Y1_YEARINDEX) 
	                        {
	                            yearName = String.valueOf(startYear);
	                        }
	                        
	                        // update year 2 and exteral id fields
	                        if( ipmFinancialYear.Year__c==IPM_ConstantUtils.Y2_YEARINDEX) 
	                        {
	                            yearName = String.valueOf(startYear+1);
	                        }
	                        
	                        // update year 3 and exteral id fields
	                        if( ipmFinancialYear.Year__c==IPM_ConstantUtils.Y3_YEARINDEX) 
	                        {
	                            yearName = String.valueOf(startYear+2);
	                        }
	                        
	                        // update year 4 and exteral id fields
	                        if( ipmFinancialYear.Year__c==IPM_ConstantUtils.Y4_YEARINDEX) 
	                        {
	                            yearName = String.valueOf(startYear+3);
	                        }
	                        
	                        // update year 5 and exteral id fields
	                        if( ipmFinancialYear.Year__c==IPM_ConstantUtils.Y5_YEARINDEX) 
	                        {
	                            yearName = String.valueOf(startYear+4);
	                        }
	                        
	                        addYearToList(ipmFinancialYear, yearName,updatedfYearExternalIds,updateFinancialYearMap);
	                    }
	                }
	            }
        	}
        } 
    }
    
	 /*******************************************************************************************************
    * @description                  	Method to Save year to the financials
    * @param fYear 		  				financial year
    * @param yearName  					financial year name
    * @param updatedfYearExternalIds    financial year external id
    * @param updateFinancialYearMap   	financial year map
    * @return                           NONE
    ********************************************************************************************************/    
    
    private static void addYearToList( IPM_Financial_Year__c fYear, String yearName,Set<String>  updatedfYearExternalIds, Map<ID,IPM_Financial_Year__c> updateFinancialYearMap)
    {
        IPM_Financial_Year__c updateYear = new IPM_Financial_Year__c(ID = fYear.id);
        
        String yearExtId = fYear.External_Id__c.replace(fYear.Name,yearName);
        
        if(!updatedfYearExternalIds.contains(yearExtId)) 
        {
            updatedfYearExternalIds.add(yearExtId);
            updateYear.External_Id__c = yearExtId;
            updateYear.Name=yearName;
            updateFinancialYearMap.put(updateYear.id,updateYear);
        }
    }
    
    /*******************************************************************************************************
    * @description                      Method to process Last Saved data
    * @param newConsolidatedFinancial   New Consolidated Financial record 
    * @param oldConsolidatedFinancial   Old Consolidated Financial record
    * @return                           NONE
    ********************************************************************************************************/
    public static void processLastSaved(IPM_Financial__c newConsolidatedFinancial)
    {
        Set<String> fieldSufixes = new Set<String>{IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, IPM_ConstantUtils.PROJECT_SPAN_REGIONAL, IPM_ConstantUtils.PROJECT_SPAN_LOCAL};
        for(String suffix : fieldSufixes)
        {
            newConsolidatedFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_LAST_SAVED + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, System.now());
            newConsolidatedFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_LAST_SAVED_BY + suffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, UserInfo.getUserId());
       }
    }
    
    /*******************************************************************************************************
    * @description                  Method to process individual Financial Year External Id
    * @param financialExternalId    Parent Financial External Id
    * @param yearName               Year Name
    * @param yearType               Year Type
    * @param plType                 P&L Type
    * @return                       Financial Year External Id
    ********************************************************************************************************/
    private static String getFinancialYearExternalId(String financialExternalId,  String yearName, String yearType, String plType){
        return financialExternalId + '_' + yearName + '_' + yearType + '_' + plType;
    }
   
   /***********************************************************************************************************************
    * @description                  Method to update financial action standard whenever consoildate financial values change
    * @param mapNewFinancials    	Map of Financial Records
    * @return                       None
    ***********************************************************************************************************************/
   public static void updateGlobalFinancialActionStandards(Map<Id, IPM_Financial__c> mapNewFinancials){
	   List<IPM_Financial__c> newFinList=new List<IPM_Financial__c>();
	   Set<Id> projectIdSet=new Set<Id>();
	   List<IPM_Financial_Action_Standards__c> updateFinActionStdsList=new List<IPM_Financial_Action_Standards__c>();
	   for(IPM_Financial__c newFin:mapNewFinancials.values()){
	   	if(newFin.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && newFin.Financial_External_Id__c.contains(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE) && (String.isNotBlank(newFin.Global_External_Id__c) || String.isNotBlank(newFin.Regional_External_Id__c))  && !newFin.Charter_Approved__c)
        {   
        	newFinList.add(newFin);
        	projectIdSet.add(newFin.Parent_Project__c);
        }         
        	   
        }
        for(IPM_Financial_Action_Standards__c finActionStds:[SELECT Id,IPM_Financial_Year_Y1_Gross__c,IPM_Financial_Year_Y1_Gross__r.Regional_External_Id__c,IPM_Project__c,IPM_Project_Span__c,IPM_Financial_Action_Standard_Name__c,IPM_NPV_Action_Standard_Charter__c,IPM_IRR_Action_Standard_Charter__c,IPM_Payback_Action_Standard_Charter__c FROM IPM_Financial_Action_Standards__c WHERE IPM_Project__c In:projectIdSet]){
        	for(IPM_Financial__c fin:newFinList){
        		if(finActionStds.IPM_Project_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && finActionStds.IPM_Project__c==fin.Parent_Project__c && String.isBlank(fin.Regional_External_Id__c)){
        			finActionStds.IPM_NPV_Action_Standard_Charter__c=fin.NPV_Global__c;
        			finActionStds.IPM_IRR_Action_Standard_Charter__c=fin.IRR_Global__c;
        			finActionStds.IPM_Payback_Action_Standard_Charter__c=fin.Payback_Global__c;
        			updateFinActionStdsList.add(finActionStds);
        		}
        		else if(finActionStds.IPM_Project_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && finActionStds.IPM_Project__c==fin.Parent_Project__c && String.isNotBlank(fin.Regional_External_Id__c) && finActionStds.IPM_Financial_Year_Y1_Gross__r.Regional_External_Id__c==fin.Regional_External_Id__c){
        			finActionStds.IPM_NPV_Action_Standard_Charter__c=fin.NPV_Global__c;
        			finActionStds.IPM_IRR_Action_Standard_Charter__c=fin.IRR_Global__c;
        			finActionStds.IPM_Payback_Action_Standard_Charter__c=fin.Payback_Global__c;
        			updateFinActionStdsList.add(finActionStds);
        		}
        	}
        }
        if(updateFinActionStdsList!=null && !updateFinActionStdsList.isEmpty()){
        	update updateFinActionStdsList;
        }             
   	  }
   	  
   	/************************************************************************************************************************
    * @description          Method to  sync project y3iTo with financial's Global,Regional and Local Y3iTo's
    * @param                financial Ids 
    *************************************************************************************************************************/
    public static void updateAssoProjectY3iToValue(Set<Id> financialIds) 
    {
    		List<Id> projIdsforY3iToSync = new  List<Id>();
    		
    		for(IPM_Financial__c  ipmFinRec: [Select Id ,Local_Project__c,Regional_Project__c,Parent_Project__c from  IPM_Financial__c where Id IN: financialIds])
    		{
               if(ipmFinRec.Local_Project__c!=null)
               {
               		projIdsforY3iToSync.add(ipmFinRec.Local_Project__c);
               }
               
               if(ipmFinRec.Regional_Project__c!=null)
               {
               		projIdsforY3iToSync.add(ipmFinRec.Regional_Project__c);
               }
               
               if(ipmFinRec.Parent_Project__c!=null)  
               {
               		projIdsforY3iToSync.add(ipmFinRec.Parent_Project__c);  
               }
    		} 
    		
    		if(!projIdsforY3iToSync.isEmpty())  
    		{   //skip project trigger on stoppage..
    		 	IPM_Utils.updateProjectY3ITOValue(projIdsforY3iToSync);  
    		}
    		
    }
    
    
   public static List<IPM_Financial__c> updateManualMisalignment(List<IPM_Financial__c> newFinancials)
    {
        List<IPM_Financial__c> listFinancial = new List<IPM_Financial__c>();
        if(!newFinancials.isEmpty()){
        listFinancial = [SELECT Id, Volume_Unit_Difference__c, NPV_Difference__c, IRR_Difference__c, Payback_Difference__c, CAPEX_Difference__c, BIC_Difference__c,  Total_FY_Difference__c, MisalignmentManual__c FROM IPM_Financial__c WHERE ID IN : newFinancials];
        
        }
        List<IPM_Financial__c> updatedFinancials = new List<IPM_Financial__c>(); 
        for(IPM_Financial__c financial : listFinancial)
        {
            
            Decimal TotalDiffrence = financial.Volume_Unit_Difference__c + financial.NPV_Difference__c + financial.IRR_Difference__c + financial.Payback_Difference__c + financial.CAPEX_Difference__c + financial.BIC_Difference__c + financial.Total_FY_Difference__c;
            Boolean tempMisalignment   = TotalDiffrence > 0 ? true : false;
            if(financial.MisalignmentManual__c != tempMisalignment) 
            {
                financial.MisalignmentManual__c = tempMisalignment;
                updatedFinancials.add(financial);
            }
            
        }
        
        return updatedFinancials;
    } 
    
}