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
    private static boolean runaccPlan = true;
    private static boolean runobj = true;
    private static boolean run4 = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    public static boolean runaccPlanOnce(){
        if(runaccPlan){
            runaccPlan=false;
            return true;
        }else{
            return runaccPlan;
        }
    }
    public static boolean runObjOnce(){
        if(runobj){
            runobj=false;
            return true;
        }else{
            return runobj;
        }
    } 
    public static boolean run4Once(){
        if(run4){
            run4=false;
            return true;
        }else{
            return run4;
        }
    }
   }