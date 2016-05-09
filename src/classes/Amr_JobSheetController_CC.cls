/**********************************************************************  
Name:  Amr_JobSheetController_CC ()  Copyright © 2015  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------    This class deals with various job releated funtionality like job accept, job sharing, job update etc.                                                         
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION   AUTHOR                        DATE              DETAIL                    Description    
 1.0       Mindtree                  16/12/2015      INITIAL DEVELOPMENT            CSR: 
 ***********************************************************************/
public with sharing class Amr_JobSheetController_CC{

    public String docUploaded{get;set;}
    public String projNameFromPage{get;set;}
    public String projectNameFromPage{get;set;}
    public String alertmessage{get;set;}
    public Date alertDate{get;set;}
    public String adManagerNumber{get;set;}
    public integer counterOfUpload = 0; 
    public String saveRecordValue{get;set;}
    public String saveRecordValueForQuote {get;set;}
    public String saveRecordValueForAccQuote{get;set;}
    public boolean display{get;set;}
    public String selectedAlert {get;set;}
    public string IdNeedToUpdate{get;set;}
    public  boolean DisplayLink{get;set;}
    public String quoteJobId{get;set;}
    public string savingId{get;set;}
    public String quoteId{get;set;}
    public List<SelectOption> shootLocation{get;set;}
    public List<String> selectedCountry1 {get;set;}
    public String IdDeleted{get;set;}
    public String strTabName{get;set;}
    public List<SelectOption> productionType{get;set;}
    public List<String> selectedProductionType{get;set;}
    public Amr_Job_Details__c jobDetailObj{get;set;}
    public boolean editedSavingMode{get;set;}
    public boolean viewSavingMode{get;set;}
    public boolean editedQuoteMode{get;set;}
    public boolean viewQuoteMode{get;set;}
    public boolean editedAcceptedQuote{get;set;}
    public boolean viewAcceptedQuote{get;set;}
    public Blob fileBody   {get;set;}
    public Integer QuoteNumber{get;set;}
    public Amr_Quote__c quoteObj{get;set;}
    public Integer totalAlertCount{get; set;}
    public String jobStatus{get;set;}
    public String selectedRapName{get;set;}
    public String selectedSecRapName{get;set;}
    public List<PermissionSetAssignment> userData {get;set;}
    public String profileName {get;set;}
    public String permissionSetName {get;set;}
    public Amr_Job_Details__c jobList{ get; set; }      
    Transient  String[]  categoryString;
    public String Name{get;set;}
    public String brandPosName{get;set;}
    public String selectedBrandPosName{get;set;}
    public String brandNameFromPage{get;set;} 
    public List<SelectOption> listOfCategory{get;set;} 
    public List<SelectOption> listOfBrandPosition{get;set;}
    public  List<SelectOption> listOfBrand{get;set;}
    public  List<SelectOption> listOfProjectName {get;set;}
    public String selectedCountry {get;set;}    
    public String categoryName {get;set;}
    public String selectedCategory{get;set;}
    public boolean isPrimaryUser {get;set;}
    public list<string> listOfRAPSelected{get;set;}  
    public Integer sharedListSize {get;set;}
    public boolean validateSuccess ;
    public boolean alertErrorCheck {get;set;}
    public boolean jobsheetErrorCheck {get;set;}
    public boolean jobIsAccepted {get;set;}
    public String createdByUserEmail {get;set;}
   
    public List<selectoption> selectUsername{get;set;} 
    public List<selectoption> selectJobPriority{get;set;}
    public String priority{get;set;}
    public String selectedRAPUser{get;set;} 
    public String addManagerNumber{get;set;}
    public List<Amr_Job_Allocation__c> listOfUserToDisplay {get;set;}
    public ID abc{get;set;}
    public Boolean primaryRap{get;set;}
    public Amr_Job_Allocation__c jobAlloc{get;set;}
    public Id jobId{get;set;}
    public static boolean rapAllocateCheck;
    public List <Amr_Job_Allocation__c > jobSharedList {get;set;}
    public List<SelectOption> sharedRapOption {get;set;}
    public Id selectedUnshareRapName {get;set;}
    transient list<Amr_Project_Details__c> projNameList; 
    transient String[]  listString;
    public boolean jobCancelled {get;set;}
    public String ownerIdOfSelectedJob;
    public Map<String,String>currencyMap;
    public String jobIdFromPage {get;set;}
    public String chosenDocId{get;set;}
    public List<Amr_Alert__c> alert {get;set;}
    public Id chosenId {get; set;} 
    public Amr_Alert__c alertObj{get;set;}
    public String NotesValue{get;set;}
    public Amr_JobSheetHelper_CC jobSheetHelper;
    public Boolean jobCancellCheck {get;set;}
   
    public List<FeedItem> documentList{get;set;}
     public List<Amr_Saving__c> quoteList{get;set;}
    public List<Amr_Quote__c> quoteRelatedToSavingList{get;set;}
 
    public string userId{get;set;}
    public list<Amr_Saving__c>savingJobsToShow {get;set;}
     public Integer totalSizeForSavingJobs =0;
    public Integer limitSizeForSavingJobs=5;
    public Integer counterForSavingJobs=0;
     public Integer totalSavingJobPages  {get; set;}
    public Integer currentPageNumber {get;set;}
   
    public Amr_JobSheetController_CC(){
    try{
         if(documentList == null){
         documentList = new List<FeedItem>();
         }
        jobIsAccepted   = false;
        jobCancellCheck = false;
         Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
          jobSheetHelper = new Amr_JobSheetHelper_CC();
         alertObj = new Amr_Alert__c();
         categoryString = new list<string>();
         Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
         
         listOfUserToDisplay = new List<Amr_Job_Allocation__c>();
         
            for(MDO_Category__c mdCat : categorylst){
            categoryString.add(mdCat.name);
            }
        
        validateSuccess = false;
        selectUsername= new list<selectoption>();
      
        jobIdFromPage = ApexPages.currentPage().getParameters().get(Amr_ConstantForAdManager.ID);
        
        alert = [select Id,Alert_Message__c,job_Id__r.AdManagerText__c,New_Alert__c,Job_Id__c from Amr_Alert__c where ownerId =:userInfo.getUserId() AND Hide__c =:false AND Job_Id__c  = :jobIdFromPage];          
        totalAlertCount =  [select count() from Amr_Alert__c where ownerId =:userInfo.getUserId() AND Hide__c =:false AND Job_Id__c  = :jobIdFromPage];
        getDocuments();
    }catch(Exception ex){
       
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
    } 
    try{
            jobId = ApexPages.CurrentPage().getParameters().get(Amr_ConstantForAdManager.ID); 
       }
    catch(Exception e){
           jobsheetErrorCheck = true;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Invalid_Job_Id));
           return;
    }
        
    if(String.isBlank(jobID)){
            jobsheetErrorCheck = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return;
     }
         
        String message = '' + ApexPages.CurrentPage().GetParameters().Get(label.Amr_message);
        if(message != 'null')
        {
            jobsheetErrorCheck = true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message)); 
        }
        helperMethod();
    } 
     

