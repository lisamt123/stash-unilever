public class AF_CustomSetting{

    public Map<String,AF_QuarterlyBonus__c> quarterlyBonusMap{get;set;}
    public List<AF_QuarterlyBonus__c> quarterlyBonusList{get;set;}
    public Map<String,AF_AgencyEmailAlerts__c> agencyEmailAlertMap{get;set;}
    public List<AF_AgencyEmailAlerts__c> agencyEmailAlertList{get;set;}
    public AF_TriggerDate__c triggerDate{get;set;}
    public Map<String,AF_Agency_Bonus_Access__c> agencyBonusMap{get;set;}
    public List<AF_Agency_Bonus_Access__c> agencyBonusList{get;set;}
    public Map<String,AF_isBonusLinkForAgency__c> bonusLinkMap{get;set;}
    public List<AF_isBonusLinkForAgency__c> bonusLinkList{get;set;}
    public DummyUser__c dummyUserId{get;set;}
    public AF_CMCO__c afCMCO{get;set;}
    public AF_CatFinanceThreshold__c catFinThreshold{get;set;}
    public AF_BrandEstimate_TriggerDate__c brandTriggerDate{get;set;}
    public AF_BonusQuarterly__c bonusQuarterly{get;set;}
    
    
    public Map<String,AF_AnnualBonus_Qual__c> annualBonusQualMap{get;set;}
    public List<AF_AnnualBonus_Qual__c> annualBonusQualList{get;set;}
    public AF_OOPS_Settings__c oopsPercentage{get;set;}
    public AF_Links__c afLinks{get;set;}
    
    public AF_CustomSetting()
    {
        quarterlyBonusMap = AF_QuarterlyBonus__c.getAll();
        quarterlyBonusList = quarterlyBonusMap.values();
        system.debug('quarterlyBonusUpdate..1.'+quarterlyBonusMap);
        system.debug('quarterlyBonusList...'+quarterlyBonusList);
        triggerDate = new AF_TriggerDate__c();
        triggerDate = AF_TriggerDate__c.getOrgDefaults();
        system.debug('triggerDate..'+triggerDate);
        agencyEmailAlertMap = AF_AgencyEmailAlerts__c.getAll();
        agencyEmailAlertList = agencyEmailAlertMap.values();
        agencyBonusMap = AF_Agency_Bonus_Access__c.getAll();
        agencyBonusList = agencyBonusMap.values();
        bonusLinkMap = AF_isBonusLinkForAgency__c.getAll();
        bonusLinkList = bonusLinkMap.values();
        dummyUserId = new DummyUser__c();
        dummyUserId = DummyUser__c.getOrgDefaults();
        afCMCO = new AF_CMCO__c();
        afCMCO = AF_CMCO__c.getOrgDefaults();
        catFinThreshold = new AF_CatFinanceThreshold__c();
        catFinThreshold = AF_CatFinanceThreshold__c.getOrgDefaults();
        brandTriggerDate = AF_BrandEstimate_TriggerDate__c.getOrgDefaults();
        bonusQuarterly = AF_BonusQuarterly__c.getOrgDefaults();
        
        annualBonusQualMap = AF_AnnualBonus_Qual__c.getAll();
        annualBonusQualList = annualBonusQualMap.values();
        oopsPercentage = AF_OOPS_Settings__c.getOrgDefaults();
        afLinks = AF_Links__c.getOrgDefaults();
    } 
    
    public void submitCustomSetting(){
    upsert quarterlyBonusList;
    
    }
    public void submitTriggerDate(){
    upsert triggerDate;
    }
    public void submitAgencyEmailAlerts(){
    upsert agencyEmailAlertList;
    }
    public void submitAgencyBonusMap(){
    upsert agencyBonusList;
    }
    public void submitBonusLink(){
    upsert bonusLinkList;
    }
    public void submitDummyUserId(){
    upsert dummyUserId;
    }
    public void submitAFCMCO(){
    upsert afCMCO;
    }
    public void submitCatFinThreshold(){
    upsert catFinThreshold;
    }
    public void submitbrandTriggerDate(){
    upsert brandTriggerDate;
    }
    public void submitBonusQuarterly(){
    upsert bonusQuarterly;
    }
   
    public void submitAnnualBonusQual(){
    upsert annualBonusQualList;
    }
    public void submitoopsPercentage(){
    upsert oopsPercentage;
    }
    public void submitAFLinks(){
    upsert afLinks;
    }

}