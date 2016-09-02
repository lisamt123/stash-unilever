/**********************************************************************
Purpose: Utility class for Food Solution (NAFS).
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture    11/May/2016     Utility class of NAFS project
                     10/June/2016    Updated to add test user creation method  
***********************************************************************/

public Class FS_Utility{
    private static boolean OppProduct= true;//Used in after update trigger - FS_OpportunityHelper
    private static boolean runaccPlan = true;
    private static boolean runobj = true;
    private static boolean ContractProduct= true;//Used in after update trigger - FS_ContractProductHelper
    public static boolean runOnceOppProduct(){
        if(OppProduct){
            OppProduct=false;
            return true;
        }else{
            return OppProduct;
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
    public static boolean runOnceContractProduct(){
        if(ContractProduct){
            ContractProduct=false;
            return true;
        }else{
            return ContractProduct;
        }
    }
   }