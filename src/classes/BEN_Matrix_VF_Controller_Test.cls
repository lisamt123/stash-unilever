/**********************************************************************
Name: BEN_Matrix_VF_Controller_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: Test class for Benchmarking Matrix Visualforce page COntroller clazz -------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
V1.0       mahesh     10/01/2017     INITIAL DEVELOPMENT CSR:
***********************************************************************/

@IsTest
public without sharing class BEN_Matrix_VF_Controller_Test {
    
    Static PageReference pageRef;
    static User testUser;
    static BEN_Matrix_VF_controller controller;
    static BEN_Category_Master__c CategoryMaster;
    static List<BEN_Category_Details__c> insertedCatDetails;
    
    static {
        controller = new BEN_Matrix_VF_controller();
        ID adminProfileID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].ID;
        List<User> user = [Select Name, email, username from User where username = 'firstuserdb@test.com'];
        
        if(checkEmpty(user)){
            testUser = new User(username='firstuserdb100@test.com',
                                alias = 'fu',
                                email ='firstuser100@test.com',
                                emailencodingkey = 'UTF-8',
                                lastname = 'fuln',
                                CommunityNickname = 'fucn',
                                languagelocalekey = 'en_US',
                                localesidkey = 'en_US',                                            
                                profileid = adminProfileID,
                                timezonesidkey = 'Europe/Berlin',
                                country = 'India'
                               );
            insert testUser;
        }else
            testUser = user.get(0);
        System.debug('Test User  : '+ testUser);
        
        List<BEN_Category_Master__c> catMaster =  [select name from BEN_Category_Master__c where name='Beverages'];
        if(checkEmpty(catMaster)){
            CategoryMaster=new BEN_Category_Master__c(Name='Beverages'); 
            insert CategoryMaster;
        }else
            CategoryMaster = catMaster.get(0);
        System.debug('Test BEN_Category_Master__c  : '+ CategoryMaster);
        
        Group testGroup = new Group(Name='BEN_Beverages123', Type='Queue');
        insert testGroup;
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
            GroupMember GM = new GroupMember();
            GM.GroupId = testGroup.Id;
            GM.UserOrGroupId = UserInfo.getUserId();
            insert gm;
        }
        
        BEN_CategoryDetails__c bcd = new BEN_CategoryDetails__c();
        bcd.Name = 'Beverages123';
        bcd.QueueId__c = testGroup.Id;
        insert bcd;
        
                
         Group testGroup2 = new Group(Name='BEN_GPL', Type='Queue');
        insert testGroup2;
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            QueuesObject testQueue2 = new QueueSObject(QueueID = testGroup2.id, SObjectType = 'Case');
            insert testQueue2;
            GroupMember GM = new GroupMember();
            GM.GroupId = testGroup2.Id;
            GM.UserOrGroupId = UserInfo.getUserId();
            insert gm;
        }
        
        BEN_CategoryDetails__c bcd2 = new BEN_CategoryDetails__c();
        bcd2.Name = 'Beveragesabcd';
        bcd2.QueueId__c = testGroup.Id;
        insert bcd2;
        
        init();
    }
    
    public static boolean checkEmpty(List<sObject> objs){
        
        if(objs == null){
            return true;
        }else if(objs.size()==0){
            return true;
        }else
            return false;
    }
    
    private static void init() {
        
        BEN_Category_CUC_Codes__c ccc = new BEN_Category_CUC_Codes__c();
        ccc.Name = 'Test';
        insert ccc;
        
        
        
        insertedCatDetails = new List<BEN_Category_Details__c>();
        for(Integer i = 0; i< 10 ; i++){
            
        BEN_Category_Details__c categorydetails = new BEN_Category_Details__c();
        categorydetails.Product_Category__c = CategoryMaster.Id;
        categorydetails.pkl_Region__c='Europe' ;
        categorydetails.pkl_Brand__c='Lipton Yellow Label' ;
        categorydetails.txt_Title__c='Test123' ;
        categorydetails.pkl_Year__c='2016' ;
        categorydetails.pkl_Quarter__c='Q4' ;
        categorydetails.pkl_Logic__c='PARITY on OO & KA' ;
        categorydetails.pkl_Key_Attributes__c='Parity' ;
        //categorydetails.pkl_OVERALL_SCORE__c='Parity' ;
        categorydetails.lkp_CUC_Codes__c=ccc.Id;
        categorydetails.pkl_Product_Format__c='Flavoured & Speciality' ;
        categorydetails.pkl_Product__c='Beceda' ;
        categorydetails.pkl_Country__c='Germany' ;
        categorydetails.pkl_Status__c='Approved' ;
        categorydetails.pkl_Key_Attribute_1_Appraisal__c = 'Parity';
        categorydetails.pkl_Key_Attribute_2_Consumer_Test__c = 'Parity';
        categorydetails.pkl_Benchmark__c = 'Barrys Gold';
        categorydetails.pkl_Blind_OO__c = 'Parity';
        categorydetails.txt_Unilever_Formula__c = 'testing';
        categorydetails.txt_Agency_Name__c = 'samsung';
        categorydetails.txt_Agency_Job_Number__c = '12345';  
        insertedCatDetails.add(categorydetails);
        }
        
         for(Integer i = 0; i< 10 ; i++){
            
        BEN_Category_Details__c categorydetails = new BEN_Category_Details__c();
        categorydetails.Product_Category__c = CategoryMaster.Id;
        categorydetails.pkl_Region__c='North America' ;
        categorydetails.pkl_Brand__c='Lipton Yellow Label' ;
        categorydetails.txt_Title__c='Test200' ;
        categorydetails.pkl_Year__c='2017' ;
        categorydetails.pkl_Quarter__c='Q1' ;
        categorydetails.pkl_Logic__c='WIN on OO & KA' ;
        categorydetails.pkl_Key_Attributes__c='Loss' ;
        //categorydetails.pkl_OVERALL_SCORE__c='Parity' ;
        categorydetails.lkp_CUC_Codes__c=ccc.Id;
        categorydetails.pkl_Product_Format__c='Flavoured & Speciality' ;
        categorydetails.pkl_Product__c='Beceda' ;
        categorydetails.pkl_Country__c='USA' ;
        categorydetails.pkl_Status__c='Approved' ;
        categorydetails.pkl_Key_Attribute_1_Appraisal__c = 'Loss';
        categorydetails.pkl_Key_Attribute_2_Consumer_Test__c = 'Loss';
        categorydetails.pkl_Benchmark__c = 'Barrys Gold';
        categorydetails.pkl_Blind_OO__c = 'Loss';
        categorydetails.txt_Unilever_Formula__c = 'testing';
        categorydetails.txt_Agency_Name__c = 'samsung';
        categorydetails.txt_Agency_Job_Number__c = '12345';  
        insertedCatDetails.add(categorydetails);
        }
        
         for(Integer i = 0; i< 10 ; i++){
            
        BEN_Category_Details__c categorydetails = new BEN_Category_Details__c();
        categorydetails.Product_Category__c = CategoryMaster.Id;
        categorydetails.pkl_Region__c='South Asia' ;
        categorydetails.pkl_Brand__c='Lipton Yellow Label' ;
        categorydetails.txt_Title__c='Test300' ;
        categorydetails.pkl_Year__c='2017' ;
        categorydetails.pkl_Quarter__c='Q2' ;
        categorydetails.pkl_Logic__c='WIN on OO & KA' ;
        categorydetails.pkl_Key_Attributes__c='Win' ;
        //categorydetails.pkl_OVERALL_SCORE__c='Parity' ;
        categorydetails.lkp_CUC_Codes__c=ccc.Id;
        categorydetails.pkl_Product_Format__c='Flavoured & Speciality' ;
        categorydetails.pkl_Product__c='Beceda' ;
        categorydetails.pkl_Country__c='India' ;
        categorydetails.pkl_Status__c='Approved' ;
        categorydetails.pkl_Key_Attribute_1_Appraisal__c = 'Win';
        categorydetails.pkl_Key_Attribute_2_Consumer_Test__c = 'Win';
        categorydetails.pkl_Benchmark__c = 'Barrys Gold';
        categorydetails.pkl_Blind_OO__c = 'Win';
        categorydetails.txt_Unilever_Formula__c = 'testing';
        categorydetails.txt_Agency_Name__c = 'samsung';
        categorydetails.txt_Agency_Job_Number__c = '12345';  
        insertedCatDetails.add(categorydetails);
        }
        List<Database.SaveResult> srs = Database.insert(insertedCatDetails);
        for(Database.SaveResult sr: srs){
        if (sr.isSuccess()) {
            System.debug('Successfully inserted account. record ID: ' + sr.getId());
        }
        else {           
            for(Database.Error err : sr.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Account fields that affected this error: ' + err.getFields());
            }
            
         }
            
        }
        List<BEN_Category_Details__c> totalInsertedRecords = [Select ID, pkl_Status__c  from BEN_Category_Details__c];
        System.debug(' Total inserted records  : '+ totalInsertedRecords.size() + ' recods are   : ' + totalInsertedRecords);
    } 
    
    static testmethod void testYearValues(){
        Schema.DescribeFieldResult dfr =  BEN_Category_Details__c.pkl_Year__c.getDescribe();
        List<Schema.PicklistEntry> ple = dfr.getPicklistValues();
        integer fromCount = 0;
        integer toCount = 0;
        for( Schema.PicklistEntry f : ple)
        {
            for( SelectOption so  : controller.fromYear ){
                if(f.getValue() == so.getValue())
                    fromCount++;
            }
            
            for( SelectOption so  : controller.toYear ){
                if(f.getValue() == so.getValue())
                    toCount++;
            }
        }  
        System.assertEquals(fromCount, ple.size());
        System.assertEquals(fromCount, controller.fromYear.size());
        
        System.assertEquals(toCount, ple.size());
        System.assertEquals(toCount, controller.toYear.size());
    }
    
    
    static testmethod void testQuarterValues(){
        Schema.DescribeFieldResult dfr =  BEN_Category_Details__c.pkl_Quarter__c.getDescribe();
        List<Schema.PicklistEntry> ple = dfr.getPicklistValues();
        integer fromCount = 0;
        integer toCount = 0;
        for( Schema.PicklistEntry f : ple)
        {
            for( SelectOption so  : controller.fromQuarter ){
                if(f.getValue() == so.getValue())
                    fromCount++;
            }
            for( SelectOption so  : controller.toQuarter ){
                if(f.getValue() == so.getValue())
                    toCount++;
            }
        }  
        
        System.assertEquals(fromCount, ple.size());
        System.assertEquals(fromCount, controller.fromQuarter.size());
        
        System.assertEquals(toCount, ple.size());
        System.assertEquals(toCount, controller.toQuarter.size());
    }
    
    
    static testmethod void testProdcutCategoriesList(){
        
        List<BEN_Category_Master__c> pcs = [Select Name from BEN_Category_Master__c];
        BEN_Category_Master__c allCategory = new BEN_Category_Master__c(name= 'All Categories');
        pcs.add(allCategory);
        System.debug('testProdcutCategoriesList pcs : '+ pcs);
        integer categoriesCount = 0;
        for(BEN_Category_Master__c cat:pcs){
            if(cat.Name.contains( 'Deleted'))
                Continue;
            for(SelectOption so: controller.productCategory){
                if(cat.Name == so.getValue())
                    categoriesCount ++;
            }
        }
        System.assertEquals(categoriesCount, pcs.size()-1);
        System.assertEquals(categoriesCount, controller.productCategory.size());
    }
    
    
    static testmethod void testMatrixReport(){
        
        Test.startTest();
        controller = new BEN_Matrix_VF_controller();
        
        List<BEN_Category_Details__c> listToUpdate = new List<BEN_Category_Details__c>();
        for(Integer j=0 ; j<10 ; j++){
            BEN_Category_Details__c cd = insertedCatDetails.get(j);
        cd.In_Approval__c=true;
        cd.pkl_Status__c= 'Approved';
        cd.bln_Flag_for_Retest__c=true;  
            listToUpdate.add(cd);
        }
        
        Database.update(listToUpdate, true);
        
        
        System.debug(' Total inserted records After Update records  : '+ listToUpdate.size() + ' recods are   : ' + listToUpdate);
        System.debug(' Total inserted records After Update records  Quried : '+ [Select Id, pkl_Status__c from BEN_Category_Details__c Where Id IN :listToUpdate]);
        
        Approval.ProcessWorkitemRequest[] prWkItems = New Approval.ProcessWorkItemRequest[]{};
            //Reject the record
            ProcessInstance[] pi = [Select ID, Status, TargetObject.Name, 
                (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
                (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance 
                Where TargetObjectID IN :listToUpdate AND Status = 'Pending'];
               
            System.debug('TOtal ProcessInstance  with Status = pending  : '+ pi.size()+ ' records ' +  pi);
                   
            for(ProcessInstance instance : pi){
      
                for(ProcessInstanceWorkItem workItem : instance.WorkItems){
                  
                    Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();
                    
                    prWkItem.setWorkItemID(workItem.id);
                    prWkItem.setComments('Request Canceled by User: ' + userInfo.getName());
                    prWkItem.setAction('Approve');
                    prWkItems.add(prWkItem);
                  
                }
            }          
            
            if(!prWkItems.isEmpty()){
                
                Approval.ProcessResult[] appResult = Approval.process(prWkItems);
                
                System.debug('TOtal Approved records  : '+ appResult.size()+ ' records ' +  appResult);
            }
        
        
        
        //pageRef = Page.BEN_Matrix3cross3_Report;    
        //Test.setCurrentPage(pageRef);
        controller.fromYearVal = '2009';
        controller.fromQuarterVal = 'Q1';
        controller.toYearVal = '2019';
        controller.toQuarterVal = 'Q4';
        controller.productCat = '[All Categories]';
        
        controller.getReport();
        System.debug('controller.output values  : ' + controller.parityParity_11 + controller.winLoss_00 + controller.winParity_01 +controller.winWin_02 +controller.parityLoss_10 +controller.parityWin_12 +controller.lossLoss_20 +controller.lossParity_21 + controller.lossWin_22);
        System.assert(controller.parityParity_11 == '100.0%');
        Test.stopTest();
    }
    
    static testmethod void testMatrixReportApproverUser(){
        
        Test.startTest();
        System.runAs(testUser){
            controller = new BEN_Matrix_VF_controller();
            //pageRef = Page.BEN_Matrix3cross3_Report;    
            //Test.setCurrentPage(pageRef);
            controller.fromYearVal = '2009';
            controller.fromQuarterVal = 'Q1';
            controller.toYearVal = '2019';
            controller.toQuarterVal = 'Q4';
            controller.productCat = '[All Categories]';
            
            controller.getReport();
            System.debug(' testMatrixReportApproverUser : controller.output values  : ' + controller.parityParity_11 + controller.winLoss_00 + controller.winParity_01 +controller.winWin_02 +controller.parityLoss_10 +controller.parityWin_12 +controller.lossLoss_20 +controller.lossParity_21 + controller.lossWin_22);
            System.assert(controller.parityParity_11 == '0.0%');
        }
        Test.stopTest();
    }
    
    static testmethod void testMatrixReportPrint(){
        
        Test.startTest();
        pageRef = Page.BEN_Matrix3cross3_Report;    
        Test.setCurrentPage(pageRef);
        controller.fromYearVal = '2009';
        controller.fromQuarterVal = 'Q1';
        controller.toYearVal = '2019';
        controller.toQuarterVal = 'Q4';
        controller.productCat = '[Beverages]';
        controller.getReport();
        System.debug('controller.parityParity_11  : ' + controller.parityParity_11);
        System.assert(controller.parityParity_11 == '0.0%');
        PageReference pr = controller.redirectToPDF();
        String pdfUrl = pr.getUrl();
        System.debug('URL  : '+pdfUrl);
        System.assert(pdfUrl.contains('Beverages') && pdfUrl.contains('2009') && pdfUrl.contains('Q1') && pdfUrl.contains('2019') && pdfUrl.contains('Q4') );
        Test.stopTest();
        
    }
    
    static testmethod void testMatrixReportVFControler(){
        
        PageReference printPageRef = Page.BEN_Matrix_Report_Print_VF;
        Map<String, String> params = printPageRef.getParameters();
        params.put('fromYearVal', '2009');
        params.put('fromQuarterVal', 'Q1');
        params.put('toYearVal', '2027');
        params.put('toQuarterVal', 'Q4');
        params.put('productCat', 'Beverages');
        params.put('totalRecCount', String.valueOf(11));
        params.put('winLoss_00', String.valueOf(2));
        params.put('winParity_01', String.valueOf(3));
        params.put('winWin_02', String.valueOf(4));
        params.put('parityLoss_10', String.valueOf(5));
        params.put('parityParity_11', String.valueOf(6));
        params.put('parityWin_12',String.valueOf(7 ));
        params.put('lossLoss_20', String.valueOf(8));
        params.put('lossParity_21',String.valueOf(9));
        params.put('lossWin_22', String.valueOf(10));
        printPageRef.setRedirect(true);
        Test.setCurrentPage(printPageRef);
        BEN_Matrix_Print_VF_Controller printController = new BEN_Matrix_Print_VF_Controller();
        System.assert(printController.totalRecCount.equals(String.valueOf(11)));
        System.assert(printController.lossWin_22.equals(String.valueOf(10)));   
        System.assert(printController.lossParity_21.equals(String.valueOf(9))); 
        System.assert(printController.lossLoss_20.equals(String.valueOf(8))); 
        System.assert(printController.parityWin_12.equals(String.valueOf(7))); 
        System.assert(printController.parityParity_11.equals(String.valueOf(6))); 
        System.assert(printController.parityLoss_10.equals(String.valueOf(5))); 
        System.assert(printController.winWin_02.equals(String.valueOf(4))); 
        System.assert(printController.winParity_01.equals(String.valueOf(3))); 
        System.assert(printController.winLoss_00.equals(String.valueOf(2))); 
        
        System.assert(printController.fromYearVal.equals('2009')); 
        System.assert(printController.fromQuarterVal.equals('Q1'));  
        System.assert(printController.toYearVal.equals('2027')); 
        System.assert(printController.toQuarterVal.equals('Q4')); 
        System.assert(printController.productCat.equals('Beverages')); 
    }
    
    static testmethod void testMatrixReportNegative(){
        
        Test.startTest();
        pageRef = Page.BEN_Matrix3cross3_Report;    
        Test.setCurrentPage(pageRef);
        controller = new BEN_Matrix_VF_controller();
        controller.fromYearVal = '2010';
        controller.fromQuarterVal = 'Q4';
        controller.toYearVal = '2009';
        controller.toQuarterVal = 'Q1';
        controller.productCat = '[Beverages]';
        controller.getReport();
        System.assert(controller.parityParity_11 == '0.0%');
        Test.stopTest();
    }
    
    static testmethod void testMatrixReportNegative2(){
        
        Test.startTest();
        pageRef = Page.BEN_Matrix3cross3_Report;    
        Test.setCurrentPage(pageRef);
        controller = new BEN_Matrix_VF_controller();
        controller.fromYearVal = '2009';
        controller.fromQuarterVal = 'Q4';
        controller.toYearVal = '2009';
        controller.toQuarterVal = 'Q1';
        controller.productCat = '[Beverages]';
        controller.getReport();
        System.assert(controller.parityParity_11 == '0.0%');
        Test.stopTest();
    }
    
    private static void destroy(){
        // delete testuser;
        //  delete CategoryMaster;
    }
    
}