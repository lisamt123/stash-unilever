/***********************************************************************************************************
    @Description : This class is used to schedule the IPM_OTIF_Reportbatch job with set of projetc records 
                   It will be running onece in 24 hour
    @Created Date: 22/03/2016
    @Author: Cognizant
    @Referenced: IPM_OTIF_Report_BatchSchedule
    This class has been declared as Gloabl as it implements Schedulable interface.
    This class is declared as 'without sharing' - As report needs to run without sharing as it needs to look at all records regardless of what the running user has access to    
************************************************************************************************************/

global without sharing class IPM_OTIF_Report_BatchSchedule implements Schedulable { 
 
    global String query;
    public static final String OTIF_Report = 'OTIF Report';     
    
   /****************************************************************************************
   @Description : Constructor
   @Param: none
   ******************************************************************************************/
   global IPM_OTIF_Report_BatchSchedule()
    {
            query = 'SELECT Id,IPM_Global_ProjectId__c,Project_External_ID__c,Name,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Lead__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c,IPM_Target_Launch_Dates__c,IPM_Project_Rollout__c,IPM_Misalligned__c,CreatedDate,IPM_Project_Start_Date__c,IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c,IPM_CPP__c,IPM_Fast_Track_Project__c,Is_Archieved__c,IPM_Global_OR_Regional__c,IPM_Project_Rollout__r.Target_Launch_Date__c, IPM_Project_Rollout__r.KeyMCO__c FROM IPM_Project__c';
    } 
      
   /****************************************************************************************
   @Description : batch start method
   @Param:SchedulableContext
   *****************************************************************************************/
   global void execute(SchedulableContext sc) {  
        IPM_Reporting__c reportCs = IPM_Reporting__c.getValues(OTIF_Report);
        Decimal batchSize = reportCs.Batch_Size__c;
         
        IPM_OTIF_Report_Batch  b = new IPM_OTIF_Report_Batch(query); 
        database.executebatch(b,batchSize.intValue());    
   }  
}