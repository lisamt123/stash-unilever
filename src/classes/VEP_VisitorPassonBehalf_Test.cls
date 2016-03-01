@isTest
private class VEP_VisitorPassonBehalf_Test{
    static testMethod void testMethod1(){
        VEP_Visitor__c visitor = new VEP_Visitor__c();
        visitor.name='Test Visitor';        
        insert visitor;
        
        VEP_Visitor_Pass__c visitorPass = new VEP_Visitor_Pass__c ();
        visitorPass.Visitor__c = visitor.id; 
        insert visitorPass;
        
        VEP_VisitorPassonBehalf rob = new VEP_VisitorPassonBehalf();
        rob.visitorId = visitor.id;
        rob.getVisitorDetail();
        
    }
}