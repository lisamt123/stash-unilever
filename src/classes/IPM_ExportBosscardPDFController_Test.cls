/*
* @Description : For Creating PDF Document for Bosscard
*/
@isTest
public class IPM_ExportBosscardPDFController_Test {
	
	
    /**
    * @description For Running Test Script
	*/ 
    static testMethod void testIPM_ExportBosscardPDFController_Constructor(){
         Test.startTest();
         //IPM_Bosscard__c ipmBosscard  = new IPM_Bosscard__c();
         IPM_Bosscard__c ipmBosscard = IPM_TestFactory_Helper.createIPMBosscard(FALSE);
         ipmBosscard .IPM_BosscardName__c ='Te211562';
         insert ipmBosscard;
         
         System.Assert(ipmBosscard.IPM_BosscardName__c == 'Te211562','Should be same');
         ApexPages.CurrentPage().getparameters().put('id', ipmBosscard.id);
         System.Assert(ApexPages.CurrentPage().getparameters().get('id') == ipmBosscard.id,'Should be same');
         
         ApexPages.CurrentPage().getparameters().put('print', 'true'); 
         System.Assert(ApexPages.CurrentPage().getparameters().get('print') == 'true','Should be true');

         IPM_ExportBosscardPDFController  sic = new IPM_ExportBosscardPDFController ();
         sic.Bosscard_Id = ipmBosscard.id;
         sic.printBosscard = 'true';
         Test.stopTest();     
    }
}