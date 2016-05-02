global class AF_BrandEstimatesBatch implements Database.Batchable<sObject>
{
     global final String query;
     String statusBasefee='Ready for PO';
     List<AF_Brand_Estimate__c> brandEstimateList=new  List<AF_Brand_Estimate__c>();
     List<AF_Brand_Estimate__c>  InserBrandEstimates=new List<AF_Brand_Estimate__c>();
     String Fisyear=string.valueOf(system.now().year()-1); 
     List<AF_Brand_Estimate__c> brandEstimateupdate=new  List<AF_Brand_Estimate__c>();
    
    global AF_BrandEstimatesBatch(string q)
    {
       // query = 'select id,Name,AF_Active__c,AF_Adaptive__c ,AF_Agency__c,Agency_Base_Fee__c,AF_Archived__c,AF_Basefee_Estimate_Initial_Quarter__c,Base_Fee_Total__c,AF_Bonus_Trigger_Date__c,Brand__c,AF_Comment_Type__c,AF_Controller_Flag__c,AF_Created_By_Batch__c,AF_Digital__c,AF_Fiscal_Year__c,AF_Measure_Bonus__c,AF_Overall_OOPS__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Traditional__c, (select id,Name,AF_Crossborder__c,AF_Agency_Entity_Column_Name__c,AF_Adaptation__c,AF_Adaptation_Local__c,AF_Agency__c,AF_Agency_Entity__c,AF_Archived__c,AF_Brand_Estimate__c,AF_Category__c,AF_Comment_Type__c,AF_Controller_Flag__c,AF_Deleted__c,AF_Digital__c,AF_Digital_Local__c,AF_Estimates_don_t_match__c,AF_Fiscal_Year__c,AF_IsCrossborder__c,AF_Locked__c,AF_Matrix_Data_Entry_Currency__c,AF_Agency_Exchange_Rate__c,AF_Quarter__c,AF_Rate_Currency__c,AF_Rate_Type__c,AF_Ready_For_PO_Entry_Currency__c,AF_Agency_Spot_Rate__c,AF_Status__c,AF_Total_Local__c,AF_Traditional__c,AF_Traditional_Local__c,AF_Unilever_Entity__c,AF_Unilever_Entity_Column_Name__c,AF_Unilever_Estimates__c from Agency_Estimates__R),(select id,Name,AF_Agency_Entity__c,AF_Agency_Entity_Column_Name__c,AF_Agency_Exchange_Rate__c,AF_Agency_Spot_Rate__c,AF_Agreed_Base_Fees__c,AF_Archived__c,AF_Brand_Estimate__c,AF_Estimate__c,AF_Estimate_Local__c,AF_Fiscal_Year__c,AF_Locked__c,AF_Overall_OOPS__c,AF_Quarter__c,AF_Rate_Currency__c,AF_Rate_Type__c,AF_Status__c,AF_Unilever_Entity__c,AF_Unilever_Entity_Column_Name__c from OOPS_Estimates__R)from AF_Brand_Estimate__c where AF_Status_Base_Fees__c=:statusBasefee and AF_Fiscal_Year__c=:Fisyear '  ;
       query=q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,  List<AF_Brand_Estimate__c> brandEstimateList) 
    {  
        //list<AF_Brand_Estimate__c > abelist = new list<AF_Brand_Estimate__c >();
        list<AF_Brand_Estimate__c > abelistUpdate = new list<AF_Brand_Estimate__c >();
        list<AF_Agency_Estimate__c> agest_list = new list<AF_Agency_Estimate__c >();
        list<AF_OOPS_Estimate__c> aoop_list = new list<AF_OOPS_Estimate__c>();
        Set<Id> brandEstId=new Set<Id>();
        list<AF_Brand_Estimate__c > abelist = [select id,Name,af_agency__r.name,brand__r.name,AF_Active__c,AF_Adaptive__c ,AF_Copied__c,AF_Agency__c,Agency_Base_Fee__c,AF_Basefee_Estimate_Initial_Quarter__c,Base_Fee_Total__c,AF_Bonus_Trigger_Date__c,Brand__c,AF_Comment_Type__c,AF_Controller_Flag__c,AF_Created_By_Batch__c,AF_Digital__c,AF_Fiscal_Year__c,AF_Measure_Bonus__c,AF_Overall_OOPS__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Traditional__c,AF_Locked__c from AF_Brand_Estimate__c where id in :brandEstimateList];
        for(AF_Brand_Estimate__c abe:abelist){
        AF_Brand_Estimate__c  abe_new = abe.clone(false,true);
        abe_new.AF_Fiscal_Year__c = string.valueof(system.today().year());
        abe_new.Name=abe_new.brand__r.name+'-'+ abe_new.af_agency__r.name +'-Q1-' +abe_new.AF_Fiscal_Year__c;
        abe_new.AF_Basefee_Estimate_Initial_Quarter__c ='Q1';
        abe_new.AF_Status_Base_Fees__c = 'Initiate';
        abe_new.AF_Locked__c  = false;
        abe_new.AF_Created_By_Batch__c = true;
        abe_new.AF_Traditional__c = 0;
        abe_new.AF_Digital__c = 0;
        abe_new.AF_Adaptive__c = 0;
        abe_new.AF_Copied__c = false;
        brandEstId.add(abe.Id);
        abelistUpdate.add(abe_new);
        }
        Set<Id> brList = new Set<Id>();
        Map<String,String> brandEstMap = new Map<String,String>();
        Database.SaveResult[] srList = Database.insert(abelistUpdate, false);
         for (Database.SaveResult br : srList) {
            if(br.issuccess()){
                brList.add(br.Id);
            }
        }
        list<AF_Brand_Estimate__c > brandEstNewList = [select af_agency__r.name,brand__r.name,AF_Fiscal_Year__c from AF_Brand_Estimate__c where Id IN:brList];
        for(AF_Brand_Estimate__c be:brandEstNewList){
            String uniqueCombination = be.af_agency__r.name +'-'+be.brand__r.name+'-'+Fisyear;
            brandEstMap.put(uniqueCombination,be.id);
        }
        system.debug('brandEstMap....'+brandEstMap);
                try{
                  List<AF_Agency_Estimate__c> aelist = [select AF_Brand_Estimate__r.af_agency__r.name,AF_Brand_Estimate__r.brand__r.name,AF_Brand_Estimate__r.AF_Fiscal_Year__c,id,Name,AF_Crossborder__c,AF_Agency_Entity_Column_Name__c,AF_Adaptation__c,AF_Adaptation_Local__c,AF_Agency__c,AF_Agency_Entity__c,AF_Archived__c,AF_Brand_Estimate__c,AF_Category__c,AF_Comment_Type__c,AF_Controller_Flag__c,AF_Deleted__c,AF_Digital__c,AF_Digital_Local__c,AF_Estimates_don_t_match__c,AF_Fiscal_Year__c,AF_IsCrossborder__c,AF_Locked__c,AF_Matrix_Data_Entry_Currency__c,AF_Agency_Exchange_Rate__c,AF_Quarter__c,AF_Rate_Currency__c,AF_Rate_Type__c,AF_Ready_For_PO_Entry_Currency__c,AF_Agency_Spot_Rate__c,AF_Status__c,AF_Total_Local__c,AF_Traditional__c,AF_Traditional_Local__c,AF_Unilever_Entity__c,AF_Unilever_Entity_Column_Name__c,AF_Unilever_Estimates__c from AF_Agency_Estimate__c where AF_Brand_Estimate__c = : brandEstId];
                  for (Database.SaveResult br : srList) {
                    if(br.issuccess()){
                    system.debug('br....'+br);
                    
                    for(AF_Agency_Estimate__c ae: aelist)
                    {
                        String agEstString = ae.AF_Brand_Estimate__r.af_agency__r.name+'-'+ae.AF_Brand_Estimate__r.brand__r.name+'-'+ae.AF_Brand_Estimate__r.AF_Fiscal_Year__c;
                         system.debug('agEstString....'+agEstString);
                        if(brandEstMap.get(agEstString)==br.Id){
                        AF_Agency_Estimate__c aecopy = ae.clone(false,true);
                        aecopy.AF_Brand_Estimate__c = br.Id;
                        aecopy.AF_Fiscal_Year__c = string.valueof(system.today().year());
                        aecopy.AF_Quarter__c = 'Q1';
                        aecopy.AF_Locked__c = false;
                        agest_list.add(aeCopy);
                        }
                    }
                    }
                  }
                    if(agest_list.size() > 0)
                    {
                      
                          insert agest_list;
                    }
                  } catch(exception e) {}
                        
                for(AF_Brand_Estimate__c abe:abelist){
                    if(abe.AF_Locked__c == false) {      
                        abe.AF_Locked__c  = true;
                        abe.AF_Copied__c = true;
                        brandEstimateupdate.add(abe);
                        if(brandEstimateupdate.size() >0) 
                            update brandEstimateupdate;
                    }
                }   
                  
            
            
        
    }
    //finish Mehtod
    global void finish(Database.BatchableContext BC)
    {
    system.debug('finished');
    }
    
}