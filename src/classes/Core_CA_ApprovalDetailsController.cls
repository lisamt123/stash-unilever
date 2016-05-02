/*
  Class Name: Core_CA_ApprovalDetailsController
  Author : Mindtree
  Date: 11 Sept 2014
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: List of Open and Closed Approvals.
        1. Open Requests show all approvals that have not yet had approver action.
        2. Closed Requests provides an archive of past approvals.   
*/

public with sharing class Core_CA_ApprovalDetailsController{
    public integer list_size           {get; set;}  //sets the page size or number of rows    
    Public integer counterOpen         {get; set;}  //keeps track of the offset
    public integer counterClose        {get; set;}  //keeps track of the offset
    public string  OpenAppMsg          {get; set;}  //message to display when no records found
    public string  ClosedAppMsg        {get; set;}  //message to display when no records found
    
    String strUid = userinfo.getUserId();
    Set<Id> cancelledApproverID = new Set<Id>();
    public integer total_sizeOpen;
    public integer total_sizeClose;
    string strGTES ='GTES';
    
    public Core_CA_ApprovalDetailsController(){
        //Set the pagination Limit
        list_size=integer.ValueOf(CORE_Chatter_Approval__c.getinstance('PaginationLimit').Text_Value__c);
        
        //Page Message
        OpenAppMsg = CORE_Chatter_Approval__c.getinstance('OpenApprovalMsg').Text_Value__c;
        ClosedAppMsg = CORE_Chatter_Approval__c.getinstance('ClosedApprovalMsg').Text_Value__c;
            
        //Call method to take the Pagination count.
        paginationOpenCount();  
        paginationClosedCount();       
    }
    
    public void paginationOpenCount(){
        //Set the counter value.
        counterOpen  =0;
        
        //The Open Approval record shouldn't be recalled 
        cancelledApproverID = new Set<Id>();
        List<Core_Approver_Details__c> cancelledApprover =[SELECT Approval_Header__c FROM Core_Approver_Details__c where  Role__c = 'EMP' AND Action__c = 'CANC' AND Source_System__c=: strGTES];
        for(Core_Approver_Details__c id: cancelledApprover)
            cancelledApproverID.add(id.Approval_Header__c);
            
        //Take the count of open appproval records.   
        total_sizeOpen = [SELECT count() FROM Core_Approver_Details__c where Interested_Party__c=:strUid 
                           AND ( (Is_Active__c=: true and Source_System__c=:'Ariba' AND Role__c = 'APP' AND Action__c != 'APPR' AND Action__c != 'REJC' AND Status__c !='Approved' AND Status__c!='Rejected' )
                                  OR (Source_System__c=: strGTES AND Role__c = 'APP' AND Action__c = 'ACTV' AND  Status__c !='Approved' AND Status__c!='Rejected' AND (Approval_Header__c not in :cancelledApproverID))
                               )  ]; //set the total size in the constructor
    }
    
    public void paginationClosedCount(){
        //Set the counter value.
        counterClose =0;
        
        //The Open Approval record shouldn't be recalled 
        cancelledApproverID = new Set<Id>();
        List<Core_Approver_Details__c> cancelledApprover =[SELECT Approval_Header__c FROM Core_Approver_Details__c where  Role__c = 'EMP' AND Action__c = 'CANC' AND Source_System__c=: strGTES];
        for(Core_Approver_Details__c id: cancelledApprover)
            cancelledApproverID.add(id.Approval_Header__c);
                   
        //Take the count of closed appproval records.                                    
        total_sizeClose =  [SELECT count() FROM Core_Approver_Details__c where Interested_Party__c=:strUid 
                             AND( (Role__c = 'APP' AND Source_System__c=:'Ariba' AND (Action__c = 'APPR' OR Action__c = 'REJC' OR Status__c ='Approved' OR Status__c='Rejected')) OR
                                  (Role__c = 'APP' AND Source_System__c=: strGTES AND  (Action__c = 'APPR' OR Action__c = 'REJC'  OR Status__c ='Approved' OR Status__c='Rejected') AND (Approval_Header__c not in :cancelledApproverID)) )];
    }
    
    public List<Core_Approver_Details__c>  getopenApproval() {
      try {
         //Retrive open approval records.
         List<Core_Approver_Details__c>  lstOpenApp=[SELECT Approval_Header__c,Action__c,Header_ExternalId__c,Source_System__c,Status__c,TF_Header_Status__c,TF_Requestor_Name__c FROM Core_Approver_Details__c where Interested_Party__c=:strUid 
                                                     AND ( (Is_Active__c=: true and Source_System__c=:'Ariba' AND Role__c = 'APP' AND Action__c != 'APPR' AND Action__c != 'REJC' AND Status__c !='Approved' AND Status__c!='Rejected' )
                                                           OR (Source_System__c=: strGTES AND Role__c = 'APP' AND Action__c = 'ACTV' AND Status__c !='Approved' AND Status__c!='Rejected' AND (Approval_Header__c not in :cancelledApproverID)))  
                                                           ORDER BY LastModifiedDate DESC limit :list_size offset :counterOpen ];
   
 
         return lstOpenApp;
      } catch (QueryException e) {
         ApexPages.addMessages(e);   
         return null;
      }
   }
   
   public List<Core_Approver_Details__c>  getClosedApproval() {
      try {
        //Retrive closed approval records.
         List<Core_Approver_Details__c>  lstCloseApp=[SELECT Approval_Header__c,Action__c,Header_ExternalId__c,Source_System__c,Status__c,TF_Header_Status__c,TF_Requestor_Name__c FROM Core_Approver_Details__c where Interested_Party__c=:strUid 
                                                     AND( (Role__c = 'APP' AND Source_System__c=:'Ariba' AND (Action__c = 'APPR' OR Action__c = 'REJC' OR Status__c ='Approved' OR Status__c='Rejected')) OR
                                                          (Role__c = 'APP' AND Source_System__c=: strGTES AND  (Action__c = 'APPR' OR Action__c = 'REJC' OR  Status__c ='Approved' OR Status__c='Rejected') AND (Approval_Header__c not in :cancelledApproverID) ))
                                                     ORDER BY LastModifiedDate DESC limit :list_size offset :counterClose ];
                                                   
 
         return lstCloseApp;
      } catch (QueryException e) {
         ApexPages.addMessages(e);   
         return null;
      }
   }
   
   /*----- Satrt of Pagination code for Open Approval ----*/ 
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
   public Integer getTotal_sizeOpen() {
      return total_sizeOpen;
   }
   
   //Get the current page number.
   public Integer getPageNumberOpen() {     
      return (counterOpen/list_size + 1);    
   }
   
   //Get the total page number.
   public Integer getTotalPagesOpen() {
      if (math.mod(total_sizeOpen, list_size) > 0) {
         return total_sizeOpen/list_size + 1;
      } else {
         return (total_sizeOpen/list_size);
      }
   }
   /*----- End of Pagination code for Open Approval ----*/
   
   /*----- Satrt of Pagination code for closed Approval ----*/
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
   public Integer getTotal_sizeClose() {
      return total_sizeClose;
   }
 
   //Get the current page number.
   public Integer getPageNumberClose() {
      //system.debug('getPageNumberClose'+ (counterClose/list_size + 1));
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
  /*----- End of Pagination code for Closed Approval ----*/ 
     
    

}