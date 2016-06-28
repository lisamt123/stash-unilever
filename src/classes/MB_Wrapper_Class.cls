/***************************************************************
Class Name: MB_Wrapper_Class.cls
Copyright © 2016 Salesforce

Purpose:
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Wrapper class For TEM app.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       12/05/2016        Wrapper class For TEM app
***************************************************************/


public class MB_Wrapper_Class{
   
    @AuraEnabled
    public List<DataChargeType_Wraper> dataWrapperList{get;set;}
    @AuraEnabled
    public List<CallsChargeType_Wraper> callsWrapperList{get;set;}
    @AuraEnabled
    public List<MessagingChargeType_Wraper> messageWrapperList{get;set;}
    @AuraEnabled
    public List<IpassChargeType_Wraper> ipassWrapperList{get;set;}
    @AuraEnabled
    public List<NonUsageChargeType_Wrapper> nonusageWrapperList{get;set;}
    @AuraEnabled
    public MB_Device_Wrapper_Class objdeviceWrapper{get;set;}
   /*******************************************************************************************************
    * @description This class  contains fields for  user spend with particular device.
    * @param  month
    * @return Wrapper
    */
    
    public class MB_Device_Wrapper_Class{
    
     @AuraEnabled
     public string userName{get;set;}
     
     @AuraEnabled
     public string deviceName{get;set;}
     
     @AuraEnabled
     public string deviceId{get;set;}
     
     @AuraEnabled
     public string deviceImageUrl{get;set;}
     
     @AuraEnabled
     public string userCurrency{get;set;}
     
     @AuraEnabled
     public decimal totaldeviceUsage{get;set;}
     
     @AuraEnabled
     public decimal totalUsage{get;set;}
     
     @AuraEnabled
     public decimal totalDomesticCallUsage{get;set;}
     
     @AuraEnabled
     public decimal totalInternationalCallUsage{get;set;}
     
     @AuraEnabled
     public decimal totalDomesticSMSUsage{get;set;}
     
     @AuraEnabled
     public decimal totalInternationalSMSUsage{get;set;}
     
     @AuraEnabled
     public decimal totalDomesticDataUsage{get;set;}
     
     @AuraEnabled
     public decimal totalInternationalDataUsage{get;set;}
     
     @AuraEnabled
     public decimal totalDomesticIpassUsage{get;set;}
     
     @AuraEnabled
     public decimal totalInternationalIpassUsage{get;set;}
     
     @AuraEnabled
     public decimal totalDataUsage{get;set;}
     
     @AuraEnabled
     public decimal totalCallUsage{get;set;}
     
     @AuraEnabled
     public String totalCallUsagePattern{get;set;}
     
     @AuraEnabled
     public decimal totalMessageUsage{get;set;}
     
     @AuraEnabled
     public decimal totalIpassUsage{get;set;}
     
     @AuraEnabled
     public decimal totalnonUsage{get;set;}
     
     @AuraEnabled
     public decimal totalAverageDataUsage{get;set;}
     
     @AuraEnabled
     public decimal totalAverageCallUsage{get;set;}
     
     @AuraEnabled
     public decimal totalAverageMessageUsage{get;set;}
     
     @AuraEnabled
     public decimal totalAverageIpassUsage{get;set;}
     
     @AuraEnabled
     public decimal totalDataUsageIn{get;set;}
     
     @AuraEnabled
     public decimal totalCallUsageIn{get;set;}
     
     @AuraEnabled
     public decimal totalMessageUsageIn{get;set;}
     
     @AuraEnabled
     public decimal totalIpassUsageIn{get;set;}
     
     @AuraEnabled
     public decimal totalAverageDataUsageIn{get;set;}
     
     @AuraEnabled
     public decimal totalAverageCallUsageIn{get;set;}
     
     @AuraEnabled
     public decimal totalAverageMessageUsageIn{get;set;}
     
     @AuraEnabled
     public decimal totalAverageIpassUsageIn{get;set;}
     
     @AuraEnabled
     public boolean totalSpendVariance{get;set;}
     
     @AuraEnabled
     public boolean dataVariance{get;set;}
     
     @AuraEnabled
     public boolean callVariance{get;set;}
     
     @AuraEnabled
     public boolean smsVariance{get;set;}
     
     @AuraEnabled
     public boolean ipassVariance{get;set;}
     
     @AuraEnabled
     public boolean nonUsageVariance{get;set;}
    }
    
     public class DataChargeType_Wraper{
     
     @AuraEnabled
     public string chargeTypeName{get;set;}
     
     @AuraEnabled
     public decimal totalSpend{get;set;}
    }
    
    public class CallsChargeType_Wraper{
     
     @AuraEnabled
     public string chargeTypeName{get;set;}
     
     @AuraEnabled
     public decimal totalSpend{get;set;}
    }
    
    public class MessagingChargeType_Wraper{
     
     @AuraEnabled
     public string chargeTypeName{get;set;}
     
     @AuraEnabled
     public decimal totalSpend{get;set;}
    }
    
    public class NonUsageChargeType_Wrapper{
     
     @AuraEnabled
     public string chargeTypeName{get;set;}
  
     @AuraEnabled
     public decimal totalSpend{get;set;}
    }
    
     public class IpassChargeType_Wraper{ 
     
     @AuraEnabled
     public string chargeTypeName{get;set;}
     
     @AuraEnabled
     public decimal totalSpend{get;set;}
  
    }
    public class UsageAmountType_Wraper{ 
     
     @AuraEnabled
     public string chargeTypeName{get;set;}
     
     @AuraEnabled
     public decimal UsageCurrentAmount{get;set;}
     
     @AuraEnabled
     public decimal UsagePreviousAmount{get;set;}
     
     @AuraEnabled
     public decimal UsageChangeAmount{get;set;}
     
     @AuraEnabled
     public Integer UsageVarience{get;set;}
     
     @AuraEnabled
     public Integer VarianceArrow{get;set;}
     
     @AuraEnabled
     public string userCurrency{get;set;}
  
    }
  }