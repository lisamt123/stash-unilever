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
        system.assert(vtest!=null);                    
        System.assertEquals(vtest.visitor__r.name,'Test Visitor');
        Test.stopTest();
        
    }
}