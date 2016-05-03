public Class NAFS_Utility{
    /*Static variable and method are used in Opportunity trigger to avoid recursion*/
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}