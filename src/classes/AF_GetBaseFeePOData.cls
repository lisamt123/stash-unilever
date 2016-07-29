/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_GetBaseFeePOData
@CreateDate : 11/9/2014
@Description : This is a controller class updates the records in po report object
@              based on the Agencyestimate
@Version : 1.0
@reference : none
****************************************************************************************************************************/
global with sharing class AF_GetBaseFeePOData{
	static Decimal calc;
	static Decimal calcPO;
	static Decimal total;
	static Decimal previousval;                                                
	static Decimal quarters;
	static Decimal quartersdone;
	static Decimal calcTL;
	static Decimal calcDL;
	static Decimal calcAL;
	static Decimal totalTL;
	static Decimal totalAL;
	static Decimal totalDL;
	static Decimal totalOOPSEUROTL;
	static Decimal calcTLOOPSEURO;
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
	@future
	public static void CreatePOReportFromAgencyEstimate(Set<ID> AgencyEstimateIds,Boolean deletePOReport)
	{
		af_po_report__c eachPORecord;
		List<af_po_report__c> lstpo = new List<af_po_report__c>();
		List<af_po_report__c> lstpoupdate = new List<af_po_report__c>();
		List<af_po_report__c> deletePOReportList = new List<af_po_report__c>();
		Map<ID,ID> mapPO = new Map<ID,ID>();
		List<af_po_report__c> lstpochk = new List<af_po_report__c>([select id,AF_Agency_Estimate_ID__c from af_po_report__c where AF_PO_Report_Type__c= :AF_Constants.BASEFEES_REPORT_TYPE]);
		for(af_po_report__c myagest:lstpochk)
		{
			mapPO.put(myagest.AF_Agency_Estimate_ID__c,myagest.id);
		}
		if(AgencyEstimateIds.size()>0 && !deletePOReport){
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
		else if(AgencyEstimateIds.size()>0 && deletePOReport){
			for(Id deleteRecords:AgencyEstimateIds){
				if (mapPO.containsKey(deleteRecords))
				{
					af_po_report__c deleteEachRecord = new af_po_report__c();
					deleteEachRecord.id = mapPO.get(deleteRecords);
					deletePOReportList.add(deleteEachRecord);
				}
			}
		}
		if(lstpo.size()>0)
		{
			database.insert(lstpo);
		}
		if(lstpoUpdate.size()>0)
		{
			database.update(lstpoUpdate);
		}
		if(deletePOReportList.size()>0){
			try{
			delete deletePOReportList;
			}
			catch(Exception e)
			{
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'CreatePOReportFromAgencyEstimate',e.getMessage(),e.getTypeName(),e.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Delete));
			}
		}
		lstpo.clear();
		lstpoUpdate.clear();
	}
	/***********************************************************************************
*  @Description: this method updates the records in po report based on Agencyestimate
*  @name : BatchcreatePOReportFromAgencyEstimate
*  @param : none.
*  @return: none.
*************************************************************************************/     
	public static void BatchcreatePOReportFromAgencyEstimate(Set<ID> AgencyEstimateIds,Boolean deletePOReport)
	{
		af_po_report__c eachPORecord;
		List<af_po_report__c> lstpo = new List<af_po_report__c>();
		List<af_po_report__c> lstpoupdate = new List<af_po_report__c>();
		List<af_po_report__c> deletePOReportList = new List<af_po_report__c>();
		Map<ID,ID> mapPO = new Map<ID,ID>();
		List<af_po_report__c> lstpochk = new List<af_po_report__c>([select id,AF_Agency_Estimate_ID__c from af_po_report__c where AF_PO_Report_Type__c= :AF_Constants.BASEFEES_REPORT_TYPE LIMIT 50000]);
		for(af_po_report__c myagest:lstpochk)
		{
			mapPO.put(myagest.AF_Agency_Estimate_ID__c,myagest.id);
		}
		if(AgencyEstimateIds.size()>0 && !deletePOReport){
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
		else if(AgencyEstimateIds.size()>0 && deletePOReport){
			for(Id deleteRecords:AgencyEstimateIds){
				if (mapPO.containsKey(deleteRecords))
				{
					af_po_report__c deleteEachRecord = new af_po_report__c();
					deleteEachRecord.id = mapPO.get(deleteRecords);
					deletePOReportList.add(deleteEachRecord);
				}
			}
		}
		if(lstpo.size()>0)
		{
			database.insert(lstpo);
		}
		if(lstpoUpdate.size()>0)
		{
			database.update(lstpoUpdate);
		}
		if(deletePOReportList.size()>0){
			try{
			delete deletePOReportList;
			}
			 catch(Exception e)
			 {
			 	AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'BatchcreatePOReportFromAgencyEstimate',e.getMessage(),e.getTypeName(),e.getStackTraceString());
			 	apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Delete)); 
			 }
		}
		lstpo.clear();
		lstpoUpdate.clear();
	}
	/***********************************************************************************
*  @Description: this method updates the records in po report based on oopestimate
*  @name : CreatePOReportFromOopsEstimate
*  @param : none.
*  @return: none.
*************************************************************************************/        
	public static void CreatePOReportFromOopsEstimate(Set<ID> OopsEstimateIds,Boolean deletePOReport)
	{
		af_po_report__c eachPORecord;
		List<af_po_report__c> lstpo = new List<af_po_report__c>();
		List<af_po_report__c> lstpoupdate = new List<af_po_report__c>();
		List<af_po_report__c> deletePOReportList = new List<af_po_report__c>();
		Map<ID,ID> mapPO = new Map<ID,ID>();
		List<af_po_report__c> lstpochk = new List<af_po_report__c>([select id,AF_Oops_Estimate_ID__c from af_po_report__c where AF_PO_Report_Type__c= :AF_Constants.OOPS_REPORT_TYPE]);
		for(af_po_report__c myagest:lstpochk)
		{
			mapPO.put(myagest.AF_Oops_Estimate_ID__c,myagest.id);
		}
		if(OopsEstimateIds.size()>0 && !deletePOReport){
			for(AF_OOPS_Estimate__c mypo:[SELECT AF_PO_Report_Type__c,AF_Override_Estimate_Local__c,AF_Status__c,AF_Brand__c,AF_EstimateLocal__c,af_estimate__c,AF_PO_Number__c,AF_Unilever_Entity__r.name,AF_OOPS_Actual__r.name,AF_OOPS_Actual__r.AF_Status__c,AF_OOPS_Actual__r.AF_Fiscal_year__c,AF_OOPS_Actual__c,id,AF_OOPS_Actual__r.AF_Brand__r.AF_Category_Brands__r.Name,AF_Compound_key__c,AF_Agency_Entity__r.af_legal_entity_name__c,AF_Agency_Entity__r.name,Unilever_Entity_Name__c,AF_Total__c,AF_Max_Quarter__c,AF_CountNoQuarters__c,AF_QuatersAlreadyDone__c,AF_Traditional__c,AF_Digital__c,AF_Adaptation__c,AF_OOPS_Matrix_Currency_Code__c,AF_Ready_For_PO_Entry_Currency__c,AF_OOPS_Actual__r.AF_Agency_lk__r.name FROM AF_OOPS_Estimate__c where Id IN:OopsEstimateIds])
			{
				eachPORecord = new af_po_report__c();
				eachPORecord.AF_PO_Report_Type__c= mypo.AF_PO_Report_Type__c;
				eachPORecord.af_po_number__c=mypo.AF_PO_Number__c;
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
				eachPORecord.AF_OverridePO_Traditional_LC__c =  mypo.AF_Override_Estimate_Local__c;
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
		else if(OopsEstimateIds.size()>0 && deletePOReport){
			for(Id deleteRecords:OopsEstimateIds){
				if (mapPO.containsKey(deleteRecords))
				{
					af_po_report__c deleteEachRecord = new af_po_report__c();
					deleteEachRecord.id = mapPO.get(deleteRecords);
					deletePOReportList.add(deleteEachRecord);
				}
			}
		}
		if(lstpo.size()>0)
		{
			database.insert(lstpo);
		}
		if(lstpoUpdate.size()>0)
		{
			database.update(lstpoUpdate);
		}
		if(deletePOReportList.size()>0){
			try{
			delete deletePOReportList;
			}
			catch(Exception e)
			{
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'CreatePOReportFromOopsEstimate',e.getMessage(),e.getTypeName(),e.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Delete)); 
			}
		}
		lstpo.clear();
		lstpoUpdate.clear();
	}
	/***********************************************************************************
*  @Description: this method will calculate the oopsvalues in po report
*  @name : CreatePOReportFromOopsEstimate
*  @param : none.
*  @return: none.
*************************************************************************************/        
	public static void CalculatePoReportValues(Map<String,String> compundKeyReportType,Set<String> CompundKeys){
		List<AF_PO_Report__c> po_Report_List = new List<AF_PO_Report__c>();
		set<String> baseFeeKey = new set<String>();
		set<String> oopsKey = new set<String>();
		for(String key:CompundKeys){
			if(compundKeyReportType.get(key)==AF_Constants.BASEFEES_REPORT_TYPE){
				baseFeeKey.add(key);
			}
			else{
				oopsKey.add(key);
			}
		}
		if(baseFeeKey.size()>0){
			po_Report_List = [select AF_Total__c,AF_CountNoQuarters__c,AF_OverridePO_Digital_LC__c,AF_OverridePO_Traditional_LC__c,AF_OverridePO_Adaptation_LC__c,AF_Traditional_Local__c,AF_Digital_Local__c,AF_PO_Report_Type__c,AF_Adaptation_Local__c,af_max_quarter__c,AF_QuatersAlreadyDone__c,AF_Calculated_PO_Value_Formula__c,AF_Previous_Quarter_Value__c,AF_Compound_Key__c,AF_Calculate_Tradition_Local__c,AF_Previous_Quarter_Value_TL__c,AF_Calculate_Digital_Local__c,AF_Previous_Quarter_Value_DL__c,AF_Calculate_Adaptation_Local__c,AF_Previous_Quarter_Value_AL__c from AF_PO_Report__c where AF_PO_Report_Type__c=:AF_Constants.BASEFEES_REPORT_TYPE and AF_Compound_Key__c in:baseFeeKey order by AF_Compound_Key__c,AF_QuatersAlreadyDone__c ASC];
			calculateBaseOopsvalues(po_Report_List);
		}
		po_Report_List.clear();
		if(oopsKey.size()>0){
			po_Report_List = [select AF_Total__c,AF_OverridePO_Traditional_LC__c,AF_Previous_Quarter_Value_TL_OOPSEuro__c,AF_CountNoQuarters__c,AF_Traditional_Local__c,AF_Digital_Local__c,AF_PO_Report_Type__c,AF_Adaptation_Local__c,af_max_quarter__c,AF_QuatersAlreadyDone__c,AF_Calculated_PO_Value_Formula__c,AF_Previous_Quarter_Value__c,AF_Compound_Key__c,AF_Calculate_Tradition_Local__c,AF_Previous_Quarter_Value_TL__c,AF_Calculate_Digital_Local__c,AF_Previous_Quarter_Value_DL__c,AF_Calculate_Adaptation_Local__c,AF_Previous_Quarter_Value_AL__c,AF_Traditional__c from AF_PO_Report__c where AF_PO_Report_Type__c=:AF_Constants.OOPS_REPORT_TYPE and AF_Compound_Key__c in:oopsKey order by AF_Compound_Key__c,AF_QuatersAlreadyDone__c ASC];
			calculateBaseOopsvalues(po_Report_List);
		}
	} 
	/***************************************************************************************
*  @Description: this method will creates records in Poreport Base fee based on the 
*  @             quarter of agency estimate and calculate the Basefees values in po report 
*  @name : calculateBaseOopsvalues
*  @param : none.
*  @return: none.
*************************************************************************************/      
	public static void calculateBaseOopsvalues(List<AF_PO_Report__c> po_Report_List){
		List<AF_PO_Report__c> updateList = new List<AF_PO_Report__c>();
		set<String> uniqueKey = new set<String>();
		integer i=0;
		if(po_Report_List.size()>0){
			for(AF_PO_Report__c poReport:po_Report_List){
				calc=0.0;
				calcPO=0.0;
				total=0;
				previousval=0.0;                                                
				quarters=0;
				quartersdone=0;
				calcTL=0.0;
				calcDL=0.0;
				calcAL=0.0;
				totalTL=0;
				totalAL=0;
				totalDL=0;
				totalOOPSEUROTL=0;
				calcTLOOPSEURO=0.0;
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
					poReport = POValueCalc(i,po_Report_List,poReport);
					
					//Previous Quarter value Calculation
					if(po_Report_List[i-1].AF_Total__c==null){total=0;}else{total=po_Report_List[i-1].AF_Total__c;}
					calc = calc+(total * (quarters+ quartersdone)/4);
					poReport.AF_Previous_Quarter_Value__c=calc;
					//Traditional Previous Quarter value Calculation
					poReport = POTradCalc(i,po_Report_List,poReport);
					          
					//Adapation Previous Quarter value Calculation
					poReport = POAdaptCalc(i,po_Report_List,poReport);
					         
					//Digital Previous Quarter value Calculation
					poReport = PODigitalCalc(i,po_Report_List,poReport);
					
				}
				i++;
				updateList.add(poReport);
				uniqueKey.add(poReport.AF_Compound_Key__c);
			}
			if(updateList.size()>0){
				try{
				update  updateList;
				}
				catch(Exception e)
				{
					AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'calculateBaseOopsvalues',e.getMessage(),e.getTypeName(),e.getStackTraceString());
					apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
				}
			}
		}
	}  
	public static AF_PO_Report__c POValueCalc(Integer i,List<AF_PO_Report__c> po_Report_List,AF_PO_Report__c poReport){
		if(po_Report_List[i-1].AF_Previous_Quarter_Value__c == null) {previousval=0;} else {previousval=po_Report_List[i-1].AF_Previous_Quarter_Value__c;}
		if(po_Report_List[i-1].AF_CountNoQuarters__c==null){quarters=0;}else{quarters=po_Report_List[i-1].AF_CountNoQuarters__c;}
		if(po_Report_List[i-1].AF_QuatersAlreadyDone__c==null){quartersdone=0;}else{quartersdone=po_Report_List[i-1].AF_QuatersAlreadyDone__c;}
		if(po_Report_List[i-1].AF_Total__c==null){total=0;}else{total=po_Report_List[i-1].AF_Total__c;}
		calcPO=calcPO+(total*((quarters+ quartersdone)/4) - previousval);                       
		poReport.AF_PO_Total__c =calcPO;
		return poReport;
	}
    public static AF_PO_Report__c POTradCalc(Integer i,List<AF_PO_Report__c> po_Report_List,AF_PO_Report__c poReport){
		if(po_Report_List[i-1].AF_Traditional_Local__c==null){totalTL=0;}else{totalTL=po_Report_List[i-1].AF_Traditional_Local__c;}
					calcTL = calcTL+(totalTL * (quarters+ quartersdone)/4);
					if(po_Report_List[i-1].AF_OverridePO_Traditional_LC__c==null){
						poReport.AF_Previous_Quarter_Value_TL__c=calcTL;
					}
					else{
						poReport.AF_Previous_Quarter_Value_TL__c = po_Report_List[i-1].AF_OverridePO_Traditional_LC__c + po_Report_List[i-1].AF_Previous_Quarter_Value_TL__c;
					}
					if(poReport.AF_PO_Report_Type__c == AF_Constants.OOPS_REPORT_TYPE){
						if(po_Report_List[i-1].AF_Traditional__c==null){totalOOPSEUROTL=0;}else{totalOOPSEUROTL=po_Report_List[i-1].AF_Traditional__c;}
						calcTLOOPSEURO = calcTLOOPSEURO+(totalOOPSEUROTL * (quarters+ quartersdone)/4);
						poReport.AF_Previous_Quarter_Value_TL_OOPSEuro__c=calcTLOOPSEURO;
					}
		return poReport;
	}

	public static AF_PO_Report__c POAdaptCalc(Integer i,List<AF_PO_Report__c> po_Report_List,AF_PO_Report__c poReport){
		if(poReport.AF_PO_Report_Type__c == AF_Constants.BASEFEES_REPORT_TYPE){
						if(po_Report_List[i-1].AF_Adaptation_Local__c==null){totalAL=0;}else{totalAL=po_Report_List[i-1].AF_Adaptation_Local__c;}
						calcAL = calcAL+(totalAL * (quarters+ quartersdone)/4);
						if(po_Report_List[i-1].AF_OverridePO_Adaptation_LC__c==null){
							poReport.AF_Previous_Quarter_Value_AL__c=calcAL;
						}
						else{
							poReport.AF_Previous_Quarter_Value_AL__c = po_Report_List[i-1].AF_OverridePO_Adaptation_LC__c + po_Report_List[i-1].AF_Previous_Quarter_Value_AL__c;
						}
					} 
		return poReport;				
	}
	
	public static AF_PO_Report__c PODigitalCalc(Integer i,List<AF_PO_Report__c> po_Report_List,AF_PO_Report__c poReport){
		if(poReport.AF_PO_Report_Type__c == AF_Constants.BASEFEES_REPORT_TYPE){
						if(po_Report_List[i-1].AF_Digital_Local__c==null){totalDL=0;}else{totalDL=po_Report_List[i-1].AF_Digital_Local__c;}
						calcDL = calcDL+(totalDL * (quarters+ quartersdone)/4);
						if(po_Report_List[i-1].AF_OverridePO_Digital_LC__c==null){
							poReport.AF_Previous_Quarter_Value_DL__c=calcDL;
						}
						else{
							poReport.AF_Previous_Quarter_Value_DL__c = po_Report_List[i-1].AF_OverridePO_Digital_LC__c + po_Report_List[i-1].AF_Previous_Quarter_Value_DL__c;
						}
					}
		return poReport;
	}
}