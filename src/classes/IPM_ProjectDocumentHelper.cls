/****************************************************************************************************************************
@Author Cognizant
@name IPM_ProjectDocumentHelper
@CreateDate 20/08/2015
@Description Helper Class for Project document And Project Document Section Business Logic
@Version 1.0
@reference Project Document/Document Section 
*/

public with sharing class IPM_ProjectDocumentHelper   
{
    private transient static final String BOSSCARD = 'Bosscard'; 
    private transient static final String SECTION_SEQUENCE ='7.2.'; 
    public static final Map<String,String> DOC_COMMENT_FIELDMAPPING = new Map<String,String>{
        IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED => 'IPM_Approved_Comments__c',
        IPM_ConstantUtils.DOCUMENT_STATUS_POSTPONED  => 'IPM_Postponed_Comments__c',
        IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED => 'IPM_Stopped_Comments__c'
    };
    
    public static final Map<String,String> DOC_DATE_FIELDMAPPING = new Map<String,String>
    {
        IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED => 'IPM_Approval_Date__c',
        IPM_ConstantUtils.DOCUMENT_STATUS_POSTPONED => 'IPM_Postponement_Date__c',
        IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED => 'IPM_Stopped_Date__c',
        IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED => 'IPM_Proposed_Date__c'
    };
    
    
    /**************************************************************
    * @description: Used for Creating project documents on Project Creation and Phase Change.
    * @param1 projectMap : Trigger.New projects Map
    */
    
    public static List<IPM_Project_Document__c> manageProjectDocuments(Map<Id,IPM_Project__c> projectMap)
    {
        List<IPM_Project_Document__c> preparedprojectDocumentList = new List<IPM_Project_Document__c>(); 
        for(IPM_Project__c project : ProjectMap.values())
        {
            // Get incoming projects complexity
            String projectComplexity = project.IPM_Complexity__c;
            String projectType = project.IPM_SourceProjectType__c; 
            String projectCategory = project.IPM_Category_Text__c;
            
            // Get Project Type Setting From Custom Settings 
            IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(project);
            
            if(associatedProjectType!=null) 
            {
                String projectGate = associatedProjectType.IPM_Gate_Document__c;
                
                if(projectGate!=null && !String.isEmpty(projectGate))
                {
                    projectGate = projectGate.trim();
                    for(IPM_Project_Template__c complexityTemplate: IPM_ProjectHelper.complexityTemplateMap.values())
                    {
                        // If project Complexity matches project Template Complexity. ****We need to check Category Also Here ***
                        if(!String.isblank(projectComplexity) && !String.isBlank(complexityTemplate.IPM_Template_Complexity__c) && projectComplexity == complexityTemplate.IPM_Template_Complexity__c && 
                           !String.isBlank(projectCategory) && !String.isBlank(complexityTemplate.IPM_Category__c) && complexityTemplate.IPM_Category__c.contains(projectCategory) &&
                           !String.isBlank(projectType) && !String.isBlank(complexityTemplate.IPM_Project_Type__c) && complexityTemplate.IPM_Project_Type__c == projectType )
                        {
                            if(IPM_ProjectHelper.complexitySpecificDocumentTemplates.containsKey(complexityTemplate.Id) && IPM_ProjectHelper.complexitySpecificDocumentTemplates.get(complexityTemplate.Id)!=null)
                            {
                                for(IPM_Document_Template__c docTemplate : IPM_ProjectHelper.complexitySpecificDocumentTemplates.get(complexityTemplate.Id))
                                {
                                    // If project Gate Matches Document Type Gate, We need to build Project Documents for that Gate. 
                                    if( projectGate == docTemplate.IPM_Document_Type__c)
                                    {
                                        // Prepare Project Document
                                        IPM_Project_Document__c projDoc = new IPM_Project_Document__c(); 
                                        projDoc.IPM_Project__c = project.Id;
                                        projDoc.IPM_Project_Template__c = docTemplate.IPM_Project_Template__c;
                                        projDoc.IPM_Document_Template__c = docTemplate.ID; 
                                        projDoc.IPM_GateDocuments__c = docTemplate.IPM_Document_Type__c; 
                                        projDoc.IPM_Document_Complexity__c = project.IPM_Complexity__c;                                         
                                        projDoc.IPM_Contract_GateKeeper_Model__c = associatedProjectType.IPM_GateKeeping_Model__c;
                                        projDoc.IPM_Document_Order__c=docTemplate.IPM_Document_Order__c; 
                                        projDoc.IPM_Project_External_Id__c=project.Project_External_ID__c;
                                        /* if there is already a document attached to Project for incoming Gate, update project document */    
                                        if(IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(project.Id) && IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(project.Id)!=null)
                                        {
                                           List<IPM_Project_Document__c> existingProjectDocuments  = IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(project.Id);
                                                
                                            for(IPM_Project_Document__c tempProjectDocument : existingProjectDocuments)
                                            {
                                                // If Gate Document Type matches, it means there is already a Gate Document with different Complexity.
                                                // Map Id to existing Document to this document.
                                                if(tempProjectDocument.IPM_GateDocuments__c == projectGate) 
                                                {
                                                    projDoc.Id = tempProjectDocument.Id;
                                                    projDoc.IPM_Document_Status__c = tempProjectDocument.IPM_Document_Status__c;                    
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        if(projDoc.IPM_Document_Status__c == null || String.isBlank(projDoc.IPM_Document_Status__c))
                                        {
                                            projDoc.IPM_Document_Status__c = IPM_ConstantUtils.STATUS_NOT_STARTED;
                                        }
                                        preparedprojectDocumentList.add(projDoc);
                                        break;
                                    }
                                }
                            }
                            break;     
                        }
                    }
                }
            }  
        }
        return preparedprojectDocumentList;
    }
    
    /**************************************************************
    * @description: Used for Updating Project Document Status as Approved.
    * @param1 incomingProjectMap : Trigger.New projects Map
    */
    public static void updateProjectDocumentStatus(Map<Id,IPM_Project__c> incomingProjectMap)
    {
        
        List<IPM_Project_Document__c> updateProjectDocumentList = new List<IPM_Project_Document__c>(); 
        for(IPM_Project__c project : incomingProjectMap.values())
        {
            IPM_Project_Type__c currentProjectType = IPM_Utils.retrieveProjectType(project);
            IPM_Project_Type__c previousProjectType = IPM_Utils.getPreviousPhase(currentProjectType,true);
            
            if(currentProjectType !=null && project.IPM_Current_Document_Status__c !=null && !String.isBlank(project.IPM_Current_Document_Status__c))
            {             
                String projectGate = null;
                
                if(project.IPM_Current_Document_Status__c ==  IPM_ConstantUtils.STATUS_APPROVED ) 
                {
                   if(previousProjectType!=null)
                   { 
                        projectGate =  previousProjectType.IPM_Gate_Document__c;
                   }
                   
                   if(String.isBlank(projectGate))
                   {
                       projectGate = currentProjectType.IPM_Gate_Document__c;
                   }
                }
                else
                {
                    projectGate =  currentProjectType.IPM_Gate_Document__c;
                }
                       
                if(IPM_ProjectHelper.projectMasterMap.containsKey(project.Id) && IPM_ProjectHelper.projectMasterMap.get(project.Id)!=null )
                {
                    IPM_Project__c existingProject = IPM_ProjectHelper.projectMasterMap.get(project.Id);
                    if(IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(existingProject.Id) && 
                        IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(existingProject.Id)!=null )
                    { 
                        for(IPM_Project_Document__c projectDoc : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(existingProject.Id))
                        {
                            String incomingGateType = projectDoc.IPM_GateDocuments__c;
                            
                            if(projectGate == incomingGateType)
                            {
                               projectDoc.IPM_Document_Status__c = project.IPM_Current_Document_Status__c;
  
                               if(project.IPM_Document_Update_Comments__c !=null && DOC_COMMENT_FIELDMAPPING.containsKey(projectDoc.IPM_Document_Status__c))
                               {
                                    String commentFieldAPIName = DOC_COMMENT_FIELDMAPPING.get(projectDoc.IPM_Document_Status__c);
                                    projectDoc.put(commentFieldAPIName,project.IPM_Document_Update_Comments__c);    
                               }
                               
                               if(project.IPM_Document_Update_Date__c !=null && DOC_DATE_FIELDMAPPING.containsKey(projectDoc.IPM_Document_Status__c))
                               {
                                    String dateFieldAPIName = DOC_DATE_FIELDMAPPING.get(projectDoc.IPM_Document_Status__c);
                                    projectDoc.put(dateFieldAPIName,project.IPM_Document_Update_Date__c);   
                               }
                               projectDoc.IPM_Updated_User_By__c=UserInfo.getUserId();// Added to resolve data Migration Approvers Issue
                               updateProjectDocumentList.add(projectDoc);
                               break;
                            }
                        }
                    }    
                }
            }
        }
        
        if(updateProjectDocumentList !=null && !updateProjectDocumentList.isEmpty())
        {
            update updateProjectDocumentList; // Not including try , catch as when the transaction is failed roll back is handled at other class
        }    
    }
    
    /**************************************************************
    * @description: Used for Creating project documents sections on Project Creation and Phase Change.
    * @param1 projectToDocumentMap : project to Project Document Map 
    * @param2 incomingProjects : Trigger.New projects Map
    */
    
    public static List<IPM_Project_Document_Section__c> manageProjectDocumentSections(Map<Id,Map<String,IPM_Project_Document__c>> projectToDocumentMap,Map<Id,IPM_Project__c> incomingProjects)
    {
        List<IPM_Project_Document_Section__c> projectDocumentSectionList = new List<IPM_Project_Document_Section__c>();
        
        Set<Id> matchedDocumentSectionsSet = new Set<Id>();
        
        for(IPM_Project__c project : incomingProjects.values())
        {
            Id associatedProjectID = project.Id;
            
            IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(project);
            
            String projectCurrentPhase = associatedProjectType.IPM_Phase__c;
            
            String associatedGate = associatedProjectType.IPM_Gate_Document__c;
            
            if(associatedGate!=null && !String.isblank(associatedGate))
            {
                if(projectToDocumentMap.containsKey(associatedProjectID) && projectToDocumentMap.get(associatedProjectID)!=null)
                {
                    // check if that Gate Exists in the Map
                    Map<String,IPM_Project_Document__c> gateToProjectDocumentMap = projectToDocumentMap.get(associatedProjectID);
                    if(gateToProjectDocumentMap.containsKey(associatedGate) && gateToProjectDocumentMap.get(associatedGate)!=null)
                    {
                        IPM_Project_Document__c projectDocument = gateToProjectDocumentMap.get(associatedGate);
                        Id associatedTemplateId = projectDocument.IPM_Document_Template__c;
                        
                        if(IPM_ProjectHelper.projectMasterMap.containsKey(associatedProjectID) && IPM_ProjectHelper.projectMasterMap.get(associatedProjectID)!=null )
                        {
                            IPM_Project__c currentProject = IPM_ProjectHelper.projectMasterMap.get(associatedProjectID);
                            IPM_Project__c parentProject = null;
                        
                            //Check if there is a parent Project
                            if(currentProject.IPM_Parent_Project__c != null && IPM_ProjectHelper.projectMasterMap.containsKey(currentProject.IPM_Parent_Project__c) && 
                              IPM_ProjectHelper.projectMasterMap.get(currentProject.IPM_Parent_Project__c) !=null)
                            {
                               parentProject = IPM_ProjectHelper.projectMasterMap.get(currentProject.IPM_Parent_Project__c); 
                            }
                        
                            //Check for existing project Document. If it exists, update the sections from there. 
                            IPM_Project_Document__c existingProjectDocument = null;
                            if(IPM_ProjectHelper.projectDocumentMap.containsKey(projectDocument.Id) && 
                                IPM_ProjectHelper.projectDocumentMap.get(projectDocument.Id) !=null) 
                            {
                               existingProjectDocument = IPM_ProjectHelper.projectDocumentMap.get(projectDocument.Id); 
                            }
                                
                            if(IPM_ProjectHelper.documentTemplateMap.containsKey(associatedTemplateId) && 
                                IPM_ProjectHelper.documentTemplateMap.get(associatedTemplateId)!=null )
                            {
                                IPM_Document_Template__c documentTemplate = IPM_ProjectHelper.documentTemplateMap.get(associatedTemplateId);
                                
                                // Get the list of sections from the selected document Template
                                if(IPM_ProjectHelper.documentTemplateSpecificSectionMap.containsKey(documentTemplate.Id) && 
                                    IPM_ProjectHelper.documentTemplateSpecificSectionMap.get(documentTemplate.Id)!=null )
                                {
                                    List<IPM_Section__c> associatedSectionList = IPM_ProjectHelper.documentTemplateSpecificSectionMap.get(documentTemplate.Id);
                                
                                    for(IPM_Section__c section : associatedSectionList)
                                    {
                                        IPM_Project_Document_Section__c projDocSect = new IPM_Project_Document_Section__c();
                                        // If there is an existing Product document Template associated,we assume sections are already associated with them.
                                        // In that case we need to update references to those project document section to point to proper master sec.
                                        if(existingProjectDocument!=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(existingProjectDocument.Id) 
                                        && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(existingProjectDocument.Id)  )
                                        {
                                            for(IPM_Project_Document_Section__c existingProjectDocSec : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(existingProjectDocument.Id) )
                                            {
                                                // If the sections are Same
                                                if(section.External_ID__c !=null && existingProjectDocSec.IPM_Master_Section_External_Id__c !=null && 
                                                    existingProjectDocSec.IPM_Master_Section_External_Id__c == section.External_ID__c && 
                                                    !matchedDocumentSectionsSet.contains(existingProjectDocSec.Id) && section.ProjectSpan__c.contains(project.IPMProject_Span__c) )
                                                {
                                                    matchedDocumentSectionsSet.add(existingProjectDocSec.Id);
                                                    projDocSect.Id = existingProjectDocSec.Id;
                                                    projDocSect.IPM_Gate_Document_Summary__c = existingProjectDocSec.IPM_Gate_Document_Summary__c;
                                                    projDocSect.IPM_PDP_Document_Summary__c = existingProjectDocSec.IPM_PDP_Document_Summary__c;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        projDocSect.IPM_Project_Document__c = projectDocument.Id;
                                        projDocSect.IPM_Section_Name__c = section.IPM_Section_Name__c;
                                        projDocSect.IPM_Master_Section_External_Id__c = section.External_ID__c; 
                                        projDocSect.IPM_Gate_Document__c = associatedGate;
                                        projDocSect.IPM_Section__c = section.Id;
                                        projDocSect.IPM_Section_Sequence_Number__c = section.IPM_Section_Sequence__c;
                                        projDocSect.IPM_FunctionalRole__c = section.IPM_FunctionalRole__c;
                                        projDocSect.IPM_Section_Help_Text_Long__c = section.IPM_Section_Help_Text__c;
                                        projDocSect.IPM_Negotiable__c = section.IPM_Negotiable__c;
                                        projDocSect.IPM_Section_Type__c = section.IPM_Section_Type__c;
                                        projDocSect.IPM_Has_Appendix__c=section.IPM_Has_Appendix__c;
                                        projDocSect.Is_IPM_Global_Consolidated__c=section.Is_IPM_Global_Consolidated__c;
                                        
                                        // Based on Complexity set the Default Section Flag.
                                        if(currentProject.IPM_Complexity__c == IPM_ConstantUtils.COMPLEXITY_FULL){
                                            projDocSect.IPM_Default_Section__c=true;
                                        }   
                                        else if(currentProject.IPM_Complexity__c == IPM_ConstantUtils.COMPLEXITY_LITE)
                                        {
                                            projDocSect.IPM_Default_Section__c= !section.IPM_Negotiable__c; 
                                        } 
                                        
                                        initiateCopyOverLogic(associatedGate,projDocSect,section.External_ID__c,currentProject,parentProject);
                                        
                                        String summary=projDocSect.IPM_Gate_Document_Summary__c; 
                                        if(String.isNotBlank(summary)){
                                            summary=summary.replaceAll(IPM_ConstantUtils.SPECIAL_CHARACTERS,'');
                                         }   
                                         if(associatedGate==IPM_ConstantUtils.CHARTER_GATE && String.isNotBlank(projDocSect.IPM_Gate_Document_Summary__c) && summary.length()>(Integer)section.IPM_Character_Limit__c){
                                            projDocSect.IPM_Gate_Document_Summary__c=summary.subString(0,(Integer)section.IPM_Character_Limit__c);
                                        }
                                        // Update the Status based on Whether Gate Summary information is filled or not.
                                        if(section.IPM_Section_Type__c !=IPM_ConstantUtils.SECTION_TYPE_HEADER && 
                                            section.IPM_Section_Type__c!=IPM_ConstantUtils.SECTION_TYPE_SUBHEADER)
                                        {
                                            if(String.isBlank(projDocSect.IPM_Gate_Document_Summary__c))
                                            {
                                                projDocSect.IPM_Section_Status__c=IPM_ConstantUtils.STATUS_NOT_STARTED;
                                            }
                                            else
                                            {
                                                projDocSect.IPM_Section_Status__c=IPM_ConstantUtils.SECTION_STATUS_FILLED;
                                            }
                                            
                                            if(String.isBlank(projDocSect.IPM_PDP_Document_Summary__c))
                                            {
                                                projDocSect.IPM_Functional_Input_Status__c=IPM_ConstantUtils.STATUS_NOT_STARTED;
                                            }
                                            else
                                            {
                                                projDocSect.IPM_Functional_Input_Status__c=IPM_ConstantUtils.SECTION_STATUS_FILLED;
                                            }
                                        }
                                        else
                                        {
                                            projDocSect.IPM_Section_Status__c = IPM_ConstantUtils.BLANK;
                                            projDocSect.IPM_Functional_Input_Status__c = IPM_ConstantUtils.BLANK;
                                        }
                                        
                                       if(!String.isBlank(section.ProjectSpan__c) && !String.isBlank(project.IPMProject_Span__c) && section.ProjectSpan__c.contains(project.IPMProject_Span__c)){
                                            projectDocumentSectionList.add(projDocSect);
                                       }
                                    }
                                }
                            }
                        }
                    }
                }
            }       
        }
        return projectDocumentSectionList;
    }
    
    /**************************************************************
    * @description: Used for copying over section Data from One Phase to another and in case of Bosscard.
    * @param1 gateType : Current Project Gate
    * @param2 incomingSection : Section which needs to be  updated
    * @param3 currentSectionExternalId : External Id for incoming Section
    * @param4 currentProject : Current Project in Context
    * @param5 parentProject : parent Project information
    */
    
    public static void initiateCopyOverLogic(String gateType,IPM_Project_Document_Section__c incomingSection, String currentSectionExternalId,IPM_Project__c currentProject,IPM_Project__c parentProject)
    {
        String targetValue = '';
        Id associatedBosscard = currentProject.IPM_Bosscard__c;
        SObject sourceObject = null;
        
        if(IPM_ProjectHelper.gateToSectionCopyMap.containsKey(gateType) && IPM_ProjectHelper.gateToSectionCopyMap.get(gateType) !=null && !IPM_ProjectHelper.gateToSectionCopyMap.get(gateType).isEmpty() )
        {
            Map<String,IPM_Section_Copy_Mapping__c> sectionCopyOverMap =  IPM_ProjectHelper.gateToSectionCopyMap.get(gateType);
            
            if(sectionCopyOverMap.containsKey(currentSectionExternalId) && sectionCopyOverMap.get(currentSectionExternalId)!=null )
            {
                List<String> sourceFieldAPIList = new List<String>();
                List<String> targetFieldAPIList = new List<String>();
                IPM_Section_Copy_Mapping__c targetMappingObj = sectionCopyOverMap.get(currentSectionExternalId);
                
                // Check which phase to Copy from
                String copyFromGate = targetMappingObj.Gate_To_Copy_From__c;
                
                // Source Field API Names
                String sourceFieldAPINames = targetMappingObj.IPM_SourceFieldAPIName__c;
                if(sourceFieldAPINames!=null && !String.isBlank(sourceFieldAPINames))
                {
                    sourceFieldAPIList = sourceFieldAPINames.split(IPM_ConstantUtils.COMMA_DELIMITER);
                }
                
                String targetFieldAPINames = targetMappingObj.IPM_TargetFieldAPIName__c;
                if(targetFieldAPINames!=null && !String.isBlank(targetFieldAPINames))
                {
                    targetFieldAPIList = targetFieldAPINames.split(IPM_ConstantUtils.COMMA_DELIMITER);
                
                }
                    
                IPM_Project_Document__c targetProjectDocument = null;
                
                if(copyFromGate!=null && !String.isBlank(copyFromGate) && !sourceFieldAPIList.isEmpty())
                {   
                    if(!copyFromGate.equals(BOSSCARD) )
                    {
                        if( IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(currentProject.Id) && 
                            IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id)!=null )
                        {
                            // First Validate whether current Project has that gate Document available.
                            for(IPM_Project_Document__c associatedProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(currentProject.Id))
                            {
                                if(associatedProjectDocument.IPM_GateDocuments__c == copyFromGate)
                                {
                                   targetProjectDocument =  associatedProjectDocument;
                                   break;     
                                }
                            }
                        }
                        
                        if(targetProjectDocument ==null && parentProject!=null && IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(parentProject.Id) 
                            && IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id)!=null)
                        {
                            // Iterate through the parent Project and validate whether parent project has that Gate document
                            for(IPM_Project_Document__c associatedParentProjectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(parentProject.Id))
                            {
                                if(associatedParentProjectDocument.IPM_GateDocuments__c == copyFromGate)
                                {
                                   targetProjectDocument =  associatedParentProjectDocument;
                                   break;     
                                }
                            }
                            
                        }
                        
                        if(targetProjectDocument!=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(targetProjectDocument.Id) && 
                            IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(targetProjectDocument.Id)!=null )
                        {
                            for(IPM_Project_Document_Section__c targetProDocSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(targetProjectDocument.Id))
                            {
                                if(targetProDocSection.IPM_Master_Section_External_Id__c == currentSectionExternalId)
                                {
                                    sourceObject = targetProDocSection;    
                                    break;
                                }
                            }
                        }
                    }
                    else
                    {
                        if( IPM_ProjectHelper.bossCardMap.containsKey(associatedBosscard) && IPM_ProjectHelper.bossCardMap.get(associatedBosscard)!=null )
                        {
                            sourceObject = IPM_ProjectHelper.bossCardMap.get(associatedBosscard);
                        }
                    } 
                } 
                if(sourceObject!=null)
                {
                    for(Integer counter =0;counter<sourceFieldAPIList.size();counter++)
                    {
                        // Get the source Api Name from which to copy
                        String sourceField = sourceFieldAPIList.get(counter);
                        String targetField = targetFieldAPIList.get(counter);
                        if(String.isNotBlank(sourceField) && String.isNotBlank(targetField) && (incomingSection.get(targetField) == null || incomingSection.get(targetField) == false))
                        {
                            if(currentSectionExternalId != IPM_ConstantUtils.FEEDBACK_FROM_LAST_GATE)
                            {
                                incomingSection.put(targetField,sourceObject.get(sourceField));        
                            }    
                            else 
                            {   if(targetProjectDocument !=null)
                                {
                                    incomingSection.put(targetField,targetProjectDocument.IPM_Approved_Comments__c);
                                }  
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Once Local projects are created, we need to create Project Sections at Charter level 
    public static void manageCountryFeedbackOnParentProjects(Map<Id,IPM_Project__c> incomingProjects)
    {
        List<IPM_Project_Document_Section__c> upsertParentSections = new List<IPM_Project_Document_Section__c>();
        Set<Id> globalProjectIdsSet = new Set<Id>();
        String DYNAMIC_SECTION_SEQUENCE=Section_Sequence; //Country Feedback Section Sequence Number
        
        Map<Id,List<Id>> parentToChildProjects = new Map<Id,List<Id>>();
        
        for(IPM_Project__c project : incomingProjects.values())
        {
            if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && project.IPM_Phase__c == IPM_ConstantUtils.MARKET_READY_GATE)
            {
                Id regionalProjectID = project.IPM_Parent_Project__c;
                IPM_Project__c regionalProject = null;
                IPM_Project__c globalProject = null;
                if(IPM_ProjectHelper.projectMasterMap.containsKey(regionalProjectID) && IPM_ProjectHelper.projectMasterMap.get(regionalProjectID)!=null )
                {
                   regionalProject =  IPM_ProjectHelper.projectMasterMap.get(regionalProjectID);
                   List<Id> childProjectList = new List<Id>();
                   if(parentToChildProjects.containsKey(regionalProjectID))
                   {
                       childProjectList =  parentToChildProjects.get(regionalProjectID);        
                   }
                   childProjectList.add(project.Id);
                   parentToChildProjects.put(regionalProjectID,childProjectList);
                       
                       
                   if(regionalProject!=null)
                   {
                       Id globalProjectID = regionalProject.IPM_Parent_Project__c;
                       if(IPM_ProjectHelper.projectMasterMap.containsKey(globalProjectId) && IPM_ProjectHelper.projectMasterMap.get(globalProjectId) !=null )
                       {
                           globalProject = IPM_ProjectHelper.projectMasterMap.get(globalProjectId);
                           List<Id> childProjectListTemp = new List<Id>();
                           if(parentToChildProjects.containsKey(globalProjectID))
                           {
                               childProjectListTemp =  parentToChildProjects.get(globalProjectID);        
                           }
                           childProjectListTemp.add(project.Id);
                           parentToChildProjects.put(globalProjectID,childProjectListTemp);
                       }
                   }
                }
            }
        }   

        for(Id globalProjectId : parentToChildProjects.KeySet())
        {
            IPM_Project__c globalProject = null;
            IPM_Project_Document__c globalProjectDocument = null;
            Integer lastGlobalCountrySection = 1;
            if(IPM_ProjectHelper.projectMasterMap.containsKey(globalProjectId) && IPM_ProjectHelper.projectMasterMap.get(globalProjectId) !=null )
            {
                globalProject = IPM_ProjectHelper.projectMasterMap.get(globalProjectId);
            }
            
            if(globalProject!=null && IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(globalProject.Id) && 
            IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(globalProject.Id)!=null)
            {
                for(IPM_Project_Document__c projectDocument :  IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(globalProject.Id))
                {
                    if(projectDocument.IPM_GateDocuments__c == IPM_ConstantUtils.CONTRACT_GATE)
                    {
                        // Check what sequence Number should be set
                        globalProjectDocument = projectDocument;
                        if(IPM_ProjectHelper.projectDocumentMap.containsKey(globalProjectDocument.Id) && 
                            IPM_ProjectHelper.projectDocumentMap.get(globalProjectDocument.Id) !=null)
                        {
                            IPM_Project_Document__c existingDocument = IPM_ProjectHelper.projectDocumentMap.get(globalProjectDocument.Id);
                            
                            if(IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(existingDocument.Id) && 
                                IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(existingDocument.Id)!=null)
                            {
                                for(IPM_Project_Document_Section__c docSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(existingDocument.Id))
                                {
                                    if(docSection.IPM_Section_Sequence_Number__c.startsWith(DYNAMIC_SECTION_SEQUENCE))
                                    {
                                        // Find the last Dot and prepare largest index based on that.  
                                        Integer startIndex = docSection.IPM_Section_Sequence_Number__c.lastIndexOf(IPM_ConstantUtils.DOT_DELIMITER);
                                        Integer endIndex = docSection.IPM_Section_Sequence_Number__c.length();
                                        String sequenceNumber = docSection.IPM_Section_Sequence_Number__c.substring(startIndex+1,endIndex);
                                        Integer sequenceInteger = Integer.valueOf(sequenceNumber);  
                                        
                                        if(sequenceInteger > lastGlobalCountrySection)
                                        {
                                            lastGlobalCountrySection = sequenceInteger; 
                                        }    
                                    }
                                }
                            }
                        }
                        break;
                    }
                } 
                
                // Get local Records Associated with it.
                if(parentToChildProjects.containsKey(globalProjectId) && parentToChildProjects.get(globalProjectId)!=null)
                {
                   List<Id> localProjectIds = parentToChildProjects.get(globalProjectId);
                   for(Id localProjectID : localProjectIds)
                   {
                       IPM_Project__c localProject = null;
                       if(IPM_ProjectHelper.projectMasterMap.containsKey(localProjectID) && IPM_ProjectHelper.projectMasterMap.get(localProjectID) !=null )
                       {
                           localProject = IPM_ProjectHelper.projectMasterMap.get(localProjectID);
                       }
                       if(localProject!=null)
                       {
                            IPM_Project_Document_Section__c projDocSect = new IPM_Project_Document_Section__c();
                            projDocSect.IPM_Project_Document__c = globalProjectDocument.Id;
                            projDocSect.IPM_Section_Name__c = localProject.IPM_Project_Name__c;
                            projDocSect.IPM_Section_Status__c = IPM_ConstantUtils.STATUS_NOT_STARTED;
                            projDocSect.IPM_FunctionalRole__c = IPM_ConstantUtils.IPM_ROLE_BB;
                            projDocSect.IPM_Section_Sequence_Number__c = DYNAMIC_SECTION_SEQUENCE+lastGlobalCountrySection;
                            projDocSect.IPM_Negotiable__c = true;
                            if(localProject.IPM_Complexity__c == IPM_ConstantUtils.COMPLEXITY_FULL)
                            {
                                projDocSect.IPM_Default_Section__c=true;
                            }
                            lastGlobalCountrySection++;
                            upsertParentSections.add(projDocSect);     
                       }
                   }
                } 
            }
                
            List<Id> regionalProjectIds = parentToChildProjects.get(globalProjectId);
            
            for(Id regionalProjectId : regionalProjectIds)
            {
                Integer lastRegionalCountrySection = 1;
                IPM_Project__c regionalProject = null;
                IPM_Project_Document__c regionalProjectDocument = null; 
                if(IPM_ProjectHelper.projectMasterMap.containsKey(regionalProjectId) && IPM_ProjectHelper.projectMasterMap.get(regionalProjectId) !=null )
                {
                    regionalProject = IPM_ProjectHelper.projectMasterMap.get(regionalProjectId);
                }
                
                // Get the last Section of 7.2 which is present at Regional Level.
                if(regionalProject!=null && IPM_ProjectHelper.DBprojectSpecificDocumentMap.containsKey(regionalProject.Id) && IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(regionalProject.Id)!=null)
                {
                    for(IPM_Project_Document__c projectDocument : IPM_ProjectHelper.DBprojectSpecificDocumentMap.get(regionalProject.Id))
                    {
                        if(projectDocument.IPM_GateDocuments__c == IPM_ConstantUtils.CONTRACT_GATE)
                        {
                            // Check what sequence Number should be set
                            regionalProjectDocument = projectDocument;
                            if(IPM_ProjectHelper.projectDocumentMap.containsKey(regionalProjectDocument.Id) && IPM_ProjectHelper.projectDocumentMap.get(regionalProjectDocument.Id) !=null)
                            {
                                IPM_Project_Document__c existingRegionalDocument = IPM_ProjectHelper.projectDocumentMap.get(globalProjectDocument.Id);
                                
                                if(existingRegionalDocument!=null && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.containsKey(existingRegionalDocument.Id) 
                                    && IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(existingRegionalDocument.Id)!=null)
                                {
                                    for(IPM_Project_Document_Section__c docSection : IPM_ProjectHelper.DBProjectdocumentSpecificSectionMap.get(existingRegionalDocument.Id))
                                    {
                                        if(docSection.IPM_Section_Sequence_Number__c.startsWith(DYNAMIC_SECTION_SEQUENCE))
                                        {
                                            // Find the last Dot and prepare largest index based on that.   
                                            Integer startIndex = docSection.IPM_Section_Sequence_Number__c.lastIndexOf(IPM_ConstantUtils.DOT_DELIMITER);
                                            Integer endIndex = docSection.IPM_Section_Sequence_Number__c.length()+1; 
                                            String sequenceNumber = docSection.IPM_Section_Sequence_Number__c.substring(startIndex,endIndex);
                                            Integer sequenceInteger = Integer.valueOf(sequenceNumber);  
                                            
                                            if(sequenceInteger > lastRegionalCountrySection)
                                            {
                                                lastRegionalCountrySection = sequenceInteger; 
                                            }    
                                        }
                                    }
                                }
                            }
                            break;
                        } 
                    }
                }
                
                // Get local Records Associated with it.
                if(parentToChildProjects.containsKey(regionalProjectId) && parentToChildProjects.get(regionalProjectId)!=null)
                {
                   List<Id> localProjectIds = parentToChildProjects.get(regionalProjectId);
                   for(Id localProjectID : localProjectIds)
                   {
                       IPM_Project__c localProject = null;
                       if(IPM_ProjectHelper.projectMasterMap.containsKey(localProjectID) && IPM_ProjectHelper.projectMasterMap.get(localProjectID) !=null )
                       {
                           localProject = IPM_ProjectHelper.projectMasterMap.get(localProjectID);
                       }
                       if(localProject!=null)
                       {
                            IPM_Project_Document_Section__c projDocSect = new IPM_Project_Document_Section__c();
                            projDocSect.IPM_Project_Document__c = regionalProjectDocument.Id;
                            projDocSect.IPM_Section_Name__c = localProject.IPM_Project_Name__c;
                            projDocSect.IPM_Section_Status__c = IPM_ConstantUtils.STATUS_NOT_STARTED;
                            projDocSect.IPM_FunctionalRole__c = IPM_ConstantUtils.IPM_ROLE_BB;
                            projDocSect.IPM_Section_Sequence_Number__c = DYNAMIC_SECTION_SEQUENCE+lastRegionalCountrySection;
                            projDocSect.IPM_Negotiable__c = true;
                            if(localProject.IPM_Complexity__c == IPM_ConstantUtils.COMPLEXITY_FULL)
                            {
                                projDocSect.IPM_Default_Section__c=true;
                            }
                            lastRegionalCountrySection++;   
                            upsertParentSections.add(projDocSect);  
                       }
                   }
                }  
            }
        } 
        
        if(upsertParentSections!=null && !upsertParentSections.isEmpty())
        {
            insert upsertParentSections; // Not including try , catch as when the transaction is failed roll back is handled at other class  
        }         
    }
}