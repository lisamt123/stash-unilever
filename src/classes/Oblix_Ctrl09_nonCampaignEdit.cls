/**
    About
    -----
    Description: Class Oblix_Ctrl09_nonCampaignEdit
    Created for: OBLIX Project
    Create date: Nov 2, 2015
    Created by Achraf ELHITARY
    Details
    -------
    
       Update History
    --------------    
*/
    public with sharing class Oblix_Ctrl09_nonCampaignEdit{
    
      
        public User userConnected {get;set;}
        
        public  id MSid  {get;set;}
        public Marketing_SOW__c Marketing_SOW   {get;set;}
        public Marketing_Basics__c newItem  {get;set;}
        public Marketing_Basics__c newItem1  {get;set;}
        
        public List<Marketing_Basics__c> newItems  {get;set;}
        public Boolean pick {get;set;}
        public Boolean nopick {get;set;}
        public String fYear {get;set;}
        public String agency {get;set;}
        private List<Oblix_Calculator__c> lstCalculatorRate = new List<Oblix_Calculator__c>();
        public Marketing_Basics__c OItem {get;set;}
        public set<String> setAgencyDept {get;set;}
        
        
       
        public Boolean isroledisabled {get;set;}
        public Boolean isAgencydisabled {get;set;}
        public set<String> setRoleTitle {get;set;}
        
        public String name {get;set;}
        public Marketing_Basics__c lookupActivity{get;set;}
        public String selectedRoleTitle{get;set;}        
        public String selectedCountry{get;set;}
        public String selectedCountryname{get;set;}
        public String selectedAgencyDepartment{get;set;}
        public String Rate {get;set;}
        public String result {get;set;}
        public integer hours{get;set;}
        
        public String name1{get;set;}
        public String dedicatedResource {get;set;}
        public String selectedRoleTitle1{get;set;}
        public String selectedCountry1{get;set;}
        public String selectedCountryname1{get;set;}
        public String selectedAgencyDepartment1{get;set;}
        public String Rate1 {get;set;}
        public String result1 {get;set;}
        public integer prcent{get;set;}
        
        public String saveStatus {get;set;}
        
        public Boolean agencyVisible {get;set;}
        public Boolean roleVisible {get;set;}
        public Boolean hoursVisible {get;set;}
        public Boolean rateVisible {get;set;}
        public Boolean resultVisible {get;set;}
        public Boolean addVisible {get;set;}
        
         public Boolean agencyVisible1 {get;set;}
        public Boolean roleVisible1 {get;set;}
        public Boolean prcentVisible1 {get;set;}
        public Boolean rateVisible1 {get;set;}
        public Boolean resultVisible1 {get;set;}
        public Boolean addVisible1 {get;set;}
        
        
        Public Integer ElemToDel  {get;set;}     
        Public Integer ElemToEdit  {get;set;}
        Public boolean edit1{get;set;}
        Public boolean edit2{get;set;}
        
        public List<SelectOption> countries {get;set;}
        public List<SelectOption> AgencyDepartments{get;set;}
        public List<SelectOption> RoleTitles{get;set;}
        
        public List<SelectOption> AgencyDepartments1 {get;set;}
        public List<SelectOption> RoleTitles1 {get;set;}
        
        
        public  id rtActivity  {get;set;}
        public  id rtResource  {get;set;}
        
        public  id rtCountry {get;set;}
        private String marKObjName= 'Marketing_Basics__c';
       


        
        public Oblix_Ctrl09_nonCampaignEdit(){
        
             Id idUser = UserInfo.getUserId();
             userConnected = [Select Name from User where Id =: idUser ];
             newItems = new List<Marketing_Basics__c> () ;
             newItem= new Marketing_Basics__c();
             newItem1= new Marketing_Basics__c(); 
             lookupActivity= new Marketing_Basics__c(); 
             lookupActivity.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get('Activity');
             pick=true;
             nopick=false;
             
             reRenderSOW(); 
             saveStatus ='';
             agencyVisible =false;
             roleVisible =false;
             hoursVisible =false;
             //rateVisible =false;
             resultVisible =false;
             addVisible=false;
             
             ElemToEdit  =-1;
             edit1=false;
             edit2=false;
             
              rtActivity  = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Activity').getRecordTypeId();
              rtResource = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
              rtCountry =  Schema.SObjectType.Oblix_Calculator__c.getRecordTypeInfosByName().get('Role Rate').getRecordTypeId();
              
              initialiseOptions();
             
        }
        
      private void  initialiseOptions(){
        
         AgencyDepartments = new List<SelectOption>();         AgencyDepartments.add(new SelectOption('','Agency Department'));  
         RoleTitles =new  List<SelectOption>();           RoleTitles.add(new SelectOption('','Role'));  
         AgencyDepartments1  =new  List<SelectOption>();           AgencyDepartments1.add(new SelectOption('','Agency Department'));  
         RoleTitles1 =new List<SelectOption>();           RoleTitles1.add(new SelectOption('','Role'));  
               
      }
        
      public void reRenderSOW(){
            MSid= ApexPAges.currentPage().getParameters().get('MSid');
          //   if (MSid==null) MSid='a6KM00000004gB8' ;
             
           if (MSid==null) MSid='a6KM0000000CdFJ' ;
             
             Marketing_SOW  = [select id,Financial_Year__c,Oblix_AgencyEstimate__c,Oblix_AgencyEstimate__r.Name from Marketing_SOW__c where id =: MSid];
             fYear = Marketing_SOW.Financial_Year__c;
             agency = Marketing_SOW.Oblix_AgencyEstimate__c;
             fillCountries();
             
             
     }
     public void clear(){
     
         lookupActivity.Activities__c= '';
         lookupActivity.Other_Activities__c='';
         hours= 0;
         selectedCountry = '';
         selectedRoleTitle='';
         selectedAgencyDepartment='';
         result='';
         rate = '';
         
         
             agencyVisible =false;
             roleVisible =false;         
             hoursVisible =false;
             resultVisible =false;
             addVisible=false;
     
     }
      public void clear1(){
             agencyVisible1 =false;
             roleVisible1 =false;         
             prcentVisible1 =false;
             resultVisible1 =false;
             addVisible1=false;
     }
     
     public pagereference saveList(){
         upsert newItems;
         saveStatus='Saved';
         return null;
     }
     public void delElm(){
         if (newItems[elemToDel].id!=null) delete newItems[elemToDel];
         newItems.remove(elemToDel);
         saveStatus='Unsaved';
         
     }
     
     
     
     public void editItem(){
         //newItems[elemToEdit] ;
         
         
         Id devRecordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Activity').getRecordTypeId();
         
         if (newItems[elemToEdit].recordTypeId == devRecordTypeId){
             newItem=newItems[elemToEdit]; 
             name = newItems[elemToEdit].name;
             lookupActivity.Activities__c = newItems[elemToEdit].Activities__c;
             lookupActivity.Other_Activities__c= newItems[elemToEdit].Other_Activities__c;
             
             hours=Integer.valueof(newItems[elemToEdit].No_of_Hours_Required__c) ;
             selectedCountry=newItems[elemToEdit].OblixCountry__c ;
             selectedRoleTitle =newItems[elemToEdit].Role_Title__c ;
             selectedAgencyDepartment = newItems[elemToEdit].Agency_Department__c ;
             result = String.valueof(newItems[elemToEdit].OblixOtherItemFee__c) ;
             edit1=true;
         }else{
             devRecordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
             if (newItems[elemToEdit].recordTypeId == devRecordTypeId){
                 newItem=newItems[elemToEdit]; 
                 name1 = newItems[elemToEdit].name;
                 prcent=Integer.valueof(newItems[elemToEdit].FTE__c) ;
                 selectedCountry1=newItems[elemToEdit].OblixCountry__c ;
                 selectedRoleTitle1 =newItems[elemToEdit].Role_Title__c ;
                 selectedAgencyDepartment1 = newItems[elemToEdit].Agency_Department__c ;
                 result1 = String.valueof(newItems[elemToEdit].OblixOtherItemFee__c) ; 
                 edit2=true;
             }
         }
         
         system.debug('===========newItems[elemToEdit].recordTypeId='+newItems[elemToEdit].recordTypeId);
         system.debug('===========newItem1='+newItem1);
         system.debug('===========newItem='+newItem);
     }
        
     
     
     public void addToNew(){
     
         saveStatus ='Unsaved';
         
         Id devRecordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Activity').getRecordTypeId();
         
        
         //recordtype
         
         newItem=new Marketing_Basics__c ();
         newItem.name=name;
        // if (pick) {
             newItem.Activities__c= lookupActivity.Activities__c;
             newItem.Other_Activities__c= lookupActivity.Other_Activities__c;
             
        // }else { newItem.Activities__c= lookupActivity.name;} 
         newItem.recordTypeId=  devRecordTypeId ;
         newItem.Oblix_SOWMarketing__c=Marketing_SOW.id;
         newItem.No_of_Hours_Required__c = hours;
         newItem.OblixCountry__c =selectedCountry;
         newItem.Role_Title__c =selectedRoleTitle;
         newItem.Agency_Department__c =selectedAgencyDepartment;
         newItem.OblixOtherItemFee__c = Integer.valueof(result);
         if (edit1){ // c'est un update
              newItems[ElemToEdit] = newItem; 
              edit1=false;
             }else newItems.add(newItem);// cest un ajout
             
           
         newItem=new Marketing_Basics__c ();
         
         
       //  clear();
        // system.debug('============toto'+newItems);
        
        
          
          
     }
     
     public void addToNew1(){
         saveStatus ='Unsaved';
         
         Id devRecordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
         
        
         //recordtype
         newItem1=new Marketing_Basics__c ();
         
         newItem1.name=name1;
         newItem1.Activities__c= dedicatedResource ;
         newItem1.recordTypeId=  devRecordTypeId ;
         newItem1.Oblix_SOWMarketing__c=Marketing_SOW.id;
         newItem1.FTE__c= prcent;
         newItem1.OblixCountry__c =selectedCountry1;
         newItem1.Role_Title__c =selectedRoleTitle1;
         newItem1.Agency_Department__c =selectedAgencyDepartment1;
         newItem1.OblixOtherItemFee__c = Integer.valueof(result1);
          if (edit2){ // c'est un Edit
              newItems[ElemToEdit] = newItem1;
              edit2=false;
             }else newItems.add(newItem1);
        
         newItem=new Marketing_Basics__c ();
         system.debug('============toto'+newItems);
         
         
        
        
          
          
     }
     
     public void calculResult(){ 
          result = String.valueof( Integer.valueof(rate.trim()) *hours );
          
     }
     public void calculResult1(){ 
     
          if ( prcent !=0 ){     result1 = String.valueof( Integer.valueof(rate1.trim()) /prcent);}
          else result1 =  String.valueof(0);
          
          
     }
     
     
     public void fillRate1(){ 
            rateVisible1 =false;
            prcentVisible1 =false;
            resultVisible1 =false;
            addVisible1=false;               
            List <Oblix_Calculator__c> Rates= new List <Oblix_Calculator__c>();
            //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
            Rates=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c,Role_Title__c,FTE__c from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__c=:selectedCountry1 and Agency_Department__c  =:selectedAgencyDepartment1 and Role_Title__c  =:selectedRoleTitle1 ];
            if (Rates.size()==1)
            {
                rateVisible1 =true;
                prcentVisible1 =true;
                resultVisible1 =true;
                addVisible1=true;       
                rate1=String.valueOf(Rates[0].FTE__c) ;
            }//else there is more than 1 or 0 => error 
     }
      public void fillRate(){ 
        //   if (selectedRoleTitle =='Role' || selectedRoleTitle ==null){return ;}
            rateVisible =false;
            hoursVisible =false;
            resultVisible =false;
            addVisible=false;               
            List <Oblix_Calculator__c> Rates= new List <Oblix_Calculator__c>();
            //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
            Rates=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c,Role_Title__c,Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__c=:selectedCountry and Agency_Department__c  =:selectedAgencyDepartment and Role_Title__c  =:selectedRoleTitle ];
            if (Rates.size()==1)
            {
                rateVisible =true;
                hoursVisible =true;
                resultVisible =true;
                addVisible=true;       
                rate=String.valueOf(Rates[0].Role_Daily_Rate_EUR__c) ;
            }//else there is more than 1 or 0 => error 
     }
     
     public void fillRoleTitle(){
     //   if (selectedAgencyDepartment=='' || selectedAgencyDepartment==null){return ;}
            roleVisible =false;
         //   rateVisible =false;
            hoursVisible =false;
            resultVisible =false;
            addVisible=false;         
            List <Oblix_Calculator__c> RoleTitleNames= new List <Oblix_Calculator__c>();
            //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
            RoleTitleNames=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c,Role_Title__c from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__c=:selectedCountry and Agency_Department__c  =:selectedAgencyDepartment];
            map<String,String>  RoleTitleNamesMap =new map<String,String> () ;
            for (Oblix_Calculator__c c: RoleTitleNames){
                if (c.Role_Title__c !=null)
                RoleTitleNamesMap.put(c.Role_Title__c ,c.Role_Title__c);
            }
            RoleTitles= new List<SelectOption>();
            RoleTitles.add(new SelectOption('','Role'));
            if( RoleTitleNamesMap.size()>0){
                roleVisible =true;
                selectedRoleTitle=null ;
                for (String temp: RoleTitleNamesMap.keySet()){
                   // if (selectedRoleTitle==null) selectedRoleTitle= temp; //remplir automatiquement par la premiere valeur
                    RoleTitles.add(new SelectOption(temp,RoleTitleNamesMap.get(temp)));
                }
            //else add error (there is no rt to select)
            }
    }
     public void fillRoleTitle1(){
            roleVisible1 =false;
         //   rateVisible1 =false;
            prcentVisible1 =false;
            resultVisible1 =false;
            addVisible1=false;         
            List <Oblix_Calculator__c> RoleTitleNames= new List <Oblix_Calculator__c>();
            //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
            RoleTitleNames=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c,Role_Title__c from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__c=:selectedCountry1 and Agency_Department__c  =:selectedAgencyDepartment1];
            map<String,String>  RoleTitleNamesMap =new map<String,String> () ;
            for (Oblix_Calculator__c c: RoleTitleNames){
                if (c.Role_Title__c !=null)
                RoleTitleNamesMap.put(c.Role_Title__c ,c.Role_Title__c);
            }
            RoleTitles1= new List<SelectOption>();
            RoleTitles1.add(new SelectOption('','Role'));
            if( RoleTitleNamesMap.size()>0){
                roleVisible1 =true;
                selectedRoleTitle1=null ;
                for (String temp: RoleTitleNamesMap.keySet()){
                   // if (selectedRoleTitle==null) selectedRoleTitle= temp; //remplir automatiquement par la premiere valeur
                    RoleTitles1.add(new SelectOption(temp,RoleTitleNamesMap.get(temp)));
                }
            //else add error (there is no rt to select)
            }
    }
     public void fillAgencyDepartment(){
                 
              RoleTitles =new  List<SelectOption>();         
              RoleTitles.add(new SelectOption('','Role')); 
              selectedRoleTitle=''; 
        
             
             selectedCountry = CountrryGetId(selectedCountryname );
             agencyVisible =false;
             roleVisible =false;
             rateVisible =false;
             hoursVisible =false;
             resultVisible =false;
             addVisible=false;
             
             
             //newItem.OblixCountry__c = selectedCountry;
             
            List <Oblix_Calculator__c> Agency_DepartmentNames= new List <Oblix_Calculator__c>();
            system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
          //  Agency_DepartmentNames=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c  from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__r.name=:selectedCountryname];
          Agency_DepartmentNames= [select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c  from Oblix_Calculator__c where RecordTypeId= : rtCountry  and Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__r.name like :selectedCountryname ];
          if (Agency_DepartmentNames.size()>0) 
          selectedCountry  = Agency_DepartmentNames[0].OblixCountry__c ;
            map<String,String>  Agency_DepartmentMap =new map<String,String> () ;
            Agency_DepartmentMap.put('','Agency Department');
            for (Oblix_Calculator__c c: Agency_DepartmentNames){
            //    if (c.Agency_Department__c  !=null) //remplir automatiquement par la premiere valeur
                Agency_DepartmentMap.put(c.Agency_Department__c  ,c.Agency_Department__c  );
            }
            AgencyDepartments= new List<SelectOption>();
            if( Agency_DepartmentMap.size()>0){
                 agencyVisible =true;
                selectedAgencyDepartment=null ;
                for (String temp: Agency_DepartmentMap.keySet()){
                    if (selectedAgencyDepartment==null) selectedAgencyDepartment= temp;
                    AgencyDepartments.add(new SelectOption(temp,Agency_DepartmentMap.get(temp)));
                }
            //else add error (there is no to select)
            } else{
            agencyVisible =false;
             roleVisible =false;
             //rateVisible =false;
             hoursVisible =false;
             resultVisible =false;
             addVisible=false;
                }
          //  fillRoleTitle();
          
    }
    public void fillAgencyDepartment1(){
            selectedCountry1 = CountrryGetId(selectedCountryname1 );
            //if  (selectedCountry1  == null ) return;
             newItem1.OblixCountry__c = selectedCountry1;   
             agencyVisible1 =false;
             roleVisible1 =false;
           //  rateVisible1 =false;
             prcentVisible1 =false;
             resultVisible1 =false;
             addVisible1=false;
             
            List <Oblix_Calculator__c> Agency_DepartmentNames= new List <Oblix_Calculator__c>();
            system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
           // Agency_DepartmentNames=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c  from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__r.name=:selectedCountryname1 ];
           // Agency_DepartmentNames= [Select Id, Name, RecordTypeId, Role_Daily_Rate_EUR__c, Agency_Department__c,  OblixCountry__r.Name, Oblix_Agency__c,  Role_Title__c, FTE__c, OblixCountry__c from Oblix_Calculator__c where Financial_Year__c=: fYear and OblixCountry__r.name =: selectedCountryname  and   RecordTypeId =: Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Role_Rate') and Oblix_Agency__c =: agency  ];
          
          
            Agency_DepartmentNames= [select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c  from Oblix_Calculator__c where RecordTypeId=  : rtCountry   and Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__r.name like :selectedCountryname1 ];
          if (Agency_DepartmentNames.size()>0) 
          selectedCountry1  = Agency_DepartmentNames[0].OblixCountry__c ;
           system.debug('============================zz=Agency_DepartmentNames'+Agency_DepartmentNames);
            
            map<String,String>  Agency_DepartmentMap =new map<String,String> () ;
            Agency_DepartmentMap.put('','Agency Department');
            for (Oblix_Calculator__c c: Agency_DepartmentNames){
            //    if (c.Agency_Department__c  !=null) //remplir automatiquement par la premiere valeur
                Agency_DepartmentMap.put(c.Agency_Department__c  ,c.Agency_Department__c  );
            }
            AgencyDepartments1= new List<SelectOption>();
            if( Agency_DepartmentMap.size()>0){
                 agencyVisible1 =true;
                selectedAgencyDepartment1=null ;
                for (String temp: Agency_DepartmentMap.keySet()){
                    if (selectedAgencyDepartment==null) selectedAgencyDepartment= temp;
                    AgencyDepartments1.add(new SelectOption(temp,Agency_DepartmentMap.get(temp)));
                }
            
            } //else add error (there is no to select) 
          //  fillRoleTitle();
    }
    
    private id CountrryGetId(String Cname){
        List <MDO_Geography__c> temp = null;
        id x =null;
       
        temp=[select id from MDO_Geography__c where name =:Cname limit 1];
        system.debug('===========Cname'+Cname);
        system.debug('===========temp'+temp);
        
        
        if (temp ==null) return temp[0].id;
        else return null;
    }
            
    private set<String> CountriesByFYear(String fYear_loc){
          List<Oblix_Calculator__c> lstCalculatorBoxNumber = [Select Name from Oblix_Calculator__c  where RecordTypeId =: Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Country_Box_Number') and Financial_Year__c =:fYear_loc];
          set<String> setCountries = new set<String>();
          if(!lstCalculatorBoxNumber.isEmpty()){
            for(Oblix_Calculator__c calc : lstCalculatorBoxNumber){
                 setCountries.add(calc.Name);
            }
         }    
         return setCountries;
     }
      /*
     * @Name : getCountry
     * @PAram : None
     *  @reference : CountriesByFYear(Fyea)
     * @return SelectOption of Countries
     */
     public List<SelectOption> getCountry(){
         set<String> setCountry = new Set<String>();
            setCountry =  CountriesByFYear(fYear);   
         List<SelectOption> options= new List<SelectOption>();
           options.add(new SelectOption('', 'Country'));
            if(setCountry != null && !setCountry.isEmpty()){
                for(String country : setCountry){
                    if(country != null){
                        options.add(new SelectOption(country, country));  
                    }
                }
            }
          
            return options;
     }
    
     public void fillCountries(){ 
     
                 
            countries=getCountry();
          
    }
    
    
    
   
    public PageReference save(){ 
        try{
            if(OItem.RecordTypeId == Oblix_Utils.MapRecordType(marKObjName).get('Resource') && !lstCalculatorRate.IsEmpty() && lstCalculatorRate.size()>0 && OItem.FTE__c != null && OItem.FTE__c > 0){
                OItem.OblixOtherItemFee__c = lstCalculatorRate[0].FTE__c/OItem.FTE__c; 
            }else if(OItem.FTE__c == null || OItem.FTE__c == 0){
                OItem.OblixOtherItemFee__c = lstCalculatorRate[0].FTE__c;
            }
            else if(OItem.RecordTypeId == Oblix_Utils.MapRecordType(marKObjName).get('Activity') && !lstCalculatorRate.IsEmpty() && lstCalculatorRate.size()>0 && OItem.No_of_Hours_Required__c != null && lstCalculatorRate[0].Role_Daily_Rate_EUR__c != null){
                OItem.OblixOtherItemFee__c = lstCalculatorRate[0].Role_Daily_Rate_EUR__c * OItem.No_of_Hours_Required__c;
            }else{
                 OItem.OblixOtherItemFee__c = 0;
            }
            //OItem.Discipline__c = selectedDiscipline;
            OItem.Agency_Department__c = selectedAgencyDepartment;
            OItem.Role_Title__c = selectedRoleTitle;
            
            if(OItem.Id != null){
                update OItem;
            }else{
                insert OItem;
            }
            return new PageReference('/'+OItem.Id);
            
        }catch(DmlException e){
            System.debug('###Exception Occured :'+e.getMessage());  
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured during save please review data entry'));
        }
        return null;
    }
        
    public Integer calculsomme(){
        Decimal somme = 0;
        for (Marketing_Basics__c a : newitems){
            somme+=a.OblixOtherItemFee__c ;
        } 
        return Integer.valueof(somme);
    }
    public pagereference back(){
         PageReference  page = new PageReference('/apex/Oblix_VF06_SOWView?sowId='+MSid);
           page.setRedirect(True);
           return page;
        return null;
    }
      
     
      
    }