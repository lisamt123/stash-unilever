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

    public static MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj{get;set;}
    public static Decimal DataUsage {get;set;}
    public static Decimal CallUsage {get;set;} 
    public static Decimal MessageUsage {get;set;}
    public static Decimal IpassUsage {get;set;}
    public static Decimal previousDataUsage {get;set;}
    public static Decimal previousCallUsage {get;set;}
    public static Decimal previousMessageUsage {get;set;}
    public static Decimal previousIpassUsage {get;set;}
    public static Decimal previousnonUsage {get;set;}
    public static Decimal previouSpend {get;set;}
    public static Decimal totalSpend {get;set;}
    public static final String iPass_Type = 'iPass';
     public static string CurrencySym()
     {
      MB_Billing_Currency__c CurrencySymbol = MB_Billing_Currency__c.getInstance('GBP');
      String CurrencyS=String.valueof(CurrencySymbol.Symbol__c);
      System.debug('#######'+CurrencySymbol);
      return CurrencyS;
     }
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
                                    Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c, User__c, User_Country__c, User_Email__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c =:month AND Usage_Type__r.Name !=:iPass_Type]; 
                                  
      List<MB_Wrapper_Class.MB_Device_Wrapper_Class> wrapperList=new List<MB_Wrapper_Class.MB_Device_Wrapper_Class>();
      set<Id> deviceIds=new set<Id>();
      Map<Id,MB_Billing_Entity__c> deviceMap=new Map<Id,MB_Billing_Entity__c>();
      for(MB_Billing_Entity__c entity:billingEntityList){
         
        if(!deviceMap.containsKey(entity.Device_Details__c)){
          deviceMap.put(entity.Device_Details__c,entity);
        }
      }
      for(MB_Billing_Entity__c entity:billingEntityList){
       if(entity.Device_Details__c !=null){
          deviceIds.add(Id.valueof(entity.Device_Details__c));
         }
        }
      
      List<MB_Device_Details__Feed> contentIdList=[SELECT Id, ParentId,RelatedRecordId FROM MB_Device_Details__Feed where ParentId in :deviceIds];
      Map<Id,Id> imageIdMap=new Map<Id,Id>();
    
    for(MB_Device_Details__Feed document:contentIdList){
       if(!imageIdMap.containsKey(document.ParentId)){
         if( document.RelatedRecordId !=null){
         system.debug('parentid'+document.ParentId+'recordid'+document.RelatedRecordId);
          imageIdMap.put(id.valueof(document.ParentId),id.valueof(document.RelatedRecordId));
          
       }
      }
     } 
      string sfcBaseUrl=URL.getSalesforceBaseUrl().toExternalForm() + '/'+'sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=';
      
      System.debug('URL--->'+URL.getSalesforceBaseUrl().toExternalForm());
      List<MB_Billing_Entity__c> billingEntityDistinctList=deviceMap.values();
      for(MB_Billing_Entity__c entity:billingEntityDistinctList ){
        MB_Wrapper_Class.MB_Device_Wrapper_Class objWrapper=new MB_Wrapper_Class.MB_Device_Wrapper_Class();
        objWrapper.userName=userinfo.getFirstName();
        objWrapper.deviceId=entity.Device_Details__c;
        objWrapper.userCurrency=CurrencySym();
        objWrapper.deviceName=entity.Device_Details__r.Name;
        
        if(imageIdMap.size() > 0){
          objWrapper.deviceImageUrl=sfcBaseUrl+string.valueof(imageIdMap.get(entity.Device_Details__c));
          
        }
        system.debug('###'+ objWrapper.deviceImageUrl);
        objWrapper.totalUsage=totalDeviceSpend(billingEntityList,entity.Device_Details__c).setScale(2);
     
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
              if(beObj.Local_Net_Amount__c !=null ){
                totalDeviceAmount += beObj.Local_Net_Amount__c;
                }
        }
        return totalDeviceAmount;
    }  
     /*******************************************************************************************************
    * @description This method returns total spend of a user device for a particular month.
    * @param  month 
    * @return decimal  
    */ 
     public static  decimal iPassDeviceSpend(List<MB_Billing_Entity__c> billingList) {
        decimal totalDeviceAmount = 0; 

        for(MB_Billing_Entity__c beObj : billingList){
             
              if(beObj.Local_Net_Amount__c !=null ){
                totalDeviceAmount += beObj.Local_Net_Amount__c;
                }
        }System.debug('!@#$'+totalDeviceAmount );
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
    
        DataUsage=0;
        CallUsage=0;
        MessageUsage=0;
        IpassUsage=0;
        previousDataUsage=0;
        previousCallUsage=0;
        previousMessageUsage=0;
        previousIpassUsage=0;
        totalSpend=0;
        
        wrprobj=new MB_Wrapper_Class.MB_Device_Wrapper_Class(); 
              
        
        string previousMonth=getPreviousMonth(month);
        List<MB_Billing_Entity__c> lstyourChargeType=[Select Usage_Type__r.Name, Billing_Currency__c,Data_Consumed_In_MB__c,Call_Minutes__c,Messages__c,Local_Net_Amount__c,Billing_Month__c from MB_Billing_Entity__c where Billing_Month__c in (:month,:previousMonth) and User__c=:UserInfo.getUserId()];   
        List<MB_Billing_Entity__c> currentMnthList=new List<MB_Billing_Entity__c> ();
        for(MB_Billing_Entity__c item:lstyourChargeType){
         if(item.Billing_Month__c ==month){
           currentMnthList.add(item);
         }
        }
        if(currentMnthList.size()>0){
        for(MB_Billing_Entity__c CurrentUserData:lstyourChargeType)
        {
          updateMonthDataUsage(CurrentUserData,month);
          updatePreviousMonthDataUsage(CurrentUserData,previousMonth);

        }
          system.debug('!@#$');
          wrprobj.totalCallUsagePattern='';
          Decimal callusageinmin=CallUsage.setScale(2);
          system.debug('!@#$--'+callusageinmin);
          if(getMinsSecond(callusageinmin)!=null && callusageinmin!=null)
          {
             wrprobj.totalCallUsagePattern=getMinsSecond(callusageinmin);
              system.debug('!@#$---'+wrprobj.totalCallUsagePattern);
          }
          wrprobj.totalDataUsage=DataUsage.setScale(2);
          wrprobj.totalMessageUsage=MessageUsage.setScale(2) ;
          wrprobj.totalIpassUsage=IpassUsage.setScale(2) ;
          wrprobj.totalUsage=totalSpend.setScale(2);
          wrprobj.userName=userinfo.getfirstname();
          wrprobj.dataVariance=getVariance(DataUsage,previousDataUsage );
          wrprobj.callVariance=getVariance(CallUsage ,previousCallUsage  ) ;
          wrprobj.smsVariance=getVariance(MessageUsage,previousMessageUsage );
          wrprobj.ipassVariance=getVariance(IpassUsage ,previousIpassUsage ) ;
           system.debug('$$$'+wrprobj);
          return wrprobj;
         
          
         }
         return null;
       }
       
       public static void updateMonthDataUsage(MB_Billing_Entity__c CurrentUserData, String month){
       
            if(CurrentUserData.Billing_Month__c ==month){
             if(CurrentUserData.Local_Net_Amount__c !=null){
              totalSpend=totalSpend+CurrentUserData.Local_Net_Amount__c; 
                wrprobj.userCurrency=CurrencySym();
              }
          if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Data && CurrentUserData.Data_Consumed_In_MB__c!=null){
                DataUsage +=CurrentUserData.Data_Consumed_In_MB__c;
           }
           if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Calls && CurrentUserData.Call_Minutes__c!=null){
              CallUsage +=CurrentUserData.Call_Minutes__c;
           }
           if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Messaging && CurrentUserData.Messages__c!=null){
              MessageUsage +=CurrentUserData.Messages__c;
           }
           if(CurrentUserData.Usage_Type__r.Name == MB_Constants.Usage_Type_iPass && CurrentUserData.Data_Consumed_In_MB__c!=null){
              IpassUsage +=CurrentUserData.Data_Consumed_In_MB__c;
            }
          }       
       }
        public static void updatePreviousMonthDataUsage(MB_Billing_Entity__c CurrentUserData,String previousMonth){
       
           if(CurrentUserData.Billing_Month__c ==previousMonth){
           
           if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Data && CurrentUserData.Data_Consumed_In_MB__c!=null){
               previousDataUsage +=CurrentUserData.Data_Consumed_In_MB__c;
           }
           if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Calls && CurrentUserData.Call_Minutes__c!=null){
             previousCallUsage +=CurrentUserData.Call_Minutes__c;
           }
           if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Messaging && CurrentUserData.Messages__c!=null){
             previousMessageUsage +=CurrentUserData.Messages__c;
           }
           if(CurrentUserData.Usage_Type__r.Name == MB_Constants.Usage_Type_iPass && CurrentUserData.Data_Consumed_In_MB__c!=null){
              previousIpassUsage +=CurrentUserData.Data_Consumed_In_MB__c; 
            }
         
             }    
       }
    /*******************************************************************************************************
    * @description This method returns total spend of a user device for a particular month.
    * @param  month, device Id
    * @return decimal  
    */ 
    public static boolean getVariance(decimal currentUsage,decimal previousUsage){
    
      if(currentUsage >  previousUsage && previousUsage !=0)
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
   
   /*******************************************************************************************************
    * @description This method returns total spend of a user device for a particular month.
    * @param  month, device Id
    * @return decimal  
    */ 
    
      @AuraEnabled
   public static MB_Wrapper_Class  getSpendDetails(string deviceId,string month){
  
       string previous=getPreviousMonth(month);
       List<MB_Billing_Entity__c> billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c,Charge_Type__r.Name, Data_Consumed_In_MB__c, 
                                    Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c,Usage_Type__r.Name, User__c, User_Country__c, User_Email__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c in (:month,:previous) AND Device_Details__c=:deviceId AND Usage_Type__r.Name !=:iPass_Type]; 
                                    
               
       List<MB_Billing_Entity__c> previousmonthBillingList=new List<MB_Billing_Entity__c>();
       List<MB_Billing_Entity__c> currentmonthBillingList=new List<MB_Billing_Entity__c>();
       for(MB_Billing_Entity__c entity:billingEntityList){
         if(entity.Billing_Month__c ==month) currentmonthBillingList.add(entity);
         if(entity.Billing_Month__c ==previous) previousmonthBillingList.add(entity);
       }
       //===============Code Optimization Starts================================
       Map<string,MB_Wrapper_Class.DataChargeType_Wraper> dataMap=new Map<string,MB_Wrapper_Class.DataChargeType_Wraper>();
       Map<string,MB_Wrapper_Class.CallsChargeType_Wraper> callsMap=new Map<string,MB_Wrapper_Class.CallsChargeType_Wraper>();
       Map<string,MB_Wrapper_Class.MessagingChargeType_Wraper> messagingMap= new Map<string,MB_Wrapper_Class.MessagingChargeType_Wraper>();
       Map<string,MB_Wrapper_Class.NonUsageChargeType_Wrapper> nonusageMap=new Map<string,MB_Wrapper_Class.NonUsageChargeType_Wrapper>();
      
       
       dataMap = getDataMap(currentmonthBillingList, MB_Constants.Usage_Type_Data);
       callsMap = getCallMap(currentmonthBillingList, MB_Constants.Usage_Type_Calls);
       messagingMap = getMessageMap(currentmonthBillingList, MB_Constants.Usage_Type_Messaging);
       nonUsageMap = getNonUsageMap(currentmonthBillingList);
      
      
       //===============Code Optimization Ends ================================  
       
       
    
        MB_Wrapper_Class objWrapper=new MB_Wrapper_Class();
        objWrapper.dataWrapperList=dataMap.values();
        objWrapper.callsWrapperList=callsMap.values();
        objWrapper.messageWrapperList=messagingMap.values();
        objWrapper.nonusageWrapperList=nonusageMap.values();
         
        previousDataUsage =0;
        previousCallUsage =0; 
        previousMessageUsage =0;
        previousIpassUsage =0;
        previousnonUsage =0;
        previouSpend =0;
        
         previousDataUsage=totalDeviceUsageSpend(previousmonthBillingList,MB_Constants.Usage_Type_Data).setScale(2);
         previousCallUsage=totalDeviceUsageSpend(previousmonthBillingList,MB_Constants.Usage_Type_Calls).setScale(2);
         previousMessageUsage=totalDeviceUsageSpend(previousmonthBillingList,MB_Constants.Usage_Type_Messaging).setScale(2);
         previousnonUsage=totalDeviceUsageSpend(previousmonthBillingList,MB_Constants.Usage_Type_Recurring).setScale(2);
         previouSpend=totalDeviceSpend(previousmonthBillingList,deviceId).setScale(2);
        
        MB_Wrapper_Class.MB_Device_Wrapper_Class objdevice=new MB_Wrapper_Class.MB_Device_Wrapper_Class();
        objdevice.userCurrency=CurrencySym();
        objdevice.userName=userinfo.getfirstname();
        objdevice.totalDataUsage=totalDeviceUsageSpend(currentmonthBillingList,MB_Constants.Usage_Type_Data).setScale(2);
        objdevice.totalCallUsage=totalDeviceUsageSpend(currentmonthBillingList,MB_Constants.Usage_Type_Calls).setScale(2);       
        objdevice.totalMessageUsage=totalDeviceUsageSpend(currentmonthBillingList,MB_Constants.Usage_Type_Messaging).setScale(2);
        
       
       List<MB_Usage_Type__c> nonUsageTypes=[Select id,Name from MB_Usage_Type__c where Name not in (:'Data',:'Calls',:'Messaging',:'ipass')]; 
       objdevice.totalnonUsage=0;
       for(MB_Usage_Type__c nonUsage:nonUsageTypes){           
           objdevice.totalnonUsage+=totalDeviceUsageSpend(currentmonthBillingList,nonUsage.Name).setScale(2);
       }        
        objdevice.totalUsage=totalDeviceSpend(currentmonthBillingList,deviceId).setScale(2);
        objdevice.dataVariance=getVariance(objdevice.totalDataUsage,previousDataUsage);
        objdevice.callVariance=getVariance(objdevice.totalCallUsage,previousCallUsage);
        objdevice.smsVariance=getVariance(objdevice.totalMessageUsage,previousMessageUsage);
        objdevice.nonUsageVariance=getVariance(objdevice.totalnonUsage,previousnonUsage);
        objdevice.totalSpendVariance=getVariance(objdevice.totalUsage,previouSpend);
        objWrapper.objdeviceWrapper=objdevice;        
        return objWrapper;        
  }
  
  /*******************************************************************************************************
    * @description This method returns total spend of a particular usage type.
    * @param  month, device Id
    * @return decimal  
    */ 
     @AuraEnabled
    public static  decimal totalDeviceUsageSpend(List<MB_Billing_Entity__c> billingList, string usageType) {
        decimal totalusageAmount = 0; 
        for(MB_Billing_Entity__c beObj : billingList){
            if(beObj.Usage_Type__r.Name == usageType){
              if(beObj.Local_Net_Amount__c !=null){
                totalusageAmount += beObj.Local_Net_Amount__c;
                }
             }   
        }
        
        return totalusageAmount;
    }  
   
    public static String getMinsSecond(Decimal Mins){
      String tempHours;
String tempMin;
String min='00';
String sec='00';
String hours='00';
String a='1';
String b='1';
          Decimal m=Mins;
          tempHours=String.valueof(m/60);
          String[] res=tempHours.split('\\.');
          System.debug('--'+res);
      if(res[0]!='0'){
          if(res[0].length()>1){
          hours=res[0];
          }
          else{
              hours='0'+res[0];
          }
      }
          System.debug('-hours-'+hours);
          System.debug('-res-'+res);
if(res.size()>1){
    for(Integer i=0;i<res[1].length();i++){
        a=a+'0';
    }
    System.debug('-res-'+a);
          tempMin =String.valueof((((Decimal.valueof(res[1]))/Decimal.valueof(a))*60));
          String[] res1 =tempMin.split('\\.');
          System.debug('--'+res1);
          if(res1[0]!='0'){
              if(res1[0].length()>1){
          min=res1[0].Substring(0,2);
              }else{
                  min='0'+res1[0];
              }
          }
          System.debug('-min-'+min);
    if(res1.size()>1){
          for(Integer j=0;j<res1[1].length();j++){
        b=b+'0';
    }
          String secc=string.valueof(((Decimal.valueof(res1[1])/Decimal.valueof(b))*60));
        if(secc.length()>1){
        System.debug('-secc-'+secc);
        Decimal sece=decimal.valueOf(secc);
         if(string.valueOf(Math.round(sece)).length()>1)
         {
           sec=string.valueOf(Math.round(sece)).Substring(0,2);             
         }
            else{
                sec='0'+string.valueOf(Math.round(sece));
            }
        }
        else{
            sec='0'+secc;
        }
          System.debug('-sec-'+sec);
    }  }

     String str=hours+':'+min+':'+sec;
     System.debug('--'+str);
     return str;
    }
    
    @AuraEnabled
    public static MB_Wrapper_Class.MB_Device_Wrapper_Class iPassSpendDetailsForUser(String month){
     System.debug('test#'+ month);
      List<MB_Billing_Entity__c> billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c, Data_Consumed_In_MB__c, 
                                    Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c, User__c, User_Country__c, User_Email__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c =:month AND Usage_Type__r.Name=: iPass_Type]; 
                                  
      MB_Wrapper_Class.MB_Device_Wrapper_Class wrapperList=new MB_Wrapper_Class.MB_Device_Wrapper_Class();
      wrapperList.iPassTotalAmount=0;
      wrapperList.iPassDataConsumedinMB=0;
     
      for(MB_Billing_Entity__c Total_iPass:billingEntityList)
      {
       if(Total_iPass.Local_Net_Amount__c !=null)
       {
          wrapperList.iPassTotalAmount +=Total_iPass.Local_Net_Amount__c;
          System.debug('test##'+Total_iPass.Local_Net_Amount__c);
       }
       if(Total_iPass.Data_Consumed_In_MB__c!=null)
       {
          wrapperList.iPassDataConsumedinMB +=Total_iPass.Data_Consumed_In_MB__c;
       }
      }
      wrapperList.userCurrency=CurrencySym();
      return wrapperList;
      }
    @AuraEnabled
    public static MB_Wrapper_Class  getIpassSpendDetails(string month){
    System.debug(',,,month--->'+month);
       string previous=getPreviousMonth(month);
       List<MB_Billing_Entity__c> billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c,Charge_Type__r.Name, Data_Consumed_In_MB__c, 
                                    Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c,Usage_Type__r.Name, User__c, User_Country__c, User_Email__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c in (:month,:previous) AND Usage_Type__r.Name =:iPass_Type ]; 
              
       List<MB_Billing_Entity__c> previousmonthBillingList=new List<MB_Billing_Entity__c>();
       List<MB_Billing_Entity__c> currentmonthBillingList=new List<MB_Billing_Entity__c>();
       for(MB_Billing_Entity__c entity:billingEntityList){
         if(entity.Billing_Month__c ==month){
            currentmonthBillingList.add(entity);
         }
         if(entity.Billing_Month__c ==previous){
            previousmonthBillingList.add(entity);
         }
       }
       
        
       Map<string,MB_Wrapper_Class.IpassChargeType_Wraper> ipassMap=new  Map<string,MB_Wrapper_Class.IpassChargeType_Wraper>();
            for(MB_Billing_Entity__c entity:currentmonthBillingList)
       {
       
        if(entity.Usage_Type__r.Name ==MB_Constants.Usage_Type_iPass)
        {
          if(!ipassMap.containsKey(entity.Charge_Type__r.Name)){
              system.debug('coming'+entity.Charge_Type__r.Name);
              MB_Wrapper_Class.IpassChargeType_Wraper objData=new MB_Wrapper_Class.IpassChargeType_Wraper ();
              objData.chargeTypeName=entity.Charge_Type__r.Name;
              if(entity.Local_Net_Amount__c !=null){
              objData.totalSpend=entity.Local_Net_Amount__c.setScale(2);
              }
              ipassMap.put(entity.Charge_Type__r.Name,objData);
         
          }
          else if(ipassMap.containsKey(entity.Charge_Type__r.Name)){
             //decimal amount=0;
             MB_Wrapper_Class.IpassChargeType_Wraper objData=ipassMap.get(entity.Charge_Type__r.Name);
             ipassMap.remove(entity.Charge_Type__r.Name);
             if(entity.Local_Net_Amount__c !=null){
             objData.totalSpend+=entity.Local_Net_Amount__c.setScale(2);
             objData.chargeTypeName=entity.Charge_Type__r.Name;
             ipassMap.put(entity.Charge_Type__r.Name,objData);
        }
        }
       }
       
       
        
        }
    
        MB_Wrapper_Class objWrapper=new MB_Wrapper_Class();
        objWrapper.ipassWrapperList=ipassMap.values();
         
        system.debug('@@@@'+objWrapper.ipassWrapperList.size());
        
         
        previousIpassUsage =0;
       
        previouSpend =0;
        
          
         previousIpassUsage=totalDeviceUsageSpend(previousmonthBillingList,MB_Constants.Usage_Type_iPass).setScale(2);
        
         previouSpend=iPassDeviceSpend(previousmonthBillingList).setScale(2);
        
        MB_Wrapper_Class.MB_Device_Wrapper_Class objdevice=new MB_Wrapper_Class.MB_Device_Wrapper_Class();
        objdevice.userCurrency=CurrencySym();
        objdevice.userName=userinfo.getfirstname();
         
        objdevice.totalIpassUsage=totalDeviceUsageSpend(currentmonthBillingList,MB_Constants.Usage_Type_iPass).setScale(2);
       
       
        
       objdevice.totalUsage=iPassDeviceSpend(currentmonthBillingList).setScale(2);
         
        objdevice.ipassVariance=getVariance(objdevice.totalIpassUsage,previousIpassUsage);
         
        objdevice.totalSpendVariance=getVariance(objdevice.totalUsage,previouSpend);
        objWrapper.objdeviceWrapper=objdevice;
        
        return objWrapper;
        
  }
    @AuraEnabled
    public static string getGAID(){      
        string strgaid = MB_ReportingGA__c.getinstance('GA_ID').Text_Value__c;
        return strgaid;      
    }
    
    //===============Code Optimization Starts================================
     //Get DataChargeType_Wraper
       @AuraEnabled
       public static Map<string,MB_Wrapper_Class.DataChargeType_Wraper> getDataMap(List<MB_Billing_Entity__c> beList , String usageTypeName){
        
        Map<string,MB_Wrapper_Class.DataChargeType_Wraper> dataInnerMap=new Map<string,MB_Wrapper_Class.DataChargeType_Wraper>();
        for(MB_Billing_Entity__c entity:beList){
        if(entity.Usage_Type__r.Name ==usageTypeName)
        {
          
          if(!dataInnerMap.containsKey(entity.Charge_Type__r.Name)){
                  MB_Wrapper_Class.DataChargeType_Wraper objData=new MB_Wrapper_Class.DataChargeType_Wraper();
                  objData.chargeTypeName=entity.Charge_Type__r.Name;
                  if(entity.Local_Net_Amount__c !=null){
                    objData.totalSpend=entity.Local_Net_Amount__c.setScale(2);
                    dataInnerMap.put(entity.Charge_Type__r.Name,objData);
                }
              }
              
              else if(dataInnerMap.containsKey(entity.Charge_Type__r.Name)){
                 decimal amount=0;
                 MB_Wrapper_Class.DataChargeType_Wraper objData=dataInnerMap.get(entity.Charge_Type__r.Name);
                 dataInnerMap.remove(entity.Usage_Type__r.Name);
                 if(entity.Local_Net_Amount__c !=null  )
                 {              
                   amount=objData.totalSpend+entity.Local_Net_Amount__c.setScale(2);
                 }
                 objData.totalSpend=amount.setScale(2);
                 objData.chargeTypeName=entity.Charge_Type__r.Name;
                 dataInnerMap.put(entity.Charge_Type__r.Name,objData);
            }
            
           }
            
        }
        return dataInnerMap;
       }
       
        //Get CallsChargeType_Wraper
       @AuraEnabled
       public static Map<string,MB_Wrapper_Class.CallsChargeType_Wraper> getCallMap(List<MB_Billing_Entity__c> beList , String usageTypeName){
       
       Map<string,MB_Wrapper_Class.CallsChargeType_Wraper> callsInnerMap=new Map<string,MB_Wrapper_Class.CallsChargeType_Wraper>();
           for(MB_Billing_Entity__c entity:beList){
               if(entity.Usage_Type__r.Name ==usageTypeName)
                {
                  if(!callsInnerMap.containsKey(entity.Charge_Type__r.Name)){
                      MB_Wrapper_Class.CallsChargeType_Wraper objData=new MB_Wrapper_Class.CallsChargeType_Wraper();
                      objData.chargeTypeName=entity.Charge_Type__r.Name;
                      if(entity.Local_Net_Amount__c !=null){
                        objData.totalSpend=entity.Local_Net_Amount__c.setScale(2);
                        callsInnerMap.put(entity.Charge_Type__r.Name,objData);
                       }
                  }
                  
                 else  if(callsInnerMap.containsKey(entity.Charge_Type__r.Name)){            
                     decimal amount=0;
                     MB_Wrapper_Class.CallsChargeType_Wraper objData=new MB_Wrapper_Class.CallsChargeType_Wraper();
                     objData=callsInnerMap.get(entity.Charge_Type__r.Name);
                     
                     if(entity.Local_Net_Amount__c !=null){
                     amount=objData.totalSpend+entity.Local_Net_Amount__c.setScale(2);
                     objData.totalSpend=amount.setScale(2);
                     callsInnerMap.remove(entity.Charge_Type__r.Name);
                     objData.chargeTypeName=entity.Charge_Type__r.Name;
                     callsInnerMap.put(entity.Charge_Type__r.Name,objData);
                     }
                }
                
               }
           }
           return callsInnerMap;
       }
       
       //Get MessagingChargeType_Wraper
       @AuraEnabled
       public static Map<string,MB_Wrapper_Class.MessagingChargeType_Wraper> getMessageMap(List<MB_Billing_Entity__c> beList , String usageTypeName){
       
            Map<string,MB_Wrapper_Class.MessagingChargeType_Wraper> messagingInnerMap= new Map<string,MB_Wrapper_Class.MessagingChargeType_Wraper>();
            for(MB_Billing_Entity__c entity:beList){
                
                if(entity.Usage_Type__r.Name ==usageTypeName)
                {
                  if(!messagingInnerMap.containsKey(entity.Charge_Type__r.Name)){
                      MB_Wrapper_Class.MessagingChargeType_Wraper objData=new MB_Wrapper_Class.MessagingChargeType_Wraper();
                      objData.chargeTypeName=entity.Charge_Type__r.Name;
                      if(entity.Local_Net_Amount__c !=null){
                      objData.totalSpend=entity.Local_Net_Amount__c.setScale(2);
                      messagingInnerMap.put(entity.Charge_Type__r.Name,objData);
                   }
                  }
                  
                  else if(messagingInnerMap.containsKey(entity.Charge_Type__r.Name)){
                     decimal amount=0;
                     MB_Wrapper_Class.MessagingChargeType_Wraper objData=messagingInnerMap.get(entity.Charge_Type__r.Name);
                     messagingInnerMap.remove(entity.Charge_Type__r.Name);
                     if(entity.Local_Net_Amount__c !=null){
                         amount=objData.totalSpend+entity.Local_Net_Amount__c.setScale(2);
                         objData.totalSpend=amount.setScale(2);
                         objData.chargeTypeName=entity.Charge_Type__r.Name;
                         messagingInnerMap.put(entity.Charge_Type__r.Name,objData);
                        }
                    }
                
                }
            }
            
            return messagingInnerMap;
       }
       
       //Get NonUsageChargeType_Wrapper
       @AuraEnabled
       public static Map<string,MB_Wrapper_Class.NonUsageChargeType_Wrapper> getNonUsageMap(List<MB_Billing_Entity__c> beList){
       
       Map<string,MB_Wrapper_Class.NonUsageChargeType_Wrapper> nonusageInnerMap=new Map<string,MB_Wrapper_Class.NonUsageChargeType_Wrapper>();         
       for(MB_Billing_Entity__c entity:beList){
         
       if(entity.Usage_Type__r.Name != MB_Constants.Usage_Type_iPass && entity.Usage_Type__r.Name !=MB_Constants.Usage_Type_Messaging && entity.Usage_Type__r.Name !=MB_Constants.Usage_Type_Calls && entity.Usage_Type__r.Name !=MB_Constants.Usage_Type_Data)
        {
            if(!nonusageInnerMap.containsKey(entity.Usage_Type__r.Name)){            
            List<MB_Billing_Entity__c> nonUsageBillingEntity=new List<MB_Billing_Entity__c>();
                for(MB_Billing_Entity__c nonUsageBE: beList){
                    if(nonUsageBE.Usage_Type__r.Name!=null && nonUsageBE.Usage_Type__r.Name!='' && nonUsageBE.Usage_Type__r.Name==entity.Usage_Type__r.Name){
                        nonUsageBillingEntity.add(nonUsageBE);
                    }
                }
                 
            decimal amt=0;
            for(MB_Billing_Entity__c billObj:nonUsageBillingEntity){
                if(billObj.Local_Net_Amount__c!=null ){                
                amt += billObj.Local_Net_Amount__c;
                }
            }
            
                MB_Wrapper_Class.NonUsageChargeType_Wrapper objData=new MB_Wrapper_Class.NonUsageChargeType_Wrapper();
                objData.chargeTypeName=entity.Usage_Type__r.Name;
                objData.totalSpend=amt;               
                nonusageInnerMap.put(entity.Usage_Type__r.Name,objData);
            }
            
        
        }     
        }
        return nonusageInnerMap;
       }
       
       
    //===============Code Optimization Ends================================
}