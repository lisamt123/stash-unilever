trigger UpdateCatFinanceApprover  on AF_Brand_Estimate__c (before Insert,before Update) 
{
    list<AF_Brand_Estimate__c>  afBrandEstimates=new list<AF_Brand_Estimate__c>();
    for(AF_Brand_Estimate__c  afBrand:Trigger.new)
    {
        if(afBrand.AF_Status_Base_Fees__c=='With Agency'){
        afBrandEstimates.add(afBrand); 
        if(afBrand.AF_Agency__c != null)
            AF_UpdateBrandEstimateCatApproverValues.UpdateOopsagency(afBrand);
        }
        if(!afBrand.TriggerEmailAgency__c){
            system.debug('afBrand.TriggerEmailAgency__c...'+afBrand.TriggerEmailAgency__c);
            afBrand.Archived_BrandEstimate_Quarter__c = afBrand.AF_Basefee_Estimate_Initial_Quarter__c;
        }
               
    }
    AF_UpdateBrandEstimateCatApproverValues.UpdateBrandingEstimates(afBrandEstimates);
}