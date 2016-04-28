/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_RecursiveTriggerHelper
@CreateDate : 22/8/2014
@Description : This is class is used in AF_OOPSEstimateController class 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
global class AF_RecursiveTriggerHelper {
	private static boolean alreadyModified = false;
	public static boolean isAlreadyModified() {
		return alreadyModified;
	}
	/**********************************************************************
*  @Description: This method used to stop the recurssion 
*  @name : setAlreadyModified
*  @param : none
*  @return : none
*************************************************************************/  
	public static void setAlreadyModified() {
		alreadyModified = true;
	}
}