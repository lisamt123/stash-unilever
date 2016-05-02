global without sharing class AA_TheAgentSingleExecution {
    private static boolean blnAlreadyDone = false;

    public static boolean hasAlreadyDone(){ 
        return blnAlreadyDone;
    }
    
    public static void setAlreadyDone() {
        blnAlreadyDone = true;  
    }
    
    public static void forceResetAlreadyDone() {
        blnAlreadyDone = false; 
    }
    
}