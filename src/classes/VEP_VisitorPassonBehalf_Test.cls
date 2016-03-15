@isTest
private class VEP_VisitorPassonBehalf_Test{
    static testMethod void test_VEP_VisitorPassonBehalf_VF(){
        VEP_Visitor__c visitor = new VEP_Visitor__c();
        visitor.name='Test Visitor';        
        insert visitor;
        
        
        VEP_Visitor_Pass__c visitorPass = new VEP_Visitor_Pass__c ();
        visitorPass.Visitor__c = visitor.id; 
        insert visitorPass;
        
        Test.startTest();
        VEP_VisitorPassonBehalf rob = new VEP_VisitorPassonBehalf();
        rob.visitorId = visitor.id; 
        system.assert(rob.visitorId!=null);       
        VEP_Visitor_Pass__c vtest= rob.getVisitorDetail();  
        //VEP_Visitor_Pass__c vpass = [select id,name,visitor__r.name from VEP_Visitor_Pass__c where id =: visitorPass.id];           
        System.assertEquals(vtest.visitor__r.name,'Test Visitor');
        Test.stopTest();
        System.assertEquals(vtest.visitor__c,visitor.id);
    }
}