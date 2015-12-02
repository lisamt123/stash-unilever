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
    
    public Integer TTActivities {get;set;}
    public Integer TTResources {get;set;}
    
    public id MSid {get;set;}
    public String MScurrency {get;set;}
    
    public Integer total{get;set;}
    public String itemToUpdate {get;set;}
    
    public Oblix_Ctrl10_nonCampaignView() {
   
         Id idUser = UserInfo.getUserId();
         userConnected = [Select Name from User where Id =: idUser ];
         MSid= ApexPAges.currentPage().getParameters().get('MSid');
         
        // Id RdevRecordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
         Id ARecordTypeId    = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Activity').getRecordTypeId();
     
         activities= new List <Marketing_Basics__c>();
         resources= new List <Marketing_Basics__c>();
         total=0; 
         Marketing_SOW__c  Marketing_SOW  = [select id,Financial_Year__c,currency__c,Oblix_AgencyEstimate__c,Oblix_AgencyEstimate__r.Name from Marketing_SOW__c where id =: MSid];     
         MScurrency = Marketing_SOW.currency__c ; 
         List <Marketing_Basics__c>  Marketing_Basics = [select name,non_campaign_title__c,Activities__c, Other_Activities__c , recordTypeId,FTE__c,No_of_Hours_Required__c, Oblix_SOWMarketing__c,OblixCountry__c,OblixCountry__r.name ,Role_Title__c,Agency_Department__c,OblixOtherItemFee__c from Marketing_Basics__c  where Oblix_SOWMarketing__c= :MSid order by name];
         
         TTActivities  = 0;
         TTResources  = 0;
         
         for (Marketing_Basics__c  M :Marketing_Basics  ){
            if(m.OblixOtherItemFee__c!= null) {   total+=Integer.valueof(m.OblixOtherItemFee__c ) ;   }
           
            if (m.OblixOtherItemFee__c!= null && m.recordTypeId ==ARecordTypeId ) { TTActivities +=Integer.valueof(m.OblixOtherItemFee__c ) ;  }
            else {  if(m.OblixOtherItemFee__c!= null) { TTResources +=Integer.valueof(m.OblixOtherItemFee__c ) ;}   }
            
            if (m.recordTypeId ==ARecordTypeId ) { activities.add(m); }
            else { resources.add(m);}
          }
          if (activities.isempty()){ nActivities =0 ; } else { nActivities =  activities.size(); }
          if (resources.isempty()){ nResources=0 ; } else { nResources=  resources.size(); }
            
    }
   
   
    /* Method used to redirect Back 
         * @return [Redirection VF 06] 
         */ 
    public pagereference back(){
         Pagereference meNewPage = Page.Oblix_VF06_SOWView;
                meNewPage.getParameters().put('sowId', MSid);
                meNewPage.setRedirect(True);
           return meNewPage;
        
        }
        
     /* Method used to redirect o new nonCampagne Item Page
         * @return [Redirection to vf09 to add items] 
         */     
    public pagereference addnewItems(){
          Pagereference meNewPage = Page.Oblix_VF09_nonCampaignEdit;
                meNewPage.getParameters().put('MSid', MSid);
                meNewPage.setRedirect(True);
           return meNewPage;
       
    }
     /* Method used to redirect to Item Edit Page with item to edit 
         * @return [Redirection to vf09 to add items] 
         */    
    public pagereference goToEditItem(){
        Pagereference meNewPage = Page.Oblix_VF09_nonCampaignEdit;
                meNewPage.getParameters().put('itm', itemToUpdate);
        return meNewPage;
    }
   
    }