/****************************************************************************************************************************
@Author Cognizant
@name IPM_ProjectSectionContentHelper
@CreateDate 20/08/2015
@Description Helper Class for Section Content Business Logic
@Version 1.0
@reference Project Document Section Content
@Business Logic:This class is invoked when the a Project is created or phase is changed, supporting Project Document Section Content needs to be created
                Based on teh requirement, these contents should flow into the Next Gate Documents available. Based on the Current or Child projects
                these contents gets split hence the logic is complex since each section has separate flow.
*/

public with sharing class IPM_ProjectSectionContentHelper 
{
    
    /**************************************************************
    * @description: Used for Creating OTIF Sections on Project Creation and Change.
    * @param1 projectDocToSectionMap : newly Created project Document To Section Map
    * @param2 projectToDocumentMap : project to Project Document Map 
    * @param3 projectMap : Trigger.New projects Map
    */
    public static Boolean SKIP_TRIGGER_EXECUTION = false;
    public static void createOTIFStatus(Map<Id,List<IPM_Project_Document_Section__c>> projectDocToSectionMap,Map<Id,Map<String,IPM_Project_Document__c>> projectToDocumentMap, Map<Id,IPM_Project__c> projectMap)
    {
        List<IPM_Project_Document_Section_Content__c> insertOTIFStatus = new List<IPM_Project_Document_Section_Content__c>();//list of proj doc section content
        
        for(IPM_Project__c project : projectMap.values())
        {
            IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(project);
            
            if(associatedProjectType!=null)
            {
                String projectGate = associatedProjectType.IPM_Gate_Document__c;
                 
                List<IPM_OTIF_Status__c> gateSpecificOTIFList = IPM_ProjectHelper.gateToOTIFCustomSetting.get(projectGate);
                
              
                if(projectToDocumentMap.containsKey(project.Id) && projectToDocumentMap.get(project.Id)!=null)
                {
                    Map<String,IPM_Project_Document__c> gateToDocMap = projectToDocumentMap.get(project.Id);
                    if(gateToDocMap.containsKey(projectGate) && gateToDocMap.get(projectGate)!=null && gateSpecificOTIFList!=null && !gateSpecificOTIFList.isEmpty())
                    {
                        IPM_Project_Document__c associatedProjectDocument = gateToDocMap.get(projectGate);
                        if(projectDocToSectionMap.containsKey(associatedProjectDocument.Id) && projectDocToSectionMap.get(associatedProjectDocument.Id)!=null)
                        {
                            List<IPM_Project_Document_Section__c> associatedSectionsList = projectDocToSectionMap.get(associatedProjectDocument.Id);
                            // To get the related sections for an otif question
                            Map<String,IPM_Project_Document_Section__c> sectionInformation=new Map<String,IPM_Project_Document_Section__c>();
                            
                            for(IPM_Project_Document_Section__c ips:associatedSectionsList){ 
                                sectionInformation.put(ips.IPM_Master_Section_External_Id__c,ips);
                            }
                            
                           for(IPM_Project_Document_Section__c projectSection : associatedSectionsList)
                           {
                               if(projectSection.IPM_Section_Name__c==IPM_ConstantUtils.OTIF_STATUS || projectSection.IPM_Section_Name__c==IPM_ConstantUtils.OTIF)
                               {
                                    if(!IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id))
                                    {
                                        for(IPM_OTIF_Status__c os:gateSpecificOTIFList)  
                                        {
                                           IPM_Project_Document_Section_Content__c projectDocSecContent = new IPM_Project_Document_Section_Content__c();
                                           projectDocSecContent.IPM_Gate_Type__c = projectGate;
                                           projectDocSecContent.IPM_Project_Document_Section__c = projectSection.Id;
                                           projectDocSecContent.IPM_OTIF_Responsibility__c = os.OTIF_Responsibility__c;
                                           projectDocSecContent.IPM_OTIF_Measure__c = os.OTIF_Measure__c;
                                           projectDocSecContent.IPM_Content_Type__c = IPM_ConstantUtils.OTIF;
                                           projectDocSecContent.IPM_OTIF_Status__c = os.OTIF_Status__c;
                                           projectDocSecContent.IPM_Section_type__c = projectSection.IPM_Section_Type__c;
                                           projectDocSecContent.IPM_OTIF_No_of_Status__c = os.OTIF_No_of_Status__c;
                                           projectDocSecContent.IPM_OTIF_HelpText_Red__c = os.OTIF_HelpText_Red__c;
                                           projectDocSecContent.IPM_OTIF_HelpText_Green__c = os.OTIF_HelpText_Green__c;
                                           projectDocSecContent.IPM_OTIF_HelpText_Amber__c = os.OTIF_HelpText_Amber__c;
                                           projectDocSecContent.IPM_OTIF_HelpText_NA__c = os.OTIF_Help_Text__c;
                                           projectDocSecContent.IPM_OTIF_Sequence__c = os.OTIF_Sequence_Number__c; //sequence number for OTIF
                                           projectDocSecContent.Section_Content_Ext_Id__c=os.IPM_External_Id__c;
                                           
                                           if(sectionInformation.get(os.IPM_External_Id__c)!=null){
                                               projectDocSecContent.IPM_Section_Id__c = sectionInformation.get(os.IPM_External_Id__c).Id;
                                               projectDocSecContent.IPM_Section_Name__c = sectionInformation.get(os.IPM_External_Id__c).IPM_Section_Name__c;
                                           }
                                           insertOTIFStatus.add(projectDocSecContent);
                                        }
                                    }
                               }
                           }
                        }
                    }
                }
            }
        }
        
        if(!insertOTIFStatus.isEmpty())
        {
            insert insertOTIFStatus; 
        }
    }
    
    /************************************************************************************************
    * @description: Used for Creating Financial Action Standard on Project Creation for Charter Gate.
    * @param1 projectDocToSectionMap : newly Created project Document To Section Map
    * @param2 projectToDocumentMap : project to Project Document Map 
    * @param3 projectMap : Trigger.New projects Map
    * NPATHComplexity: This function is used for creating Action Standards across all gate documnet which is a complex functionality.
                       The table for the section Business Case vs Action Standard Section of Charter,Contract and Market Ready document is created at the Charter Document
                       based on the current Financials of the Project. The Action Standad Field Values are Editable at Charter Only, the user has the ability to save these values. 
                       Using this function the record for Financial Action Standard is created at IPM_Project_Document_Section_Content__c object.
                   
    */
    public static void createFinancialActionStandard(Map<Id,List<IPM_Project_Document_Section__c>> projectDocToSectionMap,Map<Id,Map<String,IPM_Project_Document__c>> projectToDocumentMap, Map<Id,IPM_Project__c> projectMap)
    {
        List<IPM_Project_Document_Section_Content__c> insertFinancialActionStandard = new List<IPM_Project_Document_Section_Content__c>();//list of proj doc section content
        
        for(IPM_Project__c project : projectMap.values())
        {
            IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(project);
            
            if(associatedProjectType!=null)
            {
                String projectGate = associatedProjectType.IPM_Gate_Document__c;
                              
                if(projectToDocumentMap.containsKey(project.Id) && projectToDocumentMap.get(project.Id)!=null)
                {
                    Map<String,IPM_Project_Document__c> gateToDocMap = projectToDocumentMap.get(project.Id);
                    if(gateToDocMap.containsKey(projectGate) && gateToDocMap.get(projectGate)!=null)
                    {
                        IPM_Project_Document__c associatedProjectDocument = gateToDocMap.get(projectGate);
                        if(projectDocToSectionMap.containsKey(associatedProjectDocument.Id) && projectDocToSectionMap.get(associatedProjectDocument.Id)!=null && associatedProjectDocument.IPM_GateDocuments__c==IPM_ConstantUtils.CHARTER_GATE)
                        {
                           List<IPM_Project_Document_Section__c> associatedSectionsList = projectDocToSectionMap.get(associatedProjectDocument.Id);
                           for(IPM_Project_Document_Section__c projectSection : associatedSectionsList)
                           {
                               if(projectSection.IPM_Master_Section_External_Id__c==IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD)
                               {
                                    if(!IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id))
                                    {
                                       IPM_Project_Document_Section_Content__c projectDocSecContent = new IPM_Project_Document_Section_Content__c();
                                       projectDocSecContent.IPM_Project_Document_Section__c = projectSection.Id;
                                       projectDocSecContent.IPM_Content_Type__c = IPM_ConstantUtils.FINANCIAL_ACTION_STANDARDS;
                                       projectDocSecContent.IPM_GM_Action_Standards_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                       projectDocSecContent.IPM_gTO_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                       projectDocSecContent.IPM_Innov_Value_Share_Action_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                       projectDocSecContent.IPM_Inc_Value_Share_Action_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                       projectDocSecContent.IPM_IRR_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                       projectDocSecContent.IPM_iTo_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                       projectDocSecContent.IPM_NPV_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                       projectDocSecContent.IPM_Payback_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                       insertFinancialActionStandard.add(projectDocSecContent);
                                    }
                               }
                           }
                        }
                    }
                }
            }
        }
        
        if(!insertFinancialActionStandard.isEmpty())
        {
            insert insertFinancialActionStandard; 
        }
    }
    
     /**************************************************************
    * @description: Used for Creating CMI Sections on Project Creation and Change.
    * @param1 projectDocToSectionMap : newly Created project Document To Section Map
    * @param2 projectToDocumentMap : project to Project Document Map 
    * @param3 projectMap : Trigger.New projects Map
    * NPATHComplexity: This function is used for creating/ copying CMI Sections across Charter, Contract and Market Ready documents.
                        The Test Added at Charter are across Regions and Countries, these Test Needs to be split across Region Level for the Contract Document
                        The Results provided and the Over All calculated at Charter Level should be copied over to sht subsequent Gate Document. Similarly the 
                        Action Standard Set and The Results Achieved get Copied over from Contract to Market Ready documentns.  
    *                  
    */
    public static void manageCMISections(Map<Id,List<IPM_Project_Document_Section__c>> projectDocToSectionMap,Map<Id,Map<String,IPM_Project_Document__c>> projectToDocumentMap, Map<Id,IPM_Project__c> projectMap)
    {
        Set<Id> projectWithoutCMIGates = new Set<Id>();
        
        List<IPM_Project_Document_Section_Content__c> insertprojDocSecConList = new List<IPM_Project_Document_Section_Content__c>();
        
        
        for(IPM_Project__c project : projectMap.values())
        {
            IPM_Project__c currentProject = null;
            List<IPM_Gate_CMI__c> currentProjectCMIGates = null;
    
            IPM_Project_Document__c targetProjectDocument = null;
            IPM_Project_Document_Section__c targetProjectDocumentSection = null;
            Boolean CMIGateSectionAlreadyExists = false;
            
            if(IPM_ProjectHelper.projectMasterMap.containsKey(project.Id) && IPM_ProjectHelper.projectMasterMap.get(project.Id) !=null)
            {
                currentProject = IPM_ProjectHelper.projectMasterMap.get(project.Id);
                if(IPM_ProjectHelper.DBprojectSpecificCMIGateMap.containsKey(project.Id) && IPM_ProjectHelper.DBprojectSpecificCMIGateMap.get(project.Id)!=null)
                {
                    currentProjectCMIGates = IPM_ProjectHelper.DBprojectSpecificCMIGateMap.get(project.Id);
                }
            }
            
            // Get Target Section to which CMI Section Content needs to be appended.           
            if(currentProject != null)
            {
                IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(project);
                String projectGate = null;
                
                // Retrieve the current Gate and find the corresponding project Document and Project document Sections. 
                if(associatedProjectType!=null)
                {
                    projectGate = associatedProjectType.IPM_Gate_Document__c;
                    
                    if(projectGate!=null && !String.isBlank(projectGate) && projectToDocumentMap.containsKey(project.Id) && projectToDocumentMap.get(project.Id)!= null)
                    {
                        Map<String,IPM_Project_Document__c> gateToDocMap  = projectToDocumentMap.get(project.Id);
                        if(gateToDocMap.containsKey(projectGate) && gateToDocMap.get(projectGate)!=null)
                        {
                            targetProjectDocument =  gateToDocMap.get(projectGate);
                            if(projectDocToSectionMap.containsKey(targetProjectDocument.Id) && projectDocToSectionMap.get(targetProjectDocument.Id)!=null)
                            {
                                List<IPM_Project_Document_Section__c> associatedSectionList = projectDocToSectionMap.get(targetProjectDocument.Id);
                                for(IPM_Project_Document_Section__c projectSection : associatedSectionList)
                                {
                                    if(projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.CMI_SECTION )
                                    {
                                          targetProjectDocumentSection = projectSection; 
                                          break;
                                    }
                                }
                            }
                        }
                        
                        if(targetProjectDocument!=null && targetProjectDocumentSection!=null)
                        {
                           // Check if the Section and Content already existed. If yes skip Execution.
                           if(IPM_ProjectHelper.DBprojectSectionSpecificContentMap.containsKey(targetProjectDocumentSection.Id) && 
                                IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(targetProjectDocumentSection.Id)!=null )
                           {
                                List<IPM_Project_Document_Section_Content__c> existingContentList = IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(targetProjectDocumentSection.Id);
                                for(IPM_Project_Document_Section_Content__c existingContent : existingContentList)
                                {
                                    if(existingContent.IPM_Content_Type__c == IPM_ConstantUtils.CMIGATE_CONTENT_TYPE)
                                    {
                                        CMIGateSectionAlreadyExists = true;        
                                    }
                                }
                           } 
                        }
                    }
                    
                    if(!CMIGateSectionAlreadyExists && targetProjectDocument!=null && targetProjectDocumentSection!=null )
                    {
                        IPM_Project_Type__c previousProjectType = IPM_Utils.getPreviousPhase(associatedProjectType,true);
                                     
                        // If project already has CMI Gate Records associated, it means it is a phase shift.
                        //In that case we need to copy over Section Content from one phase to another.
            
                        if(previousProjectType!=null && previousProjectType.IPM_Gate_Document__c!=null && currentProjectCMIGates !=null && !currentProjectCMIGates.isEmpty())
                        {
                            String previousGate = previousProjectType.IPM_Gate_Document__c;

                            // Check if there is already Content Available under Previous Gate Sections.
                            IPM_Project_Document__c sourceProjectDocument = null;
                            IPM_Project_Document_Section__c sourceProjectDocSection = null;
                            
                            List<IPM_Project_Document_Section_Content__c> sourceSectionContentList = new List<IPM_Project_Document_Section_Content__c>(); 
                            
                            // Previous Phase Project document and Sections
                            if(IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(currentProject.Id) && IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id)!=null)
                            {
                                List<IPM_Project_Document__c> existingProjectDocuments = IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id);
                                for(IPM_Project_Document__c existingProjectDocs : existingProjectDocuments)
                                {
                                    if(existingProjectDocs.IPM_GateDocuments__c == previousGate)
                                    {
                                        sourceProjectDocument = existingProjectDocs;
                                        if(IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                            IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null)
                                        {
                                            for(IPM_Project_Document_Section__c previousGateSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                            {
                                                if(previousGateSection.IPM_Master_Section_External_Id__c ==  'Mix_Qualification_Plan_and_Action_Standards')
                                                {
                                                   sourceProjectDocSection =  previousGateSection;
                                                   if(IPM_ProjectHelper.DBprojectSectionSpecificContentMap.containsKey(sourceProjectDocSection.Id) && IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id)!=null )
                                                   {
                                                       List<IPM_Project_Document_Section_Content__c> previousPhaseContentList = IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id);
                                                       for(IPM_Project_Document_Section_Content__c prevPhaseContent : previousPhaseContentList)
                                                       {
                                                           if(prevPhaseContent.IPM_Content_Type__c == IPM_ConstantUtils.CMIGATE_CONTENT_TYPE)
                                                           {
                                                                sourceSectionContentList.add(prevPhaseContent);      
                                                           }
                                                       }  
                                                   }  
                                                   break;
                                                }
                                            }                       
                                        }
                                        break;
                                    }
                                }
                            }
                            // Populate the Data from Previous Phase's Project content 
                           
                            for(IPM_Project_Document_Section_Content__c sourceSectionContent : sourceSectionContentList)
                            {
                                IPM_Project_Document_Section_Content__c projDocSecCon = new IPM_Project_Document_Section_Content__c();
                                projDocSecCon.IPM_CMI_Country__c= sourceSectionContent.IPM_CMI_Country__c;
                                projDocSecCon.IPM_CMI_Input__c= sourceSectionContent.IPM_CMI_Input__c;
                                projDocSecCon.IPM_CMI_Color_Score_Value__c= sourceSectionContent.IPM_CMI_Color_Score_Value__c;
                                projDocSecCon.IPM_CMI_Comments__c= sourceSectionContent.IPM_CMI_Comments__c;
                                projDocSecCon.IPM_CMI_Result__c= sourceSectionContent.IPM_CMI_Result__c;
                                projDocSecCon.IPM_CMI_Results_Acheived__c= sourceSectionContent.IPM_CMI_Results_Acheived__c;
                                projDocSecCon.IPM_Gate_CMI__c= sourceSectionContent.IPM_Gate_CMI__c;
                                projDocSecCon.IPM_Project_Document_Section__c = targetProjectDocumentSection.Id;
                                projDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.CMIGATE_CONTENT_TYPE;
                                projDocSecCon.IPM_CMI_Free_Text__c=sourceSectionContent.IPM_CMI_Free_Text__c;
                                projDocSecCon.IPM_CMI_Overall_Score__c=sourceSectionContent.IPM_CMI_Overall_Score__c;
                                projDocSecCon.IPM_CMI_Overall_Score_Achieved__c=sourceSectionContent.IPM_CMI_Overall_Score_Achieved__c;
                                projDocSecCon.IPM_CMI_Overall_Score_Label__c=sourceSectionContent.IPM_CMI_Overall_Score_Label__c;
                                projDocSecCon.IPM_CMI_Is_Free_Text__c=sourceSectionContent.IPM_CMI_Is_Free_Text__c;
                                projDocSecCon.IPM_CMI_Outcome_Color__c=sourceSectionContent.IPM_CMI_Outcome_Color__c;
                                projDocSecCon.IPM_CMI_Outcome_Color_Achieved__c=sourceSectionContent.IPM_CMI_Outcome_Color_Achieved__c;
                                projDocSecCon.IPM_CMI_Overall_Colour__c=sourceSectionContent.IPM_CMI_Overall_Colour__c;
                                projDocSecCon.IPM_CMI_Overall_Color_Score_Achieved__c=sourceSectionContent.IPM_CMI_Overall_Color_Score_Achieved__c;
                                projDocSecCon.IPM_CMI_Overall_Colour_Coding_Method__c=sourceSectionContent.IPM_CMI_Overall_Colour_Coding_Method__c;
                                projDocSecCon.IPM_CMI_Result_Timing__c=sourceSectionContent.IPM_CMI_Result_Timing__c;
                                projDocSecCon.IPM_CMI_Overall_Colour_Achieved__c=sourceSectionContent.IPM_CMI_Overall_Colour_Achieved__c;
                                projDocSecCon.IPM_CMI_Color_Score_Value_Achieved__c=sourceSectionContent.IPM_CMI_Color_Score_Value_Achieved__c;
                                projDocSecCon.IPM_CMI_Overall_Comments__c=sourceSectionContent.IPM_CMI_Overall_Comments__c;
                                insertprojDocSecConList.add(projDocSecCon);
                            }                
                        }
                        else
                        {
                            projectWithoutCMIGates.add(project.Id);
                        }
                    }
                }
            }
        }
        
        List<IPM_Gate_CMI__c> insertedCMIGateList = new List<IPM_Gate_CMI__c>();

        if(projectWithoutCMIGates!=null && !projectWithoutCMIGates.isEmpty())
        {
            // Check if they have a parent, If yes get specific details.
           for(Id projectID : projectWithoutCMIGates)
           {
                IPM_Project__c currentProject = projectMap.get(projectID);
                IPM_Project__c parentProject = null;
                List<IPM_Gate_CMI__c> parentProjectCMIGates = new List<IPM_Gate_CMI__c>();
                
                IPM_Project_Type__c currentProjectType = IPM_Utils.retrieveProjectType(currentProject);
                
                List<IPM_Project_Type__c> previousPhasesList = IPM_Utils.getPreviousPhases(currentProjectType,true);
               /* Set<String> previousGates = new Set<String>();
                
                for(IPM_Project_Type__c projectType : previousPhasesList)
                {
                    previousGates.add(projectType.IPM_Gate_Document__c);
                }*/
                
                List<IPM_Gate_CMI__c> targetCMIRecords = new List<IPM_Gate_CMI__c>();
                
                Map<String,IPM_Country__c> associatedCountriesMap = new Map<String,IPM_Country__c>();
                
                if(IPM_ProjectHelper.projectToCountryMap!=null && IPM_ProjectHelper.projectToCountryMap.containsKey(projectID)) 
                {
                    associatedCountriesMap = IPM_ProjectHelper.projectToCountryMap.get(projectID);
                }  
                    
                if(currentProject!=null && currentProject.IPM_Parent_Project__c !=null && 
                    IPM_ProjectHelper.projectMasterMap.containsKey(currentProject.IPM_Parent_Project__c) &&  
                        IPM_ProjectHelper.projectMasterMap.get(currentProject.IPM_Parent_Project__c) !=null)
                {
                    parentProject = IPM_ProjectHelper.projectMasterMap.get(currentProject.IPM_Parent_Project__c);
                    
                    if(parentProject!=null && IPM_ProjectHelper.DBprojectSpecificCMIGateMap.containsKey(parentProject.Id) && 
                        IPM_ProjectHelper.DBprojectSpecificCMIGateMap.get(parentProject.Id) !=null)
                    {
                        parentProjectCMIGates = IPM_ProjectHelper.DBprojectSpecificCMIGateMap.get(parentProject.Id);
                        
                        for(IPM_Gate_CMI__c cmiGate : parentProjectCMIGates)
                        {
                           // if(!previousGates.contains(cmiGate.Gate__c))
                            //{
                              targetCMIRecords.add(cmiGate);  
                            //}
                        }
                            
                        if(targetCMIRecords!=null && !targetCMIRecords.isEmpty())
                        {
                           for(IPM_Gate_CMI__c sourceCMIGate : targetCMIRecords)
                           {
                               String countryArrayString = sourceCMIGate.Country__c;
                               String regionalCountryList = '';
                               if(countryArrayString != null && !String.isEmpty(countryArrayString))
                               {
                                   String[] countryArray = countryArrayString.split(IPM_ConstantUtils.SEMICOLON);
                                   for(String country : countryArray)
                                   {
                                       if(associatedCountriesMap.containsKey(country) && associatedCountriesMap.get(country)!=null)
                                       {
                                           if(String.isBlank(regionalCountryList))  
                                           {
                                               regionalCountryList = country;
                                           }
                                           else
                                           {
                                               regionalCountryList = regionalCountryList +IPM_ConstantUtils.SEMICOLON+country;
                                           }                                 
                                       }        
                                   }    
                               }
                               
                               if(regionalCountryList !=null && !String.isBlank(regionalCountryList))
                               {
                                   IPM_Gate_CMI__c gateCMI = new IPM_Gate_CMI__c();
                                   gateCMI.IPM_Project__c = projectID;
                                   gateCMI.Gate__c = sourceCMIGate.Gate__c; 
                                   gateCMI.Element__c = sourceCMIGate.Element__c; 
                                   gateCMI.Test__c = sourceCMIGate.Test__c;
                                   gateCMI.KPI__c = sourceCMIGate.KPI__c;
                                   gateCMI.Input__c = sourceCMIGate.Input__c;
                                   gateCMI.Results__c = sourceCMIGate.Results__c;
                                   gateCMI.IPM_CMI_Overall_Colour_Score_Method__c=sourceCMIGate.IPM_CMI_Overall_Colour_Score_Method__c;
                                   gateCMI.IPM_Skip_Test__c=sourceCMIGate.IPM_Skip_Test__c;
                                   gateCMI.IPM_Skip_Test_Reason__c=sourceCMIGate.IPM_Skip_Test_Reason__c;
                                   gateCMI.Country__c = regionalCountryList;
                                   gateCMI.IPM_CMI_Added_At__c=sourceCMIGate.IPM_CMI_Added_At__c;
                                   insertedCMIGateList.add(gateCMI);
                               }
                           }     
                        }              
                     }
                }    
           }
             
           if(!insertedCMIGateList.isEmpty())
           {
                insert insertedCMIGateList;
           }
        }
        
        for(IPM_Gate_CMI__c cmiObj : insertedCMIGateList)
        {
            Boolean CMIGateSectionAlreadyExists = false;
            ID projectId = cmiObj.IPM_Project__c;
            
            IPM_Project__c currentProject = null;
            IPM_Project__c parentProject = null;
            
            
            IPM_Project_Document__c targetProjectDocument = null;
            IPM_Project_Document_Section__c targetProjectDocumentSection = null;
            
            IPM_Project_Document__c sourceProjectDocument = null;
            IPM_Project_Document_Section__c sourceProjectDocSection = null;
            List<IPM_Project_Document_Section_Content__c> sourceSectionContentList = new List<IPM_Project_Document_Section_Content__c>();
            
            if(projectMap.containsKey(projectId) && projectMap.get(projectId)!=null )
            {
                currentProject = projectMap.get(projectId);
                
                if(currentProject != null)
                {
                    IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(currentProject);
                    String projectGate = null;
                    
                    // Retrieve the current Gate and find the corresponding project Document and Project document Sections. 
                    if(associatedProjectType!=null)
                    {
                        projectGate = associatedProjectType.IPM_Gate_Document__c;
                        
                        if(projectGate!=null && !String.isBlank(projectGate) && projectToDocumentMap.containsKey(projectId) && projectToDocumentMap.get(projectId)!= null)
                        {
                            Map<String,IPM_Project_Document__c> gateToDocMap  = projectToDocumentMap.get(projectId);
                            if(gateToDocMap.containsKey(projectGate) && gateToDocMap.get(projectGate)!=null)
                            {
                                targetProjectDocument =  gateToDocMap.get(projectGate);
                                if(projectDocToSectionMap.containsKey(targetProjectDocument.Id) && projectDocToSectionMap.get(targetProjectDocument.Id)!=null)
                                {
                                    List<IPM_Project_Document_Section__c> associatedSectionList = projectDocToSectionMap.get(targetProjectDocument.Id);
                                    for(IPM_Project_Document_Section__c projectSection : associatedSectionList)
                                    {
                                        if(projectSection.IPM_Master_Section_External_Id__c ==  'Mix_Qualification_Plan_and_Action_Standards' )
                                        {
                                            targetProjectDocumentSection = projectSection; 
                                            // Check if the Section and Content already existed. If yes skip Execution.
                                            if(IPM_ProjectHelper.DBprojectSectionSpecificContentMap.containsKey(targetProjectDocumentSection.Id) && 
                                                IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(targetProjectDocumentSection.Id)!=null )
                                            {
                                                List<IPM_Project_Document_Section_Content__c> existingContentList = IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(targetProjectDocumentSection.Id);
                                                for(IPM_Project_Document_Section_Content__c existingContent : existingContentList)
                                                {
                                                    if(existingContent.IPM_Content_Type__c == IPM_ConstantUtils.CMIGATE_CONTENT_TYPE)
                                                    {
                                                        CMIGateSectionAlreadyExists = true;        
                                                    }
                                                }
                                            } 
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        IPM_Project_Type__c previousProjectType = IPM_Utils.getPreviousPhase(associatedProjectType,true);
                    
                        if(previousProjectType!=null && !CMIGateSectionAlreadyExists && currentProject.IPM_Parent_Project__c !=null && 
                            IPM_ProjectHelper.projectMasterMap.containsKey(currentProject.IPM_Parent_Project__c) && 
                            IPM_ProjectHelper.projectMasterMap.get(currentProject.IPM_Parent_Project__c)!=null ) 
                        {
                            
                            String previousGate = previousProjectType.IPM_Gate_Document__c;
                    
                            parentProject = IPM_ProjectHelper.projectMasterMap.get(currentProject.IPM_Parent_Project__c);
                            
                            if(IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(parentProject.Id) && 
                                IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id)!=null )
                            {
                                List<IPM_Project_Document__c> parentProjectDocuments = IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id);
                                
                                for(IPM_Project_Document__c parentProjectDoc : parentProjectDocuments)
                                {
                                    if(parentProjectDoc.IPM_GateDocuments__c == previousGate)
                                    {
                                        sourceProjectDocument = parentProjectDoc;
                                        if(sourceProjectDocument!=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                            IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null )
                                        {
                                            for(IPM_Project_Document_Section__c parentGateSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                            {
                                                if(parentGateSection.IPM_Master_Section_External_Id__c ==  'Mix_Qualification_Plan_and_Action_Standards')
                                                {
                                                   sourceProjectDocSection = IPM_ProjectHelper.projectSectionMap.get(parentGateSection.Id);
                                                   if(IPM_ProjectHelper.DBprojectSectionSpecificContentMap.containsKey(sourceProjectDocSection.Id) && 
                                                        IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id)!=null)
                                                   {
                                                       List<IPM_Project_Document_Section_Content__c> parentContentList = IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id);
                                                       for(IPM_Project_Document_Section_Content__c parentContent : parentContentList)
                                                       {
                                                           if(parentContent.IPM_Content_Type__c == IPM_ConstantUtils.CMIGATE_CONTENT_TYPE)
                                                           {
                                                                sourceSectionContentList.add(parentContent);      
                                                           }
                                                       }   
                                                   }
                                                   break;
                                                }
                                            }
                                        }
                                        break;
                                    }
                                }
                            }
                             
                            
                            if(sourceSectionContentList!=null && !sourceSectionContentList.isEmpty())
                            {
                                String countryArrayString = cmiObj.Country__c;
                                if(countryArrayString != null && !String.isEmpty(countryArrayString))
                                {
                                    String[] countryArray = countryArrayString.split(IPM_ConstantUtils.SEMICOLON);
                                    
                                    for(String country : countryArray)
                                    {
                                    
                                        for(IPM_Project_Document_Section_Content__c docSectionContent : sourceSectionContentList)
                                        {
                                            if(cmiObj.Test__c == docSectionContent.IPM_CMI_Gate_Test__c && docSectionContent.IPM_CMI_Country__c == country)
                                            {
                                                
                                                IPM_Project_Document_Section_Content__c projDocSecCon = new IPM_Project_Document_Section_Content__c();
                                                projDocSecCon.IPM_CMI_Country__c= country;
                                                projDocSecCon.IPM_CMI_Input__c= docSectionContent.IPM_CMI_Input__c;
                                                projDocSecCon.IPM_CMI_Color_Score_Value__c= docSectionContent.IPM_CMI_Color_Score_Value__c;
                                                projDocSecCon.IPM_CMI_Comments__c= docSectionContent.IPM_CMI_Comments__c;
                                                projDocSecCon.IPM_CMI_Result__c= docSectionContent.IPM_CMI_Result__c;
                                                projDocSecCon.IPM_CMI_Results_Acheived__c= docSectionContent.IPM_CMI_Results_Acheived__c;
                                                projDocSecCon.IPM_Gate_CMI__c= cmiObj.Id;
                                                projDocSecCon.IPM_Project_Document_Section__c = targetProjectDocumentSection.Id;
                                                projDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.CMIGATE_CONTENT_TYPE;
                                                projDocSecCon.IPM_CMI_Free_Text__c=docSectionContent.IPM_CMI_Free_Text__c;
                                                projDocSecCon.IPM_CMI_Overall_Score__c=docSectionContent.IPM_CMI_Overall_Score__c;
                                                projDocSecCon.IPM_CMI_Overall_Score_Achieved__c=docSectionContent.IPM_CMI_Overall_Score_Achieved__c;
                                                projDocSecCon.IPM_CMI_Overall_Score_Label__c=docSectionContent.IPM_CMI_Overall_Score_Label__c;
                                                projDocSecCon.IPM_CMI_Is_Free_Text__c=docSectionContent.IPM_CMI_Is_Free_Text__c;
                                                projDocSecCon.IPM_CMI_Outcome_Color__c=docSectionContent.IPM_CMI_Outcome_Color__c;
                                                projDocSecCon.IPM_CMI_Outcome_Color_Achieved__c=docSectionContent.IPM_CMI_Outcome_Color_Achieved__c;
                                                projDocSecCon.IPM_CMI_Overall_Colour__c=docSectionContent.IPM_CMI_Overall_Colour__c;
                                                projDocSecCon.IPM_CMI_Overall_Color_Score_Achieved__c=docSectionContent.IPM_CMI_Overall_Color_Score_Achieved__c;
                                                projDocSecCon.IPM_CMI_Overall_Colour_Coding_Method__c=docSectionContent.IPM_CMI_Overall_Colour_Coding_Method__c;
                                                projDocSecCon.IPM_CMI_Result_Timing__c=docSectionContent.IPM_CMI_Result_Timing__c;
                                                projDocSecCon.IPM_CMI_Overall_Colour_Achieved__c=docSectionContent.IPM_CMI_Overall_Colour_Achieved__c;
                                                projDocSecCon.IPM_CMI_Color_Score_Value_Achieved__c=docSectionContent.IPM_CMI_Color_Score_Value_Achieved__c;
                                                projDocSecCon.IPM_CMI_Overall_Comments__c=docSectionContent.IPM_CMI_Overall_Comments__c;
                                                insertprojDocSecConList.add(projDocSecCon);    
                                            }
                                        }
                                    }
                                }
                            }
                        }   
                    }
                }
            }
        }
        
        if(insertprojDocSecConList!=null && !insertprojDocSecConList.isEmpty())
        {
            insert insertprojDocSecConList;
        }
    }
    
     /**************************************************************
    * @description: Used for Creating CMI Sections on Project Creation and Change.
    * @param1 projectDocToSectionMap : newly Created project Document To Section Map
    * @param2 projectToDocumentMap : project to Project Document Map 
    * @param3 projectMap : Trigger.New projects Map
    * NPATHComplexity: This function is used for creating/ copying Consumer Evidence across all gate documnet. Based on the Region/Country 
                       For which the test are created, the tests get split in the subsequent gate documents.     
    *                  
    */
     ///carrying the Consumer Evidence Concepts 
    public static void manageCustomerEvidenceConcepts(Map<Id,IPM_Project__c> projectMap,List<IPM_Project_Document__c> projectDocumentList,List<IPM_Project_Document_Section__c> projectSectionList)
    {
        List<IPM_Project_Document_Section_Content__c> insertedSectionContent = new List<IPM_Project_Document_Section_Content__c>(); 
        
        for(IPM_Project__c project : projectMap.values())
        {
            // Get detailedProject Object
            if(projectMap.containsKey(project.Id)!=null && projectMap.get(project.Id)!=null)
            { 
                IPM_Project__c currentProject = projectMap.get(project.Id);
                IPM_Project__c parentProject = null;
                Boolean referParentContent = false;
                if(project.IPM_Parent_Project__c !=null)
                {
                    if(IPM_ProjectHelper.projectMasterMap.containsKey(project.IPM_Parent_Project__c) && 
                        IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c)!=null)
                    {
                        parentProject = IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c);     
                    }        
                }
                    
                IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(currentProject);
                IPM_Project_Type__c previousProjectType = null;
                
                if(associatedProjectType !=null)
                {
                    previousProjectType = IPM_Utils.getPreviousPhase(associatedProjectType,true);
                }
                
                String projectcurrentGate = null; 
                IPM_Project_Document__c targetProjectDocument = null;
                IPM_Project_Document_Section__c targetProjectDocumentSection = null; 
                
                String sourceProjectGate = null;
                IPM_Project_Document__c sourceProjectDocument = null;
                IPM_Project_Document_Section__c sourceProjectDocSection = null;
                    
                
                if(associatedProjectType!=null)
                {
                    projectcurrentGate = associatedProjectType.IPM_Gate_Document__c;
                }
                
                if(previousProjectType!=null)
                {
                    sourceProjectGate = previousProjectType.IPM_Gate_Document__c;
                }
                    
                if(projectcurrentGate!=null)
                {
                    // Get the Target Project document and Corresponding Project Section to which Concepts needs to be copied Over.
                    for(IPM_Project_Document__c projectDoc : projectDocumentList)
                    {
                        if(projectDoc.IPM_GateDocuments__c == projectcurrentGate && projectDoc.IPM_Project__c == project.Id)
                        {
                            targetProjectDocument =  projectDoc;
                            for(IPM_Project_Document_Section__c projectSection : projectSectionList)
                            {
                                if(projectSection.IPM_Project_Document__c == targetProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.CONSUMER_EVIDENCE_CONCEPT )
                                {
                                      targetProjectDocumentSection = projectSection; 
                                      break;
                                }
                            }
                            break;               
                        }           
                    }
                    
                    if(IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(currentProject.Id) && 
                        IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id)!=null)
                    {
                        // Get the source document Section content and validate based on that.
                        for(IPM_Project_Document__c tempProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id))
                        {
                            // If Gate Document Type matches, it means there is already a Gate Document with different Complexity.
                            if(tempProjectDocument.IPM_GateDocuments__c == sourceProjectGate) 
                            {
                                if(IPM_ProjectHelper.projectDocumentMap.containsKey(tempProjectDocument.Id) && 
                                    IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id)!=null)
                                {
                                    sourceProjectDocument = IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id);
                                    // Get the Sections Now.
                                    if(sourceProjectDocument !=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                        IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null )
                                    {
                                        for(IPM_Project_Document_Section__c projectSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                        {
                                            if(projectSection.IPM_Project_Document__c == sourceProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.CONSUMER_EVIDENCE_CONCEPT )
                                            {
                                                  if(IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id) && 
                                                    IPM_ProjectHelper.projectSectionMap.get(projectSection.Id)!=null)
                                                  {
                                                    sourceProjectDocSection = IPM_ProjectHelper.projectSectionMap.get(projectSection.Id);
                                                  }  
                                                  break;
                                            }
                                        }
                                    }
                                }
                                break;                    
                            }
                        }
                    }            
                    
                     // Check if there is a parent.If yes use that as a reference.
                    if( (sourceProjectDocument ==null || sourceProjectDocument == null) && (parentProject!=null && 
                        IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(parentProject.Id)
                        && IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id)!=null ) )
                    {
                        for(IPM_Project_Document__c tempProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id))
                        {
                            // If Gate Document Type matches, it means there is already a Gate Document with different Complexity.
                            if(tempProjectDocument.IPM_GateDocuments__c == sourceProjectGate) 
                            {
                                if(IPM_ProjectHelper.projectDocumentMap.containsKey(tempProjectDocument.Id) && 
                                    IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id)!=null)
                                {
                                    sourceProjectDocument = IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id);
                                    // Get the Sections Now.
                                    if(sourceProjectDocument !=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                        IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null )
                                    {
                                        for(IPM_Project_Document_Section__c projectSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                        {
                                            if(projectSection.IPM_Project_Document__c == sourceProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.CONSUMER_EVIDENCE_CONCEPT )
                                            {
                                                  if(IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id) && 
                                                    IPM_ProjectHelper.projectSectionMap.get(projectSection.Id)!=null)
                                                  {
                                                    sourceProjectDocSection = IPM_ProjectHelper.projectSectionMap.get(projectSection.Id);
                                                    referParentContent = true;
                                                  }  
                                                  break;
                                            }
                                        }
                                    }
                                }
                                break;                    
                            }
                        }            
                    }
                }
                
                // Get the Project Document Section Content and start the copy over logic.
                if(sourceProjectDocSection!=null && IPM_ProjectHelper.DBprojectSectionSpecificContentMap.containsKey(sourceProjectDocSection.Id) && 
                    IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id)!=null )
                {
                    Map<String,IPM_Country__c> associatedCountriesMap = new Map<String,IPM_Country__c>();
                    // Get the list of Countries the project Might be associated with.
                    if(IPM_ProjectHelper.projectToCountryMap!=null && IPM_ProjectHelper.projectToCountryMap.containsKey(project.Id) && 
                        IPM_ProjectHelper.projectToCountryMap.get(project.Id)!=null && !IPM_ProjectHelper.projectToCountryMap.get(project.Id).isEmpty())
                    {
                        associatedCountriesMap = IPM_ProjectHelper.projectToCountryMap.get(project.Id);
                    }
                    
                    List<IPM_Project_Document_Section_Content__c> targetSectionContentList = new List<IPM_Project_Document_Section_Content__c>();
                    
                    for(IPM_Project_Document_Section_Content__c sectionContent : IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id))
                    {
                        if(targetProjectDocumentSection!=null && sectionContent.IPM_Content_Type__c == IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE)
                        {
                            // If Refer from Parent is true, it means we need to only get records which are applicable for that child. In case it is false, it is a phase change.
                            if(!referParentContent)
                            {
                                IPM_Project_Document_Section_Content__c newSectionContent = new IPM_Project_Document_Section_Content__c();
                                newSectionContent.IPM_Consumer_Evidence_Image__c = sectionContent.IPM_Consumer_Evidence_Image__c;
                                newSectionContent.IPM_Consumer_Evidence_Comments__c = sectionContent.IPM_Consumer_Evidence_Comments__c;   
                                newSectionContent.IPM_Consumer_Evidence_Concept_Name__c = sectionContent.IPM_Consumer_Evidence_Concept_Name__c;
                                newSectionContent.IPM_Consumer_Evidence_Priority__c = sectionContent.IPM_Consumer_Evidence_Priority__c;
                                newSectionContent.IPM_Consumer_Evidence_Country__c = sectionContent.IPM_Consumer_Evidence_Country__c;
                                newSectionContent.IPM_Consumer_Evidence_Logo_Id__c = sectionContent.IPM_Consumer_Evidence_Logo_Id__c;
                                newSectionContent.IPM_Project_Document_Section__c = targetProjectDocumentSection.Id;
                                newSectionContent.IPM_Consumer_Evidence_Country__c =   sectionContent.IPM_Consumer_Evidence_Country__c;
                                newSectionContent.IPM_Content_Type__c = IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE;
                                newSectionContent.IPM_Consumer_Evidence_Gate__c= sectionContent.IPM_Consumer_Evidence_Gate__c;
                                insertedSectionContent.add(newSectionContent);   
                            }
                            else 
                            {
                                if(sectionContent.IPM_Consumer_Evidence_Country__c !=null && associatedCountriesMap.containsKey(sectionContent.IPM_Consumer_Evidence_Country__c))
                                {
                                   IPM_Project_Document_Section_Content__c newSectionContent = new IPM_Project_Document_Section_Content__c();
                                   newSectionContent.IPM_Consumer_Evidence_Image__c = sectionContent.IPM_Consumer_Evidence_Image__c;
                                   newSectionContent.IPM_Consumer_Evidence_Comments__c = sectionContent.IPM_Consumer_Evidence_Comments__c;   
                                   newSectionContent.IPM_Consumer_Evidence_Concept_Name__c = sectionContent.IPM_Consumer_Evidence_Concept_Name__c;
                                   newSectionContent.IPM_Consumer_Evidence_Priority__c = sectionContent.IPM_Consumer_Evidence_Priority__c;
                                   newSectionContent.IPM_Consumer_Evidence_Country__c = sectionContent.IPM_Consumer_Evidence_Country__c;
                                   newSectionContent.IPM_Consumer_Evidence_Logo_Id__c = sectionContent.IPM_Consumer_Evidence_Logo_Id__c;
                                   newSectionContent.IPM_Project_Document_Section__c = targetProjectDocumentSection.Id;
                                   newSectionContent.IPM_Consumer_Evidence_Country__c =   sectionContent.IPM_Consumer_Evidence_Country__c;
                                   newSectionContent.IPM_Content_Type__c = IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE;
                                   newSectionContent.IPM_Consumer_Evidence_Gate__c= sectionContent.IPM_Consumer_Evidence_Gate__c;
                                   insertedSectionContent.add(newSectionContent);
                               }
                            }
                        }    
                    }
                    
                }
            }
        }
        
        if(insertedSectionContent!=null && !insertedSectionContent.isEmpty())
        {
            insert insertedSectionContent;
        }           
    }
    
     /**************************************************************
    * @description: Used for Creating Customer Channel Sections on Project Creation and Change.
    * @param1 projectDocToSectionMap : newly Created project Document To Section Map
    * @param2 projectToDocumentMap : project to Project Document Map 
    * @param3 projectMap : Trigger.New projects Map
    * NPATHComplexity: This function is used for copying Customer Channel across all gate documnet for Charter/Contract and Market Ready documents. 
                       Customer Channel created at the Previous gate should be copied over the the Next gate document. The below fucntion enbles the copy of the
                       Project Document Section Content record related to customer channel from Previous gate document to the current gate document
    *                 
    */
    ///Carrying the Customer Channel Section 
    public static void manageCustomerChannel(Map<Id,IPM_Project__c> projectMap,List<IPM_Project_Document__c> projectDocumentList,List<IPM_Project_Document_Section__c> projectSectionList)
    {
        List<IPM_Project_Document_Section_Content__c> insertedSectionContent = new List<IPM_Project_Document_Section_Content__c>(); 
        
        for(IPM_Project__c project : projectMap.values())
        {
            // Get detailedProject Object
            if(projectMap.containsKey(project.Id)!=null && projectMap.get(project.Id)!=null)
            { 
                IPM_Project__c currentProject = projectMap.get(project.Id);
                IPM_Project__c parentProject = null;
                Boolean referParentContent = false;
                if(project.IPM_Parent_Project__c !=null)
                {
                    if(IPM_ProjectHelper.projectMasterMap.containsKey(project.IPM_Parent_Project__c) && IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c)!=null)
                    {
                        parentProject = IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c);     
                    }        
                }
                    
                IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(currentProject);
                IPM_Project_Type__c previousProjectType = null;
                
                if(associatedProjectType!=null)
                {
                    previousProjectType = IPM_Utils.getPreviousPhase(associatedProjectType,true);   
                }
                
                String projectcurrentGate = null; 
                IPM_Project_Document__c targetProjectDocument = null;
                IPM_Project_Document_Section__c targetProjectDocumentSection = null;
                
                String sourceProjectGate = null;
                IPM_Project_Document__c sourceProjectDocument = null;
                IPM_Project_Document_Section__c sourceProjectDocSection = null;
                    
                
                if(associatedProjectType!=null)
                {
                    projectcurrentGate = associatedProjectType.IPM_Gate_Document__c;
                }
                
                if(previousProjectType!=null)
                {
                    sourceProjectGate = previousProjectType.IPM_Gate_Document__c;
                }
                
                if(projectcurrentGate!=null)
                {
                    // Get the Target Project document and Corresponding Project Section to which Concepts needs to be copied Over.
                    for(IPM_Project_Document__c projectDoc : projectDocumentList)
                    {
                        if(projectDoc.IPM_GateDocuments__c == projectcurrentGate && projectDoc.IPM_Project__c == project.Id)
                        {
                            targetProjectDocument =  projectDoc;
                            for(IPM_Project_Document_Section__c projectSection : projectSectionList)
                            {
                                if(projectSection.IPM_Project_Document__c == targetProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.CUSTOMER_CHANNEL )
                                {
                                      targetProjectDocumentSection = projectSection; 
                                      break;
                                }
                            }
                            break;               
                        }           
                    }
                    if(IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(currentProject.Id) && 
                        IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id)!=null)
                    {
                        // Get the source document Section content and validate based on that.
                        for(IPM_Project_Document__c tempProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id))
                        {
                            // If Gate Document Type matches, it means there is already a Gate Document with different Complexity.
                            if(tempProjectDocument.IPM_GateDocuments__c == sourceProjectGate) 
                            {
                                if(IPM_ProjectHelper.projectDocumentMap.containsKey(tempProjectDocument.Id) && 
                                    IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id)!=null)
                                {
                                    sourceProjectDocument = IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id);
                                    // Get the Sections Now.
                                    if(sourceProjectDocument !=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                        IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null )
                                    {
                                        for(IPM_Project_Document_Section__c projectSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                        {
                                            if(projectSection.IPM_Project_Document__c == sourceProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.CUSTOMER_CHANNEL )
                                            {
                                                  if(IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id) && IPM_ProjectHelper.projectSectionMap.get(projectSection.Id)!=null)
                                                  {
                                                    sourceProjectDocSection = IPM_ProjectHelper.projectSectionMap.get(projectSection.Id);
                                                  }  
                                                  break;
                                            }
                                        }
                                    }
                                }
                                break;                    
                            }
                        }
                    }            
                    
                     // Check if there is a parent.If yes use that as a reference.
                    if( (sourceProjectDocument ==null || sourceProjectDocument == null) && (parentProject!=null && 
                        IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(parentProject.Id)
                        && IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id)!=null ) )
                    {
                        for(IPM_Project_Document__c tempProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id))
                        {
                            // If Gate Document Type matches, it means there is already a Gate Document with different Complexity.
                            if(tempProjectDocument.IPM_GateDocuments__c == sourceProjectGate) 
                            {
                                if(IPM_ProjectHelper.projectDocumentMap.containsKey(tempProjectDocument.Id) && 
                                    IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id)!=null)
                                {
                                    sourceProjectDocument = IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id);
                                    // Get the Sections Now.
                                    if(sourceProjectDocument !=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                        IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null )
                                    {
                                        for(IPM_Project_Document_Section__c projectSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                        {
                                            if(projectSection.IPM_Project_Document__c == sourceProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.CUSTOMER_CHANNEL )
                                            {
                                                  if(IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id) && 
                                                    IPM_ProjectHelper.projectSectionMap.get(projectSection.Id)!=null)
                                                  {
                                                    sourceProjectDocSection = IPM_ProjectHelper.projectSectionMap.get(projectSection.Id);
                                                    referParentContent = true;
                                                  }  
                                                  break;
                                            }
                                        }
                                    }
                                }
                                break;                    
                            }
                        }            
                    }
                }
                
                // Get the Project Document Section Content and start the copy over logic.
                if(sourceProjectDocSection!=null && IPM_ProjectHelper.DBprojectSectionSpecificContentMap.containsKey(sourceProjectDocSection.Id) && 
                    IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id)!=null )
                {
                    List<IPM_Project_Document_Section_Content__c> targetSectionContentList = new List<IPM_Project_Document_Section_Content__c>();
                    for(IPM_Project_Document_Section_Content__c sectionContent : IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id))
                    {
                        if(sectionContent.IPM_Content_Type__c == IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION)
                        {
                            // If Refer from Parent is true, it means we need to only get records which are applicable for that child. In case it is false, it is a phase change.
                            IPM_Project_Document_Section_Content__c newSectionContent = new IPM_Project_Document_Section_Content__c();
                            newSectionContent.IPM_Project_Document_Section__c = targetProjectDocumentSection.Id;
                            newSectionContent.IPM_Preposition__c = sectionContent.IPM_Preposition__c;
                            newSectionContent.IPM_Customer_Channel_Priority__c = sectionContent.IPM_Customer_Channel_Priority__c;
                            newSectionContent.IPM_Customer_Channel_Priority_Order__c = sectionContent.IPM_Customer_Channel_Priority_Order__c;
                            newSectionContent.IPM_Promotion__c = sectionContent.IPM_Promotion__c;
                            newSectionContent.IPM_Price__c = sectionContent.IPM_Price__c;
                            newSectionContent.IPM_Pack__c = sectionContent.IPM_Pack__c;
                            newSectionContent.IPM_Place__c = sectionContent.IPM_Place__c;
                            newSectionContent.IPM_Customer_Channels__c = sectionContent.IPM_Customer_Channels__c;
                            newSectionContent.IPM_Product__c = sectionContent.IPM_Product__c;
                            newSectionContent.IPM_Section_type__c = sectionContent.IPM_Section_type__c;
                            newSectionContent.IPM_Preposition_Image_1_Id__c = sectionContent.IPM_Preposition_Image_1_Id__c;
                            newSectionContent.IPM_Preposition_Image_2_Id__c = sectionContent.IPM_Preposition_Image_2_Id__c;
                            newSectionContent.IPM_Promotion_Image_1_Id__c = sectionContent.IPM_Promotion_Image_1_Id__c;
                            newSectionContent.IPM_Promotion_Image_2_Id__c = sectionContent.IPM_Promotion_Image_2_Id__c;
                            newSectionContent.IPM_Product_Image_1_Id__c = sectionContent.IPM_Product_Image_1_Id__c;
                            newSectionContent.IPM_Product_Image_2_Id__c = sectionContent.IPM_Product_Image_2_Id__c;
                            newSectionContent.IPM_Pack_Image_1_Id__c = sectionContent.IPM_Pack_Image_1_Id__c;
                            newSectionContent.IPM_Pack_Image_2_Id__c = sectionContent.IPM_Pack_Image_2_Id__c;
                            newSectionContent.IPM_Price_Image_1_Id__c = sectionContent.IPM_Price_Image_1_Id__c;
                            newSectionContent.IPM_Price_Image_2_Id__c = sectionContent.IPM_Price_Image_2_Id__c;
                            newSectionContent.IPM_Place_Image_1_Id__c = sectionContent.IPM_Place_Image_1_Id__c;
                            newSectionContent.IPM_Place_Image_2_Id__c = sectionContent.IPM_Place_Image_2_Id__c;
                            newSectionContent.IPM_Content_Type__c = IPM_ConstantUtils.CUSTOMER_CHANNEL_SECTION;
                            insertedSectionContent.add(newSectionContent);   
                        }    
                    }
                }
            }
        }
        
        if(insertedSectionContent!=null && !insertedSectionContent.isEmpty()){
            insert insertedSectionContent;
        }           
    }
    
     /**************************************************************
    * @description: Used for Creating MAnageing Financial Action Standard on Project Creation and Change.
    * @param1 projectDocToSectionMap : newly Created project Document To Section Map
    * @param2 projectToDocumentMap : project to Project Document Map 
    * @param3 projectMap : Trigger.New projects Map
    * NPATHComplexity: This function is used for creating Action Standards across all gate documnet which is a complex functionality.
                       The table for the section Business Case vs Action Standard Section of Charter,Contract and Market Ready document is created at the Charter Document
                       based on the current Financials of the Project. The Action Standad Field Values are Editable at Charter Only, the user has the ability to save these values. 
                       Using this function the record for Financial Action Standard is created at IPM_Project_Document_Section_Content__c object.

    */
    ///Carrying Financial Action Atandards 
    public static void manageFinancialActionStandards(Map<Id,IPM_Project__c> projectMap,List<IPM_Project_Document__c> projectDocumentList,List<IPM_Project_Document_Section__c> projectSectionList)
    {
        List<IPM_Project_Document_Section_Content__c> insertedSectionContent = new List<IPM_Project_Document_Section_Content__c>(); 
        
        for(IPM_Project__c project : projectMap.values())
        {
            // Get detailedProject Object
            if(projectMap.containsKey(project.Id)!=null && projectMap.get(project.Id)!=null && project.IPM_Phase__c!=IPM_ConstantUtils.PHASE_MARKET_READY)
            { 
                IPM_Project__c currentProject = projectMap.get(project.Id);
                IPM_Project__c parentProject = null;
                Boolean referParentContent = false;
                if(project.IPM_Parent_Project__c !=null)
                {
                    if(IPM_ProjectHelper.projectMasterMap.containsKey(project.IPM_Parent_Project__c) && IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c)!=null)
                    {
                        parentProject = IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c);     
                    }        
                }
                    
                IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(currentProject);
                IPM_Project_Type__c previousProjectType = null;
                
                if(associatedProjectType!=null)
                {
                    previousProjectType = IPM_Utils.getPreviousPhase(associatedProjectType,true);   
                }
                
                String projectcurrentGate = null; 
                IPM_Project_Document__c targetProjectDocument = null;
                IPM_Project_Document_Section__c targetProjectDocumentSection = null;
                
                String sourceProjectGate = null;
                IPM_Project_Document__c sourceProjectDocument = null;
                IPM_Project_Document_Section__c sourceProjectDocSection = null;
                    
                
                if(associatedProjectType!=null)
                {
                    projectcurrentGate = associatedProjectType.IPM_Gate_Document__c;
                }
                
                if(previousProjectType!=null)
                {
                    sourceProjectGate = previousProjectType.IPM_Gate_Document__c;
                }
                
                if(projectcurrentGate!=null)
                {
                    // Get the Target Project document and Corresponding Project Section to which Concepts needs to be copied Over.
                    for(IPM_Project_Document__c projectDoc : projectDocumentList)
                    {
                        if(projectDoc.IPM_GateDocuments__c == projectcurrentGate && projectDoc.IPM_Project__c == project.Id)
                        {
                            targetProjectDocument =  projectDoc;
                            for(IPM_Project_Document_Section__c projectSection : projectSectionList)
                            {
                                if(projectSection.IPM_Project_Document__c == targetProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD )
                                {
                                      targetProjectDocumentSection = projectSection; 
                                      break;
                                }
                            }
                            break;               
                        }           
                    }
                    
                    if(IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(currentProject.Id) && 
                        IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id)!=null)
                    {
                        // Get the source document Section content and validate based on that.
                        for(IPM_Project_Document__c tempProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id))
                        {
                            // If Gate Document Type matches, it means there is already a Gate Document with different Complexity.
                            if(tempProjectDocument.IPM_GateDocuments__c == sourceProjectGate) 
                            {
                                if(IPM_ProjectHelper.projectDocumentMap.containsKey(tempProjectDocument.Id) && 
                                    IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id)!=null)
                                {
                                    sourceProjectDocument = IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id);
                                    // Get the Sections Now.
                                    if(sourceProjectDocument !=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                        IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null )
                                    {
                                        for(IPM_Project_Document_Section__c projectSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                        {
                                            if(projectSection.IPM_Project_Document__c == sourceProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD )
                                            {
                                                  if(IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id) && IPM_ProjectHelper.projectSectionMap.get(projectSection.Id)!=null)
                                                  {
                                                    sourceProjectDocSection = IPM_ProjectHelper.projectSectionMap.get(projectSection.Id);
                                                  }  
                                                  break;
                                            }
                                        }
                                    }
                                }
                                break;                    
                            }
                        }
                    }            
                    
                     // Check if there is a parent.If yes use that as a reference.
                    if( (sourceProjectDocument ==null || sourceProjectDocument == null) && (parentProject!=null && 
                        IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(parentProject.Id)
                        && IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id)!=null ) )
                    {
                        for(IPM_Project_Document__c tempProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id))
                        {
                            // If Gate Document Type matches, it means there is already a Gate Document with different Complexity.
                            if(tempProjectDocument.IPM_GateDocuments__c == sourceProjectGate) 
                            {
                                if(IPM_ProjectHelper.projectDocumentMap.containsKey(tempProjectDocument.Id) && 
                                    IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id)!=null)
                                {
                                    sourceProjectDocument = IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id);
                                    // Get the Sections Now.
                                    if(sourceProjectDocument !=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                        IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null )
                                    {
                                        for(IPM_Project_Document_Section__c projectSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                        {
                                            if(projectSection.IPM_Project_Document__c == sourceProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD )
                                            {
                                                  if(IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id) && 
                                                    IPM_ProjectHelper.projectSectionMap.get(projectSection.Id)!=null)
                                                  {
                                                    sourceProjectDocSection = IPM_ProjectHelper.projectSectionMap.get(projectSection.Id);
                                                    referParentContent = true;
                                                  }  
                                                  break;
                                            }
                                        }
                                    }
                                }
                                break;                    
                            }
                        }            
                    }
                }
                
                // Get the Project Document Section Content and start the copy over logic.
                if(sourceProjectDocSection!=null && IPM_ProjectHelper.DBprojectSectionSpecificContentMap.containsKey(sourceProjectDocSection.Id) && 
                    IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id)!=null )
                {
                    List<IPM_Project_Document_Section_Content__c> targetSectionContentList = new List<IPM_Project_Document_Section_Content__c>();
                    for(IPM_Project_Document_Section_Content__c sectionContent : IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id))
                    {
                        if(sectionContent.IPM_Content_Type__c == IPM_ConstantUtils.FINANCIAL_ACTION_STANDARDS)
                        {
                            // If Refer from Parent is true, it means we need to only get records which are applicable for that child. In case it is false, it is a phase change.
                            IPM_Project_Document_Section_Content__c newSectionContent = new IPM_Project_Document_Section_Content__c();
                            newSectionContent.IPM_Project_Document_Section__c = targetProjectDocumentSection.Id;
                            newSectionContent.IPM_Section_Name__c=sectionContent.IPM_Section_Name__c;
                            newSectionContent.IPM_GM_Action_Standards_Charter__c = sectionContent.IPM_GM_Action_Standards_Charter__c;
                            newSectionContent.IPM_GM_Action_Standards_Charter_Cmts__c = sectionContent.IPM_GM_Action_Standards_Charter_Cmts__c;
                            newSectionContent.IPM_gTO_Action_Standard_Charter__c = sectionContent.IPM_gTO_Action_Standard_Charter__c;
                            newSectionContent.IPM_gTO_Action_Standard_Charter_Cmts__c = sectionContent.IPM_gTO_Action_Standard_Charter_Cmts__c;
                            newSectionContent.IPM_Inov_Value_Share_Action_Charter_Cmts__c = sectionContent.IPM_Inov_Value_Share_Action_Charter_Cmts__c;
                            newSectionContent.IPM_Innov_Value_Share_Action_Charter__c = sectionContent.IPM_Innov_Value_Share_Action_Charter__c;
                            newSectionContent.IPM_Inc_Value_Share_Action_Charter__c = sectionContent.IPM_Inc_Value_Share_Action_Charter__c;
                            newSectionContent.IPM_Inc_Val_Share_Action_Charter_Cmts__c = sectionContent.IPM_Inc_Val_Share_Action_Charter_Cmts__c;
                            newSectionContent.IPM_IRR_Action_Standard_Charter__c = sectionContent.IPM_IRR_Action_Standard_Charter__c;
                            newSectionContent.IPM_IRR_Action_Standard_Charter_Cmts__c = sectionContent.IPM_IRR_Action_Standard_Charter_Cmts__c;
                            newSectionContent.IPM_iTo_Action_Standard_Charter__c = sectionContent.IPM_iTo_Action_Standard_Charter__c;
                            newSectionContent.IPM_iTo_Action_Standard_Charter_Cmts__c = sectionContent.IPM_iTo_Action_Standard_Charter_Cmts__c;
                            newSectionContent.IPM_NPV_Action_Standard_Charter__c = sectionContent.IPM_NPV_Action_Standard_Charter__c;
                            newSectionContent.IPM_NPV_Action_Standard_Charter_Cmts__c = sectionContent.IPM_NPV_Action_Standard_Charter_Cmts__c;
                            newSectionContent.IPM_Payback_Action_Standard_Charter__c = sectionContent.IPM_Payback_Action_Standard_Charter__c;
                            newSectionContent.IPM_Payback_Action_Standard_Charter_Cmts__c = sectionContent.IPM_Payback_Action_Standard_Charter_Cmts__c;                         
                            newSectionContent.IPM_Content_Type__c = IPM_ConstantUtils.FINANCIAL_ACTION_STANDARDS;
                            insertedSectionContent.add(newSectionContent);   
                        }    
                    }
                }
            }
        }
        
        if(insertedSectionContent!=null && !insertedSectionContent.isEmpty()){
            insert insertedSectionContent;
        }           
    }
    
     /**************************************************************
    * @description: Used for Managing CU on Project Creation and Change.
    * @param1 projectDocToSectionMap : newly Created project Document To Section Map
    * @param2 projectToDocumentMap : project to Project Document Map 
    * @param3 projectMap : Trigger.New projects Map
    * NPATHComplexity: This function is used for creating/ copying CU Sections across Charter, COntract and Market Ready Gate Documents.
                        the user needs to provide a Charter CU affected answer, this gets carried over to subsequet Gates. Hence new Section Content Record is created for the
                        Section in the current Active gate Document.  
    *                 
    */
     ///Carrying the Cu Complexity Section
    public static void manageCuComplexity(Map<Id,IPM_Project__c> projectMap,List<IPM_Project_Document__c> projectDocumentList,List<IPM_Project_Document_Section__c> projectSectionList)
    {
        List<IPM_Project_Document_Section_Content__c> insertedSectionContent = new List<IPM_Project_Document_Section_Content__c>(); 
        
        for(IPM_Project__c project : projectMap.values())
        {
            // Get detailedProject Object
            if(projectMap.containsKey(project.Id)!=null && projectMap.get(project.Id)!=null)
            { 
                IPM_Project__c currentProject = projectMap.get(project.Id);
                IPM_Project__c parentProject = null;
                Boolean referParentContent = false;
                if(project.IPM_Parent_Project__c !=null)
                {
                    if(IPM_ProjectHelper.projectMasterMap.containsKey(project.IPM_Parent_Project__c) && IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c)!=null)
                    {
                        parentProject = IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c);     
                    }        
                }
                    
                IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(currentProject);
                IPM_Project_Type__c previousProjectType = null;
                
                if(associatedProjectType!=null)
                {
                    previousProjectType = IPM_Utils.getPreviousPhase(associatedProjectType,true);   
                }
                
                String projectcurrentGate = null; 
                IPM_Project_Document__c targetProjectDocument = null;
                IPM_Project_Document_Section__c targetProjectDocumentSection = null;
                
                String sourceProjectGate = null;
                IPM_Project_Document__c sourceProjectDocument = null;
                IPM_Project_Document_Section__c sourceProjectDocSection = null;
                
                if(associatedProjectType!=null)
                {
                    projectcurrentGate = associatedProjectType.IPM_Gate_Document__c;
                }
                
                if(previousProjectType!=null)
                {
                    sourceProjectGate = previousProjectType.IPM_Gate_Document__c;
                }
                
                if(projectcurrentGate!=null && projectcurrentGate==IPM_ConstantUtils.MARKET_READY_GATE)
                {
                    // Get the Target Project document and Corresponding Project Section to which Concepts needs to be copied Over.
                    for(IPM_Project_Document__c projectDoc : projectDocumentList)
                    {
                        if(projectDoc.IPM_GateDocuments__c == projectcurrentGate && projectDoc.IPM_Project__c == project.Id)
                        {
                            targetProjectDocument =  projectDoc;
                            for(IPM_Project_Document_Section__c projectSection : projectSectionList)
                            {
                                if(projectSection.IPM_Project_Document__c == targetProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.IPM_CU_COMPLEXITY)
                                {
                                      targetProjectDocumentSection = projectSection; 
                                      break;
                                }
                            }
                            break;               
                        }           
                    }
                    
                    if(IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(currentProject.Id) && 
                        IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id)!=null)
                    {
                        // Get the source document Section content and validate based on that.
                        for(IPM_Project_Document__c tempProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id))
                        {
                            // If Gate Document Type matches, it means there is already a Gate Document with different Complexity.
                            if(tempProjectDocument.IPM_GateDocuments__c == sourceProjectGate) 
                            {
                                if(IPM_ProjectHelper.projectDocumentMap.containsKey(tempProjectDocument.Id) && 
                                    IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id)!=null)
                                {
                                    sourceProjectDocument = IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id);
                                    // Get the Sections Now.
                                    if(sourceProjectDocument !=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                        IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null )
                                    {
                                        for(IPM_Project_Document_Section__c projectSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                        {
                                            if(projectSection.IPM_Project_Document__c == sourceProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.IPM_CU_COMPLEXITY)
                                            {
                                                  if(IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id) && IPM_ProjectHelper.projectSectionMap.get(projectSection.Id)!=null)
                                                  {
                                                    sourceProjectDocSection = IPM_ProjectHelper.projectSectionMap.get(projectSection.Id);
                                                  }  
                                                  break;
                                            }
                                        }
                                    }
                                }
                                break;                    
                            }
                        }
                    }            
                    
                     // Check if there is a parent.If yes use that as a reference.
                    if( (sourceProjectDocument ==null || sourceProjectDocument == null) && (parentProject!=null && 
                        IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(parentProject.Id)
                        && IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id)!=null ) )
                    {
                        for(IPM_Project_Document__c tempProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id))
                        {
                            // If Gate Document Type matches, it means there is already a Gate Document with different Complexity.
                            if(tempProjectDocument.IPM_GateDocuments__c == sourceProjectGate) 
                            {
                                if(IPM_ProjectHelper.projectDocumentMap.containsKey(tempProjectDocument.Id) && 
                                    IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id)!=null)
                                {
                                    sourceProjectDocument = IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id);
                                    // Get the Sections Now.
                                    if(sourceProjectDocument !=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                        IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null )
                                    {
                                        for(IPM_Project_Document_Section__c projectSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                        {
                                            if(projectSection.IPM_Project_Document__c == sourceProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.IPM_CU_COMPLEXITY)
                                            {
                                                  if(IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id) && 
                                                    IPM_ProjectHelper.projectSectionMap.get(projectSection.Id)!=null)
                                                  {
                                                    sourceProjectDocSection = IPM_ProjectHelper.projectSectionMap.get(projectSection.Id);
                                                    referParentContent = true;
                                                  }  
                                                  break;
                                            }
                                        }
                                    }
                                }
                                break;                    
                            }
                        }            
                    }
                }
                
                // Get the Project Document Section Content and start the copy over logic.
                if(sourceProjectDocSection!=null && IPM_ProjectHelper.DBprojectSectionSpecificContentMap.containsKey(sourceProjectDocSection.Id) && 
                    IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id)!=null )
                {
                    List<IPM_Project_Document_Section_Content__c> targetSectionContentList = new List<IPM_Project_Document_Section_Content__c>();
                    for(IPM_Project_Document_Section_Content__c sectionContent : IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id))
                    {
                        if(sectionContent.IPM_Content_Type__c == IPM_ConstantUtils.CUCOMPLEXITY_CONTENT_TYPE )
                        {
                            // If Refer from Parent is true, it means we need to only get records which are applicable for that child. In case it is false, it is a phase change.
                            IPM_Project_Document_Section_Content__c newSectionContent = new IPM_Project_Document_Section_Content__c();
                            newSectionContent.IPM_Project_Document_Section__c = targetProjectDocumentSection.Id;
                            newSectionContent.IPM_Decreased_By__c = sectionContent.IPM_Decreased_By__c;
                            newSectionContent.IPM_Increased_By__c = sectionContent.IPM_Increased_By__c;
                            newSectionContent.IPM_Project_Effect__c = sectionContent.IPM_Project_Effect__c;
                            newSectionContent.IPM_Content_Type__c = IPM_ConstantUtils.CUCOMPLEXITY_CONTENT_TYPE ;
                            newSectionContent.IPM_Gate_Type__c=projectcurrentGate;
                            insertedSectionContent.add(newSectionContent);   
                        }    
                    }
                }
            }
        }
        
        if(insertedSectionContent!=null && !insertedSectionContent.isEmpty()){
            insert insertedSectionContent;
        }           
    }
    
     /**************************************************************
    * @description: Used for Assumptions Sections on Project Creation and Change.
    * @param1 projectDocToSectionMap : newly Created project Document To Section Map
    * @param2 projectToDocumentMap : project to Project Document Map 
    * @param3 projectMap : Trigger.New projects Map
    * NPATHComplexity: This function is used for creating/ copying Assumption Sections across Contract and Market Ready Gates.
                       The Section Content is created ate Contract level then as the gate is approved the corresponding values are 
                       copied over to the Market Ready Gate 
    *                  
    */
     ///Carrying the Assumptions Section
    public static void manageAssumptions(Map<Id,IPM_Project__c> projectMap,List<IPM_Project_Document__c> projectDocumentList,List<IPM_Project_Document_Section__c> projectSectionList)
    {
        List<IPM_Project_Document_Section_Content__c> insertedSectionContent = new List<IPM_Project_Document_Section_Content__c>(); 
        
        for(IPM_Project__c project : projectMap.values())
        {
            // Get detailedProject Object
            if(projectMap.containsKey(project.Id)!=null && projectMap.get(project.Id)!=null)
            { 
                IPM_Project__c currentProject = projectMap.get(project.Id);
                IPM_Project__c parentProject = null;
                Boolean referParentContent = false;
                if(project.IPM_Parent_Project__c !=null)
                {
                    if(IPM_ProjectHelper.projectMasterMap.containsKey(project.IPM_Parent_Project__c) && IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c)!=null)
                    {
                        parentProject = IPM_ProjectHelper.projectMasterMap.get(project.IPM_Parent_Project__c);     
                    }        
                }
                    
                IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(currentProject);
                IPM_Project_Type__c previousProjectType = null;
                
                if(associatedProjectType!=null)
                {
                    previousProjectType = IPM_Utils.getPreviousPhase(associatedProjectType,true);   
                }
                
                String projectcurrentGate = null; 
                IPM_Project_Document__c targetProjectDocument = null;
                IPM_Project_Document_Section__c targetProjectDocumentSection = null;
                
                String sourceProjectGate = null;
                IPM_Project_Document__c sourceProjectDocument = null;
                IPM_Project_Document_Section__c sourceProjectDocSection = null;
                    
                
                if(associatedProjectType!=null)
                {
                    projectcurrentGate = associatedProjectType.IPM_Gate_Document__c;
                }
                
                if(previousProjectType!=null)
                {
                   sourceProjectGate = previousProjectType.IPM_Gate_Document__c;
                }
                
                if(projectcurrentGate!=null && projectcurrentGate==IPM_ConstantUtils.MARKET_READY_GATE)
                {
                    // Get the Target Project document and Corresponding Project Section to which Concepts needs to be copied Over.
                    for(IPM_Project_Document__c projectDoc : projectDocumentList)
                    {
                        if(projectDoc.IPM_GateDocuments__c == projectcurrentGate && projectDoc.IPM_Project__c == project.Id)
                        {
                            targetProjectDocument =  projectDoc;
                            for(IPM_Project_Document_Section__c projectSection : projectSectionList)
                            {
                                if(projectSection.IPM_Project_Document__c == targetProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.ASSUMPTIONS)
                                {
                                      targetProjectDocumentSection = projectSection; 
                                      break;
                                }
                            }
                            break;               
                        }           
                    }
                    
                    if(IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(currentProject.Id) && 
                        IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id)!=null)
                    {
                        // Get the source document Section content and validate based on that.
                        for(IPM_Project_Document__c tempProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id))
                        {
                            // If Gate Document Type matches, it means there is already a Gate Document with different Complexity.
                            if(tempProjectDocument.IPM_GateDocuments__c == sourceProjectGate) 
                            {
                                if(IPM_ProjectHelper.projectDocumentMap.containsKey(tempProjectDocument.Id) && 
                                    IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id)!=null)
                                {
                                    sourceProjectDocument = IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id);
                                    // Get the Sections Now.
                                    if(sourceProjectDocument !=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                        IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null )
                                    {
                                        for(IPM_Project_Document_Section__c projectSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                        {
                                            if(projectSection.IPM_Project_Document__c == sourceProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.ASSUMPTIONS)
                                            {
                                                  if(IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id) && IPM_ProjectHelper.projectSectionMap.get(projectSection.Id)!=null)
                                                  {
                                                    sourceProjectDocSection = IPM_ProjectHelper.projectSectionMap.get(projectSection.Id);
                                                  }  
                                                  break;
                                            }
                                        }
                                    }
                                }
                                break;                    
                            }
                        }
                    }            
                    
                     // Check if there is a parent.If yes use that as a reference.
                    if( (sourceProjectDocument ==null || sourceProjectDocument == null) && (parentProject!=null && 
                        IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(parentProject.Id)
                        && IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id)!=null ) )
                    {
                        for(IPM_Project_Document__c tempProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id))
                        {
                            // If Gate Document Type matches, it means there is already a Gate Document with different Complexity.
                            if(tempProjectDocument.IPM_GateDocuments__c == sourceProjectGate) 
                            {
                                if(IPM_ProjectHelper.projectDocumentMap.containsKey(tempProjectDocument.Id) && 
                                    IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id)!=null)
                                {
                                    sourceProjectDocument = IPM_ProjectHelper.projectDocumentMap.get(tempProjectDocument.Id);
                                    // Get the Sections Now.
                                    if(sourceProjectDocument !=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(sourceProjectDocument.Id) && 
                                        IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id)!=null )
                                    {
                                        for(IPM_Project_Document_Section__c projectSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(sourceProjectDocument.Id))
                                        {
                                            if(projectSection.IPM_Project_Document__c == sourceProjectDocument.Id && projectSection.IPM_Master_Section_External_Id__c ==  IPM_ConstantUtils.ASSUMPTIONS)
                                            {
                                                  if(IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id) && 
                                                    IPM_ProjectHelper.projectSectionMap.get(projectSection.Id)!=null)
                                                  {
                                                    sourceProjectDocSection = IPM_ProjectHelper.projectSectionMap.get(projectSection.Id);
                                                    referParentContent = true;
                                                  }  
                                                  break;
                                            }
                                        }
                                    }
                                }
                                break;                    
                            }
                        }            
                    }
                }
                
                // Get the Project Document Section Content and start the copy over logic.
                if(sourceProjectDocSection!=null && IPM_ProjectHelper.DBprojectSectionSpecificContentMap.containsKey(sourceProjectDocSection.Id) && 
                    IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id)!=null )
                {
                    List<IPM_Project_Document_Section_Content__c> targetSectionContentList = new List<IPM_Project_Document_Section_Content__c>();
                    for(IPM_Project_Document_Section_Content__c sectionContent : IPM_ProjectHelper.DBprojectSectionSpecificContentMap.get(sourceProjectDocSection.Id))
                    {
                        if(sectionContent.IPM_Content_Type__c == IPM_ConstantUtils.Assumptions )
                        {
                            // If Refer from Parent is true, it means we need to only get records which are applicable for that child. In case it is false, it is a phase change.
                            IPM_Project_Document_Section_Content__c newSectionContent = new IPM_Project_Document_Section_Content__c();
                            newSectionContent.IPM_Project_Document_Section__c = targetProjectDocumentSection.Id;
                            newSectionContent.IPM_Content_Type__c = IPM_ConstantUtils.Assumptions ;
                            newSectionContent.IPM_Assumption_Market_Size__c=sectionContent.IPM_Assumption_Market_Size__c;
                            newSectionContent.IPM_Assumption_A_P__c=sectionContent.IPM_Assumption_A_P__c;
                            newSectionContent.IPM_Assumption_CAPEX__c=sectionContent.IPM_Assumption_CAPEX__c;
                            newSectionContent.IPM_Assumption_Countries__c=sectionContent.IPM_Assumption_Countries__c;
                            newSectionContent.IPM_Assumption_Yr_1_Trade_Promotion__c=sectionContent.IPM_Assumption_Yr_1_Trade_Promotion__c;
                            newSectionContent.IPM_Assumption_GM__c=sectionContent.IPM_Assumption_GM__c;   
                            newSectionContent.IPM_Assumption_Volume__c=sectionContent.IPM_Assumption_Volume__c;
                            newSectionContent.IPM_Assumption_Pricing__c=sectionContent.IPM_Assumption_Pricing__c;
                            newSectionContent.IPM_Assumption_Restages__c=sectionContent.IPM_Assumption_Restages__c;
                            newSectionContent.IPM_Assumption_T_O_Cannibalization__c=sectionContent.IPM_Assumption_T_O_Cannibalization__c;
                            newSectionContent.IPM_Assumption_Volume_Yr_2__c=sectionContent.IPM_Assumption_Volume_Yr_2__c;
                            newSectionContent.IPM_Gate_Type__c=projectcurrentGate;
                            insertedSectionContent.add(newSectionContent);   
                        }    
                    }
                }
            }
        }
        
        if(insertedSectionContent!=null && !insertedSectionContent.isEmpty()){
            insert insertedSectionContent;
        }           
    }
    
    /************************************************************************************************
    * @description: Used for Creating Financial Action Standard on Global Project Creation for Charter Gate.
    * @param1 projectDocToSectionMap : newly Created project Document To Section Map
    * @param2 projectToDocumentMap : project to Project Document Map 
    * @param3 projectMap : Trigger.New projects Map
    * NPATHComplexity: This function is used for creating Action Standards for Charter gate documnet which is a complex functionality.
                       The table for the section Business Case vs Action Standard Section for Charter Document
                       based on the current Financials of the Project. The Action Standad Field Values are Editable at Charter Only, the user has the ability to save these values. 
                       Using this function the record for Financial Action Standard is created at IPM_Financial_Action_Standards__c object.
                   
    */
    public static void createGlobalFinancialActionStandard(Map<Id,List<IPM_Project_Document_Section__c>> projectDocToSectionMap,Map<Id,Map<String,IPM_Project_Document__c>> projectToDocumentMap, Map<Id,IPM_Project__c> projectMap)
    {
        List<IPM_Financial_Action_Standards__c> insertGlobalFinancialActionStandard = new List<IPM_Financial_Action_Standards__c>();//list of global financial action standard
        
        for(IPM_Project__c project : projectMap.values())
        {
            if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
            {
                IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(project);
     
                if(associatedProjectType!=null)
                {
                    String projectGate = associatedProjectType.IPM_Gate_Document__c;
                                  
                    if(projectToDocumentMap.containsKey(project.Id) && projectToDocumentMap.get(project.Id)!=null)
                    {
                        Map<String,IPM_Project_Document__c> gateToDocMap = projectToDocumentMap.get(project.Id);
                        if(gateToDocMap.containsKey(projectGate) && gateToDocMap.get(projectGate)!=null)
                        {
                            IPM_Project_Document__c associatedProjectDocument = gateToDocMap.get(projectGate);
                            if(projectDocToSectionMap.containsKey(associatedProjectDocument.Id) && projectDocToSectionMap.get(associatedProjectDocument.Id)!=null && associatedProjectDocument.IPM_GateDocuments__c==IPM_ConstantUtils.CHARTER_GATE)
                            {
                               List<IPM_Project_Document_Section__c> associatedSectionsList = projectDocToSectionMap.get(associatedProjectDocument.Id);
                               for(IPM_Project_Document_Section__c projectSection : associatedSectionsList)
                               {
                                   if(projectSection.IPM_Master_Section_External_Id__c==IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD)
                                   {
                                        if(!IPM_ProjectHelper.projectSectionMap.containsKey(projectSection.Id))
                                        {
                                           IPM_Financial_Action_Standards__c finActionStandard = new IPM_Financial_Action_Standards__c();
                                           finActionStandard.IPM_Project_Document_Section__c = projectSection.Id;
                                           finActionStandard.IPM_Financial_Action_Standard_Name__c = IPM_ConstantUtils.IPM_GLOBAL_FINANCIAL_ACTION_STANDARDS;
                                           finActionStandard.IPM_GM_Action_Standards_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                           finActionStandard.IPM_gTO_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                           finActionStandard.IPM_Innov_Value_Share_Action_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                           finActionStandard.IPM_Inc_Value_Share_Action_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                           finActionStandard.IPM_IRR_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                           finActionStandard.IPM_iTo_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                           finActionStandard.IPM_NPV_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                           finActionStandard.IPM_Payback_Action_Standard_Charter__c = IPM_ConstantUtils.IPM_FINANCIAL_ACTION_STANDARD_VALUE;
                                           finActionStandard.IPM_Project_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
                                           finActionStandard.IPM_Project__c = project.Id;
                                           insertGlobalFinancialActionStandard.add(finActionStandard);
                                        }
                                   }
                               }
                            }
                        }
                    }
                }
            }
        }
        
        if(!insertGlobalFinancialActionStandard.isEmpty())
        {
            insert insertGlobalFinancialActionStandard; 
        }
    }
    
    /****************************************************************************************************************
    * @description: Used for copying regional action standards to contract gate document financial action standards.
    * @param1 proDocSecConList : newly Created project Document Section Content List
    *****************************************************************************************************************/
    @InvocableMethod
    public static void copyRegionalFinancialActionStandards(List<IPM_Project_Document_Section_Content__c> proDocSecConList){
        Set<Id> conIdSet=new Set<Id>();
        for(IPM_Project_Document_Section_Content__c pdsc:proDocSecConList){
            conIdSet.add(pdsc.Id);
        }
        Set<Id> parentProjectIdSet=new Set<Id>();
        List<IPM_Project_Document_Section_Content__c> projDocSecConList=new List<IPM_Project_Document_Section_Content__c>();
        List<IPM_Project_Document_Section_Content__c> updateProjDocSecConList=new List<IPM_Project_Document_Section_Content__c>();
        for(IPM_Project_Document_Section_Content__c sectionContent:[SELECT Id,IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c,
                                                                           IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.Market_Cluster__c,
                                                                           IPM_Section_Name__c,IPM_GM_Action_Standards_Charter__c,IPM_Inc_Value_Share_Action_Charter__c,IPM_Innov_Value_Share_Action_Charter__c,IPM_IRR_Action_Standard_Charter__c,
                                                                           IPM_gTO_Action_Standard_Charter__c,IPM_iTo_Action_Standard_Charter__c,IPM_NPV_Action_Standard_Charter__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Project_Rollout__c,
                                                                           IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Project_Rollout__r.Name FROM IPM_Project_Document_Section_Content__c
                                                                    WHERE Id In:conIdSet]){
            projDocSecConList.add(sectionContent);
            parentProjectIdSet.add(sectionContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c);
        }
        for(IPM_Financial_Action_Standards__c finAction:[SELECT Id,IPM_Financial_Action_Standard_Name__c,IPM_GM_Action_Standards_Charter__c,IPM_gTO_Action_Standard_Charter__c,IPM_Inc_Value_Share_Action_Charter__c,IPM_Innov_Value_Share_Action_Charter__c,
                                                                IPM_IRR_Action_Standard_Charter__c,IPM_iTo_Action_Standard_Charter__c,IPM_NPV_Action_Standard_Charter__c,IPM_Payback_Action_Standard_Charter__c,IPM_Project_Span__c,IPM_Project__c,IPM_Financial_Year_Y1_Gross__c,
                                                                IPM_Financial_Year_Y1_Gross__r.Regional_External_Id__c FROM IPM_Financial_Action_Standards__c
                                                         WHERE IPM_Project_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_REGIONAL and IPM_Project__c In:parentProjectIdSet]){
            for(IPM_Project_Document_Section_Content__c content:projDocSecConList){
                if(finAction.IPM_Financial_Year_Y1_Gross__r.Regional_External_Id__c==content.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Project_Rollout__r.Name){
                    content.IPM_Section_Name__c = finAction.IPM_Financial_Action_Standard_Name__c;
                    content.IPM_GM_Action_Standards_Charter__c = finAction.IPM_GM_Action_Standards_Charter__c;
                    content.IPM_gTO_Action_Standard_Charter__c = finAction.IPM_gTO_Action_Standard_Charter__c;
                    content.IPM_Innov_Value_Share_Action_Charter__c = finAction.IPM_Innov_Value_Share_Action_Charter__c;
                    content.IPM_Inc_Value_Share_Action_Charter__c = finAction.IPM_Inc_Value_Share_Action_Charter__c;
                    content.IPM_IRR_Action_Standard_Charter__c = finAction.IPM_IRR_Action_Standard_Charter__c;
                    content.IPM_iTo_Action_Standard_Charter__c = finAction.IPM_iTo_Action_Standard_Charter__c;
                    content.IPM_NPV_Action_Standard_Charter__c = finAction.IPM_NPV_Action_Standard_Charter__c;
                    content.IPM_Payback_Action_Standard_Charter__c = finAction.IPM_Payback_Action_Standard_Charter__c;
                    updateProjDocSecConList.add(content);
                }
            }   
        }
        if(updateProjDocSecConList!=null && !updateProjDocSecConList.isEmpty()){
            update updateProjDocSecConList;
        }
    }  
}