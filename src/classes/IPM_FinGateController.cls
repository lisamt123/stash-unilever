/**
* @author       Cognizant (Vipul)
* @date         27/04/2015
* @description  This class is used for displaying Financial section 
*               in the gate document
*/
public with sharing class IPM_FinGateController {
 
    public IPM_Project__c project {get; set;} //The project record for which the financial business cases are being viewed
    public Id projectId; //Project Id of te current project
    public ID getprojectId(){ return projectId; }
    public void setprojectId (ID p){
        projectId= p;
        showFinancials();
    }

    public Integer sustainabilityPeriod {get; set;} //Sustainability Period relevant for this set of business cases. 
    public Integer colSpan {get; set;} //Derived from Sustainability Perido. Used to define the number of columns visible on the Financial Table
    public Integer colSpanCalendar {get; set;} //Derived from number of financial years for Calendar Financial Table
    public Integer totalCalendarFinYears {get; set;} //Derived from number of financial years for Calendar Financial Table
    
    public string printDoc {get; set;} //Current Document being viewed
    public boolean renderGate{get;set;}
    public IPM_Financial__c currentFinancial {get; set;} //Used to store the financial business case (IPM_Financial & associated IPM_Financial_Year__c records)

    public transient IPM_FinancialWrapper financialsInnovation {get; set;} //Wrapper to store the financial values for the Innovation Years for the currentFinancial
    public transient IPM_FinancialWrapper financialsCalendar {get; set;} //Wrapper to store the financial values for the Calendar Years for the currentFinancial
    
    public transient List<String> lstClusterNames {get; set;} //List of Cluster Names for which the project is being rolled out to

    public transient ipmFinancialSummaryWrapper gTOWrapper {get; set;} //gTO Financial Summay Wrapper
    public transient ipmFinancialSummaryWrapper GMWrapper {get; set;} //GM Financial Summay Wrapper
    public transient ipmFinancialSummaryWrapper PBOWrapper {get; set;} //PBO Financial Summay Wrapper
    public transient ipmFinancialSummaryWrapper GMbpsWrapper {get; set;} //GM bps Financial Summay Wrapper
    public transient ipmFinancialSummaryWrapper PBObpsWrapper {get; set;} //PBO bps Financial Summay Wrapper
    public transient ipmFinancialSummaryWrapper iTOWrapper {get; set;} //iTO Financial Summay Wrapper
    public transient ipmFinancialSummaryWrapper iAPWrapper {get; set;} //iAP Financial Summay Wrapper
	public String ExternalId{get;set;}//to construct the financial external id // NO SONAR. variable used in Dyanamic SOQL
    public String volumeUnit {get; set;} //Volume Unit
    public String fieldSuffix {get; set;} //Used to dynamically change the field suffix based on the current view. (Accepted values are - Global,Regional.Local,Charter,Contract,MR,MD)

    /*******************************************************************************************************
    * @description  Constructor
    * @param        NONE
    * @return       NONE
    */
    public void showFinancials() {
        if (projectId == null) {
            projectId = ApexPages.currentPage().getParameters().get('id');
        }
        
        if (projectId != NULL){
            project = [SELECT Id, IPM_Project_Name__c, Sustainability_Period__c, IPMProject_Span__c, Market_Cluster__c, Market_Cluster_Name__c, IPM_Parent_Project__c, 
                              IPM_Project_Type__c, IPM_Phase__c 
                        FROM IPM_Project__C 
                        WHERE Id=:projectId];
            
            getFieldSuffix();
            getFinancials();
            getFinancialsForSummary();
            getSustainabilityPeriod();
        }
    }
    
    /*******************************************************************************************************
    * @description  Used to get Sustainability Period from the appropriate project and define the column 
    *               span for the financials table on the visualforce page
    * @param        NONE
    * @return       NONE
    */
    private void getSustainabilityPeriod(){
        sustainabilityPeriod = Integer.valueOf(project.Sustainability_Period__c);
        colSpan = (sustainabilityPeriod * 2) + 1;
        colSpanCalendar = (totalCalendarFinYears-1)/2;
    }

    /*******************************************************************************************************
    * @description  Used to generate the suffix to be used in referencing appropriate fields on the 
    *               Financial and Financial Year object
    * @param        NONE
    * @return       NONE
    */
    private void getFieldSuffix(){
        if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL) {
            fieldSuffix = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL; 
        }
        else if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL) {
            fieldSuffix = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
        }
        else {
            fieldSuffix = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
        }
       
    }

    /*******************************************************************************************************
    * @description  Used to generate the suffix to be used in referencing appropriate fields on the 
    *               Financial and Financial Year object for the appropriate gate being viewed
    * @param        NONE
    * @return       updated fieldSuffix
    */
    private String getGateFieldSuffix(String localFieldSuffix, IPM_Financial__c currentFinancial){
        String localFieldSufx = localFieldSuffix;
        printDoc=ApexPages.currentPage().getParameters().get('printDoc');
        if(printDoc  == IPM_ConstantUtils.CHARTER_GATE){
             renderGate = true;
        }
        //Charter gate document is accessed in any other phase
        if (printDoc == IPM_ConstantUtils.CHARTER_GATE && currentFinancial.Charter_Approved__c){
            localFieldSufx = IPM_ConstantUtils.FIELD_SUFFIX_CHARTER;
        } 
        //Contract gate document is accessed in any other phase
        else if (printDoc == IPM_ConstantUtils.CONTRACT_GATE && currentFinancial.Contract_Approved__c){
            localFieldSufx = IPM_ConstantUtils.FIELD_SUFFIX_CONTRACT;
        }
        //Market Ready gate document is accessed in any other phase
        else if (printDoc == IPM_ConstantUtils.MARKET_READY_GATE && currentFinancial.MR_Approved__c){
            localFieldSufx = IPM_ConstantUtils.FIELD_SUFFIX_MARKET_READY;
        }
        //Market Ready gate document is accessed in any other phase
        else if (printDoc == IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE && currentFinancial.MD_Approved__c){
            localFieldSufx = IPM_ConstantUtils.FIELD_SUFFIX_MARKET_DEPLOYMENT;
        }
        else{
            localFieldSuffix = fieldSuffix ;
        }
        return localFieldSufx;
    }       
  
    /*******************************************************************************************************
    * @description  Used to get Financial Business Case for currently selected Financial
    * @param        NONE
    * @return       NONE
    */
    private void getFinancials(){
        
        totalCalendarFinYears = 0;
        
        if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL || (project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)) {
            ExternalId = project.IPM_Project_Name__c;
        } 
        else {
            ExternalId = project.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
        }
        String queryString = 'SELECT ';
        //IPM Financial
        For (String field : Schema.SObjectType.IPM_Financial__c.fields.getMap().KeySet()) {
            queryString+= field + ', ';
        }
        //IPM Financial Year
        queryString+= '(SELECT ';
        For (String field : Schema.SObjectType.IPM_Financial_Year__c.fields.getMap().KeySet()){
            if (field != 'Id') {
                queryString+= field + ', ';
            }
        }
        queryString+= 'Id FROM IPM_Financial_Years__r ORDER BY Year__c)';
        queryString+= 'FROM IPM_Financial__c WHERE Financial_External_ID__c =: ExternalId';// need to repace by external is
        
        currentFinancial = Database.query(queryString);

        if (currentFinancial != NULL){
            fieldSuffix = getGateFieldSuffix(fieldSuffix, currentFinancial ); 
            financialsInnovation = new IPM_FinancialWrapper();
            financialsCalendar = new IPM_FinancialWrapper();
            
            volumeUnit = (String) currentFinancial.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_UNIT + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);

            For (IPM_Financial_Year__c finYear : currentFinancial.IPM_Financial_Years__r){
                //Innovation Years
                if (finYear.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_INNOVATION){
                    generateFinancials(finYear, financialsInnovation);
                }
                //Calendar Years
                else if (finYear.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR){
                    generateFinancials(finYear, financialsCalendar);
                    totalCalendarFinYears++;
                }
            }
        }
    }
    
    /*******************************************************************************************************
    * @description      Used to generate Financial Wrapper for the selected Financial Year
    * @param finYear    Selected IPM_Financial_Year__c record which needs to be processed
    * @param finWrapper Selected wrapper record which needs to be updated with the finYear values
    * @return       NONE
    */
    private void generateFinancials(IPM_Financial_Year__c finYear, IPM_FinancialWrapper finWrapper){
        //Year 0 Values
        if (finYear.Year__c == IPM_ConstantUtils.Y0_YEARINDEX){
            finWrapper.y0ValueMarketShare = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0Volume = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0VolumeTons = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0Turnover = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0GrossProfit = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0Advertising = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0Profit = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0GM = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_GM_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0AP = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_AP_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0PBO = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_PBO_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);

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
            if (finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS){
                finWrapper.lstYearNames.add(finYear.Name);
                
                //Gross PL Values to show when misaligned with Regional and Local
                finWrapper.lstGrossPLValueMarketShare.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE ,1,null, null));                
                finWrapper.lstGrossPLVolume.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_VOLUME ,2,null, null));
                finWrapper.lstGrossPLVolumeTons.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS ,2,null, null));
                finWrapper.lstGrossPLTurnover.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_TURNOVER ,2,null, null));
                finWrapper.lstGrossPLGrossProfit.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT ,2,null, null));
                finWrapper.lstGrossPLAdvertising.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS ,2,null, null));
                finWrapper.lstGrossPLProfit.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS ,2,null, null));
                finWrapper.lstGrossPLGM.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_GM_OF_TO ,1,null, null));
                finWrapper.lstGrossPLAP.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_AP_OF_TO,1,null, null));
                finWrapper.lstGrossPLPBO.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_PBO_OF_TO,1,null, null));
             
            }
            //Incremental PL Values to show when misaligned with Regional and Local
            else if (finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL) {
                finWrapper.lstIncrementalPLValueMarketShare.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_VOLUME ,1,null, null));
                finWrapper.lstIncrementalPLVolume.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_VOLUME ,2,null, null));
                finWrapper.lstIncrementalPLVolumeTons.add(new IPM_FinancialValueWrapper(finYear, null,fieldSuffix, IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS ,2,null, null));
                finWrapper.lstIncrementalPLTurnover.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_TURNOVER ,2,null, null));
                finWrapper.lstIncrementalPLGrossProfit.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT ,2,null, null));
                finWrapper.lstIncrementalPLAdvertising.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS ,2,null, null));
                finWrapper.lstIncrementalPLProfit.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS ,2,null, null));
                finWrapper.lstIncrementalPLGM.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_GM_OF_TO ,1,null, null));
                finWrapper.lstIncrementalPLAP.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_AP_OF_TO ,1,null, null));
                finWrapper.lstIncrementalPLPBO.add(new IPM_FinancialValueWrapper(finYear, null, fieldSuffix,IPM_ConstantUtils.FIELD_LITERAL_PBO_OF_TO ,1,null, null));
                
                
            }
        }
    }

    /*******************************************************************************************************
    * @description      Used to get Financial Summary data
    * @param            NONE
    * @return           NONE
    */
    private void getFinancialsForSummary(){
        lstClusterNames = new List<String>();
        
        gTOWrapper = new ipmFinancialSummaryWrapper();
        GMWrapper = new ipmFinancialSummaryWrapper();
        PBOWrapper = new ipmFinancialSummaryWrapper();
        GMbpsWrapper = new ipmFinancialSummaryWrapper();
        PBObpsWrapper = new ipmFinancialSummaryWrapper();
        iTOWrapper = new ipmFinancialSummaryWrapper();
        iAPWrapper = new ipmFinancialSummaryWrapper();
        

        //Only valid for Charter Gate Document
        if (printDoc==IPM_ConstantUtils.CHARTER_GATE && project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL){ 
            //Global Original Project
            
                List<IPM_Financial__c> lstConsolidatedFinancial = new List<IPM_Financial__c>();
                lstConsolidatedFinancial = [SELECT Id, IPM_Project_Rollout__r.Market_Cluster_Name__c, GM_Y1_bps_vs_DNDS_Global__c, GM_Y1_bps_vs_DNDS_Regional__c, GM_Y1_bps_vs_DNDS_Charter__c, 
                                                                        PBO_Y1_bps_vs_DNDS_Global__c, PBO_Y1_bps_vs_DNDS_Regional__c, PBO_Y1_bps_vs_DNDS_Charter__c,
                                                                    (SELECT Id, PL_Type__c, Turnover_Global__c, Turnover_Regional__c, Turnover_Charter__c, 
                                                                            Advertising_Promotions_Global__c, Advertising_Promotions_Regional__c, Advertising_Promotions_Charter__c, 
                                                                            GM_of_TO_Global__c, GM_of_TO_Regional__c, GM_of_TO_Charter__c, 
                                                                            PBO_of_TO_Global__c, PBO_of_TO_Regional__c, PBO_of_TO_Charter__c
                                                                        FROM IPM_Financial_Years__r 
                                                                        WHERE Year_Type__c =: IPM_ConstantUtils.YEAR_TYPE_INNOVATION
                                                                            AND Year__c =: IPM_ConstantUtils.Y1_YEARINDEX)
                                                                FROM IPM_Financial__c
                                                                WHERE Parent_Project__c =: project.Id OR (Regional_Project__c =: project.Id AND Financial_External_ID__c =:ExternalId)
            
                                                                ORDER BY IPM_Project_Rollout__r.Market_Cluster_Name__c];
                For(IPM_Financial__c consolidatedFinancial : lstConsolidatedFinancial){
                    //Global Consolidated Financial
                    if(consolidatedFinancial.IPM_Project_Rollout__c == null){
                        GMbpsWrapper.globalValue = ((Decimal) consolidatedFinancial.get(IPM_ConstantUtils.FIELD_LITERAL_GM_BPS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2);
                        PBObpsWrapper.globalValue = ((Decimal) consolidatedFinancial.get(IPM_ConstantUtils.FIELD_LITERAL_PBO_BPS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2);
                        
                        For(IPM_Financial_Year__c finYear : consolidatedFinancial.IPM_Financial_Years__r){
                            if(finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS){
                                gTOWrapper.globalValue = ((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2);
                                GMWrapper.globalValue = ((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_GM_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(1);
                                PBOWrapper.globalValue = ((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_PBO_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(1);
                            }else {
                                iTOWrapper.globalValue = ((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2);
                                iAPWrapper.globalValue = ((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2);
                            }
                        }
                    }
                    //Regional Consolidated Financial
                    else {
                        lstClusterNames.add(consolidatedFinancial.IPM_Project_Rollout__r.Market_Cluster_Name__c);
                        
                        GMbpsWrapper.lstClusterValues.add(((Decimal) consolidatedFinancial.get(IPM_ConstantUtils.FIELD_LITERAL_GM_BPS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2));
                        PBObpsWrapper.lstClusterValues.add(((Decimal) consolidatedFinancial.get(IPM_ConstantUtils.FIELD_LITERAL_PBO_BPS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2));
    
                        For(IPM_Financial_Year__c finYear : consolidatedFinancial.IPM_Financial_Years__r){
                            if(finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS){
                                gTOWrapper.lstClusterValues.add(((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2));
                                GMWrapper.lstClusterValues.add(((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_GM_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(1));
                                PBOWrapper.lstClusterValues.add(((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_PBO_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(1));
                            }else {
                                iTOWrapper.lstClusterValues.add(((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2));
                                iAPWrapper.lstClusterValues.add(((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2));
                            }
                        }
    
                    }
                }
            }
       }

   
    
    /*******************************************************************************************************
    * @description  Used to wrap financials summary together for Global and 
    *               all the clusters the project is being rolled out to
    */
    public class ipmFinancialSummaryWrapper{
        public Decimal globalValue {get; set;}
        public List<Decimal> lstClusterValues {get; set;}
        
        public ipmFinancialSummaryWrapper(){
            this.lstClusterValues = new List<Decimal>();
        }
    }
}