@IsTest
public class BEN_KPIProgressReport_Test {
    
    
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
            CategoryMaster=new BEN_Category_Master__c(Name='Beverages', pkl_Super_Category__c= 'Home Care');  
            insert CategoryMaster;
        }else
            CategoryMaster = catMaster.get(0);
        System.debug('Test BEN_Category_Master__c  : '+ CategoryMaster);
        List<Group> beverageGrpMap = [SELECT Id,DeveloperName,(SELECT Id, UserOrGroupId FROM GroupMembers) FROM Group Where Type='Queue' and Name like 'BEN_%Beverages%'];
        List<Group> GPLgrpMap = [SELECT Id,DeveloperName,(SELECT Id, UserOrGroupId FROM GroupMembers) FROM Group Where Type='Queue' and Name like 'BEN_%GPL%'];
        
        System.debug('beverageGrpMap & GPLgrpMap  : ' +beverageGrpMap +GPLgrpMap );
        Group beveragesGroup = beverageGrpMap.get(0);
        Group GPLGroup = GPLgrpMap.get(0);
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            GroupMember beveragesGM = new GroupMember();
            beveragesGM.GroupId = beveragesGroup.Id;
            beveragesGM.UserOrGroupId = testUser.Id;
            insert beveragesGM;
            
            GroupMember GPLGM = new GroupMember();
            GPLGM.GroupId = GPLGroup.Id;
            GPLGM.UserOrGroupId = UserInfo.getUserId();
            insert GPLGM;
        }
        
        BEN_CategoryDetails__c bcd2 = new BEN_CategoryDetails__c();
        bcd2.Name = 'Beverages';
        bcd2.QueueId__c = beveragesGroup.Id;
        insert bcd2;
        
        System.debug('Beverages User ID : '+testUser.id);
        System.debug('Admin USerID  : '+UserInfo.getUserId());
        
        
        System.debug('Query to find Beveragesuser aadded to Queue  : '+[SELECT Id, UserOrGroupId FROM GroupMember Where GroupID = :beveragesGroup.ID]);
        System.debug('Query to find GPLuser aadded to Queue  : '+[SELECT Id, UserOrGroupId FROM GroupMember Where GroupID = :GPLGroup.Id]);
        
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
        
        /*BEN_CU_GTIN__c ccc = new BEN_CU_GTIN__c();
        ccc.Name = 'Test';
        insert ccc;*/
                
        BEN_Benchmark__c benchamrking = new BEN_Benchmark__c();
        benchamrking.CurrencyIsoCode = 'EUR';
        benchamrking.Name = 'Barrys Gold';
        insert benchamrking;
        
        insertedCatDetails = new List<BEN_Category_Details__c>();
        for(Integer i = 0; i< 10 ; i++){
            
            BEN_Category_Details__c categorydetails = new BEN_Category_Details__c();
            categorydetails.Product_Category__c = CategoryMaster.Id;
            categorydetails.pkl_Category_Master__c= 'Beverages';
            categorydetails.pkl_Region__c='Europe' ;
            categorydetails.pkl_Brand__c='Lipton Yellow Label' ;
            categorydetails.txt_Title__c='Test123' ;
            categorydetails.pkl_Year__c='2016' ;
            categorydetails.pkl_Quarter__c='Q4' ;
            categorydetails.pkl_Logic__c='PARITY on OO & KA' ;
            categorydetails.pkl_Key_Attributes__c='Parity' ;
            //categorydetails.pkl_OVERALL_SCORE__c='Parity' ;
            categorydetails.txt_CUC_Code__c='CUC Code';
            categorydetails.pkl_Product_Format__c='Flavoured & Speciality' ;
            categorydetails.pkl_Product__c='Beceda' ;
            categorydetails.pkl_Country__c='Germany' ;
            categorydetails.pkl_Status__c='Approved' ;
            categorydetails.pkl_Key_Attribute_1_Appraisal__c = 'Parity';
            categorydetails.pkl_Key_Attribute_2_Consumer_Test__c = 'Parity';
            categorydetails.lkp_Benchmark__c = benchamrking.Id;
            categorydetails.pkl_Blind_OO__c = 'Parity';
            categorydetails.txt_Unilever_Formula__c = 'testing';
            categorydetails.txt_Agency_Name__c = 'samsung';
            categorydetails.txt_Agency_Job_Number__c = '12345';  
            insertedCatDetails.add(categorydetails);
        }
        
        for(Integer i = 0; i< 10 ; i++){
            
            BEN_Category_Details__c categorydetails = new BEN_Category_Details__c();
            categorydetails.Product_Category__c = CategoryMaster.Id;
            categorydetails.pkl_Category_Master__c= 'Beverages';
            categorydetails.pkl_Region__c='North America' ;
            categorydetails.pkl_Brand__c='Lipton Yellow Label' ;
            categorydetails.txt_Title__c='Test200' ;
            categorydetails.pkl_Year__c='2017' ;
            categorydetails.pkl_Quarter__c='Q1' ;
            categorydetails.pkl_Logic__c='WIN on OO & KA' ;
            categorydetails.pkl_Key_Attributes__c='Loss' ;
            //categorydetails.pkl_OVERALL_SCORE__c='Parity' ;
            categorydetails.txt_CUC_Code__c='CUC Code';
            categorydetails.pkl_Product_Format__c='Flavoured & Speciality' ;
            categorydetails.pkl_Product__c='Beceda' ;
            categorydetails.pkl_Country__c='USA' ;
            categorydetails.pkl_Status__c='Approved' ;
            categorydetails.pkl_Key_Attribute_1_Appraisal__c = 'Loss';
            categorydetails.pkl_Key_Attribute_2_Consumer_Test__c = 'Loss';
            categorydetails.lkp_Benchmark__c = benchamrking.Id;
            categorydetails.pkl_Blind_OO__c = 'Loss';
            categorydetails.txt_Unilever_Formula__c = 'testing';
            categorydetails.txt_Agency_Name__c = 'samsung';
            categorydetails.txt_Agency_Job_Number__c = '12345';  
            insertedCatDetails.add(categorydetails);
        }
        
        for(Integer i = 0; i< 10 ; i++){
            
            BEN_Category_Details__c categorydetails = new BEN_Category_Details__c();
            categorydetails.Product_Category__c = CategoryMaster.Id;
            categorydetails.pkl_Category_Master__c= 'Beverages';
            categorydetails.pkl_Region__c='South Asia' ;
            categorydetails.pkl_Brand__c='Lipton Yellow Label' ;
            categorydetails.txt_Title__c='Test300' ;
            categorydetails.pkl_Year__c='2017' ;
            categorydetails.pkl_Quarter__c='Q2' ;
            categorydetails.pkl_Logic__c='WIN on OO & KA' ;
            categorydetails.pkl_Key_Attributes__c='Win' ;
            //categorydetails.pkl_OVERALL_SCORE__c='Parity' ;
            categorydetails.txt_CUC_Code__c='CUC Code';
            categorydetails.pkl_Product_Format__c='Flavoured & Speciality' ;
            categorydetails.pkl_Product__c='Beceda' ;
            categorydetails.pkl_Country__c='India' ;
            categorydetails.pkl_Status__c='Approved' ;
            categorydetails.pkl_Key_Attribute_1_Appraisal__c = 'Win';
            categorydetails.pkl_Key_Attribute_2_Consumer_Test__c = 'Win';
            categorydetails.lkp_Benchmark__c = benchamrking.Id;
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
    
    
    public static String getYearQuarter() {
        String temp ='[';
        List<BEN_Category_Details__c> YearandQuarter = [select fml_Year_Quarter__c from BEN_Category_Details__c ORDER BY fml_Year_Quarter__c];
        for(BEN_Category_Details__c cDetails: YearandQuarter)  {
            temp = temp+ cDetails.fml_Year_Quarter__c+', ';
        }
        temp = temp.substring(0,temp.lastIndexOf(','));
        temp = temp+']';
        system.debug('temp  : '+ temp);
        return temp;
    }
    
    
    public testmethod static void testBENKPIProgressHandlerMethods(){
        
         BEN_Category_Details__c cd = insertedCatDetails.get(0);
        cd.In_Approval__c=true;
        cd.pkl_Status__c= 'Approved';
        Database.update(cd, true);
        
        BEN_KPIProgressReprtHandler handler= new BEN_KPIProgressReprtHandler();
        List<SelectOption> selectOptions = handler.getYearQuarter();
        
        List<BEN_Category_Details__c> YearandQuarter = [select fml_Year_Quarter__c from BEN_Category_Details__c ORDER BY fml_Year_Quarter__c];
        if(selectOptions != null && YearandQuarter!= null){
            SelectOption firstOption = SelectOptions.get(0);
            system.assertEquals(YearandQuarter.get(0).fml_Year_Quarter__c,firstOption.getValue() );
        }
        
        handler.YearQuarterSelected ='TestTrail';
        PageReference page = handler.getReport();
        PageReference pdfPage = handler.getdownloadPage();
        Map<String, String> params = pdfPage.getParameters();
        System.assert(params.get('YearQuarterSelected')!=null);
        System.assert(params.get('renderAsVar')!=null);
        
         BEN_KPIProgressReprtHandler handlerTest2= new BEN_KPIProgressReprtHandler();
        PageReference pagetest2 = handlerTest2.getReport();
        PageReference pdfPageTest2 = handlerTest2.getdownloadPage();
        Map<String, String> paramsTest2 = pdfPageTest2.getParameters();
        System.assert(paramsTest2.get('YearQuarterSelected')==null);
        System.assert(paramsTest2.get('renderAsVar')!=null);
    }
    
    public static testmethod void testBENKPIProgressReportGeneratorMethods(){
        
        BEN_Category_Details__c cd = insertedCatDetails.get(1);
        cd.In_Approval__c=true;
        cd.pkl_Status__c= 'Approved';
        Database.update(cd, true);
        
        PageReference printPageRef = Page.BEN_KPIProgressReport_Generator;
        Map<String, String> params = printPageRef.getParameters();
        params.put('YearQuarterSelected', getYearQuarter());
        printPageRef.setRedirect(true);
        Test.setCurrentPage(printPageRef);
        BEN_KPIProgress_Generator_Controller genController = new BEN_KPIProgress_Generator_Controller();
        BEN_KPIProgress_Generator_Controller.getKPIProgressReport();
        BEN_KPIProgress_Generator_Controller.Category cat = BEN_KPIProgress_Generator_Controller.allCategories;
        System.debug('Total records : totalRecs'+cat.totalRecs);
        System.debug('Total records : totalWinPerc'+cat.totalWinPerc);
        System.debug('Total records : totalParityPerc'+cat.totalParityPerc);
        System.debug('Total records : totalParityPerc'+cat.totalLossPerc);
        System.debug('Total records : totalParityPerc'+cat.totalsCount);
        System.debug('Total records : renderAsVar'+BEN_KPIProgress_Generator_Controller.renderAsVar);
        
    }
    
    
    
    
}