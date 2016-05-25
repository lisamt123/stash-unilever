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

    public List<DataChargeType_Wraper> dataWrapperList;
    public List<CallsChargeType_Wraper> callsWrapperList;
    public List<MessagingChargeType_Wraper> messageWrapperList;
    public List<IpassChargeType_Wraper> ipassWrapperList;
    public List<NonUsageChargeType_Wrapper> nonusageWrapperList;
    public MB_Device_Wrapper_Class objdeviceWrapper;
   /*******************************************************************************************************
    * @description This class  contains fields for  user spend with particular device.
    * @param  month
    * @return Wrapper
    */
    
    public class MB_Device_Wrapper_Class{
    
     @AuraEnabled
     public string userName;
     
     @AuraEnabled
     public string deviceName;
     
     @AuraEnabled
     public string deviceId;
     
     @AuraEnabled
     public string deviceImageUrl;
     
     @AuraEnabled
     public string userCurrency;
     
     @AuraEnabled
     public decimal totaldeviceUsage;
     
     @AuraEnabled
     public decimal totalUsage;
     
     @AuraEnabled
     public decimal totalDomesticCallUsage;
     
     @AuraEnabled
     public decimal totalInternationalCallUsage;
     
     @AuraEnabled
     public decimal totalDomesticSMSUsage;
     
     @AuraEnabled
     public decimal totalInternationalSMSUsage;
     
     @AuraEnabled
     public decimal totalDomesticDataUsage;
     
     @AuraEnabled
     public decimal totalInternationalDataUsage;
     
     @AuraEnabled
     public decimal totalDomesticIpassUsage;
     
     @AuraEnabled
     public decimal totalInternationalIpassUsage;
     
     @AuraEnabled
     public decimal totalDataUsage;
     
     @AuraEnabled
     public decimal totalCallUsage;
     
     @AuraEnabled
     public decimal totalMessageUsage;
     
     @AuraEnabled
     public decimal totalIpassUsage;
     
     @AuraEnabled
     public decimal totalnonUsage;
     
     @AuraEnabled
     public decimal totalAverageDataUsage;
     
     @AuraEnabled
     public decimal totalAverageCallUsage;
     
     @AuraEnabled
     public decimal totalAverageMessageUsage;
     
     @AuraEnabled
     public decimal totalAverageIpassUsage;
     
     @AuraEnabled
     public boolean dataVariance;
     
     @AuraEnabled
     public boolean callVariance;
     
     @AuraEnabled
     public boolean smsVariance;
     
     @AuraEnabled
     public boolean ipassVariance ;
    }
    
     public class DataChargeType_Wraper{
     
     @AuraEnabled
     public string chargeTypeName;
     
     @AuraEnabled
     public decimal totalSpend;
    }
    
    public class CallsChargeType_Wraper{
     
     @AuraEnabled
     public string chargeTypeName;
     
     @AuraEnabled
     public decimal totalSpend;
    }
    
    public class MessagingChargeType_Wraper{
     
     @AuraEnabled
     public string chargeTypeName;
     
     @AuraEnabled
     public decimal totalSpend;
    }
    
    public class NonUsageChargeType_Wrapper{
     
     @AuraEnabled
     public string chargeTypeName;
     
     @AuraEnabled
     public decimal totalSpend;
    }
    
     public class IpassChargeType_Wraper{
     
     @AuraEnabled
     public string chargeTypeName;
     
     @AuraEnabled
     public decimal totalSpend;
  
    }
    
 }