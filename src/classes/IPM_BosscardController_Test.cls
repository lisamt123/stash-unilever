/*******************************************************
 * @Description: Test class for  IPM_BosscardController
 * @Author:Cognizant
 * @Date:05/08/2015
 * *****************************************************/
@isTest

private class IPM_BosscardController_Test{
    private static IPM_Bosscard__c ipmBosscards  = new IPM_Bosscard__c();
    private static User loginUser = new User();
    private static User u = new User();
    private static IPM_Company_Card__c compCard;
    private static IPM_User_Profile__c up;
    private static Ipm_BosscardController sic;
    private static final String TEST_CONTENT =  'fox jumped over a lazy dog';
    private static final String MDOCATEGORY_NAME='Household Care';
    public static IPM_SoqlUtilities soqlUtility;
  private static final string PLATFORM_LASTNAME='PLATFORM_USER';
  private static final string IPMUSER_LASTNAME ='IPMUSER_LASTNAME';
  private static final string IPM_COMPANYCARD='Test bosscard company card';
  private static string bosscarName='Test Boss card';
    /*********************************************************************
    * @Description: This method is used to initialize data for test class
    * *******************************************************************/
    @TestSetup static  void initializeData(){
      
        //Insert User
        u = IPM_TestFactory_Helper.createUser(false);
        insert u;
        loginUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);//only created by user can do update operation
        
        List<User>userList=[SELECT lastName FROM user WHERE id=:loginUser.id LIMIT 1];
        System.AssertEquals(userList[0].lastName, loginUser.lastName,'user name is:'+userList[0].lastName);//positive test
        List<User>userLists=[SELECT lastName FROM user WHERE id=:u.id LIMIT 1];
        System.AssertEquals(userLists[0].lastName, u.lastName,'your user name is:'+userLists[0].lastName);//positive test
        
        
        
