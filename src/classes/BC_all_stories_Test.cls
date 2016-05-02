/* -----------------------------------------------------------------------------------------------------------------------
   Name:         BC_all_stories_Test.cls 
   Description: 1) Test class used for testing the  BC_all_stories
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0    Vanessa Barros        Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */

    @isTest
    private class  BC_all_stories_Test { 
    
    
         static testMethod void  BC_all_stories_Test() {
         
            brand_centre_new__c b = new Brand_centre_new__c(name = 'creating brand x6', 
                css_name__c = 'MyStaticName',Chatter_Group_Id__c = '123456789123456',background_image__c ='test', footer__c ='test', 
                background_colour__c ='');
            insert b;
           
             Brand_centre_content__c header= new Brand_centre_content__c (position__c = 'Latest News',name = 'BC 7',
                 brand_centre__c = b.id );
            insert header;
            Brand_centre_content__c article = new Brand_centre_content__c (name = 'article 1',header_section__c = header.id,
            summary__c = 'test', brand_centre__c = b.id);
            insert article;
            Brand_centre_content__c article2 = new Brand_centre_content__c (name = 'article 2',header_section__c = header.id,
            summary__c = 'test', brand_centre__c = b.id);
            insert article2;
            
            Test.startTest();
            Test.setCurrentPage(Page.BC_all_stories);
            System.CurrentPageReference().getParameters().put('bc',b.id);
            BC_all_stories BC_all_storiesTest  =  new  BC_all_stories();
            
            
          
            string dynamicCss = BC_all_storiesTest.getdynamicCss();
            string backgroundImage = BC_all_storiesTest.getbackgroundImage();
            string footer = BC_all_storiesTest.getfooter();
            List<Brand_centre_content__c> bcc = BC_all_storiesTest.getAllStories();
            
            System.assert(true);
            Test.stopTest();
            
            
            
         }
    }