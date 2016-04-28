/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Bonusquarterly_Reminder
@CreateDate : 21/6/2014
@Description : This is a batch class to check the bonus quarterly and trigger's email to the Agency users
@               
@Version : 1.0
@reference : none
***********************************************************************************/
global with sharing class AF_Bonusquarterly_Reminder implements Database.Batchable<sobject>{
    global string Temp='select AF_Q1__c,AF_Q2__c,AF_Q3__c from AF_BonusQuarterly_Quarterdates__c';
    private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
    global AF_Bonusquarterly_Reminder(){
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return database.getquerylocator(Temp);
    }
    /*****************************************************************************************************************************
@Author :Cognizant
@name : execute
@CreateDate : 21/6/2014
@Description : This is method execute and trigger emails to the users
@               
@Version : 1.0
@reference : none
***********************************************************************************/
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
                    NewEmailRecord.AF_Quarter__c = AF_Constants.QUARTER1;
                }
                else if(DayofMonth=='9' || DayofMonth=='10'){
                    NewEmailRecord.AF_Quarter__c = AF_Constants.QUARTER2;
                }
                else if(DayofMonth=='11' || DayofMonth=='12'){
                    NewEmailRecord.AF_Quarter__c = AF_Constants.QUARTER3;
                }
                NewEmailRecord.URL_link_to_Agency_Fees__c = Label.AF_UrlLink;
                try{
                insert NewEmailRecord;
                }
                catch(Exception e)
        		{
           	 		AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'execute',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            		apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert)); 
       			 }
            }
        }
    }
    //finish Method
    global void finish(Database.BatchableContext BC)
    {
        system.debug('Batch execution finsihed');  
    }
}