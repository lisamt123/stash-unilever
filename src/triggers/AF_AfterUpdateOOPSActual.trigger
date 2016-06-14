trigger AF_AfterUpdateOOPSActual on AF_OOPS_Actual__c (after update) 
{
    Set<id> OOPActualIds=new set<id>();
    List<AF_OOPS_Actual__c> OOPSActualCollection;
    AF_OOPSRecordManager OOPSRecordManager;
       
    OOPSRecordManager = new AF_OOPSRecordManager();
    if(AF_RecursiveTriggerHelper.isAlreadyModified() == false)
    {
        for(AF_OOPS_Actual__c  oopsActual:Trigger.new )
        {   
            AF_OOPS_Actual__c oldoopsactual=Trigger.oldMap.get(oopsActual.Id); 
            if(oldoopsactual.Overall__c!=oopsActual.Overall__c){               
            //5-09-2014---- if(oopsActual.AF_iS_OOPS_Percentage__c == false && oopsActual.AF_Matrix_Generated__c == false)
             if(oopsActual.AF_iS_OOPS_Percentage__c == false )
            {
                OOPSRecordManager.OOPSActual = oopsActual;       
                OOPSRecordManager.RecalculateOOPSEstimates();
            } 
           } 
        }   
    }   
}