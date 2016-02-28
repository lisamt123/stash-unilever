public with sharing class Amr_JobSheetController{
 
   /* public String getJobDetails() {
        return null;
    }*/

public String docUploaded{get;set;}
    public String projNameFromPage{get;set;}
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
   // public String productionType{get;set;}
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
    
    //Appraisal
    public Integer pcTimeMangCategoryValue {get;set;}
    public Integer pcCostMangCategoryValue {get;set;}
    public Integer pcProcessMangCategoryValue {get;set;}
    public Integer pcOutputQualityCategoryValue{get;set;}
    public Integer pccTimeMangCategoryValue {get;set;}
    public Integer pccCostMangCategoryValue {get;set;}
    public Integer pccProcessMangCategoryValue{get;set;}
    public Integer pccOutputQualityCategoryValue {get;set;}
    public Integer caTimeMangCategoryValue {get;set;}
    public Integer caCostMangCategoryValue {get;set;}
    public Integer caProcessMangCategoryValue{get;set;}
    public Integer caOutputQualityCategoryValue {get;set;}
    //Appraisal Class
    public String pcTimeMangCategoryClass {get;set;}
    public String pcCostMangCategoryClass {get;set;}
    public String pcProcessMangCategoryClass {get;set;}
    public String pcOutputQualityCategoryClass{get;set;}
    public String pccTimeMangCategoryClass {get;set;}
    public String pccCostMangCategoryClass {get;set;}
    public String pccProcessMangCategoryClass{get;set;}
    public String pccOutputQualityCategoryClass {get;set;}
    public String caTimeMangCategoryClass {get;set;}
    public String caCostMangCategoryClass {get;set;}
    public String caProcessMangCategoryClass{get;set;}
    public String caOutputQualityCategoryClass {get;set;}
    public Amr_Quote__c quoteObj{get;set;}
    public Integer totalAlertCount{get; set;}
    public static final String NONE ='--None--';
    
    
    public String jobStatus{get;set;}
   // public List<selectoption> userName{get;set;}
    public String selectedRapName{get;set;}
    public String selectedSecRapName{get;set;}
    public List<PermissionSetAssignment> userData {get;set;}
    public String profileName {get;set;}
    public String permissionSetName {get;set;}
    public Amr_Job_Details__c jobList{ get; set; }      
   // public String getSelectedCountry{get;set;}    
   // public String getCurrencyRecords{get;set;}
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
    
   /* 
   public  Document document {
    get {
      if (document == null)
         document = new Document();
         return document;
    }
    set;
   }*/
    public List<FeedItem> documentList{get;set;}
   
    public Amr_JobSheetController(){
    try{
         Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
         alertObj = new Amr_Alert__c();
        categoryString = new list<string>();
        Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
        System.debug('CAteLisgt' + categorylst);
        listOfUserToDisplay = new List<Amr_Job_Allocation__c>();
        for(MDO_Category__c mdCat : categorylst){
            categoryString.add(mdCat.name);
        }
        //listOfRAPSelected = new List<String>();
        validateSuccess = false;
        selectUsername= new list<selectoption>();
        jobIdFromPage = ApexPages.currentPage().getParameters().get('id');
       
         alert = [select Id,Alert_Message__c,job_Id__r.AdManagerText__c,New_Alert__c,Job_Id__c from Amr_Alert__c where ownerId =:userInfo.getUserId() AND Hide__c =:false AND Job_Id__c  = :jobIdFromPage];          
         totalAlertCount =  [select count() from Amr_Alert__c where ownerId =:userInfo.getUserId() AND Hide__c =:false AND Job_Id__c  = :jobIdFromPage];
        getDocuments();
    }catch(Exception ex){
    System.debug('Exception -> 1 '+ ex.getmessage());
    } 
        try{
            jobId = ApexPages.CurrentPage().getParameters().get('id'); 
       }
       catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Job Id'));
           return;
       }
        
        if(String.isBlank(jobID)){
            system.debug('inside first!');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return;
        }
         
        String message = '' + ApexPages.CurrentPage().GetParameters().Get('message');
        //String pageHeaderReferer = ApexPages.currentPage().getHeaders().get('Referer'); 

        if(message != 'null')
        {
               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message)); 
        }
        
        for(PermissionSetAssignment  userObj :[select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_RAP AND Assignee.id != :userInfo.getUserId() order by Assignee.name] ){
        try{
            SelectOption obj=new SelectOption(userObj.Assignee.id,userObj.Assignee.name);
            selectUsername.add(obj);
        }
        catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid User'));
           return;
       }
        }  
        userData = [select PermissionSet.Name from PermissionSetAssignment  where Assignee.id = :userinfo.getUserId()];
        System.debug('userData ->' + userData );   
        Set<String> userNameSet = new Set<String>();
        for(PermissionSetAssignment permission : userData){
            userNameSet.add(permission.PermissionSet.Name);
        }
        if(userNameSet.contains(Label.Amr_CAP)){
        //    profileName = Label.Amr_CAP;
            permissionSetName = Label.Amr_CAP;
            strTabName        = 'CAP_Jobs_Portfolio__tab';
        }else{
         //   profileName = Label.Amr_RAP;
            permissionSetName = Label.Amr_RAP;
        }
        System.debug('pRofile ->' + permissionSetName);      
    
      //  AND Is_Primary__c = True
      try{
            if(permissionSetName == Label.Amr_CAP){
                jobAlloc = [Select id,User__r.Name, Job_Allocated__c,Reported__c,Started__c,Job_Status__c,Is_Primary__c  from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId limit 1];
                        listOfUserToDisplay = [Select User__r.Name  from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId];
                                                
            }
            else{
                jobAlloc = [Select id,User__r.Name, Job_Allocated__c,Reported__c,Started__c,Job_Status__c,Is_Primary__c  from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId  AND user__c =: userInfo.getUserId() Limit 1 ];
                        listOfUserToDisplay.add(jobAlloc);
            }
            //Project_Description__c
            jobList=[select ReworkExistingMaterial__c,Buyouts_Music_Digital_ED__c,NewOriginalMaster__c,NewOriginalMasterTv__c,NewOriginalMasterCinema__c,NewOriginalMasterRadio__c,NewOriginalMasterPrint__c,NewOriginalMasterOutofHome__c,NewOriginalMasterInStore__c,NewOriginalMasterDigital__c,
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
            
            if(jobList != null){
                system.debug('category---'+jobList.ProductCategory__r.name);
                 system.debug('Brand---'+jobList.Brand_Position__r.name);
                  system.debug('Brand_Final__r---'+jobList.Brand_Final__r.name);
                 
                selectedCategory = jobList.ProductCategory__r.name;
                selectedBrandPosName = jobList.Brand_Position__r.name;
                //system.debug('brand Postition========>'+selectedBrandPosName);
                listOfBrandPosition = new List<SelectOption>();
                listOfBrandPosition.add(new selectOption(jobList.Brand_Position__r.name,jobList.Brand_Position__r.name));
                system.debug('brand name===>'+jobList.Brand_Final__r.name);
                  listOfBrand= new List<SelectOption>();
                listOfBrand.add(new selectOption(jobList.Brand_Final__r.name,jobList.Brand_Final__r.name));
                //brandNameFromPage = jobList.Brand_Final__r.name;
            }
            System.debug('PPPRRRRROOOOO  ---> ' + jobAlloc + jobList);
        }
        catch(Exception e){
        
           
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Job Allocation Record For LoggedIn User'));
            return;
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
            selectJobPriority.add(new SelectOption('Pending','Pending'));
            selectJobPriority.add(new SelectOption('Priority','Priority'));
            selectJobPriority.add(new SelectOption('Live','Live'));
            selectJobPriority.add(new SelectOption('Dormant','Dormant')); 
      
     /*
        userData = [select PermissionSet.Name from PermissionSetAssignment  where Assignee.id = :userinfo.getUserId()];
        Set<String> userNameSet = new Set<String>();
        for(PermissionSetAssignment permission : userData){
            userNameSet.add(permission.PermissionSet.Name);
        }
        if(userNameSet.contains(Label.Amr_CAP)){
            permissionSetName = Label.Amr_CAP;
        }else{
            permissionSetName = Label.Amr_RAP;
        }
        System.debug('pRofile ->' + permissionSetName);
   // profileName = 'CAP';
        System.debug('PPPRRRRROOOOO  ---> ' + permissionSetName); */
        
        projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
         listString= new list<string>();
         
         listString.add(NONE);
        For(Amr_Project_Details__c i : projNameList){
            
                listString.add(i.name);
            
        }
        
         system.debug('proj list  -->  !! '+projNameList); 
                system.debug('list  -->  !! '+listString); 
              system.debug('jobList!!'+jobList);      
                selectedRAPUser =  jobAlloc.User__c; 
        categoryName = jobList.ProductCategory__r.name;
        brandPosName = jobList.Brand_Position__r.name;
        brandNameFromPage = jobList.Brand_Final__r.name;
        selectedCountry = jobList.Currency_Conversion_Country_List__c;
        system.debug('selectedCountry !!'+selectedCountry );
       List<Amr_CurrencyConversionRate__c>currencyList=[SELECT Currency_Unit__c,Name,Currency_Unit_To_Euro__c FROM Amr_CurrencyConversionRate__c limit 50000];
       currencyMap=new Map<String,String>();
       for(Amr_CurrencyConversionRate__c curr:currencyList){
       if(selectedCountry == curr.Name+'-'+curr.Currency_Unit__c){
           currencyMap.put('selectedCountry',String.valueOf(curr.Currency_Unit_To_Euro__c));
           }
       }
           system.debug('currencyMap!!'+currencyMap);
        jobStatus = jobAlloc.Job_Status__c;    
        primaryRap=  jobAlloc.Is_Primary__c;    
        addManagerNumber = jobList.AdManagerText__c;
        jobCancelled = jobList.Job_Cancelled__c;
        ownerIdOfSelectedJob = jobList.OwnerId;
       selectedSecRapName = jobAlloc.User__r.Name;
       selectedRapName = jobAlloc.User__r.Name;
               try{
        editedSavingMode = false;
        viewSavingMode = true;
        editedQuoteMode = false;
        viewQuoteMode = true;
        editedAcceptedQuote = false;
        viewAcceptedQuote = true;
        jobId = ApexPages.currentPage().getParameters().get('id');
        quoteObj = new Amr_Quote__c();
        selectedCountry1 = new List<String> {'Test'};
        List<Amr_Country_Cluster__c> countrylst=  Amr_Country_Cluster__c.getall().values();
        shootLocation = new List<SelectOption>();
        for(Amr_Country_Cluster__c countryObj:countrylst){
             shootLocation.add(new SelectOption(countryObj.Country__c,countryObj.Country__c));
            }
            
            system.debug('========>jobId'+jobId);
                        system.debug('========>selectedCountry '+selectedCountry );
             userId = userinfo.getuserid();
            updateData();
        }catch(Exception ex){
            System.debug('Exception -> 2'+ ex.getmessage());
        }
         
         
     }
      
           
    public void updateData(){
        try{
            
           
            
            
            List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name ='CAP' order by Assignee.name];
            boolean flag = false;
            for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
                 if(userId == permissionObj.Assignee.id){
                   
                    flag = true;
                    system.debug('inside cap User===>');
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
                      quoteList = [select id,PC_Appraisal_Time_Management__c,PC_Appraisal_Output_Quality__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Cost_Management__c,PPC_Appraisal_Time_Management__c,PPC_Appraisal_Output_Quality__c,PPC_Appraisal_Process_Management__c ,PPC_Appraisal_Cost_Management__c,CA_Appraisal_Time_Management__c,CA_Appraisal_Output_Quality__c ,CA_Appraisal_Process_Management__c ,CA_Appraisal_Cost_Management__c,Folder_Name__c,Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,LastModifiedById,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Production_Type__c,Job_Details__r.AdManagerText__c,CreatedById,Number_Of_Quotes__c,
                               Average_Total_Opening_Quotes__c,Saving_Average_of_Quotes__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c,(select Total_Cost__c,Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c from Quotes__r where Is_Accepted__c =:true) from Amr_Saving__c where Job_Details__r.id = :jobId];
                      system.debug('inside Cap List========>'+quoteList );
                      
                      
                 }else{
                   quoteList = [select id,PC_Appraisal_Time_Management__c,PC_Appraisal_Output_Quality__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Cost_Management__c,PPC_Appraisal_Time_Management__c,PPC_Appraisal_Output_Quality__c,PPC_Appraisal_Process_Management__c ,PPC_Appraisal_Cost_Management__c,CA_Appraisal_Time_Management__c,CA_Appraisal_Output_Quality__c ,CA_Appraisal_Process_Management__c ,CA_Appraisal_Cost_Management__c,Folder_Name__c,Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,LastModifiedById,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Production_Type__c,Job_Details__r.AdManagerText__c,CreatedById,Number_Of_Quotes__c,
                               Average_Total_Opening_Quotes__c,Saving_Average_of_Quotes__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c,(select Total_Cost__c,Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c from Quotes__r where Is_Accepted__c =:true) from Amr_Saving__c where Job_Details__r.id = :jobId AND (CreatedById = :userId OR LastModifiedById = :userId )];
                      system.debug('inside Rap List========>'+quoteList );
                     
                 }            
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
               
              //  quoteJobId = jobId;
                if(quoteList.size()>0){
                        adManagerNumber = quoteList[0].Job_Details__r.AdManagerText__c;
                }else{
                   Amr_Job_Details__c jobObj = [select AdManagerText__c from Amr_Job_Details__c where id = :jobId];
                   adManagerNumber = jobObj.AdManagerText__c;
                }
                  
                         
              
            }
      
        }catch(exception ex){
          System.debug('Exception -> '+ ex.getmessage());
        }
    }
      
    //public  Amr_Quote__c acceptedQuote {get;set;}
    public  Document document {
        get {
          if (document == null)
             document = new Document();
             return document;
        }
        set;
   }
    public List<InnerSavingClass> docAndQuoteLst{
        get{
             if(docAndQuoteLst == null)
                    docAndQuoteLst = new List<InnerSavingClass>();     
                return docAndQuoteLst;
        }set;
    }
    
       
    public class InnerSavingClass{
        public Amr_Quote__c quoteObj{get;set;}
        public Document attachmentObj{get;set;}
        
        
        public InnerSavingClass( Integer i,Boolean accepted ,Amr_Quote__c quoteObj1){
            quoteObj = quoteObj1;
            quoteObj.Quote_Number__c = i;
            quoteObj.Is_Accepted__c = accepted;
            attachmentObj = new Document();
        }
        
    }
    public String lstcov {
      get{
            lstcov = JSON.serialize(Amr_CurrencyConversionRate__c.getAll().values());
            return lstcov;
        }set;
    }  
    //public String jobId{get;set;}
    public List<Amr_Saving__c> quoteList{get;set;}
    public List<Amr_Quote__c> quoteRelatedToSavingList{get;set;}
  /*  public List<Amr_Saving__c> lstQuoteToaddRow{
        get{
             if(lstQuoteToaddRow == null)
                    lstQuoteToaddRow = new List<Amr_Saving__c>();     
                return lstQuoteToaddRow;
        }set;
    }*/
    public string userId{get;set;}
 
      public List<selectOption> currencyRecords{
    get {
        
        List<selectOption> options = new List<selectOption>();
        if(currencyMap!=null){
        options.add(new SelectOption(currencyMap.get('selectedCountry'),selectedCountry));}
        
        for (Amr_CurrencyConversionRate__c currencyConversion: Amr_CurrencyConversionRate__c.getAll().values())
        if(selectedCountry != currencyConversion.Name+'-'+currencyConversion.Currency_Unit__c){
        options.add(new SelectOption(String.valueOf(currencyConversion.Currency_Unit_To_Euro__c),currencyConversion.Name+'-'+currencyConversion.Currency_Unit__c));
        }
        return options;
    }
    set;
  }
         
         public String getMethodToPassProjectNames(){
            try{
         projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
         String ProjectName = null;
         if(jobId !=null){
          ProjectName = [select Project_Details__r.name from Amr_Job_Details__c where id=: jobId].Project_Details__r.name;
          system.debug('projectName getMethodToPassProjectNames '+ProjectName);
         }
         listString= new list<string>();
         if(ProjectName !=null){
          listString.add(ProjectName);
         }
         listString.add(NONE);
        For(Amr_Project_Details__c i : projNameList){
            if(ProjectName != i.name){
                listString.add(i.name);
            }
        }
        system.debug('serialize!!'+JSON.serialize(listString));
        return JSON.serialize(listString);
            }catch(Exception e){
            system.debug('Exception ->15'+e.getmessage());
            return null;
            }
    }
    
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
            system.debug('Exception ->16'+e.getmessage());
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
            PageReference pageRef = new PageReference('/apex/Amr_CAPJobPortfolio');
             pageRef.setRedirect(true);
             return pageRef;
        }else{
        
            permissionSetName = Label.Amr_RAP;
             PageReference pageRef = new PageReference('/apex/Amr_RAPJobPortfolio');
             pageRef.setRedirect(true);
             return pageRef;
        }
        }catch(Exception e){
            system.debug('Exception ->17'+e.getmessage());
            return null;
        }
      
        
    }
        
     public PageReference reAllocate() {
        try{
             if(String.isBlank(jobID)){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
                 return null;
             }
          
             else{
                system.debug('selected RAP !!! '+ selectedRAPUser);
                
                  System.debug('CAAAP ->   ' + jobList);
                 if(jobList.Job_Cancelled__c){
                     ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This job has already been cancelled'));
            /*         jobList.Job_Cancelled__c = false;
                     jobAlloc.Job_Status__c = ''; 
                      ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_JobAllocated));
                      update jobList;
                       update jobAlloc;    */
                     return null; 
                 }
                  jobReAllocate(selectedRAPUser,jobId, jobList);
                  if(rapAllocateCheck && !jobList.Job_Cancelled__c){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.Amr_Error_JobAlreadyAllocated));
                      return null;    
                 }
                 else{
                     ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_JobAllocated));
                    return null;
                }
            } 
        }catch(Exception e){
            system.debug('Exception ->18'+e.getmessage());
            return null;
        }
    }
        
    public static void jobReAllocate(String selectedRap, Id jobId, Amr_Job_Details__c jobDet){
        try{
        System.debug('List Of RAP ->'+ selectedRap + ' Job ID -> ' + jobId );
        System.debug('jobDet' + jobDet );
        List<Amr_Job_Allocation__c> jobAllocList = [select Id,Name,User__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND Is_Primary__c = TRUE ]; // AND User__c = :userInfo.getUserId()
        //List<Amr_Job_Details__Share> jobShare = [Select Id ,RowCause from Amr_Job_Details__Share where parentId = :jobID AND RowCause = 'manual'];
       //  System.debug('jobShare ' + jobShare );
        for(Amr_Job_Allocation__c jAlloc : jobAllocList ){
            if(jobDet.ownerId == selectedRap){
                rapAllocateCheck = TRUE;        
            }
              else{
                rapAllocateCheck = FALSE; 
            }
        }
        System.debug('CHECK -> ' + rapAllocateCheck  +  'jobAllocate ->   ' +  jobAllocList );
        if(!rapAllocateCheck){
            if(!jobAllocList.isEmpty()){
                delete jobAllocList;
            }
           /* if(!jobShare.isEmpty()){
                delete jobShare;
            }
             */
          
            Amr_Job_Allocation__c jobAllocObj = new Amr_Job_Allocation__c();
            Amr_Job_Details__Share jobShareObj = new Amr_Job_Details__Share();
       //     Amr_Job_Allocation__Share jobAllocShare = new Amr_Job_Allocation__Share();

                         System.debug('Selected RAP ->' + selectedRap);
            jobAllocObj.AM_Job_Detail__c = jobId;
            jobAllocObj.Is_Primary__c = TRUE;
            jobAllocObj.User__c = selectedRap ;             
            jobAllocObj.Job_Allocated__c = 'Yes';
            
            jobShareObj.ParentId = jobId;
            jobShareObj.UserOrGroupId = selectedRap ;               
            jobShareObj.AccessLevel = 'Edit';
            
    
            User userList = [Select id, email from User where Id = :selectedRap];
            if(!String.isBlank(userList.Email)){
                 jobDet.JobAllocated_Email__c = userList.email;   
            } 
        /*    List<Amr_Job_Details__Share> jobShare1 = new List<Amr_Job_Details__Share>();
            jobShare1 = [Select Id from Amr_Job_Details__Share where id = :jobId and UserOrGroupId =:selectedRap  ];
               
            System.debug('User Email List -> ' + jobShare1 );
            
             try{
                if(jobShare1.isEmpty())
                insert jobShareObj; 
            }
            catch(exception ex){
                System.debug('Uex -> ' + ex );
                
            }   */
            insert jobAllocObj;               
            
       /*     jobAllocShare.ParentId = jobAllocObj.id;                                          // This part is to be deleted, since we are changing ownerid only
            jobAllocShare.UserOrGroupId = selectedRap;
            jobAllocShare.AccessLevel = 'Read';
            jobAllocShare.RowCause = Schema.Amr_Job_Details__share.RowCause.Manual;  
            
            insert jobAllocShare; */
             jobDet.OwnerId = selectedRap;
            update jobDet;
            
           // Amr_EmailSendingClass.emailSending(jobId , emailAddress, 'Amr_RAPAllocatedJob', new List<Id>());  
         }  
        }catch(Exception e){
        system.debug('Exception ->19'+e.getmessage());
      
        }
    }
        
         
    public pagereference cancelJob(){
       try{
        if(String.isBlank(jobID)){

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
        }
        else{
            if(jobList.Job_Cancelled__c){
  
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobAlreadyCancelled));  
                return null;
           } 
           else{

               jobCancellation(jobList, jobId, jobAlloc);
               System.debug('And Here');
               PageReference navPage = Page.Amr_CAPJobPortfolio;
               navPage.setRedirect(true);
               return navPage;
          }
       }
       }catch(Exception e){
        system.debug('Exception ->20'+e.getmessage());
         return null;
       }
    }
       
       
    public void jobCancellation(Amr_Job_Details__c jobDetail, String jobId, Amr_Job_Allocation__c jobAlloc ){
       try{
        System.debug('Job Details Object ->'+ jobDetail + ' Job ID -> ' + jobId );
        List<String> toEmailAddress = new List<String>();
        List<Amr_Job_Allocation__c> jbAlloc  = [select Id,Name,User__c,Job_Status__c  from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND Is_Primary__c = TRUE ];
        jobDetail.Job_Cancelled__c = TRUE;
        if(jbAlloc != null && !jbAlloc.isEmpty() ){
        jbAlloc[0].Job_Status__c = Label.Amr_Job_Cancelled;
            update jbAlloc;
        }
        List<Amr_Job_Allocation__c> canceledJobList = [select id, Is_Primary__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId And Is_Primary__c = false];
        System.debug('CANCELL LIST ->  ' + canceledJobList );
        List<Amr_Job_Allocation__c> jbAllocCancel = new List<Amr_Job_Allocation__c> ();
        if(!canceledJobList.isEmpty()){
            for(Amr_Job_Allocation__c obj : canceledJobList){
                obj.Job_Status__c = Label.Amr_Job_Cancelled;
                jbAllocCancel.add(obj);
                
            }
             update jbAllocCancel;
            //delete canceledJobList;
        }
        List<Amr_Job_Details__Share> cancelShareList = [Select Id from Amr_Job_Details__Share where id = :jobId AND  UserOrGroupId != :ownerIdOfSelectedJob];
        System.debug('HELLO ->' + cancelShareList);
        if(!cancelShareList.isEmpty()){
            delete cancelShareList; 
        }
        System.debug('CANCELL SHARE LIST ->  ' + cancelShareList);
        System.debug('CANCELL LIST ->  ' + jbAlloc);
  /*      toEmailAddress.add(jobDetail.Unilever_Project_Leader_Email__c);
        toEmailAddress.add(jobDetail.Unilever_Finance_Member_Email__c);
        toEmailAddress.add(jobDetail.Final_Approver_Of_Material_Email__c);
        toEmailAddress.add(jobDetail.Agency_Contact_Account_Director_Email__c );
        toEmailAddress.add(jobDetail.Your_Email_Address__c); */
        update jobDetail;
     //   Amr_EmailSendingClass.emailSending(jobId,toEmailAddress, 'Amr_JobCancellation', new List<Id>() );
       }catch(Exception e){
       system.debug('Exception ->21'+e.getmessage());
       
       }
    }
       
      
    public PageReference acceptJob(){
       try{
        if(jobStatus == Label.Amr_Job_Accepted) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobAlreadyAccepted)); 
            return null;
       }
        if(joblist.Job_Cancelled__c){
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
           update joblist;
           
           
           List <String> userEmailList = new List<String>();
           userEmailList.add(userEmail);
           
        //   Amr_EmailSendingClass.emailSending(jobId  , userEmailList , 'Amr_RAPAcceptedJob', new List<Id>() );
           ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_JobAccepted));             
           return null;
       }  
       }catch(Exception e){
        system.debug('Exception ->22'+e.getmessage());
         return null;
       }
    }  
 
    public PageReference cancelRapJob(){
        
        if(joblist.Job_Cancelled__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobAlreadyCancelled));  
            return null;
        }
         
        else{
            jobCancellation(jobList, jobId, jobAlloc);
            PageReference navPage = Page.Amr_RAPJobPortfolio;
            navPage.setRedirect(true);
            return navPage;
       }
    }
  
       
    public PageReference reAllocateRAP() {
       
      
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
       }
       else{
       System.debug('RAAAP ->   ' + jobList);
        
           if(jobList.Job_Cancelled__c){
                     jobList.Job_Cancelled__c = false;
                     jobAlloc.Job_Status__c = ''; 
                     ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'This job has already been cancelled'));
                      update jobList;
                       update jobAlloc;
                     return null; 
           }
        

            jobReAllocate(selectedRapName, jobId, jobList); 
           if(rapAllocateCheck &&  !jobList.Job_Cancelled__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.Amr_Error_JobAlreadyAllocated));
                return null;    
           }
            
           else{
               
               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_JobAllocated));
                PageReference landingPage = Page.Amr_RAPJobPortfolio;
                return landingPage;

          }
      }    
        
    }
     public PageReference reAllocateSecRAP(){
     
         selectedRapName = selectedSecRapName;
         reAllocateRAP();
         PageReference landingPage = Page.Amr_RAPJobPortfolio;
         return landingPage;
     
     }    
        
    public PageReference changePriority(){
      
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
        }
        else{
            update jobList;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_StatusChanged)); 
            return null;
       }    
    }
        
        /*
        public List<SelectOption> getCategoryList(){      
        
         listOfCategory = new List<SelectOption>();
         
         listOfCategory.add(new selectOption(NONE,NONE));
         Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
         
         for(String cat: utiltyObj.categoryBrandPositionMap.keySet()){
             listOfCategory.add(new selectOption(cat,cat));
             system.debug('inside Category==>'+cat);
         }
         return listOfCategory;
     } */
     
     
      public String getCategoryList(){ 
        System.debug('cATE ->' +  JSON.serialize(categoryString));
        return JSON.serialize(categoryString);
    }
     
     public List<SelectOption> getProjectNameList(){      
        
         listOfProjectName = new List<SelectOption>();
         List<Amr_Project_Details__c> ProjectNameList= [Select id,Name from Amr_Project_Details__c order by name limit 500];
         listOfProjectName .add(new selectOption(NONE,NONE));
         for(Amr_Project_Details__c cat : ProjectNameList){
             listOfProjectName.add(new selectOption(cat.Id,cat.Name));
         }
        
         System.debug('Category List -> ' + listOfProjectName );
         return listOfProjectName ;
     }
   
    public List<SelectOption> getBrandPositioningList(){    
       
         /*System.debug('BBBBBBRANDDD ->'+ categoryName);  
         Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
         Set<String> brandPositionlst = new Set<String>();
         
         for(String cat:utiltyObj.categoryBrandPositionMap.keySet()){
                if(cat == categoryName){
                        brandPositionlst = utiltyObj.categoryBrandPositionMap.get(cat);
                }
                
         }
         
         listOfBrandPosition = new List<SelectOption>();
         listOfBrandPosition.add(new selectOption(NONE,NONE));
         for(String bps : brandPositionlst){
             listOfBrandPosition.add(new selectOption(bps,bps));
         }
        //System.debug('BBBBBBRANDDDLSIT ->'+ brandPosList);  
        
       
        
        system.debug('brandPositionList----->'+listOfBrandPosition);*/
        listOfBrandPosition = new List<SelectOption>();
        listOfBrandPosition.add(new selectOption(jobList.Brand_Position__r.name,jobList.Brand_Position__r.name));
        system.debug(jobList.Brand_Position__r.name+'==Brand Position==>'+listOfBrandPosition);
        //listOfBrandPosition.add(new selectOption(selectedBrandPosName = jobList.Brand_Position__r.name;));
        return listOfBrandPosition;
         
    }   
    
    public PageReference  brandPositionListData(){    
        System.debug('BBBBBBRANDDD ->'+ selectedCategory);  
        selectedBrandPosName = null;
        brandNameFromPage = null;
        Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        Set<MDO_BrandPositions__c> brandPositionlst = utiltyObj.brandPostitionValues(selectedCategory);

        system.debug('brandPositionListttoo----->'+brandPositionlst );

        listOfBrandPosition = new List<SelectOption>();
        listOfBrandPosition.add(new selectOption(NONE,NONE));
        Set<String> brnadPosNameSet = new Set<String>();
        for(MDO_BrandPositions__c bps : brandPositionlst){

            if(!brnadPosNameSet.contains(bps.brand_position_id__r.name)){
                listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));

                brnadPosNameSet.add(bps.brand_position_id__r.name);
            }
        }
         listOfBrand = new List<SelectOption>();
         listOfBrand.add(new selectOption(NONE,NONE));
        system.debug('brandPositionListtt----->'+listOfBrandPosition);
        system.debug('brand----->'+listOfBrand);
        return null;

    }
    
    public void ProjectData(){
        system.debug('project-------->'+projNameFromPage);
    
    }
     /*
    public List<SelectOption> getBrandList(){      
       
         listOfBrand = new List<SelectOption>();
         system.debug('========>'+brandPosName);
         
         listOfBrand.add(new selectOption(NONE,NONE));
         
         Set<String> brandlst = new Set<String>();
         Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
         
         for(String brandPos:utiltyObj.BrandPositionAndBrandMap.keySet()){
                 List<String> postionCategorylist = brandPos.split(',');
                 system.debug('bandPostion and Category====>'+postionCategorylist);
                 if(postionCategorylist.size()>0){
                        if(postionCategorylist[0] == brandPosName && postionCategorylist[1] == categoryName){
                                brandlst = utiltyObj.BrandPositionAndBrandMap.get(brandPos);
                        }
                 }
         }
         
          for(String bps : brandlst)
             listOfBrand.add(new selectOption(bps,bps));
        
         return listOfBrand;
     }  */
     
     
       public List<SelectOption> getBrandList(){      
        listOfBrand = new List<SelectOption>();
        system.debug('========>  '+selectedBrandPosName+' category name=====>'+selectedCategory);

        listOfBrand.add(new selectOption(NONE,NONE));

        //Set<String> brandlst = new Set<String>();
        Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        Set<MDO_BrandPositions__c> brandlst = utiltyObj.brandValues(selectedCategory,selectedBrandPosName);
        Set<String> brnadNameSet = new Set<String>();
        for(MDO_BrandPositions__c bps : brandlst){

            if(!brnadNameSet.contains(bps.brand_id__r.name)){
                listOfBrand.add(new selectOption(bps.brand_id__r.name,bps.brand_id__r.name));

                brnadNameSet.add(bps.brand_id__r.name);
            }
        }
        System.debug('LIST -> ' + listOfBrand);
        return listOfBrand;
    }

    public Pagereference updateJob(){
        List<MDO_BrandPositions__c> MDOBrandPositionslst =[select  brand_position_id__c,product_category_id__c,brand_id__c from MDO_BrandPositions__c where product_category_id__r.name = :categoryName AND brand_position_id__r.name = :brandPosName AND brand_id__r.name = :brandNameFromPage];
        system.debug('===list MDO'+MDOBrandPositionslst);
        
        if(categoryString == null){
                categoryString = new list<string>();
                Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
                Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
                System.debug('CAteLisgt' + categorylst);
                for(MDO_Category__c mdCat : categorylst){
                    categoryString.add(mdCat.name);
                }
        }
        /*if(projNameList == null){
                 projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
                 listString= new list<string>();
                 
                 listString.add(NONE);
                 For(Amr_Project_Details__c i : projNameList){
                    
                        listString.add(i.name);
                    
                 }
        }*/
        if(MDOBrandPositionslst.size()>0){
                        if(categoryName !=NONE){
                                system.debug('===list MDO Category'+MDOBrandPositionslst[0].product_category_id__c );
                        jobList.ProductCategory__c = MDOBrandPositionslst[0].product_category_id__c ;}
                        if(brandPosName!=NONE){
                                system.debug('===list MDO brand Post'+MDOBrandPositionslst[0].brand_position_id__c);
                        jobList.Brand_Position__c = MDOBrandPositionslst[0].brand_position_id__c ;}
                        if(brandNameFromPage!=NONE){
                                system.debug('===list MDO brand'+MDOBrandPositionslst[0].brand_position_id__c);
                        jobList.Brand_Final__c = MDOBrandPositionslst[0].brand_id__c ;
                        updateAdManagerText();
                        }
        }
        system.debug('selectedCountry!!'+selectedCountry);
        if(String.isNotBlank(selectedCountry)){
        Amr_CurrencyConversionRate__c currencyObject =[SELECT Currency_Unit__c,Name FROM Amr_CurrencyConversionRate__c WHERE Currency_Unit_To_Euro__c =:double.valueOf(selectedCountry) limit 1];
         
         String currencyFinalString = currencyObject.Name+'-'+currencyObject.Currency_Unit__c;
         jobList.Currency_Conversion_Country_List__c = currencyFinalString;
         selectedCountry = currencyFinalString;
        }
       
        validateJobList();
        if(validateSuccess){
        update jobList;
       
         PageReference pageRef = new PageReference('/apex/Amr_JobSheet');
         pageRef.getParameters().put('id',jobList.Id);
         pageRef.getParameters().put('tab','job-details');
         pageRef.getParameters().put('message', 'Successfully updated');
        // ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Successfully updated')); 
         pageRef.setRedirect(true);
         return pageRef; 
         }
         return null;
    }
    public Pagereference updateJobForNotes(){
     if(joblist.Job_Notes__c != null && joblist.Job_Notes__c != ''){
         List<Amr_Job_Allocation__c> jobAllocationList = [Select id, User__r.Name, User__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId ];
         List<Amr_Job_Allocation__c> jobAllocationListUpdate  = new  List<Amr_Job_Allocation__c>();
         update jobList;
         
         for(Amr_Job_Allocation__c objJobAllocation: jobAllocationList){
            objJobAllocation.Started__c = 'Yes';
            jobAllocationListUpdate.add(objJobAllocation);
         }
         update jobAllocationListUpdate;
         PageReference pageRef = new PageReference('/apex/Amr_JobSheet');
         pageRef.getParameters().put('id',jobList.Id);
         pageRef.getParameters().put('tab','notes');              
         pageRef.getParameters().put('message', 'Successfully updated');
         pageRef.setRedirect(true);
         return pageRef;
     }
    
     return null;
    }
    
    public void updateAdManagerText(){
        
        
        system.debug(brandNameFromPage+'brandNameFromPage !!'+jobList.Brand_Final__r.Name);
        //MDO_Brand__c jobBrand = [select Name from MDO_Brand__c  where Id =: brandNameFromPage];
       // system.debug(brandNameFromPage+'brandNameFromPage !!'+jobList.Brand_Final__r.Name);
        String adManText = jobList.AdManagerText__c;
        String adManTextUpdatedStr = adManText.Right(6);
        //String brandUpdatedNameStr =jobBrand.Name.left(3); 
        String brandUpdatedNameStr =brandNameFromPage.left(3); 
        String finalAdManagerNumber = brandUpdatedNameStr + adManTextUpdatedStr ;
        system.debug('finalAdManagerNumber !!'+finalAdManagerNumber+'adManText !!'+adManText +'adManTextUpdatedStr !!'+adManTextUpdatedStr +'brandUpdatedNameStr !!'+brandUpdatedNameStr  );
        jobList.AdManagerText__c = finalAdManagerNumber;
        
    }
    

    public pagereference recordShare(){
     
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
        }
        else{
             List<Amr_Job_Allocation__c> shareCheckList = [Select id, User__r.Name, User__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND User__c IN :listOfRAPSelected AND Is_Primary__c = false];
             Set<String> rapSet = new Set<String>();
             List<String> finalRapList = new List<String>();
             if(!shareCheckList.isEmpty()){
                for(Amr_Job_Allocation__c rapAlreadyShared : shareCheckList ){
                    String errorMsg = 'Job already Shared with ' + rapAlreadyShared.User__r.Name;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg));
                    rapSet.add(rapAlreadyShared.User__c);
                }
            }
           System.debug('SET -> ' + listOfRAPSelected);
            for(String raps : listOfRAPSelected){
                if(!rapSet.contains(raps)){
                    finalRapList.add(raps);
                                System.debug('INN IFF  ->>>> ' + finalRapList);
                }
            }
            System.debug('FINAL -> ' + finalRapList);
            List<Amr_Job_Details__share> listOfJobShare = new List<Amr_Job_Details__share>();
            List<Amr_Job_Allocation__c> listOfRAPJob = new List<Amr_Job_Allocation__c>();
            List<Amr_Job_Allocation__Share> listOfSharedAllocatedJob = new List<Amr_Job_Allocation__Share>();
            Amr_Job_Details__Share jobShr; 
            Amr_Job_Allocation__c jobAllocObj;
            Amr_Job_Allocation__Share jobAllocShare;
            System.debug('Finalll ->>>> ' + finalRapList);
            for (String eachSelectedUser :finalRapList)
            {
                system.debug('Value'+eachSelectedUser);      
                jobShr  = new Amr_Job_Details__share ();
                jobShr.ParentId = jobId;
                jobShr.UserOrGroupId = eachSelectedUser;
                jobShr.AccessLevel = 'Read';
                jobShr.RowCause = Schema.Amr_Job_Details__share.RowCause.Manual;  
                listOfJobShare.add(jobShr);
                
              
               jobAllocObj = new Amr_Job_Allocation__c();
               jobAllocObj.AM_Job_Detail__c = jobId;
               jobAllocObj.Is_Primary__c = FALSE;
               jobAllocObj.User__c = eachSelectedUser;  
               jobAllocObj.Job_Allocated__c= 'Yes';  
               jobAllocObj.Job_Shared__c  = 'Yes';       
               listOfRAPJob.add(jobAllocObj);

          }
          insert listOfJobShare;
          insert listOfRAPJob;
          System.debug('List Of Job Alloc -> ' + listOfRAPJob);
          System.debug('Job SHARE -> ' + listOfJobShare);
          for(Amr_Job_Allocation__c jAlloc : listOfRAPJob){
                 jobAllocShare = new Amr_Job_Allocation__Share();
                jobAllocShare.ParentId = jAlloc.id;
                jobAllocShare.UserOrGroupId = jAlloc.User__c;
                jobAllocShare.AccessLevel = 'Read';
                jobAllocShare.RowCause = Schema.Amr_Job_Details__share.RowCause.Manual;  
                listOfSharedAllocatedJob.add(jobAllocShare); 
          }
          System.debug('SHARING -> ' + listOfSharedAllocatedJob);
          insert listOfSharedAllocatedJob;
                  System.debug('INSERTED');
          List<User> userList = [Select id, email from User where Id IN :listOfRAPSelected];
          List<String> emailAddress = new List<String>();
          for(User userEmail : userList){
              emailAddress.add(userEmail.email);
          }
          List<Amr_Job_Allocation__c> rapNameList = [Select id, User__r.Name, User__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND User__c IN :finalRapList AND Is_Primary__c = false];
          for(Amr_Job_Allocation__c jAlloc : rapNameList ){
              String successMsg = 'Job shared successfully with '+ jAlloc.User__r.Name ;
              ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,successMsg ));
          }
          jobSharedList = [ select id, User__c, User__r.Name from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND Is_Primary__c = False order by User__r.Name];
          sharedListSize = jobSharedList.size();
          sharedOption(jobSharedList );
          system.debug('List Size ->  ' + sharedListSize );
          system.debug('List  ->  ' + jobSharedList );
      
   //  ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_JobShared)); 
    Amr_EmailSendingClass.emailSending(jobId, emailAddress, 'Amr_RAPSharedJob', new List<id>());
 
      PageReference pageRef = Page.amr_jobsheet;
     pageRef.getParameters().put('id',jobId);
     pageRef.setRedirect(true);
     return PageRef;
    // return null;   
    }  
     
   }
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
       new Amr_JobSheetController();
       PageReference pageRef = Page.amr_jobsheet;
     pageRef.getParameters().put('id',jobId);
     pageRef.setRedirect(true);
     return PageRef;
   }
   
   public PageReference validateJobList(){
        
                Boolean okayToSave = true;
                validateSuccess = false;
         if(jobList.Check_With_CMI__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Have you checked with CMI if there is an existing asset in the Millward Brown TV Ad Vitality Bank that could be utilised for this JTBD? : a radio button must be selected'));
        okayToSave =false;
        
        }
        
         if(jobList.Your_Email_Address__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Your email address : must follow the standard format of an email address, e.g. txt@txt.com'));
       okayToSave =false;
        } 
        if(jobList.Unilever_Finance_Member_Email__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unilever finance member email : must follow the standard format of an email address, e.g. txt@txt.com'));
        okayToSave =false;
        }
        if(jobList.Final_Approver_Of_Material_Email__c== null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Final approver of material email : must follow the standard format of an email address, e.g. txt@txt.com'));
       okayToSave =false;
        }
        if(String.isBlank(selectedCountry)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Budget allocated for this activity (enter all digits) : option must be selected from drop down'));
       okayToSave =false;
        }
        
        if(jobList.Budget_Allocated_Input_Value__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Budget allocated for this activity (enter all digits) : number must be entered'));
       okayToSave =false;
        }
        
         if( jobList.ProductCategory__c == null || categoryName == NONE){
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Category > Brand Positioning > Brand : option must be selected from all drop downs - Category, Brand Position & Brand Name'));
        okayToSave =false;
        }
         if( jobList.Brand_Position__c == null || brandPosName == NONE){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Category > Brand Positioning > Brand : option must be selected from all drop downs - Category, Brand Position & Brand Name'));
        okayToSave =false;
        }
         if(jobList.Brand_Final__c == null || brandNameFromPage == NONE){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Category > Brand Positioning > Brand : option must be selected from all drop downs - Category, Brand Position & Brand Name'));
        okayToSave =false;
        }
        
        if(jobList.Agency_Contact_Account_Director_Email__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Agency contact or account director email : must follow the standard format of an email address, e.g. txt@txt.com'));
       okayToSave =false;
        }
        if(jobList.Project_Description__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project description : text must be entered'));
       okayToSave =false;
        }
        if(jobList.Campaign_Name__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Campaign name : text must be entered'));
       okayToSave =false;
        }
        if(jobList.Target_Air_Date__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Target air date : a date must be selected from the calendar'));
       okayToSave =false;
        }
     //----     
       
       
        if(jobList.Project_Leader_Cluster__c == null || jobList.Project_Leader_Country__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Location of Unilever project leader : option must be selected from both market cluster and country drop downs'));
        okayToSave =false;
        }
        
        if(jobList.Function_You_Are_Part__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Which function are you part of (BD/BB/Other) : option must be selected from drop down'));
       okayToSave =false;
        }
        
        if(jobList.Budget_Responsibility__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Budget responsibility (BD, BB, Other) : option must be selected from drop down'));
        okayToSave =false;
        }
        if(jobList.Lead_Creative_Agency_name__c == null && jobList.Lead_Agency_Name_Other__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Lead agency name : option must be selected from the drop down menu OR a name must be entered in the "Other" text box'));
       okayToSave =false;
        }
        if(jobList.Lead_Agency_Location_Cluster__c == null || jobList.Lead_Agency_Location_Country__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Lead agency location : option must be selected from both market cluster and country drop downs'));
       okayToSave =false;
        }
        system.debug('jobList.Project_Details__c!!'+jobList.Project_Details__c);
       if(String.isBlank(jobList.Project_Details__c) && String.isBlank(jobList.Project_Name_Other__c)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project name (e.g. Apollo) : option must be selected from the drop down menu OR a name must be entered in the "Other" text box'));
      okayToSave =false;
        }
        if(jobList.Project_Location_Cluster__c == null || jobList.Project_Location_Country__c==null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project location : option must be selected from both market cluster and country drop downs'));
       okayToSave =false;
        }
        if(jobList.Production_Activity_Type__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'What type of activity will this production support? : one option must be selected from the drop down menu'));
       okayToSave =false;
        }
           // system.debug('jobDetails.Project_Description__c!!'+jobDetails.Project_Description__c+'jobDetails.Execution_Name__c!!'+jobDetails.Execution_Name__c);  
        
        if(String.isBlank(jobList.Project_Description__c)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project description : text must be entered'));
       okayToSave =false;
        }
        
        if(String.isBlank(jobList.Execution_Name__c)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Execution name : text must be entered'));
      okayToSave =false;
        }

         if(String.isBlank(jobList.Brodcast_Market__c)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Broadcast market : one option must be selected from the drop down menu'));
      okayToSave =false;
        }

        
        if(jobList.Require_Music__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Do you anticipate that your production will require Music? : a radio button must be selected'));
       okayToSave =false;
        }
        
        if(jobList.Require_Celebrity_Talent__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Do you anticipate that your production will require Celebrity Talent? : a radio button must be selected'));
       okayToSave =false;
        }
        if(jobList.Stage_of_Production_Activity__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Current stage of your production activity : option must be selected from drop down'));
       okayToSave =false;
        }
        
      if(!jobList.NewOriginalMaster__c && !jobList.LanguageAdaptionMaster__c && !jobList.Create_Additional_Material__c && !jobList.ReworkExistingMaterial__c && !jobList.BuyoutsTalent__c && !jobList.BuyoutsMusic__c ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Production activity types : at least one option must be selected'));
            okayToSave =false;
        }
        
        if(jobList.NewOriginalMaster__c && !jobList.NewOriginalMasterCinema__c && !jobList.NewOriginalMasterTv__c && 
            !jobList.NewOriginalMasterRadio__c && !jobList.NewOriginalMasterPrint__c && !jobList.NewOriginalMasterOutofHome__c &&
                !jobList.NewOriginalMasterInStore__c && !jobList.NewOriginalMasterDigital__c && !jobList.NewOriginalMasterInternalVideo__c ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
       
        
         if(jobList.NewOriginalMaster__c && jobList.NewOriginalMasterOutofHome__c && !jobList.NewOriginalMasterOutofHomeMovingImage__c && 
            !jobList.NewOriginalMasterOutofHomeAudio__c && !jobList.NewOriginalMasterOutofHomeStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false; 
        }
        
        
        if(jobList.NewOriginalMaster__c && jobList.NewOriginalMasterInStore__c && !jobList.NewOriginalMasterInStoreMovingImage__c && 
            !jobList.NewOriginalMasterInStoreAudio__c && !jobList.NewOriginalMasterInStoreStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
           
        if(jobList.NewOriginalMaster__c && !jobList.NewOriginalMasterCinema__c && !jobList.NewOriginalMasterTv__c && 
            !jobList.NewOriginalMasterRadio__c && !jobList.NewOriginalMasterPrint__c && !jobList.NewOriginalMasterOutofHome__c &&
                !jobList.NewOriginalMasterInStore__c && !jobList.NewOriginalMasterDigital__c && !jobList.NewOriginalMasterInternalVideo__c ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
        
      
         if(jobList.NewOriginalMaster__c && jobList.NewOriginalMasterOutofHome__c && !jobList.NewOriginalMasterOutofHomeMovingImage__c && 
            !jobList.NewOriginalMasterOutofHomeAudio__c && !jobList.NewOriginalMasterOutofHomeStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
        
        if(jobList.NewOriginalMaster__c && jobList.NewOriginalMasterInStore__c && !jobList.NewOriginalMasterInStoreMovingImage__c && 
            !jobList.NewOriginalMasterInStoreAudio__c && !jobList.NewOriginalMasterInStoreStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
          if(jobList.NewOriginalMaster__c && jobList.NewOriginalMasterDigital__c && !jobList.NewOriginalMasterDigitalMovingImage__c && 
            !jobList.NewOriginalMasterDigitalAudio__c && !jobList.NewOriginalMasterDigitalStillImage__c  
            && !jobList.New_Original_Master_Digital_ED__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
        if(!jobList.NewOriginalMaster__c && jobList.LanguageAdaptionMaster__c && !jobList.LanguageAdaptionMasterTv__c && 
            !jobList.LanguageAdaptionMasterCinema__c && !jobList.LanguageAdaptionMasterRadio__c 
            && !jobList.LanguageAdaptionMasterPrint__c && 
                !jobList.LanguageAdaptionMasterOutofHome__c && 
                !jobList.LanguageAdaptionMasterInStore__c && 
                !jobList.LanguageAdaptionMasterDigital__c &&
                !jobList.LanguageAdaptionMasterInternalVideo__c ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected'));
            okayToSave =false;
        }
        
    
    
        
         if(!jobList.NewOriginalMaster__c && jobList.LanguageAdaptionMaster__c && jobList.LanguageAdaptionMasterOutofHome__c && 
            !jobList.LanguageAdaptionMasterOutofHomeAudio__c && 
            !jobList.LanguageAdaptionMasterOutHomeStillImage__c && 
            !jobList.LanguageAdaptionMasterOutHomeMovingImage__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
         if(!jobList.NewOriginalMaster__c && jobList.LanguageAdaptionMaster__c && jobList.LanguageAdaptionMasterInStore__c && 
            !jobList.LanguageAdaptionMasterInStoreAudio__c && 
            !jobList.LanguageAdaptionMasterInStoreMovingImage__c && 
            !jobList.LanguageAdaptionMasterInStoreStillImage__c 
            
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
        if(!jobList.NewOriginalMaster__c && jobList.LanguageAdaptionMaster__c && jobList.LanguageAdaptionMasterDigital__c && 
            !jobList.LanguageAdaptionMasterDigitalAudio__c && 
            !jobList.LanguageAdaptionMasterDigitalMovingImage__c && 
            !jobList.LanguageAdaptionMasterDigitalStillImage__c && !jobList.Language_Adaptation_of_Master_Digital_ED__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
        
        
        if(!jobList.NewOriginalMaster__c && jobList.Create_Additional_Material__c && jobList.AdditionalSupplementaryNewMaterialOOH__c && 
            !jobList.AdditionalSupplementaryNewMaterialOofHMI__c && 
            !jobList.AdditionalSupplementaryNewMaterialOofHSI__c && 
            !jobList.AdditionalSupplementaryNewMaterialOofHA__c  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
            if(!jobList.NewOriginalMaster__c && jobList.Create_Additional_Material__c && jobList.AdditionalSupplementaryNewMaterialStore__c && 
            !jobList.AdditionalSupplementaryNewMaterialInSMI__c && 
            !jobList.AdditionalSupplementaryNewMaterialInSA__c && 
            !jobList.AdditionalSupplementaryNewMaterialInSSI__c  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
        
            if(!jobList.NewOriginalMaster__c && jobList.Create_Additional_Material__c && jobList.AdditionalSupplementaryNewMaterialDigi__c && 
            !jobList.AdditionalSupplementaryNewMaterialDigiMI__c && 
            !jobList.AdditionalSupplementaryNewMaterialDigiA__c && 
            !jobList.AdditionalSupplementaryNewMaterialDigiSI__c  &&
            !jobList.Digital_Editorial__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
            if(!jobList.NewOriginalMaster__c && jobList.Create_Additional_Material__c &&  
            !jobList.AdditionalSupplementaryNewMaterialStore__c && 
            !jobList.AdditionalSupplementaryNewMaterialDigi__c &&
            !jobList.AdditionalSupplementaryNewMaterialTv__c &&
            !jobList.AdditionalSupplementaryNewMaterialCinema__c &&
            !jobList.AdditionalSupplementaryNewMaterialRadio__c &&
            !jobList.AdditionalSupplementaryNewMaterialOOH__c &&
            !jobList.AdditionalSupplementaryNewMaterialIVideo__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
        
            if(!jobList.NewOriginalMaster__c && jobList.ReworkExistingMaterial__c && jobList.ReworkExistingMaterialOutofHome__c && 
            !jobList.ReworkExistingMaterialOutHomeMovingImage__c && 
            !jobList.ReworkExistingMaterialOutofHomeAudio__c && 
            !jobList.ReworkExistingMaterialOutHomeStillImage__c
            
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
        
            if(!jobList.NewOriginalMaster__c && jobList.ReworkExistingMaterial__c && jobList.ReworkExistingMaterialInStore__c && 
            !jobList.ReworkExistingMaterialInStoreMovingImage__c && 
            !jobList.ReworkExistingMaterialInStoreAudio__c && 
            !jobList.In_Store_Still_Image__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
        
            if(!jobList.NewOriginalMaster__c && jobList.ReworkExistingMaterial__c && jobList.ReworkExistingMaterialDigital__c && 
            !jobList.ReworkExistingMaterialDigitalMovingImage__c && 
            !jobList.ReworkExistingMaterialDigitalAudio__c && 
            !jobList.ReworkExistingMaterialDigitalStillImage__c  &&
            !jobList.Rework_Exisiting_Material_Digital_ED__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
        if(!jobList.NewOriginalMaster__c && jobList.ReworkExistingMaterial__c && !jobList.ReworkExistingMaterialOutofHome__c && 
            !jobList.ReworkExistingMaterialInStore__c && 
            !jobList.ReworkExistingMaterialDigital__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
        
        
            if(!jobList.NewOriginalMaster__c && jobList.BuyoutsTalent__c && jobList.BuyoutsTalentOutofHome__c && 
            !jobList.BuyoutsTalentOutofHomeMovingImage__c && 
            !jobList.BuyoutsTalentOutofHomeAudio__c && 
            !jobList.BuyoutsTalentOutofHomeStillImage__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
        
            if(!jobList.NewOriginalMaster__c && jobList.BuyoutsTalent__c && jobList.BuyoutsTalentInStore__c && 
            !jobList.BuyoutsTalentInStoreMovingImage__c && 
            !jobList.BuyoutsTalentInStoreAudio__c && 
            !jobList.BuyoutsTalentInStoreStillImage__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Medium must be selected corresponding to In Store' ));
            okayToSave =false;
        }
        
        
        
            if(!jobList.NewOriginalMaster__c && jobList.BuyoutsTalent__c && jobList.BuyoutsTalentDigital__c && 
            !jobList.BuyoutsTalentDigitalMovingImage__c && 
            !jobList.BuyoutsTalentDigitalAudio__c && 
            !jobList.BuyoutsTalentDigitalStillImage__c &&
            !jobList.Buyouts_Talent_Digital_ED__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
          if(!jobList.NewOriginalMaster__c && jobList.BuyoutsTalent__c && !jobList.BuyoutsTalentOutofHome__c && 
            !jobList.BuyoutsTalentInStore__c && 
            !jobList.BuyoutsTalentDigital__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
        
        
        
            if(!jobList.NewOriginalMaster__c && jobList.BuyoutsMusic__c && jobList.BuyoutsMusicOutofHome__c && 
            !jobList.BuyoutsMusicOutofHomeMovingImage__c && 
            !jobList.BuyoutsMusicOutofHomeAudio__c && 
            !jobList.BuyoutsMusicOutofHomeStillImage__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
            if(!jobList.NewOriginalMaster__c && jobList.BuyoutsMusic__c && !jobList.BuyoutsMusicInStore__c && 
            !jobList.BuyoutsMusicDigital__c && 
            !jobList.BuyoutsMusicTv__c &&
            !jobList.BuyoutsMusicCinema__c &&
            !jobList.BuyoutsMusicRadio__c &&
            !jobList.BuyoutsMusicInternalVideo__c &&
            !jobList.BuyoutsMusicOutofHome__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
        
            if(!jobList.NewOriginalMaster__c && jobList.BuyoutsMusic__c && jobList.BuyoutsMusicInStore__c && 
            !jobList.BuyoutsMusicInStoreMovingImage__c && 
            !jobList.BuyoutsMusicInStoreAudio__c && 
            !jobList.BuyoutsMusicInStoreStillImage__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
        
        
            if(!jobList.NewOriginalMaster__c && jobList.BuyoutsMusic__c && jobList.BuyoutsMusicDigital__c && 
            !jobList.BuyoutsMusicDigitalMovingImage__c && 
            !jobList.BuyoutsMusicDigitalAudio__c && 
            !jobList.BuyoutsMusicDigitalStillImage__c  &&
            !jobList.Buyouts_Music_Digital_ED__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        

       
        
        if(okayToSave) {
                validateSuccess = true;
                return null;
        }
   return null;
   }
   
   public void uploadDocument(){
    
            system.debug('inside upload!!'+document+'jobIdFromPage!!'+jobIdFromPage);
              if(document.body==null){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select atleast one document'));
               // return null;
              }
                 
                  if(document.body!=null && jobIdFromPage != null){           
              system.debug(document+'--------document Body'+document.body);
             /* List<Folder> FolderId = [SELECT Id,Name FROM Folder where name = 'Brief'];
              system.debug('FolderId !!'+FolderId);
              document.FolderId = FolderId[0].Id;
              insert document;*/
                                   
              FeedItem FI = new FeedItem();
              FI.ParentId = jobIdFromPage;
              FI.Body = 'Attachment added';
              FI.ContentData = document.body;
              FI.ContentFileName = document.Name;
              
              insert FI;
              getDocuments();
              system.debug('====>feed'+FI);
              document = new document();
        }
            
        
      //  return null;
    }
    
    public void getDocuments(){
    
       documentList= [select ContentFileName,relatedrecordid,createdDate from FeedItem where ParentId =:jobIdFromPage];  //ContentFileName,
    }
     public Pagereference deleteDocuments(){
               
        FeedItem doc =[select Id from FeedItem where Id=:chosenDocId limit 1];
        system.debug('object delete!!'+doc);
        delete doc ;
        system.debug('deleted!!!!!'+chosenDocId);
        getDocuments();
        return null;
    }
    
     public void addNewAlert(){

         alertObj.Job_Id__c  = jobIdFromPage ;
        System.debug('Alert -> ' + alertObj);
        if(alertObj.New_Alert__c == null || alertObj.Alert_Message__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter both alert date and alert message'));
            
        }
        if(alertObj.New_Alert__c < Date.today()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Alert date must be greater than or equal to today\'s date'));
        }
        if(alertObj.Alert_Message__c.length()>100){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Alert message should be less than 100 characters'));
        }
        if(!String.isBlank(String.valueOf(alertObj.New_Alert__c)) && !String.isBlank(alertObj.Alert_Message__c) && alertObj.New_Alert__c >= Date.today() && alertObj.Alert_Message__c.length()<=100){
         insert alertObj;
         alert = [SELECT Alert_Message__c,job_Id__r.AdManagerText__c,New_Alert__c,Job_Id__c FROM Amr_Alert__c where hide__c = :false AND Job_Id__c  = :jobIdFromPage AND ownerId = :userInfo.getUserID() order by New_Alert__c desc];
         totalAlertCount =  [select count() from Amr_Alert__c where ownerId =:userInfo.getUserId() AND Hide__c =:false AND Job_Id__c  = :jobIdFromPage];
       alertObj = new Amr_Alert__c();
       }   
    //    return null;
    }
     public void alertHide(){
            
            System.debug('Alert Id -> ' + selectedAlert);
            
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

    public PageReference jobSheetPageTransfer(){
          
           PageReference pageRef = new PageReference('/apex/Amr_JobSheet');
           pageRef.getParameters().put('id',chosenId);
           pageRef.setRedirect(true);
           return pageRef;
       }
}