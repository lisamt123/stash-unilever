@isTest
private class VEP_VisitorStatus_Test{
    static testMethod void test_VEP_VisitorStatus(){
        List<VEP_Visitor__c> listVisitor = new List<VEP_Visitor__c>();
        List<VEP_Visitor__c> listVisitorQ = new List<VEP_Visitor__c>();
        set<id> setVisitorIds = new Set<id>();
        
        VEP_FactoryVisit__c Fsetting = new VEP_FactoryVisit__c();
        Fsetting.Name = 'Factory1';
        Fsetting.Travel_Desk_Email__c='test@xyz.com';
        Fsetting.Lodging_Desk_Email__c='test@xyz.com';
        insert Fsetting;
        
        string sApproved= 'Approved';
        string showmessage = 'Please click on the correct URL that you have received';
        VEP_Visitor__c visitor = new VEP_Visitor__c();
        visitor.name='Test Visitor'; 
        visitor.Travel__c=true;
        visitor.lodging__c=true;
        visitor.pickup__c=true;
        visitor.Factory_to_visit__c='Factory1';
        listVisitor.add(visitor); 
        VEP_Visitor__c visitor1 = new VEP_Visitor__c();
        visitor1.name='Test Visitor1'; 
        visitor1.status__c=sApproved;
        visitor1.Travel_Approval_Status__c=sApproved;
        visitor1.Lodging_Approval_Status__c=sApproved;
        visitor1.Travel__c=true; 
        visitor1.lodging__c=true; 
        visitor1.pickup__c=true;
        visitor1.Factory_to_visit__c='Factory1';
        listVisitor.add(visitor1);    
        insert listVisitor;
        for(VEP_Visitor__c v: listVisitor){
            setVisitorIds.add(v.id);
        }
        listVisitorQ = [select id,VEp_number__c from VEP_Visitor__c where id in:setVisitorIds];
        System.assert(listVisitorQ != null);
        System.assert(listVisitorQ.size() >0 );        
                
        Apexpages.currentpage().getparameters().put('VEPnumber',listVisitorQ[1].VEP_number__c);
        Apexpages.currentpage().getparameters().put('TravelStatus',sApproved);
        VEP_VisitorStatus_CC vStatus4 = new VEP_VisitorStatus_CC();
        vStatus4.displayMsg();
        System.assertEquals(vStatus4.message,'Travel request is already Approved');
        
        Apexpages.currentpage().getparameters().put('TravelStatus','Approvedsfdf');
        VEP_VisitorStatus_CC vStatus5 = new VEP_VisitorStatus_CC();
        vStatus5.displayMsg();
        System.assertEquals(vStatus5.message, showmessage);
        
        Apexpages.currentpage().getparameters().put('VEPnumber',listVisitorQ[0].VEP_number__c);
        Apexpages.currentpage().getparameters().put('TravelStatus',sApproved);
        VEP_VisitorStatus_CC vStatus3 = new VEP_VisitorStatus_CC();
        vStatus3.displayMsg();
        System.assertEquals(vStatus3.message,'Travel request is Approved Visitor will be notified by an email');
                       
        Apexpages.currentpage().getparameters().put('VEPnumber',listVisitorQ[0].VEP_number__c);
        Apexpages.currentpage().getparameters().put('LodgingStatus',sApproved);
        VEP_VisitorStatus_CC vStatus6 = new VEP_VisitorStatus_CC();
        vStatus6.displayMsg();                      
        System.assertEquals(vStatus6.message, 'Lodging request is Approved Visitor will be notified by an email');
        VEP_Visitor__c vstatus = [select Lodging_Approval_Status__c,id from VEP_Visitor__c where VEP_number__c=: vStatus6.visitorId];
        system.assert(vstatus!=null);  
        System.assertEquals(vstatus.Lodging_Approval_Status__c,sApproved);


        Apexpages.currentpage().getparameters().put('VEPnumber',listVisitorQ[1].VEP_number__c);
        Apexpages.currentpage().getparameters().put('LodgingStatus',sApproved);
        VEP_VisitorStatus_CC vStatus7 = new VEP_VisitorStatus_CC(); 
             
        vStatus7.displayMsg();        
        System.assertEquals(vStatus7.message, 'Lodging request is already Approved');
        
        
        
        
        
        Apexpages.currentpage().getparameters().put('LodgingStatus','Approvedsfdf');
        VEP_VisitorStatus_CC vStatus8 = new VEP_VisitorStatus_CC();
        vStatus8.displayMsg();
        System.assertEquals(vStatus8.message, showmessage);
        
        
        
        
    }
}