/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Bonus_SummaryHandler
@CreateDate : 24/11/2016
@Description : This is Handler class for AF_Bonus_Summary__c
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_Bonus_SummaryHandler implements ITrigger
{
  private List<AF_Bonus_Summary__c> afBonusSummaryList = new List<AF_Bonus_Summary__c>();
  private List<AF_Bonus_Summary__c> UpdateOopsagencyList = new List<AF_Bonus_Summary__c>();
  
  // Af_AfterInsertBrandEstShare Trigger Logic Ends
  /***********************************************************************************
*  @Description: this method is used to query and update the record based on the user type
*  @             and updates the status field of the record 
*  @name : bulkBefore
*  @param : none
*  @return: none.
*************************************************************************************/
  public void bulkBefore()
  {
    if(Trigger.isUpdate || Trigger.isInsert)
    {
      // UpdateCatFinanceApprover Trigger Logic Starts
      List<AF_Bonus_Summary__c> brandEstimateList = (List<AF_Bonus_Summary__c>)trigger.new;
      for(AF_Bonus_Summary__c bonusSummaryInstance : brandEstimateList)
      {
        //if(bonusSummaryInstance.AF_Status_Base_Fees__c == AF_Constants.BASE_FEES_WITH_AGENCY)
        //{
          afBonusSummaryList.add(bonusSummaryInstance);
          if(bonusSummaryInstance.AF_Agency__c != null)
          {
            UpdateOopsagencyList.add(bonusSummaryInstance);
          }
        //}
      }
      // UpdateCatFinanceApprover Trigger Logic Ends
      
    }      
  }
 
  /***********************************************************************************
*  @Description: this method is derived as a part of trigger factory
*  @             
*  @name : bulkAfter
*  @param : none
*  @return: none.
*************************************************************************************/
  public void bulkAfter()
  {
  }
  /***********************************************************************************
*  @Description: this method is derived as a part of trigger factory
*  @             
*  @name : beforeInsert
*  @param : none
*  @return: none.
*************************************************************************************/
  public void beforeInsert(SObject so)
  {
    /*Method is Blank as this handler doesnot handle any beforeInsert*/
  }
  /***********************************************************************************
*  @Description: this method is derived as a part of trigger factory
*  @             
*  @name : beforeUpdate
*  @param : none
*  @return: none.
*************************************************************************************/
  public void beforeUpdate(SObject oldSo, SObject so)
  {
    /*Method is Blank as this handler doesnot handle any beforeUpdate*/
  }
    /**********************************************************************************************
*  @Description: this method is iteratively for each record to be deleted during a BEFORE trigger
*  @             
*  @name : beforeDelete
*  @param : none
*  @return: none.
*************************************************************************************/
  public void beforeDelete(SObject so)
  {
     /*Method is Blank as this handler doesnot handle any beforeDELETE*/
  }
  /**********************************************************************************************
*  @Description: this method is derived as a part of trigger factory
*  @             
*  @name : afterInsert
*  @param : none
*  @return: none.
*************************************************************************************/
  public void afterInsert(SObject so)
  {
    /*Method is Blank as this handler doesnot handle any afterInsert*/
  }
  /**********************************************************************************************
*  @Description: this method is iteratively for each record updated during an AFTER trigger
*  @             
*  @name : afterUpdate
*  @param : none
*  @return: none.
*************************************************************************************/
  public void afterUpdate(SObject oldSo, SObject so)
  {
    /*Method is Blank as this handler doesnot handle any afterUpdate*/
  }
  
   /**********************************************************************************************
*  @Description: this method is derived as a part of trigger factory
*  @             
*  @name : afterDelete
*  @param : none
*  @return: none.
*************************************************************************************/
  public void afterDelete(SObject so)
  {
    /*Method is Blank as this handler doesnot handle any afterDelete*/
  }
  
  /***************************************************************************************
*  @Description: this method is used to query and update the record in the object, based on
*  @             the parent object action, update,delete will be actioned on childobject
*  @name : andFinally
*  @param : none
*  @return: none.
*************************************************************************************/
  public void andFinally()
  {  
    string  andfinally='andFinally';
    // UpdateCatFinanceApprover Trigger Logic Starts
    if( !UpdateOopsagencyList.isEmpty() )
    {
      AF_UpdateBonusSummaryCatApproverValues.UpdateOopsagencyBulk(UpdateOopsagencyList);
    }
    if( !afBonusSummaryList.isEmpty() )
    {  
      AF_UpdateBonusSummaryCatApproverValues.UpdateBonusSummary(afBonusSummaryList);
    }
    // Af_AfterInsertBrandEstShare Trigger Logic Ends
     
  }
 
}