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