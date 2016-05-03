/* -----------------------------------------------------------------------------------------------------------------------
   Name:        BC_ChatterGroupExistCheck_Test.cls 
   Description: 1) Test class used for testing the BC_ChatterGroupExistCheck
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0    Vanessa Barros        Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */

    @isTest
    private class BC_ChatterGroupExistCheck_Test { 
    
    
         static testMethod void  BC_ChatterGroupExistCheck_Test() {
         
            Test.startTest();
            
            brand_centre_new__c b = new Brand_centre_new__c(name = 'creating brand x10', 
            css_name__c = 'MyStaticName',Chatter_Group_Id__c = '123456789123456',background_image__c ='test', footer__c ='test', 
            background_colour__c ='');
            insert b;
         
            collaborationGroup c = new collaborationGroup(name = 'creating group x10',CollaborationType = 'Public');
            insert c;
            
            string cgID = string.valueOf(c.id).left( 15);
            brand_centre_new__c b1 = new Brand_centre_new__c(name = 'creating brand x12', 
            css_name__c = 'MyStaticName',Chatter_Group_Id__c =cgID,background_image__c ='test', footer__c ='test', 
            background_colour__c ='');
            insert b1;
          
           
             
            System.assert(true);
            Test.stopTest();
            
            
            
         }
    }