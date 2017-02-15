/***************************************************************  
Name:  CCF_Landing_CC  Copyright © 2015  Salesforce  
====================================================== 
Purpose:                                                             
1. Once user login the lang page of CCF_Landing uses this controller                                                           
====================================================== 
History                                                            
-------                                                             

VERSION  AUTHOR      DATE          DETAIL        Description    
1.0      Saravanan    30/12/2016                                
***************************************************************/ 

public class CCF_Landing_CC 
{
    public list<CCF_Request_Header__c> ccfHeaderList;
    //public String statusValue{get;set;}
    CCF_Request_Header__c headerObject{get;set;}
    public boolean displayPopup {get; set;}
    Public List<RecordType> recordTypes{get;set;}
    
    public CCF_Request_Header__c ccfHeader
    {
        get
        {
            if(ccfHeader==null)
            {
                ccfHeader=new CCF_Request_Header__c();
            }
            return ccfHeader;
        }set;
     }
   
    public CCF_Landing_CC()
    {
        System.Debug('in Constructor '+ccfHeader.Effective_Date__c +'  '+ccfHeader.Expiration_Date__c );
        headerObject = new CCF_Request_Header__c();
        recordTypes=[select name from recordtype where sobjecttype='CCF_Request_Header__c'];
      //  statusValue='In progress';
    }
    
    /*START:: Getter and Setter methods*/
    public list<CCF_Request_Header__c> getccfHeaderList()
    {
        if(ccfHeaderList==null)
        {
            ccfHeaderList=new list<CCF_Request_Header__c>();
            ccfHeaderList=[Select id, Role__c,Valid_UPA_exist__c,Contract_Name__c,Name,Supplier_Name__r.Name,Contract_Description__c,Portfolio__c,Effective_Date__c,Status__c,CCF_Request_Header__c.Owner.name,Expiration_Date__c,Contract_Owner__r.name from CCF_Request_Header__c where Status__c='Draft'];
        }
        return ccfHeaderList;
    }
    /*END:: Getter and Setter methods*/
    
    /*START :: Action methods*/
    public pagereference newCCF()
    {
        Pagereference page=new Pagereference('/apex/CCF_Formv2');
        page.setRedirect(true);
        return page;
    }
    /*END:: Action Methods*/
         
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    
    /*START :: Action methods*/
    public PageReference searchResults()
    {
        string dateFilter=null;
        string queryStr;
        ccfHeaderList.clear();
        if(ccfHeader.Status__c==null)
            System.debug('null is detected');
        System.debug(ccfHeader.Status__c + ' ' +ccfHeader.Effective_Date__c + ' ' +ccfHeader.Expiration_Date__c );
        
       
        
        
        if(ccfHeader.Effective_Date__c != null)
        {
            System.debug('in effectiveDate not null');
            Datetime dot1=Date.newInstance(ccfHeader.Effective_Date__c.year(), ccfHeader.Effective_Date__c.month(), ccfHeader.Effective_Date__c.day()); 
            string dt1=dot1.format('yyyy-MM-dd');
            dateFilter='where Effective_Date__c >='+dt1;
            if(ccfHeader.Expiration_Date__c != null )
              {
                  Datetime dot2=Date.newInstance(ccfHeader.Expiration_Date__c.year(), ccfHeader.Expiration_Date__c.month(), ccfHeader.Expiration_Date__c.day());
                  string dt2=dot2.format('yyyy-MM-dd');
                  dateFilter+= ' and Expiration_Date__c <= '+dt2;
               }
             if(ccfHeader.Status__c != null )
             {
                  dateFilter+=' and Status__c =\''+ccfHeader.Status__c+'\'';
             }
        }
        else
        {          
            System.debug('in effectiveDate null');

             if(ccfHeader.Status__c != null )
             {
                  dateFilter='where Status__c =\''+ccfHeader.Status__c+'\'';
             }
        }
        
       
        if(dateFilter!=null)
        {
             queryStr='Select id,Role__c,Contract_Name__c, Valid_UPA_exist__c,Name,Supplier_Name__r.Name,Contract_Description__c,Portfolio__c,Effective_Date__c,Status__c,CCF_Request_Header__c.Owner.name,Expiration_Date__c,Contract_Owner__r.name from CCF_Request_Header__c '+dateFilter;
        }
        else{
             queryStr='Select id,Role__c,Contract_Name__c, Valid_UPA_exist__c,Name,Supplier_Name__r.Name,Contract_Description__c,Portfolio__c,Effective_Date__c,Status__c,CCF_Request_Header__c.Owner.name,Expiration_Date__c,Contract_Owner__r.name from CCF_Request_Header__c where Status__c=\'Draft\'';
        }
        System.debug(queryStr);
       ccfHeaderList=database.query(queryStr);
       return null;
    }
    
    public PageReference searchClear()
    { 
        ccfHeader.Status__c=null;
        ccfHeader.Effective_Date__c=null;
          ccfHeader.Expiration_Date__c=null;
        String queryStr='Select id,Role__c,Contract_Name__c, Valid_UPA_exist__c,Name,Supplier_Name__r.Name,Contract_Description__c,Portfolio__c,Effective_Date__c,Status__c,CCF_Request_Header__c.Owner.name,Expiration_Date__c,Contract_Owner__r.name from CCF_Request_Header__c where Status__c=\'Draft\'';
      System.debug(queryStr);
        
         ccfHeaderList=database.query(queryStr);
        return null;
    }
    
    
}