/** 
    About
    -----
    Description: Class Oblix_Ctrl04Bis_OverrideOtherItemsNews
    Created for: Oblix Unilever Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : Used as a  class to Override New/Edit of Other Items
                  		
            Functionnalities : 
                    
    Update History
    --------------    
*/
public with sharing class Oblix_Ctrl04Bis_OverrideOtherItemsNews {
	private List<Oblix_Calculator__c> lstCalculatorRate = new List<Oblix_Calculator__c>();
	public Marketing_Basics__c OItem {get;set;}
	public String fYear {get;set;}
	public String agency {get;set;}
	public String rtResourceId {get;set;}
	public String rtActivityId {get;set;}
	
	public String selectedDiscipline{get;set;}
	public String selectedAgencyDepartment{get;set;}
	public String selectedRoleTitle{get;set;}
	public String selectedOblixCountry{get;set;}
	
	
	public Oblix_Ctrl04Bis_OverrideOtherItemsNews(ApexPAges.StandardController controller){
		 if(!System.Test.isRunningTest()){
             controller.addFields(new List<String>{'Oblix_SOWMarketing__c','Description__c', 'FTE__c', 'No_of_Hours_Required__c', 'Name', 'Id', 'RecordTypeId'});
         }
		 rtResourceId = Oblix_Utils.MapRecordType('Marketing_Basics__c').get('Resource');
		 rtActivityId = Oblix_Utils.MapRecordType('Marketing_Basics__c').get('Activity');
		 
		  
		this.OItem = (Marketing_Basics__c) controller.getRecord();
		
		if(OItem.Id == null){
			rtResourceId = rtResourceId.substring(0, 15);
			rtActivityId = rtActivityId.substring(0, 15);
		}
		
		System.debug('###OItem : '+OItem);
		System.debug('###rtResourceId : '+rtResourceId);
		System.debug('###rtActivityId : '+rtActivityId);
		lstCalculatorRate = [Select Id, Name, RecordTypeId, Role_Daily_Rate_EUR__c, Agency_Department__c, Discipline__c, OblixCountry__r.Name,
					Role_Title__c, FTE__c, OblixCountry__c from Oblix_Calculator__c where 
				RecordTypeId =: Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Role_Rate') Limit 1];
		System.debug('###lstCalculatorRate : '+lstCalculatorRate);
		Marketing_SOW__c parentSow = [Select Id, Name, Financial_Year__c, Marketing_Agency__c from Marketing_SOW__c where id =:OItem.Oblix_SOWMarketing__c];
		System.debug('###parentSow : '+parentSow);
		fYear = parentSow.Financial_Year__c;
		agency = parentSow.Marketing_Agency__c;
	}
	
	 public List<SelectOption> getPickListDiscipline(){
	 	
	 	 List<SelectOption> options= new List<SelectOption>();
	       	if(!lstCalculatorRate.isEmpty() && lstCalculatorRate[0].Discipline__c != null){
	       		options.add(new SelectOption(lstCalculatorRate[0].Discipline__c, lstCalculatorRate[0].Discipline__c));
	       	}
	       	else{
	       		options.add(new SelectOption('', 'None'));
	       	}	
	       
	       	return options;
	 }
	 
	 public List<SelectOption> getAgencyDepartment(){
	 	
	 	 List<SelectOption> options= new List<SelectOption>();
	       	if(!lstCalculatorRate.isEmpty()&& lstCalculatorRate[0].Agency_Department__c != null){
	       		options.add(new SelectOption(lstCalculatorRate[0].Agency_Department__c, lstCalculatorRate[0].Agency_Department__c));
	       	}
	       	else{
	       		options.add(new SelectOption('', 'None'));
	       	}	
	       
	       	return options;
	 }
	 
	 public List<SelectOption> getRoleTitle(){
	 	
	 	 List<SelectOption> options= new List<SelectOption>();
	       	if(!lstCalculatorRate.isEmpty() && lstCalculatorRate[0].Role_Title__c != null){
	       		options.add(new SelectOption(lstCalculatorRate[0].Role_Title__c, lstCalculatorRate[0].Role_Title__c));
	       	}
	       	else{
	       		options.add(new SelectOption('', 'None'));
	       	}	
	       
	       	return options;
	 }
	  public List<SelectOption> getOblixCountry(){
	 	
	 	 List<SelectOption> options= new List<SelectOption>();
	       	if(!lstCalculatorRate.isEmpty() && lstCalculatorRate[0].OblixCountry__c != null){
	       		options.add(new SelectOption(lstCalculatorRate[0].OblixCountry__c, lstCalculatorRate[0].OblixCountry__r.Name));
	       	}
	       	else{
	       		options.add(new SelectOption('', 'None'));
	       	}	
	       
	       	return options;
	 }
	public PageReference save(){
		try{
			if(OItem.RecordTypeId == Oblix_Utils.MapRecordType('Marketing_Basics__c').get('Resource') && !lstCalculatorRate.IsEmpty() && OItem.FTE__c != null && OItem.FTE__c > 0){
				OItem.OblixOtherItemFee__c = lstCalculatorRate[0].FTE__c/OItem.FTE__c; 
			}else{
				OItem.OblixOtherItemFee__c = lstCalculatorRate[0].FTE__c;
			}
			if(OItem.RecordTypeId == Oblix_Utils.MapRecordType('Marketing_Basics__c').get('Activity') && !lstCalculatorRate.IsEmpty() && OItem.No_of_Hours_Required__c != null && lstCalculatorRate[0].Role_Daily_Rate_EUR__c != null){
				OItem.OblixOtherItemFee__c = lstCalculatorRate[0].Role_Daily_Rate_EUR__c * OItem.No_of_Hours_Required__c;
			}else{
				OItem.OblixOtherItemFee__c = 0;
			}
			OItem.Discipline__c = selectedDiscipline;
			OItem.Agency_Department__c = selectedAgencyDepartment;
			OItem.Role_Title__c = selectedRoleTitle;
			OItem.OblixCountry__c = selectedOblixCountry;
			
			
			if(OItem.Id != null){
				update OItem;
			}else{
				insert OItem;
			}
			return new PageReference('/'+OItem.Id);
			
		}catch(DmlException e){
			System.debug('###Exception Occured :'+e.getMessage());
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured during save please review data entry'));
		}
		return null;
		
	}
}