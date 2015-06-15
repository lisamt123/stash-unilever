public without sharing class IPMFinancialController {

    public IPM_Project__c project {get; set;}
    
    public Integer sustainabilityPeriod {get; set;}
    public Integer colSpan {get; set;}
    public Boolean isEditMode {get; set;}
    public Boolean isError {get; set;}
    public Boolean isEditable{get;set;}
    public List<RolloutWrapper> lstRolloutWrappers {get; set;}
    public Map<String, IPM_Financial__c> mapConsolidatedFinancials {get; set;}

    public String currentFinancialId {get; set;}
    public String currentTab {get; set;}
    public IPM_Financial__c currentFinancial {get; set;}

    public Boolean showTopDownTab {get; set;}
    public Boolean showRollupTab {get; set;}
    
    public ipmFinancialWrapper financialsInnovation {get; set;}
    public ipmFinancialWrapper financialsCalendar {get; set;}

    public Map<String, IPM_Financial_Year__c> mapFinancialYears {get; set;}
    public String volumeUnit {get; set;}
    public String fieldSuffix {get; set;}
    
    public Boolean showMisalignment {get; set;}

    public String tabLabelMyView {get; set;}
    public String tabLabelTopDown {get; set;}
    public String tabLabelRollup {get; set;}
    
    public List<SelectOption> lstSustainabilityPeriod {get; set;}
    public String selectedSustainabilityPeriod {get; set;}

    public List<SelectOption> documentSections {get; set;}
    public String selectedDocumentSection {get; set;}
    
    private Map<String, IPM_Financial_Year__c> mapFinancialYearRecords;
    
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
    public ipmFinancialController() {
        //IE-9 Fix
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        
        String projectId = ApexPages.currentPage().getParameters().get('Id');
        currentTab = TAB_MYVIEW;
        isError = FALSE;
        sustainabilityPeriod=0;
        isEditable=false;
        getIpmuserType();
        if (projectId != NULL){
            project = [SELECT Id, IPM_Project_Name__c, Sustainability_Period__c, Sustainability_Period_Changed__c, IPMProject_Span__c, Market_Cluster__c, Market_Cluster_Name__c, IPM_Parent_Project__c, IPM_Parent_Project__r.Market_Cluster__c, IPM_Parent_Project__r.Market_Cluster_Name__c, IPM_Parent_Project__r.IPM_Parent_Project__c, IPM_Phase__c 
                        FROM IPM_Project__C 
                        WHERE Id=:projectId];
            try{
                getSectionList();
                getVisibleTabs();
                getSustainabilityPeriod();
                getRolloutWrappers();
                getFinancials();
                getMisalignmentVisibility();
                isEditMode = FALSE;
            } catch (Exception e){
                isError = TRUE;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 
                    'No Rollouts added. Please add atleast one rollout for this project'));
            }
        }
    }
    
    /* ------------------------------------------------------------------------------------------------------------------
      Name:         getVisibleTabs()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to get visible tabs
    --------------------------------------------------------------------------------------------------------------------- */
    private void getVisibleTabs(){
        //Global Project
        if (project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL){
            tabLabelMyView = 'TOP DOWN';
            tabLabelRollup = 'BOTTOM UP';
            
            showTopDownTab = FALSE;
            if (project.IPM_Phase__c == PROJECT_PHASE_IDEA)
                showRollupTab = FALSE;
            else
                showRollupTab = TRUE;
          system.debug(showRollupTab+'3 getting called');       
        } 
        //Regional Project
        else if (project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL){
            tabLabelMyView = 'MY VIEW';
            tabLabelTopDown = 'TOP DOWN';
            tabLabelRollup = 'LOCAL ROLLUP';
            
            showTopDownTab = TRUE;
            showRollupTab = TRUE;
        } 
        //Local Project
        else if (project.IPMProject_Span__c == PROJECT_SPAN_LOCAL){
            tabLabelMyView = 'MY VIEW';
            tabLabelTopDown = 'TOP DOWN';
            
            showTopDownTab = TRUE;
            showRollupTab = FALSE;
        }
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         getSectionList()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to get list of Document Sections for Finance Team
    --------------------------------------------------------------------------------------------------------------------- */
    private void getSectionList(){
        system.debug('------------------- ENTER SECTION LIST:');
        String currentStage;
        if(project.IPM_Phase__c == 'Ideas')
            currentStage = 'Charter';
        else if(project.IPM_Phase__c == 'Feasibility')
            currentStage = 'Contract';
        else if(project.IPM_Phase__c == 'Capability')
            currentStage = 'Market Ready';
        else if(project.IPM_Phase__c == 'Market Ready')
            currentStage = 'Market Deploy';

        List<IPM_Project_Document__c> lstCurrentDocuments = [SELECT Id, IPM_GateDocuments__c, 
                                                                (SELECT Id, IPM_Section_Sequence__c, IPM_Section_Name__c
                                                                    FROM IPM_Project_Sections__r
                                                                    WHERE (NOT IPM_Section_Type__c LIKE: '%Header%')
                                                                        AND IPM_FunctionalRole__c =: 'Finance'
                                                                        AND (NOT IPM_Section_Sequence__c LIKE: '8%')
                                                                    ORDER BY IPM_Section_Sequence__c)
                                                            FROM IPM_Project_Document__c
                                                            WHERE IPM_GateDocuments__c =: currentStage
                                                                AND IPM_Project__c =: project.Id 
                                                            LIMIT 1];

        documentSections = new List<SelectOption>();
        documentSections.add(new SelectOption('','Go to Document Section'));
        if(lstCurrentDocuments.size() > 0){
            For(IPM_Project_Document_Section__c documentSection : lstCurrentDocuments[0].IPM_Project_Sections__r)
                documentSections.add(new SelectOption(documentSection.Id, documentSection.IPM_Section_Sequence__c + ' ' + documentSection.IPM_Section_Name__c));
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
        sustainabilityPeriod = Integer.valueOf(project.Sustainability_Period__c);
        colSpan = (sustainabilityPeriod * 2) + 1;
        
        lstSustainabilityPeriod = new List<SelectOption>();
        lstSustainabilityPeriod.add(new SelectOption('','Select Sustainability Period'));
        lstSustainabilityPeriod.add(new SelectOption('3','3 Years'));
        lstSustainabilityPeriod.add(new SelectOption('5','5 Years'));
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         getRolloutWrappers()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to get Financials for multiple regions/mco's/countries for the appropriate project and 
                    update the side panel accordingly
    --------------------------------------------------------------------------------------------------------------------- */
    private void getRolloutWrappers(){
        getRolloutWrappers(NULL);
    }

    private void getRolloutWrappers(String statefulCurrentFinancialId){
        lstRolloutWrappers = new List<RolloutWrapper>();
        mapConsolidatedFinancials = new Map<String, IPM_Financial__c> ();
        currentFinancialId = NULL;
        
        getRecordtypes();

        system.debug('------------------- project.IPMProject_Span__c:' + project.IPMProject_Span__c);
        system.debug('------------------- currentTab:' + currentTab);

        //Global Project
        if (project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL){
            if (currentTab == TAB_MYVIEW)
                getGlobalMyViewWrappers();
            else if (currentTab == TAB_ROLLUP)
                getGlobalRollupWrappers();
            
        } 
        //Regional Project
        else if (project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL){
            if (currentTab == TAB_MYVIEW)
                getRegionalMyViewWrappers();
            else if (currentTab == TAB_TOPDOWN)
                getRegionalTopDownWrappers();
            else if (currentTab == TAB_ROLLUP)
                getRegionalRollupWrappers();
            
        } 

        //Local Project
        else if (project.IPMProject_Span__c == PROJECT_SPAN_LOCAL){
            if (currentTab == TAB_MYVIEW)
                getLocalMyViewWrappers();
            else if (currentTab == TAB_TOPDOWN)
                getLocalMyViewWrappers();
        }
        
        if(statefulCurrentFinancialId != NULL)
            currentFinancialId = statefulCurrentFinancialId;
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
    
    //Rollout Wrappers for Global My View Tab
    private void getGlobalMyViewWrappers(){
        //Rollout Wrappers
        For (IPM_Project_Rollout__c regionalRollout : [SELECT Id, Market_Cluster_Name__c, 
                                                        (SELECT Id, Name, Financial_External_ID__c, Status__c
                                                            FROM IPM_Financials__r
                                                            WHERE RecordTypeId =: DEFAULT_FINANCIAL_RECORDTYPE
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c)
                                                        FROM IPM_Project_Rollout__c
                                                        WHERE IPM_Project__c =: project.Id
                                                            AND RecordTypeId =: REGIONAL_ROLLOUT_RECORDTYPE]){

            lstRolloutWrappers.add(
                new RolloutWrapper(
                    regionalRollout.Market_Cluster_Name__c, 
                    regionalRollout.IPM_Financials__r
                )
            );
            
            For (IPM_Financial__c financial : regionalRollout.IPM_Financials__r){
                If ((currentFinancialId == NULL) || (currentFinancialId == ''))
                    currentFinancialId = financial.Id;
            }
        }

        For(IPM_Financial__c ipmFinancial : [SELECT Id, Name, Financial_External_ID__c, Status__c, IPM_Project_Rollout__c, IPM_Project_Rollout__r.Market_Cluster_Name__c
                                                 FROM IPM_Financial__c
                                                 WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE
                                                     AND Parent_Project__c =: project.Id]){
            IF(ipmFinancial.IPM_Project_Rollout__c == NULL)
                mapConsolidatedFinancials.put(PROJECT_SPAN_GLOBAL, ipmFinancial);
            else
                mapConsolidatedFinancials.put(ipmFinancial.IPM_Project_Rollout__r.Market_Cluster_Name__c, ipmFinancial);
        }
        
    }

    //Rollout Wrappers for Global Rollup Tab
    private void getGlobalRollupWrappers(){
        //Rollout Wrappers
        For (IPM_Project__c regionalProject : [SELECT Id, Market_Cluster_Name__c, 
                                                    (SELECT Id, Financial_External_Id__c, Status__c 
                                                        FROM IPM_Financials_Regional__r
                                                        WHERE RecordTypeId =: DEFAULT_FINANCIAL_RECORDTYPE 
                                                        ORDER BY Sorting_Order__c, Financial_External_Id__c)
                                                    FROM IPM_Project__c
                                                    WHERE IPM_Parent_Project__c =: project.Id]){
            lstRolloutWrappers.add(
                new RolloutWrapper(
                    regionalProject.Market_Cluster_Name__c, 
                    regionalProject.IPM_Financials_Regional__r
                )
            );
            
            For (IPM_Financial__c financial : regionalProject.IPM_Financials_Regional__r){
                If ((currentFinancialId == NULL) || (currentFinancialId == ''))
                    currentFinancialId = financial.Id;
            }
        }
        
        For(IPM_Financial__c ipmFinancial : [SELECT Id, Name, Financial_External_ID__c, Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c
                                                 FROM IPM_Financial__c
                                                 WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE
                                                     AND Parent_Project__c =: project.Id]){
            IF(ipmFinancial.Regional_Project__c == NULL)
                mapConsolidatedFinancials.put(PROJECT_SPAN_GLOBAL, ipmFinancial);
            else
                mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);
        }
    }
    
    //Rollout Wrappers for Regional My View Tab
    private void getRegionalMyViewWrappers(){
        List<IPM_Financial__c> lstRegionalFinancials = [SELECT Id, Name, Financial_External_ID__c, Status__c
                                                            FROM IPM_Financial__c
                                                            WHERE Regional_Project__c =: project.Id
                                                                AND RecordTypeId =: DEFAULT_FINANCIAL_RECORDTYPE 
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c];
                                                           
        lstRolloutWrappers.add(
            new RolloutWrapper(
                project.Market_Cluster_Name__c, 
                lstRegionalFinancials
            )
        );

        For (IPM_Financial__c financial : lstRegionalFinancials){
            If ((currentFinancialId == NULL) || (currentFinancialId == ''))
                currentFinancialId = financial.Id;
        }

        For(IPM_Financial__c ipmFinancial : [SELECT Id, Name, Financial_External_ID__c, Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c
                                                 FROM IPM_Financial__c
                                                 WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE
                                                     AND Parent_Project__c =: project.IPM_Parent_Project__c]){
            IF(ipmFinancial.Regional_Project__c == NULL)
                mapConsolidatedFinancials.put(PROJECT_SPAN_GLOBAL, ipmFinancial);
            else
                mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);
        }
    }

    //Rollout Wrappers for Regional Top Down Tab
    private void getRegionalTopDownWrappers(){
        IPM_Project_Rollout__c regionalRollout = [SELECT Id, Market_Cluster_Name__c, 
                                                        (SELECT Id, Name, Financial_External_ID__c, Status__c
                                                            FROM IPM_Financials__r
                                                            WHERE RecordtypeId =: DEFAULT_FINANCIAL_RECORDTYPE
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c)
                                                        FROM IPM_Project_Rollout__c
                                                        WHERE IPM_Project__c =: project.IPM_Parent_Project__c
                                                            AND RecordTypeId =: REGIONAL_ROLLOUT_RECORDTYPE
                                                            AND Market_Cluster__c =: project.Market_Cluster__c];

        lstRolloutWrappers.add(
            new RolloutWrapper(
                regionalRollout.Market_Cluster_Name__c, 
                regionalRollout.IPM_Financials__r
            )
        );
        
        For (IPM_Financial__c financial : regionalRollout.IPM_Financials__r){
            If ((currentFinancialId == NULL) || (currentFinancialId == ''))
                currentFinancialId = financial.Id;
        }

        For(IPM_Financial__c ipmFinancial : [SELECT Id, Name, Financial_External_ID__c, Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c
                                                 FROM IPM_Financial__c
                                                 WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE
                                                     AND Parent_Project__c =: project.IPM_Parent_Project__c]){
            IF(ipmFinancial.Regional_Project__c == NULL)
                mapConsolidatedFinancials.put(PROJECT_SPAN_GLOBAL, ipmFinancial);
            else
                mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);
        }
    }

    //Rollout Wrappers for Regional Rollup Tab
    private void getRegionalRollupWrappers(){
        List<IPM_Financial__c> lstRegionalFinancials = [SELECT Id, Name, Financial_External_ID__c, Status__c
                                                            FROM IPM_Financial__c
                                                            WHERE Regional_Project__c =: project.Id
                                                                AND RecordTypeId =: DEFAULT_FINANCIAL_RECORDTYPE
                                                                AND (NOT Financial_External_ID__c LIKE: '%NONKEY')
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c];
                                                           
        lstRolloutWrappers.add(
            new RolloutWrapper(
                project.Market_Cluster_Name__c, 
                lstRegionalFinancials
            )
        );

        For (IPM_Financial__c financial : lstRegionalFinancials){
            If ((currentFinancialId == NULL) || (currentFinancialId == ''))
                currentFinancialId = financial.Id;
        }

        For(IPM_Financial__c ipmFinancial : [SELECT Id, Name, Financial_External_ID__c, Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c
                                                 FROM IPM_Financial__c
                                                 WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE
                                                     AND Parent_Project__c =: project.IPM_Parent_Project__c]){
            IF(ipmFinancial.Regional_Project__c == NULL)
                mapConsolidatedFinancials.put(PROJECT_SPAN_GLOBAL, ipmFinancial);
            else
                mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);
        }
    }

    //Rollout Wrappers for Local My View & Top Down
    private void getLocalMyViewWrappers(){
        system.debug('------------------- ENTER:' );
        List<IPM_Financial__c> lstLocalFinancials = [SELECT Id, Name, Financial_External_ID__c, Status__c
                                                            FROM IPM_Financial__c
                                                            WHERE Local_Project__c =: project.Id
                                                                AND RecordtypeId =: DEFAULT_FINANCIAL_RECORDTYPE
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c];
                                                            
        system.debug('------------------- lstLocalFinancials:' + lstLocalFinancials);
        
        lstRolloutWrappers.add(
            new RolloutWrapper(
                project.IPM_Parent_Project__r.Market_Cluster_Name__c, 
                lstLocalFinancials
            )
        );

        For (IPM_Financial__c financial : lstLocalFinancials){
            If ((currentFinancialId == NULL) || (currentFinancialId == ''))
                currentFinancialId = financial.Id;
        }

        For(IPM_Financial__c ipmFinancial : [SELECT Id, Name, Financial_External_ID__c, Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c
                                                 FROM IPM_Financial__c
                                                 WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE
                                                     AND Parent_Project__c =: project.IPM_Parent_Project__r.IPM_Parent_Project__c]){
            IF(ipmFinancial.Regional_Project__c == NULL)
                mapConsolidatedFinancials.put(PROJECT_SPAN_GLOBAL, ipmFinancial);
            else
                mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);
        }
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         getFinancials()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to get Financials for currently selected Financial
    --------------------------------------------------------------------------------------------------------------------- */
    private void getFinancials(){
        fieldSuffix = getFieldSuffix();
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
        queryString+= 'FROM IPM_Financial__c WHERE Id =: currentFinancialId';
        
        currentFinancial = Database.query(queryString);
        mapFinancialYears = new Map<String, IPM_Financial_Year__c>();
        if (currentFinancial != NULL){
            financialsInnovation = new ipmFinancialWrapper();
            financialsCalendar = new ipmFinancialWrapper();
            
            volumeUnit = (String) currentFinancial.get('Volume_Unit_' + fieldSuffix + '__c');

            For (IPM_Financial_Year__c finYear : currentFinancial.IPM_Financial_Years__r){
                //Add to Map
                mapFinancialYears.put(generateMapKey(finYear.Year_Type__c, finYear.Year__c, finYear.PL_Type__c), finYear);
                
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
             system.debug(finYear+'17 getting called'); 
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
      Name:         getMisalignmentVisibility()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to set is the misalignment should be visible on tabs
    --------------------------------------------------------------------------------------------------------------------- */
    private void getMisalignmentVisibility(){
        showMisalignment = FALSE;
        if (project.IPMProject_Span__c != PROJECT_SPAN_GLOBAL && currentTab == TAB_MYVIEW)
            showMisalignment = TRUE;
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         downloadTemplate()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to refresh the financials for the same tab
    --------------------------------------------------------------------------------------------------------------------- */
    public PageReference uploadDownloadTemplate(){
        PageReference templatePage = Page.ipmFinancialUpload;
        templatePage.getParameters().put('id', project.Id);
        templatePage.setRedirect(true);
        return templatePage;
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         goToSection()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to refresh the financials for the same tab
    --------------------------------------------------------------------------------------------------------------------- */
    public PageReference goToSection(){
        PageReference sectionPage = Page.ipmProjectDocumentSectionEditorV1;
        sectionPage.getParameters().put('id', project.Id);
        sectionPage.getParameters().put('projDocSecId', selectedDocumentSection);
        sectionPage.setRedirect(true);
        return sectionPage;
        //Go to Page
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         changeSustainabilityPeriod()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to change Sustainability Period for the project
    --------------------------------------------------------------------------------------------------------------------- */
    public void changeSustainabilityPeriod(){
        project.Sustainability_Period__c = selectedSustainabilityPeriod;
        project.Sustainability_Period_Changed__c = TRUE;
        Database.update(project);

        getSustainabilityPeriod();
        getFinancials();
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         refreshFinancials()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to refresh the financials for the same tab
    --------------------------------------------------------------------------------------------------------------------- */
    public void refreshFinancials(){
        getFinancials();
        isEditMode = FALSE;
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         changeTabs()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to refresh the financials for tab change
    --------------------------------------------------------------------------------------------------------------------- */
    public void changeTabs(){
        getRolloutWrappers();
        getFinancials();
        getMisalignmentVisibility();
        isEditMode = FALSE;
    }
    
    /* ------------------------------------------------------------------------------------------------------------------
      Name:         editFinancials()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to edit the current Financials
    --------------------------------------------------------------------------------------------------------------------- */
    public void editFinancials() {
        isEditMode = true;
    }
    
    /* ------------------------------------------------------------------------------------------------------------------
      Name:         saveFinancials()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to edit the current Financials
    --------------------------------------------------------------------------------------------------------------------- */
    public void saveFinancials() {
        isEditMode = false;
        //DO NOT CHANGE the order - Calendar years need to be saved first before Innovation Years to ensure Volume Units get saved appropriately
        saveFinancialRecords(financialsCalendar, YEAR_TYPE_CALENDAR);
        saveFinancialRecords(financialsInnovation, YEAR_TYPE_INNOVATION);
        getRolloutWrappers(currentFinancialId);
        getFinancials();
    }
    
    private void saveFinancialRecords(ipmFinancialWrapper finWrapper, String yearType){
        List<IPM_Financial_Year__c> lstUpdateFinancials = new List<IPM_Financial_Year__c>();
        mapFinancialYearRecords = new Map<String, IPM_Financial_Year__c>();
        
        //Year 0
        IPM_Financial_Year__c y0FinancialYear = mapFinancialYears.get(generateMapKey(yearType, Y0_YEARINDEX, null));
        
        y0FinancialYear.put('Value_Market_Share_' + fieldSuffix + '__c', finWrapper.y0ValueMarketShare);
        y0FinancialYear.put('Volume_' + fieldSuffix + '__c', finWrapper.y0Volume);
        y0FinancialYear.put('Turnover_' + fieldSuffix + '__c', finWrapper.y0Turnover);
        y0FinancialYear.put('Gross_Profit_' + fieldSuffix + '__c', finWrapper.y0GrossProfit);
        y0FinancialYear.put('Advertising_Promotions_' + fieldSuffix + '__c', finWrapper.y0Advertising);
        y0FinancialYear.put('Profit_Before_Overheads_' + fieldSuffix + '__c', finWrapper.y0Profit);

        lstUpdateFinancials.add(y0FinancialYear);
        
        //GROSS P&L
        processFinancialYearRecords(finWrapper.lstGrossPLValueMarketShare, yearType, PL_TYPE_GROSS, 'Value_Market_Share_' + fieldSuffix + '__c');
        processFinancialYearRecords(finWrapper.lstGrossPLVolume, yearType, PL_TYPE_GROSS, 'Volume_' + fieldSuffix + '__c');
        processFinancialYearRecords(finWrapper.lstGrossPLTurnover, yearType, PL_TYPE_GROSS, 'Turnover_' + fieldSuffix + '__c');
        processFinancialYearRecords(finWrapper.lstGrossPLGrossProfit, yearType, PL_TYPE_GROSS, 'Gross_Profit_' + fieldSuffix + '__c');
        processFinancialYearRecords(finWrapper.lstGrossPLAdvertising, yearType, PL_TYPE_GROSS, 'Advertising_Promotions_' + fieldSuffix + '__c');
        processFinancialYearRecords(finWrapper.lstGrossPLProfit, yearType, PL_TYPE_GROSS, 'Profit_Before_Overheads_' + fieldSuffix + '__c');

        //INCREMENTAL P&L
        processFinancialYearRecords(finWrapper.lstIncrementalPLValueMarketShare, yearType, PL_TYPE_INCREMENTAL, 'Value_Market_Share_' + fieldSuffix + '__c');
        processFinancialYearRecords(finWrapper.lstIncrementalPLVolume, yearType, PL_TYPE_INCREMENTAL, 'Volume_' + fieldSuffix + '__c');
        processFinancialYearRecords(finWrapper.lstIncrementalPLTurnover, yearType, PL_TYPE_INCREMENTAL, 'Turnover_' + fieldSuffix + '__c');
        processFinancialYearRecords(finWrapper.lstIncrementalPLGrossProfit, yearType, PL_TYPE_INCREMENTAL, 'Gross_Profit_' + fieldSuffix + '__c');
        processFinancialYearRecords(finWrapper.lstIncrementalPLAdvertising, yearType, PL_TYPE_INCREMENTAL, 'Advertising_Promotions_' + fieldSuffix + '__c');
        processFinancialYearRecords(finWrapper.lstIncrementalPLProfit, yearType, PL_TYPE_INCREMENTAL, 'Profit_Before_Overheads_' + fieldSuffix + '__c');

        //Add all the objects
        if (mapFinancialYearRecords.size()>0){
            For(IPM_Financial_Year__c obj : mapFinancialYearRecords.values())
                lstUpdateFinancials.add(obj);
        }
        
        //Update Financial Year Records
        if (lstUpdateFinancials.size() > 0)
            update lstUpdateFinancials;
        
        currentFinancial.Status__c = 'In Progress';
        currentFinancial.put('Last_Saved_' + fieldSuffix + '__c', System.now());
        currentFinancial.put('Last_Saved_By_' + fieldSuffix + '__c', UserInfo.getUserId());
        
        Database.update(currentFinancial);
    }

    private void processFinancialYearRecords(List<ipmFinancialValueWrapper> lstValueWrapper, String yearType, String plType, String fieldName){
        For(ipmFinancialValueWrapper valueWrapper : lstValueWrapper){
            IPM_Financial_Year__c fyRecord = mapFinancialYears.get(generateMapKey(yearType, '' + valueWrapper.index, plType));
            String recordId = fyRecord.Id;
            If (mapFinancialYearRecords.containsKey(recordId))
                fyRecord = mapFinancialYearRecords.get(recordId);
            else
                mapFinancialYearRecords.put(recordId, fyRecord);
            
            fyRecord.put(fieldName, valueWrapper.value);
        }
    }
    
    /* ------------------------------------------------------------------------------------------------------------------
      Name:         refreshFromLocal()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to refresh the financial numbers from Local Rollout
    --------------------------------------------------------------------------------------------------------------------- */
    public void refreshFromLocal() {
        currentFinancial.Copy_Local_to_Regional__c = true;
        Database.update(currentFinancial);
        getFinancials();
    }

    /* ------------------------------------------------------------------------------------------------------------------
      Name:         refreshFromLocal()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to refresh the financial numbers from Regional Rollout
    --------------------------------------------------------------------------------------------------------------------- */
    public void refreshFromRegional() {
        currentFinancial.Copy_Regional_to_Local__c = true;
        Database.update(currentFinancial);
        getFinancials();
    }
    
    /* ------------------------------------------------------------------------------------------------------------------
      Name:         getFieldSuffix()
      Type:         METHOD
      Parameters:   NONE
      Description:  Used to generate the suffix to be used in referencing appropriate fields on the Financial 
                    and Financial Year object
    --------------------------------------------------------------------------------------------------------------------- */
    private String getFieldSuffix(){
        //Global Project
        if (project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL){
            //My View
            system.debug(currentTab+'21 getting called'); 
            if (currentTab == TAB_MYVIEW)
            {
                system.debug(currentTab+'22 getting called'); 
                return PROJECT_SPAN_GLOBAL;
            }   
            else if (currentTab == TAB_ROLLUP)
            {
                system.debug(currentTab+'23 getting called'); 
                return PROJECT_SPAN_REGIONAL;
            }   
        } 
        //Regional Project
        else if (project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL){
            if (currentTab == TAB_MYVIEW)
                return PROJECT_SPAN_REGIONAL;
            else if (currentTab == TAB_TOPDOWN)
                return PROJECT_SPAN_GLOBAL;
            else if (currentTab == TAB_ROLLUP)
                return PROJECT_SPAN_LOCAL;
        } 
        //Local Project
        else if (project.IPMProject_Span__c == PROJECT_SPAN_LOCAL){
            if (currentTab == TAB_MYVIEW)
                return PROJECT_SPAN_LOCAL;
            else if (currentTab == TAB_TOPDOWN)
                return PROJECT_SPAN_REGIONAL;
        }
        return null;
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
    
    /* ------------------------------------------------------------------------------------------------------------------
      Name:         RolloutWrapper()
      Type:         CLASS
      Description:  Used to wrap region and financials together. Used wrapper instead of standard object (Rollout) 
                    because for regional & local projects the concerned object is IPM_Project__c and not 
                    IPM_Project_Rollout__c
    --------------------------------------------------------------------------------------------------------------------- */
    public class RolloutWrapper{
        public String regionName {get; set;}
        public List<IPM_Financial__c> lstFinancials {get; set;}
        
        public RolloutWrapper(String regionName, List<IPM_Financial__c> lstFinancials){
            this.regionName = regionName;
            this.lstFinancials = lstFinancials;
        }
    }
    
    //Get user type
    public void getIpmuserType(){
    String projectId = ApexPages.currentPage().getParameters().get('Id');
    list<IPM_Project_Resource__c>lstProuser=[select IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c from IPM_Project_Resource__c where 
                                             IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() and IPM_Role_Type__c='Finance'  limit 1];
    if(lstProuser.size()>0){
     isEditable=true;   
    } 
    list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c,Deputy_Project_Leader__c from IPM_Project__c where 
                                            (IPM_Project_Leader__c=:userinfo.getuserid() or Deputy_Project_Leader__c=:userinfo.getuserid()) and  id=:projectId limit 1];
    if(lstofuser.size()>0){
        isEditable=true;
        }
    list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                            from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
     if(PermissonS.size()>0){
         isEditable=true;
     }   
                                         
    }           
}