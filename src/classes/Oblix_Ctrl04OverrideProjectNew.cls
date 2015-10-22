public with sharing class Oblix_Ctrl04OverrideProjectNew {
	public Oblix_SOW_Projects__c project {get;set;}
	public String selectedCountries {get;set;}
	public Map<String, String> MapCountryToRegion = new Map<String, String>();
	public set<String> setRegionsName {get;set;} 
	public List<MDO_Geography__c> lstCountries {get;set;}
	
	public Oblix_Ctrl04OverrideProjectNew(ApexPAges.StandardController controller){
		this.project = (Oblix_SOW_Projects__c) controller.getRecord();
			System.debug('###project : '+project);
		if(project.Id!=null){
			project = [Select o.Total_Fees_for_Project__c, o.Total_Digital_Fee__c, o.Total_Adapt_Fees__c, o.Timescale_Notes__c, 
			o.Stimulus_Requirements__c, o.Should_legal_review_this_project__c, o.Project_Start_Date__c, o.Project_Stage__c, 
			o.Project_Scale_2__c, o.Project_Scale_1__c, o.Project_Priority__c, o.Project_Finish_Date__c, 
			o.Project_Completion_Date__c, o.ProjectTotalAssetscore__c, o.Production_Completion_Date__c, o.Preview_Feedback__c, 
			o.Platform__c, o.Percentage_of_Fee_for_this_FY__c, o.Overall_Project_Complete__c, o.Other_Kinds_of_Research__c, 
			o.Oblix_ProjectBoxNumber__c, o.OblixProjectSplitPercentage_Comment__c, o.OblixClonedFromParentProject__c, 
			o.Number_of_Previews__c, o.Number_of_Markets_for_Preview__c, o.Name, o.List_Preview_Markets__c, 
			o.Jobs_to_be_Done__c, o.Is_type_of_item_usually_poduced_by_this__c, o.Is_this_High_Risk__c, 
			o.Innovation_Projects__c, o.Id, o.First_Air_Date__c, o.Financial_Year__c, o.Description__c, 
			o.Date_for_Assets_to_be_in_BET__c, o.Campaign_Idea__c, o.Budget_Burnt_to_date__c, o.Brand_Led_Growth__c, o.OblixRegion__c, o.OblixCountries__c,
			o.Agency_Percentage_of_Fees_to_this_FY__c From Oblix_SOW_Projects__c o
				where Id =: ApexPAges.currentPage().getParameters().get('Id')		
						];     
		}
		
		
		 lstCountries = [Select m.parent_L6__c, m.parent_L5__c, m.parent_L4__c, m.parent_L3__c, m.parent_L2__c, 
					m.parent_L1__c, m.geography_type__c, m.Name, m.Id, parent_L5__r.Name From MDO_Geography__c m where geography_type__c Like 'Country%'
					];
					
		if(!lstCountries.isEmpty()){
			MapCountryToRegion = new Map<String, String>();
			for(MDO_Geography__c country : lstCountries){
				if(country.parent_L5__c != null && (!MapCountryToRegion.containsKey(country.Name))){
						MapCountryToRegion.put(country.Name, country.parent_L5__r.Name);
				}
			}
		}
	}
	
	/*
	*	Used as action function method to fetch the correct regions when choosing Countries.
	*/
	public void RelatedCountriesRegions(){
			setRegionsName = new set<String>();
			String RegionsName = '';
			List<String> lstCountriesString = new List<String>();
		    if(selectedCountries != null && selectedCountries != ''){
		    	lstCountriesString =  selectedCountries.split(',');
		    }
		    
			for(String selectedCountry : lstCountriesString){
				if(MapCountryToRegion.get(selectedCountry) != null){
					setRegionsName.add(MapCountryToRegion.get(selectedCountry));
					 
				}
			}
			for(String reg : setRegionsName){
				RegionsName += reg + ';';
			}
			project.OblixCountries__c = selectedCountries;//.substring(0,selectedCountries.length()-1);
			project.OblixRegion__c = RegionsName;
			if(lstCountriesString != null && lstCountriesString.size()>0){
				if(lstCountriesString.size()==1){ project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market1;}
				if(lstCountriesString.size()>1 && lstCountriesString.size()<=5){ project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market2;}
				if(lstCountriesString.size()>5 && lstCountriesString.size()<=10){ project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market3;}
				if(lstCountriesString.size()>10 && lstCountriesString.size()<=15){ project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market4;}
				if(lstCountriesString.size()>15){ project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market5;}
				
			}else{
				project.Project_Scale_1__c = '';
			}
			
			System.debug('###project : '+project);
	}
	
	public PageReference Save(){
		try{
				System.debug('###selectedCountries save : '+selectedCountries);
				if((selectedCountries == null || selectedCountries == '') && project.OblixCountries__c != null){
						List<String> lstCountriesString =  project.OblixCountries__c.split(',');
						System.debug('###lsstCountriesString save : '+lstCountriesString);
						if(lstCountriesString.size()>0){
							if(lstCountriesString.size()==1){ project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market1;}
							if(lstCountriesString.size()>1 && lstCountriesString.size()<=5){ project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market2;}
							if(lstCountriesString.size()>5 && lstCountriesString.size()<=10){ project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market3;}
							if(lstCountriesString.size()>10 && lstCountriesString.size()<=15) {project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market4;}
							if(lstCountriesString.size()>15){ project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market5;}
							
						}else{
							project.Project_Scale_1__c = '';
						}
				}
			if(project != null && project.Id != null){
				update project;
			}else{
				insert project;
			}
			return new PageReference('/'+project.Id);
		}catch(Exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured during save please review data entry'));
		}
		return null;
	}
}