        //Insert Bosscard
        system.runAs(loginUser){
            
            //Insert Company Card
            compCard=IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            compCard.Name=IPM_COMPANYCARD;
            compCard.IPM_Managed_Category__c=MDOCATEGORY_NAME;
            compCard.IPM_Currency__c='10';
            compCard.IPM_TxtGeographical_Scope__c='Global';
            insert compCard;
            //Insert Company Card
            IPM_Company_Card__c regincompCard=IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            regincompCard.Name='Test bosscard company card2';
            regincompCard.IPM_Managed_Category__c=MDOCATEGORY_NAME;
            regincompCard.IPM_Currency__c='10';
            regincompCard.IPM_TxtGeographical_Scope__c='Africa';
            regincompCard.IPM_Business_Partner__c= LoginUser.id;
            insert regincompCard;
            List<IPM_Company_Card__c>companyCList=[SELECT Name FROM IPM_Company_Card__c WHERE ID=:compCard.id LIMIT 1];
            System.AssertEquals(companyCList[0].Name,compCard.Name, 'company card name is:'+companyCList[0].Name); //Positive test
            
            //Insert User Profile
            up=IPM_TestFactory_Helper.createUserProfile(false);
            up.IPM_User__c=loginUser.Id; 
            up.IPM_Company_Card__c= compCard.id;
            up.IPM_User_Function__c='Project Leader';
            up.IPM_User_Category__c=MDOCATEGORY_NAME;
            insert up;
            List<IPM_User_Profile__c>userProfileCList=[SELECT IPM_User__c FROM IPM_User_Profile__c WHERE ID=:up.id LIMIT 1];
            System.AssertEquals(userProfileCList[0].IPM_User__c,loginUser.Id, 'user profile user name is:'+userProfileCList[0].IPM_User__c); //Positive test
        
            
            ipmBosscards = IPM_TestFactory_Helper.createIPMBosscard(false);
            ipmBosscards.IPM_Bosscard_Status__c = IPM_ConstantUtils.STATUS_IN_PROGRESS;
            ipmBosscards.IPM_Company_Card__c=compCard.id;
            ipmBosscards.IPM_BosscardName__c=bosscarName;
            insert ipmBosscards;
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Bosscard_Status__c FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertEquals(bossList[0].IPM_Bosscard_Status__c,IPM_ConstantUtils.STATUS_IN_PROGRESS, 'Bosscard status is:'+bossList[0].IPM_Bosscard_Status__c); //Positive test
            
            //Insert ProductCategory
            MDO_Category__c proCategory = IPM_TestFactory_Helper.createMDOCategory(false);
            proCategory.Name = MDOCATEGORY_NAME;
            insert proCategory;
            List<MDO_Category__c>mdoCateList=[SELECT Name from MDO_Category__c WHERE id=:proCategory.id LIMIT 1];
            system.assertEquals(mdoCateList[0].Name,proCategory.Name,'Category name is:'+mdoCateList[0].Name);
            
            //Insert Geography
            MDO_Geography__c geo = IPM_TestFactory_Helper.createMDOGeography(false);
            geo.Name='TestRegion';
            geo.geography_type__c='Cluster';
            Insert geo;
            
            List<MDO_Geography__c>mdoGeoList=[SELECT Name,geography_type__c from MDO_Geography__c WHERE id=:geo.id LIMIT 1];
            system.assertEquals(mdoGeoList[0].Name,geo.Name,'Category name is:'+mdoGeoList[0].Name);
            system.assertEquals(mdoGeoList[0].geography_type__c,geo.geography_type__c,'Geograpgy type is:'+mdoGeoList[0].geography_type__c);
            
            //Insert Brand Position
            MDO_BrandPosition__c bPosition = IPM_TestFactory_Helper.createMDOBrandPosition(false);
            bPosition.Name = 'TestBrandPosition';
            bPosition.status__c = 'active';
            insert bPosition;
            List<MDO_BrandPosition__c>mdoBrandPList=[SELECT Name,status__c from MDO_BrandPosition__c WHERE id=:bPosition.id LIMIT 1];
            system.assertEquals(mdoBrandPList[0].Name,bPosition.Name,'Category name is:'+mdoBrandPList[0].Name);
            
            
            
            //Insert Brand Positions
            MDO_BrandPositions__c  brandPosition =IPM_TestFactory_Helper.createMDOBrandPositions(false);
            brandPosition.product_category_id__c=ProCategory.id;
            brandPosition.geo_id__c=geo.id;
            insert brandPosition;
            
            List<MDO_BrandPositions__c>mdoBrandPsList=[SELECT product_category_id__c,geo_id__c from MDO_BrandPositions__c WHERE id=:brandPosition.id LIMIT 1];
            system.assertEquals(mdoBrandPsList[0].product_category_id__c,ProCategory.id,'product Category id is:'+mdoBrandPsList[0].product_category_id__c);
            system.assertEquals(mdoBrandPsList[0].geo_id__c,geo.id,'Geo id is:'+mdoBrandPsList[0].geo_id__c);
            
        }
        //call bosscard page
        PageReference pageRef = Page.IPM_Bosscard;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put('id', ipmBosscards.id);
        ApexPages.StandardController sc = new ApexPages.standardController(ipmBosscards);
        sic = new Ipm_BosscardController (sc);
        
        
    }
    
    /********************************************************************
    * @Description: This method is used to call Page referecnce         
    * *******************************************************************/
    
    static void callPageReference(){
      
      ipmBosscards=[SELECT id,Name,IPM_Company_Card__c FROM IPM_Bosscard__c WHERE IPM_BosscardName__c=:bosscarName LIMIT 1];
      loginUser=[SELECT ID FROM USER WHERE LastName=:PLATFORM_LASTNAME LIMIT 1]; 
      u=[SELECT ID FROM USER WHERE LastName=:IPMUSER_LASTNAME LIMIT 1];
    compCard=[SELECT ID,Name,IPM_TxtGeographical_Scope__c FROM IPM_Company_Card__c WHERE Name=:IPM_COMPANYCARD LIMIT 1]; 
      PageReference pageRef = Page.IPM_Bosscard;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put('id', ipmBosscards.id);
        ApexPages.StandardController sc = new ApexPages.standardController(ipmBosscards);
        sic = new Ipm_BosscardController (sc);
    
    }
    
    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and getListOfQuarter method of the main class           
    * *******************************************************************/
    static testMethod void testGetListOfQuarter(){

    callPageReference();
        Test.startTest();
        soqlUtility = new IPM_SoqlUtilities();
        IPM_SoqlUtilities.IPM_ProjectID='';
        IPM_SoqlUtilities.getBosscardMap();
        
        system.RunAs(loginUser){
            List<SelectOption>quarterList=sic.getListOfQuarter();
            system.assertEquals(quarterList.isEmpty(),false,'List of quarter should not be empty');//positive test
        }
        Test.stopTest();     
    }
    
    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and getBrandPos method of the main class           
    * *******************************************************************/
    static testMethod void testGetBrandPos(){
        
    callPageReference();
        Test.startTest();
        system.runAs(LoginUser){
            sic.selCat=MDOCATEGORY_NAME;
            sic.geoScope_STR=compCard.IPM_TxtGeographical_Scope__c;
            sic.REType=IPM_ConstantUtils.COMPANY_CARD_GLOBAL;
            List<Selectoption> optns=sic.getBrandPos(); 
            system.assert(!optns.isEmpty(),'brand positioning list can not be empty');//positive test
        }
        Test.stopTest();  
        
    }  
    
    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and getCategory method of the main class           
    * *******************************************************************/
    static testMethod void testGetCategory(){

    callPageReference();
        Test.startTest();
        system.runAs(LoginUser){
            sic.selectedCompany=ipmBosscards.IPM_Company_Card__c;
            List<SelectOption> lstOptions = sic.getCategory();
            System.assert(!lstOptions.isEmpty(),'category list can not be empty');//positive test
        }
        Test.stopTest();
    }
    
    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and getAllcompanycard method of the main class           
    * *******************************************************************/
    
    static testMethod void testGetAllcompanycard(){

    callPageReference();
        Test.startTest();
        system.runAs(LoginUser){
            List<SelectOption> lstOptions = sic.getAllcompanycard();
            System.assert(!lstOptions.isEmpty(),'company card list can not be empty');//positive test
        }
        Test.stopTest();  
    } 

    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and save method of the main class           
    * *******************************************************************/  
    static testMethod void testSave(){

    callPageReference();
        Test.startTest();
        system.runAs(LoginUser){
            sic.bosscard.IPM_BosscardName__c = 'TestWithBoss';
            sic.bosscard.IPM_Assumptions__c = TEST_CONTENT;
            sic.bosscard.IPM_Background__c =TEST_CONTENT;
            sic.bosscard.IPM_Constraints__c = TEST_CONTENT;
            sic.bosscard.IPM_Consumer_Need__c=TEST_CONTENT;
            sic.bosscard.IPM_Deliverables__c=TEST_CONTENT;
            sic.bosscard.IPM_Potential_Business_Opportunity__c=TEST_CONTENT;
            sic.bosscard.IPM_Resources__c=TEST_CONTENT;
            sic.bosscard.IPM_Scope__c=TEST_CONTENT;
            sic.bosscard.IPM_Sustainibility__c=TEST_CONTENT;
            sic.bosscard.IPM_Bosscard_Logo__c= '/servlet/servlet.FileDownload?file='; 
            sic.bosscard.IPM_Gate_Keeper__c=LoginUser.id;
            sic.selectedCompany=compCard.id;
            sic.selCat=MDOCATEGORY_NAME;
            sic.save();
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Category__c FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertEquals(bossList[0].IPM_Category__c,sic.selCat, 'Bosscard category is:'+bossList[0].IPM_Category__c); //Positive test
            sic.selCat='';
            sic.bosscard.IPM_BosscardName__c = '##%$%#$';
            sic.save();
            List<IPM_Bosscard__c>bossLists=[SELECT IPM_Category__c FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertNotEquals(bossLists[0].IPM_Category__c,sic.selCat, 'Bosscard category is:'+bossList[0].IPM_Category__c); //Positive test
            sic.bosscard.IPM_BosscardName__c=null;
            sic.selectedCompany=null;
            sic.save();
             
        }
        //read only user
        system.runAs(u){
            sic.bosscard.IPM_BosscardName__c = 'TestBossC';
            sic.bosscard.IPM_Assumptions__c = TEST_CONTENT;
            sic.bosscard.IPM_Background__c =TEST_CONTENT;
            sic.bosscard.IPM_Constraints__c = TEST_CONTENT;
            sic.bosscard.IPM_Consumer_Need__c=TEST_CONTENT;
            sic.bosscard.IPM_Deliverables__c=TEST_CONTENT;
            sic.bosscard.IPM_Potential_Business_Opportunity__c=TEST_CONTENT;
            sic.bosscard.IPM_Resources__c=TEST_CONTENT;
            sic.bosscard.IPM_Scope__c=TEST_CONTENT;
            sic.bosscard.IPM_Sustainibility__c=TEST_CONTENT;
            sic.bosscard.IPM_Bosscard_Logo__c= '/servlet/servlet.FileDownload?file='; 
            sic.bosscard.IPM_Gate_Keeper__c=LoginUser.id;
            sic.selectedCompany=compCard.id;
            sic.selCat=MDOCATEGORY_NAME;
            sic.save();
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Category__c FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertEquals(bossList.isEmpty(),true, 'no access to bosscard'); //Negative test
            
        }
        Test.stopTest();  
    }  
    
    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and PDFAfterApproved method of the main class           
    * *******************************************************************/
    
    static testMethod void testPDFAfterApproved(){

    callPageReference();
        Test.startTest();
        system.runAs(LoginUser){
            sic.bosscard.IPM_BosscardName__c = 'TestBossPDF';
            sic.bosscard.IPM_Gate_Keeper__c=LoginUser.id;
            sic.selectedCompany=compCard.id;
            sic.selCat=MDOCATEGORY_NAME;
            sic.exportPDFBooln=true;
            sic.PDFAfterApproved();//generate bosscard PDF with saving data
            sic.bosscardData(ipmBosscards.Id);
            List<IPM_Bosscard__c>bossList=[SELECT IPM_BosscardName__c FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertEquals(bossList[0].IPM_BosscardName__c,sic.bosscard.IPM_BosscardName__c, 'Bosscard name is:'+bossList[0].IPM_BosscardName__c); //Positive test
            
             
        }
        Test.stopTest();  
    }
    
    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and removeApprover method of the main class           
    * *******************************************************************/
    
    static testMethod void testremoveApprover(){

    callPageReference();
        Test.startTest();
        system.runAs(LoginUser){
            sic.removeApprover();
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Gate_Keeper__c FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertNotEquals(bossList[0].IPM_Gate_Keeper__c,LoginUser.id, 'Bosscard Name is:'+bossList[0].IPM_Gate_Keeper__c); //Positive test
        }
        system.runAs(u){
            sic.removeApprover();
            List<IPM_Bosscard__c>bossLists=[SELECT IPM_Gate_Keeper__c FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertEquals(bossLists.isEmpty(),true,'current user does not having access'); //Negative test
        }
        Test.stopTest();  
    }
    
    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and removeBosscardLogo method of the main class           
    * *******************************************************************/
    
    static testMethod void removeBosscardLogo(){

    callPageReference();
    Test.startTest();
        system.runAs(LoginUser){
            sic.bossId='';
            sic.showMsg();
            sic.removeBosscardLogo();
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Bosscard_Logo__c FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertEquals(bossList[0].IPM_Bosscard_Logo__c,null, 'Bosscard logo should be:'+bossList[0].IPM_Bosscard_Logo__c); //Positive test
            
       }
       //Read only user
       system.runAs(u){
            sic.bossId='';
            sic.showMsg();
            sic.removeBosscardLogo();
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Bosscard_Logo__c FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertEquals(bossList.isEmpty(),true, 'read access to bosscard'); //Negative test
            
       }
      Test.stopTest();  
    }
    
    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and removeBosscardLogo method of the main class           
    * *******************************************************************/
    
    static testMethod void testCancelBosscard(){

        callPageReference();
        
    Test.startTest();
        system.runAs(LoginUser){
            sic.bosscard.IPM_IsSaved__c=true;
            sic.cancelBosscard();
            List<IPM_Bosscard__c>bosscList=[SELECT id FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertEquals(bosscList.isEmpty(),false, 'Bosscard should not get deleted'); //Positive test
            
            sic.bosscard.IPM_IsSaved__c=false;
            sic.cancelBosscard();
            List<IPM_Bosscard__c>bossList=[SELECT id FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertEquals(bossList.isEmpty(),true, 'Bosscard should get deleted'); //Positive test
       } 
       //read only user
       system.runAs(u){
            sic.bosscard.IPM_IsSaved__c=false;
            sic.cancelBosscard();
            List<IPM_Bosscard__c>bossLists=[SELECT IPM_Gate_Keeper__c FROM IPM_Bosscard__c WHERE ID=:ipmBosscards.id LIMIT 1];
            System.AssertEquals(bossLists.isEmpty(),true,'current user does not having access'); //Negative test
        }
      Test.stopTest();  
    }
    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and DeleteBosscard method of the main class           
    * *******************************************************************/
    static testMethod void testDeleteBosscard(){

    callPageReference();
        Test.startTest();
        system.runAs(LoginUser){
            id projectid=IPM_BosscardController.DeleteBosscard(ipmBosscards.id);
            List<IPM_Project__c>projectLists=[SELECT id FROM IPM_Project__c WHERE ID=:projectid LIMIT 1];
            System.AssertEquals(projectLists[0].id,projectid,'Project id is:'+projectLists[0].id); //Positive test
            
        }
        Test.stopTest();    
    }
    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and getIpmuserType method of the main class           
    * *******************************************************************/
    static testMethod void testGetIpmuserType(){

    callPageReference();
        Test.startTest();
        system.runAs(LoginUser){
            sic.getIpmuserType();
            System.assertEquals(true, sic.isEditable,'User not have an edit access');//positive test
            sic.bosscard.IPM_Bosscard_Status__c=IPM_ConstantUtils.IPM_BOSS_INPROGRESS;
            sic.isEditable=true;
            sic.isPL=true;
            sic.renderedConditions();
      sic.bosscard.IPM_Is_Accepted__c=true;
            sic.bosscard.IPM_Bosscard_Status__c=IPM_ConstantUtils.IPM_BOSS_NOT_APPROVED;
            sic.isEditable=false;
            sic.renderedConditions();
            sic.bosscard.IPM_Bosscard_Logo_Id__c=null;
            sic.renderedConditions();
            sic.isEditable=true;
            sic.bosscard.IPM_Gate_Keeper__c=null;
            sic.renderedConditions();
            sic.bosscard.IPM_Bosscard_Status__c=IPM_ConstantUtils.IPM_BOSS_DISCARD;
            sic.renderedConditions();
            sic.bosscard.IPM_Bosscard_Status__c=IPM_ConstantUtils.IPM_BOSS_INPROGRESS;
            sic.bosscard.IPM_Bosscard_Status__c=IPM_ConstantUtils.IPM_BOSS_NOT_APPROVED;
            sic.renderedConditions();
            sic.bosscard.IPM_Bosscard_Status__c=IPM_ConstantUtils.IPM_BOSS_APPROVED;
            sic.renderedConditions();
            system.assertEquals(sic.changeBossStatusCCS,IPM_ConstantUtils.IPM_BOSS_CSS_COMPLETED,'Bosscard status is not completed');
            
           
        }
        Test.stopTest();  
    }
   /********************************************************************************
    *@Description : For hidding the save message.
    *********************************************************************************/  
    static testMethod void testhideSaveMsg() {

    callPageReference();
        Test.startTest();
        system.runAs(LoginUser){
            sic.searchprojectpahse(); 
            sic.getBrandposition();
            sic.saveMsg=true;
            sic.hideSaveMsg();//save message should be false
            System.assertEquals(sic.saveMsg,false,'Show the Bosscard Save Message');//positive test
        }
        Test.stopTest(); 
        
    }
   /********************************************************************************
    *@Description : For Duplicate bosscard
    *********************************************************************************/  
    static testMethod void testsearchDuplicateBosscard() {

    callPageReference();
        Test.startTest();
        system.runAs(LoginUser){
            sic.bosscardId=ipmBosscards.id;
            sic.bosscard.IPM_BosscardName__c='TestwithBoss';
            sic.searchDuplicateBosscard();//check for duplicate bosscard name
            System.assertEquals(sic.isBosscardNameBlank,true,'Bosscard Name is not Blank');//positive test
            sic.isBosscardNameBlank=false;
            sic.hideBosscardSuggetion();
            System.assertEquals(sic.isBosscardNameBlank,true,'Bosscard Name is not Blank');//positive test
        } 
        Test.stopTest(); 
        
    }
    
    
}