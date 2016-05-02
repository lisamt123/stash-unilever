global class AF_GetBaseFeePOData{
   
    @future
    public static void CreatePOReportFromAgencyEstimate(Set<ID> AgencyEstimateIds,Boolean deletePOReport)
    {
       system.debug('AgencyEstimateIds...'+AgencyEstimateIds);
       af_po_report__c eachPORecord;
    List<af_agency_estimate__c> lstagest = new List<af_agency_estimate__c>();
    List<af_po_report__c> lstpo = new List<af_po_report__c>();
    List<af_po_report__c> lstpoupdate = new List<af_po_report__c>();
    List<af_po_report__c> deletePOReportList = new List<af_po_report__c>();
    String Fisyear=string.valueOf(system.now().year()); 
   
    Map<ID,ID> mapPO = new Map<ID,ID>();
       List<af_po_report__c> lstpochk = new List<af_po_report__c>([select id,AF_Agency_Estimate_ID__c from af_po_report__c where AF_PO_Report_Type__c= 'Base Fees']);
       for(af_po_report__c myagest:lstpochk)
       {
           mapPO.put(myagest.AF_Agency_Estimate_ID__c,myagest.id);
       }
           
            if(AgencyEstimateIds.size()>0 && deletePOReport==false){
           for(af_agency_estimate__c mypo:[SELECT AF_po_report_type__c,AF_OverridePO_Adaptation_LC__c,AF_OverridePO_Digital_LC__c,AF_OverridePO_Traditional_LC__c,af_po_number__c,AF_Unilever_Entity__r.name,af_brand_estimate__r.name,af_brand_estimate__r.AF_Status_Base_Fees__c,Brand__c,af_brand_estimate__r.AF_Fiscal_Year__c,af_brand_estimate__c,id,AF_Brand_Estimate__r.Brand__r.AF_Category_Brands__r.Name,AF_Compound_Key__c,AF_Agency_Entity__r.af_legal_entity_name__c,AF_Agency_Entity__r.name,AF_Unilever_Entity_Name__c,af_total__c,af_max_quarter__c,AF_CountNoQuarters__c,AF_QuartersAlreadyDone__c,AF_Traditional__c,AF_Traditional_Local__c,AF_Digital__c,AF_Digital_Local__c,AF_Adaptation__c,AF_Adaptation_Local__c,AF_Matrix_Data_Entry_Currency__c,AF_Ready_For_PO_Entry_Currency__c,af_brand_estimate__r.af_agency__r.name FROM AF_Agency_Estimate__c where Id IN:AgencyEstimateIds])
           {
               eachPORecord = new af_po_report__c();
               eachPORecord.AF_PO_Report_Type__c= mypo.AF_PO_Report_Type__c;
               eachPORecord.af_po_number__c=mypo.af_po_number__c;
               eachPORecord.AF_Adaptation_Local__c=mypo.AF_Adaptation_Local__c;
               eachPORecord.AF_Adaptation__c=mypo.AF_Adaptation__c;
               eachPORecord.AF_Digital_Local__c=mypo.AF_Digital_Local__c;
               eachPORecord.AF_Digital__c=mypo.AF_Digital__c;
               eachPORecord.AF_Traditional_Local__c=mypo.AF_Traditional_Local__c;
               eachPORecord.AF_Traditional__c=mypo.AF_Traditional__c;
               eachPORecord.AF_Brand_Estimate_Name__c=mypo.af_brand_estimate__r.name;
               eachPORecord.AF_Base_Fee_Status__c=mypo.af_brand_estimate__r.AF_Status_Base_Fees__c;
               eachPORecord.AF_Fiscal_Year__c=mypo.af_brand_estimate__r.AF_Fiscal_Year__c;
               eachPORecord.Fiscal_Year__c=mypo.af_brand_estimate__r.AF_Fiscal_Year__c;
               eachPORecord.AF_Brand_Estimate_ID__c=mypo.af_brand_estimate__c;
               eachPORecord.AF_Agency_Estimate_ID__c=mypo.id;
               eachPORecord.AF_Category__c=mypo.AF_Brand_Estimate__r.Brand__r.AF_Category_Brands__r.Name;
               eachPORecord.AF_Compound_Key__c=mypo.AF_Compound_Key__c;
               eachPORecord.AF_Legal_Entity_Name__c=mypo.AF_Agency_Entity__r.af_legal_entity_name__c;
               eachPORecord.AF_Agency_Entity__c=mypo.AF_Agency_Entity__r.name;
               eachPORecord.AF_Agency_Name__c=mypo.af_brand_estimate__r.af_agency__r.name;
               eachPORecord.AF_Unilever_Entity__c=mypo.AF_Unilever_Entity__r.name;
               eachPORecord.AF_Total__c=mypo.af_total__c;
               eachPORecord.af_max_quarter__c =mypo.af_max_quarter__c;
               eachPORecord.AF_CountNoQuarters__c=mypo.AF_CountNoQuarters__c;
               eachPORecord.AF_QuatersAlreadyDone__c=mypo.AF_QuartersAlreadyDone__c;
               eachPORecord.AF_Matrix_Code__c=mypo.AF_Matrix_Data_Entry_Currency__c;
               eachPORecord.AF_Ready_for_PO_Code__c=mypo.AF_Ready_For_PO_Entry_Currency__c;
               eachPORecord.AF_Brand__c = mypo.Brand__c;
               eachPORecord.AF_Unilever_Entity__c=mypo.AF_Unilever_Entity__r.name;
               eachPORecord.AF_OverridePO_Adaptation_LC__c = mypo.AF_OverridePO_Adaptation_LC__c;
               eachPORecord.AF_OverridePO_Digital_LC__c   = mypo.AF_OverridePO_Digital_LC__c;
               eachPORecord.AF_OverridePO_Traditional_LC__c =  mypo.AF_OverridePO_Traditional_LC__c;
               system.debug('eachPORecord...'+eachPORecord);
               if (mapPO.containsKey(mypo.id))
               {
                   eachPORecord.id = mapPO.get(mypo.id);
                   lstpoUpdate.add(eachPORecord);
               }else
               {
                    lstpo.add(eachPORecord);
              }
              
           }
          }
          else if(AgencyEstimateIds.size()>0 && deletePOReport==true){
            for(Id deleteRecords:AgencyEstimateIds){
            if (mapPO.containsKey(deleteRecords))
               {
                   af_po_report__c deleteEachRecord = new af_po_report__c();
                   deleteEachRecord.id = mapPO.get(deleteRecords);
                   deletePOReportList.add(deleteEachRecord);
               }
            }
          }
        system.debug('lstpo size:'+ lstpo.size());
        system.debug('lstpoUpdate size:'+ lstpoUpdate.size());
        if(lstpo.size()>0)
        {
            database.insert(lstpo);
        }
        if(lstpoUpdate.size()>0)
        {
           
            database.update(lstpoUpdate);
           
        }
        system.debug('deletePOReportList...'+deletePOReportList);
        if(deletePOReportList.size()>0){
         delete deletePOReportList;
        }
        lstpo.clear();
        lstpoUpdate.clear();
    }
   
   public static void BatchcreatePOReportFromAgencyEstimate(Set<ID> AgencyEstimateIds,Boolean deletePOReport)
    {
       system.debug('AgencyEstimateIds...'+AgencyEstimateIds);
       af_po_report__c eachPORecord;
    List<af_agency_estimate__c> lstagest = new List<af_agency_estimate__c>();
    List<af_po_report__c> lstpo = new List<af_po_report__c>();
    List<af_po_report__c> lstpoupdate = new List<af_po_report__c>();
    List<af_po_report__c> deletePOReportList = new List<af_po_report__c>();
   
    Map<ID,ID> mapPO = new Map<ID,ID>();
       List<af_po_report__c> lstpochk = new List<af_po_report__c>([select id,AF_Agency_Estimate_ID__c from af_po_report__c where AF_PO_Report_Type__c= 'Base Fees' LIMIT 50000]);
       for(af_po_report__c myagest:lstpochk)
       {
           mapPO.put(myagest.AF_Agency_Estimate_ID__c,myagest.id);
       }
           
            if(AgencyEstimateIds.size()>0 && deletePOReport==false){
           for(af_agency_estimate__c mypo:[SELECT AF_po_report_type__c,AF_OverridePO_Adaptation_LC__c,AF_OverridePO_Digital_LC__c,AF_OverridePO_Traditional_LC__c,af_po_number__c,AF_Unilever_Entity__r.name,af_brand_estimate__r.name,af_brand_estimate__r.AF_Status_Base_Fees__c,Brand__c,af_brand_estimate__r.AF_Fiscal_Year__c,af_brand_estimate__c,id,AF_Brand_Estimate__r.Brand__r.AF_Category_Brands__r.Name,AF_Compound_Key__c,AF_Agency_Entity__r.af_legal_entity_name__c,AF_Agency_Entity__r.name,AF_Unilever_Entity_Name__c,af_total__c,af_max_quarter__c,AF_CountNoQuarters__c,AF_QuartersAlreadyDone__c,AF_Traditional__c,AF_Traditional_Local__c,AF_Digital__c,AF_Digital_Local__c,AF_Adaptation__c,AF_Adaptation_Local__c,AF_Matrix_Data_Entry_Currency__c,AF_Ready_For_PO_Entry_Currency__c,af_brand_estimate__r.af_agency__r.name FROM AF_Agency_Estimate__c where Id IN:AgencyEstimateIds])
           {
               eachPORecord = new af_po_report__c();
               eachPORecord.AF_PO_Report_Type__c= mypo.AF_PO_Report_Type__c;
               eachPORecord.af_po_number__c=mypo.af_po_number__c;
               eachPORecord.AF_Adaptation_Local__c=mypo.AF_Adaptation_Local__c;
               eachPORecord.AF_Adaptation__c=mypo.AF_Adaptation__c;
               eachPORecord.AF_Digital_Local__c=mypo.AF_Digital_Local__c;
               eachPORecord.AF_Digital__c=mypo.AF_Digital__c;
               eachPORecord.AF_Traditional_Local__c=mypo.AF_Traditional_Local__c;
               eachPORecord.AF_Traditional__c=mypo.AF_Traditional__c;
               eachPORecord.AF_Brand_Estimate_Name__c=mypo.af_brand_estimate__r.name;
               eachPORecord.AF_Base_Fee_Status__c=mypo.af_brand_estimate__r.AF_Status_Base_Fees__c;
               eachPORecord.AF_Fiscal_Year__c=mypo.af_brand_estimate__r.AF_Fiscal_Year__c;
               eachPORecord.Fiscal_Year__c=mypo.af_brand_estimate__r.AF_Fiscal_Year__c;
               eachPORecord.AF_Brand_Estimate_ID__c=mypo.af_brand_estimate__c;
               eachPORecord.AF_Agency_Estimate_ID__c=mypo.id;
               eachPORecord.AF_Category__c=mypo.AF_Brand_Estimate__r.Brand__r.AF_Category_Brands__r.Name;
               eachPORecord.AF_Compound_Key__c=mypo.AF_Compound_Key__c;
               eachPORecord.AF_Legal_Entity_Name__c=mypo.AF_Agency_Entity__r.af_legal_entity_name__c;
               eachPORecord.AF_Agency_Entity__c=mypo.AF_Agency_Entity__r.name;
               eachPORecord.AF_Agency_Name__c=mypo.af_brand_estimate__r.af_agency__r.name;
               eachPORecord.AF_Unilever_Entity__c=mypo.AF_Unilever_Entity__r.name;
               eachPORecord.AF_Total__c=mypo.af_total__c;
               eachPORecord.af_max_quarter__c =mypo.af_max_quarter__c;
               eachPORecord.AF_CountNoQuarters__c=mypo.AF_CountNoQuarters__c;
               eachPORecord.AF_QuatersAlreadyDone__c=mypo.AF_QuartersAlreadyDone__c;
               eachPORecord.AF_Matrix_Code__c=mypo.AF_Matrix_Data_Entry_Currency__c;
               eachPORecord.AF_Ready_for_PO_Code__c=mypo.AF_Ready_For_PO_Entry_Currency__c;
               eachPORecord.AF_Brand__c = mypo.Brand__c;
               eachPORecord.AF_Unilever_Entity__c=mypo.AF_Unilever_Entity__r.name;
               eachPORecord.AF_OverridePO_Adaptation_LC__c = mypo.AF_OverridePO_Adaptation_LC__c;
               eachPORecord.AF_OverridePO_Digital_LC__c   = mypo.AF_OverridePO_Digital_LC__c;
               eachPORecord.AF_OverridePO_Traditional_LC__c =  mypo.AF_OverridePO_Traditional_LC__c;
               system.debug('eachPORecord...'+eachPORecord);
               if (mapPO.containsKey(mypo.id))
               {
                   eachPORecord.id = mapPO.get(mypo.id);
                   lstpoUpdate.add(eachPORecord);
               }else
               {
                    lstpo.add(eachPORecord);
              }
              
           }
          }
          else if(AgencyEstimateIds.size()>0 && deletePOReport==true){
            for(Id deleteRecords:AgencyEstimateIds){
            if (mapPO.containsKey(deleteRecords))
               {
                   af_po_report__c deleteEachRecord = new af_po_report__c();
                   deleteEachRecord.id = mapPO.get(deleteRecords);
                   deletePOReportList.add(deleteEachRecord);
               }
            }
          }
        system.debug('lstpo size:'+ lstpo.size());
        system.debug('lstpoUpdate size:'+ lstpoUpdate.size());
        if(lstpo.size()>0)
        {
            database.insert(lstpo);
        }
        if(lstpoUpdate.size()>0)
        {
           
            database.update(lstpoUpdate);
           
        }
        system.debug('deletePOReportList...'+deletePOReportList);
        if(deletePOReportList.size()>0){
         delete deletePOReportList;
        }
        lstpo.clear();
        lstpoUpdate.clear();
    }
              
    public static void CreatePOReportFromOopsEstimate(Set<ID> OopsEstimateIds,Boolean deletePOReport)
    {
       system.debug('OopsEstimateIds...'+OopsEstimateIds);
       af_po_report__c eachPORecord;
   
    List<af_po_report__c> lstpo = new List<af_po_report__c>();
    List<af_po_report__c> lstpoupdate = new List<af_po_report__c>();
    List<af_po_report__c> deletePOReportList = new List<af_po_report__c>();
   
    Map<ID,ID> mapPO = new Map<ID,ID>();
       List<af_po_report__c> lstpochk = new List<af_po_report__c>([select id,AF_Oops_Estimate_ID__c from af_po_report__c where AF_PO_Report_Type__c= 'OOPS']);
       for(af_po_report__c myagest:lstpochk)
       {
           mapPO.put(myagest.AF_Oops_Estimate_ID__c,myagest.id);
       }
           
            if(OopsEstimateIds.size()>0 && deletePOReport==false){
           for(AF_OOPS_Estimate__c mypo:[SELECT AF_PO_Report_Type__c,AF_Override_Estimate_Local__c,AF_Status__c,AF_Brand__c,AF_EstimateLocal__c,af_estimate__c,AF_PO_Number__c,AF_Unilever_Entity__r.name,AF_OOPS_Actual__r.name,AF_OOPS_Actual__r.AF_Status__c,AF_OOPS_Actual__r.AF_Fiscal_year__c,AF_OOPS_Actual__c,id,AF_OOPS_Actual__r.AF_Brand__r.AF_Category_Brands__r.Name,AF_Compound_key__c,AF_Agency_Entity__r.af_legal_entity_name__c,AF_Agency_Entity__r.name,Unilever_Entity_Name__c,AF_Total__c,AF_Max_Quarter__c,AF_CountNoQuarters__c,AF_QuatersAlreadyDone__c,AF_Traditional__c,AF_Digital__c,AF_Adaptation__c,AF_OOPS_Matrix_Currency_Code__c,AF_Ready_For_PO_Entry_Currency__c,AF_OOPS_Actual__r.AF_Agency_lk__r.name FROM AF_OOPS_Estimate__c where Id IN:OopsEstimateIds])
           {
               eachPORecord = new af_po_report__c();
               eachPORecord.AF_PO_Report_Type__c= mypo.AF_PO_Report_Type__c;
               eachPORecord.af_po_number__c=mypo.AF_PO_Number__c;
               //eachPORecord.AF_Adaptation_Local__c=mypo.AF_Adaptation_Local__c;
               //eachPORecord.AF_Adaptation__c=mypo.AF_Adaptation__c;
               //eachPORecord.AF_Digital_Local__c=mypo.AF_Digital_Local__c;
               //eachPORecord.AF_Digital__c=mypo.AF_Digital__c;
               eachPORecord.AF_Traditional_Local__c=mypo.AF_EstimateLocal__c;
               eachPORecord.AF_Traditional__c=mypo.af_estimate__c;
               eachPORecord.AF_OOPS_Name__c=mypo.AF_OOPS_Actual__r.name;
               eachPORecord.AF_Base_Fee_Status__c=mypo.AF_Status__c;
               eachPORecord.AF_Fiscal_Year__c=mypo.AF_OOPS_Actual__r.AF_Fiscal_year__c;
               eachPORecord.Fiscal_Year__c=mypo.AF_OOPS_Actual__r.AF_Fiscal_year__c;
               eachPORecord.Oops_Actual_Id__c=mypo.AF_OOPS_Actual__c;
               eachPORecord.AF_Oops_Estimate_ID__c=mypo.id;
               eachPORecord.AF_Category__c=mypo.AF_OOPS_Actual__r.AF_Brand__r.AF_Category_Brands__r.Name;
               eachPORecord.AF_Compound_Key__c=mypo.AF_Compound_key__c;
               eachPORecord.AF_Legal_Entity_Name__c=mypo.AF_Agency_Entity__r.af_legal_entity_name__c;
               eachPORecord.AF_Agency_Entity__c=mypo.AF_Agency_Entity__r.name;
               eachPORecord.AF_Agency_Name__c=mypo.AF_OOPS_Actual__r.AF_Agency_lk__r.name;
               eachPORecord.AF_Unilever_Entity__c=mypo.AF_Unilever_Entity__r.name;
               eachPORecord.AF_Total__c=mypo.AF_Total__c;
               eachPORecord.af_max_quarter__c =mypo.af_max_quarter__c;
               eachPORecord.AF_CountNoQuarters__c=mypo.AF_CountNoQuarters__c;
               eachPORecord.AF_QuatersAlreadyDone__c=mypo.AF_QuatersAlreadyDone__c;
               eachPORecord.AF_Matrix_Code__c=mypo.AF_OOPS_Matrix_Currency_Code__c;
               eachPORecord.AF_Ready_for_PO_Code__c=mypo.AF_Ready_For_PO_Entry_Currency__c;
               eachPORecord.AF_Brand__c = mypo.AF_Brand__c;
               //eachPORecord.AF_Big_Category__c = mypo.AF_Big_Category__c;
              // eachPORecord.AF_Unilever_Entity__c=mypo.AF_Unilever_Entity__r.name;
              eachPORecord.AF_OverridePO_Traditional_LC__c =  mypo.AF_Override_Estimate_Local__c;
               system.debug('eachPORecord...'+eachPORecord);
               if (mapPO.containsKey(mypo.id))
               {
                   eachPORecord.id = mapPO.get(mypo.id);
                   lstpoUpdate.add(eachPORecord);
               }else
               {
                    lstpo.add(eachPORecord);
               }
              
           }
          }
          else if(OopsEstimateIds.size()>0 && deletePOReport==true){
            for(Id deleteRecords:OopsEstimateIds){
            if (mapPO.containsKey(deleteRecords))
               {
                   af_po_report__c deleteEachRecord = new af_po_report__c();
                   deleteEachRecord.id = mapPO.get(deleteRecords);
                   deletePOReportList.add(deleteEachRecord);
               }
            }
          }
        system.debug('lstpo size:'+ lstpo.size());
        system.debug('lstpoUpdate size:'+ lstpoUpdate.size());
        if(lstpo.size()>0)
        {
           database.insert(lstpo);
        }
        if(lstpoUpdate.size()>0)
        {
           
            database.update(lstpoUpdate);
           
        }
        system.debug('deletePOReportList...'+deletePOReportList);
        if(deletePOReportList.size()>0){
         delete deletePOReportList;
        }
        lstpo.clear();
        lstpoUpdate.clear();
    }
 
    
    public static void CalculatePoReportValues(Map<String,String> compundKeyReportType,Set<String> CompundKeys){
        List<AF_PO_Report__c> po_Report_List = new List<AF_PO_Report__c>();
                                List<AF_PO_Report__c> updateList = new List<AF_PO_Report__c>();
                                set<String> uniqueKey = new set<String>();
                                set<String> baseFeeKey = new set<String>();
                                set<String> oopsKey = new set<String>();
                                integer i=0;
                                for(String key:CompundKeys){
                                    if(compundKeyReportType.get(key)=='Base Fees'){
                                        baseFeeKey.add(key);
                                    }
                                     else{
                                        oopsKey.add(key);
                                        }
                               }
                               
                                if(baseFeeKey.size()>0){
                                po_Report_List = [select AF_Total__c,AF_CountNoQuarters__c,AF_OverridePO_Digital_LC__c,AF_OverridePO_Traditional_LC__c,AF_OverridePO_Adaptation_LC__c,AF_Traditional_Local__c,AF_Digital_Local__c,AF_PO_Report_Type__c,AF_Adaptation_Local__c,af_max_quarter__c,AF_QuatersAlreadyDone__c,AF_Calculated_PO_Value_Formula__c,AF_Previous_Quarter_Value__c,AF_Compound_Key__c,AF_Calculate_Tradition_Local__c,AF_Previous_Quarter_Value_TL__c,AF_Calculate_Digital_Local__c,AF_Previous_Quarter_Value_DL__c,AF_Calculate_Adaptation_Local__c,AF_Previous_Quarter_Value_AL__c from AF_PO_Report__c where AF_PO_Report_Type__c='Base Fees' and AF_Compound_Key__c in:baseFeeKey order by AF_Compound_Key__c,AF_QuatersAlreadyDone__c ASC];
                                calculateBaseOopsvalues(po_Report_List);
                                }
                                po_Report_List.clear();
                                if(oopsKey.size()>0){
                                po_Report_List = [select AF_Total__c,AF_OverridePO_Traditional_LC__c,AF_Previous_Quarter_Value_TL_OOPSEuro__c,AF_CountNoQuarters__c,AF_Traditional_Local__c,AF_Digital_Local__c,AF_PO_Report_Type__c,AF_Adaptation_Local__c,af_max_quarter__c,AF_QuatersAlreadyDone__c,AF_Calculated_PO_Value_Formula__c,AF_Previous_Quarter_Value__c,AF_Compound_Key__c,AF_Calculate_Tradition_Local__c,AF_Previous_Quarter_Value_TL__c,AF_Calculate_Digital_Local__c,AF_Previous_Quarter_Value_DL__c,AF_Calculate_Adaptation_Local__c,AF_Previous_Quarter_Value_AL__c,AF_Traditional__c from AF_PO_Report__c where AF_PO_Report_Type__c='OOPS' and AF_Compound_Key__c in:oopsKey order by AF_Compound_Key__c,AF_QuatersAlreadyDone__c ASC];
                                calculateBaseOopsvalues(po_Report_List);
                                }
               
    } 
    
   
 public static void calculateBaseOopsvalues(List<AF_PO_Report__c> po_Report_List){
    List<AF_PO_Report__c> updateList = new List<AF_PO_Report__c>();
  set<String> uniqueKey = new set<String>();
  integer i=0;
   if(po_Report_List.size()>0){
     for(AF_PO_Report__c poReport:po_Report_List){
                Decimal calc=0.0;
                Decimal calcPO=0.0;
                Decimal total=0;
                Decimal previousval=0.0;                                                
                Integer counter=0;
                Decimal quarters=0;
                Decimal quartersdone=0;
                Decimal calcTL=0.0;
                Decimal calcDL=0.0;
                Decimal calcAL=0.0;
                Decimal totalTL=0;
                Decimal totalAL=0;
                Decimal totalDL=0;
                Decimal totalOOPSEUROTL=0;
                Decimal calcTLOOPSEURO=0.0;
                if(!uniqueKey.contains(poReport.AF_Compound_Key__c)){
                          poReport.AF_Previous_Quarter_Value__c =0;
                          poReport.AF_Previous_Quarter_Value_TL__c =0;
                          poReport.AF_Previous_Quarter_Value_AL__c =0;
                          poReport.AF_Previous_Quarter_Value_DL__c =0;
                          poReport.AF_Previous_Quarter_Value_TL_OOPSEuro__c=0;
                          calcPO=0.0;          
                    }
                                                                                                                               
                else{
                    //PO value calculation
                    if(po_Report_List[i-1].AF_Previous_Quarter_Value__c == null) {previousval=0;} else {previousval=po_Report_List[i-1].AF_Previous_Quarter_Value__c;}
                    if(po_Report_List[i-1].AF_CountNoQuarters__c==null){quarters=0;}else{quarters=po_Report_List[i-1].AF_CountNoQuarters__c;}
                    if(po_Report_List[i-1].AF_QuatersAlreadyDone__c==null){quartersdone=0;}else{quartersdone=po_Report_List[i-1].AF_QuatersAlreadyDone__c;}
                    if(po_Report_List[i-1].AF_Total__c==null){total=0;}else{total=po_Report_List[i-1].AF_Total__c;}
                    calcPO=calcPO+(total*((quarters+ quartersdone)/4) - previousval);                       
                    poReport.AF_PO_Total__c =calcPO;
                                                                               
                    //Previous Quarter value Calculation
                    if(po_Report_List[i-1].AF_Total__c==null){total=0;}else{total=po_Report_List[i-1].AF_Total__c;}
                    calc = calc+(total * (quarters+ quartersdone)/4);
                    poReport.AF_Previous_Quarter_Value__c=calc;
                                                                                               
                    //Traditional Previous Quarter value Calculation
                    //if(poReport.AF_PO_Report_Type__c == 'Base Fees'){
                        if(po_Report_List[i-1].AF_Traditional_Local__c==null){totalTL=0;}else{totalTL=po_Report_List[i-1].AF_Traditional_Local__c;}
                        calcTL = calcTL+(totalTL * (quarters+ quartersdone)/4);
                        if(po_Report_List[i-1].AF_OverridePO_Traditional_LC__c==null){
                        system.debug('inside if....po_Report_List[i-1].AF_OverridePO_Traditional_LC__c...'+po_Report_List[i-1].AF_OverridePO_Traditional_LC__c);
                        poReport.AF_Previous_Quarter_Value_TL__c=calcTL;
                        }
                        else{
                        system.debug('po_Report_List[i-1].AF_OverridePO_Traditional_LC__c...'+po_Report_List[i-1].AF_OverridePO_Traditional_LC__c);
                        poReport.AF_Previous_Quarter_Value_TL__c = po_Report_List[i-1].AF_OverridePO_Traditional_LC__c + po_Report_List[i-1].AF_Previous_Quarter_Value_TL__c;
                        }
                        system.debug('po_Report_List[i-1].AF_Traditional_Local__c..'+po_Report_List[i-1].AF_Traditional_Local__c);
                        system.debug('totalTL...'+totalTL);
                        system.debug('quarters...'+quarters);
                        system.debug('quartersdone...'+quartersdone);
                        system.debug('calcTL...'+calcTL);
                        if(poReport.AF_PO_Report_Type__c == 'OOPS'){
                            
                            if(po_Report_List[i-1].AF_Traditional__c==null){totalOOPSEUROTL=0;}else{totalOOPSEUROTL=po_Report_List[i-1].AF_Traditional__c;}
                            calcTLOOPSEURO = calcTLOOPSEURO+(totalOOPSEUROTL * (quarters+ quartersdone)/4);
                            poReport.AF_Previous_Quarter_Value_TL_OOPSEuro__c=calcTLOOPSEURO;
                        }
                   // }             
                    //Adapation Previous Quarter value Calculation
                    if(poReport.AF_PO_Report_Type__c == 'Base Fees'){
                        if(po_Report_List[i-1].AF_Adaptation_Local__c==null){totalAL=0;}else{totalAL=po_Report_List[i-1].AF_Adaptation_Local__c;}
                        calcAL = calcAL+(totalAL * (quarters+ quartersdone)/4);
                        if(po_Report_List[i-1].AF_OverridePO_Adaptation_LC__c==null){
                        poReport.AF_Previous_Quarter_Value_AL__c=calcAL;
                        }
                        else{
                        poReport.AF_Previous_Quarter_Value_AL__c = po_Report_List[i-1].AF_OverridePO_Adaptation_LC__c + po_Report_List[i-1].AF_Previous_Quarter_Value_AL__c;
                        }
                    }             
                    //Digital Previous Quarter value Calculation
                    if(poReport.AF_PO_Report_Type__c == 'Base Fees'){
                        if(po_Report_List[i-1].AF_Digital_Local__c==null){totalDL=0;}else{totalDL=po_Report_List[i-1].AF_Digital_Local__c;}
                        calcDL = calcDL+(totalDL * (quarters+ quartersdone)/4);
                        if(po_Report_List[i-1].AF_OverridePO_Digital_LC__c==null){
                        poReport.AF_Previous_Quarter_Value_DL__c=calcDL;
                        }
                        else{
                        poReport.AF_Previous_Quarter_Value_DL__c = po_Report_List[i-1].AF_OverridePO_Digital_LC__c + po_Report_List[i-1].AF_Previous_Quarter_Value_DL__c;
                        }
                                                                               
                    }
                    }
                    i++;
                    updateList.add(poReport);
                    uniqueKey.add(poReport.AF_Compound_Key__c);
                    system.debug('updateList...'+updateList);
                                               
                    }
                                               
                    if(updateList.size()>0){
                     //system.debug('updateList....'+updateList);
                     update  updateList;
                    }
                }
               
    }   
}