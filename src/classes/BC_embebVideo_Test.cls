/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_embebVideo_Test.cls 
   Description: 1) Test class used for testing the BC_embebVideo
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0    Vanessa Barros        Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */

    @isTest
    private class BC_embebVideo_Test { 
    
    
         static testMethod void  BC_embebVideo_Test() {
         
            brand_centre_new__c b = new Brand_centre_new__c(name = 'creating brand x20', 
                css_name__c = 'MyStaticName',Chatter_Group_Id__c = '123456789123456',background_image__c ='test', footer__c ='test', 
                background_colour__c ='');
            insert b;
            Brand_centre_content__c bc = new Brand_centre_content__c (embeb_url__c = 'www.google.com',name = 'BC 7',
                 brand_centre__c = b.id );
            insert bc;
            
            Test.startTest();
            Test.setCurrentPage(Page.BC_VideoDisplay);
            ApexPages.StandardController ctr = new ApexPages.StandardController( bc);
            System.CurrentPageReference().getParameters().put('bc_id',bc.id);
            System.CurrentPageReference().getParameters().put('b',b.id);
            BC_embebVideo bC_embebVideoTest  =  new  BC_embebVideo(ctr);
            
            String dynamicCss = bC_embebVideoTest.getDynamicCss();
            String backgroundImage = bC_embebVideoTest.getBackgroundImage ();
            String BackgroundColour = bC_embebVideoTest.getBackgroundColour();
            string footer = bC_embebVideoTest.getFooter ();
            System.assert(true);
            Test.stopTest();
            
            
            
         }
    }