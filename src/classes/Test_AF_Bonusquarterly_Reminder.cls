/**
 * Test_AF_Bonusquarterly_Reminder  : This Test class for AF_Bonusquarterly_Reminder apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AF_Bonusquarterly_Reminder  
{    
    
    Static testMethod void SchedulableContext()
    {
    date mydate=system.today();
    date daysBefore = mydate.adddays(-14);
    
    String curr;
    curr=string.valueOf(system.now().month());
    
    //custom setting
    //list<AF_BonusQuarterly_Quarterdates__c> Quarterly = new list <AF_BonusQuarterly_Quarterdates__c>();
    AF_BonusQuarterly_Quarterdates__c Quarter =new AF_BonusQuarterly_Quarterdates__c();
     //Quarterly.Cat Finance reminder=system.today();
     Quarter.Name = 'Sample Quarter';
     //Quarter.AF_Q1__c = system.today();
     //Quarter.AF_Q2__c = system.today();
     //Quarter.AF_Q3__c = system.today();
     Quarter.AF_Q1__c = daysBefore;
     Quarter.AF_Q2__c = daysBefore;
     Quarter.AF_Q3__c = daysBefore;
     insert Quarter;

     //insert send email
     Send_Email__c  send =new Send_Email__c ();
     send.sendEmailBonusQuartToCatFinance__c=true;
     send.Financial_Year__c=curr;
     send.URL_link_to_Agency_Fees__c = Label.AF_UrlLink;
     send.AF_Quarter__c='Q3' ;
     insert send;
     
     
     Test.StartTest();
     AF_BonusQuarterly_Reminder_schedule  BonusQuarterly =new AF_BonusQuarterly_Reminder_schedule();
     String CRON_VALUE = '0 0 3 ? * *';
     system.schedule('AF_Bonusquarterly_Reminder-yearly (TEST)', CRON_VALUE, BonusQuarterly);
     test.stopTest();
    
  }
}