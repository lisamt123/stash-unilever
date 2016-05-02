/* -----------------------------------------------------------------------------------------------------------------------
   Name:         BC_brandContentHeader_Test.cls 
   Description: 1) Test class used for testing the  BC_brandContentHeader
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0    Vanessa Barros        Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */

    @isTest
    private class  BC_brandContentHeader_Test { 
    
    
         static testMethod void  BC_brandContentHeader_Test() {
         
            brand_centre_new__c b = new Brand_centre_new__c(name = 'creating brand x9', 
                css_name__c = 'MyStaticName',Chatter_Group_Id__c = '123456789123456',background_image__c ='test', footer__c ='test', 
                background_colour__c ='');
            insert b;
            Brand_centre_content__c bc = new Brand_centre_content__c (position__c = 'Right Side',name = 'BC 7',
                 brand_centre__c = b.id,header__c=true, ordinal__c=1 );
            insert bc;
             Brand_centre_content__c bc1 = new Brand_centre_content__c (position__c = 'Community',name = 'BC 7',
                 brand_centre__c = b.id,header__c=true  );
            insert bc1;
             Brand_centre_content__c bc2 = new Brand_centre_content__c (position__c = 'Online',name = 'BC 7',
                 brand_centre__c = b.id,header__c=true  );
            insert bc2;
             Brand_centre_content__c bc3 = new Brand_centre_content__c (position__c = 'Latest News',name = 'BC 7',
                 brand_centre__c = b.id,header__c=true  );
            insert bc3;
            
            Test.startTest();
            Test.setCurrentPage(Page.BC_header_Display);
            ApexPages.StandardController ctr = new ApexPages.StandardController( b);
            System.CurrentPageReference().getParameters().put('id',b.id);
            System.CurrentPageReference().getParameters().put('brand_centre',b.id);
            System.CurrentPageReference().getParameters().put('bc',bc3.id);
            BC_brandContentHeader BC_brandContentHeaderTest  =  new  BC_brandContentHeader(ctr);
            
            List< Brand_centre_content__c> bcc = BC_brandContentHeaderTest.getBB();
            System.CurrentPageReference().getParameters().put('bcentre',b.id);

            PageReference p = BC_brandContentHeaderTest.DeleteBrandCentreContent();
            System.assert(true);
            Test.stopTest();
            
            
            
         }
        
    }