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
    public static Boolean SKIP_TRIGGER_EXECUTION = false;  
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
    * @Business Logic: This method is used for copying over the section details from one gate document to the subsequent gate document section
    				   The major parameters to be considered for copying a sections are the Gate Documetn Summary, the FUnctional Summary,
    				   Whether the Section was default at previous gate, and the Character Count of the Summary section.
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
                                         
                                         // the below logic is required because from Bosscard RTF field data needs to be copied into RTF field of Section with Character Limit 
                                         if(associatedGate==IPM_ConstantUtils.CHARTER_GATE && String.isNotBlank(projDocSect.IPM_Gate_Document_Summary__c) && summary.length()>(Integer)section.IPM_Character_Limit__c){
                                            projDocSect.IPM_Gate_Document_Summary__c=summary.subString(0,(Integer)section.IPM_Character_Limit__c);
                                        }
                                        if(section.IPM_Character_Limit__c!=NULL){
                                            if(String.isNotBlank(projDocSect.IPM_Gate_Document_Summary__c)){
                                                projDocSect.IPM_Summary_Character_Remaining__c=(Integer)section.IPM_Character_Limit__c-projDocSect.IPM_Gate_Document_Summary__c.length();
                                            }
                                            else{
                                                projDocSect.IPM_Summary_Character_Remaining__c=section.IPM_Character_Limit__c;
                                            }
                                        }
                                        // Update the Status based on Whether Gate Summary information is filled or not.
                                        if(section.IPM_Section_Type__c !=IPM_ConstantUtils.SECTION_TYPE_HEADER && 
                                            section.IPM_Section_Type__c!=IPM_ConstantUtils.SECTION_TYPE_SUBHEADER)
                                        {
                                           // DEF2994 Restrict the copy over of Filled in logic 16/12/2015
                                            if(String.isBlank(projDocSect.IPM_PDP_Document_Summary__c))
                                            {
                                                projDocSect.IPM_Functional_Input_Status__c=IPM_ConstantUtils.STATUS_NOT_STARTED;
                                            }
                                            else if(String.isNotBlank(projDocSect.IPM_PDP_Document_Summary__c) && projDocSect.IPM_PDP_Document_Summary__c.length() >=15)
                                            {
                                                projDocSect.IPM_Functional_Input_Status__c=IPM_ConstantUtils.STATUS_STARTED;
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
                        //NO SONAR for Unnecessary Boolean Comparison, since targetField is coming from Map where two fields are of typr Text and 1 is of Checkbox, we need to explicitly check for this condition in order for Business Logic to Work
                        //While copying over sections data 3 fields pulled from the custom settings "IPM_Section_CopyMapping" needs to be copied Gate Summary, Functional Summary (which are text fields) and isDefault which is a boolean  
                        if(String.isNotBlank(sourceField) && String.isNotBlank(targetField) && (incomingSection.get(targetField) == null || incomingSection.get(targetField)==false))
                        {
                            if(copyFromGate.equals(BOSSCARD) || currentSectionExternalId != IPM_ConstantUtils.FEEDBACK_FROM_LAST_GATE)
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
}