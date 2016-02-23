public with sharing class AIW_Market_Share_QA{
    public string timeperiod{get;set;}
    public string brand{get;set;}
    public string level1{get;set;}
    public string level2{get;set;}
    public string metric{get;set;}
    public string category{get;set;}
    public string USbrand{get;set;}
    public string USCategory{get;set;}
    public string USlevel1{get;set;}
    public string USlevel2{get;set;}
    public string USImage{get;set;}
    public string strUBC{get;set;}
    public String colorSet{get;set;}
    public list<String> queryString1=new list<String>();  
    public Decimal MSvalue{get;set;}
    public Decimal MSchange{get;set;}
    public boolean showKantarbtn{get;set;}
    public integer tcmax{get;set;}
    
    public AIW_Market_Share_QA(){
        
        timeperiod ='MAT';
        brand='Lynx';
        level1 ='Male';
        level2 ='AP';
        metric='VALUE';
        strUBC='Lynx,DEODORANTS,Male,AP';
        String queryString ='';
        String queryString2 ='';
        String tp='';
        //tp=timeperiod;
        queryString = System.currentPagereference().getParameters().get('UBC');
        system.debug('queryString  *****= '+queryString );
        system.debug('queryString  &&&&= '+System.currentPagereference().getParameters().get('tp') );
        timeperiod = System.currentPagereference().getParameters().get('tp');
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
            system.debug('brand......'+brand);
            system.debug('level1......'+level1);
            system.debug('level2......'+mkList );
            //getShares();
            //system.debug('level2......'+mkList );
            // USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_'+USbrand.toLowerCase()+'.png';
            if(USbrand.contains(' '))
            {
                USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_dove.png';
            }
            else
            { 
                USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_'+USbrand.toLowerCase()+'.png';
            }
        }
        
        if (level1.toLowercase() == 'all' && level2.toLowercase() == 'all')
        {
            showKantarbtn = false;
        }
        else
        {
            showKantarbtn = true;
        }
        
    }
    public List<AIWMarketShare__c> mkList{get;set;} 
    public List<AIWHeartbeat_Metrics__c > hbmList {get;set;}
    
    public PageReference getShares() {
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);
            sbrand = '%'+sbrand+'%';
            mkList = [SELECT AIWBrand__c,Channel__c,
                      CreatedById,CreatedDate,
                      Id,
                      Level_Description__c,MSchg__c,
                      MS_Level__c,
                      MS__c,Name
                      ,TimePeriod__c,
                      TotCovChg__c FROM AIWMarketShare__c 
                      where MS__c != NULL and Level1__c !=null and Level2__c !=null and TimePeriod__c =:timeperiod and AIWBrand__r.name like :sbrand and level1__c =:level1 and level2__c =:level2 and metric__c =: metric order by Channel__c desc ];
            
            
            hbmList = [SELECT 
                       AIW_Brand__c,AIW_Category__c,
                       MarketShareChange__c,MarketShareOld__c,
                       Market_Share__c,Name,OwnerId,PenetrationChange__c,
                       Time_Period__c,USGOld__c,USG__c,UVGOld__c,UVG__c,WeekEnding__c 
                       FROM AIWHeartbeat_Metrics__c
                       where Time_Period__c =:timeperiod and AIW_Brand__r.name like :sbrand and level1__C=:level1 and level2__C =:level2];
            MSvalue = hbmList[0].Market_Share__c;
            MSchange = hbmList[0].MarketShareChange__c;    
        }
        else
        {
            mkList = [SELECT AIWBrand__c,Channel__c,
                      CreatedById,CreatedDate,
                      Id,
                      Level_Description__c,MSchg__c,
                      MS_Level__c,
                      MS__c,Name
                      ,TimePeriod__c,
                      TotCovChg__c FROM AIWMarketShare__c 
                      where MS__c != NULL and Level1__c !=null and Level2__c !=null and TimePeriod__c =:timeperiod and AIWBrand__r.name =:brand and level1__c =:level1 and level2__c =:level2 and metric__c =: metric order by Channel__c desc ];
            
            
            hbmList = [SELECT 
                       AIW_Brand__c,AIW_Category__c,
                       MarketShareChange__c,MarketShareOld__c,
                       Market_Share__c,Name,OwnerId,PenetrationChange__c,
                       Time_Period__c,USGOld__c,USG__c,UVGOld__c,UVG__c,WeekEnding__c 
                       FROM AIWHeartbeat_Metrics__c
                       where Time_Period__c =:timeperiod and AIW_Brand__r.name=:brand and level1__C=:level1 and level2__C =:level2];
            MSvalue = hbmList[0].Market_Share__c;
            MSchange = hbmList[0].MarketShareChange__c;     
        }               
        return null;
    }                       
    public List<TCCData> getTCData() 
    {  
        List<TCCData> data = new List<TCCData>();
        List<AIWMarketShare__c> memb = new List<AIWMarketShare__c>();  
        colorSet = '';
        String sql;
        
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);    
            sbrand = '%'+sbrand+'%';
            
            list<aggregateResult> aggResults = [SELECT MAX(TotCovChg__c)mytotc FROM AIWMarketShare__c where TotCovChg__c != NULL and TimePeriod__c=: timeperiod and AIWBrand__r.name like :sbrand and level1__c =:level1 and level2__c =:level2 and metric__c =: metric];
            System.debug('Max is from if: ' + aggResults[0].get('mytotc')); 
            
            tcmax = ((decimal)aggResults[0].get('mytotc')).intValue();
            if (tcmax < 0)
            {
                tcmax=0;
            } 
        }
        else
        {
            
            list<aggregateResult> aggResults = [SELECT MAX(TotCovChg__c)mytotc FROM AIWMarketShare__c where TotCovChg__c != NULL and TimePeriod__c=: timeperiod and AIWBrand__r.name =:brand and level1__c =:level1 and level2__c =:level2 and metric__c =: metric];
            System.debug('Max is from else: ' + aggResults[0].get('mytotc'));
            
            tcmax = ((decimal)aggResults[0].get('mytotc')).intValue();
            if (tcmax < 0)
            {
                tcmax=0;
            } 
            
        }
        
        
        
        
        
        
        
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);
            
            sbrand = '%'+sbrand+'%';
            sql = 'SELECT Channel__c, TotCovChg__c FROM AIWMarketShare__c where TotCovChg__c != NULL and TimePeriod__c=: timeperiod and AIWBrand__r.name like :sbrand and level1__c =:level1 and level2__c =:level2 and metric__c =: metric order by Channel__c';
        }
        else
        {
            sql = 'SELECT Channel__c, TotCovChg__c FROM AIWMarketShare__c where TotCovChg__c != NULL and TimePeriod__c=: timeperiod and AIWBrand__r.name =:brand and level1__c =:level1 and level2__c =:level2 and metric__c =: metric order by Channel__c';
            
        }
        
        
        memb = Database.Query(sql);
        for(AIWMarketShare__c temp:memb)
        {   
            if(Integer.valueOf(temp.TotCovChg__c)>0){
                colorSet = colorSet + '669900,';
            }
            else{
                colorSet = colorSet + 'ff6600,';
            }                        
            data.add(new TCCData(temp.Channel__c,Integer.valueOf(temp.TotCovChg__c)));            
        }
        return data;  
    }  
    
    // Wrapper class to hold Total Coverage change data
    public class TCCData 
    {  
        public String name { get; set; }  
        public Integer data { get; set; }  
        
        public TCCData(String name, Integer data) 
        {  
            this.name = name;  
            this.data = data;  
        }  
    }         
    
    
    public List<MKSData> getMKData() 
    {  
        List<MKSData> data = new List<MKSData>();
        List<AIWMarketShare__c> memb = new List<AIWMarketShare__c>();  
        String sql;
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);
            sbrand = '%'+sbrand+'%';
            sql = 'SELECT Channel__c, MS__c FROM AIWMarketShare__c where MS__c != NULL and Level1__c !=null and Level2__c !=null and TimePeriod__c=: timeperiod and AIWBrand__r.name like :sbrand and level1__c =:level1 and level2__c =:level2 and metric__c =: metric';
        }
        else
            
        {
            sql = 'SELECT Channel__c, MS__c FROM AIWMarketShare__c where MS__c != NULL and Level1__c !=null and Level2__c !=null and TimePeriod__c=: timeperiod and AIWBrand__r.name =:brand and level1__c =:level1 and level2__c =:level2 and metric__c =: metric';
        }
        memb = Database.Query(sql);
        for(AIWMarketShare__c temp:memb)
        {           
            data.add(new MKSData(temp.Channel__c,temp.MS__c));
            
        }
        return data;  
    }  
    
    // Wrapper class to hold Market Share % Data
    public class MKSData 
    {  
        public String name { get; set; }  
        public Decimal data { get; set; }  
        
        public MKSData(String name, Decimal data) 
        {  
            this.name = name;  
            this.data = data;  
        }  
    }          
    
    
    
    public PageReference openHBM()
    {                       
        PageReference page = new PageReference('/apex/HeartBeatMetrics_QA?UBC='+strUBC+'&tp='+timeperiod);
        return page;
    }
    
    public PageReference openKantar()
    {
        PageReference page = new PageReference('/apex/aiwkantar_QA?UBC='+strUBC+'&tp='+timeperiod);
        return page;
    }
    
    public PageReference openCompetition()
    {
        PageReference page = new PageReference('/apex/aiwcompetition_QA?UBC='+strUBC+'&tp='+timeperiod);
        return page;
    }
    
    public PageReference getMatrixtime() {
        return null;
    }
    
    
    public PageReference openHBMInfo() {
        return null;
    }
    public PageReference openBrandSwitching(){
        PageReference page = new PageReference('/apex/UserBrandSwitching_QA?frompage=AIWMarketshare'+'&tp='+timeperiod);
        return page;
    }
     public PageReference openSocial(){
                       
                          PageReference page = new PageReference('/apex/AIWSocial_QA?UBC='+strUBC+'&tp='+'24 Hours');
                        
                       return page;
                      
                       }
    
}