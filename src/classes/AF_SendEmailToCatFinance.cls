/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_SendEmailToCatFinance
   @CreateDate : 23/8/2014
   @Description : This is a batch class
   @              this is used to send email to category finance users.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
global with sharing class AF_SendEmailToCatFinance implements Database.Batchable<sobject>
{
    global String emailcatfinance='select AF_Date__c from AF_CatFinanceThreshold__c';
    private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
    /***********************************************************************************
*  @Description: this is the start method of the Batch class
*  @name : start
*  @param : ae
*  @return: none.
*************************************************************************************/  
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(emailcatfinance);
    }
    /***********************************************************************************
*  @Description: this is the execute method of the Batch class
*  @name : execute
*  @param : ctx
*  @return: none.
*************************************************************************************/  
    global void execute(Database.BatchableContext BC,List<AF_CatFinanceThreshold__c> catFinanceDate) 
    {  
       AF_CatFinanceThreshold__c Thershold = AF_CatFinanceThreshold__c.getOrgDefaults();
        if(catFinanceDate.size()>0){
            if(Thershold.AF_Date__c == system.today()){
                Send_Email__c NewEmailRecord= new Send_Email__c();
                NewEmailRecord.sendEmailToCatFinance__c = true;
                NewEmailRecord.Financial_Year__c =  String.valueOf(System.Today().year());
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
    /***********************************************************************************
*  @Description: this is the finish method of the Batch class
*  @name : finish
*  @param : BC
*  @return: none.
*************************************************************************************/
    global void finish(Database.BatchableContext BC)
    {
        system.debug('Batch class is completed');  
    }
}