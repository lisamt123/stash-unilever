public class AF_Bonusthresholds {
    public String agencyId{get;set;}
    public String ParentId{get;set;}
    public string brand_estimate_id = ApexPages.currentPage().getParameters().get('id');
    public AF_Brand_Estimate__c BrandEstimateObj {get;set;}
    public List<AF_Agency_Estimate__c> agencyEstimates{get;set;}
    public list<AF_Bonus_Threshold__c>Bonus_thresholds=new list<AF_Bonus_Threshold__c>();
    public list<wrapbonus> BonusThresholds {get;set;}
    public string selectedCountryname{get;set;}
    public list<selectoption> Countrynames{get;set;}
    public string brandid;
    public string agencyid1;
    public string Fyear;
    Public  List<SelectOption> measure_criteria {get;set;}
    Public string Measure_val{get;set;}
    
    public AF_Bonusthresholds(){
  
     BonusThresholds = new list<wrapbonus>(); 
   
     agencyid= ApexPages.currentPage().getParameters().get('Agencyid'); 
     brandid=ApexPages.currentPage().getParameters().get('Brandid'); 
     Fyear=ApexPages.currentPage().getParameters().get('Year'); 
     
     system.debug(' agencyid'+ agencyid+'brandid'+brandid+'Fyear'+Fyear);
           
     GetCountry();
     getMeasure();
     Bonus_thresholds=new list<AF_Bonus_Threshold__c>();
     Bonus_thresholds=[Select AF_Unique_Thresholds__c,Id,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Traditional__c,AF_Digital__c,Agency_Name__c,AF_Country__c,Brand_Name__c,Year__c,Bonus_Measure__c from AF_Bonus_Threshold__c  where Brand_Name__c=:brandid.substring(0,15) and Agency_Name__c=:agencyid.substring(0,15) and Year__c=:Fyear];
      
      if(Bonus_thresholds.size()>0){
      BonusThresholds = new list<wrapbonus>();
      for(AF_Bonus_Threshold__c b:Bonus_thresholds){
      
      Measure_val= b.Bonus_Measure__c;
      BonusThresholds.add(new wrapbonus(b));
      }
      }
    }
    
     Public void addwrapper(){
   
     
   }
 public List<Selectoption>getMeasure(){
        measure_criteria=new list<Selectoption>();
        Schema.DescribeFieldResult CommprefField = AF_Bonus_Threshold__c.Bonus_Measure__c.getDescribe(); 
        Schema.PicklistEntry [] Commpref = CommprefField.getPickListValues();
        measure_criteria.add(new SelectOption('select one', '----Select One----'));
        for(Schema.PicklistEntry val : Commpref)
        {
            measure_criteria.add(new SelectOption(val.getValue(), val.getLabel()));
        }
       Return  measure_criteria;    
   }
  public List<SelectOption> getCountry()
     {
       
       Countrynames = new List<SelectOption>();
       Countrynames.add(new selectoption('--None--','--Country--'));
       List<AF_Entity__c> UEntity=[select id,name from AF_Entity__c where RecordType.Name =:'Unilever Entity']; 
         for(AF_Entity__c UE:UEntity)
          {
              Countrynames.add(new selectoption(UE.id,UE.name));
          }
          return Countrynames;
    }
  public void createBonusThreshold(){
        AF_Bonus_Threshold__c bonusNewRecord = new AF_Bonus_Threshold__c();
        /*bonusNewRecord.AF_Minimum__c=null;
        bonusNewRecord.AF_Stretching__c=null;
        bonusNewRecord.AF_Outstanding__c=null;
        bonusNewRecord.AF_Traditional__c=false;
        bonusNewRecord.AF_Digital__c=false;
        bonusNewRecord.AF_Country__c=null;*/
        system.debug('bonusNewRecord...'+bonusNewRecord);
        BonusThresholds.add(new wrapbonus(bonusNewRecord));
        
    } 
 public void SaveBonusThresholds(){
        list<AF_Bonus_Threshold__c>bonus_latestlist=new list<AF_Bonus_Threshold__c>();
        String uniquethreshold='';
        Boolean isUnique;
        Try{
        For(wrapbonus bonus_thresolds:BonusThresholds){
          
            uniquethreshold=bonus_thresolds.bonusthresholds.AF_Country__c+'::'+agencyid.substring(0,15)+'::'+brandid.substring(0,15)+'::'+Fyear;
            
            AF_Bonus_Threshold__c insertBonusRecords = new AF_Bonus_Threshold__c();
            insertBonusRecords.AF_Minimum__c = bonus_thresolds.bonusthresholds.AF_Minimum__c;
            insertBonusRecords.AF_Stretching__c= bonus_thresolds.bonusthresholds.AF_Stretching__c;
            insertBonusRecords.AF_Outstanding__c= bonus_thresolds.bonusthresholds.AF_Outstanding__c;
            insertBonusRecords.AF_Traditional__c= bonus_thresolds.bonusthresholds.AF_Traditional__c;
            insertBonusRecords.AF_Digital__c= bonus_thresolds.bonusthresholds.AF_Digital__c;
            insertBonusRecords.AF_Country__c= bonus_thresolds.bonusthresholds.AF_Country__c;
            insertBonusRecords.Id = bonus_thresolds.bonusthresholds.Id;
            insertBonusRecords.Brand_Name__c=brandid;
            insertBonusRecords.Agency_Name__c = agencyid;
            insertBonusRecords.Year__c = Fyear;
            insertBonusRecords.AF_Unique_Thresholds__c=uniquethreshold;
            insertBonusRecords.Bonus_Measure__c= Measure_val;
                        
             bonus_latestlist.add(insertBonusRecords);
        }
        system.debug('bonus_latestlist....'+bonus_latestlist);
        upsert bonus_latestlist;
        Apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,  'Records successfully saved' ));
       
        }
         catch(DMLException ex){
         Apexpages.addmessage(new apexpages.message(apexpages.severity.error,  ex.getMessage() )); 
         }    
     }
public class wrapbonus{
    public AF_Bonus_Threshold__c bonusthresholds {get;set;}
    public wrapbonus(AF_Bonus_Threshold__c objthresholds){
    this.bonusthresholds=objthresholds;
    }
  }   

}