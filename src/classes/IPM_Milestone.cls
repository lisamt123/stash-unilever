/****************************************************************************************************************************
@Author: Cognizant
@name: IPM_Milestone
@CreateDate: Oct'2014
@Description: To Add / Edit Milestones for any project. PL can add Adhoc/MINI Milestones which are already listed.
@Version: 
@reference: Referred in IPM_AddMilestone , IPM_EditMilestone VF Pages. 
*/ 

public with sharing class IPM_Milestone {
    
    public IPM_Milestone__c milestoneObj{get;set;} // To query the milestone
    public IPM_Project__c projectObject{get;set;} // To get the Milestones for Projectid
    public sObject msObject{get;set;} // To get the details of Milestone sobj
    
    public String sObjName{get; set;} // To query the Name of sobj
    public String errorMessage {get;set;} // To display the error message
    public string isEditable{get;set;} // To give the editable permission only to certain users
    public string IsDateEdit{get;set;} // To check the date is editable
    public string dateFormat1 {get; set;} // To check the format of the date
    public string ProjectWizard{get;set;} // dIsplay on the wizard
    public string sourceProjectType; // To store the source project type
    
    public Id projectId{get; set;} // Fetching the projectids
    public Id milestoneId{get; set;} // Fetching and Initilaizing the Milestonesid
    
    public boolean validateSuccess {get;set;} // To validate the check is needed
    public boolean displayPopup {get; set;} // To display popup
    public boolean editMsNameFlag{get; set;} // Boolean to check Miestone Name 
    public boolean editPhaseFlag{get; set;} // Boolean to check Miestone Phase Name
    public boolean complDateFlag{get; set;} // Boolean to check Miestone Due Date
	public boolean milestoneFlag{get; set;} // Boolean to check Miestone Id null or not 
    public boolean stndMilestoneFlag{get; set;} // Boolean to check Miestone type
    public boolean adhocMilestoneFlag{get; set;} // Boolean to check Miestone type
    public boolean miniMilestoneFlag{get; set;} // Boolean to check Miestone type
    public boolean showError{get; set;} // Boolean flag to show error if no MINI Ms is selected
        
    public date duedateValue; // To initialize the due date 
    
    public List<MilestoneWrapper> milestones {get;set;} // Getting the list of milestones
    
    public final String IPM_MILESTONE_STR = IPM_Milestone.class.getName();
    
    public static final String CREATE_MILESTONES = 'createMileStones';
    public static final String STR_ERROR = 'Error';
    public static final String SELECTED_MS = 'minMsId';
    
    /***************************************************************
    *@Description :Constructor to fetch the details of the Milestones and Project
     @param1  : Standard Controller
    ****************************************************************/
    public IPM_Milestone(ApexPages.StandardController controller) 
    {
        IPM_IECompatible.ieFix(); // To fix IE11 related UI issue.
        ProjectWizard='';
        validateSuccess = false;
        isEditable=ApexPages.currentPage().getParameters().get(IPM_Utils.isEdit);
        IsDateEdit=ApexPages.currentPage().getParameters().get(IPM_Utils.isDateEdit);
        ProjectWizard=ApexPages.currentPage().getParameters().get(IPM_Utils.Wizard);
        milestoneObj = (IPM_Milestone__c)controller.getRecord();
        showError = false;
        projectObject = new IPM_Project__c();
        
        if(String.IsNotBlank(ApexPages.currentPage().getParameters().get(IPM_Utils.IPM_NewTaskprojectId)))
        {
            projectId = ApexPages.currentPage().getParameters().get(IPM_Utils.IPM_NewTaskprojectId);
            sObjName = projectId.getSObjectType().getDescribe().getName();
            
            String projectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null,true);
            String projectWhereClause = ' WHERE Id =: projectId limit 1';
            projectQuery = projectQuery + projectWhereClause;
            
            projectObject  = Database.query(projectQuery);
            
            // Reterive the project type 
            IPM_Project_Type__c projectType = IPM_Utils.retrieveProjectType(projectObject);
            if(projectType!=null)
            {
            	sourceProjectType = projectType.Source_Project_Type__c; // Get the source Project type
            }	
            
            if(String.IsNotBlank(ApexPages.currentPage().getParameters().get(IPM_Utils.taskId)))
            {
                milestoneId = ApexPages.currentPage().getParameters().get(IPM_Utils.taskId);
                sObjName = milestoneId.getSObjectType().getDescribe().getName();
                String milestoneQuery = 'SELECT Id,IPM_Category__c,IPM_Completed_On__c,IPM_Completed__c,IPM_Due_Date__c,IPM_Milestone__c,IPM_Name__c,IPM_No_of_Days__c, IPM_Phase__c,IPM_Planned_Date__c,IPM_Project__c,IPM_Type_of_gate__c,IPM_BET__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c WHERE id =\''+ milestoneId + '\' ';
                msObject= Database.query(milestoneQuery);
                
                milestoneObj = (IPM_Milestone__c)msObject;
                if(String.IsNotBlank(String.valueOf(milestoneObj.IPM_Due_Date__c)))
                {
                    duedateValue=milestoneObj.IPM_Due_Date__c;
                }                        
                                
                // To check if Milestone name and phase is editable or not
                if(milestoneObj.IPM_Type_of_Milestone__c != '' && milestoneObj.IPM_Type_of_Milestone__c == IPM_ConstantUtils.ADHOC)
                {
                    editMsNameFlag = true;
                    editPhaseFlag = true;
                }
                else
                {
                    editMsNameFlag = false;
                    editPhaseFlag = false;
                }
                // To check if Completed On Date is editable or not 
                if(milestoneObj.IPM_Type_of_Milestone__c == IPM_ConstantUtils.STANDARD)
                {
                    complDateFlag = false;
                }
                else
                {
                    complDateFlag = true;
                }
            }
        
        }
        
        
        
        // Checking the Local date format for user
        dateFormat1 = UserInfo.getLocale();            
        //Checking if the result is returned or not
        getCategories();
        renderCondition();
    }

    // To auto select Mini Milestone on change of Due date
    public void selectMiniMs()
    {
    	Map<String,String> requestMap = Apexpages.currentPage().getParameters();
    	if(requestMap.containsKey(SELECTED_MS) && requestMap.get(SELECTED_MS)!=null)
    	{
    		String miniMSId = requestMap.get(SELECTED_MS);	
         for(MilestoneWrapper miniMSObj :  milestones)
         {
            if(miniMSObj.mile.Id == miniMSId)
            {
                if(miniMSObj.mile.IPM_Due_Date__c != null)
                {
                    miniMSObj.checked = true;   
                }
                else
                {
                    miniMSObj.checked = false;
                }
            }
         }
    	}
    }    
    
    /********************************************************************************
    *@Description : .
     @param1  : none
    *********************************************************************************/
    public void renderCondition(){
    	
    	stndMilestoneFlag = false;
    	milestoneFlag = false;
    	miniMilestoneFlag = false;
    	adhocMilestoneFlag = false;
    	if(milestoneid != null){
    		milestoneFlag = true;
    	}
			
		if(milestoneObj.IPM_Type_of_Milestone__c == IPM_ConstantUtils.STANDARD){
			stndMilestoneFlag = true;
		}else if(milestoneObj.IPM_Type_of_Milestone__c == IPM_ConstantUtils.ADHOC){
			adhocMilestoneFlag = true;
		}else if(milestoneObj.IPM_Type_of_Milestone__c == IPM_ConstantUtils.MINI){
			miniMilestoneFlag = true;
		} 
    }
     
    /********************************************************************************
    *@Description : checking the milestones duedate and update the milestones.
     @param1  : Milestone list 
    *********************************************************************************/
    public void upsertMilestones(List<IPM_Milestone__c> msList) {
        try {
            Database.upsert(msList);
        } catch(Exception ex) {
            errorMessage =ex.getMessage();
            if(errorMessage.contains(IPM_Utils.Duedate)) {
                errorMessage = Label.IPM_Milestone_Due_Date_Error;
            } 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage));
            validateSuccess =false;
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_MILESTONE_STR,
                        'upsertMilestones',ex.getMessage(),ex, STR_ERROR, null, null, null, null);
        }
    }
    
    /********************************************************************************
    *@Description : Method to create milestones and redirect the page
    *@Param: None
    *@return: This method returns to Milestones Page
    *********************************************************************************/
    public pageReference createMileStones()
    {
        
        try
        {
            List<IPM_Milestone__c> lstmiles=new List<IPM_Milestone__c>();
            
            IPM_Milestone__c[] milestone;
            
            Set<Id> selectedMiniMileMaster = new Set<Id>();
            Set<String> selectedMiniMilePhases = new Set<String>();
            // Get the standard Mini Milestones.
            for (MilestoneWrapper msWrap : milestones) 
            {
                if (msWrap.checked)
                {
                     selectedMiniMileMaster.add(msWrap.mile.IPM_Milestone__c); 
                     selectedMiniMilePhases.add(msWrap.mile.IPM_Phase__c);      
                }                
            }
       
            // Get the Project Specific Standard Milestones based on Selected Mini Milestone's Master Ids.
            if(!selectedMiniMileMaster.isEmpty())
            {
                Boolean errorPresent = false;
                
                List<MilestoneWrapper> mileStoneWrapToBeProcessed = new List<MilestoneWrapper>();
                
                Map<Id,IPM_Milestone__c> masterToProjectMileStone = new Map<Id,IPM_Milestone__c>();
                
                for(IPM_Milestone__c projectMilestone : [SELECT Id,IPM_Due_Date__c,IPM_Category__c,IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,
                IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c WHERE IPM_Project__c = :String.escapeSingleQuotes(String.valueOf(projectObject.Id)) 
                AND IPM_Milestone__c in :selectedMiniMileMaster AND IPM_Phase__c in :selectedMiniMilePhases] )
                {
                   masterToProjectMileStone.put(projectMilestone.IPM_Milestone__c,projectMilestone); 
                }  
                
                for(MilestoneWrapper incomingMileWrap : milestones)
                {
                    if (incomingMileWrap.checked)
                    { 
                        Date gateDueDate = null;
                        Date incomingDate = incomingMileWrap.mile.IPM_Due_Date__c;
                        Id standardMasterMileId = incomingMileWrap.mile.IPM_Milestone__c;
                    
                        if(masterToProjectMileStone.containsKey(standardMasterMileId) && masterToProjectMileStone.get(standardMasterMileId)!=null)
                        {
                            IPM_Milestone__c projectMilestone =   masterToProjectMileStone.get(standardMasterMileId);
                            gateDueDate = projectMilestone.IPM_Due_Date__c;             
                        }
                    
                        if(gateDueDate!=null && gateDueDate < incomingDate)
                        {
                           incomingMileWrap.errorRecord = true;
                           errorPresent = true;                       
                        }
                        else
                        {
                            incomingMileWrap.errorRecord = false;
                            mileStoneWrapToBeProcessed.add(incomingMileWrap); 
                        }
                    }
                }
                
                if(!errorPresent && !mileStoneWrapToBeProcessed.isEmpty())
                {
                    for(MilestoneWrapper selectedMiniMileWrap :  mileStoneWrapToBeProcessed)
                    {
                        IPM_Milestone__c msObj = new IPM_Milestone__c();
                        msObj.recordTypeId             = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectMilestones).getRecordTypeId();
                        msObj.IPM_Name__c              = selectedMiniMileWrap.mile.IPM_Name__c;
                        msObj.IPM_Project__c           = projectObject.Id;
                        msObj.IPM_Milestone__c         = selectedMiniMileWrap.mile.Id;
                        msObj.IPM_Phase__c             = selectedMiniMileWrap.mile.IPM_Phase__c;
                        msObj.IPM_Planned_Date__c      = selectedMiniMileWrap.mile.IPM_Due_Date__c;
                        msObj.IPM_Due_Date__c      	   = selectedMiniMileWrap.mile.IPM_Due_Date__c;
                        msObj.IPM_Type_of_Milestone__c = IPM_ConstantUtils.MINI;
                        msObj.IPM_Active__c            = true;
                        lstmiles.add(msObj);
                    }
                }
                showError = false;
            }else{
                showError = true;
            }
            
            if(!lstmiles.isEmpty())
            {
                upsert lstmiles;
                validateSuccess =true;
            }
        }
        catch(Exception ex)
        {
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage)); 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_MILESTONE_STR,
                        CREATE_MILESTONES,ex.getMessage(),ex, STR_ERROR, null, null, null, null);
            
        }
        return null;  
    }
    
    
    // wrapper class
    public class MilestoneWrapper {
        public Boolean checked{ get; set; }
        public IPM_Milestone__c mile { get; set;}
        public Boolean errorRecord {get;set;}
        
        public MilestoneWrapper()
        {
            mile = new IPM_Milestone__c();
            checked = false;
        }
        
        // Milestone wrapper         
        public MilestoneWrapper(IPM_Milestone__c c,Date launchDate)
        {
            mile = c;
            if(c.IPM_BET__c && c.IPM_Name__c == IPM_Utils.BETFirstRelease){
                mile.IPM_Due_Date__c = launchDate.month() < IPM_ConstantUtils.BET_DUEDATE_MONTH ? Date.newInstance(launchDate.year() -IPM_ConstantUtils.BET_DUEDATE_YEAR, IPM_ConstantUtils.BET_DUEDATE_H1_MONTH, IPM_ConstantUtils.BET_DUEDATE_H1_DAY):Date.newInstance(launchDate.year()-IPM_ConstantUtils.BET_DUEDATE_YEAR, IPM_ConstantUtils.BET_DUEDATE_H2_MONTH, IPM_ConstantUtils.BET_DUEDATE_H2_DAY);
            }else if(c.IPM_BET__c && c.IPM_Name__c == IPM_Utils.BETFinalReleasecompletewithApprovedCommunication){
                mile.IPM_Due_Date__c=launchDate.addDays(-180);
            }
            checked = false;
            errorRecord = false;
            if(test.isRunningTest()){
                checked = true;
            }
        }
    }
    
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) 
            {
                Id mileStoneRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMMilestones).getRecordTypeId(); 
                con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id,IPM_Project__c,IPM_Due_Date__c,IPM_Name__c,IPM_Category__c,IPM_Planned_Date__c,
                        IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_BET__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c,IPM_Phase_Order__c FROM IPM_Milestone__c 
                        WHERE IPM_Name__c != null And RecordTypeId= : mileStoneRecordType AND IPM_Type_of_Milestone__c=: IPM_ConstantUtils.MINI 
                        AND IPM_Project_Type__c =: sourceProjectType order by IPM_Phase_Order__c, IPM_Name__c])); 
                
                // sets the number of records in each page set
                con.setPageSize(20);
                
            }
            return con;
        }
        set;
    }
    
    /********************************************************************************
    *@Description : To get the milestones based on TLD
    *@Param: Getting categories for milestones
    *@return: milestones
    *********************************************************************************/    
    public List<MilestoneWrapper> getCategories() {
        milestones = new List<MilestoneWrapper>();
        for (IPM_Milestone__c mile : (List<IPM_Milestone__c>)con.getRecords()){
           //   Added as part of phase 2.0 , added just the If condition to hide PDL milestone for Personal Care category group.
            if (!(projectObject.IPM_Category_Group__c!= null && IPM_ConstantUtils.PERSONAL_CARE.equals(projectObject.IPM_Category_Group__c) && mile.IPM_Name__c.equals(IPM_ConstantUtils.ADDITIONAL_MILSTONE_PDL)))
            {
             milestones.add(new MilestoneWrapper(mile,projectObject.IPM_Target_Launch_Dates__c));
            }
             
        }
        return milestones;
    }
    
    /********************************************************************************
    *@Description : To get the due dates based on the phase of the project
    *********************************************************************************/      
    public void getduedate(){
        try{
            if(String.IsNotEmpty(milestoneObj.IPM_Phase__c)){
                integer milescount=[SELECT count() FROM IPM_Milestone__c WHERE IPM_Project__c = :projectId AND IPM_Milestone__c = null AND IPM_Phase__c = : milestoneObj.IPM_Phase__c AND IPM_Planned_Date__c != null];
                if(milescount < 0){
                    return;
                }
                List<IPM_Milestone__c> milestoneList = new List<IPM_Milestone__c>();
                
                milestoneList =[SELECT Id,IPM_Category__c,IPM_Planned_Date__c,IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_BET__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c WHERE IPM_Project__c = :projectId AND IPM_Milestone__c = null and IPM_Phase__c = : milestoneObj.IPM_Phase__c and IPM_Planned_Date__c != null limit 1];
                
                for(IPM_Milestone__c miles : milestoneList)
                {
                    if(String.IsNotBlank(String.valueOf(miles.IPM_Planned_Date__c)))
                    {    
                        milestoneObj.IPM_Planned_Date__c=miles.IPM_Planned_Date__c;
                        milestoneObj.IPM_Due_Date__c=miles.IPM_Planned_Date__c;
                    }
                }
            }
        }catch(Exception ex){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_MILESTONE_STR,
                        'getduedate',ex.getMessage(),ex, STR_ERROR, null, null, null, null);
        }
    }
    
    /********************************************************************************
    *@Description : To check the mandatory fields of Milestone
    *********************************************************************************/   
    private String mandatoryFieldChecks()
    {
        // Milestone name is required  
        if(String.isBlank(milestoneObj.IPM_Name__c))
        {
            return Label.IPM_MilestoneName;
        }
        
        // Phase is required
        if(String.isBlank(milestoneObj.IPM_Phase__c))
        {
            return Label.IPM_Phase;
        }
        
        // Due date is required
        
        if(String.isBlank(String.valueOf(milestoneObj.IPM_Due_Date__c)))
        {
            return Label.IPM_DueDate;
        }
        
        return IPM_ConstantUtils.BLANK;
    }
    /********************************************************************************
    *@Description : To save milestones based on the required fields
     @return : Boolean value after validation check
    *********************************************************************************/    
    public Boolean validateMilestone()
    {
        try
        {
            //Perform Mandatory Checks
            String resultString = mandatoryFieldChecks();
            if(!String.isBlank(resultString) )
            {
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_DueDate);
                ApexPages.addMessage(myMsg); 
                return false;
            }
            
            if(milestoneId !=null)
            {
                Map<String,List<IPM_Milestone__c>> phasetoMilestoneMap = new Map<String,List<IPM_Milestone__c>>();
                IPM_Milestone__c incomingMilestone = null;
                
                // Get the standard Milestones and keep it in cache.
                String stndMileStoneString = IPM_ConstantUtils.STANDARD;
                
                // Get the in context Milestone.
                List<IPM_Milestone__c> incomingMileStoneList =[SELECT Id,IPM_Due_Date__c,IPM_Project__c,IPM_Project__r.IPM_Target_Launch_Dates__c,IPM_Category__c,
                IPM_Completed_On__c,IPM_Milestone__c,IPM_Milestone__r.IPM_Milestone__c,IPM_Phase__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c  
                WHERE Id =:milestoneId ];
                
                            
                List<IPM_Milestone__c> projectSpecificMilestoneList = [SELECT Id,IPM_Due_Date__c,IPM_Name__c,IPM_Project__c,IPM_Project__r.IPM_Target_Launch_Dates__c,IPM_Category__c,
                IPM_Completed_On__c,IPM_Milestone__c,IPM_Phase__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c  
                WHERE  IPM_Type_of_Milestone__c =:stndMileStoneString AND IPM_Project__c =:projectId AND IPM_Active__c =: true];
                
                
                 
                for(IPM_Milestone__c milestone : projectSpecificMilestoneList)
                {
                    List<IPM_Milestone__c> mileStoneList = new List<IPM_Milestone__c>();
                    if(phasetoMilestoneMap.containsKey(milestone.IPM_Phase__c) )
                    {
                        mileStoneList = phasetoMilestoneMap.get(milestone.IPM_Phase__c);     
                    }
                    mileStoneList.add(milestone);
                    
                    phasetoMilestoneMap.put(milestone.IPM_Phase__c,mileStoneList);
                }
                
                if( !incomingMileStoneList.isEmpty() )
                {
                    incomingMilestone =  incomingMileStoneList.get(0);
                    
                    String milestonePhase = incomingMilestone.IPM_Phase__c;
                    Date milestoneDueDate = milestoneObj.IPM_Due_Date__c;
                    
                    if(IPM_ConstantUtils.MINI == incomingMileStone.IPM_Type_of_Milestone__c &&  incomingMileStone.IPM_Milestone__c!=null)
                    {
                        // Get Master Milestone Information 
                       
                        Id masterMilestoneId = incomingMileStone.IPM_Milestone__r.IPM_Milestone__c;
                        Date gateSpecificDate = null;
                        for(IPM_Milestone__c stndMilestone : projectSpecificMilestoneList)
                        {
                            
                            if(stndMilestone.IPM_Milestone__c == masterMilestoneId && milestonePhase == stndMilestone.IPM_Phase__c)
                            {
                               gateSpecificDate = stndMilestone.IPM_Due_Date__c;    
                               break;
                            }
                        }

                        if(gateSpecificDate !=null && milestoneDueDate != null && milestoneDueDate > gateSpecificDate)
                        {
                             ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Milestone_Due_Date_Error);
                             ApexPages.addMessage(myMsg);
                             return false; 
                        }
                    }
                    
                   // Check if Milestone type is standard
                    if(IPM_Utils.IPM_Type_of_Milestone == incomingMilestone.IPM_Type_of_Milestone__c)
                    {
                        if(milestoneObj!=null && milestoneObj.IPM_Due_Date__c < System.today())
                        {
                            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,milestoneObj.IPM_Name__c + ' ' + Label.IPM_MILESTONE_DUE_DATE_LESS_THAN_TODAY);
                            ApexPages.addMessage(myMsg); 
                            return false; 
                        }
                        
                        Set<String> previousPhases = new Set<String>();
                        
                    	for(String phase : IPM_ConstantUtils.phaseSequence.KeySet()){
                    		if(phase == milestonePhase)
                    		{
                    			break;
                    		}
                    		previousPhases.add(phase);		
                		}
                        
                        for(IPM_Milestone__c milestone : projectSpecificMilestoneList)
                        {
                            // Phase 2.0 changes - To accomodate Due date validations for PDL milestone
                            if(milestone.IPM_Phase__c.equals(milestonePhase) && milestone.IPM_Name__c.equals(IPM_ConstantUtils.PRODUCT_DESIGN_LOCK) && !milestoneObj.IPM_Name__c.equals(milestone.IPM_Name__c)){
                                if(milestone.IPM_Due_Date__c != null && milestone.IPM_Due_Date__c > milestoneDueDate)
                                {
                                    String errorMessage = Label.IPM_ContractGate_Milestone_Before_PDL;
                                    ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
                                    ApexPages.addMessage(myMsg);
                                    return false;
                                }
                                
                                
                            }
                            // Due date validation check with next milestones 
                            if(milestone.IPM_Phase__c.equals(milestonePhase) && milestone.IPM_Name__c.equals(IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE) && milestone.IPM_Due_Date__c != null && !milestoneObj.IPM_Name__c.equals(milestone.IPM_Name__c) && milestone.IPM_Due_Date__c < milestoneDueDate)
                            {
                                String errorMessage = Label.IPM_PDL_Due_Date_Before_Contract_Milestone;
                                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
                                ApexPages.addMessage(myMsg);
                                return false;
                            }
                            if(milestone.IPM_Phase__c != milestonePhase)
                            {
                                // Due date validation check with previous milestones 
                                if(previousPhases.contains(milestone.IPM_Phase__c))
                                {
                                    if(milestone.IPM_Due_Date__c != null && milestone.IPM_Due_Date__c > milestoneDueDate)
                                    {
                                       String errorMessage = Label.IPM_Milestone_DueDate_Validation;
                                       // Phase 2.0 changes related to REQ03115.
                                       if(milestone.IPM_Name__c.equals(IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE) && milestoneObj.IPM_Name__c.equals(IPM_ConstantUtils.PRODUCT_DESIGN_LOCK)){
                                            errorMessage=Label.IPM_PDL_Due_Date_After_Charter;
                                        }
                                        
                                        ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
                                        ApexPages.addMessage(myMsg);
                                        return false;
                                    }
                                    
                                }
                                else
                                {
                                    // Due date validation check with next milestones 
                                    if(milestone.IPM_Due_Date__c != null && milestone.IPM_Due_Date__c < milestoneDueDate)
                                    {
                                        String errorMessage = Label.IPM_Milestone_FutureDueDate_Validation;
                                        //Phase 2.0 changes related to REQ03115.
                                        if(milestoneObj.IPM_Name__c.equals(IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE) && milestone.IPM_Name__c.equals(IPM_ConstantUtils.PRODUCT_DESIGN_LOCK)){
                                            errorMessage=Label.IPM_Charter_Due_Date_Before_PDL;
                                        }
                                        ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
                                        ApexPages.addMessage(myMsg);
                                        return false;
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_MILESTONE_STR,'validateMilestone',ex.getMessage(),ex, STR_ERROR, null, null, null, null);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.IPM_Generic_ErrorMessage));
            return false;
        }
        
        return true;
    }
     /********************************************************************************
    *@Description : To display the prompt with options to update task related to current milestone phase
     @return : Returns to milestone page
    
    *********************************************************************************/   
    public PageReference promptForTaskUpdate()
    {
        displayPopup = false;
        
        // Get the List of Tasks associated with the Project. If there are no tasks associated with Project proceed with Milestone Save.
       
        List<IPM_Task__c> associatedPhaseTaskList  =[SELECT Id,IPM_Due_Date1__c, IPM_Project__c, IPM_Due_Date__c, IPM_Phase__c, IPM_Completed__c FROM IPM_Task__c WHERE IPM_Phase__c =: milestoneObj.IPM_Phase__c AND IPM_Completed__c = false AND IPM_Project__c = : milestoneObj.IPM_Project__c LIMIT 50000];

       // If milestone phase is same as Project Phase, then only display Pop up for task  update.  
        if(!String.isBlank(milestoneObj.IPM_Type_of_Milestone__c) && milestoneObj.IPM_Type_of_Milestone__c == IPM_ConstantUtils.STANDARD && milestoneObj.IPM_Phase__c == projectObject.IPM_Phase__c && projectObject.IPM_PM_Approach__c == IPM_ConstantUtils.IPM_APPROACH_INTERNAL && !associatedPhaseTaskList.isEmpty() )
        {

        	Integer taskCount = 0;
        	// Check if related tasks have blank due date
        	for(IPM_Task__c ipmTask : associatedPhaseTaskList){
        		if(ipmTask.IPM_Due_Date1__c == null){
        			taskCount++;
        		}
        	}
        	// If no task has due date then Save Milestone and Update the Tasks, Promt will not be shown
        	if(taskCount == associatedPhaseTaskList.size())
        	{
        		return saveMilestoneAndTasks();
        	}
        	
            validateSuccess = validateMilestone();
            if(validateSuccess)
            {
               validateSuccess = false; // Block the Page from Getting refreshed.
               displayPopup = true; 
            }
        }
        else
        {
            return saveMilestones();
        }
        return null;
    }
     /********************************************************************************
    *@Description : To update the current milestone and also related tasks to that particular milestone
     @return : return to milestone page
    *********************************************************************************/   
    public PageReference saveMilestoneAndTasks()
    {
        validateSuccess = validateMilestone();
        if(validateSuccess)
        {
            System.savePoint sp = Database.setSavePoint();
            try
            {
        	saveMilestones();
        		
                List<IPM_Task__c> lstTasks=[SELECT Id,IPM_Due_Date1__c, IPM_Project__c, IPM_Due_Date__c, IPM_Phase__c, IPM_Completed__c FROM IPM_Task__c WHERE IPM_Phase__c =: milestoneObj.IPM_Phase__c AND IPM_Completed__c = false AND IPM_Project__c = : milestoneObj.IPM_Project__c LIMIT 50000 ];
            
                if(!lstTasks.isEmpty())
                {
                    IPM_Taskhelper.updateTaskDueDateBasedOnMS(lstTasks);
                    update lstTasks;
                }
                displayPopup = false;  
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.IPM_Generic_ErrorMessage));
                validateSuccess =false;
                Database.Rollback(sp);    
            }   
        }
        return null;    
    }
    
     /********************************************************************************
    *@Description : To update the current milestone details 
     @return : Returns to milestone page
    *********************************************************************************/   
    public PageReference saveMilestones()
    {
        validateSuccess = validateMilestone();
        if(validateSuccess)
        {
            milestoneObj.RecordTypeId = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectMilestones).getRecordTypeId();
            milestoneObj.IPM_Planned_Date__c = milestoneObj.IPM_Due_Date__c;
            milestoneObj.IPM_Completed__c = String.IsNotBlank(String.valueOf(milestoneObj.IPM_Completed_On__c)) ? true : false;
            milestoneObj.IPM_Active__c =true;
            if(milestoneObj.IPM_Project__c == null){
            	milestoneObj.IPM_Project__c = projectId;
            }
            
            if(milestoneObj.IPM_Type_of_Milestone__c == null)
            {
                milestoneObj.IPM_Type_of_Milestone__c = IPM_constantUtils.ADHOC;
            }  
            try
            {
                upsert milestoneObj;
                displayPopup = false;
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.IPM_Generic_ErrorMessage));
                validateSuccess =false;    
            }
        }
        return null;       
    }
}