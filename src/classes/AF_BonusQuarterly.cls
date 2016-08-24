/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_BonusQuarterly
   @CreateDate : 30/7/2014
   @Description : This is a controller class for AF_QuarterlyBonus Page, 
   @              this is used to enter and calculate the quarterly Bonus.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public with sharing class AF_BonusQuarterly {
    public Boolean IsDraft{get;set;}
    public String Bonus_Measure { get; set; }
    public Boolean showmainblock{get;set;}
    public Integer Totals_Traditional { get; set; }
    public Boolean isQuantEmpty;
    public Boolean isTraditional { get; set; }
    public Integer Totals_Digital { get; set; }
    public Boolean isDigital { get; set; }
    public decimal sum_of_bonus_per { get; set; }
    public decimal sum_of_bonus_val { get; set; }
    public list<wrapbonus> QuartelyBonus {get;set;}
    public list<AF_Bonus_Results__c>AF_Bonus_Result{get;set;}
    public list<AF_Bonus_Threshold__c> AF_Bonus_Threshold{get;set;}
    public String Country_Full_Name;
    public Boolean AF_Digital;
    public Integer AF_Minimum;
    public Integer AF_Outstanding;
    public Integer AF_Stretching;
    public Boolean AF_Traditional;
    public Integer Quant;
    public Decimal Bonus_Percent;
    public decimal Bonus_value;
    public string brandestimate_id;
    public string Country_name;
    public integer Traditional_value;
    public integer Digital_value;
    public integer TotalTraditionalValue;
    public integer TotalDigitalValue;
    public integer total_bonus_fees;
    public id threshold_id;
    public string agency_name;
    public string Brand_name;
    public list<AF_Agency_Estimate__c>Agency_Estimate=new list<AF_Agency_Estimate__c>();
    public Boolean IsEditable{get;set;}
    public map<id,string>bonus_thresholdid=new  map<id,string>(); 
    set<string> Threshold = new set<string>();
    public Set<String> Countryname_BT=new set<String>();
    public Boolean IsSave{get;set;}
    public Boolean isNoRecord{get;set;}
    public string Quarterinfo{get;set;}
    public Boolean IsLocked{get;set;}
    public Integer Totals_BonusMeasureTrad { get; set; }
    public Integer Totals_BonusMeasureDigital { get; set; }
    public List<AF_Sub_Result__c> Bonus_SubResult_List;
    public List<AF_Sub_Result__c> Bonus_SubResult_BackupList;
    public decimal sum_of_bonus_basefee {get;set;}
    public decimal sum_of_bonus_basefee_onload {get;set;}
    public Boolean displaySubmitButton{get;set;}
    public Boolean displaySubmitSave{get;set;}
    //private static String Digital = AF_Constants.DIGITAL;
    //private static String Trad = AF_Constants.TRADITIONAL;
    //private static String Bonus_Thershold=AF_Constants.TEST_BONUS_THRESHOLD;
    /**********************************************************************
*  @Description: Contructor method
*  @name : AF_BonusQuarterly
*  @param : none
*  @return : none
*************************************************************************/      
    public  AF_BonusQuarterly() {
        Quarterinfo=AF_Constants.QUARTER1;
        sum_of_bonus_basefee=0;
        CallBonusQuarterly();
    }
    /***********************************************************************************
*  @Description: this method is used to query and display the quarterly bonus records
*  @name : queryBrandEstimate
*  @param : none
*  @return: none.
*************************************************************************************/
    public void CallBonusQuarterly() {
        Bonus_SubResult_List = new List<AF_Sub_Result__c>();
        Bonus_SubResult_BackupList = new List<AF_Sub_Result__c>();
        IsLocked=false;
        IsDraft=True;
        IsSave=false;
        IsEditable=false;
        agency_name='';
        Brand_name='';
        Country_Full_Name='';
        AF_Digital=false;
        AF_Minimum=0;
        AF_Outstanding=0;
        AF_Stretching=0;
        AF_Traditional=false;
        brandestimate_id='';
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
        isNoRecord=True;
        sum_of_bonus_basefee=0;
        sum_of_bonus_basefee_onload=0;
        Totals_BonusMeasureTrad =0;
        Totals_BonusMeasureDigital=0;
        QuartelyBonus=new list<wrapbonus>();
        String Brand_id = ApexPages.currentPage().getParameters().get(AF_Constants.BRANDID);
        String agency_id=ApexPages.currentPage().getParameters().get(AF_Constants.AGENCYID);
        String current_year=ApexPages.currentPage().getParameters().get(AF_Constants.YEAR);
        displaySubmitButton = false;
        User userObj = new User();
        userObj = [select Id, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
        if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER|| userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE)
        {
            IsEditable=true;
        }
        list<AF_Brand_Estimate__c>Pilot_model=[select ID,AF_Pilot_Model__c,AF_No_Bonus__c from AF_Brand_Estimate__c where  Brand__c=:Brand_id and AF_Agency__c=:agency_id and AF_Fiscal_Year__c=:current_year and AF_Active__c=True limit 1];    
        if(Pilot_model.size()>0){
            if(Pilot_model.get(0).AF_Pilot_Model__c){
                showmainblock=false; 
                apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Brand_Remuneration));
            }
            else{
                showmainblock=true;
                Map<String,Integer> countryBMMap= new Map<String,Integer>();
                map<String,map<String,boolean>> bonus_Threshold_Trad_Dig_BM_Map = new map<String,map<String,boolean>>();
                map<String,map<String,boolean>> bonus_Threshold_Trad_Dig_BM_MapTemp = new map<String,map<String,boolean>>();
                map<String,Integer> countryCountMap = new map<String,Integer>();
                set<Id> bonusThId= new set<Id>();
                list<AF_Bonus_Threshold__c> Bonus_Result_list= new list<AF_Bonus_Threshold__c>();
                Set<Id> btId = new Set<Id>();
                set<string> agencyEstUnqStr = new set<string>();
                Bonus_Result_list=[select id from AF_Bonus_Threshold__c where Agency_Name__c =:agency_id and Brand_Name__c=:Brand_id and Year__c=:current_year order by AF_Country__r.AF_Country__c ASC];
                if(Bonus_Result_list.size()>0){
                    if(Bonus_Result_list.size()>0){
                        for(AF_Bonus_Threshold__c bt:Bonus_Result_list){
                            btId.add(bt.Id);
                        }
                    }
                    if(btId.size()>0){
                        Bonus_SubResult_List = [select AF_Comment__c,AF_Quant__c,AF_Period__c,AF_Total_Bonus__c,AF_Qual__c,AF_Country__r.AF_Country__c,AF_Country__r.name,Bonus_Measure__c,AF_Locked__c,AF_country__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Year__c,AF_Digital__c,AF_Traditional__c,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Unique_Thresholds__c,AF_Quant_Bonus_Value__c,AF_Total_Bonus_Value__c,AF_Bonusable_Fees__c,AF_Quant_Bonus__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :btId and AF_Period__c=:Quarterinfo];
                        if(Bonus_SubResult_List.size()>0){
                            Bonus_SubResult_BackupList.addAll(Bonus_SubResult_List);
                        }
                        if(Bonus_SubResult_List.size()==0){
                            Bonus_SubResult_List = [select AF_Comment__c,AF_Quant__c,AF_Total_Bonus__c,AF_Qual__c,AF_Country__r.AF_Country__c,AF_Country__r.name,Bonus_Measure__c,AF_Locked__c,AF_country__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Year__c,AF_Digital__c,AF_Traditional__c,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Unique_Thresholds__c,AF_Quant_Bonus_Value__c,AF_Total_Bonus_Value__c,AF_Bonusable_Fees__c,AF_Quant_Bonus__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :btId and AF_Period__c=null];
                        }
                    }
                    if(Bonus_SubResult_List.size()>0){
                        for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List){
                            Countryname_BT.add(bonus_Threshold_Obj.AF_Country__r.AF_Country__c);
                            string brandname_id=bonus_Threshold_Obj.AF_Bonus_Threshold__r.Brand_Name__c;
                            string agencyname_id=bonus_Threshold_Obj.AF_Bonus_Threshold__r.Agency_Name__c;
                            string str=agencyname_id+'::'+ brandname_id+'::'+bonus_Threshold_Obj.AF_Country__r.AF_Country__c+'::'+bonus_Threshold_Obj.AF_Bonus_Threshold__r.Year__c;
                            agencyEstUnqStr.add(str);
                            bonusThId.add(bonus_Threshold_Obj.Id);
                            String countryDigital = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                            String countryTrad = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                            Integer count=0;
                            if(bonus_Threshold_Obj.AF_Digital__c){
                                if(!countryBMMap.containsKey(countryDigital)){
                                    countryBMMap.put(countryDigital,1);
                                }
                                else{
                                    count = countryBMMap.get(countryDigital);
                                    count=count +1;
                                    countryBMMap.put(countryDigital,count);
                                }
                            }
                            if(bonus_Threshold_Obj.AF_Traditional__c){
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
                            if(!countryCountMap.containsKey(bonus_Threshold_Obj.AF_Country__r.AF_Country__c)){
                                unileverContCount = unileverContCount + 1;
                                countryCountMap.put(bonus_Threshold_Obj.AF_Country__r.AF_Country__c,unileverContCount);
                            }
                            else{
                                unileverContCount = countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c);
                                unileverContCount = unileverContCount+1;
                                countryCountMap.put(bonus_Threshold_Obj.AF_Country__r.AF_Country__c,unileverContCount);
                            }
                            String BMStr = bonus_Threshold_Obj.AF_Unique_Thresholds__c;
                            map<String,boolean> tradDigMapBM = new map<String,boolean>();
                            tradDigMapBM.put(AF_Constants.DIGITAL,bonus_Threshold_Obj.AF_Digital__c);
                            tradDigMapBM.put(AF_Constants.TRADITIONAL,bonus_Threshold_Obj.AF_Traditional__c);
                            bonus_Threshold_Trad_Dig_BM_Map.put(BMStr,tradDigMapBM);
                        } 
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
                    else{
                        isNoRecord=false;
                    }
                    map<string,AF_Sub_Result__c>mapBonus_result=new map<string,AF_Sub_Result__c>();
                    for(AF_Sub_Result__c bonusResObj:Bonus_SubResult_List){
                        mapBonus_result.put(bonusResObj.AF_Unique_Thresholds__c,bonusResObj);
                        //checking for locked Bonus Result record 
                        if(bonusResObj.AF_Locked__c){
                            IsLocked=True;
                        }else{
                            IsLocked=false;
                        }
                        if(bonusResObj.AF_Quant_Bonus_Value__c!=null){
                            sum_of_bonus_val=sum_of_bonus_val + integer.valueof(bonusResObj.AF_Quant_Bonus_Value__c);
                        }
                        if(bonusResObj.AF_Bonusable_Fees__c!=null){          
                            sum_of_bonus_basefee_onload=sum_of_bonus_basefee_onload+bonusResObj.AF_Bonusable_Fees__c;// 01-09-2014 Calculate the sum for initial load
                            if(sum_of_bonus_basefee_onload>0)
                            sum_of_bonus_per=math.round((sum_of_bonus_val/sum_of_bonus_basefee_onload)*100);
                        }
                    } 
                    list<AF_Agency_Estimate__c>oddagencylist=new   list<AF_Agency_Estimate__c>();
                    set<String> setofnonthreshold_country = new set<String>();
                    oddagencylist=[Select ID,AF_Total__c,AF_Unilever_Entity__r.AF_Country__c from AF_Agency_Estimate__c where AF_Unilever_Entity__r.AF_Country__c !=:Countryname_BT and AF_Agency_Entity__r.AF_Agency__c=:agency_id.substring(0,15) and AF_Brand_Id__c=:Brand_id.substring(0,15) and AF_Brand_Estimate__r.AF_Active__c=True and AF_Fiscal_Year__c=:current_year];
                    if(oddagencylist.size()>0){
                        for(AF_Agency_Estimate__c oddagency:oddagencylist){
                            if(oddagency.AF_Total__c>0){
                                setofnonthreshold_country.add(oddagency.AF_Unilever_Entity__r.AF_Country__c);
                            }
                        }
                        showmainblock=True;
                        if(setofnonthreshold_country.size()>0 && !Pilot_model.get(0).AF_No_Bonus__c){
                            displaySubmitButton = true; 
                            Apexpages.addmessage(new apexpages.message(apexpages.severity.WARNING,  Label.AF_Thershold_Mismatch+ ' '+ setofnonthreshold_country ));
                        }
                    }
                    Map<String,Integer> EntityAmtMap = new Map<String,Integer>();
                    list<AF_Agency_Estimate__c>lstof_agencyestimates=new list<AF_Agency_Estimate__c>();
                    lstof_agencyestimates=[Select id,AF_Bonus_Agency_Formula__c,name,Agency_Account__c,Brand__c, AF_Unilever_Entity__c,AF_Digital__c,AF_Traditional__c,AF_Unilever_Entity__r.name,AF_Unilever_Entity__r.AF_Country__c from AF_Agency_Estimate__c where AF_Bonus_Agency_Formula__c IN :agencyEstUnqStr and AF_Brand_Estimate__r.AF_Active__c=True];
                    if(lstof_agencyestimates.size()>0){
                        for(AF_Agency_Estimate__c agEstObj:lstof_agencyestimates){
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
                        sum_of_bonus_basefee=Totals_BonusMeasureTrad+Totals_BonusMeasureDigital;
                    }
                    else{
                        showmainblock=false; 
                    }
                    Map<String,Integer> BonusMeasureCalcMap = new Map<String,Integer>();
                    for(String countryName:Countryname_BT)
                    {
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
                    Integer totalBMCalc=0;
                    Integer BMDiff =0;
                    Map<String,Integer> BonusMeasureShowMap = new Map<String,Integer>();
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
                    BMDiff = integer.valueof(sum_of_bonus_basefee) - totalBMCalc;
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
                    BMDiff = integer.valueof(sum_of_bonus_basefee) - totalBMCalc;
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
                        if(mapBonus_result.containsKey(bonus_Threshold_Obj.AF_Unique_Thresholds__c) && (mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==0 || mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==null)){
                            QuartelyBonus.add(new wrapbonus(bonus_Threshold_Obj.AF_Bonus_Threshold__c,bonus_Threshold_Obj.AF_Country__r.AF_Country__c,bonus_Threshold_Obj.AF_Minimum__c,bonus_Threshold_Obj.AF_Stretching__c,bonus_Threshold_Obj.AF_Outstanding__c,mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c),count,bonus_Threshold_Obj.Bonus_Measure__c,countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c)));
                        }else if(!mapBonus_result.containsKey(bonus_Threshold_Obj.AF_Unique_Thresholds__c)){
                            QuartelyBonus.add(new wrapbonus(bonus_Threshold_Obj.AF_Bonus_Threshold__c,bonus_Threshold_Obj.AF_Country__r.AF_Country__c,bonus_Threshold_Obj.AF_Minimum__c,bonus_Threshold_Obj.AF_Stretching__c,bonus_Threshold_Obj.AF_Outstanding__c,new AF_Sub_Result__c(),count,bonus_Threshold_Obj.Bonus_Measure__c,countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c)));
                        }
                        else if(mapBonus_result.containsKey(bonus_Threshold_Obj.AF_Unique_Thresholds__c) && mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c!=0){
                            Integer newAmt = Integer.valueOf(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c);
                            QuartelyBonus.add(new wrapbonus(bonus_Threshold_Obj.AF_Bonus_Threshold__c,bonus_Threshold_Obj.AF_Country__r.AF_Country__c,bonus_Threshold_Obj.AF_Minimum__c,bonus_Threshold_Obj.AF_Stretching__c,bonus_Threshold_Obj.AF_Outstanding__c,mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c),newAmt,bonus_Threshold_Obj.Bonus_Measure__c,countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c)));
                        }
                    }
                }
            }
        }     
    }
    /***********************************************************************************
*  @Description: this method is used to calculate the quant bonus for bonus quarterly
*  @name : Calculate_Bonus
*  @param : none
*  @return: none.
*************************************************************************************/
    public void Calculate_Bonus() {
        sum_of_bonus_per=0;
        sum_of_bonus_val=0;
        Decimal Quantvalue=0;
        Decimal quant_bonus_value=0;
        sum_of_bonus_basefee=0;
        for(wrapbonus newbonus:QuartelyBonus ){
            if(newbonus.total_bonus_fees!=null){
                sum_of_bonus_basefee=sum_of_bonus_basefee+newbonus.total_bonus_fees; //01-09-2014
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
                else if (newbonus.bonusResObj.AF_Quant__c<newbonus.Minimum_bonus) {
                    Quantvalue=0;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setScale(2, RoundingMode.HALF_UP);
                }
                else if(newbonus.bonusResObj.AF_Quant__c==null){
                    newbonus.bonusResObj.AF_Quant_Bonus__c=0;
                }
                if(newbonus.bonusResObj.AF_Quant_Bonus__c!=null){
                    quant_bonus_value=math.round(newbonus.total_bonus_fees* newbonus.bonusResObj.AF_Quant_Bonus__c/100);            
                    newbonus.bonusResObj.AF_Quant_Bonus_Value__c= quant_bonus_value;
                    newbonus.bonusResObj.AF_Bonusable_Fees__c=newbonus.total_bonus_fees;// Added record to the AF_Bonusable_Fees__c 01-09-2014
                    sum_of_bonus_val=sum_of_bonus_val + newbonus.bonusResObj.AF_Quant_Bonus_Value__c;
                    if(sum_of_bonus_basefee>0)//02-09-2014 Divide by zero check
                    sum_of_bonus_per=(sum_of_bonus_val/sum_of_bonus_basefee)*100;
                }
            }  
        } 
    }
    /***********************************************************************************
*  @Description: this method is used to update the calculated bonus for bonus quarterly
*  @name : UpdateBonus
*  @param : none
*  @return: none.
*************************************************************************************/
    public void UpdateBonus() {
        Calculate_Bonus();
        displaySubmitSave = false;
        integer success=0;
        list<AF_Sub_Result__c> bonus_latestlist=new list<AF_Sub_Result__c>();
        Boolean bException=false;
        if(Bonus_SubResult_BackupList.size()>0){
            for(wrapbonus w_bonus:QuartelyBonus){
                if(w_bonus.total_bonus_fees!=null){    
                    w_bonus.bonusResObj.AF_Bonus_Threshold__c=w_bonus.bonus_threshold_id;
                    w_bonus.bonusResObj.Af_status__c=AF_Constants.STATUS_DRAFT;
                    w_bonus.bonusResObj.AF_Period__c=Quarterinfo;
                    if(w_bonus.bonusResObj.AF_Quant__c==null){
                        bException=true;
                    }
                    bonus_latestlist.add(w_bonus.bonusResObj);
                }  
            }
        }
        else{
            for(wrapbonus w_bonus:QuartelyBonus){
                AF_Sub_Result__c bonus_latestlocalList=new AF_Sub_Result__c();
                if(w_bonus.total_bonus_fees!=null){ 
                    bonus_latestlocalList.AF_Bonus_Threshold__c = w_bonus.bonus_threshold_id;
                    bonus_latestlocalList.Af_status__c = AF_Constants.STATUS_DRAFT;
                    bonus_latestlocalList.AF_Period__c = Quarterinfo;
                    bonus_latestlocalList.AF_Bonusable_Fees__c = w_bonus.total_bonus_fees;
                    bonus_latestlocalList.Bonus_Measure__c = w_bonus.Bonus_Threshold_Measure;
                    bonus_latestlocalList.AF_Minimum__c=  w_bonus.Minimum_bonus;
                    bonus_latestlocalList.AF_Outstanding__c = w_bonus.Outstanding_bonus;
                    bonus_latestlocalList.AF_Stretching__c = w_bonus.Streching_bonus;
                    bonus_latestlocalList.AF_Digital__c = w_bonus.bonusResObj.AF_Digital__c;
                    bonus_latestlocalList.AF_Traditional__c = w_bonus.bonusResObj.AF_Traditional__c;
                    bonus_latestlocalList.AF_Quant__c = w_bonus.bonusResObj.AF_Quant__c;
                    bonus_latestlocalList.AF_Quant_Bonus__c =  w_bonus.bonusResObj.AF_Quant_Bonus__c;
                    bonus_latestlocalList.AF_Quant_Bonus_Value__c = w_bonus.bonusResObj.AF_Quant_Bonus_Value__c;
                    bonus_latestlocalList.AF_country__c = w_bonus.bonusResObj.AF_country__c;
                    bonus_latestlocalList.AF_Comment__c = w_bonus.bonusResObj.AF_Comment__c;
                    bonus_latestlocalList.Sub_Result_AnnualID__c = w_bonus.bonusResObj.Id;
                    bonus_latestlocalList.AF_Class_code__c = true;
                    if(w_bonus.bonusResObj.AF_Quant__c==null){
                        bException=true;
                    }
                    bonus_latestlist.add(bonus_latestlocalList);
                }
            }
        }
        Integer validateTotal =0;
        validateTotal = Totals_BonusMeasureTrad+Totals_BonusMeasureDigital;
        String validationError;
        if(bException){
            String validationErrorMsg = Label.AF_Quant;
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,validationErrorMsg));
        }
        else if(sum_of_bonus_basefee!=validateTotal){
            validationError=Label.AF_Reconcile;
            Decimal Validationdifference= sum_of_bonus_basefee-validateTotal;
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
            validationError = validationError+ AF_Constants.EURO;
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,validationError));
        }
        else{
            if(!bonus_latestlist.isEmpty()){
                try{
                upsert bonus_latestlist;
                displaySubmitSave = true;
                apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,Label.AF_Record_Success));
                success=1;
                }
                catch(Exception e)
                 {
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_Constants.AF_AdjustQuater_STR,'UpdateBonus',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
                 }
            }
        }
        if(success==1)
        CallBonusQuarterly();
    }
    /***********************************************************************************
*  @Description: this method is used to update/Lock the calculated bonus for bonus quarterly
*  @name : ConfirmBonus
*  @param : none
*  @return: none.
*************************************************************************************/
    public void ConfirmBonus() {
        CallBonusQuarterly();
        Calculate_Bonus();
        list<AF_Sub_Result__c> bonus_latestlist=new list<AF_Sub_Result__c>();
        for(wrapbonus w_bonus:QuartelyBonus){
            if(w_bonus.total_bonus_fees!=null){    
                w_bonus.bonusResObj.AF_Bonus_Threshold__c=w_bonus.bonus_threshold_id;
                w_bonus.bonusResObj.Af_status__c=AF_Constants.STATUS_SUBMITTED;
                w_bonus.bonusResObj.AF_Locked__c=true;
                w_bonus.bonusResObj.AF_Period__c=Quarterinfo;
                bonus_latestlist.add(w_bonus.bonusResObj);   
            }   
        }
        if(!bonus_latestlist.isEmpty()){
            try{
            upsert bonus_latestlist;
            IsSave=false;
            apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,Label.AF_Record_Submitted));
            }
            catch(Exception e)
                {
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_Constants.AF_AdjustQuater_STR,'ConfirmBonus',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
                }
        }
    }        
    /***********************************************************************************
*  @Description: this wrapper class is used to display the bonus quarterly
*  @name : wrapbonus
*  @param : none
*  @return: none.
*************************************************************************************/
    public class wrapbonus{
        public String Countryname{get;set;}
        public decimal Minimum_bonus{get;set;}
        Public decimal Streching_bonus{get;set;}
        Public decimal Outstanding_bonus{get;set;}
        public AF_Sub_Result__c bonusResObj {get;set;}
        public integer total_bonus_fees{get;set;}
        public id bonus_threshold_id{get;set;}
        public String Bonus_Threshold_Measure{get;set;}
        public Integer countryCount{get;set;}
        public wrapbonus(Id b_threshold_id, String Country_Name, Decimal Minimum,Decimal Streching,Decimal Outstanding,AF_Sub_Result__c bonusResObj,integer bonus_fees,String bonusMeasure,Integer cCount){
            this.Countryname=Country_Name;
            this.Minimum_bonus=minimum;
            this.Streching_bonus=Streching;
            this.Outstanding_bonus=Outstanding;
            this.bonusResObj=bonusResObj;
            this.total_bonus_fees=bonus_fees;
            this.bonus_threshold_id=b_threshold_id;
            this.Bonus_Threshold_Measure = bonusMeasure;
            this.countryCount = cCount;
        }
    }
}