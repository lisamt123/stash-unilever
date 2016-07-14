/***********************************************************************************************************************************************************
* @author Cognizant
* @date  15/12/2014
* @description To Display Gate Document Sections
*/
public with sharing class IPM_GateDocumentController extends IPM_ProjectIntermediateController { 

    public List<IPM_Milestone__c> lstMstn;
    //String to replace duplicate string literals
    public static final String IPM_GATEDOCUMENTCONTR_STR = 'IPM_GateDocumentController';
    public static final String IPM_ANDFUNCTIONALROLE_STR = ' and (IPM_FunctionalRole__c=\'';
    public static final String IPM_ORFUNCTIONALROLE_STR =  ' OR IPM_FunctionalRole__c=\'';
    public static final String IPM_FUNCTIONALROLE_STR = '\' OR IPM_FunctionalRole__c=\'';
    //Variable Declarations
    public List<Attachment> attachmentList{get; set;} //Contains the Attachment
    public string typeFilters{get;set;} //Contains All Type Filter Values
    public string statusFilters{get;set;} //Contains All Status Filter Values
    public string roleFilters{get;set;} //Contains All Functional Role Filter Values
    public IPM_Country__c country {get; set;} //Contains country Record
    public IPM_Project_Document__c projectDoc {get; set;} //Contains Project Document Record
    public String projectId{get; set;} //Contains Project Id from Page URL Parameter
    public List<IPM_Project_Document_Section__c> projSectionList {get; set;} //Contains All Header Project Document Sections 
    public List<IPM_Project_Document_Section__c> projSubSectionList {get; set;} //Contains All Sub-Header Project Document Sections 
    public List<IPM_Project_Document_Section__c> projSubLevelSectionList{get;set;}
    public List<IPM_Project_Document_Section__c> projDocSectionList {get; set;} //Contains All Project Document Sections Used for Gate Document PDF
    public transient List<IPM_Project_Document_Section__c> projDocAppdxSectionList {get; set;} //Contains All Project Document Sections Related to Appendix
    public String dueDate{get;set;}
    public Boolean DueDateMsg{get;set;}
    //Type
    public Boolean IsNegotiable{get;set;} //Indicates Non-Negotiable Type Section
    public Boolean Isoptional{get;set;} //Indicates Negotiable Type Section
    public Boolean IsTypeAll{get; set;} //Indicates Both Non-Negotiable and Negotiable Type Sections
    
    //Status
    public Boolean IsStatusAll{get; set;} //Indicates Both Not-Started and Filled-In Status Sections
    public Boolean IsNotstarted{get;set;} //Indicates Status Not-Started Section
    public Boolean IsFilledIn{get;set;} //Indicates Status Filled-In Section
    
    //Functional role
    public Boolean IsRoleAll{get; set;} //Indicates All Functional Role Sections
    public Boolean IsBD{get;set;} //Indicates BD Functional Role Section
    public Boolean IsCMI{get;set;} //Indicates CMI Functional Role Section
    public Boolean IsCD{get;set;} //Indicates CD Functional Role Section
    public Boolean IsRnD{get;set;} //Indicates R&D Functional Role Section
    public Boolean IsSC{get;set;} //Indicates SC Functional Role Section
    public Boolean IsFinance{get;set;} //Indicates FINANCE Functional Role Section
    public Boolean IsBB{get;set;} //Indicates BB Functional Role Section
    public Boolean IsPL{get;set;} //Indicates CMI Functional Role Section
    
    //Total filter counts
    public integer NonNegotiableCount{get;set;} //Contains Number of Non-Negotiable Sections
    public integer OptionalCount{get;set;} //Contains Number of Negotiable Sections
    public integer NotstartedCount{get;set;} //Contains Number of Status Not-Started Sections
    public integer FilledinCount{get;set;} //Contains Number of Status Filled-In Sections
    public integer ExcludedCount{get;set;}  //Contains Number of Status Excluded Sections
    public integer BDCount{get;set;}  //Contains Number of Functional Role BD Sections
    public integer CMICount{get;set;}  //Contains Number of Functional Role CMI Sections
    public integer CDCount{get;set;}  //Contains Number of Functional Role CD Sections
    public integer RnDCount{get;set;}  //Contains Number of Functional Role R&D Sections
    public integer FinanceCount{get;set;}  //Contains Number of Functional Role Finance Sections
    public integer BBCount{get;set;} //Contains Number of Functional Role BB Sections
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
    public string gateDocument{get;set;} //Contains Gate Document Type
    
    
    //get user types
    public Boolean isReadable{get;set;} //For Readable Mode
    
    public String printDoc{get;set;} //Contains Gate Document Type for Referring Old Document
    public IPM_Financial__c fin {get; set;} //Contains Financial Record
    public IPM_Financial__c finRegional{get;set;}// for Financial Regional Business Impact
    public IPM_Financial__c finLocal{get;set;}// for Financial Local Business Impact
    public string globalbusinessImpactStr  {get; set;}//DEF2450
    public IPM_Financial__c finProjectPriority {get; set;} //Contains Financial Record
    public list<IPM_Project_Rollout__c> rollOut {get; set;} //Contains Rollout Records
    public List<IPM_Project_Document_Section__c> filtersCountList{get;set;} //Contains Text Type Project Document Sections
    
    //For Filled-In Percentage
    public Integer NonNegotiable;
    public Integer removeoptional;
    
    
    public ID parentSectionId{get;set;}
    public ID sectionId{get;set;}
    
    //variables for VF Rendering Conditions
    public Boolean isEditLinkActive{get;set;}
    public Boolean showIntroHeader{get;set;}
    public Boolean showExtHeader{get;set;}
    public Boolean showMixHeader{get;set;}
    public Boolean showDepHeader{get;set;}
    public Boolean showTechHeader{get;set;}
    public Boolean showFinHeader{get;set;}
    public Boolean showPMHeader{get;set;}
    //@Description:download PDF
    public Boolean isPDFDownload{get;set;}
    public boolean isExemptFromThresholdITO {get;set;}
    public Boolean showAttach{get;set;}
    
    public Set<String> proSubSectionParentsSequenceList1;//DEF1474 - contains all headers sequence
    
    public Static final String ENVIRONMENTAL_IMPACT = 'Environmental_Impact';
    public Boolean bDocStatusNotStartedOrApproved{get;set;}//Flag to check if document is in Not Started or Approved Status
    public string regionalCPP {get;set;}
    public string localCPP {get;set;}
    public string brandPosition {get; set;}
	//phase 2.0 variables
    public boolean isWithAppendix{get;set;}//set boolean value to display appendix on gate document PDF page
    public boolean isDisplayWithoutAppendix{get;set;}//check whether without appendix pdf to display on page or not
    public boolean reactivateProjectFlag{get; set;} // Boolean to display the 'Reactivate Project'
    /****************************************************************************************************************************************************
    @description Retrieving Project,Project Document,Project Document Section Records Using Page URL Parameters and Initializing the Values for Variables
    */
    public IPM_GateDocumentController()
    {
        super();    
        showAttach=false;
        isReadable=true;
        IsUpdateStatus=false;
        isPDFDownload=true;
        isExemptFromThresholdITO=false;
        bDocStatusNotStartedOrApproved = false;
		isDisplayWithoutAppendix=false;//phase 2.0
        isWithAppendix=true;
        //Total filter counts
        NonNegotiableCount=0;
        OptionalCount=0;
        NotstartedCount=0;
        FilledinCount=0;
        ExcludedCount=0;
        BDCount=0;
        CMICount=0;
        CDCount=0;
        RnDCount=0;
        FinanceCount=0;
        BBCount=0;
        SCCount=0;
        PLCount=0;
        FilledinPer=0;
        
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
        
        //To Retrieve Project, Project Document Record
        getProjectDocument();
        
        // to calculate the count of various parameters
        filtersCountList=[SELECT IPM_Section__r.IPM_Section_Sequence__c, IPM_Section_Sequence__c, IPM_Section__r.IPM_Negotiable__c,IPM_Section_Status__c,IPM_FunctionalRole__c, IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c,IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c 
                          FROM IPM_Project_Document_Section__c 
                          WHERE IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_HEADER and 
                          IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER and IPM_Default_Section__c=true
		];
        
        for(IPM_Project_Document_Section__c filterCount:filtersCountList){
            if(filterCount.IPM_Section__c!=null && filterCount.IPM_Section__r.IPM_Negotiable__c!=null && !filterCount.IPM_Section__r.IPM_Negotiable__c){
                NonNegotiableCount++; // count of Non-Negotiable Sections
                // below counts used to display count of Non Negotiables on the Accordian Headers
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.INTRODUCTION_HEADER_SEQUENCE)){
                    IntroNegotiable++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.EXTERNAL_HEADER_SEQUENCE)){
                    ExterNegotiable++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.MIX_HEADER_SEQUENCE)){
                    MixNegotiable++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.DEPLOYMENT_HEADER_SEQUENCE)){
                    DeploNegotiable++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.TECHNICAL_HEADER_SEQUENCE)){
                    TechNegotiable++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.FINANCE_HEADER_SEQUENCE)){
                    FinNegotiable++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.PROJECT_MANAGEMENT_HEADER_SEQUENCE)){
                    ProMNegotiable++;
                }
            }
            
            if(filterCount.IPM_Section__r.IPM_Negotiable__c!=null && filterCount.IPM_Section__r.IPM_Negotiable__c){
                OptionalCount++; // count of Negotiable Sections
                // below counts used to display count of Optionals on the Accordian Headers
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.INTRODUCTION_HEADER_SEQUENCE)){
                    IntroOptional++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.EXTERNAL_HEADER_SEQUENCE)){
                    ExterOptional++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.MIX_HEADER_SEQUENCE)){
                    MixOptional++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.DEPLOYMENT_HEADER_SEQUENCE)){
                    DeploOptional++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.TECHNICAL_HEADER_SEQUENCE)){
                    TechOptional++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.FINANCE_HEADER_SEQUENCE)){
                    FinOptional++;
                }
                if(filterCount.IPM_Section__r.IPM_Section_Sequence__c.startsWith(IPM_ConstantUtils.PROJECT_MANAGEMENT_HEADER_SEQUENCE)){
                    ProMOptional++;
                }
            }
            
            if(filterCount.IPM_Section_Status__c==IPM_ConstantUtils.STATUS_NOT_STARTED){
                NotstartedCount++; //Count Not Started Sections
            }
            if(filterCount.IPM_Section_Status__c==IPM_ConstantUtils.SECTION_STATUS_FILLED){
                FilledinCount++; //Count Filled In Sections
            }
            if(filterCount.IPM_Section_Status__c==IPM_ConstantUtils.STATUS_EXCLUDED){
                ExcludedCount++; //Count Excluded In Sections
            }
            // counts based on various Functional roles
            if(filterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_BD){
                BDCount++;
            }
            if(filterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI){
                CMICount++;
            }
            if(filterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_CD){
                CDCount++;
            }
            if(filterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_RD){
                RnDCount++;
            }
            if(filterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_Finance){
                FinanceCount++;
            }
            if(filterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_BB){
                BBCount++;
            }
            if(filterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_SC){
                SCCount++;
            }
             if(filterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_PL){
                PLCount++;
            }
        }
        
        //Getting Local Project Country feedbacks
        lstCountryFeedback=new list<IPM_Project_Document_Section__c>();
        lstCountryFeedback=[SELECT IPM_Section_Name__c,IPM_Gate_Document_Summary__c,IPM_Section_Sequence__c,IPM_Project_ID__c,IPM_Section_Sequence_Number__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_GateDocuments__c 
                            FROM IPM_Project_Document_Section__c 
                            WHERE IPM_Section_Sequence_Number__c=:IPM_ConstantUtils.DYNAMIC_SECTION_SEQUENCE];
        
        
        //Getting Project Document Sections  
        getProjectDocumentSection();
        getDocumentSectionMap();
        gateDocumentData(project.Id);
        If(projectDoc.IPM_Document_Status__c==IPM_ConstantUtils.STATUS_NOT_STARTED || projectDoc.IPM_Document_Status__c==IPM_ConstantUtils.STATUS_APPROVED){
            bDocStatusNotStartedOrApproved = true;
            //For Storing Filled-In Percentage Calculation in Project Object 
            Integer NonNegotiable=[SELECT count() FROM IPM_Project_Document_Section__c 
                                   WHERE IPM_Default_Section__c=true AND IPM_Project_Document__c=:projectDoc.Id AND IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_HEADER AND 
                                   IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER AND IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c!=:IPM_ConstantUtils.APPENDIX];
            Integer removeoptional=[SELECT count() FROM IPM_Project_Document_Section__c 
                                    WHERE IPM_Section_Status__c=:IPM_ConstantUtils.SECTION_STATUS_FILLED AND IPM_Project_Document__c=:projectDoc.Id AND  IPM_Default_Section__c=true AND 
                                    IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_HEADER AND IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER AND IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c!=:IPM_ConstantUtils.APPENDIX];
            if(NonNegotiable!=0){
                FilledinPer=math.round((Decimal.valueof(removeoptional)/decimal.valueof(NonNegotiable))*100);
            }
        }
        if((((IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(project.IPM_Project_Type__c))) || 
        (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(project.IPM_Project_Type__c))) || 
        (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equalsIgnoreCase(project.IPM_Project_Type__c)))) && (project.Exempt_from_Threshold__c))){
         isExemptFromThresholdITO = true;
        }
        /*** Logic to Display the "Reactivate Project" button on Gate Document page for IPM Business Partner   
   			For Stopped project in Ideas phase for 38 months, "Reactivate Project" button will be displayed for IPM Business Partner
       ***/
       Integer noOfMonths = Integer.valueOf(Label.IPM_NoOfMonths_ForReactivation);
       Date dateToCompare = System.today().addMonths(-noOfMonths); 
       if(project.IPM_EligibleForReactivation__c && project.IPM_Stopped_Date_Time__c > dateToCompare)
       {
   	      //security for central team and BP users
          IPM_CustomPermission custPermission = new IPM_CustomPermission();
          reactivateProjectFlag = custPermission.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
       }
    } 
    
    /*************************************************************************************************************************************************************
    @description Getting Project and Project Document
    */ 
    public void getProjectDocument()
    {
        //Retrieving Project Record Using Page URL Parameter Id
        projectId=ApexPages.currentPage().getParameters().get('Id');
        printDoc=ApexPages.currentPage().getParameters().get('printDoc');
        if(String.IsNotBlank(String.valueOf(projectId)) && String.IsNotBlank(String.valueOf(printDoc))){
            getIpmuserType();  
            gateDocument=printDoc;
            //Retrieving Project Document Record    
            List<IPM_Project_Document__c> lstProjectDoc = new List<IPM_Project_Document__c>();
            lstProjectDoc=[SELECT Id,IPM_Contract_GateKeeper_Model__c,IPM_Category_Status_while_Approved__c ,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Updated_User_By__r.smallPhotoURL,
                                  IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c,IPM_Updated_User_By__c,IPM_Updated_User_By__r.Name 
                           FROM IPM_Project_Document__c 
                           WHERE IPM_Project__c=:project.Id AND IPM_GateDocuments__c=:gateDocument];
            if(!lstProjectDoc.isEmpty()){
                projectDoc = lstProjectDoc[0];
				//Phase 2.0-Check gate document as all four gates.
                if((IPM_ConstantUtils.CHARTER_GATE.Equals(projectDoc.IPM_GateDocuments__c)||IPM_ConstantUtils.CONTRACT_GATE.Equals(projectDoc.IPM_GateDocuments__c)||
                IPM_ConstantUtils.MARKET_READY_GATE.Equals(projectDoc.IPM_GateDocuments__c)||IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE.Equals(projectDoc.IPM_GateDocuments__c))&&isPDFDownload){
                	isDisplayWithoutAppendix=true;		
                }
                isEditLinkAvailable();
            }
            
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
    }
    
    /*************************************************************************************************************************************************************
    @description Getting user type with access permission
    */ 
    public void getIpmuserType(){
        try{
            Integer guestCount=0;
            guestCount=[SELECT COUNT() FROM IPM_Project_Resource__c 
                        WHERE IPM_Role_Type__c=:IPM_ConstantUtils.IPM_ROLE_GUEST AND IPM_Project__c=:projectId AND 
                              IPM_User__c=:userinfo.getuserid()  AND IPM_Project__r.Is_Archieved__c=false LIMIT 1];
            if(guestCount>0){
                isPDFDownload=false;
            }
            IPM_Project__c associatedProject = null; 
            //Getting Current Logged-In User Role Type and Assigning Permission
            list<IPM_Project__c> projectList=[SELECT IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c, IPM_PrepareForArchival__c, Is_Archieved__c 
                                            FROM IPM_Project__c 
                                            WHERE id=:projectId AND (IPM_Project_Leader__c =:userinfo.getuserid() 
                                                                     OR Deputy_Project_Leader__c=:userinfo.getuserid())  limit 1];
            if(projectList!=null && !projectList.isEmpty()){
                isReadable=false;
                IsUpdateStatus=true;
                associatedProject = projectList[0];
            }
            
            //security for central team and BP users
            IPM_CustomPermission cpr = new IPM_CustomPermission();
            boolean isCentralTeam=false;
            boolean isBPUser=false;
            isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
            isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
            if(isCentralTeam || isBPUser){
                IsUpdateStatus=true;
                isReadable=false;
                
            }   
           	if(associatedProject !=null)
            {
                if(IsUpdateStatus)
                {
            		IsUpdateStatus = !(associatedProject.Is_Archieved__c || associatedProject.IPM_PrepareForArchival__c);
            	}
 
	            if(associatedProject.Is_Archieved__c || associatedProject.IPM_PrepareForArchival__c)
	            {
            		isReadable = true;
                } 
            }    
            
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
                'getIpmuserType',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            
        }
    }   
    
    /*************************************************************************************************************************************************************
    @description To filter the sections based on selection
    */ 
    
    public Set<String> proSubSectionParentsSequenceList{get;set;}
    public String proSubSectionParentsSequences{get;set;}
    public void filterSections(){ 
        
        //Initializing the Variables
        NonNegotiableCount=0;
        OptionalCount=0;
        NotstartedCount=0;
        FilledinCount=0;
        ExcludedCount=0;
        BDCount=0;
        CMICount=0;
        CDCount=0;
        RnDCount=0;
        FinanceCount=0;
        BBCount=0;
        SCCount=0;
        PLCount=0;
        Integer zero=0;
        //Getting Header Sections
        getProjectDocumentSection();
        
        //For Getting Sub-Header Sections
        String Query='SELECT Id,IPM_Master_Section_External_Id__c,IPM_Count_of_Comments__c,IPM_Default_Section__c,IPM_FunctionalRole__c,IPM_GateHistory_Date__c,IPM_GateHistory__c,IPM_Gate_Document_Summary__c,IPM_Is_Excluded__c,IPM_Negotiable__c,IPM_PDPHistoty_Date__c,IPM_PDPHistoty__c,IPM_PDP_Document_Summary__c,IPM_Project_Document__c,IPM_Project_ID__c,IPM_Project_Section__c,IPM_Section_Help_Text_Long__c,IPM_Section_Help_Text__c,IPM_Section_Name__c,IPM_Section_Owner__c,IPM_Section_Sequence_Number__c,IPM_Section_Sequence__c,IPM_Section_Status__c,IPM_Section_Type__c,IPM_Section__c,Name,IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Section__r.IPM_Section_Name__c,IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c, IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c , IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Sequence__c, IPM_Has_Appendix__c FROM IPM_Project_Document_Section__c WHERE IPM_Project_Document__c= \'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Is_Parent_Exist__c =true and IPM_Default_Section__c=true';
        String filterValue='';
        Integer roleCount=0;
        
        //For Getting Sections Other than Headers and Sub-Headers
        String secFilterQuery='SELECT IPM_Section__r.IPM_Section_Sequence__c,IPM_Section__r.IPM_Negotiable__c,IPM_Section_Status__c,IPM_FunctionalRole__c,IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c,IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c  FROM IPM_Project_Document_Section__c WHERE IPM_Default_Section__c=true and IPM_Project_Document__c=\''+projectDoc.Id+'\' and IPM_Section__r.IPM_Section_Type__c!=\''+IPM_ConstantUtils.SECTION_TYPE_HEADER+'\' and IPM_Section__r.IPM_Section_Type__c!=\''+IPM_ConstantUtils.SECTION_TYPE_SUBHEADER+'\'';
        
        
        /*For Type Filter*/
        if(String.IsNotBlank(String.valueOf(IsTypeAll)) && IsTypeAll){
            filterValue=filterValue+' and (IPM_Section__r.IPM_Negotiable__c=true OR IPM_Section__r.IPM_Negotiable__c=false)';
        }
        else{
            if(String.IsNotBlank(String.valueOf(IsNegotiable)) && IsNegotiable)
            {
                filterValue=filterValue+' and IPM_Section__r.IPM_Negotiable__c=false';
            }
            if(Isoptional != null && Isoptional)
            {
                filterValue=filterValue+' and IPM_Section__r.IPM_Negotiable__c=true';
            }    
        }
        
        /*For Status Filter*/
        if(String.IsNotBlank(String.valueOf(IsStatusAll)) && IsStatusAll){
            filterValue=filterValue+' and (IPM_Section_Status__c=\''+IPM_ConstantUtils.STATUS_NOT_STARTED+'\' OR IPM_Section_Status__c=\''+IPM_ConstantUtils.SECTION_STATUS_FILLED+'\')';
        }
        else{
            if(String.IsNotBlank(String.valueOf(IsNotstarted)) && IsNotstarted)
            {
                filterValue=filterValue+' and IPM_Section_Status__c=\''+IPM_ConstantUtils.STATUS_NOT_STARTED+'\'';
            }    
            if(IsFilledIn != null && IsFilledIn)
            {
                filterValue=filterValue+' and IPM_Section_Status__c=\''+IPM_ConstantUtils.SECTION_STATUS_FILLED+'\'';
            }    
        }
        
        /*For Functional Role Filter*/
        if(String.IsNotBlank(String.valueOf(IsRoleAll)) && IsRoleAll){
            filterValue=filterValue+IPM_ANDFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_BD+IPM_FUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI+IPM_FUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_CD+IPM_FUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_RD+IPM_FUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_SC+IPM_FUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE+IPM_FUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_BB+IPM_FUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_PL+'\')'; //+IPM_FUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_PL      
        }
        else{
            if(String.IsNotBlank(String.valueOf(IsBD)) && IsBD){
                filterValue=filterValue+IPM_ANDFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_BD+'\'';
                roleCount++;
            }
            if(String.IsNotBlank(String.valueOf(IsCMI)) && IsCMI){
                if(roleCount>zero){
                    filterValue=filterValue+IPM_ORFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI+'\'';
                }
                else{
                    filterValue=filterValue+IPM_ANDFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI+'\'';
                    roleCount++;
                }
            }
            if(String.IsNotBlank(String.valueOf(IsCD)) && IsCD){
                if(roleCount>zero){
                    filterValue=filterValue+IPM_ORFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_CD+'\'';
                }
                else{
                    filterValue=filterValue+IPM_ANDFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_CD+'\'';
                    roleCount++;
                }
            }
            if(String.IsNotBlank(String.valueOf(IsRnD)) && IsRnD){
                if(roleCount>zero){
                    filterValue=filterValue+IPM_ORFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_RD+'\'';
                }
                else{
                    filterValue=filterValue+IPM_ANDFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_RD+'\'';
                    roleCount++;
                }
            }
            if(String.IsNotBlank(String.valueOf(IsSC)) && IsSC){
                if(roleCount>zero){
                    filterValue=filterValue+IPM_ORFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_SC+'\'';
                }
                else{
                    filterValue=filterValue+IPM_ANDFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_SC+'\'';
                    roleCount++;
                }
            }
            if(String.IsNotBlank(String.valueOf(IsFinance)) && IsFinance){
                if(roleCount>zero){
                    filterValue=filterValue+IPM_ORFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE+'\'';
                }
                else{
                    filterValue=filterValue+IPM_ANDFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE+'\'';
                    roleCount++;
                }
            }
            if(String.IsNotBlank(String.valueOf(IsBB)) && IsBB){
                if(roleCount>zero){
                    filterValue=filterValue+IPM_ORFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_BB+'\'';
                }
                else{
                    filterValue=filterValue+IPM_ANDFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_BB+'\'';
                    roleCount++;
                }
            }
             if(String.IsNotBlank(String.valueOf(IsPL)) && IsPL){
                if(roleCount>zero){
                    filterValue=filterValue+IPM_ORFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_PL+'\'';
                }
                else{
                    filterValue=filterValue+IPM_ANDFUNCTIONALROLE_STR+IPM_ConstantUtils.FUNCTIONAL_ROLE_PL+'\'';
                    roleCount++;
                }
            }
            if(roleCount>zero)
            {
                filterValue=filterValue+')';
            }    
        }
        
        //Retrieving Project Document Section Records Based on Filter Values
        List <IPM_Project_Document_Section__c> secFilterList=new  List <IPM_Project_Document_Section__c>();
        try{
            
            Query=Query+filterValue+' order by IPM_Section__r.IPM_Section_Sequence__c asc';
            projSubSectionList=Database.query(Query);
            
            
            proSubSectionParentsSequenceList = new Set<String>();
            for(IPM_Project_Document_Section__c temp : projSubSectionList){
                if(temp.IPM_Section__r.IPM_Parent_Section__c != null && 
                    !proSectionParentsSequenceList.contains(temp.IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Sequence__c) )
                {
                        proSubSectionParentsSequenceList.add(temp.IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Sequence__c);
                }
            }
            
            for(String tempStr : proSubSectionParentsSequenceList){
                proSubSectionParentsSequences += ' ' + tempStr;
            }
            secFilterList=Database.query(secFilterQuery+filterValue);
            //Start - DEF2056 - logic to show subheaders on applying filter
            proSubSectionParentsSequenceList1 = new Set<String>();
            for(IPM_Project_Document_Section__c tempProDocSection : projSubSectionList){
                if(tempProDocSection.IPM_Section__r.IPM_Parent_Section__c != null && 
                    !proSectionParentsSequenceList.contains(tempProDocSection.IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Sequence__c))
                {                    
                    proSubSectionParentsSequenceList1.add(tempProDocSection.IPM_Section__r.IPM_Parent_Section__c);
                }
            }
            
            List<IPM_Project_Document_Section__c> requiredSubHeadersProDocSectionList;
            if(proSubSectionParentsSequenceList1 != null && !proSubSectionParentsSequenceList1.isEmpty()){
                requiredSubHeadersProDocSectionList = [Select Id,IPM_Count_of_Comments__c,IPM_Default_Section__c,IPM_FunctionalRole__c,IPM_GateHistory_Date__c,
                        IPM_GateHistory__c,IPM_Gate_Document_Summary__c,IPM_Is_Excluded__c,IPM_Negotiable__c,IPM_PDPHistoty_Date__c,IPM_PDPHistoty__c,
                        IPM_PDP_Document_Summary__c,IPM_Project_Document__c,IPM_Project_ID__c,IPM_Project_Section__c,IPM_Section_Help_Text_Long__c,IPM_Section_Help_Text__c,
                        IPM_Section_Name__c,IPM_Section_Owner__c,IPM_Section_Sequence_Number__c,IPM_Section_Sequence__c,IPM_Section_Status__c,IPM_Section_Type__c,
                        IPM_Section__c,Name,IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Section__r.IPM_Section_Type__c,
                        IPM_Section__r.IPM_Section_Sequence__c,IPM_Section__r.IPM_Section_Name__c,IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c, IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c, 
                        IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Sequence__c, IPM_Section__r.IPM_Parent_Section__r.IPM_Section_type__c FROM IPM_Project_Document_Section__c 
                        where IPM_Project_Document__c =: projectDoc.Id and IPM_Section__c in : proSubSectionParentsSequenceList1];
            }
            
            if(requiredSubHeadersProDocSectionList != null && !requiredSubHeadersProDocSectionList.isEmpty()){
                projSubSectionList.addAll(requiredSubHeadersProDocSectionList);
            }
            
            List<ProjectSubSectionsWrapper> ProjectSubSectionsWrapperList = new List<ProjectSubSectionsWrapper>();
            Set<Id> sectionsIds = new Set<Id>();
            if(projSubSectionList != null && !projSubSectionList.isEmpty()){
                for(IPM_Project_Document_Section__c tempSection : projSubSectionList){
                    ProjectSubSectionsWrapperList.add(new ProjectSubSectionsWrapper(tempSection));
                    sectionsIds.add(tempSection.IPM_Section__c);
                }
            }
            
            if(sectionsIds != null && !sectionsIds.isEmpty()){
                //Start - DEF2770 
                String queryForSubLevel = 'SELECT Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c, IPM_Section_Sequence__c, '
                                    + 'IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,'
                                    + 'IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Project_Document__c,'
                                    + 'IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Count_of_Comments__c,IPM_FunctionalRole__c,IPM_Has_Appendix__c,'
                                    + 'IPM_GateHistory__c,IPM_GateHistory_Date__c,IPM_Gate_Document_Summary__c,LastModifiedBy.Name,LastModifiedDate,IPM_Master_Section_External_Id__c' 
                                    + ' FROM IPM_Project_Document_Section__c WHERE IPM_Project_Document__c= \''+ projectDoc.Id + '\'' +' AND IPM_Section__r.IPM_Parent_Section__r.ID in:sectionsIds AND IPM_Default_Section__c=true';
                                    
                queryForSubLevel = queryForSubLevel + filterValue + ' order by IPM_Section__r.IPM_Section_Sequence__c asc limit 50000'; 
                
                projSubLevelSectionList = Database.query(queryForSubLevel);   
                //END - DEF2770                  
            }
            
            if(ProjectSubSectionsWrapperList != null && !ProjectSubSectionsWrapperList.isEmpty()){
                ProjectSubSectionsWrapperList.sort();
                projSubSectionList.clear();
                for(ProjectSubSectionsWrapper tempWrapper : ProjectSubSectionsWrapperList){
                    projSubSectionList.add(tempWrapper.projDocSection);
                }
            }
            //End - DEF2056
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
        'filterSections',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        //Counting Number of Project Document Sections by Status,Type and Functional Role After Applying Filter
        for(IPM_Project_Document_Section__c secFilterCount:secFilterList){
            
            //Counts Based on Section Type
            if(String.IsNotBlank(String.valueOf(secFilterCount.IPM_Section__r.IPM_Negotiable__c)) && !secFilterCount.IPM_Section__r.IPM_Negotiable__c){
                NonNegotiableCount++; 
            }
            if(String.IsNotBlank(String.valueOf(secFilterCount.IPM_Section__r.IPM_Negotiable__c)) && secFilterCount.IPM_Section__r.IPM_Negotiable__c){
                OptionalCount++; 
            }
            
            //Counts Based on Section Status
            if(secFilterCount.IPM_Section_Status__c==IPM_ConstantUtils.STATUS_NOT_STARTED){
                NotstartedCount++; 
            }
            if(secFilterCount.IPM_Section_Status__c==IPM_ConstantUtils.SECTION_STATUS_FILLED){
                FilledinCount++; 
            }
            if(secFilterCount.IPM_Section_Status__c==IPM_ConstantUtils.STATUS_EXCLUDED){
                ExcludedCount++;
            }
            
            //Counts Based on Various Functional Roles
            if(secFilterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_BD){
                BDCount++;
            }
            if(secFilterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI){
                CMICount++;
            }
            if(secFilterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_CD){
                CDCount++;
            }
            if(secFilterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_RD){
                RnDCount++;
            }
            if(secFilterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE){
                FinanceCount++;
            }
            if(secFilterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_BB){
                BBCount++;
            }
            if(secFilterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_SC){
                SCCount++;
            }
            if(secFilterCount.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_PL){
                PLCount++;
            }
        }
        IsBD = false;
        IsCMI = false;
        IsCD = false;
        IsRnD = false;
        IsSC = false;
        IsFinance = false;
        IsBB = false;
        ISPL=false;
        IsRoleAll = false;
        IsTypeAll = false;
        IsNegotiable = false;
        Isoptional = false;
        IsStatusAll = false;
        IsNotstarted = false;
        IsFilledIn = false;
    }
    
    /*************************************************************************************************************************************************************
    @description To Get Project Document Sections(Header)
    */ 
    public Set<String> proSectionParentsSequenceList; 
    public void getProjectDocumentSection(){
        //Retrieving Header Project Document Sections for Gate Document
        try{
            showIntroHeader=false;
            showExtHeader=false;
            showMixHeader=false;
            showDepHeader=false;
            showTechHeader=false;
            showFinHeader=false;
            showPMHeader=false;
            projSectionList=[SELECT Id,IPM_Section__c, IPM_Section_Sequence__c, IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,
                             IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,
                             IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c,IPM_Has_Appendix__c, 
                             IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c, IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c
                             FROM IPM_Project_Document_Section__c 
                             WHERE IPM_Project_Document__c=:projectDoc.Id AND IPM_Section__r.IPM_Is_Parent_Exist__c=false AND IPM_Section__r.IPM_Section_Sequence__c!='8' order by IPM_Section__r.IPM_Section_Sequence__c asc limit 50000]; 
            //need to remove filter condition of 8*
            proSectionParentsSequenceList = new Set<String>();
            
            for(IPM_Project_Document_Section__c proSec : projSectionList){
                proSectionParentsSequenceList.add(proSec.IPM_Section__r.IPM_Section_Sequence__c);
               // showHeader(proSec);              
                                
            }              
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    } 
    
    /*************************************************************************************************************************************************************
    @description To Get Project Document Sections(Sub-Headers)
    */
    public List<IPM_Project_Document_Section__c> proDocSectionListForAppendix{get;set;} 
    public string appendixCCId{get;set;} 
    public void getDocumentSectionMap(){
        //Retrieving Sub-Header and Other Type Project Document Sections for Gate Document
        try{
            projSubSectionList=[SELECT Id,IPM_GateHistory__c, IPM_Section_Sequence__c, IPM_GateHistory_Date__c,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,
                                IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,
                                LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Project_Document__c,
                                IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c,IPM_FunctionalRole__c,
                                IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c, IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c, IPM_Master_Section_External_Id__c,IPM_Has_Appendix__c  
                                FROM IPM_Project_Document_Section__c 
                                WHERE IPM_Project_Document__c=:projectDoc.Id AND IPM_Section__r.IPM_Is_Parent_Exist__c =true AND IPM_Default_Section__c=true AND (IPM_Section_Sequence__c like '1%' or IPM_Section_Sequence__c like '8%') 
                                order by IPM_Section__r.IPM_Section_Sequence__c asc limit 50000];
            
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
    public PageReference exportToPdf(){ 
        try{
            PageReference url = null;
            url = Page.IPM_GateDocumentPDF;
            url.setRedirect(false);
            gateDocumentData(project.Id);
            //PDF Download Parameters
            Apexpages.currentPage().getHeaders().put(IPM_ConstantUtils.ATTACHMENT_CONTENT_DISPOSITION, IPM_ConstantUtils.ATTACHMENT_FILE_NAME+project.IPM_Project_Name__c+ '_'+projectDoc.IPM_GateDocuments__c+IPM_ConstantUtils.ATTACHMENT_DOCUMENT+system.today().format()+IPM_ConstantUtils.ATTACHMENT_FILE_TYPE);
            return url;
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
                'exportToPdf',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);

            return null;
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
				if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
				{
					fin=[SELECT id,ipm_cpp_local__c,Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,Year_3_iTO_MR__c,Year_3_iTO_MD__c,Business_Impact_Global__c,
					            Business_Impact_Local__c,Business_Impact_Regional__c,Year_3_iTO_Global__c,Year_3_iTO_Local__c,Year_3_iTO_Regional__c,
					            IPM_Business_Impact_Charter__c,IPM_Business_Impact_Contract__c,IPM_Business_Impact_MR__c,IPM_Business_Impact_MD__c 
						 FROM IPM_Financial__c 
						 WHERE Parent_Project__c=:project.Id AND Financial_External_ID__c=:nam+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
 			            globalbusinessImpactStr = gateDocument==IPM_ConstantUtils.CHARTER_GATE? fin.Business_Impact_Global__c:fin.Business_Impact_Regional__c;
				}
				else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
				{		
					fin=[SELECT id,ipm_cpp_local__c,Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,Year_3_iTO_MR__c,Year_3_iTO_MD__c,
								Business_Impact_Global__c,Business_Impact_Local__c,Business_Impact_Regional__c,Year_3_iTO_Global__c,
								Year_3_iTO_Local__c,Year_3_iTO_Regional__c,IPM_Business_Impact_Charter__c,IPM_Business_Impact_Contract__c,IPM_Business_Impact_MR__c,IPM_Business_Impact_MD__c
						 FROM IPM_Financial__c 
						 WHERE Regional_Project__c=:project.Id AND Financial_External_ID__c=:nam+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
					     globalbusinessImpactStr = fin.Business_Impact_Regional__c;						
					
					if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)
					{						
						finRegional=[SELECT id,ipm_cpp_local__c,Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,Year_3_iTO_MR__c,Year_3_iTO_MD__c,
								Business_Impact_Global__c,Business_Impact_Local__c,Business_Impact_Regional__c,Year_3_iTO_Global__c,
								Year_3_iTO_Local__c,Year_3_iTO_Regional__c,IPM_Business_Impact_Charter__c,IPM_Business_Impact_Contract__c,IPM_Business_Impact_MR__c,IPM_Business_Impact_MD__c
						 FROM IPM_Financial__c 
						 WHERE Parent_Project__c=:project.IPM_Parent_Project__c AND Financial_External_ID__c=:project.IPM_Parent_Project__r.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
						 globalbusinessImpactStr = finRegional.Business_Impact_Regional__c;
					}
				}
				else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
				{
					
					fin = [SELECT ipm_cpp_local__c,ipm_cpp_regional__c, Year_3_iTO_Local__c,Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,Year_3_iTO_MR__c,
								   Year_3_iTO_MD__c,Business_Impact_Local__c 
							FROM IPM_Financial__c 
							WHERE Financial_External_ID__c =: nam limit 1];
					localCPP = fin.ipm_cpp_local__c;
					regionalCPP = fin.ipm_cpp_regional__c;
							
					string parentProjectType=project.IPM_Parent_Project__r.IPM_Project_Type__c;					
					if(parentProjectType==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
					{
						finLocal=[SELECT Business_Impact_Regional__c,IPM_Business_Impact_Charter__c,IPM_Business_Impact_Contract__c,IPM_Business_Impact_MR__c,IPM_Business_Impact_MD__c FROM IPM_Financial__c 
								  WHERE Regional_Project__c=:project.IPM_Parent_Project__c 
								  AND Financial_External_ID__c=:project.IPM_Parent_Project__r.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
						 globalbusinessImpactStr = finLocal.Business_Impact_Regional__c;
					}
					else if(parentProjectType==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)// traverse to its Global Project for getting BI from CONSOLIDATED Financial
					{
						IPM_Project__c globalParentId= [Select IPM_Parent_Project__r.IPM_Parent_Project__c,IPM_Parent_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c FROM IPM_Project__c where ID=:project.Id];
						finLocal=[SELECT Business_Impact_Global__c,Business_Impact_Regional__c,IPM_Business_Impact_Charter__c,IPM_Business_Impact_Contract__c,IPM_Business_Impact_MR__c,IPM_Business_Impact_MD__c FROM IPM_Financial__c 
								 WHERE Parent_Project__c=:globalParentId.IPM_Parent_Project__r.IPM_Parent_Project__c
								 AND Financial_External_ID__c=:globalParentId.IPM_Parent_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
						 
						 
						 globalbusinessImpactStr = finLocal.Business_Impact_Regional__c;
					}
					
				}
			}
			// For BI and Year3Ito where Source is ORIGINAL project. Will work got GKM5,GKM6,GKM7 OPERATIONAL
			else if(project.IPM_SourceProjectType__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
			{
				globalbusinessImpactStr = IPM_ConstantUtils.BLANK;
				fin= [SELECT ipm_cpp_local__c,Year_3_iTO_Global__c,Year_3_iTO_Local__c,Year_3_iTO_Regional__c,
				             Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,
				             Year_3_iTO_MR__c,Year_3_iTO_MD__c 
				      FROM IPM_Financial__c WHERE Financial_External_ID__c =: nam limit 1];

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
           
            if(isWithAppendix){
            	getAppendixSections();
            }
	
	}
	catch(Exception ex){
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
	}
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
    
    /*****************************************************************
    @description Getting Selected Filter Values from gate Document
    */
    public void setFilter(){
        String[] types;
        String[] statuses;
        String[] roles;
        types=typeFilters.split(',');
        statuses=statusFilters.split(',');
        roles=roleFilters.split(',');
        
        /*Type Filter*/
        for(Integer i=0;i<types.size();i++){
            if(types[i]==IPM_ConstantUtils.TYPE_ALL)
            {
                IsTypeAll=true;
            }    
            else if(types[i]==IPM_ConstantUtils.TYPE_NON_NEGOTIABLE)
            {
                IsNegotiable=true;
            }    
            else if(types[i]==IPM_ConstantUtils.TYPE_OPTIONAL)
            {
                Isoptional=true;
            }    
        }
        
        /*Status Filter*/
        for(Integer i=0;i<statuses.size();i++){
            if(statuses[i]==IPM_ConstantUtils.STATUS_ALL)
            {
                IsStatusAll=true;
            }    
            else if(statuses[i]==IPM_ConstantUtils.STATUS_NOT_STARTED )
            {
                IsNotstarted=true;
            }    
            else if(statuses[i]==IPM_ConstantUtils.SECTION_STATUS_FILLED)
            {
                IsFilledIn=true;
            }  
        }
        
        /*Functional Role Filter*/
        for(Integer i=0;i<roles.size();i++){
            if(roles[i]==IPM_ConstantUtils.FUNCTIONAL_ROLE_ALL)
            {
                IsRoleAll=true;
            }
            else if(roles[i]==IPM_ConstantUtils.FUNCTIONAL_ROLE_BD)
            {
                IsBD=true;
            }
            else if(roles[i]==IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI)
            {
                IsCMI=true;
            }
            else if(roles[i]==IPM_ConstantUtils.FUNCTIONAL_ROLE_CD)
            {
                IsCD=true;
            }
            else if(roles[i]==IPM_ConstantUtils.FUNCTIONAL_ROLE_RD)
            {
                IsRnD=true;
            }
            else if(roles[i]==IPM_ConstantUtils.FUNCTIONAL_ROLE_Finance)
            {
                IsFinance=true;
            }
            else if(roles[i]==IPM_ConstantUtils.FUNCTIONAL_ROLE_BB)
            {
                IsBB=true;
            }
            else if(roles[i]==IPM_ConstantUtils.FUNCTIONAL_ROLE_SC)
            {
                IsSC=true;
            }
            else if(roles[i]==IPM_ConstantUtils.FUNCTIONAL_ROLE_PL)
            {
                IsPL=true;
            } 
            
       }
         
        //Invoking Filter Query
        filterSections();
    } 
    
    /********************************************
    @description For Resetting the Filter Values
    */
    public void ResetFilters(){
        IsTypeAll=true;
        IsStatusAll=true;
        IsRoleAll=true;
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
    @description To get dynamic Summary for Lazy Load
    
    */
    public void getDynamicSection()
    {
        getProjectDocumentSection();
       
        try{
           // showSummary=true;
           projSubSectionList=[SELECT Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c, IPM_Section_Sequence__c, 
                                IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,
                                IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Project_Document__c,
                                IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Count_of_Comments__c,IPM_FunctionalRole__c,IPM_Has_Appendix__c,
                                IPM_GateHistory__c,IPM_GateHistory_Date__c,IPM_Gate_Document_Summary__c,LastModifiedBy.Name,LastModifiedDate,IPM_Master_Section_External_Id__c,IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c, IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c
                                FROM IPM_Project_Document_Section__c 
                                WHERE IPM_Project_Document__c=:projectDoc.Id AND IPM_Section__r.IPM_Parent_Section__c =:parentSectionId AND IPM_Default_Section__c=true  
                                order by IPM_Section__r.IPM_Section_Sequence__c asc limit 50000];
           // Start Fix - DEF3031   
           // logic for not displaying sub-header if its not containing sub section inside it.
           // steps : 
           // 1. retrieve projSubSectionList sequence no 
           // 2. query for sublevelsection(projSubLevelSectionList) 
           // 3. collect projSubLevelSectionList parents sequence no and compare it with projSubSectionList sequence no 
           // 4. if not present in projSubLevelSectionList parents sequence no then don't display that sub-header
           List<Id> parentSectionIds = new List<Id>();
           Map<String, IPM_Project_Document_Section__c> parentSequenceList = new Map<String, IPM_Project_Document_Section__c>();
           List<IPM_Project_Document_Section__c> subSectionList = new List<IPM_Project_Document_Section__c>();
           Map<String, List<IPM_Project_Document_Section__c>> subSectionSequenceList = new Map<String, List<IPM_Project_Document_Section__c>>();
           List<String> sequenceToBeExclude = new List<String>();
           Boolean flag = false;
           Map<String, List<IPM_Project_Document_Section__c>> parentSeqChildDocMap = new Map<String, List<IPM_Project_Document_Section__c>>();
           
           if(projSubSectionList != null && !projSubSectionList.isEmpty()){
               for(IPM_Project_Document_Section__c tempSection : projSubSectionList){
                    parentSectionIds.add(tempSection.IPM_Section__c);
                    parentSequenceList.put(tempSection.IPM_Section__r.IPM_Section_Sequence__c, tempSection);                                
               }    
           }
           
           if(parentSectionIds != null && !parentSectionIds.isEmpty()){
                subSectionList = [Select id, IPM_Default_Section__c, IPM_Section__r.IPM_Section_Sequence__c, IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Sequence__c from IPM_Project_Document_Section__c
                                             where IPM_Project_Document__c=:projectDoc.Id AND IPM_Section__r.IPM_Parent_Section__c =:parentSectionIds 
                                             order by IPM_Section__r.IPM_Section_Sequence__c asc limit 50000];
           }
           // If header is having more than 1 sub header, then check for each sub-header subsections
           if(subSectionList != null && !subSectionList.isEmpty()){
           		List<IPM_Project_Document_Section__c> docList;
                for(IPM_Project_Document_Section__c tempSubSection : subSectionList){
                	if(parentSeqChildDocMap.get(tempSubSection.IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Sequence__c) == null ){
                		docList = new List<IPM_Project_Document_Section__c>();
                		docList.add(tempSubSection);
                		parentSeqChildDocMap.put(tempSubSection.IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Sequence__c, docList);
                	}
                	else{
                		if(docList != null && !docList.isEmpty()){
                			docList.add(tempSubSection);
                			parentSeqChildDocMap.put(tempSubSection.IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Sequence__c, docList);
                		}
                	}
                }
                // if sub-header is having more than 1 subsections, if any any subsection is having default section as true then skip that sub-header
                if(parentSeqChildDocMap != null && !parentSeqChildDocMap.isEmpty()){
                	for(String tempSeq : parentSeqChildDocMap.keyset()){
                		for(IPM_Project_Document_Section__c tempSection : parentSeqChildDocMap.get(tempSeq)){
                			if(tempSection.IPM_Default_Section__c){
		                		flag = true;
		                	}
                		}
                
                		if(!flag){
                			subSectionSequenceList.put(tempSeq, parentSeqChildDocMap.get(tempSeq));
                		}
                		flag = false;
                	}
                }
           }
           
           for(String tempParSeq : parentSequenceList.keyset()){
                for(String tempSubSectionSeq : subSectionSequenceList.keyset()){
                    if(tempSubSectionSeq.equals(tempParSeq)){
                        sequenceToBeExclude.add(tempSubSectionSeq);
                    }
                }       
           }
           
           for(String temp : sequenceToBeExclude){
                parentSequenceList.remove(temp);
           }
           
           projSubSectionList.clear();
           
           for(String tempParSeq : parentSequenceList.keyset()){
                projSubSectionList.add(parentSequenceList.get(tempParSeq));
           }
           showAttchSection();// used to show Attachments in gd page. DONOT REMOVE
           // End Fix - DEF3031
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
               'getDynamicSection',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);

        }
    }
    
    /*******************************************************************************************
    @description To get dynamic Subsection Summary for Lazy Load
    
    */
  
    public void getProjectSubSections()
    {
    //reRenderMe=true;
    	 try{
            projSubLevelSectionList=[SELECT Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c, IPM_Section_Sequence__c, 
                                    IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,
                                    IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Project_Document__c,
                                    IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Count_of_Comments__c,IPM_FunctionalRole__c,IPM_Has_Appendix__c,
                                    IPM_GateHistory__c,IPM_GateHistory_Date__c,IPM_Gate_Document_Summary__c,LastModifiedBy.Name,LastModifiedDate,IPM_Master_Section_External_Id__c,IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c, IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c 
                                    FROM IPM_Project_Document_Section__c 
                                    WHERE IPM_Project_Document__c=:projectDoc.Id AND IPM_Section__r.IPM_Parent_Section__r.ID=:parentSectionId AND IPM_Default_Section__c=true  
                                    order by IPM_Section__r.IPM_Section_Sequence__c asc limit 50000];
                                    showAttchSection();// used to show Attachments in gd page. DONOT REMOVE
            }
            
            catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEDOCUMENTCONTR_STR,
                   'getDynamicSection',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
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
        }               
    }
    
    /*******************************************************************************************
    @description To get the rendering condition based on Document Status
    
    */
    public boolean isEditLinkAvailable(){
        isEditLinkActive=true;
            return isEditLinkActive;
    }
    
    public void showAttchSection()
    {
        attachmentList=[SELECT Id,Name,ParentId,Description FROM Attachment WHERE ParentId=:sectionId];
        if(!attachmentList.isEmpty())
        {
            showAttach=true;
        }
        else
        {
            showAttach=false;
        }
        
    }
    
    //DEF1474 - class to sort Project Document section according to sequence no
    private class ProjectSubSectionsWrapper implements Comparable{
        IPM_Project_Document_Section__c projDocSection = new IPM_Project_Document_Section__c();
        
        public ProjectSubSectionsWrapper(IPM_Project_Document_Section__c incomingprojDocSection){
            projDocSection = incomingprojDocSection.clone(true,true,true,true);
        }
        
        public Integer compareTo(Object compareTo) {
            ProjectSubSectionsWrapper compareToProSubSection = (ProjectSubSectionsWrapper)compareTo;
            Integer returnValue = 0;
    
            if (projDocSection.IPM_Section__r.IPM_Section_Sequence__c > compareToProSubSection.projDocSection.IPM_Section__r.IPM_Section_Sequence__c) {
              returnValue = 1;
            } 
            else if (projDocSection.IPM_Section__r.IPM_Section_Sequence__c < compareToProSubSection.projDocSection.IPM_Section__r.IPM_Section_Sequence__c) {
              returnValue = -1;
            }
            return returnValue;      
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