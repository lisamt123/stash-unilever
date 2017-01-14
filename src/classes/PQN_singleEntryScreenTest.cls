@isTest
private class PQN_singleEntryScreenTest{
    private static testMethod void testPQN_singleEntryScreen(){
    Test.startTest();
    
         list<PQNFreezeDate__c> freezeDateList=new list<PQNFreezeDate__c>();
     PQNFreezeDate__c date1=new PQNFreezeDate__c();
     date1.name='January';
     //date1.Freeze_Date__c=Date.newInstance(20,1,2016);
     date1.Freeze_Date__c=system.today()- 1;
     date1.Numeric_Value__c=1;
     freezeDateList.add(date1);
     insert freezeDateList;
     
     PQN_Pallet_Loss_Tree__c lossCode = new PQN_Pallet_Loss_Tree__c();
     lossCode.Name = '123';
lossCode.Explanations__c = 'testing';
lossCode.Loss_Code__c = 12345;
lossCode.Loss_L1__c = 'testing';
lossCode.Loss_L2__c = 'testing';
lossCode.Loss_L3__c = 'testing';
lossCode.Loss_L4__c = 'testing';
insert lossCode;
                    integer err=0;
                   ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Supplier is not found.');
                   ApexPages.addMessage(myMsg1);  
                   err++;
     
        
        PQN_Supplier__c s=PQN_TestLibraryUtil.createSupplier();
        insert s;
        
         account acc=PQN_TestLibraryUtil.createpqnAccount('DC1','India');
         acc.PQN_Country__c = 'India';
         insert acc;
        PQN_User_Creation_Request__c userCreationRequest = PQN_TestLibraryUtil.createUserCreationRequest();
        insert userCreationRequest;
        user u=PQN_TestLibraryUtil.createPQNUser();
       // u.country = 'India';
        insert u;
        
     
        PQN_Pallet_Quality_Non_Conformance__c pqn=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(s.id,acc.id,null);
        pqn.region__c = 'Europe';
        pqn.Date_Pallet_Received__c = system.today();
        insert pqn;
        
         PQN_Targets__c t = new PQN_Targets__c();
        t.Year__c = string.valueof(system.today().year());
        t.Target_Reduction__c=12;
        t.Target__c='23';
        t.Region__c = 'Europe';
        insert t;
         
        PageReference pageRef = Page.PQN_SingleEntryScreen_VF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', pqn.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(pqn);
        PQN_singleEntryScreen testPQN = new PQN_singleEntryScreen(sc);
        
        testPQN.validate();
        testPQN .savePQN();
        testPQN .cancelPQN();
        testPQN.checkFreezePeriod();
                
        PageReference pageRef1 = Page.PQN_SingleEntryScreen_VF;
        Test.setCurrentPage(pageRef1);
   
        ApexPages.StandardController sc1 = new ApexPages.StandardController(pqn);
        PQN_singleEntryScreen testPQN1 = new PQN_singleEntryScreen(sc1);
        testPQN1.validate();
        
        testPQN1.savePQN();
        testPQN1.cancelPQN();
        testPQN1.checkFreezePeriod();
        testPQN1.Target_update();
        testPQN1.DC_Vol_update();
        testPQN1.assignAccount();
        
        Apexpages.currentPage().getParameters().put('skuName',pqn.SKU__c);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(pqn);
        PQN_singleEntryScreen testPQN2 = new PQN_singleEntryScreen(sc2);
        testPQN2.validate();
              
        Apexpages.currentPage().getParameters().put('skuname','' );
        ApexPages.StandardController sc3 = new ApexPages.StandardController(pqn);
        PQN_singleEntryScreen testPQN3 = new PQN_singleEntryScreen(sc3);
        testPQN3.validate();
        
        Apexpages.currentPage().getParameters().put('suppname','abc' );
        ApexPages.StandardController sc5 = new ApexPages.StandardController(s);
        PQN_singleEntryScreen testPQN5 = new PQN_singleEntryScreen(sc5);
        testPQN5.validate();
        //testPQN5.pqn.supplier_type__c='';
        //testPQN5.pqn.supplier__c='';
        //testPQN5.pqn.supplier_number__c=null;
        testPQN5.validateIte('153489','def','116'); 
        
        Apexpages.currentPage().getParameters().put('skuname','2#2' );
        ApexPages.StandardController sc4 = new ApexPages.StandardController(pqn);
        PQN_singleEntryScreen testPQN4 = new PQN_singleEntryScreen(sc4);
        testPQN4.validate();
        testPQN4.validateIte('153489','Test Account Name','116'); 
        testPQN5.validateIte('153489','def','12345'); 
        
        Apexpages.currentPage().getParameters().put('userinfo.getusertype()','PowerPartner');
        Apexpages.currentPage().getParameters().put('err',null);
        ApexPages.StandardController sc6 = new ApexPages.StandardController(pqn);
        PQN_singleEntryScreen testPQN6 = new PQN_singleEntryScreen(sc6);
        testPQN6.sup=s;
        testPQN6.validate();
        testPQN6 .savePQN();
        testPQN6.cancelPQN();
        testPQN6.Target_update();
        testPQN6.DC_Vol_update();
        testPQN6.assignAccount();
        
       
        testPQN5.Target_update();
               
               
    Test.stopTest();
    }
    
        }