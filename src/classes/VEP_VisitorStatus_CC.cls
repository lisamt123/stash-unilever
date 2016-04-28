/**********************************************************************
Name: VEP_VisitorStatus_CC
Purpose:
This Apex Class is used to Approve/Reject the Visitor Request by Factory Manager
VERSION   AUTHOR   DATE    
1.0       Leena   Jan-2016   
***********************************************************************/

Public with sharing class VEP_VisitorStatus_CC{
    public string visitorId{get; set;}    
    public string TravelStatus{get; set;}
    public string LodgingStatus{get; set;}
    public string message{get; set;}
    
    public VEP_VisitorStatus_CC(){       
        visitorId = Apexpages.currentpage().getparameters().get('VEPnumber');  
        TravelStatus =  Apexpages.currentpage().getparameters().get('TravelStatus');
        LodgingStatus =  Apexpages.currentpage().getparameters().get('LodgingStatus');     
    }
    public void displayMsg(){
        List<Vep_Visitor__c> listVisitor = new List<Vep_Visitor__c>();
        Vep_Visitor__c vRec = new Vep_Visitor__c();

        try{
                       
            if((VisitorId!=null && VisitorId!='') && (TravelStatus!=null || LodgingStatus!=null)){
                if(VisitorId !=null){
                    listVisitor = [select id,status__c,travel__c,lodging__c,Factory_to_visit__c,Lodging_Approval_Status__c,Travel_Approval_Status__c  from Vep_Visitor__c where VEp_number__c=:VisitorId ];
                }
                if(!listVisitor.isEmpty()){
                    vRec = listvisitor[0];
                }
                else{
                    message = label.VEP_Access_Err;
                }
                if(TravelStatus!=null && vRec!=null && (!listVisitor.isEmpty())){
                    if(TravelStatus == 'Approved' || TravelStatus == 'Rejected'){
                    if(VRec.Travel_Approval_Status__c == 'Approved' || VRec.Travel_Approval_Status__c == 'Rejected'){
                    message = 'Travel request is already ' + VRec.Travel_Approval_Status__c ;
                    
                    }
                    else{
                        vRec.Travel_Approval_Status__c = TravelStatus;
                        message = 'Travel request is '+TravelStatus+' Visitor will be notified by an email';
                        update vRec;
                    }
                    } 
                    else{
                        message = label.VEP_Status_ERR;
                    }   
                }
                if(LodgingStatus!=null && vRec!=null && (!listVisitor.isEmpty())){
                    if(LodgingStatus == 'Approved' || LodgingStatus == 'Rejected'){
                    if(VRec.Lodging_Approval_Status__c== 'Approved' || VRec.Lodging_Approval_Status__c== 'Rejected'){
                    message = 'Lodging request is already ' + VRec.Lodging_Approval_Status__c;
                    
                    }
                    else{
                        vRec.Lodging_Approval_Status__c= LodgingStatus;
                        message = 'Lodging request is '+LodgingStatus+' Visitor will be notified by an email';
                        update vRec;
                    } 
                    } 
                    else{
                        message = label.VEP_Status_ERR;
                    }    
                }
            }
        }
        Catch(Exception e){
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,e.getmessage() );
            ApexPages.addmessage(msg);
        }
        
    }
    
    
}