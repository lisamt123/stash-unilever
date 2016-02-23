public with sharing class AIW_Social {
    Public List<AIWJSONParser_2> jobs{get;set;}
    public List<Data> data;
    public string timeperiod{get;set;}
    public string dimension{get;set;}
    public string stp{get;set;}
    public string brand{get;set;}
    public string level1{get;set;}
    public string level2{get;set;}
    public string USlevel1{get;set;}
    public string USlevel2{get;set;}
    public string USImage{get;set;}
    public string strUBC{get;set;}
    public string USbrand{get;set;}
    public string USCategory{get;set;}
    public string USObname{get;set;}
    public string category{get;set;}
    public string strdefaultcombi;
    public list<String> queryString1=new list<String>();
    public Integer talkability{get;set;}
    
    
    public List<AIWUserBrand__c> ublist{get;set;}  
    public List<jsonwrapper> jw{get;set;}
    public jsonwrapper jw1{get;set;}
    public jsonwrapper jw2{get;set;}
    public jsonwrapper jw3{get;set;}
    public jsonwrapper jw4{get;set;}
    public jsonwrapper jw5{get;set;}
    
    
    public String endDate;
    public String limits;
    public String location;
    public String orderBy;
    public String orderDirection;
    public string pageType;
    public string queryId;
    public String startDate;
    public String projectId;
    public string accessToken;
    
    
    
    //public List<AIWUserBrand__c> ublist{get;set;}  
    public AIW_Social(){
    dimension = 'Hours';
        stp='24 Hours';
        brand = 'Lynx';
        category='Deodorants';
        level1 ='All';
        level2 ='All';
        strUBC='Lynx,Deodorants,All,All';
        
        String queryString ='';
        String queryString2 ='';
        String tp ='';
        
        queryString = System.currentPagereference().getParameters().get('UBC');
       // stp=System.currentPagereference().getParameters().get('tp');
        system.debug('tp');
        if(queryString!=null){
            queryString1=queryString.split(',');
            system.debug('queryString1......'+queryString1);
            USCategory=queryString1[1].trim();
            USbrand=queryString1[0].trim();
            USlevel1=queryString1[2].trim();
            USlevel2=queryString1[3].trim();
            //USObname=queryString1[4];
            
            
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
        else
        {
            strdefaultcombi = getUserdefaultCombi();
            system.debug('strdefaultcombi...'+strdefaultcombi);
            queryString1=strdefaultcombi.split(',');
            system.debug('queryString1......'+queryString1);
            USCategory=queryString1[1].trim();
            USbrand=queryString1[0].trim();
            USlevel1=queryString1[2].trim();
            USlevel2=queryString1[3].trim();
            
            brand=USbrand;
            category=USCategory;
            level1=USlevel1;
            level2=USlevel2;
           // stp='24 Hours';
            strUBC=strdefaultcombi;
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
        if(USbrand==null){
            brand = 'Lynx';
            system.debug('brand....'+brand);
            level1 ='Male';
            level2 ='AP';
            USbrand=brand;
            USlevel1=level1;
            USlevel2=level2;
            stp='MAT';
            category='Deodorants';
            USCategory=category;
            USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_'+USbrand.toLowerCase()+'.png';
            
        }
      //  getMatrixtime();
        updateAddressByGeocode();
    }
    
    
    // Return a list of data points for a chart
    public List<Data> getData12() {
       return getChartData12Months();

    }
    
    
    // The actual chart data; needs to be static to be
    public List<Data> getChartData12Months() {
        Date d = System.today();
String month = (String.valueOf(d.month()));
Date dt1 = system.today().AddDays(-30);
Date dt2 = system.today().AddDays(-365);
String prviosmonth = (String.valueOf(dt1.month()));
String lst12monthsold = (String.valueOf(dt2.month()));

if(lst12monthsold=='12')
lst12monthsold = 'Dec';
else if(lst12monthsold == '11')
lst12monthsold='Nov';
else if(lst12monthsold=='10')
lst12monthsold = 'Oct';
else if(lst12monthsold == '9')
lst12monthsold='Sep';
else if(lst12monthsold=='8')
lst12monthsold = 'Aug';
else if(lst12monthsold == '7')
lst12monthsold='Jul';
else if(lst12monthsold=='6')
lst12monthsold = 'Jun';
else if(lst12monthsold == '5')
lst12monthsold='May';
else if(lst12monthsold=='4')
lst12monthsold = 'Apr';
else if(lst12monthsold == '3')
lst12monthsold='Mar';
else if(lst12monthsold=='2')
lst12monthsold = 'Feb';
else 
lst12monthsold='Jan';



if(prviosmonth=='12')
prviosmonth = 'Dec';
else if(prviosmonth == '11')
prviosmonth='Nov';
else if(prviosmonth=='10')
prviosmonth = 'Oct';
else if(prviosmonth == '9')
prviosmonth='Sep';
else if(prviosmonth=='8')
prviosmonth = 'Aug';
else if(prviosmonth == '7')
prviosmonth='Jul';
else if(prviosmonth=='6')
prviosmonth = 'Jun';
else if(prviosmonth == '5')
prviosmonth='May';
else if(prviosmonth=='4')
prviosmonth = 'Apr';
else if(prviosmonth == '3')
prviosmonth='Mar';
else if(prviosmonth=='2')
prviosmonth = 'Feb';
else 
prviosmonth='Jan';

system.debug(lst12monthsold);
system.debug(prviosmonth);

       data = new List<Data>();
        
        List<AIWSocialMonth__c > memb = new List<AIWSocialMonth__c >();  
        String sql;
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);    
            sbrand = '%'+sbrand+'%';  
            sql = 'SELECT AIW_Brand__c,tstDate__c,DataMonth__c ,Talkability__c, Impression__c,Volume__c,Engagement__c FROM AIWSocialMonth__c where AIW_Brand__r.name like :sbrand and DataMonth__c >= :dt2 and  DataMonth__c <=  :dt1 and ';
           
        }
        
        else
        {
            sql = 'SELECT AIW_Brand__c,tstDate__c,DataMonth__c ,Talkability__c, Impression__c,Volume__c,Engagement__c FROM AIWSocialMonth__c where AIW_Brand__r.name =:brand and DataMonth__c >= :dt2 and  DataMonth__c <=  :dt1';
             
        }
        memb = Database.Query(sql);
        memb.sort();
      
        for(AIWSocialMonth__c temp:memb)
        {           
            data.add(new Data(string.valueof(temp.tstDate__c),
                              Integer.valueOf(temp.Talkability__c),
                              Integer.valueOf(temp.Impression__c),
                              Integer.valueOf(temp.Volume__c),
                              Integer.valueOf(temp.Engagement__c)));
            
        }
        
        return data;
    }
    
    // Return a list of data points for a chart
    public List<Data> getData7() {
      return getChartData7Days();
     
    }
    
    
    public List<Data> getChartData7Days() {
     data = new List<Data>();
        
        List<AIWSocial_Hours__c> memb = new List<AIWSocial_Hours__c>();  
        String sql;
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);    
            sbrand = '%'+sbrand+'%';    
            sql = 'SELECT AIWBrand__c,Days__c,Dimension__c,Talkability__c, Impression__c,Volume__c,Engagement__c FROM AIWSocial_Hours__c where AIWBrand__r.name like :sbrand and Dimension__c=:dimension';
        }
        else{
            sql = 'SELECT AIWBrand__c,Days__c,Dimension__c,Talkability__c, Impression__c,Volume__c,Engagement__c FROM AIWSocial_Hours__c where AIWBrand__r.name =:brand and Dimension__c=:dimension';
        }  
        
        memb = Database.Query(sql);
        memb.sort();
        for(AIWSocial_Hours__c temp:memb)
        {           
            data.add(new Data(string.valueof(temp.Days__c),
                              Integer.valueOf(temp.Talkability__c),
                              Integer.valueOf(temp.Impression__c),
                              Integer.valueOf(temp.Volume__c),
                              Integer.valueOf(temp.Engagement__c)));
            
        }
        
        return data;
    }
    
   
   
    // Return a list of data points for a chart
    public List<Data> getData24() {
        system.debug('get24====================>'+data);
        getChartData24Hours();
        return data;
    }
    
    
    
    public PageReference getChartData24Hours() {
    try
    {
    data = new List<data>();
        List<AIWSocial_Hours__c> memb = new List<AIWSocial_Hours__c>(); 
        String sql;
        
        DateTime NowDate = datetime.now();
               DateTime Past24 = NowDate.AddDays(-1).addHours(-1);
        
         DateTime  yesterday = system.now().AddDays(-1);
        DateTime Last7days = system.now().AddDays(-8);


        system.debug('Dimension before==============>'+dimension);
        if(dimension=='Hours'){
               system.debug('Dimension Hours==============>'+dimension);
        
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);    
            sbrand = '%'+sbrand+'%';            
            
            sql = 'SELECT AIWBrand__c,Hours__c,DataTime__c,Dimension__c,Talkability__c, Impression__c,Volume__c,Engagement__c FROM AIWSocial_Hours__c where AIWBrand__r.name like :sbrand and DataTime__c >= :Past24 and DataTime__c <= :NowDate and Dimension__c =:dimension Order by DataTime__c';
              
              
        }
        
        else
        {
            sql = 'SELECT AIWBrand__c,Hours__c,DataTime__c,Dimension__c,Talkability__c, Impression__c,Volume__c,Engagement__c FROM AIWSocial_Hours__c where AIWBrand__r.name =:brand and DataTime__c >= :Past24 and DataTime__c <= :NowDate and Dimension__c =:dimension Order by DataTime__c';
        }
       
        memb = Database.Query(sql);
       
       // memb.sort();
        
             talkability = Integer.valueof(memb[memb.size()-1].Talkability__c); 
             system.debug('talkability Hours ==================>'+talkability);
        for(AIWSocial_Hours__c temp:memb)
        {           
            data.add(new Data(string.valueof(temp.Hours__c),
                              Integer.valueOf(temp.Talkability__c),
                              Integer.valueOf(temp.Impression__c),
                              Integer.valueOf(temp.Volume__c),
                              Integer.valueOf(temp.Engagement__c)));
         
        }
        
        }
        else if(dimension =='Days')
        {
        
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);    
            sbrand = '%'+sbrand+'%';    
            sql = 'SELECT AIWBrand__c,Days__c,Dimension__c,Talkability__c, Impression__c,Volume__c,Engagement__c FROM AIWSocial_Hours__c where AIWBrand__r.name like :sbrand and Dimension__c=:dimension and DataTime__c > :Last7days and DataTime__c <= :yesterday Order by DataTime__c ';
        }
        else{
            sql = 'SELECT AIWBrand__c,Days__c,Dimension__c,Talkability__c, Impression__c,Volume__c,Engagement__c FROM AIWSocial_Hours__c where AIWBrand__r.name =:brand and Dimension__c=:dimension and DataTime__c > :Last7days and DataTime__c <= :yesterday Order by DataTime__c ';
        }  
       
        memb = Database.Query(sql);
      // memb.sort();
        talkability = Integer.valueof(memb[memb.size()-1].Talkability__c); 
        for(AIWSocial_Hours__c temp:memb)
        {           
            data.add(new Data(string.valueof(temp.Days__c),
                              Integer.valueOf(temp.Talkability__c),
                              Integer.valueOf(temp.Impression__c),
                              Integer.valueOf(temp.Volume__c),
                              Integer.valueOf(temp.Engagement__c)));
            
        }
        
        }
        
        else{
        
        Date d = System.today();
        String month = (String.valueOf(d.month()));
        Date dt1 = system.today().AddDays(-30);
        Date dt2 = system.today().AddDays(-395);
        String prviosmonth = (String.valueOf(dt1.month()));
        String lst12monthsold = (String.valueOf(dt2.month()));
        
        if(lst12monthsold=='12')
        lst12monthsold = 'Dec';
        else if(lst12monthsold == '11')
        lst12monthsold='Nov';
        else if(lst12monthsold=='10')
        lst12monthsold = 'Oct';
        else if(lst12monthsold == '9')
        lst12monthsold='Sep';
        else if(lst12monthsold=='8')
        lst12monthsold = 'Aug';
        else if(lst12monthsold == '7')
        lst12monthsold='Jul';
        else if(lst12monthsold=='6')
        lst12monthsold = 'Jun';
        else if(lst12monthsold == '5')
        lst12monthsold='May';
        else if(lst12monthsold=='4')
        lst12monthsold = 'Apr';
        else if(lst12monthsold == '3')
        lst12monthsold='Mar';
        else if(lst12monthsold=='2')
        lst12monthsold = 'Feb';
        else 
        lst12monthsold='Jan';
        
        
        
        if(prviosmonth=='12')
        prviosmonth = 'Dec';
        else if(prviosmonth == '11')
        prviosmonth='Nov';
        else if(prviosmonth=='10')
        prviosmonth = 'Oct';
        else if(prviosmonth == '9')
        prviosmonth='Sep';
        else if(prviosmonth=='8')
        prviosmonth = 'Aug';
        else if(prviosmonth == '7')
        prviosmonth='Jul';
        else if(prviosmonth=='6')
        prviosmonth = 'Jun';
        else if(prviosmonth == '5')
        prviosmonth='May';
        else if(prviosmonth=='4')
        prviosmonth = 'Apr';
        else if(prviosmonth == '3')
        prviosmonth='Mar';
        else if(prviosmonth=='2')
        prviosmonth = 'Feb';
        else 
        prviosmonth='Jan';
        
        system.debug(lst12monthsold);
        system.debug(prviosmonth);

  
        
     
     
        if(brand.contains(' '))
        {
            string sbrand = brand.substring(0,4);    
            sbrand = '%'+sbrand+'%';  
            sql = 'SELECT AIWBrand__c,DataTime__c,Month__c,Talkability__c, Impression__c,Volume__c,Engagement__c FROM AIWSocial_Hours__c where AIWBrand__r.name like :sbrand and DataTime__c >= :dt2 and  DataTime__c <=  :dt1 and Dimension__c=:dimension Order By DataTime__c ';
        }
        
        else
        {
            sql = 'SELECT AIWBrand__c,DataTime__c,Month__c,Talkability__c, Impression__c,Volume__c,Engagement__c FROM AIWSocial_Hours__c where AIWBrand__r.name =:brand and DataTime__c >= :dt2 and  DataTime__c <= :dt1 and Dimension__c=:dimension Order By DataTime__c ';
        }
        
        memb = Database.Query(sql);
        memb.sort();
          talkability = Integer.valueof(memb[memb.size()-1].Talkability__c); 
        for(AIWSocial_Hours__c temp:memb)
        {           
            data.add(new Data(string.valueof(temp.Month__c),
                              Integer.valueOf(temp.Talkability__c),
                              Integer.valueOf(temp.Impression__c),
                              Integer.valueOf(temp.Volume__c),
                              Integer.valueOf(temp.Engagement__c)));
            
         }
         
        }
         system.debug('talkability Hours END ==================>'+talkability);
          }catch(DMLException ex){}
        return null;
       

    }
    
    
   
  
    /*public List<Data> getAllData() {
        System.debug('time period is at 253....'+stp);  
        if(stp=='24 Hours')
        {
        System.debug('time period is....'+stp);
            return getChartData24Hours();
            }
        else if(stp=='7 Days')
            return getChartData7Days();
        else
            return getChartData12Months();
    }*/
    // Wrapper class
    public class Data {
        public String name { get; set; }
        public Integer talkability { get; set; }
        public Integer impression { get; set; }
        public Integer volume { get; set; }
        public Integer engagement { get; set; }
        public Data(String name, Integer talkability, Integer impression, Integer volume, Integer engagement) {
            this.name = name;
            this.talkability = talkability;
            this.impression = impression;
            this.volume = volume;
            this.engagement = engagement;
        }
    }
    
  //  public PageReference getMatrixtime() {
      //  return null;
  //  }
    public PageReference openCompetition() {
        PageReference page = new PageReference('/apex/aiwcompetition?UBC='+strUBC+'&tp=MAT');
        return page;
    }
    
    public PageReference openSocial(){
        PageReference page = new PageReference('/apex/AIWSocial?UBC='+strUBC+'&tp=MAT');
        return page;
    }
    public PageReference openHBM() {
        PageReference page = new PageReference('/apex/HeartBeatMetrics?UBC='+strUBC+'&tp=MAT');
        return page;
    }    
    public string getUserdefaultcombi()
    {
        ublist = [SELECT UBC__c,ImageURL__c FROM AIWUserBrand__c where user__C =: UserInfo.getUserId() and default__c = true ];
        if (ublist != null)
        {
            return ublist[0].UBC__c;
        }  
        return null;
    } 
    
    
    public void updateAddressByGeocode(){
        
        
        
        if(AIWcommonUtility.getConfigurationValues('location').get(0) != null)
        {
            location = AIWcommonUtility.getConfigurationValues('location').get(0);                
        }
        
        if(AIWcommonUtility.getConfigurationValues('Limit').get(0) != null)
        {
            Limits= AIWcommonUtility.getConfigurationValues('Limit').get(0);                
        }
        if(AIWcommonUtility.getConfigurationValues('orderBy').get(0) != null)
        {
            orderBy= AIWcommonUtility.getConfigurationValues('orderBy').get(0);                
        }
        if(AIWcommonUtility.getConfigurationValues('orderDirection').get(0) != null)
        {
            orderDirection= AIWcommonUtility.getConfigurationValues('orderDirection').get(0);                
        }
        if(AIWcommonUtility.getConfigurationValues('pageType').get(0) != null)
        {
            pageType= AIWcommonUtility.getConfigurationValues('pageType').get(0);                
        }
        if(AIWcommonUtility.getConfigurationValues('projectId').get(0) != null)
        {
            projectId= AIWcommonUtility.getConfigurationValues('projectId').get(0);                
        }
        if(AIWcommonUtility.getConfigurationValues('accessToken').get(0) != null)
        {
            accessToken= AIWcommonUtility.getConfigurationValues('accessToken').get(0);                
        }
        System.debug('USbrand at 307is.......'+USbrand); 
        if(USbrand.contains(' '))
            
        {
            System.debug('USbrand at 306is.......'+USbrand); 
            if(AIWcommonUtility.getConfigurationValues(USbrand.substring(0,4)).get(0) != null)
            {
                queryId= AIWcommonUtility.getConfigurationValues(USbrand.substring(0,4)).get(0);  
                System.debug('queryId at 307is.......'+queryId);              
            }
        }
        else{
            System.debug('USbrand at 313 is.......'+USbrand); 
            if(AIWcommonUtility.getConfigurationValues(USbrand).get(0) != null)
            {
                queryId= AIWcommonUtility.getConfigurationValues(USbrand).get(0); 
                System.debug('queryId at 309is.......'+queryId);            
            }
        }
        
        
        
        endDate = convertdate(system.today());
        startDate = convertdate(system.today() - 6);
        
        String baseUrl = 'https://newapi.brandwatch.com/projects/1998165444/data/mentions?endDate='+endDate+'&limit='+Limits+'&location='+location+'&orderBy='+orderBy+'&orderDirection='+orderDirection+'&pageType='+pageType+'&queryId='+queryId+'&startDate='+startDate+'&projectId='+projectId+'&access_token='+accessToken+'';
        
        String baseUrl1 = 'https://newapi.brandwatch.com/projects/1998165444/data/mentions?endDate=2015-11-25&limit=5&location=uk&orderBy=influence&orderDirection=desc&pageType=twitter&queryId=1998300286&startDate=2015-11-18&projectId=1998165444&access_token=7221b7f3-1bff-4511-aad7-9cbd415f547e';
        system.debug('USbrand......'+USbrand);
        // System.debug('baseURL  is.......'+baseUrl);
        // System.debug('baseURL1 is.......'+baseUrl1);
        // String baseUrl = 'https://newapi.brandwatch.com/projects/1998165444/data/mentions?endDate=2015-11-25&limit=5&location=uk&orderBy=influence&orderDirection=desc&pageType=twitter&queryId=1998448902&startDate=2015-11-18&projectId=1998165444&access_token=7221b7f3-1bff-4511-aad7-9cbd415f547e';
        HTTPRequest request = new HTTPRequest();              
        request.setEndpoint(baseUrl);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('GET');
        request.setTimeout(120000);
        
        HTTP http = new HTTP();
        HTTPResponse  response =  http.send(request);    
        response.getStatusCode();
        response.getBody();
        system.debug('response.getBody()'+response.getBody());
        String strjson;
        
        strjson =response.getBody().substring(response.getBody().indexOf('"results":')+10);
        system.debug('strjson is at41.....'+strjson);
        // if(strjson.contains('maximumId')){
        // strjson =strjson.substring(0,strjson.indexOf(',"maximumId"'));
        // }
        strjson =strjson.substring(0,strjson.indexOf(',"maximumId"'));
        
        strjson = strjson.replace('"date":','"sociodate":');
        
        system.debug('strjson is at 47.....'+strjson);
        jobs =AIWJSONParser_2.parse(strjson);
        system.debug('Job Size........'+jobs.size());
        //system.debug('Job Size1........'+jobs[0].avatarUrl);
        //system.debug('Job Snippet........'+jobs[1]);
        jw =new list<jsonwrapper>();
        for (integer i=0;i<jobs.size();i++)
        {
            jw.add(new jsonwrapper(jobs[i].avatarUrl,jobs[i].snippet,jobs[i].twitterRetweets,jobs[i].reach,jobs[i].twitterFollowing,jobs[i].influence,jobs[i].outreach,jobs[i].sociodate,jobs[i].fullname));
            
            if(i==0){
                jw1=jw[0];
                
                String dt=setStringToDateFormat(jw1.sociodate);
                
                jw1.sociodate=dt;
                system.debug('JW1 is..........'+jw1);
            }
            if(i==1){
                jw2=jw[1];
                String dt=setStringToDateFormat(jw2.sociodate);
                jw2.sociodate=dt;
                
            }
            if(i==2){
                jw3=jw[2];
                String dt=setStringToDateFormat(jw3.sociodate);
                jw3.sociodate=dt;
            }
            if(i==3){
                jw4=jw[3];
                String dt=setStringToDateFormat(jw4.sociodate);
                jw4.sociodate=dt;
            }
            if(i==4){
                jw5=jw[4];
                String dt=setStringToDateFormat(jw5.sociodate);
                jw5.sociodate=dt;
            }
        }  
    }    
    public string setStringToDateFormat(String t1) {
        t1=t1.substring(0,t1.indexOf('T'));
        String[] myDateOnly = t1.split(' ');
        String[] strDate = myDateOnly[0].split('-');
        Integer myIntDate = integer.valueOf(strDate[2]);
        Integer myIntMonth = integer.valueOf(strDate[1]);
        Integer myIntYear = integer.valueOf(strDate[0]);  
        Datetime myDatetime = Datetime.newInstance(myIntYear, myIntMonth, myIntDate);
        String myDatetimeStr = myDatetime.format('d MMM'); 
        system.debug('D value is..........'+myDatetimeStr);
        
        return myDatetimeStr;
    }  
    
    public string convertdate(Date sd)
    {
        string dts=sd.format();
        String[] strDate = dts.split('/');
        String myIntDate = strDate[0];
        String myIntMonth = strDate[1];
        String myIntYear = strDate[2];
        string dts1=myIntYear+'-'+myIntMonth+'-'+myIntDate;
        return dts1;
    }
    
    public class jsonwrapper
    {
        public String avatarUrl{get;set;}
        public String snippet{get;set;}
        public Integer twitterRetweets{get;set;}
        public Integer reach{get;set;}
        public Integer twitterFollowing{get;set;}
        public Integer influence{get;set;}
        public Integer outreach{get;set;}
        public String sociodate{get;set;}
        public String fullname{get;set;}
        
        public jsonwrapper(String avatarUrl,String snippet,Integer twitterRetweets,Integer reach,Integer twitterFollowing,Integer influence,Integer outreach,String sociodate,String fullname){
            this.avatarUrl=avatarUrl;
            this.snippet=snippet;
            this.twitterRetweets=twitterRetweets;
            this.reach=reach;
            this.twitterFollowing=twitterFollowing;
            this.influence=influence;
            this.outreach=outreach;
            this.outreach=outreach;
            this.sociodate=sociodate;            
            this.fullname=fullname;
        }
    }       

}