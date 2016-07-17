/**********************************************************************
Purpose: Utility class for Food Solution (NAFS).
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    11/May/2016     Utility class of NAFS project
                     10/June/2016    Updated to add test user creation method  
***********************************************************************/

public Class FS_Utility{
    //Purpose: Used in Opportunity trigger to avoid recursion.Class NAFS_OpportunityHelper, update Opp with Opp Line Item Value
    private static boolean run = true;
    private static boolean run2 = true;
    private static boolean run3 = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    public static boolean run2Once(){
        if(run2){
            run2=false;
            return true;
        }else{
            return run2;
        }
    }
    public static boolean run3Once(){
        if(run3){
            run3=false;
            return true;
        }else{
            return run3;
        }
    } 
   }