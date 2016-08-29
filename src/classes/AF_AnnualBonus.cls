/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_AnnualBonus
@CreateDate : 20/7/2014
@Description : This is a controller class for AF_AnnualBonus Page, 
@             this is used to enter and calculate the Annual Bonus Results.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_AnnualBonus {
    Public Boolean IsDraft{get;set;}
    public Decimal bonusTradDigitalFee{get;set;}
    public Boolean showmainblock{get;set;}
    public Decimal Sum_remuneration_val{get;set;}
    public Decimal Sum_remuneration_per{get;set;}
    public Boolean AF_Pilot_Model { get; set; }
    public Boolean No_Bonus_Check {get;set;}
    public Decimal sum_of_quant_qual_percent { get; set; }// To get sum of total Quantative and total Qualatative Percents
    public Decimal sum_of_quant_qual_value { get; set; }// To get sum of total Quantative and total Qualatative values
    public Decimal sum_of_qual_percent { get; set; }//To get sum of Qualatative percent
    public Decimal sum_of_qual_value { get; set; }//To get sum of Qualatative value
    public Boolean isAgency{get;set;} //To check the logged in user is Agency
    public Integer Totals_Traditional { get; set; }// To get total traditional values for all display list
    //public Boolean isQuantEmpty;// To ensure that quant inputbox can not be empty;
    public Boolean isTraditional { get; set; }//Check for traditional value
    public Integer Totals_Digital { get; set; }// To get total digital values for all display list
    public Boolean isDigital { get; set; }//Check for digital value
    public decimal sum_of_bonus_per { get; set; }// To hold sum of bonus percentage which is calculated by Quantative value
    public decimal sum_of_bonus_val { get; set; }// To hold sum of bonus value which is calculated by Quantative value
    public list<wrapbonus> QuartelyBonus {get;set;}//List to hold multiple object data
    public list<AF_Bonus_Results__c>AF_Bonus_Result{get;set;}//list of bonus result records
    public list<AF_Bonus_Threshold__c> AF_Bonus_Threshold{get;set;}// list of bonus threshold records
    //public string Country_name;//store Unilever Entity name
    //public integer Traditional_value;// To hold traditional value from agency estimates
    //public integer Digital_value;// To hold digital value from agency estimates
    //public integer TotalTraditionalValue;//To hold total traditional value from agency estimates
    //public integer TotalDigitalValue;// To hold total digital value from agency estimates
    public integer total_bonus_fees;//To hold total bonusable fee which is sum of Traditional and Digital value
    //public id threshold_id;// hold threshold id
    //public string agency_name;// hold agency name
    //public string Brand_name;// hold brand name
    public list<AF_Agency_Estimate__c>Agency_Estimate=new list<AF_Agency_Estimate__c>();// list of agency estimate
    public Boolean IsEditable{get;set;}// check for CMCO super user or category finance user
    public map<id,string>bonus_thresholdid=new  map<id,string>(); // map of bonus threshold with bonus threshold id alog with combination of agency id,brand id,unilever country and fiscal year
    //set<string> Threshold = new set<string>();// store threshold id
    public Decimal qual_per=0;// to hold Qualatative percentage
    public Decimal Qual_value=0;// to hold Qualatative value
    Public Set<String> Countryname_BT=new set<String>();
    public List<wrapRenumartionbonus> renumBonus{get;set;}
    public list<AF_Bonus_Threshold__c> bonusThresholdRenumeration=new list<AF_Bonus_Threshold__c>();
    public list<AF_Bonus_Results__c> bonusResult=new list<AF_Bonus_Results__c>();
    Public  List<AF_Bonus_Summary__c> bonusSummaries{get;set;}
    public Boolean noDisplay{get;set;}
    public Boolean noDisplayQuarterly{get;set;}
    public  decimal sum_of_bonusable_fees { get; set; } //to hold the sum of Bonusable fees 30-08-2014
    public  decimal sum_of_bonusable_fees_onload { get; set; } //to hold the sum of Bonusable fees on load 03-09-2014
    public Integer Totals_BonusMeasureTrad { get; set; }
    public Integer Totals_BonusMeasureDigital { get; set; }
    /*Start code refactoring*/
    //private static String Digital =AF_Constants.DIGITAL;
    //private static String Trad = AF_Constants.TRADITIONAL;
    //private static String AF_AnnualBonus = AF_Constants.TEST_ANNUAL_BONUS;
    //private static String AF_BonusThershold=AF_Constants.TEST_BONUS_THRESHOLD;
    //private static String AF_Qualitative_value=AF_Constants.TEST_QUAL_VALUE;
    //private static string className_STR=AF_Constants.TEST_ANNUAL_BONUS;
    public Boolean showSubmit{get;set;}
    private set<string> agencyEstUnqStr = new set<string>();
    Map<String,Integer> countryBMMap= new Map<String,Integer>();
    map<String,Integer> countryCountMap = new map<String,Integer>();
    map<String,map<String,boolean>> bonus_Threshold_Trad_Dig_BM_Map = new map<String,map<String,boolean>>();
    List<AF_Sub_Result__c> Bonus_SubResult_List = new List<AF_Sub_Result__c>();
     map<String,map<String,boolean>> bonus_Threshold_Trad_Dig_BM_MapTemp = new map<String,map<String,boolean>>();
     map<string,AF_Sub_Result__c>mapBonus_result=new map<string,AF_Sub_Result__c>();
     Map<String,Integer> EntityAmtMap = new Map<String,Integer>();
     Map<String,Integer> BonusMeasureShowMap = new Map<String,Integer>();
     Map<String,Integer> BonusMeasureCalcMap = new Map<String,Integer>();
    /*End code refactoring*/
    /**********************************************************************
*  @Description: Contructor method
*  @name : AF_AnnualBonus
*  @param : none
*  @return : none
*************************************************************************/
    public  AF_AnnualBonus() {
        Boolean isQuantEmpty;
        string Country_name;
        integer Traditional_value;
        integer Digital_value;
        string agency_name;
        string Brand_name;
        noDisplay=true;
        noDisplayQuarterly=true;
        IsDraft=True;
        sum_of_bonusable_fees=0;// 30-08-2014
        sum_of_bonusable_fees_onload=0;//03-09-2014
        Sum_remuneration_val=0;
        Sum_remuneration_per=0;
        sum_of_quant_qual_value=0;
        sum_of_quant_qual_percent=0;
        sum_of_qual_value=0;
        sum_of_qual_percent=0;
        qual_per=0;
        Qual_value=0;
        IsEditable=false;
        isAgency = false;
        agency_name='';
        Brand_name=''; 
        Country_name='';
        Traditional_value=0;
        Digital_value=0;
        total_bonus_fees=0;
        sum_of_bonus_per=0;
        sum_of_bonus_val =0;
        Totals_Traditional=0;
        Totals_Digital=0;
        //TotalTraditionalValue=0;
        //TotalDigitalValue=0;
        isQuantEmpty=false;
        AF_Pilot_Model = false;
        No_Bonus_Check= false;
        Totals_BonusMeasureTrad =0;
        Totals_BonusMeasureDigital=0;
        showSubmit=false;
        QuartelyBonus=new list<wrapbonus>();// Initialization of wrapper class
        String Brand_id = ApexPages.currentPage().getParameters().get('Brandid');//get brand id from url
        String agency_id=ApexPages.currentPage().getParameters().get('Agencyid');// get agency id from url
        String current_year=ApexPages.currentPage().getParameters().get('Year');// get fiscal year
        User userObj = new User();
        userObj = [SELECT Id, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c FROM User WHERE Id =:UserInfo.getUserId()];// Get profile name and user type of current logedin user
        if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER|| userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE||userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER)
        {
            IsEditable=true;
        }
        if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
            isAgency = true;
        }
        list<AF_Brand_Estimate__c>Pilot_model=[SELECT ID,AF_Pilot_Model__c,AF_No_Bonus__c FROM AF_Brand_Estimate__c WHERE  Brand__c=:Brand_id AND AF_Agency__c=:agency_id AND AF_Fiscal_Year__c=:current_year AND AF_Active__c=True];
        if(Pilot_model.size()>0){
            AF_Pilot_Model= Pilot_model.get(0).AF_Pilot_Model__c; 
            No_Bonus_Check = Pilot_model.get(0).AF_No_Bonus__c;
        }
        if(!AF_Pilot_Model){
            //new variables
            list<AF_Bonus_Threshold__c> Bonus_Result_list= new list<AF_Bonus_Threshold__c>();
            Set<Id> btId = new Set<Id>();
            Bonus_Result_list=[SELECT id FROM AF_Bonus_Threshold__c WHERE Agency_Name__c =:agency_id AND Brand_Name__c=:Brand_id AND Year__c=:current_year order by AF_Country__r.AF_Country__c ASC ];
            if(Bonus_Result_list.size()>0){
                for(AF_Bonus_Threshold__c bt:Bonus_Result_list){
                    btId.add(bt.Id);
                }
            }
            Bonus_SubResult_List = [SELECT AF_Qual_Per__c,AF_Comment__c,AF_Quant__c,AF_Total_Bonus__c,AF_Qual__c,AF_Country__r.AF_Country__c,AF_Country__r.name,Bonus_Measure__c,AF_Locked__c,AF_country__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Year__c,AF_Digital__c,AF_Traditional__c,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Unique_Thresholds__c,AF_Quant_Bonus_Value__c,AF_Total_Bonus_Value__c,AF_Bonusable_Fees__c,AF_Quant_Bonus__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :btId and AF_Period__c=null];
            if(Bonus_SubResult_List.size()>0){
                showmainblock=true;
                annualBonusConstructorExt(Bonus_SubResult_List);
                annualBonusDigitalTradExt(Bonus_SubResult_List);
                
            }
            annualBonusQuantQualExt(Bonus_SubResult_List);
            
            list<AF_Agency_Estimate__c> oddagencylist=new   list<AF_Agency_Estimate__c>();
            set<String> setofnonthreshold_country = new set<String>();
            oddagencylist=[Select ID,AF_Total__c,AF_Unilever_Entity__r.AF_Country__c from AF_Agency_Estimate__c where AF_Unilever_Entity__r.AF_Country__c !=:Countryname_BT and AF_Agency_Entity__r.AF_Agency__c=:agency_id.substring(0,15) and AF_Brand_Id__c=:Brand_id.substring(0,15) and AF_Brand_Estimate__r.AF_Active__c=True and AF_Fiscal_Year__c=:current_year];
            if(oddagencylist.size()>0){
                for(AF_Agency_Estimate__c oddagency:oddagencylist){
                    if(oddagency.AF_Total__c>0){
                        setofnonthreshold_country.add(oddagency.AF_Unilever_Entity__r.AF_Country__c);
                    }
                } 
                if(setofnonthreshold_country.size()>0 && !No_Bonus_Check){
                    Apexpages.addmessage(new apexpages.message(apexpages.severity.WARNING, Label.AF_BonusThershold_Mismatch+ ' '+ setofnonthreshold_country ));
                }
            }
            
            
            annualBonusTradDigitalCalc();
           
            sum_of_bonusable_fees=Totals_BonusMeasureTrad+Totals_BonusMeasureDigital;
            annualBonusTotalTradDigitalCalc();
            annualBonusBMCalc(Bonus_SubResult_List);
            
            annualBonusQualQuantPerCalc(Bonus_SubResult_List);
          
        } 
        if(AF_Pilot_Model)
        {
            annualBonusPilotModel(agency_id,Brand_id,current_year);
        }   
    }
    
    /*********************************************************************************
*  @Description: this method is used to as an extension of the construtor
*  @param : none
*  @return: none.
***************************************************************************************/    
    public void annualBonusConstructorExt(List<AF_Sub_Result__c> Bonus_SubResult_List){
        for(AF_Sub_Result__c bonus_SubResult_Obj:Bonus_SubResult_List){
                    Countryname_BT.add(bonus_SubResult_Obj.AF_Country__r.AF_Country__c);
                    string brandname_id=bonus_SubResult_Obj.AF_Bonus_Threshold__r.Brand_Name__c;
                    string agencyname_id=bonus_SubResult_Obj.AF_Bonus_Threshold__r.Agency_Name__c;
                    string str=agencyname_id+'::'+ brandname_id+'::'+bonus_SubResult_Obj.AF_Country__r.AF_Country__c+'::'+bonus_SubResult_Obj.AF_Bonus_Threshold__r.Year__c;
                    agencyEstUnqStr.add(str);
                    String countryDigital = bonus_SubResult_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                    String countryTrad = bonus_SubResult_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                    Integer count=0;
                    if(bonus_SubResult_Obj.AF_Digital__c){
                        if(!countryBMMap.containsKey(countryDigital)){
                            countryBMMap.put(countryDigital,1);
                        }
                        else{
                            count = countryBMMap.get(countryDigital);
                            count=count +1;
                            countryBMMap.put(countryDigital,count);
                        }
                    }
                    if(bonus_SubResult_Obj.AF_Traditional__c){
                        if(!countryBMMap.containsKey(countryTrad)){
                            countryBMMap.put(countryTrad,1);
                        }
                        else{
                            count = countryBMMap.get(countryTrad);
                            count=count +1;
                            countryBMMap.put(countryTrad,count);
                        }
                    }
                    Integer unileverContCount =0;
                    if(!countryCountMap.containsKey(bonus_SubResult_Obj.AF_Country__r.AF_Country__c)){
                        unileverContCount = unileverContCount + 1;
                        countryCountMap.put(bonus_SubResult_Obj.AF_Country__r.AF_Country__c,unileverContCount);
                    }
                    else{
                        unileverContCount = countryCountMap.get(bonus_SubResult_Obj.AF_Country__r.AF_Country__c);
                        unileverContCount = unileverContCount+1;
                        countryCountMap.put(bonus_SubResult_Obj.AF_Country__r.AF_Country__c,unileverContCount);
                    }
                    String BMStr = bonus_SubResult_Obj.AF_Unique_Thresholds__c;
                    map<String,boolean> tradDigMapBM = new map<String,boolean>();
                    tradDigMapBM.put(AF_Constants.DIGITAL,bonus_SubResult_Obj.AF_Digital__c);
                    tradDigMapBM.put(AF_Constants.TRADITIONAL,bonus_SubResult_Obj.AF_Traditional__c);
                    bonus_Threshold_Trad_Dig_BM_Map.put(BMStr,tradDigMapBM);
                }
    }
    /**********************************************************************************************
*  @Description: this method is used to as an extension of the construtor for Trad and Digital Map
*  @param : none
*  @return: none.
***************************************************************************************************/    
    public void annualBonusDigitalTradExt(List<AF_Sub_Result__c> Bonus_SubResult_List){
        for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List){
                    String countryDigital = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                    String countryTrad = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                    map<String,boolean> tradDigMapBMtemp = new map<String,boolean>();
                    string brandname_id=bonus_Threshold_Obj.AF_Bonus_Threshold__r.Brand_Name__c;
                    string agencyname_id=bonus_Threshold_Obj.AF_Bonus_Threshold__r.Agency_Name__c;
                    String StrTemp = agencyname_id+'::'+ brandname_id+'::'+bonus_Threshold_Obj.AF_Country__r.AF_Country__c+'::'+bonus_Threshold_Obj.AF_Bonus_Threshold__r.Year__c;
                    if(countryBMMap.size()>0){
                        if(countryBMMap.get(countryDigital)>0 && countryBMMap.get(countryTrad) >0){
                            tradDigMapBMtemp.put(AF_Constants.TRADITIONAL,true);
                            tradDigMapBMtemp.put(AF_Constants.DIGITAL,true);
                        }
                        else if(countryBMMap.get(countryDigital)>0){
                            tradDigMapBMtemp.put(AF_Constants.DIGITAL,true);
                            tradDigMapBMtemp.put(AF_Constants.TRADITIONAL,false);
                        }
                        else if(countryBMMap.get(countryTrad)>0){
                            tradDigMapBMtemp.put(AF_Constants.TRADITIONAL,true);
                            tradDigMapBMtemp.put(AF_Constants.DIGITAL,false);
                        }
                        bonus_Threshold_Trad_Dig_BM_MapTemp.put(StrTemp,tradDigMapBMtemp);
                    }
                } 
    }
   /**********************************************************************************************
*  @Description: this method is used to as an extension of the construtor Quant,Qual calculation
*  @param : none
*  @return: none.
***************************************************************************************************/    
    public void annualBonusQuantQualExt(List<AF_Sub_Result__c> Bonus_SubResult_List){
        for(AF_Sub_Result__c bonusResObj:Bonus_SubResult_List){
                mapBonus_result.put(bonusResObj.AF_Unique_Thresholds__c,bonusResObj);
                if(bonusResObj.AF_Quant_Bonus_Value__c!=null){
                    sum_of_bonus_val=sum_of_bonus_val + integer.valueof(bonusResObj.AF_Quant_Bonus_Value__c);
                }
                if(bonusResObj.AF_Total_Bonus_Value__c!=null){
                    sum_of_quant_qual_value=sum_of_quant_qual_value + bonusResObj.AF_Total_Bonus_Value__c;
                }
                if(bonusResObj.AF_Bonusable_Fees__c!=null){
                    sum_of_bonusable_fees_onload=sum_of_bonusable_fees_onload+bonusResObj.AF_Bonusable_Fees__c;
                    if(sum_of_bonusable_fees_onload>0)
                    sum_of_quant_qual_percent=math.round((sum_of_quant_qual_value/sum_of_bonusable_fees_onload)*100);
                }
                if(bonusResObj.AF_Quant_Bonus__c!=null){
                    if(sum_of_bonusable_fees_onload>0)
                    sum_of_bonus_per=math.round((sum_of_bonus_val/sum_of_bonusable_fees_onload)*100);
                }
            }
    }
   /**********************************************************************************************
*  @Description: this method is used to as an extension of the construtor Trad,Digital calculation
*  @param : none
*  @return: none.
***************************************************************************************************/        
    public void annualBonusTradDigitalCalc(){
         for(AF_Agency_Estimate__c agEstObj:[Select id,AF_Total__c,AF_Bonus_Agency_Formula__c,name,Agency_Account__c,Brand__c, AF_Unilever_Entity__c,AF_Digital__c,AF_Traditional__c,AF_Unilever_Entity__r.AF_Country__c from AF_Agency_Estimate__c where AF_Bonus_Agency_Formula__c IN :agencyEstUnqStr and AF_Brand_Estimate__r.AF_Active__c=True])
            {
                String UEntityTrad= agEstObj.AF_Unilever_Entity__r.AF_Country__c + '::' + 'T';
                String UEntityDigital = agEstObj.AF_Unilever_Entity__r.AF_Country__c + '::' + 'D';
                Integer TradValue=0;
                Integer DigitalValue=0;
                if(!EntityAmtMap.containsKey(UEntityDigital)){
                    DigitalValue = DigitalValue + (integer.valueof(agEstObj.AF_Digital__c));
                    EntityAmtMap.put(UEntityDigital,DigitalValue);
                }
                else{
                    DigitalValue = EntityAmtMap.get(UEntityDigital);
                    DigitalValue = DigitalValue + (integer.valueof(agEstObj.AF_Digital__c));
                    EntityAmtMap.put(UEntityDigital,DigitalValue);
                }
                if(!EntityAmtMap.containsKey(UEntityTrad)){
                    TradValue = TradValue + (integer.valueof(agEstObj.AF_Traditional__c));
                    EntityAmtMap.put(UEntityTrad,TradValue);
                }
                else{
                    TradValue = EntityAmtMap.get(UEntityTrad);
                    TradValue = TradValue + (integer.valueof(agEstObj.AF_Traditional__c));
                    EntityAmtMap.put(UEntityTrad,TradValue);
                }
                if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c)!=null){
                    if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get(AF_Constants.DIGITAL) && bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get(AF_Constants.TRADITIONAL)){
                        Totals_BonusMeasureDigital = Totals_BonusMeasureDigital + (integer.valueof(agEstObj.AF_Digital__c));
                        Totals_BonusMeasureTrad = Totals_BonusMeasureTrad + (integer.valueof(agEstObj.AF_Traditional__c));
                    }
                    else if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get(AF_Constants.DIGITAL)){
                        Totals_BonusMeasureDigital = Totals_BonusMeasureDigital + (integer.valueof(agEstObj.AF_Digital__c));
                    }
                    else if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get(AF_Constants.TRADITIONAL)){
                        Totals_BonusMeasureTrad = Totals_BonusMeasureTrad + (integer.valueof(agEstObj.AF_Traditional__c));
                    }
                }
            } 
    }
   /*********************************************************************************
*  @Description: this method is used to calculate the Quant Bonus for the Annual Bonus
*  @name : Calculate_Bonus
*  @param : none
*  @return: none.
***************************************************************************************/    
    public void annualBonusPilotModel(String agency_id,String Brand_id,String current_year){
            bonusTradDigitalFee = 0;
            integer TotalTraditionalValue=0;
            integer TotalDigitalValue=0;
            Decimal renumRating = 0;
            Decimal renumPercentage=0;
            Decimal renumAmt=0.0;
            Boolean resultLock=false;
            Decimal RenumTotal=0.0;
            bonusThresholdRenumeration = new list<AF_Bonus_Threshold__c>();
            bonusResult = new list<AF_Bonus_Results__c>();
            renumBonus = new List<wrapRenumartionbonus>();
            bonusThresholdRenumeration =[select id,AF_Digital__c,AF_Traditional__c from AF_Bonus_Threshold__c where Agency_Name__c =:agency_id and Brand_Name__c=:Brand_id and Year__c=:current_year and AF_Country__c=null limit 1];
            for(AF_Agency_Estimate__c agEstObj:[Select id,AF_Total__c,AF_Bonus_Agency_Formula__c,name,Agency_Account__c,Brand__c, AF_Unilever_Entity__c,AF_Digital__c,AF_Traditional__c,AF_Unilever_Entity__r.name from AF_Agency_Estimate__c where AF_Agency_Entity__r.AF_Agency__c=:agency_id and AF_Brand_Estimate__r.Brand__c=:Brand_id and AF_Fiscal_Year__c=:current_year and AF_Brand_Estimate__r.AF_Active__c=True]){
                if(bonusThresholdRenumeration[0].AF_Digital__c){
                    TotalDigitalValue=TotalDigitalValue + (integer.valueof(agEstObj.AF_Digital__c));
                }
                if(bonusThresholdRenumeration[0].AF_Traditional__c){
                    TotalTraditionalValue=TotalTraditionalValue + (integer.valueof(agEstObj.AF_Traditional__c));
                }
            }
            bonusTradDigitalFee = bonusTradDigitalFee+TotalTraditionalValue+TotalDigitalValue;
            try{
                bonusResult=[select AF_Total_Bonus_Value__c,AF_Remuneration_Percentage__c,AF_Remuneration_Rating__c,AF_Locked__c,AF_Total_Remuneration__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c=:bonusThresholdRenumeration[0].Id limit 1];
                if(!(bonusResult.isEmpty())){
                    renumBonus.add(new wrapRenumartionbonus(bonusTradDigitalFee,bonusResult[0].AF_Remuneration_Rating__c,bonusResult[0].AF_Remuneration_Percentage__c,bonusResult[0].AF_Total_Remuneration__c,bonusResult[0].AF_Locked__c,bonusResult[0].AF_Total_Bonus_Value__c));
                }
                else{
                    renumBonus.add(new wrapRenumartionbonus(bonusTradDigitalFee,renumRating,renumPercentage,renumAmt,resultLock,RenumTotal));
                }
                if(bonusTradDigitalFee==0){
                    noDisplay=false;
                }
            }
            catch(Exception ex){
           AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_Constants.TEST_ANNUAL_BONUS,'AF_AnnualBonus',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString()); 
            }
    }
   /*********************************************************************************
*  @Description: this method is used to calculate the Quant Bonus for the Annual Bonus
                 on load of the screen,which retrieves the data from backend and display.
                 On save from the UI,it calculates the Quant and Qual% and update the backend
*  @name : Calculate_Bonus
*  @param : List<AF_Sub_Result__c>
*  @return: none.
***************************************************************************************/
    public void annualBonusQualQuantPerCalc(List<AF_Sub_Result__c> Bonus_SubResult_List){
          Decimal totalbonusval=0;
          for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List)
            {
                //AF_AnnualBonus_Qual__c Custom_Qualatative=AF_AnnualBonus_Qual__c.getInstance(AF_Constants.TEST_QUAL_VALUE);  
                string strBM = bonus_Threshold_Obj.AF_Unique_Thresholds__c;
                if(mapBonus_result.containskey(bonus_Threshold_Obj.AF_Unique_Thresholds__c)){
                ifLoop();
                }
                else{
                    Qual_value=0;
                    qual_per=0; 
                }
                Integer count=0;
                String countryDigital = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                String countryTrad = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get(AF_Constants.DIGITAL)){
                    count = BonusMeasureCalcMap.get(countryDigital);
                }
                if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get(AF_Constants.TRADITIONAL)){
                    count = count+BonusMeasureCalcMap.get(countryTrad);
                }
                if(mapBonus_result.containsKey(bonus_Threshold_Obj.AF_Unique_Thresholds__c) && (mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==0 || mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==null)){
                    QuartelyBonus.add(new wrapbonus(0,Qual_value,qual_per,bonus_Threshold_Obj.AF_Bonus_Threshold__c,bonus_Threshold_Obj.AF_Country__r.AF_Country__c,bonus_Threshold_Obj.AF_Minimum__c,bonus_Threshold_Obj.AF_Stretching__c,bonus_Threshold_Obj.AF_Outstanding__c,mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c),count,bonus_Threshold_Obj.Bonus_Measure__c,countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c)));
                }else if(!mapBonus_result.containsKey(bonus_Threshold_Obj.AF_Unique_Thresholds__c)){
                    QuartelyBonus.add(new wrapbonus(0,Qual_value,qual_per,bonus_Threshold_Obj.AF_Bonus_Threshold__c,bonus_Threshold_Obj.AF_Country__r.AF_Country__c,bonus_Threshold_Obj.AF_Minimum__c,bonus_Threshold_Obj.AF_Stretching__c,bonus_Threshold_Obj.AF_Outstanding__c,new AF_Sub_Result__c(),count,bonus_Threshold_Obj.Bonus_Measure__c,countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c)));
                }
                else if(mapBonus_result.containsKey(bonus_Threshold_Obj.AF_Unique_Thresholds__c) && mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c!=0){
                    Integer newAmt = Integer.valueOf(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c);
                    QuartelyBonus.add(new wrapbonus(0,Qual_value,qual_per,bonus_Threshold_Obj.AF_Bonus_Threshold__c,bonus_Threshold_Obj.AF_Country__r.AF_Country__c,bonus_Threshold_Obj.AF_Minimum__c,bonus_Threshold_Obj.AF_Stretching__c,bonus_Threshold_Obj.AF_Outstanding__c,mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c),newAmt,bonus_Threshold_Obj.Bonus_Measure__c,countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c)));
                }
                if(totalbonusval==0){
                    noDisplayQuarterly = false;
                }
            }
    }
    
   /*********************************************************************************
*  @Description: this method is used to calculate the Quant Bonus for the Annual Bonus
                 on load of the screen,which retrieves the data from backend and display.
                 On save from the UI,it calculates the Quant and Qual% and update the backend
*  @name : Calculate_Bonus
*  @param : List<AF_Sub_Result__c>
*  @return: none.
***************************************************************************************/  
    
    public void ifLoop(){
     for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List)
            {
            AF_AnnualBonus_Qual__c Custom_Qualatative=AF_AnnualBonus_Qual__c.getInstance(AF_Constants.TEST_QUAL_VALUE);  
                string strBM = bonus_Threshold_Obj.AF_Unique_Thresholds__c;
    if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==0 || mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==null){
                  if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c!=null){
                      qual_per = mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c;
                  }
                  else{
                      qual_per=0;
                  }
                  if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==1 || mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==2){
                      Qual_value=Custom_Qualatative.X1__c;
                      sum_of_qual_value=sum_of_qual_value + Qual_value;
                  }
                  else if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==3){
                      if(BonusMeasureShowMap.get(strBM)!=null){
                          Qual_value=BonusMeasureShowMap.get(strBM)*Custom_Qualatative.X3__c/100;
                          sum_of_qual_value=sum_of_qual_value + Qual_value;
                      }
                  }
                  else if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==4){
                      if(BonusMeasureShowMap.get(strBM)!=null){
                          Qual_value=BonusMeasureShowMap.get(strBM)*Custom_Qualatative.X4__c/100;
                          sum_of_qual_value=sum_of_qual_value + Qual_value;
                      }
                  }
                  else if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==5){
                       if(BonusMeasureShowMap.get(strBM)!=null){
                          Qual_value=BonusMeasureShowMap.get(strBM)*Custom_Qualatative.X5__c/100;
                          sum_of_qual_value=sum_of_qual_value + Qual_value;
                      }
                  }
              }
              else if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c!=0){
                  if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c!=null){
                      qual_per = mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual_Per__c;
                  }
                  else{
                      qual_per=0;
                  }
                  if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==1 || mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==2){
                      Qual_value=Custom_Qualatative.X1__c;
                      sum_of_qual_value=sum_of_qual_value + Qual_value;
                  }
                  else if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==3){
                      if(BonusMeasureShowMap.get(strBM)!=null){
                          Qual_value=Integer.valueOf(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c)*Custom_Qualatative.X3__c/100;
                          sum_of_qual_value=sum_of_qual_value + Qual_value;
                      }
                  }
                  else if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==4){
                      if(BonusMeasureShowMap.get(strBM)!=null){
                          Qual_value=Integer.valueOf(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c)*Custom_Qualatative.X4__c/100;
                          sum_of_qual_value=sum_of_qual_value + Qual_value;
                      }
                  }
                  else if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==5){
                       if(BonusMeasureShowMap.get(strBM)!=null){
                          Qual_value=Integer.valueOf(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c)*Custom_Qualatative.X5__c/100;
                          sum_of_qual_value=sum_of_qual_value + Qual_value;
                      }
                  }
              }
              }
    }
    
   /*********************************************************************************
*  @Description: this method is used to calculate the Digital and Traditional amounts of the 
                 Agency estimates with Bonus Threshold
*  @name : annualBonusTotalTradDigitalCalc
*  @param : none
*  @return: none.
***************************************************************************************/    
    public void annualBonusTotalTradDigitalCalc(){
         for(String countryName:Countryname_BT){
                String countryDigital = countryName + '::' + 'D';
                String countryTrad = countryName + '::' + 'T';
                Integer count=0;
                Integer Amt =0;
                Integer calc=0;
                count = countryBMMap.get(countryDigital);
                Amt = EntityAmtMap.get(countryDigital);
                if(count>0 && Amt!=null){
                    calc = integer.valueof(Amt/count);
                }
                BonusMeasureCalcMap.put(countryDigital,calc);
                count=0;
                Amt =0;
                calc=0;
                count = countryBMMap.get(countryTrad);
                Amt = EntityAmtMap.get(countryTrad);
                if(count>0 && Amt!=null){
                    calc = integer.valueof(Amt/count);
                }
                BonusMeasureCalcMap.put(countryTrad,calc);
            }
    }
   /*********************************************************************************
*  @Description: this method is used to calculate the Digital and Traditional amounts of the 
                 Agency estimates with Bonus Threshold and store it in Map to process in other methods
*  @name : annualBonusBMCalc
*  @param : List<AF_Sub_Result__c>
*  @return: none.
***************************************************************************************/        
    public void annualBonusBMCalc(List<AF_Sub_Result__c> Bonus_SubResult_List){
        Integer totalBMCalc=0;
            Integer BMDiff =0;
            
            for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List){
                string strBM = bonus_Threshold_Obj.AF_Unique_Thresholds__c;
                Integer count=0;
                String countryDigital = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                String countryTrad = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get(AF_Constants.DIGITAL)){
                    count = BonusMeasureCalcMap.get(countryDigital);
                }
                if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get(AF_Constants.TRADITIONAL)){
                    count = count+BonusMeasureCalcMap.get(countryTrad);
                }
                BonusMeasureShowMap.put(strBM,count);
                totalBMCalc = totalBMCalc + count;
            }
            BMDiff = integer.valueof(sum_of_bonusable_fees) - totalBMCalc;
            Integer loopBM=0;
            for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List)
            {
                string strBM = bonus_Threshold_Obj.AF_Unique_Thresholds__c;
                Integer count=0;
                if(countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c)>1 && loopBM==0){
                    count = BonusMeasureShowMap.get(strBM);
                    count = count + BMDiff;
                    BonusMeasureShowMap.put(strBM,count);
                    loopBM= loopBM+1;
                }
            }
    }
    /*********************************************************************************
*  @Description: this method is used to calculate the Quant Bonus for the Annual Bonus
*  @name : Calculate_Bonus
*  @param : none
*  @return: none.
***************************************************************************************/
    public void Calculate_Bonus() {
        sum_of_bonus_per=0;
        sum_of_bonus_val=0;
        sum_of_quant_qual_value=0;
        sum_of_quant_qual_percent=0;
        Decimal Quantvalue=0;
        sum_of_bonusable_fees=0;
        for(wrapbonus newbonus:QuartelyBonus ){ 
            if(newbonus.total_bonus_fees!=null){
                sum_of_bonusable_fees=sum_of_bonusable_fees+newbonus.total_bonus_fees;
                if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Outstanding_bonus) {
                    AF_QuarterlyBonus__c Custom_Bonusthreshold=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_BONUS_THRESHOLD);
                    Decimal bonus_outstanding=Custom_Bonusthreshold.Outstanding__c; 
                    Quantvalue=bonus_outstanding;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setScale(2, RoundingMode.HALF_UP);
                } 
                else if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Streching_bonus & newbonus.bonusResObj.AF_Quant__c<newbonus.Outstanding_bonus) {
                    AF_QuarterlyBonus__c Custom_Bonusthreshold=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_BONUS_THRESHOLD);
                    Decimal bonus_stretching=Custom_Bonusthreshold.Stretching__c; 
                    Decimal bonus_min=Custom_Bonusthreshold.Minimum__c;
                    Quantvalue=bonus_stretching+ bonus_min* (newbonus.bonusResObj.AF_Quant__c-newbonus.Streching_bonus)/(newbonus.Outstanding_bonus-newbonus.Streching_bonus)  ;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setScale(2, RoundingMode.HALF_UP);
                } 
                else if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Minimum_bonus & newbonus.bonusResObj.AF_Quant__c<newbonus.Streching_bonus) {
                    AF_QuarterlyBonus__c Custom_Bonusthreshold=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_BONUS_THRESHOLD);
                    Decimal bonus_minimum=Custom_Bonusthreshold.Minimum__c; 
                    Quantvalue=bonus_minimum + bonus_minimum * (newbonus.bonusResObj.AF_Quant__c-newbonus.Minimum_bonus)/(newbonus.Streching_bonus-newbonus.Minimum_bonus)  ;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setScale(2, RoundingMode.HALF_UP);
                }
                else if (newbonus.bonusResObj.AF_Quant__c!=null && newbonus.bonusResObj.AF_Quant__c<newbonus.Minimum_bonus) {
                    Quantvalue=0;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setScale(2, RoundingMode.HALF_UP);
                }
                else if(newbonus.bonusResObj.AF_Quant__c==null){
                    newbonus.bonusResObj.AF_Quant_Bonus__c=0;
                }
                if(newbonus.bonusResObj.AF_Quant_Bonus__c!=null){
                    newbonus.bonusResObj.AF_Quant_Bonus_Value__c=math.round(newbonus.total_bonus_fees* newbonus.bonusResObj.AF_Quant_Bonus__c/100);
                    sum_of_bonus_val=sum_of_bonus_val + newbonus.bonusResObj.AF_Quant_Bonus_Value__c;
                    newbonus.bonusResObj.AF_Total_Bonus__c=newbonus.bonusResObj.AF_Quant_Bonus__c+newbonus.QualPercent;
                    newbonus.bonusResObj.AF_Total_Bonus_Value__c=newbonus.bonusResObj.AF_Quant_Bonus_Value__c+ newbonus.QualValue;
                    sum_of_quant_qual_value=sum_of_quant_qual_value+newbonus.bonusResObj.AF_Total_Bonus_Value__c;
                    if(sum_of_bonusable_fees>0)
                    {
                        sum_of_quant_qual_percent=math.round((sum_of_quant_qual_value/sum_of_bonusable_fees)*100);
                        sum_of_bonus_per=math.round((sum_of_bonus_val/sum_of_bonusable_fees)*100);
                    }
                }
            }   
        } 
    }
    /*********************************************************************************
*  @Description: this method is used to calculate the Qual Bonus for the Annual Bonus
*  @name : Calculate_Qual
*  @param : none
*  @return: none.
***************************************************************************************/
    public void Calculate_Qual() {
        sum_of_qual_value=0;
        sum_of_qual_percent=0; 
        sum_of_quant_qual_value=0;
        sum_of_quant_qual_percent=0;
        //30-08-2014
        sum_of_bonusable_fees=0;
        //up to here
        AF_AnnualBonus_Qual__c Custom_Qualatative=AF_AnnualBonus_Qual__c.getInstance(AF_Constants.TEST_QUAL_VALUE);
        for(wrapbonus newbonus:QuartelyBonus ){
            if(newbonus.total_bonus_fees!=null){
                //30-08-2014
                sum_of_bonusable_fees=sum_of_bonusable_fees+newbonus.total_bonus_fees;
                //upto here
                if (newbonus.bonusResObj.AF_Qual__c==1||newbonus.bonusResObj.AF_Qual__c==2||newbonus.bonusResObj.AF_Qual__c==0) {
                    newbonus.QualValue=Custom_Qualatative.X1__c; 
                } 
                else if(newbonus.bonusResObj.AF_Qual__c==3){
                    newbonus.QualValue=newbonus.total_bonus_fees*Custom_Qualatative.X3__c/100; 
                }
                else if(newbonus.bonusResObj.AF_Qual__c==4){
                    newbonus.QualValue=newbonus.total_bonus_fees*Custom_Qualatative.X4__c/100; 
                }
                else if(newbonus.bonusResObj.AF_Qual__c==5){
                    newbonus.QualValue=newbonus.total_bonus_fees*Custom_Qualatative.X5__c/100; 
                }
                else if(newbonus.bonusResObj.AF_Qual__c==null){
                    newbonus.QualValue =0;
                }   
                if(newbonus.total_bonus_fees!=0 ){ 
                    newbonus.QualPercent=Math.round(newbonus.QualValue*100/newbonus.total_bonus_fees);
                }
                sum_of_qual_value=sum_of_qual_value+newbonus.QualValue;
                if(newbonus.bonusResObj.AF_Quant_Bonus__c!=null){ 
                    newbonus.bonusResObj.AF_Total_Bonus__c=newbonus.bonusResObj.AF_Quant_Bonus__c+newbonus.QualPercent;
                    newbonus.bonusResObj.AF_Total_Bonus_Value__c=newbonus.bonusResObj.AF_Quant_Bonus_Value__c+ newbonus.QualValue;
                    sum_of_quant_qual_value = sum_of_quant_qual_value + newbonus.bonusResObj.AF_Total_Bonus_Value__c; 
                    //30-08-2014
                    if(sum_of_bonusable_fees>0){
                        sum_of_quant_qual_percent=math.round((sum_of_quant_qual_value/sum_of_bonusable_fees)*100);
                        sum_of_qual_percent=math.round((sum_of_qual_value/sum_of_bonusable_fees)*100);
                    }
                    //upto here
                } 
            }
        }
    } 
    /*********************************************************************************
*  @Description: this method is used to calculate the Remuneration% for the Annual Bonus
*  @name : Calculate_Remun2
*  @param : none
*  @return: none.
***************************************************************************************/
    public void Calculate_Remun2() {
        AF_AnnualBonus_Qual__c Custom_Qualatative=AF_AnnualBonus_Qual__c.getInstance(AF_Constants.TEST_QUAL_VALUE);
        for(wrapRenumartionbonus newbonus:renumBonus ){
            if(newbonus.bonusableFees!=null){ 
                if (newbonus.renumRating==1||newbonus.renumRating==2) {
                    newbonus.renumPercentage=Custom_Qualatative.X1__c; 
                } 
                else if(newbonus.renumRating==3){
                    newbonus.renumPercentage=Custom_Qualatative.X3__c; 
                }
                else if(newbonus.renumRating==4){
                    newbonus.renumPercentage=Custom_Qualatative.X4__c; 
                }
                else if(newbonus.renumRating>=5){
                    newbonus.renumPercentage=Custom_Qualatative.X5__c; 
                } 
                if(newbonus.renumPercentage!=null){ 
                    newbonus.renumCalcAmount=(newbonus.bonusableFees*newbonus.renumPercentage)/100;   
                }
            }
        }
    }
    /***************************************************************************************
*  @Description: this method is used to calculate the Remuneration Amount for the Annual Bonus
*  @name : Calculate_Remun_Per2
*  @param : none
*  @return: none.
********************************************************************************************/
    public void Calculate_Remun_Per2() {
        for(wrapRenumartionbonus newbonus:renumBonus ){
            if(newbonus.renumPercentage!=null){
                newbonus.renumCalcAmount = ((newbonus.bonusableFees*newbonus.renumPercentage)/100).setScale(2, RoundingMode.HALF_UP);
            }
        }
    }
    /***************************************************************************************
*  @Description: this method is used to update the calculated Bonus value for the Annual Bonus
*  @name : UpdateBonus
*  @param : none
*  @return: none.
********************************************************************************************/
    public void UpdateBonus() {
        Calculate_Bonus();
        Calculate_Qual();
        Boolean bException=false;
        list<AF_Sub_Result__c> bonus_latestlist=new list<AF_Sub_Result__c>();
        for(wrapbonus w_bonus:QuartelyBonus){
            w_bonus.bonusResObj.AF_Bonus_Threshold__c=w_bonus.bonus_threshold_id;
            w_bonus.bonusResObj.AF_Bonusable_Fees__c=w_bonus.total_bonus_fees;
            w_bonus.bonusResObj.AF_Total_bonus_fees__c=w_bonus.totalbonusfee;
            w_bonus.bonusResObj.Af_status__c=AF_Constants.STATUS_DRAFT;
            w_bonus.bonusResObj.AF_Qual_Per__c=w_bonus.QualPercent;
            w_bonus.bonusResObj.AF_Qual_Bonus_Value__c=w_bonus.QualValue;
            if(w_bonus.bonusResObj.AF_Qual__c==null || w_bonus.bonusResObj.AF_Quant__c==null){
                bException=true;
            }
            bonus_latestlist.add(w_bonus.bonusResObj);
        }
        Integer validateTotal =0;
        validateTotal = Totals_BonusMeasureTrad+Totals_BonusMeasureDigital;
        if(bException){
            String validationErrorMsg = Label.AF_Quant_Fields;
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,validationErrorMsg));
        }
        else if(sum_of_bonusable_fees!=validateTotal){
            String validationError=Label.AF_Adjust_BonusableFees;
            Decimal Validationdifference= sum_of_bonusable_fees-validateTotal;
            Decimal Validationdifferencer =Validationdifference;
            if (Validationdifferencer <0) Validationdifferencer=Validationdifferencer*-1;
            validationError = validationError + AF_Constants.TARGET;
            if (Validationdifference>0)
            {
                validationError=validationError +AF_Constants.EXCEEDED_BY;
            }
            else
            {
                validationError=validationError +AF_Constants.MISSING_BY;    
            }
            validationError = validationError+ Validationdifferencer;
            validationError = validationError+AF_Constants.EURO;
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,validationError));
        }
        else{
            if(!bonus_latestlist.isEmpty()){
                Try{
                    upsert bonus_latestlist;
                    showSubmit = true;
                    apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,Label.AF_Record_Save));
                }
                catch(exception ex){
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(), AF_Constants.TEST_ANNUAL_BONUS,'UpdateBonus',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());   
                    apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_System_Admin));
                }
             }  
        }
    }
    /***************************************************************************************
*  @Description: this method is used to update the calculated Remuneration value for the Annual Bonus
*  @name : UpdateBonus2
*  @param : none
*  @return: none.
********************************************************************************************/
    public void  UpdateBonus2(){
        Calculate_Remun_Per2();
        Boolean isrenumEmptyupdate=false;
        AF_Bonus_Results__c newRecord = new AF_Bonus_Results__c();
        List<AF_Bonus_Results__c> newRecordList = new List<AF_Bonus_Results__c>();
        RecordType rt = [select id,Name from RecordType where SobjectType=:AF_Constants.SOBJECT_BONUSRESULT_APINAME and Name=:AF_Constants.ANNUAL_BONUS_REC_TYPE Limit 1];
        try{
            bonusResult = [select AF_Total_Bonus_Value__c,AF_Remuneration_Percentage__c,AF_Remuneration_Rating__c,AF_Locked__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c=:bonusThresholdRenumeration[0].Id];
        }
        catch(Exception ex){
        AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_Constants.TEST_ANNUAL_BONUS,'UpdateBonus2',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
        }
        for(wrapRenumartionbonus w_bonus:renumBonus){
            if(w_bonus.renumPercentage==null ){
                isrenumEmptyupdate=true;
            }
            newRecord.AF_Bonus_Thresholds__c = bonusThresholdRenumeration[0].Id;
            newRecord.AF_Bonusable_Fees__c = w_bonus.bonusableFees;
            newRecord.recordTypeId = rt.Id;
            newRecord.AF_Remuneration_Percentage__c = w_bonus.renumPercentage;
            newRecord.AF_Remuneration_Rating__c = w_bonus.renumRating;
            newRecord.Af_status__c = AF_Constants.STATUS_DRAFT;
            newRecord.AF_Total_Remuneration__c = w_bonus.renumCalcAmount;
            newRecord.AF_Total_Bonus_Value__c=w_bonus.renumCalcAmount;
            if(bonusResult.size()>0)
            newRecord.Id =  bonusResult[0].Id;
            newRecordList.add(newRecord);
        }
        if(isrenumEmptyupdate){
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Required_Result));
        }
        else{
            if(newRecordList.size()>0){
                Try{
                    upsert newRecord;
                    apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,Label.AF_Record_Save));
                }
                catch(exception ex){
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_Constants.TEST_ANNUAL_BONUS,'UpdateBonus2',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
                }
            }
        }
    }
    
    /***************************************************************************************
*  @Description: this method is used to update and Lock the calculated 
   @             Bonus value for the Annual Bonus
*  @name : ConfirmBonus
*  @param : none
*  @return: none.
********************************************************************************************/
    public void ConfirmBonus() {
        Calculate_Bonus();
        Calculate_Qual();
        Boolean bException=false;
        list<AF_Sub_Result__c> bonus_latestlist=new list<AF_Sub_Result__c>();
        for(wrapbonus w_bonus:QuartelyBonus){
            w_bonus.bonusResObj.AF_Bonus_Threshold__c=w_bonus.bonus_threshold_id;
            w_bonus.bonusResObj.AF_Bonusable_Fees__c=w_bonus.total_bonus_fees;
            w_bonus.bonusResObj.AF_Total_bonus_fees__c=w_bonus.totalbonusfee;
            w_bonus.bonusResObj.Af_status__c=AF_Constants.STATUS_SUBMITTED;
            w_bonus.bonusResObj.AF_Locked__c=true;
            w_bonus.bonusResObj.AF_Qual_Per__c=w_bonus.QualPercent;
            w_bonus.bonusResObj.AF_Qual_Bonus_Value__c=w_bonus.QualValue;
            if(w_bonus.bonusResObj.AF_Qual__c==null || w_bonus.bonusResObj.AF_Quant__c==null){
                bException=true;
            }
            bonus_latestlist.add(w_bonus.bonusResObj);   
        }
        if(bException){
            String validationErrorMsg = Label.AF_Quant_Fields;
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,validationErrorMsg));
        }
        else if(!bonus_latestlist.isEmpty()){
            Try{
                upsert bonus_latestlist;
                apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,Label.AF_Record_Submitted));
            }
            catch(exception ex){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_Constants.TEST_ANNUAL_BONUS,'ConfirmBonus',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
            }
        }
    }
    /***************************************************************************************
*  @Description: this method is used to update and Lock the calculated 
   @             Remuneration value for the Annual Bonus
*  @name : ConfirmBonus2
*  @param : none
*  @return: none.
********************************************************************************************/
    public void ConfirmBonus2(){
        Calculate_Remun_Per2();
        Boolean isrenumEmptyConfirm=false;
        AF_Bonus_Results__c newRecord = new AF_Bonus_Results__c();
        List<AF_Bonus_Results__c> newRecordList = new List<AF_Bonus_Results__c>();
        RecordType rt = [select id,Name from RecordType where SobjectType=:AF_Constants.SOBJECT_BONUSRESULT_APINAME and Name=:AF_Constants.ANNUAL_BONUS_REC_TYPE Limit 1];
        try{
            bonusResult = [select AF_Total_Bonus_Value__c,AF_Remuneration_Percentage__c,AF_Remuneration_Rating__c,AF_Locked__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c=:bonusThresholdRenumeration[0].Id];
        }catch(Exception ex){
        AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_Constants.TEST_ANNUAL_BONUS,'ConfirmBonus2',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
        }
        for(wrapRenumartionbonus w_bonus:renumBonus){
            if(w_bonus.renumPercentage==null ){
                isrenumEmptyConfirm=true;
            }
            newRecord.AF_Bonus_Thresholds__c = bonusThresholdRenumeration[0].Id;
            newRecord.AF_Bonusable_Fees__c = w_bonus.bonusableFees;
            newRecord.recordTypeId = rt.Id;
            newRecord.AF_Remuneration_Percentage__c = w_bonus.renumPercentage;
            newRecord.AF_Remuneration_Rating__c = w_bonus.renumRating;
            newRecord.Af_status__c = AF_Constants.STATUS_SUBMITTED;
            newRecord.AF_Locked__c = true;
            newRecord.AF_Total_Remuneration__c = w_bonus.renumCalcAmount;
            newRecord.AF_Total_Bonus_Value__c=w_bonus.renumCalcAmount;
            if(bonusResult.size()>0)
            newRecord.Id =  bonusResult[0].Id;
            newRecordList.add(newRecord);
        }
        if(isrenumEmptyConfirm){
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Quantitative_Results));
        }
        else{
            if(newRecordList.size()>0){
                Try{
                    upsert newRecord;
                    apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,Label.AF_Record_Submitted));
                }
                catch(exception ex){
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_Constants.TEST_ANNUAL_BONUS,'ConfirmBonus2',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
                }
            }
        }
    }
    /**********************************************************************
*  @Description: this is the Wrapper class to populate the Annual Bonus value
*  @name : wrapbonus
*  @param : none
*  @return: none
**********************************************************************/
    public class wrapbonus{
        public String Countryname{get;set;}
        public decimal Minimum_bonus{get;set;}
        Public decimal Streching_bonus{get;set;}
        Public decimal Outstanding_bonus{get;set;}
        public AF_Sub_Result__c bonusResObj {get;set;}
        public integer total_bonus_fees{get;set;}
        public id bonus_threshold_id{get;set;}
        public decimal QualValue{get;set;}
        public decimal QualPercent{get;set;}
        public Decimal totalbonusfee{get;set;}
        public String bonusMeasureMatrix{get;set;}
        public Integer countryCount{get;set;}
        public wrapbonus(Decimal totalbonusfee,
                         Decimal QualValue,
                         Decimal QualPercent,
                         Id b_threshold_id, 
                         String Country_Name, 
                         Decimal Minimum,
                         Decimal Streching,
                         Decimal Outstanding,
                         AF_Sub_Result__c bonusResObj1,
                         integer bonus_fees,
                         String bonusMeasure,
                         Integer cCount){
            this.Countryname=Country_Name;
            this.Minimum_bonus=minimum;
            this.Streching_bonus=Streching;
            this.Outstanding_bonus=Outstanding;
            this.bonusResObj=bonusResObj1;
            this.total_bonus_fees=bonus_fees;
            this.bonus_threshold_id=b_threshold_id;
            this.QualValue=QualValue;
            this.QualPercent=QualPercent;
            this.totalbonusfee=totalbonusfee;
            this.bonusMeasureMatrix = bonusMeasure;
            this.countryCount = cCount;
        }
    }
    /******************************************************************************
*  @Description: this is the Wrapper class to populate the Renumeration Bonus value
*  @name : wrapRenumartionbonus
*  @param : none
*  @return: none
*************************************************************************************/
    public class wrapRenumartionbonus{
        public Decimal bonusableFees{get;set;}
        public Decimal renumRating{get;set;}
        public Decimal renumPercentage{get;set;}
        public Decimal renumCalcAmount{get;set;}
        public Boolean Locked{get;set;}
        Public Decimal totalRenum{get;set;}
        public wrapRenumartionbonus(Decimal bonusableFees,Decimal renumRating,Decimal renumPercentage,Decimal renumCalcAmount,Boolean lock,Decimal totalRenum){
            this.bonusableFees = bonusableFees;
            this.renumRating = renumRating;
            this.renumPercentage = renumPercentage;
            this.renumCalcAmount = renumCalcAmount;
            this.Locked = lock;
            this.totalRenum=totalRenum;
        }
    }
}