@isTest
private class Oblix_SOWNonCampaignCreateCtrl_Test {

    static Marketing_Basics__c globalAct; 

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
            geographyCountry.geography_type__c = 'Country';
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
            basicParent.Non_Campaign_Key__c = '123';
            basicParent.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParent.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Resource');
            basicParent.OblixCountry__c = geographyCountry.Id;
            basicParent.OblixOtherItemFee__c  = 33;
            basicParent.No_of_Hours_Required__c = 5;
            insert basicParent;
            
      Marketing_Basics__c basicParent1 = new Marketing_Basics__c();
            basicParent1.Non_Campaign_Key__c = '124';
            basicParent1.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParent1.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Resource');
            basicParent1.FTE__c = 50;
            basicParent1.OblixCountry__c = geographyCountry.Id;
            basicParent1.OblixOtherItemFee__c  = 33;
            basicParent1.No_of_Hours_Required__c = 5;
            insert basicParent1;
          
            
          Marketing_Basics__c basicParentActivity = new Marketing_Basics__c();
            basicParentActivity.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParentActivity.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Activity');
            basicParentActivity.OblixCountry__c = geographyCountry.Id;
            basicParentActivity.Non_Campaign_Key__c = '125';
            basicParentActivity.No_of_Hours_Required__c = 5;
          Marketing_Basics__c basicParentActivity1 = new Marketing_Basics__c();
            basicParentActivity1.Oblix_SOWMarketing__c = marketingSow.Id;
            basicParentActivity1.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Activity');  
            //basicParentActivity1.FTE__c = 50;
            basicParentActivity1.No_of_Hours_Required__c = 10;
            basicParentActivity1.OblixCountry__c = geographyCountry.Id;
            basicParentActivity1.Non_Campaign_Key__c = '126';
            basicParentActivity1.No_of_Hours_Required__c = 5;
            basicParentActivity1.OblixOtherItemFee__c = 10;
            basicParentActivity1.name = 'preselected';
            insert basicParentActivity1;
            globalAct = basicParentActivity1;
            return marketingSow.id; 
        
    }
 
    static testMethod void CampaignEdit_Test() {
        
        User u = Oblix_TestUtils.createTestUser(); 
         
        System.runAs(u){
   
            Test.startTest();
            ApexPages.currentPage().getParameters().put('preSelectedName', 'preselected' );
            ApexPages.currentPage().getParameters().put('sowId', createMaketingSow() );
            Oblix_SOWNonCampaignCreateController controller = new Oblix_SOWNonCampaignCreateController();
                 
            controller.seletedActivity = JSON.serialize(globalAct);
            //test insert activity
            controller.selectedTab = 'activity';
            controller.activity.name='istest';
            controller.activity.selectedCountryname ='France' ;
            controller.fillAgencyDepartment();
            controller.activity.selectedAgencyDepartment= 'Account Management';
            controller.fillRoleTitle();
            controller.fillRate();

            controller.resource.name='istest';
            controller.resource.selectedCountryname ='France' ;
            controller.resource.selectedAgencyDepartment= 'Account Management';
            controller.getSelectedActivitiesByName();
            controller.addToActivitySelectionMap();
            controller.insertSelectedActivitiesAndRefreshBasket();
            controller.removeFromSelectionMap();
            controller.removeItemFromBasketList();
            controller.upsertSelectedResourceAndRefreshBasket();
            controller.clearActivitySelectionMap();
            List<SelectOption> roleTitle = new List<SelectOption>{new SelectOption('1','1')};
            Map<String,String> roleTitlesNameMap = new  Map<String,String>();
            roleTitlesNameMap.put('1','1');
            List<SelectOption> result = controller.populateRoleTitleList(roleTitlesNameMap);
            System.assert(result != null);
            System.assert(controller.exitSwop() != null);
            Test.stopTest();
               
         }
    }
}