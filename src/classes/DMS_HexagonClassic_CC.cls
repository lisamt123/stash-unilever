/**********************************************************************
Name: DMS_HexagonClassic_CC
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used to constructor of visual force DMS_Hexagono
====================================================== 
======================================================
History 

VERSION 	AUTHOR		 		DATE  		Description
1.0		DIMITRI M. SANTANA	 25/05/2016		INITIAL DEVELOPMENT

***********************************************************************/
public class DMS_HexagonClassic_CC 
{        
    private List<DMS_WaveHexagonRestCall.Records> recordsList;
    private Map<String,String> distributorsMap = new Map<String,String>();
    
    public List<SelectOption> datePicklistOption{get; set;}
    public List<SelectOption> distributorOption{get;set;}
    public List<SelectOption> salesChannelOption{get;set;}    
    public String selectedDistributor {get;set;} 
    public String selectedDate {get;set;} 
    public String selectedSalesChannel {get;set;} 
    public MAP<String,Map<String,IndicatorType>> hexagonMap {get;set;}
    public Map<String,List<Decimal>> actualValuesGraphicMap {get;set;}
    public Map<String,List<Decimal>> previousValuesGraphicMap {get;set;}
    public List<String>label {get;set;}  	    
    
    
    /*******************************************************************
    * Purpose: contructor  
    ********************************************************************/
    public DMS_HexagonClassic_CC()
    { 
        try{
            fillLabel();
            defineMeta();           
            optionDistributor();
            optionDate();
            optionSalesChannel(); 
        }catch(Exception e){            
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_FILL_LABEL + e.getCause() + e.getMessage() + e.getLineNumber());            
        }
    }
    
    private void fillLabel()
    {
        label = new List<String>();
        label.add(DMS_GlobalConstants.HEXAGON_LABEL_CLIENTES);
        label.add(DMS_GlobalConstants.HEXAGON_LABEL_DEVOLUCIONES);
        label.add(DMS_GlobalConstants.HEXAGON_LABEL_DROPSIZE);
        label.add(DMS_GlobalConstants.HEXAGON_LABEL_FRECUENCIA);
        label.add(DMS_GlobalConstants.HEXAGON_LABEL_PEDIDOS);
        label.add(DMS_GlobalConstants.HEXAGON_LABEL_SELLOUT);        
    }
    
    private void defineMeta() 
    {
        try
        {
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge');
        }
        catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_DEFINE_META + e.getCause() + e.getMessage() + e.getLineNumber());            
        }
    }
    
    /*******************************************************************
    * Purpose: submit Request for wave (DMS_WaveHexagonRestCall)  
    ********************************************************************/
    public void submitRequest()
    {
        defineMeta();
        try
        {        
            DMS_WaveHexagonRestCall hexagono = new DMS_WaveHexagonRestCall();
            recordsList = hexagono.getRecords('0Fb19000000A3yOCAS',selectedDistributor,selectedDate,selectedSalesChannel); 
        }
        catch(Exception e){
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON_SUBMIT + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        generateHexagon();
    }
    
    /*******************************************************************
    * Purpose: Create pickList of Distributor for filter
    ********************************************************************/
    private void optionDistributor()
    {        
        distributorOption = new List<SelectOption>();
        try
        {
            List<Account> distributorList = selectDistributor();        
            distributorOption.add(new SelectOption('','--'));        
            if(distributorList !=null){
                for(Account distributor : distributorList){
                    distributorOption.add(new SelectOption(distributor.ExternalCode__c ,distributor.name));                
                }
            }
        }
        catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_OPTION_DISTRIBUTOR + e.getCause() + e.getMessage() + e.getLineNumber());
        }        
    }
    
    /*******************************************************************
    * Purpose: Create pickList of Date for filter
    ********************************************************************/
    private void optionDate()
    {
        datePicklistOption = new List<SelectOption>();
        List<Target__c> target;
        Date firstDate;
        try
        {
            target = selectDateTarget();
            if(target != null && !target.isEmpty())
            {
                datePicklistOption.add(new SelectOption('','--'));
                firstDate = target[0].TargetDate__c;
                
                while(firstDate.addMonths(1).addDays(-1) < Date.today())
                {                
                    datePicklistOption.add(new SelectOption(String.valueOf(firstDate),firstDate.format() + ' - ' + firstDate.addMonths(1).addDays(-1).format()));
                    firstDate = firstDate.addMonths(1);               
                }
                if(firstDate.addMonths(1).addDays(-1) > Date.today())
                {
                    datePicklistOption.add(new SelectOption( String.valueOf(firstDate),firstDate.format() + ' - ' + Date.today().format()));                
                }                                                                    
            }
        }
        catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_OPTION_DATE + e.getCause() + e.getMessage() + e.getLineNumber());
        }
    }    
    
    /*******************************************************************
    * Purpose: Create picklist of Sales Channel for filter
    ********************************************************************/
    private void optionSalesChannel()
    {        
        salesChannelOption = new List<SelectOption>();
        List<AggregateResult> aggSalesChannel = selectSalesChannel();
        salesChannelOption.add(new SelectOption('','--'));
        
        if(aggSalesChannel != null)
        {
            for(AggregateResult agg : aggSalesChannel)
            {
                salesChannelOption.add(new SelectOption(String.valueOf(agg.get('salesChannel')),String.valueOf(agg.get('salesChannel'))));                
            }
        }        
    }    
    
    /*******************************************************************
    * Purpose: Select all distributors Account in salesforce   
    * Returns: List<Accoun> 
    ********************************************************************/
    private  List<Account> selectDistributor()
    {
        List<Account> distributorList;
        distributorList = new List<Account>();
        
        try
        {
            for(Account distributor :[SELECT id,name,ExternalCode__c FROM Account where recordTypeId =: RecordTypeMemory.getRecType('Account', 'Distributor')])
            {
                distributorList.add(distributor);
            }            
        }
        catch(QueryException e)
        {
            distributorList = null;
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_OPTION_DISTRIBUTOR + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        
        return distributorList;        
    }
    
    /*******************************************************************
    * Purpose: Select All Sales Channel   
    * Returns: List<AggregateResult> 
    ********************************************************************/
    private List<AggregateResult> selectSalesChannel()
    {
        
        List<AggregateResult> aggSalesChannel; 
        aggSalesChannel = new List<AggregateResult>();
        try
        {
            for(AggregateResult agg : [SELECT SalesChannel__c salesChannel FROM Account where recordTypeId =: RecordTypeMemory.getRecType('Account', 'InDirect_Customer') GROUP BY SalesChannel__c])
            {
                aggSalesChannel.add(agg);                
            }           
        }
        catch(QueryException e)
        {
            aggSalesChannel = null;
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_QUERY_SALES_CHANNEL + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        return aggSalesChannel;        
    }
    
    /*******************************************************************
    * Purpose: Get a list of Records containing the Account Owner and DistributorCode through Dataset Id
    * Parameters: Dataset Id 1, Dataset Id 2
    * Returns: List<Records> 
    ********************************************************************/
    private List<Target__c> selectDateTarget()
    {
        List<Target__c> target;        
        try
        {             
            target = [SELECT id,name,TargetDate__c FROM Target__c Where TargetDate__c != null Order by TargetDate__c LIMIT 1];
        }
        catch(QueryException e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_QUERY_TARGET_DATE + e.getCause() + e.getMessage() + e.getLineNumber());
        }       
        return target;
    }    
    
    /*******************************************************************
	* Purpose: mapping data for hexagon
	********************************************************************/
    private void generateHexagon()
    {
        hexagonMap = new MAP<String,Map<String,IndicatorType>>();
        Map<String,Map<String,IndicatorType>> indicatorTypeCategoryMap = new Map<String,Map<String,IndicatorType>>();
        Map<String,IndicatorType> indicatorTypeValuesMap = new Map<String,IndicatorType>();
        List<IndicatorType> indicatorTypesValuesList = new List<IndicatorType>();
        IndicatorType indicatorTypeValues;
        try
        {
            for(DMS_WaveHexagonRestCall.Records record : recordsList)
            {
                if(!record.Indicator_Type.equalsIgnoreCase('DEVOLUCIONES ($)'))
                {
                    indicatorTypeValues = new IndicatorType();
                    indicatorTypeValuesMap = new Map<String,IndicatorType>();
                    indicatorTypeCategoryMap = new Map<String,Map<String,IndicatorType>>();                
                    indicatorTypeValues.actual = Decimal.valueOf(record.Actual);
                    indicatorTypeValues.previous = Decimal.valueOf(record.Previous);
                    indicatorTypeValues.target = Decimal.valueOf(record.target);
                    indicatorTypeValues.performance = Decimal.valueOf(record.Performance);
                    indicatorTypeValues.variation = Decimal.valueOf(record.Variation);
                    indicatorTypeValues.targetPrevious = Decimal.valueOf(record.Target_Previous);
                    
                    if(record.Indicator_Type.equalsIgnoreCase('DEVOLUCIONES (%)'))
                    {
                        if(indicatorTypeValues.previous > 0)
                        {
                            indicatorTypeValues.preformancePrevious = 100 - indicatorTypeValues.previous;
                        } 
                        else
                        {
                            indicatorTypeValues.preformancePrevious =0;
                        }    
                    }
                    else if(indicatorTypeValues.targetPrevious > 0)
                    {
                        indicatorTypeValues.preformancePrevious = (indicatorTypeValues.previous/indicatorTypeValues.targetPrevious)*100;
                    }
                    else
                    {
                        indicatorTypeValues.preformancePrevious =0;
                    }                
                    if(hexagonMap.containsKey(record.SalesRep))
                    {
                        if(!hexagonMap.get(record.SalesRep).containsKey(record.Indicator_Type))
                        {
                            hexagonMap.get(record.SalesRep).put(record.Indicator_Type,indicatorTypeValues);
                        }
                    }
                    else
                    {
                        indicatorTypeValuesMap.put(record.Indicator_Type, indicatorTypeValues);
                        hexagonMap.put(record.SalesRep,indicatorTypeValuesMap); 
                    }  
                }   
            }  
        }
        catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON + e.getCause() + e.getMessage() + e.getLineNumber());
        }            
        System.debug(DMS_GlobalConstants.HEXAGON_VALUES + Json.serialize(hexagonMap));
        dataForGraphic();
    }
    /*******************************************************************
	* Purpose: mapping data for graphic of hexagon
	********************************************************************/
    private void dataForGraphic()
    {
        Decimal previousPerformance;   
        Decimal actualPerformance; 
        actualValuesGraphicMap = new Map<String,List<Decimal>>();
        previousValuesGraphicMap = new Map<String,List<Decimal>>();
        List<Decimal> actualValuesList;
        List<Decimal> previousValuesList;
        try
        {
            if(!hexagonMap.isEmpty())
            {
                for(String seller : hexagonMap.keySet())
                {
                    actualValuesList = new  List<Decimal>();
                    previousValuesList = new  List<Decimal>();
                    actualValuesGraphicMap.put(seller, actualValuesList);
                    previousValuesGraphicMap.put(seller, previousValuesList);            
                    
                    for(String indicatorType : label)
                    {
                        actualPerformance=100;
                        previousPerformance = 100;
                        indicatorType = indicatorType.replace('"','');
                        IndicatorType values = hexagonMap.get(seller).get(indicatorType);                                        
                        
                        if(values.performance < 100){
                            actualPerformance = values.performance;
                        }
                        if(values.preformancePrevious < 100){
                            previousPerformance = values.preformancePrevious;
                        }
                        actualValuesGraphicMap.get(seller).add(actualPerformance);
                        previousValuesGraphicMap.get(seller).add(previousPerformance);                    
                    }                
                }
            }
        }catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON_GRAPHIC + e.getCause() + e.getMessage() + e.getLineNumber());
        }       
    }
    
    /*******************************************************************
	* Purpose: Inner Class for values of hexagon
	********************************************************************/
    public Class IndicatorType
    {
        public Decimal actual {get;set;}
        public Decimal previous {get;set;}
        public Decimal target{get;set;}
        public Decimal performance {get;set;}
        public Decimal variation {get;set;}
        public Decimal targetPrevious {get;set;}
        public Decimal preformancePrevious {get;set;}
    }
}