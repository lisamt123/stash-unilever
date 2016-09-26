/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_BonusQuaterlyEmailToCatFinance
   @CreateDate : 1/8/2014
   @Description : This is a controller class is a Batch class, 
   @              this is used to trigger emails to category finance users to input the Bonus Results.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
global with sharing class AF_BonusQuaterlyEmailToCatFinance implements Database.Batchable<sobject>
{
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
    global String query='select AF_Q1__c,AF_Q2__c,AF_Q3__c from AF_BonusQuarterly_Quarterdates__c';
    /***********************************************************************************
*  @Description: this method is start method of the Batch class
*  @name : start
*  @param : Database.BatchableContext
*  @return: Database.QueryLocator.
*************************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    /********************************************************************************************
*  @Description: this method is execute method of the Batch class,which query the custom settings
*  @name : execute
*  @param : SchedulableContext
*  @return: None.
***********************************************************************************************/
    global void execute(Database.BatchableContext BC,List<AF_BonusQuarterly_Quarterdates__c> catBonusQuartFinanceDate) 
    {  
        String DayofMonth;
        DayofMonth=string.valueOf(system.now().month());
        AF_BonusQuarterly_Quarterdates__c quarter=AF_BonusQuarterly_Quarterdates__c.getOrgDefaults();
        if(catBonusQuartFinanceDate.size()>0){
            if(quarter.AF_Q1__c == system.today() || quarter.AF_Q2__c == system.today() || quarter.AF_Q3__c == system.today()){
                Send_Email__c NewEmailRecord= new Send_Email__c();
                NewEmailRecord.sendEmailBonusQuartToCatFinance__c = true;
                NewEmailRecord.Financial_Year__c =  String.valueOf(System.Today().year());
                if(DayofMonth=='5'){
                    NewEmailRecord.AF_Quarter__c = AF_Constants.QUARTER1;
                }
                else if(DayofMonth=='9'){
                    NewEmailRecord.AF_Quarter__c = AF_Constants.QUARTER2;
                }
                else if(DayofMonth=='11'){
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
    /********************************************************************************************
*  @Description: this method is finish method of the Batch class
*  @name : finish
*  @param : Database.BatchableContext
*  @return: None.
***********************************************************************************************/
    //finish Mehtod
    global void finish(Database.BatchableContext BC)
    {
        system.debug('Batch execution completed');
    }
}