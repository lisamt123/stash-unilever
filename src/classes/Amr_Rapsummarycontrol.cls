public class Amr_Rapsummarycontrol{ 
public List<Amr_Job_Details__c> Records {get; set;} 
public Amr_Rapsummarycontrol(){ 
Records = 
[select AdManagerText__c,Production_Activity__c,NewOriginalMaster__c from Amr_Job_Details__c]; 
} 
}