/**********************************************************************
Purpose: Utility class for Food Solution (NAFS).
History :
VERSION AUTHOR         DATE          DETAIL Description
1.0     Accenture    11/May/2016     Created for accountInsert 
***********************************************************************/
public Class NAFS_Utility{
    //Purpose: Used in Opportunity trigger to avoid recursion. Class NAFS_OpportunityHelper, update Opp with Opp Line Item Value
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