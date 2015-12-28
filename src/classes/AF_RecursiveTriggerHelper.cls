/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_RecursiveTriggerHelper
   @CreateDate : 22/8/2014
   @Description : This is class is sued in AF_OOPSEstimateController class 
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
global class AF_RecursiveTriggerHelper {
   
  	private static boolean alreadyModified = false;

    public static boolean isAlreadyModified() {
        return alreadyModified;
    }
   
    public static void setAlreadyModified() {
        alreadyModified = true;
    }
}