/***********************************************************************************************************
    @Description : Test class for IPM_OTIF_Report_BatchSchedule Schedule apex class
    @Created Date: 18/03/2015
    @Author: Cognizant
    @Referenced: IPM_OTIF_ReportScheduler
************************************************************************************************************/

@isTest
private class IPM_OTIF_Report_BatchSchedule_Test {

/******************************************************************
 * @Description:Test method for a scheduler,Manipulating Project 
             related records & Performing an insert in IPM_Reporting  
* *****************************************************************/
    static testmethod void testReportScheduler(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(false)){
            test.starttest();
        
            //Insert data for Custom setting
            IPM_Reporting__c reportParameter = IPM_TestFactory_Helper.createIPMReportingCustomSetting('OTIF Report', false);
            reportParameter.Batch_Size__c = 5;
            insert reportParameter; 
            
            List<IPM_Reporting__c> reportParameterlist = [SELECT Id,Name FROM IPM_Reporting__c WHERE Id=:reportParameter.Id limit 1];
            system.assertEquals(reportParameterlist[0].Name,reportParameter.Name,'Error in IPMReporting Custom Setting Creation'); //positive test
                
            IPM_OTIF_Report_BatchSchedule sch=new IPM_OTIF_Report_BatchSchedule();
        
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            String jobId = System.schedule('OTIF_Report', CRON_EXP, sch); 
        
        
            CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        
            System.assertEquals(CRON_EXP, ct.CronExpression,'Corn Expressions are not matching'); // Positive test
            System.assertEquals(0, ct.TimesTriggered,'Triggered time differs.. '); // Positive test
          
            test.stoptest();
        }
    }
}