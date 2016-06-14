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
      
 @AuraEnabled              
 public static MB_Wrapper_Class.MB_Device_Wrapper_Class getChargeType(String month, ID deviceId) {
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
         decimal DomesticDataUsage  =0;
            decimal InternationalDataUsag=0;
            decimal DomesticCallUsage=0;
            decimal DomesticSMSUsage =0;
            decimal  DomesticIpassUsage =0; 
            decimal  InternationalCallUsage=0;
            decimal  InternationalSMSUsage =0;
            decimal  InternationalIpassUsage=0; 
    if(billingEntityList.size()>0){
        for(MB_Billing_Entity__c beObj : billingEntityList ){
           if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_Data && string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Domestic')==true){
               DomesticDataUsage  += beObj.Data_Consumed_In_MB__c;
             }
           if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_Data  && string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('International')==true){
               InternationalDataUsag+= beObj.Data_Consumed_In_MB__c;
             }   
           if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_Calls && string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Domestic')==true){
               DomesticCallUsage+= beObj.Call_Minutes__c;
             }
           if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_Calls && string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('International')==true){
               InternationalCallUsage+= beObj.Call_Minutes__c;
             }    
            if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_Messaging &&  string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Domestic')==true){
               DomesticSMSUsage += beObj.Messages__c;
             }
             if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_Messaging && string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('International')==true){
               InternationalSMSUsage += beObj.Messages__c;
             }
           if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_iPass && string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('Domestic')==true && beObj.iPass_Consumed_In_MB__c != null){
               DomesticIpassUsage  += beObj.iPass_Consumed_In_MB__c;
             } 
            if(string.valueOf(usageTypeMap.get(beObj.Usage_Type__c)) == MB_Constants.Usage_Type_iPass && string.valueOf(chargeTypeMap.get(beObj.Charge_Type__c)).contains('International')==true && beObj.iPass_Consumed_In_MB__c != null){
               InternationalIpassUsage += beObj.iPass_Consumed_In_MB__c;
             }  
          }  
       } 
         MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj=new MB_Wrapper_Class.MB_Device_Wrapper_Class(); 
         wrprobj.totalDomesticDataUsage=DomesticDataUsage.setScale(2);
         wrprobj.totalInternationalDataUsage=InternationalDataUsag.setScale(2);
         wrprobj.totalDomesticCallUsage=DomesticCallUsage.setScale(2);
         wrprobj.totalDomesticSMSUsage=DomesticSMSUsage.setScale(2);
         wrprobj.totalInternationalSMSUsage=InternationalSMSUsage.setScale(2) ;
         wrprobj.totalDomesticIpassUsage=DomesticIpassUsage.setScale(2);System.debug('@#@#'+wrprobj.totalDomesticIpassUsage);
         wrprobj.totalInternationalCallUsage=InternationalCallUsage.setScale(2);
         wrprobj.totalInternationalIpassUsage=InternationalIpassUsage.setScale(2) ;   
         return wrprobj;
    }
    @AuraEnabled
     public static MB_Wrapper_Class.MB_Device_Wrapper_Class getyourCollegueChargeType(String month) {
    string  country=[SELECT Country FROM User WHERE Id =:userinfo.getuserid() ].Country ; 
    
        Integer UserCount=0;
        Decimal AverageDataUsage=0;
        Decimal AverageCallUsage=0;
        Decimal AverageMessageUsage=0;
        Decimal AverageIpassUsage=0;
        Decimal DataUsage =0;
        Decimal CallUsage =0;
        Decimal MessageUsage =0;
        Decimal IpassUsage =0;
       MB_Wrapper_Class.MB_Device_Wrapper_Class wrprobj=new MB_Wrapper_Class.MB_Device_Wrapper_Class(); 
       
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
       UserCount=userIdSet.Size();System.debug('!@#$'+UserCount);
       if(lstCollegueChargeType.size()>0)   {
       for(MB_Billing_Entity__c AvgofCollegueData:lstCollegueChargeType)
       {   
           if(AvgofCollegueData.User__c !=UserInfo.getUserId()){
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
            
        }
      
        
        if(AvgofCollegueData.User__c ==UserInfo.getUserId()){
         if(AvgofCollegueData.Data_Consumed_In_MB__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_Data){  
           DataUsage +=AvgofCollegueData.Data_Consumed_In_MB__c;
          }
         if(AvgofCollegueData.Call_Minutes__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_Calls){ 
           CallUsage +=AvgofCollegueData.Call_Minutes__c;
          }
         if(AvgofCollegueData.Messages__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_Messaging){ 
           MessageUsage +=AvgofCollegueData.Messages__c;
          }
         if(AvgofCollegueData.iPass_Consumed_In_MB__c != null && string.valueOf(usageTypeMap.get(AvgofCollegueData.Usage_Type__c)) == MB_Constants.Usage_Type_iPass){
           IpassUsage +=AvgofCollegueData.iPass_Consumed_In_MB__c;
           }
          }
        }
         if(AverageDataUsage>0 && UserCount>0){
             wrprobj.totalAverageDataUsage=(AverageDataUsage/UserCount).setScale(2);
        }
        else{
             wrprobj.totalAverageDataUsage=AverageDataUsage.setScale(2);   
        }   
        if(AverageCallUsage>0 && UserCount>0){
             wrprobj.totalAverageCallUsage=(AverageCallUsage/UserCount).setScale(2); 
        }
        else{
             wrprobj.totalAverageCallUsage=AverageCallUsage.setScale(2);
        }
        if(AverageMessageUsage>0 && UserCount>0){
             wrprobj.totalAverageMessageUsage=(AverageMessageUsage/UserCount).setScale(2); 
        }
        else{
             wrprobj.totalAverageMessageUsage=AverageMessageUsage.setScale(2);
        }
        if(AverageIpassUsage>0 && UserCount>0){
             wrprobj.totalAverageIpassUsage=(AverageIpassUsage/UserCount).setScale(2);  
        }
        else{
             wrprobj.totalAverageIpassUsage=AverageIpassUsage.setScale(2);
        }
          wrprobj.totalDataUsage=DataUsage.setScale(2) ; 
          wrprobj.totalCallUsage=CallUsage.setScale(2) ; 
          wrprobj.totalMessageUsage=MessageUsage.setScale(2) ; 
          wrprobj.totalIpassUsage=IpassUsage.setScale(2) ; 
         
          return wrprobj;
         
    }
    return null;
    
}
}