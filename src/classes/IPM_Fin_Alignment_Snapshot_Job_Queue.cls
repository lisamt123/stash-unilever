public with sharing class IPM_Fin_Alignment_Snapshot_Job_Queue implements Queueable {       
        private Id projId = null;
        private Id docId = null;
        private String gateDocType = IPM_ConstantUtils.BLANK;
        public String sourceSnapShot = IPM_ConstantUtils.BLANK;
        public Integer localProjectsCount=0;
        public List<IPM_Financial__c> localFinancialList = new List<IPM_Financial__c>();
        public static final String CORE_STRATEGIC_INNOVATION='Innovation';
        public static final String Year ='3';
        public Boolean showBccTable = false;
        private static final String CLASS_NAME = IPM_Fin_Alignment_Snapshot_Job_Queue.class.getName();//Class Name for Exception Logging
        
        
        public IPM_Fin_Alignment_Snapshot_Job_Queue(Id projId, Id docId, String gateDocType) {
            this.projId = projId;
            this.docId = docId;
            this.gateDocType = gateDocType;
        }
        
        public void execute(QueueableContext context) {
            
            try{
            	
            	IPM_Project__c projectInContext  = [SELECT Id,Name,IPM_Phase__c,IPMProject_Span__c,IPM_GateKeeping_Model__c,IPM_ProjectGKM__c FROM IPM_Project__c WHERE Id =:projId LIMIT 1][0];
            
	            if(projectInContext.IPM_ProjectGKM__c.equals(IPM_ConstantUtils.GATE_KEEPING_MODEL_3) || projectInContext.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
	                showBccTable = true;
	            }
	
	            
	            if(projectInContext != null && (gateDocType==IPM_ConstantUtils.CONTRACT_GATE || gateDocType==IPM_ConstantUtils.MARKET_READY_GATE)){
	                String projectSpan = projectInContext.IPMProject_Span__c;
	                
	                List<IPM_Project_CC_Alignment_Snapshot__c> financialAlignmentSnapshotList= new List<IPM_Project_CC_Alignment_Snapshot__c>();
	                
	                if(projectSpan==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && projId!=null){
	                    
	                    localProjectsCount=[SELECT Count() FROM IPM_Project__c WHERE IPM_Parent_Project__r.IPM_Parent_Project__c=:projId];
	                    
	                    if(localProjectsCount>0) {
	                        localFinancialList=[SELECT Id,IPM_Financial_Postfix__c,Local_Project__c,Local_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.Rollout_Plan_Target_Launch_Date__c,
	                                                   Regional_Project__c,Regional_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.name,Contract_Approved__c,MR_Approved__c, 
	                                                   Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c,Is_BC_Confirmed_Capability__c
	                                            FROM IPM_Financial__c 
	                                            WHERE isActive__c=true and Regional_Project__r.IPM_Parent_Project__c=:projId and Local_Project_isNull__c = :IPM_ConstantUtils.IPM_false];
	                        }
	                     else if(showBccTable)
	                     {
	                           localFinancialList=[SELECT Id,IPM_Financial_Postfix__c,Local_Project__r.IPM_Phase__c,Local_Project__c,Local_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.Rollout_Plan_Target_Launch_Date__c,
	                                                   Regional_Project__c,Regional_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.name,
	                                                   Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c,Is_BC_Confirmed_Capability__c,Contract_Approved__c, MR_Approved__c,
	                                                    (SELECT Turnover_Regional__c,Turnover_Contract__c,Turnover_MR__c,Advertising_Promotions_Regional__c,Advertising_Promotions_Contract__c,
	                                                Advertising_Promotions_MR__c,GM_of_TO_Regional__c,GM_of_TO_Contract__c,GM_of_TO_MR__c,Turnover_Global__c,Advertising_Promotions_Global__c,GM_of_TO_Global__c 
	                                            FROM IPM_Financial_Years__r 
	                                            WHERE Year_Type__c=: CORE_STRATEGIC_INNOVATION AND Year__c=: Year)
	                                            FROM IPM_Financial__c 
	                                            WHERE isActive__c=true and IPM_Project_Rollout__r.IPM_Project__c=:projId and Local_Project_isNull__c = :IPM_ConstantUtils.IPM_false];
	                        
	                     }   
	                }
	                else if(projectSpan==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && projId!=null){
	                    localProjectsCount=[SELECT Count() FROM IPM_Project__c WHERE IPM_Parent_Project__c=:projId];
	                    if(localProjectsCount>0) {
	                        localFinancialList=[SELECT Id,IPM_Financial_Postfix__c,Local_Project__c,Local_Project__r.IPM_Phase__c,Local_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.Rollout_Plan_Target_Launch_Date__c,Regional_Project__c,Regional_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.name,
	                                                   Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c,Is_BC_Confirmed_Capability__c,Contract_Approved__c, MR_Approved__c,
	                                               (SELECT Turnover_Regional__c,Turnover_Contract__c,Turnover_MR__c,Advertising_Promotions_Regional__c,Advertising_Promotions_Contract__c,
	                                                Advertising_Promotions_MR__c,GM_of_TO_Regional__c,GM_of_TO_Contract__c,GM_of_TO_MR__c,Turnover_Global__c,Advertising_Promotions_Global__c,GM_of_TO_Global__c 
	                                            FROM IPM_Financial_Years__r 
	                                            WHERE Year_Type__c=: CORE_STRATEGIC_INNOVATION AND Year__c=: Year)
	                                            FROM IPM_Financial__c 
	                                            WHERE isActive__c=true and Regional_Project__c=:projId and Local_Project_isNull__c = :IPM_ConstantUtils.IPM_false] ;
	                        }       
	                 
	                                         
	                }
	                else if(projectSpan==IPM_ConstantUtils.PROJECT_SPAN_LOCAL && projId!=null){
	               
	                    localFinancialList=[SELECT Id,Local_Project__c,Local_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.Rollout_Plan_Target_Launch_Date__c,
	                                               Regional_Project__c,Regional_Project__r.IPM_Target_Launch_Dates__c,Local_Project__r.name,Contract_Approved__c, MR_Approved__c,
	                                               Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c,Is_BC_Confirmed_Capability__c,IPM_Financial_Postfix__c
	                                        FROM IPM_Financial__c 
	                                        WHERE isActive__c=true and Local_Project__c=:projId];
	                }
	                
	                
	                for(IPM_Financial__c localProjFin : localFinancialList ){
	                    
	                    sourceSnapShot = localProjFin.IPM_Financial_Postfix__c;
	                    
	                    IPM_Project_CC_Alignment_Snapshot__c finSnapShot = new IPM_Project_CC_Alignment_Snapshot__c();
	                    
	                    finSnapShot.Name = localProjFin.Local_Project__r.name;
	                    
	                    //populate business case confirmed at local
	                    if(gateDocType==IPM_ConstantUtils.CONTRACT_GATE){
	                        
	                        if(localProjFin.IPM_Business_Case_Confirmed__c){
	                            finSnapShot.IPM_BC_Confirmation_Text__c = IPM_ConstantUtils.BCC_CONFIRMED;
	                        }
	                        else{
	                            finSnapShot.IPM_BC_Confirmation_Text__c = IPM_ConstantUtils.BCC_UNCONFIRMED;
	                        }
	
	                    }
	                    else if(gateDocType==IPM_ConstantUtils.MARKET_READY_GATE){
	
	                        if(localProjFin.Is_BC_Confirmed_Capability__c){
	                            finSnapShot.IPM_BC_Confirmation_Text__c = IPM_ConstantUtils.BCC_CONFIRMED;
	                        }
	                        else{
	                            finSnapShot.IPM_BC_Confirmation_Text__c = IPM_ConstantUtils.BCC_UNCONFIRMED;
	                        }
	                        
	                    }
	                    
	                    
	                    if(localProjFin.IPM_Financial_Years__r !=null){
                            finSnapShot.IPM_Y3GTO__c = String.ValueOf(localProjFin.IPM_Financial_Years__r[0].get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER+sourceSnapShot+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX));
                            finSnapShot.IPM_Y3ITO__c = String.ValueOf(localProjFin.IPM_Financial_Years__r[1].get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER+sourceSnapShot+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX));
                            finSnapShot.IPM_GM_of_TO_Percentage__c = String.ValueOf(localProjFin.IPM_Financial_Years__r[0].get(IPM_ConstantUtils.FIELD_LITERAL_ADVERTISING_PROMOTIONS+sourceSnapShot+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX));
                            finSnapShot.IPM_Advertising_Promotions__c = String.ValueOf(localProjFin.IPM_Financial_Years__r[0].get(IPM_ConstantUtils.FIELD_LITERAL_GM_OF_TO+sourceSnapShot+IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX));
                        }
	                    
	                    //populate financial misalignment
	                    if(localProjFin.Misaligned__c){
	                        finSnapShot.IPM_Financial_Aligned__c = IPM_ConstantUtils.MISALIGNED;
	                    }
	                    else{
	                        finSnapShot.IPM_Financial_Aligned__c = IPM_ConstantUtils.ALIGNED;
	                    }
	                    
	                    //populate TLD misalignment
	                    if(localProjFin.Local_Project__r.Rollout_Plan_Target_Launch_Date__c == localProjFin.Local_Project__r.IPM_Target_Launch_Dates__c){
	                        finSnapShot.IPM_Financial_TLD_Aligned__c = IPM_ConstantUtils.ALIGNED;
	                    }
	                    else{
	                        finSnapShot.IPM_Financial_TLD_Aligned__c = IPM_ConstantUtils.MISALIGNED;
	                    }
	                    
	                    finSnapShot.IPM_Project_Document__c = docId ;
	                    
	                    financialAlignmentSnapshotList.add(finSnapShot);
	                }
	                
	                
	                if(!financialAlignmentSnapshotList.isEmpty()){
	                    insert financialAlignmentSnapshotList;
	                }
	                
	            
	            }
            
            }
            catch(Exception ex)
            {
             
	            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
	                    'Create Fin Alignment Snapshot',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
            
            
            
        }
            
}