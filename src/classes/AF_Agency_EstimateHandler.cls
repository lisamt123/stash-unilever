/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Agency_EstimateHandler
@CreateDate : 21/8/2014
@Description : This is a controller class for trigger's 
@               
@Version : 1.0
@reference : none
***********************************************************************************/
public with sharing class AF_Agency_EstimateHandler implements ITrigger{
  Set<String> agencyEstimateUnique = new Set<String>();
  Set<Id> Brand = new Set<Id>();
  Set<Id> Agency = new Set<Id>();
  Set<String> Year = new Set<String>();
  Set<String> Country = new Set<String>();
  Set<id> AgencyEstids=new set<id>();
  Boolean deletePOReport=false;
  Integer trigger_count=0;
  List<AF_Agency_Estimate__c> agencyEstimateRecords = new List<AF_Agency_Estimate__c>();
  List<AF_Agency_Estimate__c> agencyEstimatesRecords = new List<AF_Agency_Estimate__c>();
  map<String,map<String,Decimal>> countryTradDigitalMap = new map<String,map<String,Decimal>>();
  private static string className_STR=AF_Agency_EstimateHandler.class.getName();
  Set<Id> AgencyestimateId=new Set<Id>();
  public void bulkBefore()
  {
    list<AF_Agency_Estimate__c> AgencyEstimatelist = new list<AF_Agency_Estimate__c>();
    Set<string> Compoundkey =new Set<string> ();
    boolean errordisplay=false; 
    Set<String> quarter = new Set<String>(); 
    List<String> quarterList = new List<String>(); 
    String quarterInfo=''; 
    String brandEstimateName='';    
    if(Trigger.isDelete){
      for(AF_Agency_Estimate__c AgencyEst:(List<AF_Agency_Estimate__c>)trigger.old){
        if(AgencyEst.AF_Compound_Key__c!=null && AgencyEst.id!=null){
          AgencyestimateId.add(AgencyEst.Id);
          Compoundkey.add(AgencyEst.AF_Compound_Key__c);
          quarter.add(AgencyEst.AF_Mean_Quarter__c);
        }
      }
      quarterList.addAll(quarter);
      if(quarterList.size()>0){
        quarterInfo = quarterList[0];
      }
      AgencyEstimatelist =[select id, Name, AF_Adaptation__c, AF_Digital__c,Brand__c,Agency_Account_Id__c, AF_Agency_Entity__c, AF_Unilever_Entity__c, AF_Compound_Key__c, AF_Traditional__c,AF_Brand_Estimate__r.Name from AF_Agency_Estimate__c WHERE id NOT IN:AgencyestimateId and AF_Compound_Key__c IN:Compoundkey ]; 
      for(AF_Agency_Estimate__c  Agencylist:AgencyEstimatelist){
        brandEstimateName = Agencylist.AF_Brand_Estimate__r.Name;
        if(brandEstimateName.contains(quarterInfo) && (Agencylist.AF_Digital__c>0 || Agencylist.AF_Adaptation__c>0 ||  Agencylist.AF_Traditional__c>0 )){
          errordisplay=true;
        }
        brandEstimateName='';
      }
      for(AF_Agency_Estimate__c AgencyEstimateOldtrigger :(List<AF_Agency_Estimate__c>)trigger.old){
        If(errordisplay)
        AgencyEstimateOldtrigger.adderror(Label.AF_Check_Base_Fees);
      } 
    }
  }
  public void bulkAfter()
  {
    /*Method is Blank as this handler doesnot handle any bulkAfter*/
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
    AF_Agency_Estimate__c agencyInstance = (AF_Agency_Estimate__c)so;
    // AF_UpdateAgencyEstimate Trigger Logic Starts
    agencyEstimatesRecords.add(agencyInstance);
    // AF_UpdateAgencyEstimate Trigger Logic Ends
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
    AF_Agency_Estimate__c agencyInstance = (AF_Agency_Estimate__c)so;
    AF_Agency_Estimate__c oldAgencyInstance = (AF_Agency_Estimate__c)oldSo;
    // AF_UpdateAgencyEstimate Trigger Logic Starts
    if(agencyInstance.AF_Status__c==AF_Constants.BASE_FEES_READYFORPO && oldAgencyInstance.AF_Status__c==AF_Constants.BASE_FEES_READYFORPO){
      trigger_count++;
    }
    else{
      agencyEstimatesRecords.add(agencyInstance);
    }
    // AF_UpdateAgencyEstimate Trigger Logic Ends
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
    AF_Agency_Estimate__c agencyInstance = (AF_Agency_Estimate__c)so;
    // AF_Agency_POReport Trigger Logic Starts
    AgencyEstids.add(agencyInstance.Id);
    deletePOReport = true;
    // AF_Agency_POReport Trigger Logic Ends
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
    AF_Agency_Estimate__c agencyInstance = (AF_Agency_Estimate__c)so;
    // AF_Agency_POReport Trigger Logic Starts
    AgencyEstids.add(agencyInstance.Id);
    // AF_Agency_POReport Trigger Logic Ends
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
    AF_Agency_Estimate__c AgencyEstimateInstance = (AF_Agency_Estimate__c)so;
    AF_Agency_Estimate__c oldAgencyEstimateInstance = (AF_Agency_Estimate__c)oldSo;
    if(AgencyEstimateInstance.AF_BrandEstimate_Active__c && (AgencyEstimateInstance.AF_Traditional__c!= oldAgencyEstimateInstance.AF_Traditional__c || AgencyEstimateInstance.AF_Digital__c!= oldAgencyEstimateInstance.AF_Digital__c))
    {
      agencyEstimateUnique.add(AgencyEstimateInstance.AF_Bonus_Agency_Formula__c);
      Agency.add(AgencyEstimateInstance.AF_AgencyEntityId__c);
      Brand.add(AgencyEstimateInstance.AF_BrandIdunique__c);
      Country.add(AgencyEstimateInstance.AF_UnileverCountryName__c);
      Year.add(AgencyEstimateInstance.AF_Fiscal_Year__c);
    }
    // AF_Agency_POReport Trigger Logic Starts
    AgencyEstids.add(AgencyEstimateInstance.Id);
    // AF_Agency_POReport Trigger Logic Ends
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
  /***********************************************************************************
*  @Description: this method is used to check the values in the agency estiamte records
*  @             are picking from the home page, updates the sub result when the values  
*  @             in digital,traditional are updated
*  @name : andFinally
*  @param : none.
*  @return: none.
*************************************************************************************/
  public void andFinally()
  {   
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
      if(!agencyEstimatesRecords.isEmpty() && !AF_brandEstimatehandlerHelper.testvar){
        AF_UpdateAgencyEstimatesValues2.UpdateExchageRates(agencyEstimatesRecords);
      }
    }
    if(!AgencyEstids.isEmpty() && !system.isBatch()){
      AF_GetBaseFeePOData.CreatePOReportFromAgencyEstimate(AgencyEstids,deletePOReport);
    }
    else if(!AgencyEstids.isEmpty() && system.isBatch()){
      AF_GetBaseFeePOData.BatchcreatePOReportFromAgencyEstimate(AgencyEstids,deletePOReport);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
      try{
        finallyAgencyEst(); 
        finallySubResultList();
      }
      catch(Exception e){
        AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'andFinally',e.getMessage(),e.getTypeName(),e.getStackTraceString());
      }
    }
  }
  /***********************************************************************************
*  @Description: this method is used to check the values in the agency estiamte records
*  @             are picking from the home page,when the values  
*  @             in digital,traditional are updated
*  @name : finallyAgencyEst
*  @param : none.
*  @return: none.
*************************************************************************************/
  public void finallyAgencyEst(){
  map<String,Decimal> tradDigitaltotals = new map<String,Decimal>();
  Decimal TraditionalTotal = 0.0;
  Decimal DigitalTotal = 0.0;
  Decimal Total=0.0;
  Decimal TradAmount =0.0;
  Decimal DigitalAmount =0.0;
    Decimal TDTotal =0.0;
    agencyEstimateRecords = [select AF_Traditional__c,AF_Digital__c,AF_Bonus_Agency_Formula__c from AF_Agency_Estimate__c where AF_Bonus_Agency_Formula__c IN:agencyEstimateUnique and AF_BrandEstimate_Active__c=true];
    if(!agencyEstimateRecords.isEmpty()){
      for(AF_Agency_Estimate__c a:agencyEstimateRecords){
        if(!countryTradDigitalMap.containsKey(a.AF_Bonus_Agency_Formula__c)){
          TraditionalTotal =0.0;
          DigitalTotal = 0.0;
          TraditionalTotal = TraditionalTotal + a.AF_Traditional__c;
          DigitalTotal = DigitalTotal + a.AF_Digital__c;
          Total = TraditionalTotal + DigitalTotal;
          tradDigitaltotals.put(AF_Constants.TRADITIONAL,TraditionalTotal);
          tradDigitaltotals.put(AF_Constants.DIGITAL,DigitalTotal);
          tradDigitaltotals.put(AF_Constants.TRADITIONAL_DIGITAL,Total);
          countryTradDigitalMap.put(a.AF_Bonus_Agency_Formula__c,tradDigitaltotals);
        }
        else{
          TradAmount = tradDigitaltotals.get(AF_Constants.TRADITIONAL);
          DigitalAmount = tradDigitaltotals.get(AF_Constants.DIGITAL);
          TDTotal = tradDigitaltotals.get(AF_Constants.TRADITIONAL_DIGITAL);
          TradAmount = TradAmount + a.AF_Traditional__c;
          DigitalAmount = DigitalAmount + a.AF_Digital__c;
          TDTotal = TradAmount + DigitalAmount;
          tradDigitaltotals.put(AF_Constants.TRADITIONAL,TradAmount);
          tradDigitaltotals.put(AF_Constants.DIGITAL,DigitalAmount);
          tradDigitaltotals.put(AF_Constants.TRADITIONAL_DIGITAL,TDTotal);
          countryTradDigitalMap.put(a.AF_Bonus_Agency_Formula__c,tradDigitaltotals);
        }
      }
    }
  }
  /***********************************************************************************
*  @Description: this method is used to check the values in the agency estiamte records
*  @             updates the sub result when the values  
*  @             in digital,traditional are updated
*  @name : finallySubResultList
*  @param : none.
*  @return: none.
*************************************************************************************/
  public void finallySubResultList(){
    List<AF_Sub_Result__c> subResultRecords = new List<AF_Sub_Result__c>();
    subResultRecords = [select AF_Traditional__c,AF_Digital__c,AF_Bonusable_Fees__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Country_Name__c,AF_Bonus_Threshold__r.Year__c from AF_Sub_Result__c where AF_Bonus_Threshold__r.Agency_Name__c IN:Agency 
    and AF_Bonus_Threshold__r.Brand_Name__c IN:Brand and AF_Bonus_Threshold__r.Country_Name__c IN:Country and AF_Bonus_Threshold__r.Year__c IN:Year and AF_Locked__c=false and AF_Period__c!=null];
    if(!subResultRecords.isEmpty()){
      Decimal TDBonusableFees=0.0;
      Decimal TBonusableFees=0.0;
      Decimal DBonusableFees=0.0;
      List<AF_Sub_Result__c> updatedSubResult = new List<AF_Sub_Result__c>();
      for(AF_Sub_Result__c sub:subResultRecords){
        String Uniquekey='';
        Uniquekey = sub.AF_Bonus_Threshold__r.Agency_Name__c+'::'+sub.AF_Bonus_Threshold__r.Brand_Name__c+'::'+sub.AF_Bonus_Threshold__r.Country_Name__c+'::'+sub.AF_Bonus_Threshold__r.Year__c;
        if(sub.AF_Traditional__c && sub.AF_Digital__c){
          TDBonusableFees = countryTradDigitalMap.get(Uniquekey).get(AF_Constants.TRADITIONAL_DIGITAL);
          sub.AF_Bonusable_Fees__c = TDBonusableFees;
        }
        else if(sub.AF_Traditional__c){
          TBonusableFees =countryTradDigitalMap.get(Uniquekey).get(AF_Constants.TRADITIONAL);
          sub.AF_Bonusable_Fees__c = TBonusableFees;
        }
        else if(sub.AF_Digital__c){
          DBonusableFees = countryTradDigitalMap.get(Uniquekey).get(AF_Constants.DIGITAL);
          sub.AF_Bonusable_Fees__c = DBonusableFees;
        }
        updatedSubResult.add(sub);
      }
      if(!updatedSubResult.isEmpty()){
        try{
        update updatedSubResult;
        }
        catch(Exception e)
            {
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'finallySubResultList',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
            }
      }
    }
  }
}