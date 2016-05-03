/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_article_template_Test.cls 
   Description: 1) Test class used for testing the BC_article_template
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0    Vanessa Barros        Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */

    @isTest
    private class BC_article_template_Test { 
    
    
         static testMethod void  BC_article_template_Test() {
         
            brand_centre_new__c b = new Brand_centre_new__c(name = 'creating brand x8', 
                css_name__c = 'MyStaticName',Chatter_Group_Id__c = '123456789123456',background_image__c ='test', footer__c ='test', 
                background_colour__c ='',static_resource_name__c = 'test');
            insert b;
            Brand_centre_content__c bc = new Brand_centre_content__c (embeb_url__c = 'www.google.com',name = 'BC 7',
                 brand_centre__c = b.id );
            insert bc;
            
            Test.startTest();
            Test.setCurrentPage(Page.BC_VideoDisplay);
            ApexPages.StandardController ctr = new ApexPages.StandardController( bc);
            System.CurrentPageReference().getParameters().put('id',bc.id);
           
            BC_article_template  BC_article_template_test  =  new  BC_article_template (ctr);
            
            String dynamicCss = BC_article_template_Test.getDynamicCss();
            String backgroundImage = BC_article_template_Test.getBackgroundImage ();
            
            string footer = BC_article_template_Test.getFooter ();
            PageReference p = BC_article_template_Test.editLink ();
            System.assert(true);
            Test.stopTest();
            
            
            
         }
    }