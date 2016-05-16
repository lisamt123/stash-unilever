/****************************************************************************************************************************
@Author: Cognizant
@Name: IPM_GateCMIController
@Created Date: 14/02/2015
@Description: To Create,Modify,Delete CMI Section
@Version: 1.0
@Reference: Project Document Section Editor Page
*/
public with sharing class IPM_GateCMIController{   
    public static final String IPM_GATECMICONTORLLER_STR = 'ipm_gatecmicontorller';
    public static final String COPY_CMI_SECTIONS = 'copyCMISections';
    public static final String GET_COUNTRIES_STR='getCountries';
    public static final String UPDATERESULTTIMING_STR='updateResultTiming';
    public String[] cmiNameList; //Contains List of Selected CMI Names
    public SObject ipmCMIGate; //Contains Gate CMI Object
    public String selectedCountryName; //Contains Country Names of Gate CMI
    public String openAccordian{get; set;} //to open corresponding accordian after creating test
    public Map<String,IPM_CMI_Color_Mapping__c> colorMapping;//For color coding the results
    public Map<String,IPM_CMI_Overall_Color_Mapping__c> overallColorMapping; //For Overall Color Code Mapping
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
    public list<SelectOption> gates{get;set;} //Contains Gate,Element,Test Values
    public list<SelectOption> countries{get;set;} //Contains Countries List
    public list<SelectOption> gateTypes{get;set;} //Contains Gate Document Types
    public list<SelectOption> elements{get;set;} //Contains Element Values
    public list<SelectOption> tests{get;set;} //Contains Test Values
    public list<SelectOption> consolidatedOptions{get;set;} //Contains Combination of Gate,Element and Test values
    public list<SelectOption> contractOptionList{get;set;}//Contains Combination of Gate,Element and Test values for contract gate
    public list<SelectOption> contractMarketReadyList{get;set;}//Contains Combination of Gate,Element and Test values for Market ready gate
    public String cmiName{get; set;} //Contains Selected CMI Names
    public String countryName{get; set;} //Contains Selected Countries Name
    public String[] countryNameList{get; set;} //Contains List of Selected Countries Name
    public List<IPM_Project_Document_Section_Content__c> sectionList{get; set;} //Contains List of CMI Section Contents List
    public List<IPM_Gate_CMI__c> cmiList{get; set;}  //Contains List of Gate CMI List
    public Boolean showCMI{get; set;} //Used for showing CMI Accordion
    public IPM_Project_Document_Section_Content__c secCon{get; set;} //Contains CMI Section Content
    public string secConId{get; set;} //Contains CMI Section Content Id
    public string resultCMI{get; set;} //Contains Selected Result Value
    public string commentsCMI{get; set;} //Contains Entered Comments
    public string gateCMIId{get; set;} //Contains Gate CMI Id
    public IPM_Gate_CMI__c gateCMI{get; set;} //Contains Gate CMI Record
    public Boolean isEditable{get;set;} //Used to Set Read-Only or Editable
    public Map<String,Integer> gateCount{get; set;} //Count of Gate CMI per Gate
    public Integer charterCount{get; set;} //Charter Gate Count
    public Integer contractCount{get; set;} //Contract Gate Count
    public Integer marketReadyCount{get; set;} //Market Ready Gate Count
    public IPM_Project_Document_Section__c projDocSec{get; set;} //Contains Project Document Section
    public String gateType{get; set;} //Contains Current Gate Document Type
    public String countryNameStr{get;set;}//contain selected country while deleting the record
    public Boolean isComment{get; set;}//For updating comments in CMI Content
    public Boolean isSkip{get; set;}//For skipping the test
    public String skipComment{get; set;}//For updating skipping comments
    public String[] selectedTestConcepts{get; set;}//For getting list of selected test concepts
    public Date resultTiming{get; set;} //To store result timing of test
    public String overallColorMethod{get; set;} //To check overall colour method system or manual
    public List<IPM_Project_Document_Section_Content__c> resList{get; set;} //For result timing 
    public String overallComments{get; set;} //For over all test comments
    public String overallScore{get; set;} //For over all test score
    public Boolean isEditActionStandard{get; set;} //To check action standards editable for market ready gate
    public List<IPM_Country__c> countryList;
    public map<String,String> mapCountryNameWithCode {get;set;}
    /****************************************************************************************************************************
    @description Getting Elements Picklist Values
    @return: Element Picklist values
    */
    public List<selectoption> getElements()  {           
        gates= getPicklistValues(ipmCMIGate ,IPM_ConstantUtils.ELEMENT_FIELD);
        return gates;
    }  
    
    /****************************************************************************************************************************
    @description Getting Test Picklist Values
    @return: Test Picklist values
    */
    public List<selectoption> getTests() {           
        gates= getPicklistValues(ipmCMIGate ,IPM_ConstantUtils.TEST_FIELD);
        return gates;
    }    
    
    /****************************************************************************************************************************
    @description Getting List of Countries in Project
    @return: Countries List
    */ 
    public List<selectOption> getCountries() { 
        countryList=new List<IPM_Country__c>();
        String soql  =  'SELECT Id,Country_Code__c,Country_Name__c,IPM_Project__c,IPM_Regional_Project__c,isActive__c FROM IPM_Country__c';
        if((gateType==IPM_ConstantUtils.CHARTER_GATE && projDocSec.IPM_Project_Document__r.IPM_Project_Span__c!=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL) || projDocSec.IPM_Project_Document__r.IPM_Project_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL){
            soql += ' WHERE IPM_Project__c = \'' + projectId + '\'';
        }
        else{
            soql += ' WHERE IPM_Regional_Project__c = \'' + projectId + '\'';
        }
        //soql+= ' AND isActive__c=true';
        try{
            countryList=Database.query(soql);   
        }
        catch(QueryException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,
                GET_COUNTRIES_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        countries = new List<SelectOption>();
        if(countryList != null && !countryList.isEmpty()){
            for(IPM_Country__c tempCountry : countryList){
              if(tempCountry.isActive__c){
                  countries.add(new SelectOption(tempCountry.Country_Name__c,tempCountry.Country_Code__c));
              }  
            }
        }
        return countries;
    }
    
    /****************************************************************************************************************************
    @description For Getting Values from Picklist Field
    @param: SObject,Field Name
    @return: Picklist Values
    */ 
    public list<SelectOption> getPicklistValues(SObject obj, String fld){
        list<SelectOption> options = new list<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();   
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        if(fieldMap.get(fld).getDescribe().getPickListValues()!=null){
            list<Schema.PicklistEntry> values =
            fieldMap.get(fld).getDescribe().getPickListValues();
            // Add these values to the selectoption list
            for (Schema.PicklistEntry a : values){ 
                options.add(new SelectOption(a.getLabel(), a.getValue())); 
            }
        }
        return options;
    }
    
    /****************************************************************************************************************************
     @description Getting Consolidated Gate,Elements and Test Picklist Values
     @return: Consolidated Gate,Element and Test Values
    */ 
    public List<selectoption> getGates() {           
        consolidatedOptions=new list<SelectOption>();
        contractOptionList=new list<SelectOption>();
        contractMarketReadyList=new list<SelectOption>();
        gates= getPicklistValues(ipmCMIGate ,IPM_ConstantUtils.GATE_FIELD);
        for(SelectOption gate:gates){
            for(SelectOption element: getElements()){
                for(SelectOption test: getTests()){
                    if(projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c==IPM_ConstantUtils.CHARTER_GATE){
                        if(gate.getValue()==IPM_ConstantUtils.CHARTER_GATE &&  element.getValue()==IPM_ConstantUtils.ELEMENT_CONCEPT  
                            && (test.getValue()==IPM_ConstantUtils.TEST_IDEA_SCREENER_NIELSEN || test.getValue()==IPM_ConstantUtils.TEST_INNOSCREEN_IDEAS || 
                                test.getValue()==IPM_ConstantUtils.TEST_SNAPSHOT || test.getValue()==IPM_ConstantUtils.TEST_INNOSCREEN_CONCEPTS || 
                                test.getValue()==IPM_ConstantUtils.TEST_BUNDLE_BUILDER || test.getValue()==IPM_ConstantUtils.TEST_BASES_I || 
                                test.getValue()==IPM_ConstantUtils.TEST_DESIGNER_PRE_USE || 
                                test.getValue()==IPM_ConstantUtils.TEST_QUAL_CONCEPT)){
                            consolidatedOptions.add(new SelectOption(gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue(), gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue())); 
                        }
                    }
                    if(projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c==IPM_ConstantUtils.CHARTER_GATE || 
                        projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c==IPM_ConstantUtils.CONTRACT_GATE){
                        if(gate.getValue()==IPM_ConstantUtils.CONTRACT_GATE &&  element.getValue()==IPM_ConstantUtils.ELEMENT_PRODUCT_TEST  
                            && (test.getValue()==IPM_ConstantUtils.TEST_BLIND_PRODUCT || test.getValue()==IPM_ConstantUtils.TEST_BRANDED_PRODUCT || 
                                test.getValue()==IPM_ConstantUtils.TEST_CONCEPT_PRODUCT)){
                            contractOptionList.add(new SelectOption(gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue(), gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue())); 
                        }
                        if(gate.getValue()==IPM_ConstantUtils.CONTRACT_GATE &&  element.getValue()==IPM_ConstantUtils.ELEMENT_PACK_TEST  && 
                            (test.getValue()==IPM_ConstantUtils.TEST_QUANT_PACK)){
                            contractOptionList.add(new SelectOption(gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue(), gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue())); 
                        }
                        if(gate.getValue()==IPM_ConstantUtils.CONTRACT_GATE &&  element.getValue()==IPM_ConstantUtils.ELEMENT_PACK_TEST  && 
                            (test.getValue()==IPM_ConstantUtils.TEST_QUAL_PACK_TEST)){
                            contractOptionList.add(new SelectOption(gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue(), gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue())); 
                        }
                        if(gate.getValue()==IPM_ConstantUtils.CONTRACT_GATE &&  element.getValue()==IPM_ConstantUtils.ELEMENT_FULL_MIX_VOLUME  
                            && (test.getValue()==IPM_ConstantUtils.TEST_BASES_II || test.getValue()==IPM_ConstantUtils.TEST_DESIGNER_POST_USE)){
                            contractOptionList.add(new SelectOption(gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue(), gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue())); 
                        }
                    }
                    if(projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c==IPM_ConstantUtils.CHARTER_GATE || projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c==IPM_ConstantUtils.CONTRACT_GATE || 
                        projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c==IPM_ConstantUtils.MARKET_READY_GATE){
                        
                        if(gate.getValue()==IPM_ConstantUtils.MARKET_READY_GATE &&  element.getValue()==IPM_ConstantUtils.ELEMENT_COMMUNICATION  
                            && (test.getValue()==IPM_ConstantUtils.TEST_PREVIEW_MWB)){
                            contractMarketReadyList.add(new SelectOption(gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue(), gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue())); 
                        }
                        
                        if(gate.getValue()==IPM_ConstantUtils.MARKET_READY_GATE &&  element.getValue()==IPM_ConstantUtils.ELEMENT_FULL_MIX_VOLUME  
                            && (test.getValue()==IPM_ConstantUtils.TEST_BASES_III || test.getValue()==IPM_ConstantUtils.TEST_DESIGNER_POST_USE_MIX)){
                            contractMarketReadyList.add(new SelectOption(gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue(), gate.getValue()+IPM_ConstantUtils.Slash+element.getValue()+IPM_ConstantUtils.Slash+test.getValue())); 
                        }
                    }
                }  
            }
        }
        return gates;
    }
    
    /**********************************************************************************************************************************
    * @description Getting Gate CMI and Section Content List 
    ***********************************************************************************************************************************/ 
    public void getSectionCMIList(){
        try{
            Set<String> restrictCountry=new Set<String>();  
            resList=new List<IPM_Project_Document_Section_Content__c>();   
            string Query='SELECT Id,IPM_CMI_Added_At__c,Gate__c,IPM_CMI_Overall_Colour_Score_Method__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c FROM IPM_Gate_CMI__c WHERE IPM_Project__c=:projectId';    
            if(gateType=='Charter'){
                Query=Query+' AND IPM_CMI_Added_At__c=\'Charter\'';
            }
            else if(gateType=='Contract'){
                Query=Query+' AND (IPM_CMI_Added_At__c=\'Charter\' OR IPM_CMI_Added_At__c=\'Contract\')';
            }
            cmiList=Database.Query(Query);
            sectionList=[SELECT Id,IPM_CMI_Overall_Colour_Achieved__c,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Color_Score_Achieved__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Score_Label__c,IPM_CMI_Free_Text__c,IPM_CMI_Overall_Comments__c,IPM_CMI_Is_Free_Text__c,IPM_CMI_Result_Timing__c,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,
                                IPM_Project_Document_Section__c,IPM_CMI_Outcome_Color_Achieved__c,IPM_CMI_Results_Acheived__c,IPM_CMI_Outcome_Color__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c 
                         FROM IPM_Project_Document_Section_Content__c 
                         WHERE IPM_Project_Document_Section__c=:projDocSecId];
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
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,
                            'getSectionCMIList',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }  
    
    /**********************************************************************************************************************************
    * @description For Showing Country Level CMI Data
    ***********************************************************************************************************************************/ 
    public void showList(){
        try{
            gateCount=new Map<String,Integer>(); 
            ipmCMIGate = new IPM_Gate_CMI__c();
            selectedTestConcepts=new List<String>();
            charterCount=0;
            contractCount=0;
            marketReadyCount=0;
            //Getting Gate Types
            gateTypes=getPicklistValues(ipmCMIGate ,IPM_ConstantUtils.GATE_FIELD); 
            
            //Getting Project Document Section
            projDocSec=[SELECT Id,IPM_CMI_Selected_Countries__c,IPM_CMI_Selected_Test_Concepts__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project_Span__c,IPM_Project_Document__r.IPM_GateDocuments__c 
                        FROM IPM_Project_Document_Section__c 
                        WHERE Id=:projDocSecId];
            
            //Getting Consolidate Gate,Element and Test Options
            getGates();
            
            //Getting Countries List of Project
            getCountries();
            
            //Getting Select Countries for CMI
            /*selectedCountryName=projDocSec.IPM_CMI_Selected_Countries__c;
            if(!String.isBlank(selectedCountryName)){
                countryNameList=selectedCountryName.split(IPM_ConstantUtils.SEMICOLON);
            }*/   
            selectedCountryName=IPM_ConstantUtils.BLANK;
            if(!String.isBlank(projDocSec.IPM_CMI_Selected_Countries__c)){
                for(String country:projDocSec.IPM_CMI_Selected_Countries__c.split(IPM_ConstantUtils.SEMICOLON)){
                    for(IPM_Country__c availCountry:countryList){
                        if(country==availCountry.Country_Code__c){
                            if(String.isBlank(selectedCountryName)){
                                selectedCountryName=country+IPM_ConstantUtils.SEMICOLON;
                            }
                            else{
                                selectedCountryName=selectedCountryName+country+IPM_ConstantUtils.SEMICOLON;
                            }
                        }
                    }
                }
            }
            if(projDocSec.IPM_CMI_Selected_Countries__c!=selectedCountryName){
                projDocSec.IPM_CMI_Selected_Countries__c=selectedCountryName;
                update projDocSec;
            }
            mapCountryNameWithCode=new map<String,String>();
            if(!String.isBlank(selectedCountryName)){
              countryNameList=selectedCountryName.split(IPM_ConstantUtils.SEMICOLON);
                for(IPM_Country__c c:countryList){
                    mapCountryNameWithCode.put(c.Country_Code__c,c.Country_Name__c);
                }    
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
            if(projDocSec.IPM_CMI_Selected_Test_Concepts__c!=selectedGateCMI){
                projDocSec.IPM_CMI_Selected_Test_Concepts__c=selectedGateCMI;
                update projDocSec;
            }
            gateCount.put(IPM_ConstantUtils.CHARTER_GATE,charterCount);
            gateCount.put(IPM_ConstantUtils.CONTRACT_GATE,contractCount);
            gateCount.put(IPM_ConstantUtils.MARKET_READY_GATE,marketReadyCount);    
            
            //Getting Color Coding for KPI Results
            colorMapping=new Map<String,IPM_CMI_Color_Mapping__c>();
            for(IPM_CMI_Color_Mapping__c color:IPM_CMI_Color_Mapping__c.getall().values()){
                colorMapping.put(color.Name,color);
            }
                  
            overallColorMapping=new Map<String,IPM_CMI_Overall_Color_Mapping__c>();
            for(IPM_CMI_Overall_Color_Mapping__c overallColor:IPM_CMI_Overall_Color_Mapping__c.getall().values()){
                overallColorMapping.put(overallColor.IPM_CMI_Test__c+overallColor.IPM_CMI_Input_Combination__c,overallColor);
            }
                        
            //For Showing CMI List
            if(cmiList != null && !cmiList.isEmpty()){
                showCMI=true;
            }    
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,
                            'showList',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }   
    }

    /**********************************************************************************************************************************
    * @description For Creating CMI Section Content
    ***********************************************************************************************************************************/ 
    public void createCMISections(){
        List<IPM_Gate_CMI__c> cmiGateList=new List<IPM_Gate_CMI__c>();
        Map<String,IPM_Gate_CMI_KPI_Inputs__c> testKPIMap=new Map<String,IPM_Gate_CMI_KPI_Inputs__c>();
        String[] testValues; //For Separating Gate,Element and Test Values 
        
        //Getting Project Document Section         
        projDocSec=[SELECT Id,IPM_CMI_Selected_Countries__c,IPM_CMI_Selected_Test_Concepts__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_GateDocuments__c 
                    FROM IPM_Project_Document_Section__c 
                    WHERE Id=:projDocSecId];
        
        //Getting Gate CMI Test's and Corresponding KPI's
        for(IPM_Gate_CMI_KPI_Inputs__c testKPI:IPM_Gate_CMI_KPI_Inputs__c.getall().values()){
            testKPIMap.put(testKPI.IPM_Test__c,testKPI);
        }    

        //Getting Selected Gate CMI's
        cmiNameList=cmiName.split(',');  
        for(Integer i=0;i<cmiNameList.size();i++){
            testValues=cmiNameList[i].split(IPM_ConstantUtils.Slash);
            IPM_Gate_CMI__c gateCMI=new IPM_Gate_CMI__c();
            gateCMI.IPM_Project__c=projectId;
            gateCMI.gate__c=testValues[0];
            gateCMI.Element__c=testValues[1];
            gateCMI.Test__c=testValues[2];
            gateCMI.IPM_CMI_Added_At__c=gateType;
            if(testKPIMap.get(gateCMI.Test__c)!=null){
                gateCMI.KPI__c = testKPIMap.get(gateCMI.Test__c).IPM_KPI__c;
                gateCMI.IPM_CMI_Overall_Colour_Score_Method__c= testKPIMap.get(gateCMI.Test__c).IPM_Overall_Colour_Score_Method__c;
            }   
            if(String.isBlank(projDocSec.IPM_CMI_Selected_Test_Concepts__c)){
                projDocSec.IPM_CMI_Selected_Test_Concepts__c=cmiNameList[i];
                cmiGateList.add(gateCMI);
            }
            else if(!projDocSec.IPM_CMI_Selected_Test_Concepts__c.contains(cmiNameList[i])){
                projDocSec.IPM_CMI_Selected_Test_Concepts__c=projDocSec.IPM_CMI_Selected_Test_Concepts__c+IPM_ConstantUtils.SEMICOLON+cmiNameList[i];
                cmiGateList.add(gateCMI);
            }    
        }
        
        //To Insert Gate CMI List
        if(cmiGateList != null && !cmiGateList.isEmpty()){
            try{
                Insert cmiGateList;
                Update projDocSec;
            }
            catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,
                            'createCMISections',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
        }   
        //Getting Gate CMI and CMI Contents List
        getSectionCMIList(); 
        
        //For Showing CMI List
        if(cmiList != null && !cmiList.isEmpty()){
            showCMI=true;
        }    
    }
    
    /**********************************************************************************************************************************
    * @description For Creating Country Level CMI Data Content
    ***********************************************************************************************************************************/ 
    public void createCountryCMI(){
        String[] inputsList;
        IPM_Gate_CMI_KPI_Inputs__c kpiInputs=new IPM_Gate_CMI_KPI_Inputs__c();
        List<IPM_Project_Document_Section_Content__c> projDocSecConList=new List<IPM_Project_Document_Section_Content__c>();
        //countryNameList=countryName.replaceAll( '\\s+', '').split(','); //Contains Selected Countries
        countryNameList=countryName.split(',');
        //Getting Gate CMI      
        gateCMI=[SELECT id,IPM_CMI_Added_At__c,Gate__c,Country__c,Element__c,Test__c,KPI__c,Input__c,Results__c,IPM_CMI_Overall_Colour_Score_Method__c,Approx_Results_Timing__c,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c 
                 FROM IPM_Gate_CMI__c 
                 WHERE Id=:gateCMIId];    
                 
        //Getting KPI Inputs
        for(IPM_Gate_CMI_KPI_Inputs__c kpi:IPM_Gate_CMI_KPI_Inputs__c.getall().values()){
            if(kpi.IPM_Test__c==gateCMI.Test__c && kpi.IPM_KPI__c==gateCMI.KPI__c){
                kpiInputs=kpi;
            }
        }
                   
        //Getting Project Document Section         
        projDocSec=[SELECT Id,IPM_CMI_Selected_Countries__c,IPM_CMI_Selected_Test_Concepts__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_GateDocuments__c 
                    FROM IPM_Project_Document_Section__c 
                    WHERE Id=:projDocSecId];
                    
        //Creating Gate CMI Content         
        for(Integer i=0;i<countryNameList.size();i++){
            if(String.isBlank(gateCMI.Country__c) || !gateCMI.Country__c.contains(countryNameList[i])){
                if(String.isBlank(kpiInputs.IPM_Inputs__c)){
                    IPM_Project_Document_Section_Content__c projDocSecCon=new IPM_Project_Document_Section_Content__c();
                    projDocSecCon.IPM_Gate_CMI__c=gateCMI.Id;
                    projDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.CMIGATE_CONTENT_TYPE;
                    projDocSecCon.IPM_CMI_Country__c=countryNameList[i];
                    projDocSecCon.IPM_CMI_Is_Free_Text__c=true;
                    projDocSecCon.IPM_Project_Document_Section__c=projDocSecId;
                    projDocSecCon.IPM_CMI_Overall_Colour_Coding_Method__c=kpiInputs.IPM_Overall_Colour_Score_Method__c;
                    projDocSecCon.IPM_CMI_Overall_Score_Label__c=kpiInputs.IPM_Overall_Score_Label__c;
                    projDocSecConList.add(projDocSecCon);
                }
                else{
                    inputsList=kpiInputs.IPM_Inputs__c.split(',');
                    for(Integer j=0;j<inputsList.size();j++){
                        IPM_Project_Document_Section_Content__c projDocSecCon=new IPM_Project_Document_Section_Content__c();
                        projDocSecCon.IPM_Gate_CMI__c=gateCMI.Id;
                        projDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.CMIGATE_CONTENT_TYPE;
                        projDocSecCon.IPM_CMI_Country__c=countryNameList[i];
                        projDocSecCon.IPM_CMI_Input__c=inputsList[j];
                        projDocSecCon.IPM_Project_Document_Section__c=projDocSecId;
                        projDocSecCon.IPM_CMI_Overall_Colour_Coding_Method__c=kpiInputs.IPM_Overall_Colour_Score_Method__c;
                        projDocSecCon.IPM_CMI_Overall_Score_Label__c=kpiInputs.IPM_Overall_Score_Label__c;
                        projDocSecConList.add(projDocSecCon);
                    }
                }
                //Mapping Selected Country in Gate CMI and Project Document Section
                if(String.isBlank(gateCMI.Country__c)){
                    gateCMI.Country__c=countryNameList[i];
                }    
                else{
                    gateCMI.Country__c=gateCMI.Country__c+IPM_ConstantUtils.SEMICOLON+countryNameList[i];
                }
                    
                if(String.isBlank(projDocSec.IPM_CMI_Selected_Countries__c)){
                    projDocSec.IPM_CMI_Selected_Countries__c=countryNameList[i];
                }    
                else if(!projDocSec.IPM_CMI_Selected_Countries__c.contains(countryNameList[i])){
                    projDocSec.IPM_CMI_Selected_Countries__c=projDocSec.IPM_CMI_Selected_Countries__c+IPM_ConstantUtils.SEMICOLON+countryNameList[i];
                }    
            }
        }   
        try{
            if(projDocSecConList != null && !projDocSecConList.isEmpty()){
                insert projDocSecConList;
            }    
            update projDocSec;
            update gateCMI;
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,
                            'createCountryCMI',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        
        //Getting Gate CMI and CMI Contents List
        getSectionCMIList();
        showList();
       
        //For Showing CMI List
        if(cmiList != null && !cmiList.isEmpty()){
            showCMI=true;
        }    
    }
    
    /**********************************************************************************************************************************
    * @description For Updating country level CMI data
    ***********************************************************************************************************************************/
    public void updateCMI(){ 
        try{
            secCon=new IPM_Project_Document_Section_Content__c();
            secCon=[SELECT Id,IPM_CMI_Overall_Colour_Achieved__c,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Color_Score_Achieved__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Score_Label__c,IPM_CMI_Free_Text__c,IPM_CMI_Is_Free_Text__c,IPM_CMI_Result_Timing__c,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,
                            IPM_Project_Document_Section__c,IPM_CMI_Outcome_Color_Achieved__c,IPM_CMI_Results_Acheived__c,IPM_CMI_Outcome_Color__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c 
                     FROM IPM_Project_Document_Section_Content__c 
                     WHERE Id=:secConId];
            if(secCon!=null){
                if(isComment){
                    secCon.IPM_CMI_Comments__c=commentsCMI; 
                }
                else{
                    if(secCon.IPM_CMI_Is_Free_Text__c){
                        secCon.IPM_CMI_Free_Text__c=resultCMI;
                    }
                    else{
                        if(colorMapping!=null && !String.isBlank(colorMapping.get(resultCMI).IPM_CMI_Color__c)){
                            if(gateType==IPM_ConstantUtils.CHARTER_GATE || !isEditActionStandard){
                                secCon.IPM_CMI_Outcome_Color__c=colorMapping.get(resultCMI).IPM_CMI_Color__c;
                            }
                            else{
                                secCon.IPM_CMI_Outcome_Color_Achieved__c=colorMapping.get(resultCMI).IPM_CMI_Color__c;
                            }
                        }
                        if(colorMapping!=null && !String.isBlank(colorMapping.get(resultCMI).IPM_Color_Score_Value__c) && (gateType==IPM_ConstantUtils.CHARTER_GATE || !isEditActionStandard)){
                                secCon.IPM_CMI_Color_Score_Value__c=colorMapping.get(resultCMI).IPM_Color_Score_Value__c;
                        }
                        if(colorMapping!=null && !String.isBlank(colorMapping.get(resultCMI).IPM_Color_Score_Value__c) && gateType!=IPM_ConstantUtils.CHARTER_GATE && isEditActionStandard){
                                secCon.IPM_CMI_Color_Score_Value_Achieved__c=colorMapping.get(resultCMI).IPM_Color_Score_Value__c;
                        }
                        if(gateType==IPM_ConstantUtils.CHARTER_GATE || !isEditActionStandard){
                            secCon.IPM_CMI_Result__c=resultCMI;
                        }    
                        else{
                            secCon.IPM_CMI_Results_Acheived__c=resultCMI;
                        }
                    }
                }    
                update secCon;
                if(String.isNotBlank(secCon.IPM_CMI_Overall_Colour_Coding_Method__c) && secCon.IPM_CMI_Overall_Colour_Coding_Method__c=='System'){
                    overallScoreColor(secCon.IPM_CMI_Country__c,secCon.IPM_Gate_CMI__c,isEditActionStandard,secCon.IPM_Project_Document_Section__c);
                }
            }
        }
        catch(DMLException ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,
                            'updateCMI',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        
        //Getting Gate CMI and CMI Contents List
        getSectionCMIList();
        
        //For Showing CMI List
        if(cmiList != null && !cmiList.isEmpty()){
            showCMI=true;
        }    
    }
    
    public void overallScoreColor(String country,String gateCMIId,Boolean isActiveStandard,String secId){
        List<IPM_Project_Document_Section_Content__c> secColorList=new List<IPM_Project_Document_Section_Content__c>();
        String cmiInput='';
        secColorList=[SELECT Id,IPM_CMI_Overall_Colour_Achieved__c,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Color_Score_Achieved__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Score_Label__c,IPM_CMI_Result__c,IPM_CMI_Country__c,IPM_CMI_Results_Acheived__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Gate_Test__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c 
                      FROM IPM_Project_Document_Section_Content__c 
                      WHERE IPM_Gate_CMI__c=:gateCMIId and IPM_Project_Document_Section__c=:secId and IPM_CMI_Country__c=:country];
        for(IPM_Project_Document_Section_Content__c ipdsc:secColorList){
            if(String.isBlank(cmiInput)){
                if(gateType==IPM_ConstantUtils.CHARTER_GATE || !isEditActionStandard){
                    cmiInput=cmiInput+ipdsc.IPM_CMI_Result__c;
                }
                else{   
                    cmiInput=cmiInput+ipdsc.IPM_CMI_Results_Acheived__c;
                }   
            }   
            else{
                if(gateType==IPM_ConstantUtils.CHARTER_GATE || !isEditActionStandard){
                    cmiInput=cmiInput+'/'+ipdsc.IPM_CMI_Result__c;
                }
                else{
                    cmiInput=cmiInput+'/'+ipdsc.IPM_CMI_Results_Acheived__c;
                }   
            }   
        }              
        for(IPM_Project_Document_Section_Content__c ipdsc:secColorList){
            if(overallColorMapping.get(ipdsc.IPM_CMI_Gate_Test__c+cmiInput)!=null){
                if(gateType==IPM_ConstantUtils.CHARTER_GATE || !isEditActionStandard){
                    ipdsc.IPM_CMI_Overall_Score__c=overallColorMapping.get(ipdsc.IPM_CMI_Gate_Test__c+cmiInput).IPM_CMI_Overall_Score__c;
                    ipdsc.IPM_CMI_Overall_Colour__c=overallColorMapping.get(ipdsc.IPM_CMI_Gate_Test__c+cmiInput).IPM_CMI_Overall_Score_Colour__c;
                }
                else{
                    ipdsc.IPM_CMI_Overall_Score_Achieved__c=overallColorMapping.get(ipdsc.IPM_CMI_Gate_Test__c+cmiInput).IPM_CMI_Overall_Score__c;
                    ipdsc.IPM_CMI_Overall_Colour_Achieved__c=overallColorMapping.get(ipdsc.IPM_CMI_Gate_Test__c+cmiInput).IPM_CMI_Overall_Score_Colour__c;
                }
            }
            else{
                if(gateType==IPM_ConstantUtils.CHARTER_GATE || !isEditActionStandard){
                    ipdsc.IPM_CMI_Overall_Colour__c='';
                }
                else{
                    ipdsc.IPM_CMI_Overall_Colour_Achieved__c='';
                }
            }
        } 
        update secColorList;     
    }
    /**********************************************************************************************************************************
    * @description For Deleting Gate CMI
    ***********************************************************************************************************************************/
    public void deleteCMI(){
        try{
            String availableCMI='';
            String deletedCMI='';
            List<IPM_Project_Document_Section_Content__c> delContent=new List<IPM_Project_Document_Section_Content__c>();
            gateCMI=new IPM_Gate_CMI__c();
            if(!String.isBlank(gateCMIId)){
                gateCMI=[SELECT Id,IPM_CMI_Added_At__c,Gate__c,Element__c,Test__c,IPM_CMI_Overall_Colour_Score_Method__c FROM IPM_Gate_CMI__c WHERE Id=:gateCMIId];
                delContent=[SELECT Id FROM IPM_Project_Document_Section_Content__c WHERE IPM_Gate_CMI__c=:gateCMIId];
                if(delContent!=null && !delContent.isEmpty()){
                    delete delContent;
                }
                deletedCMI=gateCMI.Gate__c+'/'+gateCMI.Element__c+'/'+gateCMI.Test__c;
                delete gateCMI;
                
                //Removing CMI from selected CMI list 
                for(String cmi:projDocSec.IPM_CMI_Selected_Test_Concepts__c.split(IPM_ConstantUtils.SEMICOLON)){
                    if(cmi!=deletedCMI){
                        availableCMI=availableCMI+cmi+IPM_ConstantUtils.SEMICOLON;
                    }
                }
                projDocSec=new IPM_Project_Document_Section__c();
                projDocSec.Id=projDocSecId;
                projDocSec.IPM_CMI_Selected_Test_Concepts__c=availableCMI;
                update projDocSec;
            }
        }       
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,
                            'deleteCMI',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        
        //Getting Gate CMI and CMI Contents List
        getSectionCMIList();
        showList();
                
        //For Showing CMI List
        if(cmiList != null && !cmiList.isEmpty()){
            showCMI=true;
        }    
    }
      
    /**********************************************************************************************************************************
    * @description For Deleting Country Level Gate CMI Content
    ***********************************************************************************************************************************/
    public void deleteCountry(){
        try{
            List<IPM_Project_Document_Section_Content__c>countrydelList=new List<IPM_Project_Document_Section_Content__c>();
            String availableCountry='';
            Integer countryCount;
            countrydelList=[SELECT Id FROM IPM_Project_Document_Section_Content__c
                            WHERE IPM_Gate_CMI__c=:gateCMIId AND IPM_CMI_Country__c=:countryNameStr LIMIT 1000];
            gateCMI=[SELECT Id,Country__c,IPM_CMI_Added_At__c FROM IPM_Gate_CMI__c WHERE Id=:gateCMIId LIMIT 1];                
            if(countrydelList!=null && !countrydelList.isEmpty()){
                delete countrydelList; 
                
                //Removing country from selected countries 
                for(String country:gateCMI.Country__c.split(IPM_ConstantUtils.SEMICOLON)){
                    if(country!=countryNameStr){
                        availableCountry=availableCountry+country+IPM_ConstantUtils.SEMICOLON;
                    }
                }
                gateCMI.Country__c=availableCountry;
                update gateCMI;
                countryCount=[SELECT Count() FROM IPM_Project_Document_Section_Content__c WHERE IPM_CMI_Country__c=:countryNameStr];
                If(countryCount<1){
                    availableCountry='';
                    //Removing country from selected countries 
                    for(String country:projDocSec.IPM_CMI_Selected_Countries__c.split(IPM_ConstantUtils.SEMICOLON)){
                        if(country!=countryNameStr){
                            availableCountry=availableCountry+country+IPM_ConstantUtils.SEMICOLON;
                        }
                    }
                    projDocSec=new IPM_Project_Document_Section__c();
                    projDocSec.Id=projDocSecId;
                    projDocSec.IPM_CMI_Selected_Countries__c=availableCountry;
                    update projDocSec;
                }
            }
        }       
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,
                            'deleteCountry',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        
        //Getting Gate CMI and CMI Contents List
        showList();
        getSectionCMIList();
        
        //For Showing CMI List
        if(cmiList != null && !cmiList.isEmpty()){
            showCMI=true;
        }    
    }
    
    /**********************************************************************************************************************************
    @description For Skipping CMI Test
    **********************************************************************************************************************************/ 
    public void skipTest(){
        try{
            List<IPM_Project_Document_Section_Content__c> delContent=new List<IPM_Project_Document_Section_Content__c>();
            gateCMI=new IPM_Gate_CMI__c();
            if(!String.isBlank(gateCMIId)){
                gateCMI.Id=gateCMIId;
                if(isSkip){
                    delContent=[SELECT Id FROM IPM_Project_Document_Section_Content__c WHERE IPM_Gate_CMI__c=:gateCMIId];
                    if(delContent!=null && !delContent.isEmpty()){
                        delete delContent;
                    }   
                    gateCMI.IPM_Skip_Test__c=true;
                    gateCMI.Country__c='';
                    update gateCMI; 
                }
                else{
                    gateCMI.IPM_Skip_Test__c=false;
                    update gateCMI;
                }
                
            }
            //Getting Gate CMI and CMI Contents List
            getSectionCMIList();
            showList();
           
            //For Showing CMI List
            if(cmiList != null && !cmiList.isEmpty()){
                showCMI=true;
            }    
        }       
        catch(Exception ex){ 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,'skipTest',ex.getMessage(),
                ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
    }
    
    /**********************************************************************************************************************************
    @description For updating skip test reason
    *******************************************************************************************************************/ 
    public void updateSkipTestReason(){
        try{
            gateCMI=new IPM_Gate_CMI__c();
            if(!String.isBlank(gateCMIId)){
                gateCMI.Id=gateCMIId;
                gateCMI.IPM_Skip_Test_Reason__c=skipComment;
                update gateCMI;
            }
        }       
        catch(Exception ex){ 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,
                            'updateSkipTestReason',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /**********************************************************************************************************************************
    @description For updating reult timing
    *******************************************************************************************************************/ 
    public void updateResultTiming(){
        try{
            List<IPM_Project_Document_Section_Content__c> updateResultTimingList=new List<IPM_Project_Document_Section_Content__c>();
            if(!String.isBlank(gateCMIId)){
                updateResultTimingList=[SELECT id,IPM_CMI_Overall_Colour_Achieved__c,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Color_Score_Achieved__c,IPM_CMI_Overall_Score_Label__c,IPM_CMI_Result_Timing__c,IPM_Gate_CMI__c,IPM_CMI_Overall_Comments__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c FROM IPM_Project_Document_Section_Content__c 
                                        WHERE IPM_Gate_CMI__c=:gateCMIId and IPM_CMI_Country__c=:countryNameStr];
                for(IPM_Project_Document_Section_Content__c pdsc:updateResultTimingList){
                    if(isComment){
                        pdsc.IPM_CMI_Overall_Comments__c=overallComments;
                    }
                    else{
                        pdsc.IPM_CMI_Result_Timing__c=resultTiming;
                    }
                }
                update updateResultTimingList;                      
            }
        }       
        catch(Exception ex){ 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,
                            'updateResultTiming',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    public void updateOverallScore(){
         try{
            List<IPM_Project_Document_Section_Content__c> updateOverallScore=new List<IPM_Project_Document_Section_Content__c>();
            if(!String.isBlank(gateCMIId)){
                updateOverallScore=[SELECT id,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Overall_Colour_Achieved__c,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Color_Score_Achieved__c,IPM_CMI_Overall_Score_Label__c,IPM_CMI_Result_Timing__c,IPM_Gate_CMI__c,IPM_CMI_Overall_Comments__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c FROM IPM_Project_Document_Section_Content__c 
                                        WHERE IPM_Gate_CMI__c=:gateCMIId and IPM_CMI_Country__c=:countryNameStr];
                for(IPM_Project_Document_Section_Content__c pdsc:updateOverallScore){
                        if(gateType==IPM_ConstantUtils.CHARTER_GATE || !isEditActionStandard){
                            pdsc.IPM_CMI_Overall_Score__c=overallScore;
                            if(colorMapping.get(overallScore).IPM_CMI_Color__c!=null){
                                pdsc.IPM_CMI_Overall_Colour__c=colorMapping.get(overallScore).IPM_CMI_Color__c;
                            }
                            else{
                                pdsc.IPM_CMI_Overall_Colour__c='';
                            }
                            if(colorMapping.get(overallScore).IPM_Color_Score_Value__c!=null){
                                pdsc.IPM_CMI_Color_Score_Value__c=colorMapping.get(overallScore).IPM_Color_Score_Value__c;
                            }
                            else{
                                pdsc.IPM_CMI_Color_Score_Value__c='';
                            }
                        }
                        else{
                            pdsc.IPM_CMI_Overall_Score_Achieved__c=overallScore;
                            if(colorMapping.get(overallScore).IPM_CMI_Color__c!=null){
                                pdsc.IPM_CMI_Overall_Colour_Achieved__c=colorMapping.get(overallScore).IPM_CMI_Color__c;
                            }
                            else{
                                pdsc.IPM_CMI_Overall_Colour_Achieved__c='';
                            }
                            if(colorMapping.get(overallScore).IPM_Color_Score_Value__c!=null){
                                pdsc.IPM_CMI_Overall_Color_Score_Achieved__c=colorMapping.get(overallScore).IPM_Color_Score_Value__c;
                            }
                            else{
                                pdsc.IPM_CMI_Overall_Color_Score_Achieved__c='';
                            }
                        }
                }
                update updateOverallScore;                      
            }
        }       
        catch(Exception ex){ 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATECMICONTORLLER_STR,
            	UPDATERESULTTIMING_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    } 
}