/******************************************** 
*@Author:Cognizant
*@Date:October 2014
*@Description : update project name throughout IPM Project,like child project name, subchild project name.
*
*********************************************/
public with sharing class IPM_UpdateGlobalProjectName {
    /********************************************************************************
    *@Description :static method to update project name through out the IPM Project records(like IPM_Milestone__c,IPM_Task__c
    *				,IPM_Project_Document__c,IPM_Project_Document_Section__c,IPM_Financial__c,IPM_Financial_Year__c,IPM_Project_Rollout__c,IPM_Country__c)
    *@Param: map of project id's and Project Name
    *@return:null
    *********************************************************************************/
    Public static string className_STR=IPM_UpdateGlobalProjectName.class.getName();
    
    /*******************************************************************************************************************************
    @NPath description:This method contains complex business logic.It will be risk to modify the component.
    if project leader changes global project name then system will change child project name(regional/local),ipm gate document name,ipm gate document section name, ipm rollout name,ipm country name,ipm task external id,ipm milestone external id and ipm financial external id.
	If global project has regional projects and local projects then these project name will also change.
	if regional project/local name changed by system then again ipm gate document name,ipm gate document section name, ipm rollout name,ipm country name,ipm task external id,
	ipm milestone external id and ipm financial external id will change for regional and local projects.To achieve above functionality,we are calling 10 methods inside updateProjectName().
    *******************************************************************************************************************************/
    public static void updateProjectName(Map<id,String>updatedProNameMap,Map<Id,String>oldprojectnameMap){
        List<IPM_Project__c> projectList = new List<IPM_Project__c>();
        
        List<IPM_Milestone__c> updateMilesList = new List<IPM_Milestone__c>();//list of all milestones to be updated with Project name
        
        List<IPM_Task__c> updateTaskList = new List<IPM_Task__c>();//List of all task to be updated with Project name
        
        List<IPM_Project_Document__c> updateProDocList=new List<IPM_Project_Document__c>();//list of all project document to be updated with project name
        
        List<IPM_Financial__c> updateFinList = new List<IPM_Financial__c>();//list of all project finance to be updated with project name
        
        List<IPM_Project_Rollout__c> updateRolloutList = new List<IPM_Project_Rollout__c>();//list of all project rollout to be updated with project name
        
        List<IPM_Country__c> updateCountryList = new List<IPM_Country__c>();//list of all project rollout to be updated with project name
        
        set<id>rolloutId=new set<id>();//set of rollout id
        
        projectList=[SELECT IPM_Project_Type__c,
                            (SELECT Name,IPM_Rollout_Project__c,IPM_Project__c,Regional_Project__c FROM IPM_Project_Rollout__r),
							(SELECT Project_Country__c,IPM_Project__c FROM IPM_Countries__r),
                            (SELECT Name,IPM_Project__c,External_Id__c FROM Project_Documents__r),
                            (SELECT Name,IPM_Project__c,ExternalField__c FROM IPM_Milestones__r),
							(SELECT Name,IPM_Project__c,ExternalField__c FROM Tasks__r),
                            (SELECT Name,IPM_Rollout_Project__c,Regional_Project__c,IPM_Project__c FROM Regional_Project_Rollout__r WHERE IPM_Project__c=Null),
                            (SELECT Financial_External_ID__c,Parent_Project__c,Regional_Project__c,Local_Project__c FROM IPM_Financials_Consolidated__r),
                            (SELECT Financial_External_ID__c,Parent_Project__c,Regional_Project__c,Local_Project__c,IPM_Project_Rollout__c FROM IPM_Financials_Regional__r WHERE Parent_Project__c=Null AND Local_Project__c=Null),
                            (SELECT Financial_External_ID__c,Parent_Project__c,Regional_Project__c,Local_Project__c FROM IPM_Financials_Local__r)
                            FROM IPM_Project__c WHERE Id =:updatedProNameMap.Keyset() LIMIT 50000];    
        if(!projectList.isEmpty())
        {
            //list of all projects that has been updated the project name till Ideas phase
            for(IPM_Project__c proj:projectList)
            {    
                for(IPM_Project_Rollout__c roll:proj.IPM_Project_Rollout__r)
                {
                    updateRolloutList.add(roll);
                    rolloutId.add(roll.id);
                }
                
                for(IPM_Project_Rollout__c regionalRoll:proj.Regional_Project_Rollout__r)
                {
                    updateRolloutList.add(regionalRoll);
                    rolloutId.add(regionalRoll.id);
                }
                
                for(IPM_Financial__c prodoc:proj.IPM_Financials_Consolidated__r)
                {
                    if(prodoc.Financial_External_ID__c!=null){
                    updateFinList.add(prodoc);
                    }
                }
                
                for(IPM_Financial__c prodoc:proj.IPM_Financials_Regional__r)
                {
                	
                     if(prodoc.Financial_External_ID__c!=null){
                    updateFinList.add(prodoc);
                    }
                }
                
                for(IPM_Financial__c prodoc:proj.IPM_Financials_Local__r)
                {
                     if(prodoc.Financial_External_ID__c!=null){
                    updateFinList.add(prodoc);
                    }
                }
                
                for(IPM_Country__c country:proj.IPM_Countries__r)
				{
                    if(country.Project_Country__c!=null){
                    updateCountryList.add(country);
                    }
                }
                
				for(IPM_Milestone__c miles:proj.IPM_Milestones__r)
				{
                    if(miles.ExternalField__c!=null){
                    updateMilesList.add(miles);
                    }
                }
                
                for(IPM_Task__c tsk:proj.Tasks__r)
                {
                    if(tsk.ExternalField__c!=null){
                    updateTaskList.add(tsk);
                    }
                }
                
                for(IPM_Project_Document__c prodoc:proj.Project_Documents__r)
                {
                    updateProDocList.add(prodoc);
                }
            }
        } 
        	
    	skipTiggerExecution(true);
        
        List<IPM_Project_Document__c> ProDocUpdateList = new List<IPM_Project_Document__c>();
        ProDocUpdateList = updateDocNSecName(updatedProNameMap,updateProDocList,oldprojectnameMap);
        
        List<IPM_Task__c>taskUpdateList = new List<IPM_Task__c>();
        taskUpdateList = updateTaskName(updatedProNameMap,updateTaskList,oldprojectnameMap);//get list of all tasks, those values have been updated
        
        List<IPM_Milestone__c> milestoneUpdateList = new List<IPM_Milestone__c>();
        milestoneUpdateList = updateMilesName(updatedProNameMap,updateMilesList,oldprojectnameMap);//get list of all milestones, those values have been updated
        
        Set<Id> existingFinancialYear = new Set<Id>();
        List<IPM_Financial__c> updateFinanceList = new List<IPM_Financial__c>();
        updateFinanceList = updateFinName(updatedProNameMap,updateFinList,oldprojectnameMap,existingFinancialYear);//get list of all finance, those values have been updated
        
        List<IPM_Project_Rollout__c> updateRollList = new List<IPM_Project_Rollout__c>();
        updateRollList = updateRollOut(updatedProNameMap,updateRolloutList,oldprojectnameMap,rolloutId,existingFinancialYear);//get list of all rollout, those values have been updated
        
        List<IPM_Country__c>updateCountriesList=new List<IPM_Country__c>();
        updateCountriesList=updateCountryName(updatedProNameMap,updateCountryList,oldprojectnameMap);
 		
 		update ProDocUpdateList;
        update taskUpdateList;
        update milestoneUpdateList;
        update updateFinanceList;
        update updateRollList;
        update updateCountriesList;
        skipTiggerExecution(false);
        updateChildProjects(updatedProNameMap,oldprojectnameMap);
        
    }
    
    /********************************************************************************
    *@Description :if origional project name changed then update ipm gate document and ipm gate document section name
    *@Param: map of project id's and Project Name and list of ipm tasks
    *@return:list of project document
    *********************************************************************************/
    public static List<IPM_Project_Document__c> updateDocNSecName(Map<id,String>updatedProNameMap,List<IPM_Project_Document__c>updateProDocList,Map<Id,String>oldprojectnameMap){
        List<IPM_Project_Document__c>ProDocList=new List<IPM_Project_Document__c>();
        Map<Id,String>ProjecToDocMap=new Map<Id,String>();//map of document id and new project name
        map<Id,String>oplProjectToDocMap=new Map<Id,String>();//map of ducument id to old project name
        //get all project document list to be update project document name
        for(IPM_Project_Document__c eachDoc : updateProDocList) {
            IPM_Project_Document__c ProjDoc=new IPM_Project_Document__c();
            String DocName_Str=IPM_ConstantUtils.BLANK;//initialise project document name as string
            DocName_Str=eachDoc.Name.replace(oldprojectnameMap.get(eachDoc.IPM_Project__c),updatedProNameMap.get(eachDoc.IPM_Project__c));//get Project document name after '-' as string
            ProjDoc.id=eachDoc.id;//assign project document id for updation
            ProjDoc.Name=DocName_Str;//update project document name with updated project name
            ProDocList.add(ProjDoc);//add project document records into list
            ProjecToDocMap.put(eachDoc.id,updatedProNameMap.get(eachDoc.IPM_Project__c));//map of project document and project name
            oplProjectToDocMap.put(eachDoc.id,oldprojectnameMap.get(eachDoc.IPM_Project__c));
        }
        if(!ProjecToDocMap.isEmpty()){
            List<IPM_Project_Document_Section__c>projectSectionList=new List<IPM_Project_Document_Section__c>();
            List<IPM_Project_Document_Section__c>ProDocSecList=new List<IPM_Project_Document_Section__c>();
            ProDocSecList=[SELECT name,IPM_Project_Document__c FROM IPM_Project_Document_Section__c WHERE IPM_Project_Document__c=:ProjecToDocMap.keyset() LIMIT 50000];
            //get all project document section records
            for(IPM_Project_Document_Section__c ProDocSec:ProDocSecList){
                IPM_Project_Document_Section__c docsec=new IPM_Project_Document_Section__c();
                String sectionName_Str=IPM_ConstantUtils.BLANK;//initialise project document section name as string
                docsec.id=ProDocSec.id;//assign project document section id for updation
                sectionName_Str=ProDocSec.Name.replace(oplProjectToDocMap.get(ProDocSec.IPM_Project_Document__c),ProjecToDocMap.get(ProDocSec.IPM_Project_Document__c));//get Project document section name after '-' as string
                docsec.Name=sectionName_Str;//update project document section name with updated project name
                projectSectionList.add(docsec);//add project document section records into list
                
            }
           update projectSectionList;
            
            
        }
        return ProDocList;
        
    }
    /********************************************************************************
    *@Description :if origional project name changed then update pareant projects and child projects ipm task ExternalField of 
    *@Param: map of project id's and Project Name and list of ipm tasks
    *@return:list of ipm tasks
    *********************************************************************************/
    public static List<IPM_Task__c> updateTaskName(Map<id,String>updatedProNameMap,List<IPM_Task__c>updateTaskList,Map<Id,String>oldprojectnameMap){
        List<IPM_Task__c>taskList=new List<IPM_Task__c>();
        //get all task list to be update tasks name
        for(IPM_Task__c tsk:updateTaskList){
            IPM_Task__c taskUpdate=new IPM_Task__c();
            String TaskName_Str=IPM_ConstantUtils.BLANK;//initialise task name as string
            taskUpdate.id=tsk.id;//assign task id for updation
            TaskName_Str=tsk.ExternalField__c.replace(oldprojectnameMap.get(tsk.IPM_Project__c),updatedProNameMap.get(tsk.IPM_Project__c));//get task name after '-' as string
            taskUpdate.ExternalField__c=TaskName_Str;//update task name with updated project name
            taskList.add(taskUpdate);//add task records into the list of task
        }
        return taskList;
    }
    /********************************************************************************
    *@Description :if origional project name changed then update ipm milestone external id
    *@Param: map of project id's and Project Name and list of ipm milestones
    *@return:list of ipm milestones
    *********************************************************************************/
    public static List<IPM_Milestone__c> updateMilesName(Map<id,String>updatedProNameMap,List<IPM_Milestone__c>updateMilesList,Map<Id,String>oldprojectnameMap){
        List<IPM_Milestone__c>MilesList=new List<IPM_milestone__c>();
        //get all ipm milestones to be update milestones name 
        for(IPM_Milestone__c miles:updateMilesList){
            IPM_Milestone__c milesUpdate=new IPM_Milestone__c();//Initialise ipm milestone object
            milesUpdate.id=miles.id;//assign milestone id to be update
            String milesName_STR=IPM_ConstantUtils.BLANK;
            milesName_STR=miles.ExternalField__c.replace(oldprojectnameMap.get(miles.IPM_Project__c),updatedProNameMap.get(miles.IPM_Project__c));//get milestone name after '-' as string
            milesUpdate.ExternalField__c=milesName_STR;//update milestone name with updated project name
            MilesList.add(milesUpdate);//add milestones into list
        }
        return MilesList;
    }       
    /********************************************************************************
    *@Description :if origional project name changed then update ipm rollout finance external id
    *@Param: map of project id's and new Project Name and map of project id's and old Project Name
    *@return:null
    *********************************************************************************/
    
    public static void updateRollFinName(Map<id,String>updatedProNameMap,Map<Id,String>oldprojectnameMap,Set<id>rolloutId,Set<Id> existingFinancialYear)
    {
        List<IPM_Financial__c>FinList=new List<IPM_Financial__c>();
        
        List<IPM_Financial__c>rollFinList=new List<IPM_Financial__c>();
		
		map<Id,String>newFinYearNameMap=new map<Id,String>();//new project name with financial year
        
        map<Id,String>oldFinYearNameMap=new map<Id,String>();//old project name with financial year
        
        rollFinList=[SELECT Financial_External_ID__c,IPM_Project_Rollout__c FROM IPM_Financial__c WHERE
                    IPM_Project_Rollout__c IN:rolloutId];
        
        for(IPM_Financial__c fin:rollFinList)
        {
			IPM_Financial__c finUpdate=new IPM_Financial__c();//Initialise ipm finance object
			finUpdate.id=fin.id;//assign finance id to be update
			String finName_STR=IPM_ConstantUtils.BLANK;
			finName_STR=fin.Financial_External_ID__c.replace(oldprojectnameMap.get(fin.IPM_Project_Rollout__c),updatedProNameMap.get(fin.IPM_Project_Rollout__c));//get finance external id after '-' as string
			finUpdate.Financial_External_ID__c = finName_STR;//update finance name with updated project name
			newFinYearNameMap.Put(fin.id,updatedProNameMap.get(fin.IPM_Project_Rollout__c));
			oldFinYearNameMap.Put(fin.id,oldprojectnameMap.get(fin.IPM_Project_Rollout__c));
			FinList.add(finUpdate);//add finance into list
        }
		updateFinYearExternalId(newFinYearNameMap,oldFinYearNameMap,existingFinancialYear);
		update FinList;
        
        
        
    }
    /********************************************************************************
    *@Description :if origional project name changed then update ipm rollout finance year external id
    *@Param: map of project id's and new Project Name and map of project id's and old Project Name
    *@return:null
    *********************************************************************************/
    
    public static void updateFinYearExternalId(Map<id,String>updatedProNameMap,Map<Id,String>oldprojectnameMap,Set<Id> alreadyUpdatedIds)
    {
		List<IPM_Financial_Year__c>finYearList=new List<IPM_Financial_Year__c>();
		
		List<IPM_Financial_Year__c>finList=new List<IPM_Financial_Year__c>();
		
		finYearList=[SELECT External_Id__c,IPM_Financial__c FROM IPM_Financial_Year__c WHERE IPM_Financial__c IN:updatedProNameMap.KeySet() AND Id NOT IN :alreadyUpdatedIds LIMIT 50000];
		
		if(!finYearList.isEmpty())
		{
			for(IPM_Financial_Year__c fin:finYearList)
			{
				IPM_Financial_Year__c finUpdate=new IPM_Financial_Year__c();//Initialise ipm finance object
				finUpdate.id=fin.id;//assign finance id to be update
				String finName_STR=IPM_ConstantUtils.BLANK;
				if(fin.External_Id__c!=null){
				finName_STR=fin.External_Id__c.replace(oldprojectnameMap.get(fin.IPM_Financial__c),updatedProNameMap.get(fin.IPM_Financial__c));//get finance external id after '-' as string
				finUpdate.External_Id__c=finName_STR;//update finance name with updated project name
				}
				finList.add(finUpdate);//add finance into list
			    alreadyUpdatedIds.add(fin.Id); 
			}
			update finList;
		}
		
	}
	/********************************************************************************
    *@Description :if origional project name changed then update ipm rollout name
    *@Param: map of project id's and new Project Name and map of project id's and old Project Name
    *@return:list of ipm rollout
    *********************************************************************************/
    public static List<IPM_Project_Rollout__c> updateRollOut(Map<id,String>updatedProNameMap,List<IPM_Project_Rollout__c>updateRollList,Map<Id,String>oldprojectnameMap,Set<id>rolloutId,Set<Id> existingFinancialYear)
    {
        map<Id,String>newRollNameMap=new map<Id,String>();//new project name with rollout
        map<Id,String>oldRollNameMap=new map<Id,String>();//old project name with rollout
        
        List<IPM_Project_Rollout__c>rollList=new List<IPM_Project_Rollout__c>();
        //get all rollout records to be update rollout name as project name
        for(IPM_Project_Rollout__c roll:updateRollList){
            IPM_Project_Rollout__c rollUpdate=new IPM_Project_Rollout__c();//Initialise ipm finance object
            rollUpdate.id=roll.id;//assign rollout id to be update
            String rollName_STR=IPM_ConstantUtils.BLANK;
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
		updateRollFinName(newRollNameMap,oldRollNameMap,rolloutId,existingFinancialYear);
        return rollList;
    }
    /********************************************************************************
    *@Description :if origional project name changed then update ipm finance external id's
    *@Param: map of project id's and Project Name and list of ipm Financial
    *@return:list of ipm financial
    *********************************************************************************/
    public static List<IPM_Financial__c> updateFinName(Map<id,String>updatedProNameMap,List<IPM_Financial__c>updateFinList,Map<Id,String>oldprojectnameMap,Set<Id> existingFinancialYear)
    {
        List<IPM_Financial__c>FinList=new List<IPM_Financial__c>();
        map<Id,String>newFinYearNameMap=new map<Id,String>();//new project name with financial year
        map<Id,String>oldFinYearNameMap=new map<Id,String>();//old project name with financial year
        
        //get all finance records to be update finance external id as project name
        for(IPM_Financial__c fin:updateFinList)
        {
            IPM_Financial__c finUpdate=new IPM_Financial__c();//Initialise ipm finance object
            finUpdate.id=fin.id;//assign finance id to be update
            String finName_STR=IPM_ConstantUtils.BLANK;
            if(fin.Parent_Project__c!=null)
            {
            	finName_STR=fin.Financial_External_ID__c.replace(oldprojectnameMap.get(fin.Parent_Project__c),updatedProNameMap.get(fin.Parent_Project__c));//get finance external id after '-' as string
				newFinYearNameMap.Put(fin.id,updatedProNameMap.get(fin.Parent_Project__c));
				oldFinYearNameMap.Put(fin.id,oldprojectnameMap.get(fin.Parent_Project__c));
			}
            else if(fin.Parent_Project__c==null && fin.Regional_Project__c!=null && fin.Local_Project__c==null)
            {
            	finName_STR=fin.Financial_External_ID__c.replace(oldprojectnameMap.get(fin.Regional_Project__c),updatedProNameMap.get(fin.Regional_Project__c));//get finance external id after '-' as string
				newFinYearNameMap.Put(fin.id,updatedProNameMap.get(fin.Regional_Project__c));
				oldFinYearNameMap.Put(fin.id,oldprojectnameMap.get(fin.Regional_Project__c));
			}
			else if((fin.Parent_Project__c==null && fin.Regional_Project__c==null && fin.Local_Project__c!=null )|| (fin.Parent_Project__c==null && fin.Regional_Project__c!=null && fin.Local_Project__c!=null))
            {
            	finName_STR=fin.Financial_External_ID__c.replace(oldprojectnameMap.get(fin.Local_Project__c),updatedProNameMap.get(fin.Local_Project__c));//get finance external id after '-' as string
				newFinYearNameMap.Put(fin.id,updatedProNameMap.get(fin.Local_Project__c));
				oldFinYearNameMap.Put(fin.id,oldprojectnameMap.get(fin.Local_Project__c));
			}
            
            finUpdate.Financial_External_ID__c=finName_STR;//update finance name with updated project name
			
            FinList.add(finUpdate);//add finance into list
        }
        
		updateFinYearExternalId(newFinYearNameMap,oldFinYearNameMap,existingFinancialYear);
        return FinList;
    }
	 /********************************************************************************
    *@Description :if origional project name changed then update ipm Project Country name
    *@Param: map of project id's and Project Name and list of ipm countries
    *@return:list of ipm country
    *********************************************************************************/
    public static List<IPM_Country__c> updateCountryName(Map<id,String>updatedProNameMap,List<IPM_Country__c>updateCountyList,Map<Id,String>oldprojectnameMap){
        List<IPM_Country__c>countryList=new List<IPM_Country__c>();
        //get all country records to be update country name as project name
        for(IPM_Country__c cnty:updateCountyList){
            IPM_Country__c CountryUpdate=new IPM_Country__c();//Initialise ipm country object
            CountryUpdate.id=cnty.id;//assign country id to be update
            String rollName_STR=IPM_ConstantUtils.BLANK;
            rollName_STR=cnty.Project_Country__c.replace(oldprojectnameMap.get(cnty.IPM_Project__c),updatedProNameMap.get(cnty.IPM_Project__c));//get country name after '-' as string
            CountryUpdate.Project_Country__c=rollName_STR;//update country name with updated project name
            countryList.add(CountryUpdate);//add country into list
        }
        return countryList;
    }
    /**************************************************************
    * @description: Process the incoming Project and update project name to its child and grand child projects(Regional and Local)  
    * @param: ipmProjectMap : current project(IPM_Project__c) record.
    * @return:list of projects
    */ 
    
    public static List<IPM_Project__c> updateChildProjects(Map<Id, String> updatedProNameMap,Map<Id, String> oldprojectnameMap){
        
        List<IPM_Project__c> childProjectListToUpdate = new List<IPM_Project__c>(); // List of child IPMProjects to be updated
        for(IPM_Project__c childProject :    [SELECT Id,Name,
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
            childProject.Name=childProject.IPM_Project_Name__c;
            childProjectListToUpdate.add(childProject);                                   
          
        }
        
        if(!childProjectListToUpdate.isEmpty())
        {
        	
        	
        	    
            update childProjectListToUpdate;
         	 
        	
        	
        }
        
        return childProjectListToUpdate;
    }
    
    /**************************************************************
    * @description: To set flags to skip triggers on Name Update  
    * @param: isTrue : is Boolean to set the value of True and False.
    */
    public static void skipTiggerExecution(Boolean isTrue)
    {
    	IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION=isTrue;
		IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION=isTrue;
		IPM_ProjectDocumentHelper.SKIP_TRIGGER_EXECUTION=isTrue;
		IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION=isTrue;
		IPM_MilestoneHelper.SKIP_TRIGGER_EXECUTION=isTrue;
		IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION=isTrue;
		IPM_ProjectSectionContentHelper.SKIP_TRIGGER_EXECUTION=isTrue;
		IPM_ProjectCountryDetails.SKIP_TRIGGER_EXECUTION=isTrue;
		IPM_TaskHelper.SKIP_TRIGGER_EXECUTION=isTrue;
		IPM_AssesmentHandler_Helper.SKIP_TRIGGER_EXECUTION=isTrue;	
    }   
}