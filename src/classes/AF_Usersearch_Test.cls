/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Usersearch_Test
@Created Date : 02/08/2014.
@Description : This Test class for AF_Usersearch apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_Usersearch_Test
{
    static user userForusersearch;
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : af_usersearch1
*  @param : none
*  @return : none
*************************************************************************/   
    static testMethod void af_usersearch1() 
    {
        Test.startTest();
        userForusersearch=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email,Name,FirstName,LastName FROM user WHERE id=:userForusersearch.id LIMIT 1];
        system.runAs(u)
        {
            System.Assert(u.Id != null, AF_TestFactory_Helper.USER_RECORD); 
            AF_Usersearch  aff=new AF_Usersearch();
            aff.firstName=u.firstname;
            aff.lastname=u.lastname;
            aff.email=u.email;
            aff.name=u.name;
            aff.sortField='Email';
            aff.sortDir='desc';
            aff.toggleSort();
            aff.runSearch();
        }
        Test.stopTest();   
    }
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : af_usersearch2
*  @param : none
*  @return : none
*************************************************************************/   
    static testmethod void af_usersearch2()
    {
        Test.startTest();
        userForusersearch=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email,Name,FirstName,LastName FROM user WHERE id=:userForusersearch.id LIMIT 1];
        system.runAs(u)
        {
            System.Assert(u.Id != null, AF_TestFactory_Helper.USER_RECORD);
            AF_Usersearch  aff=new AF_Usersearch();
            aff.firstName=u.firstname;
            aff.lastname=u.lastname;
            aff.email=u.email;
            aff.name=u.name;   
            aff.toggleSort();
            aff.runSearch();
        }
        Test.stopTest();
    }
}