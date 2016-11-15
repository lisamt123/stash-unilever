global class AF_BrandEstimate_Statuschange implements Database.Batchable<sObject>
{
     global final String query;
     String statusBasefee='Ready for PO';
     string Fisyear = string.valueOf(system.now().year());
    // List<AF_Brand_Estimate__c> brandEstimateList=new  List<AF_Brand_Estimate__c>();
    // List<AF_Brand_Estimate__c>  InserBrandEstimates=new List<AF_Brand_Estimate__c>();
 
    
    global AF_BrandEstimate_Statuschange(string q)
    {
       //query = 'select id,Name,AF_Active__c,AF_Adaptive__c ,AF_Agency__c,Agency_Base_Fee__c,AF_Archived__c,AF_Basefee_Estimate_Initial_Quarter__c,Base_Fee_Total__c,AF_Bonus_Trigger_Date__c,Brand__c,AF_Comment_Type__c,AF_Controller_Flag__c,AF_Created_By_Batch__c,AF_Digital__c,AF_Fiscal_Year__c,AF_Measure_Bonus__c,AF_Overall_OOPS__c,AF_Status_Base_Fees__c,AF_Status_Bonus__c,AF_Status_OOPs_Atcual__c,AF_Status_OOPs_Estimate__c,AF_Traditional__c, (select id,Name,AF_Crossborder__c,AF_Agency_Entity_Column_Name__c,AF_Adaptation__c,AF_Adaptation_Local__c,AF_Agency__c,AF_Agency_Entity__c,AF_Archived__c,AF_Brand_Estimate__c,AF_Category__c,AF_Comment_Type__c,AF_Controller_Flag__c,AF_Deleted__c,AF_Digital__c,AF_Digital_Local__c,AF_Estimates_don_t_match__c,AF_Fiscal_Year__c,AF_IsCrossborder__c,AF_Locked__c,AF_Matrix_Data_Entry_Currency__c,AF_Agency_Exchange_Rate__c,AF_Quarter__c,AF_Rate_Currency__c,AF_Rate_Type__c,AF_Ready_For_PO_Entry_Currency__c,AF_Agency_Spot_Rate__c,AF_Status__c,AF_Total_Local__c,AF_Traditional__c,AF_Traditional_Local__c,AF_Unilever_Entity__c,AF_Unilever_Entity_Column_Name__c,AF_Unilever_Estimates__c from Agency_Estimates__R),(select id,Name,AF_Agency_Entity__c,AF_Agency_Entity_Column_Name__c,AF_Agency_Exchange_Rate__c,AF_Agency_Spot_Rate__c,AF_Agreed_Base_Fees__c,AF_Archived__c,AF_Brand_Estimate__c,AF_Estimate__c,AF_Estimate_Local__c,AF_Fiscal_Year__c,AF_Locked__c,AF_Overall_OOPS__c,AF_Quarter__c,AF_Rate_Currency__c,AF_Rate_Type__c,AF_Status__c,AF_Unilever_Entity__c,AF_Unilever_Entity_Column_Name__c from OOPS_Estimates__R)from AF_Brand_Estimate__c where AF_Fiscal_Year__c=:Fisyear and AF_Created_By_Batch__c =: true and AF_Locked__c =: false'  ;
       query=q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,  List<AF_Brand_Estimate__c> brandEstimateList) 
    {  
          list<AF_Brand_Estimate__c > abelist = new list<AF_Brand_Estimate__c >();
          for(AF_Brand_Estimate__c abe : brandEstimateList)
          {
              if(abe.Brand__c != null && abe.AF_Status_Base_Fees__c  !='With Agency')
              { 
                abe.AF_Status_Base_Fees__c  ='With Agency';
                abelist.add(abe);
              }
          }
          if(abelist.size() > 0)
             update abelist;
    }
    //finish Mehtod
    global void finish(Database.BatchableContext BC)
    {
    }
}