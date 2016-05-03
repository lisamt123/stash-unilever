/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_updateEmbedURL_Test.cls 
   Description: 1) Test class used for testing the BC_updateEmbedURL
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0    Vanessa Barros        Initial Release 
   January 2014    1.1    Vanessa Barros            change name to develperName and Isactive =true
  ------------------------------------------------------------------------------------------------------------------------ */

    @isTest
    private class BC_updateEmbedURL_Test { 
    
    
         static testMethod void  BC_updateEmbedURL_Test() {
         
            Test.startTest();
             collaborationGroup c = new collaborationGroup(name = '9 test brand 9',CollaborationType = 'Public');
            insert c;
            string cgID = string.valueOf(c.id).left( 15);
            brand_centre_new__c b = new Brand_centre_new__c(name = 'creating brand x24', 
            css_name__c = 'MyStaticName',Chatter_Group_Id__c = cgID,background_image__c ='test', footer__c ='test', 
            background_colour__c ='');
            insert b;
            RecordType r = [select id from recordType where developername = 'Video_Link_Content' and isActive=true ];
            Brand_centre_content__c bc = new Brand_centre_content__c (recordTypeId = r.id, Link_URL__c = 'http://www.google.com',name = 'test',
                 brand_centre__c = b.id,source__c = 'YouTube' );
            insert bc;
          Brand_centre_content__c bc1 = new Brand_centre_content__c (recordTypeId = r.id, Link_URL__c = 'http://www.google.com',name = 'test',
                 brand_centre__c = b.id,source__c = 'Vimeo' );
            insert bc1;
           
             
            System.assert(true);
            Test.stopTest();
            
            
            
         }
    }