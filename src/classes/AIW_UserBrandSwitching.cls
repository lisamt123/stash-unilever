public with sharing class AIW_UserBrandSwitching{
public string rp{get;set;}
public string timeperiod{get;set;}
 public String queryString ='';
//public string tp{get;set;}
 public List<AIWUserBrand__c> mkList{get;set;} 
 public AIW_UserBrandSwitching(){

 //String tp ='';
 queryString = System.currentPagereference().getParameters().get('frompage');
 timeperiod=System.currentPagereference().getParameters().get('tp');
 rp=queryString;
 //tp=timeperiod;
 getShares();
 }
         
    public PageReference getShares() {          
     
     mkList = [SELECT UBC__c,ImageURL__c FROM AIWUserBrand__c where user__C =: UserInfo.getUserId() order by UBC__c limit 100];          
     
     return null;
     
     }
public PageReference cancel(){
                       PageReference page = new PageReference('/apex/HeartBeatMetrics');
                       return page;
                       }
                        public PageReference openHBM(){
                       PageReference page = new PageReference('/apex/HeartBeatMetrics');
                       return page;
                       }
}