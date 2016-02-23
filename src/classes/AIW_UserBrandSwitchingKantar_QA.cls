public with sharing class AIW_UserBrandSwitchingKantar_QA{
public string rp{get;set;}
public string timeperiod{get;set;}
 public String queryString ='';
//public string tp{get;set;}
 public List<AIWUserBrand__c> mkList{get;set;} 
 public AIW_UserBrandSwitchingKantar_QA(){

 //String tp ='';
 queryString = System.currentPagereference().getParameters().get('frompage');
 timeperiod=System.currentPagereference().getParameters().get('tp');
 rp=queryString;
 //tp=timeperiod;
 getShares();
 }
         
    public PageReference getShares() {
    
         mkList = [SELECT UBC__c,ImageURL__c FROM AIWUserBrand__c where user__C =: UserInfo.getUserId() and level1__c = 'All' and level2__c = 'All' order by UBC__c limit 100];    
     
     return null;
     
     }
public PageReference cancel(){
                       PageReference page = new PageReference('/apex/HeartBeatMetrics_QA');
                       return page;
                       }
                        public PageReference openHBM(){
                       PageReference page = new PageReference('/apex/HeartBeatMetrics_QA');
                       return page;
                       }
}