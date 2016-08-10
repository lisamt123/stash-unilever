/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_SubResultHandler
@CreateDate : 21/6/2014
@Description : This is a controller class for trigger's 
@               
@Version : 1.0
@reference : none
***********************************************************************************/
public with sharing class AF_SubResultHandler implements ITrigger{
    Map<Id,String> status = new Map<Id,String>();
    Map<Id,Boolean> Lock = new Map<Id,Boolean>();
    Set<Id> BonusThresholdId = new Set<Id>();
    Set<Id>  BonusAnnualSubResult = new Set<Id>();
    Map<Id,String> BonusQuarterlySubResultMap = new Map<Id,String>();
    Set<Id>  BonusQuarterlySubResult = new Set<Id>();
    Set<String> QuaterSet = new Set<String>();
    Set<String> quarter = new Set<String>();
    Set<Id> BonusThresholdDelId = new Set<Id>();
    set<string> Uniquekey=new set<string>();
    list<AF_Bonus_Results__c> BonusList=new list<AF_Bonus_Results__c>();
    Set<Id> BonusThershold = new Set<Id>();
    set<id> bonusthreshold=new set<id>();
    Set<Id> AgencyName = new set<id>();
    Set<Id> BrandName = new set<id>();
    Set<String> year = new set<String>();
    list<AF_Sub_Result__c> SubBonusQuarterlyList=new list<AF_Sub_Result__c>();
    list<AF_Sub_Result__c> newTriggerList=new list<AF_Sub_Result__c>();
    list<AF_Sub_Result__c>  Subresultupdate= new list<AF_Sub_Result__c>();
    private static string className_STR=AF_SubResultHandler.class.getName();
    /***********************************************************************************
*  @Description: This derived as part of trigger hanlder
*            
*  @name : bulkAfter
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void bulkBefore()
    {
        /*Method is Blank as this handler doesnot handle any bulkBefore*/
    }
    /***********************************************************************************
*  @Description: This method is called prior to execution of an AFTER trigger. Use this to cache
*            any data required into maps prior execution of the trigger.
*  @name : bulkAfter
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void bulkAfter()
    {
    list<AF_Sub_Result__c>  SubresultTriggerNew= new list<AF_Sub_Result__c>();
    list<AF_Sub_Result__c>  bonusThrehsoldList= new list<AF_Sub_Result__c>();
        if(Trigger.isUpdate)
        {
            // validationOnAmounts Trigger Logic Starts
            for(AF_Sub_Result__c subResultInstance : (List<AF_Sub_Result__c>)trigger.new)
            {
                status.put(subResultInstance.AF_Bonus_Threshold__c,subResultInstance.AF_Status__c);
                Lock.put(subResultInstance.AF_Bonus_Threshold__c,subResultInstance.AF_Locked__c);
                BonusThresholdId.add(subResultInstance.AF_Bonus_Threshold__c);
                if(subResultInstance.AF_Period__c == null){
                    BonusAnnualSubResult.add(subResultInstance.AF_Bonus_Threshold__c);
                }
                if(subResultInstance.AF_Period__c != null){
                    BonusQuarterlySubResultMap.put(subResultInstance.AF_Bonus_Threshold__c,subResultInstance.AF_Period__c);
                    BonusQuarterlySubResult.add(subResultInstance.AF_Bonus_Threshold__c);
                    QuaterSet.add(subResultInstance.AF_Period__c);
                }
            }   
            // validationOnAmounts Trigger Logic Ends
        }
        if(Trigger.isUpdate || Trigger.isInsert){
            for(AF_Sub_Result__c subResultInstance : (List<AF_Sub_Result__c>)trigger.new){
                if(subResultInstance.AF_Bonus_Threshold__c!=null ){
                    bonusthreshold.add(subResultInstance.AF_Bonus_Threshold__c);
                }
                SubresultTriggerNew.add(subResultInstance);
            }
        }
        if(Trigger.isInsert){
            bonusThrehsoldList = [select AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Year__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN:bonusthreshold];
            if(bonusThrehsoldList.size()>0){
                for(AF_Sub_Result__c subBonusRes:bonusThrehsoldList){
                    AgencyName.add(subBonusRes.AF_Bonus_Threshold__r.Agency_Name__c);
                    BrandName.add(subBonusRes.AF_Bonus_Threshold__r.Brand_Name__c);
                    year.add(subBonusRes.AF_Bonus_Threshold__r.Year__c);
                }
            }
        }
    }
    /********************************************************************************************
*  @Description: This method is called iteratively for each record to be inserted during a BEFORE
*                trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
*  @name : beforeInsert
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void beforeInsert(SObject so)
    {
        AF_Sub_Result__c subResultInstance = (AF_Sub_Result__c)so;
        validateSubResult(subResultInstance);
    }
    /********************************************************************************************
*  @Description: This method is called iteratively for each record to be updated during a BEFORE
*                trigger
*  @name : beforeUpdate
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        AF_Sub_Result__c subResultInstance = (AF_Sub_Result__c)so;
        // AF_PreventQual Trigger Logic Starts
        validateSubResult(subResultInstance);       
        // AF_PreventQual Trigger Logic Ends
    }
    /********************************************************************************************
*  @Description: This method is called iteratively for each record to be deleted during a BEFORE
*                trigger
*  @name : beforeDelete
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void beforeDelete(SObject so)
    {
    list<AF_Sub_Result__c> triggerOldSubResult = new list<AF_Sub_Result__c>();
        AF_Sub_Result__c SubResultInstance = (AF_Sub_Result__c)so;
        BonusThershold.add(SubResultInstance.AF_Bonus_Threshold__c);
        quarter.add(SubResultInstance.AF_Period__c);
        Uniquekey.add(SubResultInstance.AF_Unique_Key__c);
        triggerOldSubResult.add(SubResultInstance);
    }
    /********************************************************************************************
*  @Description: This method is called iteratively for each record inserted during an AFTER
*                trigger. Always put field validation in the 'After' methods in case another trigger
*                 has modified any values. The record is 'read only' by this point.
*  @name : afterInsert
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void afterInsert(SObject so)
    {
        AF_Sub_Result__c SubResultInstance = (AF_Sub_Result__c)so;
        newTriggerList.add(SubResultInstance);
    }
    /********************************************************************************************
*  @Description: This method is called iteratively for each record updated during an AFTER
*                trigger.
*  @name : afterUpdate
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void afterUpdate(SObject oldSo, SObject so)
    {
        AF_Sub_Result__c SubResultInstance = (AF_Sub_Result__c)so;
        newTriggerList.add(SubResultInstance);
    }
    /********************************************************************************************
*  @Description: This method is called iteratively for each record deleted during an AFTER
*                trigger.
*  @name : afterDelete
*  @param : none
*  @return: boolean.
*************************************************************************************/
    public void afterDelete(SObject so)
    {
        //derived as a part of trigger factory
    }
    /**********************************************************************
*  @Description: this method is used to query the records from subresult
*   @            and calculates the total and populates for each quarter 
*  @name : andFinally
*  @param : none
*  @return: none.
**********************************************************************/
    public void andFinally()
    {   
    List<AF_Sub_Result__c> queryListofSubResult= new List<AF_Sub_Result__c>();
        if(!BonusThresholdId.isEmpty()){
            try{
                queryListofSubResult = [select AF_Bonusable_Fees__c,AF_Bonus_Threshold__c,AF_Total_Bonus_Value__c,AF_Qual_Bonus_Value__c,AF_Quant_Bonus_Value__c,AF_Period__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :BonusThresholdId];
                if(!queryListofSubResult.isEmpty()){
                    if(Trigger.isUpdate && Trigger.isAfter)
                    {
                        AF_subResult_Helper.subResultCalc(queryListofSubResult,status,Lock,BonusAnnualSubResult,QuaterSet,BonusQuarterlySubResult);
                        AF_subResult_Helper.subResultMap(BonusQuarterlySubResultMap);
                    }
                }
            }
            catch(Exception e)
            {
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'andFinally',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                system.debug(e);
            }
        }
        if(Trigger.isDelete){
            andFinallyDeleteExt();
        }   
        if(Trigger.isUpdate && Trigger.isAfter){
            andFinallyUpdateExt();
        }
        if(Trigger.isInsert && Trigger.isAfter){
            andFinallyInsertExt();
        }
    }
    public void andFinallyDeleteExt(){
    Integer countQ1=0;
    Integer countQ2=0;
    Integer countQ3=0;
    list<AF_Sub_Result__c> SubResult=new list<AF_Sub_Result__c>();
    list<AF_Sub_Result__c> UpdateSubResult = new list<AF_Sub_Result__c>();
        try{
                BonusList=[select id , AF_Bonus_Thresholds__c, AF_Qual_Bonus_Value__c, AF_Period__c,AF_Bonusable_Fees__c, AF_Quant_Bonus_Value__c from AF_Bonus_Results__c where AF_Bonus_Thresholds__c IN:BonusThershold and RecordTypeId = : Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Quarterly').getRecordTypeId() and AF_Period__c IN:quarter];
                SubResult=[select id, AF_Bonus_Threshold__c,AF_Bonusable_Fees__c, AF_Result_type__c,  AF_Qual_Bonus_Value__c, AF_Period__c, AF_Unique_Key__c, AF_deletion_key__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN:BonusThershold and AF_Unique_Key__c IN:Uniquekey and AF_Result_type__c=:AF_Constants.RESULT_TYPE_QUARTERLY and AF_Status__c=:AF_Constants.STATUS_DRAFT];
                for(AF_Sub_Result__c s:SubResult){
                    if(s.AF_Period__c==AF_Constants.QUARTER1){
                        countQ1++;
                    }
                    else if(s.AF_Period__c==AF_Constants.QUARTER2){
                        countQ2++;
                    }
                    else if(s.AF_Period__c==AF_Constants.QUARTER3){
                        countQ3++;
                    }
                }
                if(!BonusList.isEmpty() && !SubResult.isEmpty()){
                    for(AF_Sub_Result__c Sub:SubResult){
                        for(AF_Bonus_Results__c Bonus:BonusList){
                            if(countQ1==2 && Sub.AF_Period__c==AF_Constants.QUARTER1 && Sub.AF_Period__c==Bonus.AF_Period__c){
                                Sub.AF_Bonusable_Fees__c=Bonus.AF_Bonusable_Fees__c;
                                UpdateSubResult.add(Sub);
                            }
                            else if(countQ2==2 && Sub.AF_Period__c==AF_Constants.QUARTER2 && Sub.AF_Period__c==Bonus.AF_Period__c){
                                Sub.AF_Bonusable_Fees__c=Bonus.AF_Bonusable_Fees__c;
                                UpdateSubResult.add(Sub);
                            }
                            else if(countQ3==2 && Sub.AF_Period__c==AF_Constants.QUARTER3 && Sub.AF_Period__c==Bonus.AF_Period__c){
                                Sub.AF_Bonusable_Fees__c=Bonus.AF_Bonusable_Fees__c;
                                UpdateSubResult.add(Sub);
                            }
                        }       
                    }
                }
                if(!UpdateSubResult.isEmpty()){
                    update UpdateSubResult;
                }
                andFinallyBonusListUpdate();
                
            }
            catch(Exception e)
            {
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'andFinally',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
            }
    }
    public void andFinallyBonusListUpdate(){
    list<AF_Bonus_Results__c> UpdateBonus =new list<AF_Bonus_Results__c>();
        for(AF_Bonus_Results__c  Bonus:BonusList){
                    for(AF_Sub_Result__c Sub:(List<AF_Sub_Result__c>)trigger.old){
                        if(Sub.AF_Period__c!=null){
                            Decimal Amt=0;
                            if(Sub.AF_Period__c==AF_Constants.QUARTER1 && Bonus.AF_Period__c==AF_Constants.QUARTER1){
                                if(Bonus.AF_Quant_Bonus_Value__c!=null && Sub.AF_Quant_Bonus_Value__c!=null){
                                    Amt = Bonus.AF_Quant_Bonus_Value__c-Sub.AF_Quant_Bonus_Value__c;
                                    Bonus.AF_Quant_Bonus_Value__c = Amt;
                                    UpdateBonus.add(Bonus);
                                }
                            }
                            else if(Sub.AF_Period__c==AF_Constants.QUARTER2 && Bonus.AF_Period__c==AF_Constants.QUARTER2){
                                if(Bonus.AF_Quant_Bonus_Value__c!=null && Sub.AF_Quant_Bonus_Value__c!=null){
                                    Amt=Bonus.AF_Quant_Bonus_Value__c-Sub.AF_Quant_Bonus_Value__c;
                                    Bonus.AF_Quant_Bonus_Value__c = Amt;
                                    UpdateBonus.add(Bonus);
                                }
                            }
                            else if(Sub.AF_Period__c==AF_Constants.QUARTER3 && Bonus.AF_Period__c==AF_Constants.QUARTER3){
                                if(Bonus.AF_Quant_Bonus_Value__c!=null && Sub.AF_Quant_Bonus_Value__c!=null){
                                    Amt=Bonus.AF_Quant_Bonus_Value__c-Sub.AF_Quant_Bonus_Value__c;
                                    Bonus.AF_Quant_Bonus_Value__c = Amt;
                                    UpdateBonus.add(Bonus);
                                }
                            }
                        }
                    }
                }
                if(!UpdateBonus.isEmpty()){
                    try{
                    update UpdateBonus;
                    }
                    catch(Exception e)
                        {
                            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'andFinallyBonusListUpdate',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
                        }
                }
    }
    public void andFinallyUpdateExt(){
        if(AF_CheckRecursiveBonusQuarterly.run){
                AF_CheckRecursiveBonusQuarterly.run=false;
                if(newTriggerList.size()>0){
                    if(bonusthreshold != null && !bonusthreshold.isempty() ){
                        SubBonusQuarterlyList=[select id,AF_Minimum__c,AF_Outstanding__c, AF_Stretching__c,AF_country__c,AF_Traditional__c,AF_Digital__c,Bonus_Measure__c,AF_deletion_key__c,AF_Bonus_Threshold__c,Sub_Result_AnnualID__c from AF_Sub_Result__c where (AF_Period__c=:AF_Constants.QUARTER1 or AF_Period__c=:AF_Constants.QUARTER2 or AF_Period__c=:AF_Constants.QUARTER3) and AF_Status__c=:AF_Constants.STATUS_DRAFT and AF_Bonus_Threshold__c IN:bonusthreshold ];
                        if(SubBonusQuarterlyList.size()>0){
                            for(AF_Sub_Result__c subnew: SubBonusQuarterlyList){
                                for(AF_Sub_Result__c s:newTriggerList){
                                    if(subnew.Sub_Result_AnnualID__c==s.Id && subnew.Sub_Result_AnnualID__c!=null){                  
                                        subnew.AF_Minimum__c=s.AF_Minimum__c;
                                        subnew.AF_Outstanding__c=s.AF_Outstanding__c;
                                        subnew.AF_Stretching__c=s.AF_Stretching__c;
                                        subnew.AF_country__c=s.AF_country__c;
                                        subnew.Bonus_Measure__c=s.Bonus_Measure__c;
                                        subnew.AF_Traditional__c=s.AF_Traditional__c;
                                        subnew.AF_Digital__c=s.AF_Digital__c;
                                        Subresultupdate.add(subnew);
                                    }
                                    else if((subnew.AF_deletion_key__c==s.AF_deletion_key__c) && s.AF_Period__c==null){
                                        subnew.AF_Minimum__c=s.AF_Minimum__c;
                                        subnew.AF_Outstanding__c=s.AF_Outstanding__c;
                                        subnew.AF_Stretching__c=s.AF_Stretching__c;
                                        subnew.AF_country__c=s.AF_country__c;
                                        subnew.Bonus_Measure__c=s.Bonus_Measure__c;
                                        subnew.AF_Traditional__c=s.AF_Traditional__c;
                                        subnew.AF_Digital__c=s.AF_Digital__c;
                                        subnew.Sub_Result_AnnualID__c = s.Id;
                                        Subresultupdate.add(subnew);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if(Subresultupdate != null && !Subresultupdate.isEmpty()){
                try{
                    update Subresultupdate;
                }catch(exception e){
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'andFinallyUpdateExt',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                }
            }
    }
    public void andFinallyInsertExt(){
    list<AF_Sub_Result__c>  subresultinsert=new list<AF_Sub_Result__c>();
        if(AF_CheckRecursiveBonusQuarterly.run){
                AF_CheckRecursiveBonusQuarterly.run=false;
                if(newTriggerList.size()>0){
                    Set<String> QuarterInfo = new Set<String>();
                    SubBonusQuarterlyList=[select id,AF_Minimum__c,AF_Outstanding__c, AF_Stretching__c,AF_country__c,AF_Traditional__c,AF_Digital__c,Bonus_Measure__c,AF_deletion_key__c,AF_Bonus_Threshold__c,Sub_Result_AnnualID__c,AF_Period__c from AF_Sub_Result__c where (AF_Period__c=:AF_Constants.QUARTER1 or AF_Period__c=:AF_Constants.QUARTER2 or AF_Period__c=:AF_Constants.QUARTER3) and AF_Status__c=:AF_Constants.STATUS_DRAFT and AF_Bonus_Threshold__r.Agency_Name__c IN:AgencyName and AF_Bonus_Threshold__r.Brand_Name__c IN:BrandName and AF_Bonus_Threshold__r.Year__c IN:year and AF_Class_code__c=false];
                    if(SubBonusQuarterlyList.size()>0){
                        for(AF_Sub_Result__c s:SubBonusQuarterlyList){
                            QuarterInfo.add(s.AF_Period__c);
                        }
                    }
                    if(SubBonusQuarterlyList.size()>0){
                        for(String subnew: QuarterInfo){
                            for(AF_Sub_Result__c s:newTriggerList){
                                AF_Sub_Result__c subQuartSingleRecord=new AF_Sub_Result__c();
                                if(subnew==AF_Constants.QUARTER1){
                                    subQuartSingleRecord.AF_Period__c = AF_Constants.QUARTER1;
                                }
                                else if(subnew==AF_Constants.QUARTER2){
                                    subQuartSingleRecord.AF_Period__c = AF_Constants.QUARTER2;
                                }
                                else if(subnew==AF_Constants.QUARTER3){
                                    subQuartSingleRecord.AF_Period__c = AF_Constants.QUARTER3;
                                }
                                subQuartSingleRecord.AF_Minimum__c=s.AF_Minimum__c;
                                subQuartSingleRecord.AF_Outstanding__c=s.AF_Outstanding__c;
                                subQuartSingleRecord.AF_Stretching__c=s.AF_Stretching__c;
                                subQuartSingleRecord.AF_country__c=s.AF_country__c;
                                subQuartSingleRecord.Bonus_Measure__c=s.Bonus_Measure__c;
                                subQuartSingleRecord.AF_Traditional__c=s.AF_Traditional__c;
                                subQuartSingleRecord.AF_Digital__c=s.AF_Digital__c;
                                subQuartSingleRecord.AF_Bonus_Threshold__c = s.AF_Bonus_Threshold__c;
                                subQuartSingleRecord.Af_status__c = AF_Constants.STATUS_DRAFT;
                                subQuartSingleRecord.Sub_Result_AnnualID__c=s.Id;
                                subresultinsert.add(subQuartSingleRecord);
                            }
                        }
                    }
                }
            }
            if(subresultinsert.size()>0){
                try{
                    upsert subresultinsert;
                }catch(exception e){
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'andFinallyInsertExt',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
                }
            }
    }
    public void validateSubResult(AF_Sub_Result__c subResultInstance)
    {
        if(subResultInstance.AF_Minimum__c==0)
        { 
            if(subResultInstance.AF_Stretching__c!=0 && subResultInstance.AF_Outstanding__c!=0){
                if((subResultInstance.AF_Minimum__c >= subResultInstance.AF_Stretching__c || subResultInstance.AF_Minimum__c >= subResultInstance.AF_Outstanding__c ))
                {
                    subResultInstance.addError(AF_Constants.EXCEPTION_MSG_SUBRESULT);
                }
                else if((subResultInstance.AF_Stretching__c  >= subResultInstance.AF_Outstanding__c || subResultInstance.AF_Stretching__c <=subResultInstance.AF_Minimum__c ))
                {
                    subResultInstance.addError(AF_Constants.EXCEPTION_MSG_SUBRESULT);
                }
                else if((subResultInstance.AF_Outstanding__c  <= subResultInstance.AF_Minimum__c || subResultInstance.AF_Outstanding__c <=subResultInstance.AF_Stretching__c ))
                {
                    subResultInstance.addError(AF_Constants.EXCEPTION_MSG_SUBRESULT);
                }
            }
        }
        else if(subResultInstance.AF_Minimum__c!=0)
        {
            if((subResultInstance.AF_Minimum__c >= subResultInstance.AF_Stretching__c || subResultInstance.AF_Minimum__c >= subResultInstance.AF_Outstanding__c ))
            {
                subResultInstance.addError(AF_Constants.EXCEPTION_MSG_SUBRESULT);
            }
            else if((subResultInstance.AF_Stretching__c  >= subResultInstance.AF_Outstanding__c || subResultInstance.AF_Stretching__c <=subResultInstance.AF_Minimum__c ))
            {
                subResultInstance.addError(AF_Constants.EXCEPTION_MSG_SUBRESULT);
            }
            else if((subResultInstance.AF_Outstanding__c  <= subResultInstance.AF_Minimum__c || subResultInstance.AF_Outstanding__c <=subResultInstance.AF_Stretching__c ))
            {
                subResultInstance.addError(AF_Constants.EXCEPTION_MSG_SUBRESULT);
            }
        }
    }
}