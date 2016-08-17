trigger updateMDRpoints on JE_Job_Evaluation__c (after update) {
    if(UtilRecursiveCtrl.isupdateRecord != true){
        if(trigger.isAfter){                                                             
            if(trigger.isUpdate){ 
                updateMDRpointsHandler updateMdr = new updateMDRpointsHandler();
                LIST<JEPointsTable__c> jePoints = updateMdr.jobEvalutionsRecords(trigger.new); 
                Integer mdrPoint = updateMdr.determineMdrPoints(jePoints); 
                    if(trigger.old[0].Overall_Total_Score__c != trigger.new[0].Overall_Total_Score__c ){                                                                                    
                          updateMdr.updateJeEvalution(trigger.new,mdrPoint);                                             
                    }
            }                        
        }   
    }  
}