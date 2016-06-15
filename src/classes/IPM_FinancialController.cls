/**
* @author       Cognizant
* @date         27/04/2015
* @description  This class is used for managing the ipmFinancial Page 
*               and displaying Financial Business cases 
* version: Samrat Removed uploadDownloadTemplate function not required 
*/
public with sharing class IPM_FinancialController extends IPM_ProjectIntermediateController  
{ 
    //public IPM_Project__c project {get; set;} //The project record for which the financial business cases are being viewed
    public Integer sustainabilityPeriod {get; set;} //Sustainability Period relevant for this set of business cases. 
    public Integer colSpan {get; set;} //Derived from Sustainability Perido. Used to define the number of columns visible on the Financial Table
    
    public Boolean isEditMode {get; set;} //Boolean variable to define if the page is in edit mode
    public Boolean isEditable{get;set;} //Boolean Variable to define if the record is editable by the current logged in user
    public Boolean isValidationFailed {get;set;} //Boolean variable to check the financial data validation
    public Boolean isy0TurnoverInvalid {get;set;} //Boolean variable to highlight the y0Turnover cell if the value is invalid
    public Boolean isy0ProfitInvalid {get;set;} //Boolean variable to highlight the y0Profit cell if the value is invalid
    public Boolean isy0GrossProfitInvalid {get;set;} //Boolean variable to highlight the y0GrossProfit cell if the value is invalid
    
    public List<RolloutWrapper> lstRolloutWrappers {get; set;} //List of Rollout Wrappers that becomes visible for the current view
    public  Map<String, IPM_Financial__c> mapConsolidatedFinancials {get; set;} //Map of All CONSOLIDATED type financials.
    public  Map<String, IPM_Financial__c> mapDefaultFinancials {get; set;} //Map of  Defualt type financials. created by Kt
    public Boolean isError {get; set;} //Boolean variable to indicate error on page
    public String errorMessage {get; set;} //Error Message to be displayed on the page
    public Boolean isRolloutError {get; set;} //Boolean variable to indicate error if No Rollouts exist for the project
    public Boolean isValidationError {get; set;} //Boolean variable to indicate validation error on page
    public Boolean isValidationErrorCal {get; set;} //Boolean variable to check if error is in calendar year 
    public String validationErrorMessage {get; set;} //Validation error Message to be displayed on the page
	public String validationErrorMessageCal {get; set;} //Validation error Message to be displayed on the page

    public String currentFinancialId {get; set;} //Stores the id of the current financial being viewed. Changes dynamically and used with re-render
    private String previousFinancialId {get; set;} //Store the previously viwed financial Id. Used to maintain stae when switching tabs
    public String currentTab {get; set;} //Used to manage the current selected tab on the UI
    public IPM_Financial__c currentFinancial {get; set;} //Used to store the financial business case (IPM_Financial & associated IPM_Financial_Year__c records)
    private List<IPM_Financial_Year__c> lstUpdateFinancials;
   

    public Boolean showTopDownTab {get; set;} //Boolean variable to decide when to show the TopDown tab
    public Boolean showRollupTab {get; set;} //Boolean variable to decide when to show the Rollup tab
    public Boolean showKeyFinancial {get;set;} 
    public Boolean globalCharter {get;set;}
    public Boolean topDown {get;set;}
    public IPM_FinancialWrapper financialsInnovation {get; set;} //Wrapper to store the financial values for the Innovation Years for the currentFinancial
    public IPM_FinancialWrapper financialsCalendar {get; set;} //Wrapper to store the financial values for the Calendar Years for the currentFinancial

    public Map<String, IPM_Financial_Year__c> mapFinancialYears {get; set;} //Used to store the map of the financial years, based on External Id for the currentFinancial
    public String fieldSuffix {get; set;} //Used to dynamically change the field suffix based on the current view. (Accepted values are - Global,Regional.Local,Charter,Contract,MR,MD)
    
    public Boolean showMisalignment {get; set;} //Boolean variable to identify if the currentFinancial has any misalignment
    
    public  String tabLabelMyView {get; set;} //Used to define the label for My View Tab
    public  String tabLabelTopDown {get; set;} //Used to define the label for Top Down Tab
    public  String tabLabelRollup {get; set;} //Used to define the label for Rollup Tab 
    
    public List<SelectOption> lstSustainabilityPeriod {get; set;} //Used to manage appropriate sustainability period selection on the UI
    public String selectedSustainabilityPeriod {get; set;} //Selected Sustainability Period for the currentFinancial business case
    public boolean CheckCountry{get;set;}
    public String Country {get;set;}
    public IPM_Project_Rollout__c localrollout{get;set;}
    public List<IPM_Country__c> associatedCountryList{get;set;}
    public Boolean sustainabilityPeriodChanging {get; set;} //Variable to validate if the future method for changing the sustainabilityPeriod is still running

    public List<SelectOption> documentSections {get; set;} //Used to manage the list of the document sections for navigation
    public String selectedDocumentSection {get; set;} //Seleted DOcument Section for the current project for navigation
    // TLD chages start
    public String localProjectTLD; 
    public String localProjectRolloutTLD;
    
    private IPM_Project__c localRolloutProject;
   
    private IPM_Project_Rollout__c mcoCountryRolloutPlan;
    public  Boolean isMisalignedTLD {get; set;} //Boolean variable to indicate TLDs are misaligned
    public  String misalignedTLDMessage {get; set;} 
    public  Boolean showMisalignedConfirmbtn {get;set;}
    public String currentTargetLaunchDate {get;set;}
    public String previousTargetLaunchDate {get;set;}     
    public String milestoneFinanceDataValidationMessage {get;set;}
    public boolean isITOgrtGTO{get; set;} //DEF2315
    public boolean isITOgrtGTOCal{get; set;} //DEF2315
    public String BI{get;set;}
	public string financialAcceptFrom{get;set;}
    public boolean toShowEditButton{get;set;}
    public boolean toShowEditOpern{get;set;}
    public boolean isCopyfromSTDBC{get;set;}
    public boolean isTDLAcceptNBC_Confirm{get;set;}
    public string tldAcceptedBCConfirmed{get;set;}
    public string globalbusinessImpactStr  {get; set;}
    public IPM_Financial__c fin {get; set;}
    public IPM_Financial__c finRegional{get;set;}// for Financial Regional Business Impact
    public IPM_Financial__c finLocal{get;set;}// for Financial Local Business Impact
    public boolean isFinancialInvalid{get;set;}
    public boolean isFinancialInvalidInnovation;
    //variable to capture financial type
    public Boolean isConsolidatedOrNonkey 
    {
        get 
        {
            Boolean flag = false;
            if(currentFinancial!=null && currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE)) 
            {    
                flag = true;
            }
            return flag;
        } 
        set;
    } 
    public String tldAcceptFromValue{
        get {
            if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL) {
                return Label.Accept_from_Regional;
            } else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                return Label.Accept_from_Local;
            }
            return '';
        }
        set;
    }
    public Boolean isTargetLaunchDateMisaligned {
        get;

        set;
    }
     public Boolean isTLDYearMisaligned {
        get;
        set;
    }
	public String targetLaunchDateToDisplay{
        get {
            Date tld = null;
            String dateStr = '';
            if(project != null){
            	if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) {
            		tld = currentFinancial.Target_Launch_Date__c;
            	} else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL) {
                    tld = project.IPM_Target_Launch_Dates__c;
                } else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL) {
                    if(currentFinancial != null){
                        if(currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE) || currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY)) {
                            tld = currentFinancial.Target_Launch_Date__c;
                        } else {
                            IPM_Project__c proj = [Select (Select Target_Launch_Date__c From Regional_Project_Rollout__r where name=:currentFinancial.Financial_External_ID__c) From IPM_Project__c where id=:project.id];
                            if(!proj.Regional_Project_Rollout__r.isEmpty()) {
                                tld = proj.Regional_Project_Rollout__r[0].Target_Launch_Date__c;
                            }
                        }
                    }
                } else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL) {
                    if(currentFinancial != null){
                        if((project.name+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE)==currentFinancial.Financial_External_ID__c) {
                            tld = project.IPM_Target_Launch_Dates__c;
                        } else {
                            IPM_Project__c proj = [Select (Select Name, Target_Launch_Date__c From IPM_Project_Rollout__r) From IPM_Project__c where id=:project.id];
                            if(!proj.IPM_Project_Rollout__r.isEmpty()) {
                                for(IPM_Project_Rollout__c rollout:proj.IPM_Project_Rollout__r) {
                                    if(currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY) && (rollout.name+IPM_ConstantUtils.FINANCIAL_NONKEY)==currentFinancial.Financial_External_ID__c){
                                        tld = currentFinancial.Target_Launch_Date__c;
                                        break;
                                    } else if(rollout.name==currentFinancial.Financial_External_ID__c) {
                                        tld = rollout.Target_Launch_Date__c;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if(tld!=null) {
                dateStr = tld.format();
            }
            return dateStr;
        }
        set;
    }
    // TLD chages end
    
    private Map<String, IPM_Financial_Year__c> mapFinancialYearRecords; //Used to store the map of the financial years, based on External Id for the currentFinancial
    
    private static String REGIONAL_ROLLOUT_RECORDTYPE; //Recordtype Id for Regional Rollouts on IPM_Project_Rollout__c object
    private static String LOCAL_ROLLOUT_RECORDTYPE;//Recordtype Id for Local Rollouts on IPM_Project_Rollout__c object
    private static String DEFAULT_FINANCIAL_RECORDTYPE; //Recordtype Id for Default on IPM_Financial__c object  -- kt
    private static String CONSOLIDATED_FINANCIAL_RECORDTYPE; //Recordtype Id for Consolidated on IPM_Financial__c object
    
    private static final String CLASS_NAME = IPM_FinancialController.class.getName();//Class Name for Exception Logging
    private static String UPDATE_COUNTRY='updateCountry';
    
    //DEF2676 fix Start
    private Integer consolidatedYearCount = 0;
    private Integer grossCount = 0;
    private Integer incrementalCount = 0;
    public Integer nextIndex=0;
    public Integer previousIndex=0;
    public Boolean isNavigation = false;
    public Boolean showNext {  set;
                                get {
                                    Boolean flag;
                                    flag = consolidatedYearCount>sustainabilityPeriod && nextIndex < consolidatedYearCount;
                                    return flag;
                                }
    }
    public Boolean showPrevious {  set;
                                    get {
                                        Boolean flag;
                                        flag = consolidatedYearCount>sustainabilityPeriod && previousIndex > 1;
                                        return flag;
                                    }
    }
    //DEF2676 fix Start
    
    /*******************************************************************************************************
    * @description  Constructor
    * @param        NONE
    * @return       NONE
    */
    public IPM_FinancialController() 
    {
        
        
        //IE-9 Fix
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
        
        String projectId = ApexPages.currentPage().getParameters().get('Id');
        
        currentTab = IPM_ConstantUtils.TAB_MYVIEW_NAME; 
        isError = FALSE;
        sustainabilityPeriod=0;
        isEditable=false;
        isFinancialInvalid = false;
        isFinancialInvalidInnovation = false;
        isValidationFailed = false;
        isy0TurnoverInvalid = false;
        isy0ProfitInvalid = false;
        isy0GrossProfitInvalid = false;
        isValidationError = false;
        isValidationErrorCal = false;
        isConsolidatedOrNonkey=false;
        globalCharter = false;
        topDown = false;
        showKeyFinancial = false;
        isITOgrtGTO = false; 
        isITOgrtGTOCal = false;
        validationErrorMessage = IPM_ConstantUtils.BLANK;
        localrollout = new IPM_Project_Rollout__c(); 
        associatedCountryList = new List<IPM_Country__c>();
        milestoneFinanceDataValidationMessage = '';
        exRate=1;            
                
        try{
            if (projectId != null) 
            {
                isEditable=IPM_Utils.getIpmuserType(projectId, IPM_ConstantUtils.IPM_ROLE_FINANCE);
                getRolloutWrappers(); 
                getSustainabilityPeriod(); 
                getVisibleTabs(); 
                getSectionList(); 
                getMisalignmentVisibility(); 
                getFinancials();                 
                //calculating and setting the Business Impact
                setBusinessImpact(projectId);
                BI = globalbusinessImpactStr;
                if(BI == null || BI == ''){
                  BI = IPM_ConstantUtils.smallBI;
                }
                //upto here                 
                isEditMode = FALSE; 
                Boolean result = validateMilestoneAndFinacialData();
                if(result) {
                    milestoneFinanceDataValidationMessage = Label.IPM_Finacial_Data_Missing;
                }
				localProjectConditions();
              
            }
        } 
        catch (Exception ex)
        {
            isError = TRUE;
            
            if(currentFinancial != null)
            { 
                errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            } 
            else 
            {
                errorMessage = Label.IPM_NO_ROLLOUTS_ERROR;
                isRolloutError = true;          
            }
       }
       
       if(currentFinancial == null && project!=null) /// && added as throws error if class is initialised from outside
       {  
            if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL || project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)
            {
                errorMessage = Label.IPM_NO_ROLLOUTS_ERROR;
                isError = true;
                isRolloutError = true;
            }  
        }
            validateCalendarFinancialRecords(financialsCalendar, IPM_ConstantUtils.YEAR_TYPE_CALENDAR);
            validateInnovationFinancialRecords(financialsInnovation, IPM_ConstantUtils.YEAR_TYPE_INNOVATION);
      }
     //method to calculate the Business Impact
     private void setBusinessImpact(Final Id pId){
		//For Generating PDF Retrieving Project Rollouts,Finance and Project Document Sections
		try{
			String nam=project.IPM_Project_Name__c; 
			globalbusinessImpactStr = IPM_ConstantUtils.BLANK;
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
					globalbusinessImpactStr = fin.Business_Impact_Global__c;
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
						globalbusinessImpactStr = project.IPM_Phase__C!= IPM_ConstantUtils.PHASE_IDEAS?finRegional.Business_Impact_Regional__c:finRegional.Business_Impact_Global__c;
					}
				}
				else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
				{
					fin = [SELECT ipm_cpp_local__c,Year_3_iTO_Local__c,Year_3_iTO_Charter__c,Year_3_iTO_Contract__c,Year_3_iTO_MR__c,
					Year_3_iTO_MD__c,Business_Impact_Local__c 
					FROM IPM_Financial__c 
					WHERE Financial_External_ID__c =: nam limit 1];
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
						finLocal=[SELECT Business_Impact_Global__c,IPM_Business_Impact_Charter__c,IPM_Business_Impact_Contract__c,IPM_Business_Impact_MR__c,IPM_Business_Impact_MD__c FROM IPM_Financial__c 
						WHERE Parent_Project__c=:globalParentId.IPM_Parent_Project__r.IPM_Parent_Project__c
						AND Financial_External_ID__c=:globalParentId.IPM_Parent_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
						globalbusinessImpactStr =  project.IPM_Phase__C!= IPM_ConstantUtils.PHASE_IDEAS?finLocal.Business_Impact_Regional__c:finLocal.Business_Impact_Global__c;
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
		}
		catch(Exception ex){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
		}
	} 
     //upto here 
     
     private List<IPM_Country__c> getCountryList()
     {  
        associatedCountryList =  new List<IPM_Country__c>(); 
        List<IPM_Project_Rollout__c> localRolloutList = new List<IPM_Project_Rollout__c>();
        List<IPM_Project__c> ipmProjectList = new List<IPM_Project__c>(); 
        if(currentFinancial !=null)
        { 
            String financialExtID = currentFinancial.Financial_External_ID__c;
                         
                    if(globalCharter)
                    {
                        associatedCountryList =  [Select Id,Country_Name__c,Calculation_Index__c,Local_Rollout_Charter__c,Local_Rollout__c from IPM_Country__c where IPM_FinancialAtCharter__r.Financial_External_ID__c = :financialExtID LIMIT 50000];    
                    }
            else if(topDown)
                        
                { 
                    if(!financialExtID.contains(IPM_ConstantUtils.FINANCIAL_NONKEY))
                    {
                        ipmProjectList =  [SELECT Id,
                                               (SELECT Regional_Project__c, RecordTypeId, Local_Project__c, IPM_Project__c, MisAligned_Confirmed_By_Finance_Leader__c  FROM IPM_Project_Rollout__r 
                                                   WHERE RecordTypeId = :LOCAL_ROLLOUT_RECORDTYPE AND IPM_Rollout_Project__c = :financialExtID AND isActive__c = true),
                                               (SELECT Regional_Project__c, RecordTypeId, Local_Project__c, IPM_Project__c, MisAligned_Confirmed_By_Finance_Leader__c  FROM Regional_Project_Rollout__r 
                                                   WHERE RecordTypeId = :LOCAL_ROLLOUT_RECORDTYPE AND IPM_Rollout_Project__c = :financialExtID AND isActive__c = true)       
                                            FROM IPM_Project__c WHERE Id =:Project.Id];
                    }
                    else 
                    {
                    if(project.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS)
                    {
                        associatedCountryList =  [Select Id,Country_Name__c,Calculation_Index__c,Local_Rollout_Charter__c,Local_Rollout__c from IPM_Country__c where IPM_FinancialAtCharter__r.Financial_External_ID__c = :financialExtID AND isActive__c = true LIMIT 50000];    
                    }
                    else
                    {
                        // Update financials External Id if it is a non Key.
                        financialExtID = currentFinancial.Regional_External_Id__c;
                        ipmProjectList =  [SELECT Id,
                                               (Select Regional_Project__c, RecordTypeId, Local_Project__c, IPM_Project__c, MisAligned_Confirmed_By_Finance_Leader__c FROM IPM_Project_Rollout__r 
                                                   WHERE RecordTypeId = :LOCAL_ROLLOUT_RECORDTYPE AND KeyMCO__c = FALSE AND Regional_Rollout_External_Id__c= :financialExtID AND isActive__c = true),
                                               (SELECT Regional_Project__c, RecordTypeId, Local_Project__c, IPM_Project__c, MisAligned_Confirmed_By_Finance_Leader__c  FROM Regional_Project_Rollout__r 
                                                   WHERE RecordTypeId = :LOCAL_ROLLOUT_RECORDTYPE AND Regional_Rollout_External_Id__c = :financialExtID AND isActive__c = true)           
                                            FROM IPM_Project__c WHERE Id =:Project.Id];
                    } 
                } 
                    
                    if(!ipmProjectList.isEmpty())
                    {
                       IPM_Project__c project = ipmProjectList[0]; 
                       if(project.Regional_Project_Rollout__r!=null && !(project.Regional_Project_Rollout__r).isEmpty() )
                       {
                            localRolloutList.addAll(project.Regional_Project_Rollout__r); 
                       }
                       
                       if(project.IPM_Project_Rollout__r!=null && !(project.IPM_Project_Rollout__r).isEmpty() )
                       {
                            localRolloutList.addAll(project.IPM_Project_Rollout__r);
                       }
                       
                      
                       if(!localRolloutList.isEmpty())
                       {
                          associatedCountryList =  [Select Id,Country_Name__c,Calculation_Index__c from IPM_Country__c where Local_Rollout__c in :localRolloutList AND isActive__c = true];  
                       }
                }
            } 
        }
        return associatedCountryList; 
    }
    
        
    public void updateCountry()
    { 
        try{
        IPM_Country__c UpdateCountry = [Select Country_Name__c, Id, Calculation_Index__c From IPM_Country__c where Id =: Country Limit 1];
        UpdateCountry.Calculation_Index__c = CheckCountry;
        update UpdateCountry;
        } catch (DMLException ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    UPDATE_COUNTRY,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }    
        
    }
    
    /*******************************************************************************************************
    * @description  Used to get visible tabs
    * @param        NONE
    * @return       NONE
    */
    
    private void getVisibleTabs()
    {
        showTopDownTab = showRollupTab = false;
        
        //Global Project
        if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
        {
            if(project.IPM_SourceProjectType__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL )
            {
                tabLabelMyView = IPM_ConstantUtils.TAB_TOPDOWN_LABEL; //  label name --> 'Top Down' phase is feasibility
                tabLabelRollup = IPM_ConstantUtils.TAB_MARKETCLUSTERBOTTOMUP_LABEL; // --> Market cluster bottom up  phase is feasibility
            
                if (project.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS)
                {
                    showRollupTab = true;
                }
            }
            else 
            {
                tabLabelMyView = IPM_ConstantUtils.TAB_MYVIEW_LABEL; // label that will be same in both current selected tab and opertional default     
            }
        } 
        //Regional Project
        else if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
        {
            if(project.IPM_SourceProjectType__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL )
            {
                tabLabelMyView = IPM_ConstantUtils.TAB_TOPDOWN_LABEL;
                tabLabelTopDown = IPM_ConstantUtils.TAB_GLOBALCHARTER_LABEL;
                tabLabelRollup = IPM_ConstantUtils.TAB_LOCALBBROLLUP_LABEL;

                if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT )
                {
                    showTopDownTab = showRollupTab = true;      
                }
                else if(project.IPM_Project_Type__c ==  IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL )
                {
                    tabLabelTopDown = IPM_ConstantUtils.TAB_CHARTER_LABEL; 
                    if (project.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS)
                    {
                        showTopDownTab = showRollupTab = true;
                    }
                }
            }
            else
            {  // operational
                    tabLabelMyView = IPM_ConstantUtils.TAB_MYVIEW_LABEL; 
            } 
        } 
        //Local Project 
        else if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
        {
            if(project.IPM_Project_Type__c != IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
            {
                tabLabelMyView = IPM_ConstantUtils.TAB_MYVIEW_LABEL;
                tabLabelTopDown = IPM_ConstantUtils.TAB_TOPDOWN_LABEL;
                showTopDownTab = true;
            }
            else 
            {
                tabLabelMyView = IPM_ConstantUtils.TAB_MYVIEW_LABEL; 
            }
         }
    }

    /*******************************************************************************************************
    * @description  Used to get list of Document Sections for Finance Team
    * @param        NONE
    * @return       NONE
    */
    private void getSectionList(){
        String currentStage = '';
        if(project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS)
        {
            currentStage = IPM_ConstantUtils.CHARTER_GATE;
            
        }    
        else if(project.IPM_Phase__c == IPM_ConstantUtils.PHASE_FEASIBILITY) {
            currentStage = IPM_ConstantUtils.CONTRACT_GATE;
        }
        else if(project.IPM_Phase__c == IPM_ConstantUtils.PHASE_CAPABILITY) {
            currentStage = IPM_ConstantUtils.MARKET_READY_GATE;
        }
        else if(project.IPM_Phase__c == IPM_ConstantUtils.PHASE_MARKET_READY){
            currentStage = IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE; 
        }
        
        String headerString = IPM_ConstantUtils.PERCENTAGE + IPM_ConstantUtils.SECTION_TYPE_HEADER + IPM_ConstantUtils.PERCENTAGE;

        List<IPM_Project_Document__c> lstCurrentDocuments = [SELECT Id, IPM_GateDocuments__c, 
                                                                (SELECT Id, IPM_Section_Sequence__c, IPM_Section_Name__c
                                                                    FROM IPM_Project_Sections__r
                                                                    WHERE (NOT IPM_Section_Type__c LIKE: headerString)
                                                                    AND (IPM_Section_Sequence__c LIKE: '6%')
                                                                    AND IPM_Default_Section__c = true
                                                                    ORDER BY IPM_Section_Sequence__c)
                                                            FROM IPM_Project_Document__c
                                                            WHERE IPM_GateDocuments__c =: currentStage
                                                                AND IPM_Project__c =: project.Id 
                                                            LIMIT 1];
        if(project.IPM_SourceProjectType__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
            lstCurrentDocuments = [SELECT Id, IPM_GateDocuments__c, 
                                                                (SELECT Id, IPM_Section_Sequence__c, IPM_Section_Name__c
                                                                    FROM IPM_Project_Sections__r
                                                                    WHERE (NOT IPM_Section_Type__c LIKE: headerString)
                                                                    AND ( IPM_Section_Sequence__c LIKE: '6%')
                                                                    ORDER BY IPM_Section_Sequence__c)
                                                            FROM IPM_Project_Document__c
                                                            WHERE IPM_GateDocuments__c =: currentStage
                                                                AND IPM_Project__c =: project.Id 
                                                            LIMIT 1];
        }
        documentSections = new List<SelectOption>();
        documentSections.add(new SelectOption(IPM_ConstantUtils.BLANK, Label.IPM_GO_TO_DOCUMENT_SECTION));
        if(lstCurrentDocuments!=null && !lstCurrentDocuments.isEmpty()){
            For(IPM_Project_Document_Section__c documentSection : lstCurrentDocuments[0].IPM_Project_Sections__r){
                documentSections.add(new SelectOption(documentSection.Id, documentSection.IPM_Section_Sequence__c + IPM_ConstantUtils.EMPTY_STRING_DELIMITER + documentSection.IPM_Section_Name__c));
            }
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
        
        lstSustainabilityPeriod = new List<SelectOption>();
        lstSustainabilityPeriod.add(new SelectOption(IPM_ConstantUtils.BLANK, Label.IPM_Select_Sustainab));
        lstSustainabilityPeriod.add(new SelectOption(IPM_ConstantUtils.YEAR_3, Label.IPM_SUSTAINABILITY_PERIOD_3));
        lstSustainabilityPeriod.add(new SelectOption(IPM_ConstantUtils.YEAR_5, Label.IPM_SUSTAINABILITY_PERIOD_5));
        
    }

    /*******************************************************************************************************
    * @description  Used to get Financials for multiple regions/mco's/countries for the appropriate project 
    *               and update the side panel accordingly
    * @param        NONE
    * @return       NONE
    */
    private void getRolloutWrappers(){
        getRolloutWrappers(NULL); 
    }

    /*******************************************************************************************************
    * @description  Used to get Financials for multiple regions/mco's/countries for the appropriate project 
    *               and update the side panel accordingly
    * @param        NONE
    * @return       NONE
    */
    private void getRolloutWrappers(String statefulCurrentFinancialId){
         previousFinancialId = currentFinancialId;
         currentFinancialId = NULL;
         getRecordtypes();
         showKeyFinancial = false;
         globalCharter = false;
         topDown = false;
         if(project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS)
         {
             showKeyFinancial = true;
         }
         
        if(project.IPM_SourceProjectType__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
        {
                mapConsolidatedFinancials = new Map<String, IPM_Financial__c> ();
                lstRolloutWrappers = new List<RolloutWrapper>();
                
                // If Project is Global Orignal Project
                if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
                {
                    if (currentTab == IPM_ConstantUtils.TAB_MYVIEW_NAME)
                    {
                        topDown = true;
                        getGlobalMyViewWrappers();
                    } 
                    else if (currentTab == IPM_ConstantUtils.TAB_ROLLUP_NAME)
                    {
                        getGlobalRollupWrappers();
                    } 
                } 
                else if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                {
                    // If Project Type is Regional Rollout Project 
                    if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)
                    {
                        if (currentTab == IPM_ConstantUtils.TAB_MYVIEW_NAME)
                        {
                            topDown = true;
                            getRegionalMyViewWrappers();
                        } 
                        else if (currentTab == IPM_ConstantUtils.TAB_TOPDOWN_NAME)
                        {
                            globalCharter = true;
                            showKeyFinancial = true;
                            getRegionalTopDownWrappers();
                        }
                        else if (currentTab == IPM_ConstantUtils.TAB_ROLLUP_NAME)
                        {
                            getRegionalRollupWrappers();
                        }
                    }
                    else // If Project is Regional Orignal Project
                    {
                        if (currentTab == IPM_ConstantUtils.TAB_MYVIEW_NAME)
                        {
                            topDown = true;
                            getRegionalOriginalMyViewWrappers();
                        } 
                        else if (currentTab == IPM_ConstantUtils.TAB_TOPDOWN_NAME)
                        {
                            globalCharter = true;
                            showKeyFinancial = true;
                            getRegionalOriginalTopDownWrappers();
                        }
                        else if (currentTab == IPM_ConstantUtils.TAB_ROLLUP_NAME)
                        {
                            getRegionalRollupWrappers();
                        }
                    }
                } 
                // If Project is Local Rollout Project
                else if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
                {
                    if (currentTab == IPM_ConstantUtils.TAB_MYVIEW_NAME) 
                    {
                        topDown = true;
                        getLocalMyViewWrappers();
                    }
                    else if (currentTab == IPM_ConstantUtils.TAB_TOPDOWN_NAME) {
                        getLocalMyViewWrappers();
                    }
                }
               
        } // If Project is Global Operational Project
        else if(project.IPM_SourceProjectType__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
        { 
            mapDefaultFinancials = new Map<String, IPM_Financial__c> (); 
            
            if (currentTab == IPM_ConstantUtils.TAB_MYVIEW_NAME) 
            {
                getOperationalMyViewWrappers(); 
            }
        }
        
         if(statefulCurrentFinancialId != NULL){
            currentFinancialId = statefulCurrentFinancialId;
          }
    
    }
    
    /*******************************************************************************************************
    * @description  Used to get different recordtype Ids
    * @param        NONE
    * @return       NONE
    */
    private void getRecordtypes(){
        if (REGIONAL_ROLLOUT_RECORDTYPE == null) {
            REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId();
         }
        if (LOCAL_ROLLOUT_RECORDTYPE == null) {
            LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
        }
        if (DEFAULT_FINANCIAL_RECORDTYPE == null) {  
            DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
         }     
        
        if (CONSOLIDATED_FINANCIAL_RECORDTYPE == null) {
            CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
        }        
    }
    
    /*******************************************************************************************************
    * @description  Used to getRollout Wrappers for Global My View Tab now it will also give default wrapper for fiancial in case of operational
    * @param        NONE
    * @return       NONE
    */
    
    private void getRegionalOriginalMyViewWrappers()
    {
             
        
        
        List<IPM_Financial__c> lstRegionalFinancials = [SELECT Id, Name,recordTypeId,Financial_External_ID__c, Status__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c FROM IPM_Financial__c
                                                            WHERE Regional_Project__c =: project.Id 
                                                            AND RecordTypeId =: DEFAULT_FINANCIAL_RECORDTYPE AND isActive__c = true
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c Limit: IPM_ConstantUtils.MaxLimit];

        lstRolloutWrappers.add( new RolloutWrapper( project.Market_Cluster_Name__c, lstRegionalFinancials) );
        String firstFinancialId = '';
        
        For (IPM_Financial__c financial : lstRegionalFinancials)
        {
            if ((firstFinancialId == NULL) || (firstFinancialId == IPM_ConstantUtils.BLANK))
            {
                firstFinancialId = financial.Id;
            }
            
            if (previousFinancialId == financial.Id)
            {
                currentFinancialId = previousFinancialId;
            }
        }
        
        List<IPM_Financial__c> lstIpmFinancial = new List<IPM_Financial__c>();
        
        lstIpmFinancial = [SELECT Id, Name, Financial_External_ID__c,RecordTypeId,Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                            FROM IPM_Financial__c 
                            WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE
                            AND Regional_Project__c =: project.Id Limit: IPM_ConstantUtils.MaxLimit];
                                                                                            
        for(IPM_Financial__c ipmFinancial : lstIpmFinancial)
        { 
            mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);
            if (previousFinancialId == ipmFinancial.Id)
            {
                currentFinancialId = previousFinancialId;
            }
        }
      
        if ((currentFinancialId == NULL) || (currentFinancialId == IPM_ConstantUtils.BLANK))
        {
            currentFinancialId = firstFinancialId;    
        }
        
    }
    
    
    private void getGlobalMyViewWrappers()
    {  
        //Rollout Wrappers
        String firstFinancialId = '';
        List<IPM_Project_Rollout__c> lstRegionalRollout = new List<IPM_Project_Rollout__c>();
        
        lstRegionalRollout = [SELECT Id, Market_Cluster_Name__c,KeyMCO__c, Previous_Target_Launch_Date__c,(SELECT Id, Name,recordTypeID,Financial_External_ID__c, Status__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c   
                                                            FROM IPM_Financials__r
                                                            WHERE RecordTypeId =: DEFAULT_FINANCIAL_RECORDTYPE AND isActive__c = true
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c)
                                                            FROM IPM_Project_Rollout__c
                                                            WHERE IPM_Project__c =: project.Id
                                                            AND RecordTypeId =: REGIONAL_ROLLOUT_RECORDTYPE AND isActive__c = true
                                                            ORDER BY Market_Cluster_Name__c Limit: IPM_ConstantUtils.MaxLimit];
       
        For (IPM_Project_Rollout__c regionalRollout : lstRegionalRollout)
        {
            lstRolloutWrappers.add( new RolloutWrapper( regionalRollout.Market_Cluster_Name__c,regionalRollout.IPM_Financials__r) );
             
            for(IPM_Financial__c financial : regionalRollout.IPM_Financials__r)
            {
                if ((firstFinancialId == NULL) || (firstFinancialId == IPM_ConstantUtils.BLANK))
                {
                    firstFinancialId = financial.Id;
                }
                
                if (previousFinancialId == financial.Id)
                {
                    currentFinancialId = previousFinancialId;
                }
            }
        }
        
        List<IPM_Financial__c> lstIpmFinancial = new List<IPM_Financial__c>();
      
        lstIpmFinancial = [SELECT Id, Name, Financial_External_ID__c,recordTypeID, Status__c, IPM_Project_Rollout__c, IPM_Project_Rollout__r.Market_Cluster_Name__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                                                 FROM IPM_Financial__c
                                                 WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE AND isActive__c = true
                                                 AND Parent_Project__c =: project.Id Limit: IPM_ConstantUtils.MaxLimit];
        
       
       For(IPM_Financial__c ipmFinancial : lstIpmFinancial)
        {
            if(ipmFinancial.IPM_Project_Rollout__c == NULL)
            {
               mapConsolidatedFinancials.put(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, ipmFinancial);
              
            }
            else
            {
               mapConsolidatedFinancials.put(ipmFinancial.IPM_Project_Rollout__r.Market_Cluster_Name__c, ipmFinancial);
              
            }
            
            if (previousFinancialId == ipmFinancial.Id)
            {
                currentFinancialId = previousFinancialId;
            }
        }

        if ((currentFinancialId == NULL) || (currentFinancialId == IPM_ConstantUtils.BLANK))
        {
            currentFinancialId = firstFinancialId;
        }
        
        // Get associated Country List 
        
        
    }
    
    /*******************************************************************************************************
    * @description  Used to getRollout Wrappers for Global My View Tab now it will also give default wrapper for fiancial in case of operational
    * @param        NONE
    * @return       NONE
    */
    private void getOperationalMyViewWrappers()
    {    
       String firstFinancialId = '';
        
        List<IPM_Financial__c> lstIpmFinancial = new List<IPM_Financial__c>();
        String projectId = project.Id;
      
        String selectQueryString = ' SELECT Id, Name, Financial_External_ID__c, Status__c,IPM_Key_Financial__c FROM IPM_Financial__c ';
        String whereClauseString = ' WHERE RecordTypeId =:DEFAULT_FINANCIAL_RECORDTYPE ';
        
        if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
        {
           whereClauseString = whereClauseString +  ' AND Parent_Project__c = :projectId '; 
        }
        else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
        {
            whereClauseString = whereClauseString + ' AND Regional_Project__c = :projectId ';
        }
        else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
        {
            whereClauseString = whereClauseString + ' AND Local_Project__c = :projectId ';
        }
       
        String LimitString = ' Limit 50000';
           
        String finalQueryString = selectQueryString+whereClauseString+LimitString;                                        
        lstIpmFinancial = database.query(finalQueryString);
       
        if(!lstIpmFinancial.isEmpty()) 
        {
            for(IPM_Financial__c ipmFinancial : lstIpmFinancial)
            {
                mapDefaultFinancials.put(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, ipmFinancial);
                firstFinancialId = ipmFinancial.Id;
           }
        }
        if ((currentFinancialId == NULL) || (currentFinancialId == IPM_ConstantUtils.BLANK)) 
        {
            currentFinancialId = firstFinancialId;
        }
           
        }
    
   
     /*******************************************************************************************************
    * @description  Used to for rendering record 
    * @param        NONE
    * @return       Map of financial record either consolidated or default
    */
   
    public Boolean getRenderMapGlobal(){ // this should return the defualt map in case of operational look at this method
        
        if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL || project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT){
          return mapConsolidatedFinancials.containsKey(IPM_ConstantUtils.IPMGLOBAL);
          
        }
        else{ 
             return mapDefaultFinancials.containsKey(IPM_ConstantUtils.IPMGLOBAL);
        }
    }

    /*******************************************************************************************************
    * @description  Used to getRollout Wrappers for Global Rollup Tab
    * @param        NONE
    * @return       NONE
    */
    private void getGlobalRollupWrappers()
    {
        //Rollout Wrappers
        String firstFinancialId = '';
        String nonKeyLike = IPM_ConstantUtils.PERCENTAGE + IPM_ConstantUtils.FINANCIAL_NONKEY;
        
        List<IPM_Project__c> lstRegionalProject = [SELECT Id, Market_Cluster_Name__c, (SELECT Id,recordTypeID,Financial_External_Id__c, Status__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c  
                                                            FROM IPM_Financials_Regional__r
                                                            WHERE RecordTypeId =: DEFAULT_FINANCIAL_RECORDTYPE AND isActive__c = true                                                          
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c)
                                                            FROM IPM_Project__c
                                                            WHERE IPM_Parent_Project__c =: project.Id 
                                                            ORDER BY Market_Cluster_Name__c Limit: IPM_ConstantUtils.MaxLimit];
                                                    
                                             
        For (IPM_Project__c regionalProject : lstRegionalProject)
        {
            lstRolloutWrappers.add( new RolloutWrapper( regionalProject.Market_Cluster_Name__c,regionalProject.IPM_Financials_Regional__r));
            
            For (IPM_Financial__c financial : regionalProject.IPM_Financials_Regional__r)
            {
                if ((firstFinancialId == NULL) || (firstFinancialId == IPM_ConstantUtils.BLANK))
                {
                    firstFinancialId = financial.Id;
                }
                
                if (previousFinancialId == financial.Id)
                {
                    currentFinancialId = previousFinancialId;
                }
            }
        }
        
       
        List<IPM_Financial__c> lstIpmFinancial = new List<IPM_Financial__c>();
        
        lstIpmFinancial = [SELECT Id, Name,recordTypeID, Financial_External_ID__c, Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                                                 FROM IPM_Financial__c
                                                 WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE AND isActive__c = true
                                                     AND Parent_Project__c =: project.Id Limit: IPM_ConstantUtils.MaxLimit];
        
           
        For(IPM_Financial__c ipmFinancial : lstIpmFinancial)
        {
            if(ipmFinancial.Regional_Project__c == NULL)
            {
                mapConsolidatedFinancials.put(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, ipmFinancial);
            }
            else
            {
                mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);
            }

            if (previousFinancialId == ipmFinancial.Id)
            {
                currentFinancialId = previousFinancialId;
            }
        }
          
        if ((currentFinancialId == NULL) || (currentFinancialId == IPM_ConstantUtils.BLANK))
        {
            currentFinancialId = firstFinancialId;
        }
    }
    
    /*******************************************************************************************************
    * @description  Used to getRollout Wrappers for Regional My View Tab
    * @param        NONE
    * @return       NONE
    */
    private void getRegionalMyViewWrappers()
    {
        // No need to display Non Key financials in case of Regional View. Only needs to be displayed in Global Charter
        String nonKeyLike = IPM_ConstantUtils.PERCENTAGE + IPM_ConstantUtils.FINANCIAL_NONKEY;
        
        List<IPM_Financial__c> lstRegionalFinancials = [SELECT Id, Name,recordTypeID, Financial_External_ID__c, Status__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                                                            FROM IPM_Financial__c
                                                            WHERE Regional_Project__c =: project.Id AND isActive__c = true
                                                            AND RecordTypeId =: DEFAULT_FINANCIAL_RECORDTYPE 
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c Limit: IPM_ConstantUtils.MaxLimit];
                                                       
        lstRolloutWrappers.add( new RolloutWrapper( project.Market_Cluster_Name__c, lstRegionalFinancials ) );
        
        String firstFinancialId = '';
        For (IPM_Financial__c financial : lstRegionalFinancials)
        {
            if ((firstFinancialId == NULL) || (firstFinancialId == IPM_ConstantUtils.BLANK))
            {
                firstFinancialId = financial.Id;
            }
            
            if (previousFinancialId == financial.Id)
            {
                currentFinancialId = previousFinancialId;
            }
        }
        
        List<IPM_Financial__c> lstIpmFinancial = new List<IPM_Financial__c>();
        
          lstIpmFinancial = [SELECT Id, Name, recordTypeID,Financial_External_ID__c, Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                                                 FROM IPM_Financial__c
                                                 WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE AND isActive__c = true
                                                     AND Parent_Project__c =: project.IPM_Parent_Project__c Limit: IPM_ConstantUtils.MaxLimit];
                                                     
        
                                              
        For(IPM_Financial__c ipmFinancial : lstIpmFinancial){
            if(ipmFinancial.Regional_Project__c == NULL) {
                mapConsolidatedFinancials.put(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, ipmFinancial);
            }
            else {
                mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);
            }

            if (previousFinancialId == ipmFinancial.Id) {
                currentFinancialId = previousFinancialId;
            }
            }
      

        if ((currentFinancialId == NULL) || (currentFinancialId == IPM_ConstantUtils.BLANK)){
            currentFinancialId = firstFinancialId;
        }
    }
    
    private void getRegionalOriginalTopDownWrappers()
    {
        
        List<IPM_Financial__c> lstRegionalFinancials = [SELECT Id, Name,recordTypeID, Financial_External_ID__c, Status__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c  FROM IPM_Financial__c
                                                            WHERE Regional_Project__c =: project.Id 
                                                            AND RecordTypeId =: DEFAULT_FINANCIAL_RECORDTYPE
                                                            AND Charter_Approved__c = true 
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c Limit: IPM_ConstantUtils.MaxLimit];    
        
        lstRolloutWrappers.add( new RolloutWrapper( project.Market_Cluster_Name__c, lstRegionalFinancials) );
        
        String firstFinancialId = '';
        
        for(IPM_Financial__c financial : lstRegionalFinancials) 
        {
            if ((firstFinancialId == NULL) || (firstFinancialId == IPM_ConstantUtils.BLANK))
            {
                firstFinancialId = financial.Id;
            }
            
            if (previousFinancialId == financial.Id)
            {
                currentFinancialId = previousFinancialId;
            }
        }
        
        List<IPM_Financial__c> lstIpmFinancial = new List<IPM_Financial__c>();
        
        lstIpmFinancial =   [SELECT Id, Name,recordTypeID, Financial_External_ID__c, Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                                FROM IPM_Financial__c
                                WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE
                                AND Regional_Project__c =: project.Id Limit: IPM_ConstantUtils.MaxLimit];
               
        For(IPM_Financial__c ipmFinancial : lstIpmFinancial)
        {
            mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);

            if (previousFinancialId == ipmFinancial.Id)
            {
                currentFinancialId = previousFinancialId;
            }
        }

        if ((currentFinancialId == NULL) || (currentFinancialId == IPM_ConstantUtils.BLANK))
        {
            currentFinancialId = firstFinancialId;
        }
    }
    
    /*******************************************************************************************************
    * @description  Used to getRollout Wrappers for Regional Top Down Tab
    * @param        NONE
    * @return       NONE
    */
    private void getRegionalTopDownWrappers()
    {
    	// Get the regional Rollout from where regional Projects got created.Get associated financials from those regional Rollouts.
        IPM_Project_Rollout__c regionalRollout = [SELECT Id, Market_Cluster_Name__c, KeyMCO__c,Previous_Target_Launch_Date__c ,
                                                    (SELECT Id, Name, recordTypeID,Financial_External_ID__c, Status__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                                                        FROM IPM_Financials__r WHERE RecordtypeId =: DEFAULT_FINANCIAL_RECORDTYPE AND Charter_Approved__c = true
                                                        ORDER BY Sorting_Order__c, recordTypeID,Financial_External_Id__c)
                                                    FROM IPM_Project_Rollout__c
                                                    WHERE Id =: project.IPM_Project_Rollout__c AND IPM_CharterApproved__c = true  
                                                    AND RecordTypeId =: REGIONAL_ROLLOUT_RECORDTYPE Limit: IPM_ConstantUtils.MaxLimit];


        lstRolloutWrappers.add( new RolloutWrapper( regionalRollout.Market_Cluster_Name__c, regionalRollout.IPM_Financials__r) );
        
        String firstFinancialId = '';
        
        for(IPM_Financial__c financial : regionalRollout.IPM_Financials__r)
        {
            if ((firstFinancialId == NULL) || (firstFinancialId == IPM_ConstantUtils.BLANK))
            {
                firstFinancialId = financial.Id;
            }
            
            if (previousFinancialId == financial.Id)
            {
                currentFinancialId = previousFinancialId;
            }
        }
        
        List<IPM_Financial__c> lstIpmFinancial = new List<IPM_Financial__c>();
        
        lstIpmFinancial =   [SELECT Id, Name,recordTypeID, Financial_External_ID__c, Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                                FROM IPM_Financial__c
                                WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE
                                AND Parent_Project__c =: project.IPM_Parent_Project__c Limit: IPM_ConstantUtils.MaxLimit];
               
        For(IPM_Financial__c ipmFinancial : lstIpmFinancial)
        {
            if (ipmFinancial.Regional_Project__c == NULL)
            {
                mapConsolidatedFinancials.put(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, ipmFinancial);
            }
            else
            {
                mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);
            }

            if (previousFinancialId == ipmFinancial.Id)
            {
                currentFinancialId = previousFinancialId;
            }
        }
        
        if ((currentFinancialId == NULL) || (currentFinancialId == IPM_ConstantUtils.BLANK))
        {
            currentFinancialId = firstFinancialId;
        }
     }

    /*******************************************************************************************************
    * @description  Used to getRollout Wrappers for Regional Rollup Tab
    * @param        NONE
    * @return       NONE
    */
    private void getRegionalRollupWrappers()
    {
        String nonKeyLike = IPM_ConstantUtils.PERCENTAGE + IPM_ConstantUtils.FINANCIAL_NONKEY;
        List<IPM_Financial__c> lstRegionalFinancials =  [SELECT Id, Name,recordTypeID, Financial_External_ID__c, Status__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                                                            FROM IPM_Financial__c   
                                                            WHERE Regional_Project__c =: project.Id AND isActive__c = true
                                                            AND RecordTypeId =: DEFAULT_FINANCIAL_RECORDTYPE
                                                            AND (NOT Financial_External_ID__c LIKE: nonKeyLike)
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c Limit: IPM_ConstantUtils.MaxLimit];
                                                            
                                                     
        lstRolloutWrappers.add( new RolloutWrapper( project.Market_Cluster_Name__c, lstRegionalFinancials) );

        String firstFinancialId = '';
        
        For (IPM_Financial__c financial : lstRegionalFinancials)
        {
            if ((firstFinancialId == NULL) || (firstFinancialId == IPM_ConstantUtils.BLANK))
            {
                firstFinancialId = financial.Id;
            }
            
            if (previousFinancialId == financial.Id)
            {
                currentFinancialId = previousFinancialId;
            }
        }
        
        List<IPM_Financial__c> lstIpmFinancial = new List<IPM_Financial__c>();
        
        lstIpmFinancial =   [SELECT Id, Name,recordTypeID, Financial_External_ID__c, Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                            FROM IPM_Financial__c
                            WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE AND isActive__c = true
                            AND Regional_Project__c =: project.Id Limit: IPM_ConstantUtils.MaxLimit];
        
        if(!lstIpmFinancial.isEmpty())
        {
            for(IPM_Financial__c ipmFinancial : lstIpmFinancial)
            {
                if(ipmFinancial.Regional_Project__c == NULL)
                {
                    mapConsolidatedFinancials.put(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, ipmFinancial);
                }
                else
                {
                    mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);
                }

                if (previousFinancialId == ipmFinancial.Id)
                {
                    currentFinancialId = previousFinancialId;
                }
             }
        }
        
        if ((currentFinancialId == NULL) || (currentFinancialId == IPM_ConstantUtils.BLANK))
        {
            currentFinancialId = firstFinancialId;
        }    
    }

    /*******************************************************************************************************
    * @description  Used to getRollout Wrappers for Local My View & Top Down Tab
    * @param        NONE
    * @return       NONE
    */
    private void getLocalMyViewWrappers(){
        List<IPM_Financial__c> lstLocalFinancials = [SELECT Id, Name,recordTypeID, Financial_External_ID__c, Status__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                                                            FROM IPM_Financial__c
                                                            WHERE Local_Project__c =: project.Id
                                                                AND RecordtypeId =: DEFAULT_FINANCIAL_RECORDTYPE AND isActive__c = true 
                                                            ORDER BY Sorting_Order__c, Financial_External_Id__c Limit: IPM_ConstantUtils.MaxLimit];
        
                                             
        lstRolloutWrappers.add(
            new RolloutWrapper(
                project.IPM_Parent_Project__r.Market_Cluster_Name__c, 
                lstLocalFinancials
            )
        );

        String firstFinancialId = '';
        For (IPM_Financial__c financial : lstLocalFinancials){
            if ((firstFinancialId == NULL) || (firstFinancialId == IPM_ConstantUtils.BLANK)) {
                firstFinancialId = financial.Id;
            }
            if (previousFinancialId == financial.Id) {
                currentFinancialId = previousFinancialId;
            }
        }

        List<IPM_Financial__c> lstIpmFinancial = new List<IPM_Financial__c>();
        lstIpmFinancial = [SELECT Id, Name,recordTypeID, Financial_External_ID__c, Status__c, Regional_Project__c, Regional_Project__r.Market_Cluster_Name__c,IPM_Key_Financial__c,Status_Global__c,Status_Local__c,Status_Regional__c 
                                                 FROM IPM_Financial__c
                                                 WHERE RecordTypeId =: CONSOLIDATED_FINANCIAL_RECORDTYPE
                                                     AND Parent_Project__c =: project.IPM_Parent_Project__r.IPM_Parent_Project__c Limit: IPM_ConstantUtils.MaxLimit];
        
        
        if(!lstIpmFinancial.isEmpty()){
        For(IPM_Financial__c ipmFinancial : lstIpmFinancial){
            if (ipmFinancial.Regional_Project__c == NULL) {
                mapConsolidatedFinancials.put(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, ipmFinancial);
            }
            else {
                mapConsolidatedFinancials.put(ipmFinancial.Regional_Project__r.Market_Cluster_Name__c, ipmFinancial);
            }

            if (previousFinancialId == ipmFinancial.Id) {
                currentFinancialId = previousFinancialId;
            }
            }
        }
        if ((currentFinancialId == NULL) || (currentFinancialId == IPM_ConstantUtils.BLANK)){
            currentFinancialId = firstFinancialId;
        }
    }

      //DEF2676 fix Start
     public PageReference next() {
         isNavigation = true;
         nextIndex ++;
         previousIndex ++;
         getFinancials();
         return null;
     }
     public PageReference previous() {
         isNavigation = true;
         nextIndex --;
         previousIndex --;
         getFinancials();
         return null;
     }
     
   /****************************************************************************************************************
    * @description  		Used to get data related to MCO selected, queryies for the financial and finanical years 
    *              		    records to be displayed on the financial page. This generates data based on span and 
    *               		type of financial to be displayed default/consolidated 
    * @NPath Complexity:        due to complex functionality explained in the description we cannot avoid 
    					    NPathComplexity on this method.    
    * @param        NONE
    * @return       NONE
    ****************************************************************************************************************/
    private void getFinancials()
    {
        if(isNavigation) {
            isNavigation = false;
        } else {
            nextIndex = 0;
            previousIndex = 0;
        }
        grossCount = 0;
        incrementalCount = 0;
        getRecordtypes();
        
        fieldSuffix = getFieldSuffix();
        
        String queryString = 'SELECT ';
       
        //IPM Financial
        For (String field : Schema.SObjectType.IPM_Financial__c.fields.getMap().KeySet()) {
            queryString+= field + ', ';
        }
        //IPM Financial Year
        queryString+= 'Last_Saved_By_Global__r.Name,Last_Saved_By_Regional__r.Name,Last_Saved_By_Local__r.Name, (SELECT ';
        For (String field : Schema.SObjectType.IPM_Financial_Year__c.fields.getMap().KeySet()){
            if (!(field.equalsignoreCase('Id')) && field != IPM_ConstantUtils.FIELD_LITERAL_VOLUME_UNIT + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) 
            {
                queryString+= field + ', ';
            }
        }
        
      
        queryString+= 'Id FROM IPM_Financial_Years__r ORDER BY Name)';
        queryString+= 'FROM IPM_Financial__c WHERE Id =: currentFinancialId FOR UPDATE'; //Added For Update to obtain exclusive access to the record
        
        List<IPM_Financial__c> LstCurrentFinancial = new List<IPM_Financial__c>();
        LstCurrentFinancial = Database.query(queryString);
                    
        if(!LstCurrentFinancial.isEmpty()){
            currentFinancial = LstCurrentFinancial[0];
         }
        mapFinancialYears = new Map<String, IPM_Financial_Year__c>();
        if (currentFinancial != NULL)
        {
            financialsInnovation = new IPM_FinancialWrapper();
            financialsCalendar = new IPM_FinancialWrapper();

            // DEF2676 fix start
            consolidatedYearCount = 0;
            if(currentFinancial.RecordTypeId == CONSOLIDATED_FINANCIAL_RECORDTYPE) {
                 for (IPM_Financial_Year__c finYear : currentFinancial.IPM_Financial_Years__r){
                    if (finYear.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS) {
                        consolidatedYearCount ++;
                    }
                }
                if( consolidatedYearCount>sustainabilityPeriod && nextIndex==0 && previousIndex==0 ) {
                    previousIndex = 1;
                    nextIndex = sustainabilityPeriod;
                }
            }
           // DEF2676 fix end
            for (IPM_Financial_Year__c finYear : currentFinancial.IPM_Financial_Years__r){
                //Add to Map
                mapFinancialYears.put(generateMapKey(finYear.Year_Type__c, finYear.Year__c, finYear.PL_Type__c), finYear);
                
                //Innovation Years
                if (finYear.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_INNOVATION){
                    generateFinancials(finYear, financialsInnovation);
                                  
                }
                //Calendar Years
                else if (finYear.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR){
                    if(currentFinancial.RecordTypeId == CONSOLIDATED_FINANCIAL_RECORDTYPE) {
                        if(finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS) {
                            grossCount++;
                        } else if(finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL) {
                            incrementalCount++;
                        }  
                    }
                    
                    if(currentFinancial.RecordTypeId == CONSOLIDATED_FINANCIAL_RECORDTYPE && consolidatedYearCount>sustainabilityPeriod ) { 
                        if(finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS && grossCount>=previousIndex && grossCount<=nextIndex) {
                            generateFinancials(finYear, financialsCalendar);
                        } else if(finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL && incrementalCount>=previousIndex && incrementalCount<=nextIndex) {
                            generateFinancials(finYear, financialsCalendar);
                        }
                    } else {
                        generateFinancials(finYear, financialsCalendar);
                    }

                    
               }
            }
            getCountryList();
        }
            setMisalignedValue();        
        
    }
    
    /*******************************************************************************************************
    * @description      Used to generate Financial Wrapper for the selected Financial Year
    * @param finYear    Selected IPM_Financial_Year__c record which needs to be processed
    * @param finWrapper Selected wrapper record which needs to be updated with the finYear values
    * @return       NONE
    */
    private void generateFinancials(IPM_Financial_Year__c finYear, IPM_FinancialWrapper finWrapper){
        //Year 0 Values
           
        if (finYear.Year__c == IPM_ConstantUtils.Y0_YEARINDEX)
        {
            finWrapper.y0ValueMarketShare = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0Volume = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0VolumeTons = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0Turnover = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) * decMultFactor;
            finWrapper.y0GrossProfit = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) * decMultFactor;
            finWrapper.y0Advertising = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) * decMultFactor;
            finWrapper.y0Profit = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) * decMultFactor;
            finWrapper.y0GM = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_GM_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0AP = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_AP_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
            finWrapper.y0PBO = (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_PBO_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
                        
                        //Misaligned value differences
            if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL || project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT){
               
                finWrapper.y0ValueMarketShareDifference = finYear.Value_Market_Share_Difference__c;
                finWrapper.y0VolumeDifference = finYear.Volume_Difference__c * decMultFactor;
                finWrapper.y0VolumeTonsDifference = finYear.Volume_Tons_Difference__c * decMultFactor;
                finWrapper.y0TurnoverDifference = finYear.Turnover_Difference__c * decMultFactor;
                finWrapper.y0GrossProfitDifference = finYear.Gross_Profit_Difference__c * decMultFactor;
                finWrapper.y0AdvertisingDifference = finYear.Advertising_Promotions_Difference__c * decMultFactor;
                finWrapper.y0ProfitDifference = finYear.Profit_Before_Overheads_Difference__c * decMultFactor;
                finWrapper.y0GMDifference = finYear.GM_of_TO_Difference__c;
                finWrapper.y0APDifference = finYear.AP_of_TO_Difference__c;
                finWrapper.y0PBODifference = finYear.PBO_of_TO_Difference__c;
                
                //Regional and Local values to show on misalignment
                finWrapper.y0ValueMarketShareRegional = finYear.Value_Market_Share_Regional__c;
                finWrapper.y0ValueMarketShareLocal = finYear.Value_Market_Share_Local__c;
                finWrapper.y0VolumeRegional = finYear.Volume_Regional__c * decMultFactor;
                finWrapper.y0VolumeLocal = finYear.Volume_Local__c * decMultFactor;
                finWrapper.y0VolumeTonsRegional = finYear.Volume_Tons_Regional__c * decMultFactor ;
                finWrapper.y0VolumeTonsLocal = finYear.Volume_Tons_Local__c * decMultFactor;            
                finWrapper.y0TurnoverRegional = finYear.Turnover_Regional__c * decMultFactor ;
                finWrapper.y0TurnoverLocal = finYear.Turnover_Local__c * decMultFactor;           
                finWrapper.y0GrossProfitRegional = finYear.Gross_Profit_Regional__c * decMultFactor ;
                finWrapper.y0GrossProfitLocal = finYear.Gross_Profit_Local__c * decMultFactor;            
                finWrapper.y0AdvertisingRegional = finYear.Advertising_Promotions_Regional__c * decMultFactor;
                finWrapper.y0AdvertisingLocal = finYear.Advertising_Promotions_Local__c * decMultFactor;           
                finWrapper.y0ProfitRegional = finYear.Profit_Before_Overheads_Regional__c * decMultFactor ;
                finWrapper.y0ProfitLocal = finYear.Profit_Before_Overheads_Local__c * decMultFactor;           
                finWrapper.y0GMRegional = finYear.GM_of_TO_Regional__c ;
                finWrapper.y0GMLocal = finYear.GM_of_TO_Local__c;           
                finWrapper.y0APRegional = finYear.AP_of_TO_Regional__c ;
                finWrapper.y0APLocal = finYear.AP_of_TO_Local__c;           
                finWrapper.y0PBORegional = finYear.PBO_of_TO_Regional__c ;
                finWrapper.y0PBOLocal = finYear.PBO_of_TO_Local__c;
            }
        } 
        //Rest of the Year Values
        else if(Integer.valueOf(finYear.Year__c) <= sustainabilityPeriod) {
            //Gross P&L Values
            if (finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS){
                finWrapper.lstYearNames.add(finYear.Name);
                
                //Gross PL Values to show when misaligned with Regional and Local
                finWrapper.lstGrossPLValueMarketShare.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.Value_Market_Share_Regional__c, finYear.Value_Market_Share_Local__c, finYear.Value_Market_Share_Difference__c, 1));                
                finWrapper.lstGrossPLVolume.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.Volume_Regional__c, finYear.Volume_Local__c, finYear.Volume_Difference__c));
                finWrapper.lstGrossPLVolumeTons.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.Volume_Tons_Regional__c, finYear.Volume_Tons_Local__c, finYear.Volume_Tons_Difference__c));
                finWrapper.lstGrossPLTurnover.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) * decMultFactor, finYear.Turnover_Regional__c, finYear.Turnover_Local__c, finYear.Turnover_Difference__c));
                finWrapper.lstGrossPLGrossProfit.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) * decMultFactor, finYear.Gross_Profit_Regional__c , finYear.Gross_Profit_Local__c, finYear.Gross_Profit_Difference__c));
                finWrapper.lstGrossPLAdvertising.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) * decMultFactor, finYear.Advertising_Promotions_Regional__c , finYear.Advertising_Promotions_Local__c, finYear.Advertising_Promotions_Difference__c));
                finWrapper.lstGrossPLProfit.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) * decMultFactor, finYear.Profit_Before_Overheads_Regional__c, finYear.Profit_Before_Overheads_Local__c, finYear.Profit_Before_Overheads_Difference__c));
                finWrapper.lstGrossPLGM.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_GM_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.GM_of_TO_Regional__c , finYear.GM_of_TO_Local__c, finYear.GM_of_TO_Difference__c, 1));
                finWrapper.lstGrossPLAP.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_AP_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.GM_of_TO_Regional__c , finYear.AP_of_TO_Local__c, finYear.AP_of_TO_Difference__c, 1));
                finWrapper.lstGrossPLPBO.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_PBO_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.PBO_of_TO_Regional__c , finYear.PBO_of_TO_Local__c, finYear.PBO_of_TO_Difference__c, 1));
             
            }
            //Incremental PL Values to show when misaligned with Regional and Local
            else if (finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL) {
                finWrapper.lstIncrementalPLValueMarketShare.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.Value_Market_Share_Regional__c, finYear.Value_Market_Share_Local__c, finYear.Value_Market_Share_Difference__c, 1));
                finWrapper.lstIncrementalPLVolume.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.Volume_Regional__c, finYear.Volume_Local__c, finYear.Volume_Difference__c));
                finWrapper.lstIncrementalPLVolumeTons.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.Volume_Tons_Regional__c, finYear.Volume_Tons_Local__c, finYear.Volume_Tons_Difference__c));
                finWrapper.lstIncrementalPLTurnover.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)* decMultFactor, finYear.Turnover_Regional__c, finYear.Turnover_Local__c, finYear.Turnover_Difference__c));
                finWrapper.lstIncrementalPLGrossProfit.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) * decMultFactor, finYear.Gross_Profit_Regional__c , finYear.Gross_Profit_Local__c, finYear.Gross_Profit_Difference__c));
                finWrapper.lstIncrementalPLAdvertising.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) * decMultFactor, finYear.Advertising_Promotions_Regional__c , finYear.Advertising_Promotions_Local__c, finYear.Advertising_Promotions_Difference__c));
                finWrapper.lstIncrementalPLProfit.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX) * decMultFactor, finYear.Profit_Before_Overheads_Regional__c, finYear.Profit_Before_Overheads_Local__c, finYear.Profit_Before_Overheads_Difference__c));
                finWrapper.lstIncrementalPLGM.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_GM_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.GM_of_TO_Regional__c , finYear.GM_of_TO_Local__c, finYear.GM_of_TO_Difference__c, 1));
                finWrapper.lstIncrementalPLAP.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_AP_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.GM_of_TO_Regional__c , finYear.AP_of_TO_Local__c, finYear.AP_of_TO_Difference__c, 1));
                finWrapper.lstIncrementalPLPBO.add(new IPM_FinancialValueWrapper(Integer.valueOf(finYear.Year__c), (Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_PBO_OF_TO + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX), finYear.PBO_of_TO_Regional__c , finYear.PBO_of_TO_Local__c, finYear.PBO_of_TO_Difference__c, 1));
                
                
            }
        }
    }
    
    /*******************************************************************************************************
    * @description  Used to set is the misalignment should be visible on tabs
    * @param        NONE
    * @return       NONE
    */
    private void getMisalignmentVisibility()
    {
        showMisalignment = FALSE;
        
        List<IPM_Project__c> lstLocalProjects = new List<IPM_Project__c>();
        
        if (project.IPMProject_Span__c != IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && currentTab == IPM_ConstantUtils.TAB_MYVIEW_NAME && 
            (project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL || project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT))
        {
            
             // check if it is a Regional Rollout Or Regional Orignal, Check if there are local Projects created. If yes, then only display misAlignment. 
            
           
            
            if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
            {
                
                String financialExternalId = null; 
                
                if(currentFinancial!=null && currentFinancial.Financial_External_ID__c!=null && currentFinancial.recordTypeId != CONSOLIDATED_FINANCIAL_RECORDTYPE && !currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY) )
                {
                    financialExternalId = currentFinancial.Financial_External_ID__c;
                }
                      
                if(financialExternalId !=null) 
                {
                   lstLocalProjects = [Select Id from IPM_Project__c WHERE IPM_Parent_Project__c = :project.Id AND IPM_Project_Name__c =:financialExternalId AND IPMProject_Span__c = :IPM_ConstantUtils.PROJECT_SPAN_LOCAL];
                }
                else
                {
                    lstLocalProjects = [Select Id from IPM_Project__c WHERE IPM_Parent_Project__c = :project.Id AND IPMProject_Span__c = :IPM_ConstantUtils.PROJECT_SPAN_LOCAL];       
                }
                
                if(!lstLocalProjects.isEmpty())
                {
                    showMisalignment = true;        
                }
            }
            else
            {
                showMisalignment = true; 
            }
            
            if(currentFinancial!=null && currentFinancial.Financial_External_ID__c!=null && (currentFinancial.recordTypeId == CONSOLIDATED_FINANCIAL_RECORDTYPE || currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY) ) )
            {
                 showMisalignment = false;       
            }
        }
    }

    
    /*******************************************************************************************************
    * @description  Used to redirect user to the download template page
    * @param        NONE
    * @return       NONE
    */
     public PageReference CopyPasteTemplate(){
        try {
            PageReference templatePage = Page.IPM_FinancialCopyPasteGrid;
            templatePage.getParameters().put(IPM_ConstantUtils.SF_ID, project.Id);
            templatePage.getParameters().put(IPM_ConstantUtils.BI, BI);
            templatePage.setRedirect(true);
            return templatePage;
            
        } catch (Exception eX){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    IPM_ConstantUtils.EXCEPTION_IPM_FINANCIALCOPYPASTEGRID,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            return null;
        }
    }
    
    /*******************************************************************************************************
    * @description  Used to redirect user to the gate document section
    * @param        NONE
    * @return       NONE
    */
    public PageReference goToSection(){
        try {
            PageReference sectionPage = Page.IPM_ProjectDocumentSectionEditor;
            sectionPage.getParameters().put(IPM_ConstantUtils.SF_ID, project.Id);
            sectionPage.getParameters().put(IPM_ConstantUtils.SF_PROJ_DOC_SEC_ID, selectedDocumentSection);
            sectionPage.setRedirect(true);
            return sectionPage;
           
        } catch (Exception eX){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    IPM_ConstantUtils.EXCEPTION_GOTOSECTION,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            return null;
        }
    }

    /*******************************************************************************************************
    * @description  Used to change the sustainability period of the project
    * @param        NONE
    * @return       NONE
    */
    public void changeSustainabilityPeriod(){
        try{
            sustainabilityPeriodChanging = true;
            project.Sustainability_Period__c = selectedSustainabilityPeriod;
            project.Sustainability_Period_Changed__c = true;
            Database.update(project);
    
            getSustainabilityPeriod();
            getFinancials();
        } catch (Exception eX){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    IPM_ConstantUtils.EXCEPTION_CHANGESUSTAINABILITY,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }

    /*******************************************************************************************************
    * @description  Used to check if Sustainability Period for the project has changed
    * @param        NONE
    * @return       NONE
    */
    public void checkSustainabilityPeriodChanged(){
        try {
             getSustainabilityPeriod();
             getFinancials();
            
            if(currentFinancial.Project_Sustainability_Period__c == selectedSustainabilityPeriod) {
                sustainabilityPeriodChanging = false;
            }
            validateCalendarFinancialRecords(financialsCalendar, IPM_ConstantUtils.YEAR_TYPE_CALENDAR);
            validateInnovationFinancialRecords(financialsInnovation, IPM_ConstantUtils.YEAR_TYPE_INNOVATION);
        } catch (Exception eX){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    IPM_ConstantUtils.EXCEPTION_CHECKSUSTAINABILITY,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }

    /*******************************************************************************************************
    * @description  Used to refresh the financials for the current tab
    * @param        NONE
    * @return       NONE
    */
    public void refreshFinancials()
    {
        try 
        {
            getFinancials();
            getMisalignmentVisibility();
            isEditMode = FALSE;
            validateCalendarFinancialRecords(financialsCalendar, IPM_ConstantUtils.YEAR_TYPE_CALENDAR);
            validateInnovationFinancialRecords(financialsInnovation, IPM_ConstantUtils.YEAR_TYPE_INNOVATION);
        } 
        catch (Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    IPM_ConstantUtils.EXCEPTION_REFRESHFINANCIALS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }

    /*******************************************************************************************************
    * @description  Used to refresh the financials for tab change
    * @param        NONE
    * @return       NONE
    */
    public void changeTabs()
    {
        try 
        {
            getRolloutWrappers();
            getFinancials();
            getMisalignmentVisibility();
            isEditMode = FALSE;
            validateCalendarFinancialRecords(financialsCalendar, IPM_ConstantUtils.YEAR_TYPE_CALENDAR);
            validateInnovationFinancialRecords(financialsInnovation, IPM_ConstantUtils.YEAR_TYPE_INNOVATION);
        } 
        catch (Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    IPM_ConstantUtils.EXCEPTION_CHANGETABS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }
    
    /*******************************************************************************************************
    * @description  Used to edit the current Financials
    * @param        NONE
    * @return       NONE
    */
    public void editFinancials() {
        try{
            isEditMode = true;
			if(toShowEditOpern||toShowEditButton){
                isCopyfromSTDBC=true;   
            }
           
        } catch (Exception eX){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                   IPM_ConstantUtils.EXCEPTION_EDITFINANCIALS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }
    
    /*******************************************************************************************************
    * @description  Used to validate and save the current Financials
    * @param        NONE
    * @return       NONE
    */
    public void saveFinancials() 
    {
       try 
       {
            lstUpdateFinancials = new List<IPM_Financial_Year__c>();
            milestoneFinanceDataValidationMessage = '';
            Boolean isCalendarValidationFailed = false;
            Boolean isInnovationValidationFailed = false;
            isEditMode = false;
                 //DO NOT CHANGE the order - Calendar years need to be saved first before Innovation Years to ensure Volume Units get saved appropriately
                  saveFinancialRecords(financialsCalendar, IPM_ConstantUtils.YEAR_TYPE_CALENDAR);
                  saveFinancialRecords(financialsInnovation, IPM_ConstantUtils.YEAR_TYPE_INNOVATION);
      
                  //Update Financial Record
              currentFinancial.Status__c = IPM_ConstantUtils.STATUS_IN_PROGRESS;
              currentFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_STATUS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, IPM_ConstantUtils.STATUS_IN_PROGRESS);
              currentFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_LAST_SAVED + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, System.now());
              currentFinancial.put(IPM_ConstantUtils.FIELD_LITERAL_LAST_SAVED_BY + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, UserInfo.getUserId());
              Database.update(currentFinancial);
              
              //Update Financial Year Records
              if (lstUpdateFinancials!=null && !lstUpdateFinancials.isEmpty()) {
                  update lstUpdateFinancials;
              }
             
              getRolloutWrappers(currentFinancialId);
              getFinancials();
              setBusinessImpact(projectId);
              BI = globalbusinessImpactStr;
               if(BI == null || BI == ''){
                  BI = IPM_ConstantUtils.smallBI;
                }
                  isCalendarValidationFailed = validateCalendarFinancialRecords(financialsCalendar, IPM_ConstantUtils.YEAR_TYPE_CALENDAR);
                  isInnovationValidationFailed = validateInnovationFinancialRecords(financialsInnovation, IPM_ConstantUtils.YEAR_TYPE_INNOVATION);
          	  //check for hard validation - REQ3006
          	  if(isFinancialInvalid || isFinancialInvalidInnovation){
              	currentFinancial.isFinancialInvalid__c = true;
              }
              else{
                currentFinancial.isFinancialInvalid__c = false;
              }
              Database.update(currentFinancial);
                  IPM_ChatterFeedHelper.postChatterIfBusinessCaseSaved(new List<IPM_Financial__c>{currentFinancial});      
                                            
                             
        } catch (Exception eX){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    IPM_ConstantUtils.EXCEPTION_SAVEFINANCIALS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }
    
        /*******************************************************************************************************
    * @description              Used to validate the financial record values entered to save
    * @param finWrapper         Used to process the passed financial wrapper(financialsCalendar or financialsInnovation)
    * @param yearType       Used to process the passed financial wrapper for the passed year type
    * @return                   Boolean value says if the validation is failed or not
    */
    private Boolean validateInnovationFinancialRecords(IPM_FinancialWrapper finWrapper, String yearType){
        isValidationFailed = false;
        //Validate Innovation Year cell data
        //REQ3006- non key financial will be validated in upto charter, post charter validation will not be for non key financials
        if(yearType == IPM_ConstantUtils.YEAR_TYPE_INNOVATION && currentFinancial != NULL  
        	&& (!currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY) || (currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY) && project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS))){
        	if(BI != IPM_ConstantUtils.smallBI){
                validateY0Turnover(finWrapper.y0Turnover);
                
                //Validate Gross Turnover values 
                validateGrossTurnover(finWrapper.lstGrossPLTurnover);

                //No validation needed for Incremental TO, since it could be zero or even negative              
                validateIncrementalTurnover(finWrapper.lstIncrementalPLTurnover); // it is not showing incremental turn over
                //Validate Y0 Gross Profit values
                validateY0GrossProfit(finWrapper.y0GrossProfit);
                
                //Validate Gross Profit values
                validateGrossProfit(finWrapper.lstGrossPLGrossProfit);

                //Validate Incremental Profit values
                validateIncrementalProfit(finWrapper.lstIncrementalPLGrossProfit);

                //Validate Y0 PBO value
                validateY0PBO(finWrapper.y0Profit);
                
                //Validate Gross PBO values
                validateGrossPBO(finWrapper.lstGrossPLProfit);
                
                validateGrossBMI(finWrapper.lstGrossPLAdvertising);
                validateIncrementalBMI(finWrapper.lstIncrementalPLAdvertising);
                //Validate Incremental PBO values
                validateIncrementalPBO(finWrapper.lstIncrementalPLProfit);
        	}
                validateInnovationTurnOver(finWrapper.lstGrossPLTurnover,finWrapper.lstIncrementalPLTurnover);
                
        }
        return isValidationFailed;
    }   
                
    /*******************************************************************************************************
    * @description              Used to validate the financial record values entered to save
    * @param finWrapper         Used to process the passed financial wrapper(financialsCalendar or financialsInnovation)
    * @param yearType       Used to process the passed financial wrapper for the passed year type
    * @return                   Boolean value says if the validation is failed or not
    */
    private Boolean validateCalendarFinancialRecords(IPM_FinancialWrapper finWrapper, String yearType){
        isValidationFailed = false;
        //Validate Calendar Year cell data
        //REQ3006- non key financial will be validated in upto charter, post charter validation will not be for non key financials
        if(yearType == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && currentFinancial != NULL 
        	&& (!currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY) || (currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY) && project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS))){
               Boolean isValidateIncrementalTurnoverFailed= false;
               Boolean isValidateIncrementalProfitFailed= false; 
               Boolean isValidateGrossProfitFailed= false;
               Boolean isValidateGrossPBOFailed= false;
               Boolean isValidateIncrementalPBOFailed= false ;
               Boolean isValidateGrossBMIFailed= false;
               Boolean isValidateIncrementalBMIFailed= false ;
               Boolean isValidateGrossTurnoverFailed= false;
                if(BI != IPM_ConstantUtils.smallBI){
	                //Validate Gross Turnover values 
	                isValidateGrossTurnoverFailed = validateGrossTurnover(finWrapper.lstGrossPLTurnover);
	                
	                //validateForGateSubmission
	                isValidateIncrementalTurnoverFailed = validateIncrementalTurnover(finWrapper.lstIncrementalPLTurnover); 
	                isValidateGrossProfitFailed = validateGrossProfit(finWrapper.lstGrossPLGrossProfit);
	                isValidateIncrementalProfitFailed = validateIncrementalProfit(finWrapper.lstIncrementalPLGrossProfit);
	                isValidateGrossPBOFailed = validateGrossPBO(finWrapper.lstGrossPLProfit);
	                isValidateIncrementalPBOFailed = validateIncrementalPBO(finWrapper.lstIncrementalPLProfit);
                  isValidateGrossBMIFailed = validateGrossBMI(finWrapper.lstGrossPLAdvertising);
                  isValidateIncrementalBMIFailed = validateIncrementalBMI(finWrapper.lstIncrementalPLAdvertising);
                }
                Boolean isValidateCalendarTurnOverFailed=validateCalendarTurnOver(finWrapper.lstGrossPLTurnover,finWrapper.lstIncrementalPLTurnover);
                if(isValidateIncrementalBMIFailed && isValidateGrossBMIFailed && isValidateCalendarTurnOverFailed && isValidateIncrementalTurnoverFailed && isValidateGrossProfitFailed && isValidateIncrementalProfitFailed && isValidateGrossPBOFailed && isValidateIncrementalPBOFailed){
                        currentFinancial.isGateSubmissionDue__c = true;
                }
                
                
        }        
                    return isValidationFailed;
    }

      private Boolean validateMilestoneAndFinacialData() { 
        List<IPM_Project__c> projList = IPM_ValidationHelper.validateMilestoneAndFinacialData(new List<IPM_Project__c>{project}); 
        return !projList.isEmpty(); 
      } 
    
  
       
    //DEF2339 & DEF2344 fix end
    /*******************************************************************************************************
    * @description              Used to validate the financial Y0Turnover
    * @param y0Turnover         Used to process the passed y0Turnover
    * @return                   Boolean value says if the validation is failed or not
    */
    public void validateY0Turnover(Decimal y0Turnover){
        isy0TurnoverInvalid = false;
        isValidationFailed = false;
        //Validate Y0 Turnover value   
        if(y0Turnover <= IPM_ConstantUtils.INVALID_VALUE){
            isy0TurnoverInvalid = true;
                isValidationFailed = true;            
        }
    } 
    
    /*******************************************************************************************************
    * @description                      Used to validate the financial GrossPLTurnover
    * @param lstGrossPLTurnover     Used to process the passed lstGrossPLTurnover
    * @return                           Boolean value says if the validation is failed or not
    */
    public boolean validateGrossTurnover(List<IPM_FinancialValueWrapper> lstGrossPLTurnover){
                //Validate Gross Turnover values.
        isFinancialInvalid = false;
        isValidationError = false;
        validationErrorMessage = '';
        for(IPM_FinancialValueWrapper valueWrapper: lstGrossPLTurnover){
            valueWrapper.isValueInvalid = false;
            valueWrapper.isGrossTOValueInvalid = false;
                if(valueWrapper.value <= IPM_ConstantUtils.INVALID_VALUE){
                    valueWrapper.isValueInvalid = true;
                    valueWrapper.isGrossTOValueInvalid = true;
                    isValidationFailed = true;
                    isFinancialInvalid = true;
                    isValidationError = true;
	                validationErrorMessage = IPM_ConstantUtils.INVALID_DATA_TO_SAVE;
                }            
        }
        return isValidationFailed;
    }
    
    /*******************************************************************************************************
    * @description                              Used to Validate Incremental Turnover values
    * @param lstIncrementalPLTurnover   Used to process the passed lstIncrementalPLTurnover
    * @return                                   Boolean value says if the validation is failed or not
    */
    public boolean validateIncrementalTurnover(List<IPM_FinancialValueWrapper> lstIncrementalPLTurnover){
                //Validate Incremental Turnover values
                Boolean isInvalid = false;
        for(IPM_FinancialValueWrapper valueWrapper: lstIncrementalPLTurnover){
            valueWrapper.isValueInvalid = false;
            valueWrapper.isMinorValueInvalid = false;
            isInvalid = false;
            if(valueWrapper.value <= IPM_ConstantUtils.INVALID_VALUE){                
                valueWrapper.isValueInvalid = true;
                valueWrapper.isMinorValueInvalid = true;                
                isValidationFailed = true;
                isInvalid = true;
            }            
        }
        return isInvalid;
    }
    
    /*******************************************************************************************************
    * @description         Used to validate the financial y0GrossProfit
    * @param y0GrossProfit         Used to process the passed y0GrossProfit
    * @return              Boolean value says if the validation is failed or not
    */
    public void validateY0GrossProfit(Decimal y0GrossProfit){
        //Validate Y0GrossProfit value    
        if(y0GrossProfit <= IPM_ConstantUtils.INVALID_VALUE){            
            isy0GrossProfitInvalid = true;
            isValidationFailed = true;
        }
    }
    
    /*******************************************************************************************************
    * @description                              Used to Validate Gross Profit values
    * @param lstGrossPLGrossProfit      Used to process the passed lstGrossPLGrossProfit
    * @return                                   Boolean value says if the validation is failed or not
    */
    public boolean validateGrossProfit(List<IPM_FinancialValueWrapper> lstGrossPLGrossProfit){
        //Validate Gross Profit values
        Boolean isInvalid = false;
        for(IPM_FinancialValueWrapper valueWrapper: lstGrossPLGrossProfit){
            //valueWrapper.isValueInvalid = false;
            valueWrapper.isMinorValueInvalid = false;
            isInvalid = false;
            if(valueWrapper.value <= IPM_ConstantUtils.INVALID_VALUE){
                valueWrapper.isMinorValueInvalid = true;
                isValidationFailed = true;
                isInvalid = true;
            }
        } 
        return isInvalid;
    }
        
    /*******************************************************************************************************
    * @description                              Used to Validate Gross Profit values
    * @param lstIncrementalPLGrossProfit        Used to process the passed lstIncrementalPLGrossProfit
    * @return                                   Boolean value says if the validation is failed or not
    */
    public boolean validateIncrementalProfit(List<IPM_FinancialValueWrapper> lstIncrementalPLGrossProfit){
        //Validate Incremental Profit values
        Boolean isInvalid = false;
        for(IPM_FinancialValueWrapper valueWrapper: lstIncrementalPLGrossProfit){
            valueWrapper.isValueInvalid = false;
            valueWrapper.isMinorValueInvalid = false;
            isInvalid = false;
            if(valueWrapper.value <= IPM_ConstantUtils.INVALID_VALUE){
                valueWrapper.isValueInvalid = true;
                valueWrapper.isMinorValueInvalid = true;
                isValidationFailed = true;
                isInvalid = true;
            }
        } 
        return isInvalid;
    }
    
    /*******************************************************************************************************
    * @description         Used to validate the financial y0Profit
    * @param y0Profit         Used to process the passed y0Profit
    * @return              Boolean value says if the validation is failed or not
    */
    public void validateY0PBO(Decimal y0Profit){
        //Validate Y0 PBO value    
        if(y0Profit <= IPM_ConstantUtils.INVALID_VALUE){
            isy0ProfitInvalid = true;
            isValidationFailed = true;
        }
    }
    /*******************************************************************************************************
    * @description                              Used to Validate Gross Profit values
    * @param lstGrossPLProfit   Used to process the passed lstGrossPLProfit
    * @return                                   Boolean value says if the validation is failed or not
    */
    public boolean validateGrossBMI(List<IPM_FinancialValueWrapper> lstGrossBMI){
        //Validate Gross Profit values
        Boolean isInvalid = false;
        for(IPM_FinancialValueWrapper valueWrapper: lstGrossBMI){
            valueWrapper.isValueInvalid = false;
            valueWrapper.isMinorValueInvalid = false;
            isInvalid = false;
            if(valueWrapper.value <= IPM_ConstantUtils.INVALID_VALUE){
                valueWrapper.isValueInvalid = true;
                valueWrapper.isMinorValueInvalid = true;
                isValidationFailed = true;
                isInvalid = true;
            }
        } 
        return isInvalid;
    }
    /*******************************************************************************************************
    * @description                              Used to Validate Gross Profit values
    * @param lstIncrementalPLProfit     Used to process the passed lstIncrementalPLProfit
    * @return                                   Boolean value says if the validation is failed or not
    */
    public boolean validateIncrementalBMI(List<IPM_FinancialValueWrapper> lstIncrementalBMI){
        //Validate Incremental Profit values
        Boolean isInvalid = false;
        for(IPM_FinancialValueWrapper valueWrapper: lstIncrementalBMI){
            valueWrapper.isValueInvalid = false;
            valueWrapper.isMinorValueInvalid = false;
            isInvalid = false;
            if(valueWrapper.value <= IPM_ConstantUtils.INVALID_VALUE){
                valueWrapper.isValueInvalid = true;
                valueWrapper.isMinorValueInvalid = true;
                isValidationFailed = true;
                isInvalid = true;
            }
        } 
        return isInvalid;
    }
    
    /*******************************************************************************************************
    * @description                              Used to Validate Gross Profit values
    * @param lstGrossPLProfit   Used to process the passed lstGrossPLProfit
    * @return                                   Boolean value says if the validation is failed or not
    */
    public boolean validateGrossPBO(List<IPM_FinancialValueWrapper> lstGrossPLProfit){
        //Validate Gross Profit values
        Boolean isInvalid = false;
        for(IPM_FinancialValueWrapper valueWrapper: lstGrossPLProfit){
            valueWrapper.isValueInvalid = false;
            valueWrapper.isMinorValueInvalid = false;
            isInvalid = false;
            if(valueWrapper.value <= IPM_ConstantUtils.INVALID_VALUE){
                valueWrapper.isValueInvalid = true;
                valueWrapper.isMinorValueInvalid = true;
                isValidationFailed = true;
                isInvalid = true;
            }
        } 
        return isInvalid;
    }
    
    /*******************************************************************************************************
    * @description                              Used to Validate Gross Profit values
    * @param lstIncrementalPLProfit     Used to process the passed lstIncrementalPLProfit
    * @return                                   Boolean value says if the validation is failed or not
    */
    public boolean validateIncrementalPBO(List<IPM_FinancialValueWrapper> lstIncrementalPLProfit){
        //Validate Incremental Profit values
        Boolean isInvalid = false;
        for(IPM_FinancialValueWrapper valueWrapper: lstIncrementalPLProfit){
            valueWrapper.isValueInvalid = false;
            valueWrapper.isMinorValueInvalid = false;
            isInvalid = false;
            if(valueWrapper.value <= IPM_ConstantUtils.INVALID_VALUE){
                valueWrapper.isValueInvalid = true;
                valueWrapper.isMinorValueInvalid = true;
                isValidationFailed = true;
                isInvalid = true;
            }
        } 
        return isInvalid;
    }
         
    
    /*******************************************************************************************************
    * @description          Used to save the current Financial Records
    * @param finWrapper     Used to process the passed financial wrapper
    * @param yearType       Used to process the passed financial wrapper for the passed year type
    * @return               NONE
    */
    private void saveFinancialRecords(IPM_FinancialWrapper finWrapper, String yearType){
        mapFinancialYearRecords = new Map<String, IPM_Financial_Year__c>();
        
        //Year 0
        IPM_Financial_Year__c y0FinancialYear = mapFinancialYears.get(generateMapKey(yearType, IPM_ConstantUtils.Y0_YEARINDEX, null));
        
        y0FinancialYear.put(IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, finWrapper.y0ValueMarketShare);
        y0FinancialYear.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, finWrapper.y0Volume);
        y0FinancialYear.put(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX,finWrapper.y0VolumeTons);
        y0FinancialYear.put(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, finWrapper.y0Turnover);
        y0FinancialYear.put(IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, finWrapper.y0GrossProfit);
        y0FinancialYear.put(IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, finWrapper.y0Advertising);
        y0FinancialYear.put(IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX, finWrapper.y0Profit);

        lstUpdateFinancials.add(y0FinancialYear);
        
        //GROSS P&L
        processFinancialYearRecords(finWrapper.lstGrossPLValueMarketShare, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        processFinancialYearRecords(finWrapper.lstGrossPLVolume, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.FIELD_LITERAL_VOLUME + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        processFinancialYearRecords(finWrapper.lstGrossPLVolumeTons, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);       
        processFinancialYearRecords(finWrapper.lstGrossPLTurnover, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        processFinancialYearRecords(finWrapper.lstGrossPLGrossProfit, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        processFinancialYearRecords(finWrapper.lstGrossPLAdvertising, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        processFinancialYearRecords(finWrapper.lstGrossPLProfit, yearType, IPM_ConstantUtils.PL_TYPE_GROSS, IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);

        //INCREMENTAL P&L
        processFinancialYearRecords(finWrapper.lstIncrementalPLValueMarketShare, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, IPM_ConstantUtils.FIELD_LITERAL_VALUE_MARKET_SHARE + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        processFinancialYearRecords(finWrapper.lstIncrementalPLVolume, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, IPM_ConstantUtils.FIELD_LITERAL_VOLUME + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        processFinancialYearRecords(finWrapper.lstIncrementalPLVolumeTons, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, IPM_ConstantUtils.FIELD_LITERAL_VOLUME_TONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        processFinancialYearRecords(finWrapper.lstIncrementalPLTurnover, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        processFinancialYearRecords(finWrapper.lstIncrementalPLGrossProfit, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        processFinancialYearRecords(finWrapper.lstIncrementalPLAdvertising, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        processFinancialYearRecords(finWrapper.lstIncrementalPLProfit, yearType, IPM_ConstantUtils.PL_TYPE_INCREMENTAL, IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);

        //Add all the objects
        if (mapFinancialYearRecords!=null && !mapFinancialYearRecords.isEmpty()){
            For(IPM_Financial_Year__c obj : mapFinancialYearRecords.values()) {
                lstUpdateFinancials.add(obj);
            }
        }
    }

    /*******************************************************************************************************
    * @description              Used to process the individual Financial Year record
    * @param lstValueWrapper    The list Wrapper of the various attributes managed for the current business case
    * @param yearType           Used to process the passed financial wrapper for the passed year type
    * @param plType             Used to process the passed financial wrapper for the passed P&L type
    * @param fieldName          Used to manage the appropriate field for which the data should be processed
    * @return                   NONE
    */
    private void processFinancialYearRecords(List<IPM_FinancialValueWrapper> lstValueWrapper, String yearType, String plType, String fieldName)
    {
        For(IPM_FinancialValueWrapper valueWrapper : lstValueWrapper)
        {
            IPM_Financial_Year__c fyRecord = mapFinancialYears.get(generateMapKey(yearType, IPM_ConstantUtils.BLANK + valueWrapper.index, plType));
            String recordId = fyRecord.Id;
            if (mapFinancialYearRecords.containsKey(recordId)) {
                fyRecord = mapFinancialYearRecords.get(recordId);
            }
            else {
                mapFinancialYearRecords.put(recordId, fyRecord);
            }
            
            fyRecord.put(fieldName, valueWrapper.value);
        }
    }       
    
    /*******************************************************************************************************
    * @description  Used to refresh the financial numbers from Local numbers
    * @param        NONE
    * @return       NONE
    */
    public void refreshFromLocal() {
        try
        {   
            if(currentFinancial.Copy_Local_to_Regional__c)
            {
               currentFinancial.Copy_Local_to_Regional__c = false;
               update currentFinancial;
            }
            
            currentFinancial.Copy_Local_to_Regional__c = true;
            update currentFinancial;
            getFinancials();
            validateCalendarFinancialRecords(financialsCalendar, IPM_ConstantUtils.YEAR_TYPE_CALENDAR);
            validateInnovationFinancialRecords(financialsInnovation, IPM_ConstantUtils.YEAR_TYPE_INNOVATION);
        } 
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    IPM_ConstantUtils.EXCEPTION_REFRESHFROMLOCAL,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
          }
    }

    /*******************************************************************************************************
    * @description  Used to refresh the financial numbers from Regional numbers
    * @param        NONE
    * @return       NONE
    */
    public void refreshFromRegional() 
    {
        try
        {
            if(currentFinancial.Copy_Regional_to_Local__c)
            {
                currentFinancial.Copy_Regional_to_Local__c = false;
                update currentFinancial;  
            }
            
            currentFinancial.Copy_Regional_to_Local__c = true;
            update currentFinancial;
            getFinancials();
            validateCalendarFinancialRecords(financialsCalendar, IPM_ConstantUtils.YEAR_TYPE_CALENDAR);
            validateInnovationFinancialRecords(financialsInnovation, IPM_ConstantUtils.YEAR_TYPE_INNOVATION);
        } 
        catch (Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    IPM_ConstantUtils.EXCEPTION_REFRESHFROMREGIONAL,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }
    
    /*******************************************************************************************************
    * @description  Used to generate the suffix to be used in referencing appropriate fields on the 
    *               Financial and Financial Year object
    * @param        NONE
    * @return       NONE
    */
    private String getFieldSuffix()
    {
                if (currentTab == IPM_ConstantUtils.TAB_MYVIEW_NAME)
                {
            return project.IPMProject_Span__c;
                } 
                else if (currentTab == IPM_ConstantUtils.TAB_ROLLUP_NAME)
                {
            if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
            {
                    return IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            }
            else if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
            {
                
                return IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
                    }   
                }
                else if (currentTab == IPM_ConstantUtils.TAB_TOPDOWN_NAME)
                {
            if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                {
                return IPM_ConstantUtils.FIELD_SUFFIX_CHARTER;
            }
            else if (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
            {
                    return IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
           
            }
        }
        return null;
    }
    
    /*******************************************************************************************************
    * @description      Used to generate a unique key for the map of Financial Years for the 
    *                   current Financial
    * @param yearType   Year Type for the IPM_Financial_Year__c record
    * @param index      Year index for the IPM_Financial_Year__c record
    * @param plType     P&L Type for the IPM_Financial_Year__c record
    * @return           NONE
    */
    private String generateMapKey(String yearType, String index, String plType){
        return yearType + '__' + index + '__' + plType;
    }
    
    /*******************************************************************************************************
    * @description      Used to associate Financials with Countries 
    * @param countries   countries to be associated to the corresponding financial records
    * @return           NONE
    
    public void processFinancialCountries(List<IPM_Country__c> lstCountries){
     commented as part of SOnar fix
    }*/
    
    /*******************************************************************************************************
    * @description  Used to wrap region and financials together. Used wrapper instead of standard object 
    *               (Rollout) because for regional & local projects the concerned object is IPM_Project__c 
    *               and not IPM_Project_Rollout__c
    */
    public class RolloutWrapper{
        public String regionName {get; set;}
        public List<IPM_Financial__c> lstFinancials {get; set;}
        
        public RolloutWrapper(String regionName, List<IPM_Financial__c> lstFinancials){
            this.regionName = regionName;
            this.lstFinancials = lstFinancials;
            
        }
    }
    
    public boolean validateCalendarTurnOver(List<IPM_FinancialValueWrapper> lstGrossPLTurnover,List<IPM_FinancialValueWrapper> lstIncrementalPLTurnover){
                //Validate Turnover values.
        Boolean isValidWrapperFailed=false;
        isITOgrtGTOCal = false;
        isFinancialInvalid = false;
        isValidationErrorCal = false;
        validationErrorMessageCal = '';
        for(IPM_FinancialValueWrapper valueWrapperGross: lstGrossPLTurnover){
            for(IPM_FinancialValueWrapper valueWrapperIncremental: lstIncrementalPLTurnover){
               valueWrapperGross.isValueInvalid = false;
               valueWrapperIncremental.isValueInvalid = false;
               valueWrapperGross.isMinorValueInvalid = false;
               valueWrapperIncremental.isMinorValueInvalid = false;
               valueWrapperGross.isGrossTOValueInvalid = false;
               if(valueWrapperGross.index == valueWrapperIncremental.index){
			valueWrapperGross.isGrossTOGRTIto = false;
                             if(valueWrapperGross.Value < valueWrapperIncremental.Value){ 
                               isITOgrtGTOCal = true; 
                               valueWrapperGross.isGrossTOGRTIto = true;
                               isFinancialInvalid = true;
                               isValidationErrorCal = true;
	                			validationErrorMessageCal = IPM_ConstantUtils.INVALID_DATA_TO_SAVE;
                             } 
     
               }
                 if( valueWrapperGross.Value <= IPM_ConstantUtils.INVALID_VALUE){
				                	valueWrapperGross.isValueInvalid = true;
				                	valueWrapperGross.isGrossTOValueInvalid = true;
				                	isFinancialInvalid = true;
                                    isValidationErrorCal = true;
	                				validationErrorMessageCal = IPM_ConstantUtils.INVALID_DATA_TO_SAVE;
               	}
                if(valueWrapperIncremental.value <= IPM_ConstantUtils.INVALID_VALUE){
                	valueWrapperIncremental.isValueInvalid = true;
                	valueWrapperIncremental.isMinorValueInvalid = true;
                }
                 if(isValidWrapperFailed){
                  valueWrapperGross.isValueInvalid = true;
                    valueWrapperIncremental.isValueInvalid = true;
                    isValidationFailed = true;
            
                                         
                }   
                 
             }            
        }
        return isValidationFailed;
    }
    
      public boolean validateInnovationTurnOver(List<IPM_FinancialValueWrapper> lstGrossPLTurnover,List<IPM_FinancialValueWrapper> lstIncrementalPLTurnover){
                //Validate Turnover values.
       Boolean isValidWrapperFailed=false;
        isITOgrtGTO = false;
        isFinancialInvalidInnovation = false;
        isValidationError = false;
        validationErrorMessage = '';
        for(IPM_FinancialValueWrapper valueWrapperGross: lstGrossPLTurnover){
            for(IPM_FinancialValueWrapper valueWrapperIncremental: lstIncrementalPLTurnover){
               valueWrapperGross.isValueInvalid = false;
               valueWrapperIncremental.isValueInvalid = false;
               valueWrapperGross.isMinorValueInvalid = false;
               valueWrapperIncremental.isMinorValueInvalid = false;
               valueWrapperGross.isGrossTOValueInvalid = false;
               
              if(valueWrapperGross.index == valueWrapperIncremental.index){
			valueWrapperGross.isGrossTOGRTIto = false;
               	     if(valueWrapperGross.Value <  valueWrapperIncremental.Value){
                       isITOgrtGTO = true; 
                       valueWrapperGross.isGrossTOGRTIto = true;
                       isFinancialInvalidInnovation = true;
                       isValidationError = true;
	                	validationErrorMessage = IPM_ConstantUtils.INVALID_DATA_TO_SAVE;
                     }
                }
               if(valueWrapperIncremental.value <= IPM_ConstantUtils.INVALID_VALUE){
                	valueWrapperIncremental.isValueInvalid = true;
                	valueWrapperIncremental.isMinorValueInvalid = true;
                }
                if(valueWrapperGross.Value <= IPM_ConstantUtils.INVALID_VALUE){
	                	valueWrapperGross.isValueInvalid = true;
	                	valueWrapperGross.isGrossTOValueInvalid = true;
                        isFinancialInvalidInnovation = true;
                        isValidationError = true;
	                	validationErrorMessage = IPM_ConstantUtils.INVALID_DATA_TO_SAVE;
                }
               
                 if(isValidWrapperFailed){
                  valueWrapperGross.isValueInvalid = true;
                    valueWrapperIncremental.isValueInvalid = true;
                    isValidationFailed = true;
            
                                         
                }   
                
                 
                   
             }            
        }
        return isValidationFailed;
    }

        //-------------- CURRENCY RELATED CHANGES ENDS HERE ------------------
    public pageReference loadCurrencyPage(){
        try{
            PageReference templatePage = Page.IPM_Financial_Currency;
            templatePage.getParameters().put(IPM_ConstantUtils.SF_ID, project.Id);
            templatePage.setRedirect(true);
            return templatePage;
         } catch (Exception eX){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    null,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            return null;
        }
       
    }
    
   
    
    String[] currencies = new String[]{};
    public decimal decMultFactor = 1;
    public decimal exRate{get;set;}
    map<string,decimal> mapCurrency;    
    
    public List<SelectOption> getItems() {
            list<IPM_Exchange_Rate__c> lstCurrency = [SELECT Currency_Code__c,Exchange_Rate__c FROM IPM_Exchange_Rate__c order by Currency_Code__c limit 10000];
            List<SelectOption> options = new List<SelectOption>();
                mapCurrency = new map<string,decimal>();
            //populate picklist with currency codes
            for(IPM_Exchange_Rate__c curr: lstCurrency){
                options.add(new SelectOption(curr.Currency_Code__c,curr.Currency_Code__c));
                mapCurrency.put(curr.Currency_Code__c, curr.Exchange_Rate__c);
            }
            return options;
        }

        public String selectedCurrency
        {
            get
            {
               if(selectedCurrency==null){
               selectedCurrency='EUR';
               }
               return selectedCurrency;
            }
        set;
        }
                
        public pageReference applyRate(){
            if (selectedCurrency!=null){
                if (mapCurrency.containsKey(selectedCurrency)){
                    exrate = mapCurrency.get(selectedCurrency);
                    decMultFactor = exrate; 
                }else{
                    decMultFactor = 1; //
                    exrate = 1;
                }
                                /*Instead of calling everytime on list change, making it conditional in below method*/
                getFinancials();
                ///getFinancialsPartial();
            }
            return null;
        }
    
    
    //-------------- CURRENCY RELATED CHANGES ENDS HERE ------------------
    /*******************************************************************************************************
    * @description  Used to align TLD of MCO/Country with Local Rollout Project
    * @param        NONE
    * @return       NONE
    */
    public void alignTLD() {
        try{
            if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL) {
                localRolloutProject.IPM_Target_Launch_Dates__c = mcoCountryRolloutPlan.Target_Launch_Date__c;
                localRolloutProject.Rollout_Plan_Target_Launch_Date__c = mcoCountryRolloutPlan.Target_Launch_Date__c;
                update localRolloutProject;
				getFinancials();                 
            } else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                mcoCountryRolloutPlan.Target_Launch_Date__c = localRolloutProject.IPM_Target_Launch_Dates__c;            
                mcoCountryRolloutPlan.Local_Project_Target_Launch_Date__c = localRolloutProject.IPM_Target_Launch_Dates__c;            
                update mcoCountryRolloutPlan;
				getFinancials();                 
            }
            
           
        } catch (Exception eX){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                   'alignTLD',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }   

    /*******************************************************************************************************
    * @description  Used to update MisAligned_Confirmed_By_Finance_Leader__c flag
    * @param        NONE
    * @return       NONE
    */
    public void updateMisalignmentByFinanceLeader() {
        try{
            if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) {
            	project.MisAligned_Confirmed_By_Finance_Leader__c = true;
            	update project;
            	setMisalignedValue();
            } else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL) {
                localRolloutProject.MisAligned_Confirmed_By_Finance_Leader__c = true;
                showMisalignedConfirmbtn = true;  
                update localRolloutProject;
                setMisalignedValue();
            } else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL || project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL){
                mcoCountryRolloutPlan.MisAligned_Confirmed_By_Finance_Leader__c =true;  
                showMisalignedConfirmbtn = true;          
                update mcoCountryRolloutPlan;
                setMisalignedValue();
            }
        } catch (Exception eX){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                   IPM_ConstantUtils.EXCEPTION_EDITFINANCIALS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            isError = true;
            errorMessage = String.valueOf(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }   
    /****************************************************************************************************************************************
    * @description          Used to set misaligned date values for TLD, when the Financial data is loaded it checks for the current TLD and Previous
	    				    TLD to generate page message to let user know the need for Business Case update, or if the TLD dates are not aligned 
	    				    between regional and local rollouts.
    * @NPath Complexity:    due to complex functionality explained in the description we cannot avoid 
    					    NPathComplexity on this method.    
    * @param        NONE
    * @return       NONE
    *******************************************************************************************************************************************/
    private void setMisalignedValue(){
            isTLDYearMisaligned = false;
            Integer localProjectTLDYear = 0;
            Integer localProjectRolloutTLDYear = 0;
            List<IPM_Project__c> projList = new List<IPM_Project__c>();
            List<IPM_Project_Rollout__c> projRolloutList = new List<IPM_Project_Rollout__c>();
            localProjectTLD = '';
            localProjectRolloutTLD = '';
            Boolean flag = false;
            String localProjectName = '';
            localRolloutProject = null;
            showMisalignedConfirmbtn = true;
            mcoCountryRolloutPlan = null;
            //get the Rollout related to the project currently to get the TLD and year details
            if(project != null && currentFinancial != null && project.IPM_Project_Type__c!=IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) {
                if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL) {
	            //Assign Local Project Target Launch Date
                    localProjectTLD = project.IPM_Target_Launch_Dates__c.format();
		    //Assign Local Project Target Launch Year
                    localProjectTLDYear = project.IPM_Target_Launch_Dates__c.year();
		    //Assign Local Project Name
                    localProjectName = project.Name;
		    //Fetch Project Rollout list
                    projRolloutList = [Select Target_Launch_Date__c, Previous_Target_Launch_Date__c ,MisAligned_Confirmed_By_Finance_Leader__c from IPM_Project_Rollout__c where id=:project.IPM_Project_Rollout__c];
		    //Check if project list has rollout or not 
                if(!projRolloutList.isEmpty()) {
			//Assign Rollout Target Launch Date
                        localProjectRolloutTLD = projRolloutList[0].Target_Launch_Date__c.format();
			//Assign Rollout Target Launch Year
                        localProjectRolloutTLDYear = projRolloutList[0].Target_Launch_Date__c.year();
			//Assign rollout
                        mcoCountryRolloutPlan = projRolloutList[0];
                    }
                    localRolloutProject = project;
                } else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL) {// if project is regional get the project detials based currentFinanical
                    String financialExternalIdString;
                //Check if Financial external id ends with '_NONKEY'
                    if(currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY)){
                        financialExternalIdString = currentFinancial.Financial_External_ID__c.substringBeforeLast('_');
                    } else {
                        financialExternalIdString = currentFinancial.Financial_External_ID__c;
                    }
                    projList = [Select (Select Name, IPM_Target_Launch_Dates__c,MisAligned_Confirmed_By_Finance_Leader__c From IPM_Projects__r where name like :financialExternalIdString+'%'), (Select Name,Previous_Target_Launch_Date__c , Target_Launch_Date__c,MisAligned_Confirmed_By_Finance_Leader__c,KeyMCO__c, isActive__c,IPM_Rollout_Span__c From Regional_Project_Rollout__r where name like :financialExternalIdString+'%') From IPM_Project__c   where id=:project.id];
                    if(!projList.isEmpty() && !projList[0].Regional_Project_Rollout__r.isEmpty()) {
                            Date tempTLD = null;
                            for(IPM_Project_Rollout__c rollout:projList[0].Regional_Project_Rollout__r) {
                                String rolloutNonKeyName = rollout.Name.substringBeforeLast('_');
                            //Check if Financial external id ends with '_NONKEY' and Financial external id starts with rollout name and rollout is not key MCO and rollout is active and rollout span is local
                                if(currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY) && currentFinancial.Financial_External_ID__c.startsWith(rolloutNonKeyName) && !rollout.KeyMCO__c && rollout.isActive__c && rollout.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL) {
                                //Assign the earliest TLD from non key MCOs
                                if(tempTLD == null){
                                        mcoCountryRolloutPlan = rollout;
                                        tempTLD = rollout.Target_Launch_Date__c;
                                    } else if (tempTLD>rollout.Target_Launch_Date__c){
                                        mcoCountryRolloutPlan = rollout;
                                        tempTLD = rollout.Target_Launch_Date__c;
                                    }
                                } else if(rollout.name==currentFinancial.Financial_External_ID__c) {
                                    mcoCountryRolloutPlan = rollout;
                                    break;
                                }
                            }                       
                    //Assign local project rollout TLD  
                        localProjectRolloutTLD = mcoCountryRolloutPlan.Target_Launch_Date__c.format();
                    //Assign local project rollout TLD year
                        localProjectRolloutTLDYear = mcoCountryRolloutPlan.Target_Launch_Date__c.year();                                               
                    }
                    if(!projList.isEmpty() && !projList[0].IPM_Projects__r.isEmpty()) {
                        localProjectTLD = projList[0].IPM_Projects__r[0].IPM_Target_Launch_Dates__c.format();
                        localProjectTLDYear = projList[0].IPM_Projects__r[0].IPM_Target_Launch_Dates__c.year();
                        localProjectName = projList[0].IPM_Projects__r[0].Name;
                        localRolloutProject = projList[0].IPM_Projects__r[0]; 
                    }
                }
            }
            // check for the misalignment 
            if(localProjectTLD!= '' && localProjectTLD!=localProjectRolloutTLD) {
                flag = true;
                isMisalignedTLD  = true;
                validationErrorMessage = String.format(Label.IPM_TLD_VR_Misaligned,new List<String>{localProjectName,localProjectRolloutTLD,localProjectTLD});
                if((localProjectRolloutTLDYear-localProjectTLDYear) != 0 ) {
                	isTLDYearMisaligned = true;
                	validationErrorMessage += IPM_ConstantUtils.IPM_SPACE + Label.IPM_TLD_Year_Misaligned;
                }
               // misalignment message 
            } else if(validationErrorMessage.contains(Label.IPM_TLD_VR_Misaligned_Part_Msg)) {
                isMisalignedTLD  = false;
                validationErrorMessage = '';
            }          
            isTargetLaunchDateMisaligned =  flag; 
            //check for the operational type project to check for the misalignment.                              
            if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL && project.Previous_Target_Launch_Date__c!=null && project.Previous_Target_Launch_Date__c!=project.IPM_Target_Launch_Dates__c) {
            	showMisalignedConfirmbtn = project.MisAligned_Confirmed_By_Finance_Leader__c;
            	currentTargetLaunchDate = project.IPM_Target_Launch_Dates__c.format();
            	if(project.Previous_Target_Launch_Date__c!=null)
            	{
            	  previousTargetLaunchDate = project.Previous_Target_Launch_Date__c.format();
            	}
            } else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS) {
                if(currentFinancial != null){
                        IPM_Project__c proj = [Select (Select Name, Target_Launch_Date__c,Previous_Target_Launch_Date__c,MisAligned_Confirmed_By_Finance_Leader__c,KeyMCO__c,isActive__c,IPM_Rollout_Span__c From IPM_Project_Rollout__r) From IPM_Project__c where id=:project.id];                    
                        if(!proj.IPM_Project_Rollout__r.isEmpty()) 
                        {
                            Date earliestTLD = null;
                            for(IPM_Project_Rollout__c rollout:proj.IPM_Project_Rollout__r) {
                                String rolloutNonKeyName = rollout.Name.substringBeforeLast('_');
				//Check if Financial external id ends with '_NONKEY' and Financial external id starts with rollout name and rollout is not key MCO and rollout is active and rollout span is local
                                if(currentFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY) && currentFinancial.Financial_External_ID__c.startsWith(rolloutNonKeyName) && !rollout.KeyMCO__c && rollout.isActive__c && rollout.IPM_Rollout_Span__c == IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL) {
                                //Assign the earliest TLD from non key MCOs
                                    if(earliestTLD == null){
                                        mcoCountryRolloutPlan = rollout;
                                        earliestTLD = rollout.Target_Launch_Date__c;
                                    } else if (earliestTLD>rollout.Target_Launch_Date__c){
                                        mcoCountryRolloutPlan = rollout;
                                        earliestTLD = rollout.Target_Launch_Date__c;
                                    }
                                } else if(rollout.name==currentFinancial.Financial_External_ID__c) {
                                    mcoCountryRolloutPlan = rollout;
                                    break;
                                }
                            }
			}
			// check for the misalignment                                          
                        if(mcoCountryRolloutPlan != null && mcoCountryRolloutPlan.Previous_Target_Launch_Date__c!=null && mcoCountryRolloutPlan.Target_Launch_Date__c !=null){
                                showMisalignedConfirmbtn = mcoCountryRolloutPlan.MisAligned_Confirmed_By_Finance_Leader__c;
                                currentTargetLaunchDate = mcoCountryRolloutPlan.Target_Launch_Date__c.format();  
                                previousTargetLaunchDate = mcoCountryRolloutPlan.Previous_Target_Launch_Date__c.format();                               
                                if(mcoCountryRolloutPlan.Target_Launch_Date__c == null || mcoCountryRolloutPlan.Target_Launch_Date__c.format() == '' || mcoCountryRolloutPlan.Previous_Target_Launch_Date__c == null || mcoCountryRolloutPlan.Previous_Target_Launch_Date__c.format() == ''){
                                    showMisalignedConfirmbtn = true;
                                } else if (mcoCountryRolloutPlan.Target_Launch_Date__c.format() == mcoCountryRolloutPlan.Previous_Target_Launch_Date__c.format() ){
                                    showMisalignedConfirmbtn = true;
                                }
                        }                        
                }
            }else if(project!=null && project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){// misalignment for the regional projects 
                if(mcoCountryRolloutPlan != null && mcoCountryRolloutPlan.Previous_Target_Launch_Date__c!=null && mcoCountryRolloutPlan.Target_Launch_Date__c !=null){
                    showMisalignedConfirmbtn = mcoCountryRolloutPlan.MisAligned_Confirmed_By_Finance_Leader__c;
                    previousTargetLaunchDate = mcoCountryRolloutPlan.Previous_Target_Launch_Date__c.format();
                    currentTargetLaunchDate = mcoCountryRolloutPlan.Target_Launch_Date__c.format();                 
		    // check for the misalignment
                    if(mcoCountryRolloutPlan.Target_Launch_Date__c == null || mcoCountryRolloutPlan.Target_Launch_Date__c.format() == '' || mcoCountryRolloutPlan.Previous_Target_Launch_Date__c == null || mcoCountryRolloutPlan.Previous_Target_Launch_Date__c.format() == ''){
                        showMisalignedConfirmbtn = true;
                    } else if (mcoCountryRolloutPlan.Target_Launch_Date__c.format() == mcoCountryRolloutPlan.Previous_Target_Launch_Date__c.format() ){
                        showMisalignedConfirmbtn = true;
                    }  
                 }    
            } else if(project!=null && project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL) {// misalignment for the local projects 
                    if(localRolloutProject != null && localRolloutProject.Previous_Target_Launch_Date__c !=null && localRolloutProject.IPM_Target_Launch_Dates__c !=null){
                        showMisalignedConfirmbtn = localRolloutProject.MisAligned_Confirmed_By_Finance_Leader__c;
                        previousTargetLaunchDate = localRolloutProject.Previous_Target_Launch_Date__c.format();
                        currentTargetLaunchDate = localRolloutProject.IPM_Target_Launch_Dates__c.format();
			// check for the misalignment
                        if(project.IPM_Target_Launch_Dates__c == null || project.IPM_Target_Launch_Dates__c.format() == '' || project.Previous_Target_Launch_Date__c == null || project.Previous_Target_Launch_Date__c.format() == '' ){
                            showMisalignedConfirmbtn = true;
                        } else if (project.IPM_Target_Launch_Dates__c.format() == project.Previous_Target_Launch_Date__c.format()){
                            showMisalignedConfirmbtn = true;
                        } 
                    } 
                 
            } 
        } 
        
        
    public void updateVolumeType()
    {
        populateVolumeType(financialsInnovation);
        populateVolumeType(financialsCalendar);     
    }   
    
    
    public void populateVolumeType(IPM_FinancialWrapper finWrapper)
    {
        String volumeUnit = (String) currentFinancial.get(IPM_ConstantUtils.FIELD_LITERAL_VOLUME_UNIT + fieldSuffix + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);
        if(volumeUnit!=null && volumeUnit.equalsIgnoreCase(IPM_ConstantUtils.TotalTons))    
        {
            finWrapper.y0VolumeTons = finWrapper.y0Volume;
            finWrapper.y0Volume = 0;
            
            for(Integer i=0;i<finWrapper.lstGrossPLVolume.size();i++)
            {
                IPM_FinancialValueWrapper finVolWrapper = finWrapper.lstGrossPLVolume.get(i);
                IPM_FinancialValueWrapper finVolTonsWrapper = finWrapper.lstGrossPLVolumeTons.get(i);
                
                finVolTonsWrapper.value = finVolWrapper.value;
                finVolWrapper.value = 0;
            }
            for(Integer i=0;i<finWrapper.lstIncrementalPLVolume.size();i++)
            {
                IPM_FinancialValueWrapper finVolWrapper = finWrapper.lstIncrementalPLVolume.get(i);
                IPM_FinancialValueWrapper finVolTonsWrapper = finWrapper.lstIncrementalPLVolumeTons.get(i);
                
                finVolTonsWrapper.value = finVolWrapper.value;
                finVolWrapper.value = 0;        
            }
        }
        else
        {
            finWrapper.y0Volume = finWrapper.y0VolumeTons;
            finWrapper.y0VolumeTons = 0;
            
            for(Integer i=0;i<finWrapper.lstGrossPLVolumeTons.size();i++) 
            {
                IPM_FinancialValueWrapper finVolTonsWrapper = finWrapper.lstGrossPLVolumeTons.get(i);
                IPM_FinancialValueWrapper finVolWrapper = finWrapper.lstGrossPLVolume.get(i);
                
                finVolWrapper.value = finVolTonsWrapper.value;
                finVolTonsWrapper.value = 0;    
            }
            for(Integer i=0;i<finWrapper.lstIncrementalPLVolumeTons.size();i++)
            {
                IPM_FinancialValueWrapper finVolTonsWrapper = finWrapper.lstIncrementalPLVolumeTons.get(i);
                IPM_FinancialValueWrapper finVolWrapper = finWrapper.lstIncrementalPLVolume.get(i);
                
                finVolWrapper.value = finVolTonsWrapper.value;
                finVolTonsWrapper.value = 0;
            }
        }
    }
	/****************************************************************************************************************
    *@Description:checks for local project financial
    *
    *****************************************************************************************************************/
    @testvisible Private void localProjectConditions(){
        financialAcceptFrom=label.IPM_ACCEPT_REGIONAL_BC;
        boolean isLocalProjectAccept=false;
        toShowEditButton=false;
        toShowEditOpern=false;
        isCopyfromSTDBC=false;
        isTDLAcceptNBC_Confirm=false;
        tldAcceptedBCConfirmed=Label.Accept_from_Regional+IPM_ConstantUtils.IPM_SPACE +label.IPM_and_Confirm;
        if(IPM_ConstantUtils.PROJECT_SPAN_LOCAL.equals(project.IPMProject_Span__c) && IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equals(project.IPM_Project_Type__c) &&
        ((IPM_ConstantUtils.PHASE_FEASIBILITY.equals(project.IPM_Phase__c) && currentFinancial.IPM_Business_Case_Confirmed__c) ||
        (IPM_ConstantUtils.PHASE_CAPABILITY.equals(project.IPM_Phase__c) && currentFinancial.Is_BC_Confirmed_Capability__c)))
        {
          if(currentFinancial.Misaligned__c)
          { 
              financialAcceptFrom=label.IPM_ACCEPT_REGIONAL_BC+ IPM_ConstantUtils.IPM_SPACE + label.IPM_and_Confirm;
          }
          if(isTargetLaunchDateMisaligned)
          {
            isTDLAcceptNBC_Confirm=true;
           
          }
          isLocalProjectAccept=true;
        }
        updateEditableFlags(isLocalProjectAccept);
    }
    
    private void updateEditableFlags(Boolean isLocalProjectAccept)
    {
        if(isEditable && !IPM_ConstantUtils.PHASE_PLE.equals(project.IPM_Phase__c) && !IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL.equals(project.IPM_Project_Type__c)&& !isLocalProjectAccept)
        {
            toShowEditButton=true;      
        }
        
        if(isEditable && !IPM_ConstantUtils.PHASE_PLE.equals(project.IPM_Phase__c) && IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL.equals(project.IPM_Project_Type__c))
        {
            toShowEditOpern=true;       
        }
        
        if((toShowEditOpern||toShowEditButton) && !isEditMode)
        {
            isCopyfromSTDBC=true;   
        }
    } 
}