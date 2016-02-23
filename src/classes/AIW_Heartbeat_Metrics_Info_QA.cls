public with sharing class AIW_Heartbeat_Metrics_Info_QA{
 public string timeperiod{get;set;}
 public string brand{get;set;}
 public string level1{get;set;}
 public string level2{get;set;}
 public string USlevel1{get;set;}
 public string USlevel2{get;set;}
 public string USImage{get;set;}
  public string strUBC{get;set;}
 public string USbrand{get;set;}
 public string USCategory{get;set;}
 public string category{get;set;}
 
 public list<String> queryString1=new list<String>();
 
public AIW_Heartbeat_Metrics_Info_QA(){
    timeperiod ='MAT';
    brand = 'Lynx';
    category='Deodorants';
    level1 ='Male';
    level2 ='AP';
     strUBC='Lynx,Deodorants,Male,AP';
    
    String queryString ='';
    String queryString2 ='';
    String tp ='';
        
        queryString = System.currentPagereference().getParameters().get('UBC');
       timeperiod=System.currentPagereference().getParameters().get('tp');
        system.debug('tp');
       if(queryString!=null){
    queryString1=queryString.split(',');
    system.debug('queryString1......'+queryString1);
   USCategory=queryString1[1].trim();
    USbrand=queryString1[0].trim();
    USlevel1=queryString1[2].trim();
    USlevel2=queryString1[3].trim();
    brand=USbrand;
    category=USCategory;
    level1=USlevel1;
    level2=USlevel2;
    strUBC=queryString;
    system.debug('USbrand......'+USbrand);
    system.debug('USbrand- substring......'+USbrand.substring(0,4));
   if(USbrand.contains(' '))
   {
       USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_dove.png';
   }
  else
  { 
    USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_'+USbrand.toLowerCase()+'.png';
    }
   }
   
      //USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_'+USbrand.toLowerCase()+'.png';
   
   if(USbrand==null){
   brand = 'Lynx';
   system.debug('brand....'+brand);
    level1 ='Male';
    level2 ='AP';
    USbrand=brand;
    USlevel1=level1;
    USlevel2=level2;
    timeperiod='MAT';
    category='Deodorants';
   USCategory=category;
    USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_'+USbrand.toLowerCase()+'.png';
    
    }
   getMatrixtime();
}
 
 public List<AIWHeartbeat_Metrics__c > hbmList {get;set;}
 
    public PageReference getMatrixtime() {
    
   if(brand.contains(' '))
   {
    string sbrand = brand.substring(0,4);
    sbrand = '%'+sbrand+'%'; 
   hbmList = [SELECT AIW_Brand__c,
                     AIW_Category__c,
                     BBTOT_Old__c,
                     BBTOT__c,
                     bec__c,
                     BrandEquity20Old__c,
                     BrandEquity20__c,
                     CreatedById,
                     CreatedDate,
                     DistributionC__c,
                     DistributionOld__c,
                     Distribution__c,
                     Id,
                     Level1__c,Level2__c,
                     MarketShareChange__c,
                     MarketShareOld__c,Market_Share__c,
                     Name,OwnerId,PenetrationChange__c,
                     PenetrationOld__c,Penetration__c,
                     ProfitMarginOld__c,Profit_Margin__c,
                     ShareofVoiceOld__c,ShareofVoice__c,
                     SustainabilityIndexOld__c,Sustainability_Index__c,
                     SystemModstamp,TalkabilityIndexOld__c,
                     Talk_ability_Index__c,
                     Time_Period__c,USGOld__c,USG__c,UVGOld__c
                     ,UVG__c,WeekEnding__c 
                     FROM AIWHeartbeat_Metrics__c
                     where Time_Period__c =:timeperiod and AIW_Brand__r.name like :sbrand and level1__C=:level1 and level2__C =:level2];
                     }
                     else
                     {
                       hbmList = [SELECT AIW_Brand__c,
                     AIW_Category__c,
                     BBTOT_Old__c,
                     BBTOT__c,
                     bec__c,
                     BrandEquity20Old__c,
                     BrandEquity20__c,
                     CreatedById,
                     CreatedDate,
                     DistributionC__c,
                     DistributionOld__c,
                     Distribution__c,
                     Id,
                     Level1__c,Level2__c,
                     MarketShareChange__c,
                     MarketShareOld__c,Market_Share__c,
                     Name,OwnerId,PenetrationChange__c,
                     PenetrationOld__c,Penetration__c,
                     ProfitMarginOld__c,Profit_Margin__c,
                     ShareofVoiceOld__c,ShareofVoice__c,
                     SustainabilityIndexOld__c,Sustainability_Index__c,
                     SystemModstamp,TalkabilityIndexOld__c,
                     Talk_ability_Index__c,
                     Time_Period__c,USGOld__c,USG__c,UVGOld__c
                     ,UVG__c,WeekEnding__c 
                     FROM AIWHeartbeat_Metrics__c
                     where Time_Period__c =:timeperiod and AIW_Brand__r.name=:brand and level1__C=:level1 and level2__C =:level2];
                     }
    
        return null;
    }

  public static List<AIWHeartbeat_Metrics__c> getMatrix() {
  
  List<AIWHeartbeat_Metrics__c > hbmList = new List<AIWHeartbeat_Metrics__c>();
   hbmList = [SELECT AIW_Brand__c,AIW_Category__c,
                       BBTOT_Old__c,BBTOT__c,bec__c,
                       BrandEquity20Old__c,BrandEquity20__c,
                       CreatedById,CreatedDate,DistributionC__c,
                       DistributionOld__c,Distribution__c,Id,Level1__c,Level2__c,
                       MarketShareChange__c,MarketShareOld__c,
                       Market_Share__c,Name,OwnerId,PenetrationChange__c,
                       PenetrationOld__c,Penetration__c,ProfitMarginOld__c,
                       Profit_Margin__c,ShareofVoiceOld__c,ShareofVoice__c,
                       SustainabilityIndexOld__c,Sustainability_Index__c,
                       SystemModstamp,TalkabilityIndexOld__c,
                       Talk_ability_Index__c,Time_Period__c,
                       USGOld__c,USG__c,UVGOld__c,UVG__c,WeekEnding__c 
                       FROM AIWHeartbeat_Metrics__c
                        where Time_Period__c ='MAT'];
       return hbmList;
                       }
                       public PageReference openHBM(){
                       PageReference page = new PageReference('/apex/HeartBeatMetrics_QA?UBC='+strUBC+'&tp='+timeperiod);
                       return page;
                       }
                       public PageReference openHBMYtd(){
                       PageReference page = new PageReference('/apex/HeartBeatMetrics_QA?UBC='+strUBC+'&tp=YTD');
                       return page;
                       }
                        public PageReference openHBMMat(){
                       PageReference page = new PageReference('/apex/HeartBeatMetrics_QA?UBC='+strUBC+'&tp=MAT');
                       return page;
                       }
                        public PageReference openHBM12W(){
                       PageReference page = new PageReference('/apex/HeartBeatMetrics_QA?UBC='+strUBC+'&tp=12W');
                       return page;
                       }
                        public PageReference openHBM4W(){
                       PageReference page = new PageReference('/apex/HeartBeatMetrics_QA?UBC='+strUBC+'&tp=4W');
                       return page;
                       }
                       public PageReference openHBMInfo(){
                       PageReference page = new PageReference('/apex/HeartBeatMetricsInfo_QA?UBC='+strUBC+'&tp='+timeperiod);
                       return page;
                       }
                       
                       public PageReference openBrandSwitching(){
                       PageReference page = new PageReference('/apex/UserBrandSwitching_QA?frompage=heartbeatmetrics'+'&tp='+timeperiod);
                       return page;
                       }
                       public PageReference openMarketShare(){
                       PageReference page = new PageReference('/apex/AIWMarketshare_QA?UBC='+strUBC+'&tp='+timeperiod);
                       return page;
                       }
                       public PageReference openCompetition(){
                       PageReference page = new PageReference('/apex/aiwcompetition_QA?UBC='+strUBC+'&tp='+timeperiod);
                       return page;
                       }
                        public PageReference openSocial(){
                        PageReference page = new PageReference('/apex/AIWSocial_QA?UBC='+strUBC+'&tp='+'24 Hours');                     
                        return page;
                      
                       }
                       
                       }