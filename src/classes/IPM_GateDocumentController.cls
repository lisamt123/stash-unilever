/***********************************************************************************************************************************************************
* @author Cognizant
* @date  15/12/2014
* @description To Display Gate Document Sections
*/
public with sharing class IPM_GateDocumentController { 
    
    public String projectId{
        get{
            if(projectId == null && Apexpages.currentpage().getparameters().get('id') != null) {
                return  Id.valueOf(Apexpages.currentpage().getparameters().get('id')) ;
            }
            else { return projectId; }
        }
        set;
    }
    public String printDoc{
        get{
            if(printDoc == null && Apexpages.currentpage().getparameters().get('printDoc') != null) {
                return  Apexpages.currentpage().getparameters().get('printDoc');
            }
            else { return printDoc; }
        }
        set;
    }
    public string gateDocument{
        get{ return printDoc;}
    } //Contains Gate Document Type
    public IPM_Project__c project{get;set;}
    public List<IPM_Milestone__c> lstMstn;
    //String to replace duplicate string literals
    public static final String IPM_GATEDOCUMENTCONTR_STR = 'IPM_GateDocumentController';
    public static final String IPM_ANDFUNCTIONALROLE_STR = ' and (IPM_FunctionalRole__c=\'';
    public static final String IPM_ORFUNCTIONALROLE_STR =  ' OR IPM_FunctionalRole__c=\'';
    public static final String IPM_FUNCTIONALROLE_STR = '\' OR IPM_FunctionalRole__c=\'';
    //Variable Declarations
    public List<Attachment> summaryAttachmentList{get; set;} //Contains the summary side Attachments   
    public IPM_Country__c country {get; set;} //Contains country Record
    public IPM_Project_Document__c projectDoc {get; set;} //Contains Project Document Record     
    public transient List<IPM_Project_Document_Section__c> projSectionList {get; set;} //Contains All Header Project Document Sections 
    public List<IPM_Project_Document_Section__c> projDocSectionList {get; set;} //Contains All Project Document Sections Used for Gate Document PDF
    public transient List<IPM_Project_Document_Section__c> projDocAppdxSectionList {get; set;} //Contains All Project Document Sections Related to Appendix
    public Static Map<IPM_Project_Document_Section__c,Map<IPM_Project_Document_Section__c,List<IPM_Project_Document_Section__c>>> projSectionMap{get;set;}
    public String dueDate{get;set;}
    public Boolean DueDateMsg{get;set;}
    
    //Total filter counts
    public integer NonNegotiableCount{get;set;} //Contains Number of Non-Negotiable Sections
    public integer OptionalCount{get;set;} //Contains Number of Negotiable Sections
    public integer NotstartedCount{get;set;} //Contains Number of Status Not-Started Sections
    public integer FilledinCount{get;set;} //Contains Number of Status Filled-In Sections
    public integer ExcludedCount{get;set;}  //Contains Number of Status Excluded Sections
    public integer MKTGDEVCount{get;set;}  //Contains Number of Functional Role BD Sections
    public integer CMICount{get;set;}  //Contains Number of Functional Role CMI Sections
    public integer CDCount{get;set;}  //Contains Number of Functional Role CD Sections
    public integer RnDCount{get;set;}  //Contains Number of Functional Role R&D Sections
    public integer FinanceCount{get;set;}  //Contains Number of Functional Role Finance Sections
    public integer MKTGLOCALCount{get;set;} //Contains Number of Functional Role BB Sections
    public integer SCCount{get;set;} //Contains Number of Functional Role SC Sections
    public integer PLCount{get;set;}//Contains Number of Functional Role PL Sections
    
    //filled in percentage
    public decimal FilledinPer{get;set;} //Contains Filled-In Percentage of Project Document Sections
    
    //Number of Non-Negotiable & Negotiable Sections Header Wise
    public integer IntroNegotiable{get;set;} //Contains Number of Non-Negotiable Sections in Header Introduction
    public integer IntroOptional{get;set;} //Contains Number of Negotiable Sections in Header Introduction
    public integer ExterNegotiable{get;set;} //Contains Number of Non-Negotiable Sections in Header External
    public integer ExterOptional{get;set;} //Contains Number of Negotiable Sections in Header External
    public integer MixNegotiable{get;set;} //Contains Number of Non-Negotiable Sections in Header Mix
    public integer MixOptional{get;set;} //Contains Number of Negotiable Sections in Header Mix
    public integer DeploNegotiable{get;set;} //Contains Number of Non-Negotiable Sections in Header Deployment
    public integer DeploOptional{get;set;} //Contains Number of Negotiable Sections in Header Deployment
    public integer TechNegotiable{get;set;} //Contains Number of Non-Negotiable Sections in Header Technical
    public integer TechOptional{get;set;} //Contains Number of Negotiable Sections in Header Technical
    public integer FinNegotiable{get;set;} //Contains Number of Non-Negotiable Sections in Header Finance
    public integer FinOptional{get;set;} //Contains Number of Negotiable Sections in Header Finance
    public integer ProMNegotiable{get;set;} //Contains Number of Non-Negotiable Sections in Header Project Management
    public integer ProMOptional{get;set;} //Contains Number of Negotiable Sections in Header Project Management
    
    public boolean IsUpdateStatus{get;set;} //Used for Edit or Read Mode Based on User Permission
    public list<IPM_Project_Document_Section__c>lstCountryFeedback{get;set;} //Contains Local Projects Country Feedbacks
    
    //get user types
    public Boolean isReadable{get;set;} //For Readable Mode    
    
    public IPM_Financial__c financialForPdf {get; set;} //Contains Financial Record
    public string globalbusinessImpactStr  {get; set;}//DEF2450
    public IPM_Financial__c finProjectPriority {get; set;} //Contains Financial Record
    public list<IPM_Project_Rollout__c> rollOut {get; set;} //Contains Rollout Records
    public decimal year3Ito {get;set;} //year3 ito in the PDF
    //For Filled-In Percentage
    public Integer NonNegotiable;
    public Integer removeoptional;
    
    
    public ID parentSectionId{get;set;}
    public ID sectionId{get;set;}
    
    //variables for VF Rendering Conditions
    public Boolean isEditLinkActive{get;set;}
    //@Description:download PDF
    public Boolean isPDFDownload{get;set;}
    public boolean isExemptFromThresholdITO {get;set;}
    public Boolean showSummaryAttach{ get{showAllCurrentDocSummaryAttch(); return showSummaryAttach; } set;}  
    
    public Static final String ENVIRONMENTAL_IMPACT = 'Environmental_Impact';
    public Static final String OTIF_Status ='OTIF_Status';
    public Boolean bDocStatusNotStartedOrApproved{get;set;}//Flag to check if document is in Not Started or Approved Status
    public string regionalCPP {get;set;}
    public string localCPP {get;set;}
    public string brandPosition {get; set;}
    //phase 2.0 variables
    public boolean isWithAppendix{get;set;}//set boolean value to display appendix on gate document PDF page
    public boolean isDisplayWithoutAppendix{get;set;}//check whether without appendix pdf to display on page or not
    public boolean reactivateProjectFlag{get; set;} // Boolean to display the 'Reactivate Project'
    public boolean showBBCtable{get; set;} // flag to check the BBC table is applicble     
    public boolean isRedStylingApplicable{get;set;} 
    public boolean isPDLDocument{get;set;}
    public List<IPM_Project_Claim__c> projectClaimList{get; set;}
    public Attachment savedAttachmentDoc{get;set;} // show PDL attachment
    public String attachmentName{get;set;}
    public boolean isPDLApproved{get;set;}//check whether PDL document is approved or not
    public static final String DOCUMENT_TYPE ='DocumentType';
    public static final String PDF ='PDF';
    public static String projDocSecId = '';
    public String baseUrl = 'https://' + string.valueOf(ApexPages.currentPage().getHeaders().get('Host'));
    public string gateDocPDFWithAppendixURLStr{get;set;}
    public string gateDocPDFWithoutAppendixURLStr{get;set;}
    public boolean mainDataBool{get;set;}
    public boolean appendixBool{get;set;}
    public boolean pageMessagesUserTypeBool{get;set;}
    
    //Variables for storing page URLs
    public string IPM_FinInitialEstOfOppCharterPage{get;set;}
    public string IPM_Consumer_EvidencePage{get;set;}
    public string IPM_EcoDesignSectionPage{get;set;}
    public string IPM_Customer_ChannelsPage{get;set;}
    public string IPM_Risk_QuestionnaireViewPage{get;set;}
    public string IPM_Gate_RollOutsPage{get;set;}
    public string IPM_MilestoneList_PDFPage{get;set;}
    public string IPM_Country_FeedbackPage{get;set;}
    public string IPM_CMIGateSectionPage{get;set;}
    public string IPM_AssumptionsPage{get;set;}
    public string IPM_BCC_ConsolidatePage{get;set;}
    public string IPM_ViewAssortmentStrategyPage{get;set;}
    public string IPM_MarketPerformancePage{get;set;}
    public string IPM_PerformanceBreakdownPage{get;set;}
    public string IPM_Local_Sourcing_TablePage{get;set;}
    public string IPM_TradeMark_QuestionsViewPage{get;set;}
    public string IPM_CU_ComplexityPage{get;set;}
    public string IPM_CU_Complexity_ConsolidatedPage{get;set;}
    public string IPM_GlobalFinancialActionStandardsPage{get;set;}
    public string IPM_FinancialActionStandardsInversePage{get;set;}
    public string IPM_FinGatePage{get;set;}
    public string IPM_GateKeeperListViewPage{get;set;}
    public string IPM_OTIFStatusTableViewPage{get;set;}
    public string IPM_RND_QuestionsViewPage{get;set;}
    public string IPM_SC_Feasibility_QuestionsViewPage{get;set;}
    public string IPM_RND_Feasibility_QuestionsViewPage{get;set;}
    
    /****************************************************************************************************************************************************
@description Retrieving Project,Project Document,Project Document Section Records Using Page URL Parameters and Initializing the Values for Variables
*/
    public IPM_GateDocumentController()
    {
        initializeVariables();
        getProjectDocument(); //To Retrieve Project, Project Document Record
        getDueDateMsg();
        getCounts();
        if(isPDLDocument) { getPdlDocumentStatus(); }
        showBBCtable = getBCCtableFlag();
        getFilledInPercent();
        
        if((((IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(project.IPM_Project_Type__c))) || 
             (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(project.IPM_Project_Type__c))) || 
             (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equalsIgnoreCase(project.IPM_Project_Type__c)))) && (project.Exempt_from_Threshold__c)))
        {
            isExemptFromThresholdITO = true;
        }
        
        reactivateProjectCheck();        
        isRedStylingApplicable=((IPM_ConstantUtils.STATUS_APPROVED.equals(projectDoc.IPM_Document_Status__c) ? projectDoc.IPM_Category_Status_while_Approved__c:project.IPM_Threshold_Status__c)== Label.IPM_BelowThreshold) && (project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL) ;
        chkClaims();        
        
        if(ApexPages.currentPage().getUrl().containsIgnoreCase(Page.IPM_GateDocumentPDF.getUrl())) {
            gateDocumentData(project.Id);
            getAppendixCheck();
        }
        if(test.isRunningTest()){
            gateDocumentData(project.Id);
            getMainData();
            getAppendixData();
            getIpmuserType();
        }
        getOtifSecId();
        initializePageReferences();
    }
    
    public void getMainData() {
        mainDataBool = true;
        getProjectDocumentSection();
    }
    
    public void getAppendixData() {
        appendixBool = true;
        getAppendixCheck();
    }
    
    public void getOtifSecId(){
        if(!isPDLDocument && (String.isBlank(projDocSecId)))
        {
            List<IPM_Project_Document_Section__c> sectionListForprojDocSecId= [
                SELECT Id,IPM_Master_Section_External_Id__c
                FROM IPM_Project_Document_Section__c 
                WHERE IPM_Project_Document__c=:projectDoc.Id AND IPM_Default_Section__c=true 
                AND IPM_Master_Section_External_Id__c =: OTIF_Status LIMIT 1 ];
            projDocSecId = sectionListForprojDocSecId.isEmpty() ? '' : sectionListForprojDocSecId[0].Id;
        }
    }
    
    public void getPdlDocumentStatus() {
        if(isPDLApproved!=null && isPDLApproved)
        { 
            List<Attachment> savedAttachmentDocList = [Select id,body from Attachment WHERE ParentId =:projectDoc.Id];
            if(!savedAttachmentDocList.isEmpty()){
                savedAttachmentDoc = savedAttachmentDocList[0];
                attachmentName = IPM_ConstantUtils.ATTACHMENT_FILE_NAME+project.IPM_Project_Name__c+'_'+PrintDoc+IPM_ConstantUtils.ATTACHMENT_FILE_TYPE;
            }
        }
        if(ApexPages.currentPage().getParameters().get('setStatus') != null)
        {
            projectDoc.IPM_Document_Status__c = ApexPages.currentPage().getParameters().get('SetStatus');
            projectDoc.IPM_Approved_Comments__c =  ApexPages.currentPage().getParameters().get('StatusComments');
            projectDoc.IPM_Approval_Date__c =  Date.parse(ApexPages.currentPage().getParameters().get('StatusDate'));  
        }
        
        getProjectDocumentSection();
        
    }
    
    public void getAppendixCheck() {
        If(ApexPages.currentPage().getUrl().containsIgnoreCase(Page.IPM_GateDocumentPDF.getUrl())) {
            if(ApexPages.currentPage().getParameters().get('isWithAppendix') == 'true') {isWithAppendix = true;}
            else {isWithAppendix = false;}
        }
        Else {
            isWithAppendix = true;
        }
        
        if(isWithAppendix){
            getAppendixSections();
        }
    }
    
    public void initializeVariables() { 
        project=[SELECT id, IPM_ProjectGKM__c,IPM_Answer_of_Q1__c, IPM_Project_Name__C,IPM_Project_Type__c,IPM_Phase__C,IPM_Bosscard__c,IPMProject_Span__c,IPM_Bosscard_Status__c,IPM_GateKeeping_Model__c,
                 IPM_Parent_Project__c,IPM_Project_Logo__c,IPM_Brand_Positioning__c,IPM_Category_Icon__c,IPM_Category_Text__c,IPM_Parent_Project__r.IPM_Project_Name__c,Exempt_from_Threshold__c ,
                 IPM_EligibleForReactivation__c,IPM_Threshold_Status__c,IPM_CancelStoppingProjectTill__c,IPM_SourceProjectType__c,IPM_Stopped_Date_Time__c,IPM_PrepareForArchival__c,
                 Is_Archieved__c ,IPM_Parent_Project__r.IPM_Project_Type__c,IPM_Actual_Launch_Date__c,IPM_CompanyCardText__c,IPM_Current_Document_Status__c ,IPM_Document_Update_Date__c ,IPM_Document_Update_Comments__c,
                 IPM_Project_Job_Status__c, IPM_FilledIn_Percentage__c, IPM_Cluster__r.name, IPM_Project_Leader__r.Name, IPM_Strategic_Intent__c, IPM_Project_Gatekeeper__r.Name,
                 IPM_ProjectSubType__c, IPM_Complexity__c, IPM_Target_Launch_Dates__c,IPM_Fast_Track_Project__c, IPM_LocalProject_Brand__c, IPM_Project_Logo_Id__c, Source_Rollout_External_Id__c
                 FROM IPM_Project__C
                 WHERE id=:projectid  limit 1];
        appendixBool = false;
        mainDataBool = false;     
        lstCountryFeedback=new list<IPM_Project_Document_Section__c>();
        isPDLDocument = false;
        isPDLapproved = false;
        showSummaryAttach=false;
        isReadable=true;
        IsUpdateStatus=false;
        isPDFDownload=true;
        isExemptFromThresholdITO=false;
        bDocStatusNotStartedOrApproved = false;
        isDisplayWithoutAppendix=false;//phase 2.0
        showBBCtable = false;
        //Total filter counts
        NonNegotiableCount=0;
        OptionalCount=0;
        NotstartedCount=0;
        FilledinCount=0;
        ExcludedCount=0;
        MKTGDEVCount=0;
        CMICount=0;
        CDCount=0;
        RnDCount=0;
        FinanceCount=0;
        MKTGLOCALCount=0;
        SCCount=0;
        PLCount=0;
        FilledinPer=0;
        pageMessagesUserTypeBool=false;
        
        IntroNegotiable=0;
        IntroOptional=0;
        ExterNegotiable=0;
        ExterOptional=0;
        MixNegotiable=0;
        MixOptional=0;
        DeploNegotiable=0;
        DeploOptional=0;
        TechNegotiable=0;
        TechOptional=0;
        FinNegotiable=0;
        FinOptional=0;
        ProMNegotiable=0;
        ProMOptional=0;
    }
    
    public void initializePageReferences() {
        IPM_FinInitialEstOfOppCharterPage = baseUrl + Page.IPM_FinInitialEstOfOppCharterPage.getUrl();
        IPM_Consumer_EvidencePage = baseUrl + Page.IPM_Consumer_EvidencePage.getUrl();
        IPM_EcoDesignSectionPage = baseUrl + Page.IPM_EcoDesignSectionPage.getUrl();
        IPM_Customer_ChannelsPage = baseUrl + Page.IPM_Customer_ChannelsPage.getUrl();
        IPM_Risk_QuestionnaireViewPage = baseUrl + Page.IPM_Risk_QuestionnaireViewPage.getUrl();
        IPM_Gate_RollOutsPage = baseUrl + Page.IPM_Gate_RollOutsPage.getUrl();
        IPM_MilestoneList_PDFPage = baseUrl + Page.IPM_MilestoneList_PDFPage.getUrl();
        IPM_Country_FeedbackPage = baseUrl + Page.IPM_Country_FeedbackPage.getUrl();
        IPM_CMIGateSectionPage = baseUrl + Page.IPM_CMIGateSectionPage.getUrl();
        IPM_AssumptionsPage = baseUrl + Page.IPM_AssumptionsPage.getUrl();
        IPM_BCC_ConsolidatePage = baseUrl + Page.IPM_BCC_ConsolidatePage.getUrl();
        IPM_ViewAssortmentStrategyPage = baseUrl + Page.IPM_ViewAssortmentStrategyPage.getUrl();
        IPM_MarketPerformancePage = baseUrl + Page.IPM_MarketPerformancePage.getUrl();
        IPM_PerformanceBreakdownPage = baseUrl + Page.IPM_PerformanceBreakdownPage.getUrl();
        IPM_Local_Sourcing_TablePage = baseUrl + Page.IPM_Local_Sourcing_TablePage.getUrl();
        IPM_TradeMark_QuestionsViewPage = baseUrl + Page.IPM_TradeMark_QuestionsViewPage.getUrl();
        IPM_CU_ComplexityPage = baseUrl + Page.IPM_CU_ComplexityPage.getUrl();
        IPM_CU_Complexity_ConsolidatedPage = baseUrl + Page.IPM_CU_Complexity_ConsolidatedPage.getUrl();
        IPM_GlobalFinancialActionStandardsPage = baseUrl + Page.IPM_GlobalFinancialActionStandardsPage.getUrl();
        IPM_FinancialActionStandardsInversePage = baseUrl + Page.IPM_FinancialActionStandardsInversePage.getUrl();
        IPM_FinGatePage = baseUrl + Page.IPM_FinGatePage.getUrl();
        IPM_GateKeeperListViewPage = baseUrl + Page.IPM_GateKeeperListViewPage.getUrl();
        IPM_OTIFStatusTableViewPage = baseUrl + Page.IPM_OTIFStatusTableViewPage.getUrl();
        IPM_RND_QuestionsViewPage = baseUrl + Page.IPM_RND_QuestionsViewPage.getUrl();
        IPM_SC_Feasibility_QuestionsViewPage = baseUrl + Page.IPM_SC_Feasibility_QuestionsViewPage.getUrl();
        IPM_RND_Feasibility_QuestionsViewPage = baseUrl + Page.IPM_RND_Feasibility_QuestionsViewPage.getUrl();
        gateDocPDFWithAppendixURLStr = baseUrl + exportToPdf('true').getUrl();
        gateDocPDFWithoutAppendixURLStr = baseUrl + exportToPdf('false').getUrl();
    }
    
    public void getFilledInPercent() {
        If(projectDoc.IPM_Document_Status__c==IPM_ConstantUtils.STATUS_NOT_STARTED || projectDoc.IPM_Document_Status__c==IPM_ConstantUtils.STATUS_APPROVED){
            bDocStatusNotStartedOrApproved = true;
            //For Storing Filled-In Percentage Calculation in Project Object 
            Integer NonNegotiable=[SELECT count() FROM IPM_Project_Document_Section__c 
                                   WHERE IPM_Default_Section__c=true AND IPM_Project_Document__c=:projectDoc.Id 
                                   AND IPM_Section__r.IPM_Section_Type__c IN :IPM_ConstantUtils.SECTION_LIST_WO_HEADER_SUBHEADER];
            Integer removeoptional=[SELECT count() FROM IPM_Project_Document_Section__c 
                                    WHERE IPM_Section_Status__c=:IPM_ConstantUtils.SECTION_STATUS_FILLED 
                                    AND IPM_Project_Document__c=:projectDoc.Id AND  IPM_Default_Section__c=true 
                                    AND IPM_Section__r.IPM_Section_Type__c IN :IPM_ConstantUtils.SECTION_LIST_WO_HEADER_SUBHEADER];
            if(NonNegotiable!=0){
                FilledinPer=math.round((Decimal.valueof(removeoptional)/decimal.valueof(NonNegotiable))*100);
            }
        }
        If(isPDLDocument){
            integer pdlSectionCount = 0;
            integer totalFilledinCount = 0;
            for(IPM_Project_Document_Section__c s : projSectionList) {
                pdlSectionCount++;
                if(IPM_ConstantUtils.SECTION_STATUS_FILLED.Equals(s.IPM_Section_Status__c)){
                    totalFilledinCount++; //Count Filled In Sections
                }
                if(pdlSectionCount > 0) {
                    filledInPer = math.Round(decimal.ValueOf(totalFilledinCount)/decimal.ValueOf(pdlSectionCount)*100); 
                }
            }
        }
    }
    
    public void getCounts() {
        if(projectDoc != null){
            IPM_Project_Document__c projDocCounts = 
                [SELECT Rollup_Technical_OPT__c, Rollup_Technical_NN__c, Rollup_SC_Role__c, 
                 Rollup_RD_Role__c, Rollup_Project_Management_OPT__c, Rollup_Project_Management_NN__c, 
                 Rollup_PL_Role__c, Rollup_Not_Started_Sections__c, Rollup_Mix_OPT__c, Rollup_Mix_NN__c, 
                 Rollup_Introduction_OPT__c, Rollup_Introduction_NN__c, Rollup_Finance_Role__c, 
                 Rollup_Finance_OPT__c, Rollup_Finance_NN__c, Rollup_Filled_In_Sections__c, 
                 Rollup_External_OPT__c, Rollup_External_NN__c, Rollup_Excluded_Sections__c, 
                 Rollup_Deployment_OPT__c, Rollup_Deployment_NN__c, Rollup_CMI_Role__c, Rollup_CD_Role__c, 
                 Rollup_MKTG_DEV_Role__c, Rollup_MKTG_LOCAL_Role__c, Name FROM IPM_Project_Document__c 
                 where id = :projectDoc.Id];  
            IntroNegotiable = integer.valueOf(projDocCounts.Rollup_Introduction_NN__c);
            ExterNegotiable = integer.valueOf(projDocCounts.Rollup_External_NN__c);            
            MixNegotiable = integer.valueOf(projDocCounts.Rollup_Mix_NN__c);
            DeploNegotiable = integer.valueOf(projDocCounts.Rollup_Deployment_NN__c);
            TechNegotiable = integer.valueOf(projDocCounts.Rollup_Technical_NN__c);
            FinNegotiable = integer.valueOf(projDocCounts.Rollup_Finance_NN__c);
            ProMNegotiable = integer.valueOf(projDocCounts.Rollup_Project_Management_NN__c);
            NonNegotiableCount = IntroNegotiable + ExterNegotiable + MixNegotiable + DeploNegotiable
                + TechNegotiable + FinNegotiable + ProMNegotiable;
            IntroOptional = integer.valueOf(projDocCounts.Rollup_Introduction_OPT__c);
            ExterOptional = integer.valueOf(projDocCounts.Rollup_External_OPT__c);
            MixOptional = integer.valueOf(projDocCounts.Rollup_Mix_OPT__c);
            DeploOptional = integer.valueOf(projDocCounts.Rollup_Deployment_OPT__c);
            TechOptional = integer.valueOf(projDocCounts.Rollup_Technical_OPT__c);
            FinOptional = integer.valueOf(projDocCounts.Rollup_Finance_OPT__c);
            ProMOptional = integer.valueOf(projDocCounts.Rollup_Project_Management_OPT__c);
            OptionalCount = IntroOptional + ExterOptional + MixOptional + DeploOptional
                + TechOptional + FinOptional + ProMOptional;
            NotstartedCount = integer.valueOf(projDocCounts.Rollup_Not_Started_Sections__c);
            FilledinCount = integer.valueOf(projDocCounts.Rollup_Filled_In_Sections__c);
            ExcludedCount = integer.valueOf(projDocCounts.Rollup_Excluded_Sections__c);
            MKTGDEVCount = integer.valueOf(projDocCounts.Rollup_MKTG_DEV_Role__c);
            CMICount = integer.valueOf(projDocCounts.Rollup_CMI_Role__c);
            CDCount = integer.valueOf(projDocCounts.Rollup_CD_Role__c);
            RnDCount = integer.valueOf(projDocCounts.Rollup_RD_Role__c);
            FinanceCount = integer.valueOf(projDocCounts.Rollup_Finance_Role__c);
            MKTGLOCALCount = integer.valueOf(projDocCounts.Rollup_MKTG_LOCAL_Role__c);
            SCCount = integer.valueOf(projDocCounts.Rollup_SC_Role__c);
            PLCount = integer.valueOf(projDocCounts.Rollup_PL_Role__c);
        }
    }
    
    public void reactivateProjectCheck() {
        //Logic to Display the "Reactivate Project" button on Gate Document page for IPM Business Partner   
        //For Stopped project in Ideas phase for 38 months, "Reactivate Project" button will be displayed for IPM Business Partner
        
        Integer noOfMonths = Integer.valueOf(Label.IPM_NoOfMonths_ForReactivation);
        Date dateToCompare = System.today().addMonths(-noOfMonths); 
        if(project.IPM_EligibleForReactivation__c && project.IPM_Stopped_Date_Time__c > dateToCompare)
        {
            //security for central team and BP users
            IPM_CustomPermission custPermission = new IPM_CustomPermission();
            reactivateProjectFlag = custPermission.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
        }        
    }
    
    public void chkClaims() {
        if(IPM_ConstantUtils.PRODUCT_DESIGN_LOCK.Equals(printDoc))
        {
            projectClaimList = [SELECT Id, IPM_Claim__c, IPM_Project__c FROM IPM_Project_Claim__c WHERE IPM_Project__c=:projectId];
            if(projectClaimList.isEmpty()){
                isWithAppendix = false; 
            }
        }
    }
    
    public boolean getBCCtableFlag() {
        if(project.IPM_ProjectGKM__c.equals(IPM_ConstantUtils.GATE_KEEPING_MODEL_3) || project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
        {
            return true;
        }
        return false;
    }
    
    /*************************************************************************************************************************************************************
@description Getting Project and Project Document
*/ 
    public void getProjectDocument() {
        //Retrieving Project Record Using Page URL Parameter Id
        if(String.IsNotBlank(String.valueOf(projectId)) && String.IsNotBlank(String.valueOf(printDoc))){
            
            if(IPM_ConstantUtils.PRODUCT_DESIGN_LOCK.Equals(printDoc)) {
                isPDLDocument =true;
            }
            
            //Retrieving Project Document Record    
            List<IPM_Project_Document__c> lstProjectDoc = new List<IPM_Project_Document__c>();
            lstProjectDoc=[SELECT Id,IPM_Contract_GateKeeper_Model__c,IPM_Category_Status_while_Approved__c ,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Updated_User_By__r.smallPhotoURL,
                           IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c,IPM_Updated_User_By__c,IPM_Updated_User_By__r.Name 
                           FROM IPM_Project_Document__c 
                           WHERE IPM_Project__c=:projectid AND IPM_GateDocuments__c=:printDoc];
            if(!lstProjectDoc.isEmpty()){
                projectDoc = lstProjectDoc[0];
                if(isPDLDocument && projectDoc.IPM_Document_Status__c==IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED) {
                    isPDLapproved = true;
                }
                //Phase 2.0-Check gate document as all four gates.
                if((IPM_ConstantUtils.CHARTER_GATE.Equals(projectDoc.IPM_GateDocuments__c)||IPM_ConstantUtils.CONTRACT_GATE.Equals(projectDoc.IPM_GateDocuments__c)||
                    IPM_ConstantUtils.MARKET_READY_GATE.Equals(projectDoc.IPM_GateDocuments__c)||IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE.Equals(projectDoc.IPM_GateDocuments__c))&&isPDFDownload){
                        isDisplayWithoutAppendix=true;      
                    }
                isEditLinkAvailable();
            }            
        }
    }
    
    public void getDueDateMsg() {        
        lstMstn=new List<IPM_Milestone__c>();
        IPM_Milestone__c mstn = new IPM_Milestone__c();
        lstMstn=[SELECT IPM_Due_Date__c,IPM_Type_of_gate__c 
                 FROM IPM_Milestone__c 
                 WHERE IPM_Type_of_gate__c=:projectDoc.IPM_GateDocuments__c and IPM_Project__c=:projectId LIMIT 1]; 
        if(!lstMstn.isEmpty()){
            mstn = lstMstn[0];
            if(String.IsNotBlank(String.valueOf(mstn.IPM_Due_Date__c))){
                dueDate=date.valueOf(mstn.IPM_Due_Date__c).format();
                if(mstn.IPM_Due_Date__c<System.today()+4){
                    DueDateMsg=true;   
                }
            }
        }
    }
    
    /*************************************************************************************************************************************************************
@description Getting user type with access permission
*/ 
    public void getIpmuserType(){
        try{
            pageMessagesUserTypeBool = true;
            Integer guestCount=0;
            guestCount=[SELECT COUNT() FROM IPM_Project_Resource__c 
                        WHERE IPM_Role_Type__c=:IPM_ConstantUtils.IPM_ROLE_GUEST AND IPM_Project__c=:projectId AND 
                        IPM_User__c=:userinfo.getuserid()  AND IPM_Project__r.Is_Archieved__c=false LIMIT 1];
            if(guestCount>0){
                isPDFDownload=false;
            }
            //Getting Current Logged-In User Role Type and Assigning Permission
            list<IPM_Project__c> projectList=[SELECT IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c, IPM_PrepareForArchival__c, Is_Archieved__c 
                                              FROM IPM_Project__c 
                                              WHERE id=:projectId AND (IPM_Project_Leader__c =:userinfo.getuserid() 
                                                                       OR Deputy_Project_Leader__c=:userinfo.getuserid())  limit 1];
            if(projectList!=null && !projectList.isEmpty()){
                isReadable=false;
                IsUpdateStatus=true;
            }
            
            //security for central team and BP users
            IPM_CustomPermission cpr = new IPM_CustomPermission();
            boolean isCentralTeam=false;
            boolean isBPUser=false;
            isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
            isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
            if(isCentralTeam || isBPUser)
            {
                IsUpdateStatus=true;
                isReadable=false;
                
            }   
            
            if(project !=null)
            {
                if(IsUpdateStatus)
                {
                    IsUpdateStatus = !(project.Is_Archieved__c || project.IPM_PrepareForArchival__c);
                } 
                if(project.Is_Archieved__c || project.IPM_PrepareForArchival__c)
                {
                    isReadable = true;   
                }
            }   
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
                                                  'getIpmuserType',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }   
    
    /*************************************************************************************************************************************************************
@description To Get Project Document Sections
*/ 
    public void getProjectDocumentSection(){
        //Retrieving Header Project Document Sections for Gate Document
        try{
            projSectionMap = new Map<IPM_Project_Document_Section__c,Map<IPM_Project_Document_Section__c,List<IPM_Project_Document_Section__c>>>();
            Map<Id,IPM_Project_Document_Section__c> projSectionMapHelper = new Map<Id,IPM_Project_Document_Section__c>();
            
            projSectionList=[SELECT Id,IPM_GateHistory__c, IPM_Section_Sequence__c, IPM_GateHistory_Date__c,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,
                             IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,
                             LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Project_Document__c,
                             IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c,IPM_FunctionalRole__c,
                             IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c, IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c, IPM_Master_Section_External_Id__c,IPM_Has_Appendix__c  
                             FROM IPM_Project_Document_Section__c 
                             WHERE IPM_Project_Document__c=:projectDoc.Id AND IPM_Default_Section__c = true order by IPM_Section__r.IPM_Section_Sequence__c asc limit 50000]; 
            
            for(IPM_Project_Document_Section__c pds: projSectionList) {
                projSectionMapHelper.put(pds.IPM_Section__c, pds);
                if(pds.IPM_Section__r.IPM_Section_Label_Type__c == IPM_ConstantUtils.SECTION_TYPE_HEADER) {                
                    projSectionMap.put(pds, new Map<IPM_Project_Document_Section__c,List<IPM_Project_Document_Section__c>>());
                }
                Else if(pds.IPM_Section__r.IPM_Section_Label_Type__c == IPM_ConstantUtils.SECTION_TYPE_SUBHEADER) {
                    if(projSectionMapHelper.get(pds.IPM_Section__r.IPM_Parent_Section__c) != Null) {
                        IPM_Project_Document_Section__c tpds = projSectionMapHelper.get(pds.IPM_Section__r.IPM_Parent_Section__c);
                        projSectionMap.get(tpds).put(pds, new List<IPM_Project_Document_Section__c>());
                    }
                    else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                    }
                }
                Else if(pds.IPM_Section__r.IPM_Section_Label_Type__c == IPM_ConstantUtils.SECTION_TYPE_TOPIC && printDoc != IPM_ConstantUtils.PRODUCT_DESIGN_LOCK){
                    if(projSectionMapHelper.get(pds.IPM_Section__r.IPM_Parent_Section__c) != Null 
                       && projSectionMapHelper.get((projSectionMapHelper.get(pds.IPM_Section__r.IPM_Parent_Section__c)).IPM_Section__r.IPM_Parent_Section__c) != Null) {
                           IPM_Project_Document_Section__c tpds = projSectionMapHelper.get(pds.IPM_Section__r.IPM_Parent_Section__c);
                           IPM_Project_Document_Section__c ttpds = projSectionMapHelper.get(tpds.IPM_Section__r.IPM_Parent_Section__c);
                           projSectionMap.get(ttpds).get(tpds).add(pds);
                       }
                    else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                    }
                }
            }                      
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    } 
    
    /*************************************************************************************************************************************************************
@description To Create PDF for Gate Document
@return URL
@Business Rule: This functions is used to Display the data in for the Gate Documetn PDF, i which data needs to be pulled from Various entities, hence it is complex.

*/  
    
    public PageReference exportToPdf(String isWithAppendixStr)
    { 
        try
        {   
            PageReference gateDocPDFURL = null;
            gateDocPDFURL = Page.IPM_GateDocumentPDFDownload;
            gateDocPDFURL.setRedirect(true);
            
            gateDocPDFURL.getParameters().put(IPM_ConstantUtils.ID_PARAMETER, ProjectId);
            gateDocPDFURL.getParameters().put('projDocSecId', projDocSecId);
            gateDocPDFURL.getParameters().put(IPM_ConstantUtils.PROJECTNAME_PARAMETER, project.IPM_Project_Name__c);
            gateDocPDFURL.getParameters().put(IPM_ConstantUtils.PRINTDOC_PARAMETER, PrintDoc);
            gateDocPDFURL.getParameters().put(DOCUMENT_TYPE, PDF);
            gateDocPDFURL.getParameters().put(IPM_ConstantUtils.ISWITHAPPENDIX_PARAMETER,String.valueOf(isWithAppendixStr)); 
            return gateDocPDFURL; 
        }
        
        catch(Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
                                                  'exportToPdf',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            
            return null;
        }
    }
    
    void gateDocumentDataForOriginalProject(String projectName)
    {
        if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
        {
            financialForPdf=[SELECT id,ipm_cpp_local__c,Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,Year_3_iTO_MR__c,Year_3_iTO_MD__c,Business_Impact_Global__c,
                             Business_Impact_Local__c,Business_Impact_Regional__c,Year_3_iTO_Global__c,Year_3_iTO_Local__c,Year_3_iTO_Regional__c,
                             IPM_Business_Impact_Charter__c,IPM_Business_Impact_Contract__c,IPM_Business_Impact_MR__c,IPM_Business_Impact_MD__c 
                             FROM IPM_Financial__c 
                             WHERE Parent_Project__c=:project.Id AND Financial_External_ID__c=:projectName+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
            globalbusinessImpactStr = gateDocument==IPM_ConstantUtils.CHARTER_GATE || project.IPM_ProjectGKM__c.equals(IPM_ConstantUtils.GATE_KEEPING_MODEL_3) ? financialForPdf.Business_Impact_Global__c:financialForPdf.Business_Impact_Regional__c;
        }
        else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL) 
        {       
            if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
            {
                financialForPdf=[SELECT id,ipm_cpp_local__c,Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,Year_3_iTO_MR__c,Year_3_iTO_MD__c,
                                 Business_Impact_Global__c,Business_Impact_Local__c,Business_Impact_Regional__c,Year_3_iTO_Global__c,
                                 Year_3_iTO_Local__c,Year_3_iTO_Regional__c,IPM_Business_Impact_Charter__c,IPM_Business_Impact_Contract__c,IPM_Business_Impact_MR__c,IPM_Business_Impact_MD__c
                                 FROM IPM_Financial__c 
                                 WHERE Regional_Project__c=:project.Id AND Financial_External_ID__c=:projectName+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
                globalbusinessImpactStr = financialForPdf.Business_Impact_Regional__c;                     
            }
            else if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)
            {                       
                financialForPdf=[SELECT id,ipm_cpp_local__c,Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,Year_3_iTO_MR__c,Year_3_iTO_MD__c,
                                 Business_Impact_Global__c,Business_Impact_Local__c,Business_Impact_Regional__c,Year_3_iTO_Global__c,
                                 Year_3_iTO_Local__c,Year_3_iTO_Regional__c,IPM_Business_Impact_Charter__c,IPM_Business_Impact_Contract__c,IPM_Business_Impact_MR__c,IPM_Business_Impact_MD__c
                                 FROM IPM_Financial__c 
                                 WHERE Parent_Project__c=:project.IPM_Parent_Project__c AND Financial_External_ID__c=:project.IPM_Parent_Project__r.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
                globalbusinessImpactStr = financialForPdf.Business_Impact_Regional__c;
            }
        }
        else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
        {
            string sExternalID=project.Source_Rollout_External_Id__c;
            financialForPdf = [SELECT ipm_cpp_local__c,ipm_cpp_regional__c, Year_3_iTO_Local__c,Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,Year_3_iTO_MR__c,
                                     Year_3_iTO_MD__c,Business_Impact_Local__c 
                                     FROM IPM_Financial__c 
                                     WHERE Financial_External_ID__c =: sExternalID limit 1];
            localCPP = financialForPdf.ipm_cpp_local__c;
            regionalCPP = financialForPdf.ipm_cpp_regional__c;
            
            string parentProjectType=project.IPM_Parent_Project__r.IPM_Project_Type__c;                 
            if(parentProjectType==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
            {
                List<IPM_Financial__c> financialList = [SELECT id,ipm_cpp_local__c,Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,Year_3_iTO_MR__c,Year_3_iTO_MD__c,
                                                        Business_Impact_Global__c,Business_Impact_Local__c,Business_Impact_Regional__c,Year_3_iTO_Global__c,
                                                        Year_3_iTO_Local__c,Year_3_iTO_Regional__c,IPM_Business_Impact_Charter__c,IPM_Business_Impact_Contract__c,IPM_Business_Impact_MR__c,IPM_Business_Impact_MD__c
                                                        FROM IPM_Financial__c 
                                                        WHERE (Regional_Project__c=:project.IPM_Parent_Project__c  OR Parent_Project__r.ipm_ProjectGKM__c =: IPM_ConstantUtils.GKM_3)
                                                        AND Financial_External_ID__c=:project.IPM_Parent_Project__r.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
                if(!financialList.isEmpty()){
                   globalbusinessImpactStr = financialList[0].Business_Impact_Regional__c;
                }         
                
            }
            else if(parentProjectType==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)// traverse to its Global Project for getting BI from CONSOLIDATED Financial
            {
                IPM_Project__c globalParentId= [Select IPM_Parent_Project__r.IPM_Parent_Project__c,IPM_Parent_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c FROM IPM_Project__c where ID=:project.Id];
                IPM_Financial__c finr=[SELECT id,ipm_cpp_local__c,Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,Year_3_iTO_MR__c,Year_3_iTO_MD__c,
                                 Business_Impact_Global__c,Business_Impact_Local__c,Business_Impact_Regional__c,Year_3_iTO_Global__c,
                                 Year_3_iTO_Local__c,Year_3_iTO_Regional__c,IPM_Business_Impact_Charter__c,IPM_Business_Impact_Contract__c,IPM_Business_Impact_MR__c,IPM_Business_Impact_MD__c
                                 FROM IPM_Financial__c
                                 WHERE Parent_Project__c=:globalParentId.IPM_Parent_Project__r.IPM_Parent_Project__c
                                 AND Financial_External_ID__c=:globalParentId.IPM_Parent_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
                
                globalbusinessImpactStr = finr.Business_Impact_Regional__c;
            }
        } 
    }    
    
    /****************************************************
@description For Exporting Gate Document Data in PDF
@param Project Id
*/
    void gateDocumentData(Final Id pId){
        //For Generating PDF Retrieving Project Rollouts,Finance and Project Document Sections
        try{
            
            brandPosition=IPM_ConstantUtils.BLANK;
            String nam=project.IPM_Project_Name__c; 
            globalbusinessImpactStr = IPM_ConstantUtils.BLANK;
            year3Ito=0;
            country=new IPM_Country__c();
            for(String bPostion:project.IPM_Brand_Positioning__c.split(IPM_ConstantUtils.COMMA)){
                if(String.isBlank(brandPosition)){
                    brandPosition=bPostion;
                }
                else{
                    brandPosition=brandPosition+IPM_ConstantUtils.COMMA+IPM_ConstantUtils.IPM_SPACE+bPostion;
                }
            }   
            // For BI and Year3Ito where Source is ORIGINAL project. Will work got GKM1,GKM2,GKM4, ORIGINALS AND ROLLOUT
            if(project.IPM_SourceProjectType__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
            {
                gateDocumentDataForOriginalProject(nam);
            }
            // For BI and Year3Ito where Source is ORIGINAL project. Will work got GKM5,GKM6,GKM7 OPERATIONAL
            else if(project.IPM_SourceProjectType__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
            {
                globalbusinessImpactStr = IPM_ConstantUtils.BLANK;
                financialForPdf= [SELECT ipm_cpp_local__c,Year_3_iTO_Global__c,Year_3_iTO_Local__c,Year_3_iTO_Regional__c,
                                  Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,
                                  Year_3_iTO_MR__c,Year_3_iTO_MD__c 
                                  FROM IPM_Financial__c WHERE Financial_External_ID__c =: nam limit 1];                
            }
            if(financialForPdf!=null)
            {
                year3Ito=fetchY3ITO(financialForPdf,gateDocument);
            }
            // For First Country To Rollouts
            Integer flag=[select count() from IPM_Country__c where Local_Rollout__r.IPM_Status__c=:IPM_ConstantUtils.ROLLOUT_LEADER AND (IPM_Project__c=:projectId 
                                                                                                                                         OR IPM_Regional_Project__c=:projectId OR IPM_Local_Project__c=:projectId)];
            if(flag>0)
            {
                country=[select Country_Name__c,MCO_Name__c,IPM_Project__c,IPM_Regional_Project__c,IPM_Local_Project__c,Local_Rollout__r.IPM_Status__c
                         from IPM_Country__c where Local_Rollout__r.IPM_Status__c=:IPM_ConstantUtils.ROLLOUT_LEADER AND (IPM_Project__c=:projectId 
                                                                                                                         OR IPM_Regional_Project__c=:projectId OR IPM_Local_Project__c=:projectId) limit 1];
            }
            
            // to fetch the sections to be displayed in PDF            
            projDocSectionList=[SELECT Id,IPM_Section_Name__c, IPM_Default_Section__c,IPM_Section_Sequence__c,IPM_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,
                                Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.External_ID__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_FunctionalRole__c,
                                IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c, IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c, IPM_Has_Appendix__c,IPM_Master_Section_External_Id__c
                                FROM IPM_Project_Document_Section__c 
                                WHERE IPM_Project_Document__c=:projectDoc.Id and IPM_Default_Section__c=true 
                                order by IPM_Section__r.IPM_Section_Sequence__c asc];
            for(IPM_Project_Document_Section__c pd : projDocSectionList){
                if (pd.IPM_Master_Section_External_Id__c==OTIF_Status) 
                    projDocSecId = pd.Id;
            }
            
            
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    } 
    /*
@method name: fetchY3ITO 
@description:to Fetch the Y3 ITO based on teh document type and phase of the project 
@Param1 : financial object
@Param2: Gate Document
*/
    public decimal fetchY3ITO(IPM_Financial__c fin , String document)
    {
        decimal finValue=0;  
        if(IPM_ConstantUtils.CHARTER_GATE==document && IPM_constantUtils.DOCUMENT_STATUS_APPROVED==projectDoc.IPM_Document_Status__c){          
            finValue=fin.Year_3_iTO_Charter__c/1000;
            return finvalue;
        }
        else if(IPM_ConstantUtils.CONTRACT_GATE==document && IPM_constantUtils.DOCUMENT_STATUS_APPROVED==projectDoc.IPM_Document_Status__c){
            finValue=fin.Year_3_iTO_Contract__c/1000;
            return finvalue;
        }
        else if(IPM_ConstantUtils.PRODUCT_DESIGN_LOCK==document && IPM_constantUtils.DOCUMENT_STATUS_APPROVED==projectDoc.IPM_Document_Status__c){
            finValue=fin.Year_3_iTO_Global__c/1000;
            return finvalue;
        }
        else if(IPM_ConstantUtils.MARKET_READY_GATE==document && IPM_constantUtils.DOCUMENT_STATUS_APPROVED==projectDoc.IPM_Document_Status__c){
            finValue=fin.Year_3_iTO_MR__c/1000;
            return finvalue;
        }
        else if(IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE==document && IPM_constantUtils.DOCUMENT_STATUS_APPROVED==projectDoc.IPM_Document_Status__c){
            finValue=fin.Year_3_iTO_MD__c/1000;
            return finvalue;
        }     
        else if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL==project.IPMProject_Span__c && IPM_constantUtils.DOCUMENT_STATUS_APPROVED!=projectDoc.IPM_Document_Status__c){
            finValue=fin.Year_3_iTO_Global__c/1000;
            return finvalue;
        }
        
        else if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL==project.IPMProject_Span__c && IPM_constantUtils.DOCUMENT_STATUS_APPROVED!=projectDoc.IPM_Document_Status__c){
            finValue=fin.Year_3_iTO_Regional__c/1000;
            return finvalue;
        }
        
        else if(IPM_ConstantUtils.PROJECT_SPAN_LOCAL==project.IPMProject_Span__c && IPM_constantUtils.DOCUMENT_STATUS_APPROVED!=projectDoc.IPM_Document_Status__c){
            finValue=fin.Year_3_iTO_Local__c/1000;
            return finvalue;
        }       
        return finvalue;
    }
    
    /********************************************************************
@description For Moving Gate Document from Market Deployment to PLE
*/
    public void moveToPLE()
    {
        List<IPM_Project__c> lstProjectsToUpdate = new List<IPM_Project__c>();
        try
        {
            IPM_Project_Type__c currentProjectType =  IPM_Utils.retrieveProjectType(project);
            IPM_Project_Type__c nextPhaseProjectType = IPM_Utils.getNextPhase(currentProjectType,false);
            
            if(nextPhaseProjectType != null && nextPhaseProjectType.IPM_Phase__c!=null)
            {
                project.IPM_Phase__c = nextPhaseProjectType.IPM_Phase__c;
                project.IPM_Actual_Launch_Date__c = Date.today();
                lstProjectsToUpdate.add(project);
            }
            
            if(nextPhaseProjectType.IPM_CopyLaunchDate2Parent__c)
            {
                for(IPM_Project__c localProject : [SELECT Id,
                                                   IPM_Parent_Project__r.IPM_Actual_Launch_Date__c, IPM_Parent_Project__c,
                                                   IPM_Parent_Project__r.IPM_Parent_Project__c, IPM_Parent_Project__r.IPM_Parent_Project__r.IPM_Actual_Launch_Date__c 
                                                   from IPM_Project__c where id=: project.Id]){
                                                       
                                                       //Regional Project for local project
                                                       if(localProject.IPM_Parent_Project__c != null && localProject.IPM_Parent_Project__r.IPM_Actual_Launch_Date__c == null){
                                                           lstProjectsToUpdate.add( new IPM_Project__c(Id= localProject.IPM_Parent_Project__c, IPM_Actual_Launch_Date__c = Date.today()));
                                                       }
                                                       
                                                       //GLobal Project for local project
                                                       if(localProject.IPM_Parent_Project__r.IPM_Parent_Project__c != null && localProject.IPM_Parent_Project__r.IPM_Parent_Project__r.IPM_Actual_Launch_Date__c == null){
                                                           lstProjectsToUpdate.add( new IPM_Project__c(Id= localProject.IPM_Parent_Project__r.IPM_Parent_Project__c, IPM_Actual_Launch_Date__c = Date.today()));
                                                       }
                                                   }   
            }
            if(!lstProjectsToUpdate.IsEmpty()){
                update lstProjectsToUpdate;
            }
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
                                                  'moveToPLE',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            
        }
    }
    
    
    /*******************************************************************************************
@description To Move the Gate Document to next phase When the Status is Approved with Edits
*/
    
    public static String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
    public static String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId();
    public static String MOVE_TO_NEXT_DOC_STR = 'moveToNextDocument'; 
    
    public void moveToNextDocument(){
        
        Date dt=date.parse(System.today().format());
        projectDoc.IPM_Approval_Date__c=dt;
        
        IPM_Project_Type__c currentProjectType =  IPM_Utils.retrieveProjectType(project);
        IPM_Project_Type__c nextPhaseProjectType = IPM_Utils.getNextPhase(currentProjectType,false);
        
        List<IPM_Project_Rollout__c> regionalRolloutList = new List<IPM_Project_Rollout__c>();
        List<IPM_Project_Rollout__c> localRolloutList = new List<IPM_Project_Rollout__c>();
        
        if(currentProjectType!=null && nextPhaseProjectType !=null && nextPhaseProjectType.IPM_Phase__c!=null)
        {
            project.IPM_Current_Document_Status__c = projectDoc.IPM_Document_Status__c;
            project.IPM_Document_Update_Date__c = Date.today();
            project.IPM_Document_Update_Comments__c = projectDoc.IPM_Approved_Comments__c;
            project.IPM_Phase__c = nextPhaseProjectType.IPM_Phase__c;
            
            if(currentProjectType.IPM_CreateRegionalProjectOnStatusChange__c)
            {
                Id currentProjectId = project.Id; // variable used in query below NO SONAR
                
                String rolloutQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Rollout__c',false,null,true);
                String rolloutWhereClause = ' WHERE IPM_Project__c =:currentProjectId  AND recordTypeId = :REGIONAL_ROLLOUT_RECORDTYPE limit 10000';
                rolloutWhereClause = rolloutQuery + rolloutWhereClause;
                regionalRolloutList = database.query(rolloutWhereClause);
                
                if(!regionalRolloutList.isEmpty())
                {
                    for(IPM_Project_Rollout__c rollout : regionalRolloutList)
                    {
                        rollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                        rollout.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE;  
                    }
                }
            }
            
            if(currentProjectType.IPM_CreateLocalProjectOnStatusChange__c)
            {
                Id currentProjectId = project.Id; // variable used in query below NO SONAR
                
                String rolloutQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Rollout__c',false,null,true);
                String rolloutWhereClause = ' WHERE Regional_Project__c  =:currentProjectId  AND recordTypeId = :LOCAL_ROLLOUT_RECORDTYPE limit 10000';
                rolloutWhereClause = rolloutQuery + rolloutWhereClause;
                localRolloutList = database.query(rolloutWhereClause);
                
                if(!localRolloutList.isEmpty())
                {
                    for(IPM_Project_Rollout__c rollout : localRolloutList)
                    {
                        rollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                        rollout.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE;  
                    }
                }
            }
        }
        
        
        System.SavePoint sp = Database.SetSavePoint();  
        try
        {   
            if(currentProjectType.IPM_CreateRegionalProjectOnStatusChange__c && regionalRolloutList!=null && !regionalRolloutList.isEmpty())
            {
                update regionalRolloutList; 
            }
            
            if(currentProjectType.IPM_CreateLocalProjectOnStatusChange__c && localRolloutList!=null && !localRolloutList.isEmpty())
            {
                update localRolloutList;
            }
            
            update project; 
        }
        catch (DmlException ex)
        {
            Database.Rollback(sp);
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
                                                  MOVE_TO_NEXT_DOC_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            
        }
        catch (Exception ex)
        {
            Database.Rollback(sp);
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
                                                  MOVE_TO_NEXT_DOC_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            
        }
    }
    
    /*******************************************************************************************
@description To get the document Appendix Sections List

*/
    
    public void getAppendixSections()
    {
        try{
            projDocAppdxSectionList=[SELECT ID,IPM_Section_Status__c,IPM_FunctionalRole__c,IPM_Master_Section_External_Id__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section_Sequence__c,IPM_Section_Name__c,IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c, IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c
                                     FROM IPM_Project_Document_Section__c 
                                     WHERE IPM_Project_Document__c=:projectDoc.Id 
                                     AND IPM_Has_Appendix__c=true AND IPM_Default_Section__c=true 
                                     ORDER BY IPM_Section_Sequence_Number__c asc limit 50000];
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
                                                  'getAppendixSections',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }               
    }
    
    /*******************************************************************************************
@description To get the rendering condition based on Document Status

*/
    public boolean isEditLinkAvailable(){
        isEditLinkActive=true;
        return isEditLinkActive;
    }
    
    /********************************************************************************************************************************
@Description: This method will be invoked on click of paperclip icon and will open up a modal containing summary side attachments                  
@param: none
@return: void
********************************************************************************************************************************/
    public void showAllCurrentDocSummaryAttch()
    {
        summaryAttachmentList=[SELECT Id,Name,ParentId,Description FROM Attachment WHERE ParentId IN (SELECT Id from IPM_Project_Document_Section__c where IPM_Project_Document__c =:projectDoc.Id) AND Description='summary']; 
        if(summaryAttachmentList.size()>0)
        {
            showSummaryAttach=true;
        }
        else
        {
            showSummaryAttach=false;
        }
        
    }
    
    /***********************************************************************
@Description: This method will be invoked on click of 'Cancel Stopping Project' button from Project Overview page. This method is responsible to revert the project
Document status to previous state from Stopped.     
@param: none
@return: void
**********************************************************************/
    public PageReference cancelStoppingProject()
    {   
        try
        {   
            if(System.now() < project.IPM_CancelStoppingProjectTill__c)
            {
                project.IPM_PrepareForArchival__c = false; 
                update project;
            }
            PageReference gateDocumentPage = Page.IPM_GateDocument;
            gateDocumentPage.getParameters().put(IPM_ConstantUtils.SF_ID, project.Id);
            gateDocumentPage.getParameters().put('printDoc', printDoc);
            gateDocumentPage.setRedirect(true);
            return gateDocumentPage;
        }
        catch (Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,system.label.IPM_System_Admin));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
                                                  'cancelStoppingProject',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);    
            
        }
        return null;
    }    
    
}