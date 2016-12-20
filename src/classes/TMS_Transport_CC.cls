public class TMS_Transport_CC {
public TMS_Transporter_Management_Screen__c translist{get;set;}
public TMS_Transporter_Management_Screen__c transveh{get;set;}
public string vehicleNum{get;set;}
public string isDup{get;set;}
public string tmsid;

private ApexPages.StandardController GstdController;
    
    public TMS_Transport_CC(ApexPages.StandardController controller){
        GstdController = controller;
        translist = new TMS_Transporter_Management_Screen__c();
      translist = (TMS_Transporter_Management_Screen__c)controller.getRecord();
        tmsid=ApexPages.currentPage().getParameters().get('Id');
        try{
        translist = [SELECT Id, Name,Placement_Date__c,Customer__c,Transporter__c,Truck_Type__c,Truck_Number__c,Actual_Truck_Type__c,Reporting_Time__c,LR_Number__c  FROM TMS_Transporter_Management_Screen__c where id=:tmsid];
     //   transveh = [SELECT Id, Name,Placement_Date__c,Customer__c,Transporter__c,Truck_Type__c,Truck_Number__c,Actual_Truck_Type__c,Reporting_Time__c,LR_Number__c  FROM TMS_Transporter_Management_Screen__c];
        }catch(Exception e){}
    }
    public pagereference checkDuplicate(){
        List<TMS_Truck_Entry_Checklist__c> tmsveh =[select id,Vehicle_Number__c,Status__c,RFID__c,truck_Action__c,LR_Number__c from TMS_Truck_Entry_Checklist__c 
                                                    where Vehicle_Number__c=:translist.Truck_Number__c AND Status__c!='Exit' Limit 1];
        system.debug('tmsveh ->'+tmsveh);
        if(tmsveh.size()>0 ){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Vehicle with same number is already inside the Factory'));
           return null; 
        }
        else
        {
            PageReference pr = GstdController.save(); 
            return pr;
        }
        
    }
    public pagereference cancel(){
      PageReference pageRef = new PageReference('/a8j');
        pageRef.setRedirect(true);
        return pageRef;    
    }
}