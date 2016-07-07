/****************************************************************************************************************************
@Author: Cognizant
@name: IPM_List_Milestones
@CreateDate: Oct'2014
@Description: Controller to display the milestones
@Version: 
@reference:  it has been refered in IPM_List_Component apex component
*/ 
public with sharing class IPM_List_Milestones extends AbstractStandardSetExtension
{
    
    public String isChecked{get;set;}//Page property which sends back marked milestones for completion
    public String projectId{get;set;}//project Id from the query string
    public List<string> warningMessages{get;set;}//List of all the warning messages related to BET and market ready date
    public String isCompleteMilestones{get;set;}//to identify if the milestone is complete or not
    public String paginationUIDisplay ;
    public String postLaunchEvaluationPhase {get;set;}
    
    private String projectPhase;//internal variable to identify the phase of the project tht is in
    @TestVisible private String milestoneId = '';//capturing current milestone id for process
    private String phaseM = '';//milestone's phase property, getter & setter follows
    
    public Integer milestoneCnt{get;set;}//number of Milestones shown on the page
    
    public Boolean isAsc{get;set;}//toggling property which sorts the columns
    public Boolean isEditable{get;set;}//used by security
    public Boolean isMileEditable{get;set;}
    public Boolean isBDuser{get;set;}//used by security
    public Boolean isSDateEdit{get;set;}//used by security
    public Boolean isWarningRequired {get;set;}//used to display warning message when difference between MRD and TLD is less than 6 months
    public Boolean showTLDInfoIcon{get;set;}
    public String displayPage{get;set;}
    public String strLink{get;set;}
    
    public static String DEFAULT_TLD_HELPTEXT = 'IPM_Before_Rollout_TLDMilestone_HelpText';
    public static String DEFAULT_TLD_LINK = 'Go To Project Parameters';
    public static String DEFAULT_PAGE = 'IPM_CoreParameters';
    
    public Map<String, String> currentSort{get;set;}//sorting variable where the current sort fits in
    //phases by order they appear
    private Map<String, Integer> phaseOrderMap = new Map<String, Integer>{IPM_ConstantUtils.PHASE_IDEAS => 1, 
                                                                           IPM_ConstantUtils.PHASE_FEASIBILITY => 2, 
                                                                           IPM_ConstantUtils.PHASE_CAPABILITY => 3,
                                                                           IPM_ConstantUtils.PHASE_MARKET_READY => 4,
                                                                           IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT => 5,
                                                                           IPM_ConstantUtils.PHASE_POSTLAUNCHEVAL => 6};
    
    public IPM_Project__c projectObj{get;set;}
    //variable which stores all the phases.
    private List<String> phaseOrder = new List<String>{IPM_ConstantUtils.PHASE_IDEAS, 
                                                       IPM_ConstantUtils.PHASE_FEASIBILITY, 
                                                       IPM_ConstantUtils.PHASE_CAPABILITY,
                                                       IPM_ConstantUtils.PHASE_MARKET_READY,
                                                       IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT,
                                                       IPM_ConstantUtils.PHASE_POSTLAUNCHEVAL};
    public transient List<TimelineWrap> timelineMilestones{get;set;}//timeline wrapped list of the milestone shown separately on the same page
    
    public String[] phaseMsList{get;set;}//all the phases for the milestone used for sorting
    
    //setter for the milestone id
    public void setMilestoneId(String n) {
        milestoneId = n;
    }
    
    //getter for the milestone id
    public String getMilestoneId() {
        return milestoneId;
    }
    
    
    public void setphaseM(String n) {
        phaseM = String.escapeSingleQuotes(n);
    }
    
    public String getphaseM() {
        phaseM=String.escapeSingleQuotes(phaseM);
        return phaseM;
    }
    
    /***************************************************************
    *@Description  :  Constructor to fetch the details of the Project
     @param : None
    ****************************************************************/
    public IPM_List_Milestones() {
        isWarningRequired = false;
        isMileEditable = true;      
        postLaunchEvaluationPhase = IPM_ConstantUtils.PHASE_POSTLAUNCHEVAL;
        phaseMsList = new List<String>();
        isAsc = false;
        warningMessages = new List<String>();
        //this field will actually define what is the current sorting column applies to, default is Project name
        currentSort = new Map<String, String>{IPM_ConstantUtils.THIS_FIELD => 'IPM_Phase_Order__c'};
        projectId = ApexPages.currentPage().getParameters().get('id');
        if(projectId =='' || projectId ==null){
            projectId = ApexPages.currentPage().getParameters().get('Pid');
        }
        projectObj = [SELECT IPM_Phase__c,IPM_Fast_Track_Project__c, IPM_CompanyCardText__c, IPM_Project_Leader__c, Is_Archieved__c, IPM_PrepareForArchival__c, IPM_Target_Launch_Dates__c,IPM_Market_Type__c, IPM_Project_Type__c, IPMProject_Span__c, IPM_GateKeeping_Model__c,
                    BET_First_Release_Missed__c,BET_Final_Release_Missed__c,BET_MS_First_Release_Date__c,BET_MS_Final_Release_Date__c,BET_TLD_First_Release_Date__c,BET_TLD_Final_Release_Date__c, BET__c, (SELECT Id, Name from IPM_Project_Rollout__r)  FROM IPM_Project__c WHERE Id =:projectId];
        projectPhase =  projectObj != null && projectObj.IPM_Phase__c != null ? projectObj.IPM_Phase__c : '';
        initializeMilestones();
        phaseMsList.sort();//customised sort
        //Code to add BET related messages
        if(projectObj.BET__c!=null && ((projectObj.BET_TLD_First_Release_Date__c < projectObj.BET_MS_First_Release_Date__c) || (projectObj.BET_TLD_Final_Release_Date__c < projectObj.BET_MS_Final_Release_Date__c))){
            isWarningRequired = true;   
            warningMessages.add(system.label.IPM_BETMilestoneDateMismatch);
        }
        if(projectObj.BET_First_Release_Missed__c){
            isWarningRequired = true;   
            warningMessages.add(system.label.IPM_BETFirstReleaseMissed);
        }
        if(projectObj.BET_Final_Release_Missed__c){
            isWarningRequired = true;   
            warningMessages.add(system.label.IPM_BETFinalReleaseMissed);
        }
        if(projectObj.IPM_PrepareForArchival__c || projectObj.Is_Archieved__c){
        	isMileEditable = false;
        } 
        
     }
    
    /**************************************************************
    * @description: toggling sort with due date and adding back to the currentSort map & ordering the result
    */
    public void toggleDueDate() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Due_Date__c');
        setPageNumber();
        setCon = null;
    }
    
    /**************************************************************
    * @description: overide the postProcessig Method of AbstractStandardSetExtension Controller and contains the functionality to make milestone editable/readonly 
      @param : SObject List : Milestone list to be processed which will be displayed on the Milestone page 
    */
    public override void postProcessing(List<sObject> recordList)
    {
        Boolean isEditable;
        Boolean isDeletable;
        
        Set<String> nonDelMS = new Set<String>{IPM_ConstantUtils.STANDARD, IPM_ConstantUtils.BET}; // SET of Milestone type that will be non deletable
        
        for(IPM_Milestone__c eachMilestone : (List<IPM_Milestone__c>)recordList ){
            isDeletable = true;
            isEditable = true;
            showTLDInfoIcon = false;
            
            // Non Deletable Milestones 
            if(nonDelMS.contains(eachMilestone.IPM_Type_of_Milestone__c)){
                isDeletable = false;
            }
            
            // BET Milestone will be read only 
            if(eachMilestone.IPM_Type_of_Milestone__c == IPM_ConstantUtils.BET){
                isEditable = false;
            }
            // Target Launch Date will be read only
            if(eachMilestone.IPM_Name__c.equalsignorecase(IPM_Utils.TargetLaunchDateShiptoTrade) || IPM_ConstantUtils.SHIPTO_TRADE_TLD.equalsignorecase(eachMilestone.IPM_Name__c)){
                isEditable = false;
                if(projectObj.IPM_Project_Leader__c == UserInfo.getUserId()){
                	showTLDInfoIcon = true;
                	getTLDHelpText();
                }
                else{
                	showTLDInfoIcon = false;
                }
            }
            
            // Logic to check if current phase of milestone is previous or not
            IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(projectObj);
            List<IPM_Project_Type__c> previousPhasesList = IPM_Utils.getPreviousPhases(associatedProjectType,false);
            Set<String> previousPhases = new Set<String>();
            
            for(IPM_Project_Type__c projectType : previousPhasesList){
                previousPhases.add(projectType.IPM_Phase__c);
            }               
            
             /**************Logic to make milestone readonly based on below requirements
                1. Standard Milestone of previous phase should be read only
                2. Independent projects will be editable and Rest of the projects will be read only :: It is identified with the help of IPM Project Type custom setting 
             */ 
            if(eachMilestone.IPM_Type_of_Milestone__c == IPM_ConstantUtils.STANDARD){
                if(!previousPhases.isEmpty() && previousPhases.contains(eachMilestone.IPM_Phase__c)){ // check if milestone phase is previous phase 
                    isEditable = false;
                }else if(associatedProjectType != null && !associatedProjectType.Independent_Project__c){ // check if it is independent project
                    isEditable = false;
                }
            } 
            
            if(eachMilestone.IPM_Completed__c) {
                wrapperRecordList.add(new sObjectPaginationWrapper(eachMilestone, true, isEditable, isDeletable, showTLDInfoIcon));
            }else{
                wrapperRecordList.add(new sObjectPaginationWrapper(eachMilestone, false, isEditable, isDeletable, showTLDInfoIcon));
            }
        }
    }
    
    public String getTLDHelpText()
    {
    	String tldHelpTextLabel = '';
    	IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(projectObj);
    	
    	List<IPM_Project_Rollout__c> associatedRolloutList = projectObj.IPM_Project_Rollout__r;    	
		
		if(associatedRolloutList.isEmpty() && associatedProjectType.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS && associatedProjectType.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
		{
			tldHelpTextLabel = DEFAULT_TLD_HELPTEXT; //Resultant Label: IPM_Before_Rollout_TLDMilestone_HelpText
    			
			//This link will be displayed along with help text and it will take us to the IPM_CoreParameters page
			strLink = DEFAULT_TLD_LINK;
			displayPage = DEFAULT_PAGE;
		}
		else if(String.isNotBlank(associatedProjectType.IPM_TLD_Milestone_Help_Text__c))
		{
			String[] displayLinkArray = associatedProjectType.IPM_TLD_Milestone_Help_Text__c.split(IPM_ConstantUtils.COMMA_DELIMITER);
			
			if(displayLinkArray.size() == 2){
				//To display the link below along with help text and it will take us to the IPM_RolloutPlans page or IPM_CoreParameters page.
				tldHelpTextLabel = displayLinkArray[0]; 
				strLink = displayLinkArray[1];
			}
			displayPage = associatedProjectType.IPM_Go_To_Change_TLD_Link__c;
		}
		
    	return tldHelpTextLabel;
    }
    
    
    /**************************************************************
    * @description: toggling sort with milestones and adding back to the currentSort map & ordering the result
    */
    public void toggleSortMilestones(){
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Name__c');
        getProjectMilestones();
    }
    
    /**************************************************************
    * @description: toggling sort with phase and adding back to the currentSort map & ordering the result
    */
    public void toggleSortPhases() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Phase__c');
        getProjectMilestones();
    }
    
    /**************************************************************
    * @description: toggling sort with MS which are complete and adding back to the currentSort map & ordering the result
    */
    public void toggleSortCompletion() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Completed__c');
        getProjectMilestones();
    }
    
    /**************************************************************
    * @description: toggling sort with MS which are complete on and adding back to the currentSort map & ordering the result
    */
    public void toggleSortCompletedOn() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Completed_On__c');
        getProjectMilestones();
    }
        
    public void initializeMilestones()
    {
        loadMilestones();
        loadTimelines((List<IPM_Milestone__c>)sourcesObjectList);
        checkForOTIFWarning();
    }
    /*******************************************************************************************************
    * @description: It loads the updated Milestones whenever page is loaded
      @return: sobject List : Milestone list
    */
    private List<sObject> loadMilestones() {
        milestoneCnt = 0;
        phaseMsList = new List<String>();
        Set<String> phaseMsSet = new Set<String>();
        String strQuery = getQuery();
        sourcesObjectList = database.query(strQuery);
		
		sortMilestones(sourcesObjectList);
		
    	if(sourcesObjectList!=null && !sourcesObjectList.isEmpty())
        {
            milestoneCnt = sourcesObjectList.size();
        }
        for(IPM_Milestone__c eachMilestone : (List<IPM_Milestone__c>)sourcesObjectList)
        {//load all the milestones & process them and add the wrapper list
            phaseMsSet.add(eachMilestone.IPM_phase__c);   
        }
        phaseMsList.addAll(phaseMsSet);
        return sourcesObjectList;                    
    }
      /*******************************************************************************************************
    * @description: TO sort Milestone First by phase and then by date
    */
    public override void sortMilestones(List<sObject> incomingMilestoneList)
    {
    	List<MilestoneWrapper> milestoneWrapperList = new List<MilestoneWrapper>();
		
		for(IPM_Milestone__c milestone : (List<IPM_Milestone__c>)incomingMilestoneList)
		{
			milestoneWrapperList.add(new MilestoneWrapper(milestone));		
		}
		
		milestoneWrapperList.sort();
		
		incomingMilestoneList.clear();
		
		for(MilestoneWrapper milestoneWrap : milestoneWrapperList)
		{
			incomingMilestoneList.add(milestoneWrap.milestone);		
		}
    }
    
    /***************************************************************
    *@Description : Method to prepare the dynamic query of Milestone 
     @param : none
     @return: String : SOQL query 
    ****************************************************************/
    public override String getQuery()
    {
        String sortString = '  ORDER BY  ';
        String limitString = ' NULLS LAST LIMIT 9999';
        String soql  =  'SELECT IPM_Completed__c, IPM_Type_of_Milestone__c, IPM_Name__c, IPM_Violate_Preferred_Date__c , IPM_Phase_Order__c,IPM_Project__r.IPM_Target_Launch_Dates__c,IPM_Due_Date__c, IPM_Completed_On__c, IPM_phase__c, IPM_Milestone__c';
        soql += ' FROM IPM_Milestone__c ';
        
        soql += 'WHERE IPM_Project__c = \'' + String.escapeSingleQuotes(projectId) + '\' AND IPM_Active__c = true ';
        
        if(phaseM != '') {
           soql += ' AND IPM_phase__c IN '+ IPM_Utils.convertStrToSoqlList(String.escapeSingleQuotes(phaseM)); 
        } 
        if(isCompleteMilestones != null && isCompleteMilestones == 't') {
            soql += ' AND IPM_Completed__c = true';
        }
        if(isCompleteMilestones != null && isCompleteMilestones == 'f') {
            soql += ' AND IPM_Completed__c = false';
        }
        soql += ' AND recordtypeId=\'' + IPM_Utils.getMilestoneRecordType('IPM Project Milestones') + '\'';
        

        if(isAsc)
        {
            sortString +=  currentSort.get(IPM_ConstantUtils.THIS_FIELD) + ' DESC, IPM_Due_Date__c ASC' ; 
        } 
        else
        {
            sortString += currentSort.get(IPM_ConstantUtils.THIS_FIELD) + ' ASC,  IPM_Due_Date__c ASC';
        }

        soql += sortString + limitString;
        return soql;
    }
    
    /*******************************************************************************************************
    * @description: wraps the updated MS from the dynamic query
      @return: Wrapper Object list
    */
    public List<sObjectPaginationWrapper> getProjectMilestones() {
        pageSize = IPM_ConstantUtils.NO_OF_RECORDS;
        milestoneCnt = 0;
        loadMilestones();
        loadTimelines((List<IPM_Milestone__c>)sourcesObjectList);
        getWrapperRecords();
        if(getEndIndexNumber() == 0){
            paginationUIDisplay = string.format(System.Label.IPM_PaginationUIDisplay, new string[] {string.valueof(getBeginIndexNumber() - 1),String.valueof(getEndIndexNumber()),String.valueof(milestoneCnt)});
        }else{
            paginationUIDisplay = string.format(System.Label.IPM_PaginationUIDisplay, new string[] {string.valueof(getBeginIndexNumber()),String.valueof(getEndIndexNumber()),String.valueof(milestoneCnt)});
        }
        
        return  wrapperRecordList;
    }
    
    public String getPaginationUIDisplay(){
        return paginationUIDisplay;
    }
      
    /*******************************************************************************************************
    * @description: It loads the MS timelines from the same page
      @param : List of Milestones
    */
    public void loadTimelines(List<IPM_Milestone__c> milestones) {
        
        timelineMilestones = new List<TimelineWrap>();
        List<IPM_Milestone__c> tmpMilestonesLst;
        Integer currentPhase = 0; 
        Integer proPhase = 0;
        for(String eachPhase : phaseOrder) {
            currentPhase = phaseOrderMap.get(eachPhase);
            proPhase = phaseOrderMap.get(projectPhase);
            tmpMilestonesLst = new List<IPM_Milestone__c>();
            for(IPM_Milestone__c eachMilestone : milestones) 
            {
                if(eachMilestone.IPM_Phase__c == eachPhase) 
                {
                    tmpMilestonesLst.add(eachMilestone);
                }
            }
            Boolean isFtr = currentPhase > proPhase ? true : false;
            timelineMilestones.add(new TimelineWrap(eachPhase, isFtr, tmpMilestonesLst));
        }
    }
    
    /*******************************************************************************************************
    * @description: Filtering method on phases
    */
    public void filteredphaseM() {
        setCon = null;   
        getProjectMilestones();
        
    }
    
    /*******************************************************************************************************
    * @description: Filtering method on Complete MS wise
    */
    public void filterCompleteMilestones() {
         setCon = null;   
        getProjectMilestones();
    }
    
    /*******************************************************************************************************
    * @description: TO delete the MS from which adhoc or optionals
    */
    public void deleteMilestone() {
        
        // Setting Page Number to come back to same Page or previous based on Record Size.       
        setPageNumber(); 
        
        List<IPM_Milestone__c> milestonList = [SELECT Id, isDeleted FROM IPM_Milestone__c WHERE Id =:milestoneId];
        
        if (milestonList != null && !milestonList.isEmpty() && IPM_Milestone__c.sObjectType.getDescribe().isDeletable()){
            delete milestonList;
        }
         // Reset Standard Set after DML to get latest records.
        setCon = null;   
    }
    
    /********************************************************
    * @description: To mark the MS as complete
    */
    public void markCompleteM() {
        
        IPM_Milestone__c mObj = [SELECT IPM_Completed__c,IPM_Project__r.IPM_Target_Launch_Dates__c,IPM_Due_Date__c,IPM_Type_of_gate__c FROM IPM_Milestone__c WHERE Id =:milestoneId];
        mObj.IPM_Completed__c = isChecked == 'true' ? true : false; 
        mObj.IPM_Completed_On__c = isChecked == 'true' ? system.today() : null;
        update mObj;
        
        initializeMilestones();
        getWrapperRecords();
    }

	/********************************************************************************
    *@Description :Method to send the parameters required (i.e the object, fields required for the object and the where condition for the query) 
    for the excel download
    *@return:Returns the IPM_ExportToExcel page 
    *********************************************************************************/
    public pagereference exportToExcel(){
        
        PageReference url = Page.IPM_ExportToExcel;
        url.getParameters().put('currentObjectName','Milestone');
        url.getParameters().put('currentObject','IPM_Milestone__c');
        url.getParameters().put('fieldSetName','IPM_Export_List_FieldSet');
        url.getParameters().put('whereClause','where IPM_Project__c =\''+projectId+'\' and IPM_Active__c = true');
        
        url.setRedirect(true);
        return url;
    }    
    
    /***************************************************
     @Description: Display Warning Message depending on for Market Ready Gate Milestone if gap between the due date of Market Ready Gate 
                    and Target Launch Date is 6 months/4 months based on Market Type of Project .  
    */
    
    public void checkForOTIFWarning (){
        
        for(IPM_Milestone__c milestone : (List<IPM_Milestone__c>)sourcesObjectList){
            
            if(milestone.IPM_Violate_Preferred_Date__c)
            {
                if(projectObj.IPM_Market_Type__c == IPM_Utils.DevelopingIPM_Market_Type)
                {
                    isWarningRequired = true;
                    warningMessages.add(string.format(System.Label.IPM_MilestoneMarketReadyWarning, new string[] {IPM_ConstantUtils.MARKETREADYWARNINGMONTHS_FIRST, IPM_ConstantUtils.MARKETREADYWARNINGDAYS_FIRST}));
                }
                else if(projectObj.IPM_Market_Type__c == IPM_Utils.EmergingIPM_Market_Type)
                {
                    isWarningRequired = true;
                    warningMessages.add(string.format(System.Label.IPM_MilestoneMarketReadyWarning, new string[] {IPM_ConstantUtils.MARKETREADYWARNINGMONTHS_SECOND,IPM_ConstantUtils.MARKETREADYWARNINGDAYS_SECOND}));
                }
                break;
            }
            
        }   
        
    }
    
    /********************************************************
    * @description: Timeline wrapper class
    */
    public class TimelineWrap {
        
        public String milestineStatus{get;set;}//status of the milestone whether complete or in progress or not started
        public Boolean isFuture{get;set;}//is this a future MS?
        public List<IPM_Milestone__c> milestoneList{get;set;}//list of MS phases wise.
        
        public TimelineWrap(String s, Boolean f, List<IPM_Milestone__c> mL) {
            milestineStatus = s;
            milestoneList = mL;
            isFuture = f;
        }
    }
    
     /*******************************************************************************************************
    * @description: Wrapper list to compare Milestone
    */
    public class MilestoneWrapper implements Comparable 
    {
    	public IPM_Milestone__c milestone;
	
		public MilestoneWrapper(IPM_Milestone__c pMilestone)
		{
			milestone = pMilestone;
		}
		
	    // Implement the compareTo() method
	    public Integer compareTo(Object pMilestoneObject) 
	    {
	    	
	    	
	        MilestoneWrapper incomingMilestoneWrapperObj = (MilestoneWrapper)pMilestoneObject;
	        IPM_Milestone__c incomingMilestoneObject = incomingMilestoneWrapperObj.milestone;
	        
	        
	        // If Incoming Milestone Phase is Blank, Validate against Due Date.All Milestones will lower Due Dates Get Priority.
	        if(String.isBlank(incomingMilestoneObject.IPM_Phase__c))
	        {
				if(incomingMilestoneObject.IPM_Due_Date__c < milestone.IPM_Due_Date__c || milestone.IPM_Due_Date__c == null )
		        {
		        	return 1; 	
		        }	        		
	        } // In Case incoming Gate is Blank.
	        else if(incomingMilestoneObject.IPM_Due_Date__c == null)
	        {
	        	// check if the incoming Milestone Phase is less than current Milestone,then Phase incoming Milestones Phase takes less.
	        	if(incomingMilestoneObject.IPM_Phase_Order__c < milestone.IPM_Phase_Order__c)
	        	{
	        		return 1;
	        	} // if Phase is same, then If current Milestone has due date, make current Milestone is less.
	        	else if(incomingMilestoneObject.IPM_Phase_Order__c == milestone.IPM_Phase_Order__c && milestone.IPM_Due_Date__c != null)
	        	{
	        		return -1;
	        	}
	        }
	        else
	        {   // At this stage, we expect that incoming has both Phase and Due Date.
	        	// If Current Milestone doesnt have Phase,then Treat on Due date.
	        	// If Due date of incoming milestone is less than current milestone, incoming milestone is less. 
        	  	if(String.isBlank(milestone.IPM_Phase__c))
		        {
					if(milestone.IPM_Due_Date__c != null && incomingMilestoneObject.IPM_Due_Date__c < milestone.IPM_Due_Date__c)
			        {
			        	return 1; 	
			        }	        		
		        }
		        else if (milestone.IPM_Due_Date__c == null)
		       	{
		       		if(incomingMilestoneObject.IPM_Phase_Order__c <= milestone.IPM_Phase_Order__c)
		        	{
		        		return 1;
		        	}
		       	}
	        	else if(milestone.IPM_Phase__c != null && milestone.IPM_Due_Date__c !=null)
	        	{
        			if(incomingMilestoneObject.IPM_Phase_Order__c <= milestone.IPM_Phase_Order__c && incomingMilestoneObject.IPM_Due_Date__c < milestone.IPM_Due_Date__c)
					{
						return 1;
					}
	        	}	
	        }
	        
	        return -1;
	    }
    
	}
}