@isTest
private class VEP_VisitorPassonBehalf_Test{
    static testMethod void test_VEP_VisitorPassonBehalf_VF(){
        VEP_Visitor__c visitor = new VEP_Visitor__c();
        visitor.name='Test Visitor';        
        insert visitor;
        
        Test.startTest();
        VEP_Visitor_Pass__c visitorPass = new VEP_Visitor_Pass__c ();
        visitorPass.Visitor__c = visitor.id; 
        insert visitorPass;
        
        VEP_VisitorPassonBehalf rob = new VEP_VisitorPassonBehalf();
        rob.visitorId = visitor.id;
        System.assert(rob.getVisitorDetail() != null);
        rob.getVisitorDetail();
        Test.stopTest();
        
    }
}