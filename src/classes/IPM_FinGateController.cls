public with sharing class IPM_FinGateController {

    public IPM_Project__c project {get; set;}
    public Id projectId;
    public ID getprojectId(){ return projectId; }
    public void setprojectId (ID p){
        projectId= p;
        showFinancials();
    }

    public Integer sustainabilityPeriod {get; set;}
    public Integer colSpan {get; set;}
    public Boolean isEditMode {get; set;}
    
    public transient IPM_Financial__c currentFinancial {get; set;}

    public transient ipmFinancialWrapper financialsInnovation {get; set;}
    public transient ipmFinancialWrapper financialsCalendar {get; set;}

    public String volumeUnit {get; set;}
    public String fieldSuffix {get; set;}

    private static String REGIONAL_ROLLOUT_RECORDTYPE;
    private static String LOCAL_ROLLOUT_RECORDTYPE;
    private static String DEFAULT_FINANCIAL_RECORDTYPE;
    private static String CONSOLIDATED_FINANCIAL_RECORDTYPE;
    
    private static String PROJECT_SPAN_GLOBAL = 'Global';
    private static String PROJECT_SPAN_REGIONAL = 'Regional';
    private static String PROJECT_SPAN_LOCAL = 'Local';

    private static String TAB_MYVIEW = 'myview';
    private static String TAB_TOPDOWN = 'topdown';
    private static String TAB_ROLLUP = 'rollup';

    private static String PROJECT_PHASE_IDEA = 'Ideas';
    
    private static String Y0_YEARINDEX = '0';
    private static String YEAR_TYPE_INNOVATION = 'Innovation';
    private static String YEAR_TYPE_CALENDAR = 'Calendar';
    private static String PL_TYPE_GROSS = 'Gross';
    private static String PL_TYPE_INCREMENTAL = 'Incremental';
    
    /* ------------------------------------------------------------------------------------------------------------------
      Name:         ipmFinancialController()
      Type:         CONSTRUCTOR
    --------------------------------------------------------------------------------------------------------------------- */
    public void showFinancials() {
        //IE-9 Fix
      //  Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        
       // String projectId = ApexPages.currentPage().getParameters().get('Id');

        if (projectId != NULL){
            project = [SELECT Id, IPM_Project_Name__c, Sustainability_Period__c, IPMProject_Span__c, Market_Cluster__c, Market_Cluster_Name__c, IPM_Parent_Project__c, IPM_Parent_Project__r.Market_Cluster__c, IPM_Parent_Project__r.Market_Cluster_Name__c, IPM_Parent_Project__r.IPM_Parent_Project__c, IPM_Phase__c 
                        FROM IPM_Project__C 
                        WHERE Id=:projectId];
            getSustainabilityPeriod();
            getFinancials();
            isEditMode = FALSE;
        }
    }
    
    /* ------------------------------------------------------------------------------------------------------------------
      Name:         getSustainabilityPeriod()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to get Sustainability Period from the appropriate project and define the column span for the 
                    financials table on the visualforce page
    --------------------------------------------------------------------------------------------------------------------- */
    private void getSustainabilityPeriod(){
    system.debug(sustainabilityPeriod+'4 getting called');
        sustainabilityPeriod = Integer.valueOf(project.Sustainability_Period__c);
        colSpan = (sustainabilityPeriod * 2) + 1;
    }

  
    private void getRecordtypes(){
        if (REGIONAL_ROLLOUT_RECORDTYPE == null)
            REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Regional Rollout').getRecordTypeId();

        if (LOCAL_ROLLOUT_RECORDTYPE == null)
            LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Local Rollouts').getRecordTypeId();

        if (DEFAULT_FINANCIAL_RECORDTYPE == null)
            DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        
        if (CONSOLIDATED_FINANCIAL_RECORDTYPE == null)
            CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Consolidated').getRecordTypeId();
    }
    
  
    /* ------------------------------------------------------------------------------------------------------------------
      Name:         getFinancials()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to get Financials for currently selected Financial
    --------------------------------------------------------------------------------------------------------------------- */
    private void getFinancials(){
        fieldSuffix = getFieldSuffix();
        String ExternalId=project.IPM_Project_Name__c+'_CONSOLIDATED';
        String queryString = 'SELECT ';
        //IPM Financial
        For (String field : Schema.SObjectType.IPM_Financial__c.fields.getMap().KeySet())
            queryString+= field + ', ';
        //IPM Financial Year
        queryString+= '(SELECT ';
        For (String field : Schema.SObjectType.IPM_Financial_Year__c.fields.getMap().KeySet()){
            if (field != 'Id')
                queryString+= field + ', ';
        }
        queryString+= 'Id FROM IPM_Financial_Years__r ORDER BY Year__c)';
        queryString+= 'FROM IPM_Financial__c WHERE Financial_External_ID__c =: ExternalId';// need to repace by external is
        
        currentFinancial = Database.query(queryString);
      //  mapFinancialYears = new Map<String, IPM_Financial_Year__c>();
        if (currentFinancial != NULL){
            financialsInnovation = new ipmFinancialWrapper();
            financialsCalendar = new ipmFinancialWrapper();
            
            volumeUnit = (String) currentFinancial.get('Volume_Unit_' + fieldSuffix + '__c');

            For (IPM_Financial_Year__c finYear : currentFinancial.IPM_Financial_Years__r){
                //Add to Map
               // mapFinancialYears.put(generateMapKey(finYear.Year_Type__c, finYear.Year__c, finYear.PL_Type__c), finYear);
                
                //Innovation Years
                if (finYear.Year_Type__c == YEAR_TYPE_INNOVATION){
                    generateFinancials(finYear, financialsInnovation);
                }
                //Calendar Years
                else if (finYear.Year_Type__c == YEAR_TYPE_CALENDAR){
                    generateFinancials(finYear, financialsCalendar);
                }
            }
        }
        //currentFinancial = null;
    }
    
    private void generateFinancials(IPM_Financial_Year__c finYear, ipmFinancialWrapper finWrapper){
        //Year 0 Values
        if (finYear.Year__c == Y0_YEARINDEX){
            finWrapper.y0ValueMarketShare = (Decimal) finYear.get('Value_Market_Share_' + fieldSuffix + '__c');
            finWrapper.y0Volume = (Decimal) finYear.get('Volume_' + fieldSuffix + '__c');
            finWrapper.y0VolumeTons = (Decimal) finYear.get('Volume_Tons_' + fieldSuffix + '__c');
            finWrapper.y0Turnover = (Decimal) finYear.get('Turnover_' + fieldSuffix + '__c');
            finWrapper.y0GrossProfit = (Decimal) finYear.get('Gross_Profit_' + fieldSuffix + '__c');
            finWrapper.y0Advertising = (Decimal) finYear.get('Advertising_Promotions_' + fieldSuffix + '__c');
            finWrapper.y0Profit = (Decimal) finYear.get('Profit_Before_Overheads_' + fieldSuffix + '__c');
            finWrapper.y0GM = (Decimal) finYear.get('GM_of_TO_' + fieldSuffix + '__c');
            finWrapper.y0AP = (Decimal) finYear.get('AP_of_TO_' + fieldSuffix + '__c');
            finWrapper.y0PBO = (Decimal) finYear.get('PBO_of_TO_' + fieldSuffix + '__c');

            finWrapper.y0ValueMarketShareDifference = finYear.Value_Market_Share_Difference__c;
            finWrapper.y0VolumeDifference = finYear.Volume_Difference__c;
            finWrapper.y0VolumeTonsDifference = finYear.Volume_Tons_Difference__c;
            finWrapper.y0TurnoverDifference = finYear.Turnover_Difference__c;
            finWrapper.y0GrossProfitDifference = finYear.Gross_Profit_Difference__c;
            finWrapper.y0AdvertisingDifference = finYear.Advertising_Promotions_Difference__c;
            finWrapper.y0ProfitDifference = finYear.Profit_Before_Overheads_Difference__c;
            finWrapper.y0GMDifference = finYear.GM_of_TO_Difference__c;
            finWrapper.y0APDifference = finYear.AP_of_TO_Difference__c;
            finWrapper.y0PBODifference = finYear.PBO_of_TO_Difference__c;
        } 
        //Rest of the Year Values
        else if(Integer.valueOf(finYear.Year__c) <= sustainabilityPeriod) {
            //Gross P&L Values
            if (finYear.PL_Type__c == PL_TYPE_GROSS){
                finWrapper.lstYearNames.add(finYear.Name);
                
                finWrapper.lstGrossPLValueMarketShare.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Value_Market_Share_' + fieldSuffix + '__c'), finYear.Value_Market_Share_Difference__c, 1));
                finWrapper.lstGrossPLVolume.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Volume_' + fieldSuffix + '__c'), finYear.Volume_Difference__c));
                finWrapper.lstGrossPLVolumeTons.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Volume_Tons_' + fieldSuffix + '__c'), finYear.Volume_Tons_Difference__c));
                finWrapper.lstGrossPLTurnover.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Turnover_' + fieldSuffix + '__c'), finYear.Turnover_Difference__c));
                finWrapper.lstGrossPLGrossProfit.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Gross_Profit_' + fieldSuffix + '__c'), finYear.Gross_Profit_Difference__c));
                finWrapper.lstGrossPLAdvertising.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Advertising_Promotions_' + fieldSuffix + '__c'), finYear.Advertising_Promotions_Difference__c));
                finWrapper.lstGrossPLProfit.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Profit_Before_Overheads_' + fieldSuffix + '__c'), finYear.Profit_Before_Overheads_Difference__c));
                finWrapper.lstGrossPLGM.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('GM_of_TO_' + fieldSuffix + '__c'), finYear.GM_of_TO_Difference__c, 1));
                finWrapper.lstGrossPLAP.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('AP_of_TO_' + fieldSuffix + '__c'), finYear.AP_of_TO_Difference__c, 1));
                finWrapper.lstGrossPLPBO.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('PBO_of_TO_' + fieldSuffix + '__c'), finYear.PBO_of_TO_Difference__c, 1));
            }
            //Incremental P&L Values
            else if (finYear.PL_Type__c == PL_TYPE_INCREMENTAL) {
                finWrapper.lstIncrementalPLValueMarketShare.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Value_Market_Share_' + fieldSuffix + '__c'), finYear.Value_Market_Share_Difference__c, 1));
                finWrapper.lstIncrementalPLVolume.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Volume_' + fieldSuffix + '__c'), finYear.Volume_Difference__c));
                finWrapper.lstIncrementalPLVolumeTons.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Volume_Tons_' + fieldSuffix + '__c'), finYear.Volume_Tons_Difference__c));
                finWrapper.lstIncrementalPLTurnover.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Turnover_' + fieldSuffix + '__c'), finYear.Turnover_Difference__c));
                finWrapper.lstIncrementalPLGrossProfit.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Gross_Profit_' + fieldSuffix + '__c'), finYear.Gross_Profit_Difference__c));
                finWrapper.lstIncrementalPLAdvertising.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Advertising_Promotions_' + fieldSuffix + '__c'), finYear.Advertising_Promotions_Difference__c));
                finWrapper.lstIncrementalPLProfit.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('Profit_Before_Overheads_' + fieldSuffix + '__c'), finYear.Profit_Before_Overheads_Difference__c));
                finWrapper.lstIncrementalPLGM.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('GM_of_TO_' + fieldSuffix + '__c'), finYear.GM_of_TO_Difference__c, 1));
                finWrapper.lstIncrementalPLAP.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('AP_of_TO_' + fieldSuffix + '__c'), finYear.AP_of_TO_Difference__c, 1));
                finWrapper.lstIncrementalPLPBO.add(new ipmFinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get('PBO_of_TO_' + fieldSuffix + '__c'), finYear.PBO_of_TO_Difference__c, 1));
            }
        }
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         getFieldSuffix()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to generate the suffix to be used in referencing appropriate fields on the Financial 
                    and Financial Year object
    --------------------------------------------------------------------------------------------------------------------- */
    private String getFieldSuffix(){
        if (project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL){
        return PROJECT_SPAN_GLOBAL;
        }
        else if (project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL){
        return PROJECT_SPAN_REGIONAL;
        }
        else{
        return PROJECT_SPAN_LOCAL;
        }
    }
    
    /* ------------------------------------------------------------------------------------------------------------------
      Name:         generateMapKey()
      Type:         METHOD
      Parameters:   String yearType
                    String index
                    String plType
      Description:  Used to generate a unique key for the map of Financial Years for the current Financial
    --------------------------------------------------------------------------------------------------------------------- */
    private String generateMapKey(String yearType, String index, String plType){
        return yearType + '__' + index + '__' + plType;
    }
    

}