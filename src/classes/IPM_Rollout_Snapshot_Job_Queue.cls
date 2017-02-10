public with sharing class IPM_Rollout_Snapshot_Job_Queue implements Queueable {
    
        Id projId = null;
        Id docId = null;
        String gateDocType = IPM_ConstantUtils.BLANK;
        public static  ID regionalRecordTypeId =  Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).RecordTypeId;//used for displaying Regional To Local To Country Mapping ;  
    	public static  ID localRecordTypeId = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).RecordTypeId;//used for displaying Regional To Local To Country Mapping;
    	private static final String CLASS_NAME = IPM_Rollout_Snapshot_Job_Queue.class.getName();//Class Name for Exception Logging
    	
        public IPM_Rollout_Snapshot_Job_Queue(Id projId, IPM_Project_Document__c projDoc) {
            this.projId = projId;
            this.docId = projDoc.Id;
            this.gateDocType = projDoc.IPM_GateDocuments__c;
        }
        
        public void execute(QueueableContext context) {
            try
            {

                Boolean bIsGKM3Project = false;
                String showEntity = '';
              
                List<IPM_Project__c> projectList  = [SELECT Id,Name,IPMProject_Span__c,IPM_GateKeeping_Model__c,IPM_ProjectGKM__c FROM IPM_Project__c WHERE Id =:projId LIMIT 1];
                                                     
                if(projectList != null && !projectList.isEmpty()){   
                    
                    IPM_Project__c projectInContext =  projectList[0];
                    
                    System.debug('projectInContext==>'+projectInContext);
                    
                    bIsGKM3Project= IPM_ConstantUtils.GATE_KEEPING_MODEL_3.Equals(projectInContext.IPM_ProjectGKM__c);
                    
                    System.debug('bIsGKM3Project==>'+bIsGKM3Project);
                    
                    showEntity = String.format(Label.IPM_ShowEntity,new String[]{projectInContext.IPMProject_Span__c});
                    
                    System.debug('showEntity==>'+showEntity);
                    
                    Map<String,List<IPM_Project_Rollout__c>> regionalToLocalRolloutList = new Map<String,List<IPM_Project_Rollout__c>>();
                    
                    Map<Id,IPM_Project_Rollout__c> completeLocalRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
                    
                    String queryString = '';                
                    // Get the List of Regional Rollouts based on the Project.
                    // Based on The Project Span, if it is Global we need to refer IPM Project else if it is regional, Regional project needs to be used in wher clause.
                    if(projectInContext.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
                    {
                        // Get the List of Regional Rollouts based on passed global project Id.
                        queryString = 'SELECT Id,Name,IPM_Rollout_Project__c,Market_Cluster_Name__c,(SELECT Id,IPM_Brand__c,Name,IPM_Rollout_Project__c,Target_Launch_Date__c,IPM_Status__c,IPM_Regional_Rollout_Status__c,Regional_Rollout_External_Id__c,Market_Cluster_Name__c  FROM Local_Rollouts__r WHERE recordTypeId =: localRecordTypeId) FROM IPM_Project_Rollout__c WHERE IPM_Project__c = :projId AND recordTypeId =:regionalRecordTypeId AND  ( isActive__c = true OR '+ showEntity +' = true ) LIMIT 10000';
                        list<IPM_Project_Rollout__c> listRollouts = Database.Query(queryString); 
                        
                       // System.debug('listRollouts==>'+listRollouts);
                        
                        for(IPM_Project_Rollout__c regRollout : listRollouts)
                        { 
                            if(!regRollout.Local_Rollouts__r.isEmpty())
                            {
                                if(bIsGKM3Project) {
                                    regionalToLocalRolloutList.put(regRollout.Market_Cluster_Name__c,regRollout.Local_Rollouts__r);
                                }
                                else {
                                    regionalToLocalRolloutList.put(regRollout.IPM_Rollout_Project__c,regRollout.Local_Rollouts__r);
                                }                            
                                completeLocalRolloutMap.putAll(new Map<Id,IPM_Project_Rollout__c>( (List<IPM_Project_Rollout__c>)regRollout.Local_Rollouts__r));
                            }      
                        }
                        
                       // System.debug('regionalToLocalRolloutList==>'+regionalToLocalRolloutList);
                       // System.debug('completeLocalRolloutMap==>'+completeLocalRolloutMap);
                        
                        // Get the list of Regional Project based on passed global project Id.
                        queryString = 'SELECT Id,Name,IPM_Project_Name__c,(SELECT Id,Name,IPM_Brand__c,Target_Launch_Date__c,IPM_Rollout_Project__c,IPM_Status__c,IPM_Regional_Rollout_Status__c,Regional_Rollout_External_Id__c,Market_Cluster_Name__c FROM Regional_Project_Rollout__r WHERE recordTypeId =: localRecordTypeId AND ( isActive__c = true OR '+ showEntity +' = true )) FROM IPM_Project__c WHERE IPM_Parent_Project__c = :projId LIMIT 10000';
                        list<IPM_Project__c> projectRollouts = Database.Query(queryString);
                        System.debug('projectRollouts==>'+projectRollouts);  
                        for(IPM_Project__c regProject : projectRollouts)
                        {
                            if(!regProject.Regional_Project_Rollout__r.isEmpty())
                            {
                                regionalToLocalRolloutList.put(regProject.IPM_Project_Name__c,regProject.Regional_Project_Rollout__r);
                                completeLocalRolloutMap.putAll(new Map<Id,IPM_Project_Rollout__c>((List<IPM_Project_Rollout__c>) regProject.Regional_Project_Rollout__r));
                            }
                        } 
                        
                      //  System.debug('regionalToLocalRolloutList2==>'+regionalToLocalRolloutList);
                      //  System.debug('completeLocalRolloutMap2==>'+completeLocalRolloutMap);                      
    
                    }
                    else if(projectInContext.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                    {
                         // Get the list of Regional Project based on passed global project Id.
                        queryString = 'SELECT Id,Name,IPM_Project_Name__c,(SELECT Id,IPM_Brand__c,Name,IPM_Rollout_Project__c,Target_Launch_Date__c,IPM_Status__c,IPM_Regional_Rollout_Status__c,Regional_Rollout_External_Id__c,Market_Cluster_Name__c FROM Regional_Project_Rollout__r  WHERE recordTypeId =: localRecordTypeId AND ( isActive__c = true OR '+ showEntity +' = true )) FROM IPM_Project__c WHERE Id = :projId LIMIT 10000';
                        list<IPM_Project__c> projectRollouts = Database.Query(queryString); 
                        for(IPM_Project__c regProject : projectRollouts)
                        {
                            if(!regProject.Regional_Project_Rollout__r.isEmpty())
                            {
                                regionalToLocalRolloutList.put(regProject.IPM_Project_Name__c,regProject.Regional_Project_Rollout__r);
                                completeLocalRolloutMap.putAll(new Map<Id,IPM_Project_Rollout__c>((List<IPM_Project_Rollout__c>) regProject.Regional_Project_Rollout__r));
                            }
                        }   
                        
                    }
                    
                    List<IPM_Project_Rollout__c> listProjectRollout = completeLocalRolloutMap.values();
                    queryString = 'SELECT Id,Name,IPM_Brand__c,Target_Launch_Date__c,IPM_Status__c,IPM_Regional_Rollout_Status__c,Regional_Rollout_External_Id__c,Market_Cluster_Name__c,(SELECT Id,Country_Name__c,Local_Rollout__c from IPM_Countries_Local__r where isActive__c = true OR '+ showEntity +' = true ) FROM IPM_Project_Rollout__c where Id in : listProjectRollout AND ( isActive__c = true OR '+ showEntity +' = true ) ';
                    Map<Id,IPM_Project_Rollout__c> localRolloutToCountryMap = new Map<Id,IPM_Project_Rollout__c>((List<IPM_Project_Rollout__c>)Database.Query(queryString));
                    
                   // System.debug('listProjectRollout==>'+listProjectRollout);
                   // System.debug('localRolloutToCountryMap==>'+localRolloutToCountryMap);
                    
                    List<IPM_Project_Rollout_Snapshot__c> rolloutSnapshotList = new List<IPM_Project_Rollout_Snapshot__c>(); 
                    
                    for(String regional : regionalToLocalRolloutList.KeySet())
                    {
                        List<IPM_Project_Rollout__c> associatedLocalRollouts = regionalToLocalRolloutList.get(regional);
                        
                        System.debug('associatedLocalRollouts==>'+associatedLocalRollouts);
                        
                        for(IPM_Project_Rollout__c localRollout : associatedLocalRollouts)
                        {
                            if(localRolloutToCountryMap.containsKey(localRollout.Id))
                            {
                                IPM_Project_Rollout_Snapshot__c rolloutSnapshot = new IPM_Project_Rollout_Snapshot__c();
                                
                                IPM_Project_Rollout__c localRolloutWithCountries  = localRolloutToCountryMap.get(localRollout.Id);
                                List<IPM_Country__c> associatedCountries = localRolloutWithCountries.IPM_Countries_Local__r;
                                List<String> associatedGoes = new List<String>();
                                
                                for(IPM_Country__c lCountry : associatedCountries){
                                    if(lCountry.Country_Name__c != null && lCountry.Country_Name__c.length() > 0){
                                        associatedGoes.add(lCountry.Country_Name__c);
                                    }
                                }
                                
                               // System.debug('localRollout==>'+localRollout);
                                
                                rolloutSnapshot.IPM_Rollout_Countries__c = String.join(associatedGoes,IPM_ConstantUtils.COMMA+' ');
                                rolloutSnapshot.IPM_Brand__c = localRollout.IPM_Brand__c;
                                rolloutSnapshot.IPM_Local_Rollout_Name__c = localRollout.Regional_Rollout_External_Id__c;
                                rolloutSnapshot.IPM_Rollout_Status__c = localRollout.IPM_Regional_Rollout_Status__c;
                                rolloutSnapshot.IPM_Target_Launch_Date__c = localRollout.Target_Launch_Date__c;
                                rolloutSnapshot.IPM_Project_Document__c = docId;
                                rolloutSnapshot.IPM_Project_Span__c = projectInContext.IPMProject_Span__c;
                                rolloutSnapshot.Name = localRollout.Market_Cluster_Name__c;
                                rolloutSnapshotList.add(rolloutSnapshot);
                                   
                            }    
                        }
                        
                        // System.debug('rolloutSnapshotList==>'+rolloutSnapshotList);
                    }
                    
                    if(!rolloutSnapshotList.isEmpty()){
                        insert rolloutSnapshotList;
                    }
                    //Enqueue fin alignment snapshot job in the queue
                    executeFinancialSnapshot(projId,docId,gateDocType);
                    
                  /*  if(gateDocType==IPM_ConstantUtils.CONTRACT_GATE || gateDocType==IPM_ConstantUtils.MARKET_READY_GATE){
                    	ID jobID = System.enqueueJob(new IPM_Fin_Alignment_Snapshot_Job_Queue(projId,docId,gateDocType));
                    }
                  */   
                }
            }
            catch(Exception ex)
            {
             
	            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
	                    'Create Rollout Snapshot',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
        
       }
       
       // This method created to solve the N-Path complexity in main execute function
       private void executeFinancialSnapshot(ID projId,Id docId,String gateDocType){
       	   if(gateDocType==IPM_ConstantUtils.CONTRACT_GATE || gateDocType==IPM_ConstantUtils.MARKET_READY_GATE){
                    	ID jobID = System.enqueueJob(new IPM_Fin_Alignment_Snapshot_Job_Queue(projId,docId,gateDocType));
                    }
       }   

}