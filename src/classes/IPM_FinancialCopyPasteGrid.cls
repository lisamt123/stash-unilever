/*****************************************************************************************************************************
   @Author :Nandini KV
   @name : IPM_FinancialCopyPasteGrid
   @CreateDate : 02/06/2015
   @Description : This is a controller class for IPM_FinancialCopyPasteGrid Page, this supports the 
   @              process of saving the row, col data to IPM_Financialyears records.
   @Version : 1.0
   @reference : none
****************************************************************************************************************************/

//Declaring the Class Global because there is method with @Remoteaction annotation which is called from Javascript function.
global with sharing class IPM_FinancialCopyPasteGrid extends IPM_ProjectIntermediateController {
     public Set<String> setOfCountries = new set<String>();// This is to maintain the set of countries that were selected.
     public List<String> submittedList{get;set;}// submitted MCO 
     public List<IPM_Financial__c> IPMF = new list<IPM_Financial__c>();// get the list of financial records.
     public String ListCountries {get;set;}// this is the MCO collected 
     public List<SelectOption> options = new List<SelectOption>();// selectlist options where the list of MCO are added 
     global static String SelectedCountry{get;set;}// selected MCO is copied to this variable.
     public String BI{get;set;}// Project BI Value.
     public String sustainability{get;set;} // this variable stores sustainability period.
     public String projectId{get;set;}// this stores IPM_Project__c record Id.
     public IPM_Project__c IpmProject {get;set;}// stores the IPM_Project__c records.
     global String span{get;set;}// Store the span of the project.
     public Boolean flag{get;set;} // used to render the data on Page.
     public Boolean showdata{get;set;} // used to render the List of MCO on Page.
     public Boolean isEditable{get;set;}//for security
     global String projectType{get;set;}// project type 
     
     //Constructor.
    /**********************************************************************
    *  @Description: Contructor method
    *  @name : IPM_financialCopyPasteGrid
    *  @param : none
    *  @return : none
    *************************************************************************/
     public IPM_FinancialCopyPasteGrid (){
        //IE-9 Fix
        super();
        IpmProject = new IPM_Project__c();
        isEditable=false;
        Apexpages.currentPage().getHeaders().put(IPM_ConstantUtils.UA_COMPATIBLE, IPM_ConstantUtils.IE_EDGE);// keep it compatible with IE.
        submittedList = new list<String>();// initialing the list.
        projectId = ApexPages.currentPage().getParameters().get('Id');// stores the project ID from the URL
        flag = false;//initializing the boolean value
        showdata = false;// initializing the boolean value
        if(String.isNotBlank(projectId) && projectId.length() > IPM_ConstantUtils.fifteen){// handling the 18 digits ID for the Picklist.
          projectId = projectId.subString(IPM_ConstantUtils.intialVal, projectId.length()-3);
        }
        if(String.isNotBlank(projectId)){
            isEditable=IPM_Utils.getIpmuserType(projectId, IPM_ConstantUtils.IPM_ROLE_FINANCE);
        }
        if(!isEditable){
            ApexPages.Message ErrorMsg = new ApexPages.Message(ApexPages.Severity.Info, 'InSufficient Privilege '+Label.IPM_PLEASE_CONTACT_ADMINISTRATOR);
            ApexPages.addMessage(ErrorMsg); 
        }
        ExceptionLoggingHelper.initializeExceptionLog();
        Query();// query the financial records for the MCO list.
     }

    /*****************************************************************************************************
    *  @Description: This method queries the financial record based on the project Id, span of the project.
    *  @name : query
    *  @param : none
    *  @return: PageReference
    ******************************************************************************************************/
     public PageReference Query() { 
        try{

                ipmProject = [Select Sustainability_Period__c, BI__c,IPM_Parent_Project__c,IPM_Parent_Project__r.Name,Id, IPMProject_Span__c, IPM_Project_Logo__c, IPM_Category_Icon__c, IPM_SourceProjectType__c, IPM_Project_Type__c, IPM_CompanyCardText__c, IPM_Phase__c, IPM_Bosscard_Status__c,IPM_GateKeeping_Model__c ,IPM_Project_Name__c , IPM_Category_Text__c,IPM_Brand_Positioning__c, IPM_Bosscard__c  From IPM_Project__c where Id =:projectId limit 1];
                sustainability = IpmProject.Sustainability_Period__c;
                span = IpmProject.IPMProject_Span__c;
                projectType = ipmProject.IPM_Project_Type__c;
                BI = ipmProject.BI__c;
                if(BI == null || BI == '')
                    BI = IPM_ConstantUtils.smallBI;
                String soql = 'Select Id, RecordTypeId, Global_Project_Id__c, Financial_External_ID__c, Display_Name__c From IPM_Financial__c  where RecordType.Name = \'Default\'  and isActive__c = true ';
                if(span == IPM_ConstantUtils.SpanGlobal){
                        soql = soql +' and Global_Project_Id__c = \''+String.escapeSingleQuotes(projectId)+'\'';
                }
                if(span == IPM_ConstantUtils.Regional ){ 
                        soql = soql +' and Regional_Project__c = \''+String.escapeSingleQuotes(projectId)+'\'';
                }
                if(span == IPM_ConstantUtils.Local ){
                        soql = soql +' and Local_Project__c = \''+String.escapeSingleQuotes(projectId)+'\'';
                }
                
                IPMF = Database.query(soql + ' ORDER BY Sorting_Order__c, Financial_External_Id__c Limit ' +IPM_ConstantUtils.MaxLimit);
                if(IPMF.isEmpty()){
                        flag = true;
                }
               if(Test.isRunningTest()) {
                        // Cause QueryException
                        IPMF = Database.query(soql+'Exception');
                }
        }catch(QueryException ex){
               ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ConstantUtils.ClassCopyPaste,
               'query',ex.getMessage(),ex, IPM_ConstantUtils.ERROR,
                null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
                ApexPages.Message ErrorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.IPM_PLEASE_CONTACT_ADMINISTRATOR);
                ApexPages.addMessage(ErrorMsg);  
        }     
        return null; 
    } 
    
   /**********************************************************************
    *  @Description: this method is to get the MCO list into picklist.
    *  @name : getCountryValue
    *  @param : none
    *  @return: List of Select Options.
    **********************************************************************/
    public List<SelectOption> GetCountryValue() {            
       SelectedCountry = ListCountries;
       for(IPM_Financial__c c: IPMF){
                if(!setOfCountries.contains(c.Display_Name__c )){
                    setOfCountries.add(c.Display_Name__c );  
                    options.add(new SelectOption(c.ID,c.Display_Name__c ));
                }
       }
       if(options.isEmpty()){
         flag = true;
       }
        return options;
    }
        
    /*************************************************************************************************************************
    *  @Description: this remote action method put the grids data into map for mapping it to the financial year records.
    *  @             valY0InnG-- represent each column in the Grid which is a record on Financial Years Object.
    *  @             here we are trying to concatenate all the col values together to link it to a record.
    *  @name : getFinancialyear
    *  @param : rowcol, selectedMCO and pspan.
    *  @return: String.
    ***************************************************************************************************************************/   
   @RemoteAction
   global static String GetFinancialYear(String rowcol, String selectedMCO, String pspan, String projectType){
            try{
                String rowcol1;
                rowcol1=rowcol.replace('%',IPM_ConstantUtils.EMPTY_STRING_INITIAL);
                map<String,String> mapfields = new map<String,String>(); 
                list<object> RowColValue = (list<object>)JSON.deserializeUntyped(rowcol1);
                if(!RowColValue.isEmpty()){
                        final Date targetdate = [select Target_Launch_Date__c from IPM_Financial__c where Id=: selectedMCO Limit 1].Target_Launch_Date__c ;
                        //value of Innovation Years and Gross
                        String valY0InnG = IPM_ConstantUtils.NullString; 
                        String valY1InnG = IPM_ConstantUtils.NullString; 
                        String valY2InnG = IPM_ConstantUtils.NullString; 
                        String valY3InnG = IPM_ConstantUtils.NullString; 
                        String valY4InnG = IPM_ConstantUtils.NullString; 
                        String valY5InnG = IPM_ConstantUtils.NullString; 
                        //value of Innovation Incremental
                        String valY1InnI = IPM_ConstantUtils.NullString; 
                        String valY2InnI = IPM_ConstantUtils.NullString; 
                        String valY3InnI = IPM_ConstantUtils.NullString; 
                        String valY4InnI = IPM_ConstantUtils.NullString; 
                        String valY5InnI = IPM_ConstantUtils.NullString;
                        // value of Calendar Gross
                        String valY0CalG = IPM_ConstantUtils.NullString; 
                        String valY1CalG = IPM_ConstantUtils.NullString; 
                        String valY2CalG = IPM_ConstantUtils.NullString; 
                        String valY3CalG = IPM_ConstantUtils.NullString; 
                        String valY4CalG = IPM_ConstantUtils.NullString; 
                        String valY5CalG = IPM_ConstantUtils.NullString; 
                        // value of Calendar Incremental
                        String valY1CalI = IPM_ConstantUtils.NullString; 
                        String valY2CalI = IPM_ConstantUtils.NullString; 
                        String valY3CalI = IPM_ConstantUtils.NullString; 
                        String valY4CalI = IPM_ConstantUtils.NullString; 
                        String valY5CalI = IPM_ConstantUtils.NullString;
                        //Financial fields
                        String NPV = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                        String IRR = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                        String payback = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                        String capex = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                        String BIC = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                        String volumeUnit = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                        IPM_Financial__c finUpdate = new IPM_Financial__c(Id = selectedMCO);                        
                        for(integer i=IPM_ConstantUtils.intialVal; i< RowColValue.size();i++){      
                                list<object> cell = (list<object>) RowColValue[i];
                                integer row = integer.valueOf(cell[0]);//row
                                integer col = integer.valueOf(cell[1]);//col
                                String value = String.valueOf(cell[3]);//value   
                                if(col == IPM_ConstantUtils.col_one && row == IPM_ConstantUtils.row_seven){
                                        mapfields.put(IPM_ConstantUtils.Volume,value.replace('\'',IPM_ConstantUtils.EMPTY_STRING_INITIAL).trim());
                                }    
                                if(col == IPM_ConstantUtils.col_four && row < IPM_ConstantUtils.row_twentyseven){
                                        valY0InnG = setMapValues(valY0InnG,value, row);
                                        mapfields.put(IPM_ConstantUtils.Y0Innovation,valY0InnG);                              
                                }
                                if(col == IPM_ConstantUtils.col_four && row > IPM_ConstantUtils.row_twentyseven){
                                        valY0CalG = setMapValues(valY0CalG,value, row);
                                        mapfields.put(IPM_ConstantUtils.Y0Calendar,valY0CalG); 
                                }
                                if(col == IPM_ConstantUtils.col_five && row < IPM_ConstantUtils.row_twentyseven){
                                        valY1InnG = setMapValues(valY1InnG,value, row); 
                                        mapfields.put(IPM_ConstantUtils.Y1InnovationGross,valY1InnG);               
                                }
                                if(col == IPM_ConstantUtils.col_five && row > IPM_ConstantUtils.row_twentyseven){
                                        valY1CalG = setMapValues(valY1CalG,value, row);
                                        mapfields.put(targetdate.year()+IPM_ConstantUtils.CalendarGross,valY1CalG); 
                                }
                                if(col == IPM_ConstantUtils.col_six && row < IPM_ConstantUtils.row_twentyseven){
                                        valY2InnG = setMapValues(valY2InnG,value, row); 
                                        mapfields.put(IPM_ConstantUtils.Y2InnovationGross,valY2InnG);               
                                }
                                if(col == IPM_ConstantUtils.col_six && row > IPM_ConstantUtils.row_twentyseven){
                                        valY2CalG = setMapValues(valY2CalG,value, row);
                                        mapfields.put(targetdate.addYears(1).year()+IPM_ConstantUtils.CalendarGross,valY2CalG); 
                                }
                                if(col == IPM_ConstantUtils.col_seven && row < IPM_ConstantUtils.row_twentyseven){
                                        valY3InnG = setMapValues(valY3InnG,value, row); 
                                        mapfields.put(IPM_ConstantUtils.Y3InnovationGross,valY3InnG);               
                                }
                                if(col == IPM_ConstantUtils.col_seven && row > IPM_ConstantUtils.row_twentyseven){
                                        valY3CalG = setMapValues(valY3CalG,value, row);
                                        mapfields.put(targetdate.addYears(2).year()+IPM_ConstantUtils.CalendarGross,valY3CalG); 
                                }
                                if(col == IPM_ConstantUtils.col_eight && row < IPM_ConstantUtils.row_twentyseven){
                                        valY4InnG = setMapValues(valY4InnG,value, row); 
                                        mapfields.put(IPM_ConstantUtils.Y4InnovationGross,valY4InnG);               
                                }
                                if(col == IPM_ConstantUtils.col_eight && row > IPM_ConstantUtils.row_twentyseven){
                                        valY4CalG = setMapValues(valY4CalG,value, row);
                                        mapfields.put(targetdate.addYears(3).year()+IPM_ConstantUtils.CalendarGross,valY4CalG); 
                                }
                                if(col == IPM_ConstantUtils.col_nine && row < IPM_ConstantUtils.row_twentyseven){
                                        valY5InnG = setMapValues(valY5InnG,value, row); 
                                        mapfields.put(IPM_ConstantUtils.Y5InnovationGross,valY5InnG);               
                                }
                                if(col == IPM_ConstantUtils.col_nine && row > IPM_ConstantUtils.row_twentyseven){
                                        valY5CalG = setMapValues(valY5CalG,value, row);
                                        mapfields.put(targetdate.addYears(4).year()+IPM_ConstantUtils.CalendarGross,valY5CalG); 
                                }
                                if(col == IPM_ConstantUtils.col_ten && row < IPM_ConstantUtils.row_twentyseven){
                                        valY1InnI = setMapValues(valY1InnI,value, row); 
                                        mapfields.put(IPM_ConstantUtils.Y1InnovationIncremental,valY1InnI);               
                                }
                                if(col == IPM_ConstantUtils.col_ten && row > IPM_ConstantUtils.row_twentyseven){
                                        valY1CalI = setMapValues(valY1CalI,value, row);
                                        mapfields.put(targetdate.year()+IPM_ConstantUtils.CalendarIncremental,valY1CalI); 
                                }
                                if(col == IPM_ConstantUtils.col_eleven && row < IPM_ConstantUtils.row_twentyseven){
                                        valY2InnI = setMapValues(valY2InnI,value, row); 
                                        mapfields.put(IPM_ConstantUtils.Y2InnovationIncremental,valY2InnI);               
                                }
                                if(col == IPM_ConstantUtils.col_eleven && row > IPM_ConstantUtils.row_twentyseven){
                                        valY2CalI = setMapValues(valY2CalI,value, row);
                                        mapfields.put(targetdate.addYears(1).year()+IPM_ConstantUtils.CalendarIncremental,valY2CalI); 
                                }
                                if(col == IPM_ConstantUtils.col_twelve && row < IPM_ConstantUtils.row_twentyseven){
                                        valY3InnI = setMapValues(valY3InnI,value, row); 
                                        mapfields.put(IPM_ConstantUtils.Y3InnovationIncremental,valY3InnI);               
                                }
                                 if(col == IPM_ConstantUtils.col_twelve && row > IPM_ConstantUtils.row_twentyseven){
                                        valY3CalI = setMapValues(valY3CalI,value, row);
                                        mapfields.put(targetdate.addYears(2).year()+IPM_ConstantUtils.CalendarIncremental,valY3CalI); 
                                }
                                if(col == IPM_ConstantUtils.col_thirteen && row < IPM_ConstantUtils.row_twentyseven){
                                        valY4InnI = setMapValues(valY4InnI,value, row); 
                                        mapfields.put(IPM_ConstantUtils.Y4InnovationIncremental,valY4InnI);               
                                }
                                if(col == IPM_ConstantUtils.col_thirteen && row > IPM_ConstantUtils.row_twentyseven){
                                        valY4CalI = setMapValues(valY4CalI,value, row);
                                        mapfields.put(targetdate.addYears(3).year()+IPM_ConstantUtils.CalendarIncremental,valY4CalI); 
                                }   
                                if(col == IPM_ConstantUtils.col_fourteen && row < IPM_ConstantUtils.row_twentyseven){
                                        valY5InnI = setMapValues(valY5InnI,value, row); 
                                        mapfields.put(IPM_ConstantUtils.Y5InnovationIncremental,valY5InnI);               
                                }
                                if(col == IPM_ConstantUtils.col_fourteen && row > IPM_ConstantUtils.row_twentyseven){
                                        valY5CalI = setMapValues(valY5CalI,value, row);
                                        mapfields.put(targetdate.addYears(4).year()+IPM_ConstantUtils.CalendarIncremental,valY5CalI); 
                                } 
                                if(col == IPM_ConstantUtils.col_five && row == IPM_ConstantUtils.rowValue19){
                                       NPV = value;
                                } 
                                if(col == IPM_ConstantUtils.col_five && row == IPM_ConstantUtils.rowValue20){
                                       IRR = value;
                                } 
                                if(col == IPM_ConstantUtils.col_five && row == IPM_ConstantUtils.rowValue21){
                                       payback = value;
                                }
                                if(col == IPM_ConstantUtils.col_eight && row == IPM_ConstantUtils.rowValue19){
                                       capex = value;
                                }
                                if(col == IPM_ConstantUtils.col_eight && row == IPM_ConstantUtils.rowValue20){
                                       BIC = value;
                                }
                                if(col == IPM_ConstantUtils.col_one && row == IPM_ConstantUtils.row_seven){
                                       volumeUnit = value.replace('\'',IPM_ConstantUtils.EMPTY_STRING_INITIAL).trim(); 
                                } 
        
                        }
                        UpdateFinancialYear(mapfields, selectedMCO, pspan, projectType);
                        if(pspan == IPM_ConstantUtils.SpanGlobal || projectType == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL || projectType == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL){
                           finUpdate.NPV_Global__c = SetFieldValues(NPV);
                           finUpdate.IRR_Global__c = SetFieldValues(IRR);
                           finUpdate.Payback_Global__c = SetFieldValues(payback);
                           finUpdate.CAPEX_Global__c = SetFieldValues(capex);
                           finUpdate.BIC_Global__c = SetFieldValues(BIC);
                           finUpdate.Volume_Unit_Global__c = volumeUnit;
<<<<<<< HEAD
                          
=======
                           finUpdate.Last_Saved_by_Global__c = UserInfo.getUserId();
                           finUpdate.Last_Saved_Global__c = System.now(); 
                           finUpdate.Status_Global__c = IPM_ConstantUtils.STATUS_IN_PROGRESS;
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
                        }
                        if(pspan == IPM_ConstantUtils.Regional && (projectType != IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL || projectType != IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)){
                           finUpdate.NPV_Regional__c = SetFieldValues(NPV);
                           finUpdate.IRR_Regional__c = SetFieldValues(IRR);
                           finUpdate.Payback_Regional__c = SetFieldValues(payback);
                           finUpdate.CAPEX_Regional__c = SetFieldValues(capex);
                           finUpdate.BIC_Regional__c = SetFieldValues(BIC);
                           finUpdate.Volume_Unit_Regional__c = volumeUnit;
<<<<<<< HEAD
=======
                           finUpdate.Last_Saved_by_Regional__c = UserInfo.getUserId();
                           finUpdate.Last_Saved_Regional__c = System.now();
                           finUpdate.Status_Regional__c = IPM_ConstantUtils.STATUS_IN_PROGRESS;
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
                        } 
                         if(pspan == IPM_ConstantUtils.Local && (projectType != IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL || projectType != IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)){
                            finUpdate.NPV_Local__c = SetFieldValues(NPV);
                            finUpdate.IRR_Local__c = SetFieldValues(IRR);
                            finUpdate.Payback_Local__c = SetFieldValues(payback);
                            finUpdate.CAPEX_Local__c = SetFieldValues(capex);
                            finUpdate.BIC_Local__c = SetFieldValues(BIC);
                            finUpdate.Volume_Unit_Local__c = volumeUnit;
<<<<<<< HEAD
=======
                            finUpdate.Last_Saved_by_Local__c = UserInfo.getUserId();
                            finUpdate.Last_Saved_Local__c = System.now();
                            finUpdate.Status_Local__c = IPM_ConstantUtils.STATUS_IN_PROGRESS;
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
                        }
                        finUpdate.Status__c = IPM_ConstantUtils.STATUS_IN_PROGRESS;                                              
                        update finUpdate;
                        return null;
                }
            }catch(JSONException ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ConstantUtils.ClassCopyPaste,
               'getFinancialyear',ex.getMessage(),ex, IPM_ConstantUtils.ERROR,
                null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
                ApexPages.Message ErrorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.IPM_PLEASE_CONTACT_ADMINISTRATOR);
                ApexPages.addMessage(ErrorMsg);
        } 
                return null;
        }
           
    /************************************************************************************************************************************
    *  @Description: Sets the map value by appending all the rows to a specific col, which is nothing but a financial year record data.
    *  @name : setMapValues
    *  @param : rowcol, selectedMCO and pspan.
    *  @return: String.
    *************************************************************************************************************************************/ 
    public static String SetMapValues(String inputStr, String value, Integer row){      
        return (inputStr == IPM_ConstantUtils.NullString) ? row+IPM_ConstantUtils.Colon+value : 
        inputStr+IPM_ConstantUtils.Comma+row+IPM_ConstantUtils.Colon+value;
    }
    
        
    /**************************************************************************************************************************************
    *  @Description: Updates Financial Years records based on the param passed.
    *  @name : updateFinancialYear
    *  @param : mapfields, FinID and pspan.
    *  @return: void.
    ***************************************************************************************************************************************/    
    public static void UpdateFinancialYear(map<String,String> mapfields , String finID, String pspan, String projectType){
        try{
                        String valueMarketShare;
                        String vol;
                        String turnover;
                        String grossProfit ;
                        String advertisingPromotions;
                        String profitBeforeOverheads;
                        list<IPM_Financial_Year__c> updateFinancialyears = new list<IPM_Financial_Year__c>();
                        list<String> fieldList = new list<String>();                 
                        for(IPM_Financial_Year__c fy : [Select NameYearPLtype__c, Year__c, Year_Type__c, Volume_Unit_Regional__c, Volume_Unit_Local__c, Volume_Unit_Global__c, Volume_Tons_Regional__c, 
                        Volume_Tons_Local__c, Volume_Tons_Global__c, Volume_Regional__c, Volume_Local__c, Volume_Global__c, Value_Market_Share_Regional__c,
                        Value_Market_Share_Local__c, Value_Market_Share_Global__c, Turnover_Regional__c, Turnover_Local__c, Turnover_Global__c, 
                        Profit_Before_Overheads_Regional__c, Profit_Before_Overheads_Local__c, Profit_Before_Overheads_Global__c, PL_Type__c, 
                        PBO_of_TO_Regional__c, PBO_of_TO_Local__c, PBO_of_TO_Global__c, Name, Id, IPM_Financial__c, Gross_Profit_Regional__c, 
                        Gross_Profit_Local__c, Gross_Profit_Global__c, GM_of_TO_Regional__c, GM_of_TO_Local__c, GM_of_TO_Global__c, 
                        Advertising_Promotions_Regional__c, Advertising_Promotions_Local__c, Advertising_Promotions_Global__c, AP_of_TO_Regional__c, 
                        AP_of_TO_Local__c, AP_of_TO_Global__c From IPM_Financial_Year__c where IPM_Financial__c =: FinID limit: IPM_ConstantUtils.QueryLimt]){
                                valueMarketShare = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                                vol = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                                turnover = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                                grossProfit  = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                                advertisingPromotions = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                                profitBeforeOverheads = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
                                if(mapfields.containskey(fy.NameYearPLtype__c)){
                                         fieldList = mapfields.get(fy.NameYearPLtype__c).split(IPM_ConstantUtils.Comma);
                                         for(String field : fieldList){ 
                                                if(IPM_ConstantUtils.rowValue1 == field.split(IPM_ConstantUtils.Colon)[0] || IPM_ConstantUtils.rowValue28 == field.split(IPM_ConstantUtils.Colon)[0]){
                                                        valueMarketShare = setRowValuestoField(field);
                                                }
                                                if(IPM_ConstantUtils.rowValue4 == field.split(IPM_ConstantUtils.Colon)[0] || IPM_ConstantUtils.rowValue31 == field.split(IPM_ConstantUtils.Colon)[0]){
                                                        vol = setRowValuestoField(field);
                                                }
                                                if(IPM_ConstantUtils.rowValue6 == field.split(IPM_ConstantUtils.Colon)[0] || IPM_ConstantUtils.rowValue33 == field.split(IPM_ConstantUtils.Colon)[0]){
                                                        turnover = setRowValuestoField(field);
                                                }
                                                if(IPM_ConstantUtils.rowValue8 == field.split(IPM_ConstantUtils.Colon)[0] || IPM_ConstantUtils.rowValue35 == field.split(IPM_ConstantUtils.Colon)[0]){
                                                        grossProfit  = setRowValuestoField(field);
                                                }               
                                                if(IPM_ConstantUtils.rowValue9 == field.split(IPM_ConstantUtils.Colon)[0] || IPM_ConstantUtils.rowValue36 == field.split(IPM_ConstantUtils.Colon)[0]){ 
                                                        advertisingPromotions = setRowValuestoField(field);                        
                                                }  
                                                if(IPM_ConstantUtils.rowValue10 == field.split(IPM_ConstantUtils.Colon)[0] || IPM_ConstantUtils.rowValue37 == field.split(IPM_ConstantUtils.Colon)[0]){                           
                                                        profitBeforeOverheads = setRowValuestoField(field);                       
                                                }   
                                        }
                                       if(pspan == IPM_ConstantUtils.SpanGlobal || projectType == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL || projectType == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL){
                                                fy.Value_Market_Share_Global__c = setFieldValues(valueMarketShare);
                                                fy.Turnover_Global__c = setFieldValues(turnover);
                                                fy.Gross_Profit_Global__c = setFieldValues(grossProfit );
                                                fy.Advertising_Promotions_Global__c = setFieldValues(advertisingPromotions);
                                                fy.Profit_Before_Overheads_Global__c = setFieldValues(profitBeforeOverheads);
                                                fy = assignVolumevaluesGlobal(mapfields,fy,vol);
                                        }

                                        if(pspan == IPM_ConstantUtils.Regional && (projectType != IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL || projectType != IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)){ 
                                                fy.Value_Market_Share_Regional__c = setFieldValues(valueMarketShare);
                                                fy.Turnover_Regional__c = setFieldValues(turnover);
                                                fy.Gross_Profit_Regional__c = setFieldValues(grossProfit );
                                                fy.Advertising_Promotions_Regional__c = setFieldValues(advertisingPromotions);
                                                fy.Profit_Before_Overheads_Regional__c = setFieldValues(profitBeforeOverheads);
                                                fy = assignVolumevaluesRegional(mapfields,fy,vol);
                                                
                                                
                                        }
                                        if(pspan == IPM_ConstantUtils.Local && (projectType != IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL || projectType != IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)){
                                                fy.Value_Market_Share_Local__c = setFieldValues(valueMarketShare);
                                                fy.Turnover_Local__c = setFieldValues(turnover);
                                                fy.Gross_Profit_Local__c = setFieldValues(grossProfit );
                                                fy.Advertising_Promotions_Local__c = setFieldValues(advertisingPromotions);
                                                fy.Profit_Before_Overheads_Local__c = setFieldValues(profitBeforeOverheads);
                                                fy = assignVolumevaluesLocal(mapfields,fy,vol);
                                        }
                                        UpdateFinancialyears.add(fy);  
                                                                             
                                }
                        }
                         if(!UpdateFinancialyears.isEmpty()){
                                Database.update(UpdateFinancialyears, true);
                                
                         }
                         if(Test.isRunningTest()) {
                          // Cause DMLException
                          update new IPM_Financial_Year__c();
                        }
        }catch(DmlException ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ConstantUtils.ClassCopyPaste,
               'updateFinancialYear',ex.getMessage(),ex, IPM_ConstantUtils.ERROR,
                null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
                ApexPages.Message ErrorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.IPM_PLEASE_CONTACT_ADMINISTRATOR);
                ApexPages.addMessage(ErrorMsg); 
               
        }
        
        }
        
    /***************************************************************************************************************
    *  @Description: sets the field values of the financial year record..
    *  @name : setFieldValues
    *  @param : input String.
    *  @return: Decimal Value.
    ***************************************************************************************************************/ 
        public static Decimal SetFieldValues(String inputStr){
            return (inputStr == IPM_ConstantUtils.EMPTY_STRING_INITIAL) ? IPM_ConstantUtils.intialVal : decimal.valueOf(inputStr);
        }
    
    /***************************************************************************************************************
    *  @Description: Prepares the records value based on row.. ..
    *  @name : setFieldValues
    *  @param : input String.
    *  @return: String Value.
    ***************************************************************************************************************/
    public static String SetRowValuesToField(String field){
        list<String> rowValue =  field.split(IPM_ConstantUtils.Colon);
        integer GetValue = 0; 
        String fieldValue = '';
        for(String val : rowValue){
                GetValue++;
                if(GetValue == IPM_ConstantUtils.CntField) {
                  fieldValue = val;
				 }
        } 
        return fieldValue;
    }
    /***************************************************************************************************************
    *  @Description: Prepares the records value based on row.. ..
    *  @name : assignVolumevaluesGlobal
    *  @param : mapfields, financial years, volume-- value to be updated.
    *  @return: financial years financial year instance.
    ***************************************************************************************************************/
    
        public static IPM_Financial_Year__c AssignVolumeValuesGlobal(map<String,String> mapfields, IPM_Financial_Year__c fy, String vol){
                
                        if(mapfields.containskey(IPM_ConstantUtils.Volume)){
                                fy.Volume_Unit_Global__c   = mapfields.get(IPM_ConstantUtils.Volume);
                        }    
                         if(fy.Volume_Unit_Global__c == IPM_ConstantUtils.TotalTons){
                                fy.Volume_tons_Global__c = setFieldValues(vol);
                        }
                         if(fy.Volume_Unit_Global__c == IPM_ConstantUtils.TotalTons0){
                                fy.Volume_Global__c = setFieldValues(vol);
                        }		    
                                    
                return fy;
        }
    /***************************************************************************************************************
    *  @Description: Prepares the records value based on row.. ..
    *  @name : assignVolumevaluesRegional
    *  @param : mapfields, financial years, volume-- value to be updated.
    *  @return: financial years financial year instance.
    ***************************************************************************************************************/
    
        public static IPM_Financial_Year__c AssignVolumeValuesRegional(map<String,String> mapfields, IPM_Financial_Year__c fy, String vol){
                        if(mapfields.containskey(IPM_ConstantUtils.Volume)){
                                fy.Volume_Unit_Regional__c   = mapfields.get(IPM_ConstantUtils.Volume);
                        }	
                        if(fy.Volume_Unit_Regional__c == IPM_ConstantUtils.TotalTons){
                                fy.Volume_Tons_Regional__c = setFieldValues(vol);
                        }
                         if(fy.Volume_Unit_Regional__c == IPM_ConstantUtils.TotalTons0){
                                fy.Volume_Regional__c = setFieldValues(vol);
                        }	    
                        
                return fy;
        }
    /***************************************************************************************************************
    *  @Description: Prepares the records value based on row.. ..
    *  @name : assignVolumevaluesLocal
    *  @param : mapfields, financial years, volume-- value to be updated.
    *  @return: financial years financial year instance.
    ***************************************************************************************************************/
    
        public static IPM_Financial_Year__c AssignVolumeValuesLocal(map<String,String> mapfields, IPM_Financial_Year__c fy, String vol){
                         if(mapfields.containskey(IPM_ConstantUtils.Volume)){
                                fy.Volume_Unit_Local__c = mapfields.get(IPM_ConstantUtils.Volume);
                        }	
                        if(fy.Volume_Unit_Local__c == IPM_ConstantUtils.TotalTons){
                                fy.Volume_Tons_Local__c = setFieldValues(vol);
                        }
                        if(fy.Volume_Unit_Local__c == IPM_ConstantUtils.TotalTons0){
                                fy.Volume_Local__c = setFieldValues(vol);
                        }	       
                
                return fy;
        }
        
    /***************************************************************************************************************
    *  @Description: this method is called on click of the submit button on the page.
    *  @name : submit
    *  @param : none.
    *  @return: Pagereference.
     ***************************************************************************************************************/    
   public PageReference Submit() {
       SelectedCountry = ListCountries;
       if(SelectedCountry != IPM_ConstantUtils.EMPTY_STRING_INITIAL){
                    for(Integer i=IPM_ConstantUtils.intialVal; i < options.size(); i++) {                          
                               if(SelectedCountry== options.get(i).getValue()){
                                               submittedList.add(options.get(i).getLabel());
                                               showdata = true;
                                               options.remove(i); 
                                    }
                     }
       }
       
       if(options.isEmpty()){
              flag = true;
           }
        return null;
    }
    
 
    /****************************************************************************************************************
    *  @Description: this method is called on click of the Go Back button on the page, which will navigate to the parent page.
    *  @name : goBack
    *  @param : none.
    *  @return: Pagereference.
     ***************************************************************************************************************/
    public PageReference GoBack() {
        try{
                PageReference templatePage = Page.IPM_Financial;
                templatePage.getParameters().put('id', projectId);
                templatePage.setRedirect(true);
                if(Test.isRunningTest()) {
                        // Cause Exception
                        IpmProject.Id = null;
                 }
                return templatePage;
        }catch(Exception ex){
              ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ConstantUtils.ClassCopyPaste,
               'goBack',ex.getMessage(),ex, IPM_ConstantUtils.ERROR,
                null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
                ApexPages.Message ErrorMsg = new ApexPages.Message(ApexPages.Severity.Info, Label.IPM_PLEASE_CONTACT_ADMINISTRATOR);
                ApexPages.addMessage(ErrorMsg);
        }
            return null;        
    }
   
  }