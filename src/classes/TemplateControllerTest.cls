/**
 * Name : TemplateControllerTest 
 * Author : Accenture
 * Description : Test class used for testing the TemplateController
 * Date : 8/6/14 
 */
@isTest(SeeAllData=true)
public class TemplateControllerTest 
{ 

    public static NavigationElement__c newSideNavEle;
    /*
     *@name testGetSidebarItemsAsMenu()
     *@return void 
     *@description This method for getSidebarItemsAsMenu() In CLASS TemplateController.cls
     */
     static testMethod void  testGetSidebarItemsAsMenu()
     { 
        User stdUser = FA_createTestData.createUser('navTst1'); 
        
        FA_createTestData.setPS(stdUser.id);      
        Test.startTest();
        
        System.runAs(stdUser) 
        {
            TemplateController.NavigationItem testNavItem = new TemplateController.NavigationItem('Chatter','/apex/Chatter',true,true,'','','');
            NavigationElement__c sideNavElement1 = FA_createTestData.createSideNavEle('Help',1,'FA - Facility Manager');
            NavigationElement__c sideNavElement2 = FA_createTestData.createSideNavEle('FAQs',2,'Four_Acres_Participant_User');
            
            list<NavigationElement__c> topNavList = FA_createTestData.createTopNavEle();
            
            Test.setCurrentPage(Page.Chatter);
            TemplateController templateControllerTest  =  new  TemplateController();
             
            List<BasicMenuItem> listTest = templateControllerTest.getSidebarItemsAsMenu();
            Test.stopTest();
             System.assert(!listTest.isEmpty());
        }
    }
    /*
     *@name testGetCurrentSidebarItemName()
     *@return void 
     *@description This method for getCurrentSidebarItemName() In CLASS TemplateController.cls
     */
     static testMethod void  testGetCurrentSidebarItemName()
     { 
        User stdUser = FA_createTestData.createUser('navTst1');  
              
        Test.startTest();
        
        Test.setCurrentPage(Page.Chatter);
        TemplateController templateControllerTest  =  new  TemplateController();
        System.runAs(stdUser) 
        {
            NavigationElement__c sideNavElement1 = FA_createTestData.createSideNavEle('Help',1,'FA - Facility Manager');
            NavigationElement__c sideNavElement2 = FA_createTestData.createSideNavEle('FAQs',2,'Four_Acres_Participant_User');
            
            list<NavigationElement__c> topNavList = FA_createTestData.createTopNavEle();
            
            String stringTest = templateControllerTest.getCurrentSidebarItemName();
            Test.stopTest();
             System.assert(stringTest!=null);
        }
    }
    /*
     *@name testGetTopNavItems()
     *@return void 
     *@description This method for getTopNavItems() In CLASS TemplateController.cls
     */
     static testMethod void  testGetTopNavItems()
     { 
        User stdUser = FA_createTestData.createUser('navTst1');   
        Test.startTest();
        Test.setCurrentPage(Page.Chatter);
        TemplateController templateControllerTest  =  new  TemplateController();
        System.runAs(stdUser) 
        {
            NavigationElement__c sideNavElement1 = FA_createTestData.createSideNavEle('Help',1,'FA - Facility Manager');
            NavigationElement__c sideNavElement2 = FA_createTestData.createSideNavEle('FAQs',2,'Four_Acres_Participant_User');
            
            list<NavigationElement__c> topNavList = FA_createTestData.createTopNavEle();
            
            List<TemplateController.NavigationItem> listTest = templateControllerTest.getTopNavItems();
            Test.stopTest();
             System.assert(!listTest.isEmpty());
        }
    }
    /*
     *@name testGetCurrentTopNavItemName()
     *@return void 
     *@description This method for getCurrentTopNavItemName() In CLASS TemplateController.cls
     */
     static testMethod void  testGetCurrentTopNavItemName()
     { 
        User stdUser = FA_createTestData.createUser('navTst1');
        Test.startTest();
        Test.setCurrentPage(Page.Chatter);
        TemplateController templateControllerTest  =  new  TemplateController();
        System.runAs(stdUser) 
        {
            TemplateController.NavigationItem testNavItem = new TemplateController.NavigationItem('Chatter','/apex/Chatter',true,true,'','','');
            NavigationElement__c sideNavElement1 = FA_createTestData.createSideNavEle('Help',1,'FA - Facility Manager');
            NavigationElement__c sideNavElement2 = FA_createTestData.createSideNavEle('FAQs',2,'Four_Acres_Participant_User');
            
            list<NavigationElement__c> topNavList = FA_createTestData.createTopNavEle();
            
            String stringTest = templateControllerTest.getCurrentTopNavItemName();
            Test.stopTest();
             System.assert(stringTest!=null);
        }
    }
    /*
     *@name testcreateUserMenuItems()
     *@return void 
     *@description This method for createUserMenuItems () In CLASS TemplateController.cls
     */
     static testMethod void  testcreateUserMenuItems()
     { 
        User stdUser = FA_createTestData.createUser('navTst1');
        
        Test.startTest();
        PageReference testPage = new PageReference('/apex/Chatter');
        testPage.getHeaders().put('User-Agent', 'My windows phone');
        Test.setCurrentPage(testPage);
        TemplateController templateControllerTest  =  new  TemplateController();
        System.runAs(stdUser) 
        {
            TemplateController.NavigationItem testNavItem = new TemplateController.NavigationItem('Chatter','/apex/Chatter',true,true,'','','');
            NavigationElement__c sideNavElement1 = FA_createTestData.createSideNavEle('Help',1,'FA - Facility Manager');
            NavigationElement__c sideNavElement2 = FA_createTestData.createSideNavEle('FAQs',2,'Four_Acres_Participant_User');
            
            list<NavigationElement__c> topNavList = FA_createTestData.createTopNavEle();
            
            List<BasicMenuItem> listTest = templateControllerTest.getUserMenuItems();
            Test.stopTest();
             System.assert(!listTest.isEmpty());
        }
    }
    /*
     *@name testcreateUserFullName()
     *@return void 
     *@description This method for createUserFullName() In CLASS TemplateController.cls
     */
     static testMethod void  testcreateUserFullName()
     { 
        User stdUser = FA_createTestData.createUser('navTst1');
        
        Test.startTest();
        Test.setCurrentPage(Page.Chatter);
        TemplateController templateControllerTest  =  new  TemplateController();
        System.runAs(stdUser) 
        {
            TemplateController.NavigationItem testNavItem = new TemplateController.NavigationItem('Chatter','/apex/Chatter',true,true,'','','');
            NavigationElement__c sideNavElement1 = FA_createTestData.createSideNavEle('Help',1,'FA - Facility Manager');
            NavigationElement__c sideNavElement2 = FA_createTestData.createSideNavEle('FAQs',2,'Four_Acres_Participant_User');
            
            list<NavigationElement__c> topNavList = FA_createTestData.createTopNavEle();
            
            String stringTest = templateControllerTest.getUserFullName();
            Test.stopTest();
             System.assert(stringTest!=null);
        }
    }
    /*
     *@name testGetAvatarUrl()
     *@return void 
     *@description This method for getAvatarUrl () In CLASS TemplateController.cls
     */
     static testMethod void  testGetAvatarUrl()
     { 
        User stdUser = FA_createTestData.createUser('navTst1');
        FA_createTestData.setPS(stdUser.id);
        Test.startTest();
        Test.setCurrentPage(Page.Chatter);
        TemplateController templateControllerTest  =  new  TemplateController();
        System.runAs(stdUser) 
        {
            TemplateController.NavigationItem testNavItem = new TemplateController.NavigationItem('Chatter','/apex/Chatter',true,true,'','','');
            NavigationElement__c sideNavElement1 = FA_createTestData.createSideNavEle('Help',1,'FA - Facility Manager');
            NavigationElement__c sideNavElement2 = FA_createTestData.createSideNavEle('FAQs',2,'Four_Acres_Participant_User');
            
            list<NavigationElement__c> topNavList = FA_createTestData.createTopNavEle();
            
            String stringTest = templateControllerTest.getAvatarUrl();
            Test.stopTest();
             System.assert(stringTest!=null);
        }
    }
    /*
     *@name testGetAvatarCssClass()
     *@return void 
     *@description This method for getAvatarCssClass () In CLASS TemplateController.cls
     */
     static testMethod void  testGetAvatarCssClass()
     { 
        User stdUser = FA_createTestData.createUser('navTst1');
        
        Test.startTest();
        Test.setCurrentPage(Page.Chatter);
        TemplateController templateControllerTest  =  new  TemplateController();
        System.runAs(stdUser) 
        {
            TemplateController.NavigationItem testNavItem = new TemplateController.NavigationItem('Chatter','/apex/Chatter',true,true,'','','');
            NavigationElement__c sideNavElement1 = FA_createTestData.createSideNavEle('Help',1,'FA - Facility Manager');
            NavigationElement__c sideNavElement2 = FA_createTestData.createSideNavEle('FAQs',2,'Four_Acres_Participant_User');
            
            list<NavigationElement__c> topNavList = FA_createTestData.createTopNavEle();
            
            String stringTest = templateControllerTest.getAvatarCssClass();
            Test.stopTest();
             System.assert(stringTest!=null);
        }
    }
    /*
     *@name testGetIsUsingIosPhonegap()
     *@return void 
     *@description This method for getIsUsingIosPhonegap () In CLASS TemplateController.cls
     */
     static testMethod void  testGetIsUsingIosPhonegap()
     { 
        User stdUser = FA_createTestData.createUser('navTst1');
        
        Test.startTest();
        PageReference testPage = new PageReference('/apex/Chatter');
        testPage.getHeaders().put('User-Agent', 'My windows phone');
        Test.setCurrentPage(testPage);
        TemplateController templateControllerTest  =  new  TemplateController();
        System.runAs(stdUser) 
        {
            TemplateController.NavigationItem testNavItem = new TemplateController.NavigationItem('Chatter','/apex/Chatter',true,true,'','','');
            NavigationElement__c sideNavElement1 = FA_createTestData.createSideNavEle('Help',1,'FA - Facility Manager');
            NavigationElement__c sideNavElement2 = FA_createTestData.createSideNavEle('FAQs',2,'Four_Acres_Participant_User');
            
            list<NavigationElement__c> topNavList = FA_createTestData.createTopNavEle();
            
            Boolean booleanTest = templateControllerTest.getIsUsingIosPhonegap();
            Test.stopTest();
             System.assert(booleanTest==false);
        }
    }
    /*
     *@name testGetIsUsingAndroidPhonegap()
     *@return void 
     *@description This method for getIsUsingAndroidPhonegap () In CLASS TemplateController.cls
     */
     static testMethod void  testGetIsUsingAndroidPhonegap()
     { 
        User stdUser = FA_createTestData.createUser('navTst1');
        
        Test.startTest();
        PageReference testPage = new PageReference('/apex/Chatter');
        testPage.getHeaders().put('User-Agent', 'My windows phone');
        Test.setCurrentPage(testPage);
        TemplateController templateControllerTest  =  new  TemplateController();
        System.runAs(stdUser)
        {
            TemplateController.NavigationItem testNavItem = new TemplateController.NavigationItem('Chatter','/apex/Chatter',true,true,'','','');
            NavigationElement__c sideNavElement1 = FA_createTestData.createSideNavEle('Help',1,'FA - Facility Manager');
            NavigationElement__c sideNavElement2 = FA_createTestData.createSideNavEle('FAQs',2,'Four_Acres_Participant_User');
            
            list<NavigationElement__c> topNavList = FA_createTestData.createTopNavEle();
            
            Boolean booleanTest = templateControllerTest.getIsUsingAndroidPhonegap();
            Test.stopTest();
             System.assert(booleanTest==false);
        }
    }
}