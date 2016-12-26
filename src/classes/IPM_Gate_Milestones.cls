/****************************************************************************************************************************
@Author: Cognizant
@Name: IPM_Gate_Milestones
@Created Date: 15/04/2015
@Description: To Display project's milestones for gate Documents
@Version: 1.0
@Reference: IPM_MilestoneList_PDF component
*/
public with sharing class IPM_Gate_Milestones {
    //For exception handler
    public Id projectId{ // to get-set the project id from the component attribute.
        get{
            if(projectId == null && Apexpages.currentpage().getparameters().get('pId') != null) {
                return  Id.valueOf(Apexpages.currentpage().getparameters().get('pId')) ;
            }
            else { return projectId; }
        }
        set;
    } 
    public string gateType{// to get-set the project document section id from the component attribute.
        get{
            if(gateType == null && Apexpages.currentpage().getparameters().get('gateDocType') != null) {
                return  Apexpages.currentpage().getparameters().get('gateDocType');
            }
            else { return gateType; }
        }
        set;
    }
    public string gateDocumentStatus{// to get-set the project document section id from the component attribute.
        get{
            if(gateDocumentStatus == null && Apexpages.currentpage().getparameters().get('gateDocStatus') != null) {
                return  Apexpages.currentpage().getparameters().get('gateDocStatus');
            }
            else { return gateDocumentStatus; }
        }
        set;
    }
    private static final String IPM_GATE_MILESTONES_STR = IPM_Gate_Milestones.class.getName();
    private static final String SHOW_MILESTONES_STR='showMilestones';
    public boolean isCurrentDueDate{get;set;}
    public boolean isIdeaSnapShot{get;set;}
    public boolean isFeasibilitySnapShot{get;set;}
    public boolean isCapabilitySnapShot{get;set;}
    public boolean isMarketReadySnapShot{get;set;}
    
    public transient List<IPM_Milestone__c> projectMilestones{get;set;}//used to store the value return by  loadMilestones function 
    
    /************************************************************************************************************************
    * @Description: Methods to run when this controller is invoked from component
    */
    public string getInvokeMethodsForComponent() {
        showMilestones();// calling the function
        return 'Required methods are invoked for component';
    }
    
     /************************************************************************************************************************
    * @Description: CONSTRUCTOR
    */
    PUBLIC IPM_Gate_Milestones() {
        if(test.isRunningTest()){
            getInvokeMethodsForComponent();
        }
    }
    /************************************************************************************************************************
    *  Description Getting list of milestones to display in gate docuemnt and pdf
    *  @name loadMilestones
    *  @param none
    *  @return void
    *  @throws query exception
    */
    private void showMilestones(){
        try{
            IPM_IECompatible.ieFix();//For IE Compatibility
            if(String.isNotBlank(projectId)){
                projectMilestones=new List<IPM_Milestone__c>();
                String soql  =  'SELECT IPM_Completed__c, IPM_Name__c, IPM_Due_Date__c,IPM_Due_Date_Idea__c,IPM_Due_Date_Feasibility__c,IPM_Due_Date_Capability__c,IPM_Due_Date_Market_Ready__c,IPM_Due_Date_Market_Deployment__c,IPM_Due_Date_Post_Launch_Evaluation__c, IPM_Completed_On__c, IPM_phase__c,IPM_Phase_Order__c,IPM_Milestone__c';
                soql += ' FROM IPM_Milestone__c ';
                soql += 'WHERE IPM_Project__c = \'' + projectId + '\'';
                soql += ' AND recordtypeId=\'' + IPM_Utils.getMilestoneRecordType(IPM_ConstantUtils.MILESTONES_RECORDTYPE) + '\'';
                soql += ' AND IPM_Active__c=true';
                soql += ' ORDER BY IPM_Phase_Order__c asc LIMIT 1000';
                projectMilestones = Database.query(soql); 
                
                showSnapshot();             
                
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_MILESTONES_STR,
                SHOW_MILESTONES_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    private void showSnapshot(){
        isIdeaSnapShot=false;
        isFeasibilitySnapShot=false;
        isCapabilitySnapShot=false;
        isMarketReadySnapShot=false;
        isCurrentDueDate=true;
        if(String.isNotBlank(gateType) && String.isNotBlank(gateDocumentStatus))
        { 
            if(IPM_ConstantUtils.CHARTER_GATE==gateType && IPM_ConstantUtils.STATUS_APPROVED==gateDocumentStatus)
            {               
                isIdeaSnapShot=true;
                isCurrentDueDate=false;
            }
            else if(IPM_ConstantUtils.CONTRACT_GATE==gateType && IPM_ConstantUtils.STATUS_APPROVED==gateDocumentStatus)
            {
                isFeasibilitySnapShot=true;
                isCurrentDueDate=false;
            }
            else if(IPM_ConstantUtils.MARKET_READY_GATE==gateType && IPM_ConstantUtils.STATUS_APPROVED==gateDocumentStatus)
            {
                isCapabilitySnapShot=true;
                isCurrentDueDate=false;
            }
            else if(IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE==gateType && IPM_ConstantUtils.STATUS_APPROVED==gateDocumentStatus)
            {
                isMarketReadySnapShot=true;
                isCurrentDueDate=false;
            }
            
        }
    
    }
}