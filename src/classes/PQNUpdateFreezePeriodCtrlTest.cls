@isTest
private class PQNUpdateFreezePeriodCtrlTest {
       public static testMethod void TestPQNUpdateFreezePeriodCtrl(){
    
     Test.startTest();
     
     list<PQNFreezeDate__c> pqn=new list<PQNFreezeDate__c>();
     PQNFreezeDate__c date1=new PQNFreezeDate__c();
     date1.name='january';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date1.Freeze_Date__c=system.today();
     date1.Numeric_Value__c=1;
     
      PQNFreezeDate__c date2=new PQNFreezeDate__c();
     date2.name='Februwary';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date2.Freeze_Date__c=system.today();
     date2.Numeric_Value__c=2;
     
      PQNFreezeDate__c date3=new PQNFreezeDate__c();
     date3.name='march';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date3.Freeze_Date__c=system.today();
     date3.Numeric_Value__c=3;
     
      PQNFreezeDate__c date4=new PQNFreezeDate__c();
     date4.name='april';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date4.Freeze_Date__c=system.today();
     date4.Numeric_Value__c=4;
     
      PQNFreezeDate__c date5=new PQNFreezeDate__c();
     date5.name='may';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date5.Freeze_Date__c=system.today();
     date5.Numeric_Value__c=5;
     
      PQNFreezeDate__c date6=new PQNFreezeDate__c();
     date6.name='june';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date6.Freeze_Date__c=system.today();
     date6.Numeric_Value__c=6;
     
      PQNFreezeDate__c date7=new PQNFreezeDate__c();
     date7.name='july';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date7.Freeze_Date__c=system.today();
     date7.Numeric_Value__c=7;
     
      PQNFreezeDate__c date8=new PQNFreezeDate__c();
     date8.name='august';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date8.Freeze_Date__c=system.today();
     date8.Numeric_Value__c=8;
     
      PQNFreezeDate__c date9=new PQNFreezeDate__c();
     date9.name='september';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date9.Freeze_Date__c=system.today();
     date9.Numeric_Value__c=9;
     
      PQNFreezeDate__c date10=new PQNFreezeDate__c();
     date10.name='October';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date10.Freeze_Date__c=system.today();
     date10.Numeric_Value__c=6;
     
      PQNFreezeDate__c date11=new PQNFreezeDate__c();
     date11.name='november';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date11.Freeze_Date__c=system.today();
     date11.Numeric_Value__c=6;
     
      PQNFreezeDate__c date12=new PQNFreezeDate__c();
     date12.name='december';
     //date1.Freeze_Date__c=Date.newInstance(2017 , 01 ,01);
     date12.Freeze_Date__c=system.today();
     date12.Numeric_Value__c=12;
     
     pqn.add(date12);
     pqn.add(date11);
     pqn.add(date10);
     pqn.add(date9);
     pqn.add(date8);
     pqn.add(date7);
     pqn.add(date6);
     pqn.add(date5);
     pqn.add(date4);
     
     pqn.add(date3);
     
     pqn.add(date2);
     
     
     
     pqn.add(date1);
     
     insert pqn;
     
    PQNUpdateFreezePeriodCtrl freez=new PQNUpdateFreezePeriodCtrl();
    freez.getResult();
    freez.updateFreezePeriod();
    
    
   
     Test.stopTest();
     }
          
      
}