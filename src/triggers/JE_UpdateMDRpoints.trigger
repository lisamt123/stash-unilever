trigger JE_UpdateMDRpoints on JE_Job_Evaluation__c (after update) {
    if(JE_UtilRecursiveCtrl.isupdateRecord){
        if(trigger.isAfter){                                                             
            if(trigger.isUpdate){ 
                JE_UpdateMDRpointsHandler updateMdr = new JE_UpdateMDRpointsHandler();
                LIST<JE_Points_Table__c> jePoints = updateMdr.jobEvalutionsRecords(trigger.new); 
                Integer mdrPoint = updateMdr.determineMdrPoints(jePoints); 
                    if(trigger.old[0].Overall_Total_Score__c != trigger.new[0].Overall_Total_Score__c ){                                                                                    
                          updateMdr.updateJeEvalution(trigger.new,mdrPoint);                                             
                    }
            }                        
        }   
    }  
}