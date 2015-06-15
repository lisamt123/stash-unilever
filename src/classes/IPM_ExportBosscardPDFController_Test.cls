@isTest
public class IPM_ExportBosscardPDFController_Test {

    static testMethod void testIPM_ExportBosscardPDFController_Constructor(){
         Test.startTest();
         List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();       
         IPM_Bosscard__c ipmBosscard  = new IPM_Bosscard__c();
         ipmBosscard .IPM_BosscardName__c ='Te211562';
         ipmBosscard.IPM_Assumptions__c = 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
         ipmBosscard.IPM_Background__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
         ipmBosscard.IPM_Constraints__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
         ipmBosscard.IPM_Consumer_Need__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
         ipmBosscard.IPM_Deliverables__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
         ipmBosscard.IPM_Potential_Business_Opportunity__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
         ipmBosscard.IPM_Resources__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
         ipmBosscard.IPM_Scope__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
         ipmBosscard.IPM_IsSaved__c = true;
         //ipmBosscard.IPM_Brand__c= 'LOjjii';
         //ipmBosscard.IPM_Category__c= 'LOjjii';
         ipmBosscard.IPM_Brand_Positioning__c= 'LOjjii';
         //ipmBosscard.IPM_Gate_Keeper__c= 'LOjjii';
         ipmBosscard.IPM_Target_Launch_Date__c= 'LOjjii';
         ipmBosscard.IPM_Is_Archived__c= false; 
         insert ipmBosscard;
         
         ApexPages.CurrentPage().getparameters().put('id', ipmBosscard.id);
         
         ApexPages.CurrentPage().getparameters().put('print', 'true'); 

         IPM_ExportBosscardPDFController  sic = new IPM_ExportBosscardPDFController ();

         sic.Bosscard_Id = ipmBosscard.id;
         sic.printBosscard = 'true';
         
         
         
         
         Test.stopTest(); 
    
    
    
    }










}