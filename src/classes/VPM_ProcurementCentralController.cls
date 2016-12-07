/**********************************************************************
Name:  VPM_ProcurementCentralController()
Copyright ? 2016  Unilever
======================================================================
======================================================================
Purpose:  Used to trigger the Approval process 
1. Procurement Central Admin Functionality  
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Deepak      20/09/2016       INITIAL DEVELOPMENT       N/A
2.0 -    Samrin      04 Oct 2016      Temp Remove permission from oldUser and add permission to newUser.
3.0 -    Vaishali    09 Oct 2016      Remove permission from oldUser and add permission to newUser.
****************************************************************************/
without sharing public class VPM_ProcurementCentralController{
    final static string  STR_CONST_PROCENTRALADMIN = 'VPM_Procurement';
    final static Integer STR_CONST_TOTALNOSOFAPPROVALPOSSILBE = 10;
    final static string  STR_CONST_FIELDNAME ='VPM_Approver';
    final static string  STR_CONST_REMOVE='Remove';
    final static string  STR_CONST_REPLACE='Replace';
    final static String  STR_CONST_TEMPORARY='Temporary';
    final static string  STR_CONST_ASSIGN='Assign';
    final static string  STR_CONST_TEMPAPPROVER='VPM_TempApprover';
    final static string STR_CONST_TEMPAPPDATE='VPM_TempApproverDate';
    final static string STR_CONST_C='__c';
    public boolean buttonDisp {get;set;}
    public boolean ClickGo {get;set;}
    public boolean ClickGoAssign {get;set;}
    public boolean ClickGoRemove {get;set;}
    public boolean showTable{get;set;}
    public Boolean ClickGoTemp {get;set;}
    public VPM_CommodityApprover__c com {get;set;}
    public List<CommApproverList> commApprover {get;set;}
    public string country{get;set;}
    public boolean MainScreen {get;set;}
    public string MDMVendor {get;set;}
    public string newUser {get;set;}
    public string oldUser {get;set;}
    Public Date TillDate{get;set;}
    
        public class CommApproverList{
        
        public boolean checkFlag {get;set;}
        public boolean setFlag {get;set;}
        public VPM_CommodityApprover__c comApp {get;set;}
    
    }
           // Constructor
        public VPM_ProcurementCentralController()
             {
                 com = new VPM_CommodityApprover__c();
                 MainScreen = true;
                 buttonDisp = false;
             }

       /******************************************************************** 
    FunctionName : ChangeApprover  
    Created By   : Deepak
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Main function which will call whenever the Option is selected  
    Return Type  : PageReference
    ********************************************************************/
     public PageReference ChangeApprover()
     {
        oldUser = com.VPM_Approver1__c;
        newUser = com.VPM_Approver2__c;
        country= com.VPM_Country__c;
        TillDate=com.VPM_TempApproverDate1__c;
        if(MDMVendor == STR_CONST_REPLACE){
          try{
            // Steps for replace approval
            //throw error message if oldUser and newUser is null
            if((oldUser==null && newuser==null)|| (oldUser==null && newuser!=null) || (oldUser!=null && newuser==null)){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.VPM_ApproverNotSelected));
             }else{
                      // Step no 1) Replace old user with new user in commodity approval.
                      replaceApproverInCommodity(oldUser, newUser, null);
                      // Step no 2) Add new permission to newUser and remove permission from oldUser.
                      removeProcurmentPermission(oldUser, newUser);
                      com.VPM_Approver2__c=null;
                      com.VPM_Approver1__c=null;         
                   }
               }catch(Exception e){
                   system.debug(e.getMessage() +'  $$  ' +e.getLineNumber());
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'YOUR MESSAGE HERE'));
               }  
         }
                 if(MDMVendor == STR_CONST_TEMPORARY)
                    {
            // Steps for replace approval
                //throw error message if oldUser and newUser is null
                if((oldUser==null && newuser==null)|| (oldUser==null && newuser!=null) || (oldUser!=null && newuser==null)){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_ApproverNotSelected));
               }else if(TillDate==null){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_TempDateNotSelected));
                }else if(TillDate < System.Today()){
                   Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_TempDateIsPassDate));
               }else{
                    // Step no 1) Replace old user with new user in commodity approval.
                    replaceApproverInCommodity(oldUser, newUser, null);
                    // Step no 2) Add new permission to newUser if doesnt have.
                    AddProcurementPermission(newUser);
                   com.VPM_Approver2__c=null;
                   com.VPM_Approver1__c=null;
                   com.VPM_TempApproverDate1__c=null;
                  
                }
                
           }
                   if(MDMVendor == STR_CONST_ASSIGN)
                   { 
                    // Steps for add new user
                        // Step no 1) Pass null to old user, Add new approval in commodity
                            assignRemoveCommodity(null, newUser, country);
                        // Step no 2) Add new permission to newUser.
                            removeProcurmentPermission(null, newUser);
                            com.VPM_Approver2__c=null;
                            com.VPM_Country__c=null;
                   }
                   if(MDMVendor == STR_CONST_REMOVE)
                   {
                    // Steps for Remove User
                        // Step no 1) Pass null to new user.
                            assignRemoveCommodity(oldUser, null, country);
                        // Step no 2) Add new permission to newUser.
                            removeProcurmentPermission(oldUser, null);
                            com.VPM_Approver1__c=null;   
                   }
                   return null;
     }

       
          /******************************************************************** 
    FunctionName : GoBack  
    Created By   : Deepak
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Used to redirect back to menu screen 
    Return Type  : PageReference
    ********************************************************************/
         public PageReference GoBack() {
           MDMVendor = '';
           buttonDisp = false;
           ClickGoAssign = false;
           ClickGoRemove = false;
           ClickGoTemp=False;
           ClickGo = false;
           MainScreen = true;
           com.VPM_Approver2__c=null;
           com.VPM_Approver1__c=null;
           com.VPM_Country__c=null;
           com.VPM_TempApproverDate1__c=null;
           return null;
        }
        
          /******************************************************************** 
    FunctionName : goAssign  
    Created By   : Nagar, Vaishali
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Used when the Assign Option is selected  
    Return Type  : PageReference
    ********************************************************************/
       public PageReference goAssign() {
           
           try{
           if(MDMVendor == STR_CONST_ASSIGN)
              {
                ClickGoAssign = true;
                buttonDisp = false;
                 showTable = true;
                if(com.VPM_Approver2__c==null)
                 {
                     Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_ApproverNotSelectedAssignOption));
                     showTable=false;
                     buttonDisp=false;
                 }   
                else if(com.VPM_Country__c ==null)   
                {  Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_CountryNotSelected));
                   showTable=false;
                   buttonDisp=false;
                }
                 else{
                     AddApproverInCommodity(null,com.VPM_Approver2__c, com.VPM_Country__c);
                     this.commApprover = commApprover;
                 }  
              }else if(MDMVendor == STR_CONST_REMOVE)
              {
                  ClickGoRemove = true;
                  buttonDisp = false;
                  showTable = true;
                  if(com.VPM_Approver1__c==null)
                 {   Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_ApproverNotSelectedAssignOption));
                    showTable=false;
                    buttonDisp=false;
                 }
                  else
                  {
                      AddApproverInCommodity(com.VPM_Approver1__c,null, com.VPM_Country__c);
                      this.commApprover = commApprover;
                  }
                  
              
              }
           }catch(Exception ex){
              
                  system.debug('Error' +ex.getMessage());
                  if(ex.getMessage().contains('Multiple items found')){
                     Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_MultipleRecordFound)); 
                  }
           }
           
            
                return null;
            }
      /******************************************************************** 
    FunctionName : Go  
    Created By   : Nagar, Vaishali
    Created Date : 
    Last Modify  : N/A
    Description  : VPM - Used Show & Hide section & button base on user selection 
    Return Type  : PageReference
    ********************************************************************/
        public PageReference Go() {
        
          buttonDisp = true;
          MainScreen = false;
          ClickGo = false;      
          ClickGoAssign = false;
          if( MDMVendor == STR_CONST_REPLACE){      
            ClickGo = true;
          }else if(MDMVendor == STR_CONST_ASSIGN){
            ClickGoAssign = true;
            showTable = false;
            buttonDisp =false;
          }else if(MDMVendor == STR_CONST_REMOVE){
            ClickGoRemove = true;
            showTable = false;
            buttonDisp =false;
          }else if (MDMVendor == STR_CONST_TEMPORARY){
                ClickGoTemp=true;
          }  
          return null;
        }

 /* Created By : Deepak 
       Created on : 
       Description: Add  permission to newUser.
    */
    public void AddProcurementPermission(string newuser)
    {
        PermissionSet pr =[SELECT  id FROM PermissionSet WHERE name =: STR_CONST_PROCENTRALADMIN LIMIT 1];
        if(newUser != null)
        {
             list<PermissionSetAssignment> checkProcPermission = [SELECT Assignee.Name, PermissionSet.Id FROM PermissionSetAssignment where Assignee.id=:newUser and PermissionSetId=:pr.id limit 1];      
             //if(checkProcPermission.size() == 0)
             if(checkProcPermission.isEmpty())
             {    
                 // Add permission set
                PermissionSetAssignment newProcPermission = new PermissionSetAssignment(AssigneeId=newUser,PermissionSetId=pr.id);
                insert newProcPermission;
                
             }
        }
        
    }

    /* Created By : Vaishali Nagar
       Created on : 09 Oct 2016
       Description: Remove permission from oldUser and add permission to newUser.
    */
    public void removeProcurmentPermission(String oldUser, String newUser)
    {
        PermissionSet pr =[SELECT  id FROM PermissionSet WHERE name =: STR_CONST_PROCENTRALADMIN LIMIT 1];
        Group gr = [Select Id From Group where DeveloperName='VPM_Procurement' AND Type='Queue' limit 1]; 
        if(oldUser != null)
        {
             List<GroupMember> gmList = [Select Id from GroupMember where GroupId=:gr.Id AND UserOrGroupId=:oldUser];
             if(!gmList.isEmpty())
             {
               delete gmList;
             }
             list<PermissionSetAssignment> perSetAss = [SELECT id , AssigneeId FROM PermissionSetAssignment WHERE  AssigneeId=:oldUser AND PermissionSetId=:pr.id];
            if(!perSetAss.isEmpty())
            {
             delete perSetAss;
             }
        }
        if(newUser != null)
        {    
           GroupMember gm = new GroupMember();
            gm.UserOrGroupId = newUser;
            gm.GroupId = gr.Id;
            Insert gm;
            
            list<PermissionSetAssignment> checkProcPermission = [SELECT Assignee.Name, PermissionSet.Id FROM PermissionSetAssignment WHERE  Assignee.id=:newUser AND PermissionSetId=:pr.id limit 1];      
           //if(checkProcPermission.size() == 0)
           if(checkProcPermission.isEmpty())
            {    
              // Add permission set
                PermissionSetAssignment newProcPermission = new PermissionSetAssignment(AssigneeId=newUser,PermissionSetId=pr.id);
                insert newProcPermission;
                
            }
        }
    } 

    /* Created By :Vaishali Nagar
       Created on : 09 Oct 2016
       Description: Replace or Add oldUser commodity approval name with newUser.
    */
    public void replaceApproverInCommodity(String oldUser, String newUser, String country)
    {
        List<VPM_CommodityApprover__c> commAppList = new List<VPM_CommodityApprover__c>();
        if(oldUser != null){
            commAppList = [SELECT id, VPM_Approver1__c , VPM_Approver2__c,VPM_Approver3__c,VPM_Approver4__c,VPM_Approver5__c,
                                   VPM_Approver6__c,VPM_Approver7__c,VPM_ConfiguredApprovers__c, VPM_Approver8__c,VPM_Approver9__c,
                                   VPM_Approver10__c,VPM_CommodityClass__c 
                           FROM VPM_CommodityApprover__c 
                           WHERE VPM_Approver1__c =: oldUser OR VPM_Approver2__c =: oldUser OR VPM_Approver3__c =: oldUser OR VPM_Approver4__c =: oldUser
                                 OR VPM_Approver5__c =: oldUser OR VPM_Approver6__c =: oldUser OR VPM_Approver7__c =: oldUser OR VPM_Approver8__c =: oldUser
                                 OR VPM_Approver9__c =: oldUser OR VPM_Approver10__c =: oldUser LIMIT 50000];
         
         }
         if(commAppList.isEmpty() && oldUser != null){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_OlderApprovalNoLongerExist));
          }
            else
            {
                            List<String> commodities = new List<String>();
                            List<String> repCommodities = new List<String>();
                            for(VPM_CommodityApprover__c commAPP : commAppList)
                            {                         
                                String userToReplace = oldUser;
                                for(Integer approversCount =1; approversCount <= commAPP.VPM_ConfiguredApprovers__c; approversCount ++)
                                {                               
                                    if(newUser == null) // for removing user from approvals
                                    {
                                        if(commAPP.get(STR_CONST_FIELDNAME+approversCount+STR_CONST_C) == userToReplace && approversCount < STR_CONST_TOTALNOSOFAPPROVALPOSSILBE)
                                        {
                                        integer nextApprovor = approversCount+1; 
                                         commAPP.put(STR_CONST_FIELDNAME+approversCount+STR_CONST_C, commAPP.get(STR_CONST_FIELDNAME+nextApprovor+STR_CONST_C)) ;
                                           userToReplace =  string.valueOf(commAPP.get(STR_CONST_FIELDNAME+nextApprovor+STR_CONST_C));
                                           if(nextApprovor == 10){
                                             commAPP.put(STR_CONST_FIELDNAME+approversCount+STR_CONST_C, null) ;
                                           }
                                        }
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.label.VPM_ApproverRemoveSuccess));
                                    }
                                    else
                                    {
                                        //replace old approver with new approver
                                        if (MDMVendor == STR_CONST_TEMPORARY )
                                        {
                                            if(commAPP.get(STR_CONST_FIELDNAME+approversCount+STR_CONST_C) == oldUser)
                                            {
                                                if(commAPP.VPM_Approver1__c != newUser && commAPP.VPM_Approver2__c != newUser && commAPP.VPM_Approver3__c != newUser && commAPP.VPM_Approver4__c != newUser && commAPP.VPM_Approver5__c != newUser && commAPP.VPM_Approver6__c != newUser && commAPP.VPM_Approver7__c != newUser && commAPP.VPM_Approver8__c != newUser && commAPP.VPM_Approver9__c != newUser && commAPP.VPM_Approver10__c != newUser)
                                                {
                                                        commAPP.put(STR_CONST_FIELDNAME+approversCount+STR_CONST_C, newUser) ;    
                                                        commAPP.put('VPM_TempApprover'+approversCount+STR_CONST_C, oldUser) ;
                                                        commAPP.put('VPM_TempApproverDate'+approversCount+STR_CONST_C, TillDate) ;
                                                        repCommodities.add(commAPP.VPM_CommodityClass__c);
                                                }else{
                                                           commodities.add(commAPP.VPM_CommodityClass__c);
                                                           //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Approver cannot be replaced since it is already present for commodity' +commAPP.VPM_CommodityClass__c));
                                                }
                                            }
                                                 
                                           /* if(commAPP.get(STR_CONST_FIELDNAME+approversCount+STR_CONST_C) == oldUser)
                                            {
                                                    commAPP.put(STR_CONST_FIELDNAME+approversCount+STR_CONST_C, newUser) ;    
                                                    commAPP.put('VPM_TempApprover'+approversCount+STR_CONST_C, oldUser) ;
                                                    commAPP.put('VPM_TempApproverDate'+approversCount+STR_CONST_C, TillDate) ;
                                            }       
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+System.label.VPM_ApproverTemporarySuccess));*/
                                        }
                                        else 
                                        {
                                            if(commAPP.get(STR_CONST_FIELDNAME+approversCount+STR_CONST_C) == oldUser)
                                            {
                                                    if(commAPP.VPM_Approver1__c != newUser && commAPP.VPM_Approver2__c != newUser && commAPP.VPM_Approver3__c != newUser && commAPP.VPM_Approver4__c != newUser && commAPP.VPM_Approver5__c != newUser && commAPP.VPM_Approver6__c != newUser && commAPP.VPM_Approver7__c != newUser && commAPP.VPM_Approver8__c != newUser && commAPP.VPM_Approver9__c != newUser && commAPP.VPM_Approver10__c != newUser){
                                                    commAPP.put(STR_CONST_FIELDNAME+approversCount+STR_CONST_C, newUser) ;
                                                        repCommodities.add(commAPP.VPM_CommodityClass__c);
                                                    }else{
                                                       commodities.add(commAPP.VPM_CommodityClass__c);
                                                       //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Approver cannot be replaced since it is already present for commodity' +commAPP.VPM_CommodityClass__c));
                                                   } 
                                            }       
                                            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+System.label.VPM_ApproverReplaceSuccess));
                                        }
                                    }
                                    
                                }
                            }
                             updateCommApprover(json.serialize(commAppList));
                            system.debug('@@ repCommodities' + repCommodities);
                            if(!commodities.isEmpty()){
                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+System.label.VPM_CommodityApproverUnsuccessfullMessage + commodities + System.label.VPM_CommodityErrorMessage));
                             }  
                             if(!repCommodities.isEmpty())  {
                                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+System.label.VPM_CommoditySuccessFullReplaceMessage + repCommodities));
                              }
                     //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.label.VPM_ApproverReplaceSuccess));        
            }
        }
    
          @future
    public static void updateCommApprover(String seriliazeLstCommoApprover){
           List<VPM_CommodityApprover__c> commoditApprovers =     (List<VPM_CommodityApprover__c>)Json.Deserialize(seriliazeLstCommoApprover, List<VPM_CommodityApprover__c>.class);
            update commoditApprovers ;
    }
    

    /* Created By :Vaishali Nagar
       Created on : 09 Oct 2016
       Description: Set value for dataTable.
    */
    public void AddApproverInCommodity(string oldUser,String newUser,String Country){
        
         List<VPM_CommodityApprover__c> commAppList =new List<VPM_CommodityApprover__c>();
         if(oldUser==null)
         {
             commAppList = [SELECT id, VPM_ConfiguredApprovers__c,VPM_Code__c,VPM_Country__c, VPM_Approver1__c ,VPM_Approver1__r.Name , VPM_Approver2__c,VPM_Approver2__r.Name,VPM_Approver3__c,VPM_Approver3__r.Name,VPM_Approver4__r.Name,VPM_Approver4__c,VPM_Approver5__c,VPM_Approver5__r.Name,
                                   VPM_Approver6__c,VPM_Approver6__r.Name,VPM_Approver7__c,VPM_Approver7__r.Name,VPM_Approver8__c,VPM_Approver8__r.Name,VPM_Approver9__c,VPM_Approver9__r.Name,VPM_Approver10__c,VPM_Approver10__r.Name,VPM_CommodityClass__c 
                            FROM VPM_CommodityApprover__c 
                            WHERE  VPM_Country__c =: country AND (VPM_Approver1__c !=: newUser AND VPM_Approver2__c !=: newUser 
                                                             AND VPM_Approver3__c !=: newUser AND VPM_Approver4__c !=: newUser
                                                             AND VPM_Approver5__c !=: newUser AND VPM_Approver6__c !=: newUser 
                                                             AND VPM_Approver7__c !=: newUser AND VPM_Approver8__c !=: newUser
                                                             AND VPM_Approver9__c !=: newUser AND VPM_Approver10__c !=: newUser) ORDER BY VPM_CommodityClass__c ASC  LIMIT 50000];
                                                   
         }else
         {
            commAppList = [SELECT id, VPM_ConfiguredApprovers__c,VPM_Code__c,VPM_Country__c, VPM_Approver1__c ,VPM_Approver1__r.Name , VPM_Approver2__c,VPM_Approver2__r.Name,VPM_Approver3__c,VPM_Approver3__r.Name,VPM_Approver4__r.Name,VPM_Approver4__c,VPM_Approver5__c,VPM_Approver5__r.Name,
                                   VPM_Approver6__c,VPM_Approver6__r.Name,VPM_Approver7__c,VPM_Approver7__r.Name,VPM_Approver8__c,VPM_Approver8__r.Name,VPM_Approver9__c,VPM_Approver9__r.Name,VPM_Approver10__c,VPM_Approver10__r.Name,VPM_CommodityClass__c 
                           FROM VPM_CommodityApprover__c 
                           WHERE  VPM_Approver1__c =: oldUser OR VPM_Approver2__c =: oldUser OR VPM_Approver3__c =: oldUser OR VPM_Approver4__c =: oldUser
                                                    OR VPM_Approver5__c =: oldUser OR VPM_Approver6__c =: oldUser OR VPM_Approver7__c =: oldUser 
                                                    OR VPM_Approver8__c =: oldUser OR VPM_Approver9__c =: oldUser OR VPM_Approver10__c =: oldUser ORDER BY VPM_CommodityClass__c ASC LIMIT 50000];
        
        
         }
         
        if(commAppList.isEmpty())
        {
             if(oldUser==null){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_NoCommodityfound));
             }else{
                   Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_NoCommodityfoundApprover));
             }      
            showTable = false;
            buttonDisp =false;
            com.VPM_Approver1__c =null;
            com.VPM_Approver2__c =null;
            com.VPM_Country__c=null;
        
        }else{
        commApprover = new List<CommApproverList>();
           
            for(VPM_CommodityApprover__c commAPP : commAppList){
                 CommApproverList com= new CommApproverList();
                if(olduser==null)
                {
                     if(commAPP.VPM_ConfiguredApprovers__c <STR_CONST_TOTALNOSOFAPPROVALPOSSILBE)
                    {                       
                           com.checkFlag=false;
                           com.comApp =commAPP;
                           commApprover.add(com);
                    }else
                    {
                           com.checkFlag=true;
                           com.comApp =commAPP;
                           commApprover.add(com);
                    }                   
               }else
               {                     
                           com.checkFlag=false;
                           com.comApp =commAPP;
                           commApprover.add(com);
                   
                   system.debug('@@ inside remove1');
               }
           }
        }
        
       
    }
    
    public pagereference assignRemoveCommodity(string oldUser,string newUser,string Country){
   
                           List<VPM_CommodityApprover__c> commodity = new List<VPM_CommodityApprover__c>();

                                    boolean isSelected = false;
                                   for(CommApproverList comp : commApprover){
                                         
                                        if(oldUser==null){
                                           
                                            if(comp.setFlag){
                                                
                                                
                                                if(comp.comApp.VPM_Approver1__c == newUser || comp.comApp.VPM_Approver2__c == newUser || comp.comApp.VPM_Approver3__c == newUser || comp.comApp.VPM_Approver4__c == newUser|| comp.comApp.VPM_Approver5__c == newUser|| comp.comApp.VPM_Approver6__c == newUser|| comp.comApp.VPM_Approver7__c == newUser|| comp.comApp.VPM_Approver8__c == newUser|| comp.comApp.VPM_Approver9__c == newUser|| comp.comApp.VPM_Approver10__c == newUser){
                                                
                                                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' '+System.label.VPM_AlreadyCommodityapprover + ' '+comp.comApp.VPM_CommodityClass__c));
                                                    comp.setFlag=false;
                                                    return null;
                                               }else{
                                                    system.debug('Track'+ comp);
                                                    isSelected = true;
                                                    integer approvercount=integer.valueOf(comp.comApp.VPM_ConfiguredApprovers__c)+1 ;
                                                    
                                                            comp.comApp.put(STR_CONST_FIELDNAME+approvercount +STR_CONST_C,newUser);
                                                            commodity.add(comp.comApp);
                                                            system.debug('Assigned user' + commodity );
                                                            comp.setFlag=false;
                                                            
                                                   }         
                                                
                                            }
                                        }else{
                                        
                                         String userToReplace = oldUser;
                                        for(Integer approversCount =1; approversCount <= comp.comApp.VPM_ConfiguredApprovers__c; approversCount ++)
                                        {                               
                                            if(comp.setFlag && newUser==null) // for removing user from approvals
                                            {    
                                                isSelected = true;
                                                if(comp.comApp.get(STR_CONST_FIELDNAME+approversCount+STR_CONST_C) == userToReplace && approversCount < STR_CONST_TOTALNOSOFAPPROVALPOSSILBE)
                                                {
                                                integer nextApprovor = approversCount+1; 
                                                 comp.comApp.put(STR_CONST_FIELDNAME+approversCount+STR_CONST_C, comp.comApp.get(STR_CONST_FIELDNAME+nextApprovor+STR_CONST_C)) ;
                                                   userToReplace =  string.valueOf(comp.comApp.get(STR_CONST_FIELDNAME+nextApprovor+STR_CONST_C));
                                                   if(nextApprovor == STR_CONST_TOTALNOSOFAPPROVALPOSSILBE)
                                                     comp.comApp.put(STR_CONST_FIELDNAME+approversCount+STR_CONST_C, null) ;
                                                     
                                                }
                                                //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Approver successfully removed'));
                                            }
                                            
                                        
                                        }
                                        comp.setFlag=false;
                                        commodity.add(comp.comApp);
                                        system.debug('@@ commodity' +commodity);
                                      }
                                            
                                 }
                                    
                                    
                                     if(!isSelected ){
                                                
                                                if(oldUser==null){
                                                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.label.VPM_NoRecordSelectApproverCountry));
                                                }else{
                                                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+System.label.VPM_NoRecordSelectApprover));
                                                }
                                                commApprover.clear();
                                                showTable=false;
                                                buttonDisp=false;
                                                return null;
                                     }
                                     
                                         updateCommApprover(json.serialize(commodity));
                                         
                                         commApprover.clear();
                                         //commodity.clear();
                                         system.debug('@@ commmApprover' + commApprover);
                                         showTable=false;
                                         buttonDisp=false;
                                        if(oldUser==null){
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.VPM_AddedCommodityApprover));
                                        }else{
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,+System.Label.VPM_RemoveCommodityApprover));
                                        }
                            return null;
    }
    
   }