/******************************************** 
*@Author:Cognizant
*@Date:September 2015
*@Description : Sends chatter notification and mail when Milestone Due Date is today or passed or 21 days in the future 
* This class is set as Without Sharing as the Batch class needs to send Notifications to all
* eligible users irrespective of who schedules batch class. Ideally the bacth class wil be 
* scheduled by an Admin user.
* This class has been declared as global as it implements Database.Batchable interface.
*********************************************/

global without sharing class IPM_DueDateNotification_Batch implements Database.Batchable<sObject> {


    public static String response ;
    private static final String CLASS_NAME = IPM_DueDateNotification_Batch.class.getName();
    private static Map<Id,String> projIdchatterMessageMap = new Map<Id,String>();
    private static Set<Id> projIdNewProjectsSet = new Set<Id>();
    private static Map<Id,Set<Id>> subjectIdMentionIdSetMap = new Map<Id,Set<Id>>();
    private static List<IPM_Milestone__c> milestonesUpdated= new List<IPM_Milestone__c>();
    
    global Database.QueryLocator start(Database.BatchableContext bC) {
        
        Date dueIntwentyOneDays = system.today().addDays(21); // Milestones approaching due date in next 21 days
        Date todayDate = System.today();//Milestones having due date today
        String query = 'SELECT IPM_Due_Date__c,IPM_Completed__c,IPM_Project__r.IPM_Project_Gatekeeper__r.Email,IPM_Project__r.Deputy_Project_Leader__r.Name,IPM_Deputy_Project_Leader_Email__c, ';
                   query+='IPM_Project__r.IPM_Project_Leader__r.Name,IPM_Project__r.IPM_Project_Leader__r.Email,IPM_Milestone_Due_Date_In_Past__c,IPM_Project_Leader_Email__c, ' ;
                   query+='IPM_Project__r.Deputy_Project_Leader__r.Email,IPM_Project__r.IPM_Project_Name__c,IPM_Project__r.IPM_Project_Gatekeeper__r.Name,IPM_Gatekeeper_Email__c,';
                   query+='IPM_Project__c,IPM_Name__c,IPM_Type_of_gate__c,IPM_Phase__c,IPM_Project__r.IPM_Project_Leader__c,IPM_Project__r.IPM_Finance_Member__c, ';
                   query+='IPM_Project__r.Deputy_Project_Leader__c,IPM_Project__r.IPM_Company_Card__r.IPM_Business_Partner__c,IPM_Project__r.IPM_Phase__c, IPM_Project__r.IPM_Temporary_Phase__c ';
                   query+='FROM IPM_Milestone__c';
                   query +=' where (IPM_Due_Date__c <= :todayDate or IPM_Due_Date__c = :dueIntwentyOneDays) AND IPM_Completed__c = false'; 
        return Database.getQueryLocator(query);
    } 
    
    global void execute(Database.BatchableContext bC, List<IPM_Milestone__c> milestoneList) {
        Integer dateValue;
        String projectPhase;
        response = IPM_ConstantUtils.BLANK;
        Set<Id> milestoneProjSet = new Set<Id>();
        for(IPM_Milestone__c milestoneProj:milestoneList)
        {
            milestoneProjSet.add(milestoneProj.IPM_Project__c);
        }
        
        Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([
        																	SELECT Name,Id, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c,IPM_Phase__c, IPM_CompanyCardText__c 
        																	FROM IPM_Project__c 
        																	where Id IN : milestoneProjSet LIMIT 50000]);
        List<IPM_Project_Resource__c> resourceList = [Select IPM_User__c,IPM_Project__c from IPM_Project_Resource__c 
        where IPM_Role_Type__c =: IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE and IPM_Project__c IN: milestoneProjSet LIMIT 50000];
        
        for(IPM_Milestone__c eachMilestone:milestoneList)
        {
	          //Check if milestone is current active milestone of the project 
	          if(Test.isRunningTest()){
	              projectPhase = eachMilestone.IPM_Project__r.IPM_Temporary_Phase__c;
	          } 
	          else {
	              projectPhase = eachMilestone.IPM_Project__r.IPM_Phase__c;
	          }
	          if(projectPhase == eachMilestone.IPM_Phase__c && String.IsNotBlank(String.valueOf(eachMilestone.IPM_Due_Date__c)))
	          {
	             dateValue=Date.valueOf(System.today()).daysBetween(Date.valueOf(eachMilestone.IPM_Due_Date__c));
	              //If milestone due date is today
	              if(dateValue==0)
	               { 
	               		milestoneDueDateToday(eachMilestone,resourceList);  
	               }
	               //If milestone due date is approaching 21 days
	              if(dateValue==IPM_ConstantUtils.maxDueDaysDiffrence && dateValue >IPM_ConstantUtils.minDueDaysDiffrence)
	              {
	             		milestoneDueDateApproaching(eachMilestone,resourceList);
	              }
	              //if the project is driving the milestone, then only send the notification, else ignore.
	            if(IPM_Utils.retrieveProjectType(mapProjects.get(eachMilestone.IPM_Project__c))!=null && IPM_Utils.retrieveProjectType(mapProjects.get(eachMilestone.IPM_Project__c)).Independent_Project__c)
	        	  {
	        	  	  milestoneDueDateIsPassed(eachMilestone,dateValue);
	        	 
		          }
        	}  
        }
        
        try
        {
           update milestonesUpdated; 
           IPM_ChatterUtils.postChatterFeedWithMention(projIdNewProjectsSet, projIdchatterMessageMap, subjectIdMentionIdSetMap );
           response = IPM_ConstantUtils.MAIL_SENT_RESPONSE;
          }catch(System.Exception ex){ // Generalized exception
                    response = ex.getMessage();
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,IPM_ConstantUtils.EXECUTE_METHOD,response,ex, IPM_ConstantUtils.ERROR_STR, null, null, null,null);
          }     
    }   

	private static void milestoneDueDateToday(IPM_Milestone__c eachMilestone,List<IPM_Project_Resource__c> resourceList)
	{
		Set<Id> projLeadSet = createProjLeadSet(eachMilestone,resourceList);
	    
	    projIdNewProjectsSet.add(eachMilestone.IPM_Project__c);
	    subjectIdMentionIdSetMap.put(eachMilestone.IPM_Project__c,projLeadSet);
	    projIdchatterMessageMap.put(eachMilestone.IPM_Project__c,IPM_ConstantUtils.IPM_SPACE + IPM_ConstantUtils.PLANNED+eachMilestone.IPM_Name__c+IPM_ConstantUtils.IPM_SPACE+System.Label.IPM_DUE_ON_TODAY+System.Label.IPM_Remember_To_Update);
	              
	}
	
	private static void milestoneDueDateApproaching(IPM_Milestone__c eachMilestone,List<IPM_Project_Resource__c> resourceList)
	{
		Set<Id> projLeadSet = createProjLeadSet(eachMilestone,resourceList);
			
	    projIdNewProjectsSet.add(eachMilestone.IPM_Project__c);
	    subjectIdMentionIdSetMap.put(eachMilestone.IPM_Project__c,projLeadSet);
	    projIdchatterMessageMap.put(eachMilestone.IPM_Project__c,IPM_ConstantUtils.IPM_SPACE+IPM_ConstantUtils.PLANNED+eachMilestone.IPM_Type_of_gate__c+IPM_ConstantUtils.IPM_SPACE+IPM_ConstantUtils.GATE+IPM_ConstantUtils.IPM_SPACE+System.Label.IPM_Due_Date_In_21_days+IPM_ConstantUtils.DUE_DATE_STR2);
	             
	} 
	
	private static void milestoneDueDateIsPassed(IPM_Milestone__c eachMilestone,Integer dateValue)
	{
		//If milestone due date is passed
		if(eachMilestone.IPM_Due_Date__c < System.today() &&  ( dateValue == -1 || math.mod(dateValue,7) == 0 ) && !eachMilestone.IPM_Completed__c )
	      {
	        eachMilestone.IPM_Milestone_Due_Date_In_Past__c = true;
	        eachMilestone.IPM_Project_Leader_Email__c = eachMilestone.IPM_Project__r.IPM_Project_Leader__r.Email;
	        eachMilestone.IPM_Deputy_Project_Leader_Email__c = eachMilestone.IPM_Project__r.Deputy_Project_Leader__r.Email;
	        eachMilestone.IPM_Gatekeeper_Email__c = eachMilestone.IPM_Project__r.IPM_Project_Gatekeeper__r.Email;
	        milestonesUpdated.add(eachMilestone);
	       }
       else if(eachMilestone.IPM_Milestone_Due_Date_In_Past__c)
	       {
	        eachMilestone.IPM_Milestone_Due_Date_In_Past__c = false;
	        milestonesUpdated.add(eachMilestone);
	       }
	}
	
	private static Set<Id> createProjLeadSet(IPM_Milestone__c eachMilestone ,List<IPM_Project_Resource__c> resourceList){
	   
	    Set<Id>projLeadSet = new Set<Id>();
        if(eachMilestone.IPM_Project__r.IPM_Project_Leader__c != null)
        {
              projLeadSet.add(eachMilestone.IPM_Project__r.IPM_Project_Leader__c);
        }
        if(eachMilestone.IPM_Project__r.Deputy_Project_Leader__c != null )      
        {
              projLeadSet.add(eachMilestone.IPM_Project__r.Deputy_Project_Leader__c);
        }
        if(eachMilestone.IPM_Project__r.IPM_Finance_Member__c != null )      
        {
              projLeadSet.add(eachMilestone.IPM_Project__r.IPM_Finance_Member__c);
        }
        if(eachMilestone.IPM_Project__r.IPM_Company_Card__c != NULL && eachMilestone.IPM_Project__r.IPM_Company_Card__r.IPM_Business_Partner__c != null )      
        {
              projLeadSet.add(eachMilestone.IPM_Project__r.IPM_Company_Card__r.IPM_Business_Partner__c);
        }
        for(IPM_Project_Resource__c eachResource:resourceList)
        {   
            if(eachMilestone.IPM_Project__c == eachResource.IPM_Project__c && eachResource.IPM_User__c != null)
            {
                  projLeadSet.add(eachResource.IPM_User__c);
            }
        }     
        
        return projLeadSet;	
	}
	
    global void finish(Database.BatchableContext bC) {
        //sends an email for job status, after the job is completed.
        IPM_Utils.sendApexJobStatusMail(bC);
    }
    
}