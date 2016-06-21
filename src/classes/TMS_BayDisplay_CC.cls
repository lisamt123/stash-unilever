public with sharing class TMS_BayDisplay_CC {
public  Integer seconds{get;set;}
@AuraEnabled   
public List<TMS_Truck_Entry_Checklist__c> Bay {get; set;}
    public TMS_BayDisplay_CC(ApexPages.StandardController controller){
        seconds = 0;
        try
        {
           Bay=[select id,Truck_Type__c ,Bay_Description__c,Action__c,Bay_Number__c,Bay_Wait_Time__c,Vehicle_Number__c from TMS_Truck_Entry_Checklist__c where Action__c= 'Truck Reached Bay' OR Action__c='Unloading/Loading completed' OR Action__c='UnLoading/Loading' OR Action__c='Move To Bay'];
            
        }
        catch(Exception e) {} 
         
    }
    public void callMethod(){
    seconds = seconds +5;
  }
    
}