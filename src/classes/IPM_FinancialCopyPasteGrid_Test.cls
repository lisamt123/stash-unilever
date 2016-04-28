/*****************************************************************************************************************************
   @Author :Nandini KV
   @name : IPM_FinancialCopyPasteGrid
   @CreateDate : 02/06/2015
   @Description : This is a test class for IPM_FinancialCopyPasteGrid Page, 
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/

@isTest
public class IPM_FinancialCopyPasteGrid_Test {
    
    
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static List<IPM_Financial_Year__c> lstFinancialYear=new List<IPM_Financial_Year__c>();
    public static User ipmUser = new User();
    public static final String Global_STR = 'Global';
    public static final String Regional_STR = 'Regional';
    public static final String Local_STR = 'Local';
    public static final String sust_3 = '3' ;
    public static final String input1 = '[[7,1,"","Total Tons"],[4,4,"",""],[4,5,"",""],[4,6,"",""],[4,7,"",""],[4,8,"",""],[4,9,"",""],[4,10,"",""],[4,11,"",""],[4,12,"",""],[4,13,"",""],[4,14,"",""]]';
    public static final String input2 = '[[7,1,"","Total \'000 Units"],[4,4,"","5"],[4,5,"","6"],[4,6,"","7"],[4,7,"","9"],[4,8,"",""],[4,9,"",""],[4,10,"",""],[4,11,"",""],[4,12,"",""],[4,13,"",""],[4,14,"",""],[5,4,"","99.0%"],[5,5,"","1110.0%"],[5,6,"","2121.0%"],[5,7,"","3132.0%"],[5,8,"","4143.0%"],[5,9,"","5154.0%"],[5,10,"","6165.0%"],[5,11,"","7176.0%"],[5,12,"","8187.0%"],[5,13,"","9198.0%"],[5,14,"","10209.0%"],[6,4,"","110.0%"],[6,5,"","2121.0%"],[6,6,"","4132.0%"],[6,7,"","6143.0%"],[6,8,"","8154.0%"],[6,9,"","10165.0%"],[6,10,"","12176.0%"],[6,11,"","14187.0%"],[6,12,"","16198.0%"],[6,13,"","18209.0%"],[6,14,"","20220.0%"],[7,1,""," Total Tons "],[7,4,"","121.0%"],[7,5,"","3132.0%"],[7,6,"","6143.0%"],[7,7,"","9154.0%"],[7,8,"","12165.0%"],[7,9,"","15176.0%"],[7,10,"","18187.0%"],[7,11,"","21198.0%"],[7,12,"","24209.0%"],[7,13,"","27220.0%"],[7,14,"","30231.0%"],[8,4,"","132.0%"],[8,5,"","4143.0%"],[8,6,"","8154.0%"],[8,7,"","12165.0%"],[8,8,"","16176.0%"],[8,9,"","20187.0%"],[8,10,"","24198.0%"],[8,11,"","28209.0%"],[8,12,"","32220.0%"],[8,13,"","36231.0%"],[8,14,"","40242.0%"],[9,4,"","143.0%"],[9,5,"","5154.0%"],[9,6,"","10165.0%"],[9,7,"","15176.0%"],[9,8,"","20187.0%"],[9,9,"","25198.0%"],[9,10,"","30209.0%"],[9,11,"","35220.0%"],[9,12,"","40231.0%"],[9,13,"","45242.0%"],[9,14,"","50253.0%"],[10,4,"","154.0%"],[10,5,"","6165.0%"],[10,6,"","12176.0%"],[10,7,"","18187.0%"],[10,8,"","24198.0%"],[10,9,"","30209.0%"],[10,10,"","36220.0%"],[10,11,"","42231.0%"],[10,12,"","48242.0%"],[10,13,"","54253.0%"],[10,14,"","60264.0%"],[11,4,"","165.0%"],[11,5,"","7176.0%"],[11,6,"","14187.0%"],[11,7,"","21198.0%"],[11,8,"","28209.0%"],[11,9,"","35220.0%"],[11,10,"","42231.0%"],[11,11,"","49242.0%"],[11,12,"","56253.0%"],[11,13,"","63264.0%"],[11,14,"","70275.0%"],[12,4,"","176.0%"],[12,5,"","8187.0%"],[12,6,"","16198.0%"],[12,7,"","24209.0%"],[12,8,"","32220.0%"],[12,9,"","40231.0%"],[12,10,"","48242.0%"],[12,11,"","56253.0%"],[12,12,"","64264.0%"],[12,13,"","72275.0%"],[12,14,"","80286.0%"],[13,4,"","187.0%"],[13,5,"","9198.0%"],[13,6,"","18209.0%"],[13,7,"","27220.0%"],[13,8,"","36231.0%"],[13,9,"","45242.0%"],[13,10,"","54253.0%"],[13,11,"","63264.0%"],[13,12,"","72275.0%"],[13,13,"","81286.0%"],[13,14,"","90297.0%"],[15,4,"",""],[15,5,"",""],[15,6,"",""],[15,7,"",""],[15,8,"",""],[15,9,"",""],[15,10,"",""],[15,11,"",""],[15,12,"","200.0%"],[15,13,"",""],[15,14,"",""],[16,4,"",""],[16,5,"",""],[16,6,"",""],[16,7,"",""],[16,8,"",""],[16,9,"",""],[16,10,"",""],[16,11,"",""],[16,12,"","0.0%"],[16,13,"",""],[16,14,"",""],[17,4,"",""],[17,5,"",""],[17,6,"",""],[17,7,"",""],[17,8,"",""],[17,9,"",""],[17,10,"",""],[17,11,"",""],[17,12,"","200.0%"],[17,13,"",""],[17,14,"",""],[19,5,"",""],[19,8,"",0],[19,10,"",""],[19,11,"",""],[19,12,"",""],[19,13,"",""],[19,14,"",""],[20,5,"",""],[20,8,"",0],[20,10,"",""],[20,11,"",""],[20,12,"",""],[20,13,"",""],[20,14,"",""],[21,5,"",""],[21,10,"",""],[21,11,"",""],[21,12,"",""],[21,13,"",""],[21,14,"",""],[28,4,"",200],[28,5,"",201],[28,6,"",202],[28,7,"",203],[28,8,"",204],[28,9,"",205],[28,10,"",206],[28,11,"",207],[28,12,"",208],[28,13,"",209],[28,14,"",210],[29,4,"",200],[29,5,"",201],[29,6,"",202],[29,7,"",203],[29,8,"",204],[29,9,"",205],[29,10,"",206],[29,11,"",207],[29,12,"",208],[29,13,"",209],[29,14,"",210],[30,4,"",200],[30,5,"",201],[30,6,"",202],[30,7,"",203],[30,8,"",204],[30,9,"",205],[30,10,"",206],[30,11,"",207],[30,12,"",208],[30,13,"",209],[30,14,"",210],[31,1,""," Total Tons "],[31,4,"",200],[31,5,"",201],[31,6,"",202],[31,7,"",203],[31,8,"",204],[31,9,"",205],[31,10,"",206],[31,11,"",207],[31,12,"",208],[31,13,"",209],[31,14,"",210],[32,4,"",200],[32,5,"",201],[32,6,"",202],[32,7,"",203],[32,8,"",204],[32,9,"",205],[32,10,"",206],[32,11,"",207],[32,12,"",208],[32,13,"",209],[32,14,"",210],[33,4,"",200],[33,5,"",201],[33,6,"",202],[33,7,"",203],[33,8,"",204],[33,9,"",205],[33,10,"",206],[33,11,"",207],[33,12,"",208],[33,13,"",209],[33,14,"",210],[34,4,"",200],[34,5,"",201],[34,6,"",202],[34,7,"",203],[34,8,"",204],[34,9,"",205],[34,10,"",206],[34,11,"",207],[34,12,"",208],[34,13,"",209],[34,14,"",210],[35,4,"",200],[35,5,"",201],[35,6,"",202],[35,7,"",203],[35,8,"",204],[35,9,"",205],[35,10,"",206],[35,11,"",207],[35,12,"",208],[35,13,"",209],[35,14,"",210],[36,4,"",200],[36,5,"",201],[36,6,"",202],[36,7,"",203],[36,8,"",204],[36,9,"",205],[36,10,"",206],[36,11,"",207],[36,12,"",208],[36,13,"",209],[36,14,"",210],[37,4,"",200],[37,5,"",201],[37,6,"",202],[37,7,"",203],[37,8,"",204],[37,9,"",205],[37,10,"",206],[37,11,"",207],[37,12,"",208],[37,13,"",209],[37,14,"",210]]';
    public static final String input3 ='[[4,4,"","5"],[4,5,"","6"],[4,6,"","7"],[4,7,"","9"],[4,8,"",""],[4,9,"",""],[4,10,"",""],[4,11,"",""],[4,12,"",""],[4,13,"",""],[4,14,"",""],[5,4,"","99.0%"],[5,5,"","1110.0%"],[5,6,"","2121.0%"],[5,7,"","3132.0%"],[5,8,"","4143.0%"],[5,9,"","5154.0%"],[5,10,"","6165.0%"],[5,11,"","7176.0%"],[5,12,"","8187.0%"],[5,13,"","9198.0%"],[5,14,"","10209.0%"],[6,4,"","110.0%"],[6,5,"","2121.0%"],[6,6,"","4132.0%"],[6,7,"","6143.0%"],[6,8,"","8154.0%"],[6,9,"","10165.0%"],[6,10,"","12176.0%"],[6,11,"","14187.0%"],[6,12,"","16198.0%"],[6,13,"","18209.0%"],[6,14,"","20220.0%"],[7,1,""," Total Tons "],[7,4,"","121.0%"],[7,5,"","3132.0%"],[7,6,"","6143.0%"],[7,7,"","9154.0%"],[7,8,"","12165.0%"],[7,9,"","15176.0%"],[7,10,"","18187.0%"],[7,11,"","21198.0%"],[7,12,"","24209.0%"],[7,13,"","27220.0%"],[7,14,"","30231.0%"],[8,4,"","132.0%"],[8,5,"","4143.0%"],[8,6,"","8154.0%"],[8,7,"","12165.0%"],[8,8,"","16176.0%"],[8,9,"","20187.0%"],[8,10,"","24198.0%"],[8,11,"","28209.0%"],[8,12,"","32220.0%"],[8,13,"","36231.0%"],[8,14,"","40242.0%"],[9,4,"","143.0%"],[9,5,"","5154.0%"],[9,6,"","10165.0%"],[9,7,"","15176.0%"],[9,8,"","20187.0%"],[9,9,"","25198.0%"],[9,10,"","30209.0%"],[9,11,"","35220.0%"],[9,12,"","40231.0%"],[9,13,"","45242.0%"],[9,14,"","50253.0%"],[10,4,"","154.0%"],[10,5,"","6165.0%"],[10,6,"","12176.0%"],[10,7,"","18187.0%"],[10,8,"","24198.0%"],[10,9,"","30209.0%"],[10,10,"","36220.0%"],[10,11,"","42231.0%"],[10,12,"","48242.0%"],[10,13,"","54253.0%"],[10,14,"","60264.0%"],[11,4,"","165.0%"],[11,5,"","7176.0%"],[11,6,"","14187.0%"],[11,7,"","21198.0%"],[11,8,"","28209.0%"],[11,9,"","35220.0%"],[11,10,"","42231.0%"],[11,11,"","49242.0%"],[11,12,"","56253.0%"],[11,13,"","63264.0%"],[11,14,"","70275.0%"],[12,4,"","176.0%"],[12,5,"","8187.0%"],[12,6,"","16198.0%"],[12,7,"","24209.0%"],[12,8,"","32220.0%"],[12,9,"","40231.0%"],[12,10,"","48242.0%"],[12,11,"","56253.0%"],[12,12,"","64264.0%"],[12,13,"","72275.0%"],[12,14,"","80286.0%"],[13,4,"","187.0%"],[13,5,"","9198.0%"],[13,6,"","18209.0%"],[13,7,"","27220.0%"],[13,8,"","36231.0%"],[13,9,"","45242.0%"],[13,10,"","54253.0%"],[13,11,"","63264.0%"],[13,12,"","72275.0%"],[13,13,"","81286.0%"],[13,14,"","90297.0%"],[15,4,"",""],[15,5,"",""],[15,6,"",""],[15,7,"",""],[15,8,"",""],[15,9,"",""],[15,10,"",""],[15,11,"",""],[15,12,"","200.0%"],[15,13,"",""],[15,14,"",""],[16,4,"",""],[16,5,"",""],[16,6,"",""],[16,7,"",""],[16,8,"",""],[16,9,"",""],[16,10,"",""],[16,11,"",""],[16,12,"","0.0%"],[16,13,"",""],[16,14,"",""],[17,4,"",""],[17,5,"",""],[17,6,"",""],[17,7,"",""],[17,8,"",""],[17,9,"",""],[17,10,"",""],[17,11,"",""],[17,12,"","200.0%"],[17,13,"",""],[17,14,"",""],[19,5,"",""],[19,8,"",0],[19,10,"",""],[19,11,"",""],[19,12,"",""],[19,13,"",""],[19,14,"",""],[20,5,"",""],[20,8,"",0],[20,10,"",""],[20,11,"",""],[20,12,"",""],[20,13,"",""],[20,14,"",""],[21,5,"",""],[21,10,"",""],[21,11,"",""],[21,12,"",""],[21,13,"",""],[21,14,"",""],[28,4,"",200],[28,5,"",201],[28,6,"",202],[28,7,"",203],[28,8,"",204],[28,9,"",205],[28,10,"",206],[28,11,"",207],[28,12,"",208],[28,13,"",209],[28,14,"",210],[29,4,"",200],[29,5,"",201],[29,6,"",202],[29,7,"",203],[29,8,"",204],[29,9,"",205],[29,10,"",206],[29,11,"",207],[29,12,"",208],[29,13,"",209],[29,14,"",210],[30,4,"",200],[30,5,"",201],[30,6,"",202],[30,7,"",203],[30,8,"",204],[30,9,"",205],[30,10,"",206],[30,11,"",207],[30,12,"",208],[30,13,"",209],[30,14,"",210],[31,1,""," Total Tons "],[31,4,"",200],[31,5,"",201],[31,6,"",202],[31,7,"",203],[31,8,"",204],[31,9,"",205],[31,10,"",206],[31,11,"",207],[31,12,"",208],[31,13,"",209],[31,14,"",210],[32,4,"",200],[32,5,"",201],[32,6,"",202],[32,7,"",203],[32,8,"",204],[32,9,"",205],[32,10,"",206],[32,11,"",207],[32,12,"",208],[32,13,"",209],[32,14,"",210],[33,4,"",200],[33,5,"",201],[33,6,"",202],[33,7,"",203],[33,8,"",204],[33,9,"",205],[33,10,"",206],[33,11,"",207],[33,12,"",208],[33,13,"",209],[33,14,"",210],[34,4,"",200],[34,5,"",201],[34,6,"",202],[34,7,"",203],[34,8,"",204],[34,9,"",205],[34,10,"",206],[34,11,"",207],[34,12,"",208],[34,13,"",209],[34,14,"",210],[35,4,"",200],[35,5,"",201],[35,6,"",202],[35,7,"",203],[35,8,"",204],[35,9,"",205],[35,10,"",206],[35,11,"",207],[35,12,"",208],[35,13,"",209],[35,14,"",210],[36,4,"",200],[36,5,"",201],[36,6,"",202],[36,7,"",203],[36,8,"",204],[36,9,"",205],[36,10,"",206],[36,11,"",207],[36,12,"",208],[36,13,"",209],[36,14,"",210],[37,4,"",200],[37,5,"",201],[37,6,"",202],[37,7,"",203],[37,8,"",204],[37,9,"",205],[37,10,"",206],[37,11,"",207],[37,12,"",208],[37,13,"",209],[37,14,"",210]]';
    public static final String input4 ='[[7,1,"","Total \'000 Units"],[7,4,"","121.0%"],[7,5,"","1"],[7,6,"","6143.0%"],[7,7,"","9154.0%"],[7,8,"","12165.0%"],[7,9,"","15176.0%"],[7,10,"","18187.0%"],[7,11,"","21198.0%"],[7,12,"","24209.0%"],[7,13,"","27220.0%"],[7,14,"","30231.0%"],[8,4,"","132.0%"],[8,5,"","4143.0%"],[8,6,"","8154.0%"],[8,7,"","12165.0%"],[8,8,"","16176.0%"],[8,9,"","20187.0%"],[8,10,"","24198.0%"],[8,11,"","28209.0%"],[8,12,"","32220.0%"],[8,13,"","36231.0%"],[8,14,"","40242.0%"],[9,4,"","143.0%"],[9,5,"","5154.0%"],[9,6,"","10165.0%"],[9,7,"","15176.0%"],[9,8,"","20187.0%"],[9,9,"","25198.0%"],[9,10,"","30209.0%"],[9,11,"","35220.0%"],[9,12,"","40231.0%"],[9,13,"","45242.0%"],[9,14,"","50253.0%"],[10,4,"","154.0%"],[10,5,"","6165.0%"],[10,6,"","12176.0%"],[10,7,"","18187.0%"],[10,8,"","24198.0%"],[10,9,"","30209.0%"],[10,10,"","36220.0%"],[10,11,"","42231.0%"],[10,12,"","48242.0%"],[10,13,"","54253.0%"],[10,14,"","60264.0%"],[11,4,"","165.0%"],[11,5,"","7176.0%"],[11,6,"","14187.0%"],[11,7,"","21198.0%"],[11,8,"","28209.0%"],[11,9,"","35220.0%"],[11,10,"","42231.0%"],[11,11,"","49242.0%"],[11,12,"","56253.0%"],[11,13,"","63264.0%"],[11,14,"","70275.0%"],[12,4,"","176.0%"],[12,5,"","8187.0%"],[12,6,"","16198.0%"],[12,7,"","24209.0%"],[12,8,"","32220.0%"],[12,9,"","40231.0%"],[12,10,"","48242.0%"],[12,11,"","56253.0%"],[12,12,"","64264.0%"],[12,13,"","72275.0%"],[12,14,"","80286.0%"],[13,4,"","187.0%"],[13,5,"","9198.0%"],[13,6,"","18209.0%"],[13,7,"","27220.0%"],[13,8,"","36231.0%"],[13,9,"","45242.0%"],[13,10,"","54253.0%"],[13,11,"","63264.0%"],[13,12,"","72275.0%"],[13,13,"","81286.0%"],[13,14,"","90297.0%"],[15,4,"",""],[15,5,"",""],[15,6,"",""],[15,7,"",""],[15,8,"",""],[15,9,"",""],[15,10,"",""],[15,11,"",""],[15,12,"","200.0%"],[15,13,"",""],[15,14,"",""],[16,4,"",""],[16,5,"",""],[16,6,"",""],[16,7,"",""],[16,8,"",""],[16,9,"",""],[16,10,"",""],[16,11,"",""],[16,12,"","0.0%"],[16,13,"",""],[16,14,"",""],[17,4,"",""],[17,5,"",""],[17,6,"",""],[17,7,"",""],[17,8,"",""],[17,9,"",""],[17,10,"",""],[17,11,"",""],[17,12,"","200.0%"],[17,13,"",""],[17,14,"",""],[19,5,"",""],[19,8,"",0],[19,10,"",""],[19,11,"",""],[19,12,"",""],[19,13,"",""],[19,14,"",""],[20,5,"",""],[20,8,"",0],[20,10,"",""],[20,11,"",""],[20,12,"",""],[20,13,"",""],[20,14,"",""],[21,5,"",""],[21,10,"",""],[21,11,"",""],[21,12,"",""],[21,13,"",""],[21,14,"",""],[28,4,"",200],[28,5,"",201],[28,6,"",202],[28,7,"",203],[28,8,"",204],[28,9,"",205],[28,10,"",206],[28,11,"",207],[28,12,"",208],[28,13,"",209],[28,14,"",210],[29,4,"",200],[29,5,"",201],[29,6,"",202],[29,7,"",203],[29,8,"",204],[29,9,"",205],[29,10,"",206],[29,11,"",207],[29,12,"",208],[29,13,"",209],[29,14,"",210],[30,4,"",200],[30,5,"",201],[30,6,"",202],[30,7,"",203],[30,8,"",204],[30,9,"",205],[30,10,"",206],[30,11,"",207],[30,12,"",208],[30,13,"",209],[30,14,"",210],[31,1,""," Total Tons "],[31,4,"",200],[31,5,"",201],[31,6,"",202],[31,7,"",203],[31,8,"",204],[31,9,"",205],[31,10,"",206],[31,11,"",207],[31,12,"",208],[31,13,"",209],[31,14,"",210],[32,4,"",200],[32,5,"",201],[32,6,"",202],[32,7,"",203],[32,8,"",204],[32,9,"",205],[32,10,"",206],[32,11,"",207],[32,12,"",208],[32,13,"",209],[32,14,"",210],[33,4,"",200],[33,5,"",201],[33,6,"",202],[33,7,"",203],[33,8,"",204],[33,9,"",205],[33,10,"",206],[33,11,"",207],[33,12,"",208],[33,13,"",209],[33,14,"",210],[34,4,"",200],[34,5,"",201],[34,6,"",202],[34,7,"",203],[34,8,"",204],[34,9,"",205],[34,10,"",206],[34,11,"",207],[34,12,"",208],[34,13,"",209],[34,14,"",210],[35,4,"",200],[35,5,"",201],[35,6,"",202],[35,7,"",203],[35,8,"",204],[35,9,"",205],[35,10,"",206],[35,11,"",207],[35,12,"",208],[35,13,"",209],[35,14,"",210],[36,4,"",200],[36,5,"",201],[36,6,"",202],[36,7,"",203],[36,8,"",204],[36,9,"",205],[36,10,"",206],[36,11,"",207],[36,12,"",208],[36,13,"",209],[36,14,"",210],[37,4,"",200],[37,5,"",201],[37,6,"",202],[37,7,"",203],[37,8,"",204],[37,9,"",205],[37,10,"",206],[37,11,"",207],[37,12,"",208],[37,13,"",209],[37,14,"",210]]';
    public static final String EMPTY_LIST = 'list empty';
    private static final String PROJ_SPAN_LOCAL_MSG = 'Project span should be Local';
    private static final String PROJ_TEST1 = 'test1';
    private static final String PROJ_TEST1_MSG = 'The project list should contain test1';
    private static final String PROJ_TEST2 = 'test2';
    private static final String PROJ_TEST2_MSG = 'The project list should contain test2';
    private static final String PROJ_TEST3 = 'test3';
    private static final String PROJ_TEST3_MSG = 'The project list should contain test3';
    private static final String FIN_GLOBALMCONAME = 'globalMCOName';
    private static final String FIN_GLOBALMCONAME_MSG = 'The Financials list should contain globalMCOName';
    private static final String FIN_REGIONALMCONAME = 'RegionalMCOName';
    private static final String FIN_REGIONALMCONAME_MSG = 'The Financials list should contain RegionalMCOName';
    private static final String FIN_LOCALALMCONAME = 'LocalalMCOName';
    private static final String FIN_LOCALALMCONAME_MSG = 'The Financials list should contain LocalalMCOName';
    private static final String PLATFORM_USER = 'PLATFORM_USER';
    private static final String PLATFORM_USER_MSG = 'User last name must be PLATFORM_USER';
    private static final String PROJ_NAME_LIKE = 'test%';
    private static final String FIN_EXT_ID_LIKE = '%MCOName';
    private static Final String MCO_LST_MSG = 'List of financial inserted should be same as MCOList from getCountryValue';
    private static Final PageReference PageRef = Page.IPM_Financial;
    private static Final String GoBack_MSG = 'Back to Financial Page';
    private static Final String submit_MSG = 'List of MCO on submit reduce as we remove the submitted MCO from the List';
    private static Final String getFinancial_MSG = 'update the financial Status to In Progress from Not Started';
    private static Final String PAGE_REF_NULL_MSG = 'Page reference null found';
    
    /**********************************************************************
    *  @Description: Test Method to initialize data for the other test methods
    *  @name : initializeData
    *  @param : none
    *  @return : none
    *************************************************************************/
    @testSetup
    static void initializeData(){
        
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
          // user has to be created as system admin 
           ipmUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        } 
        System.assertEquals(PLATFORM_USER, ipmUser.LastName,PLATFORM_USER_MSG);
        
        Test.startTest(); 
        System.runAs(ipmUser){
            
            projectList = IPM_TestFactory_Helper.insertIPMProjectList();
            lstFinancial = IPM_TestFactory_Helper.insertIPMFinancialList(true);
        }  
        Test.stopTest();
        
        projectList = [select ID,name,IPM_Project_Type__c from IPM_Project__c where name like :PROJ_NAME_LIKE];
        Set<String> projNames = new Set<String>();
        for(IPM_Project__c proj:  projectList) {
            projNames.add(proj.name);
        }
        System.assert(projNames.contains(PROJ_TEST1),PROJ_TEST1_MSG);
        System.assert(projNames.contains(PROJ_TEST2),PROJ_TEST2_MSG);
        System.assert(projNames.contains(PROJ_TEST3),PROJ_TEST3_MSG);
            
        
        lstFinancial = [select ID, Financial_External_ID__c, Status__c from IPM_Financial__c where Financial_External_ID__c like :FIN_EXT_ID_LIKE];  
        Set<String> finExtIds = new Set<String>();
        for(IPM_Financial__c financial:  lstFinancial) {
            finExtIds.add(financial.Financial_External_ID__c);
        }
        System.assert(finExtIds.contains(FIN_GLOBALMCONAME),FIN_GLOBALMCONAME_MSG);
        System.assert(finExtIds.contains(FIN_REGIONALMCONAME),FIN_REGIONALMCONAME_MSG);
        System.assert(finExtIds.contains(FIN_LOCALALMCONAME),FIN_LOCALALMCONAME_MSG);
    }
    
   
    
    
    /**********************************************************************
    *  @Description: Test Method to to update Global span records
    *  @name : testEditFinancialsGlobal
    *  @param : none
    *  @return : none
    *************************************************************************/
    
     static testMethod void testEditFinancialsGlobal(){
        
        projectList = [select ID,name,IPM_Project_Type__c from IPM_Project__c where name like :PROJ_NAME_LIKE];
        Set<String> projNames = new Set<String>();
        for(IPM_Project__c proj:  projectList) {
            projNames.add(proj.name);
        }
        System.assert(projNames.contains(PROJ_TEST1),PROJ_TEST1_MSG);
        System.assert(projNames.contains(PROJ_TEST2),PROJ_TEST2_MSG);
        System.assert(projNames.contains(PROJ_TEST3),PROJ_TEST3_MSG);
            
        
        lstFinancial = [select ID, Financial_External_ID__c, Status__c from IPM_Financial__c where Financial_External_ID__c like :FIN_EXT_ID_LIKE];  
        Set<String> finExtIds = new Set<String>();
        for(IPM_Financial__c financial:  lstFinancial) {
            finExtIds.add(financial.Financial_External_ID__c);
        }
        System.assert(finExtIds.contains(FIN_GLOBALMCONAME),FIN_GLOBALMCONAME_MSG);
        System.assert(finExtIds.contains(FIN_REGIONALMCONAME),FIN_REGIONALMCONAME_MSG);
        System.assert(finExtIds.contains(FIN_LOCALALMCONAME),FIN_LOCALALMCONAME_MSG);
        
        User globalUser = [Select Id,LastName from User where LastName=:PLATFORM_USER limit 1];
        System.assertEquals(PLATFORM_USER, globalUser.LastName,PLATFORM_USER_MSG);
        
        Test.startTest();
        system.runAs(globalUser){
            // this is to cover the Volume unit Total Tons and without any values function on the copy and paste page
            //Span = Global 
            
            PageReference pRef = Page.IPM_FinancialCopyPasteGrid;
            pRef.getParameters().put('id', projectList[0].Id);
            Test.setCurrentPage(pRef);
            system.assertNotEquals(pRef, null, PAGE_REF_NULL_MSG);
            IPM_FinancialCopyPasteGrid ipmFinCon2=new IPM_FinancialCopyPasteGrid();        
            ipmFinCon2.Sustainability=sust_3 ;
            ipmFinCon2.Span= Global_STR;
            ipmFinCon2.submit();
            system.assertEquals(0 , ipmFinCon2.options.size(), submit_MSG );
            List<SelectOption> selOpts=ipmFinCon2.options;
            selOpts.add(new SelectOption(lstFinancial[0].Id,lstFinancial[0].Id));
            selOpts.add(new SelectOption(lstFinancial[1].Id,lstFinancial[1].Id));
            selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));        
            system.assertEquals(selOpts.isEmpty() , false,EMPTY_LIST);
            ipmFinCon2.ListCountries = lstFinancial[0].Id;
            List<SelectOption> McoList = ipmFinCon2.getCountryValue();
            system.assertEquals(McoList.size(), 3, MCO_LST_MSG);
            ipmFinCon2.submit();
            system.assertEquals(McoList.size(), ipmFinCon2.options.size() , submit_MSG);
            string rowcol = input1;
            map<String,String> mapfields = new map<string,string>();
            mapfields.put('Volume','4');
            IPM_Financial_Year__c fy= new IPM_Financial_Year__c();
            IPM_Financial_Year__c fy1= new IPM_Financial_Year__c();
            fy.Volume_Unit_Local__c = IPM_ConstantUtils.TotalTons;
            fy = IPM_FinancialCopyPasteGrid.assignVolumevaluesLocal(mapfields,fy1,'400');
            fy.Volume_Unit_Local__c = IPM_ConstantUtils.TotalTons0;
            fy = IPM_FinancialCopyPasteGrid.assignVolumevaluesRegional(mapfields,fy1,'400');
            IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[0].Id,Global_STR,projectList[0].IPM_Project_Type__c);
            system.assertNotEquals(IPM_ConstantUtils.STATUS_IN_PROGRESS, lstFinancial[0].status__c , getFinancial_MSG );
            PageReference goback = ipmFinCon2.goBack();
            PageRef.getParameters().put('id' , projectList[0].Id );
            system.assertEquals(string.valueOf(PageRef), string.valueOf(goback) ,GoBack_MSG);
            
           
            // this is to cover the Volume unit Total '000 units and without any values function on the copy and paste page
            //Span = Global, with complete input
           
            PageReference pRef2 = Page.IPM_FinancialCopyPasteGrid;
            pRef2.getParameters().put('id', projectList[0].Id);
            Test.setCurrentPage(pRef2);
            system.assertNotEquals(pRef2, null, PAGE_REF_NULL_MSG);
            IPM_FinancialCopyPasteGrid ipmFinCon5=new IPM_FinancialCopyPasteGrid(); 
            ipmFinCon5=new IPM_FinancialCopyPasteGrid();        
            ipmFinCon5.Sustainability=sust_3 ;
            ipmFinCon5.Span= Global_STR;
            ipmFinCon5.submit();
            system.assertEquals(0, ipmFinCon5.options.size() , submit_MSG);
            selOpts=ipmFinCon5.options;
            selOpts.add(new SelectOption(lstFinancial[0].Id,lstFinancial[0].Id));        
            system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
            ipmFinCon5.ListCountries = lstFinancial[0].Id;
            List<SelectOption> McoListGbl = ipmFinCon5.getCountryValue();
            system.assertEquals(McoListGbl.size(), 1, MCO_LST_MSG);
            rowcol = input2;
            IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[0].Id,Global_STR,projectList[0].IPM_Project_Type__c);
            system.assertNotEquals(IPM_ConstantUtils.STATUS_IN_PROGRESS, lstFinancial[0].status__c , getFinancial_MSG );
            PageReference gobck = ipmFinCon5.goBack();
            system.assertEquals(string.valueOf(PageRef), string.valueOf(gobck) ,GoBack_MSG);
            
              // this is to cover the Volume unit Total '000 Units and with complete all the values on the copy and paste page
            //Span = Global, with complete input        
            
            PageReference pRef5 = Page.IPM_FinancialCopyPasteGrid;
            pRef5.getParameters().put('id', projectList[0].Id);
            Test.setCurrentPage(pRef5);
            system.assertNotEquals(pRef5, null, PAGE_REF_NULL_MSG);
            IPM_FinancialCopyPasteGrid ipmFinConGlobal3=new IPM_FinancialCopyPasteGrid(); 
            ipmFinConGlobal3=new IPM_FinancialCopyPasteGrid();        
            ipmFinConGlobal3.Sustainability=sust_3 ;
            ipmFinConGlobal3.Span= Global_STR;
            ipmFinConGlobal3.submit();
            system.assertEquals(0, ipmFinConGlobal3.options.size() , submit_MSG);
            selOpts=ipmFinConGlobal3.options;
            selOpts.add(new SelectOption(lstFinancial[0].Id,lstFinancial[0].Id));        
            system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
            ipmFinConGlobal3.ListCountries = lstFinancial[0].Id;
            List<SelectOption> McoListGblerr = ipmFinConGlobal3.getCountryValue();
            system.assertEquals(McoListGblerr.size(), 1, MCO_LST_MSG);
            rowcol = input3;
            IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[0].Id,Global_STR,projectList[0].IPM_Project_Type__c);
            
            PageReference gobckglb3 = ipmFinConGlobal3.goBack();
            system.assertEquals(string.valueOf(PageRef), string.valueOf(gobckglb3) ,GoBack_MSG);
            
            //negative testing, with no input at all when a submit is clicked without any input.
            PageReference pRef4 = Page.IPM_FinancialCopyPasteGrid;
            pRef4.getParameters().put('id', projectList[0].Id);
            Test.setCurrentPage(pRef4);
            system.assertNotEquals(pRef4, null, PAGE_REF_NULL_MSG);
            IPM_FinancialCopyPasteGrid ipmFinConGlobal2=new IPM_FinancialCopyPasteGrid(); 
            ipmFinConGlobal2=new IPM_FinancialCopyPasteGrid();        
            ipmFinConGlobal2.Sustainability=sust_3 ;
            ipmFinConGlobal2.Span= Global_STR;
            ipmFinConGlobal2.submit(); 
            system.assertEquals(0, ipmFinConGlobal2.options.size() , submit_MSG);
            List<SelectOption> selOpts1=ipmFinConGlobal2.options;
            system.assertNotEquals(selOpts1.isEmpty() , false, EMPTY_LIST);
            ipmFinConGlobal2.ListCountries = lstFinancial[0].Id;
            List<SelectOption> McoListGblemptydata = ipmFinConGlobal3.getCountryValue();
            system.assertEquals(McoListGblemptydata.size(), 1, MCO_LST_MSG);
            rowcol = '';
            IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[0].Id,Global_STR,projectList[0].IPM_Project_Type__c);
            system.assertNotEquals(IPM_ConstantUtils.STATUS_IN_PROGRESS, lstFinancial[0].status__c , getFinancial_MSG );
            PageReference gobckglb2 = ipmFinConGlobal2.goBack();
            system.assertEquals(String.valueOf(PageRef), String.valueOf(gobckglb2) ,GoBack_MSG);
            
        }
        Test.stopTest();
    }
    
   /**********************************************************************
    *  @Description: Test Method to to update Regional span records
    *  @name : testEditFinancialsRegional
    *  @param : none
    *  @return : none
    *************************************************************************/
    
    static testMethod void testEditFinancialsRegional(){

        projectList = [select ID,name from IPM_Project__c where name like :PROJ_NAME_LIKE];
        Set<String> projNames = new Set<String>();
        for(IPM_Project__c proj:  projectList) {
            projNames.add(proj.name);
        }
        System.assert(projNames.contains(PROJ_TEST1),PROJ_TEST1_MSG);
        System.assert(projNames.contains(PROJ_TEST2),PROJ_TEST2_MSG);
        System.assert(projNames.contains(PROJ_TEST3),PROJ_TEST3_MSG);
            
        
        lstFinancial = [select ID, Financial_External_ID__c, Status__c from IPM_Financial__c where Financial_External_ID__c like :FIN_EXT_ID_LIKE];  
        Set<String> finExtIds = new Set<String>();
        for(IPM_Financial__c financial:  lstFinancial) {
            finExtIds.add(financial.Financial_External_ID__c);
        }
        System.assert(finExtIds.contains(FIN_GLOBALMCONAME),FIN_GLOBALMCONAME_MSG);
        System.assert(finExtIds.contains(FIN_REGIONALMCONAME),FIN_REGIONALMCONAME_MSG);
        System.assert(finExtIds.contains(FIN_LOCALALMCONAME),FIN_LOCALALMCONAME_MSG);
        
        User globalUser = [Select Id,LastName from User where LastName=:PLATFORM_USER limit 1];
        System.assertEquals(PLATFORM_USER, globalUser.LastName,PLATFORM_USER_MSG);
        
        Test.startTest();
        system.runAs(globalUser){  
            // this is to cover the Volume unit Total Tons and without any values function on the copy and paste page
            projectList[1].IPMProject_Span__c = Regional_STR;
            update projectList[1];
            
            PageReference pRef = Page.IPM_FinancialCopyPasteGrid;
            pRef.getParameters().put('id', projectList[1].Id);
            Test.setCurrentPage(pRef);
            system.assertNotEquals(pRef, null, PAGE_REF_NULL_MSG);
            IPM_FinancialCopyPasteGrid ipmFinConReg1=new IPM_FinancialCopyPasteGrid();        
            ipmFinConReg1.Sustainability=sust_3 ;
            ipmFinConReg1.Span= Regional_STR;
            ipmFinConReg1.submit();
            system.assertEquals(0, ipmFinConReg1.options.size() , submit_MSG);
            List<SelectOption> selOpts=ipmFinConReg1.options;
            selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));        
            system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
            ipmFinConReg1.ListCountries = lstFinancial[2].Id;
            List<SelectOption> MCOList = ipmFinConReg1.getCountryValue();
            system.assertEquals(MCOList.size(), 1, MCO_LST_MSG);
            ipmFinConReg1.submit();
            system.assertEquals(MCOList.size(), ipmFinConReg1.options.size() , submit_MSG);
            String rowcol = input1;
            IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[2].Id,Regional_STR,projectList[1].IPM_Project_Type__c);
            system.assertNotEquals(IPM_ConstantUtils.STATUS_IN_PROGRESS, lstFinancial[2].status__c , getFinancial_MSG );
            PageReference gobckreg1 = ipmFinConReg1.goBack();
            PageRef.getParameters().put('id' , projectList[1].Id );
            system.assertEquals(string.valueOf(PageRef), string.valueOf(gobckreg1) ,GoBack_MSG);
            
            // this is to cover the Volume unit Total '000 units and with all the values function on the copy and paste page
            
            PageReference pRef1 = Page.IPM_FinancialCopyPasteGrid;
            pRef1.getParameters().put('id', projectList[1].Id);
            Test.setCurrentPage(pRef1);
            system.assertNotEquals(pRef1, null, PAGE_REF_NULL_MSG);
            IPM_FinancialCopyPasteGrid ipmFinConReg2=new IPM_FinancialCopyPasteGrid();
            ipmFinConReg2.submit();
            system.assertEquals(0, ipmFinConReg2.options.size() , submit_MSG);
            selOpts=ipmFinConReg2.options;
            selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));        
            system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
            ipmFinConReg2.ListCountries = lstFinancial[2].Id;
            MCOList = ipmFinConReg2.getCountryValue();
            system.assertEquals(MCOList.size(), 1, MCO_LST_MSG);
            ipmFinConReg2.submit();
            system.assertEquals(MCOList.size(), ipmFinConReg2.options.size() , submit_MSG);
            rowcol = input3;
            IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[2].Id,Regional_STR,projectList[1].IPM_Project_Type__c);
            system.assertNotEquals(IPM_ConstantUtils.STATUS_IN_PROGRESS, lstFinancial[2].status__c , getFinancial_MSG );
        }
        Test.stopTest();
        
     }
     
    /**********************************************************************
    *  @Description: Test Method to to update Local span records
    *  @name : testEditFinancialsLocal
    *  @param : none
    *  @return : none
    *************************************************************************/
    
     static testMethod void testEditFinancialsLocal(){
        projectList = [select ID,name from IPM_Project__c where name like :PROJ_NAME_LIKE];
        Set<String> projNames = new Set<String>();
        for(IPM_Project__c proj:  projectList) {
            projNames.add(proj.name);
        }
        System.assert(projNames.contains(PROJ_TEST1),PROJ_TEST1_MSG);
        System.assert(projNames.contains(PROJ_TEST2),PROJ_TEST2_MSG);
        System.assert(projNames.contains(PROJ_TEST3),PROJ_TEST3_MSG);
            
        
        lstFinancial = [select ID, Financial_External_ID__c, Status__c from IPM_Financial__c where Financial_External_ID__c like :FIN_EXT_ID_LIKE];  
        Set<String> finExtIds = new Set<String>();
        for(IPM_Financial__c financial:  lstFinancial) {
            finExtIds.add(financial.Financial_External_ID__c);
        }
        System.assert(finExtIds.contains(FIN_GLOBALMCONAME),FIN_GLOBALMCONAME_MSG);
        System.assert(finExtIds.contains(FIN_REGIONALMCONAME),FIN_REGIONALMCONAME_MSG);
        System.assert(finExtIds.contains(FIN_LOCALALMCONAME),FIN_LOCALALMCONAME_MSG);
        
        User globalUser = [Select Id,LastName from User where LastName=:PLATFORM_USER limit 1];
        System.assertEquals(PLATFORM_USER, globalUser.LastName,PLATFORM_USER_MSG);
        
        Test.startTest();
        system.runAs(globalUser){
            projectList[2].IPMProject_Span__c = Local_STR;
            update projectList[2];
            // this is to cover the Volume unit Total '000 units and without any values function on the copy and paste page
            
            PageReference pRef3 = Page.IPM_FinancialCopyPasteGrid;
            pRef3.getParameters().put('id', projectList[2].Id);
            Test.setCurrentPage(pRef3);
            IPM_FinancialCopyPasteGrid ipmFinConLoc2=new IPM_FinancialCopyPasteGrid();
            ipmFinConLoc2.Sustainability='5';
            ipmFinConLoc2.Span= Local_STR;
            system.assertEquals(ipmFinConLoc2.Span, Local_STR,PROJ_SPAN_LOCAL_MSG);
             List<SelectOption> selOpts= ipmFinConLoc2.options;
             selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));        
            system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
            ipmFinConLoc2.ListCountries = lstFinancial[2].Id;
            List<SelectOption>  MCOList = ipmFinConLoc2.getCountryValue();
            system.assertEquals(MCOList.size(), 1, MCO_LST_MSG);
            ipmFinConLoc2.submit();
            system.assertEquals(MCOList.size(), ipmFinConLoc2.options.size() , submit_MSG);
            String rowcol = input2;
            IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,ipmFinConLoc2.ListCountries,Local_STR,projectList[2].IPM_Project_Type__c);
            system.assertNotEquals(IPM_ConstantUtils.STATUS_IN_PROGRESS, lstFinancial[2].status__c , getFinancial_MSG );
             // this is to cover the Volume unit Total total and with complete all the values on the copy and paste page
            
            PageReference pRef4 = Page.IPM_FinancialCopyPasteGrid;
            pRef4.getParameters().put('id', projectList[2].Id);
            Test.setCurrentPage(pRef4);
            IPM_FinancialCopyPasteGrid ipmFinConLoc3 = new IPM_FinancialCopyPasteGrid();
            ipmFinConLoc3.Sustainability='5';
            ipmFinConLoc3.Span= Local_STR;
            system.assertEquals(ipmFinConLoc3.Span, Local_STR,PROJ_SPAN_LOCAL_MSG);
            selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));        
            system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
            ipmFinConLoc3.ListCountries = lstFinancial[2].Id;
            MCOList = ipmFinConLoc3.getCountryValue();
            system.assertEquals(MCOList.size(), 0, MCO_LST_MSG);
            ipmFinConLoc3.submit();
            system.assertEquals(1, ipmFinConLoc2.options.size() , submit_MSG);
            rowcol = input4;
            IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,ipmFinConLoc3.ListCountries,Local_STR,projectList[2].IPM_Project_Type__c);
            system.assertNotEquals(IPM_ConstantUtils.STATUS_IN_PROGRESS, lstFinancial[2].status__c , getFinancial_MSG );
        }
        Test.stopTest();
        
     }
    

}