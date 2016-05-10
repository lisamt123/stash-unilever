/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimateUpdate_schedule
@CreateDate : 2/10/2014
@Description : This is class is used to schedule the AF_BrandEstimateUpdate batch class
@Version : 1.0
@reference : none
****************************************************************************************************************************/
global with sharing class AF_BrandEstimateUpdate_schedule implements Schedulable{
	global void execute(SchedulableContext  SC){
		AF_BrandEstimateUpdate BradestiamteUpdate =new AF_BrandEstimateUpdate();
		database.executebatch(BradestiamteUpdate,1);
	}
}