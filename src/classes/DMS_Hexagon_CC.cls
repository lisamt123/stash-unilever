/**********************************************************************
Name: DMS_Hexagon_CC
Copyright © 2016 Salesforce

Purpose: 
Class used to constructor of visual force DMS_Hexagono

History 

VERSION 	AUTHOR		 		DATE  		Description
1.0		DIMITRI M. SANTANA	 25/05/2016		INITIAL DEVELOPMENT

***********************************************************************/
public with sharing class DMS_Hexagon_CC 
{        
    private List<DMS_WaveHexagon.Records> recordsList;
    public List<SelectOption> distributorCountry{get;set;}
    public List<SelectOption> salesChannelOption{get;set;}     
    public String selectedDistributor {get;set;} 
    public String selectedDistributorCountry {get;set;} 
    public String selectedDate {get;set;} 
    public String selectedSeller {get;set;} 
    public String selectedSalesChannel {get;set;} 
    public Map<String,DMS_WaveHexagon.Records> hexagonMap {get;set;}
    public Map<String,List<Decimal>> actualValuesGraphicMap {get;set;}
    public Map<String,List<Decimal>> previousValuesGraphicMap {get;set;}
    public static List<String>label {get;set;}      
    private List<Account> distributorList;
    private Map<String,id> contactCodeIdMap = new Map<String,id>();
    
    static{
        label = new List<String>();
        label.add('"'+System.Label.DMS_HEXAGON_IMPACTED_STORES +'"');
        label.add('"'+System.Label.DMS_HEXAGON_DEVOLUTION+'"');
        label.add('"'+System.Label.DMS_HEXAGON_DROPSIZE+'"');
        label.add('"'+System.Label.DMS_HEXAGON_FREQUENCY+'"');
        label.add('"'+System.Label.DMS_HEXAGON_ORDERS+'"');
        label.add('"'+System.Label.DMS_HEXAGON_SELLOUT+'"');
    }
    
    /*******************************************************************
* Purpose: contructor  
********************************************************************/
    public DMS_Hexagon_CC()
    {        
        selectedSeller = 'Todos';
        defineMeta();                      
        optionDistributorCountry();                     
        optionSalesChannel();        
    }
    
    private void defineMeta() 
    {
        try
        {
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge');
        }
        catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON + e.getCause() + e.getMessage() + e.getLineNumber());            
        }
    }
    
    /*******************************************************************
* Purpose: submit Request for wave (DMS_WaveHexagon)  
********************************************************************/
    public void submitRequest()
    {
        defineMeta();
        try
        {              
            DMS_WaveHexagon hexagono = new DMS_WaveHexagon();
            recordsList = hexagono.getRecords('0Fb19000000A45oCAC',selecteddistributorCountry,selectedDistributor,selectedDate,selectedSalesChannel); 
        }
        catch(Exception e){
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        generateHexagon();
    }
    
    /*******************************************************************
* Purpose: Create pickList of Distributor for filter
********************************************************************/
    public List<SelectOption> getOptionDistributor()
    {        
        List<SelectOption> distributorOption = new List<SelectOption>();
        try
        {                        
            distributorOption.add(new SelectOption('','--'));
            if(distributorList !=null){
                for(Account distributor : distributorList){
                    if(selectedDistributorCountry != null && selectedDistributorCountry.equals(distributor.Country__c)){
                        distributorOption.add(new SelectOption(distributor.ExternalCode__c ,distributor.name));                
                    }
                }
            }
        }
        catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON + e.getCause() + e.getMessage() + e.getLineNumber());
        }  
        return distributorOption;
    }
    
    /*******************************************************************
* Purpose: Create pickList of Distributor country for filter
********************************************************************/
    private void optionDistributorCountry()
    {    
        List<Account> distributorCountryList;
        distributorCountry = new List<SelectOption>();
        
        distributorList = new List<Account>();
        try
        {           
            for(Account distributor :[SELECT id,name,ExternalCode__c,country__c FROM Account where recordTypeId =: DMS_RecordTypeMemory.getRecType('Account', 'Distributor')])
            {
                distributorList.add(distributor);
            }                  
            distributorCountry.add(new SelectOption('','--'));        
            if(distributorList !=null){
                distributorCountryList = distributorList.clone();
                checkDuplicated(distributorCountryList,'country__c');
                for(Account distributor : distributorCountryList){                    
                    distributorCountry.add(new SelectOption(distributor.country__c ,distributor.country__c));                        
                }
            }
        }
        catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON + e.getCause() + e.getMessage() + e.getLineNumber());
        }        
    }        
    
    /*******************************************************************
* Purpose: Create pickList of Date for filter
********************************************************************/
    public List<SelectOption> getOptionDate()
    {
        List<SelectOption> datePicklistOption = new List<SelectOption>();
        List<Target__c> targetList = new List<Target__c>();
        
        try
        {            
            for(Target__c target : [SELECT id,name,TargetDate__c, SalesRep__r.SellerCode__c FROM Target__c Where TargetDate__c != null and SalesRep__c != null Order by TargetDate__c])
            {
                targetList.add(target);
            }                    
            if(targetList != null && !targetList.isEmpty())
            {
                datePicklistOption.add(new SelectOption('','--'));
                checkDuplicated(targetList,'TargetDate__c');
                for( Target__c t: targetList){                    
                    if(selectedSeller != null && (selectedSeller.equals(t.SalesRep__r.SellerCode__c) || selectedSeller.equals('Todos'))){
                        
                        datePicklistOption.add(new SelectOption(String.valueOf(t.TargetDate__c),t.TargetDate__c.Month() + '-' + t.TargetDate__c.Year()));
                        
                    }
                }                                                                                   
            }            
        }
        catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        return datePicklistOption;
    }    
    public void checkDuplicated(List<SObject> optionList,String field){        
        boolean check = false;
        try{
            for(Integer x=0; x<optionList.size(); x++){
                for(Integer y=x+1; y<optionList.size(); y++){               
                    if(String.valueOf(optionList.get(x).get(field)).equals(String.valueOf(optionList.get(y).get(field)))){
                        optionList.remove(y); 
                        y--;
                    }
                }
            }
        } catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON + e.getCause() + e.getMessage() + e.getLineNumber());
        }         
    }
    /*******************************************************************
* Purpose: Create picklist of Sales Channel for filter
********************************************************************/
    private void optionSalesChannel()
    {        
        salesChannelOption = new List<SelectOption>();
        List<AggregateResult> aggSalesChannel =new List<AggregateResult>();
        try{
            for(AggregateResult agg : [SELECT SalesChannel__c salesChannel FROM Account where recordTypeId =: DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer') GROUP BY SalesChannel__c])
            {
                aggSalesChannel.add(agg);                
            }                     
            salesChannelOption.add(new SelectOption('','--'));            
            if(aggSalesChannel != null)
            {
                for(AggregateResult agg : aggSalesChannel)
                {
                    salesChannelOption.add(new SelectOption(String.valueOf(agg.get('salesChannel')),String.valueOf(agg.get('salesChannel'))));                
                }
            }
        } catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON + e.getCause() + e.getMessage() + e.getLineNumber());
        }                 
    }    
    
    /*******************************************************************
* Purpose: Create picklist of Sales Channel for filter
********************************************************************/
    public List<SelectOption> getOptionSeller()
    {     
        List<Contact> sellerList = new List<Contact>();        
        List<SelectOption> sellerOption = new List<SelectOption>();       
        
        sellerOption.add(new SelectOption('Todos','Todos'));
        try{
            if(selectedDistributor != null && !String.isBlank(selectedDistributor)){
                for(Contact cont : [SELECT id,name,SellerCode__c,Account.ExternalCode__c FROM Contact Where SellerCode__c !=null AND AccountiD != null]){
                    sellerList.add(cont);
                    contactCodeIdMap.put(cont.SellerCode__c, cont.id);
                }
            }
            for(Contact seller : sellerList)
            {                           
                if(selectedDistributor.equals(seller.Account.ExternalCode__c)){
                    sellerOption.add(new SelectOption(seller.SellerCode__c,seller.name)); 
                }
            }  
        }catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON + e.getCause() + e.getMessage() + e.getLineNumber());
        }         
        return sellerOption;
    }    
    
    /*******************************************************************
* Purpose: mapping data for hexagon
********************************************************************/
    private void generateHexagon()
    {
        hexagonMap = new Map<String,DMS_WaveHexagon.Records>();        
        try
        {
            for(DMS_WaveHexagon.Records record : recordsList)
            {
                hexagonMap.put(record.cdSalesRep,record);                
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
                    
                    actualValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforImpactedStoreAc);                                                                                                                                                                                                                                                                                                                                    
                    actualValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforDevolutionAc);
                    actualValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforDropsizeAc);
                    actualValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforFrequencyAc);
                    actualValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforOrdersAc);
                    actualValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforSelloutAc);                    
                    
                    previousValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforImpactedStorePrev);
                    previousValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforDevolutionPrev);
                    previousValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforDropsizePrev);                             
                    previousValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforFrequencyPrev);
                    previousValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforOrdersPrev);  
                    previousValuesGraphicMap.get(seller).add(hexagonMap.get(seller).perforSelloutPrev);                     					                                        
                }
            }
        }catch(Exception e)
        {
            System.debug(DMS_GlobalConstants.MSG_EXCEPTION_HEXAGON + e.getCause() + e.getMessage() + e.getLineNumber());
        }           
    }      
}