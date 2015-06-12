@isTest()
public class isll_NewsArchiveControllerTest {
	
	public static testmethod void test_NewsArchiveControllerTest(){
		
		//Create test data
		ISLL_Custom_Settings__c chatterGroupName 	= isll_TestData.createISLLCustomSetting(isll_TestData.CHATTER_GROUP);
		chatterGroupName.String_Value__c 			= isll_TestData.ISLL_NAME + ' TestNAC';
		insert chatterGroupName;

		CollaborationGroup grp = isll_TestData.createChatterGroup(isll_TestData.ISLL_NAME + ' TestNAC');
		insert grp;

		Carousel__c carousel = isll_TestData.createCarousel('Test');
		insert carousel;
		
		List<CMS_Content__c> contentList = new List<CMS_Content__c>();
		for (Integer i = 0; i<10; i++) {
			CMS_Content__c con = isll_TestData.createCMSContent('Text');
			contentList.add(con);
		}
		insert contentList;
		
		List<CMS_ContentToCarousel__c> ctcList = new List<CMS_ContentToCarousel__c>();
		for (CMS_Content__c con : contentList) {
			CMS_ContentToCarousel__c ctc = isll_TestData.createCMSContentCarousel(con.Id, carousel.Id);
			ctcList.add(ctc);
		}
		insert ctcList;
		
		isll_NewsArchiveController contr = new isll_NewsArchiveController();
		
		system.assertEquals(4, contr.newsByMonth.get(contr.months[0]).size());
		
	}

}