/****************************************************************************************************************************
@Author Cognizant
@name IPM_ProjectHelper
@CreateDate 10/08/2015
@Description Used for Creating Related Records on Project Creation and Project Phase Change.
@Version 1.0
@reference Project Initiation and Phase Change
*/ 
public with sharing class IPM_ProjectHelper 
{
    // Milestones Record Types(Standard & project)
    public static final ID  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
    public static final ID  mileProjectRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.milePMRecordType).getRecordTypeId();
    
    // Tasks Record Types(Standard & Project)
    public static final ID  taskMasterRecordType = Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(IPM_Utils.IPM_STANDARD_TASKS).getRecordTypeId();
    public static final ID  taskProjectRecordType = Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectTasks).getRecordTypeId();
    
    // Rollout Record Types
    public static final String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId(); 
    public static final String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId(); 
    
    // Financial Record Types
    public static final String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId(); 
    public static final String CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId(); 
    
    // Query Additional Parameters
    public static final String LIMIT_CLAUSE_STR = ' limit 50000 '; 
    public static final String WHERE_CLAUSE_STR = ' where ipm_project__c in :resultantprojectids ';
    
    public static final String IPM_PROJECT_ROLLOUT = 'IPM_Project_Rollout__c';
    
    public static Set<Id> incomingProjectIds = new Set<Id>();
    public static Set<Id> resultantProjectIds = new Set<Id>();
    public static Set<String> projectComplexitySet = new Set<String>();
    public static String categoryString = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
    public static Set<Id> associatedBosscards = new Set<Id>();
    
    public static Set<String> projectTypeSet = new Set<String>(); 
    
    /* Project Specific information starts*/
    public static Map<Id,IPM_Project__c> projectMasterMap = new Map<Id,IPM_Project__c>();
    
    /* Project Specific information ends*/
    
    /* Project Document Specific information starts */
    public static Map<Id,IPM_Project_Document__c> projectDocumentMap = new Map<Id,IPM_Project_Document__c>();
    public static Map<Id,List<IPM_Project_Document__c>> DBprojectSpecificDocumentMap = new Map<Id,List<IPM_Project_Document__c>>(); 
    /* Project Document Specific information ends */
    
    /* Project Document Section Specific information starts */
    public static Map<Id,IPM_Project_Document_Section__c> projectSectionMap = new Map<Id,IPM_Project_Document_Section__c>();
    public static Map<Id,List<IPM_Project_Document_Section__c>> DBProjectdocumentSpecificSectionMap = new Map<Id,List<IPM_Project_Document_Section__c>>(); 
    /* Project Document Section Specific information ends */
    
    /* Project Document Section Content Specific information starts */
    public static Map<Id,IPM_Project_Document_Section_Content__c> projectSectionContentMap = new Map<Id,IPM_Project_Document_Section_Content__c>();
    public static Map<Id,List<IPM_Project_Document_Section_Content__c>> DBprojectSectionSpecificContentMap = new Map<Id,List<IPM_Project_Document_Section_Content__c>>();
    /* Project Document Section Content Specific information ends */
    
    /* Project Specific Questionnaire information starts */
    public static Map<Id,IPM_Questionnaire__c> projectQuestionnaireMap = new Map<Id,IPM_Questionnaire__c>();
    public static Map<Id,List<IPM_Questionnaire__c>> DBprojectSpecificQuestionareMap = new Map<Id,List<IPM_Questionnaire__c>>();    
    /* Project Specific Questionnaire information ends */
    
    /* Project Specific Task information starts */
    public static Map<Id,IPM_Task__c> projectTaskMap = new Map<Id,IPM_Task__c>();
    public static Map<Id,List<IPM_Task__c>> DBprojectSpecificTasksMap = new Map<Id,List<IPM_Task__c>>();
    /* Project Specific Task information ends */
    
    /* Project Specific Resource information starts */
    public static Map<Id,IPM_Project_Resource__c> projectResourceMap = new Map<Id,IPM_Project_Resource__c>(); 
    public static Map<Id,List<IPM_Project_Resource__c>> DBprojectSpecificResourceMap = new Map<Id,List<IPM_Project_Resource__c>>();   
    /* Project Specific Resource information ends */
    
    /* Project Specific Milestone information starts */
    public static Map<Id,IPM_Milestone__c> projectMilestonesMap = new Map<Id,IPM_Milestone__c>();
    public static Map<Id,List<IPM_Milestone__c>> DBprojectSpecificMileStoneMap = new Map<Id,List<IPM_Milestone__c>>();
    /* Project Specific Milestone information ends */
    
    /* Project Specific CMI Gate information starts */
    public static Map<Id,IPM_Gate_CMI__c> projectCMIGateMap = new Map<Id,IPM_Gate_CMI__c>();
    public static Map<Id,List<IPM_Gate_CMI__c>> DBprojectSpecificCMIGateMap = new Map<Id,List<IPM_Gate_CMI__c>>();
    /* Project Specific CMI Gate information ends */
    
    /* Rollout and Country Specific Maps starts*/
    public static Map<Id,IPM_Project_Rollout__c> sourceRolloutMasterMap = new Map<Id,IPM_Project_Rollout__c>();
    public static Map<Id,Map<Id,IPM_Project_Rollout__c>> regionalRolloutToChildRolloutMap = new Map<Id,Map<Id,IPM_Project_Rollout__c>>();
    
    public static Map<Id,Map<Id,IPM_Country__c>> sourceRollOutToCountryListMap = new Map<Id,Map<Id,IPM_Country__c>>();
    
    public static Map<Id,Map<Id,IPM_Project_Rollout__c>> projectToRolloutMap = new Map<Id,Map<Id,IPM_Project_Rollout__c>>();
    public static Map<Id,Map<String,IPM_Country__c>> projectToCountryMap = new Map<Id,Map<String,IPM_Country__c>>();
    /* Rollout and Country Specific Maps ends */
    
    public static Map<Id,IPM_Bosscard__c> bossCardMap = new Map<Id,IPM_Bosscard__c>();
    
    /* Administrative Data Map Starts */
    public static Map<Id,IPM_Project_Template__c> complexityTemplateMap = new Map<Id,IPM_Project_Template__c>();
    public static Map<Id,List<IPM_Document_Template__c>> complexitySpecificDocumentTemplates = new Map<Id,List<IPM_Document_Template__c>>(); 
    public static Map<Id,List<IPM_Task__c>> complexitySpecificTaskMap = new Map<Id,List<IPM_Task__c>>();
    
    public static Map<Id,IPM_Document_Template__c> documentTemplateMap = new Map<Id,IPM_Document_Template__c>();
    public static Map<Id,List<IPM_Section__c>> documentTemplateSpecificSectionMap = new Map<Id,List<IPM_Section__c>>();
    
    
    public static Map<Id,IPM_Questionnaire__c> masterQuestionnaireMap = new Map<Id,IPM_Questionnaire__c>();
    public static Map<Id,IPM_Milestone__c> masterMilestoneMap = new Map<Id,IPM_Milestone__c>();
    public static Map<String,Map<String,IPM_Section_Copy_Mapping__c>> gateToSectionCopyMap = new Map<String,Map<String,IPM_Section_Copy_Mapping__c>>();
    public static Map<String,List<IPM_OTIF_Status__c>>  gateToOTIFCustomSetting = new Map<String,List<IPM_OTIF_Status__c>>();
    
    /* Administrative Data Map ends */
    
    public static Map<Id,Id> childToParentProject = new Map<Id,Id>();
    
    // Create a Map of project To List of Documents and Sections.
    public static Map<Id,Map<String,IPM_Project_Document__c>> projectToDocumentMap = new Map<Id,Map<String,IPM_Project_Document__c>>();
    public static  Map<Id,List<IPM_Project_Document_Section__c>> projectDocumentToSecMap = new Map<Id,List<IPM_Project_Document_Section__c>>();
    
    public static Boolean SKIP_TRIGGER_EXECUTION = false;
    
     /**************************************************************
    * @description: Used for Resetting Cache in case Project Handler is invoked again. 
    */
    
    public static void resetMasterData()
    {
        incomingProjectIds.clear();
        resultantProjectIds.clear();
        projectComplexitySet.clear();
        associatedBosscards.clear();
    
        /* Project Specific information starts*/
        projectMasterMap.clear();
        /* Project Specific information ends*/
    
        /* Project Document Specific information starts */
        projectDocumentMap.clear();
        DBprojectSpecificDocumentMap.clear();
        /* Project Document Specific information ends */
    
        /* Project Document Section Specific information starts */
        projectSectionMap.clear();
        DBProjectdocumentSpecificSectionMap.clear();
        /* Project Document Section Specific information ends */
        
        /* Project Document Section Content Specific information starts */
        projectSectionContentMap.clear();
        DBprojectSectionSpecificContentMap.clear();
        /* Project Document Section Content Specific information ends */
        
        /* Project Specific Questionnaire information starts */
        masterQuestionnaireMap.clear();
        projectQuestionnaireMap.clear();
        DBprojectSpecificQuestionareMap.clear();
        /* Project Specific Questionnaire information ends */
        
        /* Project Specific Task information starts */
        projectTaskMap.clear();
        DBprojectSpecificTasksMap.clear();
        /* Project Specific Task information ends */
        
        /* Project Specific Resource information starts */
        projectResourceMap.clear();
        DBprojectSpecificResourceMap.clear();
        /* Project Specific Resource information ends */
        
        /* Project Specific Milestone information starts */
        masterMilestoneMap.clear();
        projectMilestonesMap.clear();
        DBprojectSpecificMileStoneMap.clear();
        /* Project Specific Milestone information ends */
        
        /* Project Specific CMI Gate information starts */
        projectCMIGateMap.clear();
        DBprojectSpecificCMIGateMap.clear();
        /* Project Specific CMI Gate information ends */
        
        sourceRolloutMasterMap.clear();
        regionalRolloutToChildRolloutMap.clear();
        sourceRollOutToCountryListMap.clear();
       
        
        bossCardMap.clear();
        projectToCountryMap.clear();
        projectToRolloutMap.clear();
        
        complexityTemplateMap.clear();
        complexitySpecificDocumentTemplates.clear();
        complexitySpecificTaskMap.clear();
        documentTemplateMap.clear();
        documentTemplateSpecificSectionMap.clear();
        gateToSectionCopyMap.clear();
        
        childToParentProject.clear();     
        
        categoryString = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
    }
    
     /**************************************************************
    * @description: Used for Getting Project Specific information. This would go upto 2 levels higher for Copy Over logic and Other reasons.
    * @param1 projectMap : incoming Project Map
    */
    
    public static void initializeProjectDetail(Map<Id,IPM_Project__c> projectMap) 
    {
        if(projectMap!=null && !projectMap.isEmpty())
        {
            incomingProjectIds = projectMap.keySet();
            
            for(IPM_Project__c project  : projectMap.values())
            {
                // Get Bosscard Information to Populate when it is moving in charter Phase.
                if(project.IPM_Bosscard__c !=null)
                {
                    associatedBosscards.add(project.IPM_Bosscard__c);    
                }
                
                resultantProjectIds.add(project.Id);
                
                // Check if there are parent Projects Available. If yes 
                if(project.IPM_Parent_Project__c !=null)
                {
                    resultantProjectIds.add(project.IPM_Parent_Project__c);
                }
            }
        }
        // Get First level project specific information
        String projectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null,true);
        String projectWhereClause = ' WHERE Id in :resultantProjectIds '+ LIMIT_CLAUSE_STR;
        projectQuery = projectQuery + projectWhereClause;
        Map<Id,IPM_Project__c> projectDetailMap = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(projectQuery));
        
        // Get Top Level Parent for Projects, in case it is a Local Project.
        Set<Id> topLevelProjects = new Set<Id>();   
        if(projectDetailMap!=null && !projectDetailMap.isEmpty())
        {
            for(IPM_Project__c project : projectDetailMap.values())
            {
                if(project.IPM_Parent_Project__c !=null)
                {
                    topLevelProjects.add(project.IPM_Parent_Project__c);
                }
            }
        }
        
        if(topLevelProjects!=null && !topLevelProjects.isEmpty())
        {
            resultantProjectIds.addAll(topLevelProjects);
            if(resultantProjectIds!=null && !resultantProjectIds.isEmpty())
            {            
                // Get project Level information along with project Documents 
                String globalProjectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null,true);
                String globalProjectWhereClause = ' WHERE Id in :resultantProjectIds '+LIMIT_CLAUSE_STR;
                globalProjectQuery = globalProjectQuery + globalProjectWhereClause;
                projectMasterMap = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(globalProjectQuery) );   
            }
        }
        else
        {
            projectMasterMap = projectDetailMap;
        }
        
        
        Set<String> categorySet = new Set<String>();
        
        for(IPM_Project__c project : projectMasterMap.values())
        {
            childToParentProject.put(project.Id,project.IPM_Parent_Project__c);
            if(project.IPM_Complexity__c != null)
            {
                projectComplexitySet.add(project.IPM_Complexity__c);
            }
            
            if(project.IPM_Category_Text__c !=null) 
            {
                categorySet.add(project.IPM_Category_Text__c);
            }
            
            if(!String.isBlank(project.IPM_SourceProjectType__c))
            {
                projectTypeSet.add(project.IPM_SourceProjectType__c);
            }
        }
        
        if(!categorySet.isEmpty())
        {
            List<String> categoryList = new List<String>(categorySet);
            categoryString = String.join(categoryList,IPM_ConstantUtils.COMMA);
        }
    }
    
    /**************************************************************
    * @description: Used for Getting Administrative Data(Master Data) for IPM Project.
    */
    public static void initializeProjectMaster()
    {
        if(projectComplexitySet!=null && !projectComplexitySet.isEmpty())
        {
            // Get complexity Template Specific information based on Available list of Complexity
            String templateQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Template__c',true,new Set<String>{'IPM_Document_Template__c'},true);
            String templateWhereClause = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            String whereCondition = IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            
            if(!projectComplexitySet.isEmpty())
            {
                whereCondition  += ' IPM_Template_Complexity__c in :projectComplexitySet ';
            }
            
            if(!projectTypeSet.isEmpty() )
            {
                if(String.isNotEmpty( whereCondition))
                {
                    whereCondition  += ' AND ';
                }
                
                whereCondition  += ' IPM_Project_Type__c in :projectTypeSet ';
            }
            
            if(String.isNotEmpty(categoryString))
            {
                if(String.isNotEmpty( whereCondition))
                {
                    whereCondition  += ' AND ';
                }
                
                if(String.isNotEmpty(categoryString) )
                {
                    whereCondition  = whereCondition + ' IPM_Category__c includes ( :categoryString ) ';
                }
            }
            
             
            
            
            if(String.isNotEmpty( whereCondition) )
            {
                templateWhereClause = ' WHERE ' + whereCondition;
            }
            
            templateQuery = templateQuery + templateWhereClause + LIMIT_CLAUSE_STR;
 
            complexityTemplateMap = new Map<Id,IPM_Project_Template__c>( (List<IPM_Project_Template__c>) database.query(templateQuery) ); 
            
            // Get associated Document List for Project Templates.
            for(IPM_Project_Template__c projectTemplate : complexityTemplateMap.values())
            {
                complexitySpecificDocumentTemplates.put(projectTemplate.Id,projectTemplate.IPM_Document_Templates__r);
            }
            
            
            // Get associated task List for Project Templates.
            List<IPM_Project_Template__c> projectTemplateList = complexityTemplateMap.values();
            
            String templateTaskQuery = IPM_Utils.prepareSOQLQuery('IPM_Task__c',false,null,true);
            String templateTaskWhereClause = ' WHERE IPM_Is_Master__c = true AND IPM_Project_Template__c in :projectTemplateList ';
            
            templateTaskQuery = templateTaskQuery + templateTaskWhereClause + LIMIT_CLAUSE_STR;
            
            Map<Id,IPM_Task__c> templateTaskMap = new Map<Id,IPM_Task__c>( (List<IPM_Task__c>) database.query(templateTaskQuery) );
            
            for(IPM_Task__c task : templateTaskMap.values())
            {
                List<IPM_Task__c> templateTaskList = new List<IPM_Task__c>();
                if( complexitySpecificTaskMap.containsKey(task.IPM_Project_Template__c) )
                {
                    templateTaskList = complexitySpecificTaskMap.get(task.IPM_Project_Template__c); 
                }
                
                templateTaskList.add(task);
                
                complexitySpecificTaskMap.put(task.IPM_Project_Template__c,templateTaskList);   
            }

            if(complexityTemplateMap!=null && !complexityTemplateMap.isEmpty())
            {
                List<IPM_Project_Template__c> projectTemplates  = complexityTemplateMap.values();
                // Get Document template Type information (this would include document Template Sections as well)
                String documentTemplateQuery = IPM_Utils.prepareSOQLQuery('IPM_Document_Template__c',true,new Set<String>{'IPM_Section__c'},true);
                String documentTemplateWhereClause = 'WHERE IPM_Project_Template__c in :projectTemplates '+LIMIT_CLAUSE_STR;
                documentTemplateQuery = documentTemplateQuery + documentTemplateWhereClause;
                documentTemplateMap = new Map<Id,IPM_Document_Template__c>( (List<IPM_Document_Template__c>) database.query(documentTemplateQuery) );
                
                for(IPM_Document_Template__c documentTemplate : documentTemplateMap.values())
                {
                    
                    documentTemplateSpecificSectionMap.put(documentTemplate.Id,documentTemplate.IPM_Sections__r);
                }
            }
        
            // Get Master Questionnaire information
            String masterQuestionnaireQuery = IPM_Utils.prepareSOQLQuery('IPM_Questionnaire__c',false,null,true);
            String masterQuestionnaireWhereClause = 'WHERE Is_Master__c=true '+LIMIT_CLAUSE_STR;
            masterQuestionnaireQuery = masterQuestionnaireQuery + masterQuestionnaireWhereClause;
            masterQuestionnaireMap = new Map<Id,IPM_Questionnaire__c>( (List<IPM_Questionnaire__c>) database.query(masterQuestionnaireQuery) );
        }
        
        // Get Copy Over Custom Setting information.
        gateToSectionCopyMap = IPM_Utils.getSectionCopyOverMapping();
        
        // Get OTIF Specific information
        gateToOTIFCustomSetting = IPM_Utils.getOTIFMapping();   
    }
    
     /**************************************************************
    * @description: Used for Getting Project Specific related information which includes Documents,Sections,Section Content and Questionnaire
    */
    
    public static void initializeProjectRelatedData()
    {   
        if(resultantProjectIds!=null && !resultantProjectIds.isEmpty())
        {
            // Get project document specific Information
            
            String projectDocumentQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Document__c',false,null,true);
            String projectDocumentWhereClause = WHERE_CLAUSE_STR+LIMIT_CLAUSE_STR; // NO SONAR QUBE string literal used in dynamic SOQL 
            projectDocumentQuery = projectDocumentQuery + projectDocumentWhereClause;
            projectDocumentMap = new Map<Id,IPM_Project_Document__c>( (List<IPM_Project_Document__c>) database.query(projectDocumentQuery) );
             
            if(projectDocumentMap!=null && !projectDocumentMap.isEmpty())
            {
                for(IPM_Project_Document__c projectDocument : projectDocumentMap.values())
                {
                    List<IPM_Project_Document__c> projectDocumentList = new List<IPM_Project_Document__c>();
                    if(DBprojectSpecificDocumentMap.containsKey(projectDocument.IPM_Project__c))
                    {
                        projectDocumentList = DBprojectSpecificDocumentMap.get(projectDocument.IPM_Project__c);
                    }
                    projectDocumentList.add(projectDocument);
                    DBprojectSpecificDocumentMap.put(projectDocument.IPM_Project__c,projectDocumentList);   
                }   
            }       
            
            if(projectDocumentMap !=null && !projectDocumentMap.isEmpty())
            {
                // Get Project Document Section Specific information.
                
                List<IPM_Project_Document__c> projectDocumentList = new List<IPM_Project_Document__c>(projectDocumentMap.values());

                String projectSectionQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Document_Section__c',false,null,true);
                String projectSectionWhereClause = ' WHERE IPM_Project_Document__c in :projectDocumentList '+LIMIT_CLAUSE_STR; 
                projectSectionQuery = projectSectionQuery + projectSectionWhereClause;
                projectSectionMap = new Map<Id,IPM_Project_Document_Section__c>( (List<IPM_Project_Document_Section__c>) database.query(projectSectionQuery) );
                
                for(IPM_Project_Document_Section__c projectDocumentSection : projectSectionMap.values())
                {
                    List<IPM_Project_Document_Section__c> projectDocSectionList = new List<IPM_Project_Document_Section__c>();
                    if(DBProjectdocumentSpecificSectionMap.containsKey(projectDocumentSection.IPM_Project_Document__c))
                    {
                        projectDocSectionList = DBProjectdocumentSpecificSectionMap.get(projectDocumentSection.IPM_Project_Document__c);        
                    }
                    projectDocSectionList.add(projectDocumentSection);
                    DBProjectdocumentSpecificSectionMap.put(projectDocumentSection.IPM_Project_Document__c,projectDocSectionList);
                }
            }
            
            if(projectSectionMap!=null && !projectSectionMap.isEmpty())
            {
                // Get Section Content Specific information.
                
                List<IPM_Project_Document_Section__c> projectSectionList = new List<IPM_Project_Document_Section__c>(projectSectionMap.values());
                String projectSectionContentQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Document_Section_Content__c',false,null,true);
                String projectSectionContentWhereClause = ' WHERE IPM_Project_Document_Section__c in :projectSectionList '+LIMIT_CLAUSE_STR;
                projectSectionContentQuery = projectSectionContentQuery + projectSectionContentWhereClause;
                projectSectionContentMap = new Map<Id,IPM_Project_Document_Section_Content__c>( (List<IPM_Project_Document_Section_Content__c>) database.query(projectSectionContentQuery) );
                
                for(IPM_Project_Document_Section_Content__c projectDocSecContent : projectSectionContentMap.values())
                {
                    List<IPM_Project_Document_Section_Content__c> projectDocSectionContentList = new List<IPM_Project_Document_Section_Content__c>();
                    if(DBprojectSectionSpecificContentMap.containsKey(projectDocSecContent.IPM_Project_Document_Section__c))
                    {
                        projectDocSectionContentList = DBprojectSectionSpecificContentMap.get(projectDocSecContent.IPM_Project_Document_Section__c);        
                    }
                    projectDocSectionContentList.add(projectDocSecContent);
                    DBprojectSectionSpecificContentMap.put(projectDocSecContent.IPM_Project_Document_Section__c,projectDocSectionContentList);
                }
            }
            
            // Get Questionnaire Specific information
             
            String projectQuestionnaireQuery = IPM_Utils.prepareSOQLQuery('IPM_Questionnaire__c',false,null,true);
            String projectQuestionnaireWhereClause = WHERE_CLAUSE_STR+LIMIT_CLAUSE_STR;
            projectQuestionnaireQuery = projectQuestionnaireQuery + projectQuestionnaireWhereClause;
            projectQuestionnaireMap = new Map<Id,IPM_Questionnaire__c>( (List<IPM_Questionnaire__c>) database.query(projectQuestionnaireQuery) );
            
            for(IPM_Questionnaire__c projectQuestion : projectQuestionnaireMap.values())
            {
                List<IPM_Questionnaire__c> projectQuestionList = new list<IPM_Questionnaire__c>();
                if(DBprojectSpecificQuestionareMap.containsKey(projectQuestion.IPM_Project__c))
                {
                    projectQuestionList = DBprojectSpecificQuestionareMap.get(projectQuestion.IPM_Project__c);
                }
                projectQuestionList.add(projectQuestion);
                DBprojectSpecificQuestionareMap.put(projectQuestion.IPM_Project__c,projectQuestionList);
            }
            // Get Resource Specific Information
            
            String projectResourceQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Resource__c',false,null,true);
            String projectResourceWhereClause = WHERE_CLAUSE_STR+LIMIT_CLAUSE_STR;
            projectResourceQuery = projectResourceQuery + projectResourceWhereClause;
            projectResourceMap = new Map<Id,IPM_Project_Resource__c>( (List<IPM_Project_Resource__c>) database.query(projectResourceQuery) );
            
            for(IPM_Project_Resource__c projectResource : projectResourceMap.values())
            {
                List<IPM_Project_Resource__c> projectResourceList = new list<IPM_Project_Resource__c>();
                if(DBprojectSpecificResourceMap.containsKey(projectResource.IPM_Project__c))
                {
                    projectResourceList = DBprojectSpecificResourceMap.get(projectResource.IPM_Project__c);
                }
                projectResourceList.add(projectResource);
                DBprojectSpecificResourceMap.put(projectResource.IPM_Project__c,projectResourceList);
            } 
            
            // Get CMI Gate Specific information
            String projectCMIGateQuery = IPM_Utils.prepareSOQLQuery('IPM_Gate_CMI__c',false,null,true);
            String projectCMIGateWhereClause = WHERE_CLAUSE_STR+LIMIT_CLAUSE_STR;
            projectCMIGateQuery = projectCMIGateQuery + projectCMIGateWhereClause;
            projectCMIGateMap = new Map<Id,IPM_Gate_CMI__c>( (List<IPM_Gate_CMI__c>) database.query(projectCMIGateQuery) );
            
            for(IPM_Gate_CMI__c projectCMIGate : projectCMIGateMap.values())
            {
                List<IPM_Gate_CMI__c> projectCMIGateList = new list<IPM_Gate_CMI__c>();
                if(DBprojectSpecificCMIGateMap.containsKey(projectCMIGate.IPM_Project__c))
                {
                    projectCMIGateList = DBprojectSpecificCMIGateMap.get(projectCMIGate.IPM_Project__c);
                }
                projectCMIGateList.add(projectCMIGate);
                DBprojectSpecificCMIGateMap.put(projectCMIGate.IPM_Project__c,projectCMIGateList);
            } 
        }
        
        if(associatedBosscards!=null && !associatedBosscards.isEmpty())
        {
            String bosscardQuery = IPM_Utils.prepareSOQLQuery('IPM_Bosscard__c',false,null,true);
            String bosscardWhereClause = ' WHERE Id in :associatedBosscards '+LIMIT_CLAUSE_STR;
            bosscardQuery = bosscardQuery + bosscardWhereClause;
            bossCardMap = new Map<Id,IPM_Bosscard__c>( (List<IPM_Bosscard__c>) database.query(bosscardQuery) );
        }
    }
    
    /**************************************************************
    * @description: Used for Getting Project Specific related information which includes Rollouts and Countries.
    */ 
    public static void intializeProjectCountryNRollouts()
    {
        // Check if Project is created from Rollout, If yes get child Rollouts and update references for them.  
        Set<Id> projectSourceRolloutSet = new Set<Id>(); 
        for(IPM_Project__c project  : projectMasterMap.values())
        {
            if(project.IPM_Project_Rollout__c !=null)
            {
                projectSourceRolloutSet.add(project.IPM_Project_Rollout__c);
            }
        }
                
        if(!projectSourceRolloutSet.isEmpty())
        {    
            /*Rollout Information based on incoming Project starts */
            
            // Get References for Child rollouts for parent Rollouts. we have 2 types of Rollouts. Regional and Local. 
            // Local dont have any childs, so only Regional Rollout in Where Clause
            String projectRolloutQuery = IPM_Utils.prepareSOQLQuery(IPM_PROJECT_ROLLOUT,false,null,true); // NO SONAR QUBE IPM_PROJECT_ROLLOUT used in dyanmic SOQL
            String projectRolloutWhereClause = ' WHERE Id in:projectSourceRolloutSet OR (Regional_Rollout__c in :projectSourceRolloutSet AND recordTypeId = :LOCAL_ROLLOUT_RECORDTYPE ) '+LIMIT_CLAUSE_STR;
            projectRolloutQuery = projectRolloutQuery + projectRolloutWhereClause;
            Map<Id,IPM_Project_Rollout__c> projectsSourceRolloutsMap = new Map<Id,IPM_Project_Rollout__c>( (List<IPM_Project_Rollout__c>) database.query(projectRolloutQuery) );
            // projectsSourceRolloutsMap contains Rollouts which recently got converted to projects and its associated Child Rollouts.
            
            for(IPM_Project_Rollout__c rollout : projectsSourceRolloutsMap.values())
            {
                if(projectSourceRolloutSet.contains(rollout.Id)) // This means it is original Rollout
                {
                    sourceRolloutMasterMap.put(rollout.Id,rollout);         
                }
                else if(projectSourceRolloutSet.contains(rollout.Regional_Rollout__c))
                {
                    Map<Id,IPM_Project_Rollout__c> localRolloutMap = new Map<Id,IPM_Project_Rollout__c>(); 
                    if(regionalRolloutToChildRolloutMap.containsKey(rollout.Regional_Rollout__c))
                    {
                        localRolloutMap = regionalRolloutToChildRolloutMap.get(rollout.Regional_Rollout__c);
                    }
                    localRolloutMap.put(rollout.Id,rollout);
                    regionalRolloutToChildRolloutMap.put(rollout.Regional_Rollout__c,localRolloutMap);
                }
            }
            
            Set<Id> resultantRolloutIds = projectsSourceRolloutsMap.keySet();
            
            String projectCountryQuery = IPM_Utils.prepareSOQLQuery('IPM_Country__c',false,null,true);
            String projectCountryWhereClause = ' WHERE Local_Rollout__c in :resultantRolloutIds  AND local_Rollout__r.recordTypeId = :LOCAL_ROLLOUT_RECORDTYPE  '+LIMIT_CLAUSE_STR;
            projectCountryQuery = projectCountryQuery + projectCountryWhereClause;
            
            Map<Id,IPM_Country__c> countryMasterMap = new Map<Id,IPM_Country__c>( (List<IPM_Country__c>) database.query(projectCountryQuery) );
            
            for(IPM_Country__c country : countryMasterMap.values())
            {
                Map<Id,IPM_Country__c> associatedCountries = new Map<Id,IPM_Country__c>();
                if(sourceRollOutToCountryListMap.containsKey(country.Local_Rollout__c) && sourceRollOutToCountryListMap.get(country.Local_Rollout__c) !=null)
                {
                    associatedCountries = sourceRollOutToCountryListMap.get(country.Local_Rollout__c); 
                }
                associatedCountries.put(country.Id,country);
                sourceRollOutToCountryListMap.put(country.Local_Rollout__c,associatedCountries);
            }
        }
    }
    
    /**************************************************************
    * @description: Used for Getting Project Specific mileStone information.
    */
    public static void initializeMilestones()
    {
        // Get Project Specific information
        String projectMilestonesQuery = IPM_Utils.prepareSOQLQuery('IPM_Milestone__c',false,null,true);
        String mileStoneStandard = IPM_ConstantUtils.STANDARD;
        String projectMilestonesWhereClause = ' WHERE IPM_Project__c in :resultantProjectIds AND IPM_Type_of_Milestone__c = :mileStoneStandard '+LIMIT_CLAUSE_STR;
        projectMilestonesQuery = projectMilestonesQuery + projectMilestonesWhereClause;
        projectMilestonesMap = new Map<Id,IPM_Milestone__c>( (List<IPM_Milestone__c>) database.query(projectMilestonesQuery) );
        
        for(IPM_Milestone__c projectMilestone : projectMilestonesMap.values())
        {
            List<IPM_Milestone__c> projectMilestoneList = new list<IPM_Milestone__c>();
            if(DBprojectSpecificMileStoneMap.containsKey(projectMilestone.IPM_Project__c))
            {
                projectMilestoneList = DBprojectSpecificMileStoneMap.get(projectMilestone.IPM_Project__c);
            }
            projectMilestoneList.add(projectMilestone);
            DBprojectSpecificMileStoneMap.put(projectMilestone.IPM_Project__c,projectMilestoneList);
        }
        
        
        // Get Master Milestone information
        String masterProject = IPM_constantUtils.MASTER_PROJECT_NAME;
        String masterMilestoneQuery = IPM_Utils.prepareSOQLQuery('IPM_Milestone__c',false,null,true);
        String masterMilestoneWhereClause = 'WHERE  RecordTypeId = :mileMasterRecordType  AND IPM_Type_of_Milestone__c = :mileStoneStandard AND IPM_Project__r.Name=:masterProject '+LIMIT_CLAUSE_STR ;
        masterMilestoneQuery = masterMilestoneQuery + masterMilestoneWhereClause;
        masterMilestoneMap = new Map<Id,IPM_Milestone__c>( (List<IPM_Milestone__c>) database.query(masterMilestoneQuery) );   
    }
    
    /**************************************************************
    * @description: Used for Getting Project Specific Tasks information
    */
    public static void initializeTasks()
    {
        // Get Task Specific information
        String projectTaskQuery = IPM_Utils.prepareSOQLQuery('IPM_Task__c',false,null,true);
        String projectTaskWhereClause = WHERE_CLAUSE_STR+LIMIT_CLAUSE_STR;
        projectTaskQuery = projectTaskQuery + projectTaskWhereClause;
        projectTaskMap = new Map<Id,IPM_Task__c>( (List<IPM_Task__c>) database.query(projectTaskQuery) );
        
        for(IPM_Task__c projectTask : projectTaskMap.values())
        {
            List<IPM_Task__c> projectTaskList = new list<IPM_Task__c>();
            if(DBprojectSpecificTasksMap.containsKey(projectTask.IPM_Project__c))
            {
                projectTaskList = DBprojectSpecificTasksMap.get(projectTask.IPM_Project__c);
            }
            projectTaskList.add(projectTask);
            DBprojectSpecificTasksMap.put(projectTask.IPM_Project__c,projectTaskList);
        }
    }
    
    /**************************************************************
    * @description: Used for creating Project Documents,Sections and Section Content
    */
    public static void manageProjectDocuments(Map<Id,IPM_Project__c> projectMap)
    {                                               
        /* Used for DML Operations */        
        List<IPM_Project_Document__c> preparedprojectDocumentList = new List<IPM_Project_Document__c>();
        preparedprojectDocumentList = IPM_ProjectDocumentHelper.manageProjectDocuments(projectMap);
        
        // upsert based on Salesforce Id as mapping for Existing Project Documents is already done .
        if(preparedprojectDocumentList!=null && !preparedprojectDocumentList.isEmpty())
        {   
            upsert preparedprojectDocumentList Id;
            
               
            for(IPM_Project_Document__c doc : preparedprojectDocumentList)
            {
                Map<String,IPM_Project_Document__c> gateSpecificProjectDocMap = new Map<String,IPM_Project_Document__c>();
                if(projectToDocumentMap.containsKey(doc.IPM_Project__c))
                {
                    gateSpecificProjectDocMap = projectToDocumentMap.get(doc.IPM_Project__c);
                }
                gateSpecificProjectDocMap.put(doc.IPM_GateDocuments__c,doc);
                projectToDocumentMap.put(doc.IPM_Project__c,gateSpecificProjectDocMap);
            }
            
            // Get associated Sections for recently upserted Project Documents.
            List<IPM_Project_Document_Section__c> upsertSectionList = IPM_ProjectDocumentHelper.manageProjectDocumentSections(projectToDocumentMap,projectMap);
            
            if(upsertSectionList !=null)
            {
                upsert upsertSectionList Id;
                
                // Create a Map of project To Map of Document To Section
                
                
                for(IPM_Project_Document_Section__c section : upsertSectionList)
                {
                    List<IPM_Project_Document_Section__c> docSections = new List<IPM_Project_Document_Section__c>();
                    if(projectDocumentToSecMap.containsKey(section.IPM_Project_Document__c))
                    {
                       docSections =  projectDocumentToSecMap.get(section.IPM_Project_Document__c);
                    }
                    docSections.add(section);
                    projectDocumentToSecMap.put(section.IPM_Project_Document__c,docSections);
                }

                IPM_ProjectSectionContentHelper.createOTIFStatus(projectDocumentToSecMap,projectToDocumentMap,projectMap);          
                IPM_ProjectQuestionnaireHelper.manageQuestionnaire(upsertSectionList,preparedprojectDocumentList,projectMap);
                IPM_ProjectSectionContentHelper.createFinancialActionStandard(projectDocumentToSecMap,projectToDocumentMap,projectMap);
                IPM_ProjectSectionContentHelper.manageCMISections(projectDocumentToSecMap,projectToDocumentMap,projectMap);
                IPM_ProjectSectionContentHelper.manageCustomerEvidenceConcepts(projectMap,preparedprojectDocumentList,upsertSectionList);
                IPM_ProjectSectionContentHelper.manageCustomerChannel(projectMap,preparedprojectDocumentList,upsertSectionList);
                IPM_ProjectSectionContentHelper.manageFinancialActionStandards(projectMap,preparedprojectDocumentList,upsertSectionList);
                IPM_ProjectSectionContentHelper.manageCuComplexity(projectMap,preparedprojectDocumentList,upsertSectionList);
                IPM_ProjectSectionContentHelper.manageAssumptions(projectMap,preparedprojectDocumentList,upsertSectionList);
            }
        } 
    }
   
     /**************************************************************
    * @description: Used for populating References on Country and Rollouts, whenever a new Project is created.
    * @param1 incomingProjectMap : incoming Project Map  
    */
    public static void manageProjectCountryNRolloutReferences(Map<Id,IPM_Project__c> incomingProjectMap,Map<Id,IPM_Project__c> oldProjectMap)
    {
        Map<Id,IPM_Project_Rollout__c> updateRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
        Map<Id,IPM_Country__c> updateCountriesMap = new Map<Id,IPM_Country__c>();
        
        for(IPM_Project__c project : incomingProjectMap.values())
        {
            if(project.IPM_Project_Rollout__c !=null)
            {
                Id associatedRolloutId = project.IPM_Project_Rollout__c;
                Boolean rolloutUpdate = false;
                // Update source Rollouts with References of created Project
                if(sourceRolloutMasterMap.containsKey(associatedRolloutId) && sourceRolloutMasterMap.get(associatedRolloutId) !=null)
                {
                    IPM_Project_Rollout__c sourceRollout = sourceRolloutMasterMap.get(associatedRolloutId);
 
                    if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && sourceRollout.recordTypeId == REGIONAL_ROLLOUT_RECORDTYPE)
                    {
                        // Check for Child Rollouts to update Regional Project information.
                        if(regionalRolloutToChildRolloutMap.containsKey(associatedRolloutId) && regionalRolloutToChildRolloutMap.get(associatedRolloutId) !=null)
                        {
                            Map<Id,IPM_Project_Rollout__c> asssociatedChildRollouts = regionalRolloutToChildRolloutMap.get(associatedRolloutId);
                            
                            for(IPM_Project_Rollout__c localRollout : asssociatedChildRollouts.values())
                            {
                                
                                // Update Rollout References.
                                if(localRollout.Regional_Project__c != project.Id)
                                {
                                    localRollout.Regional_Project__c =  project.Id;
                                    rolloutUpdate = true;
                                }
                                
                                if(rolloutUpdate)
                                {
                                    updateRolloutMap.put(localRollout.Id,localRollout);
                                }
                                
                                // Update Country References.
                                if(sourceRollOutToCountryListMap.containsKey(localRollout.Id) && sourceRollOutToCountryListMap.get(localRollout.Id) !=null)
                                {
                                    Map<Id,IPM_Country__c> associatedCountryMap =  sourceRollOutToCountryListMap.get(localRollout.Id);
                                    for(IPM_Country__c associatedCountry : associatedCountryMap.values())
                                    {
                                        Boolean updateCountry = false;
                                        
                                        if(associatedCountry.IPM_Regional_Project__c != project.Id)
                                        {
                                            associatedCountry.IPM_Regional_Project__c = project.Id; 
                                            updateCountry = true;
                                        }
                                        
                                        if(updateCountry)
                                        {
                                            updateCountriesMap.put(associatedCountry.Id,associatedCountry);
                                        }
                                    }
                                }
                            }
                        } 
                    }
                    else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && sourceRollout.recordTypeId == LOCAL_ROLLOUT_RECORDTYPE)
                    {
                        sourceRollout.Local_Project__c = project.Id;
                        updateRolloutMap.put(sourceRollout.Id,sourceRollout);
                        
                        // Update Country References.
                        if(sourceRollOutToCountryListMap.containsKey(sourceRollout.Id) && sourceRollOutToCountryListMap.get(sourceRollout.Id) !=null)
                        {
                            Map<Id,IPM_Country__c> associatedCountryMap =  sourceRollOutToCountryListMap.get(sourceRollout.Id);
                            for(IPM_Country__c associatedCountry : associatedCountryMap.values())
                            {
                                Boolean updateCountry= false;
   
                                if(associatedCountry.IPM_Local_Project__c != project.Id)
                                {
                                    associatedCountry.IPM_Local_Project__c = project.Id;
                                    updateCountry = true;
                                }
                                
                                if(project.IPM_Parent_Project__c !=null && associatedCountry.IPM_Regional_Project__c != project.IPM_Parent_Project__c)
                                {
                                    if(associatedCountry.IPM_Regional_Project__c != project.IPM_Parent_Project__c)
                                    {
                                        associatedCountry.IPM_Regional_Project__c = project.IPM_Parent_Project__c;
                                        updateCountry = true;
                                    }
                                }
                                
                                if(updateCountry)
                                {
                                    updateCountriesMap.put(associatedCountry.Id,associatedCountry);
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if(!updateRolloutMap.isEmpty())
        {
            update updateRolloutMap.values();
        }
        
        if(!updateCountriesMap.isEmpty())
        {
            update updateCountriesMap.values();
        }
    }
    
    /**************************************************************
    * @description: Used for populating References on Financials,Creating financials based on certain Criteria.
    * @param1 incomingProjectMap : incoming Project Map  
    */
    
   
    public static void manageProjectFinancials(Map<Id,IPM_Project__c> incomingProjectMap,Map<Id,IPM_Project__c> oldProjectMap)
    {
        Map<String,IPM_Financial__c> finUniqueKeyToFinancialMap = new Map<String,IPM_Financial__c>();
        Map<String,IPM_Financial__c> financialsToUpsert = new Map<String,IPM_Financial__c>();
        
        Map<Id,Map<String,Set<String>>> projectToPostFixToUniqueFinancialKeySet = new Map<Id,Map<String,Set<String>>>();
        Set<String> completeFinancialUniqueKeySet = new Set<String>();
        
        if(!incomingProjectMap.isEmpty())
        {
            for(IPM_Project__c project : incomingProjectMap.values())
            {
                Map<String,Set<String>> postFixToUniqueFinancialKeySet = new Map<String,Set<String>>();
                
                Set<String> resultantPostFixSet = new Set<String>();
                // Get associated Project Type
                IPM_Project_Type__c associatedProjectType =IPM_Utils.retrieveProjectType(project);
                
                
                // Check if financials can be updated for this Project Type.
                if(associatedProjectType!=null)
                {
                    if(associatedProjectType.IPM_UpdateFinancialsReferences__c && !String.isBlank(associatedProjectType.IPM_FinancialsUpdatePostfix__c) ) 
                    {
                        String[] financialUpdateformats = associatedProjectType.IPM_FinancialsUpdatePostfix__c.split(IPM_ConstantUtils.COMMA);
                        resultantPostFixSet.addAll(financialUpdateformats);
                    }
                    
                    if(associatedProjectType.IPM_CreateFinancials__c && !String.isBlank(associatedProjectType.IPM_FinancialsInsertPostfix__c))
                    {
                        String[] financialsInsertFormats = associatedProjectType.IPM_FinancialsInsertPostfix__c.split(IPM_ConstantUtils.COMMA);
                        resultantPostFixSet.addAll(financialsInsertFormats);
                    }
                        
                    for(String KEY_POSTFIX  : resultantPostFixSet )
                    {
                        Set<String> uniqueFinancialKeySet = new Set<String>();
                        
                        if(postFixToUniqueFinancialKeySet.containsKey(KEY_POSTFIX))
                        {
                            uniqueFinancialKeySet = postFixToUniqueFinancialKeySet.get(KEY_POSTFIX);  
                        }
                            
                        // If PostFix is default, in that case use ProjectName
                        if(KEY_POSTFIX == 'DEFAULT')
                        {
                            uniqueFinancialKeySet.add(project.IPM_Project_Name__c);           
                        }
                        else if(KEY_POSTFIX == 'KEY')
                        {
                            if(projectToRolloutMap.containsKey(project.Id))
                            {
                                for(IPM_Project_Rollout__c associatedRollout : projectToRolloutMap.get(project.Id).values())
                                {
                                    if(associatedRollout.recordTypeId == LOCAL_ROLLOUT_RECORDTYPE)
                                    {
                                        uniqueFinancialKeySet.add(associatedRollout.IPM_Rollout_Project__c);
                                    }
                                }
                            }   
                        }
                        else
                        {
                            uniqueFinancialKeySet.add(project.IPM_Project_Name__c +IPM_ConstantUtils.UNDERSCORE+ KEY_POSTFIX);
                        }
                        
                        // Add to the comprehensive list of unique Financial Keys.
                        completeFinancialUniqueKeySet.addAll(uniqueFinancialKeySet);
                        
                        // Add the Unique Keys based on Postfix for future use.
                        postFixToUniqueFinancialKeySet.put(KEY_POSTFIX,uniqueFinancialKeySet);
                    }
                    
                    // Store the list of Unique Keys against projects.
                    if(!postFixToUniqueFinancialKeySet.isEmpty())
                    {
                        projectToPostFixToUniqueFinancialKeySet.put(project.Id,postFixToUniqueFinancialKeySet);
                    }
                }
            }   
        }
        
        
        if(!projectToPostFixToUniqueFinancialKeySet.isEmpty())
        {   
            // Get financial information based on Provided values.  
            String financialQuery = IPM_Utils.prepareSOQLQuery('IPM_Financial__c',false,null,true);
            String financialWhereClause = ' WHERE Financial_External_ID__c in :completeFinancialUniqueKeySet '+LIMIT_CLAUSE_STR;
            financialQuery = financialQuery + financialWhereClause;
            
            Map<Id,IPM_Financial__c> financialRecords = new Map<Id,IPM_Financial__c>( (List<IPM_Financial__c>) database.query(financialQuery) );
                
            for(IPM_Financial__c financials : financialRecords.values())
            {
                finUniqueKeyToFinancialMap.put(financials.Financial_External_ID__c,financials);
            }
            
            // Iterate throught the project value and update financials.
            for(IPM_Project__c project : incomingProjectMap.values())
            {   
                if(projectToPostFixToUniqueFinancialKeySet.containsKey(project.Id))
                {
                    Map<String,Set<String>> postFixToUniqueFinancialKeySet = projectToPostFixToUniqueFinancialKeySet.get(project.Id);
                
                    Id associatedRolloutId = project.IPM_Project_Rollout__c;
                    IPM_Project_Rollout__c rolloutDetail = sourceRolloutMasterMap.get(associatedRolloutId);
                    
                    IPM_Project_Type__c associatedProjectType =IPM_Utils.retrieveProjectType(project); 
                
                    // If update financials is true retrieve financial Key 
                    if(associatedProjectType!=null && associatedProjectType.IPM_UpdateFinancialsReferences__c)
                    {   
                        Map<String,Set<String>> financeUniquePostFixToAPIMap = new Map<String,Set<String>>();
    
                        if(!String.isBlank(associatedProjectType.IPM_FinancialsUpdatePostfix__c) && !String.isBlank(associatedProjectType.IPM_UpdateFinancialsAPIName__c) )
                        {
                            String[] financialPostFixArray = associatedProjectType.IPM_FinancialsUpdatePostfix__c.split(IPM_ConstantUtils.COMMA);
                            
                            for(String KEY_POSTFIX  :financialPostFixArray)
                            {
                               String[] financialUpdateformats = associatedProjectType.IPM_UpdateFinancialsAPIName__c.split(IPM_ConstantUtils.TILDA_DELIMITER);
                               for(String postFixToAPINameString : financialUpdateformats)
                               {
                                   String[] postFixToAPINameArray = postFixToAPINameString.split(IPM_ConstantUtils.EQUALS_DELIMITER); 
                                   if(postFixToAPINameArray!=null && !postFixToAPINameArray.isEmpty() && postFixToAPINameArray[0] == KEY_POSTFIX)
                                   {
                                       String finAPINameString = postFixToAPINameArray[1];
                                       if(!String.isBlank(finAPINameString))
                                       {
                                           Set<String> finAPINameSet = new Set<String>(finAPINameString.split(IPM_ConstantUtils.COMMA));
                                           financeUniquePostFixToAPIMap.put(KEY_POSTFIX,finAPINameSet);
                                       }
                                       break;
                                   }             
                               } 
                            }
                        }
                        
                        for(String financePostFix  : financeUniquePostFixToAPIMap.keySet())
                        {
                            Set<String> financialUniqueKeySet =  PostFixToUniqueFinancialKeySet.get(financePostFix);
                            
                            for(String financeUniqueKey : financialUniqueKeySet)
                            {
                                if(finUniqueKeyToFinancialMap.containsKey(financeUniqueKey) && finUniqueKeyToFinancialMap.get(financeUniqueKey)!=null)
                                {
                                    Boolean isChanged = false;
                                    
                                    IPM_Financial__c financialObj = finUniqueKeyToFinancialMap.get(financeUniqueKey);
                                    
                                    // Get Associated Fields which needs to be updated based on PostFix
                                    Set<String> updateFieldAPIs = financeUniquePostFixToAPIMap.get(financePostFix);
                                    
                                    if(updateFieldAPIs!=null && !updateFieldAPIs.isEmpty())
                                    {
                                      Id localProject = null;
                                      Id regionalProject = null;
                                      Id globalProject = null;
                                      Id regionalRollout = null;
                                     
                                      // Prepare Data if Project is local
                                        if( project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL )
                                        {
                                            localProject = project.Id;
                                            
                                            if(project.IPM_Parent_Project__c != null)
                                            {
                                                RegionalProject = project.IPM_Parent_Project__c;
                                            }
                                            
                                            if(childToParentProject.containsKey(project.IPM_Parent_Project__c))
                                            {
                                                globalProject = childToParentProject.get(project.IPM_Parent_Project__c);
                                            }
                                        }// Prepare Data if Project is Regional
                                        else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                                        {
                                            if(project.IPM_CompanyCardText__c == IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_REGIONAL)
                                            {
                                               globalProject = project.Id;
                                            }
                                            else
                                            {
                                                regionalProject = project.Id;
                                                if(project.IPM_Parent_Project__c !=null)
                                                {
                                                    globalProject = project.IPM_Parent_Project__c;
                                                }
                                            }
                                            
                                            if(associatedRolloutId!=null && financialObj.IPM_Project_Rollout__c != associatedRolloutId)
                                            {
                                                regionalRollout = associatedRolloutId;
                                            }
                                        }
                                    
                                        // Populate financial data with calculated values starts
                                        if(localProject !=null && financialObj.get('local_Project__c') != localProject && updateFieldAPIs.contains('local_Project__c'))
                                        {
                                            financialObj.Local_Project__c = localProject;
                                            isChanged = true;   
                                        }
                                    
                                        if(regionalProject!=null && financialObj.get('Regional_Project__c') != regionalProject && updateFieldAPIs.contains('Regional_Project__c'))
                                        {
                                            financialObj.Regional_Project__c = regionalProject;
                                            isChanged = true;
                                        }
                                    
                                        if(globalProject!=null && financialObj.get('Parent_Project__c') != globalProject && updateFieldAPIs.contains('Parent_Project__c'))
                                        {
                                            financialObj.Parent_Project__c = globalProject;
                                            isChanged = true;
                                        }
                                    
                                        if(regionalRollout!=null && financialObj.get(IPM_PROJECT_ROLLOUT) != regionalRollout && updateFieldAPIs.contains(IPM_PROJECT_ROLLOUT))
                                        {
                                            financialObj.IPM_Project_Rollout__c= regionalRollout;
                                            isChanged = true;
                                        }
                                    }   // end of if    
                                    
                                    
                                    // Check if Financial is updated with Gate indicator
                                    
                                    String gateIndicatorString = associatedProjectType.IPM_FinancialGateApprovalIndicator__c;
                                    if(gateIndicatorString!=null && !String.isBlank(gateIndicatorString))
                                    {
                                        String[] gateIndicatorArray = gateIndicatorString.split(IPM_ConstantUtils.COMMA);
                                    
                                        for(String gateIndicator :  gateIndicatorArray)
                                        {
                                            if(!String.isBlank(gateIndicator))
                                            {
                                                Boolean gateApprovalValue = (Boolean)financialObj.get(gateIndicator);
                                                if(gateApprovalValue!=null && !gateApprovalValue)
                                                {
                                                    financialObj.put(gateIndicator,true);
                                                    isChanged = true;                
                                                }
                                            }   
                                        } 
                                    }
                                    
                                    if(!String.isEmpty(associatedProjectType.FinancialCopyOverPrefix__c))
                                    {
                                        financialObj.IPM_Financial_Postfix__c = associatedProjectType.FinancialCopyOverPrefix__c;
                                        isChanged = true;
                                    }
                                    
                                    if(isChanged)
                                    {
                                        financialsToUpsert.put(financialObj.Financial_External_ID__c,financialObj);   
                                    }
                                }   
                            }
                        }                   
                    }
                
                    if(associatedProjectType!=null && associatedProjectType.IPM_CreateFinancials__c)
                    {
                        Map<String,String> financeUniquePostFixToRecordMap = new Map<String,String>();
                        
                        Map<String,Set<String>> financeUniquePostFixToAPIMap = new Map<String,Set<String>>();
    
                        if( !String.isBlank(associatedProjectType.IPM_FinancialsInsertPostfix__c) &&  !String.isBlank(associatedProjectType.IPM_InsertFinancialsAPIName__c)  )
                        {
                            String[] financialPostFixArray = associatedProjectType.IPM_FinancialsInsertPostfix__c.split(IPM_ConstantUtils.COMMA);
                            
                            for(String KEY_POSTFIX : financialPostFixArray)
                            {
                               String[] financialInsertformats = associatedProjectType.IPM_InsertFinancialsAPIName__c.split(IPM_ConstantUtils.TILDA_DELIMITER);
                               for(String postFixToAPINameString : financialInsertformats)
                               {
                                   String[] postFixToAPINameArray = postFixToAPINameString.split(IPM_ConstantUtils.EQUALS_DELIMITER); 
                                   if(postFixToAPINameArray!=null && !postFixToAPINameArray.isEmpty() && postFixToAPINameArray[0] == KEY_POSTFIX)
                                   {
                                       String finAPINameString = postFixToAPINameArray[1];
                                       if(!String.isBlank(finAPINameString))
                                       {
                                           Set<String> finAPINameSet = new Set<String>(finAPINameString.split(IPM_ConstantUtils.COMMA));
                                           financeUniquePostFixToAPIMap.put(KEY_POSTFIX,finAPINameSet);
                                       }
                                   }
                               }
    
                               String[] financialInsertRecordTypes = associatedProjectType.IPM_FinancialsInsertRecordType__c.split(IPM_ConstantUtils.COMMA);
                               for(String postFixToRecordTypeName : financialInsertRecordTypes)
                               {
                                   String[] postFixToRecordTypeArray = postFixToRecordTypeName.split(IPM_ConstantUtils.EQUALS_DELIMITER);
                                   if(postFixToRecordTypeArray!=null && !postFixToRecordTypeArray.isEmpty() && postFixToRecordTypeArray[0] == KEY_POSTFIX )
                                   {
                                        financeUniquePostFixToRecordMap.put(KEY_POSTFIX,postFixToRecordTypeArray[1]);
                                   }    
                               }
                              
                            }
                        }
                               
                        for(String financePostKey : financeUniquePostFixToAPIMap.KeySet())
                        {
                            Set<String> financialUniqueKeySet =  PostFixToUniqueFinancialKeySet.get(financePostKey);
                            
                            for(String financeUniqueKey : financialUniqueKeySet)
                            {
                                if(!finUniqueKeyToFinancialMap.containsKey(financeUniqueKey))
                                {
                                    Id localProject = null; 
                                    Id regionalProject = null;
                                    Id globalProject = null;
                                    Id regionalRollout = null;
                                    
                                    Boolean isChanged = false;
                                    
                                    // Get Associated Fields which needs to be updated
                                    Set<String> insertFieldAPIs = financeUniquePostFixToAPIMap.get(financePostKey);
                                    String configuredRecordType =  financeUniquePostFixToRecordMap.get(financePostKey);
                                    
                                    
                                    if(insertFieldAPIs!=null && !insertFieldAPIs.isEmpty() && configuredRecordType!=null && !String.isEmpty(configuredRecordType))
                                    {
                                        Schema.RecordTypeInfo recordTypeInfo = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(configuredRecordType);
                                        
                                        if(recordTypeInfo!=null && recordTypeInfo.getRecordTypeId() !=null)
                                        {
                                            IPM_Financial__c financialObj = new IPM_Financial__c();
                                            financialObj.RecordtypeId = recordTypeInfo.getRecordTypeId(); 
                                            financialObj.Financial_External_ID__c = financeUniqueKey;
                                            financialObj.Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c;
                                            financialObj.Project_Sustainability_Period__c = project.Sustainability_Period__c;
                                            financialObj.Added_At_Stage__c = project.IPM_Phase__c;      
                                            financialObj.isActive__c = true;
                                                      
                                            if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL )
                                            {   
                                                localProject = project.Id;
                                            
                                                if(project.IPM_Parent_Project__c != null)
                                                {
                                                    RegionalProject = project.IPM_Parent_Project__c;
                                                }
                                            
                                                if(childToParentProject.containsKey(project.IPM_Parent_Project__c))
                                                {
                                                    globalProject = childToParentProject.get(project.IPM_Parent_Project__c);
                                                }        
                                            } 
                                            else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                                            {   
                                                regionalProject = project.Id;
                                                if(project.IPM_Parent_Project__c !=null)
                                                {
                                                    globalProject = project.IPM_Parent_Project__c;
                                                }
                                            
                                                if(associatedRolloutId!=null && financialObj.IPM_Project_Rollout__c != associatedRolloutId)
                                                {
                                                    regionalRollout = associatedRolloutId;
                                                }
                                            }
                                            else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
                                            {
                                                globalProject = project.Id;
                                            }
                                            
                                            if(localProject !=null && financialObj.get('Local_Project__c') != localProject && insertFieldAPIs.contains('Local_Project__c'))
                                            {   
                                                financialObj.Local_Project__c = localProject;
                                                isChanged = true;   
                                            }
                                    
                                            if(regionalProject!=null && financialObj.get('Regional_Project__c') != regionalProject && insertFieldAPIs.contains('Regional_Project__c'))
                                            {   
                                                financialObj.Regional_Project__c = regionalProject;
                                                isChanged = true;
                                            }
    
                                            if(globalProject!=null && financialObj.get('Parent_Project__c') != globalProject && insertFieldAPIs.contains('Parent_Project__c')) //this api can be chnaged into custome settiing
                                            {   
                                                financialObj.Parent_Project__c = globalProject;
                                                isChanged = true;
                                            }
                                    
                                            if(regionalRollout!=null && financialObj.get(IPM_PROJECT_ROLLOUT) != regionalRollout && insertFieldAPIs.contains(IPM_PROJECT_ROLLOUT))
                                            {   
                                                financialObj.IPM_Project_Rollout__c= regionalRollout;
                                                isChanged = true;
                                            }
                                        
                                            String gateIndicatorString = associatedProjectType.IPM_FinancialGateApprovalIndicator__c;
                                            if(gateIndicatorString!=null && !String.isBlank(gateIndicatorString))
                                            {
                                                String[] gateIndicatorArray = gateIndicatorString.split(IPM_ConstantUtils.COMMA);
                                            
                                                for(String gateIndicator :  gateIndicatorArray)
                                                {
                                                    if(!String.isBlank(gateIndicator))
                                                    {
                                                        Boolean gateApprovalValue = (Boolean)financialObj.get(gateIndicator);
                                                        if(gateApprovalValue!=null && !gateApprovalValue)
                                                        {
                                                            financialObj.put(gateIndicator,true);
                                                            isChanged = true;                
                                                        }
                                                    }   
                                                } 
                                            }      
                                            
                                            if(isChanged)
                                            {
                                                financialsToUpsert.put(financialObj.Financial_External_Id__c,financialObj);
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
        
        if(!financialsToUpsert.isEmpty())
        {
            upsert financialsToUpsert.values() Financial_External_Id__c; 
        }       
    }
    
    
    public static void updateSustainabilityPeriod(Map<String,IPM_Project__c> financialYearUpdates)
    {
        // Get the financials asssociated with Project. Default Sustainability Period is 3 years. This would be invoked only in case of update for Original Projects.
        // Financials with Parent
        List<String> incomingProjectsIds =  new List<String>(financialYearUpdates.keySet());
        
        List<IPM_Financial__c> lstExistingFinancial = [SELECT Id, Financial_External_Id__c, Global_Project_Id__c,Regional_Project__c, Project_Sustainability_Period__c
                                                        FROM IPM_Financial__c WHERE Global_Project_Id__c IN: incomingProjectsIds OR Regional_Project__c IN: incomingProjectsIds ];
        
        Map<Id,IPM_Financial__c> updatedFinancials = new Map<Id,IPM_Financial__c>(); 
         
        if(!lstExistingFinancial.isEmpty())
        {
            for(IPM_Financial__c fin : lstExistingFinancial)
            {
                IPM_Project__c projectInContext = null;
                 
                // check if Global Original  Project is the one whose Sustainability is changed
                String globalProjectId = fin.Global_Project_Id__c;
                if(globalProjectId !=null && String.isNotBlank(globalProjectId) && financialYearUpdates.containsKey(globalProjectId)) 
                {
                    projectInContext = financialYearUpdates.get(globalProjectId);
                }
                
                // check if regional  Original Project is the one whose Sustainability is changed
                String regionalProjectId = fin.Regional_Project__c;
                if(regionalProjectId !=null && String.isNotBlank(regionalProjectId) && financialYearUpdates.containsKey(regionalProjectId))
                {
                    projectInContext = financialYearUpdates.get(regionalProjectId);
                }
                
                if( projectInContext != null && (fin.Project_Sustainability_Period__c != projectInContext.Sustainability_Period__c))
                {
                    fin.Project_Sustainability_Period__c = projectInContext.Sustainability_Period__c;
                    updatedFinancials.put(fin.Id,fin);
                }
            }
            
            if(!updatedFinancials.isEmpty())
            {
                update  updatedFinancials.values();
            }
        }                                         
    }
    
    /**************************************************************
    * @description: Once the Regional,Local Projects are created,This method updates the following
        References of Regional and local Project on local Rollouts.
        References of Regional and local Project on Country.
        Used for Udpating Charter Approved flag which indicates whether specific rollout or country was created before charter or not.
    * @param1 projectPhaseChange    : projects for which phase change is initiated.
    * @param2 oldProjectMap         : Old Projects for incontext Projects.
    */
    
    public static void refreshProjectRolloutCountryMapping(Map<Id,IPM_Project__c> projectPhaseChange,Map<Id,IPM_Project__c> oldProjectMap) 
    {
        Set<Id> phaseChangeProjectIdSet = projectPhaseChange.keySet();
        
        if(phaseChangeProjectIdSet != null && !phaseChangeProjectIdSet.isEmpty())
        {
            String projectRolloutQuery = IPM_Utils.prepareSOQLQuery(IPM_PROJECT_ROLLOUT,false,null,true);
            String projectRolloutWhereClause = ' WHERE IPM_Project__c in:phaseChangeProjectIdSet OR Local_Project__c in :phaseChangeProjectIdSet OR Regional_Project__c in :phaseChangeProjectIdSet '+LIMIT_CLAUSE_STR;
            projectRolloutQuery = projectRolloutQuery + projectRolloutWhereClause;
            Map<Id,IPM_Project_Rollout__c> rolloutDetailMap = new Map<Id,IPM_Project_Rollout__c>( (List<IPM_Project_Rollout__c>) database.query(projectRolloutQuery) );
            // projectsSourceRolloutsMap contains Rollouts which recently got converted to projects and its associated Child Rollouts.
            
            for(Id projectId : phaseChangeProjectIdSet )
            {
                for(IPM_Project_Rollout__c rollout : rolloutDetailMap.values())
                {
                    if(rollout.IPM_Project__c == projectId || rollout.Local_Project__c == projectId || rollout.Regional_Project__c == projectId )
                    {
                        Map<Id,IPM_Project_Rollout__c> rolloutsMap = new Map<Id,IPM_Project_Rollout__c>();
                        if(projectToRolloutMap.containsKey(projectId))
                        {
                            rolloutsMap = projectToRolloutMap.get(projectId);
                        }
                        rolloutsMap.put(rollout.Id,rollout);
                        projectToRolloutMap.put(projectId,rolloutsMap);
                    }
                }
            }
        	// Prepare the SOQL to get the Country records related to IPM Projects
            String countryQuery = IPM_Utils.prepareSOQLQuery('IPM_Country__c',false,null,true);
            String countryWhereClause = ' WHERE IPM_Project__c in :incomingProjectIds OR IPM_Regional_Project__c in :incomingProjectIds OR IPM_Local_Project__c in:incomingProjectIds '+LIMIT_CLAUSE_STR;
            countryQuery = countryQuery + countryWhereClause;
        	// get the country list related to Project
            List<IPM_Country__c> countryList = database.query(countryQuery);
            // prepare the country related data 
            for(IPM_Country__c country : countryList)
            {
                Id globalProjectID = country.IPM_Project__c;
                Map<String,IPM_Country__c> globalCountries = new Map<String,IPM_Country__c>();
                if(projectToCountryMap.containsKey(globalProjectID))
                {
                    globalCountries = projectToCountryMap.get(globalProjectID);
                }
                globalCountries.put(country.Country_Name__c,country);
                projectToCountryMap.put(globalProjectID,globalCountries);
                
                Id regionalProjectID = country.IPM_Regional_Project__c;

                Map<String,IPM_Country__c> regionalCountries = new Map<String,IPM_Country__c>();
                if(projectToCountryMap.containsKey(regionalProjectID))
                {
                    regionalCountries = projectToCountryMap.get(regionalProjectID);
                }
                regionalCountries.put(country.Country_Name__c,country);
                projectToCountryMap.put(regionalProjectID,regionalCountries);
                
                Id localProjectID = country.IPM_Local_Project__c;
                
                Map<String,IPM_Country__c> localCountries = new Map<String,IPM_Country__c>();
                if(projectToCountryMap.containsKey(localProjectID))
                {
                    localCountries = projectToCountryMap.get(localProjectID);
                }
                localCountries.put(country.Country_Name__c,country);
                projectToCountryMap.put(localProjectID,localCountries);
            }
            
            Map<Id,IPM_Project_Rollout__c> updateProjectRollout = new Map<Id,IPM_Project_Rollout__c>();
            Map<Id,IPM_Country__c> updateProjectCountry = new Map<Id,IPM_Country__c>();
            
            // prepartion of Project Rollout map data which are to be updated
            if(!projectToRolloutMap.isEmpty())
            {
                for(Id projectId : projectToRolloutMap.keySet())
                {
                    IPM_Project__c oldProject = null;
                    Map<Id,IPM_Project_Rollout__c> rolloutMap = projectToRolloutMap.get(projectId);
                    
                    if(oldProjectMap!=null && oldProjectMap.containsKey(projectId))
                    {
                        oldProject = oldProjectMap.get(projectId);
                        if( (oldProject!=null &&  oldProject.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS))
                        {
                            for(IPM_Project_Rollout__c rollout : rolloutMap.values())
                            {
                                // Update Rollouts with Charter References. Set Charter Approved as true
                                rollout.IPM_CharterApproved__c = true;
                                
                                if(rollout.recordTypeId == LOCAL_ROLLOUT_RECORDTYPE)
                                { 
                                    if(rollout.IPM_CharterFinancial__c == null)
                                    {
                                        rollout.IPM_CharterFinancial__r = new IPM_Financial__c(Financial_External_ID__c =  IPM_Utils.getFinancialExternalId(rollout));
                                    }
                                }
                                updateProjectRollout.put(rollout.Id,rollout);
                            }       
                        }
                    }
                }
                // Empty check of Project rollout map 
                if(!updateProjectRollout.isEmpty())
                {
                    IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;
                        update updateProjectRollout.values();
                    IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
                }
            }

            if(!projectToCountryMap.isEmpty())
            {
                for(Id projectId : projectToCountryMap.keySet())
                {
                    IPM_Project__c oldProject = null;
                    Map<String,IPM_Country__c> countryMap = projectToCountryMap.get(projectId);
                    
                    if(oldProjectMap!=null && oldProjectMap.containsKey(projectId))
                    {
                        oldProject = oldProjectMap.get(projectId);     
                        
                        if( (oldProject!=null &&  oldProject.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS))
                        {
                            for(IPM_Country__c country : countryMap.values())
                            {
                               country.IPM_CharterApproved__c = true;
                               
                               country.Local_Rollout_Charter__c = country.local_Rollout__c;
                               
                               if(updateProjectRollout.containsKey(country.local_Rollout__c)) 
                               {
                                    IPM_Project_Rollout__c rollout  = updateProjectRollout.get(country.local_Rollout__c); 
                                    if(rollout.recordTypeId == LOCAL_ROLLOUT_RECORDTYPE)
                                    {
                                        String financialExternalId = IPM_Utils.getFinancialExternalId(rollout);
                                        country.IPM_FinancialAtCharter__r = new IPM_Financial__c(Financial_External_ID__c =  IPM_Utils.getFinancialExternalId(rollout));
                                    }
                               }
                               updateProjectCountry.put(country.Id,country);
                            }       
                        }
                    }        
                }
                // Null check of country map
                if(!updateProjectCountry.isEmpty())
                { 
                    IPM_ProjectCountryDetails.SKIP_TRIGGER_EXECUTION = true;
                        update updateProjectCountry.values();   
                    IPM_ProjectCountryDetails.SKIP_TRIGGER_EXECUTION = false;
                }
            }
        }
    }
    
     public static void handleEcoDesignSyncProcess(IPM_Project__c incomingProject,IPM_Project__c oldProject){
            
        //If new Status is Success
        if(String.isNotBlank(incomingProject.EcoDesign_Sync_Status__c) && IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_SUCCESS.equalsIgnoreCase(incomingProject.EcoDesign_Sync_Status__c)){
            //If new status = 'Success' and old status = 'Ready' then reverback to status Ready
            if(String.isNotBlank(oldProject.EcoDesign_Sync_Status__c) && IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY.equalsIgnoreCase(oldProject.EcoDesign_Sync_Status__c)){
                incomingProject.EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY;
            }

            //also set the flag which indicates that the first sybc to eco design has occurred
            incomingProject.First_Sync_To_EcoDesign__c = TRUE;
            //also update the success timestamp with fetch timestamp
            incomingProject.Success_TimeStamp_EcoDesign__c = incomingProject.Fetch_Timestamp_Mulesoft__c;
        }
        
        //If new status = 'Error' and old status = 'Ready' then reverback to status Ready
        //also if new status = 'Error' then store the error in the field EcoDesign_Sync_Error__c
        if(String.isNotBlank(incomingProject.EcoDesign_Sync_Status__c) && IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_ERROR.equalsIgnoreCase(incomingProject.EcoDesign_Sync_Status__c)){
            if(String.isNotBlank(oldProject.EcoDesign_Sync_Status__c) && IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY.equalsIgnoreCase(oldProject.EcoDesign_Sync_Status__c)){
                incomingProject.EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY;
            }
        }
        
        //If new status =  'In Progress'
        if(String.isNotBlank(incomingProject.EcoDesign_Sync_Status__c) && IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_IN_PROGRESS.equalsIgnoreCase(incomingProject.EcoDesign_Sync_Status__c)){
            //populate the fetch time stamp with system.now()
            incomingProject.Fetch_Timestamp_Mulesoft__c = System.now();
        }
    }
    
    /**************************************************************
    * @description: Process the incoming Project and update its child and grand child projects(Regional and Local) to fasttrack 
    * @param1 incomingProjectMap : current project(IPM_Project__c) record.
    */ 
    public static void processFastTrackProjects(Map<Id, IPM_Project__c> ipmFastTrackProjectMap){
        
        List<IPM_Project__c> childProjectListToUpdate = new List<IPM_Project__c>(); // List of child IPMProjects to be updated
        for(IPM_Project__c childProject :    [SELECT Id, 
                                                     IPM_Fast_Track_Project__c, 
                                                     IPM_Parent_Project__c,  
                                                     IPM_Parent_Project__r.IPM_Parent_Project__c,
                                                     IPMProject_Span__c,
                                                     IPM_Parent_Project__r.IPMProject_Span__c
                                              FROM  IPM_Project__c 
                                              WHERE IPM_Parent_Project__c IN: ipmFastTrackProjectMap.keySet() OR IPM_Parent_Project__r.IPM_Parent_Project__c IN: ipmFastTrackProjectMap.keySet()]){
                                                
            if(childProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){ // Regional child projects to be updated
                childProject.IPM_Fast_Track_Project__c = ipmFastTrackProjectMap.get(childProject.IPM_Parent_Project__c).IPM_Fast_Track_Project__c;
            }else if(childProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL){ // Local child projects to be updated
                childProject.IPM_Fast_Track_Project__c = ipmFastTrackProjectMap.get(childProject.IPM_Parent_Project__r.IPM_Parent_Project__c).IPM_Fast_Track_Project__c;
            }
            childProjectListToUpdate.add(childProject);                                   
          
        }
        
        if(!childProjectListToUpdate.isEmpty()){
            update childProjectListToUpdate;
        }
        
    }
    
    /**************************************************************
    * @description: Used for Deleting Projects and its associated Components. 
            Once 'isCreatedInError' field is marked as true, System identifies the associated Components:
            1) Bosscard
            2) Child Projects
            3) Associated Rollouts
            4) Associated Financials
            5) Associated Countries
            The system based on specific sequence performs DML's to delete these records.  
    * @ : project id's to be deleted.
    */
    
    public static void deleteProject(Set<Id> projectIdSetToBeDeleted)
    {    
        if(!projectIdSetToBeDeleted.isEmpty() && !SKIP_TRIGGER_EXECUTION)
        {
            SKIP_TRIGGER_EXECUTION = true;    
            IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;
            
            Set<Id> associatedRolloutIds = new Set<Id>(); 
            Set<Id>bossCardid=new Set<Id>();
            // If it is a global Project, get corresponding regional Projects.
            for(IPM_Project__c project : [Select Id,IPM_Bosscard__c,(Select Id,IPM_Bosscard__c from IPM_Projects__r),(Select Id from IPM_Project_Rollout__r),(Select Id from Regional_Project_Rollout__r) from IPM_Project__c where IPM_Parent_Project__c in :projectIdSetToBeDeleted LIMIT 50000])
            {
                projectIdSetToBeDeleted.add(project.Id);
                if(project.IPM_Bosscard__c!=null){
                                bossCardid.add(project.IPM_Bosscard__c);
                }
                for(IPM_project__c childproject : project.IPM_Projects__r)
                {
                    projectIdSetToBeDeleted.add(childproject.Id);
                    if(childproject.IPM_Bosscard__c!=null){
                                    bossCardid.add(childproject.IPM_Bosscard__c);
                    }
                }
                
                for(IPM_Project_Rollout__c rollout : project.IPM_Project_Rollout__r)
                {
                    associatedRolloutIds.add(rollout.Id);
                }
                
                for(IPM_Project_Rollout__c rollout : project.Regional_Project_Rollout__r)
                {
                    associatedRolloutIds.add(rollout.Id);
                }
            }
           List<IPM_Bosscard__c>bosscardList=[SELECT ID FROM IPM_Bosscard__c WHERE Id IN:bossCardid LIMIT 50000];    
           if(bosscardList!=null && !bosscardList.isEmpty()){
               delete bosscardList;
            }
           List<IPM_Project_Document_Section_Content__c>gateDocSecConList=[SELECT ID FROM IPM_Project_Document_Section_Content__c WHERE IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c IN:projectIdSetToBeDeleted LIMIT 5000];
           if(gateDocSecConList!=null && !gateDocSecConList.isEmpty()){
               delete gateDocSecConList;        
            }
            List<IPM_Financial__c> projFinList=[Select Id From IPM_Financial__c where Parent_Project__c in:projectIdSetToBeDeleted OR Local_Project__c in:projectIdSetToBeDeleted OR Regional_Project__c in:projectIdSetToBeDeleted OR IPM_Project_Rollout__c in:associatedRolloutIds  Limit 5000];
            if(projFinList != null && !projFinList.isEmpty()){
                delete projFinList;
            }
            List<IPM_Project_Rollout__c> projRolloutList=[Select Id From IPM_Project_Rollout__c where IPM_Project__c in:projectIdSetToBeDeleted OR Local_Project__c in :projectIdSetToBeDeleted OR Regional_Project__c in :projectIdSetToBeDeleted limit 5000];
            if(projRolloutList != null && !projRolloutList.isEmpty()){
                delete projRolloutList;
            }    
            List<IPM_Country__c>countryList=[SELECT ID FROM IPM_Country__c WHERE (IPM_Project__c IN:projectIdSetToBeDeleted or IPM_Local_Project__c IN:projectIdSetToBeDeleted or IPM_Regional_Project__c IN:projectIdSetToBeDeleted) LIMIT 5000];
            if(countryList!=null && !countryList.isEmpty()){
                            delete countryList;
            }
            List<IPM_Project__c> projList=[Select Id From IPM_Project__c where Id in:projectIdSetToBeDeleted Limit 5000];
            if(projList != null && !projList.isEmpty())
                delete projList;
        } 
    }

    
    public static void udpateAsyncJobId(Set<Id>phaseChangeProjectSet, Id JobId)
    {
        Map<Id,IPM_Project__c> updateAsyncJobIdProjectMap = new Map<Id,IPM_Project__c>(); 
        for(Id projectId : phaseChangeProjectSet)
        {
            IPM_Project__c project = new IPM_Project__c(Id=projectId,IPM_PhaseChangeQueueJobId__c = JobId);
            updateAsyncJobIdProjectMap.put(projectId,project);
        }
        
        if(updateAsyncJobIdProjectMap.size() > 0)
        {
            SKIP_TRIGGER_EXECUTION = true;
            update updateAsyncJobIdProjectMap.values();
            SKIP_TRIGGER_EXECUTION = false;
        }
    }
    
}