/***********************************************************************************************************
    @Description : This class is used to schedule the IPM_BD_BB_Reportbatch job with set of projetc records 
                   based on current month.
                   For Admin -- This job will pick the last run date from the custom setting and run the job on projects
                   records created / modified post last execuation. only on year yend this job will repopulate
                   all active project details with year end chanegs.
    @Created Date: 04/10/2015
    @Author: Cognizant
    @Referenced: IPM_BD_BB_Report_BatchSchedule
    This class has been declared as Gloabl as it implements Schedulable interface.
    
************************************************************************************************************/

global without sharing class IPM_BD_BB_Report_BatchSchedule implements Schedulable { 
 
    global datetime currentDate = system.now();   
    global datetime lastrunDate;
    global String query;
    //To fetch BB BD Report last run date from custom setting 
    public static final String STR_BB_BD_Report = 'BD BB Report'; 
    
   /****************************************************************************************
   @Description : Constructor
   @Param: none
   ******************************************************************************************/
   global IPM_BD_BB_Report_BatchSchedule()
   {
        IPM_Reporting__c reportCs = IPM_Reporting__c.getValues(STR_BB_BD_Report);
        lastrunDate = reportCs.Last_Batch_RunDate__c;
        
        if(currentDate.month() == 1 && currentDate.day() == 1){
            lastrunDate = null; 
        }
        else {    
            lastrunDate = lastrunDate.adddays(-1);                
        }
        
        //Check for the year change
        if(lastrunDate == null){            
            query = 'SELECT Id,IPM_Global_ProjectId__c, IPM_Project_Name__c, IPM_LocalProject_Brand__c, IPM_Parent_Project__r.IPM_project_name__c, IPM_Platform_Formula__c, BET__r.Name, BET__r.Owner.Name, BETCurrentStatus__c, Project_External_ID__c,Name,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Lead__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Project_Rollout__r.name,IPM_Project_Rollout__r.Id,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c,IPM_Target_Launch_Dates__c,IPM_Project_Rollout__c,IPM_Misalligned__c,CreatedDate,IPM_Project_Start_Date__c,IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c,IPM_CPP__c,IPM_Fast_Track_Project__c,IPM_White_Space_Project__c,Is_Archieved__c,IPM_ProjectGKM__c,IPM_Complexity__c,IPM_Market__c,IPM_Sub_sector__c,IPM_Global_OR_Regional__c,IPM_Project_Rollout__r.Target_Launch_Date__c, IPM_Project_Rollout__r.KeyMCO__c FROM IPM_Project__c WHERE IPM_Project_Name__c != null' ;
        }   
        else{
            string formatedDt  = lastrunDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');  
            query = 'SELECT Id,IPM_Global_ProjectId__c, IPM_Project_Name__c, IPM_LocalProject_Brand__c, IPM_Parent_Project__r.IPM_project_name__c, IPM_Platform_Formula__c, BET__r.Name, BET__r.Owner.Name, BETCurrentStatus__c, Project_External_ID__c,Name, IPM_Parent_Project__r.Name,  IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Lead__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Project_Rollout__r.name,IPM_Project_Rollout__r.Id,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c,IPM_Target_Launch_Dates__c,IPM_Project_Rollout__c,IPM_Misalligned__c,CreatedDate,IPM_Project_Start_Date__c,IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c,IPM_CPP__c,IPM_Fast_Track_Project__c,IPM_White_Space_Project__c,Is_Archieved__c,IPM_ProjectGKM__c,IPM_Complexity__c,IPM_Market__c,IPM_Sub_sector__c,IPM_Global_OR_Regional__c,IPM_Project_Rollout__r.Target_Launch_Date__c, IPM_Project_Rollout__r.KeyMCO__c FROM IPM_Project__c WHERE  IPM_Project_Name__c != null AND (CreatedDate >' + formatedDt +  ' or LastModifieddate >' + formatedDt + ')';
        }
                
    } 
      
   /****************************************************************************************
   @Description : batch start method
   @Param:SchedulableContext
   *****************************************************************************************/
   global void execute(SchedulableContext sc) {  
        
        IPM_Reporting__c reportCS = IPM_Reporting__c.getValues(STR_BB_BD_Report);
        Decimal batchSize = reportCS.Batch_Size__c; 
         
        IPM_BD_BB_Report_Batch  b = new IPM_BD_BB_Report_Batch(query); 
        database.executebatch(b, batchSize.intValue());    
   }  
}