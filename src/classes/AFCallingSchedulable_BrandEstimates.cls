global class AFCallingSchedulable_BrandEstimates
  {
    public static void start()
      {
        AF_BrandEstimate_TriggerDate__c ABT = AF_BrandEstimate_TriggerDate__c.getOrgDefaults();
        //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        if(ABT.AF_Currency_Uploaded__c == true && (ABT.AF_Trigger_Date__c == system.today() || ABT.AF_Trigger_Date__c < system.today())) {
          System.schedule('BrandEstimatesBatch', '0 45 16 * * ?', new SchedulableToBrandEstimatesBatch());
        }
      }

  }