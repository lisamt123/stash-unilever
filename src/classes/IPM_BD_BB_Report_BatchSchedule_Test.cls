/***********************************************************************************************************
    @Description : Test class for IPM_BD_BB_Report_BatchSchedule Schedule apex class
    @Created Date: 14/10/2015
    @Author: Cognizant
    @Referenced: IPM_BD_BB_ReportScheduler
************************************************************************************************************/

@isTest
private class IPM_BD_BB_Report_BatchSchedule_Test {

/******************************************************************
 * @Description:Test method for a scheduler,Manipulating Project 
             related records & Performing an insert in IPM_Reporting  
* *****************************************************************/
    static testmethod void testReportScheduler(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(false)){
            test.starttest();
        
            //Insert data for Custom setting
            IPM_Reporting__c reportParameter = IPM_TestFactory_Helper.createIPMReportingCustomSetting('BD BB Report', true);
            List<IPM_Reporting__c>reportParameterlist=[SELECT Id FROM IPM_Reporting__c WHERE Id=:reportParameter.Id limit 1];
            system.assertNotEquals(reportParameterlist[0].Id,null,'Report Parameter record is not created'); //Negative test
                
            IPM_BD_BB_Report_BatchSchedule sch=new IPM_BD_BB_Report_BatchSchedule();
        
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            String jobId = System.schedule('BB_BD_Report', CRON_EXP, sch); 
        
        
            CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        
            System.assertEquals(CRON_EXP, ct.CronExpression,'Corn Expressions are not matching'); // Positive test
            System.assertEquals(0, ct.TimesTriggered,'Triggered time differs.. '); // Positive test
          
            test.stoptest();
        }
    }
}