/**Description: This class is used to get the lookup values of Brand and agency as
pick list values and display in the page
and On click of Save it should store the record in Brand Estimates
**/
public with sharing class AF_BrandAgencyCombinationController 

 {

    
// Declaration of setters and getters
 public string financialYear{get;set;} 
 public list<selectoption> brandNames{get;set;}
 public string selectedoption{get;set;}
 public string selectedoptionAgency{get;set;}
 public list<selectoption> AgencyNames{get;set;}
 Public boolean showSuccess{get; set;}
 Public boolean showFailure{get; set;}
 public boolean finalPanel{get;set;}
 public boolean displayPopup {get; set;}

 

    // Constructor definition       
    public AF_BrandAgencyCombinationController()
    {
      // Calling the getBrands() and getAgencies() to get the records as a picklist values on load of the page.
      displayPopup =false;
      finalPanel=false;
     
      getBrands();  
      getAgencies();
      financialYear=ApexPages.currentPage().getParameters().get('Year');
    }
    
    //getBrands() Method to get the picklist values
    public List<SelectOption> getBrands()
    {
       brandNames= new list<selectoption>();
       brandNames.add(new selectoption('--None--','--Brand--'));
       List<AF_Category_Brand__c> brands =[select id,name from AF_Category_Brand__c where RecordType.Name =:'Brand' order by name];
         for(AF_Category_Brand__c brand:brands)
          {
              
            brandNames.add(new selectoption(brand.id+'::'+brand.name,brand.name));
          }
          return brandNames;
     } 
    
   //getAgencies() Method to get the picklist values      
    public List<SelectOption> getAgencies()
     {
       AgencyNames = new List<SelectOption>();
       AgencyNames.add(new selectoption('--None--','--Agency--'));
       List<Account> Accounts=[select id,name from account where RecordType.Name =:'Agency Fee']; 
         for(Account acc:Accounts)
          {
              
               AgencyNames.add(new selectoption(acc.id+'::'+acc.name,acc.name));
          }
          return AgencyNames;
        }
        
         
   
   
   //save method to store the record in BrandEstimate Object
    public void Save() 
      {
         if(selectedoption==Null ||selectedoption == '--None--')
          {
               
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'The Brand/Please Select Brand'));
          }
            else if(selectedoptionAgency==Null ||selectedoptionAgency == '--None--' )
               {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'The Agency/Please Select Agency'));
               }
                else
                 {
                    List<AF_Brand_Estimate__c> b=[select AF_Agency__c, Brand__c from AF_Brand_Estimate__c where Brand__c=:selectedoption.split('::').get(0) And AF_Agency__c =:selectedoptionAgency.split('::').get(0) And AF_Fiscal_Year__c =:financialYear  ];
                    if(b.size()==0)
                    {
                     // Database.DMLOptions dmo = new database.DMLOptions();
                      AF_Brand_Estimate__c newBrand=new AF_Brand_Estimate__c();  
                      newBrand.Name= selectedoption.split('::').get(1)+'-'+selectedoptionAgency.split('::').get(1)+'-Q1'+'-'+financialYear;
                      newBrand.AF_Agency__c=selectedoptionAgency.split('::').get(0);    
                      newBrand.Brand__c=selectedoption.split('::').get(0);
                      newBrand.AF_Fiscal_Year__c=financialYear;
                     // Database.insert(newBrand, dmo); 
                     try
                     {
                         insert newBrand;
                         //displayPopup=true;
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,' The Brand/Agency Combination has been successfully created'));
                  
                      }
                      catch(Exception e)
                      {
                      
                      }
                      
                    }
                   else
                   {  
                     finalPanel=true;
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'This Brand/Agency Combination already exists,please restart the PO process using the"Raise New PO" button on the home page'));
                   } 
                 }  
       
      }
          
        public void closePopup() 
        { 
           system.debug('control is inside Closepopup action method');
           displayPopup = false;    
        } 
          
      


 }