/**********************************************************************  
Name:  Amr_AdManagerController_CC ()  Copyright © 2015  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------   This class is holds the  business logic for Creation Of New Saving,Quote and Accepted Quote.                                                         
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION   AUTHOR                        DATE              DETAIL                    Description    
 1.0       Mindtree                  04/02/2016      INITIAL DEVELOPMENT            CSR: 
 ***********************************************************************/
public with sharing class Amr_AdManagerController_CC{

    public Amr_Job_Details__c jobDetails{get;set;}
    public Amr_Logging_Form_Setting__c r  {get; set;}
    public String selectedCountry {get;set;}
    public String projectNameFromPage{get;set;}
    public String productionActivityData {get;set;}
    public List<selectOption> currencyRecords {
        get {
            List<selectOption> options = new List<selectOption>();
            List<selectOption> optionsNew = new List<selectOption>();
            options.add(new SelectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));
            List<Amr_CurrencyConversionRate__c> lstcov = Amr_CurrencyConversionRate__c.getAll().values();
            System.debug('Currency List Size --> ' + lstcov.size());
            lstcov.sort();
            
            Map<String,String> mapAmountToCurrency = new Map<String,String>();
        
            for (Amr_CurrencyConversionRate__c cc: lstcov){
                if( (cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c == Amr_ConstantForAdManager.USA_US) ||  (cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c == Amr_ConstantForAdManager.UK ) || (cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c == Amr_ConstantForAdManager.EEC_Euro)){
                    mapAmountToCurrency.put(cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c , String.valueOf(cc.Currency_Unit_To_Euro__c));
                    options.add(new SelectOption(String.valueOf(cc.Currency_Unit_To_Euro__c),cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c));
                    continue;
                }   
                else{
                    optionsNew.add(new SelectOption(String.valueOf(cc.Currency_Unit_To_Euro__c),cc.Name+Amr_ConstantForAdManager.DASH+cc.Currency_Unit__c));
                }
                //€ (EEC), £(UK), $(US)
            }
             options.addAll(optionsNew);
            
            return options;

        }
        set;
    }

   
    public String categoryName{get;set;}
    public String brandPosName{get;set;}
    public String brandNameFromPage{get;set;} 
    public List<SelectOption> listOfCategory{get;set;} 
    public List<SelectOption> listOfBrandPosition{get;set;}
    public List<SelectOption> listOfBrand{get;set;}
   
    public List<Amr_Project_Details__c> projNameList {get;set;}
    public String[]  listString{get;set;}
    public String[]  categoryString{get;set;}
    public String UserLoginId{get;set;}
    public List<PermissionSetAssignment> PermissionSetAssignmentList{get;set;}
    public boolean flag{get;set;}
    public boolean display{get;set;}
    public boolean displayRap{get;set;}
    public String CheckWithCMI{get;set;}

    public Amr_AdManagerController_CC(){
        try{
            Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
            jobDetails = new Amr_Job_Details__c();
            r = [SELECT Introduction__c, Header__c, Footer__c, Allocation__c, Automatic_Allocation_On__c FROM Amr_Logging_Form_Setting__c LIMIT 1];
            projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];

            listString = new list<string>();
            categoryString = new list<string>();
            listString.add(Amr_ConstantForAdManager.NONE);
            
            for(Amr_Project_Details__c i : projNameList){
                listString.add(i.name);
            }
            
            Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
            for(MDO_Category__c mdCat : categorylst){
                categoryString.add(mdCat.name);
            }

            listOfBrandPosition = new List<SelectOption>();
            listOfBrandPosition.add(new selectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));
            system.debug('inside constructor ===>'+listOfBrandPosition);
        
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }

    public void updateSetting(){
        update r;       
    }


    
   /*******************************************************************    
   Purpose:  This method is used to get Category Values                                                       
   Parameters: 
   Returns: It’s return String

   ********************************************************************/ 

    public String getCategoryList(){ 
      
        return JSON.serialize(categoryString);
    }
    
        
   /*******************************************************************    
   Purpose:  This method is used to get Project Name                                                     
   Parameters: 
   Returns: It’s return String

   ********************************************************************/ 
    
    public String getMethodToPassProjectNames(){
       
        return JSON.serialize(listString);
    }
    
    /*******************************************************************    
   Purpose:  This method is used to get Brand Position Data                                                 
   Parameters: 
   Returns: It’s return PageReference

   ********************************************************************/ 
    public PageReference  brandPositionListData(){  
        try{  
           
            Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
            Set<MDO_BrandPositions__c> brandPositionlst = utiltyObj.brandPostitionValues(categoryName);
            Set<String> brnadPosNameSet = new Set<String>();
            system.debug('inside brand postition======>'+listOfBrandPosition);
            for(MDO_BrandPositions__c bps : brandPositionlst){
                if(!brnadPosNameSet.contains(bps.brand_position_id__r.name)){
                    listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));
                    brnadPosNameSet.add(bps.brand_position_id__r.name);
                }
            }
           }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
        
        return null;

    }
    
    /*******************************************************************    
   Purpose:  This method is used to get Brand Data                                                 
   Parameters: 
   Returns: It’s return optionValue

   ********************************************************************/ 
    public List<SelectOption> getBrandList(){  
        try{    
            listOfBrand = new List<SelectOption>();
            listOfBrand.add(new selectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));
        
            Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
            Set<MDO_BrandPositions__c> brandlst = utiltyObj.brandValues(categoryName,brandPosName);
            Set<String> brnadNameSet = new Set<String>();
            
            for(MDO_BrandPositions__c bps : brandlst){
                if(!brnadNameSet.contains(bps.brand_id__r.name)){
                    listOfBrand.add(new selectOption(bps.brand_id__r.name,bps.brand_id__r.name));
                    brnadNameSet.add(bps.brand_id__r.name);
                }
            }
            
            return listOfBrand;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
            return null;
        }
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
    public boolean successmessage{get;set;}
    
    /*******************************************************************    
   Purpose:  This method is used to validate job Values                                            
   Parameters: 
   Returns: It’s return Pagereference
   N-Path:
   Thismethod creates new AdManager record in Amr_JobDetails object. 
   All user validations has to be checked after Submit only so there are around 50+ user values validations reuired, which can not be break down into mulitiple classes.
   ********************************************************************/ 
    public Pagereference getSubmitForm(){
        try{
            Amr_AdManagerHelper_CC admanagerHelper = new Amr_AdManagerHelper_CC();
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
            //ProjectDescriptionFlag = false;
            ExecutionNameFlag = false;
            BrodcastMarketFlag = false;
            RequireMusicFlag = false;
            RequireTalentFlag = false;
            StageProductionActivity = false;
            successmessage = true;
            CheckWithCMI = Amr_ConstantForAdManager.FILL_INFO;
            
            
            Boolean okayToSave = true;
            if(jobDetails.Project_Details__c!=null){
              Amr_Project_Details__c projectObj = [select id,name from Amr_Project_Details__c where id = :jobDetails.Project_Details__c ];
              projectNameFromPage = projectObj.name;
            
            }
         
            jobDetails.ProductionActivityTextArea__c = productionActivityData;
            
            /*
            N-Path:
            Mandatory user input is validated and require to set respective variable in order to display error message
            respective field level on page.
            */
            if(jobDetails.Check_With_CMI__c == null){      
                CheckWithCMIflag = true;     
            }
            
            if(jobDetails.Your_Email_Address__c == null){
                yourEmailAddressFlag = true;
            } 
          
            if(jobDetails.Unilever_Finance_Member_Email__c == null){
                unileverFinanceMemberEmailFlag = true;    
            }
            
            if(jobDetails.Final_Approver_Of_Material_Email__c== null){
                finalApproverMaterialEmailFlag = true;
                
            }
           
            if((String.isBlank(selectedCountry)|| selectedCountry == Amr_ConstantForAdManager.NONE)){
                budgetAllocatedCountryFlag = true;
                
            }
            if(jobDetails.Budget_Allocated_Input_Value__c == null){
                budgetAllocatedInputFlag =  true;
                
            }
            
            if(categoryName == Amr_ConstantForAdManager.NONE){
                
                categoryNameFlag = true;
                
            }
            if(brandPosName == Amr_ConstantForAdManager.NONE){
                brandPosNameFlag = true;
                
            }
            if(brandNameFromPage == Amr_ConstantForAdManager.NONE){
                brandNameFromPageFlag = true;
               
            }
            if(jobDetails.Agency_Contact_Account_Director_Email__c == null){
                AgencyDirectorEmailFlag = true;
                
            }
            if(jobDetails.Project_Description__c == null){
                ProjectDescriptionFlag = true;
               
            }
            if(jobDetails.Campaign_Name__c == null){
                CampaignNameFlag = true;
                
            }
            if(jobDetails.Target_Air_Date__c == null){
                TargetAirDateFlag = true;
               
            }
            
            if(jobDetails.Project_Leader_Cluster__c == null || jobDetails.Project_Leader_Country__c == null){
                projectLeaderCountryClusterFlag = true;
              
            }
            
            if(jobDetails.Function_You_Are_Part__c == null){
                FunctionYouArePartFlag = true;
               
            }
            
            if(jobDetails.Budget_Responsibility__c == null){
                budgetResponsibilityFlag = true;
               
            }
            
            if(jobDetails.Lead_Creative_Agency_name__c == null && jobDetails.Lead_Agency_Name_Other__c == null){
                leadAgencyFlag = true;
                
            }
            if(jobDetails.Lead_Agency_Location_Cluster__c == null || jobDetails.Lead_Agency_Location_Country__c == null){
                LeadAgencyClusterFlag = true; 
                
            }
            if(String.isBlank(jobDetails.Project_Details__c) && String.isBlank(jobDetails.Project_Name_Other__c) ){
                projectDetailsFlag = TRUE;
               // projectNameFromPage = null;
               
            }
            
            if(jobDetails.Production_Activity_Type__c == null){
                productionActivityTypeFlag = true;
               
            }
        
            if(String.isBlank(jobDetails.Project_Description__c)){
                ProjectDescriptionFlag = true;
                
            }
            if(String.isBlank(jobDetails.Execution_Name__c)){
                ExecutionNameFlag = true;
                
            }
            if(String.isBlank(jobDetails.Brodcast_Market__c)){
                BrodcastMarketFlag = true;
                
            }
            if(jobDetails.Require_Music__c == null){
                RequireMusicFlag = true;
                
            }
            if(jobDetails.Require_Celebrity_Talent__c == null){
                RequireTalentFlag = true;
               
            }
            if(jobDetails.Stage_of_Production_Activity__c == null){
                StageProductionActivity = true;           
            }
            //okayToSave = admanagerHelper.productionActivityTypeValidation(jobDetails);
           
            if( !okayToSave || CheckWithCMIflag || yourEmailAddressFlag || unileverFinanceMemberEmailFlag || projectLeaderCountryClusterFlag || finalApproverMaterialEmailFlag || functionYouArePartFlag
                 || budgetResponsibilityFlag || budgetAllocatedCountryFlag || budgetAllocatedInputFlag || categoryNameFlag || brandPosNameFlag || brandNameFromPageFlag || agencyDirectorEmailFlag
                 || projectDescriptionFlag || campaignNameFlag || leadAgencyFlag || LeadAgencyClusterFlag || projectDetailsFlag || productionActivityTypeFlag 
                 || ExecutionNameFlag ||TargetAirDateFlag || BrodcastMarketFlag || RequireMusicFlag || RequireTalentFlag || StageProductionActivity) {
           
                successmessage = false;
                return null;
            }
    
            admanagerHelper.createJob(selectedCountry,categoryName,brandPosName,brandNameFromPage,jobDetails,projectNameFromPage,listOfBrand);
            jobDetails = new Amr_Job_Details__c();
            selectedCountry =Amr_ConstantForAdManager.NONE;
            categoryName =Amr_ConstantForAdManager.NONE;
            brandPosName =Amr_ConstantForAdManager.NONE;
            brandNameFromPage =Amr_ConstantForAdManager.NONE;
            projectNameFromPage = Amr_ConstantForAdManager.NONE;
            listOfBrandPosition = new List<SelectOption>();
            listOfBrandPosition.add(new selectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
            return null;

    }
    /*******************************************************************    
   Purpose:  This method is used to to check validation of production activity type                                 
   Parameters: 
   Returns: It’s return Pagereference
   ********************************************************************/ 
    
    
    
  
    
    /*******************************************************************    
   Purpose:  This method is used to allocate job to RAP                                         
   Parameters: 
   Returns: It’s return Nothing
   ********************************************************************/ 
    public static void insertJobAllocationData(String jobId, String userId, String emailIdToAllocate){
        try{
            Amr_Job_Allocation__c jobAlloc = new Amr_Job_Allocation__c();
            jobAlloc.AM_Job_Detail__c = jobId;
            jobAlloc.Is_Primary__c = TRUE ; 
            jobAlloc.User__c = userId;
            jobAlloc.Job_Allocated__c = Amr_ConstantForAdManager.YES;
            insert jobAlloc;
           
            
            Amr_Job_Details__c jobDetails = new Amr_Job_Details__c(Id= jobId , ownerId = userId, JobAllocated_Email__c = emailIdToAllocate);
            update jobDetails; 
           
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }
    
   
   
   
    
   
    
    
    /*******************************************************************    
   Purpose:  This method is used to redirect to page denpending on who has logged in RAP OR CAP                                 
   Parameters: 
   Returns: It’s return Nothing
   ********************************************************************/ 


    public PageReference Redirect(){
        try{
            String sessionIdVal = userinfo.getSessionId();
            UserLoginId = userinfo.getuserid();  
            User userObj = [select id,SessionId__c from User where id = :UserLoginId];
            PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id,PermissionSet.Name from PermissionSetAssignment where (PermissionSet.Name = :Label.Amr_CAP OR PermissionSet.Name = :Label.Amr_RAP OR PermissionSet.Name = :Label.Amr_AdManager) order by Assignee.name];
            system.debug('------>PermissionSetAssignmentList=='+PermissionSetAssignmentList );
            PageReference pageRef =null;
            flag = false;
            display = false;
            displayRap = false;
            system.debug(userObj.SessionId__c +'======'+sessionIdVal);
            
            for(PermissionSetAssignment permissionObject:PermissionSetAssignmentList ){
                system.debug('=======>'+permissionObject.PermissionSet.Name);
                
          //      if(permissionObject.PermissionSet.Name == Label.Amr_CAP && permissionObject.Assignee.id == UserLoginId && (userObj.SessionId__c == null || userObj.SessionId__c != sessionIdVal)){
                          if(permissionObject.PermissionSet.Name == Label.Amr_CAP && permissionObject.Assignee.id == UserLoginId && (userObj.SessionId__c == null || userObj.SessionId__c != sessionIdVal)){
                    system.debug('inside cap==>');
        
                    pageRef = Page.Amr_CAPJobPortfolio;
                    pageRef.setRedirect(true);
                    userObj.SessionId__c = sessionIdVal;
                
                                } 
         //       if(permissionObject.PermissionSet.Name == Label.Amr_RAP && permissionObject.Assignee.id == UserLoginId && (userObj.SessionId__c == null || userObj.SessionId__c != sessionIdVal)){
                          if(permissionObject.PermissionSet.Name == Label.Amr_RAP && permissionObject.Assignee.id == UserLoginId && (userObj.SessionId__c == null || userObj.SessionId__c != sessionIdVal)){
                    system.debug('inside RAP==>');
    
                    pageRef = Page.Amr_RAPJobPortfolio;
                    pageRef.setRedirect(true);
                    userObj.SessionId__c = sessionIdVal;
                }
            }
            update userObj;
            if(pageRef != null){
                return pageRef;
            }
   
            PageReference pageRef1 = Page.Amr_AdManager;
            pageRef1.setRedirect(true);
            return null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
            return null;
        }
    }
    
    public void prodActivity(){
       
       
        System.debug('PRod -> ' + productionActivityData);
        
    }
    
}