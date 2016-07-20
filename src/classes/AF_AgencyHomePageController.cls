/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_AgencyHomePageController 
   @CreateDate : 3/6/2014
   @Description : This is a controller class for AgencyHomePage Page, 
   @              this is used to display the BrandEstimate details in the Homepage.
   @Version : 1.0
   @reference : none  
  ****************************************************************************************************************************/
public with sharing class AF_AgencyHomePageController {
    public Boolean IsCMCO{get;set;} //Check CMCO super user
    public Boolean IsFinance{get;set;}// Check Cat. Finance user
    public Boolean IsProcurement{get;set;}
    public Boolean IsController{get;set;}
    public Boolean IsCatFinanceRegional{get;set;}
    public string  financialYear{get;set;} //To get selected financial Year
    public string  categoryStr{get;set;} // To get selected category value
    public string  categoryNameStr{get;set;} // To get selected category Name on the page
    public Decimal totalUnileverFee {get;set;} //To display overall Unilever Base fees
    public Decimal totalAgencyFee {get;set;} //To display overall Agency Base fees
    public Decimal totalCroBordFee {get;set;} //To display overall Cross Border fees
    public Decimal totalTraditionalFee {get;set;} //To display overall Traditional fees
    public Decimal totalDigitalFee {get;set;} //To display overall Digital fees
    public Decimal totalAdaptiveFee {get;set;} //To display overall Adaptive fees
    public Integer crosPerStr {get;set;} //To display CrossBorder Percentage
    public Integer tradPerStr {get;set;} //To display Traditional Percentage 
    public Integer digitPerStr {get;set;} //To display Digital Percentage 
    public Integer adaptPerStr {get;set;} //To display Adaptive Percentage 
    public Decimal tradDecimalPerStr{get;set;}
    public Decimal digitDecimalPerStr{get;set;}
    public Decimal adaptDecimalPerStr{get;set;}
    public list<selectOption> categoryOptionList = new list<selectOption>(); //to store category option values
    public boolean isNotCurrentFy {get ;set;}
    public string CategoryId{get;set;} //to pass category Id in the url string
    public boolean isAgencyFlag{get;set;} //to check wether logged in user is partner user or not
    public String AgencyAccountName{get;set;} //Used for Agency User
    public List<AF_Agency_Estimate__c> agencyPortalUserList{get;set;} //Used for Agency User
    public set<String> brandList;  // this is used to store Brand list from User for Agency users
    public boolean isCMCOSuperFlag{get;set;} // to check whether logged in user is CMCO Super User or not
    public boolean isNonCMCONFinFlag {get;set;} //for Regional Category Finance, Controller and Procurement
    public boolean isBonusQuartFlag{get;set;} //for Agency users
    public boolean isBonusYearFlag{get;set;} //for Agency users
    public boolean isbatchcopy{set;get;} // For showing 'batch job copy' button for cmco
    public boolean isSelectedBrand{set;get;}
    public List<SelectOption> selectedbrandList{get;set;}
    public String selectedBrandOption{get;set;}
    public String selectedBrandValue{get;set;}
    public List<AF_BonusQuarterly_Quarterdates__c> bonusQuarterlyDateList{get;set;}
    public Boolean IsCMCOFinance{get;set;}
    map<Id,AF_Brand_Estimate__c> brandEstMap;
    set<Id> agencySetId;
    map<String, AF_Brand_Estimate__c> uniqueBrandEstMap;
    Boolean bonusDate;
    Boolean bonusDateQ2;
    Boolean bonusDateQ3;
    private static string className_STR=AF_AgencyHomePageController.class.getName();
  
    /**********************************************************************
*  @Description: Contructor method
*  @name : AgencyHomePageController
*  @param : none
*  @return : none
*************************************************************************/
    public AF_AgencyHomePageController()
    {
        string category_name_url=ApexPages.CurrentPage().getParameters().get(AF_Constants.CATEGORY);
        string year_url=ApexPages.CurrentPage().getParameters().get(AF_Constants.YEAR);
        String Selectbrandval_url=ApexPages.CurrentPage().getParameters().get(AF_Constants.BRANDVALUE);
        IsCMCO=false;
        IsFinance=false;
        IsProcurement=false;
        IsController=false;
        IsCatFinanceRegional=false;
        isAgencyFlag=false;
        isCMCOSuperFlag=false;
        isNonCMCONFinFlag=false;
        isBonusQuartFlag=false;
        isBonusYearFlag=false;
        isbatchcopy = false;
        IsCMCOFinance = false;
        set<String> categoryList = new set<String>();
        brandList = new set<String>();
        id userId=UserInfo.getUserId();
        selectedbrandList = new List<SelectOption>();
        brandEstMap= new map<Id,AF_Brand_Estimate__c>();
        agencySetId = new set<Id>();
        uniqueBrandEstMap = new map<String, AF_Brand_Estimate__c>();
        List<PermissionSetAssignment> permissionSetAssign =[select PermissionSet.Name from PermissionSetAssignment where Assignee.Id = :userId and (PermissionSet.Name like'%CMCO%' or PermissionSet.Name like'%Category%' or PermissionSet.Name like'%Agency%' or PermissionSet.Name like'%Procurement%' or PermissionSet.Name like'%Controllers%')  order by PermissionSet.Name];
        checkLoggedUserPermissionSet(permissionSetAssign);
    
        User userObj = new User();
        userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
        AgencyAccountName=userObj.Contact.Account.Name;          
        List<PermissionSetAssignment> userPermissionSet =    [SELECT Id, PermissionSet.Label,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId()];
        //check all category assigned to user and store it in list
        if(userObj.AF_Category__c!=null){
            for(String str :userObj.AF_Category__c.split(';')){
                categoryList.add(str);
            }
        }
        //check all Brands assigned to user and store it in list
        if(userObj.AF_Brand__c!=null){
            for(String str :userObj.AF_Brand__c.split(';')){
                brandList.add(str);
            }
        }
        //to display review for Agency
        //Add Brands to DropDown
        selectedbrandList=getBrandsOption();
        if(!selectedbrandList.isEmpty()){
            selectedBrandOption = selectedbrandList.get(0).getValue();
            //Setting default values for Brand Option
            Boolean isCategoryFinance = false;
            for(PermissionSetAssignment permSet : userPermissionSet)
            {
                if(permSet.PermissionSet.Label == AF_Constants.UT_CATEGORY_FINANCE) 
                {
                    isCategoryFinance = true;
                }
            }    
            if(isCategoryFinance)
            {
                selectedBrandOption = selectedbrandList.get(0).getValue();
            }
            else
            {    
                selectedBrandOption = selectedbrandList.get(1).getValue();
            }
            selectedBrandValue = selectedBrandOption;
        }
        // Brands as my brand and all brand from url parameter
        if(Selectbrandval_url!=null){
            selectedBrandValue=Selectbrandval_url;
            selectedBrandOption=Selectbrandval_url;
        }
    checkLoggedUserType(userObj);
        
        //Iterate each record to display it as Picklist values
        for(AF_Category_Brand__c catBrandObj: [select Id, Name,AF_Super_category__c from AF_Category_Brand__c where recordType.Name=:AF_Constants.RT_CATEGORY AND Name IN :categoryList order by Name asc]){
            if(catBrandObj.Name == AF_Constants.TEST_CATEGORYNAME){
                categoryOptionList.add(new selectOption(AF_Constants.CATEGORY_OPTION+'::'+catBrandObj.id,catBrandObj.Name));
            }
            else{
                categoryOptionList.add(new selectOption(catBrandObj.Name+'::'+catBrandObj.id,catBrandObj.Name));
            } 
        }
        if(!categoryOptionList.isEmpty()){
            categoryStr=categoryOptionList.get(0).getValue();
            CategoryId=categoryStr.split('::').get(1);
            categoryNameStr=categoryStr.split('::').get(0);
        } 
        if(financialYear==null){
            isNotCurrentFy=false;
            financialYear=String.valueOf(Date.Today().year());      
        }else if(financialYear!=AF_Constants.FISCALYEAR){
            isNotCurrentFy=true;
        }
        //Category refresh issue fix from popup 
        if(category_name_url != null){
            categoryStr = category_name_url;
            CategoryId=categoryStr.split('::').get(1);
            categoryNameStr=categoryStr.split('::').get(0);
            financialYear=year_url;
        }
        if(year_url!=null){         
            if(financialYear!=String.valueOf(Date.Today().year())){
                isNotCurrentFy=true;
            }else{
                isNotCurrentFy=false;
            }      
        } 
        try{
            String Fisyear=string.valueOf(system.now().year()-1);
            list<AF_Brand_Estimate__c> abelist = new list<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c abe : [SELECT id,Name FROM AF_Brand_Estimate__c WHERE AF_Status_Base_Fees__c =:AF_Constants.BASE_FEES_READYFORPO and AF_Fiscal_Year__c =: Fisyear and AF_Active__c =: true and AF_Copied__c=: false and AF_Locked__c =: false])
            {
                abelist.add(abe);
            }
            List<PermissionSetAssignment> permissionSetAssign_cmco=[SELECT AssigneeId,Id,PermissionSetId FROM PermissionSetAssignment where PermissionSet.name=:AF_Constants.PERM_CMCO_SUPERUSER]; 
            for(PermissionSetAssignment psa : permissionSetAssign_cmco)
            {
                if(abelist.size() >0 && psa.AssigneeId == userinfo.getuserid()){
                    {  isbatchcopy = true;
                        break;
                    }
                }
            } 
        } 
        catch(exception ex)
        {
            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog (AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,
            className_STR,ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
        }
    }
    /***********************************************************************************
*  @Description: this method is used to check the permissionset assigned for users
*  @name : checkLoggedUserPermissionSet
*  @param : List<PermissionSetAssignment>
*  @return: none.
*************************************************************************************/
  public void checkLoggedUserPermissionSet(List<PermissionSetAssignment> permissionSetAssign){
    for (PermissionSetAssignment Names:permissionSetAssign )
        {
            string permissionSetName = Names.PermissionSet.Name;
            if(permissionSetName.contains(AF_Constants.PERM_CMCO)){
                isCMCO=true;
            }
            else if(permissionSetName==AF_Constants.PERM_FINANCE_CAT){
                isFinance=true;
            }
            else if(permissionSetName.contains(AF_Constants.PERM_CONTROLLER)){
                isController=true;
            }
            else if(permissionSetName.contains(AF_Constants.PERM_PROCURMENT)){
                isProcurement=true;
            }
            else if(permissionSetName==AF_Constants.PERM_FINANCE_REG_CAT){
                IsCatFinanceRegional=true;
            }
        }
  }
  
  public void checkLoggedUserType(User userObj){
    if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
            isAgencyFlag=true;
            for(AF_isBonusLinkForAgency__c bonusObj : AF_isBonusLinkForAgency__c.getAll().values()){
                if(bonusObj.Bonus_Date__c<=Date.Today() && bonusObj.Name==AF_Constants.QUARTERLY_BONUS_REC_TYPE){
                    isBonusQuartFlag=true;
                }if(bonusObj.Bonus_Date__c<=Date.Today() && bonusObj.Name==AF_Constants.ANNUAL_BONUS_REC_TYPE){
                    isBonusYearFlag=true;
                }
            }
        }else if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER){
            isCMCOSuperFlag=true;
        }else if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE|| userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER || userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_REGIONAL_CATEGORY_FINANCE || userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_PROCUREMENT || userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CONTROLLER){
            isNonCMCONFinFlag=true;
        }
        if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER){
            IsCMCOFinance = true;
        }
  }
    /***********************************************************************************
*  @Description: this method is used to provide drop down options for Financial Year
*  @name : getfinancialYearOption
*  @param : none
*  @return: List of selectOption.
*************************************************************************************/
    public list<selectOption> getfinancialYearOption(){
        list<selectOption> financialYearOptionList = new list<selectOption>();
        Date myDate= Date.Today();
        Date previousYear = myDate.addYears(-1);
        financialYearOptionList.add(new selectOption(String.valueOf(previousYear.addYears(-1).Year()), 'FY '+previousYear.addYears(-1).Year()));
        financialYearOptionList.add(new selectOption(String.valueOf(previousYear.Year()), 'FY '+previousYear.Year()));
        financialYearOptionList.add(new selectOption(String.valueOf(myDate.year()), 'FY '+myDate.year()));
        financialYearOptionList.add(new selectOption(String.valueOf(myDate.addYears(1).year()), 'FY '+myDate.addYears(1).year()));
        return financialYearOptionList;
    }
    /***********************************************************************************
*  @Description: this method is used to provide drop down options for Category
*  @name : getCategoryOption
*  @param : none
*  @return: List of selectOption.
*************************************************************************************/
    public list<selectOption> getCategoryOption(){
        return categoryOptionList;
    }
    /**********************************************************************************************************
*  @Description: this method is used to get and display brand estimates data related to selected category
    brand in Ascending order in All brands and my brands in home page and maps the brand, agency and fiscal year
    for the records, checks the bonus quarterly dates with today dates and enables bonus quaterly and changes
    the bonus result record quarterly based on the status 
*  @name : getbrandEstimateDetailList
*  @param : none
*  @return: List of AF_Brand_Estimate__c.
***********************************************************************************************************/
    public list<AF_Brand_Estimate__c> getbrandEstimateDetailList() {
        totalAgencyFee = 0;
        list<AF_Brand_Estimate__c> brandEstimateObjList = new list<AF_Brand_Estimate__c>();
        bonusDate = false;
        bonusDateQ2 = false;
        bonusDateQ3 = false;
        if(categoryStr!=null && selectedBrandValue==AF_Constants.ALL_BRANDS && isAgencyFlag){
            Id selectedCatId = categoryStr.split('::').get(1);
            brandEstimateObjList=[select id,Brand__c,AF_Bonus_Quaterly_Status__c,AF_No_Bonus__c,AF_Pilot_Model__c,AF_Bonus_Yearly_Status__c,AF_No_Of_Bonus_Matrix_Crossborders__c,AF_No_of_OOPS_Crossborder__c, Brand__r.Name, Brand__r.AF_Brand_Logo__c,AF_Agency__r.Name,AF_Crossborder__c,Agency_Base_Fee__c,Base_Fee_Total__c,AF_Fiscal_Year__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Agency__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c,AF_No_CrossBorders__c,AF_Category_Finance_Flag__c from AF_Brand_Estimate__c where Brand__r.AF_Category_Brands__c=:selectedCatId AND AF_Fiscal_Year__c=:financialYear AND AF_Active__c=true AND AF_Agency__r.Name=:AgencyAccountName AND Brand__c !=null order by Brand__r.Name asc];
        }
        else if(categoryStr!=null && selectedBrandValue==AF_Constants.MY_BRANDS && isAgencyFlag){
            Id selectedCatId = categoryStr.split('::').get(1);
            brandEstimateObjList=[select id,Brand__c,AF_Bonus_Quaterly_Status__c,AF_No_Bonus__c,AF_Pilot_Model__c,AF_Bonus_Yearly_Status__c,AF_No_Of_Bonus_Matrix_Crossborders__c,AF_No_of_OOPS_Crossborder__c, Brand__r.Name, Brand__r.AF_Brand_Logo__c,AF_Agency__r.Name,AF_Crossborder__c,Agency_Base_Fee__c,Base_Fee_Total__c,AF_Fiscal_Year__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Agency__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c,AF_No_CrossBorders__c,AF_Category_Finance_Flag__c from AF_Brand_Estimate__c where Brand__r.AF_Category_Brands__c=:selectedCatId AND Brand__r.Name=:brandList AND AF_Fiscal_Year__c=:financialYear AND AF_Active__c=true AND AF_Agency__r.Name=:AgencyAccountName AND Brand__c !=null order by Brand__r.Name asc];
        }
        else if(categoryStr!=null && selectedBrandValue==AF_Constants.ALL_BRANDS && !isAgencyFlag){
            Id selectedCatId = categoryStr.split('::').get(1);
            brandEstimateObjList=[select id,Brand__c,AF_Bonus_Quaterly_Status__c,AF_No_Bonus__c,AF_Pilot_Model__c,AF_Bonus_Yearly_Status__c,AF_No_Of_Bonus_Matrix_Crossborders__c,AF_No_of_OOPS_Crossborder__c, Brand__r.Name, Brand__r.AF_Brand_Logo__c,AF_Agency__r.Name,AF_Crossborder__c,Agency_Base_Fee__c,Base_Fee_Total__c,AF_Fiscal_Year__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Agency__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c,AF_No_CrossBorders__c,AF_Category_Finance_Flag__c from AF_Brand_Estimate__c where Brand__r.AF_Category_Brands__c=:selectedCatId  AND AF_Fiscal_Year__c=:financialYear AND AF_Active__c=true AND AF_Agency__c!=null AND Brand__c !=null order by Brand__r.Name asc];
        }
        else if(categoryStr!=null && selectedBrandValue==AF_Constants.MY_BRANDS && !isAgencyFlag){
            Id selectedCatId = categoryStr.split('::').get(1);
            brandEstimateObjList=[select id,Brand__c,AF_Bonus_Quaterly_Status__c,AF_No_Bonus__c,AF_Pilot_Model__c,AF_Bonus_Yearly_Status__c,AF_No_Of_Bonus_Matrix_Crossborders__c,AF_No_of_OOPS_Crossborder__c, Brand__r.Name, Brand__r.AF_Brand_Logo__c,AF_Agency__r.Name,AF_Crossborder__c,Agency_Base_Fee__c,Base_Fee_Total__c,AF_Fiscal_Year__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Agency__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c,AF_No_CrossBorders__c,AF_Category_Finance_Flag__c from AF_Brand_Estimate__c where Brand__r.AF_Category_Brands__c=:selectedCatId AND Brand__r.Name=:brandList AND AF_Fiscal_Year__c=:financialYear AND AF_Active__c=true AND AF_Agency__c!=null AND Brand__c !=null order by Brand__r.Name asc];
        }
        /*Calling the method to populate OOPS Data to HomePage*/
    getOOPDataList(brandEstimateObjList);
        getBonusQuaterlyStatus();
        getBonusQuarterlyData();
        getBonusSummaryData();
        getAgencyEstDataList();
        return brandEstimateObjList;
    }
    /******************************************************************************************************
*  @Description: this method is used to get OOPS Data for the records to be displayed in the Homepage
*  @name : getOOPDataList
*  @param : list<AF_Brand_Estimate__c>
*  @return: none.
***********************************************************************************************************/  
  public void getOOPDataList(list<AF_Brand_Estimate__c> brandEstimateObjList){
  totalUnileverFee=0;
  agencySetId.clear();
  uniqueBrandEstMap.clear();
  brandEstMap.clear();
  for(AF_Brand_Estimate__c brandEstObj :brandEstimateObjList){
            string unq=string.valueOf(brandEstObj.Brand__c).substring(0,15)+'::'+string.valueOf(brandEstObj.AF_Agency__c).substring(0,15)+'::'+brandEstObj.AF_Fiscal_Year__c;
            if(!uniqueBrandEstMap.containsKey(unq)){
                uniqueBrandEstMap.put(unq,brandEstObj);
            }
            agencySetId.add(brandEstObj.AF_Agency__c);
            brandEstMap.put(brandEstObj.Id,brandEstObj);
            totalUnileverFee+=brandEstObj.Base_Fee_Total__c;
        }
        //set to filter latest OOPs Actual
        set<String> uniqueOOPSSet = new set<String>();
        for(AF_OOPS_Actual__c oopObj:[select id,AF_Unique_Combination__c, AF_Status__c,oopsEstimateStatus__c,AF_Agency_lk__c,AF_Brand__c,AF_No_Of_CrossBorder__c,AF_Fiscal_year__c from AF_OOPS_Actual__c where AF_Unique_Combination__c IN :uniqueBrandEstMap.keyset() order By lastModifiedDate desc]){
            if(uniqueBrandEstMap.containsKey(oopObj.AF_Unique_Combination__c) && !uniqueOOPSSet.contains(oopObj.AF_Unique_Combination__c)){
                uniqueBrandEstMap.get(oopObj.AF_Unique_Combination__c).AF_No_of_OOPS_Crossborder__c=oopObj.AF_No_Of_CrossBorder__c;
                uniqueBrandEstMap.get(oopObj.AF_Unique_Combination__c).AF_Status_OOPs_Atcual__c=oopObj.AF_Status__c;
                uniqueBrandEstMap.get(oopObj.AF_Unique_Combination__c).AF_Status_OOPs_Estimate__c = oopObj.oopsEstimateStatus__c;
                uniqueOOPSSet.add(oopObj.AF_Unique_Combination__c);
            } 
        }
}
   /******************************************************************************************************
*  @Description: this method is used to get Bonus Quarterly custom settings data
*  @name : getBonusQuaterlyStatus
*  @param : none
*  @return: none.
***********************************************************************************************************/
public void getBonusQuaterlyStatus(){
  bonusQuarterlyDateList = new List<AF_BonusQuarterly_Quarterdates__c>();     
    bonusQuarterlyDateList = [select AF_Q1__c,AF_Q2__c,AF_Q3__c from AF_BonusQuarterly_Quarterdates__c LIMIT 1];
        if(bonusQuarterlyDateList.size()>0){
            if(bonusQuarterlyDateList[0].AF_Q1__c <= system.today()){
                bonusDate = true;
                bonusDateQ2 = false;
                bonusDateQ3 = false;
            }
            if(bonusQuarterlyDateList[0].AF_Q2__c <= system.today()){
                bonusDateQ2 = true;
                bonusDate = false;
                bonusDateQ3 = false;
            }
            if(bonusQuarterlyDateList[0].AF_Q3__c <= system.today()){
                bonusDateQ3 = true;
                bonusDateQ2 = false;
                bonusDate = false;
            }
        }
}
   /******************************************************************************************************
*  @Description: this method is used to show the Bonus Quarterly status for each quarter 
         depending on the logged in user,also the status will vary depending on the custom 
         settings date for each quarter
*  @name : getBonusQuarterlyData
*  @param : none
*  @return: none.
***********************************************************************************************************/
public void getBonusQuarterlyData(){
  set<String> uniqueBonusThrSet = new set<String>();
  List<AF_Bonus_Threshold__c> bonusThresObj = new List<AF_Bonus_Threshold__c>();
        set<String> bonusThresholdObj = new set<String>();
        List<AF_Bonus_Results__c> bonusResultObj = new List<AF_Bonus_Results__c>();
        for(AF_Bonus_Threshold__c bonusObj:[select id,Brand_Agency_Combination__c from AF_Bonus_Threshold__c where Brand_Agency_Combination__c IN:uniqueBrandEstMap.keyset()])
        {
            bonusThresholdObj.add(bonusObj.Id);
            bonusThresObj.add(bonusObj);
        }
        if(bonusThresholdObj.size()>0)
        {
            for(AF_Bonus_Results__c bonusResObj:[select id, AF_Status__c,AF_Period__c,AF_Bonus_Thresholds__c from AF_Bonus_Results__c where RecordType.Name=:AF_Constants.QUARTERLY_BONUS_REC_TYPE and AF_Bonus_Thresholds__c IN:bonusThresholdObj])
            {
                bonusResultObj.add(bonusResObj);
            }
        }
        Boolean Quarter=false;
        for(AF_Bonus_Threshold__c bt:bonusThresObj){
            Quarter = false;
            List<AF_Bonus_Results__c> bonusResultSelectedObj = new List<AF_Bonus_Results__c>();
            for(AF_Bonus_Results__c br:bonusResultObj) {
                if(bt.id == br.AF_Bonus_Thresholds__c){
                    bonusResultSelectedObj.add(br);
                }
            }
            if(uniqueBrandEstMap.containsKey(bt.Brand_Agency_Combination__c) && !uniqueBonusThrSet.contains(bt.Brand_Agency_Combination__c))
            {
                if(bonusResultSelectedObj.size()==0 && (bonusDate || bonusDateQ2 || bonusDateQ3)){
                    uniqueBrandEstMap.get(bt.Brand_Agency_Combination__c).AF_Bonus_Quaterly_Status__c=AF_Constants.CATEGORY_FINANCE_Bonus_Quarterly;
                    uniqueBonusThrSet.add(bt.Brand_Agency_Combination__c);
                }
                else if(bonusResultSelectedObj.size()>0){
                    for(AF_Bonus_Results__c bonusResult:bonusResultSelectedObj){
                    
                        if(bonusResult.AF_Period__c == AF_Constants.QUARTER1 && bonusDate && (bonusResult.AF_Status__c == AF_Constants.STATUS_DRAFT || bonusResult.AF_Status__c ==AF_Constants.STATUS_NONE)){
                            Quarter= true;
                            uniqueBrandEstMap.get(bt.Brand_Agency_Combination__c).AF_Bonus_Quaterly_Status__c=AF_Constants.CATEGORY_FINANCE_Bonus_Quarterly;
                        }
                        else if(bonusResult.AF_Period__c == AF_Constants.QUARTER1 && bonusDate && bonusResult.AF_Status__c == AF_Constants.STATUS_SUBMITTED){
                            Quarter= true;
                            uniqueBrandEstMap.get(bt.Brand_Agency_Combination__c).AF_Bonus_Quaterly_Status__c=AF_Constants.BASE_FEES_WIHTCMCO; 
                        }
                        if(bonusResult.AF_Period__c == AF_Constants.QUARTER2 && bonusDateQ2 && (bonusResult.AF_Status__c == AF_Constants.STATUS_DRAFT || bonusResult.AF_Status__c ==AF_Constants.STATUS_NONE)){
                            Quarter= true;
                            uniqueBrandEstMap.get(bt.Brand_Agency_Combination__c).AF_Bonus_Quaterly_Status__c=AF_Constants.CATEGORY_FINANCE_Bonus_Quarterly;
                        }
                        else if(bonusResult.AF_Period__c == AF_Constants.QUARTER2 && bonusDateQ2 && bonusResult.AF_Status__c == AF_Constants.STATUS_SUBMITTED){
                            Quarter= true;
                            uniqueBrandEstMap.get(bt.Brand_Agency_Combination__c).AF_Bonus_Quaterly_Status__c=AF_Constants.BASE_FEES_WIHTCMCO; 
                        }
                        if(bonusResult.AF_Period__c == AF_Constants.QUARTER3 && bonusDateQ3 && (bonusResult.AF_Status__c == AF_Constants.STATUS_DRAFT || bonusResult.AF_Status__c ==AF_Constants.STATUS_NONE)){
                            Quarter= true;
                            uniqueBrandEstMap.get(bt.Brand_Agency_Combination__c).AF_Bonus_Quaterly_Status__c=AF_Constants.CATEGORY_FINANCE_Bonus_Quarterly;
                        }
                        else if(bonusResult.AF_Period__c == AF_Constants.QUARTER3 && bonusDateQ3 && bonusResult.AF_Status__c == AF_Constants.STATUS_SUBMITTED){
                            Quarter= true;
                            uniqueBrandEstMap.get(bt.Brand_Agency_Combination__c).AF_Bonus_Quaterly_Status__c=AF_Constants.BASE_FEES_WIHTCMCO; 
                        }
                    }
                    if(!Quarter){
                        uniqueBrandEstMap.get(bt.Brand_Agency_Combination__c).AF_Bonus_Quaterly_Status__c=AF_Constants.CATEGORY_FINANCE_Bonus_Quarterly;
                    }
                    uniqueBonusThrSet.add(bt.Brand_Agency_Combination__c);
                }
            }
        }
}
  /******************************************************************************************************
*  @Description: this method is used to display the BonusSummary Status in the Homepage
*  @name : getBonusSummaryData
*  @param : none
*  @return: none.
***********************************************************************************************************/
public void getBonusSummaryData(){
  set<String> uniqueBonusSumSet = new set<String>();
        for(AF_Bonus_Summary__c bonusSummObj : [select id, AF_Brand_Agency_Uq_Combination__c, AF_Status__c,AF_No_Of_CrossBorders__c from AF_Bonus_Summary__c where AF_Brand_Agency_Uq_Combination__c IN:uniqueBrandEstMap.keyset()]){
            if(uniqueBrandEstMap.containsKey(bonusSummObj.AF_Brand_Agency_Uq_Combination__c) && !uniqueBonusSumSet.contains(bonusSummObj.AF_Brand_Agency_Uq_Combination__c)){
                uniqueBrandEstMap.get(bonusSummObj.AF_Brand_Agency_Uq_Combination__c).AF_Bonus_Yearly_Status__c=bonusSummObj.AF_Status__c;
                uniqueBrandEstMap.get(bonusSummObj.AF_Brand_Agency_Uq_Combination__c).AF_No_Of_Bonus_Matrix_Crossborders__c=bonusSummObj.AF_No_Of_CrossBorders__c;
                uniqueBonusSumSet.add(bonusSummObj.AF_Brand_Agency_Uq_Combination__c);    
            }
        }
}
 /******************************************************************************************************
*  @Description: this method is used to calculate the total of Traditional,Digital,and Adapatation of
         all the Agency Estimates records for a particular BrandEstimate record.It also calculates the overall
         total of all the Traditional,Digital and Adapatation.
*  @name : getAgencyEstDataList
*  @param : none
*  @return: none.
***********************************************************************************************************/
public void getAgencyEstDataList(){
  totalAgencyFee=0;
        totalCroBordFee=0;
        totalTraditionalFee=0;
        totalDigitalFee=0;
        totalAdaptiveFee=0;
        crosPerStr=0;
        tradPerStr=0;
        adaptPerStr=0;
        digitPerStr=0;
        Integer noofCrossBord=0;
        tradDecimalPerStr=0;
        adaptDecimalPerStr=0;
        digitDecimalPerStr=0;
    //for Agency fee and crossborder calculation
        //map variable to store crossborder fee and Agency fee related to individual Brands
        map<Id,string> brandAgencyFeeMap = new map<Id,string>();
        List<AF_Agency_Estimate__c> agencyEstimateList = new List<AF_Agency_Estimate__c>();
        if(!isAgencyFlag){
            agencyEstimateList = [select id, AF_Traditional__c, AF_Digital__c, AF_Adaptation__c, AF_IsCrossborder__c,AF_Total__c,AF_Fiscal_Year__c,AF_Brand_Estimate__c from AF_Agency_Estimate__c where AF_Agency_Entity__r.AF_Agency__c IN:agencySetId and AF_Fiscal_Year__c=:financialYear and AF_Brand_Estimate__c IN :brandEstMap.keyset() and AF_Status__c !=:AF_Constants.BASE_FEES_WITH_AGENCY_DRAFT order by AF_Brand_Estimate__c];
        }
        else if(isAgencyFlag){
            agencyEstimateList = [select id, AF_Traditional__c, AF_Digital__c, AF_Adaptation__c, AF_IsCrossborder__c,AF_Total__c,AF_Fiscal_Year__c,AF_Brand_Estimate__c from AF_Agency_Estimate__c where AF_Agency_Entity__r.AF_Agency__c IN:agencySetId and AF_Fiscal_Year__c=:financialYear and AF_Brand_Estimate__c IN :brandEstMap.keyset() order by AF_Brand_Estimate__c];
        }
        for(AF_Agency_Estimate__c agencyEstObj:agencyEstimateList){
            //check  wethere Brand Estimate is already there in map or not
            if(!brandAgencyFeeMap.containsKey(agencyEstObj.AF_Brand_Estimate__c)){
                Decimal agencyFeeDec =0; 
                Decimal crossBordFeeDec=0;
                noofCrossBord=0;
                if(agencyEstObj.AF_IsCrossborder__c){
                    crosPerStr+=1;
                    crossBordFeeDec+=agencyEstObj.AF_Total__c;
                    totalCroBordFee+=agencyEstObj.AF_Total__c;
                    if(agencyEstObj.af_total__c>0){noofCrossBord+=1;}
                }
                agencyFeeDec+=agencyEstObj.AF_Total__c;
                totalAgencyFee+=agencyEstObj.AF_Total__c;
                brandAgencyFeeMap.put(agencyEstObj.AF_Brand_Estimate__c,string.valueOf(agencyFeeDec)+'::'+string.valueOf(crossBordFeeDec));
            }else {
                string existingAgencyFeeStr=brandAgencyFeeMap.get(agencyEstObj.AF_Brand_Estimate__c);
                Decimal agencyFeeDec =Decimal.valueOf(existingAgencyFeeStr.split('::').get(0)); 
                Decimal crossBordFeeDec=Decimal.valueOf(existingAgencyFeeStr.split('::').get(1));
                if(agencyEstObj.AF_IsCrossborder__c){
                    crosPerStr+=1;
                    crossBordFeeDec+=agencyEstObj.AF_Total__c;
                    totalCroBordFee+=agencyEstObj.AF_Total__c;
                    if(agencyEstObj.af_total__c>0){noofCrossBord+=1;}
                }
                agencyFeeDec+=agencyEstObj.AF_Total__c;
                totalAgencyFee+=agencyEstObj.AF_Total__c;
                brandAgencyFeeMap.put(agencyEstObj.AF_Brand_Estimate__c,string.valueOf(agencyFeeDec)+'::'+string.valueOf(crossBordFeeDec));
            }
            Decimal baseAgencyValue = Decimal.valueOf(brandAgencyFeeMap.get(agencyEstObj.AF_Brand_Estimate__c).split('::').get(0));
            brandEstMap.get(agencyEstObj.AF_Brand_Estimate__c).Agency_Base_Fee__c=baseAgencyValue;
            if(baseAgencyValue!=0){
                brandEstMap.get(agencyEstObj.AF_Brand_Estimate__c).AF_No_CrossBorders__c=noofCrossBord;
            }
            if(agencyEstObj.AF_Traditional__c==null)
            agencyEstObj.AF_Traditional__c=0;
            if(agencyEstObj.AF_Digital__c==null)
            agencyEstObj.AF_Digital__c=0;
            if(agencyEstObj.AF_Adaptation__c==null)
            agencyEstObj.AF_Adaptation__c=0;
            totalTraditionalFee+=agencyEstObj.AF_Traditional__c;
            totalDigitalFee+=agencyEstObj.AF_Digital__c;
            totalAdaptiveFee+=agencyEstObj.AF_Adaptation__c;
        }
        //Calculate total crossborder percentage
        if(totalAgencyFee!=0){
            tradPerStr=math.round(totalTraditionalFee/totalAgencyFee*100);
            tradDecimalPerStr = totalTraditionalFee/totalAgencyFee*100;
            tradDecimalPerStr = tradDecimalPerStr.setScale(2);
            adaptPerStr=math.round(totalAdaptiveFee/totalAgencyFee*100);
            adaptDecimalPerStr = totalAdaptiveFee/totalAgencyFee*100;
            adaptDecimalPerStr = adaptDecimalPerStr.setScale(2);
            digitDecimalPerStr = totalDigitalFee/totalAgencyFee*100;
            digitDecimalPerStr = digitDecimalPerStr.setScale(2);
            digitPerStr=math.round(totalDigitalFee/totalAgencyFee*100);
            // 101 Percentage Issue
            if(tradPerStr!=0 && digitPerStr!=0 && adaptPerStr!=0){
                adaptPerStr = 100-(tradPerStr+digitPerStr);
            }
        }  
}
    /******************************************************************************************************
*  @Description: this method is used to get and display agency estimate details for Agency Users
*  @name : getAgencyEstimateDetailList
*  @param : none
*  @return: List of AF_Agency_Estimate__c.
***********************************************************************************************************/
    public List<AF_Agency_Estimate__c> getAgencyEstimateDetailList() {
        agencyPortalUserList = new List<AF_Agency_Estimate__c>();
        totalAgencyFee = 0;
        totalCroBordFee=0;
        totalTraditionalFee=0;
        totalDigitalFee=0;
        totalAdaptiveFee=0;
        crosPerStr=0;
        tradPerStr=0;
        adaptPerStr=0;
        digitPerStr=0;
        map<string,string> agencyBrandMap = new map<string,string>();
        //map to store Brand and Brand Logo combination
        set<Id> brandIdSet = new set<Id>();
        for(AF_Agency_Estimate__c agencyEstimate:[select AF_Total__c,AF_Brand_Estimate__c,AF_Archived__c,AF_Brand_Id__c,AF_IsCrossborder__c,AF_Brand_Logo__c,AF_Brand_Estimate__r.Brand__c,AF_Status__c,Brand__c,Agency_Account__c,Category_Agency__c,AF_Adaptation__c,AF_Traditional__c,AF_Digital__c  from AF_Agency_Estimate__c where Agency_Account__c=:AgencyAccountName and Category_Agency__c = :categoryNameStr and Brand__c IN :brandList and AF_Fiscal_Year__c=:financialYear and AF_Archived__c=false]){
            brandIdSet.add(agencyEstimate.AF_Brand_Id__c);
            agencyBrandMap.put(agencyEstimate.Id,agencyEstimate.AF_Brand_Id__c);
            totalAgencyFee+= agencyEstimate.AF_Total__c;
            totalAdaptiveFee+= agencyEstimate.AF_Adaptation__c;
            totalTraditionalFee+=agencyEstimate.AF_Traditional__c;
            totalDigitalFee+=agencyEstimate.AF_Digital__c;
            if(agencyEstimate.AF_IsCrossborder__c){
                crosPerStr+=1;
                totalCroBordFee+=agencyEstimate.AF_Total__c;
            }
            agencyPortalUserList.add(agencyEstimate);
        } 
        if(totalAgencyFee!=0){
            tradPerStr = math.round(totalTraditionalFee/totalAgencyFee*100);
            adaptPerStr = math.round(totalAdaptiveFee/totalAgencyFee*100);
            digitPerStr = math.round(totalDigitalFee/totalAgencyFee*100);
            // 101 Percentage Issue
            if(tradPerStr!=0 && digitPerStr!=0 && adaptPerStr!=0){
                adaptPerStr = 100-(tradPerStr+digitPerStr);
            }
        }
        return  agencyPortalUserList;
    }
    /******************************************************************************************************
*  @Description: this method is used to redirect user to report home page
*  @name : redirectToReportPage
*  @param : none
*  @return: pagereference.
***********************************************************************************************************/
    public pagereference redirectToReportPage(){
        pagereference pf = new pagereference(AF_Constants.REDIRECT);
        pf.setredirect(true);
        return pf;
    }
    /******************************************************************************************************
*  @Description: this method is used to action for on changing category change category name in Main section
*  @name : changeCatName
*  @param : none
*  @return: none.
***********************************************************************************************************/
    public void changeCatName(){
        categoryNameStr=categoryStr.split('::').get(0);
        CategoryId=categoryStr.split('::').get(1);
        if(financialYear!=String.valueOf(Date.Today().year())){
            isNotCurrentFy=true;
        }else{
            isNotCurrentFy=false;
        }
    }
    /******************************************************************************************************
*  @Description: this method is used to action for on changing the Brand
*  @name : changeBrand
*  @param : none
*  @return: none.
***********************************************************************************************************/
    public void changeBrand(){
        selectedBrandValue=selectedBrandOption;
    }
    /******************************************************************************************************
*  @Description: this method is used to display the Brand Dropdown options
*  @name : getBrandsOption
*  @param : none
*  @return: List of SelectOption.
***********************************************************************************************************/
    public List<SelectOption> getBrandsOption() {
        List<SelectOption> selectedbrandList= new List<SelectOption>();
        selectedbrandList.add(new SelectOption(AF_Constants.MY_BRANDS,AF_Constants.MY_BRANDS)); 
        selectedbrandList.add(new SelectOption(AF_Constants.ALL_BRANDS,AF_Constants.ALL_BRANDS));                        
        return selectedbrandList;
    }
    /******************************************************************************************************
*  @Description: this method is used for sending email to Cat Finance Team
*  @name : emailtocatfinance
*  @param : none
*  @return: pagereference.
***********************************************************************************************************/
    public pagereference emailtocatfinance(){
        pagereference p = new pagereference(AF_Constants.SEND_EMAIL_CATEGORYFINANCE);
        return p;
    }
}