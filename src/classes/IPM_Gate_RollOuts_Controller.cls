/****************************************************************************************************************************
@Author: Cognizant
@Name: IPM_Gate_RollOuts_Controller
@Created Date: 15/04/2014
@Description: This class is used for fetching values from IPM_Country__c object.
@Version: 1.0
@Reference: IPM_Gate_RollOuts component
*/
public with sharing class IPM_Gate_RollOuts_Controller
{
    
    public String[] headers {get;set;} //Containd table headers
    public transient List<RegionalRollOutWrapper> regionalRollOutWrapperList {get;set;} 
    public static  ID regionalRecordTypeId =  Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).RecordTypeId;//used for displaying Regional To Local To Country Mapping ;  
    public static  ID localRecordTypeId = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).RecordTypeId;//used for displaying Regional To Local To Country Mapping;
    public Id proId
    {
        get 
        { 
            return proId; // to get the project document section ID from the component used from Gate document page
        }
        set 
        {
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
    *  Description Based on the passed Project Span,Identifies the associated local and Regional Rollouts which need to be displayed on the Gate Document Appendix 
                    section.
    *  @name prepareIPMLocalToCountryWrapper
    *  @param none
    *  @return void
    *  @throws query exception
    */
    public void prepareIPMLocalToCountryWrapper()
    {
        try
        {
            regionalRollOutWrapperList= new List<RegionalRollOutWrapper>();
           
            headers = new List<String> {Label.IPM_RegionalRollout,Label.IPM_Geography,Label.IPM_Status,Label.IPM_TARGET_LAUNCH_DATE,Label.IPM_LocalProjectName};
         
            List<IPM_Project__c> projectList  = [SELECT Id,Name,IPMProject_Span__c FROM IPM_Project__c WHERE Id =:proId LIMIT 1];
                                                 
            if(projectList != null && !projectList.isEmpty()){
                
                IPM_Project__c projectInContext =  projectList[0];
                
                Map<String,List<IPM_Project_Rollout__c>> regionalToLocalRolloutList = new Map<String,List<IPM_Project_Rollout__c>>();
                
                Map<Id,IPM_Project_Rollout__c> completeLocalRolloutMap = new Map<Id,IPM_Project_Rollout__c>();
                
                Map<String, List<IPM_Project_Rollout__c>> regProjToLocalRolloutsMap = new Map<String, List<IPM_Project_Rollout__c>>(); // Map to store Regional Project and its related local rollouts
                Set<Id> localRolloutIds = new Set<Id>();
                
                // Get the List of Regional Rollouts based on the Project.
                // Based on The Project Span, if it is Global we need to refer IPM Project else if it is regional, Regional project needs to be used in wher clause.
                if(projectInContext.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
                {
                    // Get the List of Regional Rollouts based on passed global project Id.
                    for(IPM_Project_Rollout__c regRollout : [SELECT Id,Name,IPM_Rollout_Project__c,(SELECT Id,Name,IPM_Rollout_Project__c,Target_Launch_Date__c,IPM_Status__c,IPM_Regional_Rollout_Status__c  FROM Local_Rollouts__r 
                        WHERE recordTypeId =: localRecordTypeId) FROM IPM_Project_Rollout__c WHERE IPM_Project__c = :proId AND recordTypeId =:regionalRecordTypeId AND isActive__c = true LIMIT 10000])
                    {
                        if(!regRollout.Local_Rollouts__r.isEmpty())
                        {
                            regionalToLocalRolloutList.put(regRollout.IPM_Rollout_Project__c,regRollout.Local_Rollouts__r);
                            completeLocalRolloutMap.putAll(new Map<Id,IPM_Project_Rollout__c>( (List<IPM_Project_Rollout__c>)regRollout.Local_Rollouts__r));
                        }      
                    }
                    
                    // Get the list of Regional Project based on passed global project Id.
                    for(IPM_Project__c regProject : [SELECT Id,Name,IPM_Project_Name__c,(SELECT Id,Name,Target_Launch_Date__c,IPM_Rollout_Project__c,IPM_Status__c,IPM_Regional_Rollout_Status__c FROM Regional_Project_Rollout__r 
                        WHERE recordTypeId =: localRecordTypeId) FROM IPM_Project__c WHERE IPM_Parent_Project__c = :proId AND Is_Archieved__c = FALSE LIMIT 10000])
                    {
                        if(!regProject.Regional_Project_Rollout__r.isEmpty())
                        {
                            regionalToLocalRolloutList.put(regProject.IPM_Project_Name__c,regProject.Regional_Project_Rollout__r);
                            completeLocalRolloutMap.putAll(new Map<Id,IPM_Project_Rollout__c>((List<IPM_Project_Rollout__c>) regProject.Regional_Project_Rollout__r));
                        }
                    }                       

                }
                else if(projectInContext.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
                {
                     // Get the list of Regional Project based on passed global project Id.
                    for(IPM_Project__c regProject : [SELECT Id,Name,IPM_Project_Name__c,(SELECT Id,Name,IPM_Rollout_Project__c,Target_Launch_Date__c,IPM_Status__c,IPM_Regional_Rollout_Status__c FROM Regional_Project_Rollout__r 
                        WHERE recordTypeId =: localRecordTypeId) FROM IPM_Project__c WHERE Id = :proId AND Is_Archieved__c = FALSE LIMIT 10000])
                    {
                        if(!regProject.Regional_Project_Rollout__r.isEmpty())
                        {
                            regionalToLocalRolloutList.put(regProject.IPM_Project_Name__c,regProject.Regional_Project_Rollout__r);
                            completeLocalRolloutMap.putAll(new Map<Id,IPM_Project_Rollout__c>((List<IPM_Project_Rollout__c>) regProject.Regional_Project_Rollout__r));
                        }
                    }   
                }
                
                Map<Id,IPM_Project_Rollout__c> localRolloutToCountryMap = new Map<Id,IPM_Project_Rollout__c>([SELECT Id,Name,Target_Launch_Date__c,IPM_Status__c,IPM_Regional_Rollout_Status__c,
                                                                            (SELECT Id,Country_Name__c,Local_Rollout__c from IPM_Countries_Local__r where isActive__c = true )
                                                                            FROM IPM_Project_Rollout__c where Id in :completeLocalRolloutMap.values() AND isActive__c = true]);
                
                
                for(String regional : regionalToLocalRolloutList.KeySet())
                {
                    List<IPM_Project_Rollout__c> associatedLocalRollouts = regionalToLocalRolloutList.get(regional);
                    List<LocalRolloutWrapper> associatedLocalWrapperList = new  List<LocalRolloutWrapper>();
                    for(IPM_Project_Rollout__c localRollout : associatedLocalRollouts)
                    {
                        if(localRolloutToCountryMap.containsKey(localRollout.Id))
                        {
                            IPM_Project_Rollout__c localRolloutWithCountries  = localRolloutToCountryMap.get(localRollout.Id);
                            List<IPM_Country__c> mappedCountryListPerLocalRO = localRolloutWithCountries.IPM_Countries_Local__r;
                            LocalRolloutWrapper localRollOutWrapObj = new LocalRolloutWrapper(localRollOut,mappedCountryListPerLocalRO);
                            associatedLocalWrapperList.add(localRollOutWrapObj);    
                        }    
                    }
                    RegionalRollOutWrapper regionalRolloutWrapObj = new RegionalRollOutWrapper(regional,associatedLocalWrapperList);
                    regionalRollOutWrapperList.add(regionalRolloutWrapObj);
                }
            }
        }
        catch(Exception ex)
        {
            // Invoked from Getter/Setter. Removing Exception Log insertion due to platform limitations.
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
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