trigger JE_UpdateMDRpoints on JE_Job_Evaluation__c (after update) {
    if(UtilRecursiveCtrl.isupdateRecord != true){
        if(trigger.isAfter){                                                             
            if(trigger.isUpdate){ 
                JE_UpdateMDRpointsHandler updateMdr = new JE_UpdateMDRpointsHandler();
                LIST<JEPointsTable__c> jePoints = updateMdr.jobEvalutionsRecords(trigger.new); 
                Integer mdrPoint = updateMdr.determineMdrPoints(jePoints); 
                    if(trigger.old[0].Overall_Total_Score__c != trigger.new[0].Overall_Total_Score__c ){                                                                                    
                          updateMdr.updateJeEvalution(trigger.new,mdrPoint);                                             
                    }
            }                        
        }   
    }  
}