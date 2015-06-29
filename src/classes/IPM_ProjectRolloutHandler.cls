public with sharing class IPM_ProjectRolloutHandler {
    
    private boolean m_isExecuting = false;

    public IPM_ProjectRolloutHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }
    
    public void OnBeforeInsert(IPM_Project_Rollout__c[] newProjectRollOuts) {
        assignDefaultTLP(newProjectRollOuts);
    }
    
    public void OnAfterInsert(IPM_Project_Rollout__c[] newProjectRollOuts) {
        assignLeaderShip(newProjectRollOuts, null);
    }
    
    public void OnAfterUpdate(IPM_Project_Rollout__c[] newProjectRollOuts, Map<Id, IPM_Project_Rollout__c> oldProjectRollOutsMap) {
        
        IPM_Project_Rollout__c[] projectRollOutsModified = new List<IPM_Project_Rollout__c>();
        Map<Id, Boolean> escortedLeader = new Map<Id, Boolean>();
        Boolean singleLeader;
        String singleLeaderId;
        Map<Id, IPM_Project_Rollout__c[]> projectRollOutMap = projectRollOutMap(newProjectRollOuts);
        for(String eachProject : projectRollOutMap.keySet()) {
            singleLeader = false;
            for(IPM_Project_Rollout__c eachPRollOut : projectRollOutMap.get(eachProject)) {
                IPM_Project_Rollout__c oldRollOut = oldProjectRollOutsMap != null && oldProjectRollOutsMap.get(eachPRollOut.Id) != null 
                                                        ? oldProjectRollOutsMap.get(eachPRollOut.Id) : eachPRollOut;
                if(!singleLeader && oldRollOut != null && 
                    (oldRollOut.Target_Launch_Month__c != null && oldRollOut.Target_Launch_Month__c != eachPRollOut.Target_Launch_Month__c) ||
                    (oldRollOut.Target_Launch_Year__c != null && oldRollOut.Target_Launch_Year__c != eachPRollOut.Target_Launch_Year__c) ||
                    (oldRollOut.IPM_Status__c != null 
                        && oldRollOut.IPM_Status__c != eachPRollOut.IPM_Status__c)) {
                    singleLeader = true;
                    singleLeaderId = eachPRollOut.Id;
                } else if(singleLeader && oldRollOut != null && 
                    (oldRollOut.Target_Launch_Month__c != null && oldRollOut.Target_Launch_Month__c != eachPRollOut.Target_Launch_Month__c) ||
                    (oldRollOut.Target_Launch_Year__c != null && oldRollOut.Target_Launch_Year__c != eachPRollOut.Target_Launch_Year__c) ||
                    (oldRollOut.IPM_Status__c != null 
                        && oldRollOut.IPM_Status__c != eachPRollOut.IPM_Status__c)) {
                    singleLeader = false;
                    break;
                }
            }
            if(singleLeader) {
                escortedLeader.put(singleLeaderId, singleLeader);
            }
        }
        for(IPM_Project_Rollout__c eachPRollOut : newProjectRollOuts) {
            IPM_Project_Rollout__c oldRollOut = oldProjectRollOutsMap != null && oldProjectRollOutsMap.get(eachPRollOut.Id) != null ? 
                                                        oldProjectRollOutsMap.get(eachPRollOut.Id) : null;
            if(oldRollOut != null && (oldRollOut.Target_Launch_Month__c != null && oldRollOut.Target_Launch_Month__c != eachPRollOut.Target_Launch_Month__c)
                || (oldRollOut.Target_Launch_Year__c != null && oldRollOut.Target_Launch_Year__c != eachPRollOut.Target_Launch_Year__c)
                || (oldRollOut.IPM_Status__c != null 
                        && oldRollOut.IPM_Status__c != eachPRollOut.IPM_Status__c)) {
                projectRollOutsModified.add(eachPRollOut);
            }
        }
        
        assignLeaderShip(projectRollOutsModified, escortedLeader);
    }
    
    public void OnAfterDelete(IPM_Project_Rollout__c[] newProjectRollOuts) {
        assignLeaderShip(newProjectRollOuts, null);
    }
    
    public void OnAfterUnDelete(IPM_Project_Rollout__c[] newProjectRollOuts) {
        assignLeaderShip(newProjectRollOuts, null);
    }
    
    private void assignDefaultTLP(IPM_Project_Rollout__c[] newProjectRollOuts) {
        
        Date thisDay = system.today();
        for(IPM_Project_Rollout__c eachPRollOut : newProjectRollOuts) {
            eachPRollOut.Target_Launch_Month__c = 'Dec';
            eachPRollOut.Target_Launch_Year__c = '2014';
        }
    }
    
    private Map<Id, IPM_Project_Rollout__c[]> projectRollOutMap(IPM_Project_Rollout__c[] newProjectRollOuts) {
        
        Set<Id> projectIds = new Set<Id>();
        for(IPM_Project_Rollout__c eachPRoleOut : newProjectRollOuts) {
            projectIds.add(eachPRoleOut.IPM_Project__c);
        }
        Map<Id, IPM_Project_Rollout__c[]> projectRollOutMapToReturn = new Map<Id, IPM_Project_Rollout__c[]>();
        IPM_Project_Rollout__c[] projectRollOutSObj = [SELECT IPM_Project__c, LastModifiedDate, Target_Launch_Year__c, 
                                                                Target_Launch_Month__c, IPM_Status__c, Market_Cluster__c
                                                            FROM IPM_Project_Rollout__c WHERE IPM_Project__c IN :projectIds];
        for(IPM_Project_Rollout__c eachProjectRollOut : projectRollOutSObj) {
            if(!projectRollOutMapToReturn.containsKey(eachProjectRollOut.IPM_Project__c)) {
                List<IPM_Project_Rollout__c> projectRollUp = new List<IPM_Project_Rollout__c>();
                projectRollUp.add(eachProjectRollOut);
                projectRollOutMapToReturn.put(eachProjectRollOut.IPM_Project__c, projectRollUp);
            } else {
                projectRollOutMapToReturn.get(eachProjectRollOut.IPM_Project__c).add(eachProjectRollOut);
            }
        }   
        
        return projectRollOutMapToReturn;
    }
    
    private void assignLeaderShip(IPM_Project_Rollout__c[] newProjectRollOuts, Map<Id, Boolean> escortedLeader) {
        
        if(IPM_CheckRecursive.runOnce()) {
            Date thisDay = system.today();
            
            Set<Id> projectRollOutIds = new Set<Id>();
            Map<Id, IPM_Project_Rollout__c> updatedRollOuts = new Map<Id, IPM_Project_Rollout__c>();
            Map<Id, IPM_Project_Rollout__c[]> projectRollOutMap = projectRollOutMap(newProjectRollOuts);
            
            for(String eachProject : projectRollOutMap.keySet()) {
                for(IPM_Project_Rollout__c eachRollOut : shuffleLeader(projectRollOutMap.get(eachProject), escortedLeader)) {
                    updatedRollOuts.put(eachRollOut.Id, eachRollOut);
                }
            }
            update updatedRollOuts.values();
        }
    }
    
    private List<IPM_Project_Rollout__c> shuffleLeader(IPM_Project_Rollout__c[] projectRollouts, Map<Id, Boolean> escortedLeader) {
        
        Map<String, IPM_Project_Rollout__c> leaderMap = new Map<String, IPM_Project_Rollout__c>();
        List<IPM_Project_Rollout__c> listToReturn = new List<IPM_Project_Rollout__c>();
        IPM_Project_Rollout__c leaderRollOutObj = new IPM_Project_Rollout__c();
        List<IPM_Project_Rollout__c> followerRollOuts = new List<IPM_Project_Rollout__c>();
        for(IPM_Project_Rollout__c eachProjectRollOut : projectRollouts) {
            if(!leaderMap.containsKey(IPM_ConstantUtils.ROLLOUT_LEADER)) {
                leaderMap.put(IPM_ConstantUtils.ROLLOUT_LEADER, eachProjectRollOut);
                continue;
            } else {
                if(!isLeader(leaderMap.get(IPM_ConstantUtils.ROLLOUT_LEADER), eachProjectRollOut)) {
                    followerRollOuts.add(leaderMap.get('Leader'));
                    leaderMap.put(IPM_ConstantUtils.ROLLOUT_LEADER, eachProjectRollOut);
                }else {
                    followerRollOuts.add(eachProjectRollOut);
                }
            }
        }
        
        for(IPM_Project_Rollout__c eachProjectRollOut : projectRollouts) {
            if(escortedLeader != null && escortedLeader.get(eachProjectRollOut.Id) != null && 
                                    escortedLeader.get(eachProjectRollOut.Id)) {
                if(isSameDate(leaderMap.get(IPM_ConstantUtils.ROLLOUT_LEADER), eachProjectRollOut)) {
                    followerRollOuts.add(leaderMap.get('Leader'));
                    leaderMap.put(IPM_ConstantUtils.ROLLOUT_LEADER, eachProjectRollOut);
                }
            }
        }
            
        for(IPM_Project_Rollout__c eachFollower : followerRollOuts) {
            eachFollower.IPM_Status__c = IPM_ConstantUtils.ROLLOUT_Follower;
            listToReturn.add(eachFollower);
        }
        leaderRollOutObj = leaderMap.get(IPM_ConstantUtils.ROLLOUT_LEADER);
        leaderRollOutObj.IPM_Status__c = IPM_ConstantUtils.ROLLOUT_LEADER;
        listToReturn.add(leaderRollOutObj);
        system.debug('** leaderRollOutObj : ' + leaderRollOutObj);
        system.debug('** followerRollOuts : ' + followerRollOuts);
        return listToReturn;
    }
    
    private Boolean isLeader(IPM_Project_Rollout__c leaderRollOut, IPM_Project_Rollout__c followerRollOut) {
        
        Boolean paramToReturn = true;
        Integer leaderROYear = leaderRollOut.Target_Launch_Year__c != null ? Integer.valueOf(leaderRollOut.Target_Launch_Year__c) : 0;
        Integer followerROYear = followerRollOut.Target_Launch_Year__c != null ? Integer.valueOf(followerRollOut.Target_Launch_Year__c) : 0;
        Integer leaderROMonth = leaderRollOut.Target_Launch_Month__c != null ? IPM_Utils.monthMap.get(leaderRollOut.Target_Launch_Month__c) : 0;
        Integer followerROMonth = followerRollOut.Target_Launch_Month__c != null ? IPM_Utils.monthMap.get(followerRollOut.Target_Launch_Month__c) : 0;
        if(leaderROYear < followerROYear) {
            paramToReturn = true;
        } else if(leaderROYear == followerROYear) {
            if(leaderROMonth < followerROMonth) {
                paramToReturn = true;
            }else if(leaderROMonth == followerROMonth) {
                paramToReturn = leaderRollOut.Market_Cluster__c.compareTo(followerRollOut.Market_Cluster__c) < 0 ? true : false;
                system.debug(' ** comparison : ' + leaderRollOut.Market_Cluster__c.compareTo(followerRollOut.Market_Cluster__c));
            }else {
                paramToReturn = false;
            }
        } else {
            paramToReturn = false;
        }
        return paramToReturn;
    }
    
    private Boolean isSameDate(IPM_Project_Rollout__c leaderRollOut, IPM_Project_Rollout__c followerRollOut) {
        
        Boolean paramToReturn = false;
        Integer leaderROYear = leaderRollOut.Target_Launch_Year__c != null ? Integer.valueOf(leaderRollOut.Target_Launch_Year__c) : 0;
        Integer followerROYear = followerRollOut.Target_Launch_Year__c != null ? Integer.valueOf(followerRollOut.Target_Launch_Year__c) : 0;
        Integer leaderROMonth = leaderRollOut.Target_Launch_Month__c != null ? IPM_Utils.monthMap.get(leaderRollOut.Target_Launch_Month__c) : 0;
        Integer followerROMonth = followerRollOut.Target_Launch_Month__c != null ? IPM_Utils.monthMap.get(followerRollOut.Target_Launch_Month__c) : 0;
        if(leaderROYear == followerROYear && leaderROMonth == followerROMonth) {
            paramToReturn = true;
        }
        
        return paramToReturn;
    }
}