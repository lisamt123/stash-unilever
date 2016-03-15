/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimateUpdate
@CreateDate : 2/10/2014
@Description : This is a batch class to update the brandestimate records when trigger date in custom setting is equal's today date
@Version : 1.0
@reference : none
****************************************************************************************************************************/
global with sharing class AF_BrandEstimateUpdate implements Database.Batchable<sObject>{
	global string query = 'Select Id, Name, AF_Status_Base_Fees__c from AF_Brand_Estimate__c where Base_Fee_Total__c=0 and AF_Status_Base_Fees__c=\'Initiate\' and AF_Active__c=true';
	//Constructor
	global AF_BrandEstimateUpdate(){
	}
	global Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext bc,list<AF_Brand_Estimate__c> brandEstimateList){
		AF_AgencyDate__c aD = AF_AgencyDate__c.getOrgDefaults();
		if(aD != null && aD.Agency_Trigger_Date__c == system.today()){
			if(brandEstimateList != null && !brandEstimateList.isEmpty()){
				for(AF_Brand_Estimate__c be : brandEstimateList){
					be.AF_Status_Base_Fees__c='With Agency';
				}
			}
			try{
				update brandEstimateList;
			}catch(exception e){
				system.debug('***Exception Message-->'+e.getMessage());
			}
		}
	}
	global void finish(Database.BatchableContext bc){
		system.debug('Batch execution finished');
	}
}