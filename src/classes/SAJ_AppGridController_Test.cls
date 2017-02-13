@isTest
private class SAJ_AppGridController_Test {
    
    static testMethod void testNameHigh() {
     Test.startTest();
       // Programme__c fct = new Programme__c(Description__c= 'Test Function');
       //insert fct; 
    
        ////////////////////////////////
        ////////////////////////////////
        //
        Business_Solution__c BS1 = new Business_Solution__c(Name ='test app', 
                                                            //function__c = fct.id, 
                                                            status__c = 'IPIX Project',
                                                            Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_');  
     insert BS1;
        Business_Solution__c BS2 = new Business_Solution__c(Name ='test app',       
                                                            //function__c = fct.id,
                                                         Business_Value__c = 'High',
                                                         //Complexity__c ='High'
                                                         status__c = 'IPIX Project',
                                                         Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_'); 
      insert BS2;
        Business_Solution__c BS3 = new Business_Solution__c(Name ='test app',       
                                                            //function__c = fct.id,
                                                         Business_Value__c = 'High',
                                                         //Complexity__c ='Medium'
                                                            status__c = 'IPIX Project',
                                                            Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_');
        insert BS3;
        Business_Solution__c BS4 = new Business_Solution__c(Name ='test app',       
                                                            //function__c = fct.id,
                                                         Business_Value__c = 'High',
                                                         //Complexity__c ='Low'
                                                               status__c = 'IPIX Project',
                                                               Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_');
         insert BS4;
         //Business_Solution__c BS5 = new Business_Solution__c(Name ='test app',       function__c = fct.id,
         //                                                Business_Value__c = 'High',
         //                                                Complexity__c ='Unknown'
         //                                                      status__c = 'IPIX Project');
         //insert BS5;
       
        ////////////////////////////////
        ////////////////////////////////
        
         
         //SELECT id, Name, 
         //                                    Complexity__c, Business_Value__c, 
         //                                    IPIX_Funded__c, Description__c, 
          //                                   Status__c, 
         //                                    Phase__c FROM Business_Solution__c WHERE 
         //                                    Status__c IN ('Pre-Project','IPIX Project') 
         //                                    ORDER BY Name asc]){

        
        SAJ_AppGridController oap = new SAJ_AppGridController();
        Test.stopTest();        
 

}

    
    
    static testMethod void testNameMedium() {
     Test.startTest();
      //  Programme__c fct = new Programme__c(Description__c= 'Test Function');
      // insert fct; 
        
        
           ////////////////////////////////
        ////////////////////////////////
        Business_Solution__c BS6 = new Business_Solution__c(Name ='test app6', 
                                                            //function__c = fct.id,
                                                             status__c = 'IPIX Project',
                                                             Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_');  
        try
            {
            insert BS6;
            }
        catch(exception e )
            {
                System.debug(e.getMessage());
            }
        Business_Solution__c BS7 = new Business_Solution__c(Name ='test app7',      
                                                            //function__c = fct.id,
                                                         Business_Value__c = 'Medium',
                                                         //Complexity__c ='High'
                                                         status__c = 'IPIX Project',
                                                         Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_'); 
      insert BS7;
        Business_Solution__c BS8 = new Business_Solution__c(Name ='test app8',      
                                                            //function__c = fct.id,
                                                         Business_Value__c = 'Medium',
                                                         //Complexity__c ='Medium'
                                                            status__c = 'IPIX Project',
                                                            Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_');
        insert BS8;
        Business_Solution__c BS9 = new Business_Solution__c(Name ='test app9',      
                                                            //function__c = fct.id,
                                                         Business_Value__c = 'Medium',
                                                         //Complexity__c ='Low'
                                                               status__c = 'IPIX Project',
                                                               Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_');
         insert BS9;
       
        ////////////////////////////////
        ////////////////////////////////
        
         //SELECT id, Name, 
         //                                    Complexity__c, Business_Value__c, 
         //                                    IPIX_Funded__c, Description__c, 
          //                                   Status__c, 
         //                                    Phase__c FROM Business_Solution__c WHERE 
         //                                    Status__c IN ('Pre-Project','IPIX Project') 
         //                                    ORDER BY Name asc]){

        
        SAJ_AppGridController oap = new SAJ_AppGridController();
        Test.stopTest();        
   
}
    
    
    
    
    static testMethod void testNameLow() {
     Test.startTest();
      //  Programme__c fct = new Programme__c(Description__c= 'Test Function');
      // insert fct; 
    
        
           ////////////////////////////////
        ////////////////////////////////
        Business_Solution__c BS11 = new Business_Solution__c(Name ='test app11', 
                                                             //function__c = fct.id, 
                                                             status__c = 'IPIX Project',
                                                             Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_');  
     insert BS11;
        Business_Solution__c BS12 = new Business_Solution__c(Name ='test app12',     
                                                             //function__c = fct.id,
                                                         Business_Value__c = 'Low',
                                                         //Complexity__c ='High'
                                                         status__c = 'IPIX Project',
                                                         Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_'); 
      insert BS12;
        Business_Solution__c BS13 = new Business_Solution__c(Name ='test app13',       
                                                             //function__c = fct.id,
                                                         Business_Value__c = 'Low',
                                                         //Complexity__c ='Medium'
                                                            status__c = 'IPIX Project',
                                                            Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_');
        insert BS13;
        Business_Solution__c BS14 = new Business_Solution__c(Name ='test app14',      
                                                             //function__c = fct.id,
                                                         Business_Value__c = 'Low',
                                                         //Complexity__c ='Low'
                                                               status__c = 'IPIX Project',
                                                               Clarity_ID__c = 'Test',
                                                                 Project_Dev_Prefix__c = 'SAJ_');
         insert BS14;
       
        ////////////////////////////////
        ////////////////////////////////
        
         //SELECT id, Name, 
         //                                    Complexity__c, Business_Value__c, 
         //                                    IPIX_Funded__c, Description__c, 
          //                                   Status__c, 
         //                                    Phase__c FROM Business_Solution__c WHERE 
         //                                    Status__c IN ('Pre-Project','IPIX Project') 
         //                                    ORDER BY Name asc]){

        
        SAJ_AppGridController oap = new SAJ_AppGridController();
        Test.stopTest();        
      

}
    
    
}