/*
	Unilever

	Class Name: AR_Test_AgencyPortfolioAndInformation

	Created by: Marc Saelzler | 2013-09-20

	Description: To get test coverage for AR_AgencyPortfolioAndInformation.

	Timeline
	Date 					| Name 				| Description
	2013-09-20 17:35 (CET)	| Marc Saelzler 	| Initial development.
*/


@isTest(SeeAllData=true)
public class AR_Test_AgencyPortfolioAndInformation
{
	static testMethod void AR_Test_GeneralInformationController()
	{
		Test.startTest();
		
		AR_AgencyPortfolioAndInformation test_controller = new AR_AgencyPortfolioAndInformation();
		
		Id tmp_recTypeId;
		
		Account tmp_acc = TestDataFactory.getAccount('Agency');
		
		insert tmp_acc;
		
		// check if data was saved
        system.assertNotEquals(null, tmp_acc.Id, 'Account could not be saved.');
		
		ar_Geography__c tmp_geo = TestDataFactory.getGeography();
		
		tmp_geo.Agency__c = tmp_acc.Id;
		
		insert tmp_geo;
		
		// check if data was saved
        system.assertNotEquals(null, tmp_geo.Id, 'Geography could not be saved.');
		
		ar_Experience__c tmp_exp = TestDataFactory.getExpertise(null);
		
		tmp_exp.Agency__c = tmp_acc.Id;
		
		insert tmp_exp;
		
		// check if data was saved
        system.assertNotEquals(null, tmp_exp.Id, 'Experience could not be saved.');
		
		
		test_controller.theAgencyId = tmp_acc.Id;
		
		String tmp_strValue;
		SObject tmp_sObj;
		List<SObject> tmp_sObjList;
		
		tmp_sObj = test_controller.agency;
		
		system.assertNotEquals(null, tmp_sObj.Id, 'Account data not found.');
		
		tmp_strValue = test_controller.numberEmployees;
		tmp_strValue = test_controller.offices;
		
		
		// first time its null
		tmp_sObjList = test_controller.projects;
		
		test_controller.projects = new List<ar_Experience__c>{tmp_exp};
		
		// second time its not (already set)
		tmp_sObjList = test_controller.projects;
		
		Test.stopTest();
	}
}