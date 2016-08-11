trigger updateMDRpoints on JE_Job_Evaluation__c (before insert,before update) {
        if(UtilRecursiveCtrl.isupdateRecord != true){
                if(trigger.isBefore){
                        updateMDRpointsHandler updateMdr = new updateMDRpointsHandler();
                        LIST<JE_Points_Table__c> jePoints = updateMdr.jobEvalutionsRecords(trigger.new);
                        Integer mdrPoint = updateMdr.determineMdrPoints(jePoints);
                    if(trigger.isInsert){  
                        System.debug('---records--'+trigger.new);                       
                        for(JE_Job_Evaluation__c je:trigger.new){    
                                je.Range_of_Salary_MDR_points__c = mdrPoint;     
                        }
                    }
                    if(trigger.isUpdate){                 
                        System.debug('---records--'+trigger.new);
                        for(JE_Job_Evaluation__c je:trigger.new){    
                                je.Range_of_Salary_MDR_points__c = mdrPoint;     
                        }
                        UtilRecursiveCtrl.isupdateRecord = true;  
                    }
                }        
          
        }
   
}