/***********************************************************************************************************************************
Purpose:  This method contains the logic to search job functionality and is called from 
        both CAP and RAP reallocate job method
Parameters: 
Returns: 

     N-Path:
     This method fetches required fields to display on JobSheet page so can not reduce the no. of fields in SOQL.
***********************************************************************************************************************************/     
    
     
     public PageReference helperMethod(){
     
       for(PermissionSetAssignment  userObj :[select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_RAP AND Assignee.id != :userInfo.getUserId() order by Assignee.name] ){
        
        try{
            SelectOption obj=new SelectOption(userObj.Assignee.id,userObj.Assignee.name);
            selectUsername.add(obj);
        }
        catch(Exception e){
            jobsheetErrorCheck = true;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Invalid_User));
           return null;
       }
        }  
        userData = [select PermissionSet.Name from PermissionSetAssignment  where Assignee.id = :userinfo.getUserId()];
        
        Set<String> userNameSet = new Set<String>();
        for(PermissionSetAssignment permission : userData){
            userNameSet.add(permission.PermissionSet.Name);
        }
        if(userNameSet.contains(Label.Amr_CAP)){
        
            permissionSetName = Label.Amr_CAP;
            strTabName        = label.Amr_CAP_Jobs_Portfolio_tab;
        }else{
         
            permissionSetName = Label.Amr_RAP;
        }
   
    
      
      try{
            if(permissionSetName == Label.Amr_CAP){

                jobAlloc = [Select id,User__r.Name, Job_Allocated__c,Reported__c,Started__c,Job_Status__c,Is_Primary__c  from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId limit 1];
                        listOfUserToDisplay = [Select User__r.Name, User__r.Email,Job_Status__c,Id from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId];
                           
                                        
            }
            else{
                jobAlloc = [Select id,User__r.Name, User__r.Email, Job_Allocated__c,Reported__c,Started__c,Job_Status__c,Is_Primary__c  from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId  AND user__c =: userInfo.getUserId() Limit 1 ];
                        listOfUserToDisplay.add(jobAlloc);
                      
            }
          
            jobList=[select createdById, AdditionalSupplementaryNewMaterialDigiA__c,ReworkExistingMaterial__c,Buyouts_Music_Digital_ED__c,NewOriginalMaster__c,NewOriginalMasterTv__c,NewOriginalMasterCinema__c,NewOriginalMasterRadio__c,NewOriginalMasterPrint__c,NewOriginalMasterOutofHome__c,NewOriginalMasterInStore__c,NewOriginalMasterDigital__c,
                    NewOriginalMasterInternalVideo__c,NewOriginalMasterTvMovingImage__c,NewOriginalMasterCinemaMovingImage__c,NewOriginalMasterRadioAudio__c,NewOriginalMasterPrintStillImage__c,NewOriginalMasterOutofHomeMovingImage__c,
                    NewOriginalMasterOutofHomeAudio__c,NewOriginalMasterOutofHomeStillImage__c,NewOriginalMasterInStoreMovingImage__c,NewOriginalMasterInStoreAudio__c,NewOriginalMasterInStoreStillImage__c,NewOriginalMasterDigitalMovingImage__c,
                    NewOriginalMasterDigitalAudio__c,NewOriginalMasterDigitalStillImage__c,NewOriginalMasterInternalVdoMovingImage__c,  New_Original_Master_Digital_ED__c,
                    LanguageAdaptionMaster__c,LanguageAdaptionMasterTv__c,LanguageAdaptionMasterCinema__c,LanguageAdaptionMasterRadio__c,LanguageAdaptionMasterPrint__c,LanguageAdaptionMasterOutofHome__c,LanguageAdaptionMasterInStore__c,
                    LanguageAdaptionMasterDigital__c,LanguageAdaptionMasterInternalVideo__c,LanguageAdaptionMasterTvMovingImage__c,LanguageAdaptionMasterRadioAudio__c,LanguageAdaptionMasterPrintStillImage__c,
                    LanguageAdaptionMasterOutHomeMovingImage__c,LanguageAdaptionMasterOutofHomeAudio__c,LanguageAdaptionMasterOutHomeStillImage__c,LanguageAdaptionMasterInStoreMovingImage__c,
                    LanguageAdaptionMasterInStoreAudio__c,LanguageAdaptionMasterInStoreStillImage__c    ,LanguageAdaptionMasterDigitalMovingImage__c,LanguageAdaptionMasterDigitalAudio__c,
                    LanguageAdaptionMasterDigitalStillImage__c,LanguageAdaptionMasterInternalVdoMvngImg__c,Language_Adaptation_of_Master_Digital_ED__c,
                    AdditionalSupplementaryNewMaterialTv__c,AdditionalSupplementaryNewMaterialCinema__c,AdditionalSupplementaryNewMaterialRadio__c,AdditionalSupplementaryNewMaterialPrint__c,
                    AdditionalSupplementaryNewMaterialOOH__c,AdditionalSupplementaryNewMaterialStore__c,AdditionalSupplementaryNewMaterialDigi__c,AdditionalSupplementaryNewMaterialIVideo__c,
                    AdditionalSupplementaryNewMaterialTvMI__c,AdditionalSupplementaryNewMaterialCinMI__c,AdditionalSupplementaryNewMaterialRA__c,AdditionalSupplementaryNewMaterialPSI__c,
                    AdditionalSupplementaryNewMaterialOofHMI__c,AdditionalSupplementaryNewMaterialOofHA__c,AdditionalSupplementaryNewMaterialOofHSI__c,AdditionalSupplementaryNewMaterialInSMI__c,
                    AdditionalSupplementaryNewMaterialInSA__c,AdditionalSupplementaryNewMaterialInSSI__c,AdditionalSupplementaryNewMaterialDigiMI__c,AdditionalSupplementaryNewMaterialDigiSI__c,
                    ReworkExistingMaterialTv__c,ReworkExistingMaterialCinema__c,ReworkExistingMaterialRadio__c,ReworkExistingMaterialPrint__c,ReworkExistingMaterialOutofHome__c,
                    ReworkExistingMaterialInStore__c,ReworkExistingMaterialDigital__c,ReworkExistingMaterialInternalVideo__c,ReworkExistingMaterialTvMovingImage__c,
                    ReworkExistingMaterialCinemaMovingImage__c,ReworkExistingMaterialRadioAudio__c,ReworkExistingMaterialPrintStillImage__c,ReworkExistingMaterialOutHomeMovingImage__c,
                    ReworkExistingMaterialOutofHomeAudio__c,ReworkExistingMaterialOutHomeStillImage__c,ReworkExistingMaterialInStoreMovingImage__c,ReworkExistingMaterialInStoreAudio__c,
                    ReworkExistingMaterialDigitalMovingImage__c,ReworkExistingMaterialDigitalAudio__c,ReworkExistingMaterialDigitalStillImage__c,Rework_Exisiting_Material_Digital_ED__c,ReworkExistingMaterialInternalVdoMovImg__c,
                    BuyoutsTalentTv__c,BuyoutsTalentCinema__c,BuyoutsTalentRadio__c,BuyoutsTalentPrint__c,BuyoutsTalentOutofHome__c,BuyoutsTalentInStore__c,BuyoutsTalentDigital__c,BuyoutsTalentInternalVideo__c,
                    BuyoutsTalentTvMovingImage__c,BuyoutsTalentCinemaMovingImage__c,BuyoutsTalentRadioAudio__c,BuyoutsTalentOutofHomeMovingImage__c,BuyoutsTalentOutofHomeAudio__c,
                    BuyoutsTalentOutofHomeStillImage__c,BuyoutsTalentInStoreMovingImage__c,BuyoutsTalentInStoreAudio__c,BuyoutsTalentInStoreStillImage__c,BuyoutsTalentDigitalMovingImage__c,
                    BuyoutsTalentDigitalAudio__c,BuyoutsTalentDigitalStillImage__c,Buyouts_Talent_Digital_ED__c,BuyoutsTalentInternalVideoMovingImage__c,
                    BuyoutsMusicTv__c,BuyoutsMusicCinema__c,BuyoutsMusicRadio__c,BuyoutsMusicPrint__c,BuyoutsMusicOutofHome__c,BuyoutsMusicInStore__c,BuyoutsMusicDigital__c,BuyoutsMusicInternalVideo__c,
                    BuyoutsMusicTvMovingImage__c,BuyoutsMusicCinemaMovingImage__c,BuyoutsMusicRadioAudio__c,BuyoutsMusicPrintStillImage__c,BuyoutsMusicOutofHomeMovingImage__c,BuyoutsMusicOutofHomeAudio__c,
                    BuyoutsMusicOutofHomeStillImage__c,BuyoutsMusicInStoreMovingImage__c,BuyoutsMusicInStoreAudio__c,BuyoutsMusicInStoreStillImage__c   ,BuyoutsMusicDigitalMovingImage__c,
                    BuyoutsMusicDigitalAudio__c,BuyoutsMusicDigitalStillImage__c,Additional_Supplementary_NM_Digital_ED__c,BuyoutsMusicInternalVideoMovingImage__c,                 
                    createdDate,Project_Details__r.name,id,Job_Notes__c,Currency_Conversion_Country_List__c,Lead_Agency_Name_Other__c,OwnerId,Job_Cancelled__c,Job_Status__c,Tv_Moving_Image__c,AdManagerText__c,Brand_Final__c,Brand_Final__r.name, Cinema_Moving_Image__c, Radio_Audio__c, Print_Still_Image__c, Out_Of_Home_Moving_Image__c, Out_Of_Home_Still_Image__c, Out_Of_Home_Audio__c, In_Store_Moving_Image__c, In_Store_Still_Image__c, In_Store_Audio__c, Digital_Moving_Image__c, Digital_Still_Image__c, Digital_Audio__c, Internal_Video_Moving_Image__c, Tv__c,Cinema__c, Radio__c, Print__c, Out_Of_Home__c, In_Store__c, Digital__c, Internal_Video__c, ProductCategory__c,ProductCategory__r.name,Rework_Exisiting_Material__c,BuyoutsTalent__c,BuyoutsMusic__c,New_Original_Master__c,Create_Additional_Material__c,Language_Adaptation_Of_Master__c,Require_Music__c,Require_Celebrity_Talent__c,Stage_of_Production_Activity__c,Check_With_CMI__c,Production_Activity_Type__c,Project_Description__c,Target_Air_Date__c,Execution_Name__c,Campaign_Name__c,Your_Email_Address__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Unilever_Finance_Member_Email__c,Final_Approver_Of_Material_Email__c,Function_You_Are_Part__c,Budget_Responsibility__c,Budget_Allocated_Input_Value__c,Allocated_Budget_euro__c,Brand_Position__c,Brand_Position__r.name,Lead_Creative_Agency_name__c,Lead_Agency_Location_Cluster__c,Lead_Agency_Location_Country__c,Agency_Contact_Account_Director_Email__c,Digital_Agency_Name__c,Any_other_agencies_involved__c,Project_Name__c,Project_Name_Other__c,Project_Location_Cluster__c,Project_Location_Country__c,Project_Details__c,Brodcast_Market__c from Amr_Job_Details__c where id=: jobId];       
            
           if(jobList.Job_Cancelled__c){
                jobsheetErrorCheck = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobAlreadyCancelled));
                jobCancellCheck = true;
                return null;    
           }
           
            if(jobList != null){

                projectNameFromPage = jobList.Project_Details__r.name;
                selectedCategory = jobList.ProductCategory__r.name;
                selectedBrandPosName = jobList.Brand_Position__r.name;
                
                listOfBrandPosition = new List<SelectOption>();
                listOfBrandPosition.add(new selectOption(jobList.Brand_Position__r.name,jobList.Brand_Position__r.name));
                
                listOfBrand= new List<SelectOption>();
                listOfBrand.add(new selectOption(jobList.Brand_Final__r.name,jobList.Brand_Final__r.name));
                
            }
            
        }
        catch(Exception e){
            jobsheetErrorCheck = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_No_Job_Allocation_Record_For_LoggedIn_User));
            return null;
        }  
        
        if(jobAlloc.is_Primary__c){
            jobSharedList = [ select id, User__c, User__r.Name from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND Is_Primary__c = False order by User__r.Name];
            sharedOption(jobSharedList);
            isPrimaryUser = TRUE;
        }
        else{
            isPrimaryUser = false;
        }
      
            selectJobPriority = new List<SelectOption>();
            selectJobPriority.add(new SelectOption(Amr_ConstantForAdManager.PENDING,Amr_ConstantForAdManager.PENDING));
            selectJobPriority.add(new SelectOption(Amr_ConstantForAdManager.PRIORITY,Amr_ConstantForAdManager.PRIORITY));
            selectJobPriority.add(new SelectOption(Amr_ConstantForAdManager.LIVE,Amr_ConstantForAdManager.LIVE));
            selectJobPriority.add(new SelectOption(Amr_ConstantForAdManager.DORMANT,Amr_ConstantForAdManager.DORMANT)); 
     
        
        projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
        listString= new list<string>();
         
        listString.add(Amr_ConstantForAdManager.NONE);
        For(Amr_Project_Details__c i : projNameList){
            listString.add(i.name); 
        }
        
              
        selectedRAPUser =  jobAlloc.User__c; 
        categoryName = jobList.ProductCategory__r.name;
        brandPosName = jobList.Brand_Position__r.name;
        brandNameFromPage = jobList.Brand_Final__r.name;
        selectedCountry = jobList.Currency_Conversion_Country_List__c;
        
       List<Amr_CurrencyConversionRate__c>currencyList=[SELECT Currency_Unit__c,Name,Currency_Unit_To_Euro__c FROM Amr_CurrencyConversionRate__c limit 50000];
       currencyMap=new Map<String,String>();
       
       for(Amr_CurrencyConversionRate__c curr:currencyList){
       if(selectedCountry == curr.Name+Amr_ConstantForAdManager.DASH+curr.Currency_Unit__c){
           currencyMap.put(Amr_ConstantForAdManager.SELECTEDCOUNTRY,String.valueOf(curr.Currency_Unit_To_Euro__c));
           }
       }
           
        jobStatus = jobAlloc.Job_Status__c;    
        primaryRap=  jobAlloc.Is_Primary__c;    
        addManagerNumber = jobList.AdManagerText__c;
        jobCancelled = jobList.Job_Cancelled__c;
        ownerIdOfSelectedJob = jobList.OwnerId;
       selectedSecRapName = jobAlloc.User__r.Name;
       selectedRapName = jobAlloc.User__r.Name;
       try{
       alertErrorCheck = false;
        editedSavingMode = false;
        viewSavingMode = true;
        editedQuoteMode = false;
        viewQuoteMode = true;
        editedAcceptedQuote = false;
        viewAcceptedQuote = true;
        jobId = ApexPages.currentPage().getParameters().get(Amr_ConstantForAdManager.ID);
        quoteObj = new Amr_Quote__c();
        selectedCountry1 = new List<String> {'Test'};
        List<Amr_Country_Cluster__c> countrylst=  Amr_Country_Cluster__c.getall().values();
        shootLocation = new List<SelectOption>();
        for(Amr_Country_Cluster__c countryObj:countrylst){
             shootLocation.add(new SelectOption(countryObj.Country__c,countryObj.Country__c));
            }                       
             userId = userinfo.getuserid();
            updateData();
        }catch(Exception ex){
          
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
       return null;  
         
     }
      /* 
        This method contains the logic to update the created job
    */       
    public void updateData(){
        try{
            alertErrorCheck = false; 
            List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name ='CAP' order by Assignee.name];
            boolean flag = false;
            for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
                 if(userId == permissionObj.Assignee.id){
                   
                    flag = true;
                    
                    break;
                 }
             }
             if(jobId!=null){
            jobDetailObj = [select id,AdManagerText__c,NewOriginalMasterTv__c,NewOriginalMasterCinema__c,NewOriginalMasterRadio__c,NewOriginalMasterPrint__c,
                                                     NewOriginalMasterOutofHome__c,NewOriginalMasterInStore__c,NewOriginalMasterDigital__c,
                                                     NewOriginalMasterInternalVideo__c,LanguageAdaptionMasterTv__c,LanguageAdaptionMasterCinema__c,LanguageAdaptionMasterRadio__c,
                                                     LanguageAdaptionMasterPrint__c,LanguageAdaptionMasterOutofHome__c,LanguageAdaptionMasterInStore__c,LanguageAdaptionMasterDigital__c,
                                                     LanguageAdaptionMasterInternalVideo__c,AdditionalSupplementaryNewMaterialTv__c,AdditionalSupplementaryNewMaterialCinema__c,
                                                     AdditionalSupplementaryNewMaterialRadio__c,AdditionalSupplementaryNewMaterialPrint__c,AdditionalSupplementaryNewMaterialOOH__c,
                                                     AdditionalSupplementaryNewMaterialStore__c,AdditionalSupplementaryNewMaterialDigi__c,AdditionalSupplementaryNewMaterialIVideo__c,
                                                     ReworkExistingMaterialTv__c,ReworkExistingMaterialCinema__c,ReworkExistingMaterialRadio__c,ReworkExistingMaterialPrint__c,
                                                     ReworkExistingMaterialOutofHome__c,ReworkExistingMaterialInStore__c,ReworkExistingMaterialDigital__c,ReworkExistingMaterialInternalVideo__c,
                                                     BuyoutsTalentTv__c,BuyoutsTalentCinema__c,BuyoutsTalentInStore__c,BuyoutsTalentRadio__c,BuyoutsTalentPrint__c,BuyoutsTalentOutofHome__c,
                                                     BuyoutsTalentDigital__c,BuyoutsTalentInternalVideo__c,BuyoutsMusicTv__c,BuyoutsMusicCinema__c,BuyoutsMusicRadio__c,BuyoutsMusicPrint__c,
                                                     BuyoutsMusicOutofHome__c,BuyoutsMusicInStore__c,BuyoutsMusicDigital__c,BuyoutsMusicInternalVideo__c 
                                                      
                                                     from Amr_Job_Details__c where id = :jobId];
                    }
            
            if(jobId != null){
                 if(flag){
                      quoteList = [select id,PC_Appraisal_Time_Management__c,PC_Appraisal_Output_Quality__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Cost_Management__c,Duration_of_Additional_Films__c,PPC_Appraisal_Time_Management__c,PPC_Appraisal_Output_Quality__c,PPC_Appraisal_Process_Management__c ,PPC_Appraisal_Cost_Management__c,CA_Appraisal_Time_Management__c,CA_Appraisal_Output_Quality__c ,CA_Appraisal_Process_Management__c ,CA_Appraisal_Cost_Management__c,Folder_Name__c,Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,LastModifiedById, 
                               No_of_Masters__c,No_of_Masters_List__c,Total_no_of_films__c,No_of_Additional_Films_List__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Production_Type__c,Job_Details__r.AdManagerText__c,CreatedById,Number_Of_Quotes__c, Duration_of_Masters__c,
                               Average_Total_Opening_Quotes__c,Saving_Average_of_Quotes__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c,(select Accepted_Final_Cost_Total_editing_cost__c,Total_Cost__c,Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c,Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,Local_Amount_of_PPC__c,Local_Currency_of_PPC_Costs__c,PPC_Costs_Euro_Amount__c,CA_Location__c,CA_Additional_agency_Name__c,Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,CA_Costs_Euro_Amount__c

                               ,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PPC_only_Local_Am__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_Editors_name__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_props_wardrobe__c,Saving_Type__c,PC_Costs_Euro_Amount__c from Quotes__r ORDER BY Quote_Number__c) from Amr_Saving__c where Display__c = true and Job_Details__r.id = :jobId];
                     
                 }else{
                   quoteList = [select id,PC_Appraisal_Time_Management__c,PC_Appraisal_Output_Quality__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Cost_Management__c,PPC_Appraisal_Time_Management__c,PPC_Appraisal_Output_Quality__c,Duration_of_Additional_Films__c,PPC_Appraisal_Process_Management__c ,PPC_Appraisal_Cost_Management__c,CA_Appraisal_Time_Management__c,CA_Appraisal_Output_Quality__c ,CA_Appraisal_Process_Management__c ,CA_Appraisal_Cost_Management__c,Folder_Name__c,Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,LastModifiedById, 
                               No_of_Masters__c,No_of_Masters_List__c,Total_no_of_films__c,No_of_Additional_Films_List__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Production_Type__c,Job_Details__r.AdManagerText__c,CreatedById,Number_Of_Quotes__c,Duration_of_Masters__c,
                               Average_Total_Opening_Quotes__c,Saving_Average_of_Quotes__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c,(select Accepted_Final_Cost_Total_editing_cost__c,Total_Cost__c,Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c,Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,Local_Amount_of_PPC__c,Local_Currency_of_PPC_Costs__c,PPC_Costs_Euro_Amount__c,CA_Location__c,CA_Additional_agency_Name__c,Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,CA_Costs_Euro_Amount__c

                               ,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PPC_only_Local_Am__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_Editors_name__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_props_wardrobe__c,Saving_Type__c,PC_Costs_Euro_Amount__c from Quotes__r ORDER BY Quote_Number__c) from Amr_Saving__c where Display__c = true and Job_Details__r.id = :jobId AND (CreatedById = :userId OR LastModifiedById = :userId )];
                      
                 }      
                 paginationMethodForSaving(quoteList);      
                 
                  Set<Id>savingIds=new Set<Id>();
                      for(Amr_Saving__c saving:quoteList){
                        savingIds.add(saving.Id);
                      }
                      quoteRelatedToSavingList = [select Saving_Type__c,Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c,Accepted_Final_Cost_props_wardrobe__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_editing_cost__c,Accepted_Final_Cost_Editors_name__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_PPC_only_Local_Am__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Saving__c,Quote_Number__c,Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                           Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PPC_Costs_Euro_Amount__c,
                                           Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                           Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,CA_Costs_Euro_Amount__c,
                                           CA_Additional_agency_Name__c,CA_Location__c,Is_Accepted__c,
                                           Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,PC_Costs_Euro_Amount__c,
                                           Total_Cost__c,id,Folder__c from Amr_Quote__c where Saving__c IN :savingIds ORDER BY Quote_Number__c];             //
               
              
                if(quoteList.size()>0){
                        adManagerNumber = quoteList[0].Job_Details__r.AdManagerText__c;
                }else{
                   Amr_Job_Details__c jobObj = [select AdManagerText__c from Amr_Job_Details__c where id = :jobId];
                   adManagerNumber = jobObj.AdManagerText__c;
                }
            }
      
        }catch(exception ex){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
    }  
    
      //pagination for savings starts here
   public void paginationMethodForSaving(List<Amr_Saving__c> savingListToDisplay){
    try{
       savingJobsToShow = new list<Amr_Saving__c>();
       totalSizeForSavingJobs = savingListToDisplay.size();
      
       
        //Intial adding
        //check the total records are more than limitSizeForPriorityJobs and assign the records
        if((counterForSavingJobs+limitSizeForSavingJobs) <= totalSizeForSavingJobs ){
            for(Integer i=0;i<limitSizeForSavingJobs;i++){
                savingJobsToShow.add(savingListToDisplay.get(i));
            }
        }else{
            for(Integer i=0;i<totalSizeForSavingJobs ;i++){
                savingJobsToShow.add(savingListToDisplay.get(i));
            }
        }
        system.debug('savingJobsToShow!!'+savingJobsToShow);
        
        totalSavingJobPages = (totalSizeForSavingJobs /limitSizeForSavingJobs)+1;
        currentPageNumber  = (counterForSavingJobs/limitSizeForSavingJobs)+1;
                     
        //getTotalActiveJobPages(totalSizeForActiveJobs/limitSizeForActiveJobs);
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
      }
      
      
        public void beginningForSavingJobs(){
        try{
        savingJobsToShow.clear();
        counterForSavingJobs=0;
        if((counterForSavingJobs+ limitSizeForSavingJobs) <= totalSizeForSavingJobs){
            for(Integer i=0;i<limitSizeForSavingJobs;i++){
                savingJobsToShow.add(quoteList.get(i));
            }   
        }else{
            for(Integer i=0;i<totalSizeForSavingJobs ;i++){
                savingJobsToShow.add(quoteList.get(i));
            }       
        }
        
        totalSavingJobPages = (totalSizeForSavingJobs/limitSizeForSavingJobs)+1;
        currentPageNumber = (counterForSavingJobs/limitSizeForSavingJobs)+1;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }
   
    public void nextForSavingJobs(){
        try{
        savingJobsToShow.clear();
        counterForSavingJobs=counterForSavingJobs+limitSizeForSavingJobs;
               
        if((counterForSavingJobs+limitSizeForSavingJobs) <= totalSizeForSavingJobs ){
            for(Integer i=counterForSavingJobs;i<(counterForSavingJobs+limitSizeForSavingJobs);i++){
                savingJobsToShow.add(quoteList.get(i));
            }
        } else{
            for(Integer i=counterForSavingJobs;i<totalSizeForSavingJobs ;i++){
                savingJobsToShow.add(quoteList.get(i));
            }
        }
        
        totalSavingJobPages = (totalSizeForSavingJobs /limitSizeForSavingJobs)+1;
        currentPageNumber = (counterForSavingJobs/limitSizeForSavingJobs)+1;
        
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        } 
    }
   
    public void previousForSavingJobs(){
        try{
        savingJobsToShow.clear();
        counterForSavingJobs=counterForSavingJobs-limitSizeForSavingJobs;       
            for(Integer i=counterForSavingJobs;i<(counterForSavingJobs+limitSizeForSavingJobs); i++){
            savingJobsToShow.add(quoteList.get(i));
        }
        
        totalSavingJobPages = (totalSizeForSavingJobs /limitSizeForSavingJobs)+1;
        currentPageNumber = (counterForSavingJobs/limitSizeForSavingJobs)+1;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }

    public void lastForSavingJobs (){
        try{
        SavingJobsToShow.clear();
        if(math.mod(totalSizeForSavingJobs , limitSizeForSavingJobs) == 0){
            counterForSavingJobs = limitSizeForSavingJobs* ((totalSizeForSavingJobs/limitSizeForSavingJobs)-1);
        } else if (math.mod(totalSizeForSavingJobs, limitSizeForSavingJobs) != 0){
            counterForSavingJobs = limitSizeForSavingJobs* ((totalSizeForSavingJobs/limitSizeForSavingJobs));
        }
        for(Integer i=counterForSavingJobs-1;i<totalSizeForSavingJobs-1;i++){
                savingJobsToShow.add(quoteList.get(i));
        }
        
        totalSavingJobPages = (totalSizeForSavingJobs/limitSizeForSavingJobs)+1;
        currentPageNumber = (counterForSavingJobs/limitSizeForSavingJobs)+1;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
      }
   
    public Boolean getDisableNextForSavingJobs(){
        if((counterForSavingJobs + limitSizeForSavingJobs) >= totalSizeForSavingJobs )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePreviousForSavingJobs(){
        if(counterForSavingJobs  == 0)
            return true ;
        else
            return false ;
    } 
    // ************************************************************  
    
    public  Document document {
        get {
          if (document == null)
             document = new Document();
             return document;
        }
        set;
   }
 
    public String lstcov {
      get{
            lstcov = JSON.serialize(Amr_CurrencyConversionRate__c.getAll().values());
            return lstcov;
        }set;
    }  
    
   
  /***********************************************************************************************************************************
Purpose:Method to pass currency records
Parameters: 
Returns: List of select option

************************************************************************************************************************************/  
  
  public List<selectOption> currencyRecords {
        get {
            List<selectOption> options = new List<selectOption>();
            List<selectOption> optionsNew = new List<selectOption>();
            
             if(currencyMap!=null){
                options.add(new SelectOption(currencyMap.get(Amr_ConstantForAdManager.SELECTEDCOUNTRY),selectedCountry));
            }else{
                options.add(new SelectOption(Amr_ConstantForAdManager.NONE ,Amr_ConstantForAdManager.NONE ));
            }
            List<Amr_CurrencyConversionRate__c> lstcov = Amr_CurrencyConversionRate__c.getAll().values();
           
            lstcov.sort();
            
            Map<String,String> mapAmountToCurrency = new Map<String,String>();
        
            for (Amr_CurrencyConversionRate__c cc: lstcov){
                if( (cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c == Amr_ConstantForAdManager.USAUS) ||  (cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c == Amr_ConstantForAdManager.UK ) || (cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c == Amr_ConstantForAdManager.EECEuro )){
                    mapAmountToCurrency.put(cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c , String.valueOf(cc.Currency_Unit_To_Euro__c));
                    options.add(new SelectOption(String.valueOf(cc.Currency_Unit_To_Euro__c),cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c));
                    continue;
                }   
                else{
                    optionsNew.add(new SelectOption(String.valueOf(cc.Currency_Unit_To_Euro__c),cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c));
                }
                
            }
             options.addAll(optionsNew);
            
            return options;

        }
        set;
    }
  /***********************************************************************************************************************************
Purpose:Method to pass project names
Parameters: 
Returns: JSON String

************************************************************************************************************************************/       
         public String getMethodToPassProjectNames(){
            try{
         projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
         String ProjectName = null;
         if(jobId !=null){
          ProjectName = [select Project_Details__r.name from Amr_Job_Details__c where id=: jobId].Project_Details__r.name;
          
         }
         listString= new list<string>();
         if(ProjectName !=null){
          listString.add(ProjectName);
         }
         listString.add(Amr_ConstantForAdManager.NONE);
        For(Amr_Project_Details__c i : projNameList){
            if(ProjectName != i.name){
                listString.add(i.name);
            }
        }
       
        return JSON.serialize(listString);
            }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            return null;
            }
    }
 /***********************************************************************************************************************************
Purpose: Method to get shared users options
Parameters: 
Returns: 

************************************************************************************************************************************/   
  
    public void sharedOption(List<Amr_Job_Allocation__c> jobSharedList ){
           try{
            sharedRapOption = new List<SelectOption>();     
            sharedListSize = jobSharedList.size();
            if(!jobSharedList.IsEmpty()){
                for(Amr_Job_Allocation__c sharedData : jobSharedList ){
                    SelectOption obj=new SelectOption(sharedData.User__c,sharedData.User__r.Name);
                    sharedRapOption.add(obj);
                }
           }
           }catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
           }
        }
        
    public pageReference getPage(){
        try{
        userData = [select PermissionSet.Name from PermissionSetAssignment  where Assignee.id = :userinfo.getUserId()];
        Set<String> userNameSet = new Set<String>();
        for(PermissionSetAssignment permission : userData){
            userNameSet.add(permission.PermissionSet.Name);
        }
        if(userNameSet.contains(Label.Amr_CAP)){
        
            permissionSetName = Label.Amr_CAP;
            PageReference pageRef = new PageReference(label.Amr_CApJobPortFolio);
             pageRef.setRedirect(true);
             return pageRef;
        }else{
        
            permissionSetName = Label.Amr_RAP;
             PageReference pageRef = new PageReference(label.Amr_RAPJobPortFolio);
             pageRef.setRedirect(true);
             return pageRef;
        }
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            return null;
        }
      
        
    }
 
 /***********************************************************************************************************************************
Purpose: CAP job reallocate method, reallocates job to the selected RAP
Parameters: 
Returns: PageReference

************************************************************************************************************************************/        
     public PageReference reAllocate() {
         alertErrorCheck = false; 
        try{
             if(String.isBlank(jobID)){
                 jobsheetErrorCheck = true;
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
                 return null;
             }
          
             else{
                 if(jobList.Job_Cancelled__c){
                     jobsheetErrorCheck = true;
                     ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,label.Amr_This_job_has_already_been_cancelled));
            
                     return null; 
                 }
                  jobReAllocate(selectedRAPUser,jobId, jobList);
                  if(rapAllocateCheck && !jobList.Job_Cancelled__c){
                      jobsheetErrorCheck = true;
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.Amr_Error_JobAlreadyAllocated));
                      return null;    
                 }
                 else{
                     jobsheetErrorCheck = true;
                     ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_JobAllocated));
                    return null;
                }
            } 
        }catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            return null;
        }
    }
   
