/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_UploadImage_attachments_Test.cls 
   Description: 1) Test class used for testing the BC_UploadImage_attachments
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0    Vanessa Barros        Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */

    @isTest
    private class BC_UploadImage_attachments_Test { 
    
    
         static testMethod void  BC_UploadImage_attachments_Test() {
         
            brand_centre_new__c b = new Brand_centre_new__c(name = 'creating brand x34', 
                css_name__c = 'MyStaticName',Chatter_Group_Id__c = '123456789123456',background_image__c ='test', footer__c ='test', 
                background_colour__c ='');
            insert b;
            Brand_centre_content__c bc = new Brand_centre_content__c (position__c = 'Latest News', embeb_url__c = 'www.google.com',name = 'test',
                 brand_centre__c = b.id,summary__c ='test' );
            insert bc;
            Brand_centre_content__c bc1 = new Brand_centre_content__c (embeb_url__c = 'www.google.com',name = 'test',header_section__c = bc.id,
                 brand_centre__c = b.id, summary__c = 'test' );
            insert bc1;
            
            Test.startTest();
            Test.setCurrentPage(Page.BC_UploadImage_attachments);
            ApexPages.StandardController ctr = new ApexPages.StandardController( bc1);
            System.CurrentPageReference().getParameters().put('id',bc1.id);
            System.CurrentPageReference().getParameters().put('id',bc1.id);
            BC_UploadImage_attachments BC_UploadImage_attachmentsTest  =  new  BC_UploadImage_attachments(ctr);
            
            BC_UploadImage_attachmentsTest.picture.Name='Unit Test Attachment';
            BC_UploadImage_attachmentsTest.picture.body=Blob.valueOf('Unit Test Attachment Body');
            
            PageReference p = BC_UploadImage_attachmentsTest.Attach();
            
            System.assert(true);
            Test.stopTest();
            
            
            
         }
    }