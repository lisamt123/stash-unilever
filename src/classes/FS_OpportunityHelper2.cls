/**********************************************************************
Purpose: Helper class for Opportunity for the Food Solution (NAFS).
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture      1/Aug/2016     Draft                     
***********************************************************************/

public with sharing class FS_OpportunityHelper2{
    
    public static void sharingOpportunityWithDistributorOwner(List<Opportunity> newListOpportunity){
    	/*Set<Id> distributorSetId = new Set<Id>();
    	Set<Id> opportunitySetId = new Set<Id>();
    	Id opportunityRecordTypeId;     	
    	List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
    	
    	
    	opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('UFS Opportunity Russia').getRecordTypeId();
    	
    	for (Opportunity opp: newListOpportunity){
    		if(opp.FS_distributor__c <> null && opp.RecordTypeId == opportunityRecordTypeId){
    			distributorSetId.add(opp.FS_distributor__c);
    			opportunitySetId.add(opp.Id);
    		}
    	}
    	
    	Map<Id, Opportunity> opportunityDistributorMap = 
    			new Map<Id, Opportunity>([SELECT Id, FS_distributor__r.OwnerId
    									FROM Opportunity 
    									WHERE FS_distributor__c = :distributorSetId
    									AND Id = :opportunitySetId]);
		System.debug('opportunityDistributorMap --------------->' + opportunityDistributorMap);				
		
		for (Opportunity opp: newListOpportunity){
			if(opp.FS_distributor__c <> null && opp.RecordTypeId == opportunityRecordTypeId){
				OpportunityTeamMember otm = new OpportunityTeamMember();
				otm.OpportunityId = opp.Id;
				otm.OpportunityAccessLevel = 'Read';
				otm.UserId = opportunityDistributorMap.get(opp.Id).FS_Distributor__r.OwnerId;
				otm.TeamMemberRole = 'Distributor Account Owner';
				opportunityTeamMemberList.add(otm);
			}
		}
		System.debug(' after update ---->>>>' + opportunityTeamMemberList);    									
		Database.SaveResult[] result = Database.insert(opportunityTeamMemberList, false);
		System.debug(' after result ---->>>>' + result);*/					    									   
    }   
    
    public static void createOpportunityTeamMember(List<Opportunity> newOpportunityList, Map<Id, Opportunity> oldOpportunityMap){
    	/*Set<Id> distributorSetId = new Set<Id>();
    	Set<Id> opportunitySetId = new Set<Id>();
    	List<Opportunity> updatedOpportunityList = new List<Opportunity>();
    	Map<Id, OpportunityTeamMember> existingOTMMap = new Map<Id, OpportunityTeamMember>();
    	List<OpportunityTeamMember> oldOpportunityTeamMember = new List<OpportunityTeamMember>();
    	List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
    	
    	Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('UFS Opportunity Russia').getRecordTypeId();
    	
    	for (Opportunity opp: newOpportunityList){
    		if(opp.FS_distributor__c <> null 
				&& opp.RecordTypeId == opportunityRecordTypeId 
				&& oldOpportunityMap.get(opp.id).OwnerId == opp.OwnerId){
		    				distributorSetId.add(opp.FS_distributor__c);
		    				opportunitySetId.add(opp.Id);
		    				updatedOpportunityList.add(opp);
		    	}
    	}
    	
    	Map<Id, Opportunity> opportunityDistributorMap = 
    			new Map<Id, Opportunity>([SELECT Id, FS_distributor__r.OwnerId
    									FROM Opportunity 
    									WHERE FS_distributor__c IN :distributorSetId
    									AND Id IN :opportunitySetId]);
		System.debug('opportunityDistributorMap --------------->' + opportunityDistributorMap);				
		
		for(OpportunityTeamMember otm : [SELECT Id, OpportunityId, UserId
																FROM OpportunityTeamMember
																WHERE OpportunityId IN :opportunitySetId
																AND TeamMemberRole = 'Distributor Account Owner']){
						
					existingOTMMap.put(otm.OpportunityId, otm);
										
			} 
		
		System.debug('existingOTMMap --------------->' + existingOTMMap);
		for (Opportunity opp: updatedOpportunityList){
			System.debug('Details  --------------->' +existingOTMMap);
			System.debug('Details  --------------->' +opportunityDistributorMap.get(opp.Id).FS_Distributor__r.OwnerId);
			
			if(existingOTMMap.containsKey(opp.Id)){ 
				System.debug('existingOTMMap.containsKey(opp.Id) condition --------------->');
				if (existingOTMMap.get(opp.Id).UserId <> opportunityDistributorMap.get(opp.Id).FS_Distributor__r.OwnerId ){
					System.debug('first condition --------------->');
					
					oldOpportunityTeamMember.add(existingOTMMap.get(opp.Id));
					OpportunityTeamMember otm = new OpportunityTeamMember();
					otm.OpportunityId = opp.Id;
					otm.OpportunityAccessLevel = 'Read';
					otm.UserId = opportunityDistributorMap.get(opp.Id).FS_Distributor__r.OwnerId;
					otm.TeamMemberRole = 'Distributor Account Owner';
					opportunityTeamMemberList.add(otm);
				}
			}else{
					System.debug('existingOTMMap.containsKey(opp.Id) ELSE --------------->');
					OpportunityTeamMember otm = new OpportunityTeamMember();
					otm.OpportunityId = opp.Id;
					otm.OpportunityAccessLevel = 'Read';
					otm.UserId = opportunityDistributorMap.get(opp.Id).FS_Distributor__r.OwnerId;
					otm.TeamMemberRole = 'Distributor Account Owner';
					opportunityTeamMemberList.add(otm);
			}
			
		}
		System.debug(' after update ---->>>>' + opportunityTeamMemberList);
		System.debug(' after update oldOpportunityTeamMember ---->>>>' + oldOpportunityTeamMember);
		
		Database.DeleteResult[] deleteResult = Database.delete(oldOpportunityTeamMember, false);    									
		Database.SaveResult[] result = Database.insert(opportunityTeamMemberList, false);
		
		System.debug(' after deleteResult ---->>>>' + deleteResult);
		System.debug(' after result ---->>>>' + result);
    */	
    }
}