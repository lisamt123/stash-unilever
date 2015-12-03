/*************************************************************************************************************************
Class Name      :  uw_BET_schedule_batch_recalculatemem_TEST
Class Desc.     :  Test class for class Uw_BET_Batch_Recalculatemembers and uw_BET_schedule_recalculatemembersbatch .
                    uw_BET_schedule_recalculatemembersbatch class is to schedule  batch-
                    Uw_BET_Batch_Recalculatemembers, which populate the existing BET records' total
                    number of members
Author          :       Accenture UK

Change History
****************Date          Author       version             Description                       Requested By           Tag
----------------------------------------------------------------------------------------------------------------------------
Dec-2013         Accenture UK  0.01            Initial build of class for BET 2.0                Unilever                                           
***************************************************************************************************************************/

@istest
public with sharing class uw_BET_schedule_batch_calculatemem_TEST{

static testMethod void schedulebatch()
{
        
        
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        //Create brandcentre
        uw_Brand__c brandcentre = new uw_Brand__c(name = 'testbrandcentre');
         insert brandcentre;

//Create 5 bet records for so that owner is running user                
          list <uw_bet__c> betlists = new list <uw_bet__c>();
          for(integer i = 0;i<5;i++)
          {
               uw_Inoplan_Project__c projObj = uw_UnitTestDataFactory.createInoplan();
               insert projObj ;
               uw_BET__c bet = new  uw_BET__c ( Name = 'BTestToolkit'+i,uw_Brand__c = brandcentre.id, Inoplan_Project__c = projObj.id, Product_Category_Sub_Division__c ='Cross Category',Status__c = 'First release',Market_Clusters__c = 'Global');
            
            betlists.add(bet);
          }                 
          insert betlists;
          
  
        Test.startTest();
        uw_BET_schedule_recalculatemembersbatch obj = new uw_BET_schedule_recalculatemembersbatch();                
        String jobId = system.schedule('test', sch, obj);        
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger where id = :jobId];        
        System.assertEquals(sch, ct.CronExpression);  
        //Start batch testing        
          Database.QueryLocator QL;
          string query = 'select id,Total_Number_of_Members__c from uw_bet__c';
          list<uw_bet__C> betbatch = new list<uw_bet__C>();
          Database.BatchableContext bc;
          Uw_BET_Batch_Recalculatemembers objbatch =new Uw_BET_Batch_Recalculatemembers(query);
          ql = objbatch.start(bc);
          
          
          //Iterate through the records and form betlist
          Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext())
        {
            uw_bet__C bet = (uw_bet__C)QIT.next();            
            betbatch.add(bet);
        }        
          
          objbatch.execute(bc,betbatch);
          objbatch.finish(bc);                                           
         
        Test.stopTest();


}
}