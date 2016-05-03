@isTest
private class isll_ContentUploaderControllerTest {
	static private void initData(){}
	
	static testMethod void uploadFileTest() {
		isll_ContentUploaderController controller = new isll_ContentUploaderController();
		Test.startTest();
		controller.file.versionData = Blob.valueof('myString');
        controller.file.title = 'Test_file';
        controller.file.pathOnClient ='file';
        controller.file.TagCsv = 'tag1,tag2,tag3';
        
        controller.upload();
        
        Test.stopTest();
        
        boolean foundSuccessMessage = false;
         boolean foundErrorMessage = false;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
		for(Apexpages.Message msg: msgs){
	    	if (msg.getDetail().contains('File uploaded successfully')){
	    		foundSuccessMessage = true;
			}
			if (msg.getDetail().contains('Error uploading file')){
	    		foundErrorMessage = true;
			}
		}
		system.assert(foundSuccessMessage);
		system.assert(!foundErrorMessage);
        
        List<ContentVersion> cv = [select id from ContentVersion where title = 'Test_file'];
        system.assertEquals(1, cv.size());
       	
		
	}
	
	static testMethod void uploadFileExceptionTest() {
		isll_ContentUploaderController controller = new isll_ContentUploaderController();
		Test.startTest();
		//controller.file.versionData = Blob.valueof('myString');
        controller.file.title = 'Test_file';
        controller.file.pathOnClient ='file';
        controller.file.TagCsv = 'tag1,tag2,tag3';
        
        controller.upload();
        
        Test.stopTest();
        
        boolean foundSuccessMessage = false;
         boolean foundErrorMessage = false;
        List<Apexpages.Message> msgs = ApexPages.getMessages();
		for(Apexpages.Message msg: msgs){
	    	if (msg.getDetail().contains('File uploaded successfully')){
	    		foundSuccessMessage = true;
			}
			if (msg.getDetail().contains('Error uploading file')){
	    		foundErrorMessage = true;
			}
		}
		system.assert(!foundSuccessMessage);
		system.assert(foundErrorMessage);
        
        List<ContentVersion> cv = [select id from ContentVersion where title = 'Test_file'];
        system.assertEquals(0, cv.size());
       	
		
	}
}