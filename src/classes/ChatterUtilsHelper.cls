/****************************************************************************************************************************************
    * @Author : Cognizant
    * @Name ChatterUtilsHelper
    * @CreatedDate 9-10-2015
    * @Version 1.0
    * @Description This class contains helper method for the class IPM_ProjectCountryDetails for creating chatterPost
    * @Referenced: IPM_ProjectCountryDetails.IPM_ProjectCountryDetails
******************************************************************************/



public with sharing class ChatterUtilsHelper {
	
	private static final string INSERT_EVENT = 'Insert';
	private static final string DELETE_EVENT = 'Delete';
	private static final string IPM_ROLE_TYPE_RD = IPM_ConstantUtils.IPM_ROLE_RD;
	
	/****************************************************************************
    @Description : create map of the project Id and the chatter message to be posted about countries added/deleted from the project
    @Params insertedCountries:  The list of countries upserted or deleted through trigger  
    @Params operation:   To distinguish if the operation is delete from trigger      
    *****************************************************************************/
	public static Map<Id,String> getprojIdchatterMessageMap(Map<String,String> projIdAffectedCountriesMap, String operation) {
		Map<Id,String> projIdchatterMessageMap = new Map<Id,String>();
		for(Id projectId: projIdAffectedCountriesMap.keySet()){
			if( INSERT_EVENT.equalsIgnoreCase(operation) && projIdAffectedCountriesMap.get(projectId).containsNone(';')){
				projIdchatterMessageMap.put( projectId, ' '+label.IPM_EcoDesign_Country_Added+' '+projIdAffectedCountriesMap.get(projectId)); 
			}
			else if( INSERT_EVENT.equalsIgnoreCase(operation) && projIdAffectedCountriesMap.get(projectId).contains(';')){
				projIdchatterMessageMap.put( projectId, ' '+label.IPM_EcoDesign_Countries_Added+' '+projIdAffectedCountriesMap.get(projectId));
			}
			else if( DELETE_EVENT.equalsIgnoreCase(operation) && projIdAffectedCountriesMap.get(projectId).containsNone(';')){
				projIdchatterMessageMap.put( projectId, ' '+label.IPM_EcoDesign_Country_Deleted+' '+projIdAffectedCountriesMap.get(projectId));
			}
			else if( DELETE_EVENT.equalsIgnoreCase(operation) && projIdAffectedCountriesMap.get(projectId).contains(';')){
				projIdchatterMessageMap.put( projectId, ' '+label.IPM_EcoDesign_Countries_Deleted+' '+projIdAffectedCountriesMap.get(projectId));
			}
		}

		if(projIdchatterMessageMap!=null && !projIdchatterMessageMap.isEmpty()){
			return projIdchatterMessageMap;
		}
		else{
			return null;
		}
	}
	
	
	/****************************************************************************
    @Description : create map of the project Id and Ids of the Lead R&D Project Resources
    @Params projIdMembersListMap:  Map of Project Id and It's Project Resources     
    *****************************************************************************/
	public static Map<Id,Set<Id>> fetchProjIdLeadRnDMemberIdSetMap(Map<Id,List<IPM_Project_Resource__c>> projIdMembersListMap){
		Map<Id,Set<Id>> subjectIdMentionIdSetMap = new Map<Id,Set<Id>>();
		set<Id> projResIdSet = new Set<Id>();
		if(projIdMembersListMap!=null && !projIdMembersListMap.isEmpty()){
			for(Id projId : projIdMembersListMap.keySet() ){
				for(IPM_Project_Resource__c ipr: projIdMembersListMap.get(projId)){
					if((IPM_ROLE_TYPE_RD.equalsIgnoreCase(ipr.IPM_Role_Type__c) || IPM_ROLE_TYPE_RD.equalsIgnoreCase(ipr.IPM_Role__c)) && ipr.IPM_User__c != null && ipr.IPM_Project_Role_Owner__c){		
						projResIdSet.add(ipr.IPM_User__c);
					}
				}
				subjectIdMentionIdSetMap.put(projId,projResIdSet);
			}
		}
		
		if(subjectIdMentionIdSetMap!=null &&!subjectIdMentionIdSetMap.isEmpty()){
			return subjectIdMentionIdSetMap;
		}
		else{
			return null;
		}
	}
}