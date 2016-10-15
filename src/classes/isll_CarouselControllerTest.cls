/**********************************************************************
 Name:  isll_CarouselControllerTest()
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:
Test class of controller 'isll_CarouselController'.        
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR             DATE                DETAIL                          Description
   1.0 - Marc Saelzler      14/08/2013          INITIAL DEVELOPMENT              
   
***********************************************************************/

@isTest
public class isll_CarouselControllerTest
{
	public static testmethod void isll_CarouselControllerTest()
	{
		String FILE_INDICATOR	= 'New File Indicator';

		ISLL_Custom_Settings__c newFileInd 	= isll_TestData.createISLLCustomSetting(FILE_INDICATOR);
		newFileInd.Integer_Value__c 		= 5;
		insert newFileInd;
		
		// Empty constructor.
		isll_CarouselController tmp_carouselController = new isll_CarouselController();
		
		// Capture null.
		String tmp_carouselId = tmp_carouselController.a_carouselId;
		
		// Relevant carousel record.
		Carousel__c tmp_carousel = new Carousel__c();
		insert tmp_carousel;
		
		// Standard controller with relevant carousel record.
		ApexPages.StandardController x_stdCtrl = new ApexPages.StandardController(tmp_carousel);
		
		// Constructor with standard controller.
		tmp_carouselController = new isll_CarouselController(x_stdCtrl);
		
		// Set related page of the controller.
		PageReference tmp_pageRef = Page.isll_CarouselEditPage;
		
		// Return url for value 'a_prevPage'.
		tmp_pageRef.getParameters().put('retURL', '/home/home.jsp');
		
		Test.setCurrentPage(tmp_pageRef);
		
		String tmp_prevPage = tmp_carouselController.a_prevPage;
		
		// Mode for the vf page display: edit/view.
		String tmp_mode = tmp_carouselController.a_mode;
		
		Carousel__c tmp_carouselRecord = tmp_carouselController.a_carousel;
		
		// Capture null after setting up 'a_carouselId' within the constructor.
		tmp_carouselController.a_carouselId = null;
		
		tmp_carouselId = tmp_carouselController.a_carouselId;
		
		// Get name of the carousel.
		String tmp_carouselName = tmp_carouselController.a_carouselName; // <= reminder: can never be identifier for a_carousel !!
		
		// Get map of elements within this carousel. (empty at first)
		Map<Id, CMS_Content__c> tmp_elementMap = tmp_carouselController.a_elementMap;
		
		// Editable or not?
		tmp_carouselController.getShowEditLink();
		
		// Store id of the currently relevant content record.
		Id tmp_contentId = tmp_carouselController.a_contentId;
		
		// Store the currently relevant content record.
		CMS_Content__c tmp_content = tmp_carouselController.a_content;
		
		// Save a new content record.
		tmp_carouselController.DoSave();
		
		// Get/Store all content records in a list.
		CMS_Content__c[] tmp_elements = tmp_carouselController.a_elements;
		
		// Get size of records in this list.
		Integer tmp_elementSize = tmp_carouselController.a_elementsSize;
		
		// Check that its not empty.
		System.assert(!tmp_elements.isEmpty());
		
		// Get the first content record from this list.
		tmp_contentId = tmp_elements.get(0).Id;
		
		// Set id of the current relevant content record.
		tmp_carouselController.a_contentId = tmp_contentId;
		
		// Edit mode.
		tmp_carouselController.DoEdit();
		
		// Save (update) an existing content record.
		tmp_carouselController.DoSave();
		
		// Set id of the current relevant content record.
		tmp_carouselController.a_contentId = tmp_contentId;
		
		// Cancel edit mode and reset it to view mode.
		tmp_carouselController.DoCancel();
		
		// Set id of the current relevant content record.
		tmp_carouselController.a_contentId = tmp_contentId;
		
		// Delete the selected content record.
		tmp_carouselController.DoDelete();
		
		// Go back to the 'return url', if set.
		tmp_carouselController.GoBack();
		
		tmp_carouselController.DoNext();
		
		ContentVersion cv = new ContentVersion();
		cv.Title		= 'Test File';
		cv.ContentUrl	= 'test.com';
		insert cv;
		
		Apexpages.currentPage().getParameters().put('cvid', cv.Id);
		
		List<isll_LibraryController.ContentVersionWrapper> tmpList = tmp_carouselController.contentDocs;
		
		tmp_carouselController.a_content = new CMS_Content__c();
		
		tmp_carouselController.DoAddDocument();
		
		Apexpages.currentPage().getParameters().put('cvidf', cv.Id);
		
		tmp_carouselController.addToLibrary();
		
		tmp_carouselController.DoUp();
		tmp_carouselController.DoDown();
	}
}