global class SchedulableTo_Statuschange implements Schedulable
  {
    global void execute(SchedulableContext ctx)
    {
        String Fisyear=string.valueOf(system.now().year());
        string query = 'SELECT id,Name,Brand__c,AF_Status_Base_Fees__c FROM AF_Brand_Estimate__c WHERE AF_Fiscal_Year__c ='+'\''+Fisyear+'\' and AF_Created_By_Batch__c = true and AF_Locked__c = false';
        AF_BrandEstimate_Statuschange batchApex=new AF_BrandEstimate_Statuschange(query);
        ID batchprocessid = Database.executeBatch(batchApex,1);
    }

}