/**
@Author Cognizant
@Name IPM_CreateRolloutProjects
@CreateDate 28/08/2015
@Description This class is used to create Regional rollout Projects
@Version 1.0
@reference IPM_ProjectHelper class
*/
public with sharing class IPM_CreateRolloutProjects      
{
    /*******************************************************************************************************************
    * @description Method for Insert or Update Regional Projects 
    * @param projectList Contains Charter Project Documents
    */ 
    private static final Id REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId();
    private static final Id LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
    private static final string PROCESS_ROLLOUTS = 'processRollouts';
    private static final string CLASS_NAME = IPM_CreateRolloutProjects.class.getName();//Class Name for Exception Logging
    
    
    /*******************************************************************************************************************
    * @description Method for creating Child Projects 
    * @param ipmProject Contains Project
    * @param lstRegionalRollouts Contains List of Regional Rollouts 
    * @return List of Regional Project Records
    */    
    public static List<IPM_Project__c> processRollouts(IPM_Project__c ipmProject, List<IPM_Project_Rollout__c> lstRollouts)
    {
        try{
            List<IPM_Project__c> lstProjects = new List<IPM_Project__c>();
            
            // Get Project Type
            IPM_Project_Type__c projectType = IPM_Utils.retrieveProjectType(ipmProject);
            
            for(IPM_Project_Rollout__c rollout : lstRollouts)
            {
                if( rollout.IPM_Regional_PL__c != null)
                {
                    if(rollout.IPM_Rollout_Gatekeeper__c==null){
                    	rollout.IPM_Rollout_Gatekeeper__c=rollout.IPM_Regional_PL__c;
                    }
                    IPM_Project__c newIpmProject = new IPM_Project__c(
                        IPM_Project_Name__c = rollout.IPM_Rollout_Project__c,
                        Market_Cluster__c = rollout.Market_Cluster__c,
                        IPM_Target_Launch_Dates__c = rollout.Target_Launch_Date__c,
                        IPM_Parent_Project__c = ipmProject.Id,
                        IPM_Project_Leader__c = rollout.IPM_Regional_PL__c,
                        Deputy_Project_Leader__c = rollout.IPM_Regional_PL__c,
                        IPM_Technical_Project_Leader__c = rollout.IPM_Regional_PL__c,
                        IPM_Project_Gatekeeper__c = rollout.IPM_Rollout_Gatekeeper__c,
                        IPM_Finance_Lead__c = rollout.Finance_Member__c,
                        Market_Cluster_Name__c=rollout.Market_Cluster_Name__c,
                        IPM_Rollout_Status__c = rollout.IPM_Status__c,
                        IPMProject_Span__c = rollout.IPM_Rollout_Span__c,
                        IPM_Company_Card__c = rollout.IPM_Company_Card__c,
                        IPM_Brand_Positioning__c = ipmProject.IPM_Brand_Positioning__c,
                        IPM_Brand__c = ipmProject.IPM_Brand__c,   
                        IPM_Cluster__c = ipmProject.IPM_Cluster__c,
                        IPM_SourceProjectType__c = ipmProject.IPM_SourceProjectType__c,  
                        IPM_Category_Group__c = ipmProject.IPM_Category_Group__c,
                        IPM_Category_Text__c = ipmProject.IPM_Category_Text__c,
                        IPMCompany__c = ipmProject.IPMCompany__c,
                        IPM_Market__c = ipmProject.IPM_Market__c,
                       // IPMPlatform__c = ipmProject.IPMPlatform__c,
                        IPM_Sector__c = ipmProject.IPM_Sector__c,
                        IPM_Sub_sector__c = ipmProject.IPM_Sub_sector__c,
                        IPM_Answer_of_Q1__c = ipmProject.IPM_Answer_of_Q1__c,
                        IPM_Answer_of_Q2__c = ipmProject.IPM_Answer_of_Q2__c,
                        IPM_Answer_of_Q3__c = ipmProject.IPM_Answer_of_Q3__c,
                        IPM_Complexity__c = ipmProject.IPM_Child_Complexity__c,
                        IPM_Child_Complexity__c = ipmProject.IPM_Child_Complexity__c,
                        IPM_GateKeeping_Model__c = ipmProject.IPM_GateKeeping_Model__c,
                        IPM_IsCompleted__c = ipmProject.IPM_IsCompleted__c,
                        IPM_Strategic_Intent__c = ipmProject.IPM_Strategic_Intent__c,
                        IPM_Market_Type__c = ipmProject.IPM_Market_Type__c,
                        IPM_Project_Rollout__c = rollout.ID,
                        IPM_ProjectSubType__c = ipmProject.IPM_ProjectSubType__c,
                        IPM_CompanyCardText__c = ipmProject.IPM_CompanyCardText__c,                
                        IPM_Fast_Track_Project__c = ipmProject.IPM_Fast_Track_Project__c,
                        IPM_Approver_of_Contract_Market_Ready__c = ipmProject.IPM_Approver_of_Contract_Market_Ready__c,
                        IPM_Approver_of_Charter__c = ipmProject.IPM_Approver_of_Charter__c,
                        Sustainability_Period__c = ipmProject.Sustainability_Period__c,
                        IPM_Project_Logo__c = ipmProject.IPM_Project_Logo__c,
                        IPM_Project_Logo_Id__c = ipmProject.IPM_Project_Logo_Id__c,
                        IPM_Project_Description__c = ipmProject.IPM_Project_Description__c,
                        IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT,
                        IPM_Clustering__c= ipmProject.IPM_Clustering__c,
                        IPM_IsSaved__c = ipmProject.IPM_IsSaved__c,
                        IPM_White_Space_Project__c=ipmProject.IPM_White_Space_Project__c,
                        Project_External_ID__c=rollout.External_Id__c,
                        IPM_Bosscard_Status__c=ipmProject.IPM_Bosscard_Status__c
                        
                    );
                    
                    if( projectType.IPM_CreateRegionalProjects__c  && 
                       REGIONAL_ROLLOUT_RECORDTYPE!=null && rollout.RecordtypeId == REGIONAL_ROLLOUT_RECORDTYPE)
                    {
                        newIpmProject.IPM_Phase__c = projectType.IPM_RegionalProjectDefaultPhase__c;
                    }
                    else if(projectType.IPM_CreateLocalProjects__c && LOCAL_ROLLOUT_RECORDTYPE!=null && rollout.RecordtypeId == LOCAL_ROLLOUT_RECORDTYPE)
                    {
                        newIpmProject.IPM_Phase__c = projectType.IPM_LocalProjectDefaultPhase__c;
                    }                    
                    
                    if(String.isNotBlank(newIpmProject.IPM_Phase__c))
                    {
                        lstProjects.add(newIpmProject);
                    }
                    if(rollout.RecordtypeId == REGIONAL_ROLLOUT_RECORDTYPE)
                    {
                    	newIpmProject.IPM_PM_Approach__c = ipmProject.IPM_PM_Approach__c;
                    }
                    else if(rollout.RecordtypeId == LOCAL_ROLLOUT_RECORDTYPE)
                    {
                    	newIpmProject.IPM_PM_Approach__c = IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
                    }
                }
            }
            return lstProjects;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                                                       PROCESS_ROLLOUTS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            return null;                                                            
        }    
    }
}