global class SchedulableToBrandEstimatesBatch implements Schedulable
  {
    global void execute(SchedulableContext ctx)
      {
         String Fisyear=string.valueOf(system.now().year()-1);
         String statusBasefee='Ready for PO';
       /*  string query  = 'select id,Name,AF_Active__c,AF_Adaptive__c ,AF_Agency__c,Agency_Base_Fee__c,AF_Archived__c,AF_Basefee_Estimate_Initial_Quarter__c,Base_Fee_Total__c,AF_Bonus_Trigger_Date__c,Brand__c,AF_Comment_Type__c,AF_Controller_Flag__c,AF_Created_By_Batch__c,AF_Digital__c,AF_Fiscal_Year__c,AF_Measure_Bonus__c,AF_Overall_OOPS__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Total__c,AF_Traditional__c from AF_Brand_Estimate__c where AF_Status_Base_Fees__c=:'+statusBasefee+' and AF_Fiscal_Year__c=:'+Fisyear ;
         AF_BrandEstimatesBatch batchApex=new AF_BrandEstimatesBatch(query);
         ID batchprocessid = Database.executeBatch(batchApex,1);
        */
      //  string query = 'SELECT id,Name FROM AF_Brand_Estimate__c WHERE AF_Status_Base_Fees__c =' + '\'' +statusBasefee +'\''+' AND AF_Fiscal_Year__c ='+'\''+Fisyear+'\'';
      string query = 'SELECT id,Name FROM AF_Brand_Estimate__c WHERE AF_Status_Base_Fees__c =' + '\'' +statusBasefee +'\''+' AND AF_Fiscal_Year__c ='+'\''+Fisyear+'\' and AF_Active__c = true';
        AF_BrandEstimatesBatch batchApex=new AF_BrandEstimatesBatch(query);
        ID batchprocessid = Database.executeBatch(batchApex,1);
    }

}