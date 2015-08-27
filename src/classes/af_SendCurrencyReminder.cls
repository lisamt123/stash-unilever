global class af_SendCurrencyReminder implements Schedulable
{
    
    global void execute(SchedulableContext ctx) 
    {  
        //Boolean IsthisCalledfromTest;
        String DayofMonth;
        if(!Test.isRunningtest())
        {
            DayofMonth=string.valueOf(system.now().day());
        }
        else
        {
           DayofMonth='01';
        }
          

		if(DayofMonth=='01')
		{
    		Send_Email__c mynewmail = new Send_Email__c();
    		mynewmail.AF_CurrencyUpdateRequired__c = true;
    		insert mynewmail;
		}
        
    }
    //finish Mehtod
    global void finish(Database.BatchableContext BC)
    {
        
    }

}