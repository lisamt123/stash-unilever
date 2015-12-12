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
            
            
            User loggedinuser = [select Quality_Check_Percentage__c,Max_Refund_Amount__c, FirstName from User where id = :UserInfo.getUserId()];
            
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
            
            
            fulfilmentHelper.refundApprovalCheck(Listff1,FulfilMap);
            
            
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
}