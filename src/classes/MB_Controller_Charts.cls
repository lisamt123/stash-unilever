/***************************************************************
Class Name: MB_Controller_Charts.cls
Copyright © 2016 Salesforce

Purpose:
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Controller class For TEM app Charts.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       17/05/2016        controller class For TEM app charts
***************************************************************/
public with sharing Class MB_Controller_Charts{
 public static final String Roaming_Type = 'Roaming';
 public static final String Colleague_Data = 'ColleagueData';
 public static final String Colleague_Calls = 'ColleagueCalls';
 public static final String Colleague_SMS = 'ColleagueSMS';
 
 public static Decimal DomesticDataUsage=0;
 public static Decimal InternationalDataUsage=0;
 public static Decimal totalDomesticCallUsage =0;
 public static Decimal totalInternationalCallUsage =0;
 public static Decimal totalDomesticSMSUsage =0;
 public static Decimal totalInternationalSMSUsage =0;
 public static Decimal totalDomesticIpassUsage=0;
 public static Decimal totalInternationalIpassUsage=0; 
 public static Decimal totalIpassUsageIn =0; 
 public static Decimal totalAverageIpassUsageIn =0; 
 
 

     public static Map<String,Decimal> getTotalData(MB_Billing_Entity__c beObj, Map<Id,string> chargeType ){ 
 
  Map<String,Decimal> datamap=new  Map<String,Decimal>();
     if(string.valueOf(chargeType.get(beObj.Charge_Type__c)).contains('Domestic')){
         if(beObj.Data_Consumed_In_MB__c!=null){
             DomesticDataUsage +=(beObj.Data_Consumed_In_MB__c).setScale(2);
         }
     }
     if(string.valueOf(chargeType.get(beObj.Charge_Type__c)).contains(Roaming_Type)){
        if(beObj.Data_Consumed_In_MB__c!=null){
             InternationalDataUsage +=(beObj.Data_Consumed_In_MB__c).setScale(2);
             System.debug('-----##--$$----'+InternationalDataUsage);
          }
     }
    datamap.put('DomesticData',DomesticDataUsage);
    datamap.put('InternationalData',InternationalDataUsage);
     System.debug('@----@'+DomesticDataUsage);
    return datamap;
 }
              
 public static Map<String,Decimal> getTotalCalls(MB_Billing_Entity__c beObj, Map<Id,string> chargeTypeMap){
 
  Map<String,Decimal> datamap=new  Map<String,Decimal>();
     if(string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Domestic')){
          if(beObj.Call_Minutes__c!=null){
            totalDomesticCallUsage +=(beObj.Call_Minutes__c).setScale(2);
        }
     }
     if(string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains(Roaming_Type)){
            if(beObj.Call_Minutes__c!=null){
               totalInternationalCallUsage += (beObj.Call_Minutes__c).setScale(2);
         }
     }
    datamap.put('DomesticCalls',totalDomesticCallUsage );
    datamap.put('InternationalCalls',totalInternationalCallUsage );
    return datamap;
 }
               
 public static Map<String,Decimal> getTotalMessage(MB_Billing_Entity__c beObj, Map<Id,string> chargeTypeMap){
  
  Map<String,Decimal> datamap=new  Map<String,Decimal>();
     if((string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Domestic') || string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('International Outgoing SMS'))  && string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('SMS')){
          if(beObj.Messages__c!=null){
            totalDomesticSMSUsage += (beObj.Messages__c).setScale(2);
             }
     }
          if(string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains(Roaming_Type) && string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('SMS')){
         if(beObj.Messages__c!=null){
            totalInternationalSMSUsage += (beObj.Messages__c).setScale(2);
          }
     }
    datamap.put('DomesticSMS',totalDomesticSMSUsage );
    datamap.put('InternationalSMS',totalInternationalSMSUsage );
    return datamap;
 }
             
 public static Map<String,Decimal> getTotaliPass(MB_Billing_Entity__c pbeObj, Map<Id,string> chargeTypeMap){
  
  Map<String,Decimal> datamap=new  Map<String,Decimal>();
     if(string.valueOf(chargeTypeMap.get(pbeObj.Charge_Type__c)).contains('Domestic')){
         if(pbeObj.Data_Consumed_In_MB__c!=null){
             totalDomesticIpassUsage+= (pbeObj.Data_Consumed_In_MB__c).setScale(2);
          }
     }
         if(string.valueOf(chargeTypeMap.get(pbeObj.Charge_Type__c)).contains(Roaming_Type)){
        if(pbeObj.Data_Consumed_In_MB__c!=null){
             totalInternationalIpassUsage+= (pbeObj.Data_Consumed_In_MB__c).setScale(2);
             System.debug('$$$$$'+totalInternationalIpassUsage);
            }
     }
    datamap.put('Domesticipass',totalDomesticIpassUsage);
    datamap.put('Internationalipass',totalInternationalIpassUsage);
    return datamap;
 }
 @AuraEnabled              
 public static MB_Wrapper_Class.MB_Device_Wrapper_Class getChargeType(String month, String deviceId) {
 
     MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj=new MB_Wrapper_Class.MB_Device_Wrapper_Class();
     wrprobj.totalDomesticDataUsage=0;
     wrprobj.totalInternationalDataUsage=0;
     wrprobj.totalDomesticCallUsage=0;
     wrprobj.totalInternationalCallUsage=0;
     wrprobj.totalDomesticSMSUsage=0;
     wrprobj.totalInternationalSMSUsage=0;
     
     Map<String,Decimal> datamap=new Map<String,Decimal>();

  string  country=[SELECT Country FROM User WHERE Id =:userinfo.getuserid() ].Country ;
  System.debug('@#$%'+country);
  List<MB_Billing_Entity__c> billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c, Data_Consumed_In_MB__c, 
                                    Device_Details__c,Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c, User__c, User_Country__c, User_Email__c
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND User_Country__c=:country AND Service_Name__c=:deviceId AND Billing_Month__c =: month]; 
                          
    List<ID> usageIDlist=new  List<ID>();
    List<ID> chargeIDlist=new  List<ID>();
    for(MB_Billing_Entity__c Idlist:billingEntityList)
    {
    usageIDlist.add(Id.valueof(Idlist.Usage_Type__c));
    chargeIDlist.add(Id.valueof(Idlist.Charge_Type__c));
    }
     List<MB_Usage_Type__c> usageList=[select id,name from MB_Usage_Type__c where Id in :usageIDlist];
     List<MB_Charge_Type__c> chargegeList=[select id ,name from MB_Charge_Type__c where Id in :chargeIDlist];

     Map<Id,string> usageTypeMap=new  Map<Id,string>();
     Map<Id,string> chargeTypeMap=new Map<Id,string>();
        for(MB_Charge_Type__c charge:chargegeList){
            chargeTypeMap.put(charge.id,string.valueof(charge.name));
         }
         
          for(MB_Usage_Type__c usage:usageList){
            usageTypeMap.put(usage.id,string.valueof(usage.name));
         }
        
    if(billingEntityList.size()>0){
        for(MB_Billing_Entity__c beObj : billingEntityList ){
           if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_Data){
            datamap=getTotalData(beObj,chargeTypeMap);
             wrprobj.totalDomesticDataUsage=datamap.get('DomesticData');
             wrprobj.totalInternationalDataUsage=datamap.get('InternationalData');
                System.debug('------@@--'+billingEntityList.Size());
             }  
           if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_Calls){
           datamap=getTotalCalls(beObj,chargeTypeMap);
           
            wrprobj.totalDomesticCallUsage=datamap.get('DomesticCalls');
            wrprobj.totalInternationalCallUsage=datamap.get('InternationalCalls');
            System.debug('----#---test--'+datamap.get('InternationalCalls'));
             }  
            if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_Messaging){
            datamap=getTotalMessage(beObj,chargeTypeMap);
             wrprobj.totalDomesticSMSUsage=datamap.get('DomesticSMS');
             wrprobj.totalInternationalSMSUsage=datamap.get('InternationalSMS');
       
             }
          }  
       } 
       
       return wrprobj;
    }
     @AuraEnabled              
 public static MB_Wrapper_Class.MB_Device_Wrapper_Class getiPassChargeType(String month, String UsageType) {
     System.debug('@mon'+month+'-----'+UsageType);
     MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj=new MB_Wrapper_Class.MB_Device_Wrapper_Class();
     wrprobj.totalDomesticIpassUsage=0;
     wrprobj.totalInternationalIpassUsage=0;
     
     
     Map<String,Decimal> datamap=new Map<String,Decimal>();

  string  country=[SELECT Country FROM User WHERE Id =:userinfo.getuserid() ].Country ;
     
  List<MB_Billing_Entity__c> iPassbillingEntityList = [SELECT Id, Name,Data_Consumed_In_MB__c, Local_Net_Amount__c,Usage_Type__c,Usage_Type__r.Name,Charge_Type__c,Charge_Type__r.Name, User__c, User_Country__c 
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND User_Country__c=:country AND Billing_Month__c =: month AND Usage_Type__r.Name=:UsageType]; 
                            
    List<ID> usageIDlist=new  List<ID>();
    List<ID> chargeIDlist=new  List<ID>();
    for(MB_Billing_Entity__c Idlist:iPassbillingEntityList )
    {
    usageIDlist.add(Id.valueof(Idlist.Usage_Type__c));
    chargeIDlist.add(Id.valueof(Idlist.Charge_Type__c));
    }
     List<MB_Usage_Type__c> usageList=[select id,name from MB_Usage_Type__c where Id in :usageIDlist];
     List<MB_Charge_Type__c> chargegeList=[select id ,name from MB_Charge_Type__c where Id in :chargeIDlist];

     Map<Id,string> usageTypeMap=new  Map<Id,string>();
     Map<Id,string> chargeTypeMap=new Map<Id,string>();
        for(MB_Charge_Type__c charge:chargegeList){
            chargeTypeMap.put(charge.id,string.valueof(charge.name));
         }
         
          for(MB_Usage_Type__c usage:usageList){
            usageTypeMap.put(usage.id,string.valueof(usage.name));
         }
        System.debug('@@'+iPassbillingEntityList.size());
        if(iPassbillingEntityList.size()>0){
        for(MB_Billing_Entity__c pbeObj : iPassbillingEntityList){
             if(string.valueOf(usageTypeMap.get(pbeObj.Usage_Type__c)) == MB_Constants.Usage_Type_iPass){
             datamap=getTotaliPass(pbeObj,chargeTypeMap);
               wrprobj.totalDomesticIpassUsage=datamap.get('Domesticipass');
               wrprobj.totalInternationalIpassUsage=datamap.get('Internationalipass');
             }  
       } }
       System.debug('@dom'+ wrprobj.totalDomesticIpassUsage+'@int'+wrprobj.totalInternationalIpassUsage);
       return wrprobj;
    }
 @AuraEnabled
     public static MB_Wrapper_Class.MB_Device_Wrapper_Class getyourCollegueChargeType(String month,String deviceId) {
     System.debug('---#----'+deviceId);
     MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj=new MB_Wrapper_Class.MB_Device_Wrapper_Class(); 
     Decimal serviceCount=0;
     wrprobj.totalDataUsage=0; 
     wrprobj.totalCallUsage=0; 
     wrprobj.totalMessageUsage=0; 
     wrprobj.totalIpassUsage=0; 
     wrprobj.totalAverageDataUsage=0;
    wrprobj.totalAverageCallUsage=0;
    wrprobj.totalAverageMessageUsage=0;
    wrprobj.totalAverageIpassUsage=0;
   Decimal totalDataavg=0;
     Decimal totalCallavg=0;
     Decimal totalMessageavg=0;
    string  country=[SELECT Country FROM User WHERE Id =:userinfo.getuserid() ].Country ; 
    
    AggregateResult[] serviceCoun = [SELECT COUNT_DISTINCT(Service_Name__c)serviceC FROM MB_Billing_Entity__c WHERE Usage_Type__r.Name != 'iPass' AND User_Country__c = :country AND Billing_Month__c = :month];
    if((Decimal)serviceCoun[0].get('serviceC')>0){
     serviceCount=((Decimal)serviceCoun[0].get('serviceC')).setScale(2);
     }
    wrprobj=getColleageAverage(month,country,wrprobj,deviceId);
    //code for Average Calculation
     AggregateResult[] totalData=[SELECT SUM(Data_Consumed_In_MB__c)Avg_Data from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Data];   
     if((Decimal)totalData[0].get('Avg_Data')>0){
       totalDataavg=((Decimal)totalData[0].get('Avg_Data')).setScale(2);
     }
     AggregateResult[] totalCall=[SELECT SUM(Call_Minutes__c)Avg_Call from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country  AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Calls];   
     if((Decimal)totalCall[0].get('Avg_Call')>0){
       totalCallavg=((Decimal)totalCall[0].get('Avg_Call')).setScale(2);  
     }
     AggregateResult[] totalMessage=[SELECT SUM(Messages__c)Avg_message from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND  Usage_Type__r.Name= :MB_Constants.Usage_Type_Messaging];   
     if((Decimal)totalMessage[0].get('Avg_message')>0){
       totalMessageavg=((Decimal)totalMessage[0].get('Avg_message')).setScale(2);
     }
    if(serviceCount>0){
       if(totalDataavg>0){
       wrprobj.totalAverageDataUsage=(totalDataavg/serviceCount).setScale(2) ;
       }
       if(totalCallavg>0){
       wrprobj.totalAverageCallUsage=(totalCallavg/serviceCount).setScale(2);
       }
       if(totalMessageavg>0){  
       wrprobj.totalAverageMessageUsage=(totalMessageavg/serviceCount).setScale(2);
       }
     }
     else{
        wrprobj.totalAverageDataUsage=totalDataavg.setScale(2) ;
        wrprobj.totalAverageCallUsage=totalCallavg.setScale(2);
        wrprobj.totalAverageMessageUsage=totalMessageavg.setScale(2);
     }
return wrprobj;
    
}
public static MB_Wrapper_Class.MB_Device_Wrapper_Class getColleageAverage(String month,String country, MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj, string deviceId) {
    
      AggregateResult[] totalDataUsageIn=[SELECT SUM(Data_Consumed_In_MB__c)Total_data from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND User__c =: UserInfo.getUserId() AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Data AND Service_Name__c=:deviceId];   
     if((Decimal)totalDataUsageIn[0].get('Total_data')>0){
      wrprobj.totalDataUsage=((Decimal)totalDataUsageIn[0].get('Total_data')).setScale(2);
     }
     AggregateResult[] totalCallUsageIn=[SELECT SUM(Call_Minutes__c)Total_Call from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND User__c =: UserInfo.getUserId() AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Calls AND Service_Name__c=:deviceId];   
     if((Decimal)totalCallUsageIn[0].get('Total_Call')>0){
      wrprobj.totalCallUsage=((Decimal)totalCallUsageIn[0].get('Total_Call')).setScale(2);  
     }
     AggregateResult[] totalMessageUsageIn=[SELECT SUM(Messages__c)Total_Message from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND User__c =: UserInfo.getUserId() AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Messaging AND Service_Name__c=:deviceId];   
     if((Decimal)totalMessageUsageIn[0].get('Total_Message')>0){
      wrprobj.totalMessageUsage=((Decimal)totalMessageUsageIn[0].get('Total_Message')).setScale(2);
     }
     AggregateResult[] totalIpassUsageIn1=[SELECT SUM(Data_Consumed_In_MB__c)Data_Consumed from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND User__c =: UserInfo.getUserId() AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Data AND Charge_Type__r.Name LIKE :Roaming_Type+'%'];   
     if((Decimal)totalIpassUsageIn1[0].get('Data_Consumed') >0){
      wrprobj.totalIpassUsage=((Decimal)totalIpassUsageIn1[0].get('Data_Consumed')).setScale(2); 
      
     }System.debug('%%###'+wrprobj.totalIpassUsageIn); 
     AggregateResult[] totalAverageIpassUsageIn1=[SELECT SUM(Data_Consumed_In_MB__c)Ipass_Consumed from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND User__c =: UserInfo.getUserId() AND Usage_Type__r.Name= :MB_Constants.Usage_Type_iPass AND Charge_Type__r.Name LIKE :'%'+Roaming_Type+'%'];   
     if((Decimal)totalAverageIpassUsageIn1[0].get('Ipass_Consumed')>0){
      wrprobj.totalAverageIpassUsage=((Decimal)totalAverageIpassUsageIn1[0].get('Ipass_Consumed')).setScale(2);  
     }
     System.debug('@data'+wrprobj.totalDataUsage);
   return wrprobj;
     }

 @AuraEnabled
     public static MB_Wrapper_Class.MB_Device_Wrapper_Class getInsights(String month) {
     System.debug('%%'+month);
     MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj=new MB_Wrapper_Class.MB_Device_Wrapper_Class(); 
     wrprobj.totalIpassUsageIn=0;   
     wrprobj.totalAverageDataUsageIn=0;
     wrprobj.totalAverageCallUsageIn=0;
     wrprobj.totalAverageMessageUsageIn=0;
     wrprobj.totalAverageIpassUsageIn=0;
     wrprobj.totalDataUsageIn=0; 
     wrprobj.totalCallUsageIn=0; 
     wrprobj.totalMessageUsageIn=0;
     Integer UserCount=0;
     Decimal totalDataavg=0;
     Decimal totalCallavg=0;
     Decimal totalMessageavg=0;
     string  country=[SELECT Country FROM User WHERE Id =:userinfo.getuserid() ].Country ; 
      List<MB_Billing_Entity__c> userList=[select Id,User__c from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country];
      Set<Id> userIdSet=new Set<Id>();
      for(MB_Billing_Entity__c userl:userList)
      { 
       if(userl.User__c !=null){
        userIdSet.add(userl.User__c);
        System.debug('@testUser'+userl.User__c);
        }
      }
      UserCount=userIdSet.Size();
     System.debug('@testUser'+UserCount);
     //code for Sum Calculation
     wrprobj=getTotalInsights(month,country,wrprobj);
    
     
     //code for Average Calculation
     AggregateResult[] totalData=[SELECT SUM(Data_Consumed_In_MB__c)Avg_Data from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Data];   
     if((Decimal)totalData[0].get('Avg_Data')>0){
       totalDataavg=((Decimal)totalData[0].get('Avg_Data')).setScale(2);
     }
     AggregateResult[] totalCall=[SELECT SUM(Call_Minutes__c)Avg_Call from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country  AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Calls];   
     if((Decimal)totalCall[0].get('Avg_Call')>0){
       totalCallavg=((Decimal)totalCall[0].get('Avg_Call')).setScale(2);  
     }
     AggregateResult[] totalMessage=[SELECT SUM(Messages__c)Avg_message from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND  Usage_Type__r.Name= :MB_Constants.Usage_Type_Messaging];   
     if((Decimal)totalMessage[0].get('Avg_message')>0){
       totalMessageavg=((Decimal)totalMessage[0].get('Avg_message')).setScale(2);
     }
     if(UserCount>0){
       if(totalDataavg >0){
       wrprobj.totalAverageDataUsageIn=(totalDataavg/UserCount).setScale(2); System.debug('@user1'+wrprobj.totalAverageDataUsageIn);
       }
       if(totalCallavg >0){
       wrprobj.totalAverageCallUsageIn=(totalCallavg/UserCount).setScale(2); System.debug('@user1'+wrprobj.totalAverageCallUsageIn);
       }
       if(totalMessageavg >0){  
       wrprobj.totalAverageMessageUsageIn=(totalMessageavg/UserCount).setScale(2);
       }
     }
     else{
       wrprobj.totalAverageDataUsageIn=totalDataavg.setScale(2);System.debug('@user2'+wrprobj.totalAverageDataUsageIn);
       wrprobj.totalAverageCallUsageIn=totalCallavg.setScale(2);   System.debug('@user1'+wrprobj.totalAverageCallUsageIn);
       wrprobj.totalAverageMessageUsageIn=totalMessageavg.setScale(2);
     }
     
     return wrprobj;
    
}
 public static MB_Wrapper_Class.MB_Device_Wrapper_Class getTotalInsights(String month,String country, MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj) {
     System.debug('%%'+month+country);
     /*MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj=new MB_Wrapper_Class.MB_Device_Wrapper_Class(); 
     wrprobj.totalDataUsageIn=0; 
     wrprobj.totalCallUsageIn=0; 
     wrprobj.totalMessageUsageIn=0; */
     
      AggregateResult[] totalDataUsageIn=[SELECT SUM(Data_Consumed_In_MB__c)Total_data from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND User__c =: UserInfo.getUserId() AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Data];   
     if((Decimal)totalDataUsageIn[0].get('Total_data')>0){
      wrprobj.totalDataUsageIn=((Decimal)totalDataUsageIn[0].get('Total_data')).setScale(2);
     }
     AggregateResult[] totalCallUsageIn=[SELECT SUM(Call_Minutes__c)Total_Call from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND User__c =: UserInfo.getUserId() AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Calls];   
     if((Decimal)totalCallUsageIn[0].get('Total_Call')>0){
      wrprobj.totalCallUsageIn=((Decimal)totalCallUsageIn[0].get('Total_Call')).setScale(2);  
     }
     AggregateResult[] totalMessageUsageIn=[SELECT SUM(Messages__c)Total_Message from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND User__c =: UserInfo.getUserId() AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Messaging];   
     if((Decimal)totalMessageUsageIn[0].get('Total_Message')>0){
      wrprobj.totalMessageUsageIn=((Decimal)totalMessageUsageIn[0].get('Total_Message')).setScale(2);
     }
     AggregateResult[] totalIpassUsageIn1=[SELECT SUM(Data_Consumed_In_MB__c)Data_Consume from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND User__c =: UserInfo.getUserId() AND Usage_Type__r.Name= :MB_Constants.Usage_Type_Data AND Charge_Type__r.Name LIKE :Roaming_Type+'%'];   
     System.debug('%%##1'+(Decimal)totalIpassUsageIn1[0].get('Data_Consume')); 
     if((Decimal)totalIpassUsageIn1[0].get('Data_Consume') >0){
      wrprobj.totalIpassUsageIn=((Decimal)totalIpassUsageIn1[0].get('Data_Consume')).setScale(2); 
      
     }System.debug('%%###'+wrprobj.totalIpassUsageIn); 
     AggregateResult[] totalAverageIpassUsageIn1=[SELECT SUM(Data_Consumed_In_MB__c)Ipass_Consumed from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country AND User__c =: UserInfo.getUserId() AND Usage_Type__r.Name= :MB_Constants.Usage_Type_iPass AND Charge_Type__r.Name LIKE :'%'+Roaming_Type+'%'];   
     if((Decimal)totalAverageIpassUsageIn1[0].get('Ipass_Consumed')>0){
      wrprobj.totalAverageIpassUsageIn=((Decimal)totalAverageIpassUsageIn1[0].get('Ipass_Consumed')).setScale(2);  
     }
   return wrprobj;
     }
}