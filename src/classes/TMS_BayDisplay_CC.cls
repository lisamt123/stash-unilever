public with sharing class TMS_BayDisplay_CC {
public  Integer seconds{get;set;}
@AuraEnabled   
public List<TMS_Truck_Entry_Checklist__c> Bay {get; set;}
    public TMS_BayDisplay_CC(ApexPages.StandardController controller){
        Tms_PlantCode__c mcs = Tms_PlantCode__c.getInstance();
        seconds = 0;
        try
        {
           Bay=[select id,Truck_Type__c ,Bay_Description__c,Action__c,Bay_Number__c,Bay_Wait_Time__c,Vehicle_Number__c,Bay_Number_Updated__c from TMS_Truck_Entry_Checklist__c where (Action__c='Unload/Load Done' OR Action__c='Move To Bay' OR Action__c='Sample Accepted') AND Serial_Num__c=:mcs.Plant_Code__c ORDER BY Bay_Wait_Time__c ASC];
            
        }
        catch(Exception e) {} 
         
    }
    public void callMethod(){
    seconds = seconds +5;
  }
    
}