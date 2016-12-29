/*****************************************************************
@Description :used for showing/handling   claim related  data
@Created Date: 2016/3/16
@Author: Cognizant 
@Referenced: Gate document pages
******************************************************************/
public with sharing class IPM_GlobalClaimPDLController {

    public static IPM_Project__c project {
        get {
            return IPM_Utils.getProjectFullInfo(ApexPages.currentPage().getParameters().get('Id'));
        }
    }
	public Id projectId{get; set;}
	public List<IPM_Project_Rollout__c> localRolloutList{get; set;}
	public IPM_Country_Level_Claim__c countryLevelClaims;
	public List<RolloutLevelWrapper> rolloutLvlWrapper{get;set;}
	public List<IPM_Project_Claim__c> projectClaimList{get; set;}
	public List<IPM_Country__c> countrylist{get; set;}
	public Map<String,List<String>> localCntrytoClaimMap{get; set;} 
	public List<IPM_Country_Level_Claim__c> contryLevelClaimList{get; set;}
	public Boolean readOnlyLocalView{get;set;}
	public Boolean readOnlyPDFView{get;set;} 
	public Boolean displayNonKey{get;set;} 
	public String projClaimId{get;Set;}
	public Boolean showNoClaims{get;set;} 
	
	private static final String IPM_GLOBALCLAIMPDLCONTROLLER_STR = IPM_GlobalClaimPDLController.class.getName();

	public IPM_GlobalClaimPDLController() 
	{
		Map<String,String> paramMap = Apexpages.currentpage().getparameters();
        countryList = new List<IPM_Country__c>();
        
        readOnlyLocalView  = readOnlyPDFView = displayNonKey = showNoClaims =  false;
        
        String docType = Apexpages.currentPage().getParameters().get('DocumentType');
       	if(!String.isblank(docType) && docType == 'PDF')
       	{
       		readOnlyPDFView = true;	
       	} 
        if(paramMap != null && paramMap.containsKey(IPM_ConstantUtils.SF_ID)) 
        {
            projectId = paramMap.get(IPM_ConstantUtils.SF_ID);
        }
        
        localRolloutList = [Select id, 	IPM_Rollout_Project__c, MCO_Name__c, KeyMCO__c, (Select id,Country_Name__c From IPM_Countries_Local__r Order by Local_Rollout__r.MCO__c) From IPM_Project_Rollout__c Where (IPM_Project__c =: projectId OR Local_Project__c =: projectId) and isActive__c=true and RecordType.Name =: IPM_ConstantUtils.LOCAL_ROLLOUT_RT];
        if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
		{
			readOnlyLocalView = true; 
			displayNonKey = true;
		}
                        
		if(displayNonKey)
		{
			for(IPM_Project_Rollout__c localRollout : localRolloutList)
			{
				countryList.addAll(localRollout.IPM_Countries_Local__r); 
			}
		}
		else
		{
			for(IPM_Project_Rollout__c localRollout : localRolloutList)
			{
				if(localRollout.KeyMCO__c)
				{
					countryList.addAll(localRollout.IPM_Countries_Local__r);
				}	 
			}
		}

        prepareCountryClaimDetails();
	}
	
	public class RolloutLevelWrapper{
		public IPM_Project_Rollout__c localRolloutWp{get;set;}
		public List<IPM_Country__c>	countryListWp{get;set;}
		public Map<Id,String> countryToSelectedClaims{get;set;}
		public Map<Id,List<CountryClaimsWrapper>> countryLevelMapWp{get;set;}
		public RolloutLevelWrapper(){
			localRolloutWp = new IPM_Project_Rollout__c();
			countryListWp = new List<IPM_Country__c>();
			countryToSelectedClaims = new Map<Id,String>();
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
		
		if(projectClaimList.isEmpty())
		{
			showNoClaims = true;
		}
		
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
		}
	    else if( !( readOnlyLocalView ||  readOnlyPDFView) )
		{
      		projectClaimList.add(new IPM_Project_Claim__c(IPM_Project__c = projectId));
    	} 
    	
    	
    	if(!projectClaimList.isEmpty())
    	{
    		// Only run if there are project claims
    		for(IPM_Project_Rollout__c rollout : localRolloutList)
	        {
	            if((rollout.KeyMCO__c && project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL) || project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
	            {
	                RolloutLevelWrapper rolloutLevelWp = new RolloutLevelWrapper();
	                rolloutLevelWp.localRolloutWp = rollout;
	                for(IPM_Country__c cntryEle : rollout.IPM_Countries_Local__r)
	                {
	                    String selectedClaimString = IPM_ConstantUtils.SELECT_CLAIM;
	                    List<String> selectedClaimList = new List<String>();
	                    rolloutLevelWp.countryListWp.add(cntryEle);
	        		    rolloutLevelWp.countryLevelMapWp.put(cntryEle.id,new List<CountryClaimsWrapper>());
	                    for(IPM_Project_Claim__c projClm : projectClaimList)
	                    {
	                        CountryClaimsWrapper cntyLvl = null;
	                        
	                        String uniqueKey = projClm.id +''+ cntryEle.Id;
	                    
	                        if(uniqueKeyToCountryClaimsMap.containsKey(uniqueKey))
	                        {
	                            IPM_Country_Level_Claim__c DBCountryLevelClaimObj = uniqueKeyToCountryClaimsMap.get(uniqueKey);
	                            cntyLvl = new CountryClaimsWrapper(DBCountryLevelClaimObj,true);
	                            selectedClaimList.add(DBCountryLevelClaimObj.IPM_Claim__c); 
	                        }
		                else if( !( readOnlyLocalView ||  readOnlyPDFView) )
	                        {
	                            cntyLvl = new CountryClaimsWrapper(new IPM_Country_Level_Claim__c( IPM_Project_Claim__c=projClm.id, IPM_Claim__c = projClm.IPM_Claim__c,IPM_Country__c = cntryEle.Id),false);
	                        }
	                        
	        			if(cntyLvl!=null)
	        			{
			        		rolloutLevelWp.countryLevelMapWp.get(cntryEle.id).add(cntyLvl);
	        			} 
	                    }
	                    if(!selectedClaimList.isEmpty())
	                    { 
	                        selectedClaimString = String.join(selectedClaimList,IPM_ConstantUtils.SEMICOLONCLAIMSSEPERATION);
	                    }
	                    rolloutLevelWp.countryToSelectedClaims.put(cntryEle.Id,selectedClaimString);    
	                }
	                rolloutLvlWrapper.add(rolloutLevelWp);
	            }
	        }  
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
	
	public PageReference deleteClaim()
	{
		if(projClaimId != null)
		{
			IPM_Project_Claim__c projClaim = new IPM_Project_Claim__c(id=projClaimId);
			try
			{
				delete projClaim;
			}
			catch(Exception ex)
			{
				ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GLOBALCLAIMPDLCONTROLLER_STR,
                'Claims',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);	
			}
		}
		prepareCountryClaimDetails();
		return null;
	}
}
