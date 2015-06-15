/* ------------------------------------------------------------------------------------------------------------------
Name:           IPM_CreateRolloutProjects
Developed By:   Cognizant (Kannan, Samrat)
Description:    To create Regional Projects

Change History:
17/02/2015    Vipul    Updated Project Query and logic for updating Local Rollouts
--------------------------------------------------------------------------------------------------------------------- */
public class IPM_CreateRolloutProjects
{
    //Method for creating Regional Projects from Gate Documents
    public static void createProjects(List<IPM_Project_Document__c> ProjDocList){
        Set<Id> projectIds=new Set<Id>();
        Set<Id> regionalProjectIds=new Set<Id>();

        //Fetching Projects from Project Documents
        for(IPM_Project_Document__c pd:ProjDocList)
            projectIds.add(pd.IPM_Project__c);

        //Fetching Project Details
        String queryString = 'SELECT ';
        //IPM PROJECT
        For (String field : Schema.SObjectType.IPM_Project__c.fields.getMap().KeySet())
        queryString+= field + ', ';
        //IPM PROJECT ROLLOUTS
        queryString+= '(SELECT ';
        For (String field : Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap().KeySet()){
            if (field != 'Id')
            queryString+= field + ', ';
        }
        queryString+= 'Id FROM IPM_Project_Rollout__r)';
        queryString+= 'FROM IPM_Project__c WHERE Id IN: projectIds';

        List<IPM_Project__c> lstRegionalProjects = new List<IPM_Project__c>();
        For(IPM_Project__c ipmProject : Database.query(queryString)){
            lstRegionalProjects.addAll(processRollouts(ipmProject, ipmProject.IPM_Project_Rollout__r));
        }

        if(lstRegionalProjects.size() > 0)
            Database.upsert(lstRegionalProjects, IPM_Project__c.IPM_Project_Name__c, false);
    }
    
    //Method for creating Regional Projects
    public static List<IPM_Project__c> processRollouts(IPM_Project__c ipmProject, List<IPM_Project_Rollout__c> lstRegionalRollouts){
        String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Regional Rollout').getRecordTypeId();

        List<IPM_Project__c> lstRegionalProjects = new List<IPM_Project__c>();

        For(IPM_Project_Rollout__c rollout : lstRegionalRollouts){
            if(rollout.RecordtypeId == REGIONAL_ROLLOUT_RECORDTYPE && rollout.IPM_Regional_PL__c != null){
                IPM_Project__c newIpmProject = new IPM_Project__c(
                    IPM_Project_Name__c = rollout.IPM_Rollout_Project__c,
                    Market_Cluster__c = rollout.Market_Cluster__c,
                    IPM_Target_Launch_Dates__c = rollout.Target_Launch_Date__c,
                    IPM_Parent_Project__c = ipmProject.Id,
                    IPM_Project_Leader__c = rollout.IPM_Regional_PL__c,
                    Deputy_Project_Leader__c = rollout.IPM_Regional_PL__c,
                    IPM_Technical_Project_Leader__c = rollout.IPM_Regional_PL__c,
                    IPM_Project_Gatekeeper__c = rollout.IPM_Regional_PL__c,
                    IPM_Finance_Member__c = rollout.Finance_Member__c,
                    IPMProject_Span__c = 'Regional',
                    IPM_Brand_Positioning__c = ipmProject.IPM_Brand_Positioning__c,
                    IPM_Brand__c = ipmProject.IPM_Brand__c,
                    IPM_Category_Group__c = ipmProject.IPM_Category_Group__c,
                    IPM_Category_Text__c = ipmProject.IPM_Category_Text__c,
                    IPMCompany__c = ipmProject.IPMCompany__c,
                    IPM_Market__c = ipmProject.IPM_Market__c,
                    IPMPlatform__c = ipmProject.IPMPlatform__c,
                    IPM_Sector__c = ipmProject.IPM_Sector__c,
                    IPM_Sub_sector__c = ipmProject.IPM_Sub_sector__c,
                    IPM_Answer_of_Q1__c = ipmProject.IPM_Answer_of_Q1__c,
                    IPM_Answer_of_Q2__c = ipmProject.IPM_Answer_of_Q2__c,
                    IPM_Answer_of_Q3__c = ipmProject.IPM_Answer_of_Q3__c,
                    IPM_Complexity__c = ipmProject.IPM_Complexity__c,
                    IPM_GateKeeping_Model__c = ipmProject.IPM_GateKeeping_Model__c,
                    IPM_PM_Approach__c = ipmProject.IPM_PM_Approach__c,
                    IPM_Phase__c = 'Feasibility',
                    IPM_IsCompleted__c = ipmProject.IPM_IsCompleted__c,
                    IPM_Strategic_Intent__c = ipmProject.IPM_Strategic_Intent__c,
                    IPM_Market_Type__c = ipmProject.IPM_Market_Type__c,
                    IPM_Company_Card__c = ipmProject.IPM_Company_Card__c,
                    IPM_Fast_Track_Project__c = ipmProject.IPM_Fast_Track_Project__c,
                    IPM_Approver_of_Contract_Market_Ready__c = ipmProject.IPM_Approver_of_Contract_Market_Ready__c,
                    IPM_Approver_of_Charter__c = ipmProject.IPM_Approver_of_Charter__c,
                    Sustainability_Period__c = ipmProject.Sustainability_Period__c,
                    IPM_Project_Logo__c = ipmProject.IPM_Project_Logo__c,
                    IPM_Project_Logo_Id__c = ipmProject.IPM_Project_Logo_Id__c,
                    IPM_Project_Description__c = ipmProject.IPM_Project_Description__c,
                    IPM_Project_Type__c = 'Rollout',
                    IPM_Clustering__c=ipmProject.IPM_Clustering__c,
                    Market_Cluster_Name__c=rollout.Market_Cluster_Name__c
                );
                lstRegionalProjects.add(newIpmProject);
            }
        }
        
        return lstRegionalProjects;
    }
}