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
    public static User u1 = new User();
    public static final String Global_STR = 'Global';
    public static final String Regional_STR = 'Regional';
    public static final String Local_STR = 'Local';
    public static final String sust_3 = '3' ;
    public static final String input1 = '[[7,1,"","Total Tons"],[4,4,"",""],[4,5,"",""],[4,6,"",""],[4,7,"",""],[4,8,"",""],[4,9,"",""],[4,10,"",""],[4,11,"",""],[4,12,"",""],[4,13,"",""],[4,14,"",""]]';
    public static final String input2 = '[[7,1,"","Total \'000 Units"],[4,4,"","5"],[4,5,"","6"],[4,6,"","7"],[4,7,"","9"],[4,8,"",""],[4,9,"",""],[4,10,"",""],[4,11,"",""],[4,12,"",""],[4,13,"",""],[4,14,"",""],[5,4,"","99.0%"],[5,5,"","1110.0%"],[5,6,"","2121.0%"],[5,7,"","3132.0%"],[5,8,"","4143.0%"],[5,9,"","5154.0%"],[5,10,"","6165.0%"],[5,11,"","7176.0%"],[5,12,"","8187.0%"],[5,13,"","9198.0%"],[5,14,"","10209.0%"],[6,4,"","110.0%"],[6,5,"","2121.0%"],[6,6,"","4132.0%"],[6,7,"","6143.0%"],[6,8,"","8154.0%"],[6,9,"","10165.0%"],[6,10,"","12176.0%"],[6,11,"","14187.0%"],[6,12,"","16198.0%"],[6,13,"","18209.0%"],[6,14,"","20220.0%"],[7,1,""," Total Tons "],[7,4,"","121.0%"],[7,5,"","3132.0%"],[7,6,"","6143.0%"],[7,7,"","9154.0%"],[7,8,"","12165.0%"],[7,9,"","15176.0%"],[7,10,"","18187.0%"],[7,11,"","21198.0%"],[7,12,"","24209.0%"],[7,13,"","27220.0%"],[7,14,"","30231.0%"],[8,4,"","132.0%"],[8,5,"","4143.0%"],[8,6,"","8154.0%"],[8,7,"","12165.0%"],[8,8,"","16176.0%"],[8,9,"","20187.0%"],[8,10,"","24198.0%"],[8,11,"","28209.0%"],[8,12,"","32220.0%"],[8,13,"","36231.0%"],[8,14,"","40242.0%"],[9,4,"","143.0%"],[9,5,"","5154.0%"],[9,6,"","10165.0%"],[9,7,"","15176.0%"],[9,8,"","20187.0%"],[9,9,"","25198.0%"],[9,10,"","30209.0%"],[9,11,"","35220.0%"],[9,12,"","40231.0%"],[9,13,"","45242.0%"],[9,14,"","50253.0%"],[10,4,"","154.0%"],[10,5,"","6165.0%"],[10,6,"","12176.0%"],[10,7,"","18187.0%"],[10,8,"","24198.0%"],[10,9,"","30209.0%"],[10,10,"","36220.0%"],[10,11,"","42231.0%"],[10,12,"","48242.0%"],[10,13,"","54253.0%"],[10,14,"","60264.0%"],[11,4,"","165.0%"],[11,5,"","7176.0%"],[11,6,"","14187.0%"],[11,7,"","21198.0%"],[11,8,"","28209.0%"],[11,9,"","35220.0%"],[11,10,"","42231.0%"],[11,11,"","49242.0%"],[11,12,"","56253.0%"],[11,13,"","63264.0%"],[11,14,"","70275.0%"],[12,4,"","176.0%"],[12,5,"","8187.0%"],[12,6,"","16198.0%"],[12,7,"","24209.0%"],[12,8,"","32220.0%"],[12,9,"","40231.0%"],[12,10,"","48242.0%"],[12,11,"","56253.0%"],[12,12,"","64264.0%"],[12,13,"","72275.0%"],[12,14,"","80286.0%"],[13,4,"","187.0%"],[13,5,"","9198.0%"],[13,6,"","18209.0%"],[13,7,"","27220.0%"],[13,8,"","36231.0%"],[13,9,"","45242.0%"],[13,10,"","54253.0%"],[13,11,"","63264.0%"],[13,12,"","72275.0%"],[13,13,"","81286.0%"],[13,14,"","90297.0%"],[15,4,"",""],[15,5,"",""],[15,6,"",""],[15,7,"",""],[15,8,"",""],[15,9,"",""],[15,10,"",""],[15,11,"",""],[15,12,"","200.0%"],[15,13,"",""],[15,14,"",""],[16,4,"",""],[16,5,"",""],[16,6,"",""],[16,7,"",""],[16,8,"",""],[16,9,"",""],[16,10,"",""],[16,11,"",""],[16,12,"","0.0%"],[16,13,"",""],[16,14,"",""],[17,4,"",""],[17,5,"",""],[17,6,"",""],[17,7,"",""],[17,8,"",""],[17,9,"",""],[17,10,"",""],[17,11,"",""],[17,12,"","200.0%"],[17,13,"",""],[17,14,"",""],[19,5,"",""],[19,8,"",0],[19,10,"",""],[19,11,"",""],[19,12,"",""],[19,13,"",""],[19,14,"",""],[20,5,"",""],[20,8,"",0],[20,10,"",""],[20,11,"",""],[20,12,"",""],[20,13,"",""],[20,14,"",""],[21,5,"",""],[21,10,"",""],[21,11,"",""],[21,12,"",""],[21,13,"",""],[21,14,"",""],[28,4,"",200],[28,5,"",201],[28,6,"",202],[28,7,"",203],[28,8,"",204],[28,9,"",205],[28,10,"",206],[28,11,"",207],[28,12,"",208],[28,13,"",209],[28,14,"",210],[29,4,"",200],[29,5,"",201],[29,6,"",202],[29,7,"",203],[29,8,"",204],[29,9,"",205],[29,10,"",206],[29,11,"",207],[29,12,"",208],[29,13,"",209],[29,14,"",210],[30,4,"",200],[30,5,"",201],[30,6,"",202],[30,7,"",203],[30,8,"",204],[30,9,"",205],[30,10,"",206],[30,11,"",207],[30,12,"",208],[30,13,"",209],[30,14,"",210],[31,1,""," Total Tons "],[31,4,"",200],[31,5,"",201],[31,6,"",202],[31,7,"",203],[31,8,"",204],[31,9,"",205],[31,10,"",206],[31,11,"",207],[31,12,"",208],[31,13,"",209],[31,14,"",210],[32,4,"",200],[32,5,"",201],[32,6,"",202],[32,7,"",203],[32,8,"",204],[32,9,"",205],[32,10,"",206],[32,11,"",207],[32,12,"",208],[32,13,"",209],[32,14,"",210],[33,4,"",200],[33,5,"",201],[33,6,"",202],[33,7,"",203],[33,8,"",204],[33,9,"",205],[33,10,"",206],[33,11,"",207],[33,12,"",208],[33,13,"",209],[33,14,"",210],[34,4,"",200],[34,5,"",201],[34,6,"",202],[34,7,"",203],[34,8,"",204],[34,9,"",205],[34,10,"",206],[34,11,"",207],[34,12,"",208],[34,13,"",209],[34,14,"",210],[35,4,"",200],[35,5,"",201],[35,6,"",202],[35,7,"",203],[35,8,"",204],[35,9,"",205],[35,10,"",206],[35,11,"",207],[35,12,"",208],[35,13,"",209],[35,14,"",210],[36,4,"",200],[36,5,"",201],[36,6,"",202],[36,7,"",203],[36,8,"",204],[36,9,"",205],[36,10,"",206],[36,11,"",207],[36,12,"",208],[36,13,"",209],[36,14,"",210],[37,4,"",200],[37,5,"",201],[37,6,"",202],[37,7,"",203],[37,8,"",204],[37,9,"",205],[37,10,"",206],[37,11,"",207],[37,12,"",208],[37,13,"",209],[37,14,"",210]]';
    public static final String input3 ='[[4,4,"","5"],[4,5,"","6"],[4,6,"","7"],[4,7,"","9"],[4,8,"",""],[4,9,"",""],[4,10,"",""],[4,11,"",""],[4,12,"",""],[4,13,"",""],[4,14,"",""],[5,4,"","99.0%"],[5,5,"","1110.0%"],[5,6,"","2121.0%"],[5,7,"","3132.0%"],[5,8,"","4143.0%"],[5,9,"","5154.0%"],[5,10,"","6165.0%"],[5,11,"","7176.0%"],[5,12,"","8187.0%"],[5,13,"","9198.0%"],[5,14,"","10209.0%"],[6,4,"","110.0%"],[6,5,"","2121.0%"],[6,6,"","4132.0%"],[6,7,"","6143.0%"],[6,8,"","8154.0%"],[6,9,"","10165.0%"],[6,10,"","12176.0%"],[6,11,"","14187.0%"],[6,12,"","16198.0%"],[6,13,"","18209.0%"],[6,14,"","20220.0%"],[7,1,""," Total Tons "],[7,4,"","121.0%"],[7,5,"","3132.0%"],[7,6,"","6143.0%"],[7,7,"","9154.0%"],[7,8,"","12165.0%"],[7,9,"","15176.0%"],[7,10,"","18187.0%"],[7,11,"","21198.0%"],[7,12,"","24209.0%"],[7,13,"","27220.0%"],[7,14,"","30231.0%"],[8,4,"","132.0%"],[8,5,"","4143.0%"],[8,6,"","8154.0%"],[8,7,"","12165.0%"],[8,8,"","16176.0%"],[8,9,"","20187.0%"],[8,10,"","24198.0%"],[8,11,"","28209.0%"],[8,12,"","32220.0%"],[8,13,"","36231.0%"],[8,14,"","40242.0%"],[9,4,"","143.0%"],[9,5,"","5154.0%"],[9,6,"","10165.0%"],[9,7,"","15176.0%"],[9,8,"","20187.0%"],[9,9,"","25198.0%"],[9,10,"","30209.0%"],[9,11,"","35220.0%"],[9,12,"","40231.0%"],[9,13,"","45242.0%"],[9,14,"","50253.0%"],[10,4,"","154.0%"],[10,5,"","6165.0%"],[10,6,"","12176.0%"],[10,7,"","18187.0%"],[10,8,"","24198.0%"],[10,9,"","30209.0%"],[10,10,"","36220.0%"],[10,11,"","42231.0%"],[10,12,"","48242.0%"],[10,13,"","54253.0%"],[10,14,"","60264.0%"],[11,4,"","165.0%"],[11,5,"","7176.0%"],[11,6,"","14187.0%"],[11,7,"","21198.0%"],[11,8,"","28209.0%"],[11,9,"","35220.0%"],[11,10,"","42231.0%"],[11,11,"","49242.0%"],[11,12,"","56253.0%"],[11,13,"","63264.0%"],[11,14,"","70275.0%"],[12,4,"","176.0%"],[12,5,"","8187.0%"],[12,6,"","16198.0%"],[12,7,"","24209.0%"],[12,8,"","32220.0%"],[12,9,"","40231.0%"],[12,10,"","48242.0%"],[12,11,"","56253.0%"],[12,12,"","64264.0%"],[12,13,"","72275.0%"],[12,14,"","80286.0%"],[13,4,"","187.0%"],[13,5,"","9198.0%"],[13,6,"","18209.0%"],[13,7,"","27220.0%"],[13,8,"","36231.0%"],[13,9,"","45242.0%"],[13,10,"","54253.0%"],[13,11,"","63264.0%"],[13,12,"","72275.0%"],[13,13,"","81286.0%"],[13,14,"","90297.0%"],[15,4,"",""],[15,5,"",""],[15,6,"",""],[15,7,"",""],[15,8,"",""],[15,9,"",""],[15,10,"",""],[15,11,"",""],[15,12,"","200.0%"],[15,13,"",""],[15,14,"",""],[16,4,"",""],[16,5,"",""],[16,6,"",""],[16,7,"",""],[16,8,"",""],[16,9,"",""],[16,10,"",""],[16,11,"",""],[16,12,"","0.0%"],[16,13,"",""],[16,14,"",""],[17,4,"",""],[17,5,"",""],[17,6,"",""],[17,7,"",""],[17,8,"",""],[17,9,"",""],[17,10,"",""],[17,11,"",""],[17,12,"","200.0%"],[17,13,"",""],[17,14,"",""],[19,5,"",""],[19,8,"",0],[19,10,"",""],[19,11,"",""],[19,12,"",""],[19,13,"",""],[19,14,"",""],[20,5,"",""],[20,8,"",0],[20,10,"",""],[20,11,"",""],[20,12,"",""],[20,13,"",""],[20,14,"",""],[21,5,"",""],[21,10,"",""],[21,11,"",""],[21,12,"",""],[21,13,"",""],[21,14,"",""],[28,4,"",200],[28,5,"",201],[28,6,"",202],[28,7,"",203],[28,8,"",204],[28,9,"",205],[28,10,"",206],[28,11,"",207],[28,12,"",208],[28,13,"",209],[28,14,"",210],[29,4,"",200],[29,5,"",201],[29,6,"",202],[29,7,"",203],[29,8,"",204],[29,9,"",205],[29,10,"",206],[29,11,"",207],[29,12,"",208],[29,13,"",209],[29,14,"",210],[30,4,"",200],[30,5,"",201],[30,6,"",202],[30,7,"",203],[30,8,"",204],[30,9,"",205],[30,10,"",206],[30,11,"",207],[30,12,"",208],[30,13,"",209],[30,14,"",210],[31,1,""," Total Tons "],[31,4,"",200],[31,5,"",201],[31,6,"",202],[31,7,"",203],[31,8,"",204],[31,9,"",205],[31,10,"",206],[31,11,"",207],[31,12,"",208],[31,13,"",209],[31,14,"",210],[32,4,"",200],[32,5,"",201],[32,6,"",202],[32,7,"",203],[32,8,"",204],[32,9,"",205],[32,10,"",206],[32,11,"",207],[32,12,"",208],[32,13,"",209],[32,14,"",210],[33,4,"",200],[33,5,"",201],[33,6,"",202],[33,7,"",203],[33,8,"",204],[33,9,"",205],[33,10,"",206],[33,11,"",207],[33,12,"",208],[33,13,"",209],[33,14,"",210],[34,4,"",200],[34,5,"",201],[34,6,"",202],[34,7,"",203],[34,8,"",204],[34,9,"",205],[34,10,"",206],[34,11,"",207],[34,12,"",208],[34,13,"",209],[34,14,"",210],[35,4,"",200],[35,5,"",201],[35,6,"",202],[35,7,"",203],[35,8,"",204],[35,9,"",205],[35,10,"",206],[35,11,"",207],[35,12,"",208],[35,13,"",209],[35,14,"",210],[36,4,"",200],[36,5,"",201],[36,6,"",202],[36,7,"",203],[36,8,"",204],[36,9,"",205],[36,10,"",206],[36,11,"",207],[36,12,"",208],[36,13,"",209],[36,14,"",210],[37,4,"",200],[37,5,"",201],[37,6,"",202],[37,7,"",203],[37,8,"",204],[37,9,"",205],[37,10,"",206],[37,11,"",207],[37,12,"",208],[37,13,"",209],[37,14,"",210]]';
    public static final String input4 ='[[7,1,"","Total \'000 Units"],[7,4,"","121.0%"],[7,5,"","1"],[7,6,"","6143.0%"],[7,7,"","9154.0%"],[7,8,"","12165.0%"],[7,9,"","15176.0%"],[7,10,"","18187.0%"],[7,11,"","21198.0%"],[7,12,"","24209.0%"],[7,13,"","27220.0%"],[7,14,"","30231.0%"],[8,4,"","132.0%"],[8,5,"","4143.0%"],[8,6,"","8154.0%"],[8,7,"","12165.0%"],[8,8,"","16176.0%"],[8,9,"","20187.0%"],[8,10,"","24198.0%"],[8,11,"","28209.0%"],[8,12,"","32220.0%"],[8,13,"","36231.0%"],[8,14,"","40242.0%"],[9,4,"","143.0%"],[9,5,"","5154.0%"],[9,6,"","10165.0%"],[9,7,"","15176.0%"],[9,8,"","20187.0%"],[9,9,"","25198.0%"],[9,10,"","30209.0%"],[9,11,"","35220.0%"],[9,12,"","40231.0%"],[9,13,"","45242.0%"],[9,14,"","50253.0%"],[10,4,"","154.0%"],[10,5,"","6165.0%"],[10,6,"","12176.0%"],[10,7,"","18187.0%"],[10,8,"","24198.0%"],[10,9,"","30209.0%"],[10,10,"","36220.0%"],[10,11,"","42231.0%"],[10,12,"","48242.0%"],[10,13,"","54253.0%"],[10,14,"","60264.0%"],[11,4,"","165.0%"],[11,5,"","7176.0%"],[11,6,"","14187.0%"],[11,7,"","21198.0%"],[11,8,"","28209.0%"],[11,9,"","35220.0%"],[11,10,"","42231.0%"],[11,11,"","49242.0%"],[11,12,"","56253.0%"],[11,13,"","63264.0%"],[11,14,"","70275.0%"],[12,4,"","176.0%"],[12,5,"","8187.0%"],[12,6,"","16198.0%"],[12,7,"","24209.0%"],[12,8,"","32220.0%"],[12,9,"","40231.0%"],[12,10,"","48242.0%"],[12,11,"","56253.0%"],[12,12,"","64264.0%"],[12,13,"","72275.0%"],[12,14,"","80286.0%"],[13,4,"","187.0%"],[13,5,"","9198.0%"],[13,6,"","18209.0%"],[13,7,"","27220.0%"],[13,8,"","36231.0%"],[13,9,"","45242.0%"],[13,10,"","54253.0%"],[13,11,"","63264.0%"],[13,12,"","72275.0%"],[13,13,"","81286.0%"],[13,14,"","90297.0%"],[15,4,"",""],[15,5,"",""],[15,6,"",""],[15,7,"",""],[15,8,"",""],[15,9,"",""],[15,10,"",""],[15,11,"",""],[15,12,"","200.0%"],[15,13,"",""],[15,14,"",""],[16,4,"",""],[16,5,"",""],[16,6,"",""],[16,7,"",""],[16,8,"",""],[16,9,"",""],[16,10,"",""],[16,11,"",""],[16,12,"","0.0%"],[16,13,"",""],[16,14,"",""],[17,4,"",""],[17,5,"",""],[17,6,"",""],[17,7,"",""],[17,8,"",""],[17,9,"",""],[17,10,"",""],[17,11,"",""],[17,12,"","200.0%"],[17,13,"",""],[17,14,"",""],[19,5,"",""],[19,8,"",0],[19,10,"",""],[19,11,"",""],[19,12,"",""],[19,13,"",""],[19,14,"",""],[20,5,"",""],[20,8,"",0],[20,10,"",""],[20,11,"",""],[20,12,"",""],[20,13,"",""],[20,14,"",""],[21,5,"",""],[21,10,"",""],[21,11,"",""],[21,12,"",""],[21,13,"",""],[21,14,"",""],[28,4,"",200],[28,5,"",201],[28,6,"",202],[28,7,"",203],[28,8,"",204],[28,9,"",205],[28,10,"",206],[28,11,"",207],[28,12,"",208],[28,13,"",209],[28,14,"",210],[29,4,"",200],[29,5,"",201],[29,6,"",202],[29,7,"",203],[29,8,"",204],[29,9,"",205],[29,10,"",206],[29,11,"",207],[29,12,"",208],[29,13,"",209],[29,14,"",210],[30,4,"",200],[30,5,"",201],[30,6,"",202],[30,7,"",203],[30,8,"",204],[30,9,"",205],[30,10,"",206],[30,11,"",207],[30,12,"",208],[30,13,"",209],[30,14,"",210],[31,1,""," Total Tons "],[31,4,"",200],[31,5,"",201],[31,6,"",202],[31,7,"",203],[31,8,"",204],[31,9,"",205],[31,10,"",206],[31,11,"",207],[31,12,"",208],[31,13,"",209],[31,14,"",210],[32,4,"",200],[32,5,"",201],[32,6,"",202],[32,7,"",203],[32,8,"",204],[32,9,"",205],[32,10,"",206],[32,11,"",207],[32,12,"",208],[32,13,"",209],[32,14,"",210],[33,4,"",200],[33,5,"",201],[33,6,"",202],[33,7,"",203],[33,8,"",204],[33,9,"",205],[33,10,"",206],[33,11,"",207],[33,12,"",208],[33,13,"",209],[33,14,"",210],[34,4,"",200],[34,5,"",201],[34,6,"",202],[34,7,"",203],[34,8,"",204],[34,9,"",205],[34,10,"",206],[34,11,"",207],[34,12,"",208],[34,13,"",209],[34,14,"",210],[35,4,"",200],[35,5,"",201],[35,6,"",202],[35,7,"",203],[35,8,"",204],[35,9,"",205],[35,10,"",206],[35,11,"",207],[35,12,"",208],[35,13,"",209],[35,14,"",210],[36,4,"",200],[36,5,"",201],[36,6,"",202],[36,7,"",203],[36,8,"",204],[36,9,"",205],[36,10,"",206],[36,11,"",207],[36,12,"",208],[36,13,"",209],[36,14,"",210],[37,4,"",200],[37,5,"",201],[37,6,"",202],[37,7,"",203],[37,8,"",204],[37,9,"",205],[37,10,"",206],[37,11,"",207],[37,12,"",208],[37,13,"",209],[37,14,"",210]]';
    public static final String EMPTY_LIST = 'list empty';
    
    /**********************************************************************
    *  @Description: Test Method to initialize data for the other test methods
    *  @name : initializeData
    *  @param : none
    *  @return : none
    *************************************************************************/
    static testMethod void initializeData(){
        test.startTest(); 
        //Global     
            
            u1 = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            system.assert(u1.id != Null, 'User insert failed'); 
            system.runAs(u1){
            
            projectList = IPM_TestFactory_Helper.insertIPMProjectList();
            lstFinancial = IPM_TestFactory_Helper.insertIPMFinancialList(true);
            lstFinancialYear = IPM_TestFactory_Helper.insertIPMFinancialYearList();
            system.assertEquals(projectList.isEmpty() , false, EMPTY_LIST);
            system.assertEquals(lstFinancial.isEmpty() , false, EMPTY_LIST);
            system.assertEquals(lstFinancialYear.isEmpty() , false, EMPTY_LIST);
        }  
        test.stopTest();
    }
    
   
    
    
    /**********************************************************************
    *  @Description: Test Method to to update Global span records
    *  @name : testEditFinancialsGlobal
    *  @param : none
    *  @return : none
    *************************************************************************/
    
     static testMethod void testEditFinancialsGlobal(){
        
        initializeData();
        system.runAs(u1){
        // this is to cover the Volume unit Total Tons and without any values function on the copy and paste page
        //Span = Global 
        PageReference pRef = new PageReference(IPM_ConstantUtils.FINANCIAL_CONTROLLER_STR+projectList[0].Id);
        Test.setCurrentPage(pRef);
        system.assertNotEquals(pRef, null);
        IPM_FinancialCopyPasteGrid ipmFinCon2=new IPM_FinancialCopyPasteGrid();        
        ipmFinCon2.Sustainability=sust_3 ;
        ipmFinCon2.Span= Global_STR;
        ipmFinCon2.submit();
        List<SelectOption> selOpts=ipmFinCon2.options;
        selOpts.add(new SelectOption(lstFinancial[0].Id,lstFinancial[0].Id));
        selOpts.add(new SelectOption(lstFinancial[1].Id,lstFinancial[1].Id));
        selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));        
        system.assertEquals(selOpts.isEmpty() , false,EMPTY_LIST);
        ipmFinCon2.ListCountries = lstFinancial[0].Id;
        ipmFinCon2.getCountryValue();
        ipmFinCon2.submit();
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
        ipmFinCon2.goBack();
       
        // this is to cover the Volume unit Total '000 units and without any values function on the copy and paste page
       //Span = Global, with complete input
        PageReference pRef2 = new PageReference(IPM_ConstantUtils.FINANCIAL_CONTROLLER_STR+projectList[0].Id);

        Test.setCurrentPage(pRef2);
        system.assertNotEquals(pRef2, null);
        IPM_FinancialCopyPasteGrid ipmFinCon5=new IPM_FinancialCopyPasteGrid(); 
        ipmFinCon5=new IPM_FinancialCopyPasteGrid();        
        ipmFinCon5.Sustainability=sust_3 ;
        ipmFinCon5.Span= Global_STR;
        ipmFinCon5.submit();
        selOpts=ipmFinCon5.options;
        selOpts.add(new SelectOption(lstFinancial[0].Id,lstFinancial[0].Id));        
        system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
        ipmFinCon5.ListCountries = lstFinancial[0].Id;
        ipmFinCon5.getCountryValue();
        rowcol = input2;
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[0].Id,Global_STR,projectList[0].IPM_Project_Type__c);

        ipmFinCon5.goBack();
        
        // this is to cover the Volume unit Total total and with complete all the values on the copy and paste page
        //Span = Global, with complete input
        
        /*PageReference pRef3 = new PageReference(IPM_ConstantUtils.FINANCIAL_CONTROLLER_STR+projectList[0].Id);
        Test.setCurrentPage(pRef3);
        system.assertNotEquals(pRef3, null);
        IPM_FinancialCopyPasteGrid ipmFinConGlobal1=new IPM_FinancialCopyPasteGrid(); 
        ipmFinConGlobal1=new IPM_FinancialCopyPasteGrid();        
        ipmFinConGlobal1.Sustainability=sust_3 ;
        ipmFinConGlobal1.Span= Global_STR;
        ipmFinConGlobal1.submit();
        selOpts=ipmFinConGlobal1.options;
        selOpts.add(new SelectOption(lstFinancial[0].Id,lstFinancial[0].Id));        
        system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
        ipmFinConGlobal1.ListCountries = lstFinancial[0].Id;
        ipmFinConGlobal1.getCountryValue();
        rowcol = input4;
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[0].Id,Global_STR,projectList[0].IPM_Project_Type__c);
        ipmFinConGlobal1.goBack();*/
        
          // this is to cover the Volume unit Total '000 Units and with complete all the values on the copy and paste page
        //Span = Global, with complete input        
        PageReference pRef5 = new PageReference(IPM_ConstantUtils.FINANCIAL_CONTROLLER_STR+projectList[0].Id);
        Test.setCurrentPage(pRef5);
        system.assertNotEquals(pRef5, null);
        IPM_FinancialCopyPasteGrid ipmFinConGlobal3=new IPM_FinancialCopyPasteGrid(); 
        ipmFinConGlobal3=new IPM_FinancialCopyPasteGrid();        
        ipmFinConGlobal3.Sustainability=sust_3 ;
        ipmFinConGlobal3.Span= Global_STR;
        ipmFinConGlobal3.submit();
        selOpts=ipmFinConGlobal3.options;
        selOpts.add(new SelectOption(lstFinancial[0].Id,lstFinancial[0].Id));        
        system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
        ipmFinConGlobal3.ListCountries = lstFinancial[0].Id;
        ipmFinConGlobal3.getCountryValue();
        rowcol = input3;
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[0].Id,Global_STR,projectList[0].IPM_Project_Type__c);
        ipmFinConGlobal3.goBack();
        
        
        //negative testing, with no input at all when a submit is clicked without any input.
        PageReference pRef4 = new PageReference(IPM_ConstantUtils.FINANCIAL_CONTROLLER_STR+projectList[0].Id);
        Test.setCurrentPage(pRef4);
        system.assertNotEquals(pRef4, null);
        IPM_FinancialCopyPasteGrid ipmFinConGlobal2=new IPM_FinancialCopyPasteGrid(); 
        ipmFinConGlobal2=new IPM_FinancialCopyPasteGrid();        
        ipmFinConGlobal2.Sustainability=sust_3 ;
        ipmFinConGlobal2.Span= Global_STR;
        ipmFinConGlobal2.submit(); 
        List<SelectOption> selOpts1=ipmFinConGlobal2.options;
        system.assertNotEquals(selOpts1.isEmpty() , false, EMPTY_LIST);
        ipmFinConGlobal2.ListCountries = lstFinancial[0].Id;
        ipmFinConGlobal2.getCountryValue();
        rowcol = '';
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[0].Id,Global_STR,projectList[0].IPM_Project_Type__c);
        ipmFinConGlobal2.goBack();
        
        }
    }
    
   /**********************************************************************
    *  @Description: Test Method to to update Regional span records
    *  @name : testEditFinancialsRegional
    *  @param : none
    *  @return : none
    *************************************************************************/
    
     static testMethod void testEditFinancialsRegional(){
        initializeData();
        system.runAs(u1){  
        // this is to cover the Volume unit Total Tons and without any values function on the copy and paste page
       projectList[1].IPMProject_Span__c = Regional_STR;
        update projectList[1];
        PageReference pRef = new PageReference(IPM_ConstantUtils.FINANCIAL_CONTROLLER_STR+projectList[1].Id);
        Test.setCurrentPage(pRef);
        system.assertNotEquals(pRef, null);
        IPM_FinancialCopyPasteGrid ipmFinConReg1=new IPM_FinancialCopyPasteGrid();        
        ipmFinConReg1.Sustainability=sust_3 ;
        ipmFinConReg1.Span= Regional_STR;
        ipmFinConReg1.submit();
        List<SelectOption> selOpts=ipmFinConReg1.options;
        selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));        
        system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
        ipmFinConReg1.ListCountries = lstFinancial[2].Id;
        ipmFinConReg1.getCountryValue();
        ipmFinConReg1.submit();
        String rowcol = input1;
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[2].Id,Regional_STR,projectList[1].IPM_Project_Type__c);
        ipmFinConReg1.goBack();
        
        // this is to cover the Volume unit Total '000 units and with all the values function on the copy and paste page
       
        PageReference pRef1 = new PageReference(IPM_ConstantUtils.FINANCIAL_CONTROLLER_STR+projectList[1].Id);
        Test.setCurrentPage(pRef1);
        system.assertNotEquals(pRef1, null);
        IPM_FinancialCopyPasteGrid ipmFinConReg2=new IPM_FinancialCopyPasteGrid();
        ipmFinConReg2.submit();
        selOpts=ipmFinConReg2.options;
        selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));        
        system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
        ipmFinConReg2.ListCountries = lstFinancial[2].Id;
        ipmFinConReg2.getCountryValue();
        ipmFinConReg2.submit();
        rowcol = input3;
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,lstFinancial[2].Id,Regional_STR,projectList[1].IPM_Project_Type__c);
       
       // this is to cover the Volume unit Total total and with complete all the values on the copy and paste page
         
      /*  PageReference pRef3 = new PageReference(IPM_ConstantUtils.FINANCIAL_CONTROLLER_STR+projectList[1].Id);
        Test.setCurrentPage(pRef3);
        system.assertNotEquals(pRef3, null);        
        IPM_FinancialCopyPasteGrid ipmFinConReg3=new IPM_FinancialCopyPasteGrid();
        ipmFinConReg3.submit();
        selOpts=ipmFinConReg3.options;
        selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));        
        system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
        ipmFinConReg3.ListCountries = lstFinancial[2].Id;
        ipmFinConReg3.getCountryValue();
        ipmFinConReg3.submit();
        rowcol = input4;
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,ipmFinConReg3.ListCountries,Regional_STR,projectList[1].IPM_Project_Type__c);
        rowcol = '[]';
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,ipmFinConReg3.ListCountries,Regional_STR,projectList[1].IPM_Project_Type__c);*/
        }
     }
     
    /**********************************************************************
    *  @Description: Test Method to to update Local span records
    *  @name : testEditFinancialsLocal
    *  @param : none
    *  @return : none
    *************************************************************************/
    
     static testMethod void testEditFinancialsLocal(){
        initializeData(); 
        // negative testing with only [] this when goes as input the serialization doesn't happen.
        system.runAs(u1){
        projectList[2].IPMProject_Span__c = Local_STR;
        update projectList[2];
      /*  PageReference pRef2 = new PageReference(IPM_ConstantUtils.FINANCIAL_CONTROLLER_STR+projectList[2].Id);
        Test.setCurrentPage(pRef2);
        IPM_FinancialCopyPasteGrid ipmFinConLoc1=new IPM_FinancialCopyPasteGrid();        
        ipmFinConLoc1.Sustainability='5';
        ipmFinConLoc1.Span= Local_STR;
        system.assertEquals(ipmFinConLoc1.Span, Local_STR);
        List<SelectOption> selOpts=ipmFinConLoc1.options;
        selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));
        system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
        ipmFinConLoc1.ListCountries = lstFinancial[2].Id;
        ipmFinConLoc1.getCountryValue();
        ipmFinConLoc1.submit();
        String rowcol = '[]';
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,ipmFinConLoc1.ListCountries,Local_STR,projectList[2].IPM_Project_Type__c);
        rowcol = input1;
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,ipmFinConLoc1.ListCountries,Local_STR,projectList[2].IPM_Project_Type__c);
        */
        // this is to cover the Volume unit Total '000 units and without any values function on the copy and paste page
       
        PageReference pRef3 = new PageReference(IPM_ConstantUtils.FINANCIAL_CONTROLLER_STR+projectList[2].Id);
        Test.setCurrentPage(pRef3);
        IPM_FinancialCopyPasteGrid ipmFinConLoc2=new IPM_FinancialCopyPasteGrid();
        ipmFinConLoc2.Sustainability='5';
        ipmFinConLoc2.Span= Local_STR;
        system.assertEquals(ipmFinConLoc2.Span, Local_STR);
         List<SelectOption> selOpts= ipmFinConLoc2.options;
         selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));        
        system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
        ipmFinConLoc2.ListCountries = lstFinancial[2].Id;
        ipmFinConLoc2.getCountryValue();
        ipmFinConLoc2.submit();
         String rowcol = input2;
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,ipmFinConLoc2.ListCountries,Local_STR,projectList[2].IPM_Project_Type__c);
        
         // this is to cover the Volume unit Total total and with complete all the values on the copy and paste page
        
        PageReference pRef4 = new PageReference(IPM_ConstantUtils.FINANCIAL_CONTROLLER_STR+projectList[2].Id);
        Test.setCurrentPage(pRef4);
        IPM_FinancialCopyPasteGrid ipmFinConLoc3=new IPM_FinancialCopyPasteGrid();
        ipmFinConLoc3.Sustainability='5';
        ipmFinConLoc3.Span= Local_STR;
        system.assertEquals(ipmFinConLoc3.Span, Local_STR);
        selOpts.add(new SelectOption(lstFinancial[2].Id,lstFinancial[2].Id));        
        system.assertEquals(selOpts.isEmpty() , false, EMPTY_LIST);
        ipmFinConLoc3.ListCountries = lstFinancial[2].Id;
        ipmFinConLoc3.getCountryValue();
        ipmFinConLoc3.submit();
        rowcol = input4;
        IPM_FinancialCopyPasteGrid.getFinancialyear(rowcol,ipmFinConLoc3.ListCountries,Local_STR,projectList[2].IPM_Project_Type__c);
        
     }
        
     }
    

}