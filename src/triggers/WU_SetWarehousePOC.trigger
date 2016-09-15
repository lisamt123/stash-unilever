/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     trigger to updare warehouse record owner, update total & Aberage utilization values. 
*************************************************************/

trigger WU_SetWarehousePOC on WU_Master_Warehouse__c(After Insert,Before Insert, before update,after update) 
{
    
        if (Trigger.isInsert && Trigger.isBefore){
            WU_SetWarehousePOCHandler.onBeforeInsert(trigger.new, trigger.newMap);
        }
        
        if (Trigger.isInsert && Trigger.isAfter){
            WU_SetWarehousePOCHandler.onAfterInsert(trigger.new);
            WU_SetWarehousePOCHandler.wareHouseShare(trigger.new);
        }
        
        if (Trigger.isUpdate && Trigger.isBefore){
            WU_SetWarehousePOCHandler.onBeforeUpdate(trigger.oldMap, trigger.new, trigger.newMap);
        }
        if(Trigger.isUpdate && Trigger.isAfter && !WU_warehousUtility.isTrggerExecuted)
        {
            //if(!WU_UpdateMasterWarehouseHandler.isUpdateFromChild)
            //{
                WU_SetWarehousePOCHandler.wareHouseShare(trigger.new);
                System.debug('Again ************');
                List<WU_Master_Warehouse__c> sendMail=new List<WU_Master_Warehouse__c>();
                for(WU_Master_Warehouse__c wc: trigger.new){
                    if(trigger.oldMap.get(wc.Id).WU_Committed_Max_PalletStorage__c!=trigger.newMap.get(wc.id).WU_Committed_Max_PalletStorage__c){
                        sendMail.add(wc);
                    }
                }
                if(!sendMail.isEmpty()){
                    WU_SetWarehousePOCHandler.sendEmailSecPOC(trigger.new);
                }    
                WU_CreateCapacityDetails duplicateCheck = new WU_CreateCapacityDetails();
                duplicateCheck.checkInsertRecordOrDisplayError(trigger.new, trigger.newMap,trigger.oldMap); 
                WU_warehousUtility.isTrggerExecuted = TRUE;
            //}
         }
   
}