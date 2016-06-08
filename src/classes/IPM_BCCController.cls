/************************************************************************
    @Description : This class is used for business case functionality
    @Created Date: 15/04/2014
    @Author: Cognizant
    @Referenced: IPM_Bcc_Document page
************************************************************************/
    
public with sharing class IPM_BCCController extends IPM_ProjectIntermediateController { 
          
    //public IPM_Project__c project{get; set;} //used to store query result from IPM_Project__c object 
    public IPM_Financial__c finance{get; set;} //used to store query result from IPM_Financial__c object 
    public string projectId{get; set;} //used to store current project id
    public Boolean saveMsg{get; set;} //true if we want to show save message to VF page
    public List<IPM_Project__c> projList{get; set;} //Not used
    public Boolean tldAlignment{get; set;} //true if we want to aligned output text
    public Boolean isEditable{get;set;}//used for security 
    public Boolean isPDFDownload{get;set;}//used for security 
    public Boolean isFinanceUpdate{get;set;}//check for finance user
    public Boolean showConfirmButton{get;set;}
    public string businessCaseConfirmed{get;set;}
    private static string BC_CONFIRMED='Confirmed';
    private static string BC_UNCONFIRMED='Unconfirmed';
    /************************************************************************
    @Description : This is the constructor for the class
    ************************************************************************/
    
    public IPM_BCCController()
    {
        super();
        projectId= ApexPages.currentPage().getParameters().get('Id');
        isEditable=false;
        isFinanceUpdate=false;
        if (projectId != NULL){          
            if(project.Rollout_Plan_Target_Launch_Date__c==project.IPM_Target_Launch_Dates__c && project.IPM_Target_Launch_Dates__c==project.IPM_Parent_Project__r.IPM_Target_Launch_Dates__c){
                tldAlignment=true;
            }
            
           finance = [SELECT Id,IPM_BD_BB_Feedback__c,Local_Project__c,Local_Project__r.name,Local_Project__r.IPM_Phase__c,Misaligned__c,IPM_Business_Case_Confirmed__c,Is_BC_Confirmed_Capability__c,IPM_Country_Feedback__c 
                       FROM IPM_Financial__c 
                       WHERE isActive__c=true and Local_Project__c=:projectId];
                           
            if(project.IPM_Project_Leader__c==userinfo.getuserid() || project.Deputy_Project_Leader__c==userinfo.getuserid()){
                isEditable=true;
                isFinanceUpdate=true;
            }
            businessCaseConfirmed=BC_UNCONFIRMED;
            showConfirmButton=true;
            //security for central team and BP users
            IPM_CustomPermission cpr = new IPM_CustomPermission();
            boolean isCentralTeam=false;
            boolean isBPUser=false;
            isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
            isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
            if(isCentralTeam || isBPUser){
               isEditable=true; 
               isFinanceUpdate=true;
            }
            List<IPM_Project_Resource__c>projectResList=new List<IPM_Project_Resource__c>();
            projectResList=[SELECT IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE IPM_Project__c=:projectId AND IPM_User__c=:userinfo.getuserid()  AND IPM_Project__r.Is_Archieved__c=false LIMIT 1];
            if(!projectResList.isEmpty()){
                if(IPM_ConstantUtils.IPM_ROLE_GUEST.equals(projectResList[0].IPM_Role_Type__c)){
                	isPDFDownload=false;    
                }
                if(IPM_ConstantUtils.IPM_ROLE_FINANCE.equals(projectResList[0].IPM_Role_Type__c)){
                	isFinanceUpdate=true;	
                }
            }
            
            setBusinessCaseConfirmedValue();
            
        }
    }

    /************************************************************************
    @Description : This method is used when we want to add save message to VF page
    ************************************************************************/
    
    public void save(){
        try
        {
            if(finance!=null)
            {
                update finance;//will alwasys be 1 record.
            }
            saveMsg=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_BCC_SAVED_SUCCESFULLY));
        }
        catch (Exception ex) {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,system.label.IPM_System_Admin));
        	ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BCCController.class.getName(),
            'save',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        	
        }
    }

    /************************************************************************
    @Description :This method is used for update status in current IPM_Financial__c object
     ************************************************************************/
    
    public void changeStatus(){
        
        finance.IPM_Business_Case_Confirmed__c=true;
        try{
            if(finance!=null){
            	if(finance.Local_Project__r.IPM_Phase__c==IPM_ConstantUtils.PHASE_FEASIBILITY){
                	finance.IPM_Business_Case_Confirmed__c=true;
            	}
                else if(finance.Local_Project__r.IPM_Phase__c==IPM_ConstantUtils.PHASE_CAPABILITY){
                	finance.Is_BC_Confirmed_Capability__c=true;
                }
                
                update finance;//will alwasys be 1 record.
                setBusinessCaseConfirmedValue();
            }
                 
        }
        catch (Exception ex) {  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
            
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BCCController.class.getName(),
            'changeStatus',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        
        }
       
    }

    /************************************************************************
    @Description : This method is used for when hide save message
    ************************************************************************/
    public void hideSaveMsg(){
        saveMsg=false;
    }
   
    /************************************************************************
    @Description : This method is used to set the business case confirmation value
    ************************************************************************/ 
   public void setBusinessCaseConfirmedValue(){
   	 if(finance!=null)
            {
            	if(finance.Local_Project__r.IPM_Phase__c==IPM_ConstantUtils.PHASE_FEASIBILITY && finance.IPM_Business_Case_Confirmed__c){
            		businessCaseConfirmed=BC_CONFIRMED;
            		showConfirmButton=false;
            	}
            	 else if(finance.Local_Project__r.IPM_Phase__c==IPM_ConstantUtils.PHASE_CAPABILITY && finance.Is_BC_Confirmed_Capability__c){
            	 	businessCaseConfirmed=BC_CONFIRMED;
            	 	showConfirmButton=false;
            	 }
            }
   }
               
}
