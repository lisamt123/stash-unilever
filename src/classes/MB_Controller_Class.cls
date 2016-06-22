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
                                    Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c,iPass_Consumed_In_MB__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c, User__c, User_Country__c, User_Email__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c =:month]; 
                                  
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
        List<MB_Billing_Entity__c> lstyourChargeType=[Select Usage_Type__r.Name, Billing_Currency__c,Data_Consumed_In_MB__c,Call_Minutes__c,Messages__c,Local_Net_Amount__c,iPass_Consumed_In_MB__c,Billing_Month__c from MB_Billing_Entity__c where Billing_Month__c in (:month,:previousMonth) and User__c=:UserInfo.getUserId()];   
        List<MB_Billing_Entity__c> currentMnthList=new List<MB_Billing_Entity__c> ();
        for(MB_Billing_Entity__c item:lstyourChargeType){
         if(item.Billing_Month__c ==month){
           currentMnthList.add(item);
         }
        }
        if(currentMnthList.size()>0){
        for(MB_Billing_Entity__c CurrentUserData:lstyourChargeType)
        {
          updateMonthDataUsage(CurrentUserData,month,previousMonth);

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
	   
	   public static void updateMonthDataUsage(MB_Billing_Entity__c CurrentUserData, String month, String previousMonth){
	   
			if(CurrentUserData.Billing_Month__c ==month){
             if(CurrentUserData.Local_Net_Amount__c !=null){
              totalSpend=totalSpend+CurrentUserData.Local_Net_Amount__c; 
                wrprobj.userCurrency=CurrencySym();
              }
          if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Data){
                DataUsage +=CurrentUserData.Data_Consumed_In_MB__c;
           }
           if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Calls){
              CallUsage +=CurrentUserData.Call_Minutes__c;
           }
           if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Messaging){
              MessageUsage +=CurrentUserData.Messages__c;
           }
           if(CurrentUserData.Usage_Type__r.Name == MB_Constants.Usage_Type_iPass){
              IpassUsage +=CurrentUserData.iPass_Consumed_In_MB__c;
            }
          }
           
           if(CurrentUserData.Billing_Month__c ==previousMonth){
           
           if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Data){
               previousDataUsage +=CurrentUserData.Data_Consumed_In_MB__c;
           }
           if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Calls){
             previousCallUsage +=CurrentUserData.Call_Minutes__c;
           }
           if(CurrentUserData.Usage_Type__r.Name ==MB_Constants.Usage_Type_Messaging){
             previousMessageUsage +=CurrentUserData.Messages__c;
           }
           if(CurrentUserData.Usage_Type__r.Name == MB_Constants.Usage_Type_iPass){
              previousIpassUsage +=CurrentUserData.iPass_Consumed_In_MB__c; 
            }
         
             }    
	   
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
   
   /*******************************************************************************************************
    * @description This method returns total spend of a user device for a particular month.
    * @param  month, device Id
    * @return decimal  
    */ 
    
      @AuraEnabled
   public static MB_Wrapper_Class  getSpendDetails(string deviceId,string month){
  // public static  MB_Wrapper_Class.MB_Device_Wrapper_Class  getSpendDetails(string deviceId,string month){
  System.debug('deviceId--->'+deviceId+',,,month--->'+month);
       string previous=getPreviousMonth(month);
       List<MB_Billing_Entity__c> billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c,Charge_Type__r.Name, Data_Consumed_In_MB__c, 
                                    Device_Details__c, Device_Details__r.Name,Device_Details__r.Photo_URL__c,iPass_Consumed_In_MB__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c,Usage_Type__r.Name, User__c, User_Country__c, User_Email__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND Billing_Month__c in (:month,:previous) AND Device_Details__c=:deviceId]; 
    
       
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
       
       Map<string,MB_Wrapper_Class.DataChargeType_Wraper> dataMap=new Map<string,MB_Wrapper_Class.DataChargeType_Wraper>();
       Map<string,MB_Wrapper_Class.CallsChargeType_Wraper> callsMap=new Map<string,MB_Wrapper_Class.CallsChargeType_Wraper>();
       Map<string,MB_Wrapper_Class.MessagingChargeType_Wraper> messagingMap= new Map<string,MB_Wrapper_Class.MessagingChargeType_Wraper>();
       Map<string,MB_Wrapper_Class.IpassChargeType_Wraper> ipassMap=new  Map<string,MB_Wrapper_Class.IpassChargeType_Wraper>();
       Map<string,MB_Wrapper_Class.NonUsageChargeType_Wrapper> nonusageMap=new Map<string,MB_Wrapper_Class.NonUsageChargeType_Wrapper>();
       
       for(MB_Billing_Entity__c entity:currentmonthBillingList)
       {
        if(entity.Usage_Type__r.Name ==MB_Constants.Usage_Type_Data)
        {
          
          if(!dataMap.containsKey(entity.Charge_Type__r.Name)){
              MB_Wrapper_Class.DataChargeType_Wraper objData=new MB_Wrapper_Class.DataChargeType_Wraper();
              objData.chargeTypeName=entity.Charge_Type__r.Name;
              if(entity.Local_Net_Amount__c !=null){
                objData.totalSpend=entity.Local_Net_Amount__c.setScale(2);
                dataMap.put(entity.Charge_Type__r.Name,objData);
            }
          }
          
          else if(dataMap.containsKey(entity.Charge_Type__r.Name)){
             decimal amount=0;
             MB_Wrapper_Class.DataChargeType_Wraper objData=dataMap.get(entity.Charge_Type__r.Name);
             dataMap.remove(entity.Usage_Type__r.Name);
             if(entity.Local_Net_Amount__c !=null  )
             {
              
               amount=objData.totalSpend+entity.Local_Net_Amount__c.setScale(2);
             }
             objData.totalSpend=amount.setScale(2);
             objData.chargeTypeName=entity.Charge_Type__r.Name;
             dataMap.put(entity.Charge_Type__r.Name,objData);
        }
        
       }
       
       if(entity.Usage_Type__r.Name ==MB_Constants.Usage_Type_Calls)
        {
          if(!callsMap.containsKey(entity.Charge_Type__r.Name)){
              MB_Wrapper_Class.CallsChargeType_Wraper objData=new MB_Wrapper_Class.CallsChargeType_Wraper();
              objData.chargeTypeName=entity.Charge_Type__r.Name;
              if(entity.Local_Net_Amount__c !=null){
                objData.totalSpend=entity.Local_Net_Amount__c.setScale(2);
                callsMap.put(entity.Charge_Type__r.Name,objData);
               }
          }
          
         else  if(callsMap.containsKey(entity.Charge_Type__r.Name)){
             system.debug('###'+callsMap.get(entity.Charge_Type__r.Name));
             system.debug('###'+entity.Local_Net_Amount__c);
             
             decimal amount=0;
             MB_Wrapper_Class.CallsChargeType_Wraper objData=new MB_Wrapper_Class.CallsChargeType_Wraper();
             objData=callsMap.get(entity.Charge_Type__r.Name);
             system.debug('****'+callsMap.get(entity.Usage_Type__r.Name));
             if(entity.Local_Net_Amount__c !=null){
             amount=objData.totalSpend+entity.Local_Net_Amount__c.setScale(2);
             objData.totalSpend=amount.setScale(2);
             callsMap.remove(entity.Charge_Type__r.Name);
             objData.chargeTypeName=entity.Charge_Type__r.Name;
             callsMap.put(entity.Charge_Type__r.Name,objData);
             }
        }
        
       }
       
       if(entity.Usage_Type__r.Name ==MB_Constants.Usage_Type_Messaging)
        {
          if(!messagingMap.containsKey(entity.Charge_Type__r.Name)){
              MB_Wrapper_Class.MessagingChargeType_Wraper objData=new MB_Wrapper_Class.MessagingChargeType_Wraper();
              objData.chargeTypeName=entity.Charge_Type__r.Name;
              if(entity.Local_Net_Amount__c !=null){
              objData.totalSpend=entity.Local_Net_Amount__c.setScale(2);
              messagingMap.put(entity.Charge_Type__r.Name,objData);
           }
          }
          
          else if(messagingMap.containsKey(entity.Charge_Type__r.Name)){
             decimal amount=0;
             MB_Wrapper_Class.MessagingChargeType_Wraper objData=messagingMap.get(entity.Charge_Type__r.Name);
             messagingMap.remove(entity.Charge_Type__r.Name);
             if(entity.Local_Net_Amount__c !=null){
             amount=objData.totalSpend+entity.Local_Net_Amount__c.setScale(2);
             objData.totalSpend=amount.setScale(2);
             objData.chargeTypeName=entity.Charge_Type__r.Name;
             messagingMap.put(entity.Charge_Type__r.Name,objData);
        }}
        
       }
       
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
       
       if(entity.Usage_Type__r.Name ==MB_Constants.Usage_Type_Recurring)
        {
          if(!nonusageMap.containsKey(entity.Charge_Type__r.Name)){
              MB_Wrapper_Class.NonUsageChargeType_Wrapper objData=new MB_Wrapper_Class.NonUsageChargeType_Wrapper();
              
              objData.chargeTypeName=entity.Charge_Type__r.Name;
              if(entity.Local_Net_Amount__c !=null){
              objData.totalSpend=entity.Local_Net_Amount__c.setScale(2);
              nonusageMap.put(entity.Charge_Type__r.Name,objData);
            }
          }
          
          else if(nonusageMap.containsKey(entity.Charge_Type__r.Name)){
             decimal amount=0;
             MB_Wrapper_Class.NonUsageChargeType_Wrapper objData=nonusageMap.get(entity.Charge_Type__r.Name);
             nonusageMap.remove(entity.Charge_Type__r.Name);
             if(entity.Local_Net_Amount__c !=null){
             amount=objData.totalSpend+entity.Local_Net_Amount__c.setScale(2);
             objData.totalSpend=amount.setScale(2);
            
             objData.chargeTypeName=entity.Charge_Type__r.Name;
             nonusageMap.put(entity.Charge_Type__r.Name,objData);
           }}
        
         }
       
        }
    
        MB_Wrapper_Class objWrapper=new MB_Wrapper_Class();
        objWrapper.dataWrapperList=dataMap.values();
        objWrapper.callsWrapperList=callsMap.values();
        objWrapper.messageWrapperList=messagingMap.values();
        objWrapper.ipassWrapperList=ipassMap.values();
        objWrapper.nonusageWrapperList=nonusageMap.values();
        system.debug('@@@@'+objWrapper.ipassWrapperList.size());
        
        previousDataUsage =0;
        previousCallUsage =0; 
        previousMessageUsage =0;
        previousIpassUsage =0;
        previousnonUsage =0;
        previouSpend =0;
        
         previousDataUsage=totalDeviceUsageSpend(previousmonthBillingList,MB_Constants.Usage_Type_Data).setScale(2);
         previousCallUsage=totalDeviceUsageSpend(previousmonthBillingList,MB_Constants.Usage_Type_Calls).setScale(2);
         previousMessageUsage=totalDeviceUsageSpend(previousmonthBillingList,MB_Constants.Usage_Type_Messaging).setScale(2);
         previousIpassUsage=totalDeviceUsageSpend(previousmonthBillingList,MB_Constants.Usage_Type_iPass).setScale(2);
         previousnonUsage=totalDeviceUsageSpend(previousmonthBillingList,MB_Constants.Usage_Type_Recurring).setScale(2);
         previouSpend=totalDeviceSpend(previousmonthBillingList,deviceId).setScale(2);
        
        MB_Wrapper_Class.MB_Device_Wrapper_Class objdevice=new MB_Wrapper_Class.MB_Device_Wrapper_Class();
        objdevice.userCurrency=CurrencySym();
        objdevice.userName=userinfo.getfirstname();
        objdevice.totalDataUsage=totalDeviceUsageSpend(currentmonthBillingList,MB_Constants.Usage_Type_Data).setScale(2);
        objdevice.totalCallUsage=totalDeviceUsageSpend(currentmonthBillingList,MB_Constants.Usage_Type_Calls).setScale(2);
       System.debug('Total Call Usage-->'+objdevice.totalCallUsage);
        objdevice.totalMessageUsage=totalDeviceUsageSpend(currentmonthBillingList,MB_Constants.Usage_Type_Messaging).setScale(2);
        objdevice.totalIpassUsage=totalDeviceUsageSpend(currentmonthBillingList,MB_Constants.Usage_Type_iPass).setScale(2);
        objdevice.totalnonUsage=totalDeviceUsageSpend(currentmonthBillingList,MB_Constants.Usage_Type_Recurring).setScale(2);
        objdevice.totalUsage=totalDeviceSpend(currentmonthBillingList,deviceId).setScale(2);
        objdevice.dataVariance=getVariance(objdevice.totalDataUsage,previousDataUsage);
        objdevice.callVariance=getVariance(objdevice.totalCallUsage,previousCallUsage);
        objdevice.smsVariance=getVariance(objdevice.totalMessageUsage,previousMessageUsage);
        objdevice.ipassVariance=getVariance(objdevice.totalIpassUsage,previousIpassUsage);
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
}