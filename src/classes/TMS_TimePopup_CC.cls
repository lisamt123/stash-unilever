public with sharing class TMS_TimePopup_CC {
public string tmscid{get;set;}
public TMS_Truck_Entry_Checklist__c Tsentry{get;set;}
public decimal updatedtime {get;set;}
public string selectedTime{get;set;}
public time seltime {get;set;}
   
    public TMS_TimePopup_CC(){
     tmscid = ApexPages.currentPage().getParameters().get('tid');
     Tsentry = new TMS_Truck_Entry_Checklist__c();
     Tsentry = [select id,name,Bay_Wait_Time__c,Vehicle_Number__c,Bay_Number__c from TMS_Truck_Entry_Checklist__c WHERE id=:tmscid];
     //system.debug('Tsentry-->'+Tsentry);
                                                           
    }
     
    public void updatetime(){     
      
      Time dt = seltime;
      string str1 = string.valueOf(dt);
      string str2 = str1.subString(0,5);
      Tsentry.Bay_Wait_Time__c=str2;
      update Tsentry;
      
    }
    
}