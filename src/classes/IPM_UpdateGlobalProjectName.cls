/******************************************** 
*@Author:Cognizant
*@Date:October 2014
*@Description : update project name throughout IPM Project,like child project name, subchild project name.
*
*********************************************/
public with sharing class IPM_UpdateGlobalProjectName {
    /********************************************************************************
    *@Description :static method to update project name through out the IPM Project records
    *@Param: map of project id's and Project Name
    *@return:null
    *********************************************************************************/
    Public static string className_STR=IPM_UpdateGlobalProjectName.class.getName();
    public static void updateProjectName(Map<id,String>updatedProNameMap,Map<Id,String>oldprojectnameMap){
        List<IPM_Project__c>projectList=new List<IPM_Project__c>();
        List<IPM_Project_Rollout__c>updateRolloutList=new List<IPM_Project_Rollout__c>();//list of all project rollout to be updated with project name
        set<id>rolloutId=new set<id>();//set of rollout id
        projectList=[SELECT IPM_Project_Type__c,
                            (SELECT Name,IPM_Rollout_Project__c,IPM_Project__c,Regional_Project__c FROM IPM_Project_Rollout__r),
                            (SELECT Name,IPM_Rollout_Project__c,Regional_Project__c,IPM_Project__c FROM Regional_Project_Rollout__r WHERE IPM_Project__c=Null)
                             FROM IPM_Project__c WHERE Id =:updatedProNameMap.Keyset() LIMIT 50000];    
        if(!projectList.isEmpty()){
            //list of all projects that has been updated the project name till Ideas phase
            for(IPM_Project__c proj:projectList){
                
                for(IPM_Project_Rollout__c roll:proj.IPM_Project_Rollout__r){
                    updateRolloutList.add(roll);
                    rolloutId.add(roll.id);
                }
                for(IPM_Project_Rollout__c regionalRoll:proj.Regional_Project_Rollout__r){
                    updateRolloutList.add(regionalRoll);
                    rolloutId.add(regionalRoll.id);
                }
                
            }
        
        } 
        
        List<IPM_Project_Rollout__c>updateRollList=new List<IPM_Project_Rollout__c>();
        //get list of all rollout, those values have been updated
        updateRollList=updateRollOut(updatedProNameMap,updateRolloutList,oldprojectnameMap,rolloutId);
        try{
            update updateRollList;
        }
        catch(DMLException ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className_STR,IPM_ConstantUtils.IPM_UPDATEGLOBAL_PROJECT,ex.getMessage(),ex, IPM_ConstantUtils.IPM_UPDATEGLOBAL_PROJECT, null, null, null,null);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
        }
        catch(Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className_STR,IPM_ConstantUtils.IPM_UPDATEGLOBAL_PROJECT,ex.getMessage(),ex, IPM_ConstantUtils.IPM_UPDATEGLOBAL_PROJECT, null, null, null,null);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
        }
        
    }
    /********************************************************************************
    *@Description :Update ipm rollout name
    *@Param: map of project id's and Project Name and list of ipm rollout
    *@return:null
    *********************************************************************************/
    public static List<IPM_Project_Rollout__c> updateRollOut(Map<id,String>updatedProNameMap,List<IPM_Project_Rollout__c>updateRollList,Map<Id,String>oldprojectnameMap,Set<id>rolloutId){
        map<Id,String>newRollNameMap=new map<Id,String>();//new project name with rollout
        map<Id,String>oldRollNameMap=new map<Id,String>();//old project name with rollout
        
        List<IPM_Project_Rollout__c>rollList=new List<IPM_Project_Rollout__c>();
        //get all rollout records to be update rollout name as project name
        for(IPM_Project_Rollout__c roll:updateRollList){
            IPM_Project_Rollout__c rollUpdate=new IPM_Project_Rollout__c();//Initialise ipm finance object
            rollUpdate.id=roll.id;//assign rollout id to be update
            String rollName_STR='';
            if(roll.IPM_Project__c!=null){
                rollName_STR=roll.name.replace(oldprojectnameMap.get(roll.IPM_Project__c),updatedProNameMap.get(roll.IPM_Project__c));//get rollout name after '-' as string
            }
            else if(roll.Regional_Project__c!=null){
                rollName_STR=roll.name.replace(oldprojectnameMap.get(roll.Regional_Project__c),updatedProNameMap.get(roll.Regional_Project__c));//get rollout name after '-' as string
            }
            rollUpdate.name=rollName_STR;//update rollout name with updated project name
            rollUpdate.IPM_Rollout_Project__c=rollName_STR;
            rollList.add(rollUpdate);//add rollout into list
            newRollNameMap.put(roll.id,updatedProNameMap.get(roll.IPM_Project__c));
            oldRollNameMap.put(roll.id,oldprojectnameMap.get(roll.IPM_Project__c));
        }
        return rollList;
    }
    
    /**************************************************************
    * @description: Process the incoming Project and update project name to its child and grand child projects(Regional and Local)  
    * @param: ipmProjectMap : current project(IPM_Project__c) record.
    */ 
    public static void updateChildProjects(Map<Id, String> updatedProNameMap,Map<Id, String> oldprojectnameMap){
        
        List<IPM_Project__c> childProjectListToUpdate = new List<IPM_Project__c>(); // List of child IPMProjects to be updated
        for(IPM_Project__c childProject :    [SELECT Id, 
                                                     IPM_Project_Name__c, 
                                                     IPM_Parent_Project__c, 
                                                     IPM_Parent_Project__r.IPM_Parent_Project__c,
                                                     IPMProject_Span__c,
                                                     IPM_Parent_Project__r.IPMProject_Span__c
                                              FROM  IPM_Project__c 
                                              WHERE IPM_Parent_Project__c IN: updatedProNameMap.keySet() OR IPM_Parent_Project__r.IPM_Parent_Project__c IN: updatedProNameMap.keySet() LIMIT 50000]){
                                                
            if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equals(childProject.IPMProject_Span__c)){ // Regional child projects to be updated
                if(childProject.IPM_Parent_Project__c!=null){
                    childProject.IPM_Project_Name__c = childProject.IPM_Project_Name__c.replace(oldprojectnameMap.get(childProject.IPM_Parent_Project__c),updatedProNameMap.get(childProject.IPM_Parent_Project__c));//get rollout name after '-' as string
                  }  
            }else if(IPM_ConstantUtils.PROJECT_SPAN_LOCAL.equals(childProject.IPMProject_Span__c)){ // Local child projects to be updated
                
                if(childProject.IPM_Parent_Project__r.IPM_Parent_Project__c!=null && oldprojectnameMap.get(childProject.IPM_Parent_Project__r.IPM_Parent_Project__c)!=null ){
                    childProject.IPM_Project_Name__c = childProject.IPM_Project_Name__c.replace(oldprojectnameMap.get(childProject.IPM_Parent_Project__r.IPM_Parent_Project__c),updatedProNameMap.get(childProject.IPM_Parent_Project__r.IPM_Parent_Project__c));//get rollout name after '-' as string
                   }
                else if(childProject.IPM_Parent_Project__c!=null && oldprojectnameMap.get(childProject.IPM_Parent_Project__c)!=null ){
                    childProject.IPM_Project_Name__c = childProject.IPM_Project_Name__c.replace(oldprojectnameMap.get(childProject.IPM_Parent_Project__c),updatedProNameMap.get(childProject.IPM_Parent_Project__c));//get rollout name after '-' as string
                   }   
            }
            childProjectListToUpdate.add(childProject);                                   
          
        }
        
        if(!childProjectListToUpdate.isEmpty()){
            try{
                update childProjectListToUpdate;
            }
            catch(DMLException ex) {
               ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className_STR,IPM_ConstantUtils.IPM_UPDATECHILD_PROJECT,ex.getMessage(),ex, IPM_ConstantUtils.IPM_UPDATECHILD_PROJECT, null, null, null,null);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
            }
            catch(Exception ex) {
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className_STR,IPM_ConstantUtils.IPM_UPDATECHILD_PROJECT,ex.getMessage(),ex, IPM_ConstantUtils.IPM_UPDATECHILD_PROJECT, null, null, null,null);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
            }
           
        }
        
    }   
}