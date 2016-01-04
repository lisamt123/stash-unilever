/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_Constants 
@CreateDate : 15/9/2014
@Description : This is a Test class for AF_Constants apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class Test_AF_Constants 
{  
     
  /***********************************************************************************
*  @Description: this method will have the test data.
*  @name : Afconstants
*  @param : none.
*  @return: none.
*************************************************************************************/
   Static testMethod void Afconstants()
  {
  
    Test.startTest();
    AF_Constants  cons = new AF_Constants();
    Test.stopTest();
    
  }

}