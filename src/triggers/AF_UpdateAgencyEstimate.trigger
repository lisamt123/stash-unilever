trigger AF_UpdateAgencyEstimate on AF_Agency_Estimate__c (before insert,before update) 
{ 
   List<AF_Agency_Estimate__c> agencyEstimatesRecords=new   List<AF_Agency_Estimate__c>();
   Integer count=0;
   if(Trigger.new.size()>0){
   for( AF_Agency_Estimate__c  agencyEst:Trigger.new)
   {
        //system.debug('brandEstimatehandlerHelper.testvar#######'+brandEstimatehandlerHelper.testvar);
        if(!AF_brandEstimatehandlerHelper.testvar){
        if(Trigger.isUpdate) {
        if(agencyEst.AF_Status__c=='Ready for PO' && Trigger.oldMap.get(agencyEst.Id).AF_Status__c=='Ready for PO'){
        count++;
        }
        else{
        agencyEstimatesRecords.add(agencyEst);
        }
        }
        else{
        agencyEstimatesRecords.add(agencyEst);
        }
        system.debug('agencyEstimatesRecords....'+agencyEstimatesRecords);
        }
   }
   }
   if(agencyEstimatesRecords.size()>0){
   system.debug('before calling method.agency.');
   AF_UpdateAgencyEstimatesValues2.UpdateExchageRates(agencyEstimatesRecords);
   }
}