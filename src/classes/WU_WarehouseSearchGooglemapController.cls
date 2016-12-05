/*************************************************************
*@Author :          Cognizant
*@Date :            November 2016
*@Description :     controller class for VF Page WarehouseGoogleMaps
*************************************************************/
public with sharing class WU_WarehouseSearchGooglemapController {    

    public string emailLoggedUser1;
    public String loggedInUser;
    
    private Integer PAGESIZE= 30;
    public WU_Master_Warehouse__c warehouseCapacity {get;set;}
    public WU_Master_Warehouse__c warehouseCapacityLookuP {get;set;}
    public string sSAP {get;set;}
    public string sRegion {get;set;}
    public string sCategory{get;set;}
    public string sMCO{get;set;}
    public string sCountry{get;set;}
    public string sCity{get;set;}
    public string sBuildingContractType {get;set;}
    public Integer listsize{get;set;}
    // the soql without the order and limit
    private String soql {get;set;}
    PageReference currentPage;
    public ApexPages.StandardSetController lstWarehouses {get;set;}
   
    public List<WU_Master_Warehouse__c> AllSearchRecords  
    {  
        get  
        {  
            if(lstWarehouses!=null)  
                return (List<WU_Master_Warehouse__c>)lstWarehouses.getRecords();  
            else  
                return null ;  
        }  
        set;
    } 
        
   public void getWarehouseList(){
       soql='SELECT Id,Name,Owner.Name,WU_Procurement_Manager__r.Name,WU_Average_Current_Utilization__c,WU_Average_Pallet_Utilization_Week__c,WU_Average_Pallet_Utilization_Month__c,WU_Total_Current_Month_Utilisation__c,WU_AverageUtilization__c,WU_CityName__c,WU_Committed_Max_PalletStorage__c,'+
            'WU_Country__c,WU_Average_Pallet_Utilization_Count__c,WU_Current_Utilization__c,WU_FromDate__c,WU_MCO__c,WU_Network__c,WU_Prior_CommittedPalletStorage__c,'+
            'WU_Region__c,WU_SAPCode_s__c,WU_SAPName_s__c,WU_ToDate__c,WU_Total_Utilization__c,WU_WarehousePOC_Email__c,'+
            'WU_Warehouse_Capacity__c,WU_Building_ContractType__c FROM WU_Master_Warehouse__c where name!=null LIMIT 10000';
 
        try{
            lstWarehouses = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
            lstWarehouses.setPageSize(PAGESIZE);
            system.debug('@@@lstWarehouses--->'+lstWarehouses);
        }
        catch (exception ex){
            system.debug('@@@Catch Err--->'+ex.getMessage());
        }   
        /*if(wcFilterId != null)
        {
          lstWarehouses.setFilterId(wcFilterId );
        }*/
   }   
   
   public WU_WarehouseSearchGooglemapController(ApexPages.StandardController stdController) {
        warehouseCapacity =(WU_Master_Warehouse__c) stdController.getRecord(); 
        warehouseCapacity = new WU_Master_Warehouse__c () ;  
        warehouseCapacityLookup = new WU_Master_Warehouse__c () ;
        getWarehouseList();
        AllSearchRecords=(List<WU_Master_Warehouse__c>)lstWarehouses.getRecords();  
        listSize = AllSearchRecords.size();      
    }
  
    public pagereference SearchRecords(){
        //String reg= Apexpages.currentPage().getParameters().get('region');
        
         soql='SELECT Id,Name,Owner.Name,WU_Procurement_Manager__r.Name,WU_Average_Current_Utilization__c,WU_Average_Pallet_Utilization_Week__c,WU_Average_Pallet_Utilization_Month__c,WU_Total_Current_Month_Utilisation__c,WU_AverageUtilization__c,WU_CityName__c,WU_Committed_Max_PalletStorage__c,'+
            'WU_Country__c,WU_Average_Pallet_Utilization_Count__c,WU_Current_Utilization__c,WU_FromDate__c,WU_MCO__c,WU_Network__c,WU_Prior_CommittedPalletStorage__c,'+
            'WU_Region__c,WU_SAPCode_s__c,WU_SAPName_s__c,WU_ToDate__c,WU_Total_Utilization__c,WU_WarehousePOC_Email__c,'+
            'WU_Warehouse_Capacity__c,WU_Building_ContractType__c FROM WU_Master_Warehouse__c where name!=null';
        if(warehouseCapacity!=null){
            sRegion=warehouseCapacity.WU_Region__c;
            sCategory=warehouseCapacity.WU_Network__c;
            sMCO=warehouseCapacity.WU_MCO__c;
            sCountry=warehouseCapacity.WU_Country__c;
            sCity=warehouseCapacity.WU_CityName__c;
            sSAP=warehouseCapacity.WU_SAPCode_s__c;
            sBuildingContractType=warehouseCapacity.WU_Building_ContractType__c ;
          }
        system.debug('@@@warehouseCapacity --->'+warehouseCapacity + '-' + sSAP+ '-' + sRegion+ '-' + sMCO +'-'+ sCategory+'-' + sCountry+ '-' + sCity );
       
        if(!String.isEmpty(sSAP)){
            soql += ' and WU_SAPCode_s__c= '+' :sSAP';
        }
                
        if(!String.isEmpty(sRegion)){
            soql += ' and WU_Region__c = '+':sRegion';
        }
                
        if(!String.isEmpty(sMCO)){
            soql += ' and WU_MCO__c= '+':sMCO'; 
        }
                
        if(!String.isEmpty(sCategory)){
            soql += ' and WU_Network__c='+': sCategory';
        }
        
         if(!String.isEmpty(sBuildingContractType)){
            soql += ' and WU_Building_ContractType__c='+':sBuildingContractType';
        }
        
        if(!String.isEmpty(sCountry)){
            soql += ' and WU_Country__c='+':sCountry'; 
        }
                
        if(!String.isEmpty(sCity)){
            soql += ' and WU_CityName__c='+':sCity';
        }
        
       
                
        system.debug('@@@soql --->'+soql );
 
        try{
            lstWarehouses = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
            AllSearchRecords=(List<WU_Master_Warehouse__c>)lstWarehouses.getRecords();
            listSize = AllSearchRecords.size();
                  system.debug('@@@lstWarehouses--->'+lstWarehouses);
        }
        catch (exception ex){
            system.debug('@@@Catch Err--->'+ex.getMessage());
        }   
        lstWarehouses.setPageSize(PAGESIZE);
        return null;
    }
    
    
    
}