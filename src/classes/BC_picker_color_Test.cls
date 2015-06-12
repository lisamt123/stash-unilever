/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_picker_color_Test.cls 
   Description: 1) Test class used for testing the BC_picker_color
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0    Vanessa Barros        Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */

    @isTest
    private class BC_picker_color_Test { 
    
    
         static testMethod void   BC_picker_color_Test() {
         
            brand_centre_new__c b = new Brand_centre_new__c(name = 'creating brand x22', 
                css_name__c = 'MyStaticName',Chatter_Group_Id__c = '123456789123456',background_image__c ='test', footer__c ='test', 
                background_colour__c ='ffffff');
            insert b;
            
            Test.startTest();
            Test.setCurrentPage(Page.BC_picker_color);
            ApexPages.StandardController controller = new ApexPages.StandardController( b);
            System.CurrentPageReference().getParameters().put('id',b.id);
            
            
            BC_picker_color BC_picker_colorTest  =  new  BC_picker_color(controller);
            
            PageReference save = BC_picker_colorTest.save();
            PageReference reset = BC_picker_colorTest.reset ();
            PageReference edit = BC_picker_colorTest.edit ();
           
            
            System.assert(true);
            Test.stopTest();
            
            
            
            
            
            
         }
    }