/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_subResult_Helper
@CreateDate : 21/6/2014
@Description : This is a controller class query the records from bonus threshold 
@              and updates it's in the bonus quarterly
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_subResult_Helper{
    static Map<Id,Decimal> bonusfeesAnnualMap = new Map<Id,Decimal>();
    static Map<Id,Decimal> quantBonusAnnualMap = new Map<Id,Decimal>();
    static Map<Id,Decimal> totalBonusAnnualMap = new Map<Id,Decimal>();
    static Map<Id,Decimal> QualBonusAnnualMap = new Map<Id,Decimal>();
    static Map<Id,Decimal> bonusfeesQ1 = new Map<Id,Decimal>();
    static Map<Id,Decimal> bonusfeesQ2 = new Map<Id,Decimal>();
    static Map<Id,Decimal> bonusfeesQ3 = new Map<Id,Decimal>();
    static Map<Id,Decimal> quantBonusQ1 = new Map<Id,Decimal>();
    static Map<Id,Decimal> quantBonusQ2 = new Map<Id,Decimal>();
    static Map<Id,Decimal> quantBonusQ3 = new Map<Id,Decimal>();
    static List<AF_Bonus_Results__c> bonusResultQuartList;
    static List<AF_Bonus_Results__c> bonusResultList;
    static Integer counter;
    static Set<Id> bonusResultCreated = new Set<Id>();
    private static string className_STR=AF_subResult_Helper.class.getName();
    /*****************************************************************************************
*  @Description: this method is used to create the sub result records based on the bonus thershold
*  @             and bonus result  record type and it will calculate the quant amount and update the
                 sub result object as well as the Bonus Annual records.
*  @name : subResultCalc
*  @param : queryListofSubResult,status,Lock,BonusAnnualSubResult,BonusQuarterlySubResultMap
*  @return: none.
*************************************************************************************/  
    public static void subResultCalc(List<AF_Sub_Result__c> queryListofSubResult,
    Map<Id,String> status,Map<Id,Boolean> Lock,Set<Id> BonusAnnualSubResult,Set<String> QuaterSet,Set<Id> BonusQuarterlySubResult){
        subResultCalcExt(queryListofSubResult);
        subResultBonusFeesCalc(queryListofSubResult);
        bonusResultList = new List<AF_Bonus_Results__c>();
        if(BonusAnnualSubResult.size()>0){
            for(AF_Bonus_Results__c bonusResult : [select AF_Bonus_Thresholds__c,AF_Bonusable_Fees__c,AF_Status__c,AF_Locked__c,AF_Total_Bonus_Value__c,AF_Qual_Bonus_Value__c,AF_Quant_Bonus_Value__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c IN :BonusAnnualSubResult and RecordTypeId = : Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Annual').getRecordTypeId()]){
                bonusResult.AF_Bonusable_Fees__c = bonusfeesAnnualMap.get(bonusResult.AF_Bonus_Thresholds__c);
                bonusResult.AF_Total_Bonus_Value__c = totalBonusAnnualMap.get(bonusResult.AF_Bonus_Thresholds__c);
                bonusResult.AF_Qual_Bonus_Value__c = QualBonusAnnualMap.get(bonusResult.AF_Bonus_Thresholds__c);
                bonusResult.AF_Quant_Bonus_Value__c = quantBonusAnnualMap.get(bonusResult.AF_Bonus_Thresholds__c);
                bonusResult.AF_Status__c = status.get(bonusResult.AF_Bonus_Thresholds__c);
                bonusResult.AF_Locked__c = Lock.get(bonusResult.AF_Bonus_Thresholds__c);
                bonusResultList.add(bonusResult);
            }
        }
        counter =0;
        subResultStatusCalc(BonusQuarterlySubResult,QuaterSet,status,Lock);
     }   
        /*****************************************************************************************
*  @Description: this method is used to Map the sub result id to string of that records
*  @             
*  @name : subResultMap
*  @param : queryListofSubResult,status,Lock,BonusAnnualSubResult,BonusQuarterlySubResultMap
*  @return: none.
*************************************************************************************/  
        public static void subResultMap(Map<Id,String> BonusQuarterlySubResultMap){
        string subResultMap='subResultMap';
        if(counter ==1){
            List<AF_Bonus_Results__c> bonusquart = new List<AF_Bonus_Results__c>();
            for(Id bt:BonusQuarterlySubResultMap.keySet()){
                if(!bonusResultCreated.contains(bt)){
                    AF_Bonus_Results__c b = new AF_Bonus_Results__c();
                    if(BonusQuarterlySubResultMap.get(bt)==AF_Constants.QUARTER1){
                        b.AF_Bonusable_Fees__c = bonusfeesQ1.get(bt);
                        b.AF_Quant_Bonus_Value__c = quantBonusQ1.get(bt);
                        b.AF_Bonus_Thresholds__c = bt;
                        b.AF_Status__c = AF_Constants.STATUS_DRAFT;
                        b.AF_Period__c = BonusQuarterlySubResultMap.get(bt);
                        b.RecordTypeId=Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get(AF_Constants.QUARTERLY_BONUS_REC_TYPE).getRecordTypeId();
                        bonusquart.add(b);
                    }
                    else if(BonusQuarterlySubResultMap.get(bt)==AF_Constants.QUARTER2){
                        b.AF_Bonusable_Fees__c = bonusfeesQ2.get(bt);
                        b.AF_Quant_Bonus_Value__c = quantBonusQ2.get(bt);
                        b.AF_Bonus_Thresholds__c = bt;
                        b.AF_Status__c = AF_Constants.STATUS_DRAFT;
                        b.AF_Period__c = BonusQuarterlySubResultMap.get(bt);
                        b.RecordTypeId=Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get(AF_Constants.QUARTERLY_BONUS_REC_TYPE).getRecordTypeId();
                        bonusquart.add(b);
                    }
                    else if(BonusQuarterlySubResultMap.get(bt)==AF_Constants.QUARTER3){
                        b.AF_Bonusable_Fees__c = bonusfeesQ3.get(bt);
                        b.AF_Quant_Bonus_Value__c = quantBonusQ3.get(bt);
                        b.AF_Bonus_Thresholds__c = bt;
                        b.AF_Status__c = AF_Constants.STATUS_DRAFT;
                        b.AF_Period__c = BonusQuarterlySubResultMap.get(bt);
                        b.RecordTypeId=Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get(AF_Constants.QUARTERLY_BONUS_REC_TYPE).getRecordTypeId();
                        bonusquart.add(b);
                    }
                }
            }
            if(bonusquart.size()>0){
                try{
                upsert bonusquart;
                }
                catch(Exception e)
                {
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,subResultMap,e.getMessage(),e.getTypeName(),e.getStackTraceString());
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
                }
            }
        } 
        if(bonusResultList.size()>0){
            try{
            upsert bonusResultList;
            }
            catch(Exception e)
                {
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,subResultMap,e.getMessage(),e.getTypeName(),e.getStackTraceString());
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
                }
        }
        if(bonusResultQuartList.size()>0){
            try{
            upsert bonusResultQuartList;
            }
            catch(Exception e)
                {
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,subResultMap,e.getMessage(),e.getTypeName(),e.getStackTraceString());
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
                }
        }
      }
    public static void subResultCalcExt(List<AF_Sub_Result__c> queryListofSubResult){
        for(AF_Sub_Result__c subResult:queryListofSubResult){
            if(subResult.AF_Period__c == null){
                Decimal BonusableFeesAnnual=0;
                if(subResult.AF_Bonusable_Fees__c!=null){
                    if(!bonusfeesAnnualMap.containsKey(subResult.AF_Bonus_Threshold__c)){
                        BonusableFeesAnnual = BonusableFeesAnnual + subResult.AF_Bonusable_Fees__c;
                        bonusfeesAnnualMap.put(subResult.AF_Bonus_Threshold__c,BonusableFeesAnnual);
                    }
                    else{
                        BonusableFeesAnnual = bonusfeesAnnualMap.get(subResult.AF_Bonus_Threshold__c);
                        BonusableFeesAnnual = BonusableFeesAnnual + subResult.AF_Bonusable_Fees__c;
                        bonusfeesAnnualMap.put(subResult.AF_Bonus_Threshold__c,BonusableFeesAnnual);
                    }
                }
                Decimal totalBonusValue=0;
                if(subResult.AF_Total_Bonus_Value__c!=null){
                    if(!totalBonusAnnualMap.containsKey(subResult.AF_Bonus_Threshold__c)){
                        totalBonusValue = totalBonusValue + subResult.AF_Total_Bonus_Value__c;
                        totalBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,totalBonusValue);
                    }
                    else{
                        totalBonusValue = totalBonusAnnualMap.get(subResult.AF_Bonus_Threshold__c);
                        totalBonusValue = totalBonusValue + subResult.AF_Total_Bonus_Value__c;
                        totalBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,totalBonusValue);
                    }
                }
                Decimal QualBonus=0;
                if(subResult.AF_Qual_Bonus_Value__c!=null){
                    if(!QualBonusAnnualMap.containsKey(subResult.AF_Bonus_Threshold__c)){
                        QualBonus = QualBonus + subResult.AF_Qual_Bonus_Value__c;
                        QualBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,QualBonus);
                    }
                    else{
                        QualBonus = QualBonusAnnualMap.get(subResult.AF_Bonus_Threshold__c);
                        QualBonus = QualBonus + subResult.AF_Qual_Bonus_Value__c;
                        QualBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,QualBonus);
                    }
                }
                Decimal QuantBonusAnnual=0;
                if(subResult.AF_Quant_Bonus_Value__c!=null){
                    if(!quantBonusAnnualMap.containsKey(subResult.AF_Bonus_Threshold__c)){
                        QuantBonusAnnual = QuantBonusAnnual + subResult.AF_Quant_Bonus_Value__c;
                        quantBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,QuantBonusAnnual);
                    }
                    else{
                        QuantBonusAnnual = quantBonusAnnualMap.get(subResult.AF_Bonus_Threshold__c);
                        QuantBonusAnnual = QuantBonusAnnual + subResult.AF_Quant_Bonus_Value__c;
                        quantBonusAnnualMap.put(subResult.AF_Bonus_Threshold__c,QuantBonusAnnual);
                    }
                }
            }
        }
    }
    
    public static void subResultBonusFeesCalc(List<AF_Sub_Result__c> queryListofSubResult){
                for(AF_Sub_Result__c c:queryListofSubResult){
            Decimal countBonusfees =0;
            if(c.AF_Period__c != null){
                if(c.AF_Bonusable_Fees__c!=null){
                    if(c.AF_Period__c==AF_Constants.QUARTER1){
                        if(!bonusfeesQ1.containsKey(c.AF_Bonus_Threshold__c)){
                            countBonusfees = countBonusfees+c.AF_Bonusable_Fees__c;
                            bonusfeesQ1.put(c.AF_Bonus_Threshold__c,countBonusfees);
                        }
                        else{
                            countBonusfees = bonusfeesQ1.get(c.AF_Bonus_Threshold__c);
                            countBonusfees = countBonusfees + c.AF_Bonusable_Fees__c;
                            bonusfeesQ1.put(c.AF_Bonus_Threshold__c,countBonusfees);
                        }
                    }
                    else if(c.AF_Period__c==AF_Constants.QUARTER2){
                        if(!bonusfeesQ2.containsKey(c.AF_Bonus_Threshold__c)){
                            countBonusfees = countBonusfees+c.AF_Bonusable_Fees__c;
                            bonusfeesQ2.put(c.AF_Bonus_Threshold__c,countBonusfees);
                        }
                        else{
                            countBonusfees = bonusfeesQ2.get(c.AF_Bonus_Threshold__c);
                            countBonusfees = countBonusfees + c.AF_Bonusable_Fees__c;
                            bonusfeesQ2.put(c.AF_Bonus_Threshold__c,countBonusfees);
                        }
                    }
                    else if(c.AF_Period__c==AF_Constants.QUARTER3){
                        if(!bonusfeesQ3.containsKey(c.AF_Bonus_Threshold__c)){
                            countBonusfees = countBonusfees+c.AF_Bonusable_Fees__c;
                            bonusfeesQ3.put(c.AF_Bonus_Threshold__c,countBonusfees);
                        }
                        else{
                            countBonusfees = bonusfeesQ3.get(c.AF_Bonus_Threshold__c);
                            countBonusfees = countBonusfees + c.AF_Bonusable_Fees__c;
                            bonusfeesQ3.put(c.AF_Bonus_Threshold__c,countBonusfees);
                        }
                    }
                }
                Decimal countquantBonus =0;
                if(c.AF_Quant_Bonus_Value__c!=null){
                    if(c.AF_Period__c==AF_Constants.QUARTER1){
                        if(!quantBonusQ1.containsKey(c.AF_Bonus_Threshold__c)){
                            countquantBonus = countquantBonus+c.AF_Quant_Bonus_Value__c;
                            quantBonusQ1.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                        else{
                            countquantBonus = quantBonusQ1.get(c.AF_Bonus_Threshold__c);
                            countquantBonus = countquantBonus + c.AF_Quant_Bonus_Value__c;
                            quantBonusQ1.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                    }
                    else if(c.AF_Period__c==AF_Constants.QUARTER2){
                        if(!quantBonusQ2.containsKey(c.AF_Bonus_Threshold__c)){
                            countquantBonus = countquantBonus+c.AF_Quant_Bonus_Value__c;
                            quantBonusQ2.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                        else{
                            countquantBonus = quantBonusQ2.get(c.AF_Bonus_Threshold__c);
                            countquantBonus = countquantBonus + c.AF_Quant_Bonus_Value__c;
                            quantBonusQ2.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                    }
                    else if(c.AF_Period__c==AF_Constants.QUARTER3){
                        if(!quantBonusQ3.containsKey(c.AF_Bonus_Threshold__c)){
                            countquantBonus = countquantBonus+c.AF_Quant_Bonus_Value__c;
                            quantBonusQ3.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                        else{
                            countquantBonus = quantBonusQ3.get(c.AF_Bonus_Threshold__c);
                            countquantBonus = countquantBonus + c.AF_Quant_Bonus_Value__c;
                            quantBonusQ3.put(c.AF_Bonus_Threshold__c,countquantBonus);
                        }
                    }
                }
            }
        }
    }
    public static void subResultStatusCalc(Set<Id> BonusQuarterlySubResult,Set<String> QuaterSet,Map<Id,String> status,Map<Id,Boolean> Lock){
        bonusResultQuartList = new List<AF_Bonus_Results__c>();
        if(BonusQuarterlySubResult.size()>0){
            List<AF_Bonus_Results__c> tempBonusResult = new List<AF_Bonus_Results__c>();
            try{
                tempBonusResult = [select AF_Bonus_Thresholds__c,AF_Bonusable_Fees__c,AF_Period__c,AF_Status__c,AF_Locked__c,AF_Total_Bonus_Value__c,AF_Qual_Bonus_Value__c,AF_Quant_Bonus_Value__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c IN :BonusQuarterlySubResult and RecordTypeId = : Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get(AF_Constants.QUARTERLY_BONUS_REC_TYPE).getRecordTypeId() and AF_Period__c IN:QuaterSet];
            }
            catch(Exception e){
                system.debug(e);
            }
            if(tempBonusResult.size()!=BonusQuarterlySubResult.size()){
                counter=1;
            }
            for(AF_Bonus_Results__c bonusResult : tempBonusResult){
                bonusResultCreated.add(bonusResult.AF_Bonus_Thresholds__c);
                if(bonusResult.AF_Period__c==AF_Constants.QUARTER1){
                    bonusResult.AF_Bonusable_Fees__c = bonusfeesQ1.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Quant_Bonus_Value__c = quantBonusQ1.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Status__c = status.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Locked__c = Lock.get(bonusResult.AF_Bonus_Thresholds__c);
                }
                else if(bonusResult.AF_Period__c==AF_Constants.QUARTER2){
                    bonusResult.AF_Bonusable_Fees__c = bonusfeesQ2.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Quant_Bonus_Value__c = quantBonusQ2.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Status__c = status.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Locked__c = Lock.get(bonusResult.AF_Bonus_Thresholds__c);
                }
                else if(bonusResult.AF_Period__c==AF_Constants.QUARTER3){
                    bonusResult.AF_Bonusable_Fees__c = bonusfeesQ3.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Quant_Bonus_Value__c = quantBonusQ3.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Status__c = status.get(bonusResult.AF_Bonus_Thresholds__c);
                    bonusResult.AF_Locked__c = Lock.get(bonusResult.AF_Bonus_Thresholds__c);
                }
                bonusResultQuartList.add(bonusResult);
            }
        }
    }
}