/***********************************************************************************************************************************
Purpose:  This method contains the logic to reallocate job functionality and is called from 
        both CAP and RAP reallocate job method
Parameters: Selected RAP name (String), JobID (Id), Job Detail Object (object)
Returns: 

************************************************************************************************************************************/     
    public static void jobReAllocate(String selectedRap, Id jobId, Amr_Job_Details__c jobDet){
        try{
        List<Amr_Job_Allocation__c> jobAllocList = [select Id,Name,User__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND Is_Primary__c = TRUE ]; 
               for(Amr_Job_Allocation__c jAlloc : jobAllocList ){
            if(jobDet.ownerId == selectedRap){
                rapAllocateCheck = TRUE;        
            }
              else{
                rapAllocateCheck = FALSE; 
            }
        }
       
        if(!rapAllocateCheck){
            if(!jobAllocList.isEmpty()){
                delete jobAllocList;
            }
            Amr_Job_Allocation__c jobAllocObj = new Amr_Job_Allocation__c();
            Amr_Job_Details__Share jobShareObj = new Amr_Job_Details__Share();
                 
            jobAllocObj.AM_Job_Detail__c = jobId;
            jobAllocObj.Is_Primary__c = TRUE;
            jobAllocObj.User__c = selectedRap ;             
            jobAllocObj.Job_Allocated__c = Amr_ConstantForAdManager.YES;
            
            jobShareObj.ParentId = jobId;
            jobShareObj.UserOrGroupId = selectedRap ;               
            jobShareObj.AccessLevel = Amr_ConstantForAdManager.EDIT;
            
            User userList = [Select id, email from User where Id = :selectedRap];
            if(!String.isBlank(userList.Email)){
                 jobDet.JobAllocated_Email__c = userList.email;   
            } 
       
            insert jobAllocObj;   
           
           /* if(String.isBlank(jobDet.Job_Status__c)){
                jobDet.Job_Status__c = 'Pending';
            }*/          
            jobDet.Job_Status__c = 'Pending';
            jobDet.OwnerId = selectedRap;
            update jobDet;
                    }  
        }catch(Exception e){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
      
        }
    }
  
 /***********************************************************************************************************************************
Purpose:  CAP job cancel method, to cancel a particular job and send it to cancelled list.
Parameters: 
Returns: PageReference

************************************************************************************************************************************/      
    public pagereference cancelJob(){
       try{
        if(String.isBlank(jobID)){
            jobsheetErrorCheck = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
        }
        else{
            if(jobList.Job_Cancelled__c){
                 jobsheetErrorCheck = true;
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobAlreadyCancelled));  
                return null;
           } 
           else{
              jobSheetHelper.jobCancellation(jobList,jobId,jobAlloc,ownerIdOfSelectedJob);
               PageReference navPage = Page.Amr_CAPJobPortfolio;
               navPage.setRedirect(true);
               return navPage;
          }
       }
       }catch(Exception e){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
         return null;
       }
    }
       
   


 /***********************************************************************************************************************************
Purpose:  Method contains the logic for the RAP to accept a Job.
Parameters: 
Returns: PageReference

************************************************************************************************************************************/     
    public PageReference acceptJob(){
        alertErrorCheck = false;
       try{
        if(jobStatus == Label.Amr_Job_Accepted) {
            jobsheetErrorCheck = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobAlreadyAccepted)); 
            return null;
       }
        if(joblist.Job_Cancelled__c){
            jobsheetErrorCheck = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIsCancelled));  
            return null;
        }
       else{
           jobAlloc.Job_Status__c  = Label.Amr_Job_Accepted;
           jobStatus = jobAlloc.Job_Status__c;
           jobAlloc.Job_Status__c= Label.Amr_Job_Accepted;      
           update jobAlloc;
           
           String userEmail = [Select email from User where id = :jobAlloc.User__c].email;
           joblist.Job_Accepted_Email__c = userEmail;
           joblist.Job_Status__c = 'Live';
          
          String createdByEmail = [Select email from User where id = :joblist.createdByid].email;
          
          List<String> createdByUserEmailAdd = new List<String>();
          
          createdByUserEmailAdd.add(createdByEmail);
          createdByUserEmailAdd.add(joblist.Unilever_Project_Leader_Email__c);
          createdByUserEmailAdd.add(joblist.Final_Approver_Of_Material_Email__c);
         
          createdByUserEmail = JSON.serialize(createdByUserEmailAdd);
          System.debug('Created BY EMAIL ->  ' + createdByUserEmail);
          
           update joblist;
           
           jobIsAccepted = true;
                     
           List <String> userEmailList = new List<String>();
           userEmailList.add(userEmail);
           jobsheetErrorCheck = true;     
           ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_JobAccepted));             
           return null;
       }  
       }catch(Exception e){
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
         return null;
       }
    }  
  
