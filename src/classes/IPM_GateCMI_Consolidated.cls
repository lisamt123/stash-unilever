/****************************************************************************************************************************
@Author: Cognizant
@Name: IPM_GateCMI_Consolidated
@Created Date: 28/10/2015
@Description: To View Consolidated CMI Section
@Version: 1.0
@Reference: Project Document Section Editor Page
*/
public with sharing class IPM_GateCMI_Consolidated{   
    public static final String IPM_GATECMI_CONSOLIDATED_STR = IPM_GateCMI_Consolidated.class.getName();
    public static final String GET_COUNTRIES_STR='getCountries';
    public static final String GET_SECTION_CMI_LIST_STR='getSectionCMIList';
    public static final String SHOW_LIST_STR='showList';
    public SObject ipmCMIGate; //Contains Gate CMI Object
    public String selectedCountryName; //Contains Country Names of Gate CMI
    public IPM_Project__c project{get; set;} //Contains project record
    public Id projectId {   //Contains Project Id for Retrieving Countries List
        get{
            return projectId ;
        }
        set{
            projectId = value;
        }
    } 
    public Id projDocSecId { //Contains Project Document Section Id
        get{
            return projDocSecId;
        }
        set{
            projDocSecId= value;
            showList();
        }
    }
    public transient list<SelectOption> countries{get;set;} //Contains Countries List
    public transient list<String> gateTypes{get;set;} //Contains Gate Document Types
    public transient String[] countryNameList{get; set;} //Contains List of Selected Countries Name
    public transient List<IPM_Project_Document_Section_Content__c> sectionList{get; set;} //Contains List of CMI Section Contents List
    public transient List<IPM_Gate_CMI__c> cmiList{get; set;}  //Contains List of Gate CMI List
    public transient Map<String,Integer> gateCount{get; set;} //Count of Gate CMI per Gate
    public Integer charterCount{get; set;} //Charter Gate Count
    public Integer contractCount{get; set;} //Contract Gate Count
    public Integer marketReadyCount{get; set;} //Market Ready Gate Count
    public transient List<IPM_Project_Document_Section__c> projDocSecList{get; set;} //Contains Project Document Section
    public String gateType{get; set;} //Contains Current Gate Document Type
    public transient List<IPM_Project_Document_Section_Content__c> resList{get; set;} //For result timing 
    public transient List<IPM_Country__c> countryList; //List od Countries
    public map<String,String> mapCountryNameWithCode {get;set;}
    /************************************************************************************************************************
    *  Description Getting List of Countries in Project
    *  @name getCountries
    *  @param none
    *  @return List
    *  @throws query exception
    */
    public List<selectOption> getCountries() { 
        countryList=new List<IPM_Country__c>();
        String soql  =  'SELECT Id,Country_Name__c,Country_Code__c,IPM_Project__c,IPM_Regional_Project__c FROM IPM_Country__c';
        if(gatetype==IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE){
            soql += ' WHERE IPM_Regional_Project__c = \'' + project.IPM_Parent_Project__c + '\'';
        }    
        else{
            soql += ' WHERE IPM_Regional_Project__r.IPM_Parent_Project__c = \'' + projectId + '\'';
        }
            
        try{
            countryList=Database.query(soql);   
        }
        catch(QueryException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMI_CONSOLIDATED_STR,
                GET_COUNTRIES_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        countries = new List<SelectOption>();
        if(countryList != null && !countryList.isEmpty()){
            for(IPM_Country__c tempCountry : countryList){
                countries.add(new SelectOption(tempCountry.Country_Name__c,tempCountry.Country_Code__c));
            }
        }
        return countries;
    }
    
    /************************************************************************************************************************
    *  Description Getting Gate CMI and Section Content List
    *  @name getSectionCMIList
    *  @param none
    *  @return void
    *  @throws query exception
    */
    public void getSectionCMIList(){
        try{
            String gateDocument=IPM_ConstantUtils.BLANK;
            if(gateType==IPM_ConstantUtils.CONTRACT_GATE){
                gateDocument=IPM_ConstantUtils.CONTRACT_GATE;
            }
            if(gateType==IPM_ConstantUtils.MARKET_READY_GATE){
                gateDocument=IPM_ConstantUtils.MARKET_READY_GATE;
            }
            if(gateType==IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE){
                gateDocument=IPM_ConstantUtils.MARKET_READY_GATE;
            }
            Set<String> restrictCountry=new Set<String>(); 
            resList=new List<IPM_Project_Document_Section_Content__c>();  
            
            if(gateType==IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE){
                cmiList=[SELECT Id,IPM_Project__c,IPM_Project__r.IPM_Project_Name__c,Gate__c,IPM_CMI_Overall_Colour_Score_Method__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c 
                         FROM IPM_Gate_CMI__c 
                         WHERE IPM_Project__c=:project.IPM_Parent_Project__c OR (IPM_Project__r.IPM_Parent_Project__c=:projectId AND IPM_Skip_Test__c=:true)];   
            	sectionList=[SELECT Id,IPM_CMI_Overall_Colour_Achieved__c,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Color_Score_Achieved__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Score_Label__c,IPM_CMI_Free_Text__c,IPM_CMI_Overall_Comments__c,IPM_CMI_Is_Free_Text__c,IPM_CMI_Result_Timing__c,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,
                                	IPM_Project_Document_Section__c,IPM_CMI_Outcome_Color_Achieved__c,IPM_CMI_Results_Acheived__c,IPM_CMI_Outcome_Color__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c 
                         	 FROM IPM_Project_Document_Section_Content__c 
                         	 WHERE IPM_Content_Type__c=:IPM_ConstantUtils.CMIGATE_CONTENT_TYPE AND IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c=:gateDocument AND IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c=:project.IPM_Parent_Project__c];
            }
            else{
            cmiList=[SELECT Id,IPM_Project__c,IPM_Project__r.IPM_Project_Name__c,Gate__c,IPM_CMI_Overall_Colour_Score_Method__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c 
                     FROM IPM_Gate_CMI__c 
                     WHERE IPM_Project__r.IPM_Parent_Project__c=:projectId OR (IPM_Project__c=:projectId AND IPM_Skip_Test__c=:true)]; 
            sectionList=[SELECT Id,IPM_CMI_Overall_Colour_Achieved__c,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Color_Score_Achieved__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Score_Label__c,IPM_CMI_Free_Text__c,IPM_CMI_Overall_Comments__c,IPM_CMI_Is_Free_Text__c,IPM_CMI_Result_Timing__c,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,
                                IPM_Project_Document_Section__c,IPM_CMI_Outcome_Color_Achieved__c,IPM_CMI_Results_Acheived__c,IPM_CMI_Outcome_Color__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c 
                         FROM IPM_Project_Document_Section_Content__c 
                         WHERE IPM_Content_Type__c=:IPM_ConstantUtils.CMIGATE_CONTENT_TYPE AND IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c=:gateDocument AND IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c=:projectId];
            }
            for(IPM_Project_Document_Section_Content__c pdsc:sectionList){
               if(restrictCountry==null){
                    resList.add(pdsc);
                    restrictCountry.add(pdsc.IPM_CMI_Country__c+pdsc.IPM_Gate_CMI__c);
                }
                if(restrictCountry!=null && !restrictCountry.contains(pdsc.IPM_CMI_Country__c+pdsc.IPM_Gate_CMI__c)){
                    resList.add(pdsc);
                    restrictCountry.add(pdsc.IPM_CMI_Country__c+pdsc.IPM_Gate_CMI__c);
                }
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMI_CONSOLIDATED_STR,
                GET_SECTION_CMI_LIST_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }  
    
    /************************************************************************************************************************
    *  Description For Showing Country Level CMI Data
    *  @name showList
    *  @param none
    *  @return void
    *  @throws query exception
    */
    public void showList(){
        try{
            gateCount=new Map<String,Integer>(); 
            ipmCMIGate = new IPM_Gate_CMI__c();
            gateTypes=new list<String>();
            project=new IPM_Project__c();
            charterCount=0;
            contractCount=0;
            marketReadyCount=0;
            //Getting Gate Types
            gateTypes.add(IPM_ConstantUtils.CHARTER_GATE);
            gateTypes.add(IPM_ConstantUtils.CONTRACT_GATE);
            gateTypes.add(IPM_ConstantUtils.MARKET_READY_GATE);
            
            project=[SELECT Id,IPM_Parent_Project__c FROM IPM_Project__c WHERE Id=:projectId];
            //Getting Project Document Section
            if(gateType==IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE){
                projDocSecList=[SELECT Id,IPM_CMI_Selected_Countries__c,IPM_CMI_Selected_Test_Concepts__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project_Span__c,IPM_Project_Document__r.IPM_GateDocuments__c 
                                FROM IPM_Project_Document_Section__c 
                                WHERE IPM_Master_Section_External_Id__c=:IPM_ConstantUtils.CMI_SECTION AND(IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c=:project.IPM_Parent_Project__c OR IPM_Project_Document__r.IPM_Project__c=:project.IPM_Parent_Project__c)];
            }
            else{
                projDocSecList=[SELECT Id,IPM_CMI_Selected_Countries__c,IPM_CMI_Selected_Test_Concepts__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project_Span__c,IPM_Project_Document__r.IPM_GateDocuments__c 
                                FROM IPM_Project_Document_Section__c 
                                WHERE IPM_Master_Section_External_Id__c=:IPM_ConstantUtils.CMI_SECTION AND(IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c=:projectId OR IPM_Project_Document__r.IPM_Project__c=:projectId)];
            }
            
            //Getting Countries List of Project
            getCountries();
            
            selectedCountryName=IPM_ConstantUtils.BLANK;
            for(IPM_Project_Document_Section__c projDocSec:projDocSecList){
                if(!String.isBlank(projDocSec.IPM_CMI_Selected_Countries__c)){
                    for(String country:projDocSec.IPM_CMI_Selected_Countries__c.split(IPM_ConstantUtils.SEMICOLON)){
                        for(IPM_Country__c availCountry:countryList){
                            if(country==availCountry.Country_Code__c){
                                if(String.isBlank(selectedCountryName)){
                                    selectedCountryName=country+IPM_ConstantUtils.SEMICOLON;
                                }
                                else{
                                    if(!selectedCountryName.contains(country)){
                                        selectedCountryName=selectedCountryName+country+IPM_ConstantUtils.SEMICOLON;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            mapCountryNameWithCode=new map<String,String>();
            if(!String.isBlank(selectedCountryName)){
                for(IPM_Country__c c:countryList){
                    mapCountryNameWithCode.put(c.Country_Code__c,c.Country_Name__c);
                }    
                countryNameList=selectedCountryName.split(IPM_ConstantUtils.SEMICOLON);
            }
            
            //Getting Gate CMI and CMI Contents List
            getSectionCMIList();   
             
            
            //Count of CMI Data per Gate    
            String selectedGateCMI=IPM_ConstantUtils.BLANK;         
            for(IPM_Gate_CMI__c gateCount:cmiList){
                if(String.isBlank(selectedGateCMI)){
                    selectedGateCMI=gateCount.Gate__c+IPM_ConstantUtils.Slash+gateCount.Element__c+IPM_ConstantUtils.Slash+gateCount.Test__c+IPM_ConstantUtils.Slash+IPM_ConstantUtils.SEMICOLON;
                }
                else{
                    selectedGateCMI=selectedGateCMI+gateCount.Gate__c+IPM_ConstantUtils.Slash+gateCount.Element__c+IPM_ConstantUtils.Slash+gateCount.Test__c+IPM_ConstantUtils.Slash+IPM_ConstantUtils.SEMICOLON;
                }
                if(gateCount.Gate__c==IPM_ConstantUtils.CHARTER_GATE){
                    charterCount++;
                }    
                if(gateCount.Gate__c==IPM_ConstantUtils.CONTRACT_GATE){
                    contractCount++;
                }    
                if(gateCount.Gate__c==IPM_ConstantUtils.MARKET_READY_GATE){
                    marketReadyCount++;     
                }    
            }

            gateCount.put(IPM_ConstantUtils.CHARTER_GATE,charterCount);
            gateCount.put(IPM_ConstantUtils.CONTRACT_GATE,contractCount);
            gateCount.put(IPM_ConstantUtils.MARKET_READY_GATE,marketReadyCount);    
            
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMI_CONSOLIDATED_STR,
                SHOW_LIST_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }   
    }
}