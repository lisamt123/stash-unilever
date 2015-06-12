public with sharing class IPM_CheckRecursive {
    
    private static boolean run = true;
    private static boolean runAgain = true;
    
    public static boolean runOnce(){
        
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
    public static boolean runOnceAgain(){
        
        if(runAgain){
            runAgain=false;
            return true;
        }else{
            return runAgain;
        }
    }
}