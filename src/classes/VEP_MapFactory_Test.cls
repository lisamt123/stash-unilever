@isTest
private class VEP_MapFactory_Test{
    static testMethod void testMethod1(){
        VEP_Factory__c fact= new VEP_Factory__c();
        fact.name='Factory1';
        fact.category__c ='Category1';
        insert fact;
        
        List<Vep_Visitor__c> listvisitor = new List<Vep_Visitor__c>();
        Vep_Visitor__c visitor1 = new Vep_Visitor__c();
        visitor1.name= 'Test Visitor1';
        visitor1.status__c='Approved';
        visitor1.email__c=userinfo.getuseremail();
        listvisitor.add(visitor1);
        Vep_Visitor__c visitor2 = new Vep_Visitor__c();
        visitor2.name= 'Test Visitor2';
        visitor2.status__c='Rejected';
        visitor2.email__c=userinfo.getuseremail();
        listvisitor.add(visitor2);
        Vep_Visitor__c visitor3 = new Vep_Visitor__c();
        visitor3.name= 'Test Visitor3';
        visitor3.status__c='Pending Visit';
        visitor3.email__c=userinfo.getuseremail();
        listvisitor.add(visitor3);
        Vep_Visitor__c visitor4 = new Vep_Visitor__c();
        visitor4.name= 'Test Visitor4';
        visitor4.status__c='Pending Approval';
        listvisitor.add(visitor4);
        visitor4.email__c=userinfo.getuseremail();
        insert listvisitor;
        
        VEP_MapFactory_CC mapfact = new VEP_MapFactory_CC();
        Apexpages.currentPage().getParameters().put('searchnameparam','Factory1');
        system.CurrentPageReference().getParameters().put('searchcatparam','Category1');
        mapfact.SearchFactoryList();
        mapfact.factname='Factory1';
        mapfact.StateFactoryList();
        mapfact.gotoVFORM();
        mapfact.Back2Factories();
        
       /* Apexpages.currentPage().getParameters().put('searchnameparam','');
        mapfact.SearchFactoryList();
        
        Apexpages.currentPage().getParameters().put('searchnameparam','Factory1');
        system.CurrentPageReference().getParameters().put('searchcatparam','');
        mapfact.SearchFactoryList();*/
        

       
        VEP_MapFactory_CC mapfact1 = new VEP_MapFactory_CC();
        mapfact1.targetField = fact.id;
        mapfact1.SearchFactoryList();
        mapfact1.factname='';
        mapfact1.StateFactoryList();
        mapfact1.gotoVFORMROB();
        
    }
}