/***********************************************************************************************************************************
Purpose:   This method contains the logic to cancel job by RAP.
Parameters: 
Returns: PageReference

************************************************************************************************************************************/  
    public PageReference cancelRapJob(){
        
        if(joblist.Job_Cancelled__c){
            jobsheetErrorCheck = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobAlreadyCancelled));  
            return null;
        }
         
        else{
            jobSheetHelper.jobCancellation(jobList,jobId,jobAlloc,ownerIdOfSelectedJob);
            PageReference navPage = Page.Amr_RAPJobPortfolio;
            navPage.setRedirect(true);
            return navPage;
       }
    }
  
    
  /***********************************************************************************************************************************
Purpose:   Method to reallocate a particular job by one RAP(Primary RAP) to another RAP
Parameters: 
Returns: PageReference

************************************************************************************************************************************/ 
    public PageReference reAllocateRAP() {
            
        if(String.isBlank(jobID)){
            jobsheetErrorCheck = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
       }
       else{
      
           if(jobList.Job_Cancelled__c){
                     jobList.Job_Cancelled__c = false;
                     jobAlloc.Job_Status__c = ''; 
                     jobsheetErrorCheck = true;
                     ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,label.Amr_This_job_has_already_been_cancelled));
                      update jobList;
                       update jobAlloc;
                     return null; 
           }
          
                jobReAllocate(selectedRapName, jobId, jobList); 
               if(rapAllocateCheck &&  !jobList.Job_Cancelled__c){
               jobsheetErrorCheck = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.Amr_Error_JobAlreadyAllocated));
                return null;    
               }           
               else{
               alertErrorCheck = false;
               jobsheetErrorCheck = true;
               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_JobAllocated));
                PageReference landingPage = Page.Amr_RAPJobPortfolio;
               return landingPage;
                 }
           
      }    
        
    }
  
      
  /***********************************************************************************************************************************
Purpose:   Method to reallocate a particular job by one RAP(Primary RAP) to another RAP
Parameters: 
Returns: PageReference

************************************************************************************************************************************/  
     public PageReference reAllocateSecRAP(){
     
         selectedRapName = selectedSecRapName;
         reAllocateRAP();
         PageReference landingPage = Page.Amr_RAPJobPortfolio;
         return landingPage;
     
     }    
   
  /***********************************************************************************************************************************
Purpose:   Method for changing job status Live, dormant, etc.
Parameters: 
Returns: PageReference

************************************************************************************************************************************/  
    public PageReference changePriority(){
      
        if(String.isBlank(jobID)){
            jobsheetErrorCheck = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
        }
        else{
            alertErrorCheck = false;
            update jobList;
            jobsheetErrorCheck = true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_StatusChanged)); 
            return null;
       }    
    }
 /***********************************************************************************************************************************
Purpose:  Method to get all the categories.
Parameters: 
Returns: JSON String

************************************************************************************************************************************/        

      public String getCategoryList(){ 
      
        return JSON.serialize(categoryString);
    }
   
 
 
  /***********************************************************************************************************************************
Purpose: Method to get all the brand positions on the basis of selected category.
Parameters: 
Returns: List of select options

************************************************************************************************************************************/   
    public List<SelectOption> getBrandPositioningList(){    
                
        listOfBrandPosition = new List<SelectOption>();
        listOfBrandPosition.add(new selectOption(jobList.Brand_Position__r.name,jobList.Brand_Position__r.name));
        return listOfBrandPosition;
         
    }   
    
    public PageReference  brandPositionListData(){    
       
        selectedBrandPosName = null;
        brandNameFromPage = null;
        Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        Set<MDO_BrandPositions__c> brandPositionlst = utiltyObj.brandPostitionValues(selectedCategory);
         listOfBrandPosition = new List<SelectOption>();
        listOfBrandPosition.add(new selectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));
        Set<String> brnadPosNameSet = new Set<String>();
        for(MDO_BrandPositions__c bps : brandPositionlst){

            if(!brnadPosNameSet.contains(bps.brand_position_id__r.name)){
                listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));
                brnadPosNameSet.add(bps.brand_position_id__r.name);
            }
        }
         listOfBrand = new List<SelectOption>();
         listOfBrand.add(new selectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));
    
         return null;
    }
   
 
