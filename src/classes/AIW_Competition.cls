public with sharing class AIW_Competition{
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
    public integer mapSize{get;set;}
    public integer mapSizeForTable{get;set;}
    public list<String> queryString1=new list<String>();
    
    public AIW_Competition(){
        timeperiod ='MAT';
        brand='Lynx';
        level1 ='Male';
        level2 ='AP';
        strUBC='Lynx,DEODORANTS FRAGRANCES,Male,AP';
        
        String queryString ='';
        String queryString2 ='';
        String tp='';
        
        queryString = System.currentPagereference().getParameters().get('UBC');
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
            
            USImage = AIWcommonUtility.getUSImage(USbrand);
        }
        
    }
    
    public List<AIW_Competition__c> compList {get;set;}
    public map<integer, AIW_Competition__c> compMap{get;set;}
    
    public PageReference getCompetitionData() {
        compMap= new map<integer,AIW_Competition__c>();
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);
            sbrand = '%'+sbrand+'%';
            
            compList =  [SELECT Category__c,
                         Company__c,Competition_Basis_Point__c,
                         Competiton_Percentage__c,Competitor_Brand__c,
                         CreatedById,CreatedDate,
                         Id,IsDeleted,
                         LastActivityDate,
                         LastModifiedById,LastModifiedDate,
                         Level1__c,MS_P__c,
                         MS__c,Name,OwnerId,
                         PriceKG_L_P__c,PriceKG_L__c,
                         SystemModstamp,TDPS_P__c,TDPS__c,
                         Time_Period__c,Unilever_Brand__c,
                         ValueP__c,Value__c,VolumeP__c,Volume__c,Unilever_Brand__r.name
                         FROM AIW_Competition__c where Time_Period__c=: timeperiod and Unilever_Brand__r.name like :sbrand and level1__C=:level1 and level2__C =:level2];
            //FROM AIW_Competition__c where Time_Period__c=: timeperiod];
        }
        else{
            compList =  [SELECT Category__c,
                         Company__c,Competition_Basis_Point__c,
                         Competiton_Percentage__c,Competitor_Brand__c,
                         CreatedById,CreatedDate,
                         Id,IsDeleted,
                         LastActivityDate,
                         LastModifiedById,LastModifiedDate,
                         Level1__c,MS_P__c,
                         MS__c,Name,OwnerId,
                         PriceKG_L_P__c,PriceKG_L__c,
                         SystemModstamp,TDPS_P__c,TDPS__c,
                         Time_Period__c,Unilever_Brand__c,
                         ValueP__c,Value__c,VolumeP__c,Volume__c,Unilever_Brand__r.name
                         FROM AIW_Competition__c where Time_Period__c=: timeperiod and Unilever_Brand__r.name=:brand and level1__C=:level1 and level2__C =:level2];
            //FROM AIW_Competition__c where Time_Period__c=: timeperiod];
        }
        integer i=1; 
        
        for(AIW_Competition__c  ac :complist){
            i++;
            system.debug('ac.Unilever_Brand__r.name is......'+ac.Unilever_Brand__r.name);
            system.debug('ac.Competitor_Brand__c is......'+ac.Competitor_Brand__c);
            if(ac.Unilever_Brand__r.name == ac.Competitor_Brand__c)
            {
                compMap.put(1,ac);
                i--;
            }
            else{
                compMap.put(i,ac);
            }
            
        }   
        system.debug('length is......'+compMap.size());
        mapSizeForTable = compMap.size();
        mapSize=compMap.size();
        system.debug('map1is......'+compMap.get(1));
        system.debug('map1is......'+compMap.get(2));
        system.debug('map1is......'+compMap.get(3));
        system.debug('map1is......'+compMap.get(4));
        system.debug('map1is......'+compMap.get(5));
        return null; 
    }
    
    
    public PageReference openHBM(){
        PageReference page = new PageReference('/apex/HeartBeatMetrics?UBC='+strUBC+'&tp='+timeperiod);
        return page;
    }
    public PageReference openHBMInfo(){
        PageReference page = new PageReference('/apex/HeartBeatMetricsInfo');
        return page;
    }
    public PageReference openBrandSwitching(){
        PageReference page = new PageReference('/apex/UserBrandSwitching?frompage=aiwcompetition'+'&tp='+timeperiod);
        return page;
    }
    public PageReference openCompetition(){
        PageReference page = new PageReference('/apex/aiwcompetition');
        return page;
    }
    
     public PageReference openSocial(){
         PageReference page = new PageReference('/apex/AIWSocial?UBC='+strUBC+'&tp='+'24 Hours');
         return page;             
    }
    
    
}