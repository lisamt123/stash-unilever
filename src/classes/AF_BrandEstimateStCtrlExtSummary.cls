/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimateStCtrlExtSummary
@CreateDate : 23/6/2014
@Description : This is a controller class for AF_UL_AgencyMatrix Page, 
@              this is used to display the summary section of the Basefee Matrix page.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_BrandEstimateStCtrlExtSummary {
    public String brandEstimateId {get;set;}
    public string financialYear{get;set;} //To get selected financial Year
    public string categoryStr{get;set;} // To get selected category value
    public string categoryNameStr{get;set;} // To get selected category Name on the page
    public Decimal totalUnileverFee {get;set;} //To display overall Unilever Base fees
    public Decimal totalAgencyFee {get;set;} //To display overall Agency Base fees
    public Decimal totalAgencyFeeDiv {get;set;} //To display overall Agency Base fees
    public Decimal totalCroBordFee {get;set;} //To display overall Cross Border fees
    public Decimal totalTraditionalFee {get;set;} //To display overall Traditional fees
    public Decimal totalDigitalFee {get;set;} //To display overall Digital fees
    public Decimal totalAdaptiveFee {get;set;} //To display overall Adaptive fees
    public Integer crosPerStr {get;set;} //To display CrossBorder Percentage
    public Integer tradPerStr {get;set;} //To display Traditional Percentage 
    public Integer digitPerStr {get;set;} //To display Digital Percentage 
    public Integer adaptPerStr {get;set;} //To display Adaptive Percentage 
    public string category {get;set;} //this can be removed while merging with latest UI
    public list<selectOption> categoryOptionList = new list<selectOption>(); //to store category option values
    public boolean isClicked{get;set;}
    public boolean isNotCurrentFy {get ;set;}
    String Currentyear = String.valueOf(Date.Today().year()); //Need to discuss it with Pratyusha
    public string CategoryId{get;set;} //to pass category Id in the url string
    public boolean isAgencyFlag{get;set;} //to check wether logged in user is partner user or not
    public string statusProcess{get;set;} 
    public string statusProcessImage{get;set;} 
    public Decimal tradDecimalPerStr{get;set;}
    public Decimal digitDecimalPerStr{get;set;}
    public Decimal adaptDecimalPerStr{get;set;}
    /**********************************************************************
*  @Description: Contructor method
*  @name : AF_BrandEstimateStCtrlExtSummary
*  @param : ApexPages.StandardController
*  @return : none
*************************************************************************/
    public AF_BrandEstimateStCtrlExtSummary(ApexPages.StandardController stdController) {
        brandEstimateId = ApexPages.currentPage().getParameters().get('id');
        AF_Brand_Estimate__c mybrand = [select AF_Category_Name__c,AF_Category_Finance_Flag__c,AF_Category_Finance_Approved__c,Base_Fee_Total__c,AF_Status_Base_Fees__c,AF_ProgressImage_Reviews__c,AF_ProgressImage__c from AF_Brand_Estimate__c where id=:brandEstimateId];
        statusProcess=mybrand.AF_Status_Base_Fees__c;
        if(statusProcess==AF_Constants.BASE_FEES_WITH_AGENCY)  statusProcessImage=AF_Constants.AGENCYPROCESS_IMAGE ; 
        if(statusProcess==AF_Constants.CATEGORY_FINANCE)  statusProcessImage=AF_Constants.CATEGORYPROCESS_IMAGE ; 
        if(statusProcess==AF_Constants.BASE_FEES_WIHTCMCO)  statusProcessImage=AF_Constants.CMCOPROCESS_IMAGE ; 
        if(statusProcess==AF_Constants.BASE_FEES_READYFORPO)  statusProcessImage=AF_Constants.READYFORPO_IMAGE ; 
        totalUnileverFee=0;
        totalAgencyFee=0;
        totalCroBordFee=0;
        totalTraditionalFee=0;
        totalDigitalFee=0;
        totalAdaptiveFee=0;
        tradDecimalPerStr=0;
        digitDecimalPerStr=0;
        adaptDecimalPerStr=0;
        crosPerStr=0;
        tradPerStr=0;
        adaptPerStr=0;
        digitPerStr=0;
        categoryNameStr=mybrand.AF_Category_Name__c;
        totalUnileverFee = mybrand.Base_Fee_Total__c;
        list<AF_Agency_Estimate__c> agencyEstimateObjList = new list<AF_Agency_Estimate__c>();
        agencyEstimateObjList=[select id,AF_IsCrossborder__c,AF_Total__c,af_digital__c,af_traditional__c,af_adaptation__c from AF_Agency_Estimate__c where AF_Brand_Estimate__c=:brandEstimateId];
        for(AF_Agency_Estimate__c myae:agencyEstimateObjList)
        {
            totalAgencyFee=totalAgencyFee+myae.AF_Total__c;
            if(myae.AF_IsCrossborder__c) {totalCroBordFee=totalCroBordFee + myae.AF_Total__c;crosPerStr=crosPerStr+1;}
            totalTraditionalFee=totalTraditionalFee+myae.af_traditional__c;
            totalDigitalFee=totalDigitalFee+myae.AF_Digital__c;
            totalAdaptiveFee=totalAdaptiveFee+myae.AF_Adaptation__c;
        }
        {
            if(totalAgencyFee==0 || totalAgencyFee ==null )
            {totalAgencyFeeDiv=1;} else {totalAgencyFeeDiv=totalAgencyFee;}
            tradPerStr=math.round(totalTraditionalFee/totalAgencyFeeDiv*100);
            adaptPerStr=math.round(totalAdaptiveFee/totalAgencyFeeDiv*100);
            digitPerStr=math.round(totalDigitalFee/totalAgencyFeeDiv*100);
            tradDecimalPerStr = totalTraditionalFee/totalAgencyFeeDiv*100;
            tradDecimalPerStr = tradDecimalPerStr.setScale(2);
            adaptDecimalPerStr = totalAdaptiveFee/totalAgencyFeeDiv*100;
            adaptDecimalPerStr = adaptDecimalPerStr.setScale(2);
            digitDecimalPerStr = totalDigitalFee/totalAgencyFeeDiv*100;
            digitDecimalPerStr = digitDecimalPerStr.setScale(2);
            // 101 Percentage Issue
            if(tradPerStr!=0 && digitPerStr!=0 && adaptPerStr!=0){
                adaptPerStr = 100-(tradPerStr+digitPerStr);
            }
        }
    }
    /***********************************************************************************
*  @Description: this method is used to get the BrandEstimate and AgencyEstimate details
*  @name : getbrandEstimateDetailList
*  @param : none
*  @return: List of AF_Brand_Estimate__c.
*************************************************************************************/
    public list<AF_Brand_Estimate__c> getbrandEstimateDetailList() {
        list<AF_Brand_Estimate__c> brandEstimateObjList = new list<AF_Brand_Estimate__c>();
        brandEstimateObjList=[select id, Brand__r.Name, Brand__r.AF_Brand_Logo__c,AF_Agency__r.Name,AF_Crossborder__c,Agency_Base_Fee__c,Base_Fee_Total__c,AF_Fiscal_Year__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Agency__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c from AF_Brand_Estimate__c where id =:brandEstimateId AND AF_Fiscal_Year__c=:financialYear AND AF_Active__c=true order by Brand__r.Name asc];
        //variable to store base fees details related to brand
        //map to store brand estimate instance with id as key
        map<Id,AF_Brand_Estimate__c> brandEstMap= new map<Id,AF_Brand_Estimate__c>();
        //variable to store Agency id
        set<Id> agencySetId = new set<Id>();
        totalUnileverFee=0;
        totalAgencyFee=0;
        totalCroBordFee=0;
        totalTraditionalFee=0;
        totalDigitalFee=0;
        totalAdaptiveFee=0;
        crosPerStr=0;
        tradPerStr=0;
        adaptPerStr=0;
        digitPerStr=0;
        for(AF_Brand_Estimate__c brandEstObj :brandEstimateObjList){
            agencySetId.add(brandEstObj.AF_Agency__c);
            brandEstMap.put(brandEstObj.Id,brandEstObj);
            if(brandEstObj.AF_Traditional__c==null)
            brandEstObj.AF_Traditional__c=0;
            if(brandEstObj.AF_Digital__c==null)
            brandEstObj.AF_Digital__c=0;
            if(brandEstObj.AF_Adaptive__c==null)
            brandEstObj.AF_Adaptive__c=0;
            totalTraditionalFee+=brandEstObj.AF_Traditional__c;
            totalDigitalFee+=brandEstObj.AF_Digital__c;
            totalAdaptiveFee+=brandEstObj.AF_Adaptive__c;
        }
        totalUnileverFee=totalTraditionalFee+totalDigitalFee+totalAdaptiveFee;
        /*
        if(totalUnileverFee!=0){
            tradPerStr=math.round(totalTraditionalFee/totalUnileverFee*100);
            adaptPerStr=math.round(totalAdaptiveFee/totalUnileverFee*100);
            digitPerStr=math.round(totalDigitalFee/totalUnileverFee*100);
            tradDecimalPerStr = totalTraditionalFee/totalUnileverFee*100;
            tradDecimalPerStr = tradDecimalPerStr.setScale(2);
            adaptDecimalPerStr = totalAdaptiveFee/totalUnileverFee*100;
            adaptDecimalPerStr = adaptDecimalPerStr.setScale(2);
            digitDecimalPerStr = totalDigitalFee/totalUnileverFee*100;
            digitDecimalPerStr = digitDecimalPerStr.setScale(2);
            // 101 Percentage Issue
            if(tradPerStr!=0 && digitPerStr!=0 && adaptPerStr!=0){
                adaptPerStr = 100-(tradPerStr+digitPerStr);
            }
        }*/
        //for Agency fee and crossborder calculation
        //map variable to store crossborder fee and Agency fee related to individual Brands
        map<Id,string> brandAgencyFeeMap = new map<Id,string>();
        for(AF_Agency_Estimate__c agencyEstObj:[select id,AF_IsCrossborder__c,AF_Total__c,AF_Fiscal_Year__c,AF_Brand_Estimate__c from AF_Agency_Estimate__c where AF_Agency_Entity__r.AF_Agency__c IN:agencySetId and AF_Fiscal_Year__c=:financialYear and AF_Brand_Estimate__c IN :brandEstMap.keyset()]){
            //check  wethere Brand Estimate is already there in map or not
            if(!brandAgencyFeeMap.containsKey(agencyEstObj.AF_Brand_Estimate__c)){
                Decimal agencyFeeDec =0; 
                Decimal crossBordFeeDec=0;
                if(agencyEstObj.AF_IsCrossborder__c){
                    crossBordFeeDec+=agencyEstObj.AF_Total__c;
                    totalCroBordFee+=agencyEstObj.AF_Total__c;
                }
                agencyFeeDec+=agencyEstObj.AF_Total__c;
                totalAgencyFee+=agencyEstObj.AF_Total__c;
                brandAgencyFeeMap.put(agencyEstObj.AF_Brand_Estimate__c,string.valueOf(agencyFeeDec)+'::'+string.valueOf(crossBordFeeDec));
            }else {
                string existingAgencyFeeStr=brandAgencyFeeMap.get(agencyEstObj.AF_Brand_Estimate__c);
                Decimal agencyFeeDec =Decimal.valueOf(existingAgencyFeeStr.split('::').get(0)); 
                Decimal crossBordFeeDec=Decimal.valueOf(existingAgencyFeeStr.split('::').get(1));
                if(agencyEstObj.AF_IsCrossborder__c){
                    crossBordFeeDec+=agencyEstObj.AF_Total__c;
                    totalCroBordFee+=agencyEstObj.AF_Total__c;
                }
                agencyFeeDec+=agencyEstObj.AF_Total__c;
                totalAgencyFee+=agencyEstObj.AF_Total__c;
                brandAgencyFeeMap.put(agencyEstObj.AF_Brand_Estimate__c,string.valueOf(agencyFeeDec)+'::'+string.valueOf(crossBordFeeDec));
            }
            Decimal baseAgencyValue = Decimal.valueOf(brandAgencyFeeMap.get(agencyEstObj.AF_Brand_Estimate__c).split('::').get(0));
            Decimal baseCrossValue = Decimal.valueOf(brandAgencyFeeMap.get(agencyEstObj.AF_Brand_Estimate__c).split('::').get(1));
            brandEstMap.get(agencyEstObj.AF_Brand_Estimate__c).Agency_Base_Fee__c=baseAgencyValue;
            if(baseAgencyValue!=0){
                brandEstMap.get(agencyEstObj.AF_Brand_Estimate__c).AF_Crossborder__c=(baseCrossValue/baseAgencyValue*100);
            }
        }
        //Calculate total crossborder percentage
        if(totalAgencyFee!=0){
            crosPerStr=math.round(totalCroBordFee/totalAgencyFee*100);
        }   
        return brandEstimateObjList;
    }
  /***********************************************************************************
*  @Description: this method is used to get the BrandEstimate and AgencyEstimate details
*  @name : getbrandEstimateDetailList
*  @param : none
*  @return: List of AF_Brand_Estimate__c.
*************************************************************************************/

  Public void getbrandEstimateDetailListExt(){
  list<AF_Brand_Estimate__c> brandEstimateObjLst = new list<AF_Brand_Estimate__c>();
        brandEstimateObjLst=[select id, Brand__r.Name, Brand__r.AF_Brand_Logo__c,AF_Agency__r.Name,AF_Crossborder__c,Agency_Base_Fee__c,Base_Fee_Total__c,AF_Fiscal_Year__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Agency__c,AF_Traditional__c,AF_Digital__c,AF_Adaptive__c from AF_Brand_Estimate__c where id =:brandEstimateId AND AF_Fiscal_Year__c=:financialYear AND AF_Active__c=true order by Brand__r.Name asc];
        //variable to store base fees details related to brand
        //map to store brand estimate instance with id as key
        map<Id,AF_Brand_Estimate__c> brandEstMap= new map<Id,AF_Brand_Estimate__c>();
        set<Id> agencySetId = new set<Id>();
        totalTraditionalFee=0;
        totalDigitalFee=0;
        totalAdaptiveFee=0;
         for(AF_Brand_Estimate__c brandEstObj :brandEstimateObjLst){
            agencySetId.add(brandEstObj.AF_Agency__c);
            brandEstMap.put(brandEstObj.Id,brandEstObj);
            if(brandEstObj.AF_Traditional__c==null)
            brandEstObj.AF_Traditional__c=0;
            if(brandEstObj.AF_Digital__c==null)
            brandEstObj.AF_Digital__c=0;
            if(brandEstObj.AF_Adaptive__c==null)
            brandEstObj.AF_Adaptive__c=0;
            totalTraditionalFee+=brandEstObj.AF_Traditional__c;
            totalDigitalFee+=brandEstObj.AF_Digital__c;
            totalAdaptiveFee+=brandEstObj.AF_Adaptive__c;
        }
        /*Added for code refractoring */
        totalUnileverFee=totalTraditionalFee+totalDigitalFee+totalAdaptiveFee;
        if(totalUnileverFee!=0){
            tradPerStr=math.round(totalTraditionalFee/totalUnileverFee*100);
            adaptPerStr=math.round(totalAdaptiveFee/totalUnileverFee*100);
            digitPerStr=math.round(totalDigitalFee/totalUnileverFee*100);
            tradDecimalPerStr = totalTraditionalFee/totalUnileverFee*100;
            tradDecimalPerStr = tradDecimalPerStr.setScale(2);
            adaptDecimalPerStr = totalAdaptiveFee/totalUnileverFee*100;
            adaptDecimalPerStr = adaptDecimalPerStr.setScale(2);
            digitDecimalPerStr = totalDigitalFee/totalUnileverFee*100;
            digitDecimalPerStr = digitDecimalPerStr.setScale(2);
            // 101 Percentage Issue
            if(tradPerStr!=0 && digitPerStr!=0 && adaptPerStr!=0){
                adaptPerStr = 100-(tradPerStr+digitPerStr);
            }
        }
  }
    
    /***********************************************************************************
*  @Description: this method is used to change the category
*  @name : changeCatName
*  @param : none
*  @return: none.
*************************************************************************************/
    public void changeCatName(){
        categoryNameStr=categoryStr.split('::').get(0);
        CategoryId=categoryStr.split('::').get(1);
        if(financialYear!=String.valueOf(Date.Today().year())){
            isNotCurrentFy=true;
        }else{
            isNotCurrentFy=false;
        }
    }
}