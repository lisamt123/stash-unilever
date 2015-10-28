global class AF_BonusQuaterlyEmailToCatFinance implements Schedulable
{
     String query;
     List<AF_BonusQuarterly_Quarterdates__c> catBonusQuartFinanceDate=new  List<AF_BonusQuarterly_Quarterdates__c>();
     
 
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) 
    {  
         String DayofMonth;
         DayofMonth=string.valueOf(system.now().month());
        catBonusQuartFinanceDate= [select AF_Q1__c,AF_Q2__c,AF_Q3__c from AF_BonusQuarterly_Quarterdates__c];
        if(catBonusQuartFinanceDate.size()>0){
            if(catBonusQuartFinanceDate[0].AF_Q1__c == system.today() || catBonusQuartFinanceDate[0].AF_Q2__c == system.today() || catBonusQuartFinanceDate[0].AF_Q3__c == system.today()){
                Send_Email__c NewEmailRecord= new Send_Email__c();
                NewEmailRecord.sendEmailBonusQuartToCatFinance__c = true;
                NewEmailRecord.Financial_Year__c =  String.valueOf(System.Today().year());
                if(DayofMonth=='5'){
                NewEmailRecord.AF_Quarter__c = 'Q1';
                }
                else if(DayofMonth=='9'){
                NewEmailRecord.AF_Quarter__c = 'Q2';
                }
                else if(DayofMonth=='11'){
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