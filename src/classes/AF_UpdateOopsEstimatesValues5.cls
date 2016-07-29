/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_UpdateOopsEstimatesValues5
@CreateDate : 28/7/2014
@Description : This is a controller class for OOPS Estimate trigger, 
@             this is used to calculate the local currency for oopsEstimate.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing Class AF_UpdateOopsEstimatesValues5
{
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
    static set<String> agencyCountries=new set<String>();
    static set<String> unileverCountries=new set<String>();
    private static string className_STR=AF_UpdateOopsEstimatesValues5.class.getName();
    
    /***********************************************************************************
*  @Description: this method is used to calculate the local currency of OOPSEstimate
*  @name : UpdateExchageRates
*  @param : ae
*  @return: none.
*************************************************************************************/  
    public static void UpdateExchageRates(list<AF_OOPS_Estimate__c> ae)
    {
    	set<id>   AgencyEntity= new set<id>();
    	set<id>   unileverEntity=new set<id>();
        List<AF_OOPS_Estimate__c> agencyRecords=ae;
        if(agencyRecords.size()>0)
        for(AF_OOPS_Estimate__c agencyEst:agencyRecords)
        {   
            if(agencyEst.AF_Agency_Entity__c!=null)
            AgencyEntity.add(agencyEst.AF_Agency_Entity__c);//collecting AgencyEnties  
            if(agencyEst.AF_Unilever_Entity__c!=null)       
            unileverEntity.add(agencyEst.AF_Unilever_Entity__c);// Collecting Unilever  Entities
            if(agencyEst.AF_Fiscal_Year__c!=null){       
                fYear.add(agencyEst.AF_Fiscal_Year__c);
            }
            else
            {
                fYear.add(agencyEst.AF_Fiscal_Year_FF__c); 
            }
        }
        // query for retrieve  Entities countries(Agency)
        If(AgencyEntity.size()>0)
        for(AF_Entity__c  entity:[Select id,Name,AF_Country__c from AF_Entity__c  where id IN:AgencyEntity limit 50000 ])
        {
            AgencyEntityNames.put(entity.id,entity.AF_Country__c );// Add id,and its Agency Country from Entity 
            agencyCountries.add(entity.AF_Country__c);
        }
        // query for retrieve  Entities countries(unilever)   
        If(unileverEntity.size()>0)
        for(AF_Entity__c  entity:[Select id,Name,AF_Country__c from AF_Entity__c  where id IN:unileverEntity limit 50000 ])
        {
            unileverEntityNames.put(entity.id,entity.AF_Country__c );// Add id,and its unilever Country from Entity 
            unileverCountries.add(entity.AF_Country__c);
        }
        retrieveMatrixTable(agencyRecords);
        
    }
    public static void retrieveMatrixTable(List<AF_OOPS_Estimate__c> agencyRecords){
        //Query for matrix Table records 
        list<AF_Matrix_Table__c> matrixRecords=[select id, AF_Agency_Country__c,AF_Matrix_Country__c,Ready_For_PO_Conversion__c,AF_Matrix_country_Currency__c,AF_Matrix_Currency_Code__c,AF_Ready_For_PO_Country__c,AF_Ready_For_PO_Country_Currency__c,AF_Ready_For_PO_Currency_Code__c,AF_Unilver_Country__c from AF_Matrix_Table__c where AF_Agency_Country__c IN : agencyCountries And AF_Unilver_Country__c IN : unileverCountries limit 50000];
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
*  @Description: this method is used to to query the exchange rates
*  @name : retrieveCurrency
*  @param : ae
*  @return: none.
*************************************************************************************/  
    public static void retrieveCurrency(List<AF_OOPS_Estimate__c> agencyRecords,List<AF_Matrix_Table__c> matrixRecords){
        retrieveCurrencyExt();
        if(agencyRecords.size()>0)
        for(AF_OOPS_Estimate__c agencyEst:agencyRecords)
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
                if(matrixString!=null&&matrixString.size()>=2)
                {
                    if(matrixString[0]==unlieverentity && matrixString[1]==agncyentity)
                    {   
                        
                        String Matccode=mapMatrixcountry.get(mt.id);
                        string readypcode=mapReadyForPOCountry.get(mt.id);
                        retrieveStatusRate(agencyEst,Matccode,readypcode,mt);
                        agencyEst.AF_Agency_Exchange_Rate__c= CurrencyMap.get(Matccode);
                        if (agencyEst.AF_Status__c==AF_Constants.BASE_FEES_READYFORPO &&  agencyEst.AF_Ready_For_PO_Entry_Currency__c != null && agencyEst.AF_Ready_For_PO_Exchange_Rate__c !=null)
                        {
                            agencyEst.AF_OOPS_Matrix_Currency_Code__c = agencyEst.AF_Ready_For_PO_Entry_Currency__c;
                            agencyEst.AF_Agency_Exchange_Rate__c = agencyEst.AF_Ready_For_PO_Exchange_Rate__c;
                        }
                        else
                        {
                            agencyEst.AF_OOPS_Matrix_Currency_Code__c=matrixDataEntryCurrency.get(mt.id);
                            agencyEst.AF_MatrixCodeTemp__c = matrixDataEntryCurrency.get(mt.id);
                            agencyEst.AF_Ready_For_PO_Entry_Currency__c=matrixReadyforconversion.get(mt.id);
                            agencyEst.AF_ReadyforPoCodeTemp__c=matrixReadyforconversion.get(mt.id);
                            if(agencyEst.AF_ReadyforPoCodeTemp__c==null){
                                agencyEst.AF_ReadyforPoCodeTemp__c = matrixDataEntryCurrency.get(mt.id);
                            }
                        }
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
    public static void retrieveCurrencyExt(){
        // Query for Retrieve Currency Records
        List<AF_Currency__c> currencyrecords;
        try{    
            currencyrecords=[select id,Country_Currency__c,Ready_For_PO_Exchange_Rate_To_EUR__c,AF_Currency_Code__c,Ready_For_PO_Exchange_Rate_SGD_To_USD__c,AF_Average_Exchange_Rate_To_EUR__c from AF_Currency__c where Locked__c=:false and Country_Currency__c IN:currncycodes  and AF_Fiscal_Year_new__c IN :fYear limit 50000];
        }
        catch(Exception e){
            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'AF_UpdateOopsEstimatesValues5',e.getMessage(),e.getTypeName(),e.getStackTraceString());
        }
        if(currencyrecords.size()>0)
        for(AF_Currency__c  curren:currencyrecords)
        {
            if(curren.Country_Currency__c!=null)
            {
                CurrencyMap.put(curren.Country_Currency__c,curren.AF_Average_Exchange_Rate_To_EUR__c);
                CurrencyMapforUSD.put(curren.Country_Currency__c,curren.Ready_For_PO_Exchange_Rate_SGD_To_USD__c );
                CurrencyMapforGBP.put(curren.Country_Currency__c,curren.Ready_For_PO_Exchange_Rate_To_EUR__c );
            }
        }
    }
    public static void retrieveStatusRate(AF_OOPS_Estimate__c agencyEst,String Matccode,String readypcode,AF_Matrix_Table__c mt){
        if(agencyEst.AF_Status__c==AF_Constants.BASE_FEES_READYFORPO)
                        {     
                            if(MatrixReadyforConversion.get(mt.id)!=AF_Constants.AF_NONE_DELIM && MatrixReadyforConversion.get(mt.id)==AF_Constants.AF_CURRENCY_GBP){
                                agencyEst.AF_Ready_For_PO_Exchange_Rate__c= CurrencyMapforUSD.get(readypcode);
                                agencyEst.AF_ReadyforPOExchangeRateTemp__c= CurrencyMapforUSD.get(readypcode);
                            }
                            else if(MatrixReadyforConversion.get(mt.id)!=AF_Constants.AF_NONE_DELIM && MatrixReadyforConversion.get(mt.id)==AF_Constants.AF_CURRENCY_USD){
                                agencyEst.AF_Ready_For_PO_Exchange_Rate__c= CurrencyMapforGBP.get(readypcode);
                                agencyEst.AF_ReadyforPOExchangeRateTemp__c= CurrencyMapforGBP.get(readypcode);
                            }
                            if(agencyEst.AF_OOPS_Code__c!=matrixDataEntryCurrency.get(mt.id))
                            {
                                agencyEst.AF_Agency_Exchange_Rate__c= CurrencyMap.get(Matccode);
                            }
                            if(agencyEst.AF_ReadyforPOExchangeRateTemp__c==null){
                                agencyEst.AF_ReadyforPOExchangeRateTemp__c = CurrencyMap.get(Matccode);
                            }
                            if(agencyEst.AF_Ready_For_PO_Exchange_Rate__c!= null && agencyEst.AF_Ready_For_PO_Exchange_Rate__c!= 0 && agencyEst.AF_OOPS_Estimate_Local__c!= null  && agencyEst.AF_Agency_Exchange_Rate__c!=null)
                            {
                                agencyEst.AF_OOPS_Estimate_Local__c= (agencyEst.AF_Estimate__c*agencyEst.AF_Agency_Exchange_Rate__c)/agencyEst.AF_Ready_For_PO_Exchange_Rate__c;
                            }
                        }
                        else 
                        {
                            agencyEst.AF_Ready_For_PO_Exchange_Rate__c=null; 
                            agencyEst.AF_Agency_Exchange_Rate__c= CurrencyMap.get(Matccode);
                            agencyEst.AF_Agency_ExchangeRateTemp__c= CurrencyMap.get(Matccode);
                            if(agencyEst.AF_Agency_Exchange_Rate__c != null && agencyEst.AF_Agency_Exchange_Rate__c!= 0 && agencyEst.AF_Estimate__c!= null)
                            agencyEst.AF_OOPS_Estimate_Local__c= agencyEst.AF_Estimate__c*agencyEst.AF_Agency_Exchange_Rate__c;
                        }  
    }
}