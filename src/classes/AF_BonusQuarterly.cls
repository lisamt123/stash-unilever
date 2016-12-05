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
    public map<String,Integer> CountryAgencyTotalMap = new Map<String,Integer>();
    public String agency_id;
    public String Brand_id;
    public String current_year;
    
    public map<string,Integer> CountryBusinessmeasureBonusablefee = new map<string,Integer>();
    public Boolean IsDraft{get;set;}
    public String Bonus_Measure { get; set; }
    public Boolean showmainblock{get;set;}
    public Integer Totals_Traditional { get; set; }
    //public Boolean isQuantEmpty;
    public Boolean isTraditional { get; set; }
    public Integer Totals_Digital { get; set; }
    public Boolean isDigital { get; set; }
    public decimal sum_of_bonus_per { get; set; }
    public decimal sum_of_bonus_val { get; set; }
    public list<wrapbonus> QuartelyBonus {get;set;}
    public list<AF_Bonus_Results__c>AF_Bonus_Result{get;set;}
    public list<AF_Bonus_Threshold__c> AF_Bonus_Threshold{get;set;}
    //public String Country_Full_Name;
    public Boolean AF_Digital;
    //public Integer AF_Minimum;
    //public Integer AF_Outstanding;
    //public Integer AF_Stretching;
    //public Boolean AF_Traditional;
    //public Integer Quant;
    //public Decimal Bonus_Percent;
    //public decimal Bonus_value;
    //public string brandestimate_id;
    //public string Country_name;
    //public integer Traditional_value;
    //public integer Digital_value;
    //public integer TotalTraditionalValue;
    //public integer TotalDigitalValue;
    public integer total_bonus_fees;
    //public id threshold_id;
    //public string agency_name;
    //public string Brand_name;
    public list<AF_Agency_Estimate__c>Agency_Estimate=new list<AF_Agency_Estimate__c>();
    public Boolean IsEditable{get;set;}
    //public map<id,string>bonus_thresholdid=new  map<id,string>(); 
    //set<string> Threshold = new set<string>();
    public Set<String> Countryname_BT=new set<String>();
    public Boolean IsSave{get;set;}
    public Boolean isNoRecord{get;set;}
    public string Quarterinfo{get;set;}
    public Boolean IsLocked{get;set;}
    public Integer Totals_BonusMeasureTrad { get; set; }
    public Integer Totals_BonusMeasureDigital { get; set; }
    public Integer Totals_BonusMeasureAdap { get; set; }
    public List<AF_Sub_Result__c> Bonus_SubResult_List;
    public List<AF_Sub_Result__c> Bonus_SubResult_BackupList;
    public decimal sum_of_bonus_basefee {get;set;}
    public decimal bonusable_fee {get;set;}
    public decimal Bonusable_fees_total{get;set;}
    public decimal sum_of_bonus_basefee_onload {get;set;}
    public Boolean displaySubmitButton{get;set;}
    public Boolean displaySubmitSave{get;set;}
    public set<string> agencyEstUnqStrTemp = new set<string>();
    public boolean isglobal {get;set;}
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
        //agency_name='';
        //Brand_name='';
        //Country_Full_Name='';
        AF_Digital=true;
        //AF_Minimum=0;
        //AF_Outstanding=0;
        //AF_Stretching=0;
        //AF_Traditional=false;
        //brandestimate_id='';
        //Country_name='';
        //Traditional_value=0;
        //Digital_value=0;
        total_bonus_fees=0;
        sum_of_bonus_per=0;
        sum_of_bonus_val =0;
        Totals_Traditional=0;
        Totals_Digital=0;
        //TotalTraditionalValue=0;
        //TotalDigitalValue=0;
        //isQuantEmpty=false;
        isNoRecord=True;
        sum_of_bonus_basefee=0;
        bonusable_fee = 0;
        Bonusable_fees_total=0;
        sum_of_bonus_basefee_onload=0;
        Totals_BonusMeasureTrad =0;
        Totals_BonusMeasureDigital=0;
        Totals_BonusMeasureAdap=0;
        QuartelyBonus=new list<wrapbonus>();
        Brand_id = ApexPages.currentPage().getParameters().get(AF_Constants.BRANDID);
        agency_id=ApexPages.currentPage().getParameters().get(AF_Constants.AGENCYID);
        current_year=ApexPages.currentPage().getParameters().get(AF_Constants.YEAR);
        displaySubmitButton = false;
        User userObj = new User();
        userObj = [select Id, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
        if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER|| userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE)
        {
            IsEditable=true;
        }
        list<AF_Brand_Estimate__c>Pilot_model=[select ID, AF_Is_Global_Bonus_Threshold_Checked__c,AF_AgencyBaseFees__c, AF_Pilot_Model__c,AF_No_Bonus__c from AF_Brand_Estimate__c where  Brand__c=:Brand_id and AF_Agency__c=:agency_id and AF_Fiscal_Year__c=:current_year and AF_Active__c=True limit 1];    
        if(Pilot_model.size()>0){
            Bonusable_fees_total=Pilot_model.get(0).AF_AgencyBaseFees__c;
            if(Pilot_model.get(0).AF_Pilot_Model__c){
                showmainblock=false; 
                apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Brand_Remuneration));
            }
            else{
                isglobal = Pilot_model.get(0).AF_Is_Global_Bonus_Threshold_Checked__c;
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
                       //code added by sairam 
                       if(Pilot_model.get(0).AF_Is_Global_Bonus_Threshold_Checked__c){
                        Bonus_SubResult_List = [select AF_Comment__c,AF_Bonus_Target__c,AF_Quant__c,AF_Period__c,AF_Total_Bonus__c,AF_Qual__c,AF_Country__r.AF_Country__c,AF_Country__r.name,Bonus_Measure__c,AF_Locked__c,AF_country__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Year__c,AF_Digital__c,AF_Traditional__c,AF_Adaptation__c,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Unique_Thresholds__c,AF_Quant_Bonus_Value__c,AF_Total_Bonus_Value__c,AF_Bonusable_Fees__c,AF_Quant_Bonus__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :btId and AF_Period__c=:Quarterinfo and AF_Country__r.AF_country__c = 'Global' and Bonus_Measure__c!=:AF_Constants.Qualitative_Measure];
                        if(Bonus_SubResult_List.size()>0){
                            Bonus_SubResult_BackupList.addAll(Bonus_SubResult_List); 
                        }
                        if(Bonus_SubResult_List.size()==0){
                            Bonus_SubResult_List = [select AF_Comment__c,AF_Bonus_Target__c,AF_Quant__c,AF_Total_Bonus__c,AF_Qual__c,AF_Country__r.AF_Country__c,AF_Country__r.name,Bonus_Measure__c,AF_Locked__c,AF_country__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Year__c,AF_Digital__c,AF_Traditional__c,AF_Adaptation__c,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Unique_Thresholds__c,AF_Quant_Bonus_Value__c,AF_Total_Bonus_Value__c,AF_Bonusable_Fees__c,AF_Quant_Bonus__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :btId and AF_Period__c=null and AF_Country__r.AF_country__c = 'Global' and Bonus_Measure__c!=:AF_Constants.Qualitative_Measure];
                            bonusable_fee=Pilot_model.get(0).AF_AgencyBaseFees__c;
                            sum_of_bonus_basefee=Pilot_model.get(0).AF_AgencyBaseFees__c;
                        }
                        } //ends here..
                        else if(!Pilot_model.get(0).AF_Is_Global_Bonus_Threshold_Checked__c) {
                            Bonus_SubResult_List = [select AF_Comment__c,AF_Bonus_Target__c,AF_Quant__c,AF_Period__c,AF_Total_Bonus__c,AF_Qual__c,AF_Country__r.AF_Country__c,AF_Country__r.name,Bonus_Measure__c,AF_Locked__c,AF_country__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Year__c,AF_Digital__c,AF_Traditional__c,AF_Adaptation__c,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Unique_Thresholds__c,AF_Quant_Bonus_Value__c,AF_Total_Bonus_Value__c,AF_Bonusable_Fees__c,AF_Quant_Bonus__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :btId and AF_Period__c=:Quarterinfo and AF_Country__r.AF_country__c != 'Global' and Bonus_Measure__c!=:AF_Constants.Qualitative_Measure];
                        if(Bonus_SubResult_List.size()>0){
                            Bonus_SubResult_BackupList.addAll(Bonus_SubResult_List);
                        }
                        if(Bonus_SubResult_List.size()==0){
                            Bonus_SubResult_List = [select AF_Comment__c,AF_Bonus_Target__c,AF_Quant__c,AF_Total_Bonus__c,AF_Qual__c,AF_Country__r.AF_Country__c,AF_Country__r.name,Bonus_Measure__c,AF_Locked__c,AF_country__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Year__c,AF_Digital__c,AF_Traditional__c,AF_Adaptation__c,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Unique_Thresholds__c,AF_Quant_Bonus_Value__c,AF_Total_Bonus_Value__c,AF_Bonusable_Fees__c,AF_Quant_Bonus__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :btId and AF_Period__c=null and AF_Country__r.AF_country__c != 'Global' and Bonus_Measure__c!=:AF_Constants.Qualitative_Measure];
                        }
                        
                        }
                    }
                    if(Bonus_SubResult_List.size()>0){
                        for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List){
                            Countryname_BT.add(bonus_Threshold_Obj.AF_Country__r.AF_Country__c);
                            string brandname_id=bonus_Threshold_Obj.AF_Bonus_Threshold__r.Brand_Name__c;
                            string agencyname_id=bonus_Threshold_Obj.AF_Bonus_Threshold__r.Agency_Name__c;
                            string str=agencyname_id+'::'+ brandname_id+'::'+bonus_Threshold_Obj.AF_Country__r.AF_Country__c+'::'+bonus_Threshold_Obj.AF_Bonus_Threshold__r.Year__c;
                            agencyEstUnqStr.add(str);
                            agencyEstUnqStrTemp.add(str);
                            bonusThId.add(bonus_Threshold_Obj.Id);
                            String countryDigital = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                            String countryTrad = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                            String countryAdap = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'A';
                            Integer count=0;
                          if(bonus_Threshold_Obj.Bonus_Measure__c == 'Business Measure'){
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
                            if(bonus_Threshold_Obj.AF_Adaptation__c){
                                if(!countryBMMap.containsKey(countryAdap)){
                                    countryBMMap.put(countryAdap,1);
                                }
                                else{
                                    count = countryBMMap.get(countryAdap);
                                    count=count +1;
                                    countryBMMap.put(countryAdap,count);
                                }
                            }
                           }
                            Integer unileverContCount =0;
                            if(!countryCountMap.containsKey(bonus_Threshold_Obj.AF_Country__r.AF_Country__c)){
                               if(bonus_Threshold_Obj.Bonus_Measure__c == 'Business Measure'){
                                unileverContCount = unileverContCount + 1;
                                countryCountMap.put(bonus_Threshold_Obj.AF_Country__r.AF_Country__c,unileverContCount);
                               }
                            }
                            else{
                              if(bonus_Threshold_Obj.Bonus_Measure__c == 'Business Measure'){
                                unileverContCount = countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c);
                                unileverContCount = unileverContCount+1;
                                countryCountMap.put(bonus_Threshold_Obj.AF_Country__r.AF_Country__c,unileverContCount);
                              }
                            }
                            String BMStr = bonus_Threshold_Obj.AF_Unique_Thresholds__c;
                            map<String,boolean> tradDigMapBM = new map<String,boolean>();
                            tradDigMapBM.put(AF_Constants.DIGITAL,bonus_Threshold_Obj.AF_Digital__c);
                            tradDigMapBM.put(AF_Constants.TRADITIONAL,bonus_Threshold_Obj.AF_Traditional__c);
                            tradDigMapBM.put(AF_Constants.ADAPTATION,bonus_Threshold_Obj.AF_Adaptation__c);
                            bonus_Threshold_Trad_Dig_BM_Map.put(BMStr,tradDigMapBM);
                        } 
                        
                        System.debug('Countryname_BT ...####'+Countryname_BT);
                        System.debug('agencyEstUnqStr ...####'+agencyEstUnqStr);
                        System.debug('bonusThId ...####'+bonusThId);
                        System.debug('countryBMMap ...####'+countryBMMap);
                        System.debug('countryCountMap ...####'+countryCountMap);
                        
                        System.debug('bonus_Threshold_Trad_Dig_BM_Map ...####'+bonus_Threshold_Trad_Dig_BM_Map);
                        
                        
                        
                        
                        
                        
                        for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List){
                            String countryDigital = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                            String countryTrad = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                            String countryAdap = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'A';
                            map<String,boolean> tradDigMapBMtemp = new map<String,boolean>();
                            string brandname_id=bonus_Threshold_Obj.AF_Bonus_Threshold__r.Brand_Name__c;
                            string agencyname_id=bonus_Threshold_Obj.AF_Bonus_Threshold__r.Agency_Name__c;
                            String StrTemp = agencyname_id+'::'+ brandname_id+'::'+bonus_Threshold_Obj.AF_Country__r.AF_Country__c+'::'+bonus_Threshold_Obj.AF_Bonus_Threshold__r.Year__c;
                            if(countryBMMap.size()>0){
                                if(countryBMMap.get(countryDigital)>0 && countryBMMap.get(countryTrad) >0 && countryBMMap.get(countryAdap) >0){
                                    tradDigMapBMtemp.put(AF_Constants.TRADITIONAL,true);
                                    tradDigMapBMtemp.put(AF_Constants.DIGITAL,true);
                                    tradDigMapBMtemp.put(AF_Constants.ADAPTATION,true);
                                }
                                else if(countryBMMap.get(countryDigital)>0){
                                    tradDigMapBMtemp.put(AF_Constants.DIGITAL,true);
                                    tradDigMapBMtemp.put(AF_Constants.TRADITIONAL,false);
                                    tradDigMapBMtemp.put(AF_Constants.ADAPTATION,false);
                                }
                                else if(countryBMMap.get(countryTrad)>0){
                                    tradDigMapBMtemp.put(AF_Constants.TRADITIONAL,true);
                                    tradDigMapBMtemp.put(AF_Constants.DIGITAL,false);
                                    tradDigMapBMtemp.put(AF_Constants.ADAPTATION,false);
                                }
                                else if(countryBMMap.get(countryAdap)>0){
                                    tradDigMapBMtemp.put(AF_Constants.TRADITIONAL,false);
                                    tradDigMapBMtemp.put(AF_Constants.DIGITAL,false);
                                    tradDigMapBMtemp.put(AF_Constants.ADAPTATION,true);
                                }
                                bonus_Threshold_Trad_Dig_BM_MapTemp.put(StrTemp,tradDigMapBMtemp);
                            }
                        } 
                        
                        
                        System.debug('bonus_Threshold_Trad_Dig_BM_MapTemp ...####'+bonus_Threshold_Trad_Dig_BM_MapTemp);
                        
                         
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
                        SYSTEM.DEBUG('bonusResObj.AF_Quant_Bonus_Value__c...###'+bonusResObj.AF_Quant_Bonus_Value__c);
                        SYSTEM.debug('sum_of_bonus_val....'+sum_of_bonus_val);
                        if(bonusResObj.AF_Quant_Bonus_Value__c!=null){
                            
                            sum_of_bonus_val=sum_of_bonus_val + integer.valueof(bonusResObj.AF_Quant_Bonus_Value__c);
                            SYSTEM.debug('sum_of_bonus_val....111'+sum_of_bonus_val);
                        }
                        if(bonusResObj.AF_Bonusable_Fees__c!=null){  
                            System.debug('Inside bonusablefees loop..####');        
                            sum_of_bonus_basefee_onload=sum_of_bonus_basefee_onload+bonusResObj.AF_Bonusable_Fees__c;// 01-09-2014 Calculate the sum for initial load
                            if(sum_of_bonus_basefee_onload>0)
                            sum_of_bonus_per=math.round((sum_of_bonus_val/Bonusable_fees_total)*100);
                        }
                    } 
                    
                    System.debug('mapBonus_result ...####'+mapBonus_result);
                    
                    
                    list<AF_Agency_Estimate__c>oddagencylist=new   list<AF_Agency_Estimate__c>();
                    set<String> setofnonthreshold_country = new set<String>();
                    if(!isglobal){
                        oddagencylist=[Select ID,AF_Total__c,AF_Unilever_Entity__r.AF_Country__c from AF_Agency_Estimate__c where AF_Unilever_Entity__r.AF_Country__c !=:Countryname_BT and AF_Agency_Entity__r.AF_Agency__c=:agency_id.substring(0,15) and AF_Brand_Id__c=:Brand_id.substring(0,15) and AF_Brand_Estimate__r.AF_Active__c=True and AF_Fiscal_Year__c=:current_year];
                    }
                    System.debug('oddagencylist....###'+oddagencylist);
                    if(oddagencylist.size()>0){
                        for(AF_Agency_Estimate__c oddagency:oddagencylist){
                            if(oddagency.AF_Total__c>0){
                                setofnonthreshold_country.add(oddagency.AF_Unilever_Entity__r.AF_Country__c);
                            }
                        }
                        showmainblock=True;
                        if(setofnonthreshold_country.size()>0 &&!Pilot_model.get(0).AF_No_Bonus__c){
                            displaySubmitButton = true; 
                            Apexpages.addmessage(new apexpages.message(apexpages.severity.WARNING,  Label.AF_Thershold_Mismatch+ ' '+ setofnonthreshold_country ));
                        }
                    }
                    System.debug('setofnonthreshold_country...###'+setofnonthreshold_country);
                    
                    Map<String,Integer> EntityAmtMap = new Map<String,Integer>();
                    
                    list<AF_Agency_Estimate__c>lstof_agencyestimates=new list<AF_Agency_Estimate__c>();
                    if(!isglobal){
                        lstof_agencyestimates=[Select id,AF_Total__c,AF_Bonus_Agency_Formula__c,name,Agency_Account__c,Brand__c, AF_Unilever_Entity__c,AF_Digital__c,AF_Adaptation__c,AF_Traditional__c,AF_Unilever_Entity__r.name,AF_Unilever_Entity__r.AF_Country__c from AF_Agency_Estimate__c where AF_Bonus_Agency_Formula__c IN :agencyEstUnqStr and AF_Brand_Estimate__r.AF_Active__c=True];
                        System.debug('lstof_agencyestimates...###'+lstof_agencyestimates);
                   
                    } else {
                        lstof_agencyestimates=[Select id,AF_Total__c,AF_Bonus_Agency_Formula__c,name,Agency_Account__c,Brand__c, AF_Unilever_Entity__c,AF_Digital__c,AF_Adaptation__c,AF_Traditional__c,AF_Unilever_Entity__r.name,AF_Unilever_Entity__r.AF_Country__c from AF_Agency_Estimate__c where AF_Agency_Entity__r.AF_Agency__c=:agency_id.substring(0,15) and AF_Brand_Id__c=:Brand_id.substring(0,15) and AF_Brand_Estimate__r.AF_Active__c=True and AF_Fiscal_Year__c=:current_year];
                    }
                    if(lstof_agencyestimates.size()>0){
                        for(AF_Agency_Estimate__c agEstObj:lstof_agencyestimates){
                            String UEntityTrad= agEstObj.AF_Unilever_Entity__r.AF_Country__c + '::' + 'T';
                            String UEntityDigital = agEstObj.AF_Unilever_Entity__r.AF_Country__c + '::' + 'D';
                            String UEntityAdap = agEstObj.AF_Unilever_Entity__r.AF_Country__c + '::' + 'A';
                            Integer TradValue=0;
                            Integer DigitalValue=0;
                            integer total=0;
                            
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
                            
                            if(!EntityAmtMap.containsKey(UEntityAdap)){
                                total = total + (integer.valueof(agEstObj.AF_Adaptation__c));
                                system.debug('*****IF****'+EntityAmtMap);
                                EntityAmtMap.put(UEntityAdap,total);
                            }
                            else{
                                total = EntityAmtMap.get(UEntityAdap);
                                total = total + (integer.valueof(agEstObj.AF_Adaptation__c));
                                EntityAmtMap.put(UEntityAdap,total);
                                system.debug('*****ELSE****'+EntityAmtMap);
                            }
                            
                            if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c)!=null || isglobal){
                                //if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get(AF_Constants.DIGITAL) && //bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get(AF_Constants.TRADITIONAL)){
                                    Totals_BonusMeasureDigital = Totals_BonusMeasureDigital + (integer.valueof(agEstObj.AF_Digital__c));
                                    Totals_BonusMeasureTrad = Totals_BonusMeasureTrad + (integer.valueof(agEstObj.AF_Traditional__c));
                                    Totals_BonusMeasureAdap = Totals_BonusMeasureAdap + (integer.valueof(agEstObj.AF_Adaptation__c));
                                /*}
                                else if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get(AF_Constants.DIGITAL)){
                                    Totals_BonusMeasureDigital = Totals_BonusMeasureDigital + (integer.valueof(agEstObj.AF_Digital__c));
                                }
                                else if(bonus_Threshold_Trad_Dig_BM_MapTemp.get(agEstObj.AF_Bonus_Agency_Formula__c).get(AF_Constants.TRADITIONAL)){
                                    Totals_BonusMeasureTrad = Totals_BonusMeasureTrad + (integer.valueof(agEstObj.AF_Traditional__c));
                                }*/
                               // bonusable_fee = bonusable_fee + (integer.valueof(agEstObj.AF_Digital__c)+ integer.valueof(agEstObj.AF_Traditional__c) 
                               // + integer.valueof(agEstObj.AF_Adaptation__c));
                            }
                        }
                        bonusable_fee = Totals_BonusMeasureDigital + Totals_BonusMeasureTrad +Totals_BonusMeasureAdap;
                        System.debug('EntityAmtMap...###'+EntityAmtMap);
                        //sum_of_bonus_basefee=Totals_BonusMeasureTrad+Totals_BonusMeasureDigital;
                        sum_of_bonus_basefee=bonusable_fee;
                    }
                    else{
                        showmainblock=false; 
                    }
                    Map<String,Integer> BonusMeasureCalcMap = new Map<String,Integer>();
                    for(String countryName:Countryname_BT)
                    {
                        String countryDigital = countryName + '::' + 'D';
                        String countryTrad = countryName + '::' + 'T';
                        String countryAdap = countryName + '::' + 'A';
                        Integer count=0;
                        Integer Amt =0;
                        Integer calc=0;
                       if(!isglobal){
                        count = countryBMMap.get(countryDigital);
                        Amt = EntityAmtMap.get(countryDigital);
                        if(count>0 && Amt!=null){
                            calc = integer.valueof(Amt/count);
                        }
                        system.debug('******DIGI********'+BonusMeasureCalcMap+Amt);
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
                        
                        count=0;
                        Amt =0;
                        calc=0;
                        count = countryBMMap.get(countryAdap);
                        Amt = EntityAmtMap.get(countryAdap);
                        if(count>0 && Amt!=null){
                            calc = integer.valueof(Amt/count);
                        }
                        
                        BonusMeasureCalcMap.put(countryAdap,calc);
                       } else {
                       
                           Map<string,Integer> entityamtmaptemp = new Map<string,Integer>();
                       
                           count = countryBMMap.get(countryDigital);
                           for(string s :EntityAmtMap.keyset()){
                                if(s.contains(AF_Constants.AF_Digital_Delim)){
                                    Amt = Amt+EntityAmtMap.get(s);
                                }
                           }
                            
                           entityamtmaptemp.put(countryDigital,Amt);
                            if(count>0 && Amt!=null){
                            calc = integer.valueof(Amt/count);
                            }
                          
                        system.debug('******DIGI********'+BonusMeasureCalcMap+Amt);
                        BonusMeasureCalcMap.put(countryDigital,calc);
                        
                        count=0;
                        Amt =0;
                        calc=0;
                        count = countryBMMap.get(countryTrad);
                         for(string s :EntityAmtMap.keyset()){
                                if(s.contains('::T')){
                                    Amt = Amt+EntityAmtMap.get(s);
                                }
                           }
                           entityamtmaptemp.put(countryTrad,Amt);
                        if(count>0 && Amt!=null){
                            calc = integer.valueof(Amt/count);
                        }
                        BonusMeasureCalcMap.put(countryTrad,calc);
                        
                        count=0;
                        Amt =0;
                        calc=0;
                        count = countryBMMap.get(countryAdap);
                         for(string s :EntityAmtMap.keyset()){
                           System.debug('s...@@@@'+s);
                                if(s.contains(AF_Constants.AF_Adaption_Delim)){
                                    System.debug('Inside AAAA');
                                    System.debug('Amt...22222'+Amt);
                                     System.debug('Amt...EntityAmtMap.get(s)'+EntityAmtMap.get(s));
                                    Amt = Amt+EntityAmtMap.get(s);
                                
                                }
                           }
                           System.debug('Amt...111111'+Amt);
                           entityamtmaptemp.put(countryAdap,Amt);
                        if(count>0 && Amt!=null){
                            calc = integer.valueof(Amt/count);
                        }
                        SYSTEM.DEBUG('CALC...'+calc);
                        SYSTEM.DEBUG('countryAdap...'+countryAdap);
                        BonusMeasureCalcMap.put(countryAdap,calc);
                        EntityAmtMap.clear();
                        EntityAmtMap = entityamtmaptemp.clone();
                       
                       }
                    }
                     system.debug('******BonusMeasureCalcMap********###'+BonusMeasureCalcMap);
                    
                    Integer totalBMCalc=0;
                    Integer BMDiff =0;
                    Map<String,Integer> BonusMeasureShowMap = new Map<String,Integer>();
                    for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List){
                        string strBM = bonus_Threshold_Obj.AF_Unique_Thresholds__c;
                        Integer count=0;
                        String countryDigital = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                        String countryTrad = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                        String countryAdap = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'A';
                        if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get(AF_Constants.DIGITAL)){
                            count = BonusMeasureCalcMap.get(countryDigital);
                        }
                        if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get(AF_Constants.TRADITIONAL)){
                            count = count+BonusMeasureCalcMap.get(countryTrad);
                        }
                        if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get(AF_Constants.ADAPTATION)){
                            count = count+BonusMeasureCalcMap.get(countryAdap);
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
                    System.debug('Going inside adding of quarterly bonus list..');
                    for(AF_Sub_Result__c bonus_Threshold_Obj:Bonus_SubResult_List){
                        //Coded Added by Sairam
                        //showmainblock is the varibale which is not allowing to show global records..
                        //added a check as if bonus_Threshold_Obj.AF_Country__r.AF_Country__c is 'global',showmainblock = true
                        
                        if(bonus_Threshold_Obj.AF_Country__r.AF_Country__c == 'global' || bonus_Threshold_Obj.AF_Country__r.AF_Country__c == 'Global'){
                            showmainblock = True;
                        }
                        System.debug('$$$$bonus_Threshold_Obj:Bonus_SubResult_List..'+Bonus_SubResult_List);
                        System.debug('$$$mapBonus_result...'+mapBonus_result);
                        string strBM = bonus_Threshold_Obj.AF_Unique_Thresholds__c;
                        Integer count=0;
                        String countryDigital = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'D';
                        String countryTrad = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'T';
                        String countryAdap = bonus_Threshold_Obj.AF_Country__r.AF_Country__c + '::' + 'A';
                      if(bonus_Threshold_Obj.AF_Country__r.AF_Country__c != 'Global'){
                       if(bonus_Threshold_Obj.Bonus_Measure__c == 'Business Measure' ){
                        if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get(AF_Constants.DIGITAL)){
                            count = BonusMeasureCalcMap.get(countryDigital);
                            System.debug('Inside the digital loop..'+count+'...'+BonusMeasureCalcMap.get(countryDigital));
                        }
                        if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get(AF_Constants.TRADITIONAL)){
                            count = count+BonusMeasureCalcMap.get(countryTrad);
                            System.debug('Inside the digital loop..'+count+'...'+BonusMeasureCalcMap.get(countryTrad));
                        }
                         if(bonus_Threshold_Trad_Dig_BM_Map.get(strBM).get(AF_Constants.ADAPTATION)){
                            count = count+BonusMeasureCalcMap.get(countryAdap);
                             System.debug('Inside the digital loop..'+count+'...'+BonusMeasureCalcMap.get(countryAdap));
                        
                        }
                       } else {
                           count = EntityAmtMap.get(countryDigital)+EntityAmtMap.get(countryTrad)+EntityAmtMap.get(countryAdap);
                       
                       }
                       } else {
                            if(bonus_Threshold_Obj.Bonus_Measure__c == 'Business Measure' ){
                            count = EntityAmtMap.get(countryDigital)+EntityAmtMap.get(countryTrad)+EntityAmtMap.get(countryAdap);
                            count = count/countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c);
                            }else {
                             count = EntityAmtMap.get(countryDigital)+EntityAmtMap.get(countryTrad)+EntityAmtMap.get(countryAdap);
                           }
                       
                       }
                        System.debug('Count is... $$$'+count);
                        if(mapBonus_result.containsKey(bonus_Threshold_Obj.AF_Unique_Thresholds__c) && (mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==0 || mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c==null)){
                            System.debug('inside 1st loop..');
                            QuartelyBonus.add(new wrapbonus(bonus_Threshold_Obj.AF_Bonus_Threshold__c,bonus_Threshold_Obj.AF_Country__r.AF_Country__c,bonus_Threshold_Obj.AF_Minimum__c,bonus_Threshold_Obj.AF_Stretching__c,bonus_Threshold_Obj.AF_Outstanding__c,mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c),count,bonus_Threshold_Obj.Bonus_Measure__c,countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c),bonus_Threshold_Obj.AF_Bonus_Target__c));
                        }else if(!mapBonus_result.containsKey(bonus_Threshold_Obj.AF_Unique_Thresholds__c)){
                            System.debug('inside 2nd loop..');
                            QuartelyBonus.add(new wrapbonus(bonus_Threshold_Obj.AF_Bonus_Threshold__c,bonus_Threshold_Obj.AF_Country__r.AF_Country__c,bonus_Threshold_Obj.AF_Minimum__c,bonus_Threshold_Obj.AF_Stretching__c,bonus_Threshold_Obj.AF_Outstanding__c,new AF_Sub_Result__c(),count,bonus_Threshold_Obj.Bonus_Measure__c,countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c),bonus_Threshold_Obj.AF_Bonus_Target__c));
                        }
                        else if(mapBonus_result.containsKey(bonus_Threshold_Obj.AF_Unique_Thresholds__c) && mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c!=0){
                            System.debug('inside 3rd loop..');
                            Integer newAmt = Integer.valueOf(mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c).AF_Bonusable_Fees__c);
                            QuartelyBonus.add(new wrapbonus(bonus_Threshold_Obj.AF_Bonus_Threshold__c,bonus_Threshold_Obj.AF_Country__r.AF_Country__c,bonus_Threshold_Obj.AF_Minimum__c,bonus_Threshold_Obj.AF_Stretching__c,bonus_Threshold_Obj.AF_Outstanding__c,mapBonus_result.get(bonus_Threshold_Obj.AF_Unique_Thresholds__c),newAmt,bonus_Threshold_Obj.Bonus_Measure__c,countryCountMap.get(bonus_Threshold_Obj.AF_Country__r.AF_Country__c),bonus_Threshold_Obj.AF_Bonus_Target__c));
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
        CountryBusinessmeasureBonusablefee = new Map<String,Integer>();
        sum_of_bonus_per=0;
        sum_of_bonus_val=0;
        Decimal Quantvalue=0;
        Decimal quant_bonus_value=0;
        sum_of_bonus_basefee=0;
        for(wrapbonus newbonus:QuartelyBonus ){
            if(newbonus.Bonus_Threshold_Measure == 'Business Measure'){
                if(!CountryBusinessmeasureBonusablefee.containsKey(newbonus.Countryname)){
                     
                     CountryBusinessmeasureBonusablefee.put(newbonus.Countryname,newbonus.total_bonus_fees);   
                
                } else {
                    integer temp = 0;
                   temp =  CountryBusinessmeasureBonusablefee.get(newbonus.Countryname);
                   temp = temp+newbonus.total_bonus_fees;
                   CountryBusinessmeasureBonusablefee.put(newbonus.Countryname,temp); 
                } 
            
            }
            if(newbonus.total_bonus_fees!=null){
                sum_of_bonus_basefee=sum_of_bonus_basefee+newbonus.total_bonus_fees; //01-09-2014
                if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Outstanding_bonus & newbonus.bonusResObj.Bonus_Measure__c==AF_Constants.TEST_BRAND_ATTRIBUTE ) {
                    AF_QuarterlyBonus__c Brand_attribute=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_BRAND_ATTRIBUTE );
                    Decimal bonus_outstanding=Brand_attribute.Outstanding__c; 
                    Quantvalue=bonus_outstanding;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(2,RoundingMode.HALF_UP);
                } 
                else if (newbonus.bonusResObj.AF_Quant__c==newbonus.Streching_bonus && newbonus.bonusResObj.Bonus_Measure__c==AF_Constants.TEST_BRAND_ATTRIBUTE) {
                    AF_QuarterlyBonus__c Brand_attribute=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_BRAND_ATTRIBUTE);
                    Decimal bonus_stretching=Brand_attribute.Stretching__c; 
                    Decimal bonus_min=Brand_attribute.Minimum__c;
                    Quantvalue=bonus_stretching+ bonus_min* (newbonus.bonusResObj.AF_Quant__c-newbonus.Streching_bonus)/(newbonus.Outstanding_bonus-newbonus.Streching_bonus)  ;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(2, RoundingMode.HALF_UP);
                } 
                else if (newbonus.bonusResObj.AF_Quant__c==newbonus.Minimum_bonus && newbonus.bonusResObj.Bonus_Measure__c==AF_Constants.TEST_BRAND_ATTRIBUTE) {
                    AF_QuarterlyBonus__c Brand_attribute=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_BRAND_ATTRIBUTE);
                    Decimal bonus_minimum=Brand_attribute.Minimum__c; 
                    Quantvalue=bonus_minimum + bonus_minimum * (newbonus.bonusResObj.AF_Quant__c-newbonus.Minimum_bonus)/(newbonus.Streching_bonus-newbonus.Minimum_bonus)  ;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(2, RoundingMode.HALF_UP);  
                }
                else if (newbonus.bonusResObj.AF_Quant__c<newbonus.Minimum_bonus) {
                    Quantvalue=0;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(0, RoundingMode.HALF_UP);
                }
                else if(newbonus.bonusResObj.AF_Quant__c==null){
                    newbonus.bonusResObj.AF_Quant_Bonus__c=0;
                }
                if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Outstanding_bonus & newbonus.bonusResObj.Bonus_Measure__c==AF_Constants.TEST_BUSINESS_MEASURE ) {
                    AF_QuarterlyBonus__c Business_Measure=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_BUSINESS_MEASURE );
                    Decimal bonus_outstanding=Business_Measure.Outstanding__c; 
                    Quantvalue=bonus_outstanding;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(2, RoundingMode.HALF_UP);
                } 
                else if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Streching_bonus && newbonus.bonusResObj.AF_Quant__c<newbonus.Outstanding_bonus && newbonus.bonusResObj.Bonus_Measure__c==AF_Constants.TEST_BUSINESS_MEASURE) {
                    AF_QuarterlyBonus__c Business_Measure=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_BUSINESS_MEASURE);
                    Decimal bonus_stretching=Business_Measure.Stretching__c; 
                    Decimal bonus_min=Business_Measure.Minimum__c;
                    Quantvalue=bonus_stretching+ bonus_min* (newbonus.bonusResObj.AF_Quant__c-newbonus.Streching_bonus)/(newbonus.Outstanding_bonus-newbonus.Streching_bonus)  ;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(2, RoundingMode.HALF_UP);
                } 
                else if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Minimum_bonus && newbonus.bonusResObj.AF_Quant__c<newbonus.Streching_bonus && newbonus.bonusResObj.Bonus_Measure__c==AF_Constants.TEST_BUSINESS_MEASURE ) {
                    AF_QuarterlyBonus__c Business_Measure=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_BUSINESS_MEASURE);
                    Decimal bonus_minimum=Business_Measure.Minimum__c; 
                    Quantvalue=bonus_minimum + bonus_minimum * (newbonus.bonusResObj.AF_Quant__c-newbonus.Minimum_bonus)/(newbonus.Streching_bonus-newbonus.Minimum_bonus)  ;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(2, RoundingMode.HALF_UP);  
                }
                else if (newbonus.bonusResObj.AF_Quant__c<newbonus.Minimum_bonus) {
                    Quantvalue=0;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(2, RoundingMode.HALF_UP);
                }
                else if(newbonus.bonusResObj.AF_Quant__c==null){
                    newbonus.bonusResObj.AF_Quant_Bonus__c=0;
                }
                if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Outstanding_bonus & newbonus.bonusResObj.Bonus_Measure__c==AF_Constants.TEST_COMMUNICATION) {
                    AF_QuarterlyBonus__c Communication=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_COMMUNICATION);
                    Decimal bonus_outstanding=Communication.Outstanding__c; 
                    Quantvalue=bonus_outstanding;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(2, RoundingMode.HALF_UP);
                } 
                else if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Streching_bonus && newbonus.bonusResObj.AF_Quant__c<newbonus.Outstanding_bonus && newbonus.bonusResObj.Bonus_Measure__c==AF_Constants.TEST_COMMUNICATION) {
                    AF_QuarterlyBonus__c Communication=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_COMMUNICATION);
                    Decimal bonus_stretching=Communication.Stretching__c; 
                    Decimal bonus_min=Communication.Minimum__c;
                    Quantvalue=bonus_stretching+ bonus_min* (newbonus.bonusResObj.AF_Quant__c-newbonus.Streching_bonus)/(newbonus.Outstanding_bonus-newbonus.Streching_bonus)  ;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(2, RoundingMode.HALF_UP);
                } 
                else if (newbonus.bonusResObj.AF_Quant__c>=newbonus.Minimum_bonus && newbonus.bonusResObj.AF_Quant__c<newbonus.Streching_bonus && newbonus.bonusResObj.Bonus_Measure__c==AF_Constants.TEST_COMMUNICATION) {
                    AF_QuarterlyBonus__c Communication=AF_QuarterlyBonus__c.getInstance(AF_Constants.TEST_COMMUNICATION);
                    Decimal bonus_minimum=Communication.Minimum__c; 
                    Quantvalue=bonus_minimum + bonus_minimum * (newbonus.bonusResObj.AF_Quant__c-newbonus.Minimum_bonus)/(newbonus.Streching_bonus-newbonus.Minimum_bonus)  ;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(2, RoundingMode.HALF_UP);  
                }
                else if (newbonus.bonusResObj.AF_Quant__c<newbonus.Minimum_bonus) {
                    Quantvalue=0;
                    newbonus.bonusResObj.AF_Quant_Bonus__c=Quantvalue.setscale(2, RoundingMode.HALF_UP);
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
                    sum_of_bonus_per=((sum_of_bonus_val/Bonusable_fees_total)*100).setscale(2);
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
        
        map<string,string> bonusablefeesexecption = new map<String,string>();
        
        list<AF_Agency_Estimate__c>lstof_agencyestimates=new list<AF_Agency_Estimate__c>();
        CountryAgencyTotalMap = new Map<String,Integer>();
        if(!isglobal){
        
            lstof_agencyestimates=[Select id,AF_Total__c,AF_Bonus_Agency_Formula__c,name,Agency_Account__c,Brand__c, AF_Unilever_Entity__c,AF_Digital__c,AF_Adaptation__c,AF_Traditional__c,AF_Unilever_Entity__r.name,AF_Unilever_Entity__r.AF_Country__c from AF_Agency_Estimate__c where AF_Bonus_Agency_Formula__c IN :agencyEstUnqStrTemp and AF_Brand_Estimate__r.AF_Active__c=True];
            System.debug('lstof_agencyestimates...'+lstof_agencyestimates);
            for(AF_Agency_Estimate__c agEst : lstof_agencyestimates){
               if(!CountryAgencyTotalMap.containskey(agEst.AF_Unilever_Entity__r.AF_Country__C)){
            CountryAgencyTotalMap.put(agEst.AF_Unilever_Entity__r.AF_Country__C,Integer.valueof(agEst.AF_Total__c));
              }else{
                  integer count = 0;
                 count = CountryAgencyTotalMap.get(agEst.AF_Unilever_Entity__r.AF_Country__C);
                  count = count + Integer.valueof(agEst.AF_Total__c);
                   CountryAgencyTotalMap.put(agEst.AF_Unilever_Entity__r.AF_Country__C,count);
              }
           System.debug('!!!! test..'+agEst.id+'...'+agEst.AF_Unilever_Entity__r.AF_Country__C+'...'+Integer.valueof(agEst.AF_Total__c));
           System.debug('CountryAgencyTotalMap....'+CountryAgencyTotalMap); 
            }
        } else {
        
            lstof_agencyestimates=[Select id,AF_Total__c,AF_Bonus_Agency_Formula__c,name,Agency_Account__c,Brand__c, AF_Unilever_Entity__c,AF_Digital__c,AF_Adaptation__c,AF_Traditional__c,AF_Unilever_Entity__r.name,AF_Unilever_Entity__r.AF_Country__c from AF_Agency_Estimate__c where AF_Agency_Entity__r.AF_Agency__c=:agency_id.substring(0,15) and AF_Brand_Id__c=:Brand_id.substring(0,15) and AF_Brand_Estimate__r.AF_Active__c=True and AF_Fiscal_Year__c=:current_year];
            
            for(AF_Agency_Estimate__c agEst : lstof_agencyestimates){
              System.debug('agEst...&&&'+agEst+'...'+Integer.valueof(agEst.AF_Total__c));
                if(!CountryAgencyTotalMap.containskey('Global')){
                    System.debug('Inside the 1@LOOP');
                    CountryAgencyTotalMap.put('Global',Integer.valueof(agEst.AF_Total__c));
                }else{
                System.debug('Inside the 1@LOOP');
                integer count = Integer.valueof(agEst.AF_Total__c);
                count = count +CountryAgencyTotalMap.get('Global');
                CountryAgencyTotalMap.put('Global',count);
                }
            }
        }
        
       
        System.debug('CountryBusinessmeasureBonusablefee...###'+CountryBusinessmeasureBonusablefee);
        System.debug('CountryAgencyTotalMap...###'+CountryAgencyTotalMap);
        integer tempcount = 0;
        for(String str:CountryAgencyTotalMap.keyset()){
             
              String excep;
             Integer value =   CountryBusinessmeasureBonusablefee.get(str);
             if(value > CountryAgencyTotalMap.get(str)){
                 Integer diff =  value - CountryAgencyTotalMap.get(str) ;
                if(tempcount == 0){ excep = 'Target exceeded by ' + string.valueof(diff);}
                else { excep = ', Target exceeded by ' + string.valueof(diff);}
                 bonusablefeesexecption.put(str,excep);
             
             }
             if(value < CountryAgencyTotalMap.get(str)){
                 Integer diff =  CountryAgencyTotalMap.get(str) - value  ;
                if(tempcount == 0){ excep = 'Target missing by ' + string.valueof(diff);}
                else { excep = ', Target missing by ' + string.valueof(diff);}
                 bonusablefeesexecption.put(str,excep);
             
             }
             tempcount ++;
        }
        
        System.debug('bonusablefeesexecption...##'+bonusablefeesexecption);
        
        
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
                    bonus_latestlocalList.AF_Bonus_Target__c = w_bonus.Bonus_Target;
                    bonus_latestlocalList.AF_Minimum__c=  w_bonus.Minimum_bonus;
                    bonus_latestlocalList.AF_Outstanding__c = w_bonus.Outstanding_bonus;
                    bonus_latestlocalList.AF_Stretching__c = w_bonus.Streching_bonus;
                    bonus_latestlocalList.AF_Digital__c = w_bonus.bonusResObj.AF_Digital__c;
                    bonus_latestlocalList.AF_Traditional__c = w_bonus.bonusResObj.AF_Traditional__c;
                    bonus_latestlocalList.AF_Adaptation__c = w_bonus.bonusResObj.AF_Adaptation__c;
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
        validateTotal = Totals_BonusMeasureTrad+Totals_BonusMeasureDigital+Totals_BonusMeasureAdap;
        String validationError;
        if(bException){
            String validationErrorMsg = Label.AF_Quant;
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,validationErrorMsg));
        } else if(bonusablefeesexecption.size()>0){
             string validateerror = 'Manual adjustment to Bonusable fees must reconcile back to Base Fee Matrix.';
             for(string str: bonusablefeesexecption.keyset()){
                 validateerror = validateerror + bonusablefeesexecption.get(str) + ' for country ' + str;
             }
             
              apexpages.addmessage(new apexpages.message(apexpages.severity.Error,validateerror));  
        
        }
        /*
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
        }*/
        else{
            if(!bonus_latestlist.isEmpty()){
                try{
                if(sum_of_bonus_per>24){
                apexpages.addmessage(new apexpages.message(apexpages.severity.warning,Label.AF_BonusValidation));
                }else{
                upsert bonus_latestlist;
                }
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
            if(sum_of_bonus_per>24){
            apexpages.addmessage(new apexpages.message(apexpages.severity.warning,Label.AF_BonusValidation));
            }else{
            upsert bonus_latestlist;
            }
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
        public string Bonus_Target{get;set;}
        public Integer countryCount{get;set;}
        public wrapbonus(Id b_threshold_id, String Country_Name, Decimal Minimum,Decimal Streching,Decimal Outstanding,AF_Sub_Result__c bonusResObj,integer bonus_fees,String bonusMeasure,Integer cCount,string bonustarget){
            this.Countryname=Country_Name;
            this.Minimum_bonus=minimum;
            this.Streching_bonus=Streching;
            this.Outstanding_bonus=Outstanding;
            this.bonusResObj=bonusResObj;
            this.total_bonus_fees=bonus_fees;
            this.bonus_threshold_id=b_threshold_id;
            this.Bonus_Threshold_Measure = bonusMeasure;
            this.Bonus_Target=bonustarget;
            this.countryCount = cCount;
        }
    }
}