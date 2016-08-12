/******************************************** 
*@Author:Cognizant
*@Date:October 2014
*@Description : To create coreparameters
*Referring in page ipm_ProjectSetupView page 
*********************************************/
public with sharing class IPM_Coreparameters extends IPM_ProjectIntermediateController {
    
    Public Map<String, IPM_BET_Search_Fields__c> betCustomSettings = IPM_BET_Search_Fields__c.getAll();
    Public List<String> dataSetNames= new List<String>();
    Public  List<String> columnLabels{get{if(columnLabels==null){ checkLabel();} return columnLabels; } private set;}
    Public  List<String> classProperties {get{if(classProperties==null) {checkLabel();} return classProperties ; } private set;}
    Public  Map<String,boolean> classPropertiesMap {get{if(classPropertiesMap==null) {checkLabel();} return classPropertiesMap ; } private set;}
    Public void checkLabel(){
        dataSetNames.addAll(betCustomSettings.keySet());
        dataSetNames.sort();
        columnLabels= new List<String>();
        classProperties= new List<String>();
        classPropertiesMap =new Map<String,boolean>();
        for (String dataSetName : dataSetNames) {
            IPM_BET_Search_Fields__c betCoulmn = betCustomSettings.get(dataSetName );
            columnLabels.add(betCoulmn.Field_Label__c);
            classProperties.add(betCoulmn.Field_Name__c);
            classPropertiesMap.put(betCoulmn.Field_Name__c,betCoulmn.Is_Date__c);
        }
    }
    // Boolean to control rendering of BET Search Component
    public boolean bLinkBET {get;set;}
    //Variable to store reset BET options
    public string resetBEToption;
    
    //*@description: store project id from url parameter
    public string ProjectID{get;set;}
    //*@description: get details of coreparameter
    public IPM_Project__c IPM_Coreparameter{get;set;}
    //*@description: store selected answer for question
    public string SelectedAnswer{get;set;}
    //*@description: core parameters help text for question no 1
    public IPM_CorePara_helps_example__c lstIpmCoreHelp{get;set;}
    //*@description: core parameters help text for question no 2
    public IPM_CorePara_helps_example__c lstIpmCoreHelpQ2{get;set;}
    //*@description: core parameters help text for question no 3
    public IPM_CorePara_helps_example__c lstIpmCoreHelpQ3{get;set;}
    //*@description: Display successfull message of question number two
    public Boolean saveQuestionTwo{get;set;}
    //*@description: Specifies user access permission
    Public Boolean isEditable{get;set;}
    //*@description: get sub sector data
    public list<selectoption>lstsubsector{get;set;}
    //*@Description: To store Coreparametershelp records.
    public List<IPM_CorePara_helps_example__c> coParametersList{get; set;}
    //*@Description: no toolkit
    Public Boolean isNoToolkit{get;set;}
    //*@description:list of questions
    public List<string> questiononeList{get;set;}
    public List<string> questiontwoList{get;set;}
    public List<string> questionthreeList{get;set;}
    public IPM_CoreParameter_Configration__c coreConfig{get;set;}//configuration of core parameter
    public IPM_InnovationRenovation__c innovationRenovation{get;set;}//get innovation or innovation data
    public list<selectoption>lstmarket{get;set;}//list of market oprions
    public string strategicHelpText{get;set;}//store strategic help text
    public IPM_Coreparameter_Graph__c strategicGraphTick{get;set;}//store strategic graph tick mark
    public string editCoreParameterURL{get;set;}//get the url parameter value
    public string editAdditionaParameter{get;set;}//get the url parameter value
    public boolean isEditCoreparameter{get;set;}//show edit core parameter
    public boolean isAdditionalCoreparameter{get;set;}//show additional parameter
    public boolean isThresholdSaved{get;set;}
    public IPM_Category__c ipm_CategoryVal{get;set;}//category rendered values
    public string answerone_STR{get;set;}//answer one value
    public string answertwo_STR{get;set;}//answer two value
    public string answerthree_STR{get;set;}//answer three value
    public string market_STR{get;set;}//market value
    public string subSector_STR{get;set;}//subsector value
    public string betValue_STR{get;set;}//bet value
    public string checked_STR{get;set;}//used in JS
    public string unchecked_STR{get;set;}//used in JS
    public string ple_STR{get;set;}//PLE phase
    public boolean isOperational{get;set;}//check for operational project
    public boolean isOriginal{get;set;}//check for original project
    public final String IPM_COREPARAMETERREVAMP_STR = IPM_ProjectIntermediateController.IPM_Coreparameters.class.getName();
    public static final string UPDATECOREPRAMETER='updateCoreParameter';
    @TestVisible private string coretickMark;
    @TestVisible private string selCat;
    public boolean isShowFastTOrWhiteS{get;set;}//check for display fasttrack or whitespace
    public boolean isEditCoreparamPage{get;set;}//check for edit access on edit button
    public boolean isMPAEditable{get;set;}//check for display MPA question
    public boolean isCPVEditable{get;set;}//check for display CPV question
    public boolean isETEditable{get;set;}//check for display ET question
    public boolean isMPABack{get;set;}//check for display MPA back button
    public boolean isEditCoreparam{get;set;}//used for security
    public boolean editplatform{get;set;}//used for security
    public boolean isAdditionalPara{get;set;}//used for security
    public boolean editSubSector{get;set;}//used for security
    public boolean editMarketActivityByPL{get;set;}//used for security
    public boolean editMPAByBD{get;set;}//used for security
    public boolean editCPVByBD{get;set;}//used for security
    public boolean editETByTPL{get;set;}//used for security
    public boolean isExemptFromThresholdITO{get;set;}//check if the project is eligible to set Exempt From Threshold iTO
    //*@description: BET Search related Changes: Start
    Public  BET_BETWrapper SelectedBet{get;set;}
    public map<id, string> mapIdOwner {get; set;} 
    public map<id, string> mapIdBrandPos = new map<id, string>();
    @TestVisible private boolean extraEditable;  
    public string operationalSlider_STR{get;set;}//operational css value
    public string operationaPointer_STR{get;set;}//operational css value
    public string answerChecked_STR{get;set;}//css value
    public string answerUnChecked_STR{get;set;}//css value
    public Boolean isRegRollout {get; set;} // true if project is regional rollout
    public String projbetlink {
    get{
        If (IPM_Coreparameter.BET_Link_Requested__c!=null ){
            return IPM_Coreparameter.BET_Link_Requested__c;
        }
        else if(string.isNotBlank(IPM_Coreparameter.bet__c)){
            return IPM_Coreparameter.bet__c;    
        }
        else{
            return null;
        }
    } 
    set;
    }
    Public BET_BETWrapper PreSelectedBet{
    get{
        if(string.isNotBlank(projbetlink)){
            return BET_BETService.getBet(projbetlink);
        }
        else{
            return null;
        }
    }
    set;
    }
    public String searchstring{get;set;}
    public string betId{get;set;}
    public string betName{get;set;}
    public boolean isEmptySearchResult {get { if(isEmptySearchResult==null) { isEmptySearchResult  =false;} return isEmptySearchResult ;} set;}
    Public List<IPM_BET_BETWrapper> searchresultBet{
        get{
            if(searchresultBet==null)
            {
                searchresultBet=new List<IPM_BET_BETWrapper>();
            }
                return searchresultBet;
        } 
        set;    
    }
    
    public List<selectoption> availableBrands{get;set;} 
    public Boolean isBrandVisible{get;set;}
    /****************************************************************************
    @Description: MEthod to unlink BET from IPM Project
    *****************************************************************************/
    Public pageReference Replace(){
        bLinkBET = true;
        IPM_Project__c updateProj =new IPM_Project__c(id=projectid);
        updateProj.BET_Link_Requested__c='';
        updateProj.BET_Link_Requested_on_Date__c=null;
        updateProj.BET__c = null;
        if(String.isNotBlank(IPM_Coreparameter.BET__c)){
            BET_LinkingService.unfollow(projectid,IPM_Coreparameter.BET__c);    
        }
        update updateProj ;             
        projbetlink = '';
        betId = '';
        IPM_Coreparameter.BET_Link_Requested__c=null;
        IPM_Coreparameter.BET_Link_Requested_on_Date__c=null;
        IPM_Coreparameter.BET__c = null;
        return null;
    } 
    /****************************************************************************
    @Description : search BET method - calls BET method to retrieve search results.
    *****************************************************************************/
    public void searchBET(){
        Map<String,BET_BETWrapper> betWapMap =new  Map<String,BET_BETWrapper>();   
        set<id> setOwnerIds = new set<id>();
        set<id> setBrandPosIds = new set<id>();
        searchresultBet =new List<IPM_BET_BETWrapper>();
        id categoryId=null;
        if(IPM_Coreparameter.IPM_category_text__c!=null){
            list<mdo_category__c> lstCat = new list<mdo_category__c>();
            lstCat = [select id from mdo_category__c where name = :IPM_Coreparameter.IPM_category_text__c and category_type__c = :IPM_ConstantUtils.CATEGORY_TYPE and status__c = :IPM_ConstantUtils.CATEGORY_STATUS_ACTIVE LIMIT 1];
            if(!lstCat.isEmpty()){
                categoryId = lstCat[0].id;  
            }
        }
        List<BET_BETWrapper> searchBet = new List<BET_BETWrapper>();
        searchBet = BET_BETService.searchBet(searchstring,categoryId,null);
        for (BET_BETWrapper bw : searchBet ){
            if(!bw.isArchived){
                betWapMap.put(bw.betId ,bw);
                setOwnerIds.add(bw.betOwner);
                setBrandPosIds.add(bw.brandPosition);
            }
        }
        if(searchBet.isEmpty()){
            isEmptySearchResult = true;
        }
        else{
            isEmptySearchResult = false;
        }
        
        
        if(!setOwnerIds.isEmpty()){
            mapIdOwner= new map<id, string>();
            for(user usr : [select id, firstname, lastName from user where id in :setOwnerIds LIMIT 1000]){
                mapIdOwner.put(usr.id,(usr.firstname!=null?usr.firstname+' ':'')+usr.LastName);      
            }
        }
        if(!setBrandPosIds.isEmpty()){
            mapIdBrandPos = new map<id, string>();
            for(MDO_BrandPosition__c brnd: [select id, Name from MDO_BrandPosition__c where id in :setBrandPosIds LIMIT 1000]){
                mapIdBrandPos.put(brnd.id,brnd.Name);       
            }
        }
        for(string it :  betWapMap .keyset()){
            IPM_BET_BETWrapper temp = new IPM_BET_BETWrapper(betWapMap.get(it));
            if(betWapMap.get(it).betOwner!=null && !mapIdOwner.isEmpty() && mapIdOwner.containskey(betWapMap.get(it).betOwner)){
                temp.OwnerName = mapIdOwner.get(betWapMap.get(it).betOwner);     
            }
            if(betWapMap.get(it).brandPosition!=null && !mapIdBrandPos.isEmpty() && mapIdBrandPos.containskey(betWapMap.get(it).brandPosition)){
                temp.brandPos = mapIdBrandPos.get(betWapMap.get(it).brandPosition);      
            }
            searchresultBet.add(temp);
        }
    } 
    public Boolean reactivateProjFlag; 
    /**BET Search related Changes: End**/
    /****************************************************************************
    @Description : constructor To initialize IPM_CoreParameterRevamp object
    *****************************************************************************/
    public ipm_Coreparameters (){
        
        // call utility class to save having to do this multiple times in multiple places
        super();
        reactivateProjFlag = project.Is_Archieved__c;
        IPM_IECompatible.ieFix();    
        initialise();
        bLinkBET = true;
        If(IPM_Coreparameter!=null && (IPM_Coreparameter.BET_Link_Requested__c!=null || String.isNotBlank(IPM_Coreparameter.BET__c))){
            bLinkBET = false;
        }
        resetBEToption = IPM_Coreparameter.IPM_BET_Toolkit__c;
        
        if(IPM_ConstantUtils.PROJECT_SPAN_LOCAL.equals(IPM_Coreparameter.IPMProject_Span__c) && IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equals(IPM_Coreparameter.IPM_Project_Type__c))
        {   
            isBrandVisible=true;
            
        }
    }
    @TestVisible private  void initialise(){
        isEditCoreparameter=false;
        isShowFastTOrWhiteS=false;
        isEditCoreparamPage=false;
        isMPAEditable=false;
        isCPVEditable=false;
        isETEditable=false;
        isMPABack=false;
        isEditCoreparam=false;
        isAdditionalPara=false;
        editSubSector=false;
        editplatform = false;
        editMPAByBD=false;
        editCPVByBD=false;
        editETByTPL=false;
        extraEditable=false; 
        isRegRollout=false; 
        isExemptFromThresholdITO=false;
        operationalSlider_STR=IPM_ConstantUtils.IPM_OPERATIONAL_SLIDER;
        operationaPointer_STR=IPM_ConstantUtils.IPM_OPERATIONAL_BLUEPOINTER;
        answerChecked_STR=IPM_ConstantUtils.IPM_ANSWER_CHECKED;
        answerUnChecked_STR=IPM_ConstantUtils.IPM_ANSWER_UNCHECKED;
        coretickMark=IPM_ConstantUtils.BLANK;
        selCat=IPM_ConstantUtils.BLANK;
        market_STR=IPM_ConstantUtils.BLANK;
        subSector_STR=IPM_ConstantUtils.BLANK;
        betValue_STR=IPM_ConstantUtils.BLANK;
        isAdditionalCoreparameter=false;
        isEditable=false;
        checked_STR=IPM_ConstantUtils.CHECKED;
        unchecked_STR=IPM_ConstantUtils.UNCHECKED;
        ple_STR=IPM_ConstantUtils.PHASE_PLE;
        saveQuestionTwo=false;
        answerone_STR=IPM_ConstantUtils.BLANK;
        answertwo_STR=IPM_ConstantUtils.BLANK;
        answerthree_STR=IPM_ConstantUtils.BLANK;
        SelectedAnswer=IPM_ConstantUtils.BLANK;
        ProjectID=IPM_ConstantUtils.BLANK;
        strategicHelpText=IPM_ConstantUtils.BLANK;
        isNoToolkit=true;
        isOriginal=false;
        isOperational=false;
        editcoreParameterURL=IPM_ConstantUtils.BLANK;
        editAdditionaParameter=IPM_ConstantUtils.BLANK;
        coreConfig=new IPM_CoreParameter_Configration__c();
        InnovationRenovation=new IPM_InnovationRenovation__c ();
        lstIpmCoreHelpQ2=new IPM_CorePara_helps_example__c();
        lstIpmCoreHelpQ3=new IPM_CorePara_helps_example__c();
        ipm_CategoryVal=new IPM_Category__c();
        ProjectID=apexpages.currentpage().getparameters().get(IPM_ConstantUtils.SF_ID ); 
        editcoreParameterURL=apexpages.currentpage().getparameters().get(IPM_ConstantUtils.EDITPARAMETER);
        editAdditionaParameter=apexpages.currentpage().getparameters().get(IPM_ConstantUtils.ADDITIONALPARAMETER);
        if(string.isNotBlank(editcoreParameterURL)){
            isEditCoreparameter=true;
        }
         if(string.isNotBlank(editAdditionaParameter)){
            isAdditionalCoreparameter=true;
        }
        if(string.isBlank(ProjectID)){
            ProjectID=apexpages.currentpage().getparameters().get(IPM_ConstantUtils.IPM_Project_PID);
        }
        

        IPM_Coreparameter=new IPM_Project__c();
        lstIpmCoreHelp=new IPM_CorePara_helps_example__c();
        getProjectDetails();
        getCoreparameterConfig();
        getcoreparameterHelps();                   
        getAllQuestions();
        getCoreStrategicIntent();
        if(project!=null && !reactivateProjFlag){
            getIpmuserType();   
        }
        getCategoryValue();
		if(ipm_CategoryVal !=null && ipm_CategoryVal.IPM_Sector__c)
        {
        	subSector_STR=IPM_Coreparameter.IPM_Sector__c;	
        }
        getsubsector();//common method for market,sub sector and sector
        getStrategicGraph();
        betValue();
        getAccessonPage();
        //Reset BET option for eligible IPM Projects
        if(string.isNotBlank(resetBEToption) && IPM_Coreparameter.BET_Link_Requested__c==null && IPM_Coreparameter.BET__c==null){
            IPM_Coreparameter.IPM_BET_Toolkit__c = resetBEToption;  
        }
        searchstring = '';
        searchresultBet.clear();
        betId = '';
        
    }
    /****************************************************************************
    @Description :Method to get core parameter configuration
    *****************************************************************************/
   @TestVisible private void getCoreparameterConfig(){
        String projectSubType=IPM_ConstantUtils.BLANK;
        if(IPM_Coreparameter.IPM_ProjectSubType__c!=null){
            if(IPM_Coreparameter.IPM_ProjectSubType__c.Equals(IPM_ConstantUtils.IPM_BLG)){
                IPM_Coreparameter.IPM_Answer_of_Q1__c=IPM_ConstantUtils.BLG;
                answerone_STR=IPM_ConstantUtils.BLG;
                projectSubType=answerone_STR;
            }else{
             projectSubType=IPM_Coreparameter.IPM_ProjectSubType__c;   
            }
            coreConfig=IPM_CoreParameter_Configration__c.getInstance(projectSubType);
            
            if(coreConfig!=null && !coreConfig.IPM_CPV__c){
                IPM_Coreparameter.IPM_Answer_of_Q2__c=system.Label.IPM_Not_Applicable_Core;
            }
            if(coreConfig!=null && !coreConfig.IPM_ET__c){
                IPM_Coreparameter.IPM_Answer_of_Q3__c=system.Label.IPM_Not_Applicable_Core;
            } 
      }
        
    }
    /****************************************************************************
    @Description :Method to get category rendered value
    *****************************************************************************/
    @TestVisible private void getCategoryValue(){
        if(IPM_Coreparameter.IPM_Category_Text__c!=null){
            ipm_CategoryVal=IPM_Category__c.getInstance(IPM_Coreparameter.IPM_Category_Text__c);
        }   
    }
    /****************************************************************************
    @Description :Method to get core parameter strategic intent
    *****************************************************************************/
    @TestVisible private void getCoreStrategicIntent(){ 
        if(string.isNotBlank(answerone_STR) && string.isNotBlank(answertwo_STR) && string.isNotBlank(answerthree_STR)){
            Map<string,IPM_InnovationRenovation__c> allpossibaleMap=IPM_InnovationRenovation__c.getAll();
            for(IPM_InnovationRenovation__c innoReno:allpossibaleMap.Values()){
                if(answertwo_STR.Contains(innoReno.IPM_CPV__c) && 
                    answerthree_STR.Contains(innoReno.IPM_ET__c)){
                    InnovationRenovation=innoReno;
                }
            }
            if(InnovationRenovation.IPM_Renovation__c){
                IPM_Coreparameter.IPM_Strategic_Intent__c=IPM_ConstantUtils.CORE_STRATEGIC_RENOVATION;
            }
            else{
                IPM_Coreparameter.IPM_Strategic_Intent__c=IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION;
            }
        }           
        if(IPM_ConstantUtils.IPM_BLG.equals(IPM_Coreparameter.IPM_ProjectSubType__c)){
            IPM_Coreparameter.IPM_Strategic_Intent__c=IPM_ConstantUtils.BLG;
        }
        if(IPM_ConstantUtils.IPM_OPERATIONAL.equals(IPM_Coreparameter.IPM_ProjectSubType__c)){
            IPM_Coreparameter.IPM_Strategic_Intent__c=IPM_ConstantUtils.IPM_OPERATIONAL;
        }
        //to get strategic intent help text based on strategic intent
        if(IPM_Coreparameter.IPM_Strategic_Intent__c!=null){
            MAP<String,IPM_CoreParameter_Configration__c>strategicHelpMap=IPM_CoreParameter_Configration__c.getAll();
            for(IPM_CoreParameter_Configration__c sHelp:strategicHelpMap.Values()){
                if(IPM_Coreparameter.IPM_Strategic_Intent__c.equals(sHelp.Name) && sHelp.IPM_Help_Text__c!=null){
                    strategicHelpText=sHelp.IPM_Help_Text__c + IPM_ConstantUtils.IPM_SPACE;
                }
                if(IPM_Coreparameter.IPM_Strategic_Intent__c.equals(sHelp.Name) && sHelp.IPM_Help_Text_Two__c!=null){
                    strategicHelpText=strategicHelpText+sHelp.IPM_Help_Text_Two__c;
                }
            }
        }
   }
   /****************************************************************************
    @Description :method to get strategic graph based on selected answer's
    *****************************************************************************/
    public void getStrategicGraph(){
        coretickMark=IPM_ConstantUtils.BLANK;
        if(IPM_Coreparameter.IPM_ProjectSubType__c!=null){
            if(IPM_Coreparameter.IPM_ProjectSubType__c.Equals(IPM_ConstantUtils.IPM_INNOVATION_RENOVATION)){
                coretickMark=answerthree_STR+IPM_ConstantUtils.IPM_BACKSLASH + answertwo_STR;      
            }
            if(IPM_Coreparameter.IPM_ProjectSubType__c.Equals(IPM_ConstantUtils.IPM_BLG)){
                coretickMark=IPM_ConstantUtils.BLG + IPM_ConstantUtils.IPM_BACKSLASH +answertwo_STR;
            }
            if(IPM_Coreparameter.IPM_ProjectSubType__c.Equals(IPM_ConstantUtils.IPM_OPERATIONAL)){
                coretickMark=answerthree_STR+ IPM_ConstantUtils.IPM_BACKSLASH +IPM_Coreparameter.IPM_ProjectSubType__c;
            }
            strategicGraphTick=IPM_Coreparameter_Graph__c.getInstance(coretickMark);
        }
            
    }
    /****************************************************************************
    @Description :Method to get core parameter questions with options
    *****************************************************************************/
    @TestVisible private void getAllQuestions(){
        questiononeList=new List<String>();
        questiontwoList=new List<String>();
        questionthreeList=new List<string>();
        integer qOne=1;
        integer qTwo=2;
        integer qThree=3;
        
        List<IPM_CoreParameter_Questions__c>allCorepQuestionList=new List<IPM_CoreParameter_Questions__c>();
        allCorepQuestionList=[SELECT Name,IPM_Question_Number__c,IPM_Innovation_Renovation__c,
                            IPM_Operational__c,IPM_BLG__c FROM IPM_CoreParameter_Questions__c ORDER BY 
                            IPM_Question_Number__c,IPM_Order_Number__c ASC LIMIT 1000];
        for(IPM_CoreParameter_Questions__c coreQ:allCorepQuestionList){
            //get coreparameter questions for Innovation/Renovation project
            if(IPM_Coreparameter.IPM_ProjectSubType__c!=null && IPM_Coreparameter.IPM_ProjectSubType__c.equals(IPM_ConstantUtils.IPM_INNOVATION_RENOVATION)){
                if(coreQ.IPM_Innovation_Renovation__c && coreQ.IPM_Question_Number__c==qOne){
                    questiononeList.add(coreQ.name);
                }
                if(coreQ.IPM_Innovation_Renovation__c && coreQ.IPM_Question_Number__c==qTwo){
                    questiontwoList.add(coreQ.name);
                }
                if(coreQ.IPM_Innovation_Renovation__c && coreQ.IPM_Question_Number__c==qThree){
                    questionthreeList.add(coreQ.name);
                }
            }
            //get coreparameter questions for Operational project
            if(IPM_Coreparameter.IPM_ProjectSubType__c!=null && (IPM_Coreparameter.IPM_ProjectSubType__c.equals(IPM_ConstantUtils.IPM_OPERATIONAL))){
                if(coreQ.IPM_Operational__c && coreQ.IPM_Question_Number__c==qOne){
                    questiononeList.add(coreQ.name);
                }
                if(coreQ.IPM_Operational__c && coreQ.IPM_Question_Number__c==qTwo){
                    questiontwoList.add(coreQ.name);
                }
                if(coreQ.IPM_Operational__c && coreQ.IPM_Question_Number__c==qThree){
                    questionthreeList.add(coreQ.name);
                }
                isOperational=true;
            } 
            //get coreparameter questions for BLG project 
            if(IPM_Coreparameter.IPM_ProjectSubType__c!=null && (IPM_Coreparameter.IPM_ProjectSubType__c.equals(IPM_ConstantUtils.IPM_BLG))){    
                if(coreQ.IPM_BLG__c && coreQ.IPM_Question_Number__c==qOne){
                    questiononeList.add(coreQ.name);
                }
                if(coreQ.IPM_BLG__c && coreQ.IPM_Question_Number__c==qTwo){
                    questiontwoList.add(coreQ.name);
                }
                if(coreQ.IPM_BLG__c && coreQ.IPM_Question_Number__c==qThree){
                    questionthreeList.add(coreQ.name);
                }
            }
             
        }
        
        
    }
    /****************************************************************************
    @Description :Method to get questions helps contents
    *****************************************************************************/  
    @TestVisible private void getcoreparameterHelps(){
        coParametersList=new List<IPM_CorePara_helps_example__c>();
        coParametersList=[SELECT IPM_Core_Parameter_Helps__c,IPM_Core_Parameter_example__c,IPM_Core_Parameter_example_two__c,
                          IMP_Core_Parameter_example_three__c,IPM_Core_Parameter_example_four__c,IPM_Answer__c,
                          IPM_Core_Parameter_example_five__c FROM  IPM_CorePara_helps_example__c WHERE (IPM_Answer__c=:answerone_STR OR
                          IPM_Answer__c=:answertwo_STR OR  IPM_Answer__c=:answerthree_STR) LIMIT 1000];
        for(IPM_CorePara_helps_example__c coHelp:coParametersList){
            if(coHelp.IPM_Answer__c.Equals(answerone_STR)){
                lstIpmCoreHelp=coHelp;//get answer one help text
            }
            else if(coHelp.IPM_Answer__c.Equals(answertwo_STR)){
                lstIpmCoreHelpQ2=coHelp;//get answer two help text
            }
            else if(coHelp.IPM_Answer__c.Equals(answerthree_STR)){
                lstIpmCoreHelpQ3=coHelp;//get answer three help text
            }
        }        
    }
    /****************************************************************************
    @Description : To query the Project details and reuse at many places.
    *****************************************************************************/
    @TestVisible private void getProjectDetails(){
        if(String.isNotBlank(ProjectID))
        {
            IPM_Coreparameter=project;
			// Access check for Business Partner user while reactivating the project
    		isEditable = IPM_Utils.overrideAccessForBusinessPartner(project, isEditable);            
            Integer noOfMonths = Integer.valueOf(Label.IPM_NoOfMonths_ForReactivation);
            Date dateToCompare = System.today().addMonths(-noOfMonths); 
            if(IPM_Coreparameter.IPM_EligibleForReactivation__c && IPM_Coreparameter.IPM_Stopped_Date_Time__c > dateToCompare)
            {
                editplatform = editSubSector = reactivateProjFlag = isEditable;    
            }
            
            answerone_STR=IPM_Coreparameter.IPM_Answer_of_Q1__c;
            answertwo_STR=IPM_Coreparameter.IPM_Answer_of_Q2__c;
            answerthree_STR=IPM_Coreparameter.IPM_Answer_of_Q3__c;
            market_STR=IPM_Coreparameter.IPM_Market__c;
            subSector_STR=IPM_Coreparameter.IPM_Sub_sector__c;
            betValue_STR=IPM_Coreparameter.IPM_BET_Toolkit__c;
            if(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equals(IPM_Coreparameter.IPM_Project_Type__c) && IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equals(IPM_Coreparameter.IPMProject_Span__c)){
                isRegRollout=true;
            }
            if(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equals(IPM_Coreparameter.IPM_Project_Type__c) || IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equals(IPM_Coreparameter.IPM_Project_Type__c)){
                isOriginal=true;
            }
            
        } 
    }
    /****************************************************************************
    @Description : save additional coreparameter
    *****************************************************************************/
    public void saveAdditionalCorep(){
        if(String.isNotBlank(betId) && betId!=IPM_Coreparameter.BET_Link_Requested__c){
            IPM_Coreparameter.BET_Link_Requested__c=betId;
            IPM_Coreparameter.BET_Link_Requested_on_Date__c=system.now();
            if(!IPM_ConstantUtils.PHASE_IDEAS.equals(IPM_Coreparameter.IPM_Phase__c)){
                BET_LinkingService.follow(projectid,betId,new list<id> {IPM_Coreparameter.IPM_Project_Leader__c,IPM_Coreparameter.Deputy_Project_Leader__c});
            }
        }
        IPM_Coreparameter.IPM_Market__c=market_STR;
        if(ipm_CategoryVal.IPM_Sector__c)
        {
        	IPM_Coreparameter.IPM_Sector__c = subSector_STR;	
        }
        else{
        	IPM_Coreparameter.IPM_Sub_sector__c=subSector_STR;
        } 
        isThresholdSaved =true;
        updateCoreParameter();
        //Update Reset BET option upon save
        resetBEToption = IPM_Coreparameter.IPM_BET_Toolkit__c;
    }
        
    /****************************************************************************
    @Description :For getting the BETToolkit options
    @Return : List of Toolkit options.
    *****************************************************************************/
    public List<SelectOption> getBETToolkit(){
        List<selectOption> options = new List<selectOption>();
        Schema.sObjectType sobject_type = IPM_Project__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map=new  Map<String, Schema.SObjectField> ();
        field_map = sobject_describe.fields.getMap();
        if( !field_map.isEmpty()){
            List<Schema.PicklistEntry> pick_list_values = field_map.get(IPM_ConstantUtils.BET_TOOLKIT).getDescribe().getPickListValues();
            for (Schema.PicklistEntry a : pick_list_values) {
                options.add(new selectOption(a.getLabel(), a.getValue()));
            }
        }
        return options;
    }
        
    /****************************************************************************
    @Description :method to update answer one
    *****************************************************************************/
    public void answerOne(){
        answerone_STR=SelectedAnswer;
        getCoreStrategicIntent();
        getcoreparameterHelps();
        
    }
    /****************************************************************************
    @Description :method to update answer two
    *****************************************************************************/
    public void answerTwo(){
        answertwo_STR=SelectedAnswer;
        getCoreStrategicIntent();
        getcoreparameterHelps();
        
    } 
    /****************************************************************************
    @Description :method to update answer two
    *****************************************************************************/
    public void answerThree(){
        answerthree_STR=SelectedAnswer;
        getCoreStrategicIntent();
        getcoreparameterHelps();
        
    } 
    /****************************************************************************
    @Description :method to update selected answer
    *****************************************************************************/
    public void answerAnswer(){
        IPM_Coreparameter.IPM_Answer_of_Q1__c=answerone_STR;
        IPM_Coreparameter.IPM_Answer_of_Q2__c=answertwo_STR;
        IPM_Coreparameter.IPM_Answer_of_Q3__c=answerthree_STR;
        getCoreparameterConfig();
        updateCoreParameter();
    }
    /****************************************************************************
    @Description :method to reset selected answer
    *****************************************************************************/
    public void resetAnswer(){
        initialise();
    }
    
    /****************************************************************************       
    @Description :method to show messages on save       
    *****************************************************************************/      
    public void showMessage(){      
    isThresholdSaved = false;       
    }
    /****************************************************************************
    @Description :method to update answer two
    *****************************************************************************/
    private void updateCoreParameter(){
        try{ 
            update IPM_Coreparameter;
            getcoreparameterHelps();
            getStrategicGraph();
            SelectedAnswer=IPM_ConstantUtils.BLANK;
        }
        catch(DMLexception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_COREPARAMETERREVAMP_STR,
                    UPDATECOREPRAMETER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null); 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,system.label.IPM_System_Admin));         
        } 
        catch(exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_COREPARAMETERREVAMP_STR,
                    UPDATECOREPRAMETER,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null); 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,system.label.IPM_System_Admin));         
        } 
        
    }     
    /****************************************************************************
    @Description :Get user type with access permission
    *****************************************************************************/
    @TestVisible private void getIpmuserType(){
        list<IPM_Project_Resource__c>lstProuser=new list<IPM_Project_Resource__c>();
    
        string userRole=IPM_ConstantUtils.BLANK;
        if(String.isNotBlank(projectId)) {
            lstProuser=[SELECT IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,
                        IPM_Project__r.IPM_Project_Leader__c FROM IPM_Project_Resource__c WHERE 
                        IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() AND 
                        IPM_Project__r.Is_Archieved__c=false 
                        AND  IPM_Role_Type__c !=null limit 1];
            
        } 
        //extra edit access on coreparameter
        if(((IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equals(IPM_Coreparameter.IPM_Project_Type__c)&& IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equals(IPM_Coreparameter.IPMProject_Span__c)) || 
        (IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equals(IPM_Coreparameter.IPM_Project_Type__c)&& IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equals(IPM_Coreparameter.IPMProject_Span__c)) &&
        (IPM_ConstantUtils.PHASE_FEASIBILITY.equals(IPM_Coreparameter.IPM_Phase__c) || IPM_ConstantUtils.PHASE_IDEAS.equals(IPM_Coreparameter.IPM_Phase__c))))
        
        {
            extraEditable=true;
        }
        
        if(!lstProuser.isEmpty()){
            userRole=lstProuser[0].IPM_Role_Type__c;
            if(userRole.equals(IPM_ConstantUtils.IPM_ROLE_CD)|| 
            userRole.equals(IPM_ConstantUtils.IPM_ROLE_RD) || userRole.equals(IPM_ConstantUtils.IPM_ROLE_SUPPLY_CHAIN)||
            userRole.equals(IPM_ConstantUtils.IPM_ROLE_FINANCE)){
                isEditable=false;
                
            }
            //BD user access
            if(userRole.equals(IPM_ConstantUtils.IPM_ROLE_BD) && extraEditable && !(IPM_Coreparameter.IPM_PrepareForArchival__c || reactivateProjFlag)){
                isEditCoreparam=true;
                editMPAByBD=true;
                editCPVByBD=true;
                
            }
            
        }
        //TPL user access
        if(IPM_Coreparameter.IPM_Technical_Project_Leader__c!=null && IPM_Coreparameter.IPM_Technical_Project_Leader__c==userinfo.getuserid() && 
            !reactivateProjFlag && extraEditable && (IPM_Coreparameter.IPM_Technical_Project_Leader__c!=IPM_Coreparameter.IPM_Project_Leader__c || 
            IPM_Coreparameter.IPM_Technical_Project_Leader__c!=IPM_Coreparameter.Deputy_Project_Leader__c) && !(IPM_Coreparameter.IPM_PrepareForArchival__c || reactivateProjFlag)){
            editETByTPL=true;
            isEditCoreparam=true;
        }
        if(!isEditable){
            list<IPM_Project__c>lstofuser=[SELECT IPM_Project_Leader__c FROM IPM_Project__c WHERE 
                                           id=:projectId and (IPM_Project_Leader__c =:userinfo.getuserid() 
                                                              OR Deputy_Project_Leader__c=:userinfo.getuserid() ) 
                                                              AND Is_Archieved__c=false limit 1];
            if(!lstofuser.isEmpty()){
                if(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equals(IPM_Coreparameter.IPM_Project_Type__c)&& IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equals(IPM_Coreparameter.IPMProject_Span__c) &&
                (IPM_ConstantUtils.PHASE_FEASIBILITY.equals(IPM_Coreparameter.IPM_Phase__c) || IPM_ConstantUtils.PHASE_CAPABILITY.equals(IPM_Coreparameter.IPM_Phase__c)))
                {
                    editMarketActivityByPL=true;
                } 
                isEditable=true;
                editplatform = true;
                editETByTPL=false;
                if(IPM_ConstantUtils.PHASE_IDEAS.equals(IPM_Coreparameter.IPM_Phase__c)){
                    editSubSector=true;
                }
            }
            else{
                isEditable=false;
            }
        }
        
        //security for central team and BP users
        IPM_CustomPermission cpr = new IPM_CustomPermission();
        boolean isCentralTeam=false;
        boolean isBPUser=false;
        isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
        isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
        if(isCentralTeam || isBPUser){
            isEditable=true;
            if(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equals(IPM_Coreparameter.IPM_Project_Type__c) || IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL.equals(IPM_Coreparameter.IPM_Project_Type__c) ){
                editSubSector = true;
                editplatform = true;
            }
            if((IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(IPM_Coreparameter.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(IPM_Coreparameter.IPM_Project_Type__c))) || 
            (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(IPM_Coreparameter.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(IPM_Coreparameter.IPM_Project_Type__c))) || 
            (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(IPM_Coreparameter.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equalsIgnoreCase(IPM_Coreparameter.IPM_Project_Type__c)))){
                isExemptFromThresholdITO = true;
            }
        }                                       
        
    }     
    /****************************************************************************
    @Description :To retrieve the Subsector/Makert/Sector details
    *****************************************************************************/  
    @TestVisible private void getSubsector(){
        selCat=IPM_ConstantUtils.BLANK;
        if(ipm_CategoryVal !=null && IPM_Coreparameter.IPM_Category_Text__c!=null){
            lstsubsector=new list<selectoption>();
            selCat=IPM_Coreparameter.IPM_Category_Text__c;
            List<MDO_Category__c > subsectorList=new List<MDO_Category__c >();
            set<string>uniqueSubSector=new set<string>();
            string query_Str='';
            query_Str='SELECT Name FROM MDO_Category__c ';
            if(ipm_CategoryVal.IPM_Sub_Sector__c)
            {
            	 query_Str+='WHERE parent_L3__r.Name= \''+ selCat +'\' AND category_type__c=\''+IPM_ConstantUtils.IPM_SUBSECTOR +'\' ';
            }
            else if(ipm_CategoryVal.IPM_Sector__c)
            {
            	query_Str+='WHERE parent_L2__r.Name= \''+ selCat + '\' AND category_type__c=\''+IPM_ConstantUtils.IPM_SECTOR +'\' ';
            }
            else if(ipm_CategoryVal.IPM_Market__c)
            {
            	query_Str+='WHERE category_type__c= \''+IPM_ConstantUtils.IPM_MARKET + '\' AND parent_id__r.Name=\''+ selCat + '\' ';
            }
            query_Str+=' LIMIT 1000';
            
            subsectorList = Database.Query(query_Str);
            for(MDO_Category__c u:subsectorList){
                if(!uniqueSubSector.contains(u.Name)){
                    lstsubsector.add(new Selectoption(u.Name,u.Name));
                    uniqueSubSector.add(u.Name );
                }
            }  
        }          
    }
    
    /****************************************************************************
    @Description :Referenced in IPM_CoreParameter component. 
    *****************************************************************************/
    public void betValue(){
        if(string.isNotBlank(betValue_STR) && betValue_STR.equals(IPM_ConstantUtils.NO_TOOLKIT)){
            isNoToolkit=false;
        }
        else{
            isNoToolkit=true;
        }
    } 
    /****************************************************************************
    @Description :get access on vf page or component
    *****************************************************************************/
    @Testvisible private void getAccessonPage(){
        if((coreConfig.IPM_FastTrack__c!=null && coreConfig.IPM_FastTrack__c) || (coreConfig.IPM_WhiteSpace__c!=null && coreConfig.IPM_WhiteSpace__c)){
            isShowFastTOrWhiteS=true;
        
        }
        if(isEditable && !ple_STR.Equals(IPM_Coreparameter.IPM_Phase__c) && !IPM_Coreparameter.IPM_PrepareForArchival__c && !reactivateProjFlag){
            isEditCoreparamPage=true;
        }
        if(coreConfig.IPM_MPA__c!=null && coreConfig.IPM_MPA__c && (isEditable||isEditCoreparam)){
            isMPAEditable=true;
        }
        if(coreConfig.IPM_CPV__c!=null && coreConfig.IPM_CPV__c && (isEditable||isEditCoreparam)){
            isCPVEditable=true;
        }
        if(coreConfig.IPM_ET__c!=null && coreConfig.IPM_ET__c && (isEditable||isEditCoreparam)){
            isETEditable=true;
        }
        if(coreConfig.IPM_MPA__c!=null && !coreConfig.IPM_MPA__c && isEditable && !isEditCoreparameter){
            isMPABack=true;
        }
        if(isEditable && !ple_STR.Equals(IPM_Coreparameter.IPM_Phase__c) && !(IPM_Coreparameter.IPM_PrepareForArchival__c || reactivateProjFlag) &&
        !((IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equals(IPM_Coreparameter.IPM_Project_Type__c)&& IPM_ConstantUtils.PROJECT_SPAN_LOCAL.equals(IPM_Coreparameter.IPMProject_Span__c))
            ||(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equals(IPM_Coreparameter.IPM_Project_Type__c)&& IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equals(IPM_Coreparameter.IPMProject_Span__c)
            ))){
            
            isAdditionalPara=true;
        }
        if(isEditable && !IPM_ConstantUtils.PHASE_MARKET_READY.Equals(IPM_Coreparameter.IPM_Phase__c) && !IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT.Equals(IPM_Coreparameter.IPM_Phase__c) &&
        !ple_STR.Equals(IPM_Coreparameter.IPM_Phase__c) && !(IPM_ConstantUtils.PROJECT_SPAN_LOCAL.equals(IPM_Coreparameter.IPMProject_Span__c) && !IPM_ConstantUtils.IPM_OPERATIONAL.equals(IPM_Coreparameter.IPM_Project_Type__c)) && !(IPM_Coreparameter.IPM_PrepareForArchival__c || reactivateProjFlag))
            {
            isEditCoreparam=true;
            
        }
        
    }
        
    
      
    
    /****************************************************************************
    @Description :Wrapper class to hold data from BET as well as IPM
    *****************************************************************************/

    public class IPM_BET_BETWrapper {
    
    //Id of Bet
    public Id betId{get;set;}
    //Name of Bet
    public String betName{get;set;}
    //Bet Status
    public String status{get;set;}
    //Date of First release
    public Date firstReleaseDate{get;set;}
    //Due date of first release
    public Date firstReleaseDueDate{get;set;}
    //Date of final release
    public Date finalReleaseDate{get;set;}
    //Due date of final release
    public Date finalReleaseDueDate{get;set;}
    //Value indicating if BET is archived
    public Boolean isArchived{get;set;}
    //Id of BET owner user
    public Id betOwner{get;set;}
    //Id of BET group category lookup (ProductCategory)
    public Id groupCategory{get;set;}
    //Id of BET category lookup (ProductCategory)
    public Id category{get;set;}
    //Id of BET owner user
    public Id brandPosition{get;set;}
    //Id of BET owner user
    public Id brand{get;set;}
    //Name of Owner
    public string OwnerName{get;set;}
    //Name of Brand POsition
    public string brandPos{get;set;}
    //Date of launch
    public Datetime targetLaunchDate{get;set;}
    Public IPM_BET_BETWrapper(BET_BETWrapper bw){
    this.betId=bw.betId;
    this.betName = bw.betName;
    this.status = bw.status;
    this.firstReleaseDate = bw.firstReleaseDate ;
    this.firstReleaseDueDate = bw.firstReleaseDueDate;
    this.finalReleaseDate = bw.finalReleaseDate;
    this.finalReleaseDueDate = bw.finalReleaseDueDate;
    this.isArchived = bw.isArchived;
    this.betOwner = bw.betOwner;
    this.groupCategory = bw.groupCategory;
    this.category = bw.category;
    this.brandPosition = bw.brandPosition;
    this.brand = bw.brand;
    this.targetLaunchDate = bw.targetLaunchDate;
    }
    }
}