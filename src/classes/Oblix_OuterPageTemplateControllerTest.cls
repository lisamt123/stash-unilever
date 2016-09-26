@isTest
private class Oblix_OuterPageTemplateControllerTest
{


    @testSetup static void initCommonData() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {  
            insert Oblix_TestUtils.createOblixCustomSettings();
            insert Oblix_TestUtils.createOblixFXChangeCustomSetting();
            insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
            insert Oblix_TestUtils.createCountryCalculatorRecords();
        }
    }


	@isTest
	static void testFXMessage()
	{
		// Given
        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_OuterPageTemplate;
        Test.setCurrentPage(pageRef);

		// When
        Test.startTest();

        Oblix_OuterPageTemplateController controller = new Oblix_OuterPageTemplateController();

        Test.stopTest();


		// Then
        Oblix_FX_Change__c orgDate = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
        Date fxDate = orgDate.Org_FX_Date__c;
        String message = 'Please note : on ' + Oblix_Utils.toLocaleDate(fxDate) + ' fees were automatically updated with the current Unilever Planning rates. This may have resulted in a movement in both campaign and non-campaign fees since you last logged in.';
        System.assertEquals(message, controller.FXMessage);

	}


    @isTest
    static void testShowFXMessage()
    {
        User u = Oblix_TestUtils.createSuperUser();
        System.runAs(u) {
            // Given
            //Get Org-wide FX date
            Oblix_FX_Change__c orgDate = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
            Date fxDate = orgDate.Org_FX_Date__c;

            Oblix_FX_Change__c userFxDetails = new Oblix_FX_Change__c(FX_Date__c = string.valueof(fxDate),
                                                                      Acknowledged__c = false,
                                                                      SetupOwnerId = UserInfo.getUserId());
            insert userFxDetails;

            //Init controller with existing assets
            PageReference pageRef = Page.Oblix_OuterPageTemplate;
            Test.setCurrentPage(pageRef);

            // When
            Test.startTest();

            Oblix_OuterPageTemplateController controller = new Oblix_OuterPageTemplateController();

            Test.stopTest();


            // Then
            System.assertEquals(false, controller.showFXMessage);
        }

    }

    @isTest
    static void testUpdateFX()
    {
        User u = Oblix_TestUtils.createSuperUser();
        System.runAs(u) {
            // Given
            //Get Org-wide FX date
            Oblix_FX_Change__c orgDate = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
            Date fxDate = orgDate.Org_FX_Date__c;

            //Init controller with existing assets
            PageReference pageRef = Page.Oblix_OuterPageTemplate;
            Test.setCurrentPage(pageRef);

            // When
            Test.startTest();

            Oblix_OuterPageTemplateController controller = new Oblix_OuterPageTemplateController();
            controller.updateFX();

            Test.stopTest();


            // Then
            List<Oblix_FX_Change__c> fxChange = [SELECT Id, FX_Date__c, Acknowledged__c FROM Oblix_FX_Change__c WHERE SetupOwnerId = :UserInfo.getUserId()];
            System.assertNotEquals(0, fxChange.size());
            System.assertEquals(true, fxChange[0].Acknowledged__c);
            System.assertEquals(true, fxChange[0].Acknowledged__c);
            System.assertEquals(string.valueof(fxDate), fxChange[0].FX_Date__c);
            
        }

    }



    @isTest
    static void testUpdateFX_noOrgWideCS()
    {
        User u = Oblix_TestUtils.createSuperUser();
        System.runAs(u) {
            // Given
            //Delete Org-wide CS
            Oblix_FX_Change__c orgDate = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
            delete orgDate;

            Oblix_FX_Change__c orgDateDeleted = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
            System.debug('### orgCS: ' + orgDateDeleted);

            //Init controller with existing assets
            PageReference pageRef = Page.Oblix_OuterPageTemplate;
            Test.setCurrentPage(pageRef);

            // When
            Test.startTest();

            Oblix_OuterPageTemplateController controller = new Oblix_OuterPageTemplateController();
            controller.updateFX();

            Test.stopTest();


            // Then
            List<Oblix_FX_Change__c> fxChange = [SELECT Id, FX_Date__c, Acknowledged__c FROM Oblix_FX_Change__c WHERE SetupOwnerId = :UserInfo.getUserId()];
            System.assertNotEquals(0, fxChange.size());
            System.assertEquals(true, fxChange[0].Acknowledged__c);
            System.assertEquals(true, fxChange[0].Acknowledged__c);
            System.assertEquals(string.valueof(Date.today()), fxChange[0].FX_Date__c);
            
        }

    }

}