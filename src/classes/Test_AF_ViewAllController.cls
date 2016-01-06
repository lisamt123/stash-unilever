/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_Constants 
@CreateDate : 16/9/2014
@Description : This is a Test class for AF_Constants apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class Test_AF_ViewAllController 
{ 
    public static final string DParentId ;
    public static final string CParentId ;
    public static final string CHParentId;
    public static Boolean ViewComments;
    public static Boolean ViewDocuments;
    public static Boolean ViewChangeHistory;
    public static Boolean agencyEstimate;
    public static Boolean oopEstimate;
    public static Boolean bonusEstimate;
    /***********************************************************************************
*  @Description: this method will have the test data.
*  @name : AFViewAllController
*  @param : none.
*  @return: none.
*************************************************************************************/
    static testmethod void AFViewAllController()
    {
        Test.startTest();
        Profile p=[Select Id from Profile where Name='System Administrator'];       
        //Insert User 
        User u= new User(Alias = 'testab', Email='standarduserab@unilever.com', 
        EmailEncodingKey='UTF-8', LastName='Test Userab', LanguageLocaleKey=AF_Constants.LocaleKey, 
        LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
        TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c=AF_Constants.UT_CATEGORY_FINANCE,isActive=true, 
        UserName='testuserab@test123321.com',AF_Brand__c='Test Brandab',AF_Category__c='Test Beveragesab');
        insert u;    
        System.Assert(u.Id != null, AF_Constants.TEST_ASSERT_MSG);    
        System.runAs(u)
        {
        AF_ViewAllController  viewall = new AF_ViewAllController();
        viewall.CParentId ='14256';
        viewall.DParentId ='4654';
        viewall.CHParentId='3232';
        viewall.ViewComments=true;
        viewall.ViewDocuments=true;
        viewall.ViewChangeHistory=true;
        viewall.agencyEstimate=true;
        viewall.oopEstimate=true;
        viewall.bonusEstimate=true;
        Test.stopTest();
        }
    }
}