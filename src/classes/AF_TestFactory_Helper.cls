public with sharing class AF_TestFactory_Helper 
{
    public static List<AF_Bonus_Summary__c> BonussummaryList;
    public static user u;
    public static user u1;
    public static user u2;
    public static user u3;
    public static user u4;
    public static string User_permissonset_user1='AF_Sairam';
    public static string User_permissonset_user2='AF_Sairam1';
    public static List<DummyUser__c> createDummyusr;
    public static date mydate=system.today();
    public static string currr;
    public static List<AF_PO_Report__c> poreportLst;
    public static List<AF_Comments__c> commentsList;
    public static List<AF_Comments__c> commentsList1;
    public static List<AF_Comments__c> commentsList2;
    public static List<AF_Comments__c> commentsList3;
    public static List<PermissionSet> PermissionSetLst;
    public static List<PermissionSet> PermissionSetLst1;
    public static List<Users_Category__c > usercategoryLst;
    public static List<Users_Category__c> usercategoryLst1;
    public static List<AF_Matrix_Table__c> MatrixTableList;
    public static List<AF_AgencyDate__c> agencylst;
    public static date daysBefore = mydate.adddays(-14);
    public static List<AF_Agency_Estimate__c > AgencyEstimateList1;
    public static List<AF_AnnualBonus_Qual__c> AnnualBonusList;
    public static List<AF_AnnualBonus_Qual__c> AnnualBonus;
    public static List<AF_QuarterlyBonus__c> QuarterlyBonus;
    public static List<AF_OOPS_Actual__c> OOPSActualList;
    public static List<AF_OOPS_Actual__c> OOPSActualList1;
    Public static List<Send_Email__c> SendEmail;
    public static List<AF_Sub_Result__c> subResultLst;
    public static List<AF_Sub_Result__c> subResultLst1;
    public static List<AF_Agency_Bonus_Access__c> agencybonusaccessLst;
    public static List<AF_Brand_Estimate__c> BrandEstimateList1;
    public static List<AF_Entity_Exception__c>  EntityExcepList;
    public static List<contact> conList = new List<contact>();
    public static List<contact> conList1 = new List<contact>();
    public static List<contact> conList2 = new List<contact>();
    public Static Integer IcurrYear = System.Today().year();
    public Static string currYear=string.valueof(IcurrYear);
    Public Static Integer IcurrYear1 = System.Today().year()-1;
    Public Static string currYear1=string.valueof(IcurrYear1);
    public static List<AF_Bonus_Results__c > BonusResultsList;
    public static List<AF_OOPS_Estimate__c> oopsEstimateList;
     public static List<AF_OOPS_Estimate__c> oopsEstimateList1;
    public static List<AF_Bonus_Matrix__c > BonusMatrixList;
    public static List<Account> accList = new List<Account>();
    Public static List<AF_Category_Brand__c> categoryList;
    public static  List<AF_isBonusLinkForAgency__c> bonusLinkforAgencyLst;
    public static List<AF_CMCO__c> cmcoLst;
    public static List<AF_BonusQuarterly__c> bonusQuarterlyLst;
    public static List<AF_CatFinanceThreshold__c> catfinancethresholdlst;
    public static List<AF_BrandEstimate_TriggerDate__c> BrandEstimateTriggerDateLst;
    public static List<AF_OOPS_Settings__c> oopssettingslst;
    public static List<AF_Links__c> linkLst;
    public static List<AF_BonusQuarterly_Quarterdates__c > BonusQuarterlyQuarter;
    public static String agencyEntityCountry = 'Singapore';
    Public static List<AF_Category_Brand__c> categoryBrandList = new List<AF_Category_Brand__c>();
    public static List<AF_Bonus_Threshold__c > BonusThresholdList = new List<AF_Bonus_Threshold__c >();
    Public static List<AF_Brand_Estimate__c>   BrandEstimateList = new List<AF_Brand_Estimate__c>();
    public static List<AF_Currency__c> currencyList = new List<AF_Currency__c>();
    public static List<AF_Entity__c> EntityList = new List<AF_Entity__c>();
    public static List<AF_Entity__c> EntityListRec;
    public static List<AF_Entity__c> Entity3Lst;
    public static List<AF_Entity__c> Entity4Lst;
    public static List<AF_TriggerDate__c> TriggerdateLst;
    public static List<Attachment> attachmentLst;
    public static List<Attachment> attachmentLst1;
    public static List<Attachment>  attachmentLst2;
    public static List<PermissionSetAssignment> permissionsetassignlst;
    public static List<Group> grouplst;
    Public static List<GroupMember> groupmemlst;
    public static List<AF_AgencyEmailAlerts__c>  AgnecyEmailAlertsLst;
    public static List<AF_Controller_Review__c> controllerReviewList = new List<AF_Controller_Review__c>();
    public static List<AF_Controller_Review__c> controllerReviewList1 = new List<AF_Controller_Review__c>();
    public static List<AF_Agency_Estimate__c> AgencyEstimateList = new List<AF_Agency_Estimate__c>();
    public static Id AF_CATEGORY_RECTYPE = Schema.SObjectType.AF_Category_Brand__c.RecordTypeInfosByName.get('Category').RecordTypeId;
    public static Id AF_BRAND_RECTYPE = Schema.SObjectType.AF_Category_Brand__c.RecordTypeInfosByName.get('Brand').RecordTypeId;
    public static Id AF_AGENCY_ENTITY_RECTYPE = Schema.SObjectType.AF_Entity__c.RecordTypeInfosByName.get('Agency Entity').RecordTypeId;
    public static Id AF_UNILIVER_ENTITY_RECTYPE = Schema.SObjectType.AF_Entity__c.RecordTypeInfosByName.get('Unilever Entity').RecordTypeId;
    public static Id AF_BONUS_RESULTS_RECTYPE = Schema.SObjectType.AF_Bonus_Results__c.RecordTypeInfosByName.get('Bonus Annual').RecordTypeId;
    public static Id AF_BONUS_RESULTS_RECTYPE_QUARTERLY = Schema.SObjectType.AF_Bonus_Results__c.RecordTypeInfosByName.get('Bonus Quarterly').RecordTypeId;
    public static Profile P = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    public static Profile Platformprofile=[Select Id from Profile where Name='Agency Fee Platform User']; 
    public static Profile AgencyPlatformprofile=[Select Id from Profile where Name='AF - Agency Portal User']; 
    public static user usr;
    public static final string ACCOUNT_RECORD =' The Account Records are Inserted';
    public static final string CONTACT_RECORD = 'The Contact Records are Inserted';
    public static final string CATEGORY_RECORD ='The Category Records are inserted';
    public static final string BRAND_RECORD ='The Brand Records are inserted';
    public static final string BRANDESTIMATE_RECORD ='The BrandEstimate Records are inserted';
    public static final string AGENCYESTIMATE_RECORD='Agency Estimate is inserted';
    public static final string CURRENCY_RECORD ='The Currency records are inserted';
    public static final string AGENCY_ENTITY='Agency Entity is inserted';
    public static final string UNILEVER_ENTITY='The UnileverEntity records are inserted';
    public static final string MATRIX_RECORD='The Matrix table record is inserted';
    public static final string BONUSSUMMARY_RECORD='The BonusSummary records are inserted';
    public static final string BONUSTHERSHOLD_RECORD='The BonusThreshold records are inserted';
    public static final string BONUSRESULT_RECORD='The BonusResults records are inserted';
    public static final string BONUSMATRIX_RECORD='The BonusMatrix records are inserted';
    public static final string USER_RECORD ='The User Records are inserted';
    public static final string OOPSACTUCAL_RECORD ='OopsActual is inserted';
    public static final string OOPSESTIMATE_RECORD='OopsEstimate is inserted';
    public static final string ENTITYEXCEPTION_RECORD ='Entity Exception Record is inserted';
    public static final string CONTROLLERREVIEW_RECORD ='controller review Record is inserted';
    public static final string COMMENT_RECORD ='comment Record is inserted';
    public static final string SUBRESULT_RECORD ='sub result Record is inserted';
    
    public static User createUserAdmin(Boolean doInsert) 
    {
        u= new User(Alias = 'testbe', Email='standarduserbe@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, FirstName=AF_Constants.TEST_USER_FIRSTNAME,LastName='Test Userbe', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id, 
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c='agency',isActive=true, 
        UserName='testuserbe@test123321.com',AF_Brand__c='Test Brandbe',AF_Category__c='Test Beveragesbe');
        if(doInsert){
            insert u; 
        }return u;
    }
    public static User createUserAdmin1(Boolean doInsert) 
    {
        u1= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbth1@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id,
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true,AF_UserTypeText__c='Regional Category Finance', 
        UserName='testuserbth1@test123321.com',AF_Brand__c=AF_Constants.TEST_BRAND,AF_Category__c=AF_Constants.TEST_AF_Category);
        if(doInsert){
            insert u1; 
        }return u1;
    }
    public static User createUserADMINSTRATOR_CATEGORY(Boolean doInsert) 
    {
        u1= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbth1@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id,
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true,AF_UserTypeText__c=AF_Constants.UT_CATEGORY_FINANCE, 
        UserName='testuserbth@test123321.com',AF_Brand__c=AF_Constants.TEST_BRANDNAME,AF_Category__c=AF_Constants.TEST_CATEGORYNAME);
        if(doInsert){
            insert u1; 
        }return u1;
    }
    public static User createUserADMINSTRATOR(Boolean doInsert) 
    {
        u1= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbth1@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id,
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true,AF_UserTypeText__c=AF_Constants.UT_CATEGORY_FINANCE, 
        UserName='testuserbth@test123321.com',AF_Brand__c=AF_Constants.TEST_BRANDNAME,AF_Category__c=AF_Constants.TEST_AF_Category);
        if(doInsert){
            insert u1; 
        }return u1;
    }
    public static User createUserADMINSTRATOR1(Boolean doInsert) 
    {
        u1= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbth11@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id,
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true,AF_UserTypeText__c=AF_Constants.UT_CATEGORY_FINANCE, 
        UserName='testuserbth1@test12332123.com',AF_Brand__c=AF_Constants.TEST_BRANDNAME,AF_Category__c=AF_Constants.TEST_AF_Category);
        if(doInsert){
            insert u1; 
        }return u1;
    }
    public static User createUserADMINSTRATOR2(Boolean doInsert) 
    {
        u1= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbth11@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id,
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true,AF_UserTypeText__c=AF_Constants.UT_CATEGORY_FINANCE, 
        UserName='testuserbth123@test12332123.com',AF_Brand__c=AF_Constants.TEST_BRANDNAME,AF_Category__c=AF_Constants.TEST_AF_Category);
        if(doInsert){
            insert u1; 
        }return u1;
    }
    public static User createUserADMINSTRATOR3(Boolean doInsert) 
    {
        u1= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbth11@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id,
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true,AF_UserTypeText__c=AF_Constants.UT_CATEGORY_FINANCE, 
        UserName='testuserbth12123@test12332123.com',AF_Brand__c=AF_Constants.TEST_BRANDNAME,AF_Category__c=AF_Constants.TEST_AF_Category);
        if(doInsert){
            insert u1; 
        }return u1;
    }
    public static User createUserADMINSTRATOR4(Boolean doInsert) 
    {
        u1= new User(Alias = AF_Constants.TEST_Alias, Email='standarduserbth11@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = p.Id,
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true,AF_UserTypeText__c=AF_Constants.UT_CATEGORY_FINANCE, 
        UserName='testuserbth12123@test1233212345.com',AF_Brand__c=AF_Constants.TEST_BRANDNAME,AF_Category__c=AF_Constants.TEST_AF_Category);
        if(doInsert){
            insert u1; 
        }return u1;
    }
      public static user createUserAdmin2(Boolean doInsert)
    {
        usr= new User(Alias = 'testc', Email='standarduserc@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Userc', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = Platformprofile.Id, 
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CMCO_USER,isActive=true, 
        UserName='testuserc@test123321.com',AF_Brand__c='Test Brandc',AF_Category__c='Test Beveragesc');
        if(doInsert){
            insert usr;
        }
        return usr;
    }
    public static User createUserAdmin3(Boolean doInsert) 
    {
        u3= new User(Alias = 'testuo3', Email='standarduseruo3@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Useruo3', LanguageLocaleKey=AF_Constants.LocaleKey, 
        LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id,
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
        UserName='testuseruo3@test123321.com',AF_Brand__c=AF_Constants.TEST_BRANDNAME,AF_Category__c=AF_Constants.TEST_AF_Category);
        if(doInsert){
            insert u3; 
        }return u3;
    }
    public static User createUserAdmin4(Boolean doInsert) 
    {
        u4= new User(Alias = 'testuo4', Email='standarduseruo4@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Useruo4', LanguageLocaleKey=AF_Constants.LocaleKey, 
        LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c=AF_Constants.UT_REGIONAL_CATEGORY_FINANCE,isActive=true, 
        UserName='testuseruo3@test121.com',AF_Brand__c=AF_Constants.TEST_BRAND,AF_Category__c=AF_Constants.TEST_AF_Category);
        if(doInsert){
            insert u4; 
        }return u4;
    }
    public static user createuser(Boolean doInsert)
    {
        usr= new User(Alias = 'testc', Email='standarduserc@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Userc', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = Platformprofile.Id, 
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c='CMCO Super User',isActive=true, 
        UserName='testuserctc@test123321.com',AF_Brand__c='Test Brandc',AF_Category__c='Test Beveragesc');
        if(doInsert){
            insert usr;
        }
        return usr;
    }
    public static user createAgency(Boolean doInsert)
    {
        usr= new User(Alias = 'testc', Email='standarduserc@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Userc', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = Platformprofile.Id,AF_UserTypeText__c=AF_Constants.UT_CATEGORY_FINANCE,
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
        UserName='testusercsd@test123321.com',AF_Brand__c=AF_Constants.TEST_BRAND,AF_Category__c='Test Beveragesc');
        if(doInsert){
            insert usr;
        }
        return usr;
    }
    public static user createAgencyProfile(Boolean doInsert)
    {
        usr= new User(Alias = 'testc', Email='standarduserc@unilever.com', 
        EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName='Test Userc', LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
        LocaleSidKey=AF_Constants.TEST_LanguageLocaleKey, ProfileId = AgencyPlatformprofile.Id,AF_UserTypeText__c=AF_Constants.UT_CATEGORY_FINANCE,
        TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
        UserName='testusercsd@test12332112.com',AF_Brand__c=AF_Constants.TEST_BRAND,AF_Category__c='Test Beveragesc');
        if(doInsert){
            insert usr;
        }
        return usr;
    }
    public static List<Users_Category__c> insertusercategory (integer count,Boolean doInsert)
    {
        usercategoryLst = new List<Users_Category__c>();
        for(integer i=1;i<=count;i++){
            Users_Category__c userCat=new Users_Category__c();
            userCat.Brand__c=categoryBrandList[i-1].Id;
            userCat.Category__c=categoryList[i-1].Id;
            userCat.User__c=u.Id;
            usercategoryLst.add(userCat);
        }
        if(doInsert){
            insert usercategoryLst;
        }
        return usercategoryLst;
    }
    public static List<Users_Category__c> insertusercategory1 (integer count,Boolean doInsert)
    {
        usercategoryLst1 = new List<Users_Category__c>();
        for(integer i=1;i<=count;i++){
            Users_Category__c userCat1=new Users_Category__c();
            userCat1.Brand__c=categoryBrandList[i-1].Id;
            userCat1.Category__c=categoryList[i-1].Id;
            userCat1.User__c=u1.Id;
            usercategoryLst1.add(userCat1);
        }
        if(doInsert){
            insert usercategoryLst1;
        }
        return usercategoryLst1;
    }
    public static List<AF_BrandEstimate_TriggerDate__c> insertBrandEstimateTriggerDate (Integer count,Boolean doinsert)
    {
        BrandEstimateTriggerDateLst = new List<AF_BrandEstimate_TriggerDate__c> ();
        for(integer i=1;i<=count;i++){
            AF_BrandEstimate_TriggerDate__c be = new AF_BrandEstimate_TriggerDate__c();
            be.AF_Currency_Uploaded__c = true;
            be.AF_Trigger_Date__c = system.today();
            BrandEstimateTriggerDateLst.add(be);
        }
        if(doInsert){
            insert BrandEstimateTriggerDateLst;
        }
        return BrandEstimateTriggerDateLst;
    }
    public static List<AF_OOPS_Settings__c> insertOOPsetting (Boolean doInsert ,integer count)
    {
        oopssettingslst = new List<AF_OOPS_Settings__c>();
        for(integer i=1;i<=count;i++){
            AF_OOPS_Settings__c oops = new AF_OOPS_Settings__c();
            oops.Overall_Percentage__c = 4;
            oopssettingslst.add(oops);
        }
        if(doInsert){
            insert oopssettingslst;
        }
        return oopssettingslst;
    }
    public static List<AF_Links__c> insertlink (integer count,Boolean doinsert)
    {
        linklst = new List<AF_Links__c>();
        for(integer i=1;i<=count;i++){
            AF_Links__c link = new AF_Links__c();
            link.AF_Community_Link__c = 'https://agfeecog2-unilever.cs8.force.com/AgencyFees';
            linklst.add(link);
        }
        if(doInsert){
            insert linklst;
        }
        return linklst;
    }
    public static List<AF_BonusQuarterly__c> insertAnnualBonusQuarterly(Boolean doInsert ,integer count)
    {
        bonusQuarterlyLst = new List<AF_BonusQuarterly__c>();
        for(integer i=1;i<=count;i++){
            AF_BonusQuarterly__c bq = new AF_BonusQuarterly__c();
            bq.AF_BonusQuarterlyDate__c = system.today();
            bonusQuarterlyLst.add(bq);
        }
        if(doInsert)    {
            insert bonusQuarterlyLst;
        }
        return bonusQuarterlyLst;
    }
    public static List<AF_CMCO__c> insertCMCO (integer count, Boolean doInsert)
    {
        cmcoLst = new List<AF_CMCO__c> ();
        for(integer i=1;i<=count;i++){
            AF_CMCO__c ac = new AF_CMCO__c();
            ac.AF_CMCO_Rights__c = true;
            cmcoLst.add(ac);
        }
        if(doInsert){
            insert CmcoLst;
        }
        return cmcoLst;
    }
    public static List<AF_CatFinanceThreshold__c> insertcatfinancethreshold (integer count,Boolean doInsert)
    {
        catfinancethresholdlst= new List<AF_CatFinanceThreshold__c> ();
        for(integer i=1;i<=count;i++){
            AF_CatFinanceThreshold__c cf = new AF_CatFinanceThreshold__c();
            cf.AF_Date__c = system.today();
            catfinancethresholdlst.add(cf);
        }
        if(doInsert){
            insert catfinancethresholdlst;
        }
        return catfinancethresholdlst;
    }
    public static List<DummyUser__c>  createDummyUser(Boolean doInsert)
    {
        createDummyusr = new List<DummyUser__c>();
        DummyUser__c dummyuser = new DummyUser__c();
        dummyuser.User_id__c = u.id;
        createDummyusr.add(dummyuser);
        if(doInsert){
            insert createDummyusr;
        } return createDummyusr;
    }
    public static List<AF_Agency_Bonus_Access__c> insertAgencyBonusAccess(Integer count, Boolean doInsert)
    {
        agencybonusaccesslst = new List<AF_Agency_Bonus_Access__c>();
        for(integer i=1;i<=count;i++){
            AF_Agency_Bonus_Access__c ab = new AF_Agency_Bonus_Access__c();
            ab.Name=currYear;
            ab.AF_Access_Date__c = system.today();
            ab.AF_Fiscal_Year__c = currYear;
        }
        if(doInsert){
            insert agencybonusaccesslst;
        }
        return agencybonusaccesslst;
    }
    public static List<AF_isBonusLinkForAgency__c> insertBonusLinkforAgency (Integer count,Boolean doInsert)
    {
        bonusLinkforAgencyLst = new List<AF_isBonusLinkForAgency__c>();
        for(integer i=1;i<=count;i++){
            AF_isBonusLinkForAgency__c bl = new AF_isBonusLinkForAgency__c();
            bl.Name ='Bonus Quarterly';
            bl.Bonus_Date__c = system.today();
            bonusLinkforAgencyLst.add(bl);
        }
        if(doInsert){
            insert bonusLinkforAgencyLst;
        }
        return bonusLinkforAgencyLst;
    }
    public static List<Account> insertAFaccList(Integer count ,Boolean doInsert)
    {
        accList = new List<Account>();
        for(Integer i = 1; i <= count; i++)
        {
            Account  acc =new Account(Name='TestAgency'+i);
            accList.add(acc);
        }
        if(doInsert){
            insert accList;
        } return accList;
    }
    public static List<contact> AFInsertContact (Integer count,Boolean doInsert)
    {
        conList = new List<contact>();
        for(Integer i = 1; i <= count; i++)
        {
            Contact con=new Contact();
            con.LastName='Test_Contac'+i;
            con.AccountId=accList[i-1].Id;
            con.AF_Send_Email_Notification__c = true;
            con.Email='testcon1@test1233.com';
            conList.add(con);
        }
        if(doInsert){
            insert conList;
        }return conList;
    }
    public static List<contact> AFInsertContact1(Integer count,Boolean doInsert)
    {
        conList1 = new List<contact>();
        for(Integer i = 1; i <= count; i++)
        {
            contact con1 = new contact();
            con1.LastName='Test_Contac'+i;
            con1.AccountId=accList[i-1].Id;
            con1.AF_Send_Email_Notification__c = true;
            con1.Email='testcon2@test1233.com';
            conList1.add(con1);
        }
        if(doInsert){
            insert conList1;
        }return conList1;
    }
    public static List<contact> AFInsertContact2 (Integer count,Boolean doInsert)
    {
        conList2 = new List<contact>();
        for(Integer i = 1; i <= count; i++)
        {
            contact con2 = new contact();
            con2.LastName='Test_Contac'+i;
            con2.AccountId=accList[i-1].Id;
            con2.AF_Send_Email_Notification__c = true;
            con2.Email='testcon2@test1233.com';
            conList2.add(con2);
        }
        if(doInsert){
            insert conList2;
        }return conList2;
    }
    public static List<AF_Category_Brand__c> insertAFCBList(Integer count, Boolean doInsert)
    {
        categoryList = new List<AF_Category_Brand__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Category_Brand__c AFCategory = new AF_Category_Brand__c();
            AFCategory.RecordTypeId =AF_CATEGORY_RECTYPE;
            AFCategory.Name='Test'+i;
            AFcategory.AF_Super_category__c='Drinks';
            categoryList.add(AFCategory);
        }
        if(doInsert){
            insert categoryList;
        }return categoryList;
    }
    public static List<AF_Category_Brand__c> insertBrand (Integer count , Boolean doInsert)
    {
        categoryBrandList = new List<AF_Category_Brand__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Category_Brand__c AFBrand = new AF_Category_Brand__c();
            AFBrand.RecordTypeId = AF_BRAND_RECTYPE;
            AFBrand.AF_Category_Brands__c = categoryList[i-1].id;
            AFBrand.Name= 'BrandName'+i;
            categoryBrandList.add(AFBrand);
        } 
        if(doInsert){
        insert categoryBrandList;
        }return categoryBrandList;
    }
    public static List<AF_Comments__c> insertcomments (Integer count,Boolean doInsert)
    {
        commentsList = new List<AF_Comments__c>();
        for(Integer i = 1; i <= count; i++)
        {
            AF_Comments__c comm=new AF_Comments__c();
            comm.AF_Parent_Object_Type__c='AF_Brand_Estimate__c';
            comm.AF_Parent_Record_Id__c=BrandEstimateList[i-1].id;
            comm.AF_Agency_Estimate__c=AgencyEstimateList[i-1].Id;
            comm.AF_Bonus__c=BonusMatrixList[i-1].Id;
            comm.AF_Brand_Estimate__c=BrandEstimateList[i-1].id;
            comm.AF_Comments__c='Comment'+i;
            comm.AF_OOPS_Actual__c=OOPSActualList[i-1].Id;
            comm.AF_OOPS_Estimate__c=oopsEstimateList[i-1].Id;
            commentsList.add(comm);
        }
        if(doInsert){
            insert commentsList;
        }
        return commentsList;
    }
    public static List<AF_Comments__c> insertcomments1 (Integer count,Boolean doInsert)
    {
        commentsList1 = new List<AF_Comments__c>();
        for(Integer i = 1; i <= count; i++)
        {
            AF_Comments__c comm1=new AF_Comments__c();
            comm1.AF_Parent_Object_Type__c='AF_Agency_Estimate__c';
            comm1.AF_Parent_Record_Id__c=AgencyEstimateList[i-1].id;
            comm1.AF_Agency_Estimate__c=AgencyEstimateList[i-1].Id;
            comm1.AF_Bonus__c=BonusMatrixList[i-1].Id;
            comm1.AF_Brand_Estimate__c=BrandEstimateList[i-1].id;
            comm1.AF_Comments__c='Comment';
            comm1.AF_OOPS_Actual__c=OOPSActualList[i-1].Id;
            comm1.AF_OOPS_Estimate__c=oopsEstimateList[i-1].Id;
            commentsList1.add(comm1);
        }
        if(doInsert){
            insert commentsList1;
        }
        return commentsList1;
    }
    public static List<AF_Comments__c> insertcomments2 (Integer count,Boolean doInsert)
    {
        commentsList2 = new List<AF_Comments__c>();
        for(Integer i = 1; i <= count; i++)
        {
            AF_Comments__c comm2=new AF_Comments__c();
            comm2.AF_Parent_Object_Type__c='AF_Bonus__c';
            comm2.AF_Parent_Record_Id__c=BonusMatrixList[i-1].id;
            comm2.AF_Agency_Estimate__c=AgencyEstimateList[i-1].Id;
            comm2.AF_Bonus__c=BonusMatrixList[i-1].Id;
            comm2.AF_Brand_Estimate__c=BrandEstimateList[i-1].id;
            comm2.AF_Comments__c='Comment';
            comm2.AF_OOPS_Actual__c=OOPSActualList[i-1].Id;
            comm2.AF_OOPS_Estimate__c=oopsEstimateList[i-1].Id;
            commentsList2.add(comm2);
        }
        if(doInsert){
            insert commentsList2;
        }
        return commentsList2;
    }
    public static List<AF_Comments__c> insertcomments3 (Integer count,Boolean doInsert)
    {
        commentsList3 = new List<AF_Comments__c>();
        for(Integer i = 1; i <= count; i++)
        {
            AF_Comments__c comm3  = new AF_Comments__c();
            comm3.AF_Parent_Object_Type__c='AF_OOPS_Estimate__c';
            comm3.AF_Parent_Record_Id__c=oopsEstimateList[i-1].id;
            comm3.AF_Agency_Estimate__c=AgencyEstimateList[i-1].Id;
            comm3.AF_Bonus__c=BonusMatrixList[i-1].Id;
            comm3.AF_Brand_Estimate__c=BrandEstimateList[i-1].id;
            comm3.AF_Comments__c='Comment';
            comm3.AF_OOPS_Actual__c=OOPSActualList[i-1].Id;
            comm3.AF_OOPS_Estimate__c=oopsEstimateList[i-1].Id;
            commentsList3.add(comm3);
        }
        if(doInsert){
            insert commentsList3;
        }
        return commentsList3;
    }
    public static List<AF_Brand_Estimate__c> insertAFBrandEstList (Integer count,Boolean doInsert)
    {
        BrandEstimateList = new List<AF_Brand_Estimate__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Brand_Estimate__c  AFBrandEst = new AF_Brand_Estimate__c();
            AFBrandEst.AF_Agency__c=accList[i-1].id;
            AFBrandEst.Name='Test'+i;
            AFBrandEst.Brand__c=categoryBrandList[i-1].id;
            AFBrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;  
            BrandEstimateList.add(AFBrandEst);
        }
        if(doInsert){
            insert BrandEstimateList;
        }return BrandEstimateList;
    }
    public static List<AF_Brand_Estimate__c> insertAFBrandEstList1 (Integer count,Boolean doInsert)
    {
        BrandEstimateList1 = new List<AF_Brand_Estimate__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Brand_Estimate__c  AFBrandEst1 = new AF_Brand_Estimate__c();
            AFBrandEst1.AF_Agency__c=accList[i-1].id;
            AFBrandEst1.Name='Test'+i;
            AFBrandEst1.Brand__c=categoryBrandList[i-1].id;
            BrandEstimateList1.add(AFBrandEst1);
        }
        if(doInsert){
            insert BrandEstimateList1;
        }return BrandEstimateList1;
    }
    public static List<AF_Currency__c> insertAFcurrencyList (Integer count,Boolean doInsert)
    {
        currencyList = new List<AF_Currency__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Currency__c curr = new AF_Currency__c();
            curr.AF_Country__c = 'Ecuador'+i;
            curr.AF_Currency_Code__c = 'USD'+i;
            curr.Country_Currency__c = 'Eucador-USD'+i;
            curr.AF_Fiscal_Year_new__c = currYear;
            curr.Currency_Unit__c = 'US $'+i;
            curr.AF_Fiscal_Year__c = system.today();
            curr.AF_Average_Exchange_Rate_To_EUR__c = 1.3253;
            curr.Ready_For_PO_Exchange_Rate_SGD_To_USD__c=1.0000;
            curr.Ready_For_PO_Exchange_Rate_To_EUR__c = 1.6112;
            currencyList.add(curr);
        }if(doInsert){
            insert currencyList;
        }return currencyList;    
    }
    public static List<AF_Controller_Review__c> AfcontrollerReview(Integer count , Boolean doInsert)
    {
        controllerReviewList = new List<AF_Controller_Review__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Controller_Review__c conRev1=new AF_Controller_Review__c();
            conRev1.Brand_Estimate__c=BrandEstimateList[i-1].Id;
            conRev1.Controller_Group__c=AF_Constants.TEST_USER_FIRSTNAME;
            controllerReviewList.add(conRev1);
        }
        if(doInsert){
            insert controllerReviewList; 
        }return  controllerReviewList;
    }
    public static List<AF_Controller_Review__c> AfcontrollerReview1(Integer count , Boolean doInsert)
    {
        controllerReviewList = new List<AF_Controller_Review__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Controller_Review__c conRev=new AF_Controller_Review__c();
            conRev.Brand_Estimate__c=BrandEstimateList[i-1].Id;
            conRev.Controller_Group__c='test1';
            controllerReviewList.add(conRev);
        }
        if(doInsert){
            insert controllerReviewList1; 
        }return  controllerReviewList1;
    }
    public static List<AF_Entity__c> insertAgencyEntityList(Integer count , Boolean doInsert)
    {
        EntityList = new List<AF_Entity__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Entity__c entity1=new AF_Entity__c();
            entity1.Name='Australia'+i; 
            entity1.AF_Country__c='Australia';     
            entity1.AF_Agency__c=accList[i-1].Id;
            entity1.RecordTypeId=AF_AGENCY_ENTITY_RECTYPE;       
            EntityList.add(entity1);
        }if(doInsert){
            Insert EntityList;
        }return EntityList;
    }
    public static List<AF_Entity__c> insertUnileverEntityListRec(Integer count, Boolean doInsert)
    {
        EntityListRec = new List<AF_Entity__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Entity__c entity2=new AF_Entity__c();
            entity2.Name='Test Unilever Entity'+i;
            entity2.AF_Country__c='Austria';     
            entity2.RecordTypeId=AF_UNILIVER_ENTITY_RECTYPE;         
            EntityListRec.add(entity2);
        }if(doInsert){
            insert EntityListRec;
        }return EntityListRec;
    }
    public static List<AF_Entity__c> insertEntity3(Integer count, Boolean doInsert)
    {
        Entity3Lst = new List<AF_Entity__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Entity__c entity3=new AF_Entity__c();
            entity3.Name='Test Entityab3'+i;       
            entity3.AF_Agency__c=accList[i-1].Id; 
            entity3.AF_Country__c=agencyEntityCountry;
            entity3.RecordTypeId=AF_AGENCY_ENTITY_RECTYPE;
            Entity3Lst.add(entity3);
        }if(doInsert){
            insert Entity3Lst;
        }return Entity3Lst;
    }
    public static List<AF_Entity__c> insertEntity4(Integer count, Boolean doInsert)
    {
        Entity4Lst = new List<AF_Entity__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Entity__c entity4=new AF_Entity__c();
            entity4.Name='Test Entityab4'+i;       
            entity4.AF_Agency__c=accList[i-1].Id; 
            entity4.AF_Country__c='india';
            entity4.Controller_Group__c=AF_Constants.TEST_CURRENCY_COUNTRY;
            entity4.RecordTypeId=AF_UNILIVER_ENTITY_RECTYPE;
            Entity3Lst.add(entity4);
        }if(doInsert){
            insert Entity4Lst;
        }return Entity4Lst;
    }
    public static List<AF_Agency_Estimate__c> insertAgencyEstimate(Integer count,Boolean doInsert)
    {
        AgencyEstimateList =new List<AF_Agency_Estimate__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Agency_Estimate__c agenEst=new AF_Agency_Estimate__c();
            agenEst.AF_Brand_Estimate__c=BrandEstimateList[i-1].Id;
            agenEst.AF_Agency_Entity__c=EntityList[i-1].Id;
            agenEst.AF_Unilever_Entity__c=EntityListRec[i-1].Id;
            AgencyEstimateList.add(agenEst);
        } if(doInsert){
            insert AgencyEstimateList;
        }return AgencyEstimateList;
    }
    public static List<AF_Agency_Estimate__c> insertAgencyEstimate1(Integer count,Boolean doInsert)
    {
        AgencyEstimateList1 =new List<AF_Agency_Estimate__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Agency_Estimate__c agenEst1=new AF_Agency_Estimate__c();
            agenEst1.AF_Brand_Estimate__c=BrandEstimateList[i-1].Id;
            agenEst1.AF_Agency_Entity__c=Entity3Lst[i-1].Id;
            agenEst1.AF_Unilever_Entity__c=EntityListRec[i-1].Id;
            AgencyEstimateList.add(agenEst1);
        } if(doInsert){
            insert AgencyEstimateList1;
        }return AgencyEstimateList1;
    }
    public static List<AF_Bonus_Summary__c> insertBonusSummary(Integer count ,Boolean doInsert)
    {
        BonussummaryList = new List<AF_Bonus_Summary__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Bonus_Summary__c bonSum=new AF_Bonus_Summary__c();
            bonSum.AF_Agency__c=accList[i-1].Id;
            bonSum.AF_Brand__c=categoryBrandList[i-1].Id;
            bonSum.AF_Fiscal_Year__c=currYear;
            BonussummaryList.add(bonSum);
        }
        if(doInsert){
            insert BonussummaryList;
        }return BonussummaryList;
    }
    public static List<AF_Entity_Exception__c> InsertEntityException (Integer count ,Boolean doInsert)
    {
        EntityExcepList = new List<AF_Entity_Exception__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Entity_Exception__c entiExcep=new AF_Entity_Exception__c();
            entiExcep.AF_Agency_Estimate__c=AgencyEstimateList[i-1].Id;
            entiExcep.AF_Value_Euro__c=122;
            entiExcep.AF_Value__c=10;
            entiExcep.AF_Country__c=AF_Constants.TEST_AGENCY_ENTITY_COUNTRY;
            EntityExcepList.add(entiExcep);
        }
        if(doInsert){
            insert EntityExcepList;
        }
        return EntityExcepList;
    }
    public static List<AF_Bonus_Results__c > insertBonusResults (integer count, Boolean doInsert)
    {
        BonusResultsList = new List<AF_Bonus_Results__c >();
        for(Integer i=1;i<=count;i++)
        {
            AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
            bonRes.AF_Bonus_Thresholds__c=BonusThresholdList[i-1].Id;
            bonRes.AF_Total_Bonus_Value__c=23;
            bonRes.RecordTypeId = AF_BONUS_RESULTS_RECTYPE;
            BonusResultsList.add(bonRes);
        }
        if(doInsert){
            insert BonusResultsList;
        }return BonusResultsList;
    }
     public static List<AF_Bonus_Results__c > insertBonusResultsquarterly (integer count, Boolean doInsert)
    {
        BonusResultsList = new List<AF_Bonus_Results__c >();
        for(Integer i=1;i<=count;i++)
        {
            AF_Bonus_Results__c bonRes=new AF_Bonus_Results__c();
            bonRes.AF_Bonus_Thresholds__c=BonusThresholdList[i-1].Id;
            bonRes.AF_Total_Bonus_Value__c=23;
            bonRes.RecordTypeId = AF_BONUS_RESULTS_RECTYPE_QUARTERLY;
            BonusResultsList.add(bonRes);
        }
        if(doInsert){
            insert BonusResultsList;
        }return BonusResultsList;
    }
    public static List<AF_Bonus_Threshold__c > insertBonusThreshhold(Integer count, Boolean doInsert)
    {
        BonusThresholdList = new List<AF_Bonus_Threshold__c >();
        for(Integer i=1;i<=count;i++)
        {
            AF_Bonus_Threshold__c bonThres = new AF_Bonus_Threshold__c();
            bonThres.Agency_Name__c = accList[i-1].Id;
            bonThres.AF_Brand_Estimate__c = BrandEstimateList[i-1].Id;
            bonThres.Brand_Name__c = categoryBrandList[i-1].Id;
            bonThres.AF_Country__c = EntityListRec[i-1].Id;
            BonusThresholdList.add(bonThres);
        }
        if(doinsert){
            insert BonusThresholdList;
        }return BonusThresholdList;
    }
    public static List<AF_Bonus_Matrix__c> insertBonusMatrix (Integer count ,Boolean doInsert)
    {
        BonusMatrixList = new List<AF_Bonus_Matrix__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Bonus_Matrix__c bonMat=new AF_Bonus_Matrix__c();
            bonMat.AF_Agency_Entity__c=EntityList[i-1].Id;
            bonMat.AF_Bonus_Results__c=BonusResultsList[i-1].Id;
            bonMat.AF_Bonus_Summary__c=BonussummaryList[i-1].Id;
            bonMat.AF_Unilever_Entity__c=EntityListRec[i-1].Id;
            BonusMatrixList.add(bonMat);
        }
        if(doInsert){
            insert BonusMatrixList;
        }return BonusMatrixList;
    }
    public static List<AF_OOPS_Actual__c> insertOOPSActual (Integer count, Boolean doInsert)
    {
        OOPSActualList = new List<AF_OOPS_Actual__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
            oopsActual.AF_Agency_lk__c=accList[i-1].Id;     
            oopsActual.AF_Agency__c=accList[i-1].Id;   
            oopsActual.AF_BrandEstimateId__c=BrandEstimateList[i-1].id;
            oopsActual.AF_Brand__c=categoryBrandList[i-1].Id;
            oopsActual.AF_Fiscal_year__c=currYear;
            OOPSActualList.add(oopsActual);
        }
        if(doInsert){
            insert OOPSActualList;
        }
        return OOPSActualList;
    }
    public static List<AF_OOPS_Actual__c> insertOOPSActual1 (Integer count, Boolean doInsert)
    {
        OOPSActualList1 = new List<AF_OOPS_Actual__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_OOPS_Actual__c oopsActual=new AF_OOPS_Actual__c();
            oopsActual.AF_Agency_lk__c=accList[i-1].Id;     
            oopsActual.AF_Agency__c=accList[i-1].Id;   
            oopsActual.AF_BrandEstimateId__c=BrandEstimateList[i-1].id;
            oopsActual.AF_Brand__c=categoryBrandList[i-1].Id;
            oopsActual.AF_Fiscal_year__c=currYear1;
            OOPSActualList.add(oopsActual);
        }
        if(doInsert){
            insert OOPSActualList1;
        }
        return OOPSActualList1;
    }
    public static List<AF_OOPS_Estimate__c> InsertOOPsEstimate (integer count , Boolean doInsert)
    {
        oopsEstimateList = new List<AF_OOPS_Estimate__c> ();
        for(Integer i=1;i<=count;i++)
        {
            AF_OOPS_Estimate__c oopEst=new AF_OOPS_Estimate__c();
            oopEst.AF_Agency_Entity__c=EntityList[i-1].Id;
            oopEst.AF_Brand_Estimate__c=BrandEstimateList[i-1].id;
            oopEst.AF_OOPS_Actual__c=OOPSActualList[i-1].Id;
            oopEst.AF_Unilever_Entity__c=EntityListRec[i-1].Id;
            oopEst.AF_Estimate__c=55;
            oopsEstimateList.add(oopEst);
        }
        if(doInsert){
            insert oopsEstimateList;
        }
        return oopsEstimateList;
    }
    public static List<AF_OOPS_Estimate__c> InsertOOPsEstimate1 (integer count , Boolean doInsert)
    {
        oopsEstimateList1 = new List<AF_OOPS_Estimate__c> ();
        for(Integer i=1;i<=count;i++)
        {
            AF_OOPS_Estimate__c oopEst1=new AF_OOPS_Estimate__c();
            oopEst1.AF_Agency_Entity__c=EntityList[i-1].Id;
            oopEst1.AF_Brand_Estimate__c=BrandEstimateList[i-1].id;
            oopEst1.AF_OOPS_Actual__c=OOPSActualList[i-1].Id;
            oopEst1.AF_Unilever_Entity__c=EntityListRec[i-1].Id;
            oopEst1.AF_Estimate__c=55;
            oopsEstimateList.add(oopEst1);
        }
        if(doInsert){
            insert oopsEstimateList1;
        }
        return oopsEstimateList1;
    }
    public static List<AF_AnnualBonus_Qual__c> insertAnnualBonusQual (Integer count,Boolean doInsert)
    {
        AnnualBonusList = new List<AF_AnnualBonus_Qual__c>();
        for(Integer i=1;i<=count;i++)
        {   AF_AnnualBonus_Qual__c customRecord = new AF_AnnualBonus_Qual__c();
            customRecord.Name='5'+i;
            customRecord.X5__c = 15;
            AnnualBonusList.add(customRecord);
        }
        if(doInsert){
            insert AnnualBonusList;
        }
        return AnnualBonusList;
    }
    public static List<AF_AnnualBonus_Qual__c> insertAnnualBonus (Integer count,Boolean doInsert)
    {
        AnnualBonus = new List<AF_AnnualBonus_Qual__c>();
        for(Integer i=1;i<=count;i++)
        {   AF_AnnualBonus_Qual__c customRecord1 = new AF_AnnualBonus_Qual__c();
            customRecord1.Name=AF_Constants.TEST_QUAL_VALUE +i;
            AnnualBonus.add(customRecord1);
        }
        if(doInsert){
            insert AnnualBonus;
        }
        return AnnualBonus;
    }
    public static List<AF_QuarterlyBonus__c> insertQuarterlyBonus (Integer count,Boolean doInsert)
    {
        QuarterlyBonus = new List<AF_QuarterlyBonus__c>();
        for(Integer i=1;i<=count;i++)
        {   AF_QuarterlyBonus__c QB = new AF_QuarterlyBonus__c();
            QB.Name = AF_Constants.TEST_BONUS_THRESHOLD+i;
            QuarterlyBonus.add(QB);
        }
        if(doInsert){
            insert QuarterlyBonus;
        }
        return QuarterlyBonus;
    }
    public static List<AF_TriggerDate__c> insertTriggerdate (Integer count,Boolean doInsert)
    {
        TriggerdateLst = new List<AF_TriggerDate__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_TriggerDate__c td = new AF_TriggerDate__c();
            td.Date__c = system.today();
            TriggerdateLst.add(td);
        }
        if(doInsert){
            insert TriggerdateLst;
        }
        return TriggerdateLst;
    }
    public static List<AF_AgencyEmailAlerts__c> insertagencyEmailalerts (Integer count,Boolean doInsert)
    {
        AgnecyEmailAlertsLst = new List<AF_AgencyEmailAlerts__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_AgencyEmailAlerts__c ae = new AF_AgencyEmailAlerts__c();
            ae.Name = 'Agency Reminder';
            ae.Q1__c = system.today();
            ae.Q2__c = system.today();
            ae.Q3__c = system.today();
            ae.Q4__c = system.today();
        }
        if(doinsert){
            insert AgnecyEmailAlertsLst;
        }
        return AgnecyEmailAlertsLst;
    }
    public static List<AF_Sub_Result__c> insertSubResult (Integer count , Boolean doInsert)
    {
        subResultLst = new List<AF_Sub_Result__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Sub_Result__c subResult = new AF_Sub_Result__c();
            subResult.AF_Bonus_Threshold__c = BonusThresholdList[i-1].Id;
            subResult.AF_country__c = EntityListRec[i-1].id;
            subResultLst.add(subResult);
        }
        if(doInsert){
            insert subResultLst;
        }
        return subResultLst;
    }
    public static List<AF_Sub_Result__c> insertSubResult1 (Integer count , Boolean doInsert)
    {
        subResultLst1 = new List<AF_Sub_Result__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Sub_Result__c subResult1 = new AF_Sub_Result__c();
            subResult1.AF_Bonus_Threshold__c = BonusThresholdList[i-1].Id;
            subResult1.AF_country__c = EntityListRec[i-1].id;
            subResultLst1.add(subResult1);
        }
        if(doInsert){
            insert subResultLst1;
        }
        return subResultLst1;
    }
    public static List<AF_BonusQuarterly_Quarterdates__c> insertBonusQuarterlyQuarterdate(Integer count ,Boolean doInsert)
    {
        BonusQuarterlyQuarter = new List<AF_BonusQuarterly_Quarterdates__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_BonusQuarterly_Quarterdates__c Quarter =new AF_BonusQuarterly_Quarterdates__c();
            Quarter.Name = 'Sample Quarter';
            Quarter.AF_Q1__c = daysBefore;
            Quarter.AF_Q2__c = daysBefore;
            Quarter.AF_Q3__c = daysBefore;
            BonusQuarterlyQuarter.add(Quarter);
        }
        if(doInsert){
            insert BonusQuarterlyQuarter;
        }
        return BonusQuarterlyQuarter;
    }
    public static List<Send_Email__c> insertSendEmail(Integer count ,Boolean doInsert)
    {
        SendEmail= new List<Send_Email__c>();
        for(Integer i=1;i<=count;i++)
        {
            currr=string.valueOf(system.now().month());
            Send_Email__c  send =new Send_Email__c ();
            send.sendEmailBonusQuartToCatFinance__c=true;
            send.Financial_Year__c=currr;
            send.URL_link_to_Agency_Fees__c = Label.AF_UrlLink;
            send.AF_Quarter__c='Q3' ;
            SendEmail.add(send);
        }
        if(doInsert){
            insert SendEmail;
        }
        return SendEmail;
    }
    public static List<Attachment> insertAttachment (Integer count, Boolean doInsert)
    {
        attachmentLst = new List<Attachment>();
        for(Integer i=1;i<=count;i++)
        {
            Attachment a1 = new Attachment();
            a1.name = 'test Doc1';
            Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body1');
            a1.body = bodyBlob;
            a1.ParentId = BrandEstimateList[i-1].id;
            attachmentLst.add(a1);
        }
        if(doInsert){
            insert attachmentLst;
        }
        return attachmentLst;
    }
    public static List<Attachment> insertAttachment1 (Integer count, Boolean doInsert)
    {
        attachmentLst1 = new List<Attachment>();
        for(Integer i=1;i<=count;i++)
        {
            Attachment a2 = new Attachment();
            a2.name = 'test Doc1';
            Blob bodyBlob1 = Blob.valueOf('Unit Test Attachment Body2');
            a2.body = bodyBlob1;
            a2.ParentId = OOPSActualList[i-1].id;
            attachmentLst1.add(a2);
        }
        if(doInsert){
            insert attachmentLst1;
        }
        return attachmentLst1;
    }
    public static List<Attachment> insertAttachment2(Integer count, Boolean doInsert)
    {
        attachmentLst2 = new List<Attachment>();
        for(Integer i=1;i<=count;i++)
        {
            Attachment a3 = new Attachment();
            a3.name = 'test Doc1';
            Blob bodyBlob2 = Blob.valueOf('Unit Test Attachment Body3');
            a3.body = bodyBlob2;
            a3.ParentId = BonussummaryList[i-1].id;
            attachmentLst2.add(a3);
        }
        if(doInsert){
            insert attachmentLst2;
        }
        return attachmentLst2;
    }
    public static List<AF_Matrix_Table__c> insertmatrixtable(Integer count,Boolean doInsert)
    {
        MatrixTableList = new  List<AF_Matrix_Table__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_Matrix_Table__c mtable = new AF_Matrix_Table__c();
            mtable.AF_Agency_Country__c = AF_Constants.TEST_AGENCY_ENTITY_COUNTRY;
            mtable.AF_Unilver_Country__c = AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
            mtable.AF_Matrix_Country__c = AF_Constants.TEST_CURRENCY_COUNTRY;
            mtable.AF_Matrix_Currency_Code__c = AF_Constants.AF_CURRENCY_USD;
            mtable.AF_Ready_For_PO_Currency_Code__c = AF_Constants.AF_CURRENCY_USD;
            mtable.AF_Ready_For_PO_Country__c =AF_Constants.TEST_AGENCY_ENTITY_COUNTRY;
            mtable.Ready_For_PO_Conversion__c = AF_Constants.AF_CURRENCY_USD;
            MatrixTableList.add(mtable);
        }
        if(doInsert){
            insert MatrixTableList;
        }
        return MatrixTableList;
    }
    public static List<AF_AgencyDate__c> insertAgencyDate(integer count,boolean doInsert){
        agencylst = new List<AF_AgencyDate__c>();
        for(Integer i=1;i<=count;i++)
        {
            AF_AgencyDate__c be = new AF_AgencyDate__c();
            be.Agency_Trigger_Date__c = system.today();
            agencylst.add(be);
        }
        if(doInsert){
            insert agencylst;
        }
        return agencylst;
        
    }
    
    public static List<PermissionSet> insertPermissionSet (Boolean doInsert,Integer count)
    {
        PermissionSetLST = new List<PermissionSet>();
         for(Integer i=1;i<=count;i++)
        {   
        PermissionSet ps1=new PermissionSet();  
        ps1.Name = User_permissonset_user1;
        ps1.Label = User_permissonset_user1;
        PermissionSetLst.add(ps1);
        }
        if(doInsert){
            insert permissionSetLst;
        }
        return PermissionSetLst;
    }
    
    public static List<PermissionSet> insertPermissionSet1 (Boolean doInsert,Integer count)
    {
        PermissionSetLST1 = new List<PermissionSet>();
         for(Integer i=1;i<=count;i++)
        {   
        PermissionSet ps2=new PermissionSet();  
        ps2.Name = User_permissonset_user2;
        ps2.Label = User_permissonset_user2;
        PermissionSetLst.add(ps2);
        }
        if(doInsert){
            insert permissionSetLst1;
        }
        return PermissionSetLst1;
    }
    public static List<PermissionSetAssignment> insertpermissionsetassign (Boolean doinsert, integer count)
    {
        permissionsetassignlst = new List<PermissionSetAssignment>();
         for(Integer i=1;i<=count;i++)
        { 
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        psa1.AssigneeId = u.Id;
        psa1.PermissionSetId = PermissionSetLST[0].Id;     
        permissionsetassignlst.add(psa1);
        }
        if(doInsert){
         insert permissionsetassignlst;
        }
        return permissionsetassignlst;
    }
    
    public static List<Group> insertgroup (Boolean doInsert , integer count)
    {
        grouplst = new  List<Group>();
         for(Integer i=1;i<=count;i++)
        { 
            Group gr = new Group();
           gr.Name = 'af_reetha';
           grouplst.add(gr);
        }
        if(doInsert){
            insert grouplst;
        }
        return grouplst;
    }
    
    public static List<GroupMember> insertgroupmem (Boolean doInsert , integer count)
    {
        groupmemlst = new  List<GroupMember>();
         for(Integer i=1;i<=count;i++)
        { 
            GroupMember gmember = new GroupMember();
             gmember.UserOrGroupId = u.Id;
            gmember.GroupId = grouplst[i-1].Id;
           groupmemlst.add(gmember);
        }
        if(doInsert){
            insert groupmemlst;
        }
        return groupmemlst;
     }
     
      public static List<AF_PO_Report__c> insertPOReport(Boolean doInsert , integer count)
    {
        poreportLst = new  List<AF_PO_Report__c>();
         for(Integer i=1;i<=count;i++)
        { 
            AF_PO_Report__c po= new AF_PO_Report__c();
            po.AF_Adaptation__c=145;
            po.AF_Agency_Name__c=AF_Constants.TEST_USER_FIRSTNAME;
            po.AF_Compound_Key__c='compondtest';
            po.AF_PO_Report_Type__c='poreport';
           poreportLst.add(po);
        }
        if(doInsert){
            insert poreportLst;
        }
        return poreportLst;
     }

}