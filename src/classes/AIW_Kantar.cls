public with sharing class AIW_Kantar{
    
    public String countries { get; set; }
    
    //public string timeperiod{get;set;}
    //public string brand{get;set;}
    public string level1{get;set;}
    public string level2{get;set;}
    public string USlevel1{get;set;}
    public string USlevel2{get;set;}
    public string USImage{get;set;}
    public string strUBC{get;set;}
    public string USbrand{get;set;}
    public string USCategory{get;set;}
    public string category{get;set;}
    
    public string timeperiod{get;set;}
    public string brand{get;set;}
    public string measures{get;set;}
    public string channel{get;set;}
    public string measure1 {get;set;}
    public string measure2 {get;set;}
    public string measure3 {get;set;}
    public string measure4 {get;set;}
    public integer tcmax{get;set;}
    
    public Decimal expvalue{get;set;}
    public Decimal expchange{get;set;}
    public String colorSet{get;set;}
    public list<String> queryString1=new list<String>();
    
    public AIW_Kantar(){
        timeperiod = 'MAT';
        brand = 'Lynx';
        measures = 'Expenditure';
        channel = 'Total Market';
        
        measure1 = 'Penetration';
        measure2 = 'Frequency';
        measure3 = 'Packs per Trip';
        measure4 = 'Price per Pack';
        
        strUBC='Lynx,DEODORANTS,Male,AP';
        
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
            
            //USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_'+USbrand.toLowerCase()+'.png';
            if(USbrand.contains(' '))
            {
                USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_dove.png';
            }
            else
            { 
                USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_'+USbrand.toLowerCase()+'.png';
            }
        }
    }
    
    public List<AIWKantarP__c> kantarList {get;set;}
    
    public PageReference getKantarData() {
        
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);
            sbrand = '%'+sbrand+'%'; 
            kantarList = [SELECT AIW_Brand__c,
                          AIW_Category__c,AWP__c,
                          Change__c,Channel__c,CreatedById,
                          CreatedDate,expenditure_cp__c,
                          expenditure_pp__c,Frequency__c,Id,Last_Year_Value__c
                          ,Measures__c,Name,OwnerId,PacksPerTrip__c,
                          Penetration__c,PricePerPack__c,SystemModstamp,
                          TimePeriod__c,TripSpend__c,Value__c 
                          FROM AIWKantarP__c
                          where TimePeriod__c =:timeperiod and AIW_Brand__r.name like :sbrand and Channel__c =:channel and (
                              Measures__c =: measure1 or Measures__c =:measure2 or Measures__c =:measure3
                              or Measures__c =: measure4) ORDER BY Measureorder__c  ASC];
            
            expList = [Select Value__c, Change__c From AIWKantarP__c where Measures__c =:measures and TimePeriod__c =:timeperiod and AIW_Brand__r.name like :sbrand and Channel__c =:channel limit 1];
            expvalue = expList[0].Value__c;
            expchange = expList[0].Change__c;
            system.debug('VALUE=====>'+expvalue +'CHANGE========>'+ expchange);
        }
        else
        {
            kantarList = [SELECT AIW_Brand__c,
                          AIW_Category__c,AWP__c,
                          Change__c,Channel__c,CreatedById,
                          CreatedDate,expenditure_cp__c,
                          expenditure_pp__c,Frequency__c,Id,
                          IsDeleted,Last_Year_Value__c
                          ,Measures__c,Name,OwnerId,PacksPerTrip__c,
                          Penetration__c,PricePerPack__c,SystemModstamp,
                          TimePeriod__c,TripSpend__c,Value__c 
                          FROM AIWKantarP__c
                          where TimePeriod__c =:timeperiod and AIW_Brand__r.name=:brand and Channel__c =:channel and (
                              Measures__c =: measure1 or Measures__c =:measure2 or Measures__c =:measure3
                              or Measures__c =: measure4) ORDER BY Measureorder__c  ASC];
            
            expList = [Select Value__c, Change__c From AIWKantarP__c where Measures__c =:measures and TimePeriod__c =:timeperiod and AIW_Brand__r.name=:brand and Channel__c =:channel limit 1];
            expvalue = expList[0].Value__c;
            expchange = expList[0].Change__c;
            system.debug('VALUE=====>'+expvalue +'CHANGE========>'+ expchange);
            
        }     
        
        return null;
    }
    public List<AIWKantarP__c> expList{get;set;}
    
    public PageReference getExpData(){
        
        
        
        expList = [Select Value__c, Change__c From AIWKantarP__c where Measures__c =:measures and TimePeriod__c =:timeperiod and AIW_Brand__r.name=:brand and Channel__c =:channel limit 1];
        expvalue = expList[0].Value__c;
        expchange = expList[0].Change__c;
        system.debug('VALUE=====>'+expvalue +'CHANGE========>'+ expchange);
        return null;
        
        
    }
    public List<VCdata> getVCdata() 
    {  
        List<VCdata> data = new List<VCdata>();
        List<AIWKantarP__c> memb = new List<AIWKantarP__c>();  
        colorSet = '';
        String sql;
        
        
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);    
            sbrand = '%'+sbrand+'%';
            
            list<aggregateResult> aggResults = [SELECT MAX(Expcontribution__c)mytotc FROM AIWKantarP__c where TimePeriod__c =:timeperiod and AIW_Brand__r.name like :sbrand and Channel__c =:channel and (Measures__c =: measure1 or Measures__c =:measure2 or Measures__c =:measure3 or Measures__c =: measure4)];
            System.debug('Max is from if: ' + aggResults[0].get('mytotc')); 
            
            tcmax = ((decimal)aggResults[0].get('mytotc')).intValue();
            if (tcmax < 0)
            {
                tcmax=0;
            } 
        }
        else
        {
            
            list<aggregateResult> aggResults = [SELECT MAX(Expcontribution__c)mytotc  FROM AIWKantarP__c where TimePeriod__c =:timeperiod and AIW_Brand__r.name = :brand and Channel__c =:channel and (Measures__c =: measure1 or Measures__c =:measure2 or Measures__c =:measure3 or Measures__c =: measure4)];
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
            sql = 'SELECT Measures__c,Expcontribution__c,Measureorder__c FROM AIWKantarP__c where TimePeriod__c =:timeperiod and AIW_Brand__r.name like :sbrand and Channel__c =:channel and (Measures__c =: measure1 or Measures__c =:measure2 or Measures__c =:measure3 or Measures__c =: measure4) order by Measureorder__c DESC';
        }
        else
        {
            sql = 'SELECT Measures__c,Expcontribution__c,Measureorder__c FROM AIWKantarP__c where TimePeriod__c =:timeperiod and AIW_Brand__r.name=:brand and Channel__c =:channel and (Measures__c =: measure1 or Measures__c =:measure2 or Measures__c =:measure3 or Measures__c =: measure4) order by Measureorder__c DESC';     
        }
        memb = Database.Query(sql);
        system.debug('memb.......'+memb);
        for(AIWKantarP__c temp:memb)
        {  
            if(Integer.valueOf(temp.Expcontribution__c)>0){
                colorSet = colorSet + '669900,';
            }
            else{
                colorSet = colorSet + 'ff6600,';
            }   
            data.add(new VCdata(string.valueof(temp.Measures__c),Integer.valueof(temp.Expcontribution__c)));
        }
        return data;  
    }  
    
    
    // Wrapper class to hold Value Change change data
    public class VCdata
    {  
        public string name { get; set; }  
        public Integer data  { get; set; }  
        
        public VCdata(string name, Integer data)
        {  
            this.name = name;  
            this.data = data;
        }  
    } 
    
    public List<TCCData> getTCData() 
    {  
        List<TCCData> data = new List<TCCData>();
        List<AIWKantarP__c> memb = new List<AIWKantarP__c>();  
        String sql;
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);   
            sbrand = '%'+sbrand+'%';
            sql = 'SELECT Value__c, Last_Year_Value__c FROM AIWKantarP__c where TimePeriod__c=: timeperiod and AIW_Brand__r.name like :sbrand and Measures__c =: measures and Channel__c =: channel  limit 1';
        }
        else
        {
            sql = 'SELECT Value__c, Last_Year_Value__c FROM AIWKantarP__c where TimePeriod__c=: timeperiod and AIW_Brand__r.name =:brand and Measures__c =: measures and Channel__c =: channel  limit 1';        
        }
        memb = Database.Query(sql);
        for(AIWKantarP__c temp:memb)
        {           
            
            data.add(new TCCData('LAST YEAR',Integer.valueOf(temp.Last_Year_Value__c)));
            data.add(new TCCData('THIS YEAR',Integer.valueOf(temp.Value__c)));
            
        }
        return data;  
    }  
    
    // Wrapper class to hold Total Coverage change data
    public class TCCData 
    {  
        public String name { get; set; }  
        public Integer data  { get; set; }  
        
        public TCCData(string name, Integer data)
        {  
            this.name = name;  
            this.data = data;
        }  
    }         
    
    public PageReference openHBM(){
        PageReference page = new PageReference('/apex/HeartBeatMetrics?UBC='+strUBC+'&tp='+timeperiod);
        return page;
    }
    public PageReference openMKS(){
        PageReference page = new PageReference('/apex/AIWMarketshare?UBC='+strUBC+'&tp='+timeperiod);
        return page;
    }
    
    public PageReference openBrandSwitching(){
        PageReference page = new PageReference('/apex/UserBrandSwitching?frompage=aiwkantar'+'&tp='+timeperiod);
        return page;
    }
    
    public PageReference openCompetition(){
        PageReference page = new PageReference('/apex/aiwcompetition?UBC='+strUBC+'&tp='+timeperiod);
        return page;
    }
     public PageReference openSocial(){
        PageReference page = new PageReference('/apex/AIWSocial?UBC='+strUBC+'&tp='+'24 Hours'); 
                       return page;
                      
                       }
    
    public PageReference openKantar() {
        return null;
    }
    
    public PageReference test() {
        return null;
    }
    
    public String getItems() {
        return null;
    }                       
    
}