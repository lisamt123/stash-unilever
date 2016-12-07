@isTest

Public Class PQN_NewTargetExtensionTest{

// Test Class for the controller 

    Public static testMethod void testNewTargetExtension(){
        //Create a test Target record and insert it
        
      PQN_Targets__c target = new PQN_Targets__c();
     
        target.Year__c = '2016';
        target.Target_Reduction__c  = 10;
        target.Region_Geography__c = 'UK';
        insert target;
        
        ApexPages.StandardController stdTarget = new ApexPages.StandardController(target);

        
        
        // Set the page reference to the PQN_TargetEntryScreen_VF
        
        PageReference pageRef = Page.PQN_TargetEntryScreen_VF;
        pageRef.getParameters().put('id',target.id);
        Test.setCurrentPage(pageRef);
        
        PQN_NewTargetExtension ctrl = new PQN_NewTargetExtension(stdTarget);
        ctrl.saveTarget();
        
        
    }
    

}