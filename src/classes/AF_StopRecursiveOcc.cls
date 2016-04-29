/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_StopRecursiveOcc
   @CreateDate : 21/6/2014
   @Description : This is a controller class for trigger's 
   @			  this is used to stop the recursive trigger
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public class AF_StopRecursiveOcc {
	// Static variables are local to the context of a Web request  
	// (or testMethod during a runTests call)  
	// Therefore, this variable will be initialized as false  
	// at the beginning of each Web request which accesses it.  
	private static boolean alreadyCreated = false;
	/***********************************************************************************
*  @Description: this method variable will be initialized as false  
	             at the beginning of each Web request which accesses it.
*  @name : hasAlreadyCreated
*  @param : none
*  @return: boolean.
*************************************************************************************/
	public static boolean hasAlreadyCreated() {
		return alreadyCreated;
	}
 
	/***********************************************************************************
*  @Description: this method By setting the variable to true, it maintains this 
	             new value throughout the duration of the request.
*  @name : setAlreadyCreated
*  @param : none
*  @return: none.
*************************************************************************************/
	public static void setAlreadyCreated() {
		alreadyCreated = true;
	}
}