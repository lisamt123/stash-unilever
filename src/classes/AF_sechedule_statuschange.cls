global class AF_sechedule_statuschange
  {
    public static void start()
      {
          profile p = [select id from profile where name =: 'System Administrator'];
          AF_AfterBatch_Trigger__c ABT = AF_AfterBatch_Trigger__c.getInstance(p.id); 

          date d = abt.AF_Date__c;
          //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
          string timeinterval = '0 05 17 ' +d.day()+ ' '+ d.month() + ' ' + '?';
          System.schedule('Status Change Batch',timeinterval, new SchedulableTo_Statuschange());
        
      }

  }