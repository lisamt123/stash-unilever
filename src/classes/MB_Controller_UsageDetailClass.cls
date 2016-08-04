/***************************************************************
Class Name: MB_Controller_UsageDetailClass.cls
Copyright © 2016 Salesforce

Purpose:
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Controller class For TEM app UsageDetail page.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       31/05/2016        controller class For TEM app UsageDetail page
***************************************************************/

public with sharing class MB_Controller_UsageDetailClass{
  
  @AuraEnabled
  public static Decimal getSpendDetails(string deviceId,string month,string usagetype){
    System.debug('---------'+month+'-------------'+usagetype+'-------'+deviceId);
      List<MB_Billing_Entity__c> billingEntityList;
      if(usagetype==MB_Constants.Usage_Type_iPass || usagetype==MB_Constants.Usage_Type_Messaging || usagetype==MB_Constants.Usage_Type_Calls ||usagetype==MB_Constants.Usage_Type_Data){
            billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c,Charge_Type__r.Name, Data_Consumed_In_MB__c, 
                                    Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c,iPass_Consumed_In_MB__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c,Usage_Type__r.Name, User__c, User_Country__c, User_Email__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c =:month AND Service_Name__c=:deviceId AND Usage_Type__r.Name=:usagetype]; 
      }
      else{
          
           billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c,Charge_Type__r.Name, Data_Consumed_In_MB__c, 
                                    Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c,iPass_Consumed_In_MB__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c,Usage_Type__r.Name, User__c, User_Country__c, User_Email__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c =:month AND Service_Name__c=:deviceId AND Usage_Type__r.Name not in (:'Data',:'Calls',:'Messaging',:'ipass')]; 
      
      }
    Decimal TotalUsageAmount=0;
    for(MB_Billing_Entity__c UsageTotalAmount:billingEntityList){
      if(UsageTotalAmount.Local_Net_Amount__c!=null){
         TotalUsageAmount+=UsageTotalAmount.Local_Net_Amount__c;
         }
    }
    return TotalUsageAmount;
 }
  @AuraEnabled
  public static Decimal getSpendDetailsforchargetype(string deviceId,string month,string chargetype){
  System.debug('---------'+month+'------------@@-'+chargetype+'-------'+deviceId);
      List<MB_Billing_Entity__c> billingEntityList;
      if(chargetype!='NonUsage'&&chargetype!='Recurring'&&chargetype!='Tax'&&chargetype!='Discount'&&chargetype!='Recurring Credit'&&chargetype!='Usage Credit'&&chargetype!='Miscellaneous'&&chargetype!='Disputed'&&chargetype!='None'){
            billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c,Charge_Type__r.Name, Data_Consumed_In_MB__c, 
                                    Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c,iPass_Consumed_In_MB__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c,Usage_Type__r.Name, User__c, User_Country__c, User_Email__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c =:month AND Service_Name__c=:deviceId AND Charge_Type__r.Name=:chargetype]; 
            System.debug('Inside charge type if-->'+billingEntityList);
      }
      else{
            billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c,Charge_Type__r.Name, Data_Consumed_In_MB__c, 
                                    Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c,iPass_Consumed_In_MB__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c,Usage_Type__r.Name, User__c, User_Country__c, User_Email__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c =:month AND Service_Name__c=:deviceId AND Usage_Type__r.Name=:chargetype]; 
            System.debug('else flow');
      }
      
    Decimal TotalUsageAmount=0;
    for(MB_Billing_Entity__c UsageTotalAmount:billingEntityList){
    if(UsageTotalAmount.Local_Net_Amount__c!=null){
         TotalUsageAmount+=UsageTotalAmount.Local_Net_Amount__c;
         }
    }
    return TotalUsageAmount;
 }
 /*-------------------------------------------------------------------------*/   
     public static String getPreviousMonth(String month) {
      Map<String, String> monthsMap = new Map<String, String>{'January' => 'December', 'February' => 'January', 'March' => 'February', 'April' => 'March', 
            'May' => 'April', 'June' => 'May', 'July' => 'June', 'August' => 'July', 'September' => 'August', 
            'October' => 'September', 'November' => 'October', 'December' => 'November'};
        String[] selectedMonthArray = month.split(' '); 
        String previousMonth = monthsMap.get(selectedMonthArray[0]);
        Integer selectedMonthYear = Integer.valueof(selectedMonthArray[1]);
        Integer previousMonthYear = selectedMonthYear;
        if(previousMonth.equalsIgnoreCase('December'))
        {
           previousMonthYear = previousMonthYear - 1;
        }
        String previousBillingPeriod = previousMonth + ' ' + string.valueof(previousMonthYear);
        return  previousBillingPeriod;
    }
 /*-------------------------------------------------------------------------*/ 
 @AuraEnabled
 public static MB_Wrapper_Class.UsageAmountType_Wraper getUsageTotalAmount(string deviceId,string month,string usagetype){
  System.debug('---------'+month+'-------------'+usagetype+'-------'+deviceId);
 System.debug('%$#@!'+deviceId+month+usagetype);
     MB_Wrapper_Class.UsageAmountType_Wraper wprClass=new MB_Wrapper_Class.UsageAmountType_Wraper();
     //if(usagetype!='NonUsage'){
     Decimal usageamount=getSpendDetails(deviceId,month,usagetype);
     string previousMonth= getPreviousMonth(month);
     Decimal  previoususageamount=getSpendDetails(deviceId,previousMonth,usagetype);
     Decimal change=(usageamount-previoususageamount);
     Integer varience=0;
     if(previoususageamount!=0 && change!=0){
     varience=Integer.valueof((change.abs()/previoususageamount)*100);
     }
     else if(previoususageamount==0){
     varience=Integer.valueof(previoususageamount);
     }
     Integer VarianceArrow;
     if(change>0){VarianceArrow=1;}
     else if(change<0){VarianceArrow=2;}
     else{VarianceArrow=3;}
     
     wprClass.userCurrency=MB_Controller_Class.CurrencySym();//[Select Billing_Currency__c FROM MB_Billing_Entity__c LIMIT 1].Billing_Currency__c ;
     System.debug('@!@!'+wprClass.userCurrency);
     wprClass.chargeTypeName=usagetype;System.debug('%%%%$$$$'+wprClass.ChargeTypeName);
     wprClass.UsageCurrentAmount=usageamount.setScale(2);
     wprClass.UsagePreviousAmount=previoususageamount.setScale(2);
     wprClass.UsageChangeAmount=change.abs().setScale(2);
     wprClass.UsageVarience=varience;System.debug('%%%'+wprClass.UsageVarience);
      wprClass.VarianceArrow=VarianceArrow;
 //}
    return wprClass;
  }
 /*-------------------------------------------------------------------------*/  
  @AuraEnabled
  public static List<MB_Wrapper_Class.UsageAmountType_Wraper> getSpendDetailsforChargelist(string deviceId,string month,string usagetype){
   System.debug('---------'+month+'-------------'+usagetype+'-------'+deviceId);
   System.debug('----------------ank1i----------------'+deviceId+'-----------'+month+'-----------'+usagetype);
      List<MB_Wrapper_Class.UsageAmountType_Wraper> lst;
      if(usagetype!='NonUsage'){
          System.debug('usagetype!=nonusage');
          lst=new List<MB_Wrapper_Class.UsageAmountType_Wraper>();
              List<MB_Billing_Entity__c> billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c,Charge_Type__r.Name, Data_Consumed_In_MB__c, 
                                            Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c,iPass_Consumed_In_MB__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                            Service_Name__c, Usage_Type__c,Usage_Type__r.Name, User__c, User_Country__c, User_Email__c 
                                            FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c =:month AND Service_Name__c=:deviceId AND Usage_Type__r.Name=:usagetype]; 
            Set<String> chargelist=new Set<String>();
            for(MB_Billing_Entity__c chargelst:billingEntityList){
                 chargelist.add(chargelst.Charge_Type__r.Name);
            }
            Decimal  previoususageamount=0;
            
            for(string chargelstforUsage:chargelist){System.debug('####$$$$'+chargelstforUsage);
             Decimal usageamount=getSpendDetailsforchargetype(deviceId,month,chargelstforUsage);
             
             string previousMonth= getPreviousMonth(month);
             previoususageamount=getSpendDetailsforchargetype(deviceId,previousMonth,chargelstforUsage);
             System.debug('@@@!!@$$$'+previoususageamount+'----'+usageamount+'------'+chargelstforUsage);
             Decimal change=(usageamount-previoususageamount);
             
             Integer varience=0;
             if(previoususageamount!=0 && change!=0){
             varience=Integer.valueof((change.abs()/previoususageamount)*100);
             }
             else if(previoususageamount==0){
             varience=Integer.valueof(previoususageamount);
             }
             Integer VarianceArrow;
             if(change>0){VarianceArrow=1;}
             else if(change<0){VarianceArrow=2;}
             else{VarianceArrow=3;}
             MB_Wrapper_Class.UsageAmountType_Wraper wprClass=new MB_Wrapper_Class.UsageAmountType_Wraper();
             if(usageamount>0 || previoususageamount>0){
             wprClass.chargeTypeName=chargelstforUsage; 
             wprClass.UsageCurrentAmount=usageamount.setScale(2);
             wprClass.UsagePreviousAmount=previoususageamount.setScale(2);
             wprClass.UsageChangeAmount=change.abs().setScale(2);
             wprClass.UsageVarience=varience; 
             wprClass.VarianceArrow=VarianceArrow;
             lst.add(wprClass);
             }
             
            }
          System.debug('list in if--->'+lst);
      }
      else{
          lst=new List<MB_Wrapper_Class.UsageAmountType_Wraper>();
          //Start here
            //List<Id> usageIds=[Select Id from MB_Charge_Type__c where Name not in (:'Data',:'Calls',:'Messaging',:'ipass')] ;         
            List<MB_Billing_Entity__c> billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c,Charge_Type__r.Name, Data_Consumed_In_MB__c, 
                                            Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c,iPass_Consumed_In_MB__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                            Service_Name__c, Usage_Type__c,Usage_Type__r.Name, User__c, User_Country__c, User_Email__c 
                                            FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c =:month AND Service_Name__c=:deviceId AND Usage_Type__r.Name not in (:'Data',:'Calls',:'Messaging',:'ipass')]; 
            Set<String> chargelist=new Set<String>();
            for(MB_Billing_Entity__c chargelst:billingEntityList){
                 chargelist.add(chargelst.Usage_Type__r.Name);
                 /*if(!chargelist.contains('NonUsage'))
                 chargelist.add('NonUsage');*/
            }
            Decimal  previoususageamount=0;
            
            for(string chargelstforUsage:chargelist){
                 System.debug('####$$$$'+chargelstforUsage);
                 Decimal usageamount=getSpendDetailsforchargetype(deviceId,month,chargelstforUsage);
                 string previousMonth= getPreviousMonth(month);
                 previoususageamount=getSpendDetailsforchargetype(deviceId,previousMonth,chargelstforUsage);
                 System.debug('@@@!!@$$$'+previoususageamount+'----'+usageamount+'------'+chargelstforUsage);
                 Decimal change=(usageamount-previoususageamount);
                 
                 Integer varience=0;
                 if(previoususageamount!=0 && change!=0){
                 varience=Integer.valueof((change.abs()/previoususageamount)*100);
                 }
                 else if(previoususageamount==0){
                 varience=Integer.valueof(previoususageamount);
                 }
                 Integer VarianceArrow;
                 if(change>0){VarianceArrow=1;}
                 else if(change<0){VarianceArrow=2;}
                 else{VarianceArrow=3;}
                 MB_Wrapper_Class.UsageAmountType_Wraper wprClass=new MB_Wrapper_Class.UsageAmountType_Wraper();
                 if(usageamount>0 || previoususageamount>0){
                 wprClass.chargeTypeName=chargelstforUsage; 
                 wprClass.UsageCurrentAmount=usageamount.setScale(2);
                 wprClass.UsagePreviousAmount=previoususageamount.setScale(2);
                 wprClass.UsageChangeAmount=change.abs().setScale(2);
                 wprClass.UsageVarience=varience; 
                 wprClass.VarianceArrow=VarianceArrow;
                 lst.add(wprClass);
                 }
             
            }
          
          //Finish here
      }
          
    System.debug('----------------anki----------------'+lst);
   return lst; 
 }
   /**** Get FAQ Values****/
    @AuraEnabled
    public static List<MB_FAQ_List__c> getFaqList() {
        List<MB_FAQ_List__c> lst=MB_FAQ_List__c.getall().values();
        return lst;
    } 
    @AuraEnabled
    public static string getGAID(){      
        string strgaid = MB_Info_ReportingGA__c.getinstance('GA_ID').Text_Value__c;
        return strgaid;      
    }
    
 }