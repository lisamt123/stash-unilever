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
 public static Decimal DomesticDataUsage=0;
 public static Decimal InternationalDataUsage=0;
 public static Decimal totalDomesticCallUsage =0;
 public static Decimal totalInternationalCallUsage =0;
 public static Decimal totalDomesticSMSUsage =0;
 public static Decimal totalInternationalSMSUsage =0;
 public static Decimal totalDomesticIpassUsage=0;
 public static Decimal totalInternationalIpassUsage=0; 
 public static Decimal AverageDataUsage=0;
 public static Decimal AverageCallUsage=0;
 public static Decimal AverageMessageUsage=0;
 public static Decimal AverageIpassUsage=0;
 public static Decimal DataUsage =0;
 public static Decimal CallUsage =0;
 public static Decimal MessageUsage =0;
 public static Decimal IpassUsage =0;
     public static Map<String,Decimal> getTotalData(MB_Billing_Entity__c beObj, Map<Id,string> chargeType ){ 
 
  Map<String,Decimal> datamap=new  Map<String,Decimal>();
     if(string.valueOf(chargeType.get(beObj.Charge_Type__c)).contains('Domestic')==true){
         if(beObj.Data_Consumed_In_MB__c!=null){
             DomesticDataUsage +=(beObj.Data_Consumed_In_MB__c).setScale(2);
         }
     }
     if(string.valueOf(chargeType.get(beObj.Charge_Type__c)).contains('Roaming')==true){
        if(beObj.Data_Consumed_In_MB__c!=null){
             InternationalDataUsage +=(beObj.Data_Consumed_In_MB__c).setScale(2);
          }
     }
    datamap.put('DomesticData',DomesticDataUsage);
    datamap.put('InternationalData',InternationalDataUsage);
     System.debug('@----@'+DomesticDataUsage);
    return datamap;
 }
              
 public static Map<String,Decimal> getTotalCalls(MB_Billing_Entity__c beObj, Map<Id,string> chargeTypeMap){
 
  Map<String,Decimal> datamap=new  Map<String,Decimal>();
     if(string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Domestic')==true){
          if(beObj.Call_Minutes__c!=null){
            totalDomesticCallUsage +=(beObj.Call_Minutes__c).setScale(2);
        }
     }
     if(string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Roaming')==true){
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
     if(string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Domestic')==true && string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('SMS')==true){
          if(beObj.Messages__c!=null){
            totalDomesticSMSUsage += (beObj.Messages__c).setScale(2);
             }
     }
          if(string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Roaming')==true && string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('SMS')==true){
         if(beObj.Messages__c!=null){
            totalInternationalSMSUsage += (beObj.Messages__c).setScale(2);
          }
     }
    datamap.put('DomesticSMS',totalDomesticSMSUsage );
    datamap.put('InternationalSMS',totalInternationalSMSUsage );
    return datamap;
 }
             
 public static Map<String,Decimal> getTotaliPass(MB_Billing_Entity__c beObj, Map<Id,string> chargeTypeMap){
  
  Map<String,Decimal> datamap=new  Map<String,Decimal>();
     if(string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Domestic')==true){
         if(beObj.iPass_Consumed_In_MB__c!=null){
             totalDomesticIpassUsage+= (beObj.iPass_Consumed_In_MB__c).setScale(2);
          }
     }
         if(string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Roaming')==true){
        if(beObj.iPass_Consumed_In_MB__c!=null){
             totalInternationalIpassUsage+= (beObj.iPass_Consumed_In_MB__c).setScale(2);
            }
     }
    datamap.put('Domesticipass',totalDomesticIpassUsage);
    datamap.put('Internationalipass',totalInternationalIpassUsage);
    return datamap;
 }
 public static Map<String,Decimal> getColleagueTotalUsage(MB_Billing_Entity__c AvgofCollegueData, Map<Id,string> usageTypeMap){
 
           if(AvgofCollegueData.Data_Consumed_In_MB__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_Data){
               AverageDataUsage+=AvgofCollegueData.Data_Consumed_In_MB__c;  
           }
           if(AvgofCollegueData.Call_Minutes__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_Calls){
               AverageCallUsage+=AvgofCollegueData.Call_Minutes__c; 
           }
           if(AvgofCollegueData.Messages__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_Messaging){
               AverageMessageUsage+=AvgofCollegueData.Messages__c;  
           }  
           if(AvgofCollegueData.iPass_Consumed_In_MB__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_iPass){
                AverageIpassUsage+=AvgofCollegueData.iPass_Consumed_In_MB__c ; 
           }
     Map<String,Decimal> getColleagueTotalMap=new Map<String,Decimal>();
     getColleagueTotalMap.put('ColleagueData',AverageDataUsage);
     getColleagueTotalMap.put('ColleagueCalls',AverageCallUsage);
     getColleagueTotalMap.put('ColleagueSMS',AverageMessageUsage);
     getColleagueTotalMap.put('Colleagueipass',AverageIpassUsage);
     
     return getColleagueTotalMap;
 }
  public static Map<String,Decimal> getUserTotalUsage(MB_Billing_Entity__c AvgofCollegueData, Map<Id,string> usageTypeMap){
 
         if(AvgofCollegueData.Data_Consumed_In_MB__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_Data){  
           DataUsage +=AvgofCollegueData.Data_Consumed_In_MB__c;
           System.debug('-------$$----'+DataUsage );
          }
         if(AvgofCollegueData.Call_Minutes__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_Calls){ 
           CallUsage +=AvgofCollegueData.Call_Minutes__c;
           System.debug('-------$$----'+CallUsage );
          }
         if(AvgofCollegueData.Messages__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_Messaging){ 
           MessageUsage +=AvgofCollegueData.Messages__c;
           System.debug('-------$$----'+MessageUsage );
          }
         if(AvgofCollegueData.iPass_Consumed_In_MB__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_iPass){
           IpassUsage +=AvgofCollegueData.iPass_Consumed_In_MB__c;
           System.debug('-------$$----'+IpassUsage );
           }
     Map<String,Decimal> getUserTotalMap=new Map<String,Decimal>();
     getUserTotalMap.put('UserData',DataUsage );
     getUserTotalMap.put('UserCalls',CallUsage );
     getUserTotalMap.put('UserSMS',MessageUsage );
     getUserTotalMap.put('Useripass',IpassUsage );
     System.debug('@@##'+getUserTotalMap.size());
     return getUserTotalMap;
 }
 
 @AuraEnabled              
 public static MB_Wrapper_Class.MB_Device_Wrapper_Class getChargeType(String month, ID deviceId) {
     MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj=new MB_Wrapper_Class.MB_Device_Wrapper_Class();
     wrprobj.totalDomesticDataUsage=0;
     wrprobj.totalInternationalDataUsage=0;
     wrprobj.totalDomesticCallUsage=0;
     wrprobj.totalInternationalCallUsage=0;
     wrprobj.totalDomesticSMSUsage=0;
     wrprobj.totalInternationalSMSUsage=0;
     wrprobj.totalDomesticIpassUsage=0;
     wrprobj.totalInternationalIpassUsage=0;
     
     
     Map<String,Decimal> datamap=new Map<String,Decimal>();

  string  country=[SELECT Country FROM User WHERE Id =:userinfo.getuserid() ].Country ;
  System.debug('@#$%'+country);
  List<MB_Billing_Entity__c> billingEntityList = [SELECT Id, Name, Billing_Currency__c, Billing_Month__c, Call_Minutes__c, Charge_Type__c, Data_Consumed_In_MB__c, 
                                    Device_Details__c, iPass_Consumed_In_MB__c, Item_Count__c, Local_Net_Amount__c, Messages__c, Non_Usage_Consumed__c, 
                                    Service_Name__c, Usage_Type__c, User__c, User_Country__c, User_Email__c
                                    FROM MB_Billing_Entity__c where User__c =: UserInfo.getUserId() AND User_Country__c=:country AND Device_Details__c =:deviceId AND Billing_Month__c =: month]; 
                              
  
    List<MB_Wrapper_Class.MB_Device_Wrapper_Class> lst=new List<MB_Wrapper_Class.MB_Device_Wrapper_Class>();
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
                System.debug('-------test--'+datamap.get('DomesticData'));
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
           if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_iPass){
             datamap=getTotaliPass(beObj,chargeTypeMap);
               wrprobj.totalDomesticIpassUsage=datamap.get('Domesticipass');
               wrprobj.totalInternationalIpassUsage=datamap.get('Internationalipass');
             } 
          }  
       } 
       
       return wrprobj;
    }
    @AuraEnabled
     public static MB_Wrapper_Class.MB_Device_Wrapper_Class getyourCollegueChargeType(String month) {
     MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj=new MB_Wrapper_Class.MB_Device_Wrapper_Class(); 
     wrprobj.totalDataUsage=0; 
     wrprobj.totalCallUsage=0; 
     wrprobj.totalMessageUsage=0; 
     wrprobj.totalIpassUsage=0; 
     wrprobj.totalAverageDataUsage=0;
    wrprobj.totalAverageCallUsage=0;
    wrprobj.totalAverageMessageUsage=0;
    wrprobj.totalAverageIpassUsage=0;
    string  country=[SELECT Country FROM User WHERE Id =:userinfo.getuserid() ].Country ; 
    Map<String,Decimal> getColleagueTotalMap=new Map<String,Decimal>();
    Map<String,Decimal> getUserTotalMap =new Map<String,Decimal>();
        Integer UserCount=0;
       
       List<MB_Billing_Entity__c> lstCollegueChargeType=[Select Data_Consumed_In_MB__c,Usage_Type__c,Charge_Type__c,User__c,Call_Minutes__c,Messages__c,iPass_Consumed_In_MB__c from MB_Billing_Entity__c where Billing_Month__c =: month AND User_Country__c=:country ];   
       Set<Id> userIdSet=new Set<Id>();
        List<ID> usageIDlist=new  List<ID>();
    List<ID> chargeIDlist=new  List<ID>();
    for(MB_Billing_Entity__c Idlist:lstCollegueChargeType)
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
        
       for(MB_Billing_Entity__c CollegueData:lstCollegueChargeType){
       userIdSet.add(CollegueData.User__c);System.debug('!@#$!'+CollegueData.User__c);
       }
       UserCount=userIdSet.Size()-1;System.debug('----&---1--'+UserCount);
       
       if(lstCollegueChargeType.size()>0)   {
       for(MB_Billing_Entity__c AvgofCollegueData:lstCollegueChargeType)
       {   System.debug('----&---11--'+UserCount);
      if(AvgofCollegueData.User__c != UserInfo.getUserId()){
          
     /*calling method*/  
     getColleagueTotalMap = getColleagueTotalUsage(AvgofCollegueData,usageTypeMap);
       
        if(UserCount>0){
             wrprobj.totalAverageDataUsage=(getColleagueTotalMap.get('ColleagueData')/UserCount).setScale(2);
        }
        else{ 
             wrprobj.totalAverageDataUsage=getColleagueTotalMap.get('ColleagueData').setScale(2);   
        }   
        if(UserCount>0){
                 wrprobj.totalAverageCallUsage=(getColleagueTotalMap.get('ColleagueCalls')/UserCount).setScale(2); 
        }
        else{
             wrprobj.totalAverageCallUsage=getColleagueTotalMap.get('ColleagueCalls').setScale(2);
        }
        if(UserCount>0){
              System.debug('----&---4--'+UserCount);
             wrprobj.totalAverageMessageUsage=(getColleagueTotalMap.get('ColleagueSMS')/UserCount).setScale(2); 
             System.debug('----&---5--'+wrprobj.totalAverageMessageUsage);
        }
        else{
             wrprobj.totalAverageMessageUsage=getColleagueTotalMap.get('ColleagueSMS').setScale(2);
        }
        if(UserCount>0){
             wrprobj.totalAverageIpassUsage=(getColleagueTotalMap.get('Colleagueipass')/UserCount).setScale(2);  
        }
        else{
             wrprobj.totalAverageIpassUsage=getColleagueTotalMap.get('Colleagueipass').setScale(2);
        }
            }
      
        
            if(AvgofCollegueData.User__c ==UserInfo.getUserId()){
               getUserTotalMap = getUserTotalUsage(AvgofCollegueData,usageTypeMap);
               System.debug('@@##'+getUserTotalMap.get('UserData').setScale(2));
                  wrprobj.totalDataUsage=(getUserTotalMap.get('UserData')).setScale(2) ; 
                  wrprobj.totalCallUsage=(getUserTotalMap.get('UserCalls')).setScale(2) ; 
                  wrprobj.totalMessageUsage=(getUserTotalMap.get('UserSMS')).setScale(2) ; 
                  wrprobj.totalIpassUsage=(getUserTotalMap.get('Useripass')).setScale(2) ;
              }
        }
        
             
      return wrprobj;
         
    }
    return null;
    
}
}