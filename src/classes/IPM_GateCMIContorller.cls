public class IPM_GateCMIContorller
{   public Id projectId {
        get{
            return projectId ;
        }
        set{
            projectId = value;
        }} 
    public Id projDocSecId {
        get{
            return projDocSecId;
        }
        set{
            projDocSecId= value;
            showList();
        }}
    public list<SelectOption> gates{get;set;}
    public list<SelectOption> countries{get;set;}
    public list<SelectOption> gateTypes{get;set;}
    public list<SelectOption> elements{get;set;}
    public list<SelectOption> tests{get;set;}
    public list<SelectOption> consolidatedOptions{get;set;}
    public String cmiName{get; set;}
    public String countryName{get; set;}
    public String[] cmiNameList;
    public String[] countryNameList{get; set;}
    public List<IPM_Project_Document_Section_Content__c> sectionList{get; set;}
    public List<IPM_Gate_CMI__c> cmiList{get; set;}
    public Boolean showCMI{get; set;}
    public IPM_Project_Document_Section_Content__c secCon{get; set;}
    public string secConId{get; set;}
    public string resultCMI{get; set;}
    public string commentsCMI{get; set;}
    public string gateCMIId{get; set;}
    public IPM_Gate_CMI__c gateCMI{get; set;}
    public Boolean isEditable{get;set;}
    public SObject ipmCMIGate;
    public Map<String,Integer> gateCount{get; set;}
    public Integer charterCount{get; set;}
    public Integer contractCount{get; set;}
    public Integer marketReadyCount{get; set;}
    public IPM_Project_Document_Section__c projDocSec{get; set;}
    public String selectedCountryName;
    public String gateType{get; set;}
    public List<selectoption> getElements() 
    {           
        //SObject ipmCMIGate = new IPM_Gate_CMI__c();
        gates= getPicklistValues(ipmCMIGate ,'Element__c');
        return gates;
        
    }  
    public List<selectoption> getTests() 
    {           
        //SObject ipmCMIGate = new IPM_Gate_CMI__c();
        gates= getPicklistValues(ipmCMIGate ,'Test__c');
        return gates;
        
    }    
    public List<selectOption> getCountries() 
    {           
        List<IPM_Country__c> countryList=[Select Id,Country_Name__c,IPM_Project__c from IPM_Country__c where IPM_Project__c=:projectId];
        countries = new List<SelectOption>();
        for(Integer i=0;i<countryList.size();i++)
        {
            countries.add(new SelectOption(countryList[i].Country_Name__c,countryList[i].Country_Name__c));
        }
        return countries;
    }
    public list<SelectOption> getPicklistValues(SObject obj, String fld)
    {
        list<SelectOption> options = new list<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        
        if(fieldMap!=null){
            if(fieldMap.get(fld)!=null)
            {
                if(fieldMap.get(fld).getDescribe()!=null)
                {
                    if(fieldMap.get(fld).getDescribe().getPickListValues()!=null)
                    {
                        list<Schema.PicklistEntry> values =
                        fieldMap.get(fld).getDescribe().getPickListValues();
                        // Add these values to the selectoption list.
                        for (Schema.PicklistEntry a : values)
                        { 
                            options.add(new SelectOption(a.getLabel(), a.getValue())); 
                            
                            
                        }
                    }
                }
            }
        }
        return options;
    }
    public List<selectoption> getGates() 
    {           
        consolidatedOptions=new list<SelectOption>();
        //SObject ipmCMIGate = new IPM_Gate_CMI__c();
        gates= getPicklistValues(ipmCMIGate ,'Gate__c');
        System.debug(gates+'gates');
        for(SelectOption gate:gates)
        {
            list<SelectOption> elements=  getElements();
            
            for(SelectOption element: elements){
                
                list<SelectOption> tests=getTests();
                
                for(SelectOption test: tests){
                    
                    //Conditions
                    //1
                    if(projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c=='Charter')
                    {
                        if(gate.getValue()=='Charter' &&  element.getValue()=='Concept'  && (test.getValue()=='Idea Screener - Nielsen' || test.getValue()=='Innoscreen * ideas - Ipsos' || test.getValue()=='Snapshot - Nielsen' || test.getValue()=='Innoscreen * Concepts - Ipsos' || test.getValue()=='Bundle Builder -Nielsen' || test.getValue()=='Bases I - Nielsen' || test.getValue()=='Designor pre use - Ipsos' ))
                        {
                            
                            consolidatedOptions.add(new SelectOption(gate.getValue()+'/'+element.getValue()+'/'+test.getValue(), gate.getValue()+'/'+element.getValue()+'/'+test.getValue())); 
                            
                        }
                    }
                    if(projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c=='Charter' || projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c=='Contract')
                    {
                        //2
                        if(gate.getValue()=='Contract' &&  element.getValue()=='Product Test'  && (test.getValue()=='Blind Product Test - Ipsos' || test.getValue()=='Branded Product Test - Ipsos' || test.getValue()=='Concept Product test - Ipsos'))
                        {
                            
                            consolidatedOptions.add(new SelectOption(gate.getValue()+'/'+element.getValue()+'/'+test.getValue(), gate.getValue()+'/'+element.getValue()+'/'+test.getValue())); 
                            
                        }
                        //3
                        if(gate.getValue()=='Contract' &&  element.getValue()=='Pack Test'  && (test.getValue()=='Quant Pack test - PRS PackEval'))
                        {
                            
                            consolidatedOptions.add(new SelectOption(gate.getValue()+'/'+element.getValue()+'/'+test.getValue(), gate.getValue()+'/'+element.getValue()+'/'+test.getValue())); 
                            
                        }
                        
                        //4
                        if(gate.getValue()=='Contract' &&  element.getValue()=='Full Mix-Volume'  && (test.getValue()=='Bases II - Nielsen' || test.getValue()=='Designor post use - Ipsos' || test.getValue()=='Bases III - Nielsen' || test.getValue()=='Designor post use with full mix - Ipsos'))
                        {
                            
                            consolidatedOptions.add(new SelectOption(gate.getValue()+'/'+element.getValue()+'/'+test.getValue(), gate.getValue()+'/'+element.getValue()+'/'+test.getValue())); 
                            
                        }
                    }
                    if(projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c=='Charter' || projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c=='Contract' || projDocSec.IPM_Project_Document__r.IPM_GateDocuments__c=='Market Ready')
                    {
                        //5
                        if(gate.getValue()=='Market Ready' &&  element.getValue()=='Communication'  && (test.getValue()=='Preview - MWB'))
                        {
                            
                            consolidatedOptions.add(new SelectOption(gate.getValue()+'/'+element.getValue()+'/'+test.getValue(), gate.getValue()+'/'+element.getValue()+'/'+test.getValue())); 
                            
                        }
                        //6
                        if(gate.getValue()=='Market Ready' &&  element.getValue()=='Full Mix-Volume'  && (test.getValue()=='Bases II - Nielsen' || test.getValue()=='Designor post use - Ipsos' || test.getValue()=='Bases III - Nielsen' || test.getValue()=='Designor post use with full mix - Ipsos'))
                        {
                            
                            consolidatedOptions.add(new SelectOption(gate.getValue()+'/'+element.getValue()+'/'+test.getValue(), gate.getValue()+'/'+element.getValue()+'/'+test.getValue())); 
                            
                        }
                    }
                }  
            }
            
        }
        return gates;
    }
    public IPM_GateCMIContorller()
    {
    }   
    public void showList()
    {   
        projDocSec=[Select Id,IPM_CMI_Selected_Countries__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_GateDocuments__c from IPM_Project_Document_Section__c where Id=:projDocSecId];
        gateCount=new Map<String,Integer>();
        //SObject ipmCMIGate = new IPM_Gate_CMI__c();
        ipmCMIGate = new IPM_Gate_CMI__c();
        gateTypes=getPicklistValues(ipmCMIGate ,'Gate__c'); 
        getGates();
        getCountries();
        charterCount=[Select count() from IPM_Gate_CMI__c where Gate__c='Charter' and IPM_Project__c=:projectId];
        gateCount.put('Charter',charterCount);
        contractCount=[Select count() from IPM_Gate_CMI__c where Gate__c='Contract' and IPM_Project__c=:projectId];
        gateCount.put('Contract',contractCount);
        marketReadyCount=[Select count() from IPM_Gate_CMI__c where Gate__c='Market Ready' and IPM_Project__c=:projectId];
        gateCount.put('Market Ready',marketReadyCount);
        selectedCountryName=projDocSec.IPM_CMI_Selected_Countries__c;
        if(selectedCountryName!=null && selectedCountryName!='')
        countryNameList=selectedCountryName.split(';');
        cmiList=[Select id,Gate__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c from IPM_Gate_CMI__c where IPM_Project__c=:projectId];
        sectionList=[Select id,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,IPM_Project_Document_Section__c,IPM_CMI_Results_Acheived__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId];
        if(cmiList.size()>0)
        showCMI=true;
        System.debug('From Constructor'+cmiList);    
        System.debug('From Constructor'+sectionList);  
    }

    public void createCMISections()
    {
        List<IPM_Gate_CMI__c> cmiGateList=new List<IPM_Gate_CMI__c>();
        List<IPM_Gate_CMI__c> existingGateList=new List<IPM_Gate_CMI__c>();
        System.debug(projectId+'projectId');
        existingGateList=[Select id,Gate__c,Country__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Approx_Results_Timing__c from IPM_Gate_CMI__c where IPM_Project__c=:projectId];    
        Map<String,IPM_Gate_CMI__c> existingGateCMI=new Map<String,IPM_Gate_CMI__c>();
        for(IPM_Gate_CMI__c gc:existingGateList)
        {
            existingGateCMI.put(gc.Gate__c+gc.Element__c+gc.Test__c,gc);
        }
        System.debug(existingGateCMI+'existingGateCMI');
        cmiNameList=cmiName.split(',');
        String[] testValues;
        for(Integer i=0;i<cmiNameList.size();i++)
        {
            testValues=cmiNameList[i].split('/');
            IPM_Gate_CMI__c gateCMI=new IPM_Gate_CMI__c();
            gateCMI.IPM_Project__c=projectId;
            gateCMI.gate__c=testValues[0];
            gateCMI.Element__c=testValues[1];
            gateCMI.Test__c=testValues[2];
            if(gateCMI.Test__c =='Idea Screener - Nielsen'){
                gateCMI.KPI__c = 'Salience/Attraction Matrix';
            }
            if(gateCMI.Test__c =='Designor pre use - Ipsos' || gateCMI.Test__c =='Designor post use with full mix - Ipsos' || gateCMI.Test__c =='Innoscreen * ideas - Ipsos' || gateCMI.Test__c =='Innoscreen * Concepts - Ipsos'|| gateCMI.Test__c =='Designor post use - Ipsos'){
                gateCMI.KPI__c = 'RED';
            }
            if(gateCMI.Test__c =='Snapshot - Nielsen' || gateCMI.Test__c =='Bundle Builder -Nielsen' || gateCMI.Test__c =='Bases I - Nielsen'){
                gateCMI.KPI__c = 'IntroSCAPE';
            }
            if(gateCMI.Test__c =='Qual Pack Test' || gateCMI.Test__c =='Qual Concept'){
                gateCMI.KPI__c = 'Judgement call';
            }
            if(gateCMI.Test__c =='Blind Product Test - Ipsos' || gateCMI.Test__c =='Branded Product Test - Ipsos' || gateCMI.Test__c =='Concept Product test - Ipsos'){
                gateCMI.KPI__c = 'Overall Score';
            }
            if(gateCMI.Test__c =='Quant Pack test - PRS PackEval'){
                gateCMI.KPI__c = 'Performance';
            }
            if(gateCMI.Test__c =='Preview - MWB'){
                gateCMI.KPI__c = 'Persuation/Awareness';
            }
            if(gateCMI.Test__c =='Bases II - Nielsen' || gateCMI.Test__c =='Bases III - Nielsen'){
                gateCMI.KPI__c = 'SCAPE';
            } 
            if(!existingGateCMI.containsKey(gateCMI.Gate__c+gateCMI.Element__c+gateCMI.Test__c))
            cmiGateList.add(gateCMI);
        }
        if(cmiGateList.size()>0)
        Insert cmiGateList;
        System.debug(cmiGateList+'cmiGateList');
        cmiList=[Select id,Gate__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c from IPM_Gate_CMI__c where IPM_Project__c=:projectId];
        
        showCMI=true;
    }
    public void createCountryCMI()
    {
        System.debug('createCountryCMI');
        List<IPM_Project_Document_Section_Content__c> projDocSecConList=new List<IPM_Project_Document_Section_Content__c>();
        countryNameList=countryName.split(',');
        //selectedCountryName='';
        String[] inputsList;
        gateCMI=[Select id,Gate__c,Country__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Approx_Results_Timing__c from IPM_Gate_CMI__c where Id=:gateCMIId];    
        System.debug('gateCMI'+gateCMI);
        System.debug('countryNameList'+countryNameList);
        IPM_Gate_CMI_KPI_Inputs__c kpiInputs=new IPM_Gate_CMI_KPI_Inputs__c();
        kpiInputs=[Select Name,IPM_Test__c,IPM_KPI__c,IPM_Inputs__c from IPM_Gate_CMI_KPI_Inputs__c where IPM_Test__c=:gateCMI.Test__c and IPM_KPI__c=:gateCMI.KPI__c];
        System.debug(kpiInputs+'kpiInputs');
        projDocSec=[Select Id,IPM_CMI_Selected_Countries__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_GateDocuments__c from IPM_Project_Document_Section__c where Id=:projDocSecId];
        for(Integer i=0;i<countryNameList.size();i++)
        {
            if(gateCMI.Country__c==null || !gateCMI.Country__c.contains(countryNameList[i]))
            {
                System.debug(selectedCountryName+'selectedCountryName'+countryNameList[i]+'countryNameList[i]');
                //selectedCountryName=selectedCountryName+countryNameList[i]+';';
                inputsList=kpiInputs.IPM_Inputs__c.split(',');
                System.debug(inputsList+'inputsList');
                for(Integer j=0;j<inputsList.size();j++)
                {
                    IPM_Project_Document_Section_Content__c projDocSecCon=new IPM_Project_Document_Section_Content__c();
                    projDocSecCon.IPM_Gate_CMI__c=gateCMI.Id;
                    projDocSecCon.IPM_CMI_Country__c=countryNameList[i];
                    projDocSecCon.IPM_CMI_Input__c=inputsList[j];
                    projDocSecCon.IPM_Project_Document_Section__c=projDocSecId;
                    projDocSecConList.add(projDocSecCon);
                }
                if(gateCMI.Country__c==null)
                gateCMI.Country__c=countryNameList[i];
                else
                gateCMI.Country__c=gateCMI.Country__c+';'+countryNameList[i];
                if(projDocSec.IPM_CMI_Selected_Countries__c==null)
                projDocSec.IPM_CMI_Selected_Countries__c=countryNameList[i];
                else if(!projDocSec.IPM_CMI_Selected_Countries__c.contains(countryNameList[i]))
                projDocSec.IPM_CMI_Selected_Countries__c=projDocSec.IPM_CMI_Selected_Countries__c+';'+countryNameList[i];
            }
        }   
        System.debug(projDocSecConList+'projDocSecConList');
        
        if(projDocSecConList.size()>0)
            Insert projDocSecConList;
        /*if(projDocSec.IPM_CMI_Selected_Countries__c==null || projDocSec.IPM_CMI_Selected_Countries__c=='')
        {
            if(selectedCountryName!=null && selectedCountryName!='')
                projDocSec.IPM_CMI_Selected_Countries__c=selectedCountryName;
        }    
        else
        {
            if(!projDocSec.IPM_CMI_Selected_Countries__c.contains(selectedCountryName))    
                projDocSec.IPM_CMI_Selected_Countries__c=projDocSec.IPM_CMI_Selected_Countries__c+';'+selectedCountryName;
        }    */
        update projDocSec;
        //gateCMI.Country__c=selectedCountryName;
        update gateCMI;
        System.debug(projDocSecConList+'projDocSecConList');
        cmiList=[Select id,Gate__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c from IPM_Gate_CMI__c where IPM_Project__c=:projectId];
        sectionList=[Select id,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,IPM_Project_Document_Section__c,IPM_CMI_Results_Acheived__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId];
        System.debug(sectionList+'sectionList');
        showCMI=true;
    }
    public void updateCMI()
    {
        System.debug('I am coming'+resultCMI);
        secCon=[Select id,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,IPM_Project_Document_Section__c,IPM_CMI_Results_Acheived__c from IPM_Project_Document_Section_Content__c where Id=:secConId];
        if(gateType=='Charter')
        secCon.IPM_CMI_Result__c=resultCMI;
        else
        secCon.IPM_CMI_Results_Acheived__c=resultCMI;
        secCon.IPM_CMI_Comments__c=commentsCMI;
        update secCon;
        System.debug('secCon'+secCon);
        cmiList=[Select id,Gate__c,Element__c,Test__c,KPI__c,Input__c,Country__c,Results__c,Approx_Results_Timing__c from IPM_Gate_CMI__c where IPM_Project__c=:projectId];
        sectionList=[Select id,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,IPM_Project_Document_Section__c,IPM_CMI_Results_Acheived__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId];
    }
    public void deleteCMI()
    {
        gateCMI=[Select id,Gate__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Approx_Results_Timing__c from IPM_Gate_CMI__c where Id=:gateCMIId]; 
        delete gateCMI;
        cmiList=[Select id,Gate__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c from IPM_Gate_CMI__c where IPM_Project__c=:projectId];
        sectionList=[Select id,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,IPM_Project_Document_Section__c,IPM_CMI_Results_Acheived__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId];
    }
    public void deleteCountry()
    {
        secCon=[Select id,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,IPM_Project_Document_Section__c,IPM_CMI_Results_Acheived__c from IPM_Project_Document_Section_Content__c where Id=:secConId];
        delete secCon;
        cmiList=[Select id,Gate__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c from IPM_Gate_CMI__c where IPM_Project__c=:projectId];
        sectionList=[Select id,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,IPM_Project_Document_Section__c,IPM_CMI_Results_Acheived__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId];
    }
   
    /* For Copyover CMI Sections to Contract,Market Ready Document*/
     @future
    public static void copyCMISections(Set<Id> parentIds,Set<Id> projIds,string gateModel)
    {
       List<IPM_Gate_CMI__c> gateCMIList=new List<IPM_Gate_CMI__c>();
       System.debug(parentIds+'parentIds'+projIds+'projIds');
       gateCMIList=[Select Id,IPM_Project__c,Gate__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c from IPM_Gate_CMI__c where (Gate__c='Contract' OR Gate__c='Market Ready') and IPM_Project__c In:parentIds];
       System.debug(gateCMIList+'gateCMIList');
       Set<Id> gateCMIIds=new Set<Id>();
       List<IPM_Project_Document_Section_Content__c> projDocSecConList=new List<IPM_Project_Document_Section_Content__c>();
       List<IPM_Country__c> countryList=new List<IPM_Country__c>();
       //For Countries
       countryList=[Select Id,Country_Name__c,IPM_Regional_Project__c from IPM_Country__c where IPM_Regional_Project__c in:projIds];
       System.debug(countryList+'countryList');
       String[] Countries;
       for(IPM_Gate_CMI__c gc:gateCMIList)
       {
            gateCMIIds.add(gc.Id);
       }
       System.debug(gateCMIIds+'gateCMIIds');
       for(IPM_Project_Document_Section_Content__c pdsc:[Select id,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_Gate_CMI__r.Test__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c,IPM_CMI_Results_Acheived__c from IPM_Project_Document_Section_Content__c where IPM_Gate_CMI__c In:gateCMIIds])
       {
            projDocSecConList.add(pdsc);
       }
       System.debug(projDocSecConList+'projDocSecConList');
       List<IPM_Project_Document_Section__c> contractProjDocSec=new List<IPM_Project_Document_Section__c>();
       contractProjDocSec=[Select Id,IPM_Section_Sequence_Number__c,IPM_CMI_Selected_Countries__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c,IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c from IPM_Project_Document_Section__c where IPM_Section_Sequence_Number__c='3.7' and IPM_Project_Document__r.IPM_Project__c In:projIds];
       List<IPM_Gate_CMI__c> insertGateCMIList=new List<IPM_Gate_CMI__c>();
       System.debug(contractProjDocSec+'contractProjDocSec');
       String cmiCountries;
       Boolean avail=false;
       for(IPM_Project_Document_Section__c pds:contractProjDocSec)
       {
            for(IPM_Gate_CMI__c gcl:gateCMIList)
            {
                avail=false;
                if(pds.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c==gcl.IPM_Project__c)
                {
                    IPM_Gate_CMI__c gateCMI=new IPM_Gate_CMI__c();
                    gateCMI.IPM_Project__c=pds.IPM_Project_Document__r.IPM_Project__c;
                    gateCMI.Gate__c=gcl.Gate__c;
                    gateCMI.Element__c=gcl.Element__c;
                    gateCMI.Test__c=gcl.Test__c;
                    gateCMI.KPI__c=gcl.KPI__c;
                    gateCMI.Input__c=gcl.Input__c;
                    gateCMI.Results__c=gcl.Results__c;
                    for(IPM_Country__c c:countryList)
                    {
                    System.debug(gcl.Country__c+'gcl.Country__c'+c.IPM_Regional_Project__c+'c.IPM_Regional_Project__c'+pds.IPM_Project_Document__r.IPM_Project__c+'pds.IPM_Project_Document__r.IPM_Project__c'+c.Country_Name__c+'c.Country_Name__c');
                        if(gcl.Country__c!=null && c.IPM_Regional_Project__c==pds.IPM_Project_Document__r.IPM_Project__c && gcl.Country__c.contains(c.Country_Name__c))
                        {
                            if(gateCMI.Country__c==null)
                            gateCMI.Country__c=c.Country_Name__c;
                            else
                            gateCMI.Country__c=gateCMI.Country__c+';'+c.Country_Name__c;
                            avail=true;
                        }
                    }
                    //gateCMI.Country__c=gcl.Country__c;
                    gateCMI.Approx_Results_Timing__c=gcl.Approx_Results_Timing__c;
                    if(avail==true)
                    insertGateCMIList.add(gateCMI);
                }
            }
       }
       if(insertGateCMIList.size()>0)
       Insert insertGateCMIList;
       System.debug(insertGateCMIList+'insertGateCMIList');
       Set<Id> insertGateCMIListIds=new Set<Id>();
       for(IPM_Gate_CMI__c igc:insertGateCMIList)
       {
            insertGateCMIListIds.add(igc.Id);
       }
       List<IPM_Gate_CMI__c> newInsertGateCMIList=new List<IPM_Gate_CMI__c>();
       newInsertGateCMIList=[Select Id,IPM_Project__c,IPM_Project__r.IPM_Parent_Project__c,Gate__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c from IPM_Gate_CMI__c where Id In:insertGateCMIListIds];
       System.debug(newInsertGateCMIList+'newInsertGateCMIList');
       List<IPM_Project_Document_Section_Content__c> insertprojDocSecConList=new List<IPM_Project_Document_Section_Content__c>();
       String selectedCountries;
       String[] gateCountries;
       for(IPM_Project_Document_Section__c pds:contractProjDocSec)
       {
            selectedCountries=pds.IPM_CMI_Selected_Countries__c;
            for(IPM_Gate_CMI__c gcl:newInsertGateCMIList)
            {
                if(pds.IPM_Project_Document__r.IPM_Project__c==gcl.IPM_Project__c)
                {   
                    for(IPM_Country__c c:countryList)
                    {
                        if(gcl.Country__c!=null && c.IPM_Regional_Project__c==pds.IPM_Project_Document__r.IPM_Project__c && gcl.Country__c.contains(c.Country_Name__c))
                        {
                            if(selectedCountries==null)
                            selectedCountries=c.Country_Name__c;
                            else
                            {
                                if(!selectedCountries.contains(c.Country_Name__c))
                                selectedCountries=selectedCountries+';'+c.Country_Name__c;
                            }
                        }
                    }
                    /*if(selectedCountries=='' || selectedCountries==null)
                    selectedCountries=gcl.Country__c;
                    else
                    {
                        gateCountries=gcl.Country__c.split(';');
                        for(Integer k=0;k<gateCountries.size();k++)
                        {
                            if(!selectedCountries.contains(gateCountries[k]))
                            selectedCountries=selectedCountries+';'+gateCountries[k];
                        }
                    }*/
                    
                    for(IPM_Project_Document_Section_Content__c pdsc:projDocSecConList)
                    {
                        if(pdsc.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c==pds.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c)
                        {
                            if(gcl.Test__c==pdsc.IPM_Gate_CMI__r.Test__c)
                            {
                                IPM_Project_Document_Section_Content__c projDocSecCon=new IPM_Project_Document_Section_Content__c();
                                projDocSecCon.IPM_CMI_Country__c=pdsc.IPM_CMI_Country__c;
                                //projDocSecCon.IPM_Gate_CMI__c=pdsc.IPM_Gate_CMI__c;
                                projDocSecCon.IPM_CMI_Input__c=pdsc.IPM_CMI_Input__c;
                                projDocSecCon.IPM_CMI_Comments__c=pdsc.IPM_CMI_Comments__c;
                                projDocSecCon.IPM_CMI_Result__c=pdsc.IPM_CMI_Result__c;
                                projDocSecCon.IPM_CMI_Country__c=pdsc.IPM_CMI_Country__c;
                                projDocSecCon.IPM_Project_Document_Section__c=pds.Id;
                                projDocSecCon.IPM_Gate_CMI__c=gcl.Id;
                                insertprojDocSecConList.add(projDocSecCon);
                            }
                        }
                    }
                }
            }
            pds.IPM_CMI_Selected_Countries__c=selectedCountries;    
       }
       update contractProjDocSec;
       insert insertprojDocSecConList;
       System.debug(insertprojDocSecConList+'insertprojDocSecConList');
    }
}