/***********************************************************************************************************************************
Purpose:Method to get all the brand names on the basis of selected brand position.
Parameters: 
Returns: List of select options

************************************************************************************************************************************/     
       public List<SelectOption> getBrandList(){      
        listOfBrand = new List<SelectOption>();
        listOfBrand.add(new selectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));

        Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        Set<MDO_BrandPositions__c> brandlst = utiltyObj.brandValues(selectedCategory,selectedBrandPosName);
        Set<String> brnadNameSet = new Set<String>();
        for(MDO_BrandPositions__c bps : brandlst){

            if(!brnadNameSet.contains(bps.brand_id__r.name)){
                listOfBrand.add(new selectOption(bps.brand_id__r.name,bps.brand_id__r.name));

                brnadNameSet.add(bps.brand_id__r.name);
            }
        }
        
        return listOfBrand;
    }

/***********************************************************************************************************************************
Purpose:Method to update the job.
Parameters: 
Returns: PageReference
N-Path:
MDO* obejcts are the Matser live data in UL and this method itertes the whole category data to dispaly on AdManager page and Job sheet page
************************************************************************************************************************************/

    public Pagereference updateJob(){
        if(selectedBrandPosName != null){
                brandPosName = selectedBrandPosName;
        }
        if(selectedCategory != null){
                categoryName = selectedCategory;
        }
        List<MDO_BrandPositions__c> MDOBrandPositionslst =[select  brand_position_id__c,product_category_id__c,brand_id__c from MDO_BrandPositions__c where product_category_id__r.name = :categoryName AND brand_position_id__r.name = :brandPosName AND brand_id__r.name = :brandNameFromPage];
              
        if(categoryString == null){
                categoryString = new list<string>();
                Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
                Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
               
                for(MDO_Category__c mdCat : categorylst){
                    categoryString.add(mdCat.name);
                }
        }
       
        if(MDOBrandPositionslst.size()>0){
                        if(categoryName !=Amr_ConstantForAdManager.NONE){       
                                jobList.ProductCategory__c = MDOBrandPositionslst[0].product_category_id__c ;
                        }
                        if(brandPosName!=Amr_ConstantForAdManager.NONE){
                            jobList.Brand_Position__c = MDOBrandPositionslst[0].brand_position_id__c ;
                        }
                        if(brandNameFromPage!=Amr_ConstantForAdManager.NONE){
                            jobList.Brand_Final__c = MDOBrandPositionslst[0].brand_id__c ;
                                jobSheetHelper.updateAdManagerText(jobList,brandNameFromPage);
                        }
        }
        
        if(String.isNotBlank(selectedCountry)){
        Amr_CurrencyConversionRate__c currencyObject =[SELECT Currency_Unit__c,Name FROM Amr_CurrencyConversionRate__c WHERE Currency_Unit_To_Euro__c =:double.valueOf(selectedCountry) limit 1];
         
         String currencyFinalString = currencyObject.Name+Amr_ConstantForAdManager.DASH+currencyObject.Currency_Unit__c;
         jobList.Currency_Conversion_Country_List__c = currencyFinalString;
         selectedCountry = currencyFinalString;
        }
      
         if(jobList.Project_Details__c!=null){
            
              Amr_Project_Details__c projectObj = [select id,name from Amr_Project_Details__c where id = :jobList.Project_Details__c ];
              projectNameFromPage = projectObj.name;
              
         }
        validateJobList();
        if(validateSuccess){
            
        update jobList;
       
         PageReference pageRef = new PageReference(label.Amr_JobSheet);
         pageRef.getParameters().put(Amr_ConstantForAdManager.ID,jobList.Id);
         pageRef.getParameters().put(label.Amr_tab,label.Amr_job_details);
         pageRef.getParameters().put(label.Amr_message,label.Amr_Successfully_updated);
         pageRef.getParameters().put('defaultPage','jobdetails');
       
         pageRef.setRedirect(true);
         return pageRef; 
         }
         return null;
    }
 /***********************************************************************************************************************************
Purpose:Method to update job once notes entered.
Parameters: 
Returns: PageReference

************************************************************************************************************************************/  
    public PageReference updateJobForNotes(){

        joblist.Job_Notes__c = NotesValue;
     if(joblist.Job_Notes__c != null && joblist.Job_Notes__c != ''){
         List<Amr_Job_Allocation__c> jobAllocationList = [Select id, User__r.Name, User__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId ];
         List<Amr_Job_Allocation__c> jobAllocationListUpdate  = new  List<Amr_Job_Allocation__c>();
         update jobList;
         
         for(Amr_Job_Allocation__c objJobAllocation: jobAllocationList){
            objJobAllocation.Started__c = 'Yes';
            jobAllocationListUpdate.add(objJobAllocation);
         }
         update jobAllocationListUpdate;
         
         return null;
     }
    
     return null;
    }
   
    /***********************************************************************************************************************************
Purpose: Method for RAP(primary) to share job with other RAPs
Parameters: 
Returns: PageReference

************************************************************************************************************************************/  
      
    public pagereference recordShare(){
        
         alertErrorCheck = false;
        if(String.isBlank(jobID)){
            jobsheetErrorCheck = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
        }
        else{
             List<Amr_Job_Allocation__c> shareCheckList = [Select id, User__r.Name, User__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND User__c IN :listOfRAPSelected AND Is_Primary__c = false];
             Set<String> rapSet = new Set<String>();
             List<String> finalRapList = new List<String>();
             if(!shareCheckList.isEmpty()){
                 jobsheetErrorCheck = true;
                for(Amr_Job_Allocation__c rapAlreadyShared : shareCheckList ){
                    String errorMsg = label.Amr_Job_already_Shared_with + rapAlreadyShared.User__r.Name;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg));
                    rapSet.add(rapAlreadyShared.User__c);
                }
            }
          
            for(String raps : listOfRAPSelected){
                if(!rapSet.contains(raps)){
                    finalRapList.add(raps);
                        
                }
            }
            
            List<Amr_Job_Details__share> listOfJobShare = new List<Amr_Job_Details__share>();
            List<Amr_Job_Allocation__c> listOfRAPJob = new List<Amr_Job_Allocation__c>();
            List<Amr_Job_Allocation__Share> listOfSharedAllocatedJob = new List<Amr_Job_Allocation__Share>();
            Amr_Job_Details__Share jobShr; 
            Amr_Job_Allocation__c jobAllocObj;
            Amr_Job_Allocation__Share jobAllocShare;
            
            for (String eachSelectedUser :finalRapList)
            {                
                jobShr  = new Amr_Job_Details__share ();
                jobShr.ParentId = jobId;
                jobShr.UserOrGroupId = eachSelectedUser;
                jobShr.AccessLevel = Amr_ConstantForAdManager.READ;
                jobShr.RowCause = Schema.Amr_Job_Details__share.RowCause.Manual;  
                listOfJobShare.add(jobShr);
                              
               jobAllocObj = new Amr_Job_Allocation__c();
               jobAllocObj.AM_Job_Detail__c = jobId;
               jobAllocObj.Is_Primary__c = FALSE;
               jobAllocObj.User__c = eachSelectedUser;  
               jobAllocObj.Job_Allocated__c= Amr_ConstantForAdManager.YES;  
               jobAllocObj.Job_Shared__c  = Amr_ConstantForAdManager.YES;       
               listOfRAPJob.add(jobAllocObj);

          }
          insert listOfJobShare;
          insert listOfRAPJob;
          
          for(Amr_Job_Allocation__c jAlloc : listOfRAPJob){
                 jobAllocShare = new Amr_Job_Allocation__Share();
                jobAllocShare.ParentId = jAlloc.id;
                jobAllocShare.UserOrGroupId = jAlloc.User__c;
                jobAllocShare.AccessLevel = Amr_ConstantForAdManager.READ;
                jobAllocShare.RowCause = Schema.Amr_Job_Details__share.RowCause.Manual;  
                listOfSharedAllocatedJob.add(jobAllocShare); 
          }
          
          insert listOfSharedAllocatedJob;
                
          List<User> userList = [Select id, email from User where Id IN :listOfRAPSelected];
          List<String> emailAddress = new List<String>();
          for(User userEmail : userList){
              emailAddress.add(userEmail.email);
          }
          List<Amr_Job_Allocation__c> rapNameList = [Select id, User__r.Name, User__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND User__c IN :finalRapList AND Is_Primary__c = false];
          for(Amr_Job_Allocation__c jAlloc : rapNameList ){
              String successMsg = label.Amr_Job_shared_successfully_with + jAlloc.User__r.Name ;
              jobsheetErrorCheck = true;
              ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,successMsg ));
          }
          jobSharedList = [ select id, User__c, User__r.Name from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND Is_Primary__c = False order by User__r.Name];
          sharedListSize = jobSharedList.size();
          sharedOption(jobSharedList );
    
    Amr_EmailSendingClass_CC.emailSending(jobId, emailAddress,label.Amr_RAPSharedJob);
 
      PageReference pageRef = Page.amr_jobsheet;
     pageRef.getParameters().put(Amr_ConstantForAdManager.ID,jobId);
     pageRef.setRedirect(true);
     return PageRef;
    
    }  
     
   }
  /***********************************************************************************************************************************
Purpose:  Method for RAP(primary) to unshare job with RAPs.
Parameters: 
Returns: PageReference

************************************************************************************************************************************/ 
     public PageReference jobUnShare(){
   
       List<Amr_Job_Details__share> listOfJobDetailShare = [Select Id from Amr_Job_Details__Share where id = :jobId AND UserOrGroupId = :selectedUnshareRapName AND UserOrGroupId != :userInfo.getUserId()];
       List<Amr_Job_Allocation__Share> listOfSharedAllocatedJob = [Select Id from Amr_Job_Allocation__Share where ParentId = :jobId AND UserOrGroupId = :selectedUnshareRapName AND UserOrGroupId != :userInfo.getUserId()];
       List<Amr_Job_Allocation__c> listOfSharedJob = [Select Id from Amr_Job_Allocation__c where AM_Job_Detail__c  = :jobId AND User__c = :selectedUnshareRapName  AND User__c != :userInfo.getUserId() AND Is_Primary__c != TRUE];
       if(!listOfJobDetailShare.IsEmpty()){
           delete listOfJobDetailShare;
       }
       if(!listOfSharedAllocatedJob.isEmpty()){
           delete listOfSharedAllocatedJob;
       } 
       if(!jobSharedList.isEmpty()){
           delete listOfSharedJob;
       }
       new Amr_JobSheetController_CC();
       PageReference pageRef = Page.amr_jobsheet;
     pageRef.getParameters().put(Amr_ConstantForAdManager.ID,jobId);
     pageRef.setRedirect(true);
     return PageRef;
   }
   
   
    public boolean CheckWithCMIflag{get;set;}
    public boolean yourEmailAddressFlag{get;set;}
    public boolean unileverFinanceMemberEmailFlag{get;set;}
    public boolean projectLeaderCountryClusterFlag{get;set;}
    public boolean finalApproverMaterialEmailFlag{get;set;}
    public boolean functionYouArePartFlag{get;set;}
    public boolean budgetResponsibilityFlag{get;set;}
    public boolean budgetAllocatedCountryFlag{get;set;}
    public boolean budgetAllocatedInputFlag{get;set;}
    public boolean categoryNameFlag{get;set;}
    public boolean brandPosNameFlag{get;set;}
    public boolean brandNameFromPageFlag{get;set;}
    public boolean agencyDirectorEmailFlag{get;set;}
    public boolean projectDescriptionFlag{get;set;}
    public boolean campaignNameFlag{get;set;}
    public boolean targetAirDateFlag{get;set;}
    public boolean leadAgencyFlag{get;set;}
    public boolean LeadAgencyClusterFlag{get;set;}
    public boolean projectDetailsFlag{get;set;}
    public boolean productionActivityTypeFlag{get;set;}
    public boolean ExecutionNameFlag{get;set;}
    public boolean BrodcastMarketFlag{get;set;}
    public boolean RequireMusicFlag{get;set;}
    public boolean RequireTalentFlag{get;set;}
    public boolean StageProductionActivity{get;set;}
    public String CheckWithCMI{get;set;}
    /***********************************************************************************************************************************
Purpose: Method to validate job
Parameters: 
Returns: PageReference
N-Path:
 This validation is on JobSheet edit page where CAP/RAP can edit and submit the form again, so can not break down 'if' decision points
************************************************************************************************************************************/
   public PageReference validateJobList(){
   
            CheckWithCMIflag = false;
            yourEmailAddressFlag = false;
            unileverFinanceMemberEmailFlag = false;
            projectLeaderCountryClusterFlag = false;
            finalApproverMaterialEmailFlag = false;
            FunctionYouArePartFlag = false;
            budgetResponsibilityFlag = false;
            budgetAllocatedCountryFlag = false;
            budgetAllocatedInputFlag = false;
            categoryNameFlag = false;
            brandPosNameFlag = false;
            brandNameFromPageFlag = false;
            AgencyDirectorEmailFlag = false;
            ProjectDescriptionFlag = false;
            CampaignNameFlag = false;
            TargetAirDateFlag = false;
            leadAgencyFlag = false;
            LeadAgencyClusterFlag = false;
            projectDetailsFlag = false;
            productionActivityTypeFlag = false;
            ExecutionNameFlag = false;
            BrodcastMarketFlag = false;
            RequireMusicFlag = false;
            RequireTalentFlag = false;
            StageProductionActivity = false;
            CheckWithCMI = label.Amr_Please_fill_in_missing_information;
            Boolean okayToSave = true;
            validateSuccess = false;
            
          /*
           N-Path:
            Mandatory user input is validated and require to set respective variable in order to display error message
            respective field level on page
          */  
         if(jobList.Check_With_CMI__c == null){
             CheckWithCMIflag = true;
          }
         if(jobList.Your_Email_Address__c == null){
             yourEmailAddressFlag = true;
          } 
        if(jobList.Unilever_Finance_Member_Email__c == null){
             unileverFinanceMemberEmailFlag = true;
         }
        if(jobList.Final_Approver_Of_Material_Email__c== null){
             finalApproverMaterialEmailFlag = true;
        }
        if(String.isBlank(selectedCountry)){
            budgetAllocatedCountryFlag = true;
        }
        if(jobList.Budget_Allocated_Input_Value__c == null){
            budgetAllocatedInputFlag =  true;
         }
        if( jobList.ProductCategory__c == null || categoryName == Amr_ConstantForAdManager.NONE){
            categoryNameFlag = true;
        }
         if( jobList.Brand_Position__c == null || brandPosName == Amr_ConstantForAdManager.NONE){
            brandPosNameFlag = true;
        }
         if(jobList.Brand_Final__c == null || brandNameFromPage == Amr_ConstantForAdManager.NONE){
             brandNameFromPageFlag = true;
         }
         if(jobList.Agency_Contact_Account_Director_Email__c == null){
            AgencyDirectorEmailFlag = true;
          }
        if(jobList.Project_Description__c == null){
            ProjectDescriptionFlag = true;
          }
        if(jobList.Campaign_Name__c == null){
             CampaignNameFlag = true;
         }
        if(jobList.Target_Air_Date__c == null){
             TargetAirDateFlag = true;
         }
        if(jobList.Project_Leader_Cluster__c == null || jobList.Project_Leader_Country__c == null){
             projectLeaderCountryClusterFlag = true;
       }
        if(jobList.Function_You_Are_Part__c == null){
             FunctionYouArePartFlag = true;
         }
       if(jobList.Budget_Responsibility__c == null){
            budgetResponsibilityFlag = true;
         }
        if(jobList.Lead_Creative_Agency_name__c == null && jobList.Lead_Agency_Name_Other__c == null){
            leadAgencyFlag = true;
          }
        if(jobList.Lead_Agency_Location_Cluster__c == null || jobList.Lead_Agency_Location_Country__c == null){
             LeadAgencyClusterFlag = true; 
         }
       
        if(String.isBlank(jobList.Project_Details__c) && String.isBlank(jobList.Project_Name_Other__c)){
        projectDetailsFlag = true;
        projectNameFromPage = null;
        }
       if(jobList.Production_Activity_Type__c == null){
            productionActivityTypeFlag = true;
         }
        if(String.isBlank(jobList.Project_Description__c)){
             ProjectDescriptionFlag = true;
       }
         if(String.isBlank(jobList.Execution_Name__c)){
             ExecutionNameFlag = true;
         }
        if(String.isBlank(jobList.Brodcast_Market__c)){
              BrodcastMarketFlag = true;
       }
       if(jobList.Require_Music__c == null){
            RequireMusicFlag = true;
        }
        if(jobList.Require_Celebrity_Talent__c == null){
            RequireTalentFlag = true;
     }
        if(jobList.Stage_of_Production_Activity__c == null){
            StageProductionActivity = true;
         }
      //   okayToSave = jobSheetHelper.productionActivityTypeValidation(okayToSave,jobList);
         
         if( okayToSave && !CheckWithCMIflag  && !yourEmailAddressFlag && !unileverFinanceMemberEmailFlag && !projectLeaderCountryClusterFlag  && !finalApproverMaterialEmailFlag  && !functionYouArePartFlag 
                 && !budgetResponsibilityFlag  && !budgetAllocatedCountryFlag  && !budgetAllocatedInputFlag  && !categoryNameFlag  && !brandPosNameFlag && !brandNameFromPageFlag && !agencyDirectorEmailFlag 
                 && !projectDescriptionFlag  && !campaignNameFlag && !leadAgencyFlag  && !LeadAgencyClusterFlag && !projectDetailsFlag  && !productionActivityTypeFlag  && !TargetAirDateFlag 
                 && !ExecutionNameFlag  && !BrodcastMarketFlag  && !RequireMusicFlag && !RequireTalentFlag  && !StageProductionActivity ) {
                validateSuccess = true;
                 return null;
        }
    return null;
   }
   
   /***********************************************************************************************************************************
Purpose: Method to upload documents
Parameters: 
Returns: PageReference

************************************************************************************************************************************/
   
   public Pagereference uploadDocument(){
             
              if(document.body==null){
                 jobsheetErrorCheck = true;
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Select_atleast_one_document));
              
              }
                  if(document.body!=null && jobIdFromPage != null){           
                                   
              FeedItem FI = new FeedItem();
              FI.ParentId = jobIdFromPage;
              FI.Body = Amr_ConstantForAdManager.ATTACHMENT_ADDED;
              FI.ContentData = document.body;
              FI.ContentFileName = document.Name;
              
              insert FI;
              getDocuments();
              document = new document();
              
              PageReference pageRef = new PageReference(label.Amr_JobSheet); 
              pageRef.getParameters().put(Amr_ConstantForAdManager.ID,jobList.Id);
              //pageRef.getParameters().put(label.Amr_message,label.Amr_Successfully_updated);        
              pageRef.getParameters().put('defaultPage','creative_docs');       
              pageRef.setRedirect(true);
              return pageRef;
              
        }
        
        return null;
     
    }
    /***********************************************************************************************************************************
Purpose: Method to get uploaded documents.
Parameters: 
Returns: 

************************************************************************************************************************************/
    public void getDocuments(){
    
       documentList= [select ContentFileName,CreatedBy.name,relatedrecordid,createdDate from FeedItem where ParentId =:jobIdFromPage];  //ContentFileName,
    }
     public Pagereference deleteDocuments(){
               
        FeedItem doc =[select Id from FeedItem where Id=:chosenDocId limit 1];
        delete doc ;
        getDocuments();
        return null;
    }
    
  /***********************************************************************************************************************************
Purpose: Method to create alerts.
Parameters: 
Returns: 

************************************************************************************************************************************/
    
     public void addNewAlert(){

         alertObj.Job_Id__c  = jobIdFromPage ;
        
        if(alertObj.New_Alert__c == null || alertObj.Alert_Message__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Please_enter_both_alert_date_and_alert_message));
            alertErrorCheck = true;
            jobsheetErrorCheck = false;
            return;
            
        } 
        if(alertObj.New_Alert__c < Date.today()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Alert_date_must_be_greater_than_or_equal_to_today_s_date));
            alertErrorCheck = true;
            jobsheetErrorCheck = false;
            return;
        }
        if(alertObj.Alert_Message__c.length()>150){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Alert_message_should_be_less_than_150_characters));
            alertErrorCheck = true;
            jobsheetErrorCheck = false;
            return;
        }
        if(!String.isBlank(String.valueOf(alertObj.New_Alert__c)) && !String.isBlank(alertObj.Alert_Message__c) && alertObj.New_Alert__c >= Date.today() && alertObj.Alert_Message__c.length()<=150){
         insert alertObj;
         alert = [SELECT Alert_Message__c,job_Id__r.AdManagerText__c,New_Alert__c,Job_Id__c FROM Amr_Alert__c where hide__c = :false AND Job_Id__c  = :jobIdFromPage AND ownerId = :userInfo.getUserID() order by New_Alert__c desc];
         totalAlertCount =  [select count() from Amr_Alert__c where ownerId =:userInfo.getUserId() AND Hide__c =:false AND Job_Id__c  = :jobIdFromPage];
       alertObj = new Amr_Alert__c();
       }   
   
    }
    
/***********************************************************************************************************************************
Purpose: Method to hide alert.
Parameters: 
Returns: 

************************************************************************************************************************************/
     public void alertHide(){
            
            
            List<Amr_Alert__c> alertHideList = new List<Amr_Alert__c>();
            alertHideList = [SELECT Alert_Message__c,Hide__c FROM Amr_Alert__c where id = :selectedAlert];
           if(!alertHideList.isEmpty()){
            for(Amr_Alert__c alertObj : alertHideList){
                alertObj .Hide__c = TRUE;
            }
            update alertHideList;
           }
           alert = [SELECT Alert_Message__c,job_Id__r.AdManagerText__c,New_Alert__c,Job_Id__c FROM Amr_Alert__c where Job_Id__c  = :jobIdFromPage and hide__c = :false AND ownerId = :userInfo.getUserID() order by New_Alert__c desc];
         totalAlertCount =  [select count() from Amr_Alert__c where ownerId =:userInfo.getUserId() AND Hide__c =:false AND Job_Id__c  = :jobIdFromPage];
        }
/***********************************************************************************************************************************
Purpose: Method to transfer to other page.
Parameters: 
Returns: PageReference

************************************************************************************************************************************/

    public PageReference jobSheetPageTransfer(){
          
           PageReference pageRef = new PageReference(label.Amr_JobSheet);
           pageRef.getParameters().put(Amr_ConstantForAdManager.ID,chosenId);
           pageRef.setRedirect(true);
           return pageRef;
       }
       
    public void makeAcceptanceEmailFalse() {        
        jobIsAccepted = false;      
    }
}