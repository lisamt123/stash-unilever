/**********************************************************************
Name:  CEC_CaseActionControllerTest()
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the Test class for CEC_CaseActionController Apex class                                                                                                    

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0       Koti             Dec-2015      INITIAL DEVELOPMENT   
***********************************************************************/

@isTest(SeeAllData=false)
public class CEC_CaseActionControllerTest{
    
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
        List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN ('CEC_User','CEC_Manager','CEC_CRUD','CEC_Business_Admin','CEC_Knowledge_Manager','CEC_Automated_User')];
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
      Test method for constructor
    */  
    public static testMethod void TestConstructor(){
        Test.startTest();
        User u = insertUser();
        
        System.runAs(u)
        {
            String CurrentCaseId = '';
            
            PageReference pageRef = Page.CEC_CaseActions;
            //Test data creation for 'Case Market Mapping'
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c = 'India';
            insert cmm;
            
            //Test data creation for 'Product Category'
            mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
            insert pCategory;
            
            //Test data creation for 'Case Product'
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Dove Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
            insert productObj;          
            
            //Test data creation for 'Global Listening Tree'
            mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', L2_Desc__c = 'Product',
                                                                L3_Desc__c = 'Foreign matter',L4_Desc__c = 'Unidentifiable Foreign Matter', L5_Desc__c = 'Foreign matter - unidentifiable');
            insert gListingTree;
            
            //Test data creation for 'Reason Code'
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261', Global_Listening_Tree__c = gListingTree.Id);
            insert reasonObj;
            
            //Test data creation for 'Case'
            Case caseObj= new Case();
            caseObj.Status='New';
            caseObj.Origin='Email'; 
            caseObj.Subject = 'Complaint on Dove Soap';
            caseObj.CEC_Product__c = productObj.id;
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Country__c = cmm.id;
            caseObj.Production_Code__c = 'L1234';
            caseObj.DayCode__c ='1234';
            insert caseObj;
            
            caseObj.CEC_Product__c = null;
            update caseObj;
            
            /*case caseTest2 = [Select DayCode__c, Case_Market__c from case Where DayCode__c ='1234'];
            
            System.assertEquals(cmm.Market__c, caseTest2.Case_Market__c);*/
            
            //Test data creation for 'Alert Rule'
            cec_Alert_Rule__c alertRule = new cec_Alert_Rule__c(Name = 'Rule 1', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='India',  All_Market__c = false, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5', Group_By_Day_Code__c = true);
            insert alertRule;
            
            //Test data creation for 'Person Account'
            Id personAccountRecordId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
            Account newConsumer = new Account();
            newConsumer.FirstName = 'John.Smith@test00DE0000000bbLj.com';
            newConsumer.LastName = 'John.Smith@test00DE0000000bbLj.com';
            newConsumer.PersonEmail = 'John.Smith@test00DE0000000bbLj.com';
            newConsumer.RecordTypeId = personAccountRecordId;
            String accountString = JSON.serialize(newConsumer);
            accountString = accountString.subString( 0, accountString.length() - 1 ) + ',"IsPersonAccount":true}';
            newConsumer = (Account)JSON.deserialize( accountString, Account.class );
            insert newconsumer;
            
            
            //List to store the 'Alert Action' records
            List<cec_Alert_Action__c> alertActionList = new List<cec_Alert_Action__c>();
            
            //Test data creation for 'Alert Action'
            cec_Alert_Action__c alertAction = new cec_Alert_Action__c( Type__c = 'Questionnaire', Alert_Rule_Id__c = alertRule.id,
                                                            Q12__c = 'CaseNumber', Q2__c = 'CaseOrigin', Q3__c = 'CaseOwner', 
                                                            Q4__c = 'ProductCode', Q5__c = 'ProductionCode', Q6__c = 'ReasonCodeDesc',
                                                            Q7__c = 'ShortCode', Q8__c = 'Verbatim',
                                                            Q9__c = 'UsedProdPreviously', Q10__c = 'CaseOpenedDate',
                                                            Survey_Id__c = 'abcdefgh', Survey_Name__c = 'Test Survey Name');

  
            alertActionList.add(alertAction);
            insert alertActionList;
            
            caseObj.CEC_Product__c = productObj.id;
            update caseObj;
            //Storing the case id to a string
            CurrentCaseId = caseObj.Id;
            
            //check whether the 'Alert Tracker Item' is created or not
            Integer atCount = [SELECT COUNT() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
            System.assertEquals(1,atCount);
            
            // Fetch the Case Action Records related to the 'caseObj' case record.
            List<cec_Case_Action__c> surveyCaseActionList = [Select Id, Q12_Data__c, Q2_Data__c, Q3_Data__c, Q4_Data__c, 
                                                        Q5_Data__c, Q6_Data__c, Q7_Data__c, Q8_Data__c, Q9_Data__c,
                                                        Q10_Data__c, Q11_Data__c, Survey_Id__c, Survey_Name__c From cec_Case_Action__c WHERE Case_Id__c = :CurrentCaseId];
       
            System.assertEquals(surveyCaseActionList[0].Q8_Data__c, '&q8=Complaint on Dove Soap');
            System.assertEquals(surveyCaseActionList[0].Q2_Data__c, '&q2=Email');   
            System.assertEquals(surveyCaseActionList[0].Survey_Id__c, 'abcdefgh');
            
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', CurrentCaseId);
            //Create a new instance of the class
            CEC_CaseActionController controller = new CEC_CaseActionController();
            System.assertEquals(controller.CaseActionList[0].Q8_Data__c, '&q8=Complaint on Dove Soap');
            System.assertEquals(controller.CaseActionList[0].Q2_Data__c, '&q2=Email'); 
            System.assertEquals(controller.CaseActionList[0].Q5_Data__c, '&q5=L1234');
            System.assertEquals(controller.CaseActionList[0].Survey_Id__c, 'abcdefgh');
            System.assertEquals(controller.CaseActionList[0].Survey_Name__c, 'Test Survey Name');
        }
        Test.stopTest();
    }
    
}