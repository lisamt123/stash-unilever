global class AF_SendEmailToCatFinance implements Schedulable
{
     String query;
     List<AF_CatFinanceThreshold__c> catFinanceDate=new  List<AF_CatFinanceThreshold__c>();
     
 
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) 
    {  
        catFinanceDate = [select AF_Date__c from AF_CatFinanceThreshold__c];
        if(catFinanceDate.size()>0){
            if(catFinanceDate[0].AF_Date__c == system.today()){
                Send_Email__c NewEmailRecord= new Send_Email__c();
                NewEmailRecord.sendEmailToCatFinance__c = true;
                NewEmailRecord.Financial_Year__c =  String.valueOf(System.Today().year());
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