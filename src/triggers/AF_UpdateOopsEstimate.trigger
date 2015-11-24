trigger AF_UpdateOopsEstimate on AF_OOPS_Estimate__c(before insert,before update) 
{ 
   List<AF_OOPS_Estimate__c> oopsEstimatesRecords=new   List<AF_OOPS_Estimate__c>();
   Integer count=0;
   if(Trigger.new.size()>0){
   for( AF_OOPS_Estimate__c oopsEst:Trigger.new)
   {

        system.debug('inside loop.oops.');
        if(Trigger.isUpdate) {   
        if(oopsEst.AF_Status__c=='Ready for PO' &&  Trigger.oldMap.get(oopsEst.Id).AF_Status__c=='Ready for PO'){
        count++;
        }
        else{
        oopsEstimatesRecords.add(oopsEst);
        }
        }
        else{
        oopsEstimatesRecords.add(oopsEst);
        }
        
        
         
   }
   }
   if(oopsEstimatesRecords.size()>0){
   //AF_UpdateOopsEstimatesValues2.UpdateExchageRates(Trigger.new);
   //AF_UpdateOopsEstimatesValues3.UpdateExchageRates(Trigger.new);
   system.debug('before calling method.oops.');
   AF_UpdateOopsEstimatesValues5.UpdateExchageRates(oopsEstimatesRecords);
   }

}