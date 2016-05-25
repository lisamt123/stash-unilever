/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     controller class for VF Page WU WarehouseSearch
*************************************************************/
public class WU_WarehouseSearchController {

     
    private Integer PAGESIZE= 30;
    public WU_Master_Warehouse__c warehouseCapacity {get;set;}
    public WU_Master_Warehouse__c warehouseCapacityLookuP {get;set;}
    public string sSAP {get;set;}
    public string sRegion {get;set;}
    public string sCategory{get;set;}
    public string sMCO{get;set;}
    public string sCountry{get;set;}
    public string sCity{get;set;}
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
            'WU_Warehouse_Capacity__c FROM WU_Master_Warehouse__c where name!=null LIMIT 10000';
 
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
   
   public WU_WarehouseSearchController(ApexPages.StandardController stdController) {
        warehouseCapacity =(WU_Master_Warehouse__c) stdController.getRecord(); 
        warehouseCapacity = new WU_Master_Warehouse__c () ;  
        warehouseCapacityLookup = new WU_Master_Warehouse__c () ;
        getWarehouseList();
        AllSearchRecords=(List<WU_Master_Warehouse__c>)lstWarehouses.getRecords();
    }
  
    public pagereference SearchRecords(){
        //String reg= Apexpages.currentPage().getParameters().get('region');
        
         soql='SELECT Id,Name,Owner.Name,WU_Procurement_Manager__r.Name,WU_Average_Current_Utilization__c,WU_Average_Pallet_Utilization_Week__c,WU_Average_Pallet_Utilization_Month__c,WU_Total_Current_Month_Utilisation__c,WU_AverageUtilization__c,WU_CityName__c,WU_Committed_Max_PalletStorage__c,'+
            'WU_Country__c,WU_Average_Pallet_Utilization_Count__c,WU_Current_Utilization__c,WU_FromDate__c,WU_MCO__c,WU_Network__c,WU_Prior_CommittedPalletStorage__c,'+
            'WU_Region__c,WU_SAPCode_s__c,WU_SAPName_s__c,WU_ToDate__c,WU_Total_Utilization__c,WU_WarehousePOC_Email__c,'+
            'WU_Warehouse_Capacity__c FROM WU_Master_Warehouse__c where name!=null';
        if(warehouseCapacity!=null){
            sRegion=warehouseCapacity.WU_Region__c;
            sCategory=warehouseCapacity.WU_Network__c;
            sMCO=warehouseCapacity.WU_MCO__c;
            sCountry=warehouseCapacity.WU_Country__c;
            sCity=warehouseCapacity.WU_CityName__c;
            sSAP=warehouseCapacity.WU_SAPCode_s__c;
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
        
        if(!String.isEmpty(sCountry)){
            soql += ' and WU_Country__c='+':sCountry'; 
        }
                
        if(!String.isEmpty(sCity)){
            soql += ' and WU_CityName__c='+':sCity';
        }
                
        system.debug('@@@soql --->'+soql );
 
        try{
            lstWarehouses = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
            system.debug('@@@lstWarehouses--->'+lstWarehouses);
        }
        catch (exception ex){
            system.debug('@@@Catch Err--->'+ex.getMessage());
        }   
        lstWarehouses.setPageSize(PAGESIZE);
        return null;
    }
    //Method created for Search based on Lookup Values.
    /*
    public pagereference SearchRecordsWithLookupVal(){
                
         soql='SELECT Id,Name,Owner.Name,WU_Procurement_Manager__r.Name,WU_Average_Current_Utilization__c,WU_Average_Pallet_Utilization_Week__c,WU_Average_Pallet_Utilization_Month__c,WU_Total_Current_Month_Utilisation__c,WU_AverageUtilization__c,WU_CityName__c,WU_Committed_Max_PalletStorage__c,'+
            'WU_Country__c,WU_Current_Utilization__c,WU_FromDate__c,WU_MCO__c,WU_Network__c,WU_Prior_CommittedPalletStorage__c,'+
            'WU_Region__c,WU_SAPCode_s__c,WU_SAPName_s__c,WU_ToDate__c,WU_Total_Utilization__c,WU_WarehousePOC_Email__c,'+
            'WU_Warehouse_Capacity__c FROM WU_Master_Warehouse__c where name!=null';
        if(warehouseCapacity!=null){
            sRegion = warehouseCapacityLookup.Master_Region__c;
            sCategory = warehouseCapacityLookup.WU_Network__c;
            sMCO = warehouseCapacityLookup.Master_MCO__c;
            sCountry = warehouseCapacityLookup.Master_Country__c;
            sCity = warehouseCapacityLookup.Master_city__c;
            sSAP = warehouseCapacityLookup.WU_SAPCode_s__c;
          }
        
        system.debug('@@@warehouseCapacityLookup --->'+warehouseCapacityLookup + '-' + sSAP+ '-' + sRegion+ '-' + sMCO +'-'+ sCategory+'-' + sCountry+ '-' + sCity );
       
        if(!String.isEmpty(sSAP)){
            soql += ' and WU_SAPCode_s__c= '+' :sSAP';
        }
                
        if(!String.isEmpty(sRegion)){
            soql += ' and Master_Region__c = '+':sRegion ';
        }
                
        if(!String.isEmpty(sMCO)){
            soql += ' and Master_MCO__c = '+':sMCO';  
        }
                
        if(!String.isEmpty(sCategory)){
            soql += ' and WU_Network__c='+': sCategory';
        }
        
        if(!String.isEmpty(sCountry)){
            soql += ' and Master_Country__c ='+':sCountry';
        }
       
        if(!String.isEmpty(sCity)){
            soql += ' and Master_city__c ='+':sCity';
        }
                
        system.debug('@@@soql --->'+soql );
 
        try{
            lstWarehouses = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
            system.debug('@@@lstWarehouses--->'+lstWarehouses);
        }
        catch (exception ex){
            system.debug('@@@Catch Err--->'+ex.getMessage());
        }   
        lstWarehouses.setPageSize(PAGESIZE);
        return null;
    }
    */
    
    //Get all available list view for Warehouse
    public SelectOption[] getExistingViews(){
        return lstWarehouses.getListViewOptions();
    }

   
    //Boolean to check if there are more records after the present displaying records  
    public Boolean hasNext  
    {  
        get  
        {  
            return lstWarehouses.getHasNext();  
        }  
        set;  
    }  
   
    //Boolean to check if there are more records before the present displaying records  
    public Boolean hasPrevious  
    {  
        get  
        {  
            return lstWarehouses.getHasPrevious();  
        }  
        set;  
    }  
   
    //Page number of the current displaying records  
    public Integer pageNumber  
    {  
        get  
        {  
            return lstWarehouses.getPageNumber();  
        }  
        set;  
    }  
  
    //Returns the previous page of records  
    public void previous()  
    {  
        lstWarehouses.previous();  
    }  
   
    //Returns the next page of records  
    public void next()  
    {  
        lstWarehouses.next();  
    }  
    
    public pagereference redirectToReport(){
        pagereference pagr = new pagereference('/'+Label.WU_Report_Id);
        
        if(warehouseCapacity.WU_SAPCode_s__c != NUll){
            pagr.getParameters().put('pc0',Label.WU_Report_SAP_Code);
            pagr.getParameters().put('pn0','eq');
            pagr.getParameters().put('pv0',warehouseCapacity.WU_SAPCode_s__c );
        }
        
        if(warehouseCapacity.WU_Region__c != NUll){
            pagr.getParameters().put('pc1',Label.WU_Report_Region);
            pagr.getParameters().put('pn1','eq');
            pagr.getParameters().put('pv1',warehouseCapacity.WU_Region__c);
        }
        
        if(warehouseCapacity.WU_MCO__c != NUll){
            pagr.getParameters().put('pc2',Label.WU_Report_MCO );
            pagr.getParameters().put('pn2','eq');
            pagr.getParameters().put('pv2',warehouseCapacity.WU_MCO__c);
        }
        
        if(warehouseCapacity.WU_Network__c != NUll){
            pagr.getParameters().put('pc3',Label.WU_Report_Network );
            pagr.getParameters().put('pn3','eq');
            pagr.getParameters().put('pv3',warehouseCapacity.WU_Network__c);
        }
        
        if(warehouseCapacity.WU_Country__c != NUll){
            pagr.getParameters().put('pc4',Label.WU_Report_Country );
            pagr.getParameters().put('pn4','eq');
            pagr.getParameters().put('pv4',warehouseCapacity.WU_Country__c);
        }
        
        if(warehouseCapacity.WU_CityName__c != NUll){
            pagr.getParameters().put('pc5',Label.WU_Report_City);
            pagr.getParameters().put('pn5','eq');
            pagr.getParameters().put('pv5',warehouseCapacity.WU_CityName__c);
        }
        
        return pagr;
    }
}