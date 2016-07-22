/**
* @author       Cognizant (Vipul)
* @date         27/04/2015
* @description  This class is used for displaying Financial Action Stndards 
*               in the gate document
*/
public with sharing class IPM_FinancialActionStandards {

    public IPM_Project__c project {get; set;} //The project record for which the financial business cases are being viewed
    public Id projDocSecId{get; set;}
    public Id conId{get; set;}
    public IPM_Project_Document_Section_Content__c projDocSecCon{get; set;}
    public Id projectId; //Project Id of te current project
    public ID getprojectId(){ return projectId; }
    public string commentField{get; set;}
    public string comments{get; set;}
    public Boolean isComment{get; set;}
    public Decimal numValue{get; set;}
    public String gateType{get;set;}
    public void setprojectId (ID p){
        projectId = p;
        showFinancialActionStandards(); 
    }
    
    /***********************************************************************************************************************************************************
    * @description To Check Record is Editable or Read Mode
    * @return True If Enabled
    */
    public boolean editTable{ 
        get {
            return editTable;
        }
        set {
            editTable= value;
        }
    }
    
    public Map<String,IPM_Financial_Year__c> mapFinancialYears{get;set;}

    public String fieldSuffix {get; set;} //Used to dynamically change the field suffix based on the current view. (Accepted values are - Global,Regional.Local,Charter,Contract,MR,MD)
    public String printDoc {get; set;} //Current Document being viewed

    public IPM_Financial__c financial; //Current Financial Record
    public IPM_Financial_Year__c firstFullYearGross; //First Full Year Gross Wrapper
    public IPM_Financial_Year__c firstFullYearIncremental; //First Full Year Incremental Wrapper

    public List<String> lstGateNames {get; set;} //List of Different Gate Names relevant for the current gate document

    public String colSpan {get; set;} //Used to define the number of columns visible on the Financial Table

    public ipmFinancialActionStandardWrapper innovationValueShareWrapper {get; set;} //Innovation Value Market Share Wrapper
    public ipmFinancialActionStandardWrapper incrementalValueShareWrapper {get; set;} //Incremental Value Market Share Wrapper
    public ipmFinancialActionStandardWrapper gTOWrapper {get; set;} //Gross Turnover Wrapper
    public ipmFinancialActionStandardWrapper iTOWrapper {get; set;} //Incremental Turnover Wrapper
    public ipmFinancialActionStandardWrapper GMWrapper {get; set;} //Gross Margin Wrapper
    public ipmFinancialActionStandardWrapper NPVWrapper {get; set;} //NPV Wrapper
    public ipmFinancialActionStandardWrapper IRRWrapper {get; set;} //IRR Wrapper
    public ipmFinancialActionStandardWrapper PaybackWrapper {get; set;} //Payback Wrapper

    public static final String CLASS_NAME = IPM_FinancialActionStandards.Class.getName(); //Class Name for Exception Logging
    @TestVisible private static string UPDATE_ACTION_STANDARDS_STR = 'updateActionStandards';
    @TestVisible private static string COMMENT_INNOVATION = 'Innovation';
    @TestVisible private static string COMMENT_INCREMENTAL = 'Incremental';
    @TestVisible private static string COMMENT_GTO = 'gTO';
    @TestVisible private static string COMMENT_ITO = 'iTO';
    @TestVisible private static string COMMENT_GM = 'GM';
    @TestVisible private static string COMMENT_NPV = 'NPV';
    @TestVisible private static string COMMENT_IRR = 'IRR';
    @TestVisible private static string COMMENT_PAYBACK = 'PayBack';
    
    /*******************************************************************************************************
    * @description  Action Method to show Action Standards
    * @param        NONE
    * @return       NONE
    */
    public void showFinancialActionStandards(){
        try{
            project = [SELECT IPM_Project_Name__c,IPM_Project_Type__c,IPMProject_Span__c, IPM_Phase__c
                       FROM IPM_Project__c 
                       WHERE ID =: projectId];
            
            getFieldSuffix();
            getFinancials();
            getActionStandards();
            
        } catch (Exception ex) {
            if(ApexPages.currentPage() != null){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Generic_ErrorMessage ) );
            }
        }
    }


    /*******************************************************************************************************
    * @description  Used to generate the suffix to be used in referencing appropriate fields on the 
    *               Financial and Financial Year object
    * @param        NONE
    * @return       NONE
    */
    public void getFieldSuffix(){
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
    * @description  Used to get Financial Business Case for currently selected Financial
    * @param        NONE
    * @return       NONE
    */
    public void getFinancials(){
        String financialExternalId=IPM_ConstantUtils.BLANK;
        lstGateNames = new List<String>();
        innovationValueShareWrapper = new ipmFinancialActionStandardWrapper();
        incrementalValueShareWrapper = new ipmFinancialActionStandardWrapper();
        gTOWrapper = new ipmFinancialActionStandardWrapper();
        iTOWrapper = new ipmFinancialActionStandardWrapper();
        GMWrapper = new ipmFinancialActionStandardWrapper();
        NPVWrapper = new ipmFinancialActionStandardWrapper();
        IRRWrapper = new ipmFinancialActionStandardWrapper();
        PaybackWrapper = new ipmFinancialActionStandardWrapper();
        if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
            financialExternalId = project.IPM_Project_Name__c;
        }        
        else{
            financialExternalId = project.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
        }
        financial = [SELECT Id, NPV_Global__c, NPV_Regional__c, NPV_Local__c, NPV_Charter__c, NPV_Contract__c, NPV_MR__c, NPV_MD__c, 
                            IRR_Global__c, IRR_Regional__c, IRR_Local__c, IRR_Charter__c, IRR_Contract__c, IRR_MR__c, IRR_MD__c, 
                            Payback_Global__c, Payback_Regional__c, Payback_Local__c, Payback_Charter__c, Payback_Contract__c, Payback_MR__c, Payback_MD__c,
                        (SELECT Id, External_Id__c, PL_Type__c, 
                                Value_Market_Share_Global__c, Value_Market_Share_Regional__c, Value_Market_Share_Local__c, Value_Market_Share_Charter__c, Value_Market_Share_Contract__c, Value_Market_Share_MR__c, Value_Market_Share_MD__c, 
                                GM_of_TO_Global__c, GM_of_TO_Regional__c, GM_of_TO_Local__c, GM_of_TO_Charter__c, GM_of_TO_Contract__c, GM_of_TO_MR__c, GM_of_TO_MD__c, 
                                Turnover_Global__c, Turnover_Regional__c, Turnover_Local__c, Turnover_Charter__c, Turnover_Contract__c, Turnover_MR__c, Turnover_MD__c, 
                                Year_Type__c
                            FROM IPM_Financial_Years__r)
                    FROM IPM_Financial__c 
                    WHERE Financial_External_Id__c =: financialExternalId Limit 1];
                    
        
        mapFinancialYears = new Map<String, IPM_Financial_Year__c>();
        For(IPM_Financial_Year__c finYear : financial.IPM_Financial_Years__r) {
            mapFinancialYears.put(finYear.External_Id__c, finYear);
        }

        String firstFullYearGrossExtId = financialExternalId + '_' + IPM_ConstantUtils.Y1_LABEL + '_' + IPM_ConstantUtils.YEAR_TYPE_INNOVATION + '_' + IPM_ConstantUtils.PL_TYPE_GROSS;
        if (mapFinancialYears.containsKey(firstFullYearGrossExtId)) {
            firstFullYearGross = mapFinancialYears.get(firstFullYearGrossExtId);
        }
        
        String firstFullYearIncrementalExtId = financialExternalId + '_' + IPM_ConstantUtils.Y1_LABEL + '_' + IPM_ConstantUtils.YEAR_TYPE_INNOVATION + '_' + IPM_ConstantUtils.PL_TYPE_INCREMENTAL;
        
        if (mapFinancialYears.containsKey(firstFullYearIncrementalExtId)) {
            firstFullYearIncremental = mapFinancialYears.get(firstFullYearIncrementalExtId);
        }
        
        if ((firstFullYearGross != null) && (firstFullYearIncremental != null)){
            //Generate Wrappers
            printDoc = ApexPages.currentPage().getParameters().get('printDoc');
            if(String.isBlank(printDoc)){
                printDoc=gateType;
            }
            String actionsStandardsFieldSuffix;
            if (project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS) {
                actionsStandardsFieldSuffix = fieldSuffix;
            }
            else {
                actionsStandardsFieldSuffix = IPM_ConstantUtils.FIELD_SUFFIX_CHARTER;
            }
            innovationValueShareWrapper.actionStandardValue = ((Decimal) firstFullYearGross.get(IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE + actionsStandardsFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(1);
           
            incrementalValueShareWrapper.actionStandardValue = ((Decimal) firstFullYearIncremental.get(IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE + actionsStandardsFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(1);
            gTOWrapper.actionStandardValue = ((Decimal) firstFullYearGross.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + actionsStandardsFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2);
            iTOWrapper.actionStandardValue = ((Decimal) firstFullYearIncremental.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + actionsStandardsFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2);
            GMWrapper.actionStandardValue = ((Decimal) firstFullYearGross.get(IPM_ConstantUtils.FIELD_LITERAL_GM_OF_TO + actionsStandardsFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(1);
            NPVWrapper.actionStandardValue = ((Decimal) financial.get(IPM_ConstantUtils.FIELD_LITERAL_NPV + actionsStandardsFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2);
            IRRWrapper.actionStandardValue = ((Decimal) financial.get(IPM_ConstantUtils.FIELD_LITERAL_IRR + actionsStandardsFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(3);
            PaybackWrapper.actionStandardValue = ((Decimal) financial.get(IPM_ConstantUtils.FIELD_LITERAL_PAYBACK + actionsStandardsFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2);
    
            //Charter - Always Process Charter Results
            lstGateNames.add(IPM_ConstantUtils.CHARTER_GATE);
            if (project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS) {
                processWrapperListGateValues(fieldSuffix);
            }
            else {
                processWrapperListGateValues(IPM_ConstantUtils.FIELD_SUFFIX_CHARTER);
            }
    
            
            //Contract - Only Process if Project phase is not Ideas && Gate Not Charter 
            if((project.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS) 
                    && (printDoc != IPM_ConstantUtils.CHARTER_GATE)){
    
                lstGateNames.add(IPM_ConstantUtils.CONTRACT_GATE);
                if(project.IPM_Phase__c == IPM_ConstantUtils.PHASE_FEASIBILITY){
                    processWrapperListGateValues(fieldSuffix);
                }
                else {
                    processWrapperListGateValues(IPM_ConstantUtils.FIELD_SUFFIX_CONTRACT);
                }
            }
    
            //Market Ready - Only Process if Project phase is not Ideas,Feasibility && Gate Not Charter,Contract 
            if((project.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS) 
                    && (project.IPM_Phase__c != IPM_ConstantUtils.PHASE_FEASIBILITY) 
                    && (printDoc != IPM_ConstantUtils.CHARTER_GATE) 
                    && (printDoc != IPM_ConstantUtils.CONTRACT_GATE)){
    
                lstGateNames.add(IPM_ConstantUtils.MARKET_READY_GATE);
                if(project.IPM_Phase__c == IPM_ConstantUtils.PHASE_CAPABILITY){
                    processWrapperListGateValues(fieldSuffix);
                }
                else {
                    processWrapperListGateValues(IPM_ConstantUtils.FIELD_SUFFIX_MARKET_READY);
                }
            }
                
            //1 Column (attributes) + 1 column (Action Standards) + 1 column (Comments) + Number of Gates to be made visible
            Integer calcColSpan = IPM_ConstantUtils.CHANNEL_PRIORITY_THREE + lstGateNames.size();
            colSpan = '' + calcColSpan;
        }
    }
    
    /*******************************************************************************************************
    * @description                  Process List of relevant gate values
    * @param passedFieldSuffix      Field Suffix of the passed gate
    * @return                       NONE
    */
    public void processWrapperListGateValues(String passedFieldSuffix){
        innovationValueShareWrapper.lstGateValues.add(((Decimal) firstFullYearGross.get(IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE + passedFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(1));
        incrementalValueShareWrapper.lstGateValues.add(((Decimal) firstFullYearIncremental.get(IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE + passedFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(1));
        gTOWrapper.lstGateValues.add(((Decimal) firstFullYearGross.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + passedFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2));
        iTOWrapper.lstGateValues.add(((Decimal) firstFullYearIncremental.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + passedFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2));
        GMWrapper.lstGateValues.add(((Decimal) firstFullYearGross.get(IPM_ConstantUtils.FIELD_LITERAL_GM_OF_TO + passedFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(1));
        NPVWrapper.lstGateValues.add(((Decimal) financial.get(IPM_ConstantUtils.FIELD_LITERAL_NPV + passedFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2));
        IRRWrapper.lstGateValues.add(((Decimal) financial.get(IPM_ConstantUtils.FIELD_LITERAL_IRR + passedFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(3));
        PaybackWrapper.lstGateValues.add(((Decimal) financial.get(IPM_ConstantUtils.FIELD_LITERAL_PAYBACK + passedFieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)).setScale(2));
    }
    
    public void getActionStandards(){
        projDocSecCon=new IPM_Project_Document_Section_Content__c();
        if(String.isNotBlank(projDocSecId)){
            projDocSecCon=[SELECT Id,IPM_GM_Action_Standards_Charter__c,IPM_GM_Action_Standards_Charter_Cmts__c,IPM_gTO_Action_Standard_Charter__c,IPM_gTO_Action_Standard_Charter_Cmts__c,IPM_Section_Name__c,
                                  IPM_Inc_Val_Share_Action_Charter_Cmts__c,IPM_Inc_Value_Share_Action_Charter__c,IPM_Innov_Value_Share_Action_Charter__c,IPM_Inov_Value_Share_Action_Charter_Cmts__c,
                                  IPM_IRR_Action_Standard_Charter__c,IPM_IRR_Action_Standard_Charter_Cmts__c,IPM_iTo_Action_Standard_Charter__c,IPM_iTo_Action_Standard_Charter_Cmts__c,IPM_NPV_Action_Standard_Charter__c,
                                  IPM_NPV_Action_Standard_Charter_Cmts__c,IPM_Payback_Action_Standard_Charter__c,IPM_Payback_Action_Standard_Charter_Cmts__c,IPM_Project_Document_Section__c,IPM_Content_Type__c 
                           FROM IPM_Project_Document_Section_Content__c 
                           WHERE IPM_Project_Document_Section__c=:projDocSecId and IPM_Content_Type__c=:IPM_ConstantUtils.FINANCIAL_ACTION_STANDARDS];
        }
    }
    
    public void updateActionStandards(){
        try{
            if(String.isNotBlank(conId)){
                projDocSecCon=new IPM_Project_Document_Section_Content__c();
                projDocSecCon.Id=conId;
                if(commentField == COMMENT_INNOVATION){
                    if(isComment){
                        projDocSecCon.IPM_Inov_Value_Share_Action_Charter_Cmts__c=comments;
                    }
                    else{
                        projDocSecCon.IPM_Innov_Value_Share_Action_Charter__c=numvalue;
                    }
                }
                else if(commentField == COMMENT_INCREMENTAL){
                    if(isComment){
                        projDocSecCon.IPM_Inc_Val_Share_Action_Charter_Cmts__c=comments;
                    }
                    else{
                        projDocSecCon.IPM_Inc_Value_Share_Action_Charter__c=numvalue;
                    }   
                }
                else if(commentField == COMMENT_GTO){
                    if(isComment){
                        projDocSecCon.IPM_gTO_Action_Standard_Charter_Cmts__c=comments;
                    }
                    else{
                        projDocSecCon.IPM_gTO_Action_Standard_Charter__c=numvalue;
                    }   
                }
                else if(commentField == COMMENT_ITO){
                    if(isComment){
                        projDocSecCon.IPM_iTo_Action_Standard_Charter_Cmts__c=comments;
                    }
                    else{
                        projDocSecCon.IPM_iTo_Action_Standard_Charter__c=numvalue;
                    }   
                }
                else if(commentField == COMMENT_GM){
                    if(isComment){
                        projDocSecCon.IPM_GM_Action_Standards_Charter_Cmts__c=comments;
                    }
                    else{
                        projDocSecCon.IPM_GM_Action_Standards_Charter__c=numvalue;
                    }
                }
                else if(commentField == COMMENT_NPV){
                    if(isComment){
                        projDocSecCon.IPM_NPV_Action_Standard_Charter_Cmts__c=comments;
                    }
                    else{
                        projDocSecCon.IPM_NPV_Action_Standard_Charter__c=numvalue;
                    }   
                }
                else if(commentField == COMMENT_IRR){
                    if(isComment){
                        projDocSecCon.IPM_IRR_Action_Standard_Charter_Cmts__c=comments;
                    }
                    else{
                        projDocSecCon.IPM_IRR_Action_Standard_Charter__c=numvalue;
                    }   
                }
                else if(commentField == COMMENT_PAYBACK){
                    if(isComment){
                        projDocSecCon.IPM_Payback_Action_Standard_Charter_Cmts__c=comments;
                    }
                    else{
                        projDocSecCon.IPM_Payback_Action_Standard_Charter__c=numvalue;
                    }   
                }
                update projDocSecCon;
            }
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    UPDATE_ACTION_STANDARDS_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
            if(ApexPages.currentPage() != null){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Generic_ErrorMessage ) );
            }
        }  
    }
    
    /*******************************************************************************************************
    * @description  Used to wrap financials summary together for Global and 
    *               all the relevant gates of the project
    */
    public class ipmFinancialActionStandardWrapper{
        public Decimal actionStandardValue {get; set;}
        public List<Decimal> lstGateValues {get; set;}
        
        public ipmFinancialActionStandardWrapper(){
            this.lstGateValues = new List<Decimal>();
        }
    }
}