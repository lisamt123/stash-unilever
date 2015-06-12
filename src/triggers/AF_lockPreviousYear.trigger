trigger AF_lockPreviousYear on AF_Currency__c (before update) 
{
  /* if(trigger.isafter)
    {
        boolean lockPYear = false;    
        for(AF_Currency__c ac:trigger.new)
        {    
            System.debug('@@@@@ac.AF_Fiscal_Year_new__c@@'+ ac.AF_Fiscal_Year_new__c);
            System.debug('*****systemtoday****'+ String.valueOf( system.today().year()));
            if(ac.AF_Fiscal_Year_new__c == String.valueOf( system.today().year()))
            {
                lockPYear = true;
            }
        }
        if(lockPYear == true)
        AF_LockPreviousYearRecords.lockPrevious(lockPYear);
    }
    */
    if(trigger.isbefore)
    {
         for(AF_Currency__c Afc:trigger.new)
         {
             
             if(Afc.Locked__c == true)
                 if(afc.AF_Average_Exchange_Rate_To_EUR__c!=trigger.oldmap.get(afc.id).AF_Average_Exchange_Rate_To_EUR__c)
                     afc.AF_Average_Exchange_Rate_To_EUR__c.adderror(Label.AF_Lock);
         }        
    }
    if(trigger.isupdate)
    {
       for(af_currency__C af : trigger.new)
       {
           if(af.AF_Fiscal_Year_new__c != null && integer.valueof(af.AF_Fiscal_Year_new__c) < date.today().year())
              af.locked__C = true;
       }
    }
}