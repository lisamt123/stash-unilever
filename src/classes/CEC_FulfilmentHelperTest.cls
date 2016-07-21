/**********************************************************************
    Name:  CEC_Test_FulfilmentHelper
    Copyright © 2014  Unilever
    ======================================================================
    =======================================================================
    Purpose: This is the test class for the CEC_FulfilmentHelper                                                                                                                  
    =======================================================================
    =======================================================================
    History                                                            
    -------                                                            
    VERSION  AUTHOR            DATE            DETAIL               Description
    1.0 -    Rajesh            19/11/2015      INITIAL DEVELOPMENT  CSR
    1.0 -    Masood            20/11/2015      INITIAL DEVELOPMENT  CSR
    2.0      Samrin Shaikh     17/12/2015       CSC-2765            CSC-2765 US-009 Letter/Enclosure auto population
    2.1      Masood            09/02/2016      Max Refund value added for user 
    ***********************************************************************/
    
    /*
    Test class for the Helper class CEC_FulfilmentHelper
    */
    
    @isTest(SeeAllData=false)
    public class CEC_FulfilmentHelperTest {
        
        public static User insertUser()
        {
                  
            Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Salesforce MultiApp Standard'];
            
            User u = new User(LastName = 'Testing', 
                              Username = 'cectestuser@test00DE0000000bbLj.org', 
                              Email = 'cectestuser@test00DE0000000bbLj.org', 
                              Alias = 'utest', 
                              TimeZoneSidKey = 'Europe/London', 
                              LocaleSidKey = 'en_GB', 
                              EmailEncodingKey = 'UTF-8', 
                              ProfileId = p.Id,
                              Refund_Authorization_Limit__c = 'Level 4',
                              
                              LanguageLocaleKey = 'en_US',
                              UserPermissionsKnowledgeUser = true);  
            
            insert u;
            List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN ('CEC_User','CEC_Manager','CEC_CRUD','CEC_Business_Admin','CEC_Knowledge_Manager','CEC_Automated_User','CEC Cheque Process')];
            List<PermissionSetAssignment> psalist = new List<PermissionSetAssignment>();
            for(PermissionSet ps:pslist)
            {
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = u.Id;
                psa.PermissionSetId = ps.Id;
                
                psalist.add(psa);
                
            }
            
            insert psalist;
            
            Group GR = [SELECT Id,name FROM Group WHERE Name = 'CEC - Knowledge Manager'];
            GroupMember GM = new GroupMember();
            GM.GroupId = GR.id;
            GM.UserOrGroupId = u.Id;
            insert GM;
            
            return u;
            
        }
        
        /**
    Test method for beforeInsert() method
    */
        
        public static testMethod void test_beforeInsert(){
            
            User u = insertUser();
            
            System.runAs(u)
            {
                
                
                List<cec_Fulfilment__c>  Listff = new List<cec_Fulfilment__c> ();
                List<cec_Fulfilment__c>  Listff1 = new List<cec_Fulfilment__c> ();  
                Map<id,cec_Fulfilment__c> FulfilMap = new Map<id,cec_Fulfilment__c>();
                
                
                
               Account accountObj = new Account();
                accountObj.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
                accountObj.PersonMailingCity = 'Mumbai';
                accountObj.LastName = 'TestAccount';        
                
                insert accountObj;
                System.assertEquals( accountObj.LastName,'TestAccount');         
                
                
                
                Case caseObj = new Case();
                caseObj .Status = 'New';
                caseObj .Origin = 'Email';
                caseObj.AccountID=  accountObj.id;
                caseObj.Case_product_category__c='IceCream';
                insert caseObj;
                System.assertEquals( caseObj.Origin,'Email');           
                
                System.debug('~~~~caseObj '+ caseObj);     
                System.debug('~~~~caseObj Account'+ caseObj.Account);      
                
                cec_Fulfilment__c fulfilmentObj = new cec_Fulfilment__c();
                fulfilmentObj.Case__c = caseObj.id;  
                Listff.add(fulfilmentObj);   
                insert Listff;
                System.debug('~~~~fulfilmentObj'+ fulfilmentObj);  
                
                System.assertEquals(Listff.size(),1);
                
                CEC_Cheque_Authorization_Limit__c chequeLimit=new CEC_Cheque_Authorization_Limit__c(Level_1__c=100,Level_2__c=200,Level_3__c=300,Level_4__c=400,Level_5__c=500,Level_6__c=600,Level_7__c=700);
                insert chequeLimit;
                
                User loggedinuser = [select Quality_Check_Percentage__c,Max_Refund_Amount__c, FirstName from User where id = :UserInfo.getUserId()];
                loggedinuser.Refund_Authorization_Limit__c ='Level 4';
                update loggedinuser;
                System.debug('@@@@@Refund amount' + loggedinuser.Max_Refund_Amount__c);
                
                System.debug(''+loggedinuser.Quality_Check_Percentage__c+' '+loggedinuser.FirstName);
                
                Double randomnumber = 0.00;
                Double QualityPercent  = 1.00;
                Double qualityMaxRefund = 1.00;
                System.debug('~~~~randomnumber ' + randomnumber ); 
                
                CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
                fulfilmentHelper.qualityCheck(Listff);
                
                String.valueOf(randomnumber );
                cec_Fulfilment__c fulfilmentObj1 = new cec_Fulfilment__c();
                fulfilmentObj1.Refund_Value__c = 10;       
                fulfilmentObj1.Case__c = caseObj.id;  
                Listff1.add(fulfilmentObj1);   
                insert Listff1;
                FulfilMap.put(fulfilmentObj1.Id,fulfilmentObj1);
                
                fulfilmentHelper.qualityCheck(Listff1);
                
                cec_Fulfilment__c oldfulfilmentObj = [select ID,Refund_Value__c from cec_Fulfilment__c where id = :fulfilmentObj1.Id];
                oldfulfilmentObj.Refund_Value__c = 20;
                update oldfulfilmentObj;
                Listff1.add(oldfulfilmentObj); 
                
                //Commented for CSC - 3135
                //fulfilmentHelper.refundApprovalCheck(Listff1,FulfilMap);
                
                
            }
            
        }
        public static testMethod void test_getChequeNumber(){
            
            User u = insertUser();        
            System.runAs(u) {
                
                List<cec_Fulfilment__c>  Listff = new List<cec_Fulfilment__c> ();
                List<cec_Fulfilment__c>  Listff1 = new List<cec_Fulfilment__c> ();         
                List<CEC_ChequeBook_Detail__c> chbd = new List<CEC_ChequeBook_Detail__c>();
                
                Account accountObj = new Account();
                accountObj.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
                accountObj.PersonMailingCity = 'Mumbai';
                accountObj.LastName = 'TestAccount';  
                insert accountObj;
                System.assertEquals(accountObj.LastName,'TestAccount');  
                
                mdm_Product_Category__c pc = new mdm_Product_Category__c();
                //pc.L7_Product_Category__c ='Soup';
                pc.L2_Product_Category__c ='Soup';
                pc.Corp_Brand_Name__c ='Knorr';
                insert pc;
                
                mdm_Case_Product__c cp = new mdm_Case_Product__c();
                cp.Brand__c ='Knorr';
                cp.Active_for_CEC__c= true;
                cp.Global_CPG_Code__c = pc.id;
                insert cp;
                
                Case caseObj = new Case();
                caseObj .Status = 'New';
                caseObj .Origin = 'Email';
                caseObj.AccountID=  accountObj.id;
                //caseObj.Case_product_category__c = 'Soup';
                caseObj.Brand__c = 'Knorr';
                caseObj.CEC_Product__c = cp.id;
                insert caseObj;
                System.assertEquals( caseObj.Origin,'Email');           
                
                System.debug('~~~~caseObj '+ caseObj);     
                System.debug('~~~~caseObj Account'+ caseObj.Account);      
                
                cec_Fulfilment__c fulfilmentObj = new cec_Fulfilment__c();  
                fulfilmentObj.Case__c = caseObj.id;  
                fulfilmentObj.Country__c = 'India';
                //fulfilmentObj.Cheque_Number__c = 12;
                //fulfilmentObj.Case_Product_Category__c = cp.id;
                Listff.add(fulfilmentObj);   
                insert Listff;
                
                System.debug('~~~~fulfilmentObj'+ fulfilmentObj); 
                System.assertEquals(Listff.size(),1);
                
                mdm_Geography__c g = new mdm_Geography__c();
                g.Name='India';
                insert g;
                
                CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
                cmm.Market__c='US';
                cmm.Country__c=g.Id;
                cmm.Language__c='Spanish';
                insert cmm;
                
                CEC_ChequeBook_Detail__c cd1= new CEC_ChequeBook_Detail__c();
                cd1.Cheque_Book__c='CB1';
                cd1.Increment_Number__c=1;
                cd1.Currency__c ='USD';
                cd1.Currency_Text__c ='Dollors';
                cd1.Currency_Decimal_Text__c ='Cents';
                cd1.Last_Cheque_Number__c = 11;
               // cd1.Brand__c='Knorr';
                cd1.Country__c =cmm.Id;
                cd1.Max_Cheque_Number__c =1000;
                cd1.Active__c = true;
                cd1.Product_Category__c = pc.Id;
                //cd1.Product_Category__c = 'Soup'; -- Nagesh
                chbd.add(cd1);
                
                insert chbd;  
                
                //System.assertEquals(fulfilmentObj.Cheque_Number__c, cd1.Last_Cheque_Number__c+cd1.Increment_Number__c);
                CEC_ChequeProcess.generateChequeNumber(Listff[0].Id);
                
                
            }
        }
        public static testMethod void test_getChequeNumber_maxChequeNumberExceeded(){
            
            User u = insertUser();        
            System.runAs(u) {
                
                List<cec_Fulfilment__c>  Listff = new List<cec_Fulfilment__c> ();
                List<cec_Fulfilment__c>  Listff1 = new List<cec_Fulfilment__c> ();         
                List<CEC_ChequeBook_Detail__c> chbd = new List<CEC_ChequeBook_Detail__c>();
                
                Account accountObj = new Account();
                accountObj.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
                accountObj.PersonMailingCity = 'Mumbai';
                accountObj.LastName = 'TestAccount';  
                insert accountObj;
                System.assertEquals(accountObj.LastName,'TestAccount');  
                
                mdm_Product_Category__c pc = new mdm_Product_Category__c();
                //pc.L7_Product_Category__c ='Soup';
                pc.L2_Product_Category__c ='Soup';
                pc.Corp_Brand_Name__c ='Knorr';
                insert pc;
                
                mdm_Case_Product__c cp = new mdm_Case_Product__c();
                cp.Brand__c ='Knorr';
                cp.Active_for_CEC__c= true;
                cp.Global_CPG_Code__c = pc.id;
                insert cp;
                
                Case caseObj = new Case();
                caseObj .Status = 'New';
                caseObj .Origin = 'Email';
                caseObj.AccountID=  accountObj.id;
                //caseObj.Case_product_category__c = 'Soup';
                caseObj.Brand__c = 'Knorr';
                caseObj.CEC_Product__c = cp.id;
                insert caseObj;
                System.assertEquals( caseObj.Origin,'Email');           
                
                System.debug('~~~~caseObj '+ caseObj);     
                System.debug('~~~~caseObj Account'+ caseObj.Account);      
                
                cec_Fulfilment__c fulfilmentObj = new cec_Fulfilment__c();  
                fulfilmentObj.Case__c = caseObj.id; 
                fulfilmentObj.Country__c = 'India';
                //fulfilmentObj.Cheque_Number__c=1000;
                Listff.add(fulfilmentObj);   
                insert Listff;
                
                System.debug('~~~~fulfilmentObj'+ fulfilmentObj); 
                System.assertEquals(Listff.size(),1);
                
                mdm_Geography__c g = new mdm_Geography__c();
                g.Name='India';
                insert g;
                
                CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
                cmm.Market__c='US';
                cmm.Country__c=g.Id;
                cmm.Language__c='Spanish';
                insert cmm;
                
                CEC_ChequeBook_Detail__c cd1= new CEC_ChequeBook_Detail__c();
                cd1.Cheque_Book__c='CB1';
                cd1.Increment_Number__c=1;
                cd1.Currency__c ='USD';
                cd1.Currency_Text__c ='Dollors';
                cd1.Currency_Decimal_Text__c ='Cents';              
                cd1.Last_Cheque_Number__c = 1100;
                //cd1.Brand__c='Knorr';
                cd1.Country__c =cmm.Id;
                cd1.Max_Cheque_Number__c =1000;
                cd1.Active__c = true;
                cd1.Product_Category__c = pc.Id;
                //cd1.Product_Category__c = 'Soup'; -- Nagesh
                chbd.add(cd1);
                
                insert chbd;  
                
                
                //System.assertNotEquals(fulfilmentObj.Cheque_Number__c, cd1.Last_Cheque_Number__c+cd1.Increment_Number__c);           
                CEC_ChequeProcess.generateChequeNumber(Listff[0].Id);
                
                
            }
        }
        public static testMethod void test_getChequeNumber_emptylist(){
            
            User u = insertUser();        
            System.runAs(u) {
                
                List<cec_Fulfilment__c>  Listff = new List<cec_Fulfilment__c> ();
                List<cec_Fulfilment__c>  Listff1 = new List<cec_Fulfilment__c> ();         
                List<CEC_ChequeBook_Detail__c> chbd = new List<CEC_ChequeBook_Detail__c>();
                
                Account accountObj = new Account();
                accountObj.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
                accountObj.PersonMailingCity = 'Mumbai';
                accountObj.LastName = 'TestAccount';  
                insert accountObj;
                System.assertEquals(accountObj.LastName,'TestAccount');    
                
                mdm_Product_Category__c pc = new mdm_Product_Category__c();
                //pc.L7_Product_Category__c ='Soup';
                pc.L2_Product_Category__c ='Soup';
                insert pc; 
                
                mdm_Case_Product__c cp = new mdm_Case_Product__c();
                cp.Brand__c ='Knorr';
                cp.Active_for_CEC__c= true;
                cp.Global_CPG_Code__c = pc.Id;
                insert cp;
                
                Case caseObj = new Case();
                caseObj .Status = 'New';
                caseObj .Origin = 'Email';
                caseObj.AccountID=  accountObj.id;
                caseObj.Case_product_category__c = 'Soup';
                insert caseObj;
                System.assertEquals( caseObj.Origin,'Email');           
                
                System.debug('~~~~caseObj '+ caseObj);     
                System.debug('~~~~caseObj Account'+ caseObj.Account);      
                
                cec_Fulfilment__c fulfilmentObj = new cec_Fulfilment__c();  
                fulfilmentObj.Case__c = caseObj.id;
                fulfilmentObj.Country__c = 'India';
                Listff.add(fulfilmentObj);   
                insert Listff;
                
                System.debug('~~~~fulfilmentObj'+ fulfilmentObj); 
                System.assertEquals(Listff.size(),1);
                
                mdm_Geography__c g = new mdm_Geography__c();
                g.Name='India';
                insert g;
                
                CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
                cmm.Market__c='US';
                cmm.Country__c=g.Id;
                cmm.Language__c='Spanish';
                insert cmm;
                
                CEC_ChequeBook_Detail__c cd1= new CEC_ChequeBook_Detail__c();
                cd1.Cheque_Book__c='CB1';
                cd1.Increment_Number__c=1;
                cd1.Currency__c ='USD';
                cd1.Currency_Text__c ='Dollors';
                cd1.Currency_Decimal_Text__c ='Cents';              
                cd1.Last_Cheque_Number__c = 11;
               // cd1.Brand__c='Knorr';
                cd1.Country__c =cmm.Id;
                cd1.Max_Cheque_Number__c =1000;
                cd1.Active__c = true;
                cd1.Product_Category__c = pc.Id;
                //cd1.Product_Category__c = 'Soup';
                chbd.add(cd1);
                
                insert chbd;  
                
                //System.assertEquals(fulfilmentObj.Cheque_Number__c, null);
                CEC_ChequeProcess.generateChequeNumber(Listff[0].Id);
                
                
            }
        }
        public static testMethod void test_getChequeNumber_nullCheck(){
            CEC_ChequeProcess.generateChequeNumber(null);
            
        }
        public static testMethod void test_beforeUpdate(){
            
            User u = insertUser();
            
            System.runAs(u)
            {
                
                
                List<cec_Fulfilment__c>  Listff = new List<cec_Fulfilment__c> ();
                List<cec_Fulfilment__c>  Listff1 = new List<cec_Fulfilment__c> ();  
                List<cec_Fulfilment__c>  Listff2 = new List<cec_Fulfilment__c> ();  
                Map<id,cec_Fulfilment__c> FulfilMap = new Map<id,cec_Fulfilment__c>();
                Map<id,cec_Fulfilment__c> FulfilMap1 = new Map<id,cec_Fulfilment__c>();
                Map<id,cec_Fulfilment__c> FulfilMap2 = new Map<id,cec_Fulfilment__c>();            
                
                
               Account accountObj = new Account();
                accountObj.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
                accountObj.PersonMailingCity = 'Mumbai';
                accountObj.LastName = 'TestAccount';        
                
                insert accountObj;
                System.assertEquals( accountObj.LastName,'TestAccount');         
                
                
                
                Case caseObj = new Case();
                caseObj .Status = 'New';
                caseObj .Origin = 'Email';
                caseObj.AccountID=  accountObj.id;
                caseObj.Case_product_category__c='IceCream';
                insert caseObj;
                System.assertEquals( caseObj.Origin,'Email');           
                
                System.debug('~~~~caseObj '+ caseObj);     
                System.debug('~~~~caseObj Account'+ caseObj.Account);      
    
                cec_Enclosure__c enclosure1 = new cec_Enclosure__c();
                enclosure1.name = 'UK601';
                enclosure1.Active__c = true;
                enclosure1.Country__c = 'United States';
                insert enclosure1;
                cec_Enclosure__c en1 = [select id,name from cec_Enclosure__c where name ='UK601' ];
                 System.assertEquals(en1.name,'UK601');  
                
                cec_Enclosure__c enclosure2 = new cec_Enclosure__c();
                enclosure2.name = 'UK602';
                enclosure2.Active__c = true;
                enclosure2.Country__c = 'United States';
                insert enclosure2;
                cec_Enclosure__c en2 = [select id, name from cec_Enclosure__c where name ='UK602' ];
                 System.assertEquals(en2.name,'UK602');  
                
                cec_Enclosure__c enclosure3 = new cec_Enclosure__c();
                enclosure3.name = 'UK603';
                enclosure3.Active__c = true;
                enclosure3.Country__c = 'United States';
                insert enclosure3;
                cec_Enclosure__c en3 = [select id,name from cec_Enclosure__c where name ='UK603' ];
                 System.assertEquals(en3.name,'UK603');  
    
                cec_Enclosure__c enclosure4 = new cec_Enclosure__c();
                enclosure4.name = 'UK604';
                enclosure4.Active__c = true;
                enclosure4.Country__c = 'United States';
                insert enclosure4;
                cec_Enclosure__c en4 = [select id,name from cec_Enclosure__c where name ='UK604' ];
                 System.assertEquals(en4.name,'UK604');  
    
                cec_Enclosure__c enclosure5 = new cec_Enclosure__c();
                enclosure5.name = 'UK605';
                enclosure5.Active__c = true;
                enclosure5.Country__c = 'United States';
                insert enclosure5;          
                cec_Enclosure__c en5 = [select id, name from cec_Enclosure__c where name ='UK605' ];
                 System.assertEquals(en5.name,'UK605');  
                
                integer enCount = [select count() from cec_Enclosure__c where name like 'UK%' ];
                System.assertEquals(enCount,5);
                
                cec_Fulfilment__c fulfilmentObj = new cec_Fulfilment__c();
                fulfilmentObj.Case__c = caseObj.id;  
                fulfilmentObj.Country__c = 'United States';
                
                Listff.add(fulfilmentObj);   
                insert Listff;
                System.assertEquals(Listff.size(),1);
                FulfilMap.put(fulfilmentObj.Id,fulfilmentObj);
                System.debug('~~~~fulfilmentObj'+ fulfilmentObj);  
                
                cec_Fulfilment__c oldfulfilmentObj = [select ID,Enclosure1_Quantity__c,Enclosure2_Quantity__c,Enclosure3_Quantity__c,Enclosure4_Quantity__c,Enclosure5_Quantity__c from cec_Fulfilment__c where id = :fulfilmentObj.Id];
                oldfulfilmentObj.Enclosure1__c = en1.Id;
                oldfulfilmentObj.Enclosure2__c = en2.Id;
                oldfulfilmentObj.Enclosure3__c = en3.Id;
                oldfulfilmentObj.Enclosure4__c = en4.Id;
                oldfulfilmentObj.Enclosure5__c = en5.Id;
                
                oldfulfilmentObj.Enclosure1_Quantity__c = '1';
                oldfulfilmentObj.Enclosure2_Quantity__c = '2';
                oldfulfilmentObj.Enclosure3_Quantity__c = '3';
                oldfulfilmentObj.Enclosure4_Quantity__c = '4';
                oldfulfilmentObj.Enclosure5_Quantity__c = '5';
                
                update oldfulfilmentObj;
                
                FulfilMap1.put(oldfulfilmentObj.Id,oldfulfilmentObj);
                
                
                
                System.assertEquals(Listff.size(),1);
                
                
                User loggedinuser = [select Quality_Check_Percentage__c,Max_Refund_Amount__c, FirstName from User where id = :UserInfo.getUserId()];
                
                System.debug(''+loggedinuser.Quality_Check_Percentage__c+' '+loggedinuser.FirstName);
                
                
                CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
                fulfilmentHelper.upsertFulfilmentEnclosure(Listff,FulfilMap);
                
                integer ffENCount = [select count() from CEC_Fulfilment_Enclosure__c  ];
                System.assertEquals(ffENCount,5);
                
    
                //////////////////////////////////
                cec_Fulfilment__c oldfulfilmentObj1 = [select ID,Enclosure1_Quantity__c,Enclosure2_Quantity__c,Enclosure3_Quantity__c,Enclosure4_Quantity__c,Enclosure5_Quantity__c from cec_Fulfilment__c where id = :fulfilmentObj.Id];
                oldfulfilmentObj1.Enclosure1_Quantity__c = '1';
                oldfulfilmentObj1.Enclosure2_Quantity__c = '1';
                oldfulfilmentObj1.Enclosure3_Quantity__c = '1';
                oldfulfilmentObj1.Enclosure4_Quantity__c = '1';
                oldfulfilmentObj1.Enclosure5_Quantity__c = '1';
                
                update oldfulfilmentObj1;
                Listff1.add(oldfulfilmentObj1); 
                System.assertEquals(Listff1.size(),1);
    
                fulfilmentHelper.upsertFulfilmentEnclosure(Listff1,FulfilMap1);
                FulfilMap2.put(oldfulfilmentObj1.Id,oldfulfilmentObj1);
                
                integer ffENCount1 = [select count() from CEC_Fulfilment_Enclosure__c  ];
                System.assertEquals(ffENCount1,5);          
    
            
                cec_Fulfilment__c oldfulfilmentObj2 = [select ID,Enclosure1__c,Enclosure2__c,Enclosure3__c,Enclosure4__c,Enclosure5__c,Enclosure1_Quantity__c,Enclosure2_Quantity__c,Enclosure3_Quantity__c,Enclosure4_Quantity__c,Enclosure5_Quantity__c from cec_Fulfilment__c where id = :fulfilmentObj.Id];
                
                
                oldfulfilmentObj2.Enclosure3__c = null;
                oldfulfilmentObj2.Enclosure4__c = null;
                oldfulfilmentObj2.Enclosure5__c = null;
                
                oldfulfilmentObj2.Enclosure3_Quantity__c = null;
                oldfulfilmentObj2.Enclosure4_Quantity__c = null;
                oldfulfilmentObj2.Enclosure5_Quantity__c = null;          
    
                update oldfulfilmentObj2;
                Listff2.add(oldfulfilmentObj2);
                System.assertEquals(Listff2.size(),1);
                
                 
                fulfilmentHelper.deleteFulfilmentEnclosure(Listff2,FulfilMap2);
                integer ffENCount2 = [select count() from CEC_Fulfilment_Enclosure__c  ];
                System.assertEquals(ffENCount2,2);          
                
            
                
            }
            
        }
    
        
    /* -- Samrin Changes For US - AutoEnclousure */  
     public static testMethod void test_EnclousurePopulatedCheck(){
                   User u = insertUser();        
            System.runAs(u) {
    
                mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category',L2_Product_Category__c='Other Foods');
                insert pCategory;
                
                mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
                insert productObj;           
                
                mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', 
                                                                L2_Desc__c = 'Product', L3_Desc__c = 'Foreign matter',
                                                                L4_Desc__c = 'Unidentifiable Foreign Matter', 
                                                                L5_Desc__c = 'Foreign matter - unidentifiable');
                insert gListingTree;
                
                mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Foreign matter - unidentifiable', L5_Code__c='Foreign matter - unidentifiable',Global_Listening_Tree__c = gListingTree.Id);
                insert reasonObj;
                
                mdm_Geography__c  geographyObj = new mdm_Geography__c(name='United States', ISO_Country_Dependency_Medium_Name__c= 'United States');
                insert geographyObj;
                
                cec_Case_QC_Mapping__c caseQCMappingObj = new cec_Case_QC_Mapping__c(QC_Type__c='Spam',Status__c='New',Verbatim__c='Test description',Product__c=productObj.id,Reason_Code__c=reasonObj.id,Country__c=geographyObj.id);
                insert caseQCMappingObj;
    
                CEC_Case_Market_Mapping__c marketObj = new CEC_Case_Market_Mapping__c(Market__c='United States',Name ='United States',Country__c =geographyObj.id);
                insert marketObj;
                
                List<cec_Alert_Rule__c> alertRuleLst = new  List<cec_Alert_Rule__c>();
                cec_Alert_Rule__c alertRule1 = new cec_Alert_Rule__c(Name = 'Rule 1', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='United States',  All_Market__c = false, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5');
                cec_Alert_Rule__c alertRule2 = new cec_Alert_Rule__c(Name = 'Rule 2', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='United States',  All_Market__c = false, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5');
                cec_Alert_Rule__c alertRule3 = new cec_Alert_Rule__c(Name = 'Rule 3', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='United States',  All_Market__c = false, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5');
                cec_Alert_Rule__c alertRule4 = new cec_Alert_Rule__c(Name = 'Rule 4', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='India',  All_Market__c = false, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5');
                cec_Alert_Rule__c alertRule5 = new cec_Alert_Rule__c(Name = 'Rule 5', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='India',  All_Market__c = false, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5');
    
                alertRuleLst.add(alertRule1);
                alertRuleLst.add(alertRule2);
                alertRuleLst.add(alertRule3);
                alertRuleLst.add(alertRule4);
                alertRuleLst.add(alertRule5);
                insert alertRuleLst;
    
                // Add Encolsures 
                
                List<cec_Enclosure__c> enclosureLst = new List<cec_Enclosure__c>();
                cec_Enclosure__c enclosure1 = new cec_Enclosure__c(Name ='E - 111',Active__c =true,Country__c='United States');
                cec_Enclosure__c enclosure2 = new cec_Enclosure__c(Name ='E - 112',Active__c =true,Country__c='United States');
                cec_Enclosure__c enclosure3 = new cec_Enclosure__c(Name ='E - 113',Active__c =true,Country__c='India');
                cec_Enclosure__c enclosure4 = new cec_Enclosure__c(Name ='E - 114',Active__c =true,Country__c='United States');
                cec_Enclosure__c enclosure5 = new cec_Enclosure__c(Name ='E - 211',Active__c =true,Country__c='United States');
                cec_Enclosure__c enclosure6 = new cec_Enclosure__c(Name ='E - 212',Active__c =true,Country__c='India');
                cec_Enclosure__c enclosure7 = new cec_Enclosure__c(Name ='E - 213',Active__c =true,Country__c='United States');
                cec_Enclosure__c enclosure8 = new cec_Enclosure__c(Name ='E - 214',Active__c =true,Country__c='United States');
                cec_Enclosure__c enclosure9 = new cec_Enclosure__c(Name ='E - 311',Active__c =true,Country__c='United States');
                cec_Enclosure__c enclosure10 = new cec_Enclosure__c(Name ='E - 312',Active__c =true,Country__c='United States');
                cec_Enclosure__c enclosure11 = new cec_Enclosure__c(Name ='E - 313',Active__c =true,Country__c='India');
                cec_Enclosure__c enclosure12= new cec_Enclosure__c(Name ='E - 314',Active__c =true,Country__c='United States');
                enclosureLst.add(enclosure1);
                enclosureLst.add(enclosure2);
                enclosureLst.add(enclosure3);
                enclosureLst.add(enclosure4);
                enclosureLst.add(enclosure5);
                enclosureLst.add(enclosure6);
                enclosureLst.add(enclosure7);
                enclosureLst.add(enclosure8);
                enclosureLst.add(enclosure9);
                enclosureLst.add(enclosure10);
                enclosureLst.add(enclosure11);
                enclosureLst.add(enclosure12);
                insert enclosureLst;
                
                // Alert Actions 
                List<cec_Alert_Action__c> alertActionLst = new  List<cec_Alert_Action__c>();
                cec_Alert_Action__c alertAction1 = new cec_Alert_Action__c( Type__c = 'Fulfilment', Alert_Rule_Id__c = alertRule1.id,
                                                                            Country_Name__c='United States',
                                                                            Enclosure1__c =enclosure7.Id ,Enclosure5__c=enclosure4.Id );
                cec_Alert_Action__c alertAction2 = new cec_Alert_Action__c( Type__c='Fulfilment', Alert_Rule_Id__c = alertRule2.id,
                                                                             Country_Name__c='United States',
                                                                             Enclosure1__c =enclosure7.Id ,Enclosure2__c =enclosure12.Id,Enclosure5__c=enclosure4.Id );
    
                cec_Alert_Action__c alertAction3 = new cec_Alert_Action__c( Type__c='Fulfilment', Alert_Rule_Id__c = alertRule3.id,
                                                                             Country_Name__c='United States',
                                                                             Enclosure1__c =enclosure1.Id , Enclosure3__c =enclosure10.Id,Enclosure4__c=enclosure2.Id );
    
                cec_Alert_Action__c alertAction4 = new cec_Alert_Action__c( Type__c='Fulfilment', Alert_Rule_Id__c = alertRule4.id,
                                                                             Country_Name__c='United States',
                                                                             Enclosure2__c =enclosure12.Id);
                alertActionLst.Add(alertAction1);
                alertActionLst.Add(alertAction2);
                alertActionLst.Add(alertAction3);
                alertActionLst.Add(alertAction4);
                Insert alertActionLst;
                    
                Account accountObj = new Account();
                accountObj.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
                accountObj.PersonMailingCity = 'NY';
                accountObj.PersonMailingCountry='United States';
                accountObj.LastName = 'TestAccount';        
                
                insert accountObj;       
                Case caseObj= new Case();
                caseObj.Status='New';
                caseObj.Origin='Email'; 
                caseObj.AccountID=  accountObj.id;
                caseObj.Reason_Code__c = reasonObj.id;
                caseObj.Country__c =marketObj.id;
                CaseObj.DayCode__c='E111';
                insert caseObj;
                caseObj.CEC_Product__c = productObj.id;
                Update caseObj;
                String CaseId =caseObj.id;
                // Call to the Functionality of  CSC : 2765  :  US-009 Letter/Enclosure auto population
                 
                CEC_AlertFulfilmentEnclosureHelper.AlertFulfilmentEnclosureHelperWrapperResponse result =new   CEC_AlertFulfilmentEnclosureHelper.AlertFulfilmentEnclosureHelperWrapperResponse ();
                result=CEC_AlertFulfilmentEnclosureHelper.populateEnclosureDetails(CaseId,accountObj.PersonMailingCountry);
                System.assertEquals('Success', result.message);
                System.assertEquals(5, result.enclosuresList.size());
    
                //Fulfilment  
                cec_Fulfilment__c newFulfilment = new cec_Fulfilment__c();
                newFulfilment.Case__c = caseObj.id;
                newFulfilment.Country__c=accountObj.PersonMailingCountry; 
                 if (result.status == 'S'){
                    
                if(result.enclosuresList.size()>0 )
                {
                      if(result.enclosuresList.get(0) !=null)
                        {
                             newFulfilment.Enclosure1__c=result.enclosuresList.get(0);
                             newFulfilment.Enclosure1_Quantity__c='1';
                        }
                      if(result.enclosuresList.get(1) !=null)
                        {
                             newFulfilment.Enclosure2__c=result.enclosuresList.get(1);
                             newFulfilment.Enclosure2_Quantity__c='1';
                        }
                      if(result.enclosuresList.get(2) !=null)
                        {
                             newFulfilment.Enclosure3__c=result.enclosuresList.get(2);
                             newFulfilment.Enclosure3_Quantity__c='1';
                        }
                      if(result.enclosuresList.get(3) !=null)
                        {
                             newFulfilment.Enclosure4__c=result.enclosuresList.get(3);
                             newFulfilment.Enclosure4_Quantity__c='1';
                        }
                      if(result.enclosuresList.get(4)!=null)
                        {
                             newFulfilment.Enclosure5__c=result.enclosuresList.get(4);
                             newFulfilment.Enclosure5_Quantity__c='1';
                        }
                
                }
            }
           
                Insert  newFulfilment;
    
                
                cec_Fulfilment__c  fulfilmenttemp  = [SELECT  Id, Name , Enclosure1__c,Enclosure2__c,Enclosure3__c,
                                                      Enclosure4__c,Enclosure5__c,Enclosure1_Quantity__c,Enclosure2_Quantity__c,
                                                      Enclosure3_Quantity__c,Enclosure4_Quantity__c,Enclosure5_Quantity__c 
                                                      FROM cec_Fulfilment__c 
                                                      WHERE id =:newFulfilment.Id ];
    
                
                // Rajesh Code start
                System.assertNotEquals(fulfilmenttemp.Enclosure1__c,null);
                System.assertNotEquals(fulfilmenttemp.Enclosure2__c,null);
                System.assertNotEquals(fulfilmenttemp.Enclosure3__c,null);
                System.assertNotEquals(fulfilmenttemp.Enclosure4__c,null);
                System.assertNotEquals(fulfilmenttemp.Enclosure5__c,null);
                System.assertEquals(fulfilmenttemp.Enclosure1_Quantity__c,'1');
                System.assertEquals(fulfilmenttemp.Enclosure2_Quantity__c,'1');
                System.assertEquals(fulfilmenttemp.Enclosure3_Quantity__c,'1');
                System.assertEquals(fulfilmenttemp.Enclosure4_Quantity__c,'1');
                System.assertEquals(fulfilmenttemp.Enclosure5_Quantity__c,'1');
    
                integer ffENCount = [select count() from CEC_Fulfilment_Enclosure__c ];
                System.assertEquals(5,ffENCount);
    
                // Rajesh Code ends
            
        }
     }
 
       public static testMethod void test_convertRefundValueToWords(){
            
            User u = insertUser();        
            System.runAs(u) {
                
                List<cec_Fulfilment__c>  Listff = new List<cec_Fulfilment__c> ();
                List<cec_Fulfilment__c>  Listff1 = new List<cec_Fulfilment__c> ();         
                List<CEC_ChequeBook_Detail__c> chbd = new List<CEC_ChequeBook_Detail__c>();
                
                Map<id,cec_Fulfilment__c> FulfilMap = new Map<id,cec_Fulfilment__c>();
                
                Account accountObj = new Account();
                accountObj.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
                accountObj.PersonMailingCity = 'United States';
                accountObj.LastName = 'TestAccount';  
                insert accountObj;
                System.assertEquals(accountObj.LastName,'TestAccount');  
                
                mdm_Product_Category__c pc = new mdm_Product_Category__c();
                //pc.L7_Product_Category__c ='Soup';
                pc.L2_Product_Category__c ='Savoury';
                pc.Corp_Brand_Name__c ='Knorr';
                insert pc;
                
                mdm_Case_Product__c cp = new mdm_Case_Product__c();
                cp.Brand__c ='Knorr';
                cp.Active_for_CEC__c= true;
                cp.Global_CPG_Code__c = pc.id;
                insert cp;
                
                Case caseObj = new Case();
                caseObj .Status = 'New';
                caseObj .Origin = 'Email';
                caseObj.AccountID=  accountObj.id;
                //caseObj.Case_product_category__c = 'Soup';
                caseObj.Brand__c = 'Knorr';
                caseObj.CEC_Product__c = cp.id;
                insert caseObj;
                System.assertEquals( caseObj.Origin,'Email');           
                
                System.debug('~~~~caseObj '+ caseObj);     
                System.debug('~~~~caseObj Account'+ caseObj.Account);      
                
                cec_Fulfilment__c fulfilmentObj = new cec_Fulfilment__c();  
                fulfilmentObj.Case__c = caseObj.id;  
                fulfilmentObj.Country__c = 'United States';
                fulfilmentObj.Refund_Value__c = 11.11;
                //fulfilmentObj.Cheque_Number__c = 12;
                //fulfilmentObj.Case_Product_Category__c = cp.id;
                Listff.add(fulfilmentObj);   
                insert Listff;
                
                
                FulfilMap.put(fulfilmentObj.Id,fulfilmentObj);
                
                System.debug('~~~~fulfilmentObj'+ fulfilmentObj); 
                System.assertEquals(Listff.size(),1);
                
                //  
                CEC_Cheque_Authorization_Limit__c chequeLimit=new CEC_Cheque_Authorization_Limit__c(Level_1__c=100,Level_2__c=200,Level_3__c=300,Level_4__c=400,Level_5__c=500,Level_6__c=600,Level_7__c=700);
                insert chequeLimit;
                
                User loggedinuser = [select Quality_Check_Percentage__c,Max_Refund_Amount__c, FirstName from User where id = :UserInfo.getUserId()];
                loggedinuser.Refund_Authorization_Limit__c ='Level 4';
                update loggedinuser;                
                
                mdm_Geography__c g = new mdm_Geography__c();
                g.Name='United States';
                insert g;
                
                CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
                cmm.Market__c='North America';
                cmm.Country__c=g.Id;
                cmm.Language__c='English';
                insert cmm;
                
                CEC_ChequeBook_Detail__c cd1= new CEC_ChequeBook_Detail__c();
                cd1.Cheque_Book__c='CB1';
                cd1.Increment_Number__c=1;
                cd1.Currency__c ='USD';
                cd1.Currency_Text__c ='Dollors';
                cd1.Currency_Decimal_Text__c ='Cents';
                cd1.Last_Cheque_Number__c = 11;
               // cd1.Brand__c='Knorr';
                cd1.Country__c =cmm.Id;
                cd1.Max_Cheque_Number__c =1000;
                cd1.Active__c = true;
                cd1.Product_Category__c = pc.Id;
                //cd1.Product_Category__c = 'Soup'; -- Nagesh
                chbd.add(cd1);
                
                insert chbd;  
                
                //System.assertEquals(fulfilmentObj.Cheque_Number__c, cd1.Last_Cheque_Number__c+cd1.Increment_Number__c);
                CEC_ChequeProcess.generateChequeNumber(Listff[0].Id);
                
                fulfilmentObj.Refund_Value__c = 10.11;
                update fulfilmentObj;
                
                CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
                fulfilmentHelper.ConvertRefundValueToWords(Listff,FulfilMap);
                
                cec_Fulfilment__c newfulfilmentObj = [select ID,Cheque_Number__c,ChequeBook__c,Refund_Value__c,Refund_Value_in_Words__c from cec_Fulfilment__c where id = :fulfilmentObj.Id];
                
                System.assertEquals(newfulfilmentObj.Refund_Value__c, 10.11);
                System.assertEquals(newfulfilmentObj.Cheque_Number__c, '12');
                System.assertEquals(newfulfilmentObj.Refund_Value_in_Words__c, 'Ten Dollors and Eleven Cents');
                
                ///
                
                fulfilmentObj.Refund_Value__c = 112.33;
                update fulfilmentObj;
                
                //CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
                fulfilmentHelper.ConvertRefundValueToWords(Listff,FulfilMap);
                
                cec_Fulfilment__c newfulfilmentObj1 = [select ID,Cheque_Number__c,ChequeBook__c,Refund_Value__c,Refund_Value_in_Words__c from cec_Fulfilment__c where id = :fulfilmentObj.Id];
                
                System.assertEquals(newfulfilmentObj1.Refund_Value__c, 112.33);
                System.assertEquals(newfulfilmentObj1.Cheque_Number__c, '12');
                System.assertEquals(newfulfilmentObj1.Refund_Value_in_Words__c, 'One Hundred and Twelve Dollors and Thirty Three Cents');               
                
                ///
                
                fulfilmentObj.Refund_Value__c = 112;
                update fulfilmentObj;
                
                //CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
                fulfilmentHelper.convertRefundValueToWords(Listff,FulfilMap);
                
                cec_Fulfilment__c newfulfilmentObj2 = [select ID,Cheque_Number__c,ChequeBook__c,Refund_Value__c,Refund_Value_in_Words__c from cec_Fulfilment__c where id = :fulfilmentObj.Id];
                
                System.assertEquals(newfulfilmentObj2.Refund_Value__c, 112);
                System.assertEquals(newfulfilmentObj2.Cheque_Number__c, '12');
                System.assertEquals(newfulfilmentObj2.Refund_Value_in_Words__c, 'One Hundred and Twelve Dollors');              
                
              
                
                 
            }
        }

 
    }