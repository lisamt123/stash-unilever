/****************************************************************************************************************************
@Author Cognizant
@name IPM_ProjectQuestionnaireHelper
@CreateDate 20/08/2015
@Description Helper Class for Questionnaire Business Logic
@Version 1.0
@reference Project Document Section Content
*/
public with sharing class IPM_ProjectQuestionnaireHelper {
    // GateKeeper CheckList Record Type
    public static ID recTypeGK = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.GATEKEEPER_CHECKLIST_RECORD_TYPE).RecordTypeId;
    
    // RND and POS Record Type
    public static ID recTypeRnD = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RNDQUESTION_RECORD_TYPE).RecordTypeId;
    public static ID recTypeIDPOS = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
    
    // RQS and Corporate Risk(CR) Record Type 
    public static ID recTypeIDRQS = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RQS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
    public static ID recTypeIDCR = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.CORPORATE_RISK_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
    
    // R&D feasibility, Suppy Chain Feasibility and Risk Record Type 
    public static ID recTypeRnDFeasibility = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RNDFEASIBILITYQUESTION_RECORD_TYPE).RecordTypeId;
    public static ID recTypeSCFeasibility = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.SCFEASIBILITY_RECORD_TYPE).RecordTypeId;
    public static ID recTypeTradeMark = Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.TRADEMARK_RECORD_TYPE).RecordTypeId;
    /**************************************************************
    * @description: used to create Questionnaire when project is created.
    * @param1 projectSectionList : newly Created project Document SectionList
    * @param2 projectDocumentList : associated Project Document List
    * @param3 projectMap : Trigger.New projects Map
    */
    public static void manageQuestionnaire(List<IPM_Project_Document_Section__c> projectSectionList,List<IPM_Project_Document__c> projectDocumentList, Map<Id,IPM_Project__c> projectMap){   
        
        List<IPM_Questionnaire__c> insertQuestionnaireList = new List<IPM_Questionnaire__c>();
        
        /* To store GateKeeper Master  details */
        Map<String,List<IPM_Questionnaire__c>> gateToMasterCheckListMap = new Map<String,List<IPM_Questionnaire__c>>();
        
        /* To store R&D Master   questions */
        list<IPM_Questionnaire__c> rndMasterQuesList = new List<IPM_Questionnaire__c>();
        
        /* List to Store POS/RQS Master Question List*/
        Map<String,List<IPM_Questionnaire__c>> gateToPOSMasterQuestionMap = new Map<String,List<IPM_Questionnaire__c>>();               
        List<IPM_Questionnaire__c> rqsMasterQuestionList = new List<IPM_Questionnaire__c>();
        
        /* List to Store R&D Feasibility ,Supply Chain feasibility and Risk Master Question List*/
        Map<String,List<IPM_Questionnaire__c>> rndFeasibilityQuestionMap = new Map<String,List<IPM_Questionnaire__c>>();
        Map<String,List<IPM_Questionnaire__c>> scFeasibilityQuestionMap = new Map<String,List<IPM_Questionnaire__c>>();
        Map<String,List<IPM_Questionnaire__c>> tradeMarkQuestionMap = new Map<String,List<IPM_Questionnaire__c>>();
        
        /* List to Store Corporate Risk Master Question List*/
        List<IPM_Questionnaire__c> corporateRiskQuestionList = new List<IPM_Questionnaire__c>();
        
        if(projectMap != null && !projectMap.isEmpty())
        {
            for(IPM_Questionnaire__c questionnaireObj : IPM_ProjectHelper.masterQuestionnaireMap.values())
            {  
                String gateType = questionnaireObj.IPM_RQS_Gate_Type__c;
                
                if(questionnaireObj.RecordTypeId == recTypeGK )
                {
                    List<IPM_Questionnaire__c> tempQuestionare  = new List<IPM_Questionnaire__c>();
                    
                    if(gateType!=null && gateToMasterCheckListMap.containsKey(gateType))
                    {
                        tempQuestionare = gateToMasterCheckListMap.get(gateType);
                    }
                    tempQuestionare.add(questionnaireObj);
                    gateToMasterCheckListMap.put(gateType,tempQuestionare);
                    
                }
                else if(questionnaireObj.RecordTypeId == recTypeRnD)
                {
                    rndMasterQuesList.add(questionnaireObj);
                }
                else if(questionnaireObj.RecordTypeId == recTypeIDPOS)
                {
                    // Based on Gate
                    List<IPM_Questionnaire__c> posMasterQuestionList  = new List<IPM_Questionnaire__c>();
                    
                    if(gateType!=null && gateToPOSMasterQuestionMap.containsKey(gateType))
                    {
                        posMasterQuestionList = gateToPOSMasterQuestionMap.get(gateType);
                    }
                    posMasterQuestionList.add(questionnaireObj);
                    gateToPOSMasterQuestionMap.put(gateType,posMasterQuestionList);             
                }
                else if(questionnaireObj.RecordTypeId == recTypeIDRQS)
                {
                    rqsMasterQuestionList.add(questionnaireObj);
                }
                else if(questionnaireObj.RecordTypeId == recTypeRnDFeasibility)
                {
                    List<IPM_Questionnaire__c> rndFeasibilityList = new List<IPM_Questionnaire__c>();
                    
                    if(rndFeasibilityQuestionMap.containsKey(gateType))
                    {
                        rndFeasibilityList = rndFeasibilityQuestionMap.get(gateType);
                    }
                    rndFeasibilityList.add(questionnaireObj);
                    rndFeasibilityQuestionMap.put(gateType,rndFeasibilityList);
                } 
                else if(questionnaireObj.RecordTypeId == recTypeSCFeasibility)
                {
                    List<IPM_Questionnaire__c> SCFeasibilityQuestionList = new List<IPM_Questionnaire__c>();
                    
                    if(scFeasibilityQuestionMap.containsKey(gateType))
                    {
                        SCFeasibilityQuestionList = scFeasibilityQuestionMap.get(gateType);
                    }
                    SCFeasibilityQuestionList.add(questionnaireObj);
                    scFeasibilityQuestionMap.put(gateType,SCFeasibilityQuestionList);
                } 
                 else if(questionnaireObj.RecordTypeId == recTypeTradeMark)
                {
                    List<IPM_Questionnaire__c> TradeMarkQuestionList = new List<IPM_Questionnaire__c>();
                    
                    if(tradeMarkQuestionMap.containsKey(gateType))
                    {
                        TradeMarkQuestionList= tradeMarkQuestionMap.get(gateType);
                    }
                    TradeMarkQuestionList.add(questionnaireObj);
                    tradeMarkQuestionMap.put(gateType,TradeMarkQuestionList);
                } 
                else if(questionnaireObj.RecordTypeId == recTypeIDCR){
                    corporateRiskQuestionList.add(questionnaireObj);
                }
            }
            
            for(Id associatedProjectID : projectMap.keySet())
            {
                IPM_Project__c incomingProject = projectMap.get(associatedProjectID);
                Id parentProjectId = incomingProject.IPM_Parent_Project__c;
                IPM_Project_Type__c associatedProjectType =IPM_Utils.retrieveProjectType(incomingProject);
                
                if(associatedProjectType!=null)
                {
                    String projectCurrentGate = associatedProjectType.IPM_Gate_Document__c;
                    List<IPM_Questionnaire__c> addedQuestionareAtParent = new List<IPM_Questionnaire__c>();
                    
                    Boolean rndQuestionAlreadyExists = false;
                    Boolean posQuestionAlreadyExists = false;
                    Boolean rqsQuestionAlreadyExists = false;
                    Boolean rndFeasibilityQuestionAlreadyExists = false;
                    Boolean scFeasibilityQuestionAlreadyExists = false;
                    Boolean tradeMarkQuestionAlreadyExists = false;
                    Boolean corporateRiskQuestionAlreadyExists = false;
                    Boolean gkCheckListAlreadyExists = false;
                    
                    /* Creating R&D Questionnaires for Project */
                    if(IPM_ProjectHelper.projectMasterMap.containsKey(associatedProjectID) && IPM_ProjectHelper.projectMasterMap.get(associatedProjectID) !=null)
                    {
                        
                        if( IPM_ProjectHelper.DBprojectSpecificQuestionareMap.containsKey(associatedProjectID) && 
                                IPM_ProjectHelper.DBprojectSpecificQuestionareMap.get(associatedProjectID)!=null)
                        {
                            for(IPM_Questionnaire__c existingQuestionare : IPM_ProjectHelper.DBprojectSpecificQuestionareMap.get(associatedProjectID))
                            {
                                if(existingQuestionare.RecordTypeId == recTypeRnD)
                                {
                                    rndQuestionAlreadyExists = true;
                                }
                                else if(existingQuestionare.RecordTypeId == recTypeIDPOS && existingQuestionare.IPM_RQS_Gate_Type__c == projectCurrentGate)
                                {
                                    posQuestionAlreadyExists = true;
                                }
                                else if(existingQuestionare.RecordTypeId == recTypeIDRQS)
                                {
                                    rqsQuestionAlreadyExists = true;
                                } // Gate Specific (Contract)
                                else if(existingQuestionare.RecordTypeId == recTypeRnDFeasibility && existingQuestionare.IPM_RQS_Gate_Type__c == projectCurrentGate)
                                {
                                    rndFeasibilityQuestionAlreadyExists = true;
                                } // Gate Specific (Contract)
                                else if(existingQuestionare.RecordTypeId == recTypeSCFeasibility && existingQuestionare.IPM_RQS_Gate_Type__c == projectCurrentGate)
                                {
                                    scFeasibilityQuestionAlreadyExists = true;
                                } // Gate Specific (Contract)
                                else if(existingQuestionare.RecordTypeId == recTypeGK && existingQuestionare.IPM_RQS_Gate_Type__c == projectCurrentGate)
                                {
                                    gkCheckListAlreadyExists = true;
                                } 
                                else if(existingQuestionare.RecordTypeId == recTypeIDCR)
                                {
                                    corporateRiskQuestionAlreadyExists = true;
                                }
                                 else if(existingQuestionare.RecordTypeId == recTypeTradeMark && existingQuestionare.IPM_RQS_Gate_Type__c == projectCurrentGate)
                                {
                                tradeMarkQuestionAlreadyExists=true;
                                }
                                
                            }
                        }
                    }
                    
                    if(IPM_ProjectHelper.projectMasterMap.containsKey(parentProjectId) && IPM_ProjectHelper.projectMasterMap.get(parentProjectId) !=null)
                    {
                        
                        if(IPM_ProjectHelper.DBprojectSpecificQuestionareMap.containsKey(parentProjectId) && 
                                IPM_ProjectHelper.DBprojectSpecificQuestionareMap.get(parentProjectId)!=null)
                        {
                            for(IPM_Questionnaire__c existingQuestionare : IPM_ProjectHelper.DBprojectSpecificQuestionareMap.get(parentProjectId))
                            {
                                
                                if(incomingProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && projectCurrentGate == IPM_ConstantUtils.CONTRACT_GATE && 
                                        existingQuestionare.RecordTypeId == recTypeIDRQS && (existingQuestionare.IPM_Active_RQS__c || existingQuestionare.IPM_Is_Added_Question__c))
                                {
                                    addedQuestionareAtParent.add(existingQuestionare);
                                }
                                
                                if(incomingProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && projectCurrentGate == IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE &&
                                        existingQuestionare.RecordTypeId == recTypeIDRQS && (existingQuestionare.IPM_Active_RQS__c || existingQuestionare.IPM_Is_Added_Question__c) &&  
                                        existingQuestionare.IPM_Market_Deployment_Score__c>= IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE )
                                {
                                    addedQuestionareAtParent.add(existingQuestionare);
                                }
                            }
                        }
                    }
                    
                    // Generate CheckList is based on Gate Level and should be present for every Gate once.
                    if(!gkCheckListAlreadyExists && !gateToMasterCheckListMap.isEmpty())
                    {                                                   
                        if(gateToMasterCheckListMap.containsKey(projectCurrentGate) && gateToMasterCheckListMap.get(projectCurrentGate)!=null)
                        {
                            List<IPM_Questionnaire__c> gateKeeperCheckList = gateToMasterCheckListMap.get(projectCurrentGate);
                            insertQuestionnaireList.addAll(manageGateKeeperCheckList(projectSectionList,projectDocumentList,incomingProject,gateKeeperCheckList,projectCurrentGate));
                        }
                    }
                    
                    // RND Questionare is based on Project Level. Should be visible for Every project Just Once.(Includes Global,Regional,Local)
                    if(!rndQuestionAlreadyExists)
                    {
                        insertQuestionnaireList.addAll(generateProjectQuestionnaire(rndMasterQuesList,recTypeRnD,incomingProject));
                    }
                    
                    //  POS Question is applicable at Gate Level(Applies only for Charter Gate)
                    if(!posQuestionAlreadyExists && !gateToPOSMasterQuestionMap.isEmpty())
                    {
                        if(gateToPOSMasterQuestionMap.containsKey(projectCurrentGate) && gateToPOSMasterQuestionMap.get(projectCurrentGate)!=null)
                        {
                            List<IPM_Questionnaire__c> posMasterQuestionList = gateToPOSMasterQuestionMap.get(projectCurrentGate);
                            insertQuestionnaireList.addAll(generateProjectQuestionnaire(posMasterQuestionList,recTypeIDPOS,incomingProject));
                        }   
                    }
 
                    if(!rqsQuestionAlreadyExists && !insertQuestionnaireList.isEmpty())
                    {
                        insertQuestionnaireList.addAll(generateProjectQuestionnaire(rqsMasterQuestionList,recTypeIDRQS,incomingProject));
                        if(!addedQuestionareAtParent.isEmpty())
                        {
                            insertQuestionnaireList.addAll(generateProjectQuestionnaire(addedQuestionareAtParent,recTypeIDRQS,incomingProject));    
                        }
                    }
                    
                    if(!rndFeasibilityQuestionAlreadyExists && !rndFeasibilityQuestionMap.isEmpty())
                    {
                        if(rndFeasibilityQuestionMap.containsKey(projectCurrentGate) && rndFeasibilityQuestionMap.get(projectCurrentGate)!=null)
                        {
                            List<IPM_Questionnaire__c> RnDFeasibilityQuestionList = rndFeasibilityQuestionMap.get(projectCurrentGate);
                            insertQuestionnaireList.addAll(generateProjectQuestionnaire(RnDFeasibilityQuestionList,recTypeRnDFeasibility,incomingProject));
                        }
                    }
                    
                    if(!scFeasibilityQuestionAlreadyExists && !scFeasibilityQuestionMap.isEmpty())
                    {
                        if(scFeasibilityQuestionMap.containsKey(projectCurrentGate) && scFeasibilityQuestionMap.get(projectCurrentGate)!=null)
                        {
                            List<IPM_Questionnaire__c> SCFeasibilityQuestionList = scFeasibilityQuestionMap.get(projectCurrentGate);
                            insertQuestionnaireList.addAll(generateProjectQuestionnaire(SCFeasibilityQuestionList,recTypeSCFeasibility,incomingProject));
                        }
                    }
                    
                    
                    if(!tradeMarkQuestionAlreadyExists && !tradeMarkQuestionMap.isEmpty())
                    {
                        if(tradeMarkQuestionMap.containsKey(projectCurrentGate) && tradeMarkQuestionMap.get(projectCurrentGate)!=null)
                        {
                            List<IPM_Questionnaire__c> TradeMarkQuestionList = tradeMarkQuestionMap.get(projectCurrentGate);
                            insertQuestionnaireList.addAll(generateProjectQuestionnaire(TradeMarkQuestionList,recTypeTradeMark,incomingProject));
                        }
                    }
                    
                    if(!corporateRiskQuestionAlreadyExists && !corporateRiskQuestionList.isEmpty())
                    {
                        insertQuestionnaireList.addAll(generateProjectQuestionnaire(corporateRiskQuestionList,recTypeIDCR,incomingProject));
                    }
                }
            }   
            
            if(!insertQuestionnaireList.isEmpty())
            {
                insert insertQuestionnaireList;
            }
        }
    }
    
    /**************************************************************
    * @description: used to create GateKeeperCheckList when project is created.
    * @param1 projectSectionList : newly Created project Document SectionList
    * @param2 projectDocumentList : associated Project Document List
    * @param3 project : projectInContext
    * @param4 gateType : Project Gate Type
    */
    public static List<IPM_Questionnaire__c> manageGateKeeperCheckList(List<IPM_Project_Document_Section__c> projectSectionList,List<IPM_Project_Document__c> projectDocumentList, IPM_Project__c project,List<IPM_Questionnaire__c> gateKeepercheckListMaster,String gateType){
        
        list<IPM_Questionnaire__c> insertProjectGKCheckList = new List<IPM_Questionnaire__c>();
        
        // Get associated CheckList Questions.
        IPM_Project_Document__c gateSpecificProjectDocument = null;
        List<IPM_Project_Document_Section__c>   projectGateSpecificSections = new List<IPM_Project_Document_Section__c>();
        
        // Look into Currently saved Project Documents and find the Gate 
        for(IPM_Project_Document__c currentProjectDocument : projectDocumentList)
        {
            if(currentProjectDocument.IPM_GateDocuments__c == gateType && currentProjectDocument.IPM_Project__c == project.Id)
            {
                gateSpecificProjectDocument = currentProjectDocument;
                for(IPM_Project_Document_Section__c projectDocumentSection : projectSectionList)
                {
                    if(projectDocumentSection.IPM_Project_Document__c == gateSpecificProjectDocument.Id)
                    {
                        projectGateSpecificSections.add(projectDocumentSection);    
                    }   
                }
                break;   
            }
        }
        
        integer questionSequence=0;// introduced to accomodate differnt sequencing for Original and Operational Projects   
        for(IPM_Questionnaire__c gkQ : gateKeepercheckListMaster)
        {  
            for(IPM_Project_Document_Section__c projectDocumentSection : projectGateSpecificSections)
            {
               
               if(gkQ.IPM_Section_External_Id__c!=null && !String.isBlank(gkQ.IPM_Section_External_Id__c) && 
               projectDocumentSection.IPM_Master_Section_External_Id__c!=null && !String.isBlank(projectDocumentSection.IPM_Master_Section_External_Id__c) &&
                       gkQ.IPM_Section_External_Id__c.trim() == projectDocumentSection.IPM_Master_Section_External_Id__c.trim())
                {
                    if(!IPM_ProjectHelper.projectSectionMap.containsKey(projectDocumentSection.Id))
                    {
                      
                        questionSequence++; 
                        IPM_Questionnaire__c tempGKQ = new IPM_Questionnaire__c();
                        tempGKQ.IPM_Project__c = project.Id;
                        tempGKQ.IPM_Question_Help_Text__c = gkQ.IPM_Question_Help_Text__c;
                        tempGKQ.IPM_HelpText_Yes__c = gkQ.IPM_HelpText_Yes__c;
                        tempGKQ.IPM_HelpText_Partly__c = gkQ.IPM_HelpText_Partly__c;
                        tempGKQ.IPM_HelpText_No__c = gkQ.IPM_HelpText_No__c;              
                        tempGKQ.IPM_Question__c = gkQ.IPM_Question__c;
                        tempGKQ.IPM_RQS_Gate_Type__c = gateType;
                        tempGKQ.IPM_GK_Answers__c = gkQ.IPM_GK_Answers__c;
                        tempGKQ.RecordTypeId = recTypeGK;
                        tempGKQ.IPM_Sequence_Number__c =questionSequence; 
                        tempGKQ.IPM_Section_Sequence_Number__c = projectDocumentSection.IPM_Section_Sequence_Number__c; 
                        tempGKQ.IPM_Project_Document_Section__c = projectDocumentSection.Id;
                        tempGKQ.IPM_Section_External_Id__c= gkQ.IPM_Section_External_Id__c;                 
                        insertProjectGKCheckList.add(tempGKQ);
                    }
                    break;
                }
                
                if(gkQ.IPM_Section_External_Id__c==null)
               
                {
                  
                    if(!IPM_ProjectHelper.projectSectionMap.containsKey(projectDocumentSection.Id))
                    {
                      
                       questionSequence++;
                        IPM_Questionnaire__c tempGKQ = new IPM_Questionnaire__c();
                        tempGKQ.IPM_Project__c = project.Id;
                        tempGKQ.IPM_Question_Help_Text__c = gkQ.IPM_Question_Help_Text__c;
                        tempGKQ.IPM_HelpText_Yes__c = gkQ.IPM_HelpText_Yes__c;
                        tempGKQ.IPM_HelpText_Partly__c = gkQ.IPM_HelpText_Partly__c;
                        tempGKQ.IPM_HelpText_No__c = gkQ.IPM_HelpText_No__c;              
                        tempGKQ.IPM_Question__c = gkQ.IPM_Question__c;
                        tempGKQ.IPM_RQS_Gate_Type__c = gateType;
                        tempGKQ.IPM_GK_Answers__c = gkQ.IPM_GK_Answers__c;
                        tempGKQ.RecordTypeId = recTypeGK;
                        tempGKQ.IPM_Sequence_Number__c = questionSequence;
                        tempGKQ.IPM_Section_External_Id__c= gkQ.IPM_Section_External_Id__c;
                        insertProjectGKCheckList.add(tempGKQ);
                    }
                    break;
                }
                
                
              
            }
        }               
        return insertProjectGKCheckList;
    }
    
    /**************************************************************
    * @description: used to create specific Questionnaire records based on Record Type when project is created.
    * @param1 masterQuestionnaireList : master Questionnaire List
    * @param2 recordTypeId : Questionnaire Record Type
    * @param3 project : projectInContext
    */
    public static List<IPM_Questionnaire__c> generateProjectQuestionnaire(List<IPM_Questionnaire__c> masterQuestionnaireList,Id recordTypeId,IPM_Project__c project){    
        List<IPM_Questionnaire__c> projectQuestionareList = new List<IPM_Questionnaire__c>();    
        for(IPM_Questionnaire__c questionMasterObj : masterQuestionnaireList){
            IPM_Questionnaire__c tempQuestionare = new IPM_Questionnaire__c();
            tempQuestionare.IPM_Project__c = project.Id;
            tempQuestionare.IPM_Question__c = questionMasterObj.IPM_Question__c;
            tempQuestionare.RecordTypeId = recordTypeId;
            tempQuestionare.Is_Master__c=false;
            tempQuestionare.IPM_HelpText_Yes__c = questionMasterObj.IPM_HelpText_Yes__c;
            tempQuestionare.IPM_HelpText_No__c = questionMasterObj.IPM_HelpText_No__c;
            tempQuestionare.IPM_HelpText_Partly__c = questionMasterObj.IPM_HelpText_Partly__c;               
            tempQuestionare.IPM_HelpText_Five__c = questionMasterObj.IPM_HelpText_Five__c;    
            tempQuestionare.IPM_Question_Help_Text__c = questionMasterObj.IPM_Question_Help_Text__c;
            tempQuestionare.IPM_RQS_Gate_Type__c = questionMasterObj.IPM_RQS_Gate_Type__c;        
            
            if(recordTypeId == recTypeRnDFeasibility || recordTypeId == recTypeSCFeasibility  || recordTypeId == recTypeRnD ||recordTypeId==recTypeGK || recordTypeId==recTypeTradeMark)
            {
                tempQuestionare.IPM_GK_Answers__c = questionMasterObj.IPM_GK_Answers__c;    
            }
            else if(recordTypeId == recTypeIDCR)
            {                   
                tempQuestionare.IPM_Sequence_Number__c = questionMasterObj.IPM_Sequence_Number__c;
                tempQuestionare.IPM_Active_RQS__c=true;
            }               
            else if(recordTypeId == recTypeIDPOS)
            {
                tempQuestionare.IPM_Sequence_Number__c = questionMasterObj.IPM_Sequence_Number__c;
                tempQuestionare.IPM_POS_Question_Type__c = questionMasterObj.IPM_POS_Question_Type__c;
                tempQuestionare.IPM_Show_Create_Link__c=true;   
            }
            else if(recordTypeId == recTypeIDRQS)
            {           
                tempQuestionare.IPM_Sequence_Number__c = questionMasterObj.IPM_Sequence_Number__c;
                tempQuestionare.IPM_RQS_Question_Type__c = questionMasterObj.IPM_RQS_Question_Type__c;
                tempQuestionare.IPM_Score__c = questionMasterObj.IPM_Score__c;
                tempQuestionare.IPM_Comments__c = questionMasterObj.IPM_Comments__c;
                tempQuestionare.IPM_Is_Added_Question__c = questionMasterObj.IPM_Is_Added_Question__c;
                tempQuestionare.IPM_Active_RQS__c = questionMasterObj.IPM_Active_RQS__c;
                tempQuestionare.IPM_Charter_Comments__c= questionMasterObj.IPM_Charter_Comments__c;
                tempQuestionare.IPM_Charter_Score__c= questionMasterObj.IPM_Charter_Score__c;
                tempQuestionare.IPM_Contract_Comments__c= questionMasterObj.IPM_Contract_Comments__c;
                tempQuestionare.IPM_Contract_Score__c= questionMasterObj.IPM_Contract_Score__c;
                tempQuestionare.IPM_Market_Deployment_Comments__c= questionMasterObj.IPM_Market_Deployment_Comments__c;
                tempQuestionare.IPM_Market_Deployment_Score__c= questionMasterObj.IPM_Market_Deployment_Score__c;
                tempQuestionare.IPM_Market_Ready_Comments__c= questionMasterObj.IPM_Market_Ready_Comments__c;
                tempQuestionare.IPM_Market_Ready_Score__c= questionMasterObj.IPM_Market_Ready_Score__c;
            }
           
            projectQuestionareList.add(tempQuestionare);
        }  
        return projectQuestionareList;
    }
}