/*************************************************************************************************************
* @author:Cognizant
* @date: 17/11/2015
* @description: To Sync Target Launch Date of Rollout Project and Local Project with eachOther
*/
public with sharing class IPM_RolloutPlanTLDSync {

    public static final String IPM_ROLLOUTPLANTLDSYNC_STR = IPM_RolloutPlanTLDSync.class.getName();
    /*******************************************************************************************************
    * @description  This method is used to sync target launch date between rollout and projects. It also updates parent project TLD will least TLD of child projects.
                    NPath Complexity is high because syncing TLD and updating parent project TLD involves for all three span i.e. Global, Regional and Local and different project phases
    * @param        Map Id IPM_Project
    * @param        Map Id IPM_Project_Rollout
    * @return       NONE
    */

    /*******************************************************************************************************
    * @description  Method to notify Global Finance leader about TLD Date Changes
    * @param        Map projectId,projectRollout
    * @return       NONE
    */    
    public void notifyGlobalProjectFinanceLeader(Map<Id, IPM_Project_Rollout__c> globalProjIdRollout,  List<Id>  projIdList ){
      	List<Id> projectApplicableId = new List<Id>();
        for(IPM_Project__c ipmProj : [Select Id,IPMProject_Span__c, IPM_Project_Type__c, IPM_Phase__c,IPM_ProjectGKM__c,IPM_GateKeeping_Model__c,IPM_CompanyCardText__c from IPM_Project__c where Id in : projIdList limit 50000]){
            if(ipmProj.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && ipmProj.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS && ipmProj.IPM_ProjectGKM__c != IPM_ConstantUtils.GATE_KEEPING_MODEL_3){ 
                projectApplicableId.add(ipmProj.Id);
            } else if (ipmProj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && ipmProj.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS){
                projectApplicableId.add(ipmProj.Id);
            } else if (ipmProj.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && ipmProj.IPM_ProjectGKM__c == IPM_ConstantUtils.GATE_KEEPING_MODEL_3) {
            	projectApplicableId.add(ipmProj.Id);
            }
        }
        
        Map<Id,IPM_Project_Resource__c>  projIdFinanceLeaderMap = new Map<Id,IPM_Project_Resource__c>{};
        for(IPM_Project_Resource__c ipr : [Select Id, IPM_User__c,IPM_User__r.Email,IPM_Project__c from IPM_Project_Resource__c where IPM_Role_Type__c = :IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE and IPM_Project_Role_Owner__c = true and IPM_Project__c in: projectApplicableId limit 50000]){
            projIdFinanceLeaderMap.put(ipr.IPM_Project__c, ipr);
        }       
        List<IPM_EmailOut_Notification__c> emailOut = new List<IPM_EmailOut_Notification__c>{};
        for(Id RolloutId: globalProjIdRollout.keySet()){
            partialNotifyGlobalProjectFinanceLeader(RolloutId,emailOut,globalProjIdRollout,projIdFinanceLeaderMap);
        }
        // removed exception handling as any exceptions/Messages  would be handled at controller 
        if(!emailOut.isEmpty()){
            insert emailOut;
        }
    }
    
    
    /******************************************************************************
        @Description: This method is created to resolve nPath Complexity issue
        @Return: VOID
    ******************************************************************************/
    
    private void partialNotifyGlobalProjectFinanceLeader(Id RolloutId,List<IPM_EmailOut_Notification__c> emailOut,Map<Id, IPM_Project_Rollout__c> globalProjIdRollout,Map<Id,IPM_Project_Resource__c>  projIdFinanceLeaderMap)
    {
            IPM_EmailOut_Notification__c emailOutNotification = new IPM_EmailOut_Notification__c();    
            Id projectID = globalProjIdRollout.get(RolloutId).IPM_Project__c;
            if(projectID == null)
            {
            	projectID = globalProjIdRollout.get(RolloutId).Regional_Project__c;
            }
            String emailAdd = '';
            if(projIdFinanceLeaderMap.containsKey(projectID)){
            	emailAdd = projIdFinanceLeaderMap.get(projectID).IPM_User__r.Email;
             }
            if(!String.isBlank(emailAdd)){
                emailOutNotification.Project_Name__c = globalProjIdRollout.get(RolloutId).IPM_Rollout_Project__c;
                emailOutNotification.Previous_Target_Launch_Date__c =  globalProjIdRollout.get(RolloutId).previous_Target_Launch_Date__c != null ? globalProjIdRollout.get(RolloutId).previous_Target_Launch_Date__c.format() : null;
                emailOutNotification.Target_Launch_Date__c = globalProjIdRollout.get(RolloutId).Target_Launch_Date__c != null ? globalProjIdRollout.get(RolloutId).Target_Launch_Date__c.format() : null;
                emailOutNotification.To_Address__c = emailAdd;
                emailOut.add(emailOutNotification);       
            }
        
    }
    
    
    
    /*******************************************************************************************************
    * @description  Method to notify Project Leader that Finance leader has confirmed the TLD date changes in Ideas phase
    * @param        Map projectId,projectRollout
    * @return       NONE
    */    
    public void notifyProjectFinanceAboutFinanceLeaderConfirmation(Map<Id, IPM_Project_Rollout__c> projIdRollout ){
         Map<Id,IPM_Project__c> projDetails = new Map<Id,IPM_Project__c>([Select Id, IPM_Project_Leader__r.Email from IPM_Project__c where Id in : projIdRollout.keySet()  and ((IPM_Project_Type__c = :IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL and IPM_Phase__c = :IPM_ConstantUtils.PHASE_IDEAS) OR (IPM_Project_Type__c = :IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL and IPM_ProjectGKM__c = : IPM_ConstantUtils.GATE_KEEPING_MODEL_3))  limit 50000]);
            List<IPM_EmailOut_Notification__c> emailOut = new List<IPM_EmailOut_Notification__c>{};
            for(Id projId : projDetails.keySet()){
                IPM_EmailOut_Notification__c emailOutNotification = new IPM_EmailOut_Notification__c();    
                emailOutNotification.To_Address__c = projDetails.get(projId).IPM_Project_Leader__r.Email;
                emailOutNotification.Project_Name__c = projIdRollout.get(projId).IPM_Rollout_Project__c;
                emailOutNotification.MCO_Country_Name__c =  projIdRollout.get(projId).MCO_Name__c;
                emailOutNotification.Confirmed_By__c = UserInfo.getName();
                emailOut.add(emailOutNotification);                     
            }
            if(!emailOut.isEmpty()){
                insert emailOut;
            }               
    }   
}