@isTest 
private class Oblix_Ctrl09_nonCampaignEdit_Test {

  

    private static  id createMaketingSow (){
      
         Account myAccount = new Account();
             myAccount.Name = 'AgencyAccount';
         insert myAccount;
         Marketing_SOW__c marketingSow = new Marketing_SOW__c();
            marketingSow.Active__c = true;
            marketingSow.Name = 'Marketinf Sow Approval';
            marketingSow.SOW_Status__c = 'Open';
            marketingSow.Financial_Year__c = 'FY2015';
            marketingSow.Oblix_AgencyEstimate__c = myAccount.Id;
            insert marketingSow;
            MDO_Geography__c geographyRegion = new MDO_Geography__c();
            geographyRegion.Name = 'Europe';
            geographyRegion.geography_type__c = 'Region';
            insert geographyRegion;
          
          MDO_Geography__c geographyCountry = new MDO_Geography__c();
            geographyCountry.Name = 'France';
            geographyCountry.geography_type__c = 'Country Cluste';
            geographyCountry.parent_L5__c = geographyRegion.Id;
            insert geographyCountry;  
          Oblix_Calculator__c roleRate = new Oblix_Calculator__c();
              roleRate.Agency_Department__c = 'Account Management';
              roleRate.Role_Title__c = 'Global Account Head';
              roleRate.OblixCountry__c = geographyCountry.Id;
              roleRate.FTE__c = 20;
              roleRate.Role_Daily_Rate_EUR__c = 10;
              roleRate.Financial_Year__c = marketingSow.Financial_Year__c ;
              roleRate.RecordTypeId = Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Role_Rate');
              roleRate.Oblix_Agency__c = marketingSow.Oblix_AgencyEstimate__c;
              insert roleRate; 
          String marKObjName = 'Marketing_Basics__c';
          Marketing_Basics__c basicParent = new Marketing_Basics__c();
            basicParent.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParent.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Resource');
            basicParent.OblixCountry__c = geographyCountry.Id;
            basicParent.OblixOtherItemFee__c  = 33;
            insert basicParent;
            
      Marketing_Basics__c basicParent1 = new Marketing_Basics__c();
            basicParent1.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParent1.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Resource');
            basicParent1.FTE__c = 50;
            basicParent1.OblixCountry__c = geographyCountry.Id;
            basicParent1.OblixOtherItemFee__c  = 33;
            insert basicParent1;
          
            
          Marketing_Basics__c basicParentActivity = new Marketing_Basics__c();
            basicParentActivity.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParentActivity.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Activity');
            basicParentActivity.OblixCountry__c = geographyCountry.Id;
          Marketing_Basics__c basicParentActivity1 = new Marketing_Basics__c();
            basicParentActivity1.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParentActivity1.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Activity');  
            //basicParentActivity1.FTE__c = 50;
            basicParentActivity1.No_of_Hours_Required__c = 10;
            basicParentActivity1.OblixCountry__c = geographyCountry.Id;
            insert basicParentActivity1;
            
            return basicParent.id; 
        
    }
 
    static testMethod void CampaignEdit_Test() {
        
        User u = Oblix_TestUtils.createTestUser(); 
         
        System.runAs(u){
            Marketing_SOW__c marketingSow = new Marketing_SOW__c();
                marketingSow.Active__c = true;
                marketingSow.Name = 'Marketinf Sow Approval Test';
                marketingSow.SOW_Status__c = 'Open';
                marketingSow.Financial_Year__c = 'FY2015';
                insert marketingSow;
                
           
                
           
                Test.startTest();
                    PageReference pageref = Page.Oblix_VF09_nonCampaignEdit; 
                       Test.setCurrentPage(pageref) ;
                        pageRef.getParameters().put('itm', createMaketingSow() );
                  Oblix_Ctrl09_nonCampaignEdit controller = new Oblix_Ctrl09_nonCampaignEdit();
                 //   System.assertEquals(controller.asset.Id, asset.Id); // assert that the controller take the ID from params
                 //controller.addnewItems();
                 controller.back();
                 controller.backtoSow();
                 controller.getsomme();
                 controller.saveList();
                 
                 //test insert activity
        controller.myAct.lookupActivity.Other_Activities__c = 'test';  
        controller.myAct.name='istest';
        controller.myAct.selectedCountryname ='France' ;
        controller.fillAgencyDepartment();
        controller.myAct.selectedAgencyDepartment= 'Account Management';
        controller.fillRoleTitle();
        controller.myAct.selectedRoleTitle  = 'Global Account Head'  ; 
        controller.fillRate();
        controller.myAct.Rate = '10';       
        controller.myAct.val =2;
        controller.calculResult();
        
        controller.addToNew();
               
               
                 //test insert ressource
        
      
        controller.myRes.selectedCountryname ='France' ;
        controller.fillAgencyDepartment1();
        controller.myRes.selectedAgencyDepartment= 'Account Management';
        controller.fillRoleTitle1();
        controller.myRes.selectedRoleTitle  = 'Global Account Head'  ; 
        controller.fillRate1();
        controller.myRes.Rate = '10';       
        controller.myRes.val=2;
        controller.calculResult1();
        
        controller.addToNew1();
        
        
         controller.myRes.name='istest';
        controller.myRes.selectedCountryname ='France' ;
        controller.fillAgencyDepartment1();
        controller.myRes.selectedAgencyDepartment= 'Account Management';
        controller.fillRoleTitle1();
        controller.myRes.selectedRoleTitle  = 'Global Account Head'  ; 
        controller.fillRate1();
        controller.myRes.Rate = '10';       
        controller.myRes.val=2;
        controller.calculResult1();  
        controller.addToNew1();
                 
                 
            controller.ElemToEdit  =0;
            controller.editItem();     
                 
            controller.ElemToEdit  =1;
            controller.editItem(); 
            
            controller.ElemToDel = 0; 
            controller.delElm();    
            System.assertEquals(controller.newItems.size(),2);
            
            
            Test.stopTest();
               
         }
    }
}