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
        
        public List<Marketing_Basics__c > XItems  {get;set;}
        
        public Marketing_Basics__c newItem1  {get;set;}
        public List<Marketing_Basics__c> newItems  {get;set;}
        
        public Boolean pick {get;set;}
        public Boolean nopick {get;set;}
        public Boolean TitleEdit {get;set;}
        
        
        public String fYear {get;set;}
        public String agency {get;set;}
        public String MScurrency {get;set;}
        
        
        public String name {get;set;}
        public id itemID{get;set;} 
        public Marketing_Basics__c lookupActivity{get;set;}
        public String selectedRoleTitle{get;set;}        
        public String selectedCountry{get;set;}
        public String selectedCountryname{get;set;}
        public String selectedAgencyDepartment{get;set;}
        public String Rate {get;set;}
        public String result {get;set;}
        
        public  integer hours {get;set;}
      //  public integer hours{get{if (hours == null) return 0; else return hours ;  }set;}
       // public Integer gethours(){if (hours == null) return 0; else return hours ;  }
        
        public String name1{get;set;}
        public id itemID1 {get;set;}
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
        
        private String marKObjName= System.Label.Oblix_Lbl_Marketing_Basics_c ;
        private String ActivityName= System.Label.Oblix_Lbl_Activity;
        
        private String noRole= System.Label.Oblix_Lbl_Role;
        
       
        public Decimal somme ;
        
        public boolean errMsg  {get;set;}
        public boolean myMessages {get;set;}
        public boolean errMsg1  {get;set;}
        public boolean myMessages1 {get;set;}
        
        
        public boolean   selectResource {get;set;}    //true to render a js code who trigger  resource tab                

         /* Constructor
         */ 
        public Oblix_Ctrl09_nonCampaignEdit(){
        
              selectResource=false;
              TitleEdit =false;
        
         errMsg  =false;
         myMessages = false;
         errMsg1  =false;
         myMessages1 = false;
       
        
             Id idUser = UserInfo.getUserId();
             userConnected = [Select Name from User where Id =: idUser ];
             newItems = new List<Marketing_Basics__c> () ;
             XItems  =new List<Marketing_Basics__c >();
             newItem= new Marketing_Basics__c();
             newItem1= new Marketing_Basics__c(); 
             lookupActivity= new Marketing_Basics__c(); 
             lookupActivity.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get(ActivityName);
             pick=true;
             nopick=false;
             
             MSid= ApexPAges.currentPage().getParameters().get('MSid');
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
             
              rtActivity  = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
              rtResource = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
              rtCountry =  Schema.SObjectType.Oblix_Calculator__c.getRecordTypeInfosByName().get('Role Rate').getRecordTypeId();
              
              initialiseOptions();
              initialiseOptions1();
              
              
            id EditId =  ApexPAges.currentPage().getParameters().get('itm');
            if (EditId !=null){
                TitleEdit =true;
                  elemToEdit=0 ;
               
             
                Marketing_Basics__c  editItem = [select id,name,non_campaign_title__c,FTE__c,recordTypeId,OblixOtherItemFee__c,Agency_Department__c,Role_Title__c,Activities__c,Other_Activities__c,No_of_Hours_Required__c,OblixCountry__c ,Oblix_SOWMarketing__c from Marketing_Basics__c where id = :EditId  ];
                MSid= editItem.Oblix_SOWMarketing__c ;
                reRenderSOW(); 
                newItems.add(editItem);
                fillData(editItem);
                
                 
            }
             
        }
        
        
        
private void fillData(Marketing_Basics__c   eeditItem){
               
         MDO_Geography__c g ;
               if (eeditItem.recordTypeId == rtActivity ) {
                  agencyVisible =true;
                  roleVisible =true;
                  hoursVisible =true;
                  //rateVisible =true;
                  resultVisible =true;
                  addVisible=true;
                  hours=Integer.valueof(eeditItem.No_of_Hours_Required__c);
                  
                 
                  fillCountries();
                   g = [ select id, name from MDO_Geography__c where id =:eeditItem.OblixCountry__c ];
                   selectedCountryname=  g.name.toUpperCase()  ;//'FRANCE' ;
                  fillAgencyDepartment();                  
                   selectedAgencyDepartment = eeditItem.Agency_Department__c;
                 fillRoleTitle();
                   selectedRoleTitle =  eeditItem.Role_Title__c ;      
                  fillRate();
                   edit1=true;
                 
                  name=eeditItem.name;
                  itemID =eeditItem.id;
                  lookupActivity.Activities__c = eeditItem.Activities__c ;
                  lookupActivity.Other_Activities__c= eeditItem.Other_Activities__c;
                  result = String.valueof( eeditItem.OblixOtherItemFee__c ) ;
                  
                  
                }else{  
                  selectResource = true;
                  agencyVisible1 =true;
                  roleVisible1 =true;
                  prcentVisible1 =true;
                  prcent=Integer.valueof(eeditItem.FTE__c);
                  //rateVisible =true;
                  resultVisible1 =true;
                  addVisible1=true;
                
                  name1=eeditItem.name;
                  itemID1 = eeditItem.id;
                  
                 fillCountries();
                  g = [ select id, name from MDO_Geography__c where id =:eeditItem.OblixCountry__c ];
                   
                  selectedCountryname1=  g.name.toUpperCase() ;//'FRANCE' ;
                 fillAgencyDepartment1();
                   selectedAgencyDepartment1 = eeditItem.Agency_Department__c;
                 fillRoleTitle1();
                   selectedRoleTitle1 =  eeditItem.Role_Title__c ;      
                  fillRate1();
                   edit2=true;
                   result1 = String.valueof(eeditItem.OblixOtherItemFee__c)  ;
                 
                  
                }
          }
        
        /* Void Method used to initialise SelectOptions
         */  
      private void  initialiseOptions(){
         AgencyDepartments = new List<SelectOption>();         AgencyDepartments.add(new SelectOption('','Agency Department'));  
         RoleTitles =new  List<SelectOption>();           RoleTitles.add(new SelectOption('',noRole));  
               
      }
      private void  initialiseOptions1(){
        AgencyDepartments1  =new  List<SelectOption>();           AgencyDepartments1.add(new SelectOption('','Agency Department'));  
         RoleTitles1 =new List<SelectOption>();           RoleTitles1.add(new SelectOption('',noRole));  
               
      } 
      
        /* Void Method used to initialise Marketing_SOW  
         */    
      public void reRenderSOW(){
           
             if (MSid!=null){
               Marketing_SOW  = [select id,Financial_Year__c,currency__c,Oblix_AgencyEstimate__c,Oblix_AgencyEstimate__r.Name from Marketing_SOW__c where id =: MSid];
               fYear = Marketing_SOW.Financial_Year__c;
               agency = Marketing_SOW.Oblix_AgencyEstimate__c;
               MScurrency = Marketing_SOW.currency__c ; 
               fillCountries();
             }
             
             
     }
     
     
      /* Method used to clear form activity
         * @Void
      */ 
      
     public void clear(){
        initialiseOptions();
         lookupActivity.Activities__c= '';
         lookupActivity.Other_Activities__c='';
         hours= 0;
         selectedCountry = '';
         selectedCountryname='';
         selectedRoleTitle='';
         selectedAgencyDepartment='';
         result='';
         rate = '';
         name= '';
             agencyVisible =false;
             roleVisible =false;         
             hoursVisible =false;
             resultVisible =false;
             addVisible=false;
            
     }
     
      /* Method used to clear form resource
         * @Void
      */ 
      public void clear1(){
         initialiseOptions1();
         prcent= 0;
         selectedCountry1 = '';
         selectedCountryname1='';
         selectedRoleTitle1='';
         selectedAgencyDepartment1='';
         result1='';
         rate1 = '';
         name1= '';
             agencyVisible1 =false;
             roleVisible1 =false;         
             prcentVisible1 =false;
             resultVisible1 =false;
             addVisible1=false;
     }
     
      /* Method used to save current List (upsert)
       * @Void 
      */ 
     public pagereference saveList(){
         try{
         
          /*   
             for (Marketing_Basics__c  itm : newItems){
                 if (itm.id == null ) {insert itm;}
                 else { update itm;}
                     
             }*/
             
             upsert newItems;
             delete Xitems;
             myMessages=false;
             myMessages1=false;
         }catch(DmlException e){
             System.debug('###Exception Occured :'+e.getMessage());  
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured during save please review data entry'));
             myMessages=true;
             myMessages1=true;
         }
         
         
         Xitems=new List<Marketing_Basics__c >();
         saveStatus='Saved';
         return null;
     }
     
     
     public void delElm(){
         if (newItems[elemToDel].id!=null) Xitems.add(newItems[elemToDel]);
         newItems.remove(elemToDel);
         saveStatus='Unsaved';
     }
     
     
     
     public void editItem(){
     
       fillData(newItems[elemToEdit]);
    
     }
        
     
     
     public void addToNew(){
     
        
         
        if (name == null || name == '' ){
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Name value is required.'));
              myMessages=true;
              return;
         }
          saveStatus ='Unsaved';
        myMessages=false;
         Id devRecordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
         
        
         //recordtype
          if (edit1){ // c'est un update
             
              newItem=newItems[ElemToEdit] ; 
              
             
             }else{  newItem=new Marketing_Basics__c ();
              newItem.Oblix_SOWMarketing__c=Marketing_SOW.id;
              }
         newItem.name=name;
        
             newItem.Activities__c= lookupActivity.Activities__c;
             newItem.Other_Activities__c= lookupActivity.Other_Activities__c;
             
         Map <String,String > abrev = Oblix_Utils.getAbreViationForCardAssets();
         string abr= abrev.get(lookupActivity.Activities__c);
         if (abr == null) abr = '';
         newItem.non_campaign_title__c =  'ACT-'+abr;
         //lookupActivity.Activities__c
     //    newItem.id =itemID ;
         newItem.recordTypeId=  devRecordTypeId ;
        
         newItem.No_of_Hours_Required__c = hours;
         newItem.OblixCountry__c =selectedCountry;
         newItem.Role_Title__c =selectedRoleTitle;
         newItem.Agency_Department__c =selectedAgencyDepartment;
         calculResult();
         newItem.OblixOtherItemFee__c = Decimal.valueof(result).setScale(2);  // result =result.setScale(2);
         Marketing_Basics__c  x = newItem ;
         if (edit1){ // c'est un update
             
              newItems[ElemToEdit] = x; 
              edit1=false;
             
             }else newItems.add(x);// cest un ajout
             
        clear();
          
     }
     
     public void addToNew1(){
         saveStatus ='Unsaved';
          if (name1 == null || name1 == '' ){
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Name value is required.'));
               myMessages1=true;
              return;
         }
         myMessages1=false;
         
         Id devRecordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get('Dedicated Resource').getRecordTypeId();
         
        
         //recordtype
         newItem1=new Marketing_Basics__c ();
         
         newItem1.name=name1;
         newItem1.non_campaign_title__c=name1;
         newItem1.recordTypeId=  devRecordTypeId ;
         newItem1.Oblix_SOWMarketing__c=Marketing_SOW.id;
         newItem1.FTE__c= prcent;
         newItem1.OblixCountry__c =selectedCountry1;
         newItem1.Role_Title__c =selectedRoleTitle1;
         newItem1.id= itemID1 ;
         newItem1.Agency_Department__c =selectedAgencyDepartment1;
         calculResult1();
         newItem1.OblixOtherItemFee__c = Decimal.valueof(result1).setScale(2);  // result =result.setScale(2)
          if (edit2){ // c'est un Edit
              newItems[ElemToEdit] = newItem1;
              edit2=false;
             }else newItems.add(newItem1);
        
         newItem=new Marketing_Basics__c ();
        clear1(); 
        
        
          
          
     }
     
     public void calculResult(){ 
        system.debug('============+=+=+=+=+=+=+=+=+= calculResult=+=+=+=+=+=+=+=+=+============================');    
     
          result = String.valueof(( Decimal.valueof(rate.trim()) *hours).setScale(2) );
        //  result =result;
          
     }
     public void calculResult1(){ 
      system.debug('============+=+=+=+=+=+=+=+=+= calculResult1=+=+=+=+=+=+=+=+=+============================');    
     
           result1 = String.valueof(( Decimal.valueof(rate1.trim()) *prcent/100).setScale(2)); 
           //result1 =result1;       
     }
     
     
     public void fillRate1(){ 
      system.debug('============+=+=+=+=+=+=+=+=+= fillrate1 =+=+=+=+=+=+=+=+=+============================');    
           
            rateVisible1 =false;
            prcentVisible1 =false;
            resultVisible1 =false;
            addVisible1=false;               
            List <Oblix_Calculator__c> Rates= new List <Oblix_Calculator__c>();
            //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
            Rates=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c,Role_Title__c,FTE__c from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__c=:selectedCountry1 and Agency_Department__c  =:selectedAgencyDepartment1 and Role_Title__c  =:selectedRoleTitle1 ];
            if (Rates.size()>=1)
            {
                rateVisible1 =true;
                prcentVisible1 =true;
                resultVisible1 =true;
                addVisible1=true;       
                rate1=String.valueOf(Rates[0].FTE__c) ;
                errMsg1=false;
            }
            if (Rates.size()>1){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'There are duplicate records with the selected values'));
                  errMsg1=true;
            }
            //else there is more than 1 or 0 => error 
     }
      public void fillRate(){ 
          system.debug('============+=+=+=+=+=+=+=+=+= fillrate =+=+=+=+=+=+=+=+=+============================');    
      
        //   if (selectedRoleTitle ==noRole || selectedRoleTitle ==null){return ;}
            rateVisible =false;
            hoursVisible =false;
            resultVisible =false;
            addVisible=false;               
            List <Oblix_Calculator__c> Rates= new List <Oblix_Calculator__c>();
            //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
            Rates=[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name,Agency_Department__c,Role_Title__c,Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c=:fYear and  Oblix_Agency__c =:agency and OblixCountry__c=:selectedCountry and Agency_Department__c  =:selectedAgencyDepartment and Role_Title__c  =:selectedRoleTitle ];
            if (Rates.size()>=1)
            {
                rateVisible =true;
                hoursVisible =true;
                resultVisible =true;
                addVisible=true;       
                rate=String.valueOf(Rates[0].Role_Daily_Rate_EUR__c) ;
                  errMsg=false;
            }
            if (Rates.size()>1){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,'There are duplicate records with the selected values'));
                  errMsg=true;
            }
            //else there is more than 1 or 0 => error 
     }
     
     public void fillRoleTitle(){
     system.debug('============+=+=+=+=+=+=+=+=+= fillRoleTitle=+=+=+=+=+=+=+=+=+============================');    
      
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
            RoleTitles.add(new SelectOption('',noRole));
            if( RoleTitleNamesMap.size()>0){
                roleVisible =true;
                selectedRoleTitle=null ;
                for (String temp: RoleTitleNamesMap.keySet()){
                   // if (selectedRoleTitle==null) selectedRoleTitle= temp; //remplir automatiquement par la premiere valeur
                    RoleTitles.add(new SelectOption(temp,RoleTitleNamesMap.get(temp)));
                }
              RoleTitles= selectOptionSortByLabel(RoleTitles);
            selectedRoleTitle = '' ;
             //else add error (there is no rt to select)
            }
    }
     public void fillRoleTitle1(){
     
     system.debug('============+=+=+=+=+=+=+=+=+= fillRoleTitle1=+=+=+=+=+=+=+=+=+============================');    
      
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
            RoleTitles1.add(new SelectOption('',noRole));
            if( RoleTitleNamesMap.size()>0){
                roleVisible1 =true;
                selectedRoleTitle1=null ;
                for (String temp: RoleTitleNamesMap.keySet()){
                   // if (selectedRoleTitle==null) selectedRoleTitle= temp; //remplir automatiquement par la premiere valeur
                    RoleTitles1.add(new SelectOption(temp,RoleTitleNamesMap.get(temp)));
                }
                
             RoleTitles1= selectOptionSortByLabel(RoleTitles1);
             selectedRoleTitle1 = '' ;
            //else add error (there is no rt to select)
            }
    }
     public void fillAgencyDepartment(){
          system.debug('============+=+=+=+=+=+=+=+=+= fillAgencyDepartment=+=+=+=+=+=+=+=+=+============================');    
     
     
                 
              RoleTitles =new  List<SelectOption>();         
              RoleTitles.add(new SelectOption('',noRole)); 
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
             AgencyDepartments= selectOptionSortByLabel(AgencyDepartments);
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
       system.debug('============+=+=+=+=+=+=+=+=+= fillAgencyDepartment1=+=+=+=+=+=+=+=+=+============================');    
     
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
            AgencyDepartments1= selectOptionSortByLabel(AgencyDepartments1);
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
           system.debug('============+=+=+=+=+=+=+=+=+= fillCountries =+=+=+=+=+=+=+=+=+============================');    
            countries=getCountry();
            countries= selectOptionSortByLabel(countries);
     }
     
     public static list<selectOption> selectOptionSortByLabel(list<selectOption> selectOptionsToSort) { 
        if(selectOptionsToSort == null || selectOptionsToSort.size() <= 1){
            return selectOptionsToSort;
        }
        List<SelectOption> lessSelectOption = new List<SelectOption>();
        List<SelectOption> greaterSelectOption = new List<SelectOption>();
        integer pivot = selectOptionsToSort.size() / 2;
        
        //save the pivot and remove it from the selectOption list
        SelectOption pivotValue = selectOptionsToSort[pivot];
        selectOptionsToSort.remove(pivot);
        for(selectOption SO : selectOptionsToSort){
            if(SO.getLabel() <= pivotValue.getLabel()){
                lessSelectOption.add(SO);
            }else if(SO.getLabel() > pivotValue.getLabel()){
                greaterSelectOption.add(SO);   
            }
        }
        list<selectOption> sortedSelectOptions = new list<selectOption>(); 
        sortedSelectOptions.addAll(selectOptionSortByLabel(lessSelectOption));
        sortedSelectOptions.add(pivotValue);
        sortedSelectOptions.addAll(selectOptionSortByLabel(greaterSelectOption));
        return SortedSelectOptions;
   
       
       }
    
    
    
    
      
    public Decimal getsomme(){
        Decimal somme = 0;
        for (Marketing_Basics__c a : newitems){
            somme+=a.OblixOtherItemFee__c ;
        } 
        return somme.setScale(2);  
    }
    public pagereference back(){
         PageReference  page = new PageReference('/apex/Oblix_VF10_nonCampaignView?MSid='+MSid);
           page.setRedirect(True);
           return page;
        return null;
    }
      
     
      
    }