/****************************************************************************
@Description : To meet requirements  REQ00003
@Created Date: March 2015
@Author: Cognizant 
@Referenced: ipm_ProjectSetup or ipm_EditProject page
****************************************************************************/
global with sharing class IPM_ProjectSetUpController extends IPM_ProjectIntermediateController{ 
    //*@Description: default sub project type for company card selection
    private static final Map<String,String> COMPANYCARDTODEFAULTSUBPROJECTTYPE = new Map<String,String>
    {'Global Company Card' => 'Innovation/Renovation','Regional Company Card' => 'Innovation/Renovation','Local Company Card'=>'Operational'};
    private static final String IPM_PROJECTCONTROLLER_STR = 'IPM_ProjectController';
    private static final Map<String,Boolean> APPENDREGIONMAP = new Map<String,Boolean>{'Regional' => true};
    private static final List<String> DEFAULT_MANDATORY_FIELDS = new List<String>{'IPM_Project_Name__c','IPM_Category_Text__c','IPM_Brand_Positioning__c','IPM_Company_Card__c','IPM_ProjectSubType__c','IPM_Target_Launch_Dates__c'};
    private static final String DEFAULT_CHARTER_APPROVER = 'RCLT';  
    
    //*@Description: TLD restriction in effect
    public  Boolean tldRestriction {get;set;}
    
    //*@Description: Project Resource list
    list<IPM_Project_Resource__c> lstProuser = new list<IPM_Project_Resource__c>();
    //*@Description: Project Metadata information
    public List<IPM_ProjectMetadata__c> projectTypeList{get;set;}
    public IPM_ProjectMetadata__c projectMetadata {get;set;} 
    public Map<Id,String> companyCardToRecordType {get;set;}
    //*@Description: Flag for Business Mandatory Fields
    public Boolean isMaxBrandPosition {get;set;}
    public Boolean isBusinessError {get;set;}
    public String businessErrorField {get;set;}
    public Boolean isContainSpecialChars {get;set;}     
    public boolean isDupProjectname{get;set;}
    public boolean isTLDLessThnSixMnth{get;set;}
    public boolean isTLDBeforeGates{get;set;}
    public boolean isTLDLessThnToday{get;set;}
    public boolean saveSuccess{get;set;}
    public Boolean skipValidation{get;set;}
    public Boolean isSavedDB {get;set;} 
    public string isRollout{get;set;} 
    //*@Description: Specifies list of project names
    public set<string> listofProjectName {get; set;}
    //*@Description: Flag for Image
    public Boolean isImage {get; set;}
    //*@Description: Store Image Id
    public String ImageId {get; set;}
    //*@Description: Specifies Image url
    public string imgurl{get;set;}
    //*@Description: Specifies user access permission
    public boolean isEditable{get;set;}
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
    public string functionRole{get;set;}      
    //*@Description: Flag for visibility
    public boolean isvisible{get;set;}
    //*@Description: Specifies complexity type
    public string ComplexityType{get;set;}
    //*@Description: Flag for Task generation
    public boolean isTaskgenerated{get;set;}   
    //*@Description: Specifies project quit tab name
    public string ProjectTabName{get;set;}
    public boolean isCreateTask{get;set;}//is user create tasks
    public boolean updateApproach{get;set;}// is user update project approach
    public string isFromEditPage{get;set;}// For UI usage
    public boolean isProjectNameBlank{get;set;}//is no duplicate name
    public boolean isTLDFieldEditable{get;set;}// To make TLD field readonly #REQ02427          
    //*@Description: To show preselected BET in the unlinking modal  
    public String projbetlink {
    get{
        If (project.BET_Link_Requested__c!=null ){
            return project.BET_Link_Requested__c;
        }
        else if(string.isNotBlank(project.bet__c)){
            return project.bet__c;    
        }
        else{
            return null;
        }
    } 
    set;
    }
    public BET_BETWrapper PreSelectedBet{
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
    /****************************************************************************
    @Description : Initialization of the constructor
    *****************************************************************************/
    public IPM_ProjectSetUpController(ApexPages.StandardController controller){
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
        if(project!=null){
           initialise();
        }
    }
    /****************************************************************************
    @Description : To initialize all variables
    *****************************************************************************/
    //NPath Complexity-As per business logic, different flows needs to be followed in Project Creation, hence the logic is complex
    public void initialise() {
        ComplexityType = IPM_ConstantUtils.BLANK;
        businessErrorField  = IPM_ConstantUtils.BLANK;
        ProjectTabName = IPM_ConstantUtils.BLANK;
        isEditable = false;
        isTaskgenerated = false;
        isupdateDates = true;
        isBusinessError = false;
        isContainSpecialChars  = false;
        isDupProjectname = false;
        isTLDLessThnSixMnth = false;
        isTLDBeforeGates = false;
        saveSuccess = false;
        skipValidation = false;
        isCreateTask=false;
        updateApproach=false;
        isMaxBrandPosition =false;
        isProjectNameBlank=true;
        isSavedDB = project.IPM_IsSaved__c;
        imgurl=System.Label.IPM_image;
        companyCardToRecordType = new Map<Id,String>();
        projectTypeList = new List<IPM_ProjectMetadata__c>();
        isRollout =  IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        
        if(project!=null){
            List<IPM_ProjectMetadata__c>  projectMetadataList = IPM_Utils.getProjectTypeMetadata(new List<IPM_Project__c>{project});
            if(!projectMetadataList.isEmpty()){
                projectMetadata = projectMetadataList.get(0);
            }
            ComplexityType=project.IPM_Complexity__c;
            ProjectTabName=project .IPM_Quit_Project_Tab__c;
            list<IPM_Task__c >ipmprojectTask=[SELECT id FROM IPM_Task__c WHERE IPM_Project__c=:projectId LIMIT 1];
            if(!ipmprojectTask.isEmpty())
            {
                isTaskgenerated=true;
            }
        }
        else
        {
            project = new IPM_Project__c();
        }  
        
        if(projectMetadata == null)
        {
            projectMetadata = new IPM_ProjectMetadata__c();
        } 
        isFromEditPage=ApexPages.currentPage().getParameters().get('isEdit'); 
        ImageId=ApexPages.currentPage().getParameters().get('image');
        if(String.isNotBlank(ImageId))
        {
            isImage=true;
        }
         //remove project name suffix in case of regional project when displaying in UI edit page
        if(!String.isBlank(project.IPM_Project_Name__c) && project.IPM_Project_Type__c!=null && project.IPM_Project_Type__c!=isRollout && project.IPMProject_Span__c!=null && project.IPMProject_Span__c.equals('Regional')){
            project.IPM_Project_Name__c=project.IPM_Project_Name__c.substringBefore(IPM_ConstantUtils.UNDERSCORE);
        }
        getProjectResource();
        if(project!=null && !project.Is_Archieved__c){
            getIpmuserType();   
            getMilesTaskIpmuserType();
        }
        getAllcompanycard();
        setIsTLDFieldEditable(); 
        // Block User from Performing any operation if project is under processing.
        if(!String.isBlank(project.IPM_Project_Job_Status__c) && 
           (project.IPM_Project_Job_Status__c == IPM_ConstantUtils.JOB_STATUS_ELIGIBLE || project.IPM_Project_Job_Status__c == IPM_ConstantUtils.JOB_STATUS_PROCESSING) )
        {
            isEditable=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_BACKGROUNDPROCESS_INPROGRESS));
        }
        
         IPM_TLD_Restriction__c restTLD = IPM_TLD_Restriction__c.getValues('InEffect?');
         tldRestriction = restTLD.IPM_TLD_Restriction_In_Effect__c;
    }  
    /****************************************************************************
    @Description : Inner class to get date
    *****************************************************************************/
    public class DatePicker {
        public String datename {get; set;}
    } 
    /****************************************************************************
    @Description : get all company cards for user
    @Return: List of company cards
    *****************************************************************************/
    public List<SelectOption> getAllcompanycard()
    {
        List<SelectOption> companyCardSelect  = new List<SelectOption>();
        companyCardSelect.add(new selectoption(IPM_ConstantUtils.BLANK,system.label.IPM_SelectCompanyCard));    
        try
        {
            List<SelectOption> preparedCompanyCardList = new List<SelectOption>();
            Map<Id,String> resultantCompanyCardMap = new Map<Id,String>();
            // Preparing resultant company cards
            for(IPM_User_Profile__c userProfile : [SELECT ID,IPM_Company_Card__c,IPM_Company_Card__r.recordType.Name,IPM_Company_Card__r.name FROM IPM_User_Profile__c 
                                                   WHERE IPM_User__c=:userinfo.getuserid() AND IPM_Company_Card__c <>null AND IPM_Company_Card__r.name!=null 
                                                   ORDER BY IPM_Company_Card__r.name ASC LIMIT 10000])
            {
                resultantCompanyCardMap.put(userProfile.IPM_Company_Card__c,userProfile.IPM_Company_Card__r.Name);
                companyCardToRecordType.put(userProfile.IPM_Company_Card__c,userProfile.IPM_Company_Card__r.RecordType.Name);
            }
            for(IPM_Company_Card__c companyCard : [SELECT id,Name,RecordTypeId,RecordType.Name FROM IPM_Company_Card__c 
                                                   WHERE IPM_Business_Partner__c=:userinfo.getuserid() AND Name !=null
                                                   ORDER BY Name ASC LIMIT 10000])
            {
                if(!resultantCompanyCardMap.containsKey(companyCard.Id))
                {
                    resultantCompanyCardMap.put(companyCard.Id,companyCard.Name);
                    companyCardToRecordType.put(companyCard.Id,companyCard.RecordType.Name);
                }
            }
            if(!resultantCompanyCardMap.isEmpty())
            {
                Set<ID> companyCardSet = resultantCompanyCardMap.keySet();
                Integer counter =0 ;
                for(Id companyCardID : companyCardSet)
                {
                    counter++;
                    if(counter < 1000)
                    {               
                        preparedCompanyCardList.add(new selectoption(companyCardId,resultantCompanyCardMap.get(companyCardId)));
                    }
                    else
                    {
                        break;  
                    }                    
                }
                companyCardSelect.addAll(preparedCompanyCardList);
                // If company Card List contains Only 1 company Card, 
                //retrieve Category information based on company card.
                if(preparedCompanyCardList.size() == 1)
                {
                    project.IPM_Company_Card__c =   preparedCompanyCardList.get(0).getValue();
                    if(companyCardToRecordType.containsKey(project.IPM_Company_Card__c) && project.IPM_CompanyCardText__c==null)
                    {
                        project.IPM_CompanyCardText__c = companyCardToRecordType.get(project.IPM_Company_Card__c);
                    }
                }
            }
            if(project.IPM_Company_Card__c !=null &&  !String.isBlank(project.IPM_CompanyCardText__c))
            {
                getCategory();
                getProjectSubTypes();
                  
            }
        }
        catch(Exception ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,'splitSaveProcced',ex.getMessage(),ex,
                                                       IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);  
        }
        return companyCardSelect;
    }
    public void populateCategory()
    {   
        // Update the Project Type with Category specific information to find precise project Type.
        isBusinessError = false;
        businessErrorField= IPM_ConstantUtils.BLANK;    
        projectMetadata = new IPM_ProjectMetadata__c();
        project.IPM_Project_Type__c = project.IPM_Category_Text__c = project.IPM_GateKeeping_Model__c = project.IPM_Approver_of_Charter__c = project.IPM_ProjectSubType__c =project.IPMProject_Span__c = project.IPM_Phase__c = project.IPM_Complexity__c = project.IPM_Child_Complexity__c = IPM_ConstantUtils.BLANK;
        
        if(companyCardToRecordType.containsKey(project.IPM_Company_Card__c))
        {
            project.IPM_CompanyCardText__c = companyCardToRecordType.get(project.IPM_Company_Card__c);
        }
        else
        {
            isBusinessError = true;
            businessErrorField = 'IPM_Company_Card__c';  
        }
    }
    /****************************************************************************
    @Description : Getting List of Categories
    @Return:List of category
    *****************************************************************************/  
    public List<SelectOption> getCategory()
    {   
        // Select Options List 
        List<Selectoption> categoryOptionList =new List<Selectoption>();
        categoryOptionList.add(new Selectoption(IPM_ConstantUtils.BLANK,system.label.IPM_SelectCategory));    
        try
        { 
            // Only reach here when project Type is available else error.
            if(project.IPM_Company_Card__c !=null &&  !String.isBlank(project.IPM_CompanyCardText__c))
            {
                // Using Set to get Unique Categories.
                Set<String> availableCategoryStringSet = new Set<String>();
                List<String> availableCategoryStringList = new List<String>();
                List<IPM_Company_Card__c> availableCategoryList = new List<IPM_Company_Card__c>();
                availableCategoryList =[SELECT id, IPM_Managed_category__c,RecordType.Name,IPM_TxtGeographical_Scope__c,
                                        (SELECT Id,IPM_Region__c FROM IPM_User_Profile__r WHERE IPM_User__c=:userinfo.getuserid() AND IPM_Region__c!=null) 
                                        FROM IPM_Company_Card__c 
                                        WHERE Id=:project.IPM_Company_Card__c AND IPM_Managed_category__c !=null LIMIT 1];
                Map<String,IPM_Market_Cluster_Short_Names__c> mcsNames= IPM_Market_Cluster_Short_Names__c.getAll();  
                if(String.isNotBlank(availableCategoryList[0].RecordType.Name) && availableCategoryList[0].RecordType.Name==IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_REGIONAL){
                    for(IPM_Market_Cluster_Short_Names__c mcs:mcsNames.Values()){
                        if(mcs.Unilever_Cluster__c==availableCategoryList[0].IPM_TxtGeographical_Scope__c){
                            project.Market_Cluster_Name__c=mcs.Unilever_Cluster__c;
                            project.Market_Cluster__c=mcs.Name;
                        }
                    }
                }
                for(IPM_Company_Card__c asociatedCompanyCard : availableCategoryList)
                {
                    String[] categoryArray = asociatedCompanyCard.IPM_Managed_category__c.split(IPM_ConstantUtils.DELIMITER);
                    for(String categoryString : categoryArray)
                    {   
                        availableCategoryStringSet.add(categoryString);
                    }
                }
                if(!availableCategoryStringSet.isEmpty())
                {
                    availableCategoryStringList.addAll(availableCategoryStringSet);
                    if(project.Market_Cluster_Name__c!=null){
                        project.IPM_Region_Shr__c=project.Market_Cluster_Name__c;
                    }else{
                        project.IPM_Region_Shr__c=availableCategoryList[0].IPM_TxtGeographical_Scope__c;
                    } 
                    
                    // Check if category List is equals to 1, go ahead and populate BrandPositioning 
                    if(availableCategoryStringList.size() == 1)
                    {
                        project.IPM_Category_Text__c =  availableCategoryStringList.get(0); 
                    }
                    
                    for(String categoryString : availableCategoryStringList)
                    {
                        categoryOptionList.add(new Selectoption(categoryString,categoryString));    
                    }
                }
                if(!String.isBlank(project.IPM_Category_Text__c) )
                {
                    getBrandPos();  
                }
            }
        }
        catch(Exception ex)
        { 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,'getCategory',ex.getMessage(),ex,
                                                       IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            return null;
        }
        return categoryOptionList;
    }

    /****************************************************************************
    @Description : Getting List of Brand Positionings
    @Return: List of brand positioning
    *****************************************************************************/
    //NPath Complexity-Based on the Business Logic all brand positions needs to be fetched for various conditions
    public List<SelectOption> getBrandPos()
    {   
        List<Selectoption> brandOptionList = new List<Selectoption>();
        List<MDO_BrandPositions__c> userBrandPos; 
        if(!projectMetadata.IPM_MultipleBrandPosApplicable__c)
        {
           brandOptionList.add(new Selectoption(IPM_ConstantUtils.BLANK ,system.label.IPM_SelectBrandPosition));
        }
        
        Set<String> brandPositionSet = new Set<String>(); 
        try
        {
            if(!String.isBlank(project.IPM_Category_Text__c) && String.isNotBlank(project.IPM_Region_Shr__c))
            {
                String Query_STR=IPM_ConstantUtils.BLANK;
                Query_STR='SELECT brand_position_id__r.Name FROM MDO_BrandPositions__c WHERE status__c=\''+string.escapeSingleQuotes(ipm_constantutils.BRANDPOSITION_STATUS_ACTIVE) +'\' and brand_position_id__r.status__c=\''+string.escapeSingleQuotes(ipm_constantutils.BRANDPOSITION_STATUS_ACTIVE) +'\' and product_category_id__r.parent_id__r.name=\''+ string.escapeSingleQuotes(project.IPM_Category_Text__c) +'\' ';
                if(project.IPM_CompanyCardText__c.contains(IPM_ConstantUtils.COMPANY_CARD_REGIONAL)){
                   Query_STR+=' and geo_id__r.parent_L4__r.name=\''+ string.escapeSingleQuotes(project.IPM_Region_Shr__c) +'\' ';
                }
                else if(project.IPM_CompanyCardText__c.contains(IPM_ConstantUtils.COMPANY_CARD_LOCAL)){
                    List<String>uniqueCountryList=project.IPM_Region_Shr__c.split(IPM_ConstantUtils.SEMICOLON);
                    Query_STR+=' and geo_id__r.Name IN:uniqueCountryList '; 
                }
                Query_STR+=' LIMIT 50000';
                userBrandPos=database.query(Query_STR);
                
                if(userBrandPos !=null && !userBrandPos.isEmpty())
                {
                    for(MDO_BrandPositions__c u:userBrandPos)
                    {
                        if(!brandPositionSet.Contains(u.brand_position_id__r.Name))
                        {
                            brandOptionList.add(new Selectoption(u.brand_position_id__r.Name ,u.brand_position_id__r.Name));
                            brandPositionSet.add(u.brand_position_id__r.Name);
                        }
                        
                    } 
                }
                                
                // To retain or Loose user Selection.
                if(!String.isBlank(project.IPM_Brand_Positioning__c))
                {
                    String[] selectedBrandPos = project.IPM_Brand_Positioning__c.split(IPM_ConstantUtils.COMMA);

                    Set<String> selectedBrandPosSet = new Set<String>(selectedBrandPos);  
                
                    Set<String> retainedBrandPos = new Set<String>();
                
                    for(String brandPos : brandPositionSet)
                    {
                        if(selectedBrandPosSet.contains(brandPos) )
                        {
                           retainedBrandPos.add(brandPos); 
                        }
                    }

                    String finalBrandPosString = IPM_ConstantUtils.BLANK;
                
                    if(!retainedBrandPos.isEmpty())
                    {
                        for(String retainedbrand : retainedBrandPos)
                        {
                            finalBrandPosString = finalBrandPosString + retainedbrand +  IPM_ConstantUtils.COMMA;      
                        }
                        finalBrandPosString = finalBrandPosString.removeEndIgnoreCase(IPM_ConstantUtils.COMMA);
                    }
                    project.IPM_Brand_Positioning__c = finalBrandPosString;
                }
            }
        }
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));    
        }
        return brandOptionList;
    }
    /****************************************************************************
    @Description : Getting List of Gate Keeping Models
    @Return: List of Gate Keeping Models
    *****************************************************************************/
    public List<SelectOption> getGateKeepingModels()
    {
        // Get Picklist Values from Database and then based on Project Type Filter those values
        Map<String, Schema.SObjectField> projectFieldMap = IPM_Project__c.getSObjectType().getDescribe().fields.getMap();
        List<Schema.PicklistEntry> gateKeepingPickVal = projectFieldMap.get('IPM_GateKeeping_Model__c').getDescribe().getPickListValues();
        List<SelectOption> gateKeepingOptions = new List<SelectOption>();
        if(String.isBlank(projectMetadata.IPM_Project_Type__c))
        {
            isBusinessError = true;
            businessErrorField = 'IPM_ProjectSubType__c';           
        }
        else
        {
            if(projectMetadata.IPM_GatekeepingModelsApplicable__c)
            {
                String gateKeepingString = projectMetadata.IPM_ApplicableGateKeepingModels__c;
                String defaultGateKeepingModel = projectMetadata.IPM_Default_GateKeeping_Model__c;
                Set<String> gateKeepingSet = new Set<String>();
                // Get Unique GateKeeping Models
                if(gateKeepingString!=null && !String.isEmpty(gateKeepingString))
                {
                    String[] gateKeepingArray = gateKeepingString.split(IPM_ConstantUtils.COMMA);
                    for(String gtKeepingModel: gateKeepingArray)
                    {
                        gateKeepingSet.add(gtKeepingModel);
                    }   
                }
                // Prepare the Select Option List from Picklist Metadata and get the Labels as well.
                for(Schema.PicklistEntry pickEntry : gateKeepingPickVal)
                {
                    if(!String.isBlank(pickEntry.getValue()) && gateKeepingSet.contains(pickEntry.getValue()))
                    {
                        gateKeepingOptions.add(new SelectOption (pickEntry.getLabel(),pickEntry.getValue() ) );
                    }
                }
                // Set default GateKeeping Model 
                if(!String.isBlank(defaultGateKeepingModel) && String.isBlank(project.IPM_GateKeeping_Model__c) )
                {
                    project.IPM_GateKeeping_Model__c = defaultGateKeepingModel;
                }
            }
        }
        return gateKeepingOptions;
    }
    /****************************************************************************
    @Description : Getting List of Sub Project types
    @Return: List of Sub Project types
    *****************************************************************************/
    //NPath Complexity-Based on the Business Logic fetching project sub type required for various conditions
    public List<SelectOption> getProjectSubTypes()
    {
        // Get Picklist Values from Database and then based on Project Type Filter those values
        Map<String, Schema.SObjectField> projectFieldDesc = IPM_Project__c.getSObjectType().getDescribe().fields.getMap();
        List<Schema.PicklistEntry> projectSubTypeVal = projectFieldDesc.get('IPM_ProjectSubType__c').getDescribe().getPickListValues(); 
        List<SelectOption> projectSubTypeOptions = new List<SelectOption>();
        List<String> projectSubTypeList = new List<String>();
        Set<String> projectSubTypeSet = new Set<String>();
        if(project.IPM_Company_Card__c !=null && !String.isBlank(project.IPM_CompanyCardText__c))
        {
            projectTypeList = IPM_Utils.getProjectTypesBasedOnCompanyCard(project);  
            String defaultSubProjectType = IPM_ConstantUtils.BLANK;
            
            for(IPM_ProjectMetadata__c projectMetadataObj : projectTypeList)
            {
                String projectSubTypeString = projectMetadataObj.IPM_ProjectSubType__c;
                
                if(projectMetadataObj.IPM_ApplicableCompanyCard__c == project.IPM_CompanyCardText__c && COMPANYCARDTODEFAULTSUBPROJECTTYPE.containsKey(projectMetadataObj.IPM_ApplicableCompanyCard__c))
                {
                    String tempDefaultSubProjectType = COMPANYCARDTODEFAULTSUBPROJECTTYPE.get(projectMetadataObj.IPM_ApplicableCompanyCard__c);  
                    if(!String.isBlank(tempDefaultSubProjectType) && 
                       !String.isBlank(projectSubTypeString) && projectSubTypeString.contains(tempDefaultSubProjectType))
                    {
                        defaultSubProjectType = tempDefaultSubProjectType;
                    }  
                }
                
                if(projectSubTypeString != null && !String.isBlank(projectSubTypeString))
                {
                    String[] projectSubTypeArray = projectSubTypeString.split(IPM_ConstantUtils.COMMA);
                    for(String projectSubType : projectSubTypeArray)
                    {
                        if(!projectSubTypeSet.contains(projectSubType))
                        {
                            projectSubTypeList.add(projectSubType);
                            projectSubTypeSet.add(projectSubType);
                        }
                    }     
                }    
            }
            
            if(!String.isBlank(defaultSubProjectType) && (project.IPM_ProjectSubType__c ==null || String.isBlank(project.IPM_ProjectSubType__c) ) && projectSubTypeSet.contains(defaultSubProjectType) )
            {
                project.IPM_ProjectSubType__c = defaultSubProjectType;
            }  
            
            if(projectSubTypeList!=null && !projectSubTypeList.isEmpty() && projectSubTypeList.size() == 1 && String.isBlank(project.IPM_ProjectSubType__c))
            {
                project.IPM_ProjectSubType__c = projectSubTypeList.get(0); 
            }
            
        }
        
        // Prepare the Select Option List from Picklist Metadata and get the Labels as well.
        for(Schema.PicklistEntry pickEntry : projectSubTypeVal)
        {
            if(!String.isBlank(pickEntry.getValue()) && projectSubTypeSet.contains(pickEntry.getValue()))
            {
                projectSubTypeOptions.add(new SelectOption( pickEntry.getValue(),pickEntry.getLabel()));
            }
        }
        
        if(!String.isBlank(project.IPM_ProjectSubType__c))
        {
            populateProjectInformation();
            getGateKeepingModels(); 
        }
        
        return projectSubTypeOptions;
    }
    
    /****************************************************************************
    @Description : To get Help Text for Project Sub Type 
    *****************************************************************************/
    public Map<String,String> getHelpTextProjectSubType()
    {
        Map<String,String> helpTextMap = new Map<String,String>();
        for(IPM_ProjectMetadata__c projectMetadataObj :projectTypeList)
        {
            String helpTextString = projectMetadataObj.IPM_SubProjectHelpText__c;
            helpTextMap.putAll(populateHelpText(helpTextString));
        }
        return helpTextMap;
    }
    
    /****************************************************************************
    @Description : To get Help Text for Gate Keeping Models
    *****************************************************************************/
    public Map<String,String> getHelpTextGateKeeping()
    {
        Map<String,String> helpTextMap = new Map<String,String>();
        for(IPM_ProjectMetadata__c projectMetadataObj :projectTypeList)
        {
            String helpTextString = projectMetadataObj.IPM_GateKeepingHelpText__c;
            helpTextMap.putAll(populateHelpText(helpTextString));
        }
        return helpTextMap;
    }
    
    
    /****************************************************************************
    @Description : To get Help Text for Gate Keeping Models
    *****************************************************************************/
    public Map<String,String> getHelpTextCharterQuestions() 
    {
        Map<String,String> helpTextMap = new Map<String,String>();
        String helpTextString = projectMetadata.IPM_Charter_Question_HelpText__c;
        helpTextMap.putAll(populateHelpText(helpTextString));
        
        return helpTextMap;
    }
    
    /****************************************************************************
    @Description : To populate the Help Text info
    *****************************************************************************/
    public Map<String,String> populateHelpText(String helpTextString)
    {
        Map<String,String> helpTextMap = new Map<String,String>();
        if(helpTextString!=null && !String.isEmpty(helpTextString))
        {
            String[] subProjectWiseArray = helpTextString.split(IPM_ConstantUtils.COMMA);
            for(String subProject : subProjectWiseArray)
            {
                String[] tempArray = subProject.split('=');
                if(!tempArray.isEmpty() && tempArray.size() == 2)
                {
                    helpTextMap.put(tempArray[0],tempArray[1]);                     
                }   
            }
        }
        return helpTextMap;
    }
    
    /****************************************************************************
    @Description : To populate project information
    *****************************************************************************/
    public void populateProjectInformation()
    {
        projectMetadata = new IPM_ProjectMetadata__c();
        List<IPM_ProjectMetadata__c>  projectMetadataList = IPM_Utils.getProjectTypeMetadata(new List<IPM_Project__c>{project});
        if(!projectMetadataList.isEmpty())
        {
            projectMetadata = projectMetadataList.get(0);
        }
        getbrandPos();
    }
    
    /****************************************************************************
    @Description : searching duplicate project
    *****************************************************************************/
    public void populateProjectTypeInformation(IPM_ProjectMetadata__c projectMetadata)
    {
        if(projectMetadata == null || project.IPM_CompanyCardText__c == null || String.isBlank(project.IPM_CompanyCardText__c))
        {
            isBusinessError = true;
            businessErrorField = 'IPM_Company_Card__c'; 
        }
        else
        {
                if(!projectMetadata.IPM_GatekeepingModelsApplicable__c)
                {
                   project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.BLANK;
                }
                
                if(!projectMetadata.IPM_Charter_Question_Applicable__c)
                {
                   project.IPM_Approver_of_Charter__c = IPM_ConstantUtils.BLANK;    
                }
                
                project.IPM_Project_Type__c = project.IPMProject_Span__c =  project.IPM_Phase__c = project.IPM_Complexity__c = project.IPM_Child_Complexity__c = null;
                project.IPM_Project_Type__c = projectMetadata.IPM_Project_Type__c;
                project.IPM_SourceProjectType__c = projectMetadata.IPM_Project_Type__c;
                project.IPMProject_Span__c = projectMetadata.IPM_Project_Span__c;
                project.IPM_Phase__c = projectMetadata.IPM_DefaultPhase__c;
                project.IPM_Complexity__c =  projectMetadata.IPM_DefaultComplexity__c;
                project.IPM_Child_Complexity__c = projectMetadata.IPM_DefaultComplexity__c;
                if(IPM_ConstantUtils.IPMREGIONAL.Equals(project.IPMProject_Span__c)){
                	project.IPM_GateKeeping_Model__c=projectMetadata.IPM_Default_GateKeeping_Model__c;	
                }
        }
        
           
    }

    /****************************************************************************
    @Description : For Saving Project and Proceed to Next Step. 
    Performs necessary validations based on Mandatory fields present in Custom Settings.
    Performs additional Business Validations like checking for Special Characters, Target Launch Date span specific validations
    @Return: Page Reference
    *****************************************************************************/
    //NPath Complexity- Business Logic requires complex validations to be enforced before project is saved
    public void saveProceed()
    {
        isBusinessError = false;
        isContainSpecialChars  = false;
        isDupProjectname = false;
        isMaxBrandPosition=false;
        isTLDLessThnSixMnth = false;
        isTLDBeforeGates = false;
        isTLDLessThnToday=false;
        saveSuccess = false;
        businessErrorField = IPM_ConstantUtils.BLANK;

        if(!skipValidation)
        {
            if(!project.IPM_IsSaved__c && !isRollout.Equals(project.IPM_Project_Type__c))
            {
                
                populateProjectTypeInformation(projectMetadata);
            }
        
            Map<String, Schema.SObjectField> projectFieldDesc = IPM_Project__c.getSObjectType().getDescribe().fields.getMap();
            
            // Set Default Mandaytory Fields for now.If project Type is Present, it would override the default Mandatory Fields.
            List<String> mandatoryFields = DEFAULT_MANDATORY_FIELDS;
            
            // If not project Type is selected, Force user to select company Card.
            if(projectMetadata!=null && projectMetadata.IPM_Project_Type__c !=null && !String.isBlank(projectMetadata.IPM_MadatoryFields__c))
            {
                String mandatoryFieldString = projectMetadata.IPM_MadatoryFields__c;
                mandatoryFields = mandatoryFieldString.split(IPM_ConstantUtils.COMMA);    
            }
            
            for(String mandatoryFieldAPI : mandatoryFields)
            {
                Schema.DisplayType displayType = projectFieldDesc.get(mandatoryFieldAPI).getDescribe().getType();
                Object incomingValue = project.get(mandatoryFieldAPI);
                
                if(incomingValue ==null || ( displayType == Schema.DisplayType.Boolean && !Boolean.valueOf(incomingValue)) || ( displayType != Schema.DisplayType.Boolean && String.isBlank(String.valueOf(incomingValue).trim() )  ) )
                {
                    isBusinessError = true;
                    businessErrorField = businessErrorField+IPM_ConstantUtils.COMMA+mandatoryFieldAPI;      
                }
            }
            
            if( !isRollout.Equals(project.IPM_Project_Type__c) && !String.isBlank(project.IPM_Project_Name__c) && !Pattern.matches(IPM_ConstantUtils.IPM_PROJECTNAME_PATTERN ,project.IPM_Project_Name__c))
            {
                isContainSpecialChars=true;
                
            }
            //To display error when more than 20 BrandPosSelected
            if(!String.isBlank(project.IPM_Brand_Positioning__c) && projectMetadata.IPM_MultipleBrandPosApplicable__c){
                
                String[] maxBrandPosition = project.IPM_Brand_Positioning__c.split(IPM_ConstantUtils.COMMA);
                
                if(!maxBrandPosition.isEmpty() && maxBrandPosition .size()>20){    
                    isMaxBrandPosition=true;
                    businessErrorField = 'IPM_Brand_Positioning__c';    
                }
            }
            
            //To display error when project name is not unique across all company card.
            if(!String.isBlank(project.IPM_Project_Name__c) && !isRollout.Equals(project.IPM_Project_Type__c)){
                string bossId=IPM_ConstantUtils.BLANK;
                if(project.IPM_Bosscard__c!=null){
                    bossId=project.IPM_Bosscard__c;
                }
                isDupProjectname=IPM_WithoutShareController.duplicateProjectList(projectId,project.IPM_Project_Name__c,bossId);
            }
            if(projectMetadata.IPM_TargetLaunchDateDuration__c !=null && project.IPM_Target_Launch_Dates__c <= System.today()){
                isTLDLessThnToday= true;
            }     
            else if(projectMetadata.IPM_TargetLaunchDateDuration__c !=null && project.IPM_Target_Launch_Dates__c < System.today().addDays(Integer.valueOf(projectMetadata.IPM_TargetLaunchDateDuration__c)  ))
            {
                isTLDLessThnSixMnth = true;
            }
            if(project!=null && IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL.equals(project.IPM_Project_Type__c) && project.IPM_Target_Launch_Dates__c!=null) {
     			isTLDBeforeGates = isProjectTLDBeforeMilestoneGates(project.IPM_Target_Launch_Dates__c);
            }
        }
        
        if(!isBusinessError && !isContainSpecialChars && !(isTLDLessThnSixMnth && tldRestriction) && !isTLDBeforeGates && !isTLDLessThnToday && !isDupProjectname && !isMaxBrandPosition)
        
        {
            processProjectSave();
        
        }
    } 
    /****************************************************************************
    @Description : Used for populating neccessary attributes for the associated Project Type based on 'ProjectMetadata' Custom Setting.
    Attributes like Fast Track Applicable and White Space Applicable Features.
    Appends region specific prefix to Project.
    Initiates the background Transaction management Processing.
    @Return: null
    *****************************************************************************/
    //NPath Complexity-Business Logic requires complex validations to be enforced before project is saved.
    public void processProjectSave()
    {
        try
        {
           
            project.IPM_Project_Navigate__c = true;
            if(!isSavedDB && !skipValidation && projectMetadata!=null )
            {
                project.IPM_IsSaved__c = true;
            }
            if(!projectMetadata.IPM_FastTrackApplicable__c && !projectMetadata.IPM_WhiteSpaceApplicable__c )
            {
                project.IPM_White_Space_Project__c=false;
                project.IPM_Fast_Track_Project__c=false;
            }
            if(project.IPM_Project_Type__c != isRollout && APPENDREGIONMAP.containsKey(project.IPMProject_Span__c))
            {
                String shortNameSTR = regionShortName();
                if(!String.isBlank(shortNameSTR) && !project.IPM_Project_Name__c.contains(shortNameSTR))
                {
                    project.IPM_Project_Name__c = project.IPM_Project_Name__c + shortNameSTR;
                }
            }  
           if(project.IPM_Project_Gatekeeper__c==null && project.IPM_Company_Card__c!=null){
	            list<IPM_User_Profile__c>lstGatekeeper=[SELECT IPM_User__c FROM IPM_User_Profile__c WHERE IPM_Company_Card__c=:project.IPM_Company_Card__c AND
	            										IPM_User_Function__c=:IPM_ConstantUtils.TEAM_GATEKEEPER LIMIT 1];  
	            if(lstGatekeeper!=null && !lstGatekeeper.isEmpty()){
	            	project.IPM_Project_Gatekeeper__c=lstGatekeeper[0].IPM_User__c;	
	            } 
            }	
            
			if(String.isBlank(project.IPM_Approver_of_Charter__c ) )
			{
				project.IPM_Approver_of_Charter__c= projectMetadata.IPM_DefaultCharterQuestionAnswer__c;
			}                    
            update project;
            
            if(!skipValidation)
            {
                // Check if project is being processed for backGround Processing, if no allow user to navigate to the next screen.
                List<IPM_Project__c> projectList = [SELECT Id,Name,IPM_Project_Job_Status__c from IPM_Project__c where Id =:projectId];
                if(!projectList.isEmpty())
                {
                    getProjectInformation(projectId);
                    if(project.IPM_Project_Job_Status__c != IPM_ConstantUtils.JOB_STATUS_ELIGIBLE && project.IPM_Project_Job_Status__c != IPM_ConstantUtils.JOB_STATUS_PROCESSING)
                    { 
                        saveSuccess = true;
                    }
                    else
                    {
                        isEditable=false;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PROJECT_BACKGROUND_PROCESS));
                    }
                }
            }
            skipValidation = false;
        }
        catch(DMLEXception dmlEx)
        {
            project.IPM_Project_Navigate__c = false;
            project.IPM_IsSaved__c = isSavedDB; 
            saveSuccess = false;
            skipValidation = false;
            if(dmlEx.getDmlType(0) == StatusCode.DUPLICATE_VALUE)
            {
               isDupProjectname = true;
            }
            else
            { 
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                                                           'processProjectSave',dmlEx.getMessage(),dmlEx, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
            }
        }   
        catch(Exception ex)
        { 
            project.IPM_Project_Navigate__c = false;
            project.IPM_IsSaved__c = isSavedDB;
            saveSuccess = false;
            skipValidation = false;
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                                                       'processProjectSave',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
            
        }
    }
    /****************************************************************************
    @Description : Append project name with region shot name
    *****************************************************************************/
    public string regionShortName()
    {
        Map<String,IPM_Market_Cluster_Short_Names__c> shortnameMap = IPM_Market_Cluster_Short_Names__c.getAll();
        String shortNameSTR = IPM_ConstantUtils.BLANK;
        for(IPM_Market_Cluster_Short_Names__c shortN:shortnameMap.Values())
        {
            if(shortN.Unilever_Cluster__c== project.IPM_Region_Shr__c)
            {
                shortNameSTR='_'+shortN.Short_Name__c; 
            }
        }
        return shortNameSTR;
    }
    
    /****************************************************************************
    @Description : For getting charter approver
    @Return: List of character approvers
    *****************************************************************************/
    
    public List<SelectOption> getCharterApprovers()
    {
        Schema.sObjectType sobject_type = IPM_Project__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map=new Map<String, Schema.SObjectField>();
        field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(IPM_ConstantUtils.IPM_CHARTER_APPROVER).getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        
        // Set default Charter of Approver.RCLT was the default value for GKM & Charter approver, used Default Gatekeeping Field from custom setting.
        if(String.isBlank(project.IPM_Approver_of_Charter__c ) )
        { 
            project.IPM_Approver_of_Charter__c = DEFAULT_CHARTER_APPROVER;
        }
            
        return options;
    }
    
    public void getProjectResource()
    {
        if(String.isNotBlank(projectId)) 
        {
            lstProuser=[SELECT IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,
                        IPM_Project__r.IPM_Project_Leader__c FROM IPM_Project_Resource__c WHERE
                        IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() AND IPM_Role_Type__c != null limit 1];
        }
    }
    /****************************************************************************
    @Description : Get user type with access permission
    *****************************************************************************/
    public void getIpmuserType(){
        try 
        {
            list<IPM_Project__c>lstofuser=[SELECT IPM_Project_Leader__c,IPM_IsCompleted__c  FROM IPM_Project__c WHERE
                                           id=:projectId and (IPM_Project_Leader__c =:userinfo.getuserid() 
                                                              or Deputy_Project_Leader__c=:userinfo.getuserid() ) limit 1];
            if(lstofuser.isEmpty()){
                isEditable=false;  
            }   
            else{
                isEditable=true;
            }
            
            //security for central team and BP users
            IPM_CustomPermission cpr = new IPM_CustomPermission();
            boolean isCentralTeam=false;
            boolean isBPUser=false;
            isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
            isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
            if(isCentralTeam || isBPUser){
                isEditable=true;
            }   
        }Catch (Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                                                       'getIpmuserType',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
    } 
    /****************************************************************************
    @Description : Get Milestone and task access
    *****************************************************************************/
    //NPath Complexity-Baed on the business Logic security has to be enforced for various conditions before giving access to project setup screen
    public void getMilesTaskIpmuserType(){
        try
        {
            Id loggedInUser = userinfo.getuserid();
            
            // To query the Team Members on project Resource object
            list<IPM_Project_Resource__c> projectResourceList = [select Id,IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c,IPM_Project__r.Deputy_Project_Leader__c,IPM_Project__r.IPM_Technical_Project_Leader__c 
                                                                 from IPM_Project_Resource__c where 
                                                                 IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() and IPM_Project__r.Is_Archieved__c=false  limit 1];
            
            if(projectResourceList != null && !projectResourceList.isEmpty()){
                IPM_Project_Resource__c projectResource = projectResourceList[0];
                
                if( projectResource.IPM_Role_Type__c != IPM_Utils.Guest ){
                
                    isMilestoneEditable = false;
                    
                    if( projectResource.IPM_Role_Type__c == IPM_Utils.BD || projectResource.IPM_Role_Type__c == IPM_Utils.BDMarketing )
                    {
                        isBDuser=true;
                    }
                    if(projectResource.IPM_Project_Role_Owner__c)
                    {
                            isCreateTask=true;
                            isTaskeditable =true;
                    }
                }
                else {
                    isMilestoneEditable=false;
                    
                }
                if( projectResource.IPM_Role_Type__c != null && !String.isBlank(projectResource.IPM_Role_Type__c)){
                    functionRole = projectResource.IPM_Role_Type__c;
                }
                if(projectResource.IPM_Role_Type__c==IPM_Utils.CMI || projectResource.IPM_Role_Type__c==IPM_Utils.CD || projectResource.IPM_Role_Type__c==IPM_Utils.Finance || projectResource.IPM_Role_Type__c==IPM_Utils.Guest){
                    isupdateDates=false;
                }
            } 
            
            // Checking the user List
            if(!project.Is_Archieved__c){
                // To check the Project Leader
               if( loggedInUser != null && ( loggedInUser == project.IPM_Project_Leader__c || loggedInUser == project.Deputy_Project_Leader__c ))                            
                {
                    isMilestoneEditable=true;
                    
                }
               if(loggedInUser == project.IPM_Project_Leader__c || loggedInUser == project.Deputy_Project_Leader__c 
                        || loggedInUser == project.IPM_Technical_Project_Leader__c)
                    {
                        updateApproach =true;
                        isTaskeditable =true;
                        isCreateTask=true;
                        isAllTask=true;
                    }
            }
            //security for central team and BP users
                IPM_CustomPermission cpr = new IPM_CustomPermission();
                boolean isCentralTeam=false;
                boolean isBPUser=false;
                isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
                isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
                if(isCentralTeam || isBPUser){
                    isMilestoneEditable=true;
                    isTaskeditable=true;
                    updateApproach=true;
                    isCreateTask=true;
                    isAllTask=true;
                } 
            
        }catch(Exception eX){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                            'getMilesTaskIpmuserType',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }                                           
    }
    /****************************************************************************
    @Description : save complexity type
    *****************************************************************************/
    public void saveComplexityType(){
        
        if(string.isBlank(ComplexityType))
        {
            ComplexityType=IPM_ConstantUtils.COMPLEXITY_LITE;
        }
        project.IPM_Complexity__c=ComplexityType;
        project.IPM_Child_Complexity__c=ComplexityType;
        
        processProjectSave();
        
    }
    /********************************************************************************
    *@Description : remove project logo
    *********************************************************************************/
    public void removeProjectLogo(){
        
        project.IPM_Project_Logo__c=IPM_ConstantUtils.BLANK;
        project.IPM_Project_Logo_Id__c=IPM_ConstantUtils.BLANK;
        try{
            update project;
        }
        catch(Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                                                       'removeProjectLogo',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);    
        }   
    }
     
    /****************************************************************************
    @Description : For updating the project
    *****************************************************************************/
    public void none()
    {
        //used as a dummy action function for IPM_projectSetupView page NO SONAR
    } 
    /****************************************************************************
    @Description : save IPM Approach
    *****************************************************************************/
    public void saveIPMApproach(){
        
        if(project.IPM_PM_Approach__c == IPM_ConstantUtils.IPM_APPROACH_INTERNAL)
        {
            project.IPM_PM_Approach__c=IPM_ConstantUtils.IPM_APPROACH_EXTERNAL;
        }
        else
        {
            project.IPM_PM_Approach__c=IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
        }
        
        processProjectSave();
    } 
    /****************************************************************************
    @Description : save quit Project Tab Name
    *****************************************************************************/
    @Remoteaction
    global static string savetabname(String tabName,String projectID)
    {    
        IPM_Project__c projectToUpdate = new IPM_Project__c();
        projectToUpdate.id = projectID;
        projectToUpdate.IPM_Quit_Project_Tab__c = tabName;
        try
        {
            update projectToUpdate;
        }
        catch(Exception ex) 
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTCONTROLLER_STR,
                                                       'Savetabname',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        return projectID;
    }
   /****************************************************************************
    @Description : search duplicate project name
    *****************************************************************************/
    public void searchDuplicateProject(){
        listofProjectName=new Set<string>(); 
        listofProjectName=IPM_WithoutShareController.allProjectList(projectId,project.IPM_Project_Name__c); 
        if(listofProjectName.isEmpty()){
            isProjectNameBlank=true;
        }
        else{
            isProjectNameBlank=false;
        }
    }
    /********************************************************************************
    *@Description : To make Target Launch Date editable
    *********************************************************************************/
   	@TestVisible private void setIsTLDFieldEditable(){
        if(project!= null && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL  && project.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS){
            isTLDFieldEditable = false;
        } else if (project!= null && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS){
            list<IPM_Project_Rollout__c> childProject = [Select Id,Name from IPM_Project_Rollout__c where IPM_Project__c = :project.Id or Regional_Project__c = :project.Id limit 1];
            if(!childProject.isEmpty()){
                isTLDFieldEditable = false;
            }else {
                isTLDFieldEditable = true;
            }         
        }else if(project!= null && project.IPMProject_Span__c == IPM_ConstantUtils.IPMREGIONAL && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT && project.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS){
                isTLDFieldEditable = false;     
        }else if(project!= null && project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT){
            if(project.IPM_Phase__c == IPM_ConstantUtils.PHASE_PLE || project.IPM_Phase__c == IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT){
                isTLDFieldEditable = false; 
            } else if (project.IPM_Phase__c == IPM_ConstantUtils.PHASE_MARKET_READY){
                list<IPM_Project_Document__c> ipmProjDocuments = [Select Id,  IPM_Document_Status__c, IPM_Proposed_Date__c, IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c  = :project.Id and IPM_GateDocuments__c = :IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT];
                if(!ipmProjDocuments.isEmpty()){
                    IPM_Project_Document__c ipmProjDoc = ipmProjDocuments[0];
                    if(ipmProjDoc.IPM_Document_Status__c == IPM_ConstantUtils.STATUS_NOT_STARTED || ipmProjDoc.IPM_Document_Status__c == IPM_ConstantUtils.STATUS_IN_PROGRESS){
                        isTLDFieldEditable = true;
                    } else{
                        isTLDFieldEditable = false;
                    }
                }
            } else if(project.IPM_Phase__c == IPM_ConstantUtils.FEASIBILITY_PHASE || project.IPM_Phase__c == IPM_ConstantUtils.PHASE_CAPABILITY){
                List<IPM_Financial__c>  financeList = [SELECT Id, Is_BC_Confirmed_Capability__c,IPM_Business_Case_Confirmed__c FROM IPM_Financial__c WHERE Local_Project__c=:projectId];
                if(!financeList.isEmpty()){
                    IPM_Financial__c financeObj = financeList[0];
                    if(financeObj.IPM_Business_Case_Confirmed__c && project.IPM_Phase__c == IPM_ConstantUtils.FEASIBILITY_PHASE){
                        isTLDFieldEditable = false;
                    } 
                    else if(financeObj.Is_BC_Confirmed_Capability__c && project.IPM_Phase__c == IPM_ConstantUtils.PHASE_CAPABILITY) {
                        isTLDFieldEditable = false;
                    }
                    else{
                    	isTLDFieldEditable = true;
                    }               
                }
            } 
            else {
                isTLDFieldEditable = true;
            }
        }else if(project !=null){
            isTLDFieldEditable = true;
        } 
               
    }
    /********************************************************************************
    *@Description :hide project suggetion names
    *@Param: NA
    *@return:Void.
    *********************************************************************************/
    public void hideProjectSuggetion(){
        isProjectNameBlank=true;
    }
    /*******************************************************************************************************
    * @description  Method to get a date prior to any of mandatory project Milestones (except PLE and Target Launch Date).
    * @param        NONE
    * @return       Date
    */
    @Testvisible private Boolean isProjectTLDBeforeMilestoneGates( Date tld ){
        Boolean result = false;
        List<String> milestoneNames = new List<String>{IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE,IPM_ConstantUtils.CONTRACT_GATE_APPROVAL_MILESTONE,IPM_ConstantUtils.MARKET_READY_GATE_APPROVAL_MILESTONE};
        List<IPM_Milestone__c> milestones = [Select IPM_Due_Date__c from IPM_Milestone__c where IPM_Project__c =: project.Id and IPM_Active__c = true and IPM_Name__c in: milestoneNames limit 1000];
        for(IPM_Milestone__c milestone : milestones) {
        	if(milestone.IPM_Due_Date__c != null && tld<milestone.IPM_Due_Date__c) {
        		result = true;
        		break;
        	}
        }
        return result;
    }        
    
}