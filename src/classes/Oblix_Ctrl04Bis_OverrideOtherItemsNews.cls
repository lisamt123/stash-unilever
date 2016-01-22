/** 
    About
    -----
    Description: Class Oblix_Ctrl04Bis_OverrideOtherItemsNews
    Created for: Oblix Unilever Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : Used as a  class to Override New/Edit of Other Items
                        
            Functionnalities : 
                    
    Update History
    --------------    
*/   
public with sharing class Oblix_Ctrl04Bis_OverrideOtherItemsNews {
    private List<Oblix_Calculator__c> lstCalculatorRate = new List<Oblix_Calculator__c>();
    public Marketing_Basics__c OItem {get;set;}
    public String fYear {get;set;}
    public String agency {get;set;}
    public String rtResourceId {get;set;}
    public String rtActivityId {get;set;}
    
    public String selectedAgencyDepartment{get;set;}
    public String selectedRoleTitle{get;set;}
    public String selectedCountryId{get;set;}
    public String selectedCountry{get;set;}
    
    private Marketing_SOW__c parentSow = new Marketing_SOW__c();
    public set<String> setAgencyDept {get;set;}
    public set<String> setRoleTitle {get;set;}
    public Boolean isroledisabled {get;set;}
    public Boolean isAgencydisabled {get;set;}
    private String marKObjName = 'Marketing_Basics__c';
    private String calcObjName = 'Oblix_Calculator__c'; 
    
    public Oblix_Ctrl04Bis_OverrideOtherItemsNews(ApexPAges.StandardController controller){
         if(!System.Test.isRunningTest()){
             controller.addFields(new List<String>{'OblixCountry__c','Agency_Department__c','Role_Title__c','OblixCountry__r.Name','Activities__c','RecordType.Name','Oblix_SOWMarketing__c','Description__c', 'FTE__c', 'No_of_Hours_Required__c', 'Name', 'Id', 'RecordTypeId'});
         }
         rtResourceId = Oblix_Utils.MapRecordType(marKObjName).get('Resource');
         rtActivityId = Oblix_Utils.MapRecordType(marKObjName).get('Activity');
         setAgencyDept = new set<String>();
         setRoleTitle = new set<String>();
         isAgencydisabled = true;
         isroledisabled = true;
          
        this.OItem = (Marketing_Basics__c) controller.getRecord();
        
        if(OItem.Id == null){
            rtResourceId = rtResourceId.substring(0, 15);
            rtActivityId = rtActivityId.substring(0, 15);
        }
        
        if(OItem.Oblix_SOWMarketing__c != null){
             parentSow = [Select Id, Name, Financial_Year__c, Marketing_Agency__c, Oblix_AgencyEstimate__r.Name, Oblix_AgencyEstimate__c from Marketing_SOW__c where id =:OItem.Oblix_SOWMarketing__c];
            System.debug('###parentSow : '+parentSow);
            fYear = parentSow.Financial_Year__c;
            agency = parentSow.Oblix_AgencyEstimate__r.Name;
        }
        if(OItem.Id != null){
            System.debug('!!! '+OItem);
            selectedCountryId = OItem.OblixCountry__c;
            if(selectedCountryId != null){
                selectedCountry = [select name from MDO_Geography__c where id =:selectedCountryId].Name.toUpperCase();
            }
            reRenderAgencyDepartments();
            selectedAgencyDepartment = OItem.Agency_Department__c;
            reRenderRoleTitle();
            selectedRoleTitle = OItem.Role_Title__c;
            
        }
    }
     
     
    
     /*
    @Description : Used in VF4 to refresh fyear and agency values
    */ 
     public void reRenderSOW(){
         parentSow = [Select Id, Name, Financial_Year__c, Marketing_Agency__c, Oblix_AgencyEstimate__r.Name, Oblix_AgencyEstimate__c from Marketing_SOW__c where id =:OItem.Oblix_SOWMarketing__c];
            System.debug('###parentSow : '+parentSow);
            fYear = parentSow.Financial_Year__c;
            agency = parentSow.Oblix_AgencyEstimate__r.Name;
     }
     /*
    @Description : 
    */ 
     public void reRenderAgencyDepartments(){
          
          if(selectedCountry != null && selectedCountry != ''){
              List<MDO_Geography__c > lstCountries = [Select m.parent_L6__c, m.parent_L5__c, m.parent_L4__c, m.parent_L3__c, m.parent_L2__c, 
                    m.parent_L1__c, m.geography_type__c, m.Name, m.Id, parent_L5__r.Name From MDO_Geography__c m where Name =: selectedCountry  and geography_type__c Like 'Country%' Limit 1
                    ];
               System.debug('###lstCountries : '+lstCountries );     
               if(!lstCountries.isEmpty()){
                   OItem.OblixCountry__c= lstCountries[0].Id;
               }
              
          }
            lstCalculatorRate = [Select Id, Name, RecordTypeId, Role_Daily_Rate_EUR__c, Agency_Department__c,  OblixCountry__r.Name, Oblix_Agency__c,
                    Role_Title__c, FTE__c, OblixCountry__c from Oblix_Calculator__c where Financial_Year__c=: fYear and OblixCountry__c =: selectedCountryId  and
                RecordTypeId =: Oblix_Utils.MapRecordType(calcObjName).get('Role_Rate') and Oblix_Agency__c =: parentSow.Oblix_AgencyEstimate__c ];
                
                setAgencyDept = new set<String>();
                if(!lstCalculatorRate.isEmpty()){
                    for(Oblix_Calculator__c calc : lstCalculatorRate){
                        setAgencyDept.add(calc.Agency_Department__c);
                    }
                }
                isAgencydisabled = false;
                getAgencyDepartment();  
     }
     /*
    @Description : ==============
    */ 
     public void reRenderRoleTitle(){
            lstCalculatorRate = [Select Id, Name, RecordTypeId, Role_Daily_Rate_EUR__c, Agency_Department__c,  OblixCountry__r.Name, Oblix_Agency__c,
                    Role_Title__c, FTE__c, OblixCountry__c from Oblix_Calculator__c where Financial_Year__c=: fYear and OblixCountry__c =: selectedCountryId   and
                RecordTypeId =: Oblix_Utils.MapRecordType(calcObjName).get('Role_Rate') and Oblix_Agency__c =: parentSow.Oblix_AgencyEstimate__c and Agency_Department__c =:selectedAgencyDepartment];
            setRoleTitle = new set<String>();       
            if(!lstCalculatorRate.isEmpty()){
                    for(Oblix_Calculator__c calc : lstCalculatorRate){
                        setRoleTitle.add(calc.Role_Title__c);
                    }
                }
            isroledisabled = false;                         
            getRoleTitle(); 
     }
     /*
     *  @Name : CountriesByFYear
     *  @PAram : SOW Financial Year
     *  @return set of  Countries Names
     */
     private set<String> CountriesByFYear(String fYear_loc){
        List<Oblix_Calculator__c> lstCalculatorBoxNumber = [Select Id, Name, Points_Low__c, Points_HigH__c, Box_Range__c, Financial_Year__c,
                             Box_9__c, Box_8__c, Box_7__c, Box_6__c, Box_5__c, Box_4__c, Box_3__c, Box_2__c, Box_20__c, Box_1__c, Box_19__c, Box_18__c, Box_17__c, Box_16__c, Box_15__c, Box_14__c, Box_13__c, Box_12__c, Box_11__c, Box_10__c
                     from Oblix_Calculator__c 
                     where RecordTypeId =: Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Country_Box_Number') and Financial_Year__c =:fYear_loc];
        system.debug('###lstCalculatorBoxNumber : '+lstCalculatorBoxNumber);
        set<String> setCountries = new set<String>();
         if(!lstCalculatorBoxNumber.isEmpty()){
            for(Oblix_Calculator__c calc : lstCalculatorBoxNumber){
                 setCountries.add(calc.Name);
            }
         }     
         system.debug('###setCountries : '+setCountries);
         return setCountries;
     }
     /*
     *  @Name : getCountry
     *  @PAram : None
     *  @reference : CountriesByFYear(Fyea)
     *  @return SelectOption of Countries
     */
     public List<SelectOption> getCountry(){
         set<String> setCountry = new Set<String>();
              setCountry =  CountriesByFYear(fYear);    
         List<SelectOption> options= new List<SelectOption>();
           options.add(new SelectOption('', 'None'));
            if(setCountry != null && !setCountry.isEmpty()){
                for(String country : setCountry){
                    if(country != null){
                        options.add(new SelectOption(country, country));  
                    }
                }
            }
          
            return options;
     }
     
     /*
    @Description : ==============
    */ 
     public List<SelectOption> getAgencyDepartment(){
        
         List<SelectOption> options= new List<SelectOption>();
           options.add(new SelectOption('', 'None'));
            if(setAgencyDept != null && !setAgencyDept.isEmpty()){
                for(String roleRate : setAgencyDept){
                    if(roleRate != null){
                        options.add(new SelectOption(roleRate, roleRate));  
                    }
                }
            }
                
           if(options.size()>1) { isroledisabled = false;  }
            return options;
     }
    
    /*
    @Description : ==============
    */  
     public List<SelectOption> getRoleTitle(){
        
         List<SelectOption> options= new List<SelectOption>();
          options.add(new SelectOption('', 'None'));
            if(setRoleTitle != null && !setRoleTitle.isEmpty()){
                for(String role : setRoleTitle){
                     if(role != null){
                        options.add(new SelectOption(role, role));
                    }
                }
            }
            return options;
     }
    /*
    @Description : ==============
    */ 
    public PageReference save(){
        try{
            system.debug('###OItem.FTE__c :'+OItem.FTE__c);
            system.debug('###lstCalculatorRate[0].FTE__c :'+lstCalculatorRate);
            Integer calculatorSize = lstCalculatorRate.size();
            if(OItem.RecordTypeId == Oblix_Utils.MapRecordType(marKObjName).get('Resource') && !lstCalculatorRate.IsEmpty() && calculatorSize >0 && OItem.FTE__c != null && OItem.FTE__c > 0){
                OItem.OblixOtherItemFee__c = lstCalculatorRate[0].FTE__c/OItem.FTE__c; 
            }else if((OItem.FTE__c == null || OItem.FTE__c == 0) && !lstCalculatorRate.IsEmpty()){
                OItem.OblixOtherItemFee__c = lstCalculatorRate[0].FTE__c;
            }
            else if(OItem.RecordTypeId == Oblix_Utils.MapRecordType(marKObjName).get('Activity') && !lstCalculatorRate.IsEmpty() && calculatorSize >0 && OItem.No_of_Hours_Required__c != null && lstCalculatorRate[0].Role_Daily_Rate_EUR__c != null){
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
}