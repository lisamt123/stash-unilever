public with sharing class IPMExcelTemplate3Controller{
    public IPM_Project__c project {get; set;}

    public List<IPM_Financial__c> lstFinancials {get; set;}
    public IPM_Financial__c firstFinancial {get; set;}

    public Integer sharedStringCount {get; set;}
    public Integer sharedStringUniqueCount {get; set;}

    public List<String> lstCalcChainValues {get; set;}
    
    public FinancialWrapper firstFinancialWrapper {get; set;}
    public List<FinancialWrapper> lstFinancialWrapper {get; set;}
    public String dataValidationString {get; set;}

    public String firstVolumeUnit {get; set;}
    public String secondVolumeUnit {get; set;}

    private String fieldSuffix;
    private Map<String, String> mapVolumeUnitPosition;
    
    private static String PROJECT_SPAN_GLOBAL = 'Global';
    private static String PROJECT_SPAN_REGIONAL = 'Regional';
    private static String PROJECT_SPAN_LOCAL = 'Local';
    
    private static String Y0_YEARINDEX = '0';
    private static String Y1_YEARINDEX = '1';
    private static String Y2_YEARINDEX = '2';
    private static String Y3_YEARINDEX = '3';
    private static String YEAR_TYPE_INNOVATION = 'Innovation';
    private static String YEAR_TYPE_CALENDAR = 'Calendar';
    private static String PL_TYPE_GROSS = 'Gross';
    private static String PL_TYPE_INCREMENTAL = 'Incremental';

    private static String VOLUME_UNIT_TONS = 'Total Tons';
    private static String VOLUME_UNIT_000_UNITS = 'Total \'000 Units';

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         ipmExcelTemplate5Controller()
      Type:         CONSTRUCTOR
    --------------------------------------------------------------------------------------------------------------------- */
    public IPMExcelTemplate3Controller() {
        String projectId = ApexPages.currentPage().getParameters().get('Id');
        if (projectId != NULL){
            project = [SELECT Id, IPM_Project_Name__c, Sustainability_Period__c, IPMProject_Span__c, Market_Cluster__c, IPM_Parent_Project__c, IPM_Parent_Project__r.Market_Cluster__c, IPM_Phase__c 
                        FROM IPM_Project__C 
                        WHERE Id=:projectId];
            getFinancials();
            getFieldSuffix();
            getVolumeUnitMap();
            getSharedStringData();
            getCalcChainData();
            getDataValidationString();
            getSheetData();
        }
    }

    private void getFinancials(){
        String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        String projectId = project.Id;
        if(projectId.length() > 15)
            projectId = projectId.substring(0,15);
            
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
        queryString+= 'FROM IPM_Financial__c WHERE RecordtypeId =: DEFAULT_FINANCIAL_RECORDTYPE ';
        
        if(project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL)
            queryString+= 'AND Global_Project_Id__c =: projectId';
        else if(project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL)
            queryString+= 'AND Regional_Project__c =: projectId';
        else if(project.IPMProject_Span__c == PROJECT_SPAN_LOCAL)
            queryString+= 'AND Local_Project__c =: projectId';

        queryString+= ' ORDER BY Sorting_Order__c, Financial_External_Id__c';
        
        lstFinancials = Database.query(queryString);
        
        firstFinancial = lstFinancials[0];
        lstFinancials.remove(0);
        
    }

 /* ------------------------------------------------------------------------------------------------------------------
      Name:         getFieldSuffix()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to generate the suffix to be used in referencing appropriate fields on the Financial 
                    and Financial Year object
    --------------------------------------------------------------------------------------------------------------------- */
    private void getFieldSuffix(){
        if (project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL)
            fieldSuffix = PROJECT_SPAN_GLOBAL;
        else if (project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL)
            fieldSuffix = PROJECT_SPAN_REGIONAL;
        else if (project.IPMProject_Span__c == PROJECT_SPAN_LOCAL)
            fieldSuffix = PROJECT_SPAN_LOCAL;
    }
    
    private void getVolumeUnitMap(){
        mapVolumeUnitPosition = new Map<String, String>();
        Set<String> setVolumeUnits = new Set<String>();

        firstVolumeUnit = (String) firstFinancial.get('Volume_Unit_' + fieldSuffix + '__c');
        setVolumeUnits.add(firstVolumeUnit);

        For(IPM_Financial__c financial : lstFinancials){
            String volumeUnit = (String) financial.get('Volume_Unit_' + fieldSuffix + '__c');
            setVolumeUnits.add(volumeUnit);
        }
        
        if(setVolumeUnits.size()>1){
            if(firstVolumeUnit == VOLUME_UNIT_TONS)
                secondVolumeUnit = VOLUME_UNIT_000_UNITS;
            else
                secondVolumeUnit = VOLUME_UNIT_TONS;
        }

        mapVolumeUnitPosition.put(firstVolumeUnit, '24');
    }
    
    private void getSharedStringData(){
        sharedStringCount = 62 + 55*(lstFinancials.size() - 1);
        sharedStringUniqueCount = 33 + lstFinancials.size() - 1;
        if(secondVolumeUnit != NULL){
            sharedStringUniqueCount++;
            mapVolumeUnitPosition.put(secondVolumeUnit, '' + sharedStringUniqueCount);
        }
    }

    private void getCalcChainData(){
        lstCalcChainValues = new List<String>();
        For (Integer i=0; i<lstFinancials.size(); i++){
            Integer rValue = 28 + ((i+1)*26);
            lstCalcChainValues.add('B' + rValue);
        }
    }
    
    private void getDataValidationString(){
        dataValidationString = 'B14';
        For (Integer i=0; i<lstFinancials.size(); i++){
            Integer dataValidationIndex = 14 + ((i+1)*26);
            dataValidationString = dataValidationString + ' B' + dataValidationIndex;
        }
    }
    
    private void getSheetData(){

        firstFinancialWrapper = processFinancialData(firstFinancial, null);

        lstFinancialWrapper = new List<FinancialWrapper>();
        For (Integer i=0; i<lstFinancials.size(); i++)
            lstFinancialWrapper.add(processFinancialData(lstFinancials[i], i));
        
    }
    
    private FinancialWrapper processFinancialData(IPM_Financial__c financial, Integer index){
        FinancialWrapper finWrapper = new FinancialWrapper();
        
        if (index != null){
            finWrapper.startRowIndex = 9 + (26*(index+1));
            finWrapper.sharedStringIndex = 33 + index;
            Integer formulaCellIndex = 14 + (26*(index+1));
            finWrapper.formulaCellReference = 'B' + formulaCellIndex;
        }
        
        String volumeUnit = (String) financial.get('Volume_Unit_' + fieldSuffix + '__c');
        
        finWrapper.volumeUnit = volumeUnit;
        finWrapper.volumeUnitPosition = mapVolumeUnitPosition.get(volumeUnit);
        finWrapper.npvValue = (Decimal) financial.get('NPV_' + fieldSuffix + '__c');
        finWrapper.irrValue = (Decimal) financial.get('IRR_' + fieldSuffix + '__c');
        finWrapper.paybackValue = (Decimal) financial.get('Payback_' + fieldSuffix + '__c');
        finWrapper.capexValue = (Decimal) financial.get('CAPEX_' + fieldSuffix + '__c');
        finWrapper.bicValue = (Decimal) financial.get('BIC_' + fieldSuffix + '__c');
        
        For(IPM_Financial_Year__c finYear : financial.IPM_Financial_Years__r){
            if (finYear.Year_Type__c == YEAR_TYPE_INNOVATION)
                processFinancialYearData(finYear, finWrapper.innovationYear);
            else if (finYear.Year_Type__c == YEAR_TYPE_CALENDAR)
                processFinancialYearData(finYear, finWrapper.calendarYear);
        }
        
        return finWrapper;
    }

    private void processFinancialYearData(IPM_Financial_Year__c finYear, YearTypeWrapper yearTypeWrapper){
        if (finYear.Year__c == Y0_YEARINDEX){
            yearTypeWrapper.valueMarketShare.valueY0 = (Decimal) finYear.get('Value_Market_Share_' + fieldSuffix + '__c');
            yearTypeWrapper.volume.valueY0 = (Decimal) finYear.get('Volume_' + fieldSuffix + '__c');
            yearTypeWrapper.turnover.valueY0 = (Decimal) finYear.get('Turnover_' + fieldSuffix + '__c');
            yearTypeWrapper.grossProfit.valueY0 = (Decimal) finYear.get('Gross_Profit_' + fieldSuffix + '__c');
            yearTypeWrapper.advertising.valueY0 = (Decimal) finYear.get('Advertising_Promotions_' + fieldSuffix + '__c');
            yearTypeWrapper.profit.valueY0 = (Decimal) finYear.get('Profit_Before_Overheads_' + fieldSuffix + '__c');
        }
        //Rest of the Year Values
        else {
            //Gross P&L Values
            if (finYear.PL_Type__c == PL_TYPE_GROSS){
                if (finYear.Year__c == Y1_YEARINDEX){
                    if (finYear.Year_Type__c == YEAR_TYPE_CALENDAR)
                        yearTypeWrapper.yearNames.valueGrossY1 = Decimal.valueOf(finYear.Name);
                    yearTypeWrapper.valueMarketShare.valueGrossY1 = (Decimal) finYear.get('Value_Market_Share_' + fieldSuffix + '__c');
                    yearTypeWrapper.volume.valueGrossY1 = (Decimal) finYear.get('Volume_' + fieldSuffix + '__c');
                    yearTypeWrapper.turnover.valueGrossY1 = (Decimal) finYear.get('Turnover_' + fieldSuffix + '__c');
                    yearTypeWrapper.grossProfit.valueGrossY1 = (Decimal) finYear.get('Gross_Profit_' + fieldSuffix + '__c');
                    yearTypeWrapper.advertising.valueGrossY1 = (Decimal) finYear.get('Advertising_Promotions_' + fieldSuffix + '__c');
                    yearTypeWrapper.profit.valueGrossY1 = (Decimal) finYear.get('Profit_Before_Overheads_' + fieldSuffix + '__c');

                }else if (finYear.Year__c == Y2_YEARINDEX){
                    if (finYear.Year_Type__c == YEAR_TYPE_CALENDAR)
                        yearTypeWrapper.yearNames.valueGrossY2 = Decimal.valueOf(finYear.Name);
                    yearTypeWrapper.valueMarketShare.valueGrossY2 = (Decimal) finYear.get('Value_Market_Share_' + fieldSuffix + '__c');
                    yearTypeWrapper.volume.valueGrossY2 = (Decimal) finYear.get('Volume_' + fieldSuffix + '__c');
                    yearTypeWrapper.turnover.valueGrossY2 = (Decimal) finYear.get('Turnover_' + fieldSuffix + '__c');
                    yearTypeWrapper.grossProfit.valueGrossY2 = (Decimal) finYear.get('Gross_Profit_' + fieldSuffix + '__c');
                    yearTypeWrapper.advertising.valueGrossY2 = (Decimal) finYear.get('Advertising_Promotions_' + fieldSuffix + '__c');
                    yearTypeWrapper.profit.valueGrossY2 = (Decimal) finYear.get('Profit_Before_Overheads_' + fieldSuffix + '__c');

                }else if (finYear.Year__c == Y3_YEARINDEX){
                    if (finYear.Year_Type__c == YEAR_TYPE_CALENDAR)
                        yearTypeWrapper.yearNames.valueGrossY3 = Decimal.valueOf(finYear.Name);
                    yearTypeWrapper.valueMarketShare.valueGrossY3 = (Decimal) finYear.get('Value_Market_Share_' + fieldSuffix + '__c');
                    yearTypeWrapper.volume.valueGrossY3 = (Decimal) finYear.get('Volume_' + fieldSuffix + '__c');
                    yearTypeWrapper.turnover.valueGrossY3 = (Decimal) finYear.get('Turnover_' + fieldSuffix + '__c');
                    yearTypeWrapper.grossProfit.valueGrossY3 = (Decimal) finYear.get('Gross_Profit_' + fieldSuffix + '__c');
                    yearTypeWrapper.advertising.valueGrossY3 = (Decimal) finYear.get('Advertising_Promotions_' + fieldSuffix + '__c');
                    yearTypeWrapper.profit.valueGrossY3 = (Decimal) finYear.get('Profit_Before_Overheads_' + fieldSuffix + '__c');

                }
            }
            //Incremental P&L Values
            else if (finYear.PL_Type__c == PL_TYPE_INCREMENTAL) {
                if (finYear.Year__c == Y1_YEARINDEX){
                    if (finYear.Year_Type__c == YEAR_TYPE_CALENDAR)
                        yearTypeWrapper.yearNames.valueIncrementalY1 = Decimal.valueOf(finYear.Name);
                    yearTypeWrapper.valueMarketShare.valueIncrementalY1 = (Decimal) finYear.get('Value_Market_Share_' + fieldSuffix + '__c');
                    yearTypeWrapper.volume.valueIncrementalY1 = (Decimal) finYear.get('Volume_' + fieldSuffix + '__c');
                    yearTypeWrapper.turnover.valueIncrementalY1 = (Decimal) finYear.get('Turnover_' + fieldSuffix + '__c');
                    yearTypeWrapper.grossProfit.valueIncrementalY1 = (Decimal) finYear.get('Gross_Profit_' + fieldSuffix + '__c');
                    yearTypeWrapper.advertising.valueIncrementalY1 = (Decimal) finYear.get('Advertising_Promotions_' + fieldSuffix + '__c');
                    yearTypeWrapper.profit.valueIncrementalY1 = (Decimal) finYear.get('Profit_Before_Overheads_' + fieldSuffix + '__c');

                }else if (finYear.Year__c == Y2_YEARINDEX){
                    if (finYear.Year_Type__c == YEAR_TYPE_CALENDAR)
                        yearTypeWrapper.yearNames.valueIncrementalY2 = Decimal.valueOf(finYear.Name);
                    yearTypeWrapper.valueMarketShare.valueIncrementalY2 = (Decimal) finYear.get('Value_Market_Share_' + fieldSuffix + '__c');
                    yearTypeWrapper.volume.valueIncrementalY2 = (Decimal) finYear.get('Volume_' + fieldSuffix + '__c');
                    yearTypeWrapper.turnover.valueIncrementalY2 = (Decimal) finYear.get('Turnover_' + fieldSuffix + '__c');
                    yearTypeWrapper.grossProfit.valueIncrementalY2 = (Decimal) finYear.get('Gross_Profit_' + fieldSuffix + '__c');
                    yearTypeWrapper.advertising.valueIncrementalY2 = (Decimal) finYear.get('Advertising_Promotions_' + fieldSuffix + '__c');
                    yearTypeWrapper.profit.valueIncrementalY2 = (Decimal) finYear.get('Profit_Before_Overheads_' + fieldSuffix + '__c');

                }else if (finYear.Year__c == Y3_YEARINDEX){
                    if (finYear.Year_Type__c == YEAR_TYPE_CALENDAR)
                        yearTypeWrapper.yearNames.valueIncrementalY3 = Decimal.valueOf(finYear.Name);
                    yearTypeWrapper.valueMarketShare.valueIncrementalY3 = (Decimal) finYear.get('Value_Market_Share_' + fieldSuffix + '__c');
                    yearTypeWrapper.volume.valueIncrementalY3 = (Decimal) finYear.get('Volume_' + fieldSuffix + '__c');
                    yearTypeWrapper.turnover.valueIncrementalY3 = (Decimal) finYear.get('Turnover_' + fieldSuffix + '__c');
                    yearTypeWrapper.grossProfit.valueIncrementalY3 = (Decimal) finYear.get('Gross_Profit_' + fieldSuffix + '__c');
                    yearTypeWrapper.advertising.valueIncrementalY3 = (Decimal) finYear.get('Advertising_Promotions_' + fieldSuffix + '__c');
                    yearTypeWrapper.profit.valueIncrementalY3 = (Decimal) finYear.get('Profit_Before_Overheads_' + fieldSuffix + '__c');

                }
            }
        }
    }
    
    public class FinancialWrapper {
        public Integer startRowIndex {get; set;}
        public Integer sharedStringIndex {get; set;}
        public String formulaCellReference {get; set;}
        
        public String volumeUnit {get; set;}
        public String volumeUnitPosition {get; set;}
        public Decimal npvValue {get; set;}
        public Decimal irrValue {get; set;}
        public Decimal paybackValue {get; set;}
        public Decimal capexValue {get; set;}
        public Decimal bicValue {get; set;}

        public YearTypeWrapper innovationYear {get; set;}
        public YearTypeWrapper calendarYear {get; set;}
        
        public FinancialWrapper(){
            this.innovationYear = new YearTypeWrapper();
            this.calendarYear = new YearTypeWrapper();
        }
    }
    
    public class YearTypeWrapper {
        public RowWrapper yearNames {get; set;}
        public RowWrapper valueMarketShare {get; set;}
        public RowWrapper volume {get; set;}
        public RowWrapper turnover {get; set;}
        public RowWrapper grossProfit {get; set;}
        public RowWrapper advertising {get; set;}
        public RowWrapper profit {get; set;}

        public YearTypeWrapper(){
            this.yearNames = new RowWrapper();
            this.valueMarketShare = new RowWrapper();
            this.volume = new RowWrapper();
            this.turnover = new RowWrapper();
            this.grossProfit = new RowWrapper();
            this.advertising = new RowWrapper();
            this.profit = new RowWrapper();
        }
    }
    
    public class RowWrapper{
        public Decimal valueY0 {get; set;}
        public Decimal valueGrossY1 {get; set;}
        public Decimal valueGrossY2 {get; set;}
        public Decimal valueGrossY3 {get; set;}
        public Decimal valueIncrementalY1 {get; set;}
        public Decimal valueIncrementalY2 {get; set;}
        public Decimal valueIncrementalY3 {get; set;}
    }    
}