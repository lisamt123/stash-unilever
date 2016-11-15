public class AF_AnnualBonus {
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
    public Boolean isQuantEmpty;// To ensure that quant inputbox can not be empty;
    public Boolean isTraditional { get; set; }//Check for traditional value
    public Integer Totals_Digital { get; set; }// To get total digital values for all display list
    public Boolean isDigital { get; set; }//Check for digital value
    public decimal sum_of_bonus_per { get; set; }// To hold sum of bonus percentage which is calculated by Quantative value
    public decimal sum_of_bonus_val { get; set; }// To hold sum of bonus value which is calculated by Quantative value
    public list<wrapbonus> QuartelyBonus {get;set;}//List to hold multiple object data
    public list<AF_Bonus_Results__c>AF_Bonus_Result{get;set;}//list of bonus result records
    public list<AF_Bonus_Threshold__c> AF_Bonus_Threshold{get;set;}// list of bonus threshold records
    public string Country_name;//store Unilever Entity name
    public integer Traditional_value;// To hold traditional value from agency estimates
    public integer Digital_value;// To hold digital value from agency estimates
    public integer TotalTraditionalValue;//To hold total traditional value from agency estimates
    public integer TotalDigitalValue;// To hold total digital value from agency estimates
    public integer total_bonus_fees;//To hold total bonusable fee which is sum of Traditional and Digital value
    public id threshold_id;// hold threshold id
    public string agency_name;// hold agency name
    public string Brand_name;// hold brand name
    public list<AF_Agency_Estimate__c>Agency_Estimate=new list<AF_Agency_Estimate__c>();// list of agency estimate
    public Boolean IsEditable{get;set;}// check for CMCO super user or category finance user
    public map<id,string>bonus_thresholdid=new  map<id,string>(); // map of bonus threshold with bonus threshold id alog with combination of agency id,brand id,unilever country and fiscal year
    set<string> Threshold = new set<string>();// store threshold id
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
    /**    constructor    **/
    public  AF_AnnualBonus() {
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
        Integer Quant=null;
        Country_name='';
        Traditional_value=0;
        Digital_value=0;
        total_bonus_fees=0;
        sum_of_bonus_per=0;
        sum_of_bonus_val =0;
        Totals_Traditional=0;
        Totals_Digital=0;
        TotalTraditionalValue=0;
        TotalDigitalValue=0;
        isQuantEmpty=false;
        AF_Pilot_Model = false;
        No_Bonus_Check= false;
        Totals_BonusMeasureTrad =0;
        Totals_BonusMeasureDigital=0;
        QuartelyBonus=new list<wrapbonus>();// Initialization of wrapper class
        String Brand_id = ApexPages.currentPage().getParameters().get('Brandid');//get brand id from url
        String agency_id=ApexPages.currentPage().getParameters().get('Agencyid');// get agency id from url
        String current_year=ApexPages.currentPage().getParameters().get('Year');// get fiscal year
        system.debug('url parameter'+ Brand_id+current_year+agency_id );
        
        User userObj = new User();
        userObj = [select Id, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];// Get profile name and user type of current logedin user
        if(userObj.AF_Agency_Fees_User_Type__c=='CMCO Super User'|| userObj.AF_Agency_Fees_User_Type__c=='Category Finance'||userObj.AF_Agency_Fees_User_Type__c=='CMCO User')
        {
            IsEditable=true;
        }
        if(userObj.AF_Agency_Fees_User_Type__c=='Agency'){
        isAgency = true;
        }
        list<AF_Brand_Estimate__c>Pilot_model=[select ID,AF_Pilot_Model__c,AF_No_Bonus__c from AF_Brand_Estimate__c where  Brand__c=:Brand_id and AF_Agency__c=:agency_id and AF_Fiscal_Year__c=:current_year and AF_Active__c=True];
        if(Pilot_model.size()>0){
            AF_Pilot_Model= Pilot_model.get(0).AF_Pilot_Model__c; 
            No_Bonus_Check = Pilot_model.get(0).AF_No_Bonus__c;
        }
        if(AF_Pilot_Model==false){
            
            set<string> agencyEstUnqStr = new set<string>();
            
            
            map<String,map<String,boolean>> bonus_Threshold_Trad_Dig_BM_Map = new map<String,map<String,boolean>>();
            map<String,Integer> countryCountMap = new map<String,Integer>();
            map<String,map<String,boolean>> bonus_Threshold_Trad_Dig_BM_MapTemp = new map<String,map<String,boolean>>();
            set<Id> bonusThId= new set<Id>();
            
            //new variables
            list<AF_Bonus_Threshold__c> Bonus_Result_list= new list<AF_Bonus_Threshold__c>();
            List<AF_Sub_Result__c> Bonus_SubResult_List = new List<AF_Sub_Result__c>();
            Set<Id> btId = new Set<Id>();
            Map<String,Integer> countryBMMap= new Map<String,Integer>();
            //try{
                Bonus_Result_list=[select id from AF_Bonus_Threshold__c where Agency_Name__c =:agency_id and Brand_Name__c=:Brand_id and Year__c=:current_year order by AF_Country__r.AF_Country__c ASC ];
                if(Bonus_Result_list.size()>0){
                    for(AF_Bonus_Threshold__c bt:Bonus_Result_list){
                        btId.add(bt.Id);
                    }
                }
                Bonus_SubResult_List = [select AF_Qual_Per__c,AF_Comment__c,AF_Quant__c,AF_Total_Bonus__c,AF_Qual__c,AF_Country__r.AF_Country__c,AF_Country__r.name,Bonus_Measure__c,AF_Locked__c,AF_country__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Year__c,AF_Digital__c,AF_Traditional__c,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Unique_Thresholds__c,AF_Quant_Bonus_Value__c,AF_Total_Bonus_Value__c,AF_Bonusable_Fees__c,AF_Quant_Bonus__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :btId and AF_Period__c=null];
                if(Bonus_SubResult_List.size()>0){
                    showmainblock=true;
                    for(AF_Sub_Result__c bonus_SubResult_Obj:Bonus_SubResult_List){
                        Countryname_BT.add(bonus_SubResult_Obj.AF_Country__r.AF_Country__c);
                        string brandname_id=bonus_SubResult_Obj.AF_Bonus_Threshold__r.Brand_Name__c;
                        string agencyname_id=bonus_SubResult_Obj.AF_Bonus_Threshold__r.Agency_Name__c;
                        string str=agencyname_id+'::'+ brandname_id+'::'+bonus_SubResult_Obj.AF_Country__r.AF_Country__c+'::'+bonus_SubResult_Obj.AF_Bonus_Threshold__r.Year__c;
                        agencyEstUnqStr.add(str);
                        bonusThId.add(bonus_SubResult_Obj.AF_Bonus_Threshold__c);
                        String countryDigital = bonus_SubResult_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                        String countryTrad = bonus_SubResult_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                        Integer count=0;
                        if(bonus_SubResult_Obj.AF_Digital__c == true){
                            if(!countryBMMap.containsKey(countryDigital)){
                                countryBMMap.put(countryDigital,1);
                            }
                            else{
                                count = countryBMMap.get(countryDigital);
                                count=count +1;
                                countryBMMap.put(countryDigital,count);
                            }
                        }
                        if(bonus_SubResult_Obj.AF_Traditional__c == true){
                            if(!countryBMMap.containsKey(countryTrad)){
                                countryBMMap.put(countryTrad,1);
                            }
                            else{
                                count = countryBMMap.get(countryTrad);
                                count=count +1;
                                countryBMMap.put(countryTrad,count);
                            }
                            
                        }
                        //system.debug('countryBMMap...****'+countryBMMap);
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
                        //String BMStr = agencyname_id.substring(0,15)+'::'+ brandname_id.substring(0,15)+'::'+bonus_Threshold_Obj.AF_Country__r.AF_Country__c+'::'+bonus_Threshold_Obj.Year__c+'::'+bonus_Threshold_Obj.Bonus_Measure__c;
                        String BMStr = bonus_SubResult_Obj.AF_Unique_Thresholds__c;
                        map<String,boolean> tradDigMapBM = new map<String,boolean>();
                        tradDigMapBM.put('Digital',bonus_SubResult_Obj.AF_Digital__c);
                        tradDigMapBM.put('Trad',bonus_SubResult_Obj.AF_Traditional__c);
                        bonus_Threshold_Trad_Dig_BM_Map.put(BMStr,tradDigMapBM);
                        system.debug('bonus_Threshold_Trad_Dig_BM_Map...****'+bonus_Threshold_Trad_Dig_BM_Map);
                    }
                    system.debug('countryBMMap...****'+countryBMMap);
                    system.debug('countryCountMap...****'+countryCountMap);
                    for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List){
                                String countryDigital = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                                String countryTrad = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                                //map<String,boolean> tradDigMapBM = new map<String,boolean>();
                                map<String,boolean> tradDigMapBMtemp = new map<String,boolean>();
                                string brandname_id=bonus_Threshold_Obj.AF_Bonus_Threshold__r.Brand_Name__c;
                                string agencyname_id=bonus_Threshold_Obj.AF_Bonus_Threshold__r.Agency_Name__c;
                                String StrTemp = agencyname_id+'::'+ brandname_id+'::'+bonus_Threshold_Obj.AF_Country__r.AF_Country__c+'::'+bonus_Threshold_Obj.AF_Bonus_Threshold__r.Year__c;
                                if(countryBMMap.size()>0){
                                if(countryBMMap.get(countryDigital)>0 && countryBMMap.get(countryTrad) >0){
                                    tradDigMapBMtemp.put('Trad',true);
                                    tradDigMapBMtemp.put('Digital',true);
                                }
                                else if(countryBMMap.get(countryDigital)>0){
                                    
                                    tradDigMapBMtemp.put('Digital',true);
                                    tradDigMapBMtemp.put('Trad',false);
                                }
                                else if(countryBMMap.get(countryTrad)>0){
                                  tradDigMapBMtemp.put('Trad',true);
                                  tradDigMapBMtemp.put('Digital',false);
                                }
                                bonus_Threshold_Trad_Dig_BM_MapTemp.put(StrTemp,tradDigMapBMtemp);
                            }
                        } 
                        system.debug('bonus_Threshold_Trad_Dig_BM_MapTemp....'+bonus_Threshold_Trad_Dig_BM_MapTemp);                    
                }
                system.debug('bonusThId..'+bonusThId);
                
                
                map<string,AF_Sub_Result__c>mapBonus_result=new map<string,AF_Sub_Result__c>();
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
                
                list<AF_Agency_Estimate__c> oddagencylist=new   list<AF_Agency_Estimate__c>();
                set<String> setofnonthreshold_country = new set<String>();
                
                oddagencylist=[Select ID,AF_Total__c,AF_Unilever_Entity__r.AF_Country__c from AF_Agency_Estimate__c where AF_Unilever_Entity__r.AF_Country__c !=:Countryname_BT and AF_Agency_Entity__r.AF_Agency__c=:agency_id.substring(0,15) and AF_Brand_Id__c=:Brand_id.substring(0,15) and AF_Brand_Estimate__r.AF_Active__c=True and AF_Fiscal_Year__c=:current_year];
                if(oddagencylist.size()>0){
                    for(AF_Agency_Estimate__c oddagency:oddagencylist){
                        if(oddagency.AF_Total__c>0){
                            setofnonthreshold_country.add(oddagency.AF_Unilever_Entity__r.AF_Country__c);
                        }
                    } 
                    if(setofnonthreshold_country.size()>0 && No_Bonus_Check==false){
                        Apexpages.addmessage(new apexpages.message(apexpages.severity.WARNING,  'The Thresholds entered do not match the Unilever entity/entities in the Base Fees matrix. Please resolve the following mismatches by setting Bonus Threshold for Unilever entities: '+ ' '+ setofnonthreshold_country ));
                    }
                }
                
                map<String,Integer> AgencyMap= new map<String,Integer>();
                map<String,Integer>AgencyTotalfees=new map<String,Integer>();
                Map<String,Integer> EntityAmtMap = new Map<String,Integer>();
                Decimal totalbonusval=0;
                
                for(AF_Agency_Estimate__c agEstObj:[Select id,AF_Total__c,AF_Bonus_Agency_Formula__c,name,Agency_Account__c,Brand__c, AF_Unilever_Entity__c,AF_Digital__c,AF_Traditional__c,AF_Unilever_Entity__r.AF_Country__c from AF_Agency_Estimate__c where AF_Bonus_Agency_Formula__c IN :agencyEstUnqStr and AF_Brand_Estimate__r.AF_Active__c=True])
                {
                    //Totals_BonusMeasureTrad = Totals_BonusMeasureTrad + (integer.valueof(agEstObj.AF_Traditional__c));
                    //Totals_BonusMeasureDigital = Totals_BonusMeasureDigital + (integer.valueof(agEstObj.AF_Digital__c));
                    system.debug('AF_Bonus_Agency_Formula__c...'+agEstObj.AF_Bonus_Agency_Formula__c);
                    system.debug('agEstObj.AF_Unilever_Entity__r.AF_Country__c...'+agEstObj.AF_Unilever_Entity__r.AF_Country__c);
                    system.debug('agEstObj.AF_Traditional__c...'+agEstObj.AF_Traditional__c);
                    system.debug('agEstObj.AF_Digital__c...'+agEstObj.AF_Digital__c);
                    
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
                    system.debug('EntityAmtMap....****'+EntityAmtMap);
                    if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c)!=null){
                                if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get('Digital') && bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get('Trad')){
                                Totals_BonusMeasureDigital = Totals_BonusMeasureDigital + (integer.valueof(agEstObj.AF_Digital__c));
                                Totals_BonusMeasureTrad = Totals_BonusMeasureTrad + (integer.valueof(agEstObj.AF_Traditional__c));
                                }
                                else if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get('Digital')){
                                Totals_BonusMeasureDigital = Totals_BonusMeasureDigital + (integer.valueof(agEstObj.AF_Digital__c));
                                
                                }
                                else if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get('Trad')){
                                Totals_BonusMeasureTrad = Totals_BonusMeasureTrad + (integer.valueof(agEstObj.AF_Traditional__c));
                                }
                            }
                } 
                system.debug('EntityAmtMap...'+EntityAmtMap);
                system.debug('Totals_BonusMeasureDigital....'+Totals_BonusMeasureDigital);
                system.debug('Totals_BonusMeasureTrad....'+Totals_BonusMeasureTrad);                
                sum_of_bonusable_fees=Totals_BonusMeasureTrad+Totals_BonusMeasureDigital;
                Map<String,Integer> BonusMeasureCalcMap = new Map<String,Integer>();
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
                        system.debug('Amt..'+Amt);
                        calc = integer.valueof(Amt/count);
                    }
                    BonusMeasureCalcMap.put(countryTrad,calc);
                }
                system.debug('BonusMeasureCalcMap...****'+BonusMeasureCalcMap);
                
                Integer totalBMCalc=0;
                Integer BMDiff =0;
                Map<String,Integer> BonusMeasureShowMap = new Map<String,Integer>();
                for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List){
                    
                    //string strBM=agencyname_id.substring(0,15)+'::'+brandname_id.substring(0,15)+'::'+bonus_Threshold_Obj.AF_Country__r.AF_Country__c+'::'+bonus_Threshold_Obj.Year__c+'::'+bonus_Threshold_Obj.Bonus_Measure__c;
                    string strBM = bonus_Threshold_Obj.AF_Unique_Thresholds__c;
                    Integer count=0;
                    String countryDigital = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                    String countryTrad = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                    if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get('Digital')==true){
                        count = BonusMeasureCalcMap.get(countryDigital);
                        system.debug(count);
                    }
                    if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get('Trad')==true){
                        count = count+BonusMeasureCalcMap.get(countryTrad);
                        system.debug(count);
                    }
                    BonusMeasureShowMap.put(strBM,count);
                    totalBMCalc = totalBMCalc + count;
                    //system.debug('BonusMeasureShowMap....1111..***'+BonusMeasureShowMap);
                }
                system.debug('BonusMeasureShowMap......***'+BonusMeasureShowMap);
                system.debug('totalBMCalc....'+totalBMCalc);
                //system.debug('sum_of_bonus_basefee...'+sum_of_bonusable_fees);
                BMDiff = integer.valueof(sum_of_bonusable_fees) - totalBMCalc;
                Integer loopBM=0;
                for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List)
                {
                    /*string agencyname_id=bonus_Threshold_Obj.Agency_Name__c;
            string brandname_id=bonus_Threshold_Obj.Brand_Name__c;
            string strBM=agencyname_id.substring(0,15)+'::'+brandname_id.substring(0,15)+'::'+bonus_Threshold_Obj.AF_Country__r.AF_Country__c+'::'+bonus_Threshold_Obj.Year__c+'::'+bonus_Threshold_Obj.Bonus_Measure__c;
            */
                    string strBM = bonus_Threshold_Obj.AF_Unique_Thresholds__c;
                    Integer count=0;
                    if(countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c)>1 && loopBM==0){
                        count = BonusMeasureShowMap.get(strBM);
                        count = count + BMDiff;
                        BonusMeasureShowMap.put(strBM,count);
                        loopBM= loopBM+1;
                    }
                    
                }
                for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List)
                {
                    AF_AnnualBonus_Qual__c Custom_Qualatative=AF_AnnualBonus_Qual__c.getInstance('Qualitative Value');  
                    /*string agencyname_id=bonus_Threshold_Obj.Agency_Name__c;
            string brandname_id=bonus_Threshold_Obj.Brand_Name__c;  
            string str=agencyname_id.substring(0,15)+'::'+brandname_id.substring(0,15)+'::'+bonus_Threshold_Obj.AF_Country__r.AF_Country__c+'::'+bonus_Threshold_Obj.Year__c;
            string strBM=agencyname_id.substring(0,15)+'::'+brandname_id.substring(0,15)+'::'+bonus_Threshold_Obj.AF_Country__r.AF_Country__c+'::'+bonus_Threshold_Obj.Year__c+'::'+bonus_Threshold_Obj.Bonus_Measure__c;
            decimal bonus_fees=agencyMap.get(str);
            */
                    string strBM = bonus_Threshold_Obj.AF_Unique_Thresholds__c;
                    
                    
                    
                    if(mapBonus_result.containskey(bonus_Threshold_Obj.AF_Unique_Thresholds__c)){
                        if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==0 || mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==null){
                            if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c!=null){
                                qual_per = mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c;
                            }
                            else{
                            qual_per=0;
                            }
                            
                            if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==null){
                                
                            }
                            
                            else if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==1 || mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==2){
                                
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
                            if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==null){
                            
                            }
                            
                            else if(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==1 || mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Qual__c==2){
                                
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
                    else{
                        Qual_value=0;
                        qual_per=0; 
                    }
                    
                    Integer count=0;
                    String countryDigital = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                    String countryTrad = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                    if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get('Digital')==true){
                        
                        count = BonusMeasureCalcMap.get(countryDigital);
                        system.debug('strBM...***digital'+strBM);
                        system.debug(count);
                        
                    }
                    if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get('Trad')==true){
                        count = count+BonusMeasureCalcMap.get(countryTrad);
                        system.debug('strBM...***Trad'+strBM);
                        system.debug(count);
                    }
                    //system.debug('AgencyTotalfees.get(str)...'+AgencyTotalfees.get(str));
                    
                    if(mapBonus_result.containsKey(bonus_Threshold_Obj.AF_Unique_Thresholds__c) && (mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==0 || mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==null)){
                        system.debug('bonus_Threshold_Obj.AF_Unique_Thresholds__c...***'+bonus_Threshold_Obj.AF_Unique_Thresholds__c);
                        system.debug(bonus_Threshold_Obj.AF_Country__r.AF_Country__c);
                        system.debug(bonus_Threshold_Obj.AF_Minimum__c);
                        system.debug(bonus_Threshold_Obj.AF_Stretching__c);
                        system.debug(bonus_Threshold_Obj.AF_Outstanding__c);
                        system.debug(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c));
                        system.debug(count);
                        system.debug(bonus_Threshold_Obj.Bonus_Measure__c);
                        system.debug(countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c));
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
                    system.debug('QuartelyBonus...'+QuartelyBonus);
                    
                    
                    
                    
                }
            /*}
            catch(Exception e){
                system.debug(e);
            }*/
        } 
        if(AF_Pilot_Model==true)
        {
            bonusTradDigitalFee = 0;
            Decimal renumRating = 0;
            Decimal renumPercentage=0;
            Decimal renumAmt=0.0;
            Boolean resultLock=false;
            Decimal RenumTotal=0.0;
            bonusThresholdRenumeration = new list<AF_Bonus_Threshold__c>();
            bonusResult = new list<AF_Bonus_Results__c>();
            renumBonus = new List<wrapRenumartionbonus>();
            system.debug('agency_id...reetha'+agency_id);
            system.debug('brand_id...reetha'+Brand_id);
            
            bonusThresholdRenumeration =[select id,AF_Digital__c,AF_Traditional__c from AF_Bonus_Threshold__c where Agency_Name__c =:agency_id and Brand_Name__c=:Brand_id and Year__c=:current_year and AF_Country__c=null limit 1];
            
            for(AF_Agency_Estimate__c agEstObj:[Select id,AF_Total__c,AF_Bonus_Agency_Formula__c,name,Agency_Account__c,Brand__c, AF_Unilever_Entity__c,AF_Digital__c,AF_Traditional__c,AF_Unilever_Entity__r.name from AF_Agency_Estimate__c where AF_Agency_Entity__r.AF_Agency__c=:agency_id and AF_Brand_Estimate__r.Brand__c=:Brand_id and AF_Fiscal_Year__c=:current_year and AF_Brand_Estimate__r.AF_Active__c=True]){
                if(bonusThresholdRenumeration[0].AF_Digital__c==True){
                    TotalDigitalValue=TotalDigitalValue + (integer.valueof(agEstObj.AF_Digital__c));
                }
                if(bonusThresholdRenumeration[0].AF_Traditional__c==True){
                    TotalTraditionalValue=TotalTraditionalValue + (integer.valueof(agEstObj.AF_Traditional__c));
                }
            }
            bonusTradDigitalFee = bonusTradDigitalFee+TotalTraditionalValue+TotalDigitalValue;
            system.debug('TotalTraditionalValue..'+TotalTraditionalValue);
            system.debug('TotalDigitalValue..'+TotalDigitalValue);
            system.debug('bonusTradDigitalFee..'+bonusTradDigitalFee);
            
            try{
                
                bonusResult=[select AF_Total_Bonus_Value__c,AF_Remuneration_Percentage__c,AF_Remuneration_Rating__c,AF_Locked__c,AF_Total_Remuneration__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c=:bonusThresholdRenumeration[0].Id limit 1];
                if(!(bonusResult.isEmpty())){
                    system.debug('inside bonus result');
                    renumBonus.add(new wrapRenumartionbonus(bonusTradDigitalFee,bonusResult[0].AF_Remuneration_Rating__c,bonusResult[0].AF_Remuneration_Percentage__c,bonusResult[0].AF_Total_Remuneration__c,bonusResult[0].AF_Locked__c,bonusResult[0].AF_Total_Bonus_Value__c));
                }
                else{
                    renumBonus.add(new wrapRenumartionbonus(bonusTradDigitalFee,renumRating,renumPercentage,renumAmt,resultLock,RenumTotal));
                }
                if(bonusTradDigitalFee==0){
                    noDisplay=false;
                }
            }
            catch(Exception e){
                system.debug('List has no rows for assignment to SObject'+e);
            }
            
            system.debug('renumBonus...'+renumBonus);
        }

    }
    public void Calculate_Bonus() {
        system.debug('inside the action support method..****');
        decimal bonus_value=0;
        decimal bonus_per=0;
        sum_of_bonus_per=0;
        sum_of_bonus_val=0;
        sum_of_quant_qual_value=0;
        sum_of_quant_qual_percent=0;
        Decimal Quantvalue=0;
        sum_of_bonusable_fees=0;
        
        
        for(wrapbonus newbonus:QuartelyBonus ){ 
            if(newbonus.total_bonus_fees!=null){
                
                sum_of_bonusable_fees=sum_of_bonusable_fees+newbonus.total_bonus_fees;
                
                system.debug('newbonus.total_bonus_fees....'+newbonus.total_bonus_fees);
                system.debug('newbonus.bonusResObj.AF_Quant__c..'+newbonus.bonusResObj.AF_Quant__c);
                if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Outstanding_bonus) {
                    system.debug('inside the else if..1.');      
                    AF_QuarterlyBonus__c Custom_Bonusthreshold=AF_QuarterlyBonus__c.getInstance('Bonus Threshold');
                    Decimal bonus_outstanding=Custom_Bonusthreshold.Outstanding__c; 
                    Quantvalue=bonus_outstanding;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setScale(2, RoundingMode.HALF_UP);
                    
                } 
                
                else if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Streching_bonus & newbonus.bonusResObj.AF_Quant__c<newbonus.Outstanding_bonus) {
                    system.debug('inside the else if..2.'); 
                    AF_QuarterlyBonus__c Custom_Bonusthreshold=AF_QuarterlyBonus__c.getInstance('Bonus Threshold');
                    Decimal bonus_stretching=Custom_Bonusthreshold.Stretching__c; 
                    
                    Decimal bonus_min=Custom_Bonusthreshold.Minimum__c;
                    Quantvalue=bonus_stretching+ bonus_min* (newbonus.bonusResObj.AF_Quant__c-newbonus.Streching_bonus)/(newbonus.Outstanding_bonus-newbonus.Streching_bonus)  ;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setScale(2, RoundingMode.HALF_UP);
                    
                } 
                else if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Minimum_bonus & newbonus.bonusResObj.AF_Quant__c<newbonus.Streching_bonus) {
                    system.debug('inside the else if..3.'); 
                    AF_QuarterlyBonus__c Custom_Bonusthreshold=AF_QuarterlyBonus__c.getInstance('Bonus Threshold');
                    Decimal bonus_minimum=Custom_Bonusthreshold.Minimum__c; 
                    Quantvalue=bonus_minimum + bonus_minimum * (newbonus.bonusResObj.AF_Quant__c-newbonus.Minimum_bonus)/(newbonus.Streching_bonus-newbonus.Minimum_bonus)  ;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setScale(2, RoundingMode.HALF_UP);
                }
                else if (newbonus.bonusResObj.AF_Quant__c!=null && newbonus.bonusResObj.AF_Quant__c<newbonus.Minimum_bonus) {
                    system.debug('inside the else if..4.'); 
                    Quantvalue=0;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setScale(2, RoundingMode.HALF_UP);
                }
                else if(newbonus.bonusResObj.AF_Quant__c==null){
                    newbonus.bonusResObj.AF_Quant_Bonus__c=0;
                }
                
                system.debug('newbonus.bonusResObj.AF_Quant_Bonus__c....'+newbonus.bonusResObj.AF_Quant_Bonus__c);

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

    public void Calculate_Qual() {
        sum_of_qual_value=0;
        sum_of_qual_percent=0;
        Decimal TotalBonuspercent;
        Decimal TotalBonusValue ;
        sum_of_quant_qual_value=0;
        sum_of_quant_qual_percent=0;
        
        //30-08-2014
        sum_of_bonusable_fees=0;
        //up to here
        AF_AnnualBonus_Qual__c Custom_Qualatative=AF_AnnualBonus_Qual__c.getInstance('Qualitative Value');
        for(wrapbonus newbonus:QuartelyBonus ){
            if(newbonus.total_bonus_fees!=null){
                //30-08-2014
                sum_of_bonusable_fees=sum_of_bonusable_fees+newbonus.total_bonus_fees;
                //system.debug('Sum>>>>>>'+sum_of_bonusable_fees);
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
                //sum_of_qual_percent=sum_of_qual_percent+ newbonus.QualPercent;
                sum_of_qual_value=sum_of_qual_value+newbonus.QualValue;
                if(newbonus.bonusResObj.AF_Quant_Bonus__c!=null){ 
                    newbonus.bonusResObj.AF_Total_Bonus__c=newbonus.bonusResObj.AF_Quant_Bonus__c+newbonus.QualPercent;
                    newbonus.bonusResObj.AF_Total_Bonus_Value__c=newbonus.bonusResObj.AF_Quant_Bonus_Value__c+ newbonus.QualValue;
                    // sum_of_quant_qual_percent=0;//sum_of_quant_qual_percent+newbonus.bonusResObj.AF_Total_Bonus__c;  
                    sum_of_quant_qual_value = sum_of_quant_qual_value + newbonus.bonusResObj.AF_Total_Bonus_Value__c; 
                    
                    //30-08-2014
                    //sum_of_quant_qual_percent=sum_of_quant_qual_percent+newbonus.bonusResObj.AF_Total_Bonus__c;
                    if(sum_of_bonusable_fees>0){
                        sum_of_quant_qual_percent=math.round((sum_of_quant_qual_value/sum_of_bonusable_fees)*100);
                        sum_of_qual_percent=math.round((sum_of_qual_value/sum_of_bonusable_fees)*100);
                    }
                    //upto here
                } 
            }
            
        }
    } 
    public void Calculate_Remun() {
        /*Sum_remuneration_val=0;
        Sum_remuneration_per=0;
                    AF_AnnualBonus_Qual__c Custom_Qualatative=AF_AnnualBonus_Qual__c.getInstance('Qualitative Value');
        for(wrapbonus newbonus:QuartelyBonus ){
        if(newbonus.total_bonus_fees!=null){   
        
        if (newbonus.bonusResObj.AF_Remuneration_Rating__c==1||newbonus.bonusResObj.AF_Remuneration_Rating__c==2) {
                    
        newbonus.bonusResObj.AF_Remuneration_Percentage__c=Custom_Qualatative.X1__c; 
        } 
        else if(newbonus.bonusResObj.AF_Remuneration_Rating__c==3){
            newbonus.bonusResObj.AF_Remuneration_Percentage__c=Custom_Qualatative.X3__c; 
        
        }
        else if(newbonus.bonusResObj.AF_Remuneration_Rating__c==4){
            newbonus.bonusResObj.AF_Remuneration_Percentage__c=Custom_Qualatative.X4__c; 
        
        }
        else if(newbonus.bonusResObj.AF_Remuneration_Rating__c==5){
            newbonus.bonusResObj.AF_Remuneration_Percentage__c=Custom_Qualatative.X5__c; 
        
        }   
            if(newbonus.bonusResObj.AF_Remuneration_Percentage__c!=null){ 
            newbonus.bonusResObj.AF_Total_Remuneration__c=(newbonus.total_bonus_fees*newbonus.bonusResObj.AF_Remuneration_Percentage__c)/100;   
            Sum_remuneration_val=Sum_remuneration_val + newbonus.bonusResObj.AF_Total_Remuneration__c;
            Sum_remuneration_per=Sum_remuneration_per + newbonus.bonusResObj.AF_Remuneration_Percentage__c;
        }
        }
        }*/
    }     
    public void Calculate_Remun2() {
        AF_AnnualBonus_Qual__c Custom_Qualatative=AF_AnnualBonus_Qual__c.getInstance('Qualitative Value');
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
    public void Calculate_Remun_Per() {
        /*Sum_remuneration_val=0;
                        Sum_remuneration_per=0;
                        AF_AnnualBonus_Qual__c Custom_Qualatative=AF_AnnualBonus_Qual__c.getInstance('Qualitative Value');
        for(wrapbonus newbonus:QuartelyBonus ){
        if(newbonus.total_bonus_fees!=null){
        if(newbonus.bonusResObj.AF_Remuneration_Percentage__c!=null){ 
        newbonus.bonusResObj.AF_Total_Remuneration__c=((newbonus.total_bonus_fees*newbonus.bonusResObj.AF_Remuneration_Percentage__c)/100).setScale(2, RoundingMode.HALF_UP);   
        Sum_remuneration_val= Sum_remuneration_val+ newbonus.bonusResObj.AF_Total_Remuneration__c;
        Sum_remuneration_per=Sum_remuneration_per+ newbonus.bonusResObj.AF_Remuneration_Percentage__c;
        } 
        }                     
        }*/
    }
    public void Calculate_Remun_Per2() {
        for(wrapRenumartionbonus newbonus:renumBonus ){
            if(newbonus.renumPercentage!=null){
                newbonus.renumCalcAmount = ((newbonus.bonusableFees*newbonus.renumPercentage)/100).setScale(2, RoundingMode.HALF_UP);
            }
        }
    }
    
    public void UpdateBonus() {
        Calculate_Bonus();
        Calculate_Qual();
        Boolean isQuantEmptyUpdate=false;
        list<AF_Sub_Result__c> bonus_latestlist=new list<AF_Sub_Result__c>();
        // RecordType rt = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1];
        for(wrapbonus w_bonus:QuartelyBonus){
            system.debug('AF_Pilot_Model'+ AF_Pilot_Model);
            
            
                    w_bonus.bonusResObj.AF_Bonus_Threshold__c=w_bonus.bonus_threshold_id;
                    w_bonus.bonusResObj.AF_Bonusable_Fees__c=w_bonus.total_bonus_fees;
                    w_bonus.bonusResObj.AF_Total_bonus_fees__c=w_bonus.totalbonusfee;
                    w_bonus.bonusResObj.Af_status__c='Draft';
                    w_bonus.bonusResObj.AF_Qual_Per__c=w_bonus.QualPercent;
                    w_bonus.bonusResObj.AF_Qual_Bonus_Value__c=w_bonus.QualValue;
                    bonus_latestlist.add(w_bonus.bonusResObj);
                   
            
            
        }
        Integer validateTotal =0;
        validateTotal = Totals_BonusMeasureTrad+Totals_BonusMeasureDigital;
        
         if(sum_of_bonusable_fees!=validateTotal){
            String validationError='Manaul adjustment to Bonusablefees must reconcile back to Base Fee Matrix.';
            Decimal Validationdifference= sum_of_bonusable_fees-validateTotal;
            Decimal Validationdifferencer =Validationdifference;
            if (Validationdifferencer <0) Validationdifferencer=Validationdifferencer*-1;
            validationError = validationError + 'Target ';
            if (Validationdifference>0)
            {
                validationError=validationError +' exceeded by ';
            }
            else
            {
                validationError=validationError +' missing by ';    
            }
            validationError = validationError+ Validationdifferencer;
            validationError = validationError+ ' Euro';
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,validationError));
        }
        else{
            if(!bonus_latestlist.isEmpty()){
                Try{
                    upsert bonus_latestlist;
                    apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,'Record has been successfully saved'));
                }
                catch(exception e){
                    apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Please contact to System Administrator'));
                }
                
            }
        }
    }
    
    public void  UpdateBonus2(){
        Calculate_Remun_Per2();
        Boolean isrenumEmptyupdate=false;
        AF_Bonus_Results__c newRecord = new AF_Bonus_Results__c();
        
        RecordType rt = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1];
        try{
            bonusResult = [select AF_Total_Bonus_Value__c,AF_Remuneration_Percentage__c,AF_Remuneration_Rating__c,AF_Locked__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c=:bonusThresholdRenumeration[0].Id];
        }catch(Exception e){system.debug(e);}
        for(wrapRenumartionbonus w_bonus:renumBonus){
            if(w_bonus.renumPercentage==null ){
                isrenumEmptyupdate=true;
            }
            newRecord.AF_Bonus_Thresholds__c = bonusThresholdRenumeration[0].Id;
            newRecord.AF_Bonusable_Fees__c = w_bonus.bonusableFees;
            newRecord.recordTypeId = rt.Id;
            newRecord.AF_Remuneration_Percentage__c = w_bonus.renumPercentage;
            newRecord.AF_Remuneration_Rating__c = w_bonus.renumRating;
            newRecord.Af_status__c = 'Draft';
            newRecord.AF_Total_Remuneration__c = w_bonus.renumCalcAmount;
            newRecord.AF_Total_Bonus_Value__c=w_bonus.renumCalcAmount;
            if(bonusResult.size()>0)
            newRecord.Id =  bonusResult[0].Id;
            if(isrenumEmptyupdate==true){
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'Please complete all Required results before Draft'));
            }
            else{
                if(newRecord != null){
                    Try{
                        upsert newRecord;
                        // update newRecord;
                        apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,'Record has been successfully Saved'));
                    }
                    catch(exception e){
                        
                    }
                }
            }
            
        }
    }
    
    public void ConfirmBonus() {
        Calculate_Bonus();
        Calculate_Qual();
        Boolean isQuantEmptyConfirm=false;
        list<AF_Sub_Result__c> bonus_latestlist=new list<AF_Sub_Result__c>();
        //RecordType rt = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1];
        for(wrapbonus w_bonus:QuartelyBonus){
            
            
                
                
                    w_bonus.bonusResObj.AF_Bonus_Threshold__c=w_bonus.bonus_threshold_id;
                    w_bonus.bonusResObj.AF_Bonusable_Fees__c=w_bonus.total_bonus_fees;
                    w_bonus.bonusResObj.AF_Total_bonus_fees__c=w_bonus.totalbonusfee;
                    w_bonus.bonusResObj.Af_status__c='Submitted';
                    w_bonus.bonusResObj.AF_Locked__c=true;
                    
                    w_bonus.bonusResObj.AF_Qual_Per__c=w_bonus.QualPercent;
                    w_bonus.bonusResObj.AF_Qual_Bonus_Value__c=w_bonus.QualValue;
                   bonus_latestlist.add(w_bonus.bonusResObj);   
                         
            
        }
        
        
            if(!bonus_latestlist.isEmpty()){
                Try{
                    
                    upsert bonus_latestlist;
                    
                    apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,'Record has been successfully submitted'));
                }
                catch(exception e){
                    
                }
            }
        }
        
    
    public void ConfirmBonus2(){
        Calculate_Remun_Per2();
        Boolean isrenumEmptyConfirm=false;
        AF_Bonus_Results__c newRecord = new AF_Bonus_Results__c();
        
        RecordType rt = [select id,Name from RecordType where SobjectType='AF_Bonus_Results__c' and Name='Bonus Annual' Limit 1];
        try{
            bonusResult = [select AF_Total_Bonus_Value__c,AF_Remuneration_Percentage__c,AF_Remuneration_Rating__c,AF_Locked__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c=:bonusThresholdRenumeration[0].Id];
        }catch(Exception e){system.debug(e);}
        for(wrapRenumartionbonus w_bonus:renumBonus){
            if(w_bonus.renumPercentage==null ){
                isrenumEmptyConfirm=true;
            }
            newRecord.AF_Bonus_Thresholds__c = bonusThresholdRenumeration[0].Id;
            newRecord.AF_Bonusable_Fees__c = w_bonus.bonusableFees;
            newRecord.recordTypeId = rt.Id;
            newRecord.AF_Remuneration_Percentage__c = w_bonus.renumPercentage;
            newRecord.AF_Remuneration_Rating__c = w_bonus.renumRating;
            newRecord.Af_status__c = 'Submitted';
            newRecord.AF_Locked__c = true;
            newRecord.AF_Total_Remuneration__c = w_bonus.renumCalcAmount;
            newRecord.AF_Total_Bonus_Value__c=w_bonus.renumCalcAmount;
            if(bonusResult.size()>0)
            newRecord.Id =  bonusResult[0].Id;
            if(isrenumEmptyConfirm==true){
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'Please complete all Quantitative results before submitting'));
            }
            else{
                if(newRecord != null){
                    Try{
                        upsert newRecord;
                        
                        apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,'Record has been successfully Submitted'));
                    }
                    catch(exception e){
                        
                    }
                }
            }
            
        }
    }
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
        public wrapbonus(Decimal totalbonusfee,Decimal QualValue,Decimal QualPercent,Id b_threshold_id, String Country_Name, Decimal Minimum,Decimal Streching,Decimal Outstanding,AF_Sub_Result__c bonusResObj1,integer bonus_fees,String bonusMeasure,Integer cCount){
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

    //wrapper for renumeration
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