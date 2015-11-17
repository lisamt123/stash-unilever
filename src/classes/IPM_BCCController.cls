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
    private static final string CLASS_NAME = 'IPM_BCCController';

    /************************************************************************
    @Description : This is the constructor for the class
    ************************************************************************/
    
    public IPM_BCCController(){
        projectId= ApexPages.currentPage().getParameters().get('Id');
        isEditable=false;
        if (projectId != NULL){
          /*  project = [SELECT Id,IPM_Project_Name__c,IPMProject_Span__c,IPM_Phase__c,IPM_Target_Launch_Dates__c,
                              IPM_Parent_Project__c,IPM_Parent_Project__r.IPM_Target_Launch_Dates__c 
                       FROM IPM_Project__c 
                       WHERE Id=:projectId];*/
            if(project.IPM_Target_Launch_Dates__c==project.IPM_Parent_Project__r.IPM_Target_Launch_Dates__c){
                tldAlignment=true;
            }
            finance = [SELECT Id,IPM_BD_BB_Feedback__c,Local_Project__c,Local_Project__r.name,Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c 
                       FROM IPM_Financial__c 
                       WHERE Local_Project__c=:projectId];    
            if(project.IPM_Project_Leader__c==userinfo.getuserid() || project.Deputy_Project_Leader__c==userinfo.getuserid()){
                isEditable=true;
            }
            //security for central team and BP users
            IPM_CustomPermission cpr = new IPM_CustomPermission();
            boolean isCentralTeam=false;
            boolean isBPUser=false;
            isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
            isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
            if(isCentralTeam || isBPUser){
               isEditable=true; 
            }
            Integer guestCount=0;
            guestCount=[SELECT COUNT() FROM IPM_Project_Resource__c WHERE IPM_Role_Type__c=:IPM_ConstantUtils.IPM_ROLE_GUEST
                        AND IPM_Project__c=:projectId AND IPM_User__c=:userinfo.getuserid()  AND IPM_Project__r.Is_Archieved__c=false LIMIT 1];
            if(guestCount>0){
                isPDFDownload=false;
            }
               
        }
    }

    /************************************************************************
    @Description : This method is used when we want to add save message to VF page
    ************************************************************************/
    
    public void save(){
        try{
            if(finance!=null)
                update finance;//will alwasys be 1 record.
            saveMsg=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_BCC_SAVED_SUCCESFULLY));
        }
        catch (DmlException ex) {
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
                            'save',ex.getMessage(),ex, 'Error', null, null, null);
        }
    }

    /************************************************************************
    @Description :This method is used for update status in current IPM_Financial__c object
     ************************************************************************/
    
    public void changeStatus(){
        
        finance.IPM_Business_Case_Confirmed__c=true;
        try{
            if(finance!=null){
                finance.IPM_Business_Case_Confirmed__c=true;
                update finance;//will alwasys be 1 record.
            }
                 
        }
        catch (DmlException ex) {
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
                            'changeStatus',ex.getMessage(),ex, 'Error', null, null, null);
        }
       
    }

    /************************************************************************
    @Description : This method is used for when hide save message
    ************************************************************************/
    public void hideSaveMsg(){
        saveMsg=false;
    }
}