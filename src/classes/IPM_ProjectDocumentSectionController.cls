/****************************************************************************************************************************************************************
* @author Cognizant
* @date 20/02/2015
* @description Used for editing project document section
*/
public with sharing class IPM_ProjectDocumentSectionController extends IPM_ProjectIntermediateController{   
	//Variable Declarations
	public IPM_Project_Document__c projDoc{get; set;} //Contains Project Document
	public IPM_Project_Document_Section__c projDocSec{get; set;} //Contains Project Document Section
	public Id projDocSecId{get; set;} //Contains Project Document Section Id
	public Id projectId{get; set;} //Contains Project Id
	public List<Attachment> attachmentList{get; set;} //Contains List of Project Document Section Attachments
	public string attachId{get; set;} //Contains Attachment Id
	public list<IPM_Task__c> lsttask{get;set;}  //Contains List of Tasks
	public string sectionName{get;set;}  //Contains Project Document Section Name
	public string taskid{get;set;}  //Contains Task Id
	public string isChecked{get;set;} //For Sending Notification Email
	public list<IPM_Project_Resource__c>projectResource{get;set;} //Contains List of Project Resources
	public list<IPM_Project_Document_Section__c>projSectionList{get;set;} //Contains List of Project Document Sections
	public integer charCount{get;set;} //For Character Count
	public integer countLimit{get;set;} //For Character Count Limit
	public Integer sectionCharLimit{get; set;}//For Character Count
	public integer remainingChar{get;set;} //For Remaining Character Count After Editing
	public integer countOfTask{get;set;}// Count of Number of Tasks Remaining
	public Integer countOfCountries{get; set;} //Number of Countries from Project
	public string IsGateSave{get;set;} //To Check Gate Summary Saved or Not
	public String selectedOTIFStatus{get; set;} //For OTIF Section Status
	public Boolean IsEditableOutC{get;set;} //To Read or Editable Permission on Outcome Summary
	public Boolean IsEditableSumm{get;set;} //To Read or Editable Permission on Gate Summary
	public string Frole{get;set;} //Functional Role
	public boolean isTaskeditable{get;set;} //To Check Task Editable or Not
	public string RnDSection{get;set;} //R&D Project Document Section Name
	public boolean IsCRRTEditable{get;set;} //To Check CRRT Project Document Section Editable or Not
	public boolean isEditGateCMI{get;set;} //To Check Gate CMI Project Document Section Editable or Not
	public boolean isAssortEdit{get;set;} //To Check Assortment Strategy Project Document Section Editable or Not
	public boolean isEcodesignEdit{get;set;} //To Check EcoDesign Project Document Section Editable or Not
	public static final String IPM_PROJECT_DOCUMENT_SECTION_CONTROLLER = 'ipm_projectdocumentsectioncontroller';
	public List<IPM_Project_Document_Section__c> projectSections {get;set;}//list of assigned project sections
	public String gateDocument{get; set;}//for storing gate document name
	public String currGate{get;set;}//current gate of the project
	public String currPhase;//current phase
	public string isFlagedNext{get;set;}//for going to next section 
	public string isFlagedPre{get;set;}//for going to previous section
	public boolean showPre{get;set;}//for enable Previous button
	public boolean showNext{get;set;}//for enable Next button
	public String secList{get;set;}//for storing list value
	public string firstSec;//for getting first sequence no
	public string lastSec;//for getting last sequence no
	public boolean showEcoDesign{get;set;}//for showing eco design related section or not
	public List<String> ecoDesignStr;
	public IPM_Project_Type__c projectType;
	public boolean markTaskAccess{get;set;}
	public boolean isTaskViewable{get;set;}
	public boolean isCreateTask{get;set;}
	public boolean showmsg{get;set;}// to show the error message
	public boolean status{get;set;}// to show the status
	public String summary{get;set;}//capture summarey text
	public string docSectionAccess;
	public string tempDocSectionAccess;
	@TestVisible Private Set<String>bdSectionsSet=new Set<String>{};
	@TestVisible Private Set<String>cmiSectionsSet=new Set<String>{};
	@TestVisible Private Set<String>cdSectionsSet=new Set<String>{};
	@TestVisible Private Set<String>rndSectionsSet=new Set<String>{}; 
	@TestVisible Private Set<String>scSectionsSet=new Set<String>{};  
	@TestVisible Private Set<String>financeSectionsSet=new Set<String>{}; 
	@TestVisible Private Set<String>plSectionsSet=new Set<String>{};
	@TestVisible Private Set<String>tplSectionsSet=new Set<String>{};
	private static final String PROJ_DOC_SEC_ID='projDocSecId';
	private static final String EXTERNAL_ID_ENVIRONMENTAL_IMPACT='Environmental_Impact';
	public static final Set<String> sectionEditableOnStatus = new Set<String>{IPM_ConstantUtils.DOCUMENT_STATUS_POSTPONED,IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS,IPM_ConstantUtils.STATUS_NOT_STARTED,IPM_ConstantUtils.STATUS_IN_PROGRESS};
	public Static final String ENVIRONMENTAL_IMPACT = IPM_ConstantUtils.ENVIRONMENTAL_IMPACT_EXTERNAL_ID;
	public boolean isCUandComplexity{get;set;}//to display cu and complexity component
	public boolean isEditMarketPerformance{get;set;}
	public Set<string>userRolesSet; //For getting User Role Types
	public list<IPM_Project__c>lstofuser; //For getting list of users
	public Integer CountProuser;//Count of Users
	public boolean isGlobalActionStandards{get;set;}
	
	/****************************************************************************************************************************************************************
	* @description Fetching the Page parameters and Retrieving Project,Projerct Document and Projerct Document Section
	*/
	public IPM_ProjectDocumentSectionController() {
		//Initializing Variables
		RnDSection=IPM_ConstantUtils.RND_SECTION;
		IsCRRTEditable=false;
		isCreateTask=false;
		isEcodesignEdit=false;
		isAssortEdit=false;
		isEditGateCMI=false;
		IsEditableOutC=false;
		IsEditableSumm=false;
		isTaskeditable=false;
		markTaskAccess =  false;
		isTaskViewable =  true;
		isCUandComplexity=false;
		isGlobalActionStandards=false;
		remainingChar=0;
		isChecked='';
		attachId='';
		charCount=0;
		countLimit=0;  
		showPre=true;
		showNext=true;
		showEcoDesign = false;
		isEditMarketPerformance=false;
		Apexpages.currentPage().getHeaders().put(IPM_ConstantUtils.UA_COMPATIBLE, IPM_ConstantUtils.IE_EDGE);
		projectResource=new list<IPM_Project_Resource__c>();
		projectId=ApexPages.currentPage().getParameters().get('Id');
		projDocSecId=ApexPages.currentPage().getParameters().get(PROJ_DOC_SEC_ID);
		ecoDesignStr = new List<String>();
		Frole=''; 
		Map<string,IPM_Gate_Document_Section_Access__c> gdSectionAccess = IPM_Gate_Document_Section_Access__c.getAll();
		for(IPM_Gate_Document_Section_Access__c userGDSectionAccess : gdSectionAccess.values()){
			if(string.isNotBlank(userGDSectionAccess.Name) && IPM_ConstantUtils.IPM_ROLE_BD_MARKETING.equals(userGDSectionAccess.Name) && string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c)){
				tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c;
				
				if(string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c)){
					tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c+','+userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c;
				}
				string[] docSectionAccess = tempDocSectionAccess.split(',');
				
				for(string accessToSet: docSectionAccess){
					bdSectionsSet.add(accessToSet);
				} 
			}
			else if(string.isNotBlank(userGDSectionAccess.Name) && IPM_ConstantUtils.FUNCTIONAL_ROLE_CD.equals(userGDSectionAccess.Name) && string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c)){
				tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c;
				
				if(string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c)){
					tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c+','+userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c;
				}
				string[] docSectionAccess = tempDocSectionAccess.split(',');
				
				for(string accessToSet: docSectionAccess){
					cdSectionsSet.add(accessToSet);
				}
			}
			else if(string.isNotBlank(userGDSectionAccess.Name) && IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI.equals(userGDSectionAccess.Name) && string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c)){
				tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c;
				
				if(string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c)){
					tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c+','+userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c;
				}
				string[] docSectionAccess = tempDocSectionAccess.split(',');
				
				for(string accessToSet: docSectionAccess){
					cmiSectionsSet.add(accessToSet);
				}
			}
			else if(string.isNotBlank(userGDSectionAccess.Name) && IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE.equals(userGDSectionAccess.Name) && string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c)){
				tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c;
				
				if(string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c)){
					tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c+','+userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c;
				}
				string[] docSectionAccess = tempDocSectionAccess.split(',');
				
				for(string accessToSet: docSectionAccess){
					financeSectionsSet.add(accessToSet);
				}
			}
			else if(string.isNotBlank(userGDSectionAccess.Name) && IPM_ConstantUtils.USER_FUNCTON_PL.equals(userGDSectionAccess.Name) && string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c)){
				tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c;
				
				if(string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c)){
					tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c+','+userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c;
				}
				
				string[] docSectionAccess = tempDocSectionAccess.split(',');
				for(string accessToSet: docSectionAccess){
					plSectionsSet.add(accessToSet);
				}
			}
			else if(string.isNotBlank(userGDSectionAccess.Name) && IPM_ConstantUtils.FUNCTIONAL_ROLE_RD.equals(userGDSectionAccess.Name) && string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c)){
				tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c;
				
				if(string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c)){
					tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c+','+userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c;
				}
				string[] docSectionAccess = tempDocSectionAccess.split(',');
				
				for(string accessToSet: docSectionAccess){
					rndSectionsSet.add(accessToSet);
				}
			}
			else if(string.isNotBlank(userGDSectionAccess.Name) && IPM_ConstantUtils.FUNCTIONAL_ROLE_TYPE_SUPPLY_CHAIN.equals(userGDSectionAccess.Name) && string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c)){
				tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c;
				
				if(string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c)){
					tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c+','+userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c;
				}
				
				string[] docSectionAccess = tempDocSectionAccess.split(',');
				for(string accessToSet: docSectionAccess){
					scSectionsSet.add(accessToSet);
				}
			}
			else if(string.isNotBlank(userGDSectionAccess.Name) && IPM_ConstantUtils.TEAM_TECHNICAL_PROJECT_LEADER.equals(userGDSectionAccess.Name) && string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c)){
				tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c;
				
				if(string.isNotBlank(userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c)){
					tempDocSectionAccess=userGDSectionAccess.IPM_Gate_Document_Section_Access_1__c+','+userGDSectionAccess.IPM_Gate_Document_Section_Access_2__c;
				}
				string[] docSectionAccess = tempDocSectionAccess.split(',');
				
				for(string accessToSet: docSectionAccess){
					tplSectionsSet.add(accessToSet);
				}
			}
		}
		
		//Fetching Project Document Section
		projDocSec=[SELECT Id,IPM_CMI_Selected_Test_Concepts__c,IPM_Summary_Character_Remaining__c,IPM_Project_Document__c,IPM_User_Id__c,Is_IPM_Global_Consolidated__c,IPM_Section_Sequence_Number__c,IPM_Project_L_eader_Email__c,IPM_DocSec_Project_Leader__c,IPM_Section_Sequence__c,IPM_GateHistory_Date__c,IPM_PDPHistoty_Date__c,IPM_GateHistory__c,IPM_PDPHistoty__c,
		IPM_Section_Name__c,IPM_Section_Help_Text_Long__c,IPM_FunctionalRole__c,IPM_Negotiable__c,IPM_Notify_Team__c,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.External_ID__c,IPM_Section__r.IPM_Section_Help_Text__c,
		IPM_PDP_Document_Summary__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c ,IPM_Master_Section_External_Id__c,IPM_Section__r.IPM_Character_Limit__c
		FROM IPM_Project_Document_Section__c WHERE Id=:String.escapeSingleQuotes(String.valueOf(projDocSecId)) LIMIT 1];
		
		projDoc=[SELECT Id,Name,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,
		IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c 
		FROM IPM_Project_Document__c 
		WHERE IPM_Project__c=:String.escapeSingleQuotes(String.valueOf(project.Id)) AND Id=:String.escapeSingleQuotes(String.valueOf(projDocSec.IPM_Project_Document__c))]; 
		
		//For Character Count on Gate Document Summary
		projSectionList=new list<IPM_Project_Document_Section__c>();
		
		if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
		{
			countOfCountries=[SELECT count() FROM IPM_Country__c WHERE isActive__c=true AND IPM_Project__c=:project.id];
		}
		else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
		{
			countOfCountries=[SELECT count() FROM IPM_Country__c WHERE isActive__c=true AND IPM_Regional_Project__c=:project.id];
		}
		else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
		{
			countOfCountries=0;
		}
		
		charcterCount();
		/* Added for Eco Design */
		projectType = IPM_Utils.retrieveProjectType(project);
		if(projectType != null && String.isNotBlank(projectType.IPM_EcoDesign_Document_Name__c)) {
			ecoDesignStr = projectType.IPM_EcoDesign_Document_Name__c.split(',');
			for(String ecoDesignSec : ecoDesignStr){
				if(ecoDesignSec.equalsignoreCase(projDocSec.IPM_Master_Section_External_Id__c)){
					showEcoDesign = true;  
					break;     
				}
			}
		}
		/* Added for Eco Design */
		
		//Getting Functional Role
		if(projDocSec.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_BD){
			Frole=String.escapeSingleQuotes(IPM_ConstantUtils.IPM_ROLE_BD);
		}
		else if(projDocSec.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_RnD){
			Frole=String.escapeSingleQuotes(IPM_ConstantUtils.FUNCTIONAL_ROLE_RD);
		}
		else if(projDocSec.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_SC){
			Frole=String.escapeSingleQuotes(IPM_ConstantUtils.FUNCTIONAL_ROLE_TYPE_SUPPLY_CHAIN);
		}
		else {
			Frole=projDocSec.IPM_FunctionalRole__c;
		} 
		
		//Getting Project Resources
		projectResource=[SELECT IPM_Role_Type__c,IPM_Member_Email__c,IPM_User__r.Id,IPM_User__r.Email,IPM_Res_Email__c,IPM_send_an_email__c,IPM_User__c,LastModifiedBy.Email,IPM_Project_Document_Section__r.LastModifiedBy.Email
		FROM IPM_Project_Resource__c 
		WHERE IPM_Project__c=:projectId and IPM_Role_Type__c=:Frole];
		
		sectionName=projDocSec.IPM_Section_Name__c;
		
		//Getting Attachments
		attachmentList=[SELECT Id,Name,ParentId,Description FROM Attachment WHERE ParentId=:projDocSecId];
		
		if(sectionEditableOnStatus.contains(projdoc.IPM_Document_Status__c))
		{
			//Getting Current User Functional Role & Type
			getIpmuserType();
		}
		
		//Getting Associated Tasks
		if(project.IPM_PM_Approach__c==IPM_ConstantUtils.IPM_APPROACH_INTERNAL){
			getAssociatedTask();
		}
		else{
			isTaskeditable=false;
		}
		
		pagination();
		
		for(IPM_Project_Document_Section__c proDocSec:projectSections){
			firstSec=proDocSec.IPM_Section_Sequence__c;
			break;
		}
		
		for(IPM_Project_Document_Section__c proDocSec:projectSections){
			lastSec=proDocSec.IPM_Section_Sequence__c;
		}
		
		if(projDocSec.IPM_Section_Sequence__c==firstSec){
			showPre=false;
		}
		else if(projDocSec.IPM_Section_Sequence__c==lastSec){
			showNext=false;
		}
		renderedConditions();
		
	}
	
	/****************************************************************************************************************************************************************
	* @description Get user type with access permission     
	*/
	public void getIpmuserType(){ 
		list<IPM_Project_Resource__c>lstProuser=[SELECT IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c 
												 FROM IPM_Project_Resource__c 
												 WHERE IPM_Project__c=:projectId AND IPM_User__c=:userinfo.getuserid() AND IPM_Project__r.Is_Archieved__c=false limit 100];
		userRolesSet=new Set<string>();
		if(!lstProuser.isEmpty()){
			for(IPM_Project_Resource__c projResource:lstProuser){
				if(!userRolesSet.contains(projResource.IPM_Role_Type__c)){
					userRolesSet.add(projResource.IPM_Role_Type__c);
				}
				if(projResource.IPM_Project_Role_Owner__c && Frole.equals(projResource.IPM_Role_Type__c))
				{
					isCreateTask=true;
					isTaskeditable =true;
					markTaskAccess = true;
				}
			}
			
			//To get BB/BD Users Permission
			getBBBDUserPermission();
			
			//To get CMI User Permission
			getCMIUserPermission();
			
			//To get RD/CD Users Permission
			getRDCDUserPermission();
			
			//To get Supply Chain/Finance Users Permission
			getFinSCUserPermission();
		}
		getUserTypeSection();
	}
	
	/****************************************************************************************************************************************************************
	* @description Get RD/CD User permission for editing the section    
	*/
	@testVisible private void getRDCDUserPermission(){
		if(userRolesSet.contains(IPM_ConstantUtils.FUNCTIONAL_ROLE_CD) && (cdSectionsSet.contains(projDocSec.IPM_Section__r.External_ID__c) ||  (projDocSec.IPM_Section_Name__c.Equals(IPM_ConstantUtils.IPM_CUTOMER_OPPORTUNITY) && 
							!project.IPM_Phase__c.Equals(IPM_ConstantUtils.PHASE_MARKET_READY))))
		{
			IsEditableSumm=true;
			IsEditableOutC=true;
			isAssortEdit=true;
		}
		if(userRolesSet.contains(IPM_ConstantUtils.FUNCTIONAL_ROLE_RD) && !project.IPM_Phase__c.Equals(IPM_ConstantUtils.PHASE_MARKET_READY) && rndSectionsSet.contains(projDocSec.IPM_Section__r.External_ID__c))
		{
			IsEditableSumm=true;
			IsEditableOutC=true;
			isEcodesignEdit=true;
		}
	}
	
	/****************************************************************************************************************************************************************
	* @description Get SC/Finance User permission for editing the section    
	*/
	@testVisible private void getFinSCUserPermission(){
		if(userRolesSet.contains(IPM_ConstantUtils.FUNCTIONAL_ROLE_TYPE_SUPPLY_CHAIN)){
			if(scSectionsSet.contains(projDocSec.IPM_Section__r.External_ID__c))
			{
				IsEditableSumm=true;
				IsCRRTEditable=true;
				IsEditableOutC=true;
			}
			if(userRolesSet.contains(Frole)){
				IsEditableOutC=true;
				IsCRRTEditable=true;
			}
		}
		if(userRolesSet.contains(IPM_ConstantUtils.FUNCTIONAL_ROLE_Finance)){
			if(financeSectionsSet.contains(projDocSec.IPM_Section__r.External_ID__c))
			{
				IsEditableSumm=true;
				IsEditableOutC=true;
				isGlobalActionStandards=true;
			}
			if(IPM_ConstantUtils.MONITONING_PER_EXTERNAL_ID.equals(projDocSec.IPM_Section__r.External_ID__c)){
				isEditMarketPerformance=true;
			}
		}
	}
	
	/****************************************************************************************************************************************************************
	* @description Get BB/BD User permission for editing the section    
	*/
	@testVisible private void getBBBDUserPermission(){
		if(userRolesSet.contains(IPM_ConstantUtils.FUNCTIONAL_ROLE_BD) && !project.IPM_Phase__c.Equals(IPM_ConstantUtils.PHASE_MARKET_READY)){
			if(bdSectionsSet.contains(projDocSec.IPM_Section__r.External_ID__c) || ((projDocSec.IPM_Section__r.External_ID__c.Equals(IPM_ConstantUtils.IPM_ROLLOUT_PLANS) || projDocSec.IPM_Section__r.External_ID__c.Equals(IPM_ConstantUtils.IPM_MILESTONES_DOC)) &&  !project.IPM_Phase__c.Equals(IPM_ConstantUtils.PHASE_IDEAS)))
			{
				IsEditableSumm=true;
				IsEditableOutC=true;
				IsCRRTEditable=true;
				isEditGateCMI=true;
			}
			if((bdSectionsSet.contains(projDocSec.IPM_Section__r.External_ID__c) && IPM_ConstantUtils.KEY_ISSUES_NEEDING_FOCUS_IN_GATE_MEETING.equals(projDocSec.IPM_Section__r.External_ID__c) && !project.IPM_Project_Type__c.equals(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL))){
				IsEditableSumm=false;
				IsEditableOutC=false;
			}
			if(IPM_ConstantUtils.IPM_PACK_GRAPHICS.equals(projDocSec.IPM_Section__r.External_ID__c)){
				IsEditableSumm=false;
			}
		}
		if(userRolesSet.contains(IPM_ConstantUtils.FUNCTIONAL_ROLE_BB) && project.IPM_Phase__c.Equals(IPM_ConstantUtils.PHASE_MARKET_READY) && !projDocSec.IPM_Section__r.External_ID__c.Equals(IPM_ConstantUtils.IPM_GATEKEEPE_CHECKLIST)){
			IsEditableOutC=true;
			IsEditableSumm=true;
			IsCRRTEditable=true;
			isAssortEdit=true;
			isEditGateCMI=true;
			isEcodesignEdit=true;
		}
	}
	
	/****************************************************************************************************************************************************************
	* @description Get CMI User permission for editing the section    
	*/
	@testVisible private void getCMIUserPermission(){
		if(userRolesSet.contains(IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI) && !project.IPM_Phase__c.Equals(IPM_ConstantUtils.PHASE_MARKET_READY)){
			if(cmiSectionsSet.contains(projDocSec.IPM_Section__r.External_ID__c))
			{
				IsEditableSumm=true;
				IsEditableOutC=true;
				isEditGateCMI=true;
			}
			//Special scenario 
			if(IPM_ConstantUtils.CONSUMER_EVIDENCE_COMMUNICATION.equals(projDocSec.IPM_Section__r.External_ID__c)){
				IsEditableOutC=true;
			}
			if(IPM_ConstantUtils.MONITONING_PER_EXTERNAL_ID.equals(projDocSec.IPM_Section__r.External_ID__c)){
				
				isEditMarketPerformance=true;
			}
		}
		//special case
		if(userRolesSet.contains(IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI) && project.IPM_Phase__c.Equals(IPM_ConstantUtils.PHASE_MARKET_READY) && IPM_ConstantUtils.MONITONING_PER_EXTERNAL_ID.equals(projDocSec.IPM_Section__r.External_ID__c)){
			isEditMarketPerformance=true;
		}
	}
	
	/****************************************************************************************************************************************************************
	* @description Get user type with access permission     
	*/
	private void getUserTypeSection(){
		integer ecoDesignUserCount=0;
		ecoDesignUserCount=[SELECT count() FROM IPM_Project_Resource__c 
							WHERE IPM_User__c=:userinfo.getuserid() AND IPM_Project__c=:projectId AND IPM_Role_Type__c!=:IPM_ConstantUtils.IPM_ROLE_GUEST AND IPM_Role_Type__c!=Null LIMIT 1];
		if(ecoDesignUserCount>0){
			isEcodesignEdit=true;
		}
		CountProuser=[SELECT count() FROM IPM_Project_Resource__c 
							  WHERE IPM_Project__c=:projectId and IPM_Role_Type__c=:Frole AND IPM_Project__r.Is_Archieved__c=false limit 1];
		lstofuser=new list<IPM_Project__c>(); 
		lstofuser=[SELECT IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c 
				   FROM IPM_Project__c 
				   WHERE id=:projectId AND Is_Archieved__c=false limit 1];
		if(!lstofuser.isEmpty()&& !project.IPM_Phase__c.Equals(IPM_ConstantUtils.PHASE_MARKET_READY)){
			if((lstofuser[0].IPM_Project_Leader__c!=null && lstofuser[0].IPM_Project_Leader__c==userinfo.getuserid()) || 
					(lstofuser[0].Deputy_Project_Leader__c!=null && lstofuser[0].Deputy_Project_Leader__c==userinfo.getuserid())){
				if(plSectionsSet.contains(projDocSec.IPM_Section__r.External_ID__c) || ((projDocSec.IPM_Section__r.External_ID__c.Equals(IPM_ConstantUtils.IPM_ROLLOUT_PLANS) 
								|| projDocSec.IPM_Section__r.External_ID__c.Equals(IPM_ConstantUtils.IPM_MILESTONES_DOC)) &&  project.IPM_Phase__c.Equals(IPM_ConstantUtils.PHASE_IDEAS)))
				{
					IsEditableOutC=true;
				}
				if(CountProuser==0){
					IsEditableOutC=true;
					isEditGateCMI=true;
					IsCRRTEditable=true;
					isAssortEdit=true;
					
				}
				isTaskeditable=true;   
				IsEditableSumm=true;
				markTaskAccess = true;
				isCreateTask=true;
				isEcodesignEdit=true;
				isEditMarketPerformance=true;
				isGlobalActionStandards=true;
			}
			
			else if(lstofuser[0].IPM_Technical_Project_Leader__c!=null && lstofuser[0].IPM_Technical_Project_Leader__c==userinfo.getuserid()){
				if(tplSectionsSet.contains(projDocSec.IPM_Section__r.External_ID__c)){
					IsEditableSumm=true;
					IsEditableOutC=true;
				}
				isCreateTask=true;
				isTaskeditable=true;
				markTaskAccess = true;
				isEcodesignEdit=true;
			}
			else if(lstofuser[0].IPM_Project_Gatekeeper__c!=null && lstofuser[0].IPM_Project_Gatekeeper__c==userinfo.getuserid()){
				isEcodesignEdit=true;
			}
		}
		//To get Central Team User permission
		getCentralUserPermission();
	}
	
	/****************************************************************************************************************************************************************
	* @description Get user type with access permission     
	*/
	private void getCentralUserPermission(){
		//Market Ready Gate
		if(!lstofuser.isEmpty() && project.IPM_Phase__c.Equals(IPM_ConstantUtils.PHASE_MARKET_READY)){
			if((lstofuser[0].IPM_Project_Leader__c!=null && lstofuser[0].IPM_Project_Leader__c==userinfo.getuserid()) || 
					(lstofuser[0].Deputy_Project_Leader__c!=null && lstofuser[0].Deputy_Project_Leader__c==userinfo.getuserid())){
				IsEditableSumm=true;
				isEditMarketPerformance=true;
				isGlobalActionStandards=true;
				if(CountProuser==0){
					IsEditableOutC=true;
					isEditGateCMI=true;
					IsCRRTEditable=true;
					isAssortEdit=true;
					isEcodesignEdit=true;
				}
			}
		}
		
		//security for central team and BP users
		IPM_CustomPermission cpr = new IPM_CustomPermission();
		boolean isCentralTeam=false;
		boolean isBPUser=false;
		isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
		isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
		if(isCentralTeam || isBPUser){
			IsEditableOutC=true;isEditGateCMI=true;IsCRRTEditable=true;isAssortEdit=true;isEcodesignEdit=true;isTaskeditable=true;   
			IsEditableSumm=true;markTaskAccess=true;isCreateTask=true;isEditMarketPerformance=true;isGlobalActionStandards=true;
			
		}
	}
	/****************************************************************************************************************************************************************
	* @description Saving project document section
	* @return: null  
	*/
	public pageReference save(){ 
		showmsg=true;
		summary='';
		status=true;
		if(projDocSec.IPM_Gate_Document_Summary__c!=null && projDocSec.IPM_Section__r.IPM_Character_Limit__c!=null){
			summary=projDocSec.IPM_Gate_Document_Summary__c;
			summary=summary.replaceAll(IPM_ConstantUtils.SPECIAL_CHARACTERS,'');
			projDocSec.IPM_Summary_Character_Remaining__c=projDocSec.IPM_Section__r.IPM_Character_Limit__c-summary.length();        
		}
		else{
			projDocSec.IPM_Summary_Character_Remaining__c=projDocSec.IPM_Section__r.IPM_Character_Limit__c;
		}
		charcterCount();
		
		
		//Fetching List of Questions to Check Filled-In or Not
		checkGKCFilled();
		checkOTIFFilled(); 
		checkRMPFilled();
		if((project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && project.IPM_Phase__c==IPM_ConstantUtils.PHASE_IDEAS) || project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
		{
			checkCMICompleted();
		}
		//Getting Gate Summary and Outcome Summary Saved Date and Time
		getSummaryInfo();
		try{
			if(!status){
				if(String.IsNotBlank(projDocSec.IPM_Gate_Document_Summary__c) && projDocSec.IPM_Negotiable__c && IsEditableSumm){
					projDocSec.IPM_Section_Status__c=IPM_ConstantUtils.SECTION_STATUS_FILLED;
				}
				else {
					projDocSec.IPM_Section_Status__c=IPM_ConstantUtils.STATUS_NOT_STARTED;
				}
			}
			if(status && IsEditableSumm){
				if(String.IsNotBlank(projDocSec.IPM_Gate_Document_Summary__c) && projDocSec.IPM_Negotiable__c){
					projDocSec.IPM_Section_Status__c=IPM_ConstantUtils.SECTION_STATUS_FILLED;
					showmsg=false;
				}
				if(String.IsNotBlank(projDocSec.IPM_Gate_Document_Summary__c) && !projDocSec.IPM_Negotiable__c && summary.length()>=15){
					projDocSec.IPM_Section_Status__c=IPM_ConstantUtils.SECTION_STATUS_FILLED;
					showmsg=false;
				}
			}
			
			if(String.IsNotBlank(projDocSec.IPM_PDP_Document_Summary__c) && projDocSec.IPM_PDP_Document_Summary__c.length() >=15)
			{
				projDocSec.IPM_Functional_Input_Status__c=IPM_ConstantUtils.STATUS_STARTED;
			}
			
			update projDocSec;
			IPM_Project_Document_Section__c testSection1 = [Select id, IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where id =: projDocSec.Id];
			
			
			if(projDoc.IPM_Document_Status__c==IPM_ConstantUtils.STATUS_NOT_STARTED || projDoc.IPM_Document_Status__c==IPM_ConstantUtils.DOCUMENT_STATUS_POSTPONED){
				projDoc.IPM_Document_Status__c=IPM_ConstantUtils.STATUS_IN_PROGRESS;
			}   
			update projDoc;

			//To Update Project FilledIn Percentage
			updateProjectFilledin();
			
			if(projDocSec.IPM_Negotiable__c != null && projDocSec.IPM_Negotiable__c){
				showmsg=false;
			}
			if(showmsg){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.IPM_Section_Not_Filled));
				return null;

			}
			return redirectBack();
		}
		catch(Exception ex){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
			ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECT_DOCUMENT_SECTION_CONTROLLER,
			IPM_ConstantUtils.ACCESS_SAVE,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
			return null;       
		}
	}
	
	/****************************************************************************************************************************************************************
	* @description For getting gate summary details 
	*/
	public void getSummaryInfo(){
		if(IsGateSave==IPM_ConstantUtils.GATE){
			DateTime dT = System.now();
			projDocSec.IPM_GateHistory_Date__c=dT;
			projDocSec.IPM_GateHistory__c=Userinfo.getname();
		}
		else{
			DateTime dT = System.now();
			projDocSec.IPM_PDPHistoty_Date__c=dT;
			projDocSec.IPM_PDPHistoty__c=Userinfo.getname() ;
			showmsg=false;
		}
	}
	
	/****************************************************************************************************************************************************************
	* @description For updating Filled In percentage in project 
	*/
	public void updateProjectFilledin(){
		String idstr;
		Id vid;
		List<IPM_Project_Resource__c> lstupdatedResource=new List<IPM_Project_Resource__c>();
		if(String.IsNotBlank(String.valueOf(isChecked))){
			if(!projectResource.isEmpty()){
				for(IPM_Project_Resource__c ProRes:projectResource){
					idstr=ProRes.IPM_User__r.Id;
					vid= idstr;
					idstr =vid;
					if(idstr!=UserInfo.getUserId()){
						IPM_Project_Resource__c updatedResource=new IPM_Project_Resource__c();
						updatedResource.id=ProRes.id;
						
						updatedResource.IPM_Project_Document_Section__c = projDocSecId;
						updatedResource.IPM_Res_Email__c=ProRes.IPM_User__r.Email;                     
						updatedResource.IPM_send_an_email__c=true;
						
						lstupdatedResource.add(updatedResource);  
					}
				}
			} 
			
			idstr=projDocSec.IPM_User_Id__c;
			vid= idstr;
			idstr =vid;
			
			if(idstr!=UserInfo.getUserId()){
				projDocSec.IPM_Notify_Team__c=true;
				projDocSec.IPM_Project_L_eader_Email__c=projDocSec.IPM_DocSec_Project_Leader__c;
				update projDocSec;
			}
			
			if(!lstupdatedResource.isEmpty()){
				update lstupdatedResource;
				
				IPM_Project_Document_Section__c testSection = [Select id, IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where id =: projDocSec.Id];
				
				lstupdatedResource.clear();
			}
		}
		
		//For Storing Filled-In Percentage Calculation in Project Object 
		Integer NonNegotiableCount=[SELECT count() FROM IPM_Project_Document_Section__c WHERE IPM_Default_Section__c=true AND IPM_Project_Document__c=:projDoc.Id AND IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_HEADER AND 
		IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER AND IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c!=:IPM_ConstantUtils.APPENDIX];
		Integer removeoptional=[SELECT count() FROM IPM_Project_Document_Section__c WHERE IPM_Section_Status__c=:IPM_ConstantUtils.SECTION_STATUS_FILLED AND IPM_Project_Document__c=:projDoc.Id AND  IPM_Default_Section__c=true AND 
		IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_HEADER AND IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER AND IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c!=:IPM_ConstantUtils.APPENDIX];
		if(NonNegotiableCount!=0){
			Decimal FilledinPer=math.round((Decimal.valueof(removeoptional)/decimal.valueof(NonNegotiableCount))*100);
			project.IPM_FilledIn_Percentage__c=FilledinPer;
		}
		update project;
	}
	
	/****************************************************************************************************************************************************************
	* @description For Cancelling the Current Input 
	@return: PageReference url
	*/
	public PageReference cancel(){
		PageReference url;
		url=redirectBack();
		return url;
	}

	/****************************************************************************************************************************************************************
	* @description For deleting the attachments     
	*/
	public void delet(){
		Attachment a=new Attachment();
		try{
			a=[SELECT Id FROM Attachment WHERE Id=:attachId];
			//To Check CRUD
			if (Attachment.sObjectType.getDescribe().isDeletable()){
				delete a;
			}
		}
		catch(Exception ex){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
			ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECT_DOCUMENT_SECTION_CONTROLLER,
			'delet',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);    
			
		}
		attachmentList=[SELECT Id,Name,ParentId,Description FROM Attachment WHERE ParentId=:projDocSecId];
	}

	/****************************************************************************************************************************************************************
	* @description For Getting Tasks Associated with Section        
	*/
	public void getAssociatedTask(){
		lsttask=new list<IPM_Task__c >();
		list<IPM_Task__c > lstUpdatedtask = [SELECT IPM_Task_Name__c, IPM_Phase__c,IPM_Due_Date1__c, IPM_Project_Document_Section__r.IPM_Section_Name__c,
		IPM_Project_Document_Section__r.IPM_Section_Sequence__c, IPM_Assignee__r.Name, IPM_Project__c,IPM_Completed_Date__c,
		IPM_Completed__c,IPM_Task_Type__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c,LastModifiedBy.Name,IPM_Master_Task__c,
		IPM_Assignee__c,IPM_Master_Task__r.IPM_Multiple_Functional_Role__c,IPM_Master_Task__r.IPM_Function__c,IPM_Function__c 
		FROM IPM_Task__c 
		WHERE IPM_Project__c=:projectId AND IPM_Project_Document_Section__r.IPM_Section_Name__c=:sectionName AND IPM_Function__c=:Frole AND IPM_Active__c = true order by IPM_Due_Date1__c,IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Task_Name__c ASC ];
		lsttask = IPM_TaskHelper.removeDuplicateTaskForUser(lstUpdatedtask);
		countOfTask =  [SELECT count() FROM IPM_Task__c WHERE IPM_Project__c=:projectId and IPM_Project_Document_Section__r.IPM_Section_Name__c=:sectionName and IPM_Project_Document_Section__r.IPM_Negotiable__c=true];                                      
	}

	/****************************************************************************************************************************************************************
	* @description For Deleting task        
	*/
	public void TaskDelete(){
		getAssociatedTask();
		try{
			delete [SELECT id FROM IPM_Task__c WHERE id=:taskid];
		}
		catch(Exception ex){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
			ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECT_DOCUMENT_SECTION_CONTROLLER,
			'TaskDelete',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);    
		}
		getAssociatedTask();
	} 

	/****************************************************************************************************************************************************************
	* @description For updating task        
	*/
	Public void UpdateTask(){
		try{
			List<IPM_Task__c> updatedTaskList = new  List<IPM_Task__c>();
        	
            List<IPM_Task__c> tObj = [SELECT IPM_Completed__c, IPM_Completed_Date__c,IPM_Master_Task__c,IPM_Assignee__c,IPM_Project__c FROM IPM_Task__c WHERE Id =:taskid limit 50000];
            
            Boolean isTaskComplete = tObj[0].IPM_Completed__c;
            tObj[0].IPM_Completed__c = isTaskComplete == true ? false : true; 
            tObj[0].IPM_Completed_Date__c = isTaskComplete == true ? null :system.today() ;
            
            updatedTaskList = IPM_TaskHelper.completeOtherRelatedTasks(tObj[0]);
            updatedTaskList.add(tObj[0]);
            
            update updatedTaskList;
		}
		catch(Exception ex){    
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
			ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECT_DOCUMENT_SECTION_CONTROLLER,
			'UpdateTask',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);    

		}
	}

	/****************************************************************************************************************************************************************
	* @description For Notifying User (Action Function)     
	*/
	public void IsNotify(){
		//Method used in IPM_ProjectDocumentSectionEditor page
	}

	/****************************************************************************************************************************************************************
	* @description For navigate to next and previous page       
	*/
	public pagereference pagination(){
		projectSections = new List<IPM_Project_Document_Section__c>();
		Id secId = Null;//for storing section id
		Integer i=0;
		List<IPM_Project_Document_Section__c> projectSectionsList =new List<IPM_Project_Document_Section__c>();
		try{
			IPM_Project__c projObj = IPM_Utils.getCurrentPhase(projectId);
			currPhase = projObj.IPM_Phase__c;
		}
		catch(exception ex) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
			ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECT_DOCUMENT_SECTION_CONTROLLER,
			'UpdateTask',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);    
		}
		
		if(IPM_Utils.phaseGateDocumentMap.containsKey(currPhase)) {
			currGate = IPM_Utils.phaseGateDocumentMap.get(currPhase);
		}
		
		projectSectionsList=[SELECT Id,IPM_Section_Name__c, IPM_Section_Sequence__c, 
		IPM_Project_Document__r.IPM_Project__c, IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c, IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c ,IPM_Master_Section_External_Id__c FROM IPM_Project_Document_Section__c 
		WHERE IPM_Project_Document__r.IPM_Project__c = :String.escapeSingleQuotes(projectId) AND
		IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_HEADER
		AND IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER AND        
		IPM_Project_Document__r.IPM_GateDocuments__c = :projDoc.IPM_GateDocuments__c AND IPM_Default_Section__c = true ORDER BY IPM_Section_Sequence__c];
		
		for(IPM_Project_Document_Section__c eachProSection : projectSectionsList) {
			projectSections.add(eachProSection);
		}
		
		if(String.IsNotBlank(String.valueOf(isFlagedNext))){
			for(IPM_Project_Document_Section__c proDocSec:projectSections){
				secId=proDocSec.Id;
				if(i==1){
					break;
				}
				if(proDocSec.Id==projDocSecId){
					i++; 
				}
			}
			if(String.IsNotBlank(String.valueOf(secId))){
				showNext=true;
				PageReference newSec; 
				newSec=Page.IPM_ProjectDocumentSectionEditor;
				newSec.getParameters().put('id',projectId);
				newSec.getParameters().put(PROJ_DOC_SEC_ID,secId);
				newSec.setRedirect(true);
				return newSec;
			}
		}
		else if(String.IsNotBlank(String.valueOf(isFlagedPre))){
			i=0;
			for(IPM_Project_Document_Section__c proDocSec:projectSections){
				if(proDocSec.Id==projDocSecId){
					i--; 
				}
				if(i<0){
					break;
				}
				secId=proDocSec.Id;
			}
			if(String.IsNotBlank(String.valueOf(secId))){
				showPre=true;
				PageReference newSec; 
				newSec=Page.IPM_ProjectDocumentSectionEditor;
				newSec.getParameters().put('id',projectId);
				newSec.getParameters().put(PROJ_DOC_SEC_ID,secId);
				newSec.setRedirect(true);
				return newSec; 
			}
		}  
		return null; 
	}
	
	/****************************************************************************************************************************************************************
	* @description For getting list options       
	*/
	public List<SelectOption> getSecOption() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('Go to Section','Go to Section'));
		
		for(IPM_Project_Document_Section__c proDocSec:projectSections){
			options.add(new SelectOption(proDocSec.Id,proDocSec.IPM_Section_Sequence__c +' '+proDocSec.IPM_Section_Name__c ));
		}
		return options;
	}

	/****************************************************************************************************************************************************************
	* @description For navigating to list options       
	*/
	public pagereference lstPagination(){
		If(!String.isBlank(projDocSecId))   {       
			PageReference newSec; 
			newSec=Page.IPM_ProjectDocumentSectionEditor;
			newSec.getParameters().put('id',projectId);
			newSec.getParameters().put(PROJ_DOC_SEC_ID,projDocSecId);
			newSec.setRedirect(true);
			return newSec;  
		}
		return null;
	} 
	
	/****************************************************************************************************************************************************************
	*   @description To check if gatekeeper questions are completed       
	*/
	public void checkGKCFilled(){      
		List<IPM_Questionnaire__c> ipmQuestionaires=new List<IPM_Questionnaire__c>();
		if(projDocSec.IPM_Master_Section_External_Id__c=='Gate_Keeper_Checklist'){          
			ipmQuestionaires = [SELECT id,IPM_GK_Answers__c,IPM_Project__c,IPM_Section_Sequence_Number__c,IPM_RQS_Gate_Type__c  FROM IPM_Questionnaire__c 
			WHERE IPM_RQS_Gate_Type__c=: projDoc.IPM_GateDocuments__c AND RecordTypeId=:Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.GATEKEEPER_CHECKLIST_RECORD_TYPE).RecordTypeId AND IPM_Project__c=:project.Id AND IPM_Project_Document_Section__c = null];
		}
		else{
			ipmQuestionaires = [SELECT id,IPM_GK_Answers__c,IPM_Project__c,IPM_Section_Sequence_Number__c,IPM_RQS_Gate_Type__c  FROM IPM_Questionnaire__c 
			WHERE IPM_Project_Document_Section__c=: projDocSec.Id];
		}       
		//For Making Section Filled-In
		for(IPM_Questionnaire__c ipmQuestionaire:ipmQuestionaires){
			if(ipmQuestionaire.IPM_GK_Answers__c<>IPM_ConstantUtils.GATEKEEPER_ANSWER && ipmQuestionaire.IPM_GK_Answers__c<> IPM_ConstantUtils.OPTION_NONE && ipmQuestionaire.IPM_GK_Answers__c<> null && ipmQuestionaire.IPM_GK_Answers__c<> ''){
				if(projDocSec.IPM_Gate_Document_Summary__c!=null && projDocSec.IPM_Gate_Document_Summary__c!='' && summary.length()>=15 && !projDocSec.IPM_Negotiable__c && ((projDocSec.IPM_Master_Section_External_Id__c != EXTERNAL_ID_ENVIRONMENTAL_IMPACT) || (projDocSec.IPM_Master_Section_External_Id__c == EXTERNAL_ID_ENVIRONMENTAL_IMPACT && project.IPM_Exists_AtLeast_OneAssmntPerEICountry__c && IPM_ProjectCountryDetails.isProjectReadyToSyncToEcoDesign(project)) || (projDocSec.IPM_Master_Section_External_Id__c == EXTERNAL_ID_ENVIRONMENTAL_IMPACT && project.IPM_Exists_AtLeast_OneAssmntPerEICountry__c && !IPM_ProjectCountryDetails.isProjectReadyToSyncToEcoDesign(project)) )){
					projDocSec.IPM_Section_Status__c=IPM_ConstantUtils.SECTION_STATUS_FILLED;
					showmsg=false;
				}
				else if(projDocSec.IPM_Gate_Document_Summary__c!=null && projDocSec.IPM_Gate_Document_Summary__c!='' && projDocSec.IPM_Negotiable__c){
					projDocSec.IPM_Section_Status__c=IPM_ConstantUtils.SECTION_STATUS_FILLED;
					
					showmsg=false;
				}
				else{
					status=false;
				}
			}
			else{
				status=false;
			}
		}   
	}
	
	/****************************************************************************************************************************************************************
	*   @description To check if OTIF questions are completed       
	*/
	public void checkOTIFFilled(){
		//For Checking OTIF Questions
		List<IPM_Project_Document_Section_Content__c> ipmProjectDocumentSectionContents=[SELECT Id,IPM_OTIF_Measure__c,IPM_OTIF_Status__c 
		FROM IPM_Project_Document_Section_Content__c 
		WHERE IPM_Section_Id__c=:projDocSec.Id AND IPM_OTIF_Measure__c!=null];
		for(IPM_Project_Document_Section_Content__c otif:ipmProjectDocumentSectionContents){
			if(otif.IPM_OTIF_Status__c<> IPM_ConstantUtils.OPTION_NONE && otif.IPM_OTIF_Status__c<> null && otif.IPM_OTIF_Status__c<> ''){
				if(projDocSec.IPM_Gate_Document_Summary__c!=null && projDocSec.IPM_Gate_Document_Summary__c!='' && summary.length()>=15 && !projDocSec.IPM_Negotiable__c){
					projDocSec.IPM_Section_Status__c=IPM_ConstantUtils.SECTION_STATUS_FILLED;
					showmsg=false;
				}
				else if(projDocSec.IPM_Gate_Document_Summary__c!=null && projDocSec.IPM_Gate_Document_Summary__c!='' && projDocSec.IPM_Negotiable__c){
					projDocSec.IPM_Section_Status__c=IPM_ConstantUtils.SECTION_STATUS_FILLED;
					showmsg=false;
				}
				else{
					status=false;
				}
			}
			else{
				status=false;
			}
		}
	}
	
	/****************************************************************************************************************************************************************
	*   @description To check if RMP plan is completed      
	*/
	public void checkRMPFilled(){  
		// Risk Question Validation Check
		if(projDocSec.IPM_Master_Section_External_Id__c==IPM_ConstantUtils.RISK_SECTION){            
			List<IPM_Questionnaire__c> riskQuesList=new  List<IPM_Questionnaire__c>();
			riskQuesList=[SELECT Id,IPM_Charter_Comments__c,IPM_Charter_Score__c,IPM_Contract_Comments__c,IPM_Contract_Score__c,IPM_Market_Ready_Score__c,IPM_Market_Ready_Comments__c,IPM_Project_Document_Section__c,IPM_Project__c 
			FROM IPM_Questionnaire__c 
			WHERE (IPM_Active_RQS__c=true OR IPM_Is_Added_Question__c=true) AND IPM_Project__c=:projectId];
			for(IPM_Questionnaire__c risk:riskQuesList)
			{
				if((projDoc.IPM_GateDocuments__c==IPM_ConstantUtils.CHARTER_GATE && String.isBlank(risk.IPM_Charter_Comments__c) && risk.IPM_Charter_Score__c>=IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE) || 
						(projDoc.IPM_GateDocuments__c==IPM_ConstantUtils.CONTRACT_GATE && String.isBlank(risk.IPM_Contract_Comments__c) && risk.IPM_Contract_Score__c>=IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE) ||
						(projDoc.IPM_GateDocuments__c==IPM_ConstantUtils.MARKET_READY_GATE && String.isBlank(risk.IPM_Market_Ready_Comments__c) && risk.IPM_Market_Ready_Score__c>=IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE)){
					showmsg=true;
					status=false;
				}       
			}
		}
	}
	
	/****************************************************************************************************************************************************************
	*   @description To check if CMI Test is completed plan is completed      
	*/
	public void checkCMICompleted(){
		//For CMI Validation Check
		if(projDocSec.IPM_Master_Section_External_Id__c==IPM_ConstantUtils.CMI_SECTION){
			list<IPM_Gate_CMI__c>  gateCMIList= new list<IPM_Gate_CMI__c>();
			list<IPM_Project_Document_Section_Content__c> cmiList=new list<IPM_Project_Document_Section_Content__c>();
			gateCMIList=[SELECT Id,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c FROM IPM_Gate_CMI__c WHERE IPM_Project__c=:project.id];
			if(String.isNotBlank(projDocSecId)){
				cmiList=[SELECT Id,IPM_Gate_CMI__c,IPM_Gate_CMI__r.Gate__c,IPM_CMI_Result__c,IPM_CMI_Results_Acheived__c,IPM_CMI_Is_Free_Text__c FROM IPM_Project_Document_Section_Content__c WHERE IPM_Project_Document_Section__c=:projDocSecId and IPM_CMI_Is_Free_Text__c=false];
				for(IPM_Project_Document_Section_Content__c cmi:cmiList)
				{
					if((IPM_ConstantUtils.CHARTER_GATE==projDoc.IPM_GateDocuments__c && String.isBlank(cmi.IPM_CMI_Result__c)) ||
							(IPM_ConstantUtils.CONTRACT_GATE==projDoc.IPM_GateDocuments__c && IPM_ConstantUtils.CONTRACT_GATE==cmi.IPM_Gate_CMI__r.Gate__c && String.isBlank(cmi.IPM_CMI_Results_Acheived__c)) || 
							(IPM_ConstantUtils.CONTRACT_GATE==projDoc.IPM_GateDocuments__c && IPM_ConstantUtils.MARKET_READY_GATE==cmi.IPM_Gate_CMI__r.Gate__c && String.isBlank(cmi.IPM_CMI_Result__c)) || 
							(IPM_ConstantUtils.MARKET_READY_GATE==projDoc.IPM_GateDocuments__c && IPM_ConstantUtils.MARKET_READY_GATE==cmi.IPM_Gate_CMI__r.Gate__c && String.isBlank(cmi.IPM_CMI_Results_Acheived__c))){
						showmsg=true;
						status=false;
					}    
				}
				for(IPM_Gate_CMI__c gate:gateCMIList)
				{
					if(gate.IPM_Skip_Test__c && String.isBlank(gate.IPM_Skip_Test_Reason__c)){
						showmsg=true;
						status=false;
					}    
				}
			}
		}
	}
	
	public PageReference redirectBack(){
		PageReference url=Page.IPM_ProjectDocumentSectionEditor;
		
		projectId=ApexPages.currentPage().getParameters().get('Id');
		projDocSecId=ApexPages.currentPage().getParameters().get(PROJ_DOC_SEC_ID);
		
		url.getParameters().put('id',projectId); 
		url.getParameters().put(PROJ_DOC_SEC_ID,projDocSecId); 
		url.setRedirect(true);
		
		return url;
	}
	
	public void charcterCount(){
		if(projDocSec.IPM_Section__r.IPM_Character_Limit__c!=null){
			sectionCharLimit=Integer.valueof(projDocSec.IPM_Section__r.IPM_Character_Limit__c);  
		}
		if(projDocSec.IPM_Summary_Character_Remaining__c!=null){
			countLimit=Integer.valueof(projDocSec.IPM_Summary_Character_Remaining__c);
			remainingChar=countLimit;
		}
	} 
	
	@testVisible private void renderedConditions(){
		if((project.IPM_Project_Type__c.equals(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) && projDocSec.IPM_Master_Section_External_Id__c.equals(IPM_ConstantUtils.CU_AND_COMPLEXITY))
				||(!project.IPM_Project_Type__c.equals(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) && projDocSec.IPM_Master_Section_External_Id__c.equals(IPM_ConstantUtils.CU_AND_COMPLEXITY) && (project.IPMProject_Span__c.equals(IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL) 
						|| project.IPMProject_Span__c.equals(IPM_ConstantUtils.PROJECT_SPAN_LOCAL)|| project.IPM_Phase__c.equals(IPM_ConstantUtils.PHASE_IDEAS)))){
			isCUandComplexity=true;
		}
	}     
}