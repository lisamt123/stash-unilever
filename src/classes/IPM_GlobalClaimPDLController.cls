public class IPM_GlobalClaimPDLController extends IPM_ProjectIntermediateController{

	public Id projectId{get; set;}
	public List<IPM_Project_Rollout__c> localRolloutList{get; set;}
	public Id projDocSectionId{get;set;}
	public IPM_Country_Level_Claim__c countryLevelClaims;
	public List<RolloutLevelWrapper> rolloutLvlWrapper{get;set;}
	public List<IPM_Project_Claim__c> projectClaimList{get; set;}
	public List<IPM_Country__c> countrylist{get; set;}
	public Map<String,List<String>> localCntrytoClaimMap{get; set;} //Map to keep the local rollout country claim
	public List<IPM_Country_Level_Claim__c> contryLevelClaimList{get; set;}
	public Boolean showCountryClaim{get;set;}
	
	public static final String PRODUCT_SECTION_SEQ = '3.3.1';
	private static final String PRODUCT_SECTION = 'Product';
	
	public IPM_GlobalClaimPDLController()
	{
		Map<String,String> paramMap = Apexpages.currentpage().getparameters();
        Set<Id> countryLevelId = new Set<Id>();
        List<String> localCountryList = new List<String>();
        countryList = new List<IPM_Country__c>();
        
        showCountryClaim = false;
        
        if(paramMap != null && paramMap.containsKey(IPM_ConstantUtils.SF_ID)) 
        {
            projectId = paramMap.get(IPM_ConstantUtils.SF_ID);
            projDocSectionId = paramMap.get(IPM_ConstantUtils.SF_PROJ_DOC_SEC_ID);
        }
        
        if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
		{
			showCountryClaim = true;
		}

        IPM_Project_Document_Section__c projDocSec = [SELECT Id, IPM_Section_Sequence__c, IPM_Master_Section_External_Id__c, IPM_Gate_Document__c FROM IPM_Project_Document_Section__c WHERE Id=:projDocSectionId];
                
        localRolloutList = [Select id, MCO_Name__c, KeyMCO__c, (Select id,Country_Name__c From IPM_Countries_Local__r Order by Local_Rollout__r.MCO__c) From IPM_Project_Rollout__c Where (IPM_Project__c =: projectId OR Local_Project__c =: projectId) and RecordType.Name =: IPM_ConstantUtils.LOCAL_ROLLOUT_RT];
		
		for(IPM_Project_Rollout__c localRollout : localRolloutList)
		{
			if( (localRollout.KeyMCO__c && showCountryClaim) || project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
			{
				countryList.addAll(localRollout.IPM_Countries_Local__r);
			}			
		}

        prepareCountryClaimDetails();
	}
	
	public class RolloutLevelWrapper{
		public IPM_Project_Rollout__c localRolloutWp{get;set;}
		public List<IPM_Country__c>	countryListWp{get;set;}
		public Map<Id,List<CountryClaimsWrapper>> countryLevelMapWp{get;set;}
		public RolloutLevelWrapper(){
			localRolloutWp = new IPM_Project_Rollout__c();
			countryListWp = new List<IPM_Country__c>();
			countryLevelMapWp = new Map<Id,List<CountryClaimsWrapper>>();
		} 
	}
	public class CountryClaimsWrapper{
		public boolean selected {get;set;}
		public IPM_Country_Level_Claim__c countryLvlClaim {get;set;}
		public CountryClaimsWrapper(IPM_Country_Level_Claim__c countryLevelClaiming,Boolean isSelected){
			selected = isSelected;
			countryLvlClaim = countryLevelClaiming;
		}
	}
	
	public Map<String,IPM_Country_Level_Claim__c> uniqueKeyToCountryClaimsMap;
	
	public void prepareCountryClaimDetails()
	{	
		Map<Id,List<IPM_Country_Level_Claim__c>> countryIdListProjClaimsMap = new Map<Id,List<IPM_Country_Level_Claim__c>>();
        uniqueKeyToCountryClaimsMap = new Map<String,IPM_Country_Level_Claim__c>();
        rolloutLvlWrapper = new List<RolloutLevelWrapper>();
        
		projectClaimList = [Select Id, IPM_Claim__c, IPM_Project__c, (Select Id, Name, IPM_Country__c, IPM_Project_Claim__c,IPM_Claim__c,Country_Name__c  from Country_Level_Claims__r Where IPM_Country__c IN: countryList) from IPM_Project_Claim__c WHERE IPM_Project__c=:projectId OR IPM_Project__c =: project.IPM_Parent_Project__c];

		if(!projectClaimList.isEmpty())
		{
			for(IPM_Project_Claim__c projectClaim : projectClaimList)
	        {
	        	for(IPM_Country_Level_Claim__c countryClaim : projectClaim.Country_Level_Claims__r)
	        	{
	        		if(countryIdListProjClaimsMap.containsKey(countryClaim.IPM_Country__c))
		        	{
		        		countryIdListProjClaimsMap.get(countryClaim.IPM_Country__c).add(countryClaim);
		        	}
		        	else
		        	{
		        		countryIdListProjClaimsMap.put(countryClaim.IPM_Country__c, new List<IPM_Country_Level_Claim__c>{countryClaim});
		        	}
		        	
		        	String uniqueKey = projectClaim.Id +''+countryClaim.IPM_Country__c;
		        	
		        	uniqueKeyToCountryClaimsMap.put(uniqueKey,countryClaim);
	        	}
	        }
	        
	        for(IPM_Project_Rollout__c rollout : localRolloutList)
	        {
	        	RolloutLevelWrapper rolloutLevelWp = new RolloutLevelWrapper();
	        	rolloutLevelWp.localRolloutWp = rollout;
	        	for(IPM_Country__c cntryEle : rollout.IPM_Countries_Local__r)
	        	{
	        		rolloutLevelWp.countryListWp.add(cntryEle);
	        		for(IPM_Project_Claim__c projClm : projectClaimList)
	        		{
	        			CountryClaimsWrapper cntyLvl = null;
	        			
	        			String uniqueKey = projClm.id +''+ cntryEle.Id;
	        		
	        			if(uniqueKeyToCountryClaimsMap.containsKey(uniqueKey))
	        			{
	        				IPM_Country_Level_Claim__c DBCountryLevelClaimObj = uniqueKeyToCountryClaimsMap.get(uniqueKey);
	        				cntyLvl = new CountryClaimsWrapper(DBCountryLevelClaimObj,true);	
	        			}
	        			else
	        			{
	        				cntyLvl = new CountryClaimsWrapper(new IPM_Country_Level_Claim__c( IPM_Project_Claim__c=projClm.id, IPM_Claim__c = projClm.IPM_Claim__c,IPM_Country__c = cntryEle.Id),false);
	        			}
	        			
		        		if(rolloutLevelWp.countryLevelMapWp.containsKey(cntryEle.id))
		        		{
							rolloutLevelWp.countryLevelMapWp.get(cntryEle.id).add(cntyLvl);
						}
						else
						{
							rolloutLevelWp.countryLevelMapWp.put(cntryEle.id,new List<CountryClaimsWrapper>{cntyLvl});
						}	
	        		}	
	        	}
	        	rolloutLvlWrapper.add(rolloutLevelWp);
	        }
		}	
		else
		{
      		projectClaimList.add(new IPM_Project_Claim__c(IPM_Project__c = projectId));
    	} 	
	}
	
	
	
    public PageReference addProjectClaimsToAllCountries() 
    {
    	List<IPM_Country_Level_Claim__c> countryLevelClaimList = new List<IPM_Country_Level_Claim__c>();
    	for(IPM_Project_Claim__c projectClaim : projectClaimList)
    	{
			for(IPM_Country__c country : countryList)
			{	
				String uniqueKey = projectClaim.id +''+ country.Id;
				
				if(!uniqueKeyToCountryClaimsMap.containsKey(uniqueKey))
				{
					IPM_Country_Level_Claim__c contryLevelClaim = new  IPM_Country_Level_Claim__c();
					contryLevelClaim.IPM_Claim__c = projectClaim.IPM_Claim__c;
					contryLevelClaim.IPM_Project_Claim__c = projectClaim.id;
					contryLevelClaim.IPM_Country__c = country.id;
					countryLevelClaimList.add(contryLevelClaim);
				}
			}
		}
	
		if(!countryLevelClaimList.isEmpty()){
			upsert countryLevelClaimList;
		}

		prepareCountryClaimDetails();   
		return null; 
    }


    public PageReference autoSave() 
    {
		if(!projectClaimList.isEmpty()){
			upsert projectClaimList;
		}		
		
		prepareCountryClaimDetails();
		return null;
    }
	
	
    public PageReference addProjectClaims() 
    {
		if(projectClaimList.size() < 10)
		{
			projectClaimList.add(new IPM_Project_Claim__c(IPM_Project__c = projectId));
		}
		if(!projectClaimList.isEmpty())
		{
			upsert projectClaimList;
		}
        return null; 
    }
	
	public PageReference doneEventHandling()
	{
		SavePoint dbSavePt = Database.setSavePoint();
		List<IPM_Country_Level_Claim__c> countryLevelClaimUpList = new List<IPM_Country_Level_Claim__c>();
		Map<Id,IPM_Country_Level_Claim__c> countryLevelClaimDelMap = new Map<Id,IPM_Country_Level_Claim__c>();
		
		try
		{
			for(RolloutLevelWrapper rolloutWp : rolloutLvlWrapper)
			{
				for(List<CountryClaimsWrapper> countryClmList : rolloutWp.countryLevelMapWp.values())
				{
					for(CountryClaimsWrapper countryClm : countryClmList)
					{
						if(countryClm.selected)
						{	
							countryLevelClaimUpList.add(countryClm.countryLvlClaim);	
						}
						else
						{
							if(countryClm.countryLvlClaim.id !=null)
							{
								countryLevelClaimDelMap.put(countryClm.countryLvlClaim.id,countryClm.countryLvlClaim);
							}
						}
					}
				}
			}
			
			if(!countryLevelClaimUpList.isEmpty())
			{
				upsert countryLevelClaimUpList;
			}
			
			if(!countryLevelClaimDelMap.isEmpty())
			{
				delete [Select Id from IPM_Country_Level_Claim__c where Id in :countryLevelClaimDelMap.keySet()];
			}
			prepareCountryClaimDetails();
		}
		catch(Exception ex)
		{
			Database.Rollback(dbSavePt);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Update Failed'));
		}
		return null;	
	}

	public PageReference resetEventHandling()
	{
		prepareCountryClaimDetails();	
		return null;
	}
}