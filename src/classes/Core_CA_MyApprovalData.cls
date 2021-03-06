/*
  Class Name: Core_CA_MyApprovalData
  Author : Mindtree
  Date: 10 May 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: This service class retrives the ariba and GTES Header detail and and the send the
                           Response as following wrapper
*/

global with sharing class Core_CA_MyApprovalData {
    
    /*******************************************************************************************************
    * @description this method create wrapper for the MyApproval homePage combining pending and closed approval.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_CA_WrapperUtility.MyApprovalsDataResponse wrapper
    */    
    public static String strSystemAriba=  'Ariba'; 
    public static String strSystemGtes=  'GTES';  
    public static String strSystemInvoice=  'Invoice'; 
    public static String strSystemClarity=  'Clarity'; 
    public static String strSystemClm=  'CLM'; 
    
    
    global static Core_CA_WrapperUtility.MyApprovalsDataResponse getMyApprovalsData(Core_CA_ApplicationWrapper appWrapperObj) {
        Core_CA_WrapperUtility.MyApprovalsDataResponse objMyApprovalsData = new Core_CA_WrapperUtility.MyApprovalsDataResponse();
        try{
            List<string> strFilterLabels = new List<string>{'Expense','Purchase Request'};
           // system.debug('@@@@@'+appWrapperObj);        
            objMyApprovalsData.statusCode= Core_CA_AppConstants.RESPONSE_SUCCESS_CODE;
            objMyApprovalsData.message= Core_CA_AppConstants.RESPONSE_SUCCESS_MSG;
            objMyApprovalsData.FilterLabels = strFilterLabels;
            if(appWrapperObj.myApprovalsDataRequest.ExpenseStatus.equalsIgnoreCase('All')){
                objMyApprovalsData.PendingApprovals = processPendingApprovals(appWrapperObj); 
                objMyApprovalsData.ClosedApprovals = processClosedApprovals(appWrapperObj);
            }
            else if(appWrapperObj.myApprovalsDataRequest.ExpenseStatus.equalsIgnoreCase('Pending')){
                objMyApprovalsData.PendingApprovals = processPendingApprovals(appWrapperObj); 
            }
            else if(appWrapperObj.myApprovalsDataRequest.ExpenseStatus.equalsIgnoreCase('Closed')){ 
                objMyApprovalsData.ClosedApprovals = processClosedApprovals(appWrapperObj);    
            }
                
        }
        //catch(Core_CA_BaseServiceException baseServEx){ throw new Core_CA_BaseServiceException(baseServEx);  }
        catch(Exception ex){throw new Core_CA_BaseServiceException('Exception occured: Core_CA_MyApprovalData : getMyApprovalsData method ', ex); }     
        
        return objMyApprovalsData;   
    }
    
    /*******************************************************************************************************
    * @description This method converts the pending approval into wrapper format.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_CA_WrapperUtility.PendingApprovals wrapper
    */  
    private static Core_CA_WrapperUtility.PendingApprovals processPendingApprovals(Core_CA_ApplicationWrapper appWrapperObj){
        Core_CA_WrapperUtility.PendingApprovals objPendingApproval = new Core_CA_WrapperUtility.PendingApprovals();
        try{
            Integer recordLimitToFetch = appWrapperObj.myApprovalsDataRequest.RecordsShownCount ;
            List<Core_Approver_Details__c> lstPendingApprovals = getPendingApprovals(recordLimitToFetch,appWrapperObj.myApprovalsDataRequest.ExpenseTypeSelected);
            List<Core_CA_WrapperUtility.ExpenseData> lstExpenseData = processExpenseData(lstPendingApprovals);
            objPendingApproval.ExpenseTypeSelected = appWrapperObj.myApprovalsDataRequest.ExpenseTypeSelected;
            objPendingApproval.ExpenseData = lstExpenseData;    
        }
        //catch(Core_CA_BaseServiceException baseServEx){ throw new Core_CA_BaseServiceException(baseServEx); }
        catch(Exception ex){ throw new Core_CA_BaseServiceException('Exception occured: Core_CA_MyApprovalData : processPendingApprovals method ', ex); }
        return objPendingApproval;
    }
    
    /*******************************************************************************************************
    * @description This method converts the closed approval into wrapper format.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_CA_WrapperUtility.ClosedApprovals wrapper
    */  
    private static Core_CA_WrapperUtility.ClosedApprovals processClosedApprovals(Core_CA_ApplicationWrapper appWrapperObj){ 
        Core_CA_WrapperUtility.ClosedApprovals objClosedApprovals = new Core_CA_WrapperUtility.ClosedApprovals(); 
        try{
            Integer recordLimitToFetch = appWrapperObj.myApprovalsDataRequest.RecordsShownCount ;
            List<Core_Approver_Details__c> lstClosedApprovals = getClosedApprovals(recordLimitToFetch,appWrapperObj.myApprovalsDataRequest.ExpenseTypeSelected);
            List<Core_CA_WrapperUtility.ExpenseData> lstExpenseData = processExpenseData(lstClosedApprovals); 
            objClosedApprovals.ExpenseTypeSelected = appWrapperObj.myApprovalsDataRequest.ExpenseTypeSelected;
            objClosedApprovals.ExpenseData = lstExpenseData;  
        }
        //catch(Core_CA_BaseServiceException baseServEx){ throw new Core_CA_BaseServiceException(baseServEx); }
        catch(Exception ex){ throw new Core_CA_BaseServiceException('Exception occured: Core_CA_MyApprovalData : processClosedApprovals method ', ex); }  
        return objClosedApprovals;
        
    }
    
    /*******************************************************************************************************
    * @description This method convert the Core_Approver_Details__c data into wrapper format.
    * @param list of Core_Approver_Details__c 
    * @return Core_CA_WrapperUtility.ExpenseData wrapper.
    */
    
     /* -- SONAR Issue explanation -- 
       This method retrieve the data from Approval console,Approval status and line item object and bind with the wrapper class fields
       and send to the UI. So multiple SOQL query and too many fields and multiple if condtions that is leading to Npath complexity. 
    */  
    private static List<Core_CA_WrapperUtility.ExpenseData> processExpenseData(List<Core_Approver_Details__c> lstApproverDetail){ 
        List<Core_CA_WrapperUtility.ExpenseData> lstExpenseData = new List<Core_CA_WrapperUtility.ExpenseData>();
        try{
            Core_CA_WrapperUtility.ExpenseData objExpensedata;
            Set<Id> setHeaderIds=new Set<Id>();
            for(Core_Approver_Details__c approver : lstApproverDetail){
                setHeaderIds.add(approver.Approval_Header__c);
            }
            Map<Id,Core_Approval_Header__c> mapHeaderRecord = new Map<Id,Core_Approval_Header__c>([Select Description__c,Total_amount__c,Title_Summary__c,Currency__c,External_System_Id__c,External_Created_Date__c,Requested_For_Details__c,Requested_by_details__c, TF_Currency__c,TF_Currency1__c,TF_Currency2__c,TF_Currency3__c,Name,Attachment__c,Category__c,Urgency__c,Net_Amount__c,Ariba_Company_Code__c  FROM Core_Approval_Header__c where Id in:setHeaderIds]);    
            for(Core_Approver_Details__c penddingExpense : lstApproverDetail){
                 objExpensedata = new Core_CA_WrapperUtility.ExpenseData();
                 
                 string Action = penddingExpense.Action__c;
                 string Status = penddingExpense.Status__c;
                 
                 if(Action == 'APPR' || (Status == 'Approved' && Action != 'REWO' && Action != 'APPR' && Action != 'REJC'))
                     objExpensedata.Req_Status ='APPR';
                 if((Action == 'REJC' && penddingExpense.Source_System__c!=strSystemInvoice)||(penddingExpense.Source_System__c!=strSystemInvoice && Status == 'Rejected' && Action != 'REWO' && Action != 'APPR' && Action != 'REJC' ))
                     objExpensedata.Req_Status ='REJC';
                 if(Action == 'REWO' || (Status == 'Rework' && Action != 'REWO' && Action != 'APPR' && Action != 'REJC'))
                     objExpensedata.Req_Status ='Rework';
                 if((Action == 'REJC' && penddingExpense.Source_System__c ==strSystemInvoice) || (Status == 'Return to AP' && penddingExpense.Source_System__c ==strSystemInvoice && Action != 'REWO' && Action != 'APPR' && Action != 'REJC'))
                     objExpensedata.Req_Status ='RETOAP';
                 if(Action == 'QUER' || Status == 'Query With Vendor')    
                     objExpensedata.Req_Status ='QUER';
                 
                 objExpensedata.ExpenseID = mapHeaderRecord.get(penddingExpense.Approval_Header__c).External_System_Id__c;                
                 objExpensedata.Amount = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Total_amount__c;
                 objExpensedata.ApproverId = penddingExpense.Id;
                 objExpensedata.RequestId = penddingExpense.Approval_Header__c;
                 objExpensedata.Status = penddingExpense.Status__c;
                 objExpensedata.Action=penddingExpense.Action__c;
                 objExpensedata.Currencies = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Currency__c;
                 if( mapHeaderRecord.get(penddingExpense.Approval_Header__c).External_Created_Date__c != null)
                    objExpensedata.Dates = mapHeaderRecord.get(penddingExpense.Approval_Header__c).External_Created_Date__c.format('dd/MM/yyyy');
                  
                 // Data binding for Ariba 
                 if(penddingExpense.Source_System__c == strSystemAriba){    
                     objExpensedata.ExpenseType = Core_CA_AppConstants.DATA_REQUEST_TYPE_ARIBA; 
                     objExpensedata.ExpenseName = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Description__c;     
                     objExpensedata.RequestedBy = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Requested_For_Details__c;                 
                 }
                 // Data binding for GTES
                 if(penddingExpense.Source_System__c == strSystemGtes){
                     objExpensedata.ExpenseType = Core_CA_AppConstants.DATA_REQUEST_TYPE_GTES; 
                     objExpensedata.ExpenseName = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Title_Summary__c;
                     objExpensedata.RequestedBy = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Requested_by_details__c; 
                     
                     string currency0 = mapHeaderRecord.get(penddingExpense.Approval_Header__c).TF_Currency__c;
                     string currency1 = mapHeaderRecord.get(penddingExpense.Approval_Header__c).TF_Currency1__c;
                     string currency2 = mapHeaderRecord.get(penddingExpense.Approval_Header__c).TF_Currency2__c;
                     string currency3 = mapHeaderRecord.get(penddingExpense.Approval_Header__c).TF_Currency3__c; 
                     
                     if(currency0 != '' || currency0 != null)                      
                         objExpensedata.Currencies = currency0;
                     if((currency0 == '' || currency0 == null) && (currency1 !='' && currency1 != null)) 
                         objExpensedata.Currencies  = currency1;
                     if((currency0 == '' || currency0 == null) && (currency1 == '' || currency1 == null) && (currency2 !='' && currency2 != null))   
                         objExpensedata.Currencies = currency2;
                     if((currency0 == '' || currency0 == null) && (currency1 == '' || currency1 == null) && (currency2 == '' || currency2 == null) && (currency3 !='' && currency3 != null))  
                         objExpensedata.Currencies = currency3;                   
                                
                 }
                 // Data binding for Clarity
                 if(penddingExpense.Source_System__c == strSystemClarity){    
                     objExpensedata.ExpenseType = strSystemClarity; 
                     objExpensedata.ExpenseName = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Attachment__c;     
                     objExpensedata.RequestedBy = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Requested_For_Details__c;                    
                     objExpensedata.ProjectBug = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Urgency__c;
                 }
                 // Data binding for Invoice
                 if(penddingExpense.Source_System__c==strSystemInvoice){
                     objExpensedata.ExpenseID = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Requested_For_Details__c;
                     objExpensedata.ExpenseType = strSystemInvoice; 
                     if(mapHeaderRecord.get(penddingExpense.Approval_Header__c).Category__c == 'INV')
                         objExpensedata.ExpenseName = 'Invoice'; 
                     if(mapHeaderRecord.get(penddingExpense.Approval_Header__c).Category__c == 'CN')
                         objExpensedata.ExpenseName = 'Credit Note';    
                     objExpensedata.RequestedBy = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Ariba_Company_Code__c;
                     objExpensedata.ProjectBug = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Urgency__c;                         
                 }
                 // Data binding for CLM
                 if(penddingExpense.Source_System__c==strSystemClm){
                     objExpensedata.ExpenseID = mapHeaderRecord.get(penddingExpense.Approval_Header__c).External_System_Id__c;
                     objExpensedata.ExpenseType = strSystemClm; 
                         objExpensedata.ExpenseName = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Category__c;
                     objExpensedata.RequestedBy = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Ariba_Company_Code__c;
                     objExpensedata.Amount = mapHeaderRecord.get(penddingExpense.Approval_Header__c).Net_Amount__c;                         
                 }
                 lstExpenseData.add(objExpensedata);         
             } 
             
         }
         //catch(Core_CA_BaseServiceException baseServEx){ throw new Core_CA_BaseServiceException(baseServEx); }
         catch(Exception ex){ throw new Core_CA_BaseServiceException('Exception occured: Core_CA_MyApprovalData : processClosedApprovals method ', ex);  }        
         return lstExpenseData;        
    }
    
    /*******************************************************************************************************
    * @description This method retrvies the expense those are recalled(cond:Role__c = 'EMP' and Action__c = 'CANC').
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return set header Id's those are recalled.
    */  
    private static Set<ID> getRecalledExpense(){            
       Set<Id> setRecalledExpenseID = new Set<Id>();
       try{
       List<Core_Approver_Details__c> lstRecalledExpenseID =[SELECT Approval_Header__c FROM Core_Approver_Details__c where  Role__c = 'EMP' AND Action__c = 'CANC' AND Source_System__c = :strSystemGtes];
       for(Core_Approver_Details__c id: lstRecalledExpenseID)
            setRecalledExpenseID.add(id.Approval_Header__c);
             
       }
       catch(Exception ex){ throw new Core_CA_BaseServiceException('Exception occured: Core_CA_MyApprovalData : getRecalledExpense method ', ex); }
       return setRecalledExpenseID;         
    }
    
   /*******************************************************************************************************
    * @description retrives the pending approvals for current logged in users.
    * @param number of records to be fetched, filter type 
    * @return list of Core_Approver_Details__c data
    */     
    private static List<Core_Approver_Details__c> getPendingApprovals(Integer recordFetchLimit, String ExpenseTye){
        Set<Id> recalledExpenseID = null;
        List<Core_Approver_Details__c>  lstPendingApprovals = null;
        List<Core_Approver_Details__c>  lstQueryWithVendor = null;
        try{            
            recalledExpenseID =  getRecalledExpense(); 
            //Retrive pending approval records.
            if(ExpenseTye.equalsIgnoreCase('All')){
                lstPendingApprovals=[SELECT Approval_Header__c,CreatedDate,Action__c,Header_ExternalId__c,Source_System__c,Status__c,TF_Header_Status__c,TF_Requestor_Name__c FROM Core_Approver_Details__c where Interested_Party__c=:UserInfo.getUserId() 
                                                       AND ( (Is_Active__c=: true and Source_System__c=: strSystemAriba AND Role__c = 'APP' AND Action__c != 'APPR' AND Action__c != 'REJC' AND Status__c !='Approved' AND Status__c!='Rejected' )
                                                              OR (Source_System__c=:strSystemGtes    AND Role__c = 'APP' AND Action__c = 'ACTV' AND Status__c !='Approved' AND Status__c!='Rejected' AND (Approval_Header__c not in :recalledExpenseID))
                                                              OR (Source_System__c=:'Clarity' AND Action__c = 'ACTV' AND Status__c !='Approved' AND Status__c!='Rejected' AND Status__c!='Rework'AND (Role__c = 'APP' OR Role__c = 'END')) 
                                                              OR (Source_System__c=:strSystemInvoice AND Action__c = 'ACTV' AND Status__c !='Approved' AND Status__c!='Return to AP' AND Status__c!='Query with Vendor' AND  Role__c = 'APP')
                                                              OR(Is_Active__c=: true and Source_System__c=: strSystemClm AND Action__c = 'ACTV' AND Action__c != 'APPR' AND Action__c != 'REJC' AND Status__c !='Approved' AND Status__c!='Rejected' ))  
                                                              ORDER BY TF_CreatedDate__c DESC];  
                                                              
                lstQueryWithVendor=[SELECT Approval_Header__c,CreatedDate,Action__c,Header_ExternalId__c,Source_System__c,Status__c,TF_Header_Status__c,TF_Requestor_Name__c FROM Core_Approver_Details__c where Interested_Party__c=:UserInfo.getUserId() 
                                    AND (Source_System__c=:strSystemInvoice AND (Action__c = 'QUER' OR Status__c ='Query with Vendor') AND Status__c !='Approved' AND Status__c!='Return to AP'  AND Role__c = 'APP') ORDER BY TF_CreatedDate__c DESC ];   
                lstPendingApprovals.addall(lstQueryWithVendor);                                                                                                           
            }
            else if(ExpenseTye.equalsIgnoreCase('PurchaseRequest')){
                lstPendingApprovals=[SELECT Approval_Header__c,CreatedDate,Action__c,Header_ExternalId__c,Source_System__c,Status__c,TF_Header_Status__c,TF_Requestor_Name__c FROM Core_Approver_Details__c where Interested_Party__c=:UserInfo.getUserId() 
                                                       AND Is_Active__c=: true and Source_System__c=: strSystemAriba AND Role__c = 'APP' AND Action__c != 'APPR' AND Action__c != 'REJC' AND Status__c !='Approved' AND Status__c!='Rejected'   
                                                              ORDER BY CreatedDate DESC];
            }
            else if(ExpenseTye.equalsIgnoreCase('Expense')){
                lstPendingApprovals=[SELECT Approval_Header__c,CreatedDate,Action__c,Header_ExternalId__c,Source_System__c,Status__c,TF_Header_Status__c,TF_Requestor_Name__c FROM Core_Approver_Details__c where Interested_Party__c=:UserInfo.getUserId() 
                                                       AND Source_System__c=:strSystemGtes AND Role__c = 'APP' AND Action__c = 'ACTV' AND Status__c !='Approved' AND Status__c!='Rejected' AND Approval_Header__c not in :recalledExpenseID   
                                                              ORDER BY CreatedDate DESC];
            }                                                                      
        }
        //catch(Core_CA_BaseServiceException baseServEx){  throw new Core_CA_BaseServiceException(baseServEx); }
        catch(Exception ex){ throw new Core_CA_BaseServiceException('Exception occured: Core_CA_MyApprovalData : getPendingApprovals method ', ex);}                                                  
        return lstPendingApprovals;                                                       
    }
    
      
   /*******************************************************************************************************
    * @description retrives the closed approvals for current logged in users.
    * @param number of records to be fetched, filter type 
    * @return list of Core_Approver_Details__c data
    */   
    private static List<Core_Approver_Details__c> getClosedApprovals (Integer recordFetchLimit, String ExpenseTye){
        Set<Id> setRecalledExpenseID = null;
        List<Core_Approver_Details__c>  lstClosedApprovals = null;
        try{            
            setRecalledExpenseID =  getRecalledExpense(); 
            //Retrive closed approval records.
            
            
            if(ExpenseTye.equalsIgnoreCase('All')){
                lstClosedApprovals =[SELECT Approval_Header__c,Action__c,CreatedDate,Header_ExternalId__c,Source_System__c,Status__c,TF_Header_Status__c,TF_Requestor_Name__c FROM Core_Approver_Details__c where Interested_Party__c=:UserInfo.getUserId() 
                                                        AND( (Role__c = 'APP' AND Source_System__c=:strSystemAriba AND (Action__c = 'APPR' OR Action__c = 'REJC' OR Status__c ='Approved' OR Status__c='Rejected')) OR
                                                              (Role__c = 'APP' AND Source_System__c=:strSystemGtes AND  (Action__c = 'APPR' OR Action__c = 'REJC' OR  Status__c ='Approved' OR Status__c='Rejected') AND (Approval_Header__c not in : setRecalledExpenseID) ) OR
                                                              (Source_System__c=:'Clarity' AND (Role__c = 'APP' OR Role__c = 'END' ) AND (Action__c = 'APPR' OR Action__c = 'REJC' OR Action__c = 'REWO' OR Status__c ='Approved' OR Status__c='Rejected' OR Status__c='Rework'))OR
                                                              (Source_System__c=:strSystemInvoice AND Role__c = 'APP' AND (Status__c ='Approved' OR Status__c='Return to AP'))OR
                                                              (Source_System__c=: strSystemClm AND (Action__c = 'APPR' OR Action__c = 'REJC' OR Status__c ='Approved' OR Status__c='Rejected')))
                                                              ORDER BY LastModifiedDate DESC ];
            }
            else if(ExpenseTye.equalsIgnoreCase('PurchaseRequest')){
                lstClosedApprovals =[SELECT Approval_Header__c,Action__c,CreatedDate,Header_ExternalId__c,Source_System__c,Status__c,TF_Header_Status__c,TF_Requestor_Name__c FROM Core_Approver_Details__c where Interested_Party__c=:UserInfo.getUserId() 
                                                        AND  Role__c = 'APP' AND Source_System__c=:strSystemAriba AND (Action__c = 'APPR' OR Action__c = 'REJC' OR Status__c ='Approved' OR Status__c='Rejected')
                                                         ORDER BY LastModifiedDate DESC limit : Integer.valueof(CORE_Chatter_Approval_MobileApp__c.getinstance('InitialLoad').Value__c) ];
            }
            else if(ExpenseTye.equalsIgnoreCase('Expense')){
                lstClosedApprovals =[SELECT Approval_Header__c,Action__c,CreatedDate,Header_ExternalId__c,Source_System__c,Status__c,TF_Header_Status__c,TF_Requestor_Name__c FROM Core_Approver_Details__c where Interested_Party__c=:UserInfo.getUserId() 
                                                        AND Role__c = 'APP' AND Source_System__c=:strSystemGtes AND  (Action__c = 'APPR' OR Action__c = 'REJC' OR  Status__c ='Approved' OR Status__c='Rejected') AND (Approval_Header__c not in : setRecalledExpenseID) 
                                                         ORDER BY LastModifiedDate DESC limit : Integer.valueof(CORE_Chatter_Approval_MobileApp__c.getinstance('InitialLoad').Value__c) ];
            }
        }
        //catch(Core_CA_BaseServiceException baseServEx){ throw new Core_CA_BaseServiceException(baseServEx); }
        catch(Exception ex){ throw new Core_CA_BaseServiceException('Exception occured: Core_CA_MyApprovalData : getClosedApprovals method ', ex); }  
        return lstClosedApprovals;                                                       
   } 
   
}