/**********************************************************************
 Name:  isll_USLPBrandTableCompControllerTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:Test class for  isll_USLPBrandTableComponentController                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     07/08/2013        INITIAL DEVELOPMENT         Story id:USLL-127  	
 
***********************************************************************/
@isTest
private class isll_USLPBrandTableCompControllerTest {
	static List<Brand_USLP_Progress__c> brandsList;

	static void initData(){
		brandsList = new List<Brand_USLP_Progress__c>();

		for (integer i = 0; i < 10; i++) {
			brandsList.add(isll_TestData.createBrandProgress('Brand ' + 1, i));
		}

		insert brandsList;
	}

	static testmethod void allBrandUSLPTest(){
		initData();
		isll_USLPBrandTableComponentController controller = new isll_USLPBrandTableComponentController();
		system.assertEquals(10,controller.allBrandUSLP.Size());
	}

	static testMethod void removeFromTableTest(){
		initData();
		ApexPages.currentPage().getParameters().put('brandUSLPId',brandsList[0].id);
		isll_USLPBrandTableComponentController controller = new isll_USLPBrandTableComponentController();

		test.startTest();
			controller.removeFromTable();
		test.stopTest();
		
		system.assertEquals(0,([select id from Brand_USLP_Progress__c where id = :brandsList[0].id]).size());

	}

	static testmethod void addBrandUSLPValFailureTest(){
		initData();
		isll_USLPBrandTableComponentController controller = new isll_USLPBrandTableComponentController();

		test.startTest();
		controller.newBrand.Name = 'new brand';
		
		controller.addNewBrandUSLP();
		test.stopTest();

		List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean b = false;
		for(Apexpages.Message msg:msgs){
		    if (msg.getDetail().contains(isll_USLPBrandTableComponentController.BRAND_LOGO_NEEDED)) b = true;
		}
		system.assert(b);

	}

	static testmethod void addBrandUSLPNameValFailureTest(){
		initData();
		isll_USLPBrandTableComponentController controller = new isll_USLPBrandTableComponentController();

		test.startTest();
			controller.addNewBrandUSLP();
		test.stopTest();

		List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean b = false;
		for(Apexpages.Message msg:msgs){
		    if (msg.getDetail().contains(isll_USLPBrandTableComponentController.MISSING_BRAND_NAME)) b = true;
		}
		system.assert(b);

	}

	static testmethod void addBrandUSLPTest(){
		initData();
		isll_USLPBrandTableComponentController controller = new isll_USLPBrandTableComponentController();
		controller.newBrand.Name = 'new brand';
		controller.attachment.Name = 'attachment';
		controller.attachment.Body =  Blob.valueOf('attach body');

		test.startTest();		
			controller.addNewBrandUSLP();
		test.stopTest();

		system.assertEquals(1,([select id from Brand_USLP_Progress__c where Name = 'new brand']).size());
	}

	static testmethod void editBrandUSLPTest(){
		initData();

		Attachment att = isll_TestData.createAttachment(brandsList[0].id); //new Attachment();
		//att.Name = 'attachment';
		//att.Body =  Blob.valueOf('attach body');
		//att.parentId = brandsList[0].id;
		insert att;

		isll_USLPBrandTableComponentController controller = new isll_USLPBrandTableComponentController();
		List<Brand_USLP_Progress__c> uslplist =  controller.allBrandUSLP;

		ApexPages.currentPage().getParameters().put('uslpToEditId', brandsList[0].id);
		controller.hideShowEditDialog();
		controller.newBrand.Name = 'new brand';
		controller.newBrand.Name = 'new brand1';
		controller.attachment.Name = 'attachment';
		controller.attachment.Body =  Blob.valueOf('attach body');

		test.startTest();		
			controller.addNewBrandUSLP();
		test.stopTest();
 
	}

	static testmethod void goBackTest(){
		ApexPages.currentPage().getParameters().put('returnPage', 'http://www.google.com');
		isll_USLPBrandTableComponentController controller = new isll_USLPBrandTableComponentController();
		PageReference returnPage;
		
		test.startTest();		
			returnPage = controller.goBack();
		test.stopTest();
		
		system.assertEquals('http://www.google.com', returnPage.getUrl() );

	}

	static testmethod void updateUSLPBrandsTest(){
		initData();
		isll_USLPBrandTableComponentController controller = new isll_USLPBrandTableComponentController();
		controller.allBrandUSLP[0].Started__c = true;

		test.startTest();	
			controller.updateUSLPBrands();
		test.stopTest();

		system.assert(controller.allBrandUSLP[0].Started__c);
		
	}

	static testmethod void rearragneTableTest(){
		initData();
		isll_USLPBrandTableComponentController controller = new isll_USLPBrandTableComponentController();
		List<Brand_USLP_Progress__c> uslplist =  controller.allBrandUSLP; 
		ApexPages.currentPage().getParameters().put('action',isll_USLPBrandTableComponentController.DOWN_TABLE); 
		Decimal orderNum = uslplist[0].Order_Number__c;
 	  	ApexPages.currentPage().getParameters().put('brandToMove',uslplist[0].id); 
 	  	controller.getShowEditLink();
 	  	
 	  	test.startTest();
 	  		controller.reArrangeTable();
 	  	test.stopTest();

	}

}