public with sharing class IPMLocalSourcingTableController {	
    public Id proId
    {
        get 
        { 
            return proId;
        }
        set 
        {
            proId= value;  
            getProjectSourcingPlan();          
        }
    }    
    public List<SourcingPlanWrapper> lstSourcingPlanWrapper{get;set;}
    
    public void getProjectSourcingPlan()
    {
    	lstSourcingPlanWrapper = new List<SourcingPlanWrapper>();    	
    	list<IPM_Country__c> lstCountry = [ Select ID From IPM_Country__c Where IPM_Local_Project__c =: proId ];    	
    	Set<Id> lstCountryIDs = (new Map<Id,IPM_Country__c>(lstCountry)).keySet();    	
    	list<IPM_ProductPlan__c> lstProductPlan = [Select ID,IPM_Country__r.Country_Name__c,IPM_Project_Product__r.IPM_Product_Name__c,IPM_Project_Product__r.IPM_Format__c,IPM_Project_Product__r.IPM_Formulation__c,IPM_Project_Product__r.IPM_Packing__c,IPM_Project_Product__r.IPM_ProductSize__c,(Select ID,IPM_CapabilityConfirmed__c,IPM_Sourcing_Unit__r.Source_Unit_Name__c From IPM_SourcingPlanProducts__r) From IPM_ProductPlan__c Where IPM_Country__c in : lstCountryIDs];
    	for(IPM_ProductPlan__c oProductPlan : lstProductPlan){
    		List<IPM_SourcingPlan__c> lstSourcingPlan = oProductPlan.IPM_SourcingPlanProducts__r;
    		for (IPM_SourcingPlan__c oSourcingPlan : lstSourcingPlan)
    		{
	    		SourcingPlanWrapper oSourcingPlanWrapper = new SourcingPlanWrapper();
	    		oSourcingPlanWrapper.name = oProductPlan.IPM_Project_Product__r.IPM_Product_Name__c;
	    		oSourcingPlanWrapper.format = oProductPlan.IPM_Project_Product__r.IPM_Format__c;
	    		oSourcingPlanWrapper.formulation = oProductPlan.IPM_Project_Product__r.IPM_Formulation__c;
	    		oSourcingPlanWrapper.packaging = oProductPlan.IPM_Project_Product__r.IPM_Packing__c;
	    		oSourcingPlanWrapper.size = oProductPlan.IPM_Project_Product__r.IPM_ProductSize__c;	    		
	    		oSourcingPlanWrapper.sourcingUnit = oSourcingPlan.IPM_Sourcing_Unit__r.Source_Unit_Name__c;
	    		oSourcingPlanWrapper.approval = oSourcingPlan.IPM_CapabilityConfirmed__c;
	    		oSourcingPlanWrapper.country = oProductPlan.IPM_Country__r.Country_Name__c;
	    		lstSourcingPlanWrapper.add(oSourcingPlanWrapper);
    		}
    	}
    }
    public class SourcingPlanWrapper{
    	public String name{get;set;}
    	public String format{get;set;}
    	public String formulation{get;set;}
    	public String packaging{get;set;}
    	public decimal size{get;set;}
    	public String sourcingUnit{get;set;}
    	public boolean approval{get;set;}
    	public String country{get;set;}
    }
}