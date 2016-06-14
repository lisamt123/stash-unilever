trigger AF_UpdateCatFinanceApprover  on AF_OOPS_Actual__c(before Insert,before Update) 
{
    list<AF_OOPS_Actual__c>  afOopsEstimates=new list<AF_OOPS_Actual__c>();
    for(AF_OOPS_Actual__c afOops:Trigger.new)
    {
        if(afOops.AF_Status__c=='With Category Finance')
           afOopsEstimates.add(afOops);  
        if(afOops.AF_Agency_lk__c != null)
            AF_UpdateOopsEstimateCatApproverValues.UpdateOopsagency(afoops);
             
    }
    AF_UpdateOopsEstimateCatApproverValues.UpdateOopsEstimates(afOopsEstimates);
}