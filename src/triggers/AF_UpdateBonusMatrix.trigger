trigger AF_UpdateBonusMatrix on AF_Bonus_Matrix__c(before insert,before update) 
{ 
   List<AF_Bonus_Matrix__c> BonusMatrixRecords=new   List<AF_Bonus_Matrix__c>();
   Integer count=0;
   if(Trigger.new.size()>0){
   for( AF_Bonus_Matrix__c BonusMtx:Trigger.new)
   {
       if(Trigger.isUpdate) {
        if(BonusMtx.AF_Status__c=='Ready for PO' && Trigger.oldMap.get(BonusMtx.Id).AF_Status__c=='Ready for PO'){
        count++;
        }
        else{
        BonusMatrixRecords.add(BonusMtx);
        }
        }
        else{
        BonusMatrixRecords.add(BonusMtx);
        }
         
   }
   }
   if(BonusMatrixRecords.size()>0){
    
   AF_UpdateBonusEstimatesValues5.UpdateExchageRates(Trigger.new);
   }
}