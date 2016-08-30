/**********************************************************************
Name: FS_ContactExtend_CX
======================================================
======================================================
Purpose: For Inline Contact Vf page
-------
======================================================
======================================================
History
-------
VERSION AUTHOR   DATE        DETAIL Description
1.0     Dinesh  19/07/2016 INITIAL DEVELOPMENT 
***********************************************************************/



public with sharing class FS_ContactExtend_CX{
    
    private final Id acctVarId;
    Public String varContactIdForDeletion{get;set;}
    Public String varContactRefIdForEdit{get;set;}
   public List<Contact> myContacts { get; private set; }
    
    /*******************************************************************
Purpose: Standard Controller for caprting the page id and getting the contact 
Parameters: Controller
Returns: String 
********************************************************************/
    
    public FS_ContactExtend_CX(ApexPages.StandardController controller) {
        
        acctVarId = controller.getRecord().Id;
        
        
        myContacts=new List<Contact>();
        
        myContacts = [ SELECT Id, Name,Email,FS_Position__c,FS_Decision_Maker__c,FS_RefId__c, Account.Name from Contact WHERE  Account.id=:acctVarId and FS_RefId__c!=null limit 1000];
        
    }
    
    /*******************************************************************
Purpose: Default constructor  for class 
Parameters: 
Returns:  
********************************************************************/
    public FS_ContactExtend_CX(){
        myContacts=new List<Contact>();
   }
    
    /*******************************************************************
Purpose: Creating new Contact
Parameters:
Returns: Pagereference 
********************************************************************/
   Public Pagereference createContact()
    {
        try
        {
            PageReference varCreateContact = new PageReference(FS_ContactUtility.CONTACTCREATEPAGEURL); 
            varCreateContact.setRedirect(true);
            return varCreateContact;
        }
        Catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,FS_ContactUtility.ERRORENTERVALUETEXT));
            return null;
        }
        
    }
    
/*******************************************************************
Purpose: Deleting Contact
Parameters:
Returns: Pagereference 
********************************************************************/
    Public Pagereference deleteContact()
    {
        try
        {
            Contact varDeleteContact=[Select id from Contact where id=:varContactIdForDeletion];
            delete varDeleteContact;
            myContacts = [ SELECT Id, Name,Email,FS_Position__c,FS_Decision_Maker__c,FS_RefId__c, Account.Name from Contact WHERE  Account.id=:acctVarId and FS_RefId__c!=null limit 1000];
        }
        Catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,FS_ContactUtility.ERRORTRYAGINTEXT));
        }
        return null;
    }
    /*******************************************************************
    Purpose: For Edit Contact
    Parameters:
    Returns: Pagereference 
    ********************************************************************/
  /*  Public Pagereference EditContact()
    {
        try
        {
            PageReference varEditContact = new PageReference(FS_ContactUtility.CONTACTDETAILURL+varContactRefIdForEdit+FS_ContactUtility.MODEEDITTEXT); 
            varEditContact.setRedirect(true);
            return varEditContact;
        }
        Catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,FS_ContactUtility.ERRORTRYAGINTEXT));
        }
        return null;
    } */
    
}