global class AF_BonusQuaterlyEmailToCatFinance implements Schedulable
{
     String query;
     List<AF_BonusQuarterly__c> catBonusQuartFinanceDate=new  List<AF_BonusQuarterly__c>();
     
 
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) 
    {  
        catBonusQuartFinanceDate= [select AF_BonusQuarterlyDate__c from AF_BonusQuarterly__c];
        if(catBonusQuartFinanceDate.size()>0){
            if(catBonusQuartFinanceDate[0].AF_BonusQuarterlyDate__c == system.today()){
                Send_Email__c NewEmailRecord= new Send_Email__c();
                NewEmailRecord.sendEmailBonusQuartToCatFinance__c = true;
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