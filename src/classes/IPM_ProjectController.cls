/****************************************************************************
@Description : To meet requirements  REQ00003
@Created Date: March 2015
@Author: Cognizant
@Referenced: ipm_ProjectSetup or ipm_EditProject page
****************************************************************************/
global with sharing class IPM_ProjectController extends IPM_ProjectIntermediateController{
    //*@Description: To store project Id
    IPM_Project__c updatedProjectId;
    //*@Description: Flag for special characters
    public Boolean isContainSpecialChars{get; set;}
    //*@Description: Flag for Project Id
    public Boolean IdGenerated{get;set;}
    //*@Description: Specifies category selected
    public String selCat {get; set;}
    //*@Description: Specifies list of project names
    public List<IPM_Project__c> listofProjectName {get; set;}
    //*@Description: Flag for Image
    public Boolean isImage {get; set;}
    //*@Description: Store Image Id
    public String ImageId {get; set;}
    //*@Description: Flag for Project Name
    public Boolean isNameMandatory{get;set;}
    //*@Description: Specifies expected TLD
    public String expectedTLD {get;set;}
    //*@Description: Specifies project Id
    public String ProId{get;set;}
    //*@Description: Specifies brand selected
    public String selBrand {get; set;}
    //*@Description: Specifies brand positioning
    public String selBrandPos {get; set;}
    //*@Description: Specifies project Id
    public String projectId{get; set;}
    //*@Description: Flag for save
    public Boolean isSaved{get; set;}
    //*@Description: Flag for project Initialization
    public Boolean initialised{get; set;}
    //*@Description: Specifies Image url
    public string imgurl{get;set;}
    //*@Description: Specifies user access permission
    public boolean isEditable{get;set;}
    //*@Description: Flag for saving project
    public boolean IsSaveProject{get;set;}
    //*@Description: Specifies company record type
    public list<IPM_User_Profile__c>companyCard=new list<IPM_User_Profile__c>();
    //*@Description: Stores company type based on company card record type
    public String CompanyType{get;set;}
    //*@Description: Flag for category
    public boolean isCateMandatory{get;set;}
    //*@Description: Flag for Brand
    public boolean isBrandPoMandatory{get;set;}
    //*@Description: Flag for TLD
    public boolean isTLDMandatory{get;set;}
    //*@Description: Flag for checking TLD 
    public boolean isTLDLessThnSixMnth{get;set;}
    //*@Description: Flag for Project Description
    public boolean isProDescMandatory{get;set;}
    //*@Description: Flag for Task editing
    public Boolean isTaskeditable{get;set;}
    //*@Description: Flag for Task
    public Boolean isAllTask{get;set;}
    //*@Description: Flag for Milestone editing
    public Boolean isMilestoneEditable{get;set;}
    //*@Description: Flag for BD user role
    public Boolean isBDuser{get;set;}
    //*@Description: Flag for date
    public Boolean isupdateDates{get;set;}
    //*@Description: Specifies user functional role
    public string FunctionRole{get;set;}      
    //*@Description: Flag for visibility
    public boolean isvisible{get;set;}
    //*@Description: Specifies complexity type
    public string ComplexityType{get;set;}
    //*@Description: Flag for Task generation
    public boolean isTaskgenerated{get;set;}
    //*@Description: Specifies company card selected
    public id selectedCompany{get;set;}
    //*@Description: Specifies list of company cards permitted for user
    public list<selectoption>lstCompany{get;set;}
    //*@Description: Specifies project quit tab name
    public string ProjectTabName{get;set;}
    //*@Description: Flag for initialization
    public boolean isdone{get;set;}
    //*@Description: Flag for duplicate project
    public boolean isDupProjectname{get;set;}
    //*@Description: list of existing project names
    //private list<IPM_Project__c> duplicateProject=new list<IPM_Project__c> ();
    private boolean hasDuplicateProject=false;
    //*@Description: list of project resource
    private list<IPM_Project_Resource__c> lstProuser = new list<IPM_Project_Resource__c>();
    //*@Description: list of project    
    private list<IPM_Project__c> projectUpdateList = new list<IPM_Project__c>();
    //*@Description:selected region
    Private  String Region_STR{get;set;}
    //*@Description:to hold file upload url
    public string fileUploadUrl{get;set;} 
    //*@Description:selected project type
    public static string SelectedPType {get; set;}
    //*@Description:to hold selected project type
    private string choosedPType;
    //*@Description:to check TargetLaunchDate
    private date targetLaunchValid;
    //*@Description:company card mandatory
    public boolean isCompanyMandatory{get;set;}
    //*@Description:company card recordtype
    private string REType;
    //*@Description:user role
    private string userType;
    //*@Description:Project types
    public  string pTypeInnovationRenn {get; set;}
    public  string pTypeOperational {get; set;}
    public  string pTypeBLG {get; set;}
    public static final String IPM_PROJECTCONTROLLER_STR = 'IPM_ProjectController';
    /****************************************************************************
    @Description : Initialization of the constructor
    *****************************************************************************/
    public IPM_ProjectController(ApexPages.StandardController controller){
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
        initialise();      
    }
    /****************************************************************************
    @Description : To initialize all variables
    *****************************************************************************/
    public void initialise(){
        ProId=IPM_ConstantUtils.BLANK;
        isdone=false;
        isEditable=false;
        isDupProjectname=false;
        isTaskgenerated=false;
        ComplexityType=IPM_ConstantUtils.BLANK;
        projectId=IPM_ConstantUtils.BLANK;
        IdGenerated=false;
        isContainSpecialChars=false;
        isCateMandatory=false;
        isBrandPoMandatory=false;
        isTLDMandatory=false;
        isProDescMandatory=false;
        isCompanyMandatory=false;
        isupdateDates=true;
        ProjectTabName=IPM_ConstantUtils.BLANK;
        initialised=false;
        userType=IPM_ConstantUtils.BLANK;
        REType=IPM_ConstantUtils.BLANK;
        fileUploadUrl=IPM_ConstantUtils.SERVLET_URL;
        targetLaunchValid=IPM_ConstantUtils.IPM_TargetLaunchDate ;
        imgurl=System.Label.IPM_image;
        projectId= ApexPages.currentPage().getParameters().get('Pid');
                
        PTypeInnovationRenn =IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL_VALUE1;
        pTypeOperational = IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL;
        pTypeBLG = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL_VALUE2;
                if(String.isNotBlank(projectId)){
            ProId=projectId;
            IdGenerated=true;
            initialised=true;
        }
        if (String.isBlank(ProId)){
            project = new IPM_Project__c();
        } 
        else{
            
            selBrand=project.IPM_Brand__c;
            selCat=project.IPM_Category_Text__c;
            selBrandPos=project.IPM_Brand_Positioning__c;
            expectedTLD=project.IPM_Target_Launch_Date__c;
            ComplexityType=project.IPM_Complexity__c;
            ProjectTabName=project .IPM_Quit_Project_Tab__c;
            selectedCompany=project.IPM_Company_Card__c;
            CompanyType=project.IPMProject_Span__c;
            Region_STR=project.IPM_Region_Shr__c;
            if(string.isNotblank(project.IPM_Selected_Project_Type__c)){
                SelectedPType= project.IPM_Selected_Project_Type__c;
            }
            else{
                SelectedPType=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL_VALUE1;
            }
            
            isSaved=true;
            list<IPM_Task__c >ipmprojectTask=[SELECT id FROM IPM_Task__c WHERE IPM_Project__c=:projectId LIMIT 1 ];
            if(!ipmprojectTask.isEmpty()){
                isTaskgenerated=true;
                selectedCompany=project.IPM_Company_Card__c;
            }
            //listofProjectName=IPM_WithoutShareController.allProjectList(ProId);
        }
        isNameMandatory=false; 
        ImageId=ApexPages.currentPage().getParameters().get('image');
        if(String.isNotBlank(ImageId)){
            isImage=true;
        }
        getProjectResource();
        getIpmuserType();
        getMilesTaskIpmuserType();
        getAllcompanycard();
        getCategory();
        getBrandPos();
        isdone=true;
    } 
    /****************************************************************************
    @Description : Inner class to get date
    *****************************************************************************/
    
    public class DatePicker {
        public String datename {get; set;}
    } 
    /****************************************************************************
    @Description : Getting List of Categories
    @Return:List of category
    *****************************************************************************/  
    public List<SelectOption> getCategory(){   
        try{
            List<IPM_Company_Card__c> userCat=new List<IPM_Company_Card__c>();
            if(String.isNotBlank(selectedCompany) && selectedCompany!=null){
                userCat=[SELECT id, IPM_Managed_category__c,RecordType.Name FROM IPM_Company_Card__c WHERE
                         Id=:selectedCompany and IPM_Managed_category__c !=null limit 1];
                
                if(!userCat.isEmpty() && userCat[0].RecordType.Name!=null)
                {
                    REType=userCat[0].RecordType.Name;
                }
                if(REType!=null && REType.length() > 0)
                {
                    if(REType.contains(IPM_ConstantUtils.COMPANY_CARD_GLOBAL)){
                        CompanyType=IPM_ConstantUtils.COMPANY_CARD_GLOBAL;
                    }
                    else if(REType.contains(IPM_ConstantUtils.COMPANY_CARD_REGIONAL)){
                        CompanyType=IPM_ConstantUtils.COMPANY_CARD_REGIONAL;
                    }
                    else {
                        CompanyType=IPM_ConstantUtils.COMPANY_CARD_LOCAL;
                    }
                }
                List<IPM_User_Profile__c>userRegionList=new List<IPM_User_Profile__c>();
                userRegionList=[SELECT IPM_Region__c FROM IPM_User_Profile__C WHERE 
                                IPM_User__c=:userinfo.getuserid() AND IPM_Region__c!=null AND 
                                IPM_Company_Card__c=:selectedCompany LIMIT 1];
                if(!userRegionList.isEmpty()){
                    Region_STR=userRegionList[0].IPM_Region__c;
                }
            }
            integer countCat=0;
            integer conInt=1;
            string  catName=null;
            List<Selectoption> optns=new List<Selectoption>();    
            optns.add(new Selectoption(IPM_ConstantUtils.BLANK,system.label.IPM_SelectCategory));
            if(!userCat.isEmpty()){
                String[] splitCatString = userCat[0].IPM_Managed_category__c.split(IPM_ConstantUtils.Delimiter);
                for(string catg:splitCatString){
                    optns.add(new Selectoption(catg,catg));
                    countCat++;
                    catName=catg;
                }   
            }
            if(countCat==conInt){
                selCat=catName;
            }
            return optns;
        }
        catch(Exception ex){ 
           ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                 'getCategory',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
            return null;
        }
    }
    /****************************************************************************
    @Description : Getting List of Brand Positionings
    @Return: List of brand positioning
    *****************************************************************************/
    public List<SelectOption> getBrandPos(){
        List<Selectoption> optns=new List<Selectoption>(); 
        string catName=IPM_ConstantUtils.BLANK;
        set<string>uniqueBrandP=new set<string>();
        if(string.isNotBlank(selCat) && selCat.equals(IPM_ConstantUtils.HHC_CONSTANT)){
            CatName=IPM_ConstantUtils.HOUSEHOLDCARE_CONSTANT;
        }
        else{
            CatName=selCat;
        }
        optns.add(new Selectoption(IPM_ConstantUtils.BLANK ,system.label.IPM_SelectBrandPosition));
        if(String.isNotBlank(CatName)) {
            List<mdm_Brand_Position__c> userBrandPos=[SELECT id, Brand_Position_Name__c FROM mdm_Brand_Position__c 
                                        WHERE Category_Name__c=: CatName and Brand_Position_Name__c !=null ];
            
            if(!userBrandPos.isEmpty()){
                for(mdm_Brand_Position__c u:userBrandPos){
                    UniqueBrandP.add(u.Brand_Position_Name__c);
                } 
                for(string BrandPos:UniqueBrandP){
                    optns.add(new Selectoption(BrandPos ,BrandPos ));
                }           
            }
            
        }
        return optns;
    }
    /****************************************************************************
    @Description : For getting charter approver
    @Return: List of character approvers
    *****************************************************************************/
    public List<SelectOption> getCharterApprovers(){
        Schema.sObjectType sobject_type = IPM_Project__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map=new Map<String, Schema.SObjectField>();
        field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(IPM_ConstantUtils.IPM_CHARTER_APPROVER).getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    /****************************************************************************
    @Description : For getting project type
    @Return: null
    *****************************************************************************/
    public void savePTypes(){
        choosedPType= SelectedPType;
    }
    /****************************************************************************
    @Description : For getting contract and market ready approver
    @Return: List of contract approvers
    *****************************************************************************/
    public List<SelectOption> getContractApprovers(){
        Schema.sObjectType sobject_type = IPM_Project__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map=new Map<String, Schema.SObjectField>();
        field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(IPM_ConstantUtils.IPM_GATEKEEPING_MODEL).getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }      
    /****************************************************************************
    @Description : For Saving the Project
    *****************************************************************************/ 
    public void save(){
        try{
            projectUpdateList = new list<IPM_Project__c>();
            //duplicateProject=IPM_WithoutShareController.duplicateProjectList(proId,project.IPM_Project_Name__c);
            hasDuplicateProject = IPM_WithoutShareController.duplicateProjectList(proId,project.IPM_Project_Name__c);
            //if(duplicateProject.isEmpty()){
            if(!hasDuplicateProject){
                isNameMandatory=false;
                isContainSpecialChars=false;
                project.IPM_Project_Leader__c=UserInfo.getUserId();
                project.IPM_Brand__c=selBrand;
                project.IPM_Category_Text__c=selCat;
                project.IPM_Brand_Positioning__c=selBrandPos;
                project.IPM_Target_Launch_Date__c=expectedTLD;  
                project.IPMProject_Span__c=CompanyType;
                project.IPM_Company_Card__c=selectedCompany;  
                if(string.isNotBlank(proId)){
                    projectUpdateList.add(project);
                    if(!projectUpdateList.isEmpty())
                        update projectUpdateList;
                }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,System.Label.IPM_Record_Insert_Success));
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
            } 
        }catch(Exception ex){
            
            if(ex.getMessage().contains(IPM_ConstantUtils.CUSTOM_VALIDATION_EXCEPTION)){   
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,system.label.IPM_ProjectSpecialCharacters)); 
            }
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                 'save',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
             
        }            
    } 
    
    /****************************************************************************
    @Description : get all company cards for user
    @Return: List of company cards
    *****************************************************************************/
    public List<SelectOption> getAllcompanycard(){
        integer countCC=0;
        string ccId=IPM_ConstantUtils.BLANK;
        integer conInt=1;
        list<IPM_Company_Card__c>bpUserCCList=new list<IPM_Company_Card__c>();
        Set<id>holdCCidSet=new Set<id>();
        lstCompany= new List<SelectOption>();
        lstCompany.add(new selectoption(IPM_ConstantUtils.BLANK,system.label.IPM_SelectCompanyCard));
        List<IPM_User_Profile__c> ipmcompanycard;
        try{
            ipmcompanycard=[SELECT ID,IPM_Company_Card__c,IPM_Company_Card__r.name FROM
                            IPM_User_Profile__c WHERE IPM_User__c=:userinfo.getuserid()
                            and  IPM_Company_Card__c <>null and IPM_Company_Card__r.name!=null 
                            order by IPM_Company_Card__r.name ASC LIMIT 1000]; 
            bpUserCCList=[SELECT id,Name FROM IPM_Company_Card__c WHERE 
                                IPM_Business_Partner__c=:userinfo.getuserid() Order By name ASC LIMIT 1000];
        }
        
        Catch(Exception ex) {
          ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                 'getAllcompanycard',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
           
        }
        if(!ipmcompanycard.isEmpty()){
            for(IPM_User_Profile__c pro:ipmcompanycard){
                lstCompany.add(new selectoption(pro.IPM_Company_Card__c,pro.IPM_Company_Card__r.name));
                holdCCidSet.add(pro.IPM_Company_Card__c);
                countCC++;
                ccId=pro.IPM_Company_Card__c;
            }
        }
        if(!bpUserCCList.isEmpty()){
            for(IPM_Company_Card__c cc:bpUserCCList){
                if(!holdCCidSet.contains(cc.id)){
                    lstCompany.add(new selectoption(cc.id,cc.name));
                    countCC++;
                    ccId=cc.id;
                }
            }
        }
        //if logged in user has only one user profile
        if(countCC==conInt){
            selectedCompany=ccId;
        }
        return lstCompany;
    }
    /****************************************************************************
    @Description : searching duplicate project
    *****************************************************************************/
    public void searchprojectpahse(){
        getCategory();
        getbrandPos();   
    }
    /****************************************************************************
    @Description : For Saving Project and Proceed to Next Step
    @Return: Page Reference
    *****************************************************************************/
     public void saveProceed(){
        projectUpdateList = new list<IPM_Project__c>();
        Boolean validProjName_Booln=false;
        if(Pattern.matches(IPM_ConstantUtils.IPM_PROJECTNAME_PATTERN ,project.IPM_Project_Name__c)
         && project.IPM_Project_Name__c!=null){
            validProjName_Booln=false;
        }else{
            validProjName_Booln=true;
        } 
        if(string.isBlank(project.IPM_Project_Name__c)) {
            isContainSpecialChars=false;
            isNameMandatory=true;
            isDupProjectname=false;
        }
        else{
            isNameMandatory=false;
        }
        if(string.isBlank(selCat)){
            isCateMandatory=true;
        }
        else{
            isCateMandatory=false;
        }
        if(string.isBlank(selectedCompany)){
            isCompanyMandatory=true;
         }
        else{
            isCompanyMandatory=false;
        }
        if(string.isBlank(selBrandPos)){
            isBrandPoMandatory=true;
        }
        else{
            isBrandPoMandatory=false;
        }
        if(project.IPM_Target_Launch_Dates__c==null){
            isTLDMandatory=true;
            isTLDLessThnSixMnth=false;
        }
        else{
            isTLDMandatory=false;
        }
        if(project.IPM_Target_Launch_Dates__c < targetLaunchValid){
            isTLDMandatory=false;
            isTLDLessThnSixMnth=true;
        }
        else{
            isTLDLessThnSixMnth=false;
        }
        if(validProjName_Booln && !isNameMandatory) {
            isDupProjectname=false;
            isContainSpecialChars=true;
        }
        else{
            isContainSpecialChars=false;
        }
        if(isContainSpecialChars || isNameMandatory || isTLDLessThnSixMnth || isTLDMandatory || isBrandPoMandatory ||
           isCompanyMandatory || isCateMandatory ){
               IsSaveProject=false;
           }else{
               splitSaveProcced();
           }
    } 
    /****************************************************************************
    @Description : For Saving Project and Proceed to Next Step
    @Return: null
    *****************************************************************************/
    @TestVisible private void splitSaveProcced()
    {
        try
        {
            //duplicateProject=IPM_WithoutShareController.duplicateProjectList(proId,project.IPM_Project_Name__c);
            hasDuplicateProject = IPM_WithoutShareController.duplicateProjectList(proId,project.IPM_Project_Name__c);
            //if(duplicateProject.isEmpty()){
            if(!hasDuplicateProject){
                isNameMandatory=false;
                isContainSpecialChars=false; 
                project.IPM_Project_Leader__c=UserInfo.getUserId();                                                            
                project.IPM_Brand__c=selBrand;
                project.IPM_Category_Text__c=selCat;
                project.IPM_Brand_Positioning__c=selBrandPos;
                project.IPM_Target_Launch_Date__c=expectedTLD;  
                project.IPM_Child_Fast_Track_Project__c=project.IPM_Fast_Track_Project__c;
                project.IPM_Project_Navigate__c = True; 
                project.IPM_IsSaved__c = True;
                project.IPM_Region_Shr__c=Region_STR;
                project.IPMProject_Span__c=CompanyType;
                project.IPM_Company_Card__c=selectedCompany; 
                if(CompanyType.equalsignorecase(IPM_ConstantUtils.COMPANY_CARD_LOCAL))
                {
                    project.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL;  
                        project.IPM_Selected_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL;
                }
                else{
                    project.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;    
                        project.IPM_Selected_Project_Type__c=choosedPType;
                }
                // Add to start Background Processing for Project Creation. 
                //project.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                
                if(project.IPM_Complexity__c==null)
                {
                    project.IPM_Complexity__c=IPM_ConstantUtils.COMPLEXITY_LITE;
                    project.IPM_Child_Complexity__c=IPM_ConstantUtils.COMPLEXITY_LITE;
                    project.IPM_Project_Navigate__c = True;
                }
                if(CompanyType.equals(IPM_ConstantUtils.COMPANY_CARD_REGIONAL)){
                    String shortName_STR=regionShortName();
                    String removeName=project.IPM_Project_Name__c.SubstringBefore(IPM_ConstantUtils.UNDERSCORE);
                    project.IPM_Project_Name__c=removeName+shortName_STR;
                }
                if(string.isNotBlank(proId))
                {
                    
                    projectUpdateList.add(project);
                    if(!projectUpdateList.isEmpty())
                        update projectUpdateList;
                    
                    IsSaveProject=true;
                    isNameMandatory=false;
                    isProDescMandatory=false;
                    isCateMandatory=false;
                    isBrandPoMandatory=false;
                    isTLDMandatory=false;
                    isDupProjectname=false;
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
                isContainSpecialChars=false;
                isNameMandatory=false;
                isDupProjectname=true;
            } 
        }catch(Exception ex)
        {
            if(ex.getMessage().contains(IPM_ConstantUtils.CUSTOM_VALIDATION_EXCEPTION))
            {   
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,system.label.IPM_ProjectSpecialCharacters)); 
            }
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                 'splitSaveProcced',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
           
        }
    }
    /****************************************************************************
    @Description : Append project name with region shot name
    *****************************************************************************/
    @TestVisible private string regionShortName(){
        Map<String,IPM_Market_Cluster_Short_Names__c>shortnameMap=IPM_Market_Cluster_Short_Names__c.getAll();
        String shortName_STR=IPM_ConstantUtils.BLANK;
        for(IPM_Market_Cluster_Short_Names__c shortN:shortnameMap.Values()){
            if(shortN.Unilever_Cluster__c.equalsignorecase(Region_STR)){
                shortName_STR=IPM_ConstantUtils.UNDERSCORE+shortN.Short_Name__c; 
            }
        }
        return shortName_STR;
    }
    @TestVisible private void getProjectResource(){
        if(String.isNotBlank(projectId)) {
            lstProuser=[SELECT IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,
                        IPM_Project__r.IPM_Project_Leader__c FROM IPM_Project_Resource__c WHERE
                        IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() AND 
                        IPM_Role_Type__c != null limit 1];
        }
    }
    /****************************************************************************
    @Description : Get user type with access permission
    *****************************************************************************/
    @TestVisible private void getIpmuserType(){
        try {
            Boolean hasvalues_Booln=false;
            if(lstProuser.isEmpty()){
                hasvalues_Booln=false;
            }else{
                hasvalues_Booln=true;
            }
            if(hasvalues_Booln){
                userType=lstProuser[0].IPM_Role_Type__c;
                if(userType.equals(IPM_ConstantUtils.IPM_ROLE_BD) || 
                                                userType.equals(IPM_ConstantUtils.IPM_ROLE_CD) ||
                                                userType.equals(IPM_ConstantUtils.IPM_ROLE_RD) ||
                                                userType.equals(IPM_ConstantUtils.IPM_ROLE_SUPPLY_CHAIN) ||
                                                userType.equals(IPM_ConstantUtils.IPM_ROLE_FINANCE)){
                    isEditable=false;
                }
                if(userType.equals(IPM_ConstantUtils.IPM_ROLE_CMI) || 
                        userType.equals(IPM_ConstantUtils.IPM_ROLE_BB)){
                    isEditable=true;
                }
                
            }  
            if(isEditable != NULL && !isEditable){
                list<IPM_Project__c>lstofuser=[SELECT IPM_Project_Leader__c,IPM_IsCompleted__c  FROM IPM_Project__c WHERE
                                               id=:projectId and (IPM_Project_Leader__c =:userinfo.getuserid() 
                                               or IPM_Technical_Project_Leader__c=:userinfo.getuserid() 
                                               or Deputy_Project_Leader__c=:userinfo.getuserid() ) limit 1];
                if(lstofuser.isEmpty()){
                    isEditable=false;  
                }   
                else{
                    isEditable=true;
                }
            }
            list<PermissionSetAssignment>permissonS=[SELECT Assignee.Name, PermissionSet.Name FROM PermissionSetAssignment
                                                     WHERE (PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_CENTRAL 
                                                     or PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_BUSINESS
                                                     or PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_BBPL 
                                                     or PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_DEPUTY_LEADER 
                                                     or PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_PROJECT_LEADER) 
                                                     and Assignee.id=:userinfo.getuserid()];
            if(!PermissonS.isEmpty()){
                isEditable=true;
            }
        }Catch (Exception ex) {
          ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                 'getIpmuserType',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
         
        }
    } 
    /****************************************************************************
    @Description : Get Milestone and task access
    *****************************************************************************/
    @TestVisible private void getMilesTaskIpmuserType(){
        list<IPM_Project_Resource__c>countTaskSCUser=new List<IPM_Project_Resource__c>();
        list<PermissionSetAssignment>permissonS=new list<PermissionSetAssignment>();
        if(String.isNotBlank(projectId)) {
            CountTaskSCUser=[SELECT IPM_Role_Type__c,IPM_Project_Role_Owner__c FROM IPM_Project_Resource__c WHERE 
                             IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() and 
                             IPM_Role_Type__c=:IPM_ConstantUtils.IPM_ROLE_SUPPLY_CHAIN limit 1];
        }
        if(CountTaskSCUser.isEmpty()){
            isTaskeditable=false;
            isAllTask=false; 
        }
        else{
            isTaskeditable=true;
            isAllTask=true; 
        }                                      
        Boolean hasUser_Booln=false;
        if(lstProuser.isEmpty()){
            hasUser_Booln=false;
        }else{
            hasUser_Booln=true;
        }
        if(hasUser_Booln){
                userType=lstProuser[0].IPM_Role_Type__c;
            if(userType.equals(IPM_ConstantUtils.IPM_ROLE_GUEST)){
                isMilestoneEditable=false;
                isTaskeditable=false;
            }            
            else {
                isMilestoneEditable=true;
                isTaskeditable=true;
                FunctionRole=userType;
                if(userType.equals(IPM_ConstantUtils.IPM_ROLE_BD_MARKETING))
                    FunctionRole=IPM_ConstantUtils.IPM_ROLE_BD;
            }
            if(userType.equals(IPM_ConstantUtils.IPM_ROLE_BD) || 
                userType.equals(IPM_ConstantUtils.IPM_ROLE_BD_MARKETING)){
                isBDuser=true;
            }
            if(userType.equals(IPM_ConstantUtils.IPM_ROLE_CMI) || 
                userType.equals(IPM_ConstantUtils.IPM_ROLE_CD) || 
                userType.equals(IPM_ConstantUtils.IPM_ROLE_FINANCE) || 
                userType.equals(IPM_ConstantUtils.IPM_ROLE_GUEST)){
                isupdateDates=false;
            }
        } 
        if(project!=null){
            if((project.IPM_Project_Leader__c==userinfo.getuserid() && project.IPM_Project_Leader__c != null)||
                                (project.Deputy_Project_Leader__c==userinfo.getuserid() && project.Deputy_Project_Leader__c!=null)||
                                (project.IPM_Technical_Project_Leader__c==userinfo.getuserid() && 
                                project.IPM_Technical_Project_Leader__c!=null)){
                isMilestoneEditable=true;
                isTaskeditable=true;
                isAllTask=true;  
            }
            else if(project.IPM_Project_Gatekeeper__c==userinfo.getuserid() && project.IPM_Project_Gatekeeper__c!=null){
                isMilestoneEditable=false;
                isTaskeditable=false;
                isupdateDates=false;
                isAllTask=false;
                isvisible=false;  
            }  
        }
        try {
            PermissonS=[SELECT Assignee.Name, PermissionSet.Name FROM PermissionSetAssignment WHERE
                        (PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_CENTRAL 
                        or PermissionSet.Name=:IPM_ConstantUtils.PERMISSION_BUSINESS) 
                        and Assignee.id=:userinfo.getuserid()];
            
        }Catch(Exception ex) {
          ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                 'getMilesTaskIpmuserType',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
        }
        if(!PermissonS.isEmpty()){
            isMilestoneEditable=true;
            isTaskeditable=true;
            isAllTask=true; 
        }                                       
    }
    /****************************************************************************
    @Description : save complexity type
    *****************************************************************************/
    public void saveComplexityType(){
        projectUpdateList = new list<IPM_Project__c>();
        if(string.isBlank(ComplexityType)){
            ComplexityType=IPM_ConstantUtils.COMPLEXITY_LITE;
        }
        project.IPM_Complexity__c=ComplexityType;
        project.IPM_Child_Complexity__c=ComplexityType;
        projectUpdateList.add(project);
        try{
            if(!projectUpdateList.isEmpty())
                update projectUpdateList;
        }
        Catch(Exception ex) {
          ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                 'SaveComplexityType',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
        }
    } 
    /****************************************************************************
    @Description : For updating the project
    *****************************************************************************/
    public void none(){
        projectUpdateList = new list<IPM_Project__c>();
        projectUpdateList.add(project);
        try{
            if(!projectUpdateList.isEmpty())
                update projectUpdateList;
        }
        Catch(Exception ex) {
          ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                 'none',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
        }
    } 
    /****************************************************************************
    @Description : save IPM Approach
    *****************************************************************************/
    public void saveIPMApproach(){
        projectUpdateList = new list<IPM_Project__c>();
        if(project.IPM_PM_Approach__c==IPM_ConstantUtils.IPM_APPROACH_INTERNAL){
            project.IPM_PM_Approach__c=IPM_ConstantUtils.IPM_APPROACH_EXTERNAL;
        }
        else{
            project.IPM_PM_Approach__c=IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
        }
        projectUpdateList.add(project);
        try{
            if(!projectUpdateList.isEmpty())
                update projectUpdateList;
        }
        Catch(Exception ex) {
          ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                 'SaveIPMApproach',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
        }
    } 
    /****************************************************************************
    @Description : save quit Project Tab Name
    *****************************************************************************/
    @Remoteaction
    global static string savetabname(String tabname,String projectID){
        list<IPM_Project__c>projectUpdateList = new list<IPM_Project__c>();
        IPM_Project__C projecttoUpdate=new IPM_Project__c();
        projecttoUpdate.id=projectID;
        projecttoUpdate.IPM_Quit_Project_Tab__c=Tabname;
        projectUpdateList.add(projecttoUpdate);
        try{
            if(!projectUpdateList.isEmpty())
                update projectUpdateList;
        }
        Catch(Exception ex) {
          ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                 'Savetabname',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
          
        }
        return projectID;
    }
    /****************************************************************************
    @Description : save Brand positioning
    *****************************************************************************/
    public void searchbrandPos(){
        getbrandPos();
    }
}