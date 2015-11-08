/**
    About
    -----
    Description: Class Oblix_Ctrl10_nonCampaignView 
    Created for: OBLIX Project
    Create date: Nov 6, 2015
    Created by Achraf ELHITARY
    Details
    -------
    
       Update History
    --------------    
*/
    public with sharing class Oblix_Ctrl10_nonCampaignView {
    
    public List<Marketing_Basics__c> activities {get;set;}
    public List<Marketing_Basics__c> resources {get;set;}
    public User userConnected {get;set;}
    public Integer nActivities {get;set;}
    public Integer nResources {get;set;}
    public id MSid {get;set;}
    
    public Integer total{get;set;}
    
    public Oblix_Ctrl10_nonCampaignView() {
   
         Id idUser = UserInfo.getUserId();
         userConnected = [Select Name from User where Id =: idUser ];
         MSid= ApexPAges.currentPage().getParameters().get('MSid');
         if (MSid==null) MSid='a6KM00000004gB8' ;
         Id RdevRecordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
         Id ARecordTypeId    = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Activity').getRecordTypeId();
     
         activities= new List <Marketing_Basics__c>();
         resources= new List <Marketing_Basics__c>();
         total=0; 
             
         List <Marketing_Basics__c>  Marketing_Basics = [select name,Activities__c, recordTypeId,FTE__c,No_of_Hours_Required__c, Oblix_SOWMarketing__c,OblixCountry__c,OblixCountry__r.name ,Role_Title__c,Agency_Department__c,OblixOtherItemFee__c from Marketing_Basics__c  where Oblix_SOWMarketing__c= :MSid ];
       for (Marketing_Basics__c  M :Marketing_Basics  ){
            if(m.OblixOtherItemFee__c!= null)   total+=Integer.valueof(m.OblixOtherItemFee__c ) ; 
             if (m.recordTypeId ==ARecordTypeId   ) activities.add(m);
             else  resources.add(m);
          }
          if (activities.isempty()){ nActivities =0 ; } else nActivities =  activities.size();
          if (resources.isempty()){ nResources=0 ; } else nResources=  resources.size();
            
    }
   
   
   
    public pagereference back(){
         PageReference  page = new PageReference('/apex/Oblix_VF06_SOWView?sowId='+MSid);
           page.setRedirect(True);
           return page;
        
        return null;
        }
    
   
   
   
    public pagereference walo(){
        return null;
        }
    
    
    
    
    }