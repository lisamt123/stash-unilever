/************************************************************************
    @Description : This class is used for business case functionality to diplayed in Contract and MRG Gates
    @Created Date: 30/06/2014
    @Author: Cognizant
    @Referenced: IPM_Country_Feedback page
************************************************************************/

public with sharing class IPM_BBCountryList {

	public list<IPM_Financial__c> financeList{get; set;} //used to store query result from IPM_Financial__c object 
	public string projectId{get; set;} //used to store current project id
	
	/************************************************************************
    @Description : This is the constructor for the class
    ************************************************************************/
    public IPM_BBCountryList(){
    	projectId=Apexpages.currentpage().getparameters().get('Id');
    	
    	if(projectId!=null){
    		financeList=[SELECT Id,Local_Project__c,Local_Project__r.name,Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c 
            		   FROM IPM_Financial__c 
            		   WHERE Local_Project__r.IPM_Parent_Project__c=:projectId AND isActive__c=true LIMIT 50000];   
    	}
    	
    }
}