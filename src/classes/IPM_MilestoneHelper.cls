/**
@Author :Cognizant
@name :IPM_ProjectHelper
@CreateDate :17th Aug 2015
@Description: Helper Class  will contain the methods related to Milestone fucntionality.
@Version :1.0
@reference : Milestone Creation and Copy Miletstone Details
*/

public with sharing class IPM_MilestoneHelper 
{
    public static final String LIMIT_STRING = ' LIMIT 50000 ';
    public static final String FORUPDATE_STRING = ' FOR UPDATE ';
    public static Boolean SKIP_TRIGGER_EXECUTION = false; 
     
    /* @Method Name: prepareCustomMilestoneName
       @Description: This method is used to update Milestone Name based on certain conventions.
       @param1 : incoming Milestone from Trigger
       @param2 : Project Detail Map 
    */
    public static void prepareCustomMilestoneName(IPM_Milestone__c newMilestone,Map<Id,IPM_Project__c> projectDetailMap)
    {
        if(newMilestone.IPM_Project__c !=null && projectDetailMap.containsKey(newMilestone.IPM_Project__c) )
        {
          IPM_Project__c associatedProject = projectDetailMap.get(newMilestone.IPM_Project__c);   

          String projectName = IPM_ConstantUtils.BLANK;
          if(!String.isBlank(associatedProject.IPM_Project_Name__c))
          {
            projectName = associatedProject.IPM_Project_Name__c;
          }
          else
          {
            projectName = associatedProject.Name;
          }
          
          String projectMilestoneName = projectName + '-' + newMilestone.IPM_Name__c;
          if(projectMilestoneName.length() >= 80)
          {
                newMilestone.Name = projectMilestoneName.substring(0,79);
          }
          else
          {
                newMilestone.Name = projectMilestoneName;
          }
        } 
    }
    
    
    /*@Method Name: manageMilestones
      @Date: 
      @Description: This method will be called from IPM_ProjectHandler to Process Milestones for incoming Project. This method will process all the incoming projects and 
      				prepare the standard milestones realted to incoming projects. It can be below possible ways:
      				1) All standard milestones based on Master Milestone data will be created while creating the project
      				2) All standard milestones based on Master Milestone data will be cretaed while creating the child projects(Regional and local) on phase changes
      				3) Current Miletsone will be marked as completed while changing the project phase and its related project's current milestone will also be marked as completd
      					based on which level is driving the flow of the project. 
      @Param1: incomingProjects from IPM_Project__c trigger
    */
    
    /* @sonar 
    This method is currently used for Creating Milestones, Copying Milestones, Marking Milestones as completed on Phase change and Preparing snapshots On Gate Document Change.
    This results in checking Milestones at various levels, based on various Conditions. This results in increase in Complexity. 
    */  
    public static void manageMilestones(Map<Id,IPM_Project__c> incomingProjects)
    {
        List<IPM_Milestone__c> deleteProjectMilestones = new List<IPM_Milestone__c>(); // List of milestones to be deleted 
        Map<String,IPM_Milestone__c> upsertedProjectMilestones = new Map<String,IPM_Milestone__c>(); // Milestone map wwith external key and milestone records to be updated/inserted.
        
        // Iterate the incoming projects and prepare the milestone related records to be processed
        for(IPM_project__c project : incomingProjects.values())
        {
            Boolean existingMilestonesPresent = false; // Boolean to check if Miletsones are already there for the projects
            
            IPM_Project_Type__c currentProjectType = IPM_Utils.retrieveProjectType(project); // Current project type custom setting data
            
            List<IPM_Project_Type__c> previousPhasesList = IPM_Utils.getPreviousPhases(currentProjectType,false); // Previous phase list with the help of IPM Project type custom setting
            
            Set<String> previousPhases = new Set<String>(); // Set of previous phases
            
            for(IPM_Project_Type__c projectType : previousPhasesList)
            {
                previousPhases.add(projectType.IPM_Phase__c);  
            }
            
            // Get Next Phases for Regional Project
            List<IPM_Project_Type__c> nextPhaseList = IPM_Utils.getNextPhases(currentProjectType,false);
            
            // Set the current Phase in the list of next phases, to make sure that we dont complete current Phase Tasks.
            Set<String> nextPhaseSet = new Set<String>();
            
            if(currentProjectType!=null)
            {
                nextPhaseSet.add(currentProjectType.IPM_Phase__c);
            }
            
            for(IPM_Project_Type__c projectType : nextPhaseList)
            {
                nextPhaseSet.add(projectType.IPM_Phase__c); 
            }
            
            if(IPM_ProjectHelper.projectMasterMap.containsKey(project.Id) && IPM_ProjectHelper.projectMasterMap.get(project.Id)!=null)
            {
                IPM_Project__c existingDBProject = IPM_ProjectHelper.projectMasterMap.get(project.Id);
                
                if(existingDBProject!=null && IPM_ProjectHelper.DBprojectSpecificMileStoneMap.containsKey(project.Id) && IPM_ProjectHelper.DBprojectSpecificMileStoneMap.get(project.Id) !=null )
                {
                	
                    for(IPM_Milestone__c existingProjectMilestone : IPM_ProjectHelper.DBprojectSpecificMileStoneMap.get(project.Id))
                    {
                        if(String.isNotBlank(existingProjectMilestone.IPM_Category__c) && existingProjectMilestone.IPM_Category__c.contains(project.IPM_Category_Group__c ))
                        {
                            if(existingProjectMilestone.IPM_Project_Launch_Date__c == project.IPM_Target_Launch_Dates__c)
                            {
                                // Confirms milestones are present for this project
                                existingMilestonesPresent = true;
                            }
                            // If milestones phases is not same as project current phase and is not completed. 
                            if(existingProjectMilestone.IPM_Phase__c !=null && previousPhases.contains(existingProjectMilestone.IPM_Phase__c))
                            {
                                if(existingProjectMilestone.IPM_Completed__c != null && !existingProjectMilestone.IPM_Completed__c )
                                {
                                    existingProjectMilestone.IPM_Completed__c = true;
                                    existingProjectMilestone.IPM_Completed_On__c = System.today();
                                    upsertedProjectMilestones.put(existingProjectMilestone.ExternalField__c,existingProjectMilestone);
                                }
                            }
                        }
                        else
                        {
                            deleteProjectMilestones.add(existingProjectMilestone);
                        }
                    }
                    
                    /* Milestone snapshot due date changes ---- starts here */
                    
                    // Map to current Milestone to all milestones related to that project
					Map<IPM_Milestone__c, List<IPM_Milestone__c>> currentMSToAllMilestonesMap  = new Map<IPM_Milestone__c, List<IPM_Milestone__c>>();
					
					// process all the milestone related to the project and populate the Map with current Phase to all related milestone records
					for(IPM_Milestone__c existingProjectMilestone : IPM_ProjectHelper.DBprojectSpecificMileStoneMap.get(project.Id))
					{
						if(existingProjectMilestone.IPM_Phase__c !=null && previousPhases.contains(existingProjectMilestone.IPM_Phase__c))
						{
							if(upsertedProjectMilestones != null && upsertedProjectMilestones.get(existingProjectMilestone.ExternalField__c) != null)
							{
								currentMSToAllMilestonesMap.put(upsertedProjectMilestones.get(existingProjectMilestone.ExternalField__c), IPM_ProjectHelper.DBprojectSpecificMileStoneMap.get(project.Id));
								break;
							}
						}
					}                 
					
					// process all the milestones to store the snapshot due date of milestones at all standard milestones
					if(!currentMSToAllMilestonesMap.isEmpty())
					{
						// Map to store phase and corresponding Field Api Name which will store the Due date snap shot of milestone
				    	Map<String,String> MILESTONE_PHASE_FIELDMAPPING = new Map<String,String>{
				        IPM_ConstantUtils.PHASE_IDEAS => 'IPM_Due_Date_Idea__c',
				        IPM_ConstantUtils.PHASE_FEASIBILITY  => 'IPM_Due_Date_Feasibility__c',
				        IPM_ConstantUtils.PHASE_CAPABILITY => 'IPM_Due_Date_Capability__c',
				        IPM_ConstantUtils.PHASE_MARKET_READY => 'IPM_Due_Date_Market_Ready__c',
				        IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT => 'IPM_Due_Date_Market_Deployment__c',
				        IPM_ConstantUtils.PHASE_POSTLAUNCHEVAL => 'IPM_Due_Date_Post_Launch_Evaluation__c'
				    	};
				    	
				    	for(IPM_Milestone__c milestone : currentMSToAllMilestonesMap.keySet())
				    	{
				    		for(IPM_Milestone__c projectSpecificMilestone : currentMSToAllMilestonesMap.get(milestone))
				    		{
								if(milestone.IPM_Phase__c != null && MILESTONE_PHASE_FIELDMAPPING.containsKey(milestone.IPM_Phase__c))
								{
									String phaseFieldAPIName = MILESTONE_PHASE_FIELDMAPPING.get(milestone.IPM_Phase__c);
									if(projectSpecificMilestone.IPM_Phase__c != null && milestone.IPM_Phase__c != projectSpecificMilestone.IPM_Phase__c)
									{
										if(projectSpecificMilestone.IPM_Due_Date__c != null)
										{
											projectSpecificMilestone.put(phaseFieldAPIName, projectSpecificMilestone.IPM_Due_Date__c);
											upsertedProjectMilestones.put(projectSpecificMilestone.ExternalField__c,projectSpecificMilestone);
										}
									}
									else if(milestone.IPM_Phase__c == projectSpecificMilestone.IPM_Phase__c) 
									{
										if(milestone.IPM_Due_Date__c != null)
										{
											milestone.put(phaseFieldAPIName, milestone.IPM_Due_Date__c);	
											upsertedProjectMilestones.put(milestone.ExternalField__c,milestone);
										}
									}
								}
				    		}
				    		break;
				    	}
						/* Milestone snapshot due date changes ---- ends here */
					}			
                }
                // This part will clone the milestone records for the projects from its parent Project's Milestones
                if(!existingMilestonesPresent)
                {
                    if(project.IPM_Parent_Project__c != null && IPM_ProjectHelper.projectMasterMap.containsKey(project.IPM_Parent_Project__c) && 
                        IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c)!=null)
                    {
                        // Clone Milestones from Parent
                        IPM_Project__c parentDBProject = IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c);
                           
                        if(IPM_ProjectHelper.DBprojectSpecificMileStoneMap.containsKey(parentDBProject.Id) && IPM_ProjectHelper.DBprojectSpecificMileStoneMap.get(parentDBProject.Id)!=null )
                        {
                            for(IPM_Milestone__c existingProjectMilestone : IPM_ProjectHelper.DBprojectSpecificMileStoneMap.get(parentDBProject.Id))
                            {
                                IPM_Milestone__c standardMilestone = null;
                                Id standardMilestoneId = existingProjectMilestone.IPM_Milestone__c;
                                
                                
                                IPM_Milestone__c newprojectMilestone = existingProjectMilestone.clone(false,true);
                                if(IPM_ProjectHelper.masterMilestoneMap.containsKey(standardMilestoneId) && IPM_ProjectHelper.masterMilestoneMap.get(standardMilestoneId)!=null)
                                {
                                    standardMilestone = IPM_ProjectHelper.masterMilestoneMap.get(standardMilestoneId);
                                    newprojectMilestone.IPM_Milestone__c = standardMilestone.Id;    
                                } 
                                // Market Ready Milestone will also be available for Local Projects   
                                if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && newprojectMilestone.IPM_Phase__c == IPM_ConstantUtils.MARKET_READY_GATE)
                                {
                                    newprojectMilestone.IPM_Active__c = true;
                                }
                                
                                newprojectMilestone.Clone_Record_Id__c = existingProjectMilestone.Id;
                                newprojectMilestone.IPM_Project__c = project.Id;
                                newProjectMilestone.ExternalField__c = project.IPM_Project_Name__c + IPM_ConstantUtils.HYPHEN_DELIMITER + newProjectMilestone.IPM_Name__c + IPM_ConstantUtils.HYPHEN_DELIMITER + newProjectMilestone.IPM_Phase__c + '-'+ newProjectMilestone.IPM_Project_Type__c;
                                
                                // If parent Milestone Belongs to a next phase than Projects current Phase, mark milestone as incomplete.
                                if(nextPhaseSet.contains(newprojectMilestone.IPM_Phase__c))
                                {
                                    newprojectMilestone.IPM_Completed__c = false;
                                    newprojectMilestone.IPM_Completed_On__c = null;     
                                }
                                
                                // Set the Target launch date of milestone of project to Market Deployment Phase milestone planned/due date
                                if(newProjectMilestone.IPM_Phase__c == IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE)
								{
									if(project.IPM_Target_Launch_Dates__c!=null)
									{
										newProjectMilestone.IPM_Planned_Date__c = project.IPM_Target_Launch_Dates__c;
									}
								}
                                upsertedProjectMilestones.put(newProjectMilestone.ExternalField__c,newprojectMilestone);
                            }
                        }
                    }
                    else
                    {
                        // Start Creating Milestone Records 
                        for(IPM_Milestone__c masterMilestone : IPM_ProjectHelper.masterMilestoneMap.values() )
                        {
                            if(String.isNotBlank(masterMilestone.IPM_Category__c) && masterMilestone.IPM_Category__c.contains(project.IPM_Category_Group__c ) && masterMilestone.IPM_Project_Type__c == project.IPM_SourceProjectType__c)
                            {
                                IPM_Milestone__c newProjectMilestone = new IPM_Milestone__c();
                                newProjectMilestone.IPM_Name__c = masterMilestone.IPM_Name__c;
                                newProjectMilestone.IPM_Phase__c = masterMilestone.IPM_Phase__c;
                                newProjectMilestone.IPM_Project_Launch_Date__c = project.IPM_Target_Launch_Dates__c;
                                newProjectMilestone.IPM_Milestone__c = masterMilestone.Id;
                                newProjectMilestone.IPM_Category__c = masterMilestone.IPM_Category__c;
                                newProjectMilestone.IPM_Type_of_gate__c = masterMilestone.IPM_Type_of_gate__c;
                                newProjectMilestone.IPM_Type_of_Milestone__c = masterMilestone.IPM_Type_of_Milestone__c;
                                newProjectMilestone.IPM_Project_Type__c = masterMilestone.IPM_Project_Type__c;
                                newProjectMilestone.IPM_Active__c = masterMilestone.IPM_Active__c;
                                newProjectMilestone.IPM_No_Of_Days_for_Developing__c = masterMilestone.IPM_No_Of_Days_for_Developing__c;
                                newProjectMilestone.IPM_No_Of_Days_for_Developing_Emerging__c = masterMilestone.IPM_No_Of_Days_for_Developing_Emerging__c;
                                newProjectMilestone.IPM_Project__c = project.Id;
                                newProjectMilestone.RecordTypeId = IPM_ProjectHelper.mileProjectRecordType;
                                newProjectMilestone.ExternalField__c = project.IPM_Project_Name__c + IPM_ConstantUtils.HYPHEN_DELIMITER + newProjectMilestone.IPM_Name__c + IPM_ConstantUtils.HYPHEN_DELIMITER + newProjectMilestone.IPM_Phase__c + '-'+ newProjectMilestone.IPM_Project_Type__c;
                                
                                // Due date calculation of market ready gate and Market Deployement gate milestones
                                Date myDate = date.newinstance(project.CreatedDate.year(), project.CreatedDate.month(), project.CreatedDate.day());
                                
                                if(newProjectMilestone.IPM_Type_of_gate__c == IPM_ConstantUtils.MARKET_READY_GATE){
                                  
                                  IPM_Blank_MrktRdyDueDate__c mrktReadyAutoPop = IPM_Blank_MrktRdyDueDate__c.getValues('NumberOfDays');
                                  
                                  if(project.IPM_Target_Launch_Dates__c < System.today().addDays(Integer.valueOf(mrktReadyAutoPop.No_Of_Days__c)))
                                   {
                                     newProjectMilestone.IPM_Planned_Date__c=null; 
                                     newProjectMilestone.IPM_Due_Date__c=null;
                                   }
                                   else if(project.IPM_Market_Type__c ==IPM_Utils.DevelopingIPM_Market_Type && !(project.IPM_Fast_Track_Project__c) && 
                                        String.isNotEmpty(masterMilestone.IPM_No_Of_Days_for_Developing__c))
                                    {
                                        if(project.IPM_Target_Launch_Dates__c!=null &&  project.IPM_Target_Launch_Dates__c + Integer.valueOf(masterMilestone.IPM_No_Of_Days_for_Developing__c) > myDate)
                                        {
                                            newProjectMilestone.IPM_Planned_Date__c = project.IPM_Target_Launch_Dates__c + Integer.valueOf(masterMilestone.IPM_No_Of_Days_for_Developing__c);
                                        }   
                                    }
                                    else if(project.IPM_Market_Type__c == IPM_Utils.EmergingIPM_Market_Type && !(project.IPM_Fast_Track_Project__c) && 
                                            String.isNotEmpty(masterMilestone.IPM_No_Of_Days_for_Developing_Emerging__c))
                                    {
                                        if(project.IPM_Target_Launch_Dates__c !=null && project.IPM_Target_Launch_Dates__c + Integer.valueOf(masterMilestone.IPM_No_Of_Days_for_Developing_Emerging__c) > myDate)
                                        {
                                            newProjectMilestone.IPM_Planned_Date__c = project.IPM_Target_Launch_Dates__c + Integer.valueOf(masterMilestone.IPM_No_Of_Days_for_Developing_Emerging__c);
                                        }
                                    }
                                }else if(String.isNotEmpty(masterMilestone.IPM_No_of_Days__c)){
                                    newProjectMilestone.IPM_Planned_Date__c = project.IPM_Target_Launch_Dates__c + Integer.valueOf(masterMilestone.IPM_No_of_Days__c);
                                }
                                                            
                                // Milestone due date/Planeed should not be copied for Operational Market Ready Gate
                                if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL && newProjectMilestone.IPM_Type_of_gate__c == IPM_ConstantUtils.MARKET_READY_GATE ){
                                    newProjectMilestone.IPM_Planned_Date__c = null;
                                }
                                upsertedProjectMilestones.put(newProjectMilestone.ExternalField__c,newProjectMilestone);
                            }
                        }
                    }
                }   
            }   
        } 
        
        // Milestone list to be upserted if it is not null
        if(upsertedProjectMilestones!=null && !upsertedProjectMilestones.isEmpty())
        { 
            upsert upsertedProjectMilestones.values() ExternalField__c;
        }
        
        // Milestone list to be deleted if it is not null
        if(deleteProjectMilestones!=null && !deleteProjectMilestones.isEmpty())
        {
            delete deleteProjectMilestones;
        }
    }
    
  
    /*@Method Name: CopyMilestones
      @Date: 8th sep 2015
      @Description: This method will be called from IPM_MilestoneHandler to Process Milestones and copy data on related milestones(of related Projects ).
      				Milestone details will be copied to its related project's milestone while changing the due date of milestone  
      @param1 :Map of <Id of Project of incoming Milestone> 
      @param2 :Map of <Id of incoming Milestone and Milestone Record >.
    */
    
    /* @sonar 
    	This method is currently used for copying Over Due dates for Milestones at various levels.Once the due date is populated on a Milestone, System identifies its parent and child Milestones and based on certain conditions including scope and Project Type Parameters.
    	Since it involves searching recursively across various Project Levels,it results in increasing complexity. 
    */ 
    
    public static void CopyMilestones(Map<Id,IPM_Project__c> incomingProjectMap,Map<Id,IPM_Milestone__c> eligibleMilestoneMap)
    {
        
        Set<Id> incomingProjectIds = new Set<Id>();  // Set of incoming project Ids
        Set<String> milestoneNameSet = new Set<String>(); // Set of eligible Milestone name
        Set<String> milestonePhaseSet = new Set<String>(); // Set of eligible Milestone Phase name
        Set<Id> targetProjectIDs = new Set<Id>(); //Set of target project Ids which has related milestones to be updated
                
        Map<Id,Map<Id,IPM_Project__c>> sourceToTargetProjects = new Map<Id,Map<Id,IPM_Project__c>>(); // Map to store incoming Project Ids to target projects 
        Map<Id,IPM_Project__c> masterProjectDetailMap             = new Map<Id,IPM_Project__c>(); // Map to store incoming Project Id and incoming Project record
        Map<Id,IPM_Project__c> projectToParentMapping             = new Map<Id,IPM_Project__c>(); // Map to store incoming project Ids and its parent Project record         
        Map<Id,IPM_Project__c> projectToGrandParentMapping        = new Map<Id,IPM_Project__c>(); // Map to store incoming project Ids and its grand parent Project record
        Map<Id,Map<Id,IPM_Project__c>> projectToChildMapping      = new Map<Id,Map<Id,IPM_Project__c>>(); // Map to store incoming project Ids and its child projects records in map
        Map<Id,Map<Id,IPM_Project__c>> projectToGrandChildMapping = new Map<Id,Map<Id,IPM_Project__c>>(); // Map to store incoming project Ids and its grand child projects records in map
        
        //prepare all related mappings for Project 
        if(!incomingProjectMap.isEmpty())
        {
            incomingProjectIds = incomingProjectMap.keySet();
            masterProjectDetailMap.putAll(incomingProjectMap); 
            masterProjectDetailMap.putAll(IPM_Utils.populateParentProjectDetails(incomingProjectIds));
            masterProjectDetailMap.putAll(IPM_Utils.populateChildProjectDetails(incomingProjectIds));
        
            projectToParentMapping = IPM_Utils.prepareProjectToParentMapping(incomingProjectMap,masterProjectDetailMap);
            projectToGrandParentMapping = IPM_Utils.prepareProjectToGrandParentMapping(projectToParentMapping,masterProjectDetailMap);
            projectToChildMapping = IPM_Utils.prepareProjectToChildMapping(incomingProjectMap,masterProjectDetailMap);
            projectToGrandChildMapping = IPM_Utils.prepareProjectToGrandChildMapping(projectToChildMapping,masterProjectDetailMap);
        }
        
        // Populate the eligible milestone related data
        for(IPM_Milestone__c milestone: eligibleMilestoneMap.values()){
            milestoneNameSet.add(milestone.IPM_Name__c);
            milestonePhaseSet.add(milestone.IPM_Phase__c);
        }
        
        // Empty check for incomingProjetMap
        if(!incomingProjectMap.isEmpty())
        {
          // Iterate based on incoming project ids
          for(Id projectId : incomingProjectMap.KeySet())
          {
            IPM_Project__c incomingProjectDetail =  incomingProjectMap.get(projectId);
            IPM_Project_Type__c currentProjectType =  IPM_Utils.retrieveProjectType(incomingProjectDetail);
            if(currentProjectType!=null && currentProjectType.Independent_Project__c )
            {  
                /* Local Project Calculation Begins.*/
                Map<Id,IPM_Project__c> targetProjectMap = new Map<Id,IPM_Project__c>();
                 
                // Process the local projects based on project span 
                if(incomingProjectDetail.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
                  {
                      
                      if(currentProjectType.IPM_CopyMilestoneToRegional__c && projectToParentMapping.containsKey(projectId))
                      {
                          // Get Regional Project Phase
                          IPM_Project__c regionalProject =  projectToParentMapping.get(projectId);
                          targetProjectMap.put(regionalProject.Id,regionalProject);
                      }
                      
                      if(currentProjectType.IPM_CopyMilestoneToGlobal__c && projectToGrandParentMapping.containsKey(projectId))
                      {
                          // Get Global Project Phase 
                          IPM_Project__c globalProject =  projectToGrandParentMapping.get(projectId);
                          targetProjectMap.put(globalProject.Id,globalProject); 
                      }
                      
                  }
                  /* Local Project Calculation ends */
                  
                  /* Regional Project Calculation Begins */
                  // Process the regional projects based on project span    
                  if(incomingProjectDetail.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL )
                  {
                      
                      if(currentProjectType.IPM_CopyMilestoneToGlobal__c && projectToParentMapping.containsKey(projectId))
                      {
                          // Get Global Project Phase
                          IPM_Project__c globalProject =  projectToParentMapping.get(projectId);
                          targetProjectMap.put(globalProject.Id,globalProject);
                      }
                      
                      if(currentProjectType.IPM_CopyMilestoneToLocal__c && projectToChildMapping.containsKey(projectId))
                      {
                          // Get Local Project Phase
                          Map<Id,IPM_Project__c> localProjectMap =  projectToChildMapping.get(projectId);
                          targetProjectMap.putAll(localProjectMap); 
                          
                      }
                  }
                  /* Regional Project Calculation ends */
                          
                  /* Global Project Calculation begins */
                  // Process the global projects based on project span     
                  if(incomingProjectDetail.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL )
                  {
                      if(currentProjectType.IPM_CopyMilestoneToRegional__c && projectToChildMapping.containsKey(projectId))
                      {
                          // Get regionalProject
                          Map<Id,IPM_Project__c> regionalProjectMap =  projectToChildMapping.get(projectId);
                          targetProjectMap.putAll(regionalProjectMap);
                      }
                      
                      if(currentProjectType.IPM_CopyMilestoneToLocal__c && projectToGrandChildMapping.containsKey(projectId))
                      {
                          // Get localProject
                          Map<Id,IPM_Project__c> localProjectMap =  projectToGrandChildMapping.get(projectId);
                          targetProjectMap.putAll(localProjectMap);
                      }
                
                  }
                  
                  /* Global Project Calculation ends */
                  // Empty check of targetProjectMap
                  if(!targetProjectMap.isEmpty())
                  {                   
                    targetProjectIDs.addAll(targetProjectMap.keySet());
                    sourceToTargetProjects.put(incomingProjectDetail.Id,targetProjectMap);
                  }
              }
          }
        }
        
        // Empty check of sourceToTargetProjects Map and process it if not empty 
        if(!sourceToTargetProjects.isEmpty())
        {
            Map<Id,Map<Id,IPM_Milestone__c> > targetProjectIdToMilestoneMap = new Map<Id,Map<Id,IPM_Milestone__c> >(); // Map to store Targer Projectds and its related milestones
            Map<Id,IPM_Milestone__c> finalMilestoneMap = new Map<Id,IPM_Milestone__c>(); // Final milestone map which are to be updated 
            
            // Loop to iterate milestones and populate the milestone related data
            for (IPM_Milestone__c milestone : [select id,name ,IPM_Project__c, IPM_Project__r.IPMProject_Span__c ,IPM_Phase__c ,IPM_Name__c from IPM_Milestone__c where IPM_Project__c in :targetProjectIDs AND 
                 IPM_Name__c in:milestoneNameSet AND IPM_Phase__c in :milestonePhaseSet AND IPM_Completed__c = false ] )
            {
                Map<Id,IPM_Milestone__c> milestoneMap = new Map<Id,IPM_Milestone__c>(); 
                if(targetProjectIdToMilestoneMap.containsKey(milestone.IPM_Project__c))
                {
                    milestoneMap = targetProjectIdToMilestoneMap.get(milestone.IPM_Project__c);
                }
                milestoneMap.put(milestone.Id,milestone);
                targetProjectIdToMilestoneMap.put(milestone.IPM_Project__c,milestoneMap);
            }
            
            // loop to iterate eligibleMiletsones and prepare the final milestone map data which are to be updated.     
            for(IPM_Milestone__c eligiblemilestone : eligibleMilestoneMap.values())
            {
                // Get source Project Id to identify target Project which need to be updated.
                Id sourceProjectId = eligiblemilestone.IPM_Project__c;
                String sourceKey = eligiblemilestone.IPM_Name__c  + eligiblemilestone.IPM_Phase__c; // Key to identify the milestone at different levels of projects
                if(sourceToTargetProjects.containsKey(sourceProjectId))
                {
                    Map<Id,IPM_Project__c> targetProjectIdMap = sourceToTargetProjects.get(sourceProjectId);
                    for(IPM_Project__c targetProject : targetProjectIdMap.values())
                    {
                        if(targetProjectIdToMilestoneMap.containsKey(targetProject.Id) && targetProjectIdToMilestoneMap.get(targetProject.Id)!=null)
                        {
                            for(IPM_Milestone__c targetMilestone : targetProjectIdToMilestoneMap.get(targetProject.Id).values())
                            {
                                String targetKey = targetMilestone.IPM_Name__c  + targetMilestone.IPM_Phase__c;
                                // Key check to identify the milestone from source to target projects
                                if(sourceKey == targetKey)
                                {
                                    //DEF3184 & DEF3362 fix: Any update to Global/Regional project's milestone's Target Launch Date(Ship to Trade) should not update or copied to Regional/Local Project's milestone's Target Launch Date(Ship to Trade)
                                    if(targetMilestone.IPM_Name__c != IPM_Utils.TargetLaunchDateShiptoTrade) {
                                        targetMilestone.IPM_Planned_Date__c =  eligiblemilestone.IPM_Planned_Date__c;
                                        finalMilestoneMap.put(targetMilestone.Id,targetMilestone);
                                        break;
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                
            }
            
            //update the finalMilestoneMap if it is not empty
            if(!finalMilestoneMap.isEmpty())
            {
                 update finalMilestoneMap.values();
            }    
        }
    }
}