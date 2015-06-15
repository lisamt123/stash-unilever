/* Type Name: IPM_CreateLocalProjects
Developed By: Kannan and Samrat
Change History: 
Reason: To create projects for local rollouts */
public class IPM_CreateLocalProjects
{
    @future
    public static void createProjects(Set<Id> regionalProjectIds,Set<Id> projectIds)
    {   
        //Fetching Newly Created Projects from Regional Rollouts
        Map<String,IPM_Project__c> createdRegionalProjectList=new Map<String,IPM_Project__c>();
        List<IPM_Project__c> regionalProjectList=new List<IPM_Project__c>();
        string RecordTypeIdlrt,RecordTypeIdrt;
        RecordTypeIdlrt=Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Local Rollouts').getRecordTypeId();
        RecordTypeIdrt=Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Regional Rollout').getRecordTypeId();
        //Fetching Project Details
        Map<Id,IPM_Project__c> projMap=new Map<Id,IPM_Project__c>([SELECT Deputy_Project_Leader__c,Id,IPMCompany__c,IPMPlatform__c,IPMProject_Span__c,IPMProject_Type__c,IPMRegion__c,IPM_Answer_of_Q1__c,IPM_Answer_of_Q2__c,IPM_Answer_of_Q3__c,IPM_Approver_of_Charter__c,IPM_Approver_of_Contract_Market_Ready__c,IPM_Bosscard_Status__c,IPM_Bosscard__c,IPM_Brand_Positioning__c,IPM_Brand__c,IPM_Category_Group__c,IPM_Category_Icon__c,IPM_Category_Text__c,IPM_Category__c,IPM_Company_Card__c,IPM_Complexity__c,IPM_Core_Parameters__c,IPM_CPP_Change_Reason__c,IPM_CPP__c,IPM_Fast_Track_Project__c,IPM_FilledIn_Percentage__c,IPM_Finance_Member__c,IPM_GateKeeping_Model__c,IPM_Gate_Keeping_Module__c,IPM_IsCompleted__c,IPM_Market_Type__c,IPM_Market__c,IPM_Parent_Project__c,IPM_Phase__c,IPM_PM_Approach__c,IPM_Project_Description__c,IPM_Project_Gatekeeper__c,IPM_Project_Leader__c,IPM_Project_Logo_Id__c,IPM_Project_Logo__c,IPM_Project_Name__c,IPM_Sector__c,IPM_Strategic_Intent__c,IPM_Sub_Category__c,IPM_Sub_sector__c,IPM_Target_Launch_Dates__c,IPM_Target_Launch_Date__c,IPM_Technical_Project_Leader__c,IPM_UserCategory__c,Is_Archieved__c,Name,Sustainability_Period__c FROM IPM_Project__c where Id In:projectIds]);
        regionalProjectList=[SELECT Deputy_Project_Leader__c,Id,IPMCompany__c,IPMPlatform__c,IPMProject_Span__c,IPMProject_Type__c,IPMRegion__c,IPM_Answer_of_Q1__c,IPM_Answer_of_Q2__c,IPM_Answer_of_Q3__c,IPM_Approver_of_Charter__c,IPM_Approver_of_Contract_Market_Ready__c,IPM_Bosscard_Status__c,IPM_Bosscard__c,IPM_Brand_Positioning__c,IPM_Brand__c,IPM_Category_Group__c,IPM_Category_Icon__c,IPM_Category_Text__c,IPM_Category__c,IPM_Company_Card__c,IPM_Complexity__c,IPM_Core_Parameters__c,IPM_CPP_Change_Reason__c,IPM_CPP__c,IPM_Fast_Track_Project__c,IPM_FilledIn_Percentage__c,IPM_Finance_Member__c,IPM_GateKeeping_Model__c,IPM_Gate_Keeping_Module__c,IPM_IsCompleted__c,IPM_Market_Type__c,IPM_Market__c,IPM_Parent_Project__c,IPM_Phase__c,IPM_PM_Approach__c,IPM_Project_Description__c,IPM_Project_Gatekeeper__c,IPM_Project_Leader__c,IPM_Project_Logo_Id__c,IPM_Project_Logo__c,IPM_Project_Name__c,IPM_Sector__c,IPM_Strategic_Intent__c,IPM_Sub_Category__c,IPM_Sub_sector__c,IPM_Target_Launch_Dates__c,IPM_Target_Launch_Date__c,IPM_Technical_Project_Leader__c,IPM_UserCategory__c,Is_Archieved__c,Name,Sustainability_Period__c FROM IPM_Project__c where Id In:regionalProjectIds];
        for(IPM_Project__c rp:regionalProjectList)
        {
            createdRegionalProjectList.put(rp.IPM_Project_Name__c,rp);
        }
        Map<Id,String> regionalRolloutNames=new Map<Id,String>();
        List<IPM_Project_Rollout__c> rollOuts=new List<IPM_Project_Rollout__c>();
        rollOuts=[SELECT Finance_Member__c,Id,IPM_Local_Rollout_Status__c,IPM_Project__c,IPM_Regional_PL__c,IPM_Rollout_Project__c,IPM_Status__c,KeyMCO__c,Market_Cluster__c,MCO__c,Name,Regional_Rollout__c,Target_Launch_Date__c,Target_Launch_Month__c,Target_Launch_Year__c,Type__c FROM IPM_Project_Rollout__c where IPM_Project__c In:projectIds and RecordTypeId=:RecordTypeIdrt];
        for(IPM_Project_Rollout__c ro:rollOuts)
        {
            regionalRolloutNames.put(ro.Id,ro.IPM_Rollout_Project__c);
        }
        //Fetching Local Rollouts from Projects
        Map<Id,IPM_Project_Rollout__c> localRollOutsMap=new Map<Id,IPM_Project_Rollout__c>([SELECT Id,Finance_Member__c,IPM_Local_Rollout_Status__c,IPM_Project__c,IPM_Regional_PL__c,IPM_Rollout_Project__c,IPM_Status__c,KeyMCO__c,Market_Cluster__c,MCO__c,Name,Regional_Rollout__c,Target_Launch_Date__c,Target_Launch_Month__c,Target_Launch_Year__c,Type__c FROM IPM_Project_Rollout__c where IPM_Project__c In:projectIds and RecordTypeId=:RecordTypeIdlrt]);
        Set<Id> localRolloutIds=new Set<Id>();
        localRolloutIds=localRollOutsMap.keySet();
        List<IPM_Country__c> countryDetails=new List<IPM_Country__c>();
        countryDetails=[Select Id,IPM_CountryCode__c,IPM_Country_Name__c,IPM_Project__c,IPM_Project_Rollout__c,IPM_Project_Rollout__r.IPM_Project__c,Key__c,IPM_Market_Cluster__c,Project_country__c,IPM_Region_MCO__c from IPM_Country__c where IPM_Project_Rollout__c in:localRolloutIds];
        List<IPM_Project__c> localProjectList=new List<IPM_Project__c>();
        for(IPM_Country__c coun:countryDetails)
        {
            IPM_Project__c p=new IPM_Project__c();
            p.IPM_Project_Name__c=coun.Project_country__c;
            p.IPM_Target_Launch_Dates__c=localRollOutsMap.get(coun.IPM_Project_Rollout__c).Target_Launch_Date__c;
            p.IPM_Parent_Project__c=createdRegionalProjectList.get(regionalRolloutNames.get(localRollOutsMap.get(coun.IPM_Project_Rollout__c).Regional_Rollout__c)).Id;
            p.IPM_Project_Leader__c=localRollOutsMap.get(coun.IPM_Project_Rollout__c).IPM_Regional_PL__c;
            p.Deputy_Project_Leader__c=localRollOutsMap.get(coun.IPM_Project_Rollout__c).IPM_Regional_PL__c;
            p.IPM_Technical_Project_Leader__c=localRollOutsMap.get(coun.IPM_Project_Rollout__c).IPM_Regional_PL__c;
            p.IPM_Project_Gatekeeper__c=localRollOutsMap.get(coun.IPM_Project_Rollout__c).IPM_Regional_PL__c;
            p.IPM_Finance_Member__c=localRollOutsMap.get(coun.IPM_Project_Rollout__c).Finance_Member__c;
            p.IPMProject_Span__c='Local';
            p.IPM_Brand_Positioning__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Brand_Positioning__c;
            p.IPM_Brand__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Brand__c;
            p.IPM_Category_Group__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Category_Group__c;
            p.IPM_Category_Text__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Category_Text__c;
            p.IPMCompany__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPMCompany__c;
            p.IPM_Market__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Market__c;
            p.IPMPlatform__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPMPlatform__c;
            p.IPM_Sector__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Sector__c;
            p.IPM_Sub_sector__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Sub_sector__c;
            p.IPM_Answer_of_Q1__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Answer_of_Q1__c;
            p.IPM_Answer_of_Q2__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Answer_of_Q2__c;
            p.IPM_Answer_of_Q3__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Answer_of_Q3__c;
            p.IPM_Complexity__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Complexity__c;
            p.IPM_GateKeeping_Model__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_GateKeeping_Model__c;
            p.IPM_PM_Approach__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_PM_Approach__c;
            p.IPM_Phase__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Phase__c;
            p.IPM_IsCompleted__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_IsCompleted__c;
            p.IPM_Strategic_Intent__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Strategic_Intent__c;
            p.IPM_Market_Type__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Market_Type__c;
            p.IPM_Company_Card__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Company_Card__c;
            p.IPM_Fast_Track_Project__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Fast_Track_Project__c;
            p.IPM_Approver_of_Contract_Market_Ready__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Approver_of_Contract_Market_Ready__c;
            p.IPM_Approver_of_Charter__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Approver_of_Charter__c;
            p.Sustainability_Period__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).Sustainability_Period__c;
            p.IPM_Project_Logo__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Project_Logo__c;
            p.IPM_Project_Logo_Id__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Project_Logo_Id__c;
            p.IPM_Project_Description__c=projMap.get(coun.IPM_Project_Rollout__r.IPM_Project__c).IPM_Project_Description__c;
            p.IPMProject_Type__c='Rollout';
            localProjectList.add(p);
        }
        Insert localProjectList;
        System.debug(localProjectList+'localProjectList');
    }
}