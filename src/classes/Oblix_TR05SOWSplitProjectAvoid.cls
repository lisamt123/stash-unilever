/**
    About
    -----
    Description: Class Oblix_TR05SOWSplitProjectAvoid
    Created for: Oblix Unilever Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : Used as a fired class from Trigger "" to avoid having more than 100% on split
                  		
            Functionnalities : 
                    
    Update History
    --------------    
*/
public with sharing class Oblix_TR05SOWSplitProjectAvoid {
	  
	public static void SOWSplitProjectAvoid(List<Oblix_Marketing_SOW_Project_Splits__c> lstSplitProject){
		set<Id> setProjectIds = new set<Id>();
		List<Oblix_SOW_Projects__c> lstProjects = new List<Oblix_SOW_Projects__c>();
		Map<Id, Decimal> MapProjectToPercentage = new Map<Id, Decimal>();
		
		for(Oblix_Marketing_SOW_Project_Splits__c split : lstSplitProject){
			setProjectIds.add(split.Project_Splits__c);
		}
		lstProjects = [Select Id, Name, (Select Id, Name, Project_Splits__c, Percentage__c from Marketing_SOW_Project_Splits__r) from Oblix_SOW_Projects__c where id in : setProjectIds];
		  
		//List<Oblix_Marketing_SOW_Project_Splits__c> lstSplitsByProject = [Select Id, Name, Project_Splits__c from Oblix_Marketing_SOW_Project_Splits__c where Project_Splits__c in : setProjectIds];
		if(lstProjects.size()>0){
			for(Oblix_SOW_Projects__c project : lstProjects){
				if(project.Marketing_SOW_Project_Splits__r.size()>0){
					Decimal tmp_percentageSplit = 0;
					for(Oblix_Marketing_SOW_Project_Splits__c split : project.Marketing_SOW_Project_Splits__r){
						tmp_percentageSplit += split.Percentage__c;
					}
					if(!MapProjectToPercentage.containsKey(project.Id)){
						MapProjectToPercentage.put(project.Id, tmp_percentageSplit);
					}
				}
				
			}
		}
		set<Id> setProjectIdsComment = new set<Id>();
		//Loop Over the Splits and Avoid Insert or Update if the Percentage is Above > 100%
		for(Oblix_Marketing_SOW_Project_Splits__c split : lstSplitProject){
			if(MapProjectToPercentage.get(split.Project_Splits__c) != null){
				if(MapProjectToPercentage.get(split.Project_Splits__c) > 100){
					split.AddError('Total Percentage for that project exceeded 100%, please lower it');
				}else if(MapProjectToPercentage.get(split.Project_Splits__c) < 100){
					//split.AddError('Total Percentage for that project is below 100%, please raise it');
					//split.Project_Splits__r.OblixProjectSplitPercentage_Comment__c = 'Total Percentage for that project is below 100%, please raise it';
					setProjectIdsComment.add(split.Project_Splits__c);
					
				}
			}
		}
		
		for(Oblix_SOW_Projects__c proj : lstProjects){
			proj.OblixProjectSplitPercentage_Comment__c = '';
			for(Id idProj : setProjectIdsComment){
				if(proj.Id == idProj){
					proj.OblixProjectSplitPercentage_Comment__c = 'Total Percentage for that project is below 100%, please raise it';
				}
			}
		}
		if(lstProjects.size()>0) update lstProjects;
	}
}