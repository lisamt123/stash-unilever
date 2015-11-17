/**
* @author       Cognizant
* @date         27/04/2015
* @description  This class is used for updating the rollout status and dates
*/
public class IPM_ProcessRolloutStatusAndDates {
    
    private static final string PROCESS_REGIONAL_PROJECTS = 'processRegionalProjects';
    private static final string CLASS_NAME = IPM_ProcessRolloutStatusAndDates.class.getName();
    
    /*******************************************************************************************************
    * @description                          Method used to process updation of Rollout Status
    * @param setGlobalProjectIds            Set of Global Project Ids
    * @param setRegionalOriginalProjectIds  Set of Regional Original Project Ids
    * @return                               NONE
    */
    public static void execute(Set<Id> setGlobalProjectIds, Set<Id> setRegionalOriginalProjectIds){
        execute(setGlobalProjectIds, setRegionalOriginalProjectIds, new Set<String>());
    }
    
    /*******************************************************************************************************
    * @description                          Method used to process updation of Rollout Status
    * @param setGlobalProjectIds            Set of Global Project Ids
    * @param setRegionalOriginalProjectIds  Set of Regional Original Project Ids
    * @param setDeleteRolloutIds            Set of Rollouts that are being deleted
    * @return                               NONE
    */
    public static void execute(Set<Id> setGlobalProjectIds, Set<Id> setRegionalOriginalProjectIds, Set<String> setDeleteRolloutIds){
        system.debug('@@@ inside execute of status and date ');
        String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
        
        Map<String, Date> mapEarliestGlobalLaunchDate = new Map<String,Date>();
        
        //PROCESS GLOBAL PROJECTS
        if(!setGlobalProjectIds.isEmpty()){
            //For Earliest Dates across the project
            
            //FOr Earliest Dates for every regional rollout
            Map<String, Date> mapEarliestRegionalRolloutLaunchDate = new Map<String,Date>();                       
            
            List<IPM_Project__c> lstGlobalProjects = [SELECT Id, 
                                                      (SELECT Id, Name, Target_Launch_Date__c, IPM_Status__c, Regional_Rollout__c, Regional_Rollout__r.Target_Launch_Date__c 
                                                       FROM IPM_Project_Rollout__r 
                                                       WHERE RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE ),
                                                      //AND Regional_Project__c =: null),
                                                      (SELECT Id 
                                                       FROM IPM_Projects__r)
                                                      FROM IPM_Project__c 
                                                      WHERE IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_GLOBAL AND Id IN: setGlobalProjectIds LIMIT 50000];
           
            Set<Id> setRegionalProjectIds = new Set<Id>();
            For(IPM_Project__c globalProject : lstGlobalProjects){
                //Process Local Rollouts
                For(IPM_Project_Rollout__c localRollout : globalProject.IPM_Project_Rollout__r){
                    //Only use in calculation if the rollout is not about to be deleted
                    if(!setDeleteRolloutIds.contains(localRollout.Id)){
                        Date targetLaunchDate = localRollout.Target_Launch_Date__c;
                        if(mapEarliestGlobalLaunchDate.containsKey(globalProject.Id) && mapEarliestGlobalLaunchDate.get(globalProject.Id) < targetLaunchDate){
                            targetLaunchDate = mapEarliestGlobalLaunchDate.get(globalProject.Id);
                        }                        
                        mapEarliestGlobalLaunchDate.put(globalProject.Id, targetLaunchDate);
                        
                        //Reset for Regional Rollout calculations
                        targetLaunchDate = localRollout.Target_Launch_Date__c;
                        //Regional Rollout Map
                        if(mapEarliestRegionalRolloutLaunchDate.containsKey(localRollout.Regional_Rollout__c) && mapEarliestRegionalRolloutLaunchDate.get(localRollout.Regional_Rollout__c) < targetLaunchDate){
                            targetLaunchDate = mapEarliestRegionalRolloutLaunchDate.get(localRollout.Regional_Rollout__c);                            
                        }                        
                        mapEarliestRegionalRolloutLaunchDate.put(localRollout.Regional_Rollout__c, targetLaunchDate);
                    }
                }
                
                //Create a set of Regional Project Ids for processing later
                For(IPM_Project__c regionalProject : globalProject.IPM_Projects__r)
                    setRegionalProjectIds.add(regionalProject.Id);
            }
            IPM_ProcessRolloutStatusAndDates.processRegionalProjects(setRegionalProjectIds, lstGlobalProjects, mapEarliestGlobalLaunchDate, mapEarliestRegionalRolloutLaunchDate);           
        }
        if(!setRegionalOriginalProjectIds.isEmpty()){            
            IPM_ProcessRolloutStatusAndDates.processRegionalProjects(setRegionalOriginalProjectIds, null, mapEarliestGlobalLaunchDate, null);
        }

        //TODO: PROCESS REGIONAL ORIGINAL PROJECTS
    }
    
    public static void processRegionalProjects(Set<Id> setRegionalProjectIds, List<IPM_Project__c> lstGlobalProjects, Map<String, Date> mapEarliestGlobalLaunchDate, Map<String, Date> mapEarliestRegionalRolloutLaunchDate){
        system.debug('@@@ process regional project');
        List<IPM_Project_Rollout__c> lstUpdateProjectRollouts = new List<IPM_Project_Rollout__c>();
        List<IPM_Project__c> lstUpdateProjects = new List<IPM_Project__c>();
        Set<Id> updateRolloutListSet = new Set<Id>();
        //To check if the Leader is found for the Global project
        Boolean isLeaderFound = false;
        List<IPM_Project__c> lstRegionalProjects = [SELECT Id, IPM_Parent_Project__c, IPM_Target_Launch_Dates__c, 
                                                    (SELECT Id, Name, Target_Launch_Date__c, IPM_Status__c 
                                                     FROM Regional_Project_Rollout__r 
                                                     WHERE NOT(Regional_Project__c =: null)),
                                                    (SELECT Id, IPM_Target_Launch_Dates__c, IPM_Rollout_Status__c, IPM_Parent_Project__r.IPM_Parent_Project__c 
                                                     FROM IPM_Projects__r)
                                                    FROM IPM_Project__c 
                                                    WHERE IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_REGIONAL AND Id IN: setRegionalProjectIds LIMIT 50000];
        
        For(IPM_Project__c regionalProject : lstRegionalProjects){
            //Process Local Rollouts
            For(IPM_Project_Rollout__c localRollout : regionalProject.Regional_Project_Rollout__r){
                Date targetLaunchDate = localRollout.Target_Launch_Date__c;
                if(mapEarliestGlobalLaunchDate.containsKey(regionalProject.IPM_Parent_Project__c) && mapEarliestGlobalLaunchDate.get(regionalProject.IPM_Parent_Project__c) < targetLaunchDate){
                    targetLaunchDate = mapEarliestGlobalLaunchDate.get(regionalProject.IPM_Parent_Project__c);
                    
                }
                
                mapEarliestGlobalLaunchDate.put(regionalProject.IPM_Parent_Project__c, targetLaunchDate);
            }
            
            //Process Local Projects
            For(IPM_Project__c localProject : regionalProject.IPM_Projects__r){
                Date targetLaunchDate = localProject.IPM_Target_Launch_Dates__c;
                if(mapEarliestGlobalLaunchDate.containsKey(regionalProject.IPM_Parent_Project__c) && mapEarliestGlobalLaunchDate.get(regionalProject.IPM_Parent_Project__c) < targetLaunchDate){
                    targetLaunchDate = mapEarliestGlobalLaunchDate.get(regionalProject.IPM_Parent_Project__c);
                    
                }
                
                mapEarliestGlobalLaunchDate.put(regionalProject.IPM_Parent_Project__c, targetLaunchDate);
            }
        }
        
        //---------------------------------------------------------------
        //UPDATE ROLLOUTS AND PROJECTS WITH APPROPRIATE STATUS AND DATES
        //---------------------------------------------------------------
        
        //Global Projects
        isLeaderFound = false;
        if(lstGlobalProjects != NULL && !lstGlobalProjects.isEmpty()){
            For(IPM_Project__c globalProject : lstGlobalProjects){
                //Process Local Rollouts
                For(IPM_Project_Rollout__c localRollout : globalProject.IPM_Project_Rollout__r){
                    Date earliestDate = mapEarliestGlobalLaunchDate.get(globalProject.Id);
                    if(earliestDate == localRollout.Target_Launch_Date__c){
                        if(localRollout.IPM_Status__c == IPM_ConstantUtils.ROLLOUT_LEADER){
                        	isLeaderFound = true;
                        	system.debug('@@@ isLeaderFound 140 '+isLeaderFound);
                        }else if(!isLeaderFound ){
                            localRollout.IPM_Status__c  = IPM_ConstantUtils.ROLLOUT_LEADER;
                            isLeaderFound = true;
                            system.debug('@@@ isLeaderFound 144'+isLeaderFound);
                            if(!updateRolloutListSet.contains(localRollout.Id)){
                                lstUpdateProjectRollouts.add(localRollout);
                                updateRolloutListSet.add(localRollout.Id);
                            }
                        }else{
                            localRollout.IPM_Status__c  = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                            if(!updateRolloutListSet.contains(localRollout.Id)){
                                lstUpdateProjectRollouts.add(localRollout);
                                updateRolloutListSet.add(localRollout.Id);
                            }
                        }
                    }else{
                        localRollout.IPM_Status__c  = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                        if(!updateRolloutListSet.contains(localRollout.Id)){
                            lstUpdateProjectRollouts.add(localRollout);
                            updateRolloutListSet.add(localRollout.Id);
                        }
                    }
                }                
            }
            
            //Regional Rollouts
            For(String regionalRolloutId : mapEarliestRegionalRolloutLaunchDate.keySet()){
                if(!updateRolloutListSet.contains(regionalRolloutId )){                                                                
                    lstUpdateProjectRollouts.add(
                        new IPM_Project_Rollout__c(
                            Id = regionalRolloutId,
                            Target_Launch_Date__c = mapEarliestRegionalRolloutLaunchDate.get(regionalRolloutId)
                        )
                    );
                    updateRolloutListSet.add(regionalRolloutId);
                }
            }
            
            //Global Projects
            For(String globalProjectId : mapEarliestGlobalLaunchDate.keySet()){
                lstUpdateProjects.add(
                    new IPM_Project__c(
                        Id = globalProjectId,
                        IPM_Target_Launch_Dates__c = mapEarliestGlobalLaunchDate.get(globalProjectId)
                    )
                );
            }
        }   
        
        //Regional Rollout Projects
        For(IPM_Project__c regionalProject : lstRegionalProjects){
            //Process Local Rollouts
            For(IPM_Project_Rollout__c localRollout : regionalProject.Regional_Project_Rollout__r){
                localRollout.IPM_Status__c  = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                Date earliestDate = mapEarliestGlobalLaunchDate.get(regionalProject.IPM_Parent_Project__c);
                if(earliestDate == localRollout.Target_Launch_Date__c){
                    if(localRollout.IPM_Status__c == IPM_ConstantUtils.ROLLOUT_LEADER){
                        isLeaderFound = true;
                    }else if(!isLeaderFound ){
                        localRollout.IPM_Status__c  = IPM_ConstantUtils.ROLLOUT_LEADER;
                        isLeaderFound = true;
                        if(!updateRolloutListSet.contains(localRollout.Id)){
                            lstUpdateProjectRollouts.add(localRollout);
                            updateRolloutListSet.add(localRollout.Id);
                        }
                    }else{
                        localRollout.IPM_Status__c  = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                        if(!updateRolloutListSet.contains(localRollout.Id)){
                            lstUpdateProjectRollouts.add(localRollout);
                            updateRolloutListSet.add(localRollout.Id);
                        }
                    }
                } else{
                    localRollout.IPM_Status__c  = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                    if(!updateRolloutListSet.contains(localRollout.Id)){
                        lstUpdateProjectRollouts.add(localRollout);
                        updateRolloutListSet.add(localRollout.Id);
                    }
                }
            }
            
            //Process Local Projects
            For(IPM_Project__c localProject : regionalProject.IPM_Projects__r){
                Date earliestDate = mapEarliestGlobalLaunchDate.get(localProject.IPM_Parent_Project__r.IPM_Parent_Project__c);
                if(earliestDate == localProject.IPM_Target_Launch_Dates__c){
                    if(localProject.IPM_Rollout_Status__c == IPM_ConstantUtils.ROLLOUT_LEADER){
                        isLeaderFound = true;
                    }else if(!isLeaderFound ){
                        localProject.IPM_Rollout_Status__c  = IPM_ConstantUtils.ROLLOUT_LEADER;
                        isLeaderFound = true;
                        lstUpdateProjects.add(localProject);
                    }else{                           
                        localProject.IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                        lstUpdateProjects.add(localProject);
                    }
                } else{
                    if(localProject.IPM_Rollout_Status__c != IPM_ConstantUtils.ROLLOUT_FOLLOWER){
                        localProject.IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER;
                        lstUpdateProjects.add(localProject);
                    }
                }
            }
        }
        
        try{
            if(!lstUpdateProjectRollouts.isEmpty()){
                update lstUpdateProjectRollouts;
            }
            if(!lstUpdateProjects.isEmpty()){
                update lstUpdateProjects;
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
                                                       PROCESS_REGIONAL_PROJECTS ,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null);                                                        
        }    
    }
}