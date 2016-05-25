/***************************************************************
Class Name: MB_Controller_Class.cls
Copyright © 2016 Salesforce

Purpose:
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Controller class For TEM app.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       12/05/2016        controller class For TEM app
***************************************************************/

public with sharing class MB_Controller_Class{
  
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
    
   /*******************************************************************************************************
    * @description This method returns total user spend with particular device.
    * @param  month
    * @return Wrapper
    */
    @AuraEnabled
     public static List<MB_Wrapper_Class.MB_Device_Wrapper_Class>deviceSpendDetailsForUser(String month){
     
      List<MB_Billing_Entity__c> billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c, Data_Consumed_In_MB__c, 
                                    Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c,iPass_Consumed_In_MB__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c, User__c, User_Country__c, User_Email__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c =:month]; 
                                  
      List<MB_Wrapper_Class.MB_Device_Wrapper_Class> wrapperList=new List<MB_Wrapper_Class.MB_Device_Wrapper_Class>();
      Map<Id,MB_Billing_Entity__c> deviceMap=new Map<Id,MB_Billing_Entity__c>();
      for(MB_Billing_Entity__c entity:billingEntityList){
        if(!deviceMap.containsKey(entity.Device_Details__c)){
          deviceMap.put(entity.Device_Details__c,entity);
        }
      }
      
      List<MB_Billing_Entity__c> billingEntityDistinctList=deviceMap.values();
      for(MB_Billing_Entity__c entity:billingEntityDistinctList ){
        MB_Wrapper_Class.MB_Device_Wrapper_Class objWrapper=new MB_Wrapper_Class.MB_Device_Wrapper_Class();
        objWrapper.userName=userinfo.getFirstName();
        objWrapper.deviceId=entity.Device_Details__c;
        objWrapper.userCurrency=entity.Billing_Currency__c;
        objWrapper.deviceName=entity.Device_Details__r.Name;
        objWrapper.deviceImageUrl=entity.Device_Details__r.Photo_URL__c;
        objWrapper.totalUsage=totalDeviceSpend(billingEntityList,entity.Device_Details__c);
        system.debug('###'+objWrapper.totalUsage);
        wrapperList.add(objWrapper);
      }
      
     return wrapperList;
      
     }
     
    /*******************************************************************************************************
    * @description This method returns total spend of a user device for a particular month.
    * @param  month, device Id
    * @return decimal  
    */ 
  
    public static  decimal totalDeviceSpend(List<MB_Billing_Entity__c> billingList, ID deviceId) {
        decimal totalDeviceAmount = 0; 

        for(MB_Billing_Entity__c beObj : billingList){
            if(beObj.Device_Details__c == deviceId)
                totalDeviceAmount += beObj.Local_Net_Amount__c;
        }
        return totalDeviceAmount;
    }  
     
     /*******************************************************************************************************
    * @description This method returns total spend of a user device for a particular month.
    * @param  month, device Id
    * @return decimal  
    */ 
    
    @AuraEnabled
     public static string getUserName(){
      system.debug(userinfo.getfirstname());
      return userinfo.getfirstname();
    }
    
      /*******************************************************************************************************
    * @description This method returns total spend of a user device for a particular month.
    * @param  month, device Id
    * @return decimal  
    */ 
    
    @AuraEnabled
    public static MB_Wrapper_Class.MB_Device_Wrapper_Class getUsageDetails(String month) {
        Integer UserCount=0;
        Decimal AverageDataUsage=0;
        Decimal AverageCallUsage=0;
        Decimal AverageMessageUsage=0;
        Decimal AverageIpassUsage=0;
        Decimal DataUsage =0;
        Decimal CallUsage =0; 
        Decimal MessageUsage =0;
        Decimal IpassUsage =0;
        Decimal previousDataUsage =0;
        Decimal previousCallUsage =0; 
        Decimal previousMessageUsage =0;
        Decimal previousIpassUsage =0;
        Decimal totalSpend =0;

        System.debug('!@!@');
        List<MB_Billing_Entity__c> lstCollegueChargeType=[Select Usage_Type__r.Name,Billing_Currency__c, Data_Consumed_In_MB__c,Call_Minutes__c,Messages__c,iPass_Consumed_In_MB__c from MB_Billing_Entity__c where  Billing_Month__c =: month and User__c !=:UserInfo.getUserId()];   
         system.debug('***'+lstCollegueChargeType.size());
        if(lstCollegueChargeType.size() >0){
         for(MB_Billing_Entity__c AvgofCollegueData:lstCollegueChargeType)
         {  
           UserCount++;
           if(AvgofCollegueData.Usage_Type__r.Name =='Data'){
               AverageDataUsage+=AvgofCollegueData.Data_Consumed_In_MB__c; System.debug('%%%1'+AverageDataUsage);
           }
           if(AvgofCollegueData.Usage_Type__r.Name =='Calls'){
              AverageCallUsage+=AvgofCollegueData.Call_Minutes__c; System.debug('%%%2');
           }
           if(AvgofCollegueData.Usage_Type__r.Name =='Messaging'){
              AverageMessageUsage+=AvgofCollegueData.Messages__c;
           }
           if(AvgofCollegueData.Usage_Type__r.Name == 'Ipass'){
               AverageIpassUsage+=AvgofCollegueData.iPass_Consumed_In_MB__c ;
            }
        }
        MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj=new MB_Wrapper_Class.MB_Device_Wrapper_Class();   
        wrprobj.totalAverageDataUsage=AverageDataUsage/UserCount;
        wrprobj.totalAverageCallUsage=AverageCallUsage/UserCount;
        wrprobj.totalAverageMessageUsage=AverageMessageUsage/UserCount;
        wrprobj.totalAverageIpassUsage=AverageIpassUsage/UserCount;
        string previousMonth=getPreviousMonth(month);
        List<MB_Billing_Entity__c> lstyourChargeType=[Select Usage_Type__r.Name, Billing_Currency__c,Data_Consumed_In_MB__c,Call_Minutes__c,Messages__c,Local_Net_Amount__c,iPass_Consumed_In_MB__c,Billing_Month__c from MB_Billing_Entity__c where Billing_Month__c in (:month,:previousMonth) and User__c=:UserInfo.getUserId()];   
        for(MB_Billing_Entity__c CurrentUserData:lstyourChargeType)
        {
          if(CurrentUserData.Billing_Month__c ==month){
          
          if(CurrentUserData.Usage_Type__r.Name =='Data'){
                DataUsage +=CurrentUserData.Data_Consumed_In_MB__c;
           }
           if(CurrentUserData.Usage_Type__r.Name =='Calls'){
              CallUsage +=CurrentUserData.Call_Minutes__c;
           }
           if(CurrentUserData.Usage_Type__r.Name =='Messaging'){
              MessageUsage +=CurrentUserData.Messages__c;
           }
           if(CurrentUserData.Usage_Type__r.Name == 'Ipass'){
              IpassUsage +=CurrentUserData.iPass_Consumed_In_MB__c;
            }
            
            totalSpend+=CurrentUserData.Local_Net_Amount__c; 
            wrprobj.userCurrency=CurrentUserData.Billing_Currency__c;
          }
          
           if(CurrentUserData.Billing_Month__c ==previousMonth){
           
           if(CurrentUserData.Usage_Type__r.Name =='Data'){
               previousDataUsage +=CurrentUserData.Data_Consumed_In_MB__c;
           }
           if(CurrentUserData.Usage_Type__r.Name =='Calls'){
             previousCallUsage +=CurrentUserData.Call_Minutes__c;
           }
           if(CurrentUserData.Usage_Type__r.Name =='Messaging'){
             previousMessageUsage +=CurrentUserData.Messages__c;
           }
           if(CurrentUserData.Usage_Type__r.Name == 'Ipass'){
              previousIpassUsage +=CurrentUserData.iPass_Consumed_In_MB__c; 
            }
         
          }
                   

        }
          
          wrprobj.totalDataUsage=DataUsage ;
          wrprobj.totalCallUsage=CallUsage ;
          wrprobj.totalMessageUsage=MessageUsage ;
          wrprobj.totalIpassUsage=IpassUsage ;
          wrprobj.totalUsage=totalSpend;
          wrprobj.userName=userinfo.getfirstname();
          wrprobj.dataVariance=getVariance(DataUsage,previousDataUsage );
          wrprobj.callVariance=getVariance(CallUsage ,previousCallUsage  ) ;
          wrprobj.smsVariance=getVariance(MessageUsage,previousMessageUsage );
          wrprobj.ipassVariance=getVariance(IpassUsage ,previousIpassUsage ) ;
          return wrprobj;
          
         }
         
         return null;
       }
       
    /*******************************************************************************************************
    * @description This method returns total spend of a user device for a particular month.
    * @param  month, device Id
    * @return decimal  
    */ 
    public static boolean getVariance(decimal currentUsage,decimal previousUsage){
    
      if(currentUsage >  previousUsage)
      {
        system.debug('***'+currentUsage+'$$'+previousUsage);
        return true;
      }
       if(currentUsage < previousUsage)
      {
        return false;
      }
      if(currentUsage == previousUsage){
       return null;
      }
      
      return null;
   }
   
     
}