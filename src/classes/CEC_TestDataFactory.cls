/**********************************************************************
Name:  CEC_TestDataFactory()
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: This is the factory class to create CEC Test Data

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Sathish           Mar-2016      INITIAL DEVELOPMENT   

***********************************************************************/
@isTest
public class CEC_TestDataFactory {

    public static User createStandardCECTestUser() {
        List<String> permissionSetsToBeAssigned = new List<String>{'CEC_User','CEC_Manager', 'CEC_CRUD',
                                                    'CEC_Business_Admin','CEC_Knowledge_Manager','CEC_Automated_User'};
        List<String> groupList = new List<String>{'CEC - Knowledge Manager'};

        User cecTestUser = createUser('Unilever - Salesforce MultiApp Standard','CEC Global Head', 'cectestuser@test00DE0000000bbLj.org');
        assignPermissionSet(cecTestUser.Id, permissionSetsToBeAssigned);
        addToGroup(cecTestUser.Id, groupList);
        return cecTestUser;
    }

    public static User createDebitCardProcessTestUser() {
        List<String> permissionSetsToBeAssigned = new List<String>{'CEC_User', 'CEC_Debit_Card_Process','CEC_E_Voucher_Process','CEC_Business_Admin'};
        User cecTestUser = createUser('Unilever - Salesforce MultiApp Standard','CEC Global Head','cecdebittestuser@test00DE0000000bbLj.org');
        assignPermissionSet(cecTestUser.Id, permissionSetsToBeAssigned);
        return cecTestUser;
    }
    public static User createEvoucherProcessTestUser() {
        List<String> permissionSetsToBeAssigned = new List<String>{'CEC_User', 'CEC_E_Voucher_Process','CEC_Business_Admin'};
        User cecTestUser = createUser('Unilever - Salesforce MultiApp Standard','CEC Global Head','cecdebittestuser@test00DE0000000bbLj.org');
        assignPermissionSet(cecTestUser.Id, permissionSetsToBeAssigned);
        return cecTestUser;
    }
    public static User getStandardCECTestUser() {
        User u = [SELECT Id FROM User WHERE Email='cectestuser@test00DE0000000bbLj.org' LIMIT 1];
        return u;
    }
    
    public static User createUser(String userPofile, String userRole, String userName){  
        Profile testUserProfile = [SELECT Id FROM Profile WHERE Name = :userPofile];
        UserRole testUserRole;
        if(String.isNotBlank(userRole)){
            testUserRole = [SELECT Id, name FROM UserRole WHERE Name = :userRole];
        }        
        User u = new User(LastName = 'Testing',
                          Username = userName,
                          Email = 'cectestuser@test00DE0000000bbLj.org', 
                          Alias = 'utest',
                          TimeZoneSidKey = 'Europe/London',
                          LocaleSidKey = 'en_GB', 
                          EmailEncodingKey = 'UTF-8',
                          ProfileId = testUserProfile.Id,
                          UserRoleId = testUserRole.id,
                          LanguageLocaleKey = 'en_US',
                          UserPermissionsKnowledgeUser = true);
        
        insert u;
        return u;
    }

    public static void assignPermissionSet(Id userId, List<String> permissionSetsToBeAssigned){
        List<PermissionSetAssignment> psalist = new List<PermissionSetAssignment>();
        
        List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN :permissionSetsToBeAssigned];      
        for(PermissionSet ps:pslist){
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = userId;
            psa.PermissionSetId = ps.Id;            
            psalist.add(psa);            
        }
        insert psalist;
    }

    public static void addToGroup(Id userId, List<String> groups){
        List<GroupMember> gmList = new List<GroupMember>();     
        List<Group> GrpList = [SELECT Id, name FROM Group WHERE Name IN :groups];       
        for(Group g :GrpList){
            GroupMember gm = new GroupMember();
            gm.GroupId = g.Id;
            gm.UserOrGroupId = userId;            
            gmList.add(gm);         
        }
        insert gmList;
    }

    public static Id getRecordTypeId(string recordTypeName, string sObjectname){
        Id rtId = [SELECT Id, name FROM RecordType WHERE DeveloperName = :recordTypeName AND SObjectType =: sObjectname limit 1].Id;
        
        return rtId;
    }

    public static List<Case> createTestCases(Integer noOfCases, String status, String origin,
                                            String productionCode, String dayCode,
                                            Id productId, Id reasonCodeId,  Id accountId,
                                            Id caseMarketMappingId, Boolean createAccountByDefault){
        List<Case> testCaseList = new List<Case>();
        Id noneRecordTypeId = [SELECT id, name FROM RecordType WHERE name='None' AND SobjectType = 'Case'].Id;
        for(Integer i = 1; i <= noOfCases; i++){
            Case caseObj = new Case();
            if (createAccountByDefault) {
                caseObj.SuppliedEmail = i+'cecTestForCase@UnileverTest.com';
                caseObj.SuppliedName = 'Unit Test Consumer : ' + i;
            }
            caseObj.Description = 'This is case description '+ i +' created by the test method';
            caseObj.Subject = 'This is case subject '+ i;
            caseObj.Status = status;
            caseObj.Origin = origin;
            caseObj.CEC_Product__c = productId;
            caseObj.AccountId = accountId; 
            caseObj.Reason_Code__c = reasonCodeId;
            caseObj.Country__c = caseMarketMappingId;
            caseObj.Production_Code__c = productionCode;
            caseObj.DayCode__c = dayCode;
            caseObj.RecordTypeId = noneRecordTypeId;
            testCaseList.add(caseObj);
        }
        return testCaseList;
    }
    
    public static List<Case> createBlankTestCases(Integer noOfCases, String origin){
        List<Case> testCaseList = new List<Case>();
        Id noneRecordTypeId = [SELECT id,name FROM RecordType WHERE name='None'].Id;
        for(Integer i = 1; i <= noOfCases; i++){
            Case caseObj = new Case();
            caseObj.RecordTypeId = noneRecordTypeId;
            caseObj.Origin = origin;
            testCaseList.add(caseObj);
        }
        return testCaseList;
    }

    public static List<Account> createTestAccounts(Integer noOfAccounts, String lastName, String personEmail,
                                                    String personMailingStreet, String personMailingPostalCode,
                                                    String personMailingCity, String personMailingCountry,
                                                    String knownConsumer){
        List<Account> testAccountList = new List<Account>();
        Id recordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
        for(Integer i = 1; i <= noOfAccounts; i++){
            Account anAccount = new Account();
            
            anAccount.FirstName = 'JohnTest';
            anAccount.LastName = lastName + i;
            anAccount.PersonMailingStreet = personMailingStreet;
            anAccount.PersonMailingPostalCode = personMailingPostalCode;        
            anAccount.PersonMailingCity = personMailingCity;    
            anAccount.PersonMailingCountry = personMailingCountry;
            anAccount.Known_Consumer__c = knownConsumer;
            anAccount.RecordTypeId = recordTypeId;
            if(String.isNotBlank(personEmail)) {
                anAccount.PersonEmail = String.valueOf(i) + personEmail;
            }
            testAccountList.add(anAccount);
        }
        return testAccountList;
    }

    public static List<mdm_Product_Category__c> createProductCategory(Integer noOfProdCategory) {
        List<mdm_Product_Category__c> testProdCategoryList = new List<mdm_Product_Category__c>();
        for(Integer i = 1; i <= noOfProdCategory; i++){
            mdm_Product_Category__c prodCategory = new mdm_Product_Category__c();
            prodCategory.Name = 'Test Product Category : ' + i;
            prodCategory.L0_Product_Category__c = 'Foods Category';
            prodCategory.L1_Product_Category__c = 'Food';
            prodCategory.L2_Product_Category__c = 'Savoury';
            prodCategory.L3_Product_Category__c = 'Cooking Products';
            prodCategory.L4_Product_Category__c = 'Bouillons';
            prodCategory.L5_Product_Category__c = 'Bouillon Cubes';
            prodCategory.L6_Product_Category__c = 'Bouillon Cubes';
            prodCategory.L7_Product_Category__c = 'Bouillon Cubes';
            prodCategory.Corp_Brand_Name__c = 'Knorr';
            prodCategory.Corp_Prod_Grouping_Name__c = 'Amora Bouillon Cube';
            testProdCategoryList.add(prodCategory);
        }
        return testProdCategoryList;
    }

    public static List<mdm_Case_Product__c> createCaseProduct(Integer noOfCaseProducts, Id prodCategoryId) {
        List<mdm_Case_Product__c> testCaseProdList = new List<mdm_Case_Product__c>();
        for(Integer i = 1; i <= noOfCaseProducts; i++){
            mdm_Case_Product__c caseProduct = new mdm_Case_Product__c();
            caseProduct.Name = 'Test Case Product Knorr 50 GM : ' + i;
            caseProduct.Brand__c ='Knorr';
            caseProduct.Active_for_CEC__c = true;
            caseProduct.ISO_Country_Code__c = 'US';
            caseProduct.Consumer_Product_Descriptor_Local_Lang__c = 'Knorr Chicken Soup Local';
            caseProduct.Consumer_Product_Descriptor_no_size__c = 'Knorr Chicken Soup';
            caseProduct.Global_CPG_Code__c = prodCategoryId;
            testCaseProdList.add(caseProduct);
        }
        return testCaseProdList;
    }

    public static List<mdm_Global_Listening_Tree__c> createGlobalListeningTree(Integer noOfGlobalListeningTree) {
        List<mdm_Global_Listening_Tree__c> testGlobalListeningTreeList = new List<mdm_Global_Listening_Tree__c>();
        for(Integer i = 1; i <= noOfGlobalListeningTree; i++){
            mdm_Global_Listening_Tree__c testGlobalListeningTree = new mdm_Global_Listening_Tree__c();
            
            testGlobalListeningTree.L1_Desc__c = 'Complaint';
            testGlobalListeningTree.L2_Desc__c = 'Product';
            testGlobalListeningTree.L3_Desc__c = 'Foreign matter';
            testGlobalListeningTree.L4_Desc__c = 'Unidentifiable Foreign Matter';
            testGlobalListeningTree.L5_Desc__c = 'Foreign matter - unidentifiable';
            testGlobalListeningTreeList.add(testGlobalListeningTree);
        }
        return testGlobalListeningTreeList;
    }
    
    public static List<mdm_Reason_Code__c> createReasonCode(Integer noOfReasonCode, Id globalListeningTreeId) {
        List<mdm_Reason_Code__c> testReasonCodeList = new List<mdm_Reason_Code__c>();
        for(Integer i = 1; i <= noOfReasonCode; i++){
            mdm_Reason_Code__c testReasonCode = new mdm_Reason_Code__c();
            testReasonCode.Name = 'Test Reason Code : '+ i;
            testReasonCode.L0_Code__c = 'L0Code';
            testReasonCode.L0_Desc__c = 'L0Desc';
            testReasonCode.L1_Code__c = 'T2001';
            testReasonCode.L1_Desc__c = 'Complaint';
            testReasonCode.L2_Code__c = 'T2001';
            testReasonCode.L2_Desc__c = 'Product';
            testReasonCode.L3_Code__c = 'T3004';
            testReasonCode.L3_Desc__c = 'Foreign matter';
            testReasonCode.L4_Code__c = 'T4092';
            testReasonCode.L4_Desc__c = 'Unidentifiable Foreign Matter';
            testReasonCode.L5_Code__c = 'T05099';
            testReasonCode.L5_Desc__c = 'Foreign matter - unidentifiable';
            testReasonCode.L5_Short_Desc__c = 'Short Desc';
            testReasonCode.ISO_Country__c = 'US';
            testReasonCode.Global_Listening_Tree__c = globalListeningTreeId;
            testReasonCodeList.add(testReasonCode);
        }
        return testReasonCodeList;
    }

    public static List<cec_Alert_Rule__c> createAlertRule(  Integer noOfAlertRules, String type,
                                                            String productLevel, String reasonLevel, String market,
                                                            Id reasonCodeId, Id productCategoryId, Id caseProductId,
                                                            Boolean allMarket, Boolean groupByDayCode, 
                                                            Boolean daysLimit30, Integer threshold) {
        List<cec_Alert_Rule__c> testAlertRuleList = new List<cec_Alert_Rule__c>();
        for(Integer i = 1; i <= noOfAlertRules; i++){
            cec_Alert_Rule__c testAlertRule = new cec_Alert_Rule__c();
            testAlertRule.Name = 'Test Alert Rule ' + i;
            testAlertRule.Active__c = true;
            testAlertRule.Type__c = type;
            testAlertRule.Reason_Code__c = reasonCodeId;
            testAlertRule.All_Market__c = allMarket;
            testAlertRule.Threshold__c = threshold;
            testAlertRule.Product_Category__c = productCategoryId;
            testAlertRule.Product_Level__c = productLevel;
            testAlertRule.Reason_Level__c = reasonLevel;
            testAlertRule.Group_By_Day_Code__c = groupByDayCode;
            testAlertRule.Case_Product__c = caseProductId;
            testAlertRule.X30_Days_Limit__c = daysLimit30;
            testAlertRule.Market__c = market; 
            testAlertRuleList.add(testAlertRule);
        }
        return testAlertRuleList;
    }

    public static List<cec_Alert_Action__c> createAlertAction(  Integer noOfAlertAction, String type, 
                                                                String chatterGroup1,String chatterGroup2,
                                                                String chatterTemplateName, String emailTemplateName,
                                                                String countryName, Id enclosure1Id, Id enclosure2Id,
                                                                Id enclosure3Id, Id enclosure4Id, Id enclosure5Id,
                                                                Id alertRuleId, String popupMessage, String surveyId,
                                                                String surveyName, String toEmail, String q2, String q3,
                                                                String q4, String q5, String q6, String q7, String q8,
                                                                String q9, String q10, String q11, String q12) {
        List<cec_Alert_Action__c> testAlertActionList = new List<cec_Alert_Action__c>();
        for(Integer i = 1; i <= noOfAlertAction; i++){
            cec_Alert_Action__c testAlertAction = new cec_Alert_Action__c();
            testAlertAction.Type__c = type;
            testAlertAction.Country_Chatter_Group__c = chatterGroup1;
            testAlertAction.Category_Chatter_Group__c = chatterGroup2;
            testAlertAction.Chatter_Template_Name__c = chatterTemplateName;
            testAlertAction.Email_Template_Name__c = emailTemplateName;
            testAlertAction.Country_Name__c = countryName;
            testAlertAction.Enclosure1__c = enclosure1Id;
            testAlertAction.Enclosure2__c = enclosure2Id;
            testAlertAction.Enclosure3__c = enclosure3Id;
            testAlertAction.Enclosure4__c = enclosure4Id;
            testAlertAction.Enclosure5__c = enclosure5Id;
            testAlertAction.Alert_Rule_Id__c = alertRuleId;
            testAlertAction.Popup_Message__c = popupMessage;
            testAlertAction.Survey_Id__c = surveyId;
            testAlertAction.Survey_Name__c = surveyName;
            testAlertAction.To__c = toEmail;
            testAlertAction.Q2__c = q2;
            testAlertAction.Q3__c = q3;
            testAlertAction.Q4__c = q4;
            testAlertAction.Q5__c = q5;
            testAlertAction.Q6__c = q6;
            testAlertAction.Q7__c = q7;
            testAlertAction.Q8__c = q8;
            testAlertAction.Q9__c = q9;
            testAlertAction.Q10__c = q10;
            testAlertAction.Q11__c = q11;
            testAlertAction.Q12__c = q12;
            testAlertActionList.add(testAlertAction);
        }
        return testAlertActionList;
    }

    public static List<cec_Alert_Action__c> createEmailAlertAction(Integer noOfAlertAction, 
                                                    String emailTemplateName, Id alertRuleId) {
        return createAlertAction(noOfAlertAction,'Email', null, null, null, emailTemplateName, null, null,
                                    null, null, null, null, alertRuleId, null, null, null, 'sampleabc@samplexyz.com', 
                                    null, null, null, null, null, null, null, null, null, null, null);
    }

    public static List<cec_Alert_Action__c> createQuestionnaireAlertAction(Integer noOfAlertAction, String surveyId,
                                                                String surveyName, String q2, String q3,
                                                                String q4, String q5, String q6, String q7, String q8,
                                                                String q9, String q10, String q11, String q12,
                                                                Id alertRuleId) {
        return createAlertAction(noOfAlertAction,'Questionnaire', null, null, null, null, null, null,
                                    null, null, null, null, alertRuleId, null, surveyId, surveyName, null, 
                                    q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12);
    }

    public static List<cec_Alert_Action__c> createPopupAlertAction( Integer noOfAlertAction, String popupMessage,
                                                                    Id alertRuleId) {
        return createAlertAction(noOfAlertAction,'Popup', null, null, null, null, null, null,
                                    null, null, null, null, alertRuleId, popupMessage, null, null, null, 
                                    null, null, null, null, null, null, null, null, null, null, null);
    }

    public static List<cec_Alert_Action__c> createFulfilmentAlertAction(Integer noOfAlertAction, String countryName,
                                                                    Id enclosure1Id, Id enclosure2Id, 
                                                                    Id enclosure3Id, Id enclosure4Id, 
                                                                    Id enclosure5Id, Id alertRuleId) {
        return createAlertAction(noOfAlertAction,'Fulfilment', null, null, null, null, countryName, enclosure1Id,
                                    enclosure2Id, enclosure3Id, enclosure4Id, enclosure5Id, alertRuleId, 
                                    null, null, null, null, null, null, null, null, null, null, null, null, 
                                    null, null, null);
    }

    public static List<cec_Alert_Action__c> createChatterAlertAction(Integer noOfAlertAction, String chatterTemplateName,
                                                            String chatterGroupName1, String chatterGroupName2,
                                                            Id alertRuleId) {
        return createAlertAction(noOfAlertAction,'Chatter Post', chatterGroupName1, chatterGroupName2, chatterTemplateName,
                                    null, null, null, null, null, null, null, alertRuleId, null, null, null, null, 
                                    null, null, null, null, null, null, null, null, null, null, null);
    }

    public static List<CEC_Case_Market_Mapping__c> createMasterCaseMarketMapping() {
        List<CEC_Case_Market_Mapping__c> caseMarketMappingList = new List<CEC_Case_Market_Mapping__c>();
        List<mdm_Geography__c> georgraphyList = new List<mdm_Geography__c>();

        mdm_Geography__c  geographyUK = new mdm_Geography__c(name='United Kingdom');
        georgraphyList.add(geographyUK);
        mdm_Geography__c  geographyIndia = new mdm_Geography__c(name='India');
        georgraphyList.add(geographyIndia);
        mdm_Geography__c  geographyUS = new mdm_Geography__c(name='United States');
        georgraphyList.add(geographyUS);
        mdm_Geography__c  geographyBrazil = new mdm_Geography__c(name='Brazil');
        georgraphyList.add(geographyBrazil);
        insert georgraphyList;

        CEC_Case_Market_Mapping__c cmmUK = new CEC_Case_Market_Mapping__c();
        cmmUK.Name = 'United Kingdom';
        cmmUK.Cheque_Decimals__c = 'Display as text';
        cmmUK.Market__c = 'United Kingdom';
        cmmUK.Country__c = geographyUK.Id;
        caseMarketMappingList.add(cmmUK);

        CEC_Case_Market_Mapping__c cmmIndia = new CEC_Case_Market_Mapping__c();
        cmmIndia.Name = 'India';
        cmmIndia.Market__c = 'India';
        cmmIndia.Country__c = geographyIndia.Id;
        caseMarketMappingList.add(cmmIndia);

        CEC_Case_Market_Mapping__c cmmNA = new CEC_Case_Market_Mapping__c();
        cmmNA.Name = 'North America';
        cmmNA.Market__c = 'North America';
        cmmNA.Country__c = geographyUS.Id;
        caseMarketMappingList.add(cmmNA);
        
        CEC_Case_Market_Mapping__c cmmBrazil = new CEC_Case_Market_Mapping__c();
        cmmNA.Name = 'Brazil';
        cmmNA.Market__c = 'Brazil';
        cmmNA.Country__c = geographyBrazil.Id;
        caseMarketMappingList.add(cmmBrazil);

        insert caseMarketMappingList;
        return caseMarketMappingList;
    }

    public static List<cec_Fulfilment__c> createFulfilment( Integer noOfFulfilments, String country,
                                                            Id enclosureId1, Id enclosureId2,
                                                            Id enclosureId3, Id enclosureId4,
                                                            Id enclosureId5, Id caseId ) {
        List<cec_Fulfilment__c> testFulfilmentList = new List<cec_Fulfilment__c>();
        for(Integer i = 1; i <= noOfFulfilments; i++){
            cec_Fulfilment__c testFulfilment = new cec_Fulfilment__c();
            testFulfilment.Country__c = country;
            testFulfilment.Enclosure1__c = enclosureId1;
            testFulfilment.Enclosure2__c = enclosureId2;
            testFulfilment.Enclosure3__c = enclosureId3;
            testFulfilment.Enclosure4__c = enclosureId4;
            testFulfilment.Enclosure5__c = enclosureId5;
            testFulfilment.Case__c = caseId;
            //testFulfilment.Account_Card_Number__c = '11223344';
            
            testFulfilmentList.add(testFulfilment);
        }
        return testFulfilmentList;
    }

    public static List<CEC_ChequeBook_Detail__c> createChequeBookDetail(Integer noOfChequeBookDetails,
                                                        String chequeBook, String chequeCurrency, String currencyText,
                                                        String currencyDecimalText, Integer incrementNumber,
                                                        Integer lastChequeNumber, Integer maxChequeNumber,
                                                        Id countryId, Id prodCategoryId ) {
        List<CEC_ChequeBook_Detail__c> testchequeBookDetailList = new List<CEC_ChequeBook_Detail__c>();
        for(Integer i = 1; i <= noOfChequeBookDetails; i++){
            CEC_ChequeBook_Detail__c testchequeBookDetail = new CEC_ChequeBook_Detail__c();
            testchequeBookDetail.Cheque_Book__c = chequeBook;
            testchequeBookDetail.Increment_Number__c = incrementNumber;
            testchequeBookDetail.Currency__c = chequeCurrency;
            testchequeBookDetail.Currency_Text__c = currencyText;
            testchequeBookDetail.Currency_Decimal_Text__c = currencyDecimalText;
            testchequeBookDetail.Last_Cheque_Number__c = lastChequeNumber;
            testchequeBookDetail.Country__c = countryId;
            testchequeBookDetail.Max_Cheque_Number__c = maxChequeNumber;
            testchequeBookDetail.Active__c = true;
            testchequeBookDetail.Product_Category__c = prodCategoryId;
            testchequeBookDetailList.add(testchequeBookDetail);
        }
        return testchequeBookDetailList;
    }

    public static List<cec_Enclosure__c> createEnclosure(Integer noOfEnclosures, String name, String brandName,
                                                        String countryName, String enclosureCode, String type,
                                                        Integer itemValue, Integer maxQty) {
        List<cec_Enclosure__c> enclosureList = new List<cec_Enclosure__c>();
        for(Integer i = 1; i <= noOfEnclosures; i++){
            cec_Enclosure__c enclosure = new cec_Enclosure__c();
            enclosure.Name = name + String.valueOf(i);
            enclosure.Active__c = true;
            enclosure.Country__c = countryName;
            enclosure.Brand__c = brandName;
            enclosure.Enclosure_Code__c = enclosureCode;
            enclosure.Type__c = type;
            enclosure.ItemValue__c = itemValue;
            enclosure.MaximumQty__c = maxQty;
            enclosureList.add(enclosure);
        }
        return enclosureList;
    }
    
    public static List<CEC_Debit_Card_Detail__c> createDebitCardDetail(Integer noOfDebitCardDetail,
                                                                String debitCardNumber, String Status,
                                                                Id accountId , Id geographyId) {
        List<CEC_Debit_Card_Detail__c> testDebitCardDetailList = new List<CEC_Debit_Card_Detail__c>();
        
        
        for(Integer i = 1; i <= noOfDebitCardDetail; i++){
            CEC_Debit_Card_Detail__c testDebitCardDetail = new CEC_Debit_Card_Detail__c();
            
            testDebitCardDetail.name = debitCardNumber;
            testDebitCardDetail.Expiry_Date__c = DateTime.Now().addDays(5);
            testDebitCardDetail.Active__c = true;
            testDebitCardDetail.Status__c = Status;
            testDebitCardDetail.Country__c = geographyId;
            testDebitCardDetail.Account_Id__c = accountId;
            testDebitCardDetail.Card_Value__c = 125;
            testDebitCardDetailList.add(testDebitCardDetail); 
        }
        return testDebitCardDetailList; 
    }    
    
    public static List<CEC_E_Voucher_Details__c> createEvoucherDetail(Integer noOfVoucher,
                                                                String eVoucherNumber, String Status,
                                                                Id accountId , Id geographyId) {
        List<CEC_E_Voucher_Details__c> testEvoucherDetailList = new List<CEC_E_Voucher_Details__c>();
        
        
        
        for(Integer i = 1; i <= noOfVoucher; i++){
            CEC_E_Voucher_Details__c testEvoucherDetail = new CEC_E_Voucher_Details__c();
            
            testEvoucherDetail.name = eVoucherNumber;
            testEvoucherDetail.Expiry_Date__c = DateTime.Now().addDays(5);
            testEvoucherDetail.Active__c = true;
            testEvoucherDetail.Status__c = Status;
            testEvoucherDetail.Country__c = geographyId;
            testEvoucherDetail.Account_Id__c = accountId;
            testEvoucherDetail.Voucher_Value__c = 125;
            testEvoucherDetailList.add(testEvoucherDetail); 
        }
        return testEvoucherDetailList; 
    }    
    
   public static Group createQueue(String name, String type, List<String> sobjtypes,Id userId){
   
           Group testGroup = new Group(Name=name, Type=type);
           insert testGroup;
           
           List<QueuesObject> queueObjs = new List<QueuesObject>();
           if(!sobjtypes.isEmpty() && userId != null){
                System.runAs(new User(Id=userId))
                {   
                    for(String sobj : sobjtypes){
                       queueObjs.add(new QueueSObject(QueueID = testGroup.id, SObjectType =sobj));
                    }
                    
                    insert queueObjs;
                }
           
           } 
           
          return testGroup ;  
         
    }
    
    public static List<mdm_Geography__c> createGeographies(List<String> cntryNames){
         List<mdm_Geography__c> georgraphies = new List<mdm_Geography__c>();
          for(String cntryName : cntryNames){
            georgraphies.add(new mdm_Geography__c(name=cntryName,ISO_Country_Dependency_Medium_Name__c = cntryName ));
        }
        
        insert georgraphies;
        return georgraphies;
    }
    
    public static List<cec_Store__c> createStore(List<String> cntryNames){

        List<cec_Store__c> stores = new List<cec_Store__c>();
        List<mdm_Geography__c> georgraphies = new List<mdm_Geography__c>();
        
          for(String cntryName : cntryNames){
            georgraphies.add(new mdm_Geography__c(name=cntryName,ISO_Country_Dependency_Medium_Name__c = cntryName ));
        }
        
        insert georgraphies;
        
        for(mdm_Geography__c geoGrphy: georgraphies){
            stores.add(new cec_Store__c(Name = geoGrphy.name, Country__c = geoGrphy.id ));
        }
        
        insert stores;
        
        return stores;
    }
    
     public static List<CEC_Case_Market_Mapping__c> createCaseMarketMapping(string country, Integer noOfrec) {
        List<CEC_Case_Market_Mapping__c> caseMarketMappingList = new List<CEC_Case_Market_Mapping__c>();
        List<mdm_Geography__c> georgraphyList = new List<mdm_Geography__c>();
         for(Integer recCount=0; recCount <noOfrec; recCount++){ 
             	georgraphyList.add(new mdm_Geography__c(name=country,ISO_Country_Dependency_Medium_Name__c = country));
         	
         }
         
        
        insert georgraphyList;
		 
             for(mdm_Geography__c geography : georgraphyList){
                    caseMarketMappingList.add(new CEC_Case_Market_Mapping__c(Name= geography.name,Cheque_Decimals__c = 'Display as text',
                                                                            Market__c= geography.name, Country__c= geography.id
                                                                            ));             
             }
        
        insert caseMarketMappingList;
        return caseMarketMappingList;
    }
}