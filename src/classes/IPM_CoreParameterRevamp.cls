/******************************************** 
*@Author:Cognizant
*@Date:October 2014
*@Description : To create coreparameters
*Referring in page ipmBosscard_revamp page 
*********************************************/
public with sharing class IPM_CoreParameterRevamp {

    public Integer ipmBetTimeGap =Integer.valueof(System.label.IPM_BET_TimeGap);
    Map<String, IPM_BET_Search_Fields__c> betCustomSettings = IPM_BET_Search_Fields__c.getAll();
    List<String> dataSetNames= new List<String>();
    Public  List<String> columnLabels{get{if(columnLabels==null) checkLabel();return columnLabels; } private set;}
    Public  List<String> classProperties {get{if(classProperties==null) checkLabel();return classProperties ; } private set;}
    Public  Map<String,boolean> classPropertiesMap {get{if(classPropertiesMap==null) checkLabel();return classPropertiesMap ; } private set;}
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
    //*@description: store question no.1 description 
    public String Q1_description{get;set;}
    //*@description: store option 1 for question no.1 
    public String Q1_Opt1{get;set;}
    //*@description: store option 2 for question no.1 
    public String Q1_Opt2{get;set;}
    //*@description: store option 3 for question no.1
    public String Q1_Opt3{get;set;}
    //*@description: store option 4 for question no.1
    public String Q1_Opt4{get;set;}
    //*@description: store option 5 for question no.1 
    public String Q1_Opt5{get;set;}
    //*@description: store option 6 for question no.1 
    public String Q1_Opt6{get;set;}
    //*@description: store option 7 for question no.1 
    public String Q1_Opt7{get;set;}
    //*@description: store option 8 for question no.1 
    public String Q1_Opt8{get;set;}
    //*@description: store option 9 for question no.1 
    public String Q1_Opt9{get;set;}
    //*@description: store option 10 for question no.1 
    public String Q1_Opt10{get;set;}
    //*@description: store option 11 for question no.1
    public String Q1_Opt11{get;set;}
    //*@description: store option 12 for question no.1
    public String Q1_Opt12{get;set;}
    //*@description: store option 13 for question no.1
    public String Q1_Opt13{get;set;}
    //*@description: store option 14 for question no.1
    public String Q1_Opt14{get;set;}
    //*@description: store question no.2 description
    public String Q2_description{get;set;}
    //*@description: store option 1 for question no.2
    public String Q2_Opt1{get;set;}
    //*@description: store option 2 for question no.2
    public String Q2_Opt2{get;set;}
    //*@description: store option 3 for question no.2
    public String Q2_Opt3{get;set;}
    //*@description: store option 4 for question no.2
    public String Q2_Opt4{get;set;}
    //*@description: store option 5 for question no.2
    public String Q2_Opt5{get;set;}
    //*@description: store question no.3 description
    public String Q3_description{get;set;}
    //*@description: store option 1 for question no.3
    public String Q3_Opt1{get;set;}
    //*@description: store option 2 for question no.3
    public String Q3_Opt2{get;set;}
    //*@description: store option 3 for question no.3
    public String Q3_Opt3{get;set;}
    //*@description: store option 4 for question no.3
    public String Q3_Opt4{get;set;}
    //*@description: Flag for question no.1
    public Boolean IsQuestionOne{get;set;}
    //*@description: Flag for question no.2
    public Boolean IsQuestionTwo{get;set;}
    //*@description: Flag for question no.3
    public Boolean IsQuestionThree{get;set;}
    //*@description: store project id from url parameter
    public string ProjectID{get;set;}
    //*@description: get details of project
    public IPM_Project__c Ipm_project{get;set;}
    //*@description: get details of coreparameter
    public IPM_Project__c IPM_Coreparameter{get;set;}
    //*@description: get details of project
    public IPM_Project__c IPM_CoreparameterProjectSpan{get;set;}
    //*@description: store project Id from query
    public String CoreparameterId{get;set;}
    //*@description: store selected answer for question
    public string SelectedAnswer{get;set;}
    //*@description: store selected question
    public string SelectedQuestion{get;set;}
    //*@description: core parameters help text for question no 1
    public IPM_CorePara_helps_example__c lstIpmCoreHelp{get;set;}
    //*@description: core parameters help text for question no 2
    public IPM_CorePara_helps_example__c lstIpmCoreHelpQ2{get;set;}
    //*@description: core parameters help text for question no 3
    public IPM_CorePara_helps_example__c lstIpmCoreHelpQ3{get;set;}
    //*@description: specifies bosscard id
    public string BosscardID{get;set;}
    //*@description: Display successfull message of question number one
    public Boolean saveQuestionOne{get;set;}
    //*@description: Display successfull message of question number two
    public Boolean saveQuestionTwo{get;set;}
    //*@description: Display successfull message of question number three 
    public Boolean saveQuestionThree{get;set;}
    //*@description: Display successfull message of market 
    public Boolean saveMarket{get;set;}
    //*@description: Store type of Project
    public string projecttype{get;set;}
    //*@description: Store type of Project
    public string pTypeOperational{get;set;}
    //*@description: Answer for question no 1
    public string Answerone{get;set;}
    //*@description: core parameter option for question no 1
    public Boolean IsBLG{get;set;}
    //*@description: value specifies if there is an error
    public Integer error{get;set;}
    //*@description: Enables closepopup
    public Integer closepopup{get;set;}
    //*@description: Specifies user access permission
    Public Boolean isEditable{get;set;}
    //*@description: stores strategic intent  info
    Public IPM_CoreParameter_Strategic_help_content__c StrategicHelp{get;set;}
    //*@description: Display Message for Innovation strategic intent
    public string Innovationtxt{get;set;}
    //*@description: Display Message for Renovation strategic intent
    public string Renovationtxt{get;set;}
    //*@description: Display Message for Operational strategic intent
    public string operationalTxt{get;set;}
    //*@description: Display Message for BLG strategic intent
    public string BLGtxt{get;set;}
    //*@description: stores company card options for current user
    public list<selectoption>lstCompany{get;set;}
    //*@description: stores company type based on company card record type
    public String CompanyType{get;set;}
    //*@description: get sub sector data
    public list<selectoption>lstsubsector{get;set;}
    //*@description: specifies strategic intent type
    public string IMPStrategic{get;set;}
    //*@Description: To store Coreparametershelp records.
    public List<IPM_CorePara_helps_example__c> coParametersList{get; set;}
    //*@description:used in ui
    public string addcorepara{get;set;}
    //*@description:used in ui
    public string coreptab{get;set;}
    public list<IPM_Project__c>toupdateProjectList=new list<IPM_Project__c>();
    public final String IPM_COREPARAMETERREVAMP_STR = 'IPM_CoreParameterRevamp';
    
    //*@description: BET Search related Changes: Start
    Public  BET_BETWrapper SelectedBet{get;set;}
    public map<id, string> mapIdOwner {get; set;} 
    public map<id, string> mapIdBrandPos = new map<id, string>();
    
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
    Public List<IPM_BET_BETWrapper> searchresultBet{
        get{
            if(searchresultBet==null)
                searchresultBet=new List<IPM_BET_BETWrapper>();
                return searchresultBet;
        } 
        set; 
    }
    /****************************************************************************
    @Description: MEthod to unlink BET from IPM Project
    *****************************************************************************/
    Public pageReference Replace(){
        bLinkBET = true;
        IPM_Project__c updateProj =new IPM_Project__c(id=projectid);
        updateProj.BET_Link_Requested__c='';
        updateProj.BET_Link_Requested_on_Date__c=null;
        updateProj.BET__c = null;
        if(String.isNotBlank(IPM_Coreparameter.BET_Link_Requested__c)){
            BET_LinkingService.unfollow(projectid,IPM_Coreparameter.BET_Link_Requested__c);
        }
        else if(String.isNotBlank(IPM_Coreparameter.BET__c)){
            BET_LinkingService.unfollow(projectid,IPM_Coreparameter.BET__c);    
        }
        update updateProj ;
        List<IPM_Milestone__c> NoBetdeleteMilestonesList =  [select id from IPM_Milestone__c where ( IPM_Name__c='Brand Experience Toolkit(BET) First release' OR IPM_Name__c='Brand Experience Toolkit(BET) Final release') AND IPM_Project__c=:projectid limit 50000];
        if(NoBetdeleteMilestonesList!=null &!NoBetdeleteMilestonesList.isempty()){
            delete  NoBetdeleteMilestonesList;
        }
        projbetlink = '';
        return null;
    } 
    /****************************************************************************
    @Description : search BET method - calls BET method to retrieve search results.
    *****************************************************************************/
    public void searchBET(){
    Map<String,BET_BETWrapper> bwap =new  Map<String,BET_BETWrapper>();   
    set<id> setOwnerIds = new set<id>();
    set<id> setBrandPosIds = new set<id>();
    searchresultBet =new List<IPM_BET_BETWrapper>();
    id categoryId;
    if(IPM_Coreparameter.IPM_category_text__c!=null){
        list<mdo_category__c> lstCat = new list<mdo_category__c>();
        lstCat = [select id from mdo_category__c where name = :IPM_Coreparameter.IPM_category_text__c and category_type__c = :IPM_ConstantUtils.CATEGORY_TYPE and status__c = :IPM_ConstantUtils.CATEGORY_STATUS_ACTIVE LIMIT 1];
        if(!lstCat.isEmpty()){
            categoryId = lstCat[0].id;  
        }
    }
    List<BET_BETWrapper> searchBet =BET_BETService.searchBet(searchstring,categoryId,null);
    
    for (BET_BETWrapper bw : searchBet ){
            //if(bw.finalReleaseDueDate!=null && IPM_Coreparameter.IPM_Target_Launch_Dates__c!=null && (IPM_Coreparameter.IPM_Target_Launch_Dates__c).daysBetween(bw.finalReleaseDueDate)>Integer.valueOf(label.IPM_BET_TimeGap)){
            if(bw.finalReleaseDueDate!=null && IPM_Coreparameter.IPM_Target_Launch_Dates__c!=null){
                bwap.put(bw.betId ,bw);
                setOwnerIds.add(bw.betOwner);
                setBrandPosIds.add(bw.brandPosition);
            }
    }
    
    
    if(!setOwnerIds.isEmpty()){
        mapIdOwner= new map<id, string>();
        for(user usr : [select id, firstname, lastName from user where id in :setOwnerIds ]){
            mapIdOwner.put(usr.id,usr.firstname+' '+usr.LastName);      
        }
    }
    if(!setBrandPosIds.isEmpty()){
        mapIdBrandPos = new map<id, string>();
        for(MDO_BrandPosition__c brnd: [select id, Name from MDO_BrandPosition__c where id in :setBrandPosIds]){
            mapIdBrandPos.put(brnd.id,brnd.Name);       
        }
    }
    for(string it :  bwap .keyset()){
        /**
        if(IPM_Coreparameter.IPM_Target_Launch_Dates__c!=null && bwap.get(it).finalReleaseDueDate.daysBetween(IPM_Coreparameter.IPM_Target_Launch_Dates__c)>730 && bwap.get(it).betId==IPM_Coreparameter.BET_Link_Requested__c ){
            SelectedBet=bwap.get(it);
        }**/
        IPM_BET_BETWrapper temp = new IPM_BET_BETWrapper(bwap.get(it));
        if(bwap.get(it).betOwner!=null && !mapIdOwner.isEmpty() && mapIdOwner.containskey(bwap.get(it).betOwner)){
            temp.OwnerName = mapIdOwner.get(bwap.get(it).betOwner);     
        }
        if(bwap.get(it).brandPosition!=null && !mapIdBrandPos.isEmpty() && mapIdBrandPos.containskey(bwap.get(it).brandPosition)){
            temp.brandPos = mapIdBrandPos.get(bwap.get(it).brandPosition);      
        }
        searchresultBet.add(temp);
    }
    
   
    } 
    /**BET Search related Changes: End**/
    
    /****************************************************************************
    @Description : constructor To initialize IPM_CoreParameterRevamp object
    *****************************************************************************/
    public IPM_CoreParameterRevamp (){
        bLinkBET = true;
        isEditable=false;
        IMPStrategic='';
        CompanyType='';
        error = 0;
        closepopup=0;
        projecttype='';
        saveQuestionOne=false;
        saveQuestionTwo=false;
        saveQuestionThree=false;
        saveMarket=false;
        IsBLG=false;
        SelectedAnswer='';
        SelectedQuestion='';
        IsQuestionOne=true;
        IsQuestionTwo=false;
        IsQuestionThree=false;
        ProjectID='';
        CoreparameterId='';
        Answerone='';
        pTypeOperational=IPM_ConstantUtils.ProjectType_Operational;
        BosscardID=apexpages.currentpage().getparameters().get('id'); 
        if(BosscardID== Null || BosscardID== ''){
            BosscardID=apexpages.currentpage().getparameters().get('Pid');
        }
        
        IPM_Coreparameter=new IPM_Project__c();
        lstIpmCoreHelp=new IPM_CorePara_helps_example__c();
        ProjectID=BosscardID;
        IPM_CoreparameterProjectSpan = new IPM_Project__c();
        getProjectDetails();
        
        if(IPM_Coreparameter!=null){
            Answerone = IPM_Coreparameter.IPM_Answer_of_Q1__c;
            CoreparameterId=IPM_Coreparameter.id;
            projecttype=IPM_Coreparameter.IPMProject_Type__c;
            If(IPM_Coreparameter.BET_Link_Requested__c!=null || String.isNotBlank(IPM_Coreparameter.BET__c)){
                bLinkBET = false;
            }
            
            try{
               getcoreparameterHelps();                   
                
            }
            catch(exception ex){
            } 
        }      
        QuestionOne();
        QuestionTwo();
        QuestionThree();
        getIpmuserType();
        Strategichelp();
        getProjectDetails();
        
        getsubsector();
    }
    /****************************************************************************
    @Description :Method to get questions helps contents
    *****************************************************************************/  
    public void getcoreparameterHelps(){
        coParametersList=new List<IPM_CorePara_helps_example__c>();
                coParametersList=[SELECT IPM_Core_Parameter_Helps__c,IPM_Core_Parameter_example__c,IPM_Core_Parameter_example_two__c,
                                  IMP_Core_Parameter_example_three__c,IPM_Core_Parameter_example_four__c,IPM_Answer__c,
                                  IPM_Core_Parameter_example_five__c FROM  IPM_CorePara_helps_example__c LIMIT 50000];
                for(IPM_CorePara_helps_example__c coHelp:coParametersList){
                    if(coHelp.IPM_Answer__c==IPM_Coreparameter.IPM_Answer_of_Q1__c){
                        lstIpmCoreHelp=coHelp;
                    }
                    else if(coHelp.IPM_Answer__c==IPM_Coreparameter.IPM_Answer_of_Q2__c){
                        lstIpmCoreHelpQ2=coHelp;
                    }
                    else if(coHelp.IPM_Answer__c==IPM_Coreparameter.IPM_Answer_of_Q3__c){
                        lstIpmCoreHelpQ3=coHelp;
                    }
                }        
    }
    /****************************************************************************
    @Description : To query the Project details and reuse at many places.
    *****************************************************************************/
    public void getProjectDetails(){
        if(String.isNotBlank(ProjectID))
        {
            IPM_Coreparameter=[SELECT IPM_Answer_of_Q1__c,IPM_Category_Text__c,IPM_BET_Toolkit__c,IPM_Answer_of_Q2__c,BET__c,
                               IPM_Answer_of_Q3__c,IPM_Company_Card__c,IPMProject_Span__c,IPMProject_Type__c,IPM_Category__c,
                               IPM_Category_Group__c,IPMCompany__c,IPM_Market__c,IPMPlatform__c,IPMRegion__c,IPM_Sector__c,
                               IPM_IsCompleted__c ,IPM_Sub_sector__c,BET_Link_Requested__c,IPM_Target_Launch_Dates__c,IPM_Project_Leader__c,Deputy_Project_Leader__c FROM IPM_Project__c WHERE id=:ProjectID limit 1];
        } 
    }
    
    
    /****************************************************************************
    @Description : Method to get Strategic help text
    *****************************************************************************/    
    public void Strategichelp(){
        IPM_CoreParameter_Strategic_help_content__c StrategicHelp=IPM_CoreParameter_Strategic_help_content__c.getInstance(IPM_ConstantUtils.STRATEGIC_TEXT);
        Innovationtxt=StrategicHelp.IPM_Innovation__c+StrategicHelp.IPM_InnovationPartTwo__c;
        Renovationtxt=StrategicHelp.IPM_Renovation__c+StrategicHelp.IPM_RenovationPartTwo__c;
        operationalTxt=StrategicHelp.IPM_Operational__c+StrategicHelp.IPM_Operational_Part_Two__c;
        BLGtxt=StrategicHelp.IPM_BLG__c+StrategicHelp.IPM_BLGPartTwo__c;
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
        if(field_map != NULL && !field_map.isEmpty()){
            List<Schema.PicklistEntry> pick_list_values = field_map.get(IPM_ConstantUtils.BET_TOOLKIT).getDescribe().getPickListValues();
            for (Schema.PicklistEntry a : pick_list_values) {
                options.add(new selectOption(a.getLabel(), a.getValue()));
            }
        }
        return options;
    }
        
    /****************************************************************************
    @Description :Method to get question number one 
    *****************************************************************************/    
    public void QuestionOne(){
        IPM_CoreParameter__c QuestionOne=IPM_CoreParameter__c.getInstance(IPM_ConstantUtils.CORE_QUESTION_ONE_W);
        Q1_description=QuestionOne.Question__c;
        Q1_Opt1=QuestionOne.Q1__c;
        Q1_Opt2=QuestionOne.Q2__c;
        Q1_Opt3=QuestionOne.Q3__c;
        Q1_Opt4=QuestionOne.Q4__c;
        Q1_Opt5=QuestionOne.Q5__c;
        Q1_Opt6=QuestionOne.Q6__c;
        Q1_Opt7=QuestionOne.Q7__c;
        Q1_Opt8=QuestionOne.Q8__c;
        Q1_Opt9=QuestionOne.Q9__c;
        Q1_Opt10=QuestionOne.Q10__c;
        Q1_Opt11=QuestionOne.Q11__c;
        Q1_Opt12=QuestionOne.Q12__c;
        Q1_Opt13=QuestionOne.Q13__c;
        Q1_Opt14=QuestionOne.Q14__c;
    }
    
    /****************************************************************************
    @Description :Method to get question Two 
    *****************************************************************************/
    public void QuestionTwo(){
        IPM_CoreParameter__c QuestionTwo=IPM_CoreParameter__c.getInstance(IPM_ConstantUtils.CORE_QUESTION_TWO_W);
        Q2_description=QuestionTwo.Question__c;
        Q2_Opt1=QuestionTwo.Q1__c;
        Q2_Opt2=QuestionTwo.Q2__c;
        Q2_Opt3=QuestionTwo.Q3__c;
        Q2_Opt4=QuestionTwo.Q4__c;
        Q2_Opt5=QuestionTwo.Q5__c;
    }
    
    /****************************************************************************
    @Description :Method to get question Three 
    *****************************************************************************/  
    public void QuestionThree(){
        IPM_CoreParameter__c QuestionThree=IPM_CoreParameter__c.getInstance(IPM_ConstantUtils.CORE_QUESTION_THREE_W);
        Q3_description=QuestionThree.Question__c;
        Q3_Opt1=QuestionThree.Q1__c;
        Q3_Opt2=QuestionThree.Q2__c;
        Q3_Opt3=QuestionThree.Q3__c;
        Q3_Opt4=QuestionThree.Q4__c;
    }
        
    /****************************************************************************
    @Description :Method to get previous question  
    *****************************************************************************/  
    public void PreviousQiestion(){
        if( IsQuestionTwo){
            IsQuestionOne=true;
            IsQuestionTwo=false;  
            QuestionOne();
        }
        else if( IsQuestionThree){
            IsQuestionTwo=true;
            IsQuestionThree=false;
            QuestionTwo();
        }
    } 
        
    /****************************************************************************
    @Description :Method to get next question 
    *****************************************************************************/ 
    public void NextQuestion(){
        if(IsQuestionOne){
            IsQuestionOne=false;
            IsQuestionTwo=true;
            QuestionTwo();
        }
        else if(IsQuestionTwo){
            IsQuestionTwo=false;
            IsQuestionThree=true;
            QuestionThree();
        }
    }
       
    /****************************************************************************
    @Description :method to update answer
    *****************************************************************************/
    public void SelectedAnswer(){
        try{
            saveQuestionOne=false;
            saveQuestionTwo=false;
            saveQuestionThree=false;
            saveMarket=false;
            IPM_Coreparameter=new IPM_Project__c();
            toupdateProjectList=new list<IPM_Project__c>();
            getProjectDetails();
            if(SelectedQuestion==IPM_ConstantUtils.Question1){
                if(SelectedAnswer==Q1_Opt1 || SelectedAnswer==Q1_Opt2 || SelectedAnswer==Q1_Opt3 || SelectedAnswer==Q1_Opt4 ||SelectedAnswer==Q1_Opt5 || SelectedAnswer==Q1_Opt6
                   || SelectedAnswer==Q1_Opt7 || SelectedAnswer==Q1_Opt8 || SelectedAnswer==Q1_Opt9){
                       if(SelectedAnswer==Q1_Opt9){
                           IPM_Coreparameter.IPM_Answer_of_Q3__c='';
                            if(IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt1){
                               lstIpmCoreHelpQ2.clear();
                           }
                          
                       }
                       projecttype=system.label.IPM_GlobalProject; 
                   }
                else{
                    IPM_Coreparameter.IPM_Answer_of_Q2__c='';
                    IPM_Coreparameter.IPM_Answer_of_Q3__c='';
                    projecttype=system.label.IPM_GlobalOperationalProject;
                    
                }
                IPM_Coreparameter.IPMProject_Type__c=projecttype;   
            }
            
            if(IPM_Coreparameter!=null){
                CoreparameterId=IPM_Coreparameter.id;
                if(SelectedQuestion==IPM_ConstantUtils.CORE_QUESTION_ONE){
                    IPM_Coreparameter.IPM_Answer_of_Q1__c=SelectedAnswer;
                    Answerone=SelectedAnswer;
                }
                else if(SelectedQuestion==IPM_ConstantUtils.CORE_QUESTION_TWO){
                    IPM_Coreparameter.IPM_Answer_of_Q2__c=SelectedAnswer;
                }
                else if(SelectedQuestion==IPM_ConstantUtils.CORE_QUESTION_THREE){
                    IPM_Coreparameter.IPM_Answer_of_Q3__c=SelectedAnswer;
                }
                toupdateProjectList.add(IPM_Coreparameter);
                
            }
            else{
                if(SelectedQuestion==IPM_ConstantUtils.CORE_QUESTION_ONE){
                    IPM_Coreparameter.IPM_Answer_of_Q1__c=SelectedAnswer;
                    Answerone=SelectedAnswer;
                }
                else if(SelectedQuestion==IPM_ConstantUtils.CORE_QUESTION_TWO){
                    IPM_Coreparameter.IPM_Answer_of_Q2__c=SelectedAnswer;
                }
                else if(SelectedQuestion==IPM_ConstantUtils.CORE_QUESTION_THREE){
                    IPM_Coreparameter.IPM_Answer_of_Q3__c=SelectedAnswer;
                }
                if(IPM_Coreparameter.IPM_Answer_of_Q1__c!=null && IPM_Coreparameter.IPM_Answer_of_Q2__c!=null && IPM_Coreparameter.IPM_Answer_of_Q3__c!=null)
                    IPM_Coreparameter.IPM_IsCompleted__c=true;
                else if(IPM_Coreparameter.IPM_Answer_of_Q1__c==IPM_ConstantUtils.BLG && IPM_Coreparameter.IPM_Answer_of_Q2__c!=null)
                    IPM_Coreparameter.IPM_IsCompleted__c=true;
                else if(IPM_Coreparameter.IPM_Answer_of_Q1__c==Q1_Opt10 || IPM_Coreparameter.IPM_Answer_of_Q1__c==Q1_Opt11 || IPM_Coreparameter.IPM_Answer_of_Q1__c==Q1_Opt12 || IPM_Coreparameter.IPM_Answer_of_Q1__c==Q1_Opt13 || IPM_Coreparameter.IPM_Answer_of_Q1__c==Q1_Opt14)   
                    IPM_Coreparameter.IPM_IsCompleted__c=true;
                toupdateProjectList.add(IPM_Coreparameter);
                CoreparameterId=IPM_Coreparameter.id;
            } 
            if(toupdateProjectList != NULL && !toupdateProjectList.isEmpty())
                update toupdateProjectList;
            getProjectDetails();
            
            if(IPM_Coreparameter.IPM_Answer_of_Q1__c==IPM_ConstantUtils.CORE_STRATEGIC_BLG){
                IsBLG=true;
            } 
            else{
                IsBLG=false;
            } 
        
            
            getcoreparameterHelps();
            saveintent();
            getsubsector();
        }
        catch(exception ex){
        } 
    } 
            
    /****************************************************************************
    @Description :Project Span tab
    *****************************************************************************/
    public void ProjectSpan(){
        toupdateProjectList=new list<IPM_Project__c>();
        if(IPM_Coreparameter!=null){
            
            toupdateProjectList.add(IPM_Coreparameter);
            try{ 
                if(String.isNotBlank(betId)){
                    IPM_Project__c updateProj =new IPM_Project__c(id=projectid);
                    updateProj.BET_Link_Requested__c=betId;
                    updateProj.BET_Link_Requested_on_Date__c=system.now();
                    BET_LinkingService.follow(projectid,betId,new list<id> {IPM_Coreparameter.IPM_Project_Leader__c,IPM_Coreparameter.Deputy_Project_Leader__c});
                    update updateProj ;
                }  
                if(toupdateProjectList != NULL && !toupdateProjectList.isEmpty())
                    update toupdateProjectList;    
            }
            catch(Exception ex) { 
            }
            CoreparameterId=IPM_Coreparameter.id;
            saveQuestionOne=false;
            saveQuestionTwo=false;
            saveQuestionThree=false;
            saveMarket=true;
        }
    }
        
    /****************************************************************************
    @Description :Method for save message
    *****************************************************************************/
    public void SaveMessage(){
        saveQuestionOne=true;
        saveQuestionTwo=false;
        saveQuestionThree=false;
        saveMarket=false;
    }        
    
    /****************************************************************************
    @Description :Save message for question number two
    *****************************************************************************/
    public void SaveMessageTwo(){
        saveQuestionOne=false;
        saveQuestionTwo=true;
        saveQuestionThree=false;
        saveMarket=false;
    } 
    
    /****************************************************************************
    @Description :Save message for question number three
    *****************************************************************************/
    public void SaveMessageThree(){
        saveQuestionOne=false;
        saveQuestionTwo=false;
        saveQuestionThree=true;
        saveMarket=false;
    }  
        
    
    /****************************************************************************
    @Description :Get user type with access permission
    *****************************************************************************/
    public void getIpmuserType(){
        list<IPM_Project_Resource__c>lstProuser;
        list<PermissionSetAssignment>PermissonS;
        if(String.isNotBlank(projectId)) {
            lstProuser=[SELECT IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,
                        IPM_Project__r.IPM_Project_Leader__c FROM IPM_Project_Resource__c WHERE 
                        IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() AND IPM_Project__r.Is_Archieved__c=false limit 1];
            
        }                                        
        if(lstProuser != NULL && !lstProuser.isEmpty()){
            
            if(lstProuser[0].IPM_Role_Type__c==IPM_ConstantUtils.IPM_ROLE_BD){
                isEditable=false;
                
            }
            else if(lstProuser[0].IPM_Role_Type__c==IPM_ConstantUtils.IPM_ROLE_CMI){
                isEditable=true;
            }
            else if(lstProuser[0].IPM_Role_Type__c==IPM_ConstantUtils.IPM_ROLE_CD){
                isEditable=false;
            }
            else if(lstProuser[0].IPM_Role_Type__c==IPM_ConstantUtils.IPM_ROLE_RD){
                isEditable=false;
            }
            else if(lstProuser[0].IPM_Role_Type__c==IPM_ConstantUtils.IPM_ROLE_SUPPLY_CHAIN){
                isEditable=false;
            }
            else if(lstProuser[0].IPM_Role_Type__c==IPM_ConstantUtils.IPM_ROLE_FINANCE){
                isEditable=false;
            }
            else if(lstProuser[0].IPM_Role_Type__c==IPM_ConstantUtils.IPM_ROLE_BB){
                isEditable=true;
            }
        } 
        if(!isEditable){
            list<IPM_Project__c>lstofuser=[SELECT IPM_Project_Leader__c FROM IPM_Project__c WHERE 
                                           id=:projectId and (IPM_Project_Leader__c =:userinfo.getuserid() 
                                                              OR IPM_Technical_Project_Leader__c=:userinfo.getuserid() 
                                                              OR Deputy_Project_Leader__c=:userinfo.getuserid() ) AND Is_Archieved__c=false limit 1];
            if(lstofuser != NULL && !lstofuser.isEmpty()){
                isEditable=true;  
            }
            else{
                isEditable=false;
            }
        }
        try {
            PermissonS=[SELECT Assignee.Name, PermissionSet.Name
                        FROM PermissionSetAssignment WHERE (PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_CENTRAL OR 
                                                            PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_BUSINESS OR PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_BBPL 
                                                            OR PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_DEPUTY_LEADER OR 
                                                            PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_PROJECT_LEADER) AND Assignee.id=:userinfo.getuserid() limit 50000];
        }
        Catch(Exception ex) {
        }
        if(PermissonS != NULL && !PermissonS.isEmpty()){
            isEditable=true;
        }                                       
        
    }           
    
    
    
    /****************************************************************************
    @Description :To retrive the Subsector details
    *****************************************************************************/  
    public void getsubsector(){
        getProjectDetails();
        if(IPM_Coreparameter.IPM_Category_Text__c!=null){
            lstsubsector=new list<selectoption>();
            string CatName='';
            string selCat=IPM_Coreparameter.IPM_Category_Text__c;
            List<MDO_Category__c > userMarket;
            set<string>UniqueSubSector=new set<string>();
            if(selCat.equals(IPM_ConstantUtils.HHC_CONSTANT)){
                CatName=IPM_ConstantUtils.HOUSEHOLDCARE_CONSTANT ;
            }
            else{
                CatName=selCat;
            }
            if(CatName.equals(IPM_ConstantUtils.HOUSEHOLDCARE_CONSTANT)){
                lstsubsector.add(new Selectoption('',system.label.IPM_SelectSubSector));
            }else{
                lstsubsector.add(new selectoption('',system.label.IPM_SelectMarket));
            }
            
            if(CatName != null && CatName != '') {
                userMarket=[SELECT Name FROM
                            MDO_Category__c WHERE parent_id__r.name=: CatName
                            LIMIT 50000];
            }
           
            for(MDO_Category__c u:userMarket){
                UniqueSubSector.add(u.Name );
                
            } 
            for(string CatMarket:UniqueSubSector){
                lstsubsector.add(new Selectoption(CatMarket,CatMarket));
            }           
           
        }          
    }
    
    /****************************************************************************
    @Description :To retrive the Category name , Market and Subsector
    *****************************************************************************/    
    public void getcategoryname(){
        getProjectDetails();
        getsubsector();
        
    }
    
    /****************************************************************************
    @Description :Save Intent to the back end field for reporting requirement.
    *****************************************************************************/
    public void saveintent(){
        toupdateProjectList=new list<IPM_Project__c>();
        //*@Description :BLG
        if(IPM_Coreparameter.IPM_Answer_of_Q1__c==Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_BLG; 
        
        //*@Description : Innovation
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt1 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt1 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION;  
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt1 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt2 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt1 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt3 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt1 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt4 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt2 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt1 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt2 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt2 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt2 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt3 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt3 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt1 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt3 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt2 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt4 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt1 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION;
        //*@Description : Renovation
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt1 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt5 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_RENOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt2 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt4 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_RENOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt2 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt5 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_RENOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt3 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt3 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_RENOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt3 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt4 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_RENOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt3 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt5 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_RENOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt4 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt2 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_RENOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt4 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt3 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_RENOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt4 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt4 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_RENOVATION;
        else if(IPM_Coreparameter.IPM_Answer_of_Q3__c==Q3_Opt4 && IPM_Coreparameter.IPM_Answer_of_Q2__c==Q2_Opt5 && IPM_Coreparameter.IPM_Answer_of_Q1__c!=Q1_Opt9)
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_RENOVATION; 
        else
            IMPStrategic=IPM_ConstantUtils.CORE_STRATEGIC_OPERATIONAL;  
        IPM_Coreparameter.IPM_Strategic_Intent__c=IMPStrategic;
        if(IPM_Coreparameter.IPM_Answer_of_Q1__c!=null && IPM_Coreparameter.IPM_Answer_of_Q2__c!=null && IPM_Coreparameter.IPM_Answer_of_Q3__c!=null)
            IPM_Coreparameter.IPM_IsCompleted__c=true;
        else if(IPM_Coreparameter.IPM_Answer_of_Q1__c==IPM_ConstantUtils.CORE_STRATEGIC_BLG && IPM_Coreparameter.IPM_Answer_of_Q2__c!=null)
            IPM_Coreparameter.IPM_IsCompleted__c=true;
        else if(IPM_Coreparameter.IPM_Answer_of_Q1__c==Q1_Opt10 || IPM_Coreparameter.IPM_Answer_of_Q1__c==Q1_Opt11 || IPM_Coreparameter.IPM_Answer_of_Q1__c==Q1_Opt12 || IPM_Coreparameter.IPM_Answer_of_Q1__c==Q1_Opt13 || IPM_Coreparameter.IPM_Answer_of_Q1__c==Q1_Opt14)   
            IPM_Coreparameter.IPM_IsCompleted__c=true;
        else
            IPM_Coreparameter.IPM_IsCompleted__c=false;
        toupdateProjectList.add(IPM_Coreparameter);
        try {   
            if(toupdateProjectList != NULL && !toupdateProjectList.isEmpty())
                update  toupdateProjectList; 
        }
        catch(Exception ex) {
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
    IPM_BET_BETWrapper(BET_BETWrapper bw){
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
    }
    }
}