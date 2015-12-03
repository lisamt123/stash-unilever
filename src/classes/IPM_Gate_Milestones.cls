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
    private static final String IPM_GATE_MILESTONES_STR = IPM_Gate_Milestones.class.getName();
    private static final String SHOW_MILESTONES_STR='showMilestones';
    public Id projectId{ // getter setter method for project id from the component attribute
        get {
            return projectId;
        }
        set {
            projectId= value;
            showMilestones();// calling the function
        }
    }
    public transient List<IPM_Milestone__c> projectMilestones{get;set;}//used to store the value return by  loadMilestones function 

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
                String soql  =  'SELECT IPM_Completed__c, IPM_Name__c, IPM_Due_Date__c, IPM_Completed_On__c, IPM_phase__c, IPM_Milestone__c';
                soql += ' FROM IPM_Milestone__c ';
                soql += 'WHERE IPM_Project__c = \'' + projectId + '\'';
                soql += ' AND recordtypeId=\'' + IPM_Utils.getMilestoneRecordType(IPM_ConstantUtils.MILESTONES_RECORDTYPE) + '\'';
                soql += ' AND IPM_Active__c=true';
                soql += ' ORDER BY IPM_Due_Date__c asc LIMIT 1000';
                projectMilestones = Database.query(soql);
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_MILESTONES_STR,
                SHOW_MILESTONES_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
}