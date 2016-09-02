/******************************************************
* @author Cognizant (Sumit)
* @date 13/04/2015
* @description Generic Implementation of Standard Set Controller.
*/

public abstract class AbstractStandardSetExtension    
{
    public static final Integer DEFAULT_PAGE_SIZE =10;
    public static final String FIRST_CONTEXT = 'First';
    public static final String LAST_CONTEXT = 'Last';
    public static final String NEXT_CONTEXT =  'Next';
    public static final String PREV_CONTEXT = 'Previous';
    
    public ApexPages.StandardSetController setCon {get;set;} 
    public static Integer pageSize {get;set;}
    public Integer currentPageNumber {get;set;}
    
    
    // Stores information about Selected records on UI.
    public List<sObject> selectedRecordList{get;set;}
    
    
    // Contains a subset of total Records to be displayed on Page
    public List<sObject> recordList{get;set;}
    public List<sObjectPaginationWrapper> wrapperRecordList{get;set;}
    
    
    public transient List<SObject> sourcesObjectList {get;set;}
    public static Boolean retainSelection = false;
    public static Boolean isWrapperPresent = false;
    
    /******************************************************
    * @description Used for Creating Wrapper List for processing Standard Set 
    Controller using checkboxes
    */ 
    
    
    public virtual List<sObjectPaginationWrapper> getWrapperRecords()
    {
        wrapperRecordList = new List<sObjectPaginationWrapper>();
        recordList = new List<sObject>();
        if(setCon == null)
        {
            initiateSetController();
        }
        recordList = setCon.getRecords();
        System.debug('recordList --->>>'+recordList);
        postProcessing(recordList); 
        return wrapperRecordList;
    }
    
    /********************************************************************
    * @description Hookup provided to set various params like PageSize etc.
    */ 
    public virtual void setInitializationParams()
    {
        // User needs to override this method in case they want to set some initialization params. 
        if(PageSize == null || PageSize == 0)
        {
           pageSize = DEFAULT_PAGE_SIZE;
        }
        setCon.setPageSize(pageSize);
        
        if(currentPageNumber!=null)
        {
           setCon.setPagenumber(currentPageNumber);   
        } 
    } 
    
    
    private void initiateSetController()
    {
        if(sourcesObjectList!=null && sourcesObjectList.size() > 0)
        {
        	sortMilestones(sourcesObjectList);
            setCon = new  ApexPages.StandardSetController(sourcesObjectList);
        }
        else
        {
            String query = getQuery();
            setCon = new  ApexPages.StandardSetController(Database.getQueryLocator(query));
        }
        setInitializationParams();
    }
   
    /******************************************************************
    * @description wraps Standard First Page Functionality of Standard Set Controller.
    */ 
    
    public virtual void firstPage()
    {
        getSelectedRecords();
        preprocessing(FIRST_CONTEXT);
        setCon.first();
    }
    
    /*******************************************************************
    * @description wraps Standard Last Page Functionality of Standard Set Controller.
    */ 
    
    public virtual void lastPage()
    {
        getSelectedRecords();
        preprocessing(LAST_CONTEXT);
        setCon.last();
    }
    
     /*******************************************************************
    * @description wraps Standard Next Page Functionality of Standard Set Controller.
    */ 
    
    public virtual void nextPage()
    {
        getSelectedRecords();
        preprocessing(NEXT_CONTEXT);
        setCon.next();
    }
    
    /*********************************************************************
    * @description wraps Standard Previous Page Functionality of Standard Set Controller.
    */ 
    
    public virtual void previousPage()
    {
        getSelectedRecords();
        preprocessing(PREV_CONTEXT);
        setCon.previous();
    }
    
    /*********************************************************************
    * @description wraps Standard HasPrevious Functionality of Standard Set Controller.
    */ 
    
    public virtual Boolean getHasPrevious()
    {
        return setCon.getHasPrevious();
    }
    
     /*********************************************************************
    * @description wraps Standard HasNext Functionality of Standard Set Controller.
    */
    
    public virtual Boolean getHasNext()
    {
        return setCon.getHasNext();
    }
    
    /*********************************************************************
    * @description wraps Standard getPageNumber Functionality of Standard Set Controller.
    */
    
    public virtual Integer getPageNumber()
    {
       return setCon.getPageNumber();     
    }
    
    public virtual Integer getPageSize()
    {
        return setCon.getPageSize();
    }
    
    public virtual void setPageNumber()
    {
        currentPageNumber = getPageNumber();
        if(recordList.size() == 1)
        {
           currentPageNumber = currentPageNumber -1; 
        }      
    }
    
    public virtual integer getPageRecordRange(){
    	return ((getPageNumber() -1)*getPageSize() );	
    }   
    
    /*********************************************************************
    * @description method to retrieve the starting record number for pagination
    */
    
    public virtual integer getBeginIndexNumber(){
    	return (getPageRecordRange() + 1);
    }
    
    /*********************************************************************
    * @description method to retrieve the ending record number for pagination
    */
    
    public virtual integer getEndIndexNumber(){
    	return (getPageRecordRange() + setCon.getRecords().size());
    }
    
     /*************************************************************************
    * @description Wrapper class to provide basic wrapper functionality with CheckBox.
    */
        
    public class sObjectPaginationWrapper
    {
        public boolean isChecked {get;set;}
        public sObject record {get;set;}
        public boolean isLast {get;set;}
        public boolean isEditable {get;set;}
        public boolean isDeletable {get;set;}
        public boolean showTLDInfoIcon {get;set;}
        
        public sObjectPaginationWrapper(sObject record,Boolean isChecked)
        {
            this.record = record;
            this.isChecked = isChecked;
        }
        public sObjectPaginationWrapper(sObject record,Boolean isChecked,Boolean isLast){
        	this.record =  record;
        	this.isChecked = isChecked;
        	this.isLast =  isLast;
        }
        
        public sObjectPaginationWrapper(sObject record,Boolean isChecked,Boolean isEditable, Boolean isDeletable){
        	this.record =  record;
        	this.isChecked = isChecked;
        	this.isEditable =  isEditable;
        	this.isDeletable =  isDeletable;
        }
        
        public sObjectPaginationWrapper(sObject record,Boolean isChecked,Boolean isEditable, Boolean isDeletable, Boolean showTLDInfoIcon){
        	this.record =  record;
        	this.isChecked = isChecked;
        	this.isEditable =  isEditable;
        	this.isDeletable =  isDeletable;
        	this.showTLDInfoIcon =  showTLDInfoIcon;
        }
    }
    
     /***************************************************************************
    * @description Method to be implemented by Implementing Class to provide query to be processed by Standard Set Controller.
    */
    
    public abstract String getQuery();
    
     /***************************************************************************
    * @description Method to be implemented by Implementing Class to provide sorted Milestone list.
    */
    
 	public virtual void sortMilestones(List<sObject> sourcesObjectList)
 	{
 	
 	}
     
     /****************************************************************************
    * @description Used for getting Selected Records.
    */
    
    
    private virtual void getSelectedRecords()
    {
        if(!retainSelection)
        {
            selectedRecordList = new List<Sobject>();
        }
        
        if(wrapperRecordList!=null && !wrapperRecordList.isEmpty())
        {
            for(sObjectPaginationWrapper wrapObj : wrapperRecordList)
            {
                if(wrapObj.isChecked)
                {
                    selectedRecordList.add(wrapObj.record);
                }
            }
        }           
    }
    
     /****************************************************************************
    * @description Hookups provided before next,Previous,first and Last Page Records are retrieved. 
      Any processing needed to be done can be done here.
    */
    
    public virtual void preprocessing(String contextType)
    {
        // Can be implemented in case user needs hookups before getting next set of records.
    }
    
     /*****************************************************************************
    * @description Hookups provided after next,Previous,first and Last Page Records are retrieved. 
      Any processing needed to be done can be done here.
    */
    
    public virtual void postProcessing(List<sObject> recordList)
    {
        if(isWrapperPresent)
        {
	        // Can be implemented in case user needs hookups before getting next set of records.
	        for(sObject tempSObject : recordList)
	        {
	            wrapperRecordList.add(new sObjectPaginationWrapper(tempSObject,false));
	        }
        }
    }
}