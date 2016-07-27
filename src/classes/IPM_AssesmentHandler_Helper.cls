/****************************************************************************************************************************************
    * @Author : Cognizant
    * @Name IPM_AssesmentHandler_Helper
    * @CreatedDate 9-10-2015
    * @Version 1.0
    * @Description This class facilitates the operation required by Assessment Handler. Required during insert of Assessment data
    * @Referenced: IPM_AssesmentHandler
******************************************************************************/

public with sharing class IPM_AssesmentHandler_Helper {
    public static Boolean SKIP_TRIGGER_EXECUTION = false;
    /****************************************************************************
    @Description : Delete existing assessments for the project and the country (Overloaded method)
    @Params ProjectIdSet:  Set of project Ids associated with incoming countries
    @Params countryIdSet : Set of country Ids associated with incoming countries 
    *****************************************************************************/
    public static void deleteAssociatedAssesments( Map<Id,String> projIdPhaseMapIncoming, Set<String> AssmntBatchIdSet){
        Set<Id> projectIdSet = projIdPhaseMapIncoming.keySet();
        List<IPM_Assessment__c> probableAssesmentsToDelete =  [Select id,Project_Phase__c,IPM_Project__c from IPM_Assessment__c Where IPM_Project__c IN : projectIdSet AND Assessment_Batch_ID__c NOT IN :AssmntBatchIdSet LIMIT 50000];
        List<IPM_Assessment__c> assesmentsToDelete = new List<IPM_Assessment__c>();
        
        //find assessments which have the same assessment as the incoming assessments and batch Id does not match
        if(probableAssesmentsToDelete != null && !probableAssesmentsToDelete.isEmpty()){
            for(IPM_Assessment__c probAssessment : probableAssesmentsToDelete ){
                if(probAssessment.IPM_Project__c != null && String.isNotBlank(probAssessment.Project_Phase__c) && probAssessment.Project_Phase__c.equalsIgnoreCase(projIdPhaseMapIncoming.get(probAssessment.IPM_Project__c))){
                    assesmentsToDelete.add(probAssessment);
                }
            }
        }
        
        //delete the assessments
        if(assesmentsToDelete != null && !assesmentsToDelete.isEmpty()){
            delete assesmentsToDelete;
        }
    }
    
    
    /****************************************************************************
    @Description : Delete existing assessments for the deleted Countries (Overloaded method)
    @Params deletedCountries:  the trigger.old countries in trigger.before context
    *****************************************************************************/
    public static void deleteAssociatedAssesments( List<IPM_Country__c> deletedCountries){
        Set<Id> countryIdSet = (new Map<Id,IPM_Country__c>(deletedCountries)).keySet();
        List<IPM_Assessment__c> assesmentsToDelete =  [Select id,Project_Phase__c,IPM_Project__c from IPM_Assessment__c Where IPM_Country__c IN:countryIdSet LIMIT 50000];
        
        if(assesmentsToDelete != null && !assesmentsToDelete.isEmpty()){
            delete assesmentsToDelete;
        }
    }
    
    /****************************************************************************
    @Description : Inserting the incoming assessments and the processing related to it (Delete previous assessments & if any error send mail to Lead R&D)
    @Params incomingAssessments:  the assessment records being inserted.
    *****************************************************************************/
    public static void insertAssessments(List<IPM_Assessment__c> incomingAssessments){
        Map<Id,String> projIdPhaseMapIncoming =  new Map<Id,String>();
        Map<Id,IPM_Project__c> ipmProjectIdProjectMap = new Map<Id,IPM_Project__c>();
        Map<Id,List<IPM_Country__c>> projIdCountryListMap = new Map<Id,List<IPM_Country__c>>();
        Map<Id, Set<String>> projIdCountryIdsMap = new Map<Id, Set<String>>();
        Boolean foundAssmntDataForDiffProjPhases = FALSE;
        Boolean foundIncorrectProjForCountry = FALSE;
        Set<String> AssmntBatchIdSet = new Set<String>();
        
        
        
        //check if all the assessments for all the respective projects have the same phase
        for(IPM_Assessment__c assessment: incomingAssessments ){
            if(String.isNotBlank(assessment.Assessment_Batch_ID__c)){
                AssmntBatchIdSet.add(assessment.Assessment_Batch_ID__c);
            }
            
            if(!projIdPhaseMapIncoming.containsKey(assessment.IPM_Project__c)){
                projIdPhaseMapIncoming.put(assessment.IPM_Project__c, assessment.Project_Phase__c);
                
            }
            else if(projIdPhaseMapIncoming.containsKey(assessment.IPM_Project__c) && assessment.Project_Phase__c != null){
                if(!projIdPhaseMapIncoming.get(assessment.IPM_Project__c).equalsIgnoreCase(assessment.Project_Phase__c)){
                    foundAssmntDataForDiffProjPhases = TRUE;
                }
                
            }
        }

         if(projIdPhaseMapIncoming != null && !projIdPhaseMapIncoming.isEmpty()){
            //make changes in the incoming record (currently finding the country Id form the country name)
            sanitizeRecords(incomingAssessments,projIdPhaseMapIncoming.keySet());
         }   
        
        
        //check if the assessments for the project have the same phase as the IPM project phase
        if(projIdPhaseMapIncoming != null && !projIdPhaseMapIncoming.isEmpty()){
            ipmProjectIdProjectMap = new Map<Id,IPM_Project__c>([Select Id,IPM_Phase__c,Name from IPM_Project__c where Id IN:projIdPhaseMapIncoming.keySet() LIMIT 50000 ]);
            for(Id projectId: projIdPhaseMapIncoming.keySet()){
                
                if(ipmProjectIdProjectMap.containsKey(projectId) && projIdPhaseMapIncoming.containsKey(projectId) && ipmProjectIdProjectMap.get(projectId).IPM_Phase__c!=null && !(ipmProjectIdProjectMap.get(projectId).IPM_Phase__c.equalsIgnoreCase(projIdPhaseMapIncoming.get(projectId)))){    
                    foundAssmntDataForDiffProjPhases = TRUE;
                }
            }
        }

        
        //check if the country in assessment is mapped to correct project
        projIdCountryListMap = IPM_ProjectCountryDetails.getProjectIdCountryListMap(projIdPhaseMapIncoming.keySet());

        if(projIdCountryListMap != null && !projIdCountryListMap.isEmpty()){
            
            for(Id projId : projIdCountryListMap.keySet()){
                for(IPM_Country__c country : projIdCountryListMap.get(projId)){
                    if(!projIdCountryIdsMap.containsKey(projId)){
                        projIdCountryIdsMap.put(projId, new Set<String>{country.Id});
                    }
                    else{
                        projIdCountryIdsMap.get(projId).add(country.Id);
                    }
                }
            }
            
           
            for(IPM_Assessment__c assmnt: incomingAssessments){
                if(!(projIdCountryIdsMap.get(assmnt.IPM_Project__c).contains(assmnt.IPM_country__c))){
                    foundIncorrectProjForCountry = TRUE;
                }
            }
        }
        
         
        //if an error found in incoming data then error out all the incoming assessment data
        if(foundAssmntDataForDiffProjPhases || foundIncorrectProjForCountry){
            
            for(IPM_Assessment__c assessment: incomingAssessments){
                if(foundAssmntDataForDiffProjPhases && foundIncorrectProjForCountry ){
                    assessment.addError(new TriggerException(Label.IPM_EcoDesign_Assesment_Data_Wrong_Country_Phase));
                   }
                else if(foundAssmntDataForDiffProjPhases && !foundIncorrectProjForCountry){
                    assessment.addError(new TriggerException(Label.IPM_EcoDesign_Assesment_Data_Wrong_Phase));
                    }
                else if(!foundAssmntDataForDiffProjPhases && foundIncorrectProjForCountry){
                    assessment.addError(new TriggerException(Label.IPM_EcoDesign_Assesment_Data_Wrong_Country));
                    }
                    
            } 
            
        }
        
        else{
            //before inserting delete the old assessments for the same phase, same project and same country
            deleteAssociatedAssesments(projIdPhaseMapIncoming,AssmntBatchIdSet);
            
        }   
    }
    
   
    /****************************************************************************
    @Description : Sanitize the records to be inserted. (Fetch country Id from country name...more actions to be added as and when the class is updated)
    @Params assessments:  List of assessment records to be sanitized
    *****************************************************************************/
    public static void sanitizeRecords(List<IPM_Assessment__c> assessments, Set<Id> projectIdSet){
        if(assessments != null && !assessments.isEmpty() && projectIdSet != null && !projectIdSet.isEmpty()){
            
            //fetch map of project Id and its countries
            Map<Id,List<IPM_Country__c>> projectIdCountryListMap = IPM_ProjectCountryDetails.getProjectIdCountryListMap(projectIdSet);
            
            if(projectIdCountryListMap != null && !projectIdCountryListMap.isEmpty()){
                //loop over the projects
                for(Id projectId: projectIdCountryListMap.keySet()){
                    //loop over assessments
                    for(IPM_Assessment__c assmnt :assessments ){
                        //if assessment belongs to same poject then loop over the countries of the project 
                        if(assmnt.IPM_Project__c == projectId && projectIdCountryListMap.get(projectId) != null && !projectIdCountryListMap.get(projectId).isEmpty()){
                            //loops over the list of countries
                            for(IPM_Country__c country:projectIdCountryListMap.get(projectId) ){
                                if(String.isNotBlank(String.valueOf(assmnt.IPM_Country_Name__c))&& String.isNotBlank(String.valueOf(country.Country_Name__c)) && assmnt.IPM_Country_Name__c == country.Country_Name__c){
                                    assmnt.IPM_Country__c = country.Id;
                                }
                            }
                        }
                    }
                }
            }
    
        }
    }
    
    
    
    /****************************************************************************
    @Description : clone the assessments from during phase change -- from one document to anothers based on business logic defined in custom setting IPM_Project_Type
    @Params incomingProjectsWithChangedPhase:  List of projects whose phase has changed
    @Params oldProjectsMap:  Trigger.Old values
    *****************************************************************************/
    public static void copyOverAssessments(List<IPM_Project__c> incomingProjectsWithChangedPhase, Map<Id, IPM_Project__c> oldProjectsMap){
         
        if(incomingProjectsWithChangedPhase == null || incomingProjectsWithChangedPhase.isEmpty())
        {
        	return;
        }
        Map<Id,String> projectIdPhaseMap = new Map<Id,String>();
        Map<Id,String> projectIdOldPhaseMap = new Map<Id,String>();
        List<IPM_Assessment__c> actualAssesmentsToCopy =  new List<IPM_Assessment__c>();
            
        //use the custom setting IPM_Project_Type to find if the assessments are to be copied over to the next phase for the projects
        for(IPM_Project__c project :incomingProjectsWithChangedPhase){
            if(IPM_Utils.retrieveProjectType(project) != null) {         
                if(IPM_Utils.retrieveProjectType(project).IPM_Copy_Over_Assessments__c){
                    projectIdPhaseMap.put(project.Id, project.IPM_Phase__c);
                    projectIdOldPhaseMap.put(project.Id, oldProjectsMap.get(project.Id).IPM_Phase__c);
                }
            }
        }
        
        if(projectIdPhaseMap != null && !projectIdPhaseMap.isEmpty() && projectIdOldPhaseMap != null && !projectIdOldPhaseMap.isEmpty()){
            Set<Id> projectIdSet = projectIdPhaseMap.keySet();
            
            String queryStr = '';
            queryStr = IPM_Utils.prepareSOQLQuery('IPM_Assessment__c', false, null,true);
            queryStr += ' Where IPM_Project__c IN:projectIdSet';
            
            //find all the assessments which are required to be copied over
            List<IPM_Assessment__c> probableAssesmentsToCopy = Database.Query(queryStr);
            
            for(IPM_Assessment__c probableAssessment : probableAssesmentsToCopy){
                if(probableAssessment.IPM_Project__c != null && probableAssessment.Project_Phase__c == (String)projectIdOldPhaseMap.get(probableAssessment.IPM_Project__c)){
                    actualAssesmentsToCopy.add(probableAssessment);
                }
            }
        }
        
        
        //clone the assessment and set the phase as the next phase
       cloneAndInsertAssessments(actualAssesmentsToCopy,projectIdPhaseMap);
        
    }
    
    public static void cloneAndInsertAssessments(List<IPM_Assessment__c> actualAssesmentsToCopy,Map<Id,String>projectIdPhaseMap)
    {
    	
         List<IPM_Assessment__c> assessmentsCloned =  new List<IPM_Assessment__c>();
    	 if(actualAssesmentsToCopy != null && !actualAssesmentsToCopy.isEmpty()){
            
            for(IPM_Assessment__c assessmentToCopy : actualAssesmentsToCopy){
                IPM_Assessment__c assessment = assessmentToCopy.clone(false, true, false, true);
                assessment.Name = assessmentToCopy.Name;
                assessment.Project_Phase__c = projectIdPhaseMap.get(assessment.IPM_Project__c);
                assessmentsCloned.add(assessment);
            }
        }
        
        //insert the cloned assessments
        if(!assessmentsCloned.isEmpty()){
            Insert assessmentsCloned;
        }
        
    }
    
    /****************************************************************************
    @Description : Sanitize the records to be inserted. (Fetch country Id from country name...more actions to be added as and when the class is updated)
    @Params assessments:  List of assessment records to be sanitized
    *****************************************************************************/
    public static void checkAtLeastOneAssmntPerEICountry(List<IPM_Assessment__c> assessmentsInsertedDeleted){
        Set<Id> projIdSet = new Set<Id>();
        for(IPM_Assessment__c assmnt : assessmentsInsertedDeleted){
            projIdSet.add(assmnt.IPM_Project__c);
        }
        if(projIdSet != null && !projIdSet.isEmpty()){
            IPM_ProjectCountryDetails.checkAtLeastOneAssmntPerEICountry(projIdSet);
        }
        
    }

}