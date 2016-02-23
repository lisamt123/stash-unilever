/****************************************************************************************************************************
@Author: Cognizant
@Name: IPM_Gate_RollOuts_Controller
@Created Date: 15/04/2014
@Description: This class is used for fetching values from IPM_Country__c object.
@Version: 1.0
@Reference: IPM_Gate_RollOuts component
*/
public with sharing class IPM_Gate_RollOuts_Controller{
    //For exception handler
    private static final String IPM_GATE_ROLLOUTS_CONTROLLER_STR = IPM_Gate_RollOuts_Controller.class.getName();
    private static final String IPM_PREPAREWRAPPERS='prepareIPMLocalToCountryWrapper';
    public String[] headers {get;set;} //Containd table headers
    public transient List<RegionalRollOutWrapper> regionalRollOutWrapperList {get;set;} 
    public static  ID regionalRecordTypeId =  Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).RecordTypeId;//used for displaying Regional To Local To Country Mapping ;  
    public static  ID localRecordTypeId = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).RecordTypeId;//used for displaying Regional To Local To Country Mapping;
    public Id proId{
        get {
            return proId; // to get the project document section ID from the component used from Gate document page
        }
        set {
            proId= value;// setting the value of project document section
            prepareIPMLocalToCountryWrapper();
        }
    }
    /************************************************************************************************************************
    *  Description Constructor Getting Project Id From Page URL Parameter
    *  @name IPM_GatekeeperChecklist
    */
    public IPM_Gate_RollOuts_Controller(){
       
        IPM_IECompatible.ieFix();//For IE Compatibility
      
    }
    
    /************************************************************************************************************************
    *  Description Getting rollouts to display
    *  @name prepareIPMLocalToCountryWrapper
    *  @param none
    *  @return void
    *  @throws query exception
    */
    public void prepareIPMLocalToCountryWrapper(){
        try{
        
            regionalRollOutWrapperList= new List<RegionalRollOutWrapper>();
           
            headers = new List<String> {Label.IPM_RegionalRollout,Label.IPM_Geography,Label.IPM_Status,Label.IPM_TARGET_LAUNCH_DATE,Label.IPM_LocalProjectName};
         
            List<IPM_Project__c> projectList  = [SELECT Id,Name,IPMProject_Span__c FROM IPM_Project__c 
                                                 WHERE Id =:proId limit 1];
            if(projectList != null && !projectList.isEmpty()){
                
                IPM_Project__c projectInContext =  projectList[0];
                List<IPM_Project_Rollout__c> regionalRollOutList = null;
                Map<String, List<IPM_Project_Rollout__c>> regProjToLocalRolloutsMap = new Map<String, List<IPM_Project_Rollout__c>>(); // Map to store Regional Project and its related local rollouts
                Set<Id> localRolloutIds = new Set<Id>();
                // Get the List of Regional Rollouts based on the Project.
                // Based on The Project Span, if it is Global we need to refer IPM Project else if it is regional, Regional project needs to be used in wher clause.
                if(projectInContext.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && regionalRecordTypeId != null && localRecordTypeId!=null ){
                    // Get the list of Regional and local RollOuts based on passed global project Id. 
                    regionalRollOutList = [SELECT Id,Name,(SELECT Id,Name,Target_Launch_Date__c,IPM_Status__c FROM Local_Rollouts__r 
                                                           WHERE recordTypeId =: localRecordTypeId) 
                                           FROM IPM_Project_Rollout__c WHERE IPM_Project__c = :proId AND recordTypeId =:regionalRecordTypeId LIMIT 10000];
                }
                else if(projectInContext.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                	
                    // Currently association between Regional Projects and Regional RollOut is missing.Hence need to do other way around. 
                    // Get the list of local rollOuts based on passed regional ProjectId.From Local Rollouts get list of regional Rollouts.
                   List<IPM_Project_Rollout__c> localRolloutList = [SELECT Id,Regional_Rollout__r.Id, Regional_Project__c FROM IPM_Project_Rollout__c 
                                                                    WHERE Regional_Project__c = :proId AND recordTypeId =:localRecordTypeId LIMIT 10000];
                   
                   
                   Set<Id> tempRegionalRollOutSet = new Set<Id>();
                   Set<Id> tempRegionalprojectSet = new Set<Id>(); // for regional original projects                        
                   for(IPM_Project_Rollout__c ipmLocalRollOutObj : localRolloutList){
                        if(ipmLocalRollOutObj.Regional_Rollout__c != null){  
                            tempRegionalRollOutSet.add(ipmLocalRollOutObj.Regional_Rollout__r.Id);
                        }else if(ipmLocalRollOutObj.Regional_Project__c != null){
                        	tempRegionalprojectSet.add(ipmLocalRollOutObj.Regional_Project__c); // populate the Regional project Ids set
                        }         
                   }
                   
                   if(tempRegionalprojectSet != null && !tempRegionalprojectSet.isEmpty()){
		               for(IPM_Project_Rollout__c ipmRollout : [SELECT Id, Name, Target_Launch_Date__c, IPM_Status__c, Regional_Project__c, Regional_Project__r.Name FROM IPM_Project_Rollout__c 
		                                            WHERE Regional_Project__c in :tempRegionalprojectSet AND recordTypeId =: localRecordTypeId LIMIT 10000]){

	                        List<IPM_Project_Rollout__c> tempLocalRollouts = new List<IPM_Project_Rollout__c>();
                            if(regProjToLocalRolloutsMap.containsKey(ipmRollout.Regional_Project__r.Name)){
                                tempLocalRollouts = regProjToLocalRolloutsMap.get(ipmRollout.Regional_Project__r.Name);
                            }
                            tempLocalRollouts.add(ipmRollout);
                            regProjToLocalRolloutsMap.put(ipmRollout.Regional_Project__r.Name, tempLocalRollouts);
                            localRolloutIds.add(ipmRollout.Id);  
		               }
                   }
                    
                   if(tempRegionalRollOutSet !=null && !tempRegionalRollOutSet.isEmpty() ){
                       regionalRollOutList = [SELECT Id,Name,(SELECT Id,Name,Target_Launch_Date__c,IPM_Status__c FROM Local_Rollouts__r 
                                                            WHERE recordTypeId =: localRecordTypeId) 
                                            FROM IPM_Project_Rollout__c WHERE Id in :tempRegionalRollOutSet AND recordTypeId =:regionalRecordTypeId LIMIT 10000];    
                   }                                       
                }
                
                if(regionalRollOutList!=null && !regionalRollOutList.isEmpty()){
                    // Get the List of local Rollouts.
                    List<IPM_Project_Rollout__c> localRollOutList = new List<IPM_Project_Rollout__c>();
                    for(IPM_Project_Rollout__c regionalRollOut : regionalRollOutList){
                        if(regionalRollOut.Local_Rollouts__r !=null && !regionalRollOut.Local_Rollouts__r.isEmpty()){
                            localRollOutList.addAll(regionalRollOut.Local_Rollouts__r);
                        }   
                    }
                    if(localRollOutList != null && !localRollOutList.isEmpty()){
                        // Prepare the Map of Local Rollout Vs Countries associated with it.
                        Map<Id,List<IPM_Country__c>> localRollOutToCountryListMap = new Map<Id,List<IPM_Country__c>>();
                        
                        // Query and retrieve Country specific information based on Project and local RollOuts.
                        for(IPM_Country__c IPMCountry : [SELECT Id,Country_Name__c,Local_Rollout__c
                                                         FROM IPM_Country__c WHERE Local_Rollout__c IN :localRollOutList ]){
                            List<IPM_Country__c> associatedCountryList = new List<IPM_Country__c>();
                            if(localRollOutToCountryListMap.containsKey(IPMCountry.Local_Rollout__c)){
                                associatedCountryList = localRollOutToCountryListMap.get(IPMCountry.Local_Rollout__c);
                            }
                            associatedCountryList.add(IPMCountry);
                            localRollOutToCountryListMap.put(IPMCountry.Local_Rollout__c,associatedCountryList);    
                        }
                        
                        // Prepare the Wrapper List for display
                        for(IPM_Project_Rollout__c regionalRollOut : regionalRollOutList){
                            List<LocalRolloutWrapper> associatedLocalWrapperList = new  List<LocalRolloutWrapper>();
                            for(IPM_Project_Rollout__c localRollOut : regionalRollOut.Local_Rollouts__r){
                                List<IPM_Country__c> mappedCountryListPerLocalRO = new List<IPM_Country__c>();
                                // Get the list of Countries against local Rollout
                                if(localRollOutToCountryListMap.containsKey(localRollOut.Id)){
                                    mappedCountryListPerLocalRO = localRollOutToCountryListMap.get(localRollOut.Id);
                                }
                                // Push local Rollout and List of Countries.
                                LocalRolloutWrapper localRollOutWrapObj = new LocalRolloutWrapper(localRollOut,mappedCountryListPerLocalRO);
                                
                                // Update total List of LocalRollOut against Region RollOut
                                associatedLocalWrapperList.add(localRollOutWrapObj);
                            }
                            RegionalRollOutWrapper regionalRolloutWrapObj = new RegionalRollOutWrapper(regionalRollOut.Name,associatedLocalWrapperList);//,mappedCountryListPerRegionRO);
                            regionalRollOutWrapperList.add(regionalRolloutWrapObj);
                        }
                    }       
                }else if(regProjToLocalRolloutsMap != null && !regProjToLocalRolloutsMap.isEmpty()){ // If project is regional original 
					// Prepare the Map of Local Rollout Vs Countries associated with it.
                    Map<Id,List<IPM_Country__c>> localRollOutToCountryListMap = new Map<Id,List<IPM_Country__c>>();
                    
                    // Query and retrieve Country specific information based on Project and local RollOuts.
                    for(IPM_Country__c IPMCountry : [SELECT Id,Country_Name__c,Local_Rollout__c
                                                     FROM IPM_Country__c WHERE Local_Rollout__c IN :localRolloutIds ]){
                        List<IPM_Country__c> associatedCountryList = new List<IPM_Country__c>();
                        if(localRollOutToCountryListMap.containsKey(IPMCountry.Local_Rollout__c)){
                            associatedCountryList = localRollOutToCountryListMap.get(IPMCountry.Local_Rollout__c);
                        }
                        associatedCountryList.add(IPMCountry);
                        localRollOutToCountryListMap.put(IPMCountry.Local_Rollout__c,associatedCountryList);    
                    }
                    
                    // Prepare the Wrapper List for display
                    for(String strRegProjectName : regProjToLocalRolloutsMap.keySet()){
                    	
                        List<LocalRolloutWrapper> associatedLocalWrapperList = new  List<LocalRolloutWrapper>();
                        for(IPM_Project_Rollout__c localRollOut : regProjToLocalRolloutsMap.get(strRegProjectName)){
                        	
                            List<IPM_Country__c> mappedCountryListPerLocalRO = new List<IPM_Country__c>();
                            // Get the list of Countries against local Rollout
                            if(localRollOutToCountryListMap.containsKey(localRollOut.Id)){
                                mappedCountryListPerLocalRO = localRollOutToCountryListMap.get(localRollOut.Id);
                            }
                            // Push local Rollout and List of Countries.
                            LocalRolloutWrapper localRollOutWrapObj = new LocalRolloutWrapper(localRollOut,mappedCountryListPerLocalRO);
                            
                            // Update total List of LocalRollOut against Region RollOut
                            associatedLocalWrapperList.add(localRollOutWrapObj);
                        }
                        
                        RegionalRollOutWrapper regionalRolloutWrapObj = new RegionalRollOutWrapper(strRegProjectName,associatedLocalWrapperList);//,mappedCountryListPerRegionRO);
                        
                        regionalRollOutWrapperList.add(regionalRolloutWrapObj);
                    }
                }
            }
        }
        catch(QueryException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_ROLLOUTS_CONTROLLER_STR,
                IPM_PREPAREWRAPPERS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        
    }
    
    /************************************************************************************************************************
    *  Description This class is a wrapper Class for showing dependencies between Regional Rollout and Geo.
    *  @name RegionalRollOutWrapper
    */
    public class RegionalRollOutWrapper{
        public String regionalRollOutName {get;set;} 
        public List<LocalRolloutWrapper> localRollOutWrapList {get;set;} 
        public regionalRollOutWrapper(String pRegionalRollOut,List<localRollOutWrapper> pLocalRollOutWrapList){
            this.regionalRollOutName = pRegionalRollOut;
            this.localRollOutWrapList = pLocalRollOutWrapList;
        }
    }
    
    /************************************************************************************************************************
    *  Description This class is a wrapper Class for showing dependencies between Local Rollout and Geo.
    *  @name LocalRolloutWrapper
    */
    public class LocalRolloutWrapper{
        public IPM_Project_Rollout__c localRollOut {get;set;}
        public List<IPM_Country__c>  associatedCountries {get;set;}
        public String associatedCountryString {get;set;}
        public localRolloutWrapper(IPM_Project_Rollout__c pLocalRollOut,List<IPM_Country__c>  pAssociatedCountries){
            this.localRollOut = pLocalRollOut;
            this.associatedCountries = pAssociatedCountries;
            List<String> associatedGoes = new List<String>();
            for(IPM_Country__c lCountry : associatedCountries){
                if(lCountry.Country_Name__c != null && lCountry.Country_Name__c.length() > 0){
                    associatedGoes.add(lCountry.Country_Name__c);
                }
            }
            associatedCountryString = String.join(associatedGoes,IPM_ConstantUtils.COMMA+' ');
        }
    }
}