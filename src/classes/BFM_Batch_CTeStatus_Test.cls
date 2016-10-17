@isTest
private class BFM_Batch_CTeStatus_Test{   
    private static testMethod void BFM_Batch_CTeStatus(){
    
 List<BFM_CT_e__c> lst=new List<BFM_CT_e__c>();

for(integer i=0;i<1500;i++) {
BFM_CT_e__c t=new BFM_CT_e__c();
t.CT_e_key__c= 'T'+i;
t.Cte_Emission_date_time__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
t.CT_e_Request_for_Cancel__c=true;

lst.add(t);
 }
 Test.startTest();  


 BFM_Batch_CTeStatus obj=new BFM_Batch_CTeStatus();
Database.executeBatch(obj);

//obj.execute();
Test.stopTest();

}

 }