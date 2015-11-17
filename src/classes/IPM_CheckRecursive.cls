/**
@Description: Class with a static variable to stop recursiveness in the trigger. 
Use it wisely, this will not work as a part of complex Workflow field updates.
@Author: Cognizant Technology
@Date: Oct 2014
**/
public with sharing class IPM_CheckRecursive {
    
    //@Description: Internal static variables, not exposed to be accessed outside the class
    @Testvisible private static boolean run = true; //used while only being run once
    @Testvisible private static boolean runAgain = true;//used otherwise
    
    /*
     * @Description:Use it if you want to execute your code only once.
     * @return: static boolean value
    */
    public static boolean runOnce(){
        
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
    public static void  resetCounter()
    {
        run = true;
    }
    
    /*
     * @Description: Use it if you want to execute the code only once as a part of one Workflow field update
     * @return: static boolean value
    */
    public static boolean runOnceAgain(){
        
        if(runAgain){
            runAgain=false;
            return true;
        }else{
            return runAgain;
        }
    }
}