global class AF_Bonusquarterly_Reminder implements Database.Batchable<sobject>{
     global string Temp='select AF_Q1__c,AF_Q2__c,AF_Q3__c from AF_BonusQuarterly_Quarterdates__c';
     
    global AF_Bonusquarterly_Reminder(){
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return database.getquerylocator(Temp);
   }
    
    global void execute(Database.BatchableContext BC, list<AF_BonusQuarterly_Quarterdates__c> catBonusQuartFinanceDate) { 
         String DayofMonth;
         DayofMonth=string.valueOf(system.now().month());
         AF_BonusQuarterly_Quarterdates__c BQ= AF_BonusQuarterly_Quarterdates__c.getOrgDefaults();
        if(catBonusQuartFinanceDate.size()>0){
            if(BQ.AF_Q1__c.addDays(14) == system.today() || BQ.AF_Q1__c.addDays(15) == system.today() || BQ.AF_Q1__c.addDays(16) == system.today() || BQ.AF_Q1__c.addDays(17) == system.today() || BQ.AF_Q1__c.addDays(18) == system.today() || BQ.AF_Q1__c.addDays(19) == system.today() || BQ.AF_Q2__c.addDays(14) == system.today() || BQ.AF_Q2__c.addDays(15) == system.today() || BQ.AF_Q2__c.addDays(16) == system.today() || BQ.AF_Q2__c.addDays(17) == system.today() || BQ.AF_Q2__c.addDays(18) == system.today() || BQ.AF_Q2__c.addDays(19) == system.today() || BQ.AF_Q3__c.addDays(14) == system.today() || BQ.AF_Q3__c.addDays(15) == system.today() || BQ.AF_Q3__c.addDays(16) == system.today() || BQ.AF_Q3__c.addDays(17) == system.today() || BQ.AF_Q3__c.addDays(18) == system.today() || BQ.AF_Q3__c.addDays(19) == system.today()){
                Send_Email__c NewEmailRecord= new Send_Email__c();
                NewEmailRecord.sendEmailBonusQuartToCatFinance__c = true;
                NewEmailRecord.Financial_Year__c =  String.valueOf(System.Today().year());
                if(DayofMonth=='5' || DayofMonth=='6'){
                NewEmailRecord.AF_Quarter__c = 'Q1';
                }
                else if(DayofMonth=='9' || DayofMonth=='10'){
                NewEmailRecord.AF_Quarter__c = 'Q2';
                }
                else if(DayofMonth=='11' || DayofMonth=='12'){
                NewEmailRecord.AF_Quarter__c = 'Q3';
                }
                NewEmailRecord.URL_link_to_Agency_Fees__c = Label.AF_UrlLink;
                insert NewEmailRecord;
                system.debug('NewEmailRecord....'+NewEmailRecord);
               
            }
        }
    }
    //finish Mehtod
    global void finish(Database.BatchableContext BC)
    {
        
    }
}