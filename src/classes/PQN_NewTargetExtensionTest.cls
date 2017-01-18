@isTest

Public Class PQN_NewTargetExtensionTest{

// Test Class for the controller 

    Public static testMethod void testNewTargetExtension(){
        //Create a test Target record and insert it
        
      PQN_Targets__c target = new PQN_Targets__c();
     
        target.Year__c = '2016';
        target.Target_Reduction__c  = 10;
        target.Region__c= 'UK';
        insert target;
        
        ApexPages.StandardController stdTarget = new ApexPages.StandardController(target);

        
        
        // Set the page reference to the PQN_TargetEntryScreen_VF
        
        PageReference pageRef = Page.PQN_TargetEntryScreen_VF;
        pageRef.getParameters().put('id',target.id);
        Test.setCurrentPage(pageRef);
        
        PQN_NewTargetExtension ctrl = new PQN_NewTargetExtension(stdTarget);
        ctrl.saveTarget();
        ctrl.cancelTarget();
        
        PageReference pageRef1 = Page.PQN_TargetEntryScreen_VF;
        pageRef1.getParameters().put('',target.id);
        Test.setCurrentPage(pageRef1);
        
        PQN_NewTargetExtension ctrl1 = new PQN_NewTargetExtension(stdTarget);
        ctrl1.saveTarget();
        ctrl1.cancelTarget();
        
        
    }
    

}