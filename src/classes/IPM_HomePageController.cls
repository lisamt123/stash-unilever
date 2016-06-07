/********************************************************************* 
*@Author:Cognizant
*@Date: september 2014
*@Description : To display the alertmessages and Taskcount or Project
*Referring in page ipmHome
************************************************************************/

public with sharing class IPM_HomePageController 
{
    public List<IPM_Project__History> lstprojecthistory {get;set;}  // To get the Project History Fields
    public Map<Id,IPM_Project__History> mapphistory {get; set;}  // Map the projectid with History Fields 
    public Map<String, String> alertMessageDueDatePast {get;set;} // Due date is in the past alert
    public Map<String, String> alertMessageDueDateApproaching{get; set;} // Due date is approaching alert
    public Map<String, String> alertMessageDueDateToday{get; set;} // Due date is today alert
    public Map<String, String> documentAlertMessageMap{get; set;} //Alert for approved with edits status
    public Map<Id,String> alertsOTIF {get;set;}//To display OTIF alerts
    public List<String> LstFinMisalignedMessage { get; set; }  // To get the Financial misaligned Alert Message
    public Map<String,String> rolloutProjectAlertMessageMap {get;set;}
    public Map<String,String> LstFinTLDMisalignedMessageMap { get; set; }  // To get the Financial TLD misaligned Alert Message
    public Map<String, String> finDataMissingAlertMessageMap{get; set;} 
    public Map<String,String> LstLocalFinTLDMisalignedMessageMap { get; set; }  // To get the Financial TLD misaligned Alert Message
    public List<String> LstFinTLDMisalignedMessage {get;set;}
    public List<String> BusinessCaseMessage {get;set;}
    public Map<String,String> BusinessCaseMessageMap { get; set; }
    public IPM_Project__c project {get; set;}  // To query the projectid 
    public List<IPM_Project_Rollout__c> lstprojectRollout{get;set;} // To query the Project Rollout
    public integer taskcount {get;set;}  // used for counting the no of tasks on the page
    public integer alertscount {get;set;}  // Used for no of alerts displayed on UI
    public Integer betFirstReleaseDueDate{get;set;}//number of days that the current date is due for first release BET.
    public Integer betFinalReleaseDueDate{get;set;}//number of days that the current date is due for final release BET.
    public List<String> betMsgFirstReleaseDueDate{get;set;}//BET due date first release message
    public List<String> betMsgFinalReleaseDueDate{get;set;}//BET due date final release message

    public integer overduetaskscount {get;set;}  // To count the Overdue Tasks
    public boolean isProjectEditable{get;set;}  // To know if the project is editable and to  naviagte to Projectid 
    public boolean isBossCardEditable{get;set;}  // To know if the bosscard is editable and to  naviagte to Bosscard record
    public Boolean isBosscard {get; set;}  // To check if the record is a Bosscard
    public string projectLabel{get;set;} // To check if the record is a project
    public Integer fastTrackCount{get;set;} //To count the no of fasttrack project
    public String ProjectId{get;set;}
    public Map<String,String> ProjectIdMap{get;set;}
    public String taskcountValue;
    public Map<String,String> currGateProjectMap{get;set;}
    private static final Integer DAY_VALUE_SEVEN = 7;
    private static final Integer DAY_VALUE_Fourteen = 14;
    private static final String PLANNED_STR='The planned ';
    private static final String DATEFORMAT ='dd MMMM yyyy';
    private static final String GATE_STR= 'gate';
    
    /***************************************************************
*@Description :Constructor to fetch the details of the Project
****************************************************************/
    
    public IPM_HomePageController()
    {
        isProjectEditable=false;
        isBossCardEditable=false;
        projectLabel='';
        alertscount=0;
        fastTrackCount=0;
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
        isBosscard=false;
        alertMessageDueDatePast = new Map<String, String>();
        alertMessageDueDateApproaching = new Map<String, String>();
        alertMessageDueDateToday = new Map<String, String>();
        ProjectIdMap = new Map<String, String>();
        documentAlertMessageMap = new Map<String, String>();
        finDataMissingAlertMessageMap = new Map<String, String>();
        betMsgFirstReleaseDueDate = new List<String>();
        betMsgFinalReleaseDueDate = new List<String>();
        currGateProjectMap = new Map<String, String>();
        getusertype();
        
        // To check the Count for Overdue Tasks
        
        overduetaskscount =[SELECT count() FROM IPM_Task__c WHERE IPM_Assignee__c =: UserInfo.getUserId() AND  IPM_Due_Date1__c <:System.today() And IPM_Completed__c = false LIMIT 50000];
            

        // To check the history of the Project field
        lstprojecthistory=[SELECT ParentId,Parent.IPM_Project_Name__c,Parent.Name,Parent.IPM_Fast_Track_Project__c FROM IPM_Project__History WHERE Field =: IPM_Utils.IPM_Fast_Track_Project AND CreatedDate >=: System.today()-DAY_VALUE_SEVEN and Parent.IPM_Project_Leader__c = : UserInfo.getUserId()
        LIMIT 50000];
        mapphistory=new Map<Id,IPM_Project__History>();
        for(IPM_Project__History ph:lstprojecthistory){
            if(!mapphistory.containsKey(ph.ParentId)){
                mapphistory.put(ph.ParentId,ph);
                fastTrackCount++;
            }
        }
        
        /***************************************************************
*@Description : This is to order the projectsNames
****************************************************************/
        
        List<IPM_Project__c> lstProjects =[Select Name,IPM_Project_Type__c,Rollout_Plan_Target_Launch_Date__c,IPMProject_Span__c,IPM_Bosscard_Status__c,IPM_Bosscard__r.IPM_Brand__c,IPMRegion__c,IPM_Bosscard__r.Name,
                                           IPM_Bosscard__r.IPM_Bosscard_Logo__c,IPM_Project_Logo__c,IPM_Brand__c,IPM_Category_Text__c,Deputy_Project_Leader__r.Name,IPM_Target_Launch_Dates__c,
                                           BET_TLD_First_Release_Date__c,BET_MS_First_Release_Date__c,IPM_Project_Leader__r.Name,BET_TLD_Final_Release_Date__c,BET_MS_Final_Release_Date__c,
                                            (SELECT IPM_Project_Name__c,IPM_Target_Launch_Dates__c,Rollout_Plan_Target_Launch_Date__c from IPM_Projects__r),
                                           (Select id,name,IPM_Project__c,Geography__r.Market_Type__c from IPM_Countries__r),IPM_Parent_Project__r.IPM_Target_Launch_Dates__c,IPM_Parent_Project__r.IPM_Project_Name__c,
                                           IPM_GateKeeping_Model__c ,IPM_CompanyCardText__c,IPM_FilledIn_Percentage__c,IPM_Phase__c,IPM_Project_Name__c FROM IPM_Project__c 
                                           WHERE  IPM_Project_Leader__c = : UserInfo.getUserId() and Is_Archieved__c = false Order By IPM_Project_Name__c LIMIT 50000];
        Map<id,String> projCountry = new Map<id,String>();
        Map<Id,date> ProjDueDateMap = new Map<Id,date>();
        for(IPM_Project__c proj : lstProjects){
        	
        	currGateProjectMap.put(proj.id,'');
        	IPM_Project_Type__c projectType = IPM_Utils.retrieveProjectType(proj);
        	
        	if(projectType !=  null)
        	{
        		currGateProjectMap.put(proj.id,projectType.IPM_Gate_Document__c);
	        	if(projectType.IPM_Gate_Document__c == null)
	        	{
	        		currGateProjectMap.put(proj.id,'');
	        	}
        	}	
            
            projCountry.put(proj.id,'false');
            if(proj.IPM_Countries__r != null && proj.IPM_Countries__r.isEmpty()){
                projCountry.put(proj.id,'empty');   
            }
            else{
                for(IPM_Country__c country : proj.IPM_Countries__r){
                    if(country.Geography__r.Market_Type__c ==  IPM_ConstantUtils.MARKETTYPE_DEVELOPED){
                        projCountry.put(proj.id,'true');        
                    }
                }
            }
        }
        Id recordtypeid;
        if(Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectMilestones).getRecordTypeId() != null){
            recordtypeid=Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectMilestones).getRecordTypeId();
        }
        
        if(lstProjects != null && !lstProjects.isEmpty() && recordtypeid != null)
        {
            List<IPM_Milestone__c> lstipmmilestones=[SELECT Id,IPM_Name__c,IPM_Project__c,IPM_Project__r.IPM_Project_Leader__r.Name,IPM_Project__r.Name,IPM_Type_of_gate__c,IPM_Project__r.IPM_Phase__c,
                               IPM_Project__r.Id,IPM_Project__r.IPM_Target_Launch_Dates__c,IPM_Project__r.IPM_Project_Name__c,IPM_Completed__c,
                                                 IPM_Project__r.IPM_Fast_Track_Project__c,IPM_Due_Date__c,IPM_Planned_Date__c,IPM_Completed_On__c,IPM_Phase__c FROM IPM_Milestone__c 
                                                 WHERE IPM_Project__c IN : lstProjects and IPM_Type_of_Milestone__c =: IPM_Utils.Standard And RecordtypeId = : recordtypeid limit 50000];
      
                // Checking the Due dates for the Gate Phases which is used for Alerts
                alertsOTIF = new Map<Id,String>();
                Integer DateValue;
                for(IPM_Milestone__c ipmmiles:lstipmmilestones){
                	ProjDueDateMap.put(ipmmiles.IPM_Project__c,ipmmiles.IPM_Due_Date__c);
                	ProjectIdMap.put(ipmmiles.IPM_Project__r.Name+ipmmiles.IPM_Name__c,ipmmiles.IPM_Project__r.Id);
                    
                    if(ipmmiles.IPM_Project__r.IPM_Phase__c == ipmmiles.IPM_Phase__c && String.IsNotBlank(String.valueOf(ipmmiles.IPM_Due_Date__c)) && !ipmmiles.IPM_Completed__c){
                    DateValue=Date.valueOf(System.today()).daysBetween(Date.valueOf(ipmmiles.IPM_Due_Date__c));
                            if(DateValue<0){
                                  alertMessageDueDatePast.put(ipmmiles.IPM_Project__r.Name+ipmmiles.IPM_Name__c,System.Label.IPM_DUE_DATE_FOR +IPM_ConstantUtils.IPM_SPACE+ipmmiles.IPM_Type_of_gate__c +IPM_ConstantUtils.IPM_SPACE+IPM_Utils.off+IPM_ConstantUtils.IPM_SPACE+ipmmiles.IPM_Project__r.IPM_Project_Name__c);
                            }
                            if(DateValue<=21 && DateValue!=0 && DateValue >0){
                               alertMessageDueDateApproaching.put(ipmmiles.IPM_Project__r.Name+ipmmiles.IPM_Name__c,ipmmiles.IPM_Project__r.IPM_Project_Name__c+IPM_ConstantUtils.IPM_SPACE+ipmmiles.IPM_Name__c+IPM_ConstantUtils.IPM_SPACE+IPM_Utils.dueIN +IPM_ConstantUtils.IPM_SPACE+ DateValue);
                            }
                          if(DateValue== 0){
                               alertMessageDueDateToday.put(ipmmiles.IPM_Project__r.Name+ipmmiles.IPM_Name__c,PLANNED_STR+ipmmiles.IPM_Type_of_gate__c+IPM_ConstantUtils.IPM_SPACE+GATE_STR);
                           }
                      }
                             
                }
        }
        //Adding alert for Regional-Local financial 
        LstFinMisalignedMessage = new List<String>();
        LstFinTLDMisalignedMessageMap = new Map<String,String>();
        LstLocalFinTLDMisalignedMessageMap = new Map<String,String>();
        // Final local Misalignment
        List<IPM_Financial__c> regionalFins = new List<IPM_Financial__c>();
        Set<Id> ProjIds = new Map<Id,IPM_Project__c>(lstProjects).keySet();
        regionalFins = [Select Id, Name, Misaligned__c,MisalignmentDateTime__c,Misaligned_Date__c, Target_Launch_Date__c, Regional_Project__c, Regional_Project__r.Name, Regional_Project__r.IPM_Target_Launch_Dates__c, Local_Project__c, Local_Project__r.Name, Local_Project__r.IPM_Target_Launch_Dates__c from IPM_Financial__c 
        where (Regional_Project__c IN : ProjIds or Global_Project_Id__c IN : ProjIds 
                                                or Local_Project__c IN : ProjIds) and recordtype.Name =: IPM_ConstantUtils.DEFAULT_FINANCIAL_RT and Misaligned__c = true Limit: IPM_ConstantUtils.MaxLimit];
        for(IPM_Financial__c fin: regionalFins ){  
             if(fin.Regional_Project__c != NULL && fin.Local_Project__c != NULL && fin.Misaligned__c && fin.Misaligned_Date__c < system.today().addDays(1)){
                 LstFinMisalignedMessage.add(IPM_ConstantUtils.FIN_MISALIGNED_ALERT1 +fin.Regional_Project__r.Name+ IPM_ConstantUtils.FIN_MISALIGNED_ALERT2 +fin.Local_Project__r.Name+IPM_ConstantUtils.FIN_MISALIGNED_ALERT3); //The financials for project {Regional.Project Name} and {Local.Project Name} are  misaligned.
                ProjectId=fin.Regional_Project__r.Id;
            }
        }
        // Check business Case values based on Due Date
        BusinessCaseMessageMap = new Map<String, String>();
        List<IPM_Financial__c> financialList = [Select Id, RecordTypeId, Global_Project_Id__c,Regional_Project__c,Local_Project__c, Financial_External_ID__c, Display_Name__c,
                                                 Parent_Project__r.Name,
                                                (SELECT Id, Turnover_Global__c, Turnover_Local__c,Turnover_Regional__c, Profit_Before_Overheads_Global__c,
                                                Profit_Before_Overheads_Local__c, Profit_Before_Overheads_Regional__c,
                                                Gross_Profit_Global__c, Gross_Profit_Local__c, Gross_Profit_Regional__c FROM IPM_Financial_Years__r where
                                                (Year__c =: IPM_ConstantUtils.Y1_YEARINDEX or Year__c =: IPM_ConstantUtils.Y2_YEARINDEX or Year__c =:IPM_ConstantUtils.Y3_YEARINDEX) and Year_Type__c =: IPM_ConstantUtils.YEAR_TYPE_CALENDAR ) FROM
                                                IPM_Financial__c where (Regional_Project__c IN : ProjIds or Global_Project_Id__c IN : ProjIds 
                                                or Local_Project__c IN : ProjIds) and recordtype.Name =: IPM_ConstantUtils.DEFAULT_FINANCIAL_RT Limit: IPM_ConstantUtils.MaxLimit];
                                                    
       for(IPM_Financial__c fin : financialList ){
        for(IPM_Financial_Year__c FinYear: fin.IPM_Financial_Years__r){
            if(FinYear.Turnover_Global__c ==0 || FinYear.Turnover_Local__c == 0 || FinYear.Turnover_Regional__c == 0 || FinYear.Profit_Before_Overheads_Global__c == 0 ||
              FinYear.Profit_Before_Overheads_Local__c == 0 || FinYear.Profit_Before_Overheads_Regional__c == 0 || FinYear.Gross_Profit_Global__c == 0 || 
              FinYear.Gross_Profit_Local__c == 0 || FinYear.Gross_Profit_Regional__c == 0){
                if(ProjDueDateMap.get(fin.Global_Project_Id__c) < system.today().addDays(DAY_VALUE_Fourteen) || ProjDueDateMap.get(fin.Regional_Project__c) < system.today().addDays(DAY_VALUE_Fourteen) || ProjDueDateMap.get(fin.Local_Project__c) < system.today().addDays(DAY_VALUE_Fourteen)){
                    if(fin.Global_Project_Id__c != null){
                        BusinessCaseMessageMap.put(fin.Global_Project_Id__c,Label.IPM_BusinessCaseAlert+fin.Display_Name__c);
                        ProjectIdMap.put(fin.Global_Project_Id__c+fin.Display_Name__c,fin.Global_Project_Id__c);
                        ProjectId= fin.Global_Project_Id__c;
                    }
                    if(fin.Regional_Project__c != null){
                        BusinessCaseMessageMap.put(fin.Regional_Project__c,Label.IPM_BusinessCaseAlert+fin.Display_Name__c);
                        ProjectIdMap.put(fin.Regional_Project__c+fin.Display_Name__c,fin.Regional_Project__c);
                        ProjectId= fin.Regional_Project__c;
                    }
                    if(fin.Local_Project__c != null){
                        BusinessCaseMessageMap.put(fin.Local_Project__c,Label.IPM_BusinessCaseAlert+fin.Display_Name__c);
                        ProjectIdMap.put(fin.Local_Project__c+fin.Display_Name__c,fin.Local_Project__c);
                        ProjectId= fin.Local_Project__c;
                    }
                }
            }
        }
        }
                                    
        
        //Adding alert for TLD misalignment
      for(IPM_Project__c project : lstProjects)
      {
      if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
            for(IPM_Project__c localProj: project.IPM_Projects__r)
            { 
                if(localProj.Rollout_Plan_Target_Launch_Date__c != null && localProj.IPM_Target_Launch_Dates__c != localProj.Rollout_Plan_Target_Launch_Date__c)
                {
                    LstFinTLDMisalignedMessageMap.put(project.id+project.IPM_Project_Name__c,IPM_ConstantUtils.FIN_TLDMISALIGNED_ALERT1 + project.IPM_Project_Name__c + IPM_ConstantUtils.FIN_TLDMISALIGNED_ALERT2 + localProj.IPM_Project_Name__c);
                    ProjectIdMap.put(project.id+project.IPM_Project_Name__c,project.id);
                }
            }   
        }
        if(IPM_ConstantUtils.PROJECT_SPAN_LOCAL.equalsIgnoreCase(project.IPMProject_Span__c) && project.Rollout_Plan_Target_Launch_Date__c != null && project.IPM_Target_Launch_Dates__c != project.Rollout_Plan_Target_Launch_Date__c)
        {
                LstLocalFinTLDMisalignedMessageMap.put(project.id+project.IPM_Project_Name__c,IPM_ConstantUtils.FIN_TLDMISALIGNED_ALERT1 + project.IPM_Parent_Project__r.IPM_Project_Name__c + IPM_ConstantUtils.FIN_TLDMISALIGNED_ALERT2 + project.IPM_Project_Name__c);
                ProjectIdMap.put(project.id+project.IPM_Project_Name__c,project.id);
                
        }
     }  
        
        // Adding Alert for Local Project leader is blank for rollout Projects
      rolloutProjectAlertMessageMap = new map<String, String>();
      Set<Id> newProjIds = new Map<Id,IPM_Project__c>(lstProjects).keySet();
      lstprojectRollout = [SELECT ID,Name,IPM_Regional_PL__c,Regional_Project__c,Regional_Project__r.Name FROM IPM_Project_Rollout__c where Regional_Project__c in : newProjIds];
      for(IPM_Project__c proj : lstProjects){
       
       if(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equalsIgnoreCase(proj.IPM_Project_Type__c) && IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL.equalsIgnoreCase(proj.IPMProject_Span__c))
           {
            for(IPM_Project_Rollout__c rollOutProject : lstprojectRollout){
              if(String.isBlank(rollOutProject.IPM_Regional_PL__c))
                 {
                    rolloutProjectAlertMessageMap.put(rollOutProject.Regional_Project__c+rollOutProject.Name,rollOutProject.Regional_Project__r.Name+IPM_ConstantUtils.Colon+String.format(Label.IPM_Local_Project_Leader_BlankMsg,new List<String>{rollOutProject.Name}));
                    ProjectIdMap.put(rollOutProject.Regional_Project__c+rollOutProject.Name,rollOutProject.Regional_Project__c);
                 }
             }
           }
             
        } 
        //Alert for displaying Approved with Edits status
        for(IPM_Project_Document__c eachDoc:[SELECT IPM_GateDocuments__c,IPM_Project__c,IPM_Document_Status__c,IPM_Project__r.IPM_Project_Name__c FROM IPM_Project_Document__c where IPM_Project__c IN :lstProjects limit 50000])
           {
            if(IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS.equalsIgnoreCase(eachDoc.IPM_Document_Status__c) && (System.Label.IPM_CHARTER.equalsIgnoreCase(eachDoc.IPM_GateDocuments__c) || IPM_ConstantUtils.CONTRACT_GATE.equalsIgnoreCase(eachDoc.IPM_GateDocuments__c)))
            {
                documentAlertMessageMap.put(eachDoc.IPM_Project__c,eachDoc.IPM_Project__r.IPM_Project_Name__c +IPM_ConstantUtils.Colon+eachDoc.IPM_GateDocuments__c+IPM_ConstantUtils.EMPTY_STRING_DELIMITER+system.label.IPM_Gate_Approved_With_Edits);
            }
        }
        
        //Alert for BET First Release is due on X
        for(IPM_Project__c eachProject: lstProjects)
        {
        if(eachProject.BET_MS_First_Release_Date__c != null){
          betFirstReleaseDueDate = system.today().daysBetween(eachProject.BET_MS_First_Release_Date__c);
          if(betFirstReleaseDueDate<=15 && betFirstReleaseDueDate!=0 && betFirstReleaseDueDate >0) 
           {
             Datetime targetLaunchDate=datetime.newInstance(eachProject.IPM_Target_Launch_Dates__c.year(),eachProject.IPM_Target_Launch_Dates__c.month(),eachProject.IPM_Target_Launch_Dates__c.day());
             Datetime betFirstReleaseDate=datetime.newInstance(eachProject.BET_MS_First_Release_Date__c.year(),eachProject.BET_MS_First_Release_Date__c.month(),eachProject.BET_MS_First_Release_Date__c.day());
             betMsgFirstReleaseDueDate.add(eachProject.IPM_Project_Name__c +IPM_ConstantUtils.BET_FIRST_RELEASE_MESSAGE_STR1 + targetLaunchDate.format(DATEFORMAT) + IPM_ConstantUtils.BET_FIRST_RELEASE_MESSAGE_STR2+ betFirstReleaseDate.format(DATEFORMAT)); 
             ProjectId=eachProject.id;
           }
         } 
         
       if(eachProject.BET_MS_Final_Release_Date__c != null)
       { 
           betFinalReleaseDueDate = system.today().daysBetween(eachProject.BET_MS_Final_Release_Date__c);
           if(betFinalReleaseDueDate<=15 && betFinalReleaseDueDate!=0 && betFirstReleaseDueDate >0) 
          {
            Datetime targetLaunchDate=datetime.newInstance(eachProject.IPM_Target_Launch_Dates__c.year(),eachProject.IPM_Target_Launch_Dates__c.month(),eachProject.IPM_Target_Launch_Dates__c.day());
            Datetime betFinalReleaseDate=datetime.newInstance(eachProject.BET_MS_Final_Release_Date__c.year(),eachProject.BET_MS_Final_Release_Date__c.month(),eachProject.BET_MS_Final_Release_Date__c.day());
            betMsgFinalReleaseDueDate.add(eachProject.IPM_Project_Name__c +IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1 + targetLaunchDate.format(DATEFORMAT) + IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR2+ betFinalReleaseDate.format(DATEFORMAT)); 
            ProjectId=eachProject.id;
          }      

        }
      }
      //DEF2344 fix
    List<IPM_Project__c> projList = IPM_ValidationHelper.validateMilestoneAndFinacialData(lstProjects);
    for(IPM_Project__c ipmProj : projList ) {
        finDataMissingAlertMessageMap.put(ipmProj.id, ipmProj.name + IPM_ConstantUtils.Colon + IPM_ConstantUtils.IPM_SPACE + Label.IPM_Finacial_Data_Missing); 
    }
      alertscount = fastTrackCount+alertMessageDueDatePast.size()+alertMessageDueDateApproaching.size()+alertMessageDueDateToday.size()+LstFinMisalignedMessage.size()+
      BusinessCaseMessageMap.size()+LstFinTLDMisalignedMessageMap.size()+LstLocalFinTLDMisalignedMessageMap.size()+rolloutProjectAlertMessageMap.size()+documentAlertMessageMap.size()
      + betMsgFirstReleaseDueDate.size()+betMsgFinalReleaseDueDate.size()+ finDataMissingAlertMessageMap.size();

   }    
    
    public String getTaskcountValue(){
        Integer taskcount =[SELECT count() FROM IPM_Task__c WHERE IPM_Assignee__c =: UserInfo.getUserId() AND IPM_Project__r.Is_Archieved__c = false AND IPM_Project__r.IPM_PM_Approach__c =: IPM_ConstantUtils.IPM_APPROACH_INTERNAL AND IPM_Completed__c = false LIMIT 50000];
        String taskcountValue =String.valueOf(taskcount);
        return taskcountValue;
    }
   
    // Getting  usertype 
    public void getusertype(){
        
        list<IPM_User_Profile__c>lstuserprofile=[SELECT IPM_User_Role__c,IPM_User_Function__c,Export_Porfolio_Data__c 
                                                 FROM IPM_User_Profile__c 
                                                 WHERE IPM_User__c=:userinfo.getuserid() AND IPM_Is_RoleorFunction_Blank__c=true LIMIT 50000];
        
        if(lstuserprofile != null && !lstuserprofile.isEmpty()){
            for(IPM_User_Profile__c up:lstuserprofile){
                if(!IsProjectEditable){
                   if(up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_BD || up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI|| 
                        up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_CD || up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE|| 
                        up.IPM_User_Role__c == IPM_ConstantUtils.IPM_ROLE_SUPPLY_CHAIN || up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_RD || 
                        up.IPM_User_Function__c == IPM_ConstantUtils.GATEKEEPER_CONSTANT || up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_BB){
                                IsProjectEditable=false;
                                isBossCardEditable=true;
                        } 
                }
                
                if(up.IPM_User_Function__c==IPM_ConstantUtils.TEAM_PROJECT_LEADER || up.IPM_User_Function__c==IPM_ConstantUtils.TEAM_DEPUTY_PROJECT_LEADER){
                    isProjectEditable=true;
                    isBossCardEditable=true;
                }
            }
        }
        else{
            isProjectEditable=false;
            isBossCardEditable=false;
        }
        if(!isProjectEditable || !isBossCardEditable){
            //security for central team and BP users
            IPM_CustomPermission cpr = new IPM_CustomPermission();
            boolean isCentralTeam=false;
            boolean isBPUser=false;
            isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
            isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
            if(isCentralTeam || isBPUser){
                isProjectEditable=true;
                isBossCardEditable=true;
            }     
        }   
        
    } 
    
}
