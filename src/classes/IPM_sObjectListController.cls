/****************************************************************************************************************************
	@Author Cognizant
	@name IPM_ProjectHelper
	@CreateDate 07/02/2017
	@Description 	Generic Component used to handle access related security in Standard Salesforce. 
					Makes use of Custom Permissions to identify Listing Actions.
	@Version 1.0
*/ 
public with sharing class IPM_sObjectListController {
    
    /*Standard Set Controller used for Handling Pagination */
    public ApexPages.StandardSetController standardSetCtrl{get;set;}
    
    /* Field set used for displaying Columns for Listing */
    public String associatedFieldSet {get;set;}
    public List<Schema.FieldSetMember> fieldSetMemList {get;set;}
    public sObject sobj {get;set;}
    
    /* Handles Sorting specific details*/
    public String sortOrder {get;set;}
    public String previousSortColumn {get;set;}
    public String sortColumn {get;set;} 
    
    public Integer noOfRecords {get;set;}
    
    /* Action Names which need to be verified against user permissions */
    public List<String> inlineActionList {get;set;} 
    public String viewActionPermission {get;set;}  
    public String newActionPermission {get;set;}
    public String listActionPermission {get;set;}
    public String fullPermission {get;set;}
    public Map<String,String> objectActionsToPermissions{get;set;} 
    
    public String selectedSObject{get;set;}
    public String searchFieldAPI{get;set;}

    public String unAuthorizedAccessMessage{get;set;}
	
	public static Integer PAGE_SIZE = 10;
	/* Initialize Neccessary Attributes*/
    public IPM_sObjectListController()
    {
        inlineActionList = new List<String>();
        selectedSObject = searchFieldAPI = IPM_ConstantUtils.BLANK;
        objectActionsToPermissions = new Map<String,String>();
        unAuthorizedAccessMessage = Label.IPM_UNAUTHORIZED; 
    }
    
    public void getInitialize()
    {
        String sObjectPrefix = selectedSObject.remove(IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX);    
        inlineActionList = new List<String>{IPM_ConstantUtils.EDIT_ACCESS,IPM_ConstantUtils.DELETE_ACCESS}; 

        viewActionPermission = sObjectPrefix+IPM_ConstantUtils.VIEW_ACCESS; 
        newActionPermission = sObjectPrefix+IPM_ConstantUtils.NEW_ACCESS;
        listActionPermission = sObjectPrefix+IPM_ConstantUtils.LIST_ACCESS;
        fullPermission = sObjectPrefix+IPM_ConstantUtils.FULL_ACCESS; 
        
        for(String action : inlineActionList)
        {
            objectActionsToPermissions.put(action,sObjectPrefix+action);  
        }
        
        if(standardSetCtrl == null) 
        {
            initializePaging();
        }
    }
    
    public void initializePaging()
    {
        fieldSetMemList = getFieldsFromFieldSet(selectedSObject,associatedFieldSet);
        
        if(String.isBlank(sortColumn))
        {
            sortOrder = IPM_ConstantUtils.SORTORDER_ASC;
            previousSortColumn = sortColumn = 'id';
        }
        String SOQLQueryStr = 'SELECT '; 
        for(FieldSetMember fieldSetMem : fieldSetMemList)
        {
            if(!fieldSetMem.getFieldPath().equalsIgnoreCase('id'))
            {
                SOQLQueryStr += ' '+fieldSetMem.getFieldPath() +', ';
            } 
        }
        SOQLQueryStr += ' Id FROM '+selectedSObject;
        if(String.isNotBlank(searchFieldAPI) && sObj.get(searchFieldAPI) !=null)
        {
            SOQLQueryStr += ' WHERE '+searchFieldAPI + ' LIKE  \''+sObj.get(searchFieldAPI)+'%\'';
        }
        SOQLQueryStr += ' ORDER BY '+sortColumn+' '+ sortOrder + ' LIMIT 10000 '; 

        standardSetCtrl = new ApexPages.StandardSetController(database.getQueryLocator(SOQLQueryStr)); 
        standardSetCtrl.setPageSize(PAGE_SIZE); 
        noOfRecords = standardSetCtrl.getResultSize(); 
    }
    // Initialize setCon and return a list of records
    public List<sObject> getsObjectList()  
    {
        if(standardSetCtrl==null) 
        {
           getInitialize(); 
        }
        return standardSetCtrl.getRecords();
    }
    
    /* @desc : Gets the fields associated with a field Set
       @param1 : Object Name assocaited with FieldSet
       @param2 : FieldSet Name	
    */ 
    public List<Schema.FieldSetMember> getFieldsFromFieldSet(String sObjectName,String associatedFieldSet) 
    {
        Schema.SObjectType sObjectT = Schema.getGlobalDescribe().get(selectedSObject);
        Schema.DescribeSObjectResult sObjectDesObj  = sObjectT.getDescribe();
        if(sobj == null)
        {
            sobj = sObjectT.newSObject() ;
        }
        Schema.FieldSet fieldSetObj = sObjectDesObj.FieldSets.getMap().get(associatedFieldSet);
        return fieldSetObj.getFields();
    }
    
    public void refreshPageSize() {  
    }
    
    /* Method used switch sort Order asc or desc based on button clicks*/
    public void updateSortOrder()
    {
        if(previousSortColumn.equalsIgnoreCase(sortColumn))
        {
        	sortOrder= sortOrder == IPM_ConstantUtils.SORTORDER_ASC ? IPM_ConstantUtils.SORTORDER_DESC : IPM_ConstantUtils.SORTORDER_ASC;
        }
        else
        {
            sortOrder = IPM_ConstantUtils.SORTORDER_ASC;
            previousSortColumn = sortColumn;
        }
        initializePaging();
    } 
    
    /* Method used to filter Listing Of sObjects*/
    
    public void searchRecords()
    {
        previousSortColumn = previousSortColumn = IPM_ConstantUtils.BLANK;
        sortOrder = IPM_ConstantUtils.SORTORDER_ASC;
        initializePaging();
    }
    
    /* Method used to reset filters used on searching */
    public void resetRecords()
    {
        sObj =null;  
        initializePaging();
    }
}