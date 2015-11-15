public with sharing class IPM_EcoDesignSectionAssessment {

    public boolean isEditable { get; set; }
    public transient List<IPM_Country__c> countriesList {get; set;} //Contains All Header Countries
    public transient List<CountryAssessmentWrap> countryAssessmentWrapList {get;set;}
    /*******************************************************************************************************
    * @description:hold current project document section id from url parameter
    */
    public String SecId{get;set;}
    /*******************************************************************************************************
    * @description:hold current project id from url parameter
    */
    public String projId{get;set;}
    /*******************************************************************************************************
    * @description:hold current eco design record id
    */
    public string ecoDid{get;set;}
    public IPM_EcoDesignSectionAssessment(){ 
        SecId=Apexpages.currentpage().getparameters().get('ProjDocSecId');
            projId=Apexpages.currentpage().getparameters().get('Id');
            ecoDid='';
            IPM_Project_Document_Section_Content__c IPM_SecContent=new IPM_Project_Document_Section_Content__c();
            list<IPM_Project_Document_Section_Content__c>ecodesign=new list<IPM_Project_Document_Section_Content__c>();
            if(SecId!=''){
                ecodesign=[SELECT id FROM IPM_Project_Document_Section_Content__c 
                                                                    WHERE IPM_Project_Document_Section__c=:SecId limit 1];
            }
            if(ecodesign != null && !ecodesign.isEmpty()){
                IPM_SecContent=[SELECT id,IPM_Comparison_SKU__c,New_SKU__c,IPM_Comparison_SKU_Waste__c,IPM_New_SKU_Waste__c,
                                IPM_Expected_Change_Waste__c,IPM_Directional_View_Waste__c,IPM_Comparison_SKU_Water__c,
                                IPM_New_SKU_Water__c,IPM_Expected_Change_Water__c,IPM_Directional_View_Water__c,
                                IPM_Comparison_SKU_Greenhouse__c,IPM_New_SKU_Greenhouse__c,IPM_Expected_Change_Greenhouse__c,
                                IPM_Directional_View_Greenhouse__c,IPM_Comparison_SKU_Sourcing__c,IPM_Sustainale_Sourcing__c,IPM_Nutrition__c
                                FROM IPM_Project_Document_Section_Content__c WHERE id=:ecodesign[0].id limit 1];
                ecoDid=IPM_SecContent.id;
            }
            if(projId != ''){
                countriesList = [Select IPM_Project__c, Country_Name__c, IS_EI_Country__c From IPM_Country__c Where IPM_Project__c=:projId OR IPM_Local_Project__c =:projId 
                                                                                            OR IPM_Regional_Project__c =:projId Order by IS_EI_Country__c desc,Country_Name__c asc];     
            }
            System.debug('countriesListcountriesListcountriesListcountriesList::'+countriesList);
            Map<String,List<IPM_Assessment__c>> countryAssessmentMap = new Map<String,List<IPM_Assessment__c>>();
            for(IPM_Country__c con : countriesList){
                countryAssessmentMap.put(con.Country_Name__c,new List<IPM_Assessment__c>());    
            }
            if(!countriesList.isEmpty()){
                countryAssessmentWrapList = new List<CountryAssessmentWrap>();  
                for(IPM_Assessment__c assessmentEle : [Select IPM_SKU_Type__c, IPM_New_SKU__c, IPM_New_SKU_Water__c, IPM_New_SKU_Waste__c, IPM_New_SKU_Sourcing__c, 
                                                        IPM_New_SKU_Greenhouse__c, IPM_Expected_Change_Water__c, IPM_Expected_Change_Waste__c, IPM_Expected_Change_Sourcing__c, 
                                                        IPM_Expected_Change_Greenhouse__c, IPM_Current_Global_Average_Water__c, IPM_Current_Global_Average_Waste__c, 
                                                        IPM_Current_Global_Average_Sourcing__c, IPM_Current_Global_Average_Greenhouse__c, IPM_Country__r.Country_Name__c, 
                                                        IPM_Country__c, IPM_Comparison_SKU__c, IPM_Comparison_SKU_Water__c, IPM_Comparison_SKU_Waste__c, 
                                                        IPM_Comparison_SKU_Sourcing__c, IPM_Comparison_SKU_Greenhouse__c From IPM_Assessment__c 
                                                        Where IPM_Country__c IN:countriesList Order by IPM_SKU_Type__c asc]) {
                    if(!countryAssessmentMap.containsKey(assessmentEle.IPM_Country__r.Country_Name__c)){
                        countryAssessmentMap.put(assessmentEle.IPM_Country__r.Country_Name__c, new List<IPM_Assessment__c>{assessmentEle}) ;    
                    }
                    else {
                        countryAssessmentMap.get(assessmentEle.IPM_Country__r.Country_Name__c).add(assessmentEle);
                    }
                        
                }
            }
            System.debug('countryAssessmentMapcountryAssessmentMapcountryAssessmentMapcountryAssessmentMap::'+countryAssessmentMap);
            for(String countryName : countryAssessmentMap.keySet()){
                countryAssessmentWrapList.add(new CountryAssessmentWrap(countryName,countryAssessmentMap.get(countryName)));    
            }
            System.debug('countryAssessmentWrapListcountryAssessmentWrapListcountryAssessmentWrapList::'+countryAssessmentWrapList);
            
        
    }
    public class CountryAssessmentWrap {
        public String country {get;set;}
        public List<IPM_Assessment__c> assessmentList{get;set;}
        public CountryAssessmentWrap(String con, List<IPM_Assessment__c> assessmentLst) {
            country = con;
            assessmentList = assessmentLst;
        }
    }

}