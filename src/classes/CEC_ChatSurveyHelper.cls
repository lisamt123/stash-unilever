/***********************************************************************************
Name:  CEC_ChatSurveyHelper
Copyright@: 2016  Unilever
====================================================================================
====================================================================================
Purpose: Helper class for the chat Survey link to the cases.                                                                                            

=====================================================================================
=====================================================================================
History                                                            
-------                                                            
VERSION    AUTHOR                       DATE            DETAIL                   
1.0      Goverdhan & Sathish            Feb-2016      Initial Development.   
*************************************************************************************/
public class CEC_ChatSurveyHelper {

    /******************************************************************* 
        Purpose: 
            Get all the LiveChatTranscripts for the chatKeys and update the AdditionalCaseInfo
        Parameters: 
            surveyRecords - Additional Case Info object which has survey details.
        Exception : 
            Exception is handled in the parent calling class.
    ********************************************************************/
	public void fetchAndUpdateSurveyRecords(List<cec_Additional_Case_Information__c> surveyRecords) {
        System.debug('Entering fetchAndUpdateSurveyRecords() method. surveyRecords = ' + surveyRecords);

        Set<String> chatKeys = new Set<string>();
        Map<String, String> chatKeyToCaseIdMap = new Map<string,string>();
    
        for(cec_Additional_Case_Information__c  survey :surveyRecords){
            chatKeys.add(survey.ChatKey__c);
        }
        for(LiveChatTranscript ct : [SELECT id, CaseId, ChatKey 
                                    FROM LiveChatTranscript 
                                    WHERE ChatKey IN :chatKeys]){
            System.debug('Chat Transcript = ' + ct);
            if(ct.caseId != null){
                chatKeyToCaseIdMap.put(ct.ChatKey, ct.CaseId);
            }
        }
        if (!chatKeyToCaseIdMap.isEmpty()) {
            System.debug('chatKeyToCaseIdMap = ' + chatKeyToCaseIdMap);        
            for(cec_Additional_Case_Information__c  survey :surveyRecords){
                survey.Case__c = chatKeyToCaseIdMap.get(survey.ChatKey__c);
            }  
            update(surveyRecords);
        }
        System.debug('Exiting fetchAndUpdateSurveyRecords() method. surveyRecords = ' + surveyRecords);
	}
}