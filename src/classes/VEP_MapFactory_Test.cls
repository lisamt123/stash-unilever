@isTest
private class VEP_MapFactory_Test{
    static testMethod void test_VEP_MapFactory_VF(){
        string Factoryname='Factory1';
    
        VEP_Factory__c fact= new VEP_Factory__c();
        fact.name=Factoryname;
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
        
        Test.startTest();
        
        VEP_MapFactory_CC mapfact = new VEP_MapFactory_CC();                      
        mapfact.factname=Factoryname;        
        mapfact.StateFactoryList();
        System.assertEquals(mapfact.factoryDetails.name,Factoryname);               
        mapfact.Back2Factories();
                                             
        VEP_MapFactory_CC mapfact1 = new VEP_MapFactory_CC();        
        mapfact1.targetField = fact.id;        
        mapfact1.SearchFactoryList();
        System.assert(mapfact1.factoryList!=null);
        System.assertEquals(mapfact1.factoryDetails.name,'Factory1');
        System.assertEquals(1, mapfact1.factoryList.size());
        mapfact1.factname='';
        mapfact1.StateFactoryList();
                
        mapfact1.gotoVFORMROB();
        
        
        pagereference pv= mapfact.gotoVFORM();
        
        Test.stopTest();
        
    }
}