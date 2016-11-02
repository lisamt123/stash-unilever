/************************************************************************
    @Description : This class is used for business case functionality to diplayed in Contract and MRG Gates
    @Created Date: 30/06/2014
    @Author: Cognizant
    @Referenced: IPM_Country_Feedback page
************************************************************************/

public with sharing class IPM_BBCountryList {

	public list<IPM_Financial__c> financeList{get; set;} //used to store query result from IPM_Financial__c object 
	public string projectId{get; set;} //used to store current project id
	public map<string,list<IPM_Financial__c>> mapFinance{get;set;}
	public boolean bIsGKM3 {get;set;}
	/************************************************************************
    @Description : This is the constructor for the class
    ************************************************************************/
    public IPM_BBCountryList(){
    	bIsGKM3=false;
    	projectId=Apexpages.currentpage().getparameters().get('Id');
    	
    	if(projectId!=null){    		
    		 		
    		financeList=[SELECT Id,Local_Project__c,Local_Project__r.name,Local_Project__r.Market_Cluster_Name__c,Local_Project__r.IPM_GateKeeping_Model__c,Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c 
            		   FROM IPM_Financial__c 
            		   WHERE Local_Project__r.IPM_Parent_Project__c=:projectId AND isActive__c=true LIMIT 50000];
            if(!financeList.isEmpty() && IPM_ConstantUtils.GATE_KEEPING_MODEL_3.Equals(financeList[0].Local_Project__r.IPM_GateKeeping_Model__c)){
            	bIsGKM3 = true; 
            	mapFinance=new map<string,list<IPM_Financial__c>>();
           		for(IPM_Financial__c objFinance : financeList)
           		{
           			if(mapFinance.containsKey(objFinance.Local_Project__r.Market_Cluster_Name__c)){
           				list<IPM_Financial__c> lstFinance = mapFinance.get(objFinance.Local_Project__r.Market_Cluster_Name__c);
           				lstFinance.add(objFinance);
           			}
           			else{
           				mapFinance.put(objFinance.Local_Project__r.Market_Cluster_Name__c,new List<IPM_Financial__c>{objFinance});
           			}
           		}
            }
              
    	}
    	
    }
}