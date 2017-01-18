trigger WU_SetWarehousePOC on WU_Master_Warehouse__c(After Insert,Before Insert, before update,after update) 
{
        if(Trigger.isAfter && trigger.isupdate){
            system.debug('----t---'+Trigger.new[0].WU_Approval_Status__c);
             system.debug('---tt----'+Trigger.old[0].WU_Approval_Status__c);
             
        }
    
    
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
        System.debug('Again *****tets*******'+WU_warehousUtility.isTrggerExecuted);
        if(Trigger.isUpdate && Trigger.isAfter) //
        {                       
           if(!WU_warehousUtility.isTrggerExecuted)
            {
                WU_CreateCapacityDetails duplicateCheck = new WU_CreateCapacityDetails();
                duplicateCheck.checkInsertRecordOrDisplayError(trigger.new, trigger.newMap,trigger.oldMap); 
                WU_warehousUtility.isTrggerExecuted = TRUE;
            }
                
                WU_SetWarehousePOCHandler.wareHouseShare(trigger.new);
                System.debug('Again ************');
                List<WU_Master_Warehouse__c> sendMail=new List<WU_Master_Warehouse__c>();
                for(WU_Master_Warehouse__c wc: trigger.new){
                System.debug('One More Time1' +trigger.oldMap +' ' + trigger.newMap);
                System.debug('One More Time2' +trigger.oldMap +' ' + trigger.newMap);
                System.debug('Once Again'+trigger.oldMap.get(wc.Id). WU_Approval_Status__c+' ' +trigger.newMap.get(wc.id).WU_Approval_Status__c);
                System.debug('Old Map >>>>>' + Trigger.OldMap.get(wc.Id));
                System.debug('One More Time' +trigger.oldMap.get(wc.Id) +' ' + trigger.newMap.get(wc.Id));
                    if(wc.WU_Approval_Status__c=='Submitted' && wc.WU_Approval_Status__c != Trigger.OldMap.get(wc.Id).WU_Approval_Status__c){
                        sendMail.add(wc);
                        System.debug('One More Time 3' +trigger.oldMap);
                        System.debug('One More Time 4' + trigger.newMap);
                    }
                }
                if(!sendMail.isEmpty()){
                    WU_SetWarehousePOCHandler.sendEmailSecPOC(trigger.new);
                    //WU_SetWarehousePOCHandler.sendRejectionEmailSecPOC(trigger.new);
                } 
                List<WU_Master_Warehouse__c> sendMailRej=new List<WU_Master_Warehouse__c>();
                for(WU_Master_Warehouse__c wcRej: trigger.new){
                System.debug('Once Again'+trigger.oldMap.get(wcRej.Id). WU_Approval_Status__c+' ' +trigger.newMap.get(wcRej.id).WU_Approval_Status__c);
                    if(wcRej.WU_Approval_Status__c=='Rejected' && wcRej.WU_Approval_Status__c != Trigger.OldMap.get(wcRej.Id).WU_Approval_Status__c){
                        sendMailRej.add(wcRej);
                        System.debug('Rejection');
                        
                    }
                }  
                if(!sendMailRej.isEmpty()){
                    //WU_SetWarehousePOCHandler.sendEmailSecPOC(trigger.new);
                    WU_SetWarehousePOCHandler.sendRejectionEmailSecPOC(trigger.new);
                    System.debug('Prateek Jhanwar');
                }  
                
                List<WU_Master_Warehouse__c> sendMailApp=new List<WU_Master_Warehouse__c>();
                for(WU_Master_Warehouse__c wcApp: trigger.new){
                System.debug('Once Again'+trigger.oldMap.get(wcApp.Id). WU_Approval_Status__c+' ' +trigger.newMap.get(wcApp.id).WU_Approval_Status__c);
                    if(wcApp.WU_Approval_Status__c=='Approved' && wcApp.WU_Approval_Status__c != Trigger.OldMap.get(wcApp.Id).WU_Approval_Status__c){
                        sendMailApp.add(wcApp);
                        System.debug('Approved');
                        
                    }
                }  
                if(!sendMailApp.isEmpty()){
                    //WU_SetWarehousePOCHandler.sendEmailSecPOC(trigger.new);
                    WU_SetWarehousePOCHandler.sendApprovalEmailSecPOC(trigger.new);
                    System.debug('Prateek Jhanwar');
                } 
            /*if(!WU_warehousUtility.isTrggerExecuted)
            {
             WU_CreateCapacityDetails duplicateCheck = new WU_CreateCapacityDetails();
                duplicateCheck.checkInsertRecordOrDisplayError(trigger.new, trigger.newMap,trigger.oldMap); 
                WU_warehousUtility.isTrggerExecuted = TRUE;
            }*/
            
                
               
         }
   }