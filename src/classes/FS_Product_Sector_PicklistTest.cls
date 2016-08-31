@isTest
public class FS_Product_Sector_PicklistTest {
    @testSetup static void setupTestData(){
        FS_UtilTestDataSetup testdata=new FS_UtilTestDataSetup();     
        User user =  testData.createTestUser();     
        testData.setUpTestData(user);
    }
     Static TestMethod void testSector_Picklist (){
         List<Risk__c> riskList=[select id from Risk__c limit 1];
         test.startTest();
         For (Risk__c risk : riskList){           
           ApexPages.StandardController sc=new ApexPages.StandardController(risk);
           FS_Product_Sector_Picklist_CX product_Sector=new FS_Product_Sector_Picklist_CX(sc);           
           //List<SelectOption> listProductSector=product_Sector.listSector_Picklist;
           product_Sector.autorun();
           product_sector.updateSector();           
           system.assertEquals((Risk__c)sc.getRecord(), risk);
         }
         test.stopTest();
     }
}