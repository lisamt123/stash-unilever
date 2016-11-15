/*
   Class Name              : Core_CA_RequestDetailsController
   Date                    : 11/09/2014
   Requirement/Project Name: Chatter Approvals
   Requirement/Description : List of Open and Closed Request.
       1. Open Requests show all Requests that have not yet had approver action taken on them.
       2. Closed Requests provides an archive of past requests.
*/

public with sharing class Core_CA_RequestDetailsController {
    
    public integer list_size         {get; set;}   //sets the page size or number of rows    
    Public integer counterOpen       {get; set;}   //keeps track of the offset for open request
    public integer total_sizeOpen    {get; set;}   //used to show user the total size of the list for open request 
    public integer counterClose      {get; set;}   //keeps track of the offset for closed request
    public integer total_sizeClose   {get; set;}   //used to show user the total size of the list for closed request
    public string  OpenReqMsg        {get; set;}   //message to display when no records found
    public string  CloseReqMsg       {get; set;}   //message to display when no records found
    
    String strUid = userinfo.getUserId();
    List<string> lstOpenReqst=new List<string>(); 
    List<string> lstClosedReqst=new List<string>();
    Set<Id> approverHeaderId1 = new Set<Id>();
    Set<Id> approverHeaderId2 = new Set<Id>();
    Set<Id> approverHeaderId3 = new Set<Id>();
    Set<Id> approverHeaderId4 = new Set<Id>();
    
    public Core_CA_RequestDetailsController (){       
        //Set the pagination Limit
         list_size=integer.ValueOf(CORE_Chatter_Approval__c.getinstance('PaginationLimit').Text_Value__c);       
                
        //Page Message
        OpenReqMsg  = CORE_Chatter_Approval__c.getinstance('OpenRequestMsg').Text_Value__c;
        CloseReqMsg = CORE_Chatter_Approval__c.getinstance('ClosedRequestMsg').Text_Value__c; 
        
        //retrive Custom setting for open request for ariba
        string strOpenReq = CORE_Chatter_Approval__c.getinstance('OpenRequest').Text_Value__c;
        if(strOpenReq !=null) lstOpenReqst=strOpenReq.split(',');
        
        //retrive Custom setting for closed request for ariba
        string strClosedReq = CORE_Chatter_Approval__c.getinstance('ClosedRequest').Text_Value__c;
        if(strClosedReq!=null) lstClosedReqst=strClosedReq.split(',');
         
        //Call method to take the Pagination count 
         //approvedRejectedReq();         
         paginationOpenCount();
         paginationClosedCount();
    }    
    
    public void approvedRejectedReq(){
         approverHeaderId1 = new Set<Id>();
         approverHeaderId2 = new Set<Id>();
        
        //Open request Condition for GTES   
        List<Core_Approver_Details__c> lstApprover1 = [Select Approval_Header__c From Core_Approver_Details__c Where (((Role__c='EMP' OR  Role__c='SUB') AND Interested_Party__c=:strUid) OR TF_Requested_By__c =: (strUid.Substring(0, strUid.length()-3))) AND Source_System__c=:'GTES'];         
         for(Core_Approver_Details__c id:lstApprover1)
             approverHeaderId1.add(id.Approval_Header__c );
             
        //closed request Condition for GTES              
         List<Core_Approval_Header__c> lstHeader = [Select Id From Core_Approval_Header__c Where Fully_Approved__c =True AND Id IN: approverHeaderId1 ];        
         for(Core_Approval_Header__c id: lstHeader)
             approverHeaderId2.add(id.Id);  
                
    }
    
    public void paginationOpenCount(){
        //Set the counter value.
        counterOpen =0;
        approvedRejectedReq();
        approverHeaderId3 = new Set<Id>();    
        for(Id id: approverHeaderId1){
             if(!approverHeaderId2.contains(id))
                approverHeaderId3.add(id); 
        }
        
        //Take the count of open request records.
        total_sizeOpen = [Select count() from Core_Approval_Header__c WHERE 
                          ((Status__c in :lstOpenReqst AND Source_System__c=:'Ariba' AND (Requested_By__c=: strUid  OR Requested_For__c=: strUid)) OR
                           (Source_System__c=:'GTES' AND ID IN:approverHeaderId3 )) ]; 
    }
    
    public void paginationClosedCount(){
        //Set the counter value.
        counterClose =0;
        approvedRejectedReq();
        approverHeaderId4 = new Set<Id>();
        for(Id id: approverHeaderId1){
             if(approverHeaderId2.contains(id)) 
                approverHeaderId4.add(id); 
        }
        
        //Take the count of closed request records.                                     
        total_sizeClose =  [Select count() from Core_Approval_Header__c WHERE
                            ((Status__c in :lstClosedReqst AND Source_System__c=:'Ariba' AND (Requested_By__c=: strUid  OR Requested_For__c=: strUid)) OR
                             (Source_System__c=:'GTES' AND ID IN:approverHeaderId4))]; 
    }
    
    public List<Core_Approval_Header__c>  getopenRequests() {
      try {
          //Retrive open request records.
           List<Core_Approval_Header__c>  lstOpenReq=[Select Id,Name,Source_System__c,Title_Summary__c,Status__c from Core_Approval_Header__c WHERE 
                                                   ((Status__c in :lstOpenReqst AND Source_System__c=:'Ariba' AND (Requested_By__c=: strUid  OR Requested_For__c=: strUid)) OR
                                                    (Source_System__c=:'GTES' AND ID IN:approverHeaderId3 ))
                                                    ORDER BY LastModifiedDate DESC  limit :list_size offset :counterOpen];
                                                   
          system.debug('second list'+lstOpenReq); 
          return lstOpenReq;
       } catch (QueryException e) {
          ApexPages.addMessages(e);   
          return null;
       }
   }
   
   public List<Core_Approval_Header__c>  getclosedRequests() {
      try {
          //Retrive Closed request records.
          List<Core_Approval_Header__c>  lstCloseReq =[Select Id,Name,Source_System__c,Title_Summary__c,Status__c from Core_Approval_Header__c WHERE
                                                     ((Status__c in :lstClosedReqst AND Source_System__c=:'Ariba' AND (Requested_By__c=: strUid  OR Requested_For__c=: strUid)) OR
                                                      (Source_System__c=:'GTES' AND ID IN:approverHeaderId4)) 
                                                      ORDER BY LastModifiedDate DESC  limit :list_size offset :counterClose];
                                                   
 
          return lstCloseReq ;
       }catch (QueryException e) {
          ApexPages.addMessages(e);   
          return null;
      }
   }
   
   /*----- Satrt of Pagination code for Open Request ----*/
   //user clicked beginning.
   public PageReference BeginningOpen() { 
      counterOpen = 0;
      return null;
   }
   
   //user clicked previous button.
   public PageReference PreviousOpen() { 
      counterOpen -= list_size;
      return null;
   }
   
   //user clicked next button.
   public PageReference NextOpen() { 
      counterOpen += list_size;
      return null;
   }
 
   //user clicked end. 
   public PageReference EndOpen() { 
      counterOpen = total_sizeOpen - math.mod(total_sizeOpen, list_size);
      if(counterOpen  == total_sizeOpen)
          counterOpen  = total_sizeOpen - list_size;
      return null;
   }
 
   //this will disable the previous and beginning buttons.
   public Boolean getDisablePreviousOpen() { 
      if (counterOpen>0) return false; else return true;
   }
 
   //this will disable the next and end buttons.
   public Boolean getDisableNextOpen() { 
      if (counterOpen + list_size < total_sizeOpen) return false; else return true;
   }
 
   //Get the total reocrd count.
   public Integer gettotal_sizeOpen() {
      return total_sizeOpen;
   }
   
   //Get the current page number.
   public Integer getPageNumberOpen() {
      return counterOpen/list_size + 1;
   }
 
   //Get the total page number.
   public Integer getTotalPagesOpen() {
      if (math.mod(total_sizeOpen, list_size) > 0) {
         return total_sizeOpen/list_size + 1;
      } else {
         return (total_sizeOpen/list_size);
      }
   }
   /*----- End of Pagination code for Open Request ----*/
   
   /*----- Satrt of Pagination code for Closed Request ----*/
   //user clicked beginning.
   public PageReference BeginningClose() { 
      counterClose = 0;
      return null;
   }
   
   //user clicked previous button. 
   public PageReference PreviousClose() { 
      counterClose -= list_size;
      return null;
   }
   
   //user clicked next button.
   public PageReference NextClose() { 
      counterClose += list_size;
      return null;
   }
   
   //user clicked end.
   public PageReference EndClose() { 
      counterClose = total_sizeClose - math.mod(total_sizeClose, list_size);
      if(counterClose == total_sizeClose)
          counterClose = total_sizeClose - list_size;
      return null;
   }
 
   //this will disable the previous and beginning buttons.
   public Boolean getDisablePreviousClose() { 
      if (counterClose>0) return false; else return true;
   }
 
   //this will disable the next and end buttons.
   public Boolean getDisableNextClose() { 
      if (counterClose + list_size < total_sizeClose) return false; else return true;
   }
  
   //Get the total reocrd count.
   public Integer gettotal_sizeClose() {
      return total_sizeClose;
   }
   
   //Get the current page number.
   public Integer getPageNumberClose() {
      return counterClose/list_size + 1;
   }
  
   //Get the total page number.
   public Integer getTotalPagesClose() {
      if (math.mod(total_sizeClose, list_size) > 0) {
         return total_sizeClose/list_size + 1;
      } else {
         return (total_sizeClose/list_size);
      }
   }
   /*----- End of Pagination code for Closed Request ----*/
   
     
}