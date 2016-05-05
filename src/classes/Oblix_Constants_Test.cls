@isTest
private class Oblix_Constants_Test {

	@isTest static void Oblix_CampaignSummaryController_Test(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
        	
            Test.startTest();
            
            System.assert(Oblix_Constants.SWOPReportFolder != null);
            System.assert(Oblix_Constants.Lbl_SOWSTATUS_AWAITINGAPPROVAL != null);
            System.assert(Oblix_Constants.Innovation_Projects_Innovation != null);
            System.assert(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess10 != null);
            System.assert(Oblix_Constants.BrandLedGrowth_IncremTurnover1020 != null);
            System.assert(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess2030 != null);
            System.assert(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess3040 != null);
            System.assert(Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove40 != null);
			
            System.assert(Oblix_Constants.Innovation_Projects_BrandLedGrowth != null);
            System.assert(Oblix_Constants.BrandLedGrowth_Less100 != null);
            System.assert(Oblix_Constants.BrandLedGrowth_100_200 != null);
            System.assert(Oblix_Constants.BrandLedGrowth_IncremTurnover200_300 != null);
            System.assert(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess300_400 != null);
            System.assert(Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove400 != null);

            System.assert(Oblix_Constants.Innovation_Projects_Market1 != null);
            System.assert(Oblix_Constants.Innovation_Projects_Market2 != null);
            System.assert(Oblix_Constants.Innovation_Projects_Market3 != null);
            System.assert(Oblix_Constants.Innovation_Projects_Market4 != null);
            System.assert(Oblix_Constants.Innovation_Projects_Market5 != null);
            
            System.assert(Oblix_Constants.Innovation_Projects_HubsPartners1 != null);
            System.assert(Oblix_Constants.Innovation_Projects_HubsPartners2 != null);
            System.assert(Oblix_Constants.Innovation_Projects_HubsPartners3 != null);
            System.assert(Oblix_Constants.Innovation_Projects_HubsPartners4 != null);
            System.assert(Oblix_Constants.Innovation_Projects_HubsPartners5 != null);
                       
            System.assert(Oblix_Constants.Innovation_Projects_Existing != null);
            System.assert(Oblix_Constants.Innovation_Projects_NewOne != null);
            System.assert(Oblix_Constants.Innovation_Projects_NewMulti != null);
            
            System.assert(Oblix_Constants.SELECT_ONE_FILTER != null);
            System.assert(Oblix_Constants.UIUX_Origination != null);            
            
            Test.stopTest();
        }
	}
}