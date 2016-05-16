/****************************************************************************************************************************
   @Author: Cognizant
   @Name: IPM_Consumer_Evidence_Controller
   @Created Date: 23/06/2015
   @Description: Controller for the Consumer Evidence Component in Section Editor Page
   @Version: 1.0 
   @Reference: IPM_Consumer_Evidence Component
*/
public with sharing class IPM_Consumer_Evidence_Controller{
    public Id projDocSecId {// to get-set the project document section id from the component attribute.
        get{
            return projDocSecId;// to get the project document section id from the component attribute.
        }
        set{
            projDocSecId= value;// to set the project document section id from the component attribute.
            showCountryList();//calling the method to show countries in picklist
        }
    }
    public Id projectId{// to get-set the project id from the component attribute.
        get{
            return projectId;
        }
        set{
            projectId= value;
        }
    }
    public IPM_Project_Document_Section__c projDocSec{get;set;} //object of project document section
    public transient List<IPM_Country__c> countryList{get; set;}//list of the active country
    public List<IPM_Country__c> cList{get; set;}//list of the country
    public List<IPM_Project_Document_Section_Content__c> consumerEvidenceList{get; set;} //list of consumer evidences
    public List<String> couyName{get; set;}//to get the country name in list
    public String countryName{get; set;}//string to store the country name from the UI(jQuery)
    public string comments{get; set;}//For Saving concept comments
    public string projDocSecConId{get; set;}//For Getting Project Document Section Content Id
    public string deleteCountry{get; set;}//For Deleting Country
    public string addCountryConcept{get; set;}//For adding concept to country
    public Boolean isEditable{get;set;}//for security
    public string gateType{get; set;} //For cureent project gate
    public Integer priorityNumber{get; set;} //For getting deleted concept priority number
    public map<String,String> mapCountryNameWithCode {get;set;} //To map country code with name
    public string urlCountry{get; set;} //For getting country from url
    private static string IPM_CONSUMER_EVIDENCE_CONTROLLER_STR=IPM_Consumer_Evidence_Controller.class.getName();
    /************************************************************************************************************************
    *  Description For showing the countries in picklist
    *  @name showCountryList
    *  @param none
    *  @return void
    *  @throws query exception
    */
    public void showCountryList(){
        try{
            IPM_IECompatible.ieFix();//For IE Compatibility
            //Retrieving Countries List
            countryName=IPM_Constantutils.BLANK;
            couyName=new List<String>();
            countryList=new List<IPM_Country__c>();
            cList=new List<IPM_Country__c>();
            String selCountryName=IPM_Constantutils.BLANK;
            urlCountry = apexpages.currentpage().getparameters().get('country');
            if(!String.isBlank(projDocSecId)){
                projDocSec=[SELECT Id,IPM_Section_Sequence__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c,IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c,IPM_Selected_Consumer_Evidence_Countries__c 
                            FROM IPM_Project_Document_Section__c 
                            WHERE Id=:projDocSecId];
                cList=[SELECT Id,Country_Name__c,IPM_Project__c,Country_Code__c,isActive__c
                       FROM IPM_Country__c 
                       WHERE  IPM_Project__c=:projDocSec.IPM_Project_Document__r.IPM_Project__c OR IPM_Regional_Project__c=:projDocSec.IPM_Project_Document__r.IPM_Project__c
                       ORDER BY Country_Name__c asc];
                mapCountryNameWithCode=new map<String,String>();
                for(IPM_Country__c c:cList){
                    mapCountryNameWithCode.put(c.Country_Code__c,c.Country_Name__c);
                    if(c.isActive__c){
                        countryList.add(c);
                    }
                }             
                //Getting selected country names for selection in picklist    
                consumerEvidenceList=new List<IPM_Project_Document_Section_Content__c>();       
                if(!String.isBlank(projDocSec.IPM_Selected_Consumer_Evidence_Countries__c)){
                    for(IPM_Country__c c:cList){
                        for(String cou:projDocSec.IPM_Selected_Consumer_Evidence_Countries__c.split(IPM_ConstantUtils.SEMICOLON)){
                            if(c.Country_Code__c==cou){
                                couyName.add(cou);
                            }       
                        }
                    }
                    for(Integer i=0;i<couyName.size();i++){
                        if(!String.isBlank(countryName)){
                            countryName=countryName+IPM_ConstantUtils.COMMA+couyName[i];
                        }
                        else{
                            countryName=couyName[i];    
                        }
                    }
                    consumerEvidenceList=[SELECT IPM_Consumer_Evidence_Priority__c,IPM_Consumer_Evidence_Concept_Name__c,IPM_Consumer_Evidence_Gate__c,IPM_Consumer_Evidence_Country__c,IPM_Project_Document_Section__c,
                                                 IPM_Consumer_Evidence_Comments__c,IPM_Consumer_Evidence_Image__c,IPM_Consumer_Evidence_Logo_Id__c 
                                          FROM IPM_Project_Document_Section_Content__c
                                          WHERE IPM_Project_Document_Section__c=:projDocSec.Id];  
                }                                
            }
        }
       
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CONSUMER_EVIDENCE_CONTROLLER_STR,
                    IPM_ConstantUtils.CREATECONCEPT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
    }
    
    /************************************************************************************************************************
    *  Description To Craete Concepts for Selected Countries
    *  @name createConcept
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void createConcept(){
        List<IPM_Project_Document_Section_Content__c> insertCountriesConceptList=new List<IPM_Project_Document_Section_Content__c>();
        couyName=countryName.split(IPM_ConstantUtils.COMMA);
        for(Integer i=0;i<couyName.size();i++){  
            //If selected coutries does not have concepts
            if((!String.isBlank(projDocSec.IPM_Selected_Consumer_Evidence_Countries__c) && !projDocSec.IPM_Selected_Consumer_Evidence_Countries__c.contains(couyName[i])) || String.isBlank(projDocSec.IPM_Selected_Consumer_Evidence_Countries__c)){
                //Creating defaut concept records
                IPM_Project_Document_Section_Content__c pdsc=new IPM_Project_Document_Section_Content__c();
                pdsc.IPM_Consumer_Evidence_Concept_Name__c=IPM_ConstantUtils.CONCEPT_TEST;
                pdsc.IPM_Consumer_Evidence_Priority__c=1;
                pdsc.IPM_Consumer_Evidence_Country__c=couyName[i];
                pdsc.IPM_Project_Document_Section__c=projDocSec.Id;
                pdsc.IPM_Content_Type__c = IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE;
                pdsc.IPM_Consumer_Evidence_Gate__c=gateType;
                insertCountriesConceptList.add(pdsc);
                
                IPM_Project_Document_Section_Content__c pdsco=new IPM_Project_Document_Section_Content__c();
                pdsco.IPM_Consumer_Evidence_Concept_Name__c=IPM_ConstantUtils.CONCEPT_TEST;
                pdsco.IPM_Consumer_Evidence_Priority__c=2;
                pdsco.IPM_Consumer_Evidence_Country__c=couyName[i];
                pdsco.IPM_Project_Document_Section__c=projDocSec.Id;
                pdsco.IPM_Content_Type__c = IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE;
                pdsco.IPM_Consumer_Evidence_Gate__c=gateType;
                insertCountriesConceptList.add(pdsco);
                
                //Updating selected countries
                if(!String.isBlank(projDocSec.IPM_Selected_Consumer_Evidence_Countries__c)){
                    projDocSec.IPM_Selected_Consumer_Evidence_Countries__c=projDocSec.IPM_Selected_Consumer_Evidence_Countries__c+IPM_ConstantUtils.SEMICOLON+couyName[i];
                }
                else{
                    projDocSec.IPM_Selected_Consumer_Evidence_Countries__c=couyName[i];
                }   
            }     
        }
        try{
            if(insertCountriesConceptList!=null && !insertCountriesConceptList.isEmpty()){
                insert insertCountriesConceptList;
                update projDocSec;
            }
            showCountryList();   
        }
       
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CONSUMER_EVIDENCE_CONTROLLER_STR,
                    IPM_ConstantUtils.CREATECONCEPT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
    }
    
    /************************************************************************************************************************
    *  Description To Save Concept Comments
    *  @name saveConcept
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void saveConcept(){ 
        //Updating comments for the concept
        try{
            if(!String.isBlank(projDocSecConId)){
                IPM_Project_Document_Section_Content__c pdsc=new IPM_Project_Document_Section_Content__c();
                pdsc.Id=projDocSecConId;
                pdsc.IPM_Consumer_Evidence_Comments__c=comments;
                pdsc.IPM_Content_Type__c = IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE;
                update pdsc;
            }
        }
       
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CONSUMER_EVIDENCE_CONTROLLER_STR,
                    IPM_ConstantUtils.SAVECONCEPT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }       
    }
    
    /************************************************************************************************************************
    *  Description To Delete Selected Country Concepts
    *  @name deleteSelectedCountry
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void deleteSelectedCountry(){ 
        List<IPM_Project_Document_Section_Content__c> projDocSecContentsList=new List<IPM_Project_Document_Section_Content__c>();
        String availableCountries=IPM_ConstantUtils.BLANK;
        try{
            if(!String.isBlank(deleteCountry) && !String.isBlank(projDocSecId)){
                projDocSecContentsList=[SELECT Id,IPM_Consumer_Evidence_Priority__c,IPM_Consumer_Evidence_Country__c,IPM_Project_Document_Section__c 
                                        FROM IPM_Project_Document_Section_Content__c 
                                        WHERE IPM_Consumer_Evidence_Country__c=:deleteCountry AND IPM_Project_Document_Section__c=:projDocSecId];
                projDocSec=[SELECT Id,IPM_Selected_Consumer_Evidence_Countries__c 
                            FROM IPM_Project_Document_Section__c 
                            WHERE Id=:projDocSecId];    
                //Removing country from selected countries 
                for(String country:projDocSec.IPM_Selected_Consumer_Evidence_Countries__c.split(IPM_ConstantUtils.SEMICOLON)){
                    if(country!=deleteCountry){
                        availableCountries=availableCountries+country+IPM_ConstantUtils.SEMICOLON;
                    }
                }
                projDocSec.IPM_Selected_Consumer_Evidence_Countries__c=availableCountries;
                update projDocSec;
                //Deleteing the concept test related to the country
                if(projDocSecContentsList!=null && !projDocSecContentsList.isEmpty()){
                    delete projDocSecContentsList;
                }       
            }
            showCountryList();
        }
       
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CONSUMER_EVIDENCE_CONTROLLER_STR,
                    IPM_ConstantUtils.DELETECOUNTRY_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
    }
    
    /************************************************************************************************************************
    *  Description To Craete New Concepts for Country
    *  @name addConcept
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void addConcept(){
        List<IPM_Project_Document_Section_Content__c> addProjDocSecContentsList=new List<IPM_Project_Document_Section_Content__c>();
        Integer conceptCount;
        //Adding new concept to country
        if(!String.isBlank(addCountryConcept) && !String.isBlank(projDocSecId)){
            conceptCount=[SELECT count() FROM IPM_Project_Document_Section_Content__c WHERE IPM_Project_Document_Section__c=:projDocSecId and IPM_Consumer_Evidence_Country__c=:addCountryConcept];
            IPM_Project_Document_Section_Content__c pdsc=new IPM_Project_Document_Section_Content__c();
            pdsc.IPM_Consumer_Evidence_Concept_Name__c=IPM_ConstantUtils.CONCEPT_TEST;
            pdsc.IPM_Consumer_Evidence_Priority__c=conceptCount+1;
            pdsc.IPM_Consumer_Evidence_Country__c=addCountryConcept;
            pdsc.IPM_Content_Type__c = IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE;
            pdsc.IPM_Project_Document_Section__c=projDocSecId;
            pdsc.IPM_Consumer_Evidence_Gate__c=gateType;
            addProjDocSecContentsList.add(pdsc);
        }
        try{
            if(addProjDocSecContentsList!=null && !addProjDocSecContentsList.isEmpty()){
                insert addProjDocSecContentsList;
            }
            showCountryList();
        }
        
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CONSUMER_EVIDENCE_CONTROLLER_STR,
                    IPM_ConstantUtils.ADDCONCEPT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
    }
    
    /************************************************************************************************************************
    *  Description To Delete Concept Image
    *  @name deleteImage
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    
    public void deleteImage(){ 
        //Deleting Images for the concept
        try{
            if(!String.isBlank(projDocSecConId)){
                IPM_Project_Document_Section_Content__c pdsc=new IPM_Project_Document_Section_Content__c();
                pdsc.Id=projDocSecConId;
                pdsc.IPM_Content_Type__c = IPM_ConstantUtils.EVIDENCE_CONTENT_TYPE;
                pdsc.IPM_Consumer_Evidence_Image__c=null;
                pdsc.IPM_Consumer_Evidence_Logo_Id__c=IPM_ConstantUtils.BLANK;
                update pdsc;
            }
            showCountryList();
        }
       
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CONSUMER_EVIDENCE_CONTROLLER_STR,
                    IPM_ConstantUtils.DELETE_IMAGE_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }       
    }
    
    /************************************************************************************************************************
    *  Description To Delete Concept of Consumer Evidence
    *  @name deleteConcept
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void deleteConcept(){ 
        //Deleting concept
        Integer conceptCount=0;
        String availableCountries=IPM_ConstantUtils.BLANK;
        List<IPM_Project_Document_Section_Content__c> priorityList=new List<IPM_Project_Document_Section_Content__c>();
        try{
            if(!String.isBlank(projDocSecConId)){
                IPM_Project_Document_Section_Content__c pdsc=new IPM_Project_Document_Section_Content__c();
                pdsc.Id=projDocSecConId;
                delete pdsc;
                conceptCount=[SELECT Count() FROM IPM_Project_Document_Section_Content__c WHERE IPM_Consumer_Evidence_Country__c=:deleteCountry AND IPM_Project_Document_Section__c=:projDocSecId];
                If(conceptCount<1){
                    projDocSec=[SELECT Id,IPM_Selected_Consumer_Evidence_Countries__c 
                                FROM IPM_Project_Document_Section__c 
                                WHERE Id=:projDocSecId];    
                    //Removing country from selected countries 
                    for(String country:projDocSec.IPM_Selected_Consumer_Evidence_Countries__c.split(IPM_ConstantUtils.SEMICOLON)){
                        if(country!=deleteCountry){
                            availableCountries=availableCountries+country+IPM_ConstantUtils.SEMICOLON;
                        }
                    }
                    projDocSec.IPM_Selected_Consumer_Evidence_Countries__c=availableCountries;
                    update projDocSec;  
                }
                else{
                    priorityList=[SELECT Id,IPM_Consumer_Evidence_Priority__c FROM IPM_Project_Document_Section_Content__c
                                  WHERE IPM_Consumer_Evidence_Country__c=:deleteCountry AND IPM_Project_Document_Section__c=:projDocSecId AND IPM_Consumer_Evidence_Priority__c >: priorityNumber];
                    for(IPM_Project_Document_Section_Content__c priorityContent:priorityList){
                        priorityContent.IPM_Consumer_Evidence_Priority__c=priorityContent.IPM_Consumer_Evidence_Priority__c-1;
                    }
                    if(priorityList!=null && !priorityList.isEmpty()){
                        update priorityList;
                    }
                }
            }
            showCountryList();
        }
        catch(DMLException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CONSUMER_EVIDENCE_CONTROLLER_STR,
                    IPM_ConstantUtils.DELETE_CONCEPT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CONSUMER_EVIDENCE_CONTROLLER_STR,
                    IPM_ConstantUtils.DELETE_CONCEPT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }       
    }     
                    
}
