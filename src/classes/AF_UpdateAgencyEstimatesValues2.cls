/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_UpdateAgencyEstimatesValues2
@CreateDate : 20/6/2014
@Description : This is a controller class for trigger of AgencyEstimate 
@			  this is used to calculate the local currency.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing Class AF_UpdateAgencyEstimatesValues2
{
	static set<id>   AgencyEntity= new set<id>();
	static set<id>   unileverEntity=new set<id>();
	static set<String> fYear=new set<String>();
	static Map<id ,String> AgencyEntityNames=new Map<id,String>();
	static Map<id ,String> unileverEntityNames=new Map<id,String>();
	static List<string> matrixCountries=new list<string>();
	static Map<id,list<string>>  mapMatrixtable=new Map<id,list<string>>();
	static Map<id,string> mapMatrixcountry=new Map<id,string>();
	static Map<id,string> mapReadyForPOCountry=new Map<id,string>();
	static Map<string,Double>  CurrencyMap=new  Map<string,Double>();
	static Map<string,Double>  CurrencyMapforUSD=new  Map<string,Double>();
	static Map<string,Double>  CurrencyMapforGBP=new  Map<string,Double>();
	static set<string>  currncycodes=new set<string>();
	static list<string> matrixString;
	static Map<id,String>  matrixDataEntryCurrency=new Map<id,String>();
	static Map<id,String>  matrixReadyforconversion=new Map<id,String>();
	static Map<id,String>  ReadyForPOEntryCurrency=new Map<id,String>();
	static Integer MatrixRecoundCount=0;
	static Double USDValue=0.0;
	static Double EURValue=0.0;
	static List<String> AgencyEntitycountry =new List<String>();
	static List<String> unileverEntitycountry =new List<String>();
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
	/***********************************************************************************
*  @Description: this method is used to calculate the local currency for the entity
*  @             based on the currency current fiscal year and average exchange rate in
*  @             matrix table
*  @name : UpdateExchageRates
*  @param : ae
*  @return: none.
*************************************************************************************/	 
	public static void UpdateExchageRates(list<AF_Agency_Estimate__c> ae)
	{
		List<AF_Agency_Estimate__c> agencyRecords=ae;
		if(agencyRecords.size()>0)
		for(AF_Agency_Estimate__c agencyEst:agencyRecords)
		{   
			if(agencyEst.AF_Agency_Entity__c!=null){
				AgencyEntity.add(agencyEst.AF_Agency_Entity__c);//collecting AgencyEnties  
			}
			if(agencyEst.AF_Unilever_Entity__c!=null){       
				unileverEntity.add(agencyEst.AF_Unilever_Entity__c);// Collecting Unilever  Entities
			}
			if(agencyEst.AF_Fiscal_Year__c!=null){       
				fYear.add(agencyEst.AF_Fiscal_Year__c);// Collecting Unilever  Entities
			} else
			{
				fYear.add (agencyEst.AF_Fiscal_Year_FF__c);
			}
		}
		// query for retrieve  Entities countries(Agency)
		If(AgencyEntity.size()>0)
		for(AF_Entity__c  entity:[Select id,Name,AF_Country__c from AF_Entity__c  where id IN:AgencyEntity limit 50000 ])
		{
			AgencyEntityNames.put(entity.id,entity.AF_Country__c );// Add id,and its Agency Country from Entity 
			AgencyEntitycountry.add(entity.AF_Country__c);
		}
		// query for retrieve  Entities countries(unilever)   
		If(unileverEntity.size()>0)
		for(AF_Entity__c  entity:[Select id,Name,AF_Country__c from AF_Entity__c  where id IN:unileverEntity limit 50000 ])
		{
			unileverEntityNames.put(entity.id,entity.AF_Country__c );// Add id,and its unilever Country from Entity 
			unileverEntitycountry.add(entity.AF_Country__c);
		}
		retrieveMatrixTable(agencyRecords);
	}
	/***********************************************************************************
*  @Description: this method is used to query the Matrix table         
*  @name : retrieveMatrixTable
*  @param : List<AF_Agency_Estimate__c>
*  @return: none.
*************************************************************************************/
	public static void retrieveMatrixTable(List<AF_Agency_Estimate__c> agencyRecords){
		//Query for matrix Table reocrds    
		list<AF_Matrix_Table__c> matrixRecords=[select id, AF_Agency_Country__c,AF_Matrix_Country__c,AF_Matrix_country_Currency__c,AF_Matrix_Currency_Code__c,AF_Ready_For_PO_Country__c,AF_Ready_For_PO_Country_Currency__c,AF_Ready_For_PO_Currency_Code__c,Ready_For_PO_Conversion__c,AF_Unilver_Country__c from AF_Matrix_Table__c where AF_Unilver_Country__c IN :unileverEntitycountry AND AF_Agency_Country__c IN : AgencyEntitycountry  limit 50000];   
		if(matrixRecords.size()>0)
		for(AF_Matrix_Table__c mtable:matrixRecords)
		{
			String matrixcurrency;
			string readyforPo;
			if(mtable.AF_Unilver_Country__c!=null && mtable.AF_Agency_Country__c!=null )
			{
				if(mtable.AF_Matrix_Country__c!=null && mtable.AF_Matrix_Currency_Code__c!=null )
				{
					matrixcurrency=mtable.AF_Matrix_Country__c+'-'+mtable.AF_Matrix_Currency_Code__c;                  
					currncycodes.add(matrixcurrency);
					mapMatrixcountry.put(mtable.id,matrixcurrency);
					matrixDataEntryCurrency.put(mtable.id,mtable.AF_Matrix_Currency_Code__c);
				}
				if(mtable.AF_Ready_For_PO_Country__c!=null && mtable.AF_Ready_For_PO_Currency_Code__c!=null )
				{
					readyforPo=mtable.AF_Ready_For_PO_Country__c+'-'+mtable.AF_Ready_For_PO_Currency_Code__c;                     
					mapReadyForPOCountry.put(mtable.id,readyforPo);
					currncycodes.add(readyforPo);
					ReadyForPOEntryCurrency.put(mtable.id,mtable.AF_Ready_For_PO_Currency_Code__c);
				}
				if(mtable.Ready_For_PO_Conversion__c!=AF_Constants.AF_NONE_DELIM)
				MatrixReadyforConversion.put(mtable.id,mtable.Ready_For_PO_Conversion__c);
				matrixCountries=new list<string>();
				matrixCountries.add(mtable.AF_Unilver_Country__c);
				matrixCountries.add(mtable.AF_Agency_Country__c);
				mapMatrixtable.put(mtable.id,matrixCountries);
			}     
		}
		retrieveCurrency(agencyRecords,matrixRecords);
	}
	/***********************************************************************************
*  @Description: this method is used to retrieve currency records         
*  @name : retrieveCurrency
*  @param : List<AF_Agency_Estimate__c>,List<AF_Matrix_Table__c>
*  @return: none.
*************************************************************************************/
	public static void retrieveCurrency(List<AF_Agency_Estimate__c> agencyRecords,List<AF_Matrix_Table__c> matrixRecords){
		retrieveCurrencyExt();
		if(agencyRecords.size()>0)
		for(AF_Agency_Estimate__c agencyEst:agencyRecords)
		{     
			String agncyentity;
			string unlieverentity;
			MatrixRecoundCount=0;      
			if(agencyEst.AF_Agency_Entity__c!=null)
			agncyentity= AgencyEntityNames.get(agencyEst.AF_Agency_Entity__c);
			if(agencyEst.AF_Unilever_Entity__c!=null)
			unlieverentity=unileverEntityNames.get(agencyEst.AF_Unilever_Entity__c);
			if(matrixRecords.size()>0)
			for(AF_Matrix_Table__c mt:matrixRecords)
			{ 
				Boolean Testexit=false; 
				matrixString=mapMatrixtable.get(mt.id);
				if(matrixString.size()==2)
				{
					if(matrixString[0]==unlieverentity && matrixString[1]==agncyentity)
					{   
						String Matccode=mapMatrixcountry.get(mt.id);
						string readypcode=mapReadyForPOCountry.get(mt.id);
						retrieveStatusRate(agencyEst,Matccode,readypcode,mt);
						agencyEst.AF_Matrix_Data_Entry_Currency__c=matrixDataEntryCurrency.get(mt.id);
						agencyEst.AF_Ready_For_PO_Entry_Currency__c=MatrixReadyforConversion.get(mt.id);
						Testexit=true;
						matrixString.clear();
					} 
					else
					{
						MatrixRecoundCount=MatrixRecoundCount+1;
					}
				}
				if(Testexit)
				break;
			}
		}
	}
	/***********************************************************************************
*  @Description: this method is used to retrieve currency records         
*  @name : retrieveCurrencyExt
*  @param : none
*  @return: none.
*************************************************************************************/
	public static void retrieveCurrencyExt(){
		// Query for USD Currency
		AF_Currency__c USDCurrencyTable;
		try{
			USDCurrencyTable=[select id,Country_Currency__c,AF_Currency_Code__c ,AF_Average_Exchange_Rate_To_EUR__c,Ready_For_PO_Exchange_Rate_SGD_To_USD__c,Ready_For_PO_Exchange_Rate_To_EUR__c from AF_Currency__c where Locked__c=:false and AF_Currency_Code__c=:AF_Constants.AF_CURRENCY_USD  and AF_Fiscal_Year_new__c IN :fYear  Order by Createddate limit 1];
		}
		catch(Exception ex){
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'UpdateExchageRates',
			ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
		}
		if(USDCurrencyTable!=null)
		if(USDCurrencyTable.AF_Average_Exchange_Rate_To_EUR__c!=null)
		{
			EURValue=USDCurrencyTable.AF_Average_Exchange_Rate_To_EUR__c;
		}    
		// Query for Retrieve Currency Records
		List<AF_Currency__c> currencyrecords;
		try{
			currencyrecords =[select id,Country_Currency__c,AF_Currency_Code__c ,AF_Average_Exchange_Rate_To_EUR__c,Ready_For_PO_Exchange_Rate_SGD_To_USD__c,Ready_For_PO_Exchange_Rate_To_EUR__c from AF_Currency__c where Locked__c=:false and Country_Currency__c IN:currncycodes  and AF_Fiscal_Year_new__c IN :fYear limit 50000];
		}
		catch(Exception ex){
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'UpdateExchageRates',
			ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
		}
		if(currencyrecords.size()>0)
		for(AF_Currency__c  curren:currencyrecords)
		{
			if(curren.Country_Currency__c!=null)
			{
				CurrencyMap.put(curren.Country_Currency__c,curren.AF_Average_Exchange_Rate_To_EUR__c );
				CurrencyMapforUSD.put(curren.Country_Currency__c,curren.Ready_For_PO_Exchange_Rate_SGD_To_USD__c );
				CurrencyMapforGBP.put(curren.Country_Currency__c,curren.Ready_For_PO_Exchange_Rate_To_EUR__c );
			}
			If(curren.AF_Currency_Code__c==AF_Constants.AF_CURRENCY_EUR)
			if(curren.Ready_For_PO_Exchange_Rate_To_EUR__c!=null)
			USDValue=curren.Ready_For_PO_Exchange_Rate_To_EUR__c;
		}
	}
	/***********************************************************************************
*  @Description: this method is used to retrieve exchangerates from the currency records
				 and also holds the logic to update the spot rate and Traditional,digital and
				 Adaptation local rates and Agencyexchange rate for the GBP or USD,based on
				 Matrix table,when the status is ready for PO.       
*  @name : retrieveStatusRate
*  @param : AF_Agency_Estimate__c,String,String,AF_Matrix_Table__c
*  @return: none.
*************************************************************************************/
	public static void retrieveStatusRate(AF_Agency_Estimate__c agencyEst,String Matccode,String readypcode,AF_Matrix_Table__c mt){
		if(agencyEst.AF_Status__c==AF_Constants.BASE_FEES_READYFORPO)
		{     
			if(MatrixReadyforConversion.get(mt.id)!=AF_Constants.AF_NONE_DELIM && MatrixReadyforConversion.get(mt.id)==AF_Constants.AF_CURRENCY_GBP)
			agencyEst.AF_Agency_Spot_Rate__c= CurrencyMapforUSD.get(readypcode);
			else if(MatrixReadyforConversion.get(mt.id)!=AF_Constants.AF_NONE_DELIM && MatrixReadyforConversion.get(mt.id)==AF_Constants.AF_CURRENCY_USD)
			agencyEst.AF_Agency_Spot_Rate__c= CurrencyMapforGBP.get(readypcode);
			if(agencyEst.Unilever_Code__c!=matrixDataEntryCurrency.get(mt.id))
			{
				agencyEst.AF_Agency_Exchange_Rate__c= CurrencyMap.get(Matccode);
			}
			if(agencyEst.AF_Agency_Spot_Rate__c != null && agencyEst.AF_Agency_Spot_Rate__c!= 0 && agencyEst.AF_Traditional__c  != null  && agencyEst.AF_Agency_Exchange_Rate__c!=null)
			agencyEst.AF_Traditional_Local__c = (agencyEst.AF_Traditional__c*agencyEst.AF_Agency_Exchange_Rate__c)/agencyEst.AF_Agency_Spot_Rate__c;
			if(agencyEst.AF_Agency_Spot_Rate__c  != null && agencyEst.AF_Agency_Spot_Rate__c != 0 && agencyEst.AF_Digital__c != null && agencyEst.AF_Agency_Exchange_Rate__c!=null) 
			agencyEst.AF_Digital_Local__c =(agencyEst.AF_Digital__c*agencyEst.AF_Agency_Exchange_Rate__c)/agencyEst.AF_Agency_Spot_Rate__c ;
			if(agencyEst.AF_Agency_Spot_Rate__c  != null && agencyEst.AF_Agency_Spot_Rate__c!= 0 && agencyEst.AF_Adaptation__c != null && agencyEst.AF_Agency_Exchange_Rate__c!=null) 
			agencyEst.AF_Adaptation_Local__c = (agencyEst.AF_Adaptation__c*agencyEst.AF_Agency_Exchange_Rate__c)/agencyEst.AF_Agency_Spot_Rate__c ;
			if(agencyEst.AF_Agency_Spot_Rate__c !=null && agencyEst.AF_Agency_Spot_Rate__c !=0 && USDValue!=0.0)
			agencyEst.Indicative_Gain_in_USD__c = ((agencyEst.AF_Traditional__c+agencyEst.AF_Digital__c+agencyEst.AF_Adaptation__c)/USDValue)-(agencyEst.AF_Traditional_Local__c+agencyEst.AF_Digital_Local__c +agencyEst.AF_Adaptation_Local__c) ;
			if( agencyEst.Indicative_Gain_in_USD__c!=null && EURValue!=null && EURValue!=0.0)
			{
				agencyEst.Indicative_Gain_Loss_in_EUR__c=agencyEst.Indicative_Gain_in_USD__c/EURValue;
			}
		}
		else 
		{
			retrieveStatusRateExt(agencyEst,Matccode);
			
		}
	}
	public static void retrieveStatusRateExt(AF_Agency_Estimate__c agencyEst,String Matccode){
		agencyEst.AF_Agency_Spot_Rate__c=null; 
			agencyEst.AF_Agency_Exchange_Rate__c= CurrencyMap.get(Matccode);
			if(agencyEst.AF_Agency_Exchange_Rate__c != null && agencyEst.AF_Agency_Exchange_Rate__c!= 0 && agencyEst.AF_Traditional__c  != null)
			agencyEst.AF_Traditional_Local__c = agencyEst.AF_Traditional__c*agencyEst.AF_Agency_Exchange_Rate__c;
			if(agencyEst.AF_Agency_Exchange_Rate__c  != null && agencyEst.AF_Agency_Exchange_Rate__c != 0 && agencyEst.AF_Digital__c != null) 
			agencyEst.AF_Digital_Local__c =agencyEst.AF_Digital__c*agencyEst.AF_Agency_Exchange_Rate__c ;
			if(agencyEst.AF_Agency_Exchange_Rate__c  != null && agencyEst.AF_Agency_Exchange_Rate__c!= 0 && agencyEst.AF_Adaptation__c != null) 
			agencyEst.AF_Adaptation_Local__c = agencyEst.AF_Adaptation__c*agencyEst.AF_Agency_Exchange_Rate__c ;
	}
	
}