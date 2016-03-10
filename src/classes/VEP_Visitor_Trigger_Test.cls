@isTest
private class VEP_Visitor_Trigger_Test{
    static testMethod void test_VEP_Visitor_Trigger(){
        VEP_Factory__c fact= new VEP_Factory__c();
        fact.name='Factory1';
        fact.category__c ='Category1';
        fact.Factory_Manager__c =userinfo.getuserid();
        insert fact;
        
        VEP_FactoryVisit__c Fsetting = new VEP_FactoryVisit__c();
        Fsetting.Name = 'Factory1';
        Fsetting.Travel_Desk_Email__c='test@xyz.com';
        Fsetting.Lodging_Desk_Email__c='test@xyz.com';
        insert Fsetting;
        
        List<VEP_Visitor__c> listVisitor = new List<VEP_Visitor__c>();
        VEP_Visitor__c visitor = new VEP_Visitor__c();
        Id robRecordTypeId = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request on Behalf').getRecordTypeId();
        Id rRecordTypeId = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request').getRecordTypeId();
        
        System.assert(rRecordTypeId != null);
        
        visitor.name='Test Visitor'; 
        visitor.Travel__c=true;
        visitor.lodging__c=true;
        visitor.pickup__c=true;
        visitor.recordtypeid = rRecordTypeId;
        visitor.status__c= 'Pending Approval';
        visitor.Factory_to_visit__c='Factory1';
        listVisitor.add(visitor); 
        
        System.assert(robRecordTypeId != null);
        VEP_Visitor__c visitor1 = new VEP_Visitor__c();
        visitor1.name='Test Visitor1'; 
        visitor1.status__c='Approved';
        visitor1.recordtypeid = robRecordTypeId;
        visitor1.Travel__c=true; 
        visitor1.lodging__c=true; 
        visitor1.pickup__c=true;
        visitor1.Factory_to_visit__c='Factory1';
        listVisitor.add(visitor1);    
        insert listVisitor;
        List<VEP_Visitor__c> listvepins = new List<VEP_Visitor__c>();
        listvepins = [select id from VEP_Visitor__c where id=:visitor.id or id=:visitor1.id];
        System.assertEquals(listVisitor.size(),listvepins.size());
        Test.startTest();        
        VEP_Visitor_TriggerHandler.vep_UpdateFactory(listVisitor);
        VEP_Visitor_TriggerHandler.vep_generatePassOnBehalf(listVisitor);
        Test.stopTest();
        VEP_Visitor__c lv = [select id,factory_manager__c from VEP_Visitor__c where id=:visitor.id];
        
        System.assertEquals(lv.factory_manager__c,fact.Factory_Manager__c);
        
        
      
        VEP_Visitor_Pass__c vp = [select id,Visitor__c from VEP_Visitor_Pass__c where Visitor__c=: visitor1.id limit 1];
        System.assertEquals(visitor1.id,vp.Visitor__c);
        
        
        
    }
}