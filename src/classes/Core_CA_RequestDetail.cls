/*
  Class Name: Core_CA_RequestDetail
  Author : Mindtree
  Date: 10 May 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: This service class retrives the ariba and GTES Header detail and and the send the
                           Response as following wrapper
*/

global with sharing class Core_CA_RequestDetail{
    
    /*******************************************************************************************************
    * @description This method get the wrapper data and send to the baseService application.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_CA_WrapperUtility.RequestDetailResponseAribaGTES wrapper
    */  
    
     public static String strInvoiceSystem=  'Invoice'; 
     public static String strMessage=  'Exception occured: Core_CA_MyApprovalData : getPreTripDetails method ';
    
    global static Core_CA_WrapperUtility.RequestDetailResponseAribaGTES getRequestDetail(Core_CA_ApplicationWrapper appWrapperObj) {
       Core_CA_WrapperUtility.RequestDetailResponseAribaGTES objRequestDetailResponseAribaGTES = new Core_CA_WrapperUtility.RequestDetailResponseAribaGTES(); 
       try{
            List<Core_Approval_Header__Share> lstHeaderShare = [SELECT Id FROM Core_Approval_Header__Share WHERE ParentId = : appWrapperObj.expenseDetailRequest.RequestId];
            
            if(!lstHeaderShare.isEmpty()){
                system.debug('##### test inside not empty');
                Map<Id,Core_Approver_Details__c> mapApprover = new Map<Id,Core_Approver_Details__c> ([SELECT id FROM Core_Approver_Details__c WHERE Approval_Header__c  =: appWrapperObj.expenseDetailRequest.RequestId]); 
                
                if(mapApprover.containsKey(appWrapperObj.expenseDetailRequest.ApproverId)){ 
                    List<Core_Approver_Details__c> approver = [select Interested_Party__c from Core_Approver_Details__c where Id =: appWrapperObj.expenseDetailRequest.ApproverId ];    
                    
                    if(approver[0].Interested_Party__c  ==  UserInfo.getUserId()){ system.debug('##### test inside approver');
                        objRequestDetailResponseAribaGTES = processReqDetailResponseAribaGTES(appWrapperObj.expenseDetailRequest.RequestId,appWrapperObj.expenseDetailRequest.ApproverId);
                    }
                    
                    if(approver[0].Interested_Party__c  !=  UserInfo.getUserId()){   system.debug('##### test inside non approver');                              
                        PermissionSet perSet = [SELECT Id FROM PermissionSet WHERE Name = 'CoreCAAdminUser'];
                        List<PermissionSetAssignment> lstPerSetAsgn =[SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId() AND PermissionSetId =: perSet.Id];
                        
                        List<Core_Approver_Details__c> lstApprover = [SELECT Id FROM Core_Approver_Details__c WHERE Approval_Header__c =: appWrapperObj.expenseDetailRequest.RequestId and Interested_Party__c  =: UserInfo.getUserId() and ((Source_System__c = 'Ariba' and Is_Active__c= true) or Source_System__c = 'GTES') ORDER BY CreatedDate ASC];                                          
                        if(!lstApprover.isEmpty()) {
                            objRequestDetailResponseAribaGTES = processReqDetailResponseAribaGTES(appWrapperObj.expenseDetailRequest.RequestId,lstApprover[0].Id);
                        }
                        else if(!lstPerSetAsgn.isEmpty()) {
                            objRequestDetailResponseAribaGTES = processReqDetailResponseAribaGTES(appWrapperObj.expenseDetailRequest.RequestId,appWrapperObj.expenseDetailRequest.RequestId);
                            objRequestDetailResponseAribaGTES.hasPermSet = true;
                        }
                    }                        
                }
                
                else{          
                    List<Core_Approver_Details__c> lstApprover = [SELECT Id FROM Core_Approver_Details__c WHERE Approval_Header__c =: appWrapperObj.expenseDetailRequest.RequestId and Interested_Party__c  =: UserInfo.getUserId() and ((Source_System__c = 'Ariba' and Is_Active__c= true) or Source_System__c = 'GTES') ORDER BY CreatedDate ASC];                                                         
                    PermissionSet perSet = [SELECT Id FROM PermissionSet WHERE Name = 'CoreCAAdminUser'];
                    List<PermissionSetAssignment> lstPerSetAsgn =[SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId() AND PermissionSetId =: perSet.Id];
                    if(!lstApprover.isEmpty()) {
                        objRequestDetailResponseAribaGTES = processReqDetailResponseAribaGTES(appWrapperObj.expenseDetailRequest.RequestId,lstApprover[0].Id);                                        
                    }
                    else if(!lstPerSetAsgn.isEmpty()) {
                        objRequestDetailResponseAribaGTES = processReqDetailResponseAribaGTES(appWrapperObj.expenseDetailRequest.RequestId,appWrapperObj.expenseDetailRequest.RequestId);
                        objRequestDetailResponseAribaGTES.hasPermSet = true;
                    }  
                }
                
            }
            else{system.debug('##### test inside empty');
                objRequestDetailResponseAribaGTES.accessStatus = false;
                objRequestDetailResponseAribaGTES.StatusCode = Core_CA_AppConstants.RESPONSE_SUCCESS_CODE;
                objRequestDetailResponseAribaGTES.Message = Core_CA_AppConstants.RESPONSE_SUCCESS_MSG;
            }
            
       }
       /*catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }*/
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: CoreCA_REST_GetHeaderDetails : getRequestDetail method ', ex);
       }    
      
       system.debug('##### test inside empty'+objRequestDetailResponseAribaGTES);
        return objRequestDetailResponseAribaGTES;
    }
      
    /*******************************************************************************************************
    * @description This method get hedaer detail and convert it into wrapper format.
    * @param Core_Approval_Header__c Id 
    * @return Core_CA_WrapperUtility.RequestDetailResponseAribaGTES wrapper
    */
    private static Core_CA_WrapperUtility.RequestDetailResponseAribaGTES processReqDetailResponseAribaGTES(String HeaderId, string ApproverId){
       Core_CA_WrapperUtility.RequestDetailResponseAribaGTES objRequestDetailResponseAribaGTES = new Core_CA_WrapperUtility.RequestDetailResponseAribaGTES();
       try{
           Core_Approval_Header__c objApprovalHeader = getApprovalHeader(HeaderId) ;
           
           objRequestDetailResponseAribaGTES.StatusCode = Core_CA_AppConstants.RESPONSE_SUCCESS_CODE;
           objRequestDetailResponseAribaGTES.Message = Core_CA_AppConstants.RESPONSE_SUCCESS_MSG;
           objRequestDetailResponseAribaGTES.accessStatus = true;
           objRequestDetailResponseAribaGTES.RequestId= objApprovalHeader.Id;
           objRequestDetailResponseAribaGTES.ApproverId=ApproverId;
           objRequestDetailResponseAribaGTES.RequestName = objApprovalHeader.External_System_Id__c;
           objRequestDetailResponseAribaGTES.Currencies= objApprovalHeader.Currency__c;
           objRequestDetailResponseAribaGTES.RequestedBy= objApprovalHeader.Requested_By_Details__c;
           objRequestDetailResponseAribaGTES.PreparedBy= objApprovalHeader.Requested_For_Details__c;
           objRequestDetailResponseAribaGTES.TotalAmount= objApprovalHeader.Total_amount__c;
           objRequestDetailResponseAribaGTES.Description = objApprovalHeader.Description__c;
           objRequestDetailResponseAribaGTES.ReportName= objApprovalHeader.Title_Summary__c;
           objRequestDetailResponseAribaGTES.AdvanceAmount=objApprovalHeader.Advance_Amount__c;
           objRequestDetailResponseAribaGTES.Reason=objApprovalHeader.Reason__c;
           objRequestDetailResponseAribaGTES.NetAmount=objApprovalHeader.Net_Amount__c;
           objRequestDetailResponseAribaGTES.NonReimbursable=objApprovalHeader.Non_Reimbursable_Amount__c;
           objRequestDetailResponseAribaGTES.CompanyName= objApprovalHeader.Ariba_Company_Code__c;
           objRequestDetailResponseAribaGTES.Purpose=objApprovalHeader.Purpose__c;
           objRequestDetailResponseAribaGTES.approvalhistory= processApprovalHistory(HeaderId,objApprovalHeader.Source_System__c);
           
           if(objApprovalHeader.Source_System__c == strInvoiceSystem)
               objRequestDetailResponseAribaGTES.url = '/apex/Core_CA_InvoiceChatterFeedPage?id='+objApprovalHeader.Id;
           else
               objRequestDetailResponseAribaGTES.url = '/apex/Core_CA_ChatterFeedPage?id='+objApprovalHeader.Id;
           if(!getCurrentApproverDetails(ApproverId).isEmpty()){
               objRequestDetailResponseAribaGTES.IsActive=string.valueof(getCurrentApproverDetails(ApproverId)[0].Is_Active__c);
               objRequestDetailResponseAribaGTES.ApproverStatus=getCurrentApproverDetails(ApproverId)[0].Status__c;
               objRequestDetailResponseAribaGTES.ApproverAction=getCurrentApproverDetails(ApproverId)[0].Action__c;
           } 
           
           /* Clarity App : Data binding starts*/
           if(objApprovalHeader.Source_System__c == 'Clarity'){
                objRequestDetailResponseAribaGTES.RequestType = 'Clarity';  
                objRequestDetailResponseAribaGTES.ProjectName = objApprovalHeader.Attachment__c;
                objRequestDetailResponseAribaGTES.ApprovalType = objApprovalHeader.Category__c;
                objRequestDetailResponseAribaGTES.StrategicInt = objApprovalHeader.Delegatee__c; 
                objRequestDetailResponseAribaGTES.ChargeTo =objApprovalHeader.Charge_To__c;
                objRequestDetailResponseAribaGTES.comments= objApprovalHeader.Comment__c;  
                objRequestDetailResponseAribaGTES.CompanyCode = objApprovalHeader.Impact__c;                
                objRequestDetailResponseAribaGTES.Capex = objApprovalHeader.Policy_Exception__c;
                objRequestDetailResponseAribaGTES.AmountToCompany = objApprovalHeader.Total_Budget__c;
                objRequestDetailResponseAribaGTES.Currentyear1 = objApprovalHeader.Priority__c;
                objRequestDetailResponseAribaGTES.Toatl2 = objApprovalHeader.Requestor_Employee_No__c;
                objRequestDetailResponseAribaGTES.ProjectBug = objApprovalHeader.Urgency__c;
                objRequestDetailResponseAribaGTES.YearAllOther = objApprovalHeader.All_years__c;
                //objRequestDetailResponseAribaGTES.Trade = objApprovalHeader.Amount_to_Employee__c;
                //objRequestDetailResponseAribaGTES.Restructuring = objApprovalHeader.PreTrip_Id__c;
                //objRequestDetailResponseAribaGTES.ProposedBugTotal = objApprovalHeader.Amount_to_Card__c;
                //objRequestDetailResponseAribaGTES.YearAllOther = objApprovalHeader.Other_Amount__c;
                //objRequestDetailResponseAribaGTES.ProjectFinanceTotal = objApprovalHeader.Reminder_Alert_Days__c;
                objRequestDetailResponseAribaGTES.Cop = objApprovalHeader.Invalid_PR_Reason__c;
                objRequestDetailResponseAribaGTES.Metric = objApprovalHeader.Requested_By_Language__c;
                objRequestDetailResponseAribaGTES.RequestedByLang = objApprovalHeader.Requested_For_Language__c;
                objRequestDetailResponseAribaGTES.AppType = objApprovalHeader.Approval_Type__c;
                
                
                Core_CA_WrapperUtility.PreTripDetails objPreTripDetails = new Core_CA_WrapperUtility.PreTripDetails();
                objPreTripDetails.Id= objApprovalHeader.PreTrip_Id__c;
                objPreTripDetails.LocationDetails= objApprovalHeader.PreTrip_Location_Details__c;
                objPreTripDetails.PassengerInfo= objApprovalHeader.PreTrip_Passenger_Info__c;                
                objRequestDetailResponseAribaGTES.pretripdetails= objPreTripDetails;
                
                objRequestDetailResponseAribaGTES.ApproverCnt =0;
                objRequestDetailResponseAribaGTES.EndorserCnt =0;
                List<Core_Approver_Details__c> lstApproverDetails = getApproverDetails(HeaderId,objApprovalHeader.Source_System__c);         
                for(Core_Approver_Details__c Approver:lstApproverDetails){
                    if(Approver.Role__c == 'END') objRequestDetailResponseAribaGTES.ApproverCnt = objRequestDetailResponseAribaGTES.ApproverCnt+1;
                     if(Approver.Role__c == 'APP') objRequestDetailResponseAribaGTES.EndorserCnt = objRequestDetailResponseAribaGTES.EndorserCnt+1;
                }    

           }           
           /* Clarity App : Data binding Ends*/
           
           /* Invoice App : Data binding starts*/
          else if(objApprovalHeader.Source_System__c == strInvoiceSystem){
                objRequestDetailResponseAribaGTES.RequestType =  strInvoiceSystem;
                objRequestDetailResponseAribaGTES.InvoiceType = objApprovalHeader.Category__c;
                objRequestDetailResponseAribaGTES.Cop = objApprovalHeader.Invalid_PR_Reason__c;
                
                Core_CA_WrapperUtility.PreTripDetails objPreTripDetails = new Core_CA_WrapperUtility.PreTripDetails();
                objPreTripDetails.Id= objApprovalHeader.PreTrip_Id__c;               
                objRequestDetailResponseAribaGTES.pretripdetails= objPreTripDetails;
                
                if(objApprovalHeader.External_Created_Date__c != null){
                    objRequestDetailResponseAribaGTES.CreatedOn = objApprovalHeader.External_Created_Date__c.format('dd/MM/yyyy');
                }
                objRequestDetailResponseAribaGTES.lineitems= processLineItemDetails(HeaderId);
                objRequestDetailResponseAribaGTES.CompanyCode = objApprovalHeader.Impact__c;
                
                
                
                
           }
           /* Invoice App : Data binding end*/  
           
           /* MyApproval App : Data binding starts*/
           else if(objApprovalHeader.Source_System__c == 'Ariba'|| objApprovalHeader.Source_System__c == 'GTES'){
               Core_CA_WrapperUtility.PreTripDetails objPreTripDetails = new Core_CA_WrapperUtility.PreTripDetails();
               objPreTripDetails.Id= objApprovalHeader.PreTrip_Id__c;
               objPreTripDetails.PassengerInfo= objApprovalHeader.PreTrip_Passenger_Info__c;
               objPreTripDetails.LocationDetails= objApprovalHeader.PreTrip_Location_Details__c;
               objRequestDetailResponseAribaGTES.RequestStatus = objApprovalHeader.Status__c;              
               if(objApprovalHeader.Source_System__c == 'Ariba')   
                objRequestDetailResponseAribaGTES.RequestType = Core_CA_AppConstants.DATA_REQUEST_TYPE_ARIBA;                    
               if(objApprovalHeader.Source_System__c == 'GTES')
                objRequestDetailResponseAribaGTES.RequestType = Core_CA_AppConstants.DATA_REQUEST_TYPE_GTES;           
               if(objApprovalHeader.External_Created_Date__c != null){
                    objRequestDetailResponseAribaGTES.CreatedOn = objApprovalHeader.External_Created_Date__c.format('dd-MM-yyyy');
               }           
               objRequestDetailResponseAribaGTES.Days= objApprovalHeader.Days__c;
               objRequestDetailResponseAribaGTES.ChargeTo=objApprovalHeader.Charge_To__c;         
               objRequestDetailResponseAribaGTES.ClaimExceptions= objApprovalHeader.Policy_Exception__c;             
               objRequestDetailResponseAribaGTES.pretripdetails= objPreTripDetails;
               objRequestDetailResponseAribaGTES.lineitems= processLineItemDetails(HeaderId);
               objRequestDetailResponseAribaGTES.comments= objApprovalHeader.Comment__c;       
               List<Core_Approver_Details__c> lstApprover = [SELECT Id FROM Core_Approver_Details__c WHERE Approval_Header__c =: HeaderId and Source_System__c = 'GTES' and Role__c ='EMP' and Action__c='CANC'];
               if(!lstApprover.isEmpty())
                    objRequestDetailResponseAribaGTES.isRecalled = true;   
        }   
        /* MyApproval App : Data binding ends*/
       }
       /*catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
       }*/
       catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_CA_MyApprovalData : getMyApprovalsData method ', ex);
       }   
       
       return objRequestDetailResponseAribaGTES;
    }
           
    
    /*******************************************************************************************************
    * @description This method get LineItem detail and convert it into wrapper format.
    * @param Core_Approval_Header__c Id  
    * @return Core_CA_WrapperUtility.LineItems wrapper
    */
    private static List<Core_CA_WrapperUtility.LineItems> processLineItemDetails(string HeaderId){
        List<Core_CA_WrapperUtility.LineItems> lstLineItems =new List<Core_CA_WrapperUtility.LineItems>();
        try{
            List<Core_Approval_Details__c> lstApprovalDetails = getApprovalDetails(HeaderId) ;
            Core_CA_WrapperUtility.LineItems objlineItem;
            for(Core_Approval_Details__c lineitem : lstApprovalDetails){
               objlineItem =new Core_CA_WrapperUtility.LineItems();
               objlineItem.LineItemId = lineitem.Id;
               objlineItem.Amount= lineitem.Amount__c;
               objlineItem.Currencies = lineitem.Currency__c;
               if(lineitem.Source_System__c == 'Ariba' || lineitem.Source_System__c == strInvoiceSystem ){
                objlineItem.ItemName= lineitem.Description__c;}
               else if(lineitem.Source_System__c == 'GTES'){ 
               objlineItem.ItemName= lineitem.Name;}              
               lstLineItems.add(objlineItem);
           }
        }  
        catch(Exception ex){
            throw new Core_CA_BaseServiceException(strMessage, ex);
        } 
       return lstLineItems;
    }
    
    /*******************************************************************************************************
    * @description This method get Approval history and convert it into wrapper format.
    * @param Core_Approval_Header__c Id  
    * @return Core_CA_WrapperUtility.ApprovalHistory wrapper
    */
    private static List<Core_CA_WrapperUtility.ApprovalHistory> processApprovalHistory(string HeaderId,string sourceSystem){
       List<Core_CA_WrapperUtility.ApprovalHistory> lstApprovalHistory = new List<Core_CA_WrapperUtility.ApprovalHistory>();
       try{
           List<Core_Approver_Details__c> lstApproverDetails = getApproverDetails(HeaderId,sourceSystem);
           Core_CA_WrapperUtility.ApprovalHistory objApprovalHistory;    
           for(Core_Approver_Details__c Approver:lstApproverDetails){
               objApprovalHistory =new Core_CA_WrapperUtility.ApprovalHistory();
               objApprovalHistory.ApproverName = Approver.Interested_Party_Details__c;
               objApprovalHistory.AribaRole = Approver.Ariba_Role__c;
               if(Approver.Source_System__c == 'Clarity' ){
               if(Approver.LastModifiedDate!=null)
                   objApprovalHistory.ApprovedDate = Approver.LastModifiedDate.format('dd-MM-yyyy') ;
                   objApprovalHistory.Comment = Approver.Comments__c; 
                   objApprovalHistory.Role = Approver.Role__c;   
               }
               if(Approver.Source_System__c == strInvoiceSystem ){
               if(Approver.TF_CreatedDate__c!= null)
                   objApprovalHistory.ApprovedDate = Approver.TF_CreatedDate__c.format('dd MMM yyyy') ;
                   objApprovalHistory.Comment = Approver.Comments__c;    
               } 
               if(Approver.CA_Action__c == 'Approved')
                    objApprovalHistory.ApproverAction = Approver.CA_Action__c;
               else if(Approver.CA_Action__c == 'Returned') 
                    objApprovalHistory.ApproverAction = 'Rejected';
               else if(Approver.CA_Action__c == 'Rework')   
                    objApprovalHistory.ApproverAction = Approver.CA_Action__c; 
                  
               lstApprovalHistory.add(objApprovalHistory);
           }
       } 
       catch(Exception ex){
            throw new Core_CA_BaseServiceException(strMessage, ex);
       }   
       return lstApprovalHistory;
    }
   /*******************************************************************************************************
    * @description this method retrives the header detail for the given header Id.
    * @param Core_Approval_Header__c Id  
    * @return list of Core_Approval_Header__c
    */   
   private static Core_Approval_Header__c getApprovalHeader(string HeaderId){
       Core_Approval_Header__c objApprovalHeader = null;
       try{
           objApprovalHeader = [SELECT Advance_Amount__c,Description__c,Comment__c,Charge_To__c,External_System_Id__c,CreatedDate,Currency__c,Days__c,Id,Net_Amount__c,Non_Reimbursable_Amount__c,
                                PreTrip_Id__c,PreTrip_Location_Details__c,PreTrip_Passenger_Info__c,Purpose__c,Invalid_PR__c,Ariba_Company_Code__c,Title_Summary__c,Impact__c,
                                External_Created_Date__c,Reason__c,Requested_By_Details__c,Requested_For_Details__c,Status__c,Total_amount__c,Source_System__c,Delegatee__c,Amount_to_Employee__c,
                                Amount_Paid_Card__c,Amount_to_Card__c,Other_Amount__c,Reminder_Alert_Days__c,Invalid_PR_Reason__c,Requested_By_Language__c,Category__c,Amount_to_Company__c,
                                Requested_For_Language__c,Attachment__c,Policy_Exception__c,Total_Budget__c,Priority__c,Requestor_Employee_No__c,Urgency__c,All_years__c,Approval_Type__c FROM Core_Approval_Header__c WHERE Id =: HeaderId ];
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException(strMessage, ex);
       } 
       
       return objApprovalHeader; 
   }
   
   /*******************************************************************************************************
    * @description this method retrives the all line items detail for the given header Id.
    * @param Core_Approval_Header__c Id  
    * @return list of Core_Approval_Details__c
    */
   private static List<Core_Approval_Details__c> getApprovalDetails(string HeaderId){
       List<Core_Approval_Details__c> lstApprovalDetails = null;
       try{
           lstApprovalDetails =[SELECT Amount__c,Name,Id,Currency__c,Description__c,Source_System__c,Line_Item_Number__c,Air_Fare_Details__c,Allowance_Details__c,Attachment__c,Attendees_Details__c
                                FROM Core_Approval_Details__c WHERE Approval_Header__c =: HeaderId ORDER BY Line_Item_Number__c ASC];
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException(strMessage, ex);
       } 
       
       return lstApprovalDetails; 
   }
   
   /*******************************************************************************************************
    * @description this method retrives the all approver details for the given header Id.
    * @param Core_Approval_Header__c Id  
    * @return list of Core_Approver_Details__c
    */
   private static List<Core_Approver_Details__c> getApproverDetails(string HeaderId,string sourceSystem){
       List<Core_Approver_Details__c> lstApproverDetails = null;
       try{
           if(sourceSystem == 'Ariba')
               lstApproverDetails =[SELECT CA_Action__c,Interested_Party_Details__c,Status__c,Ariba_Role__c,Action__c,Source_System__c  FROM Core_Approver_Details__c WHERE Approval_Header__c =: HeaderId AND Role__c = 'APP' AND (Action__c = 'APPR' OR Action__c = 'REJC' OR  Status__c ='Approved' OR Status__c='Rejected') ORDER BY Sort_Order__c ASC];
           if(sourceSystem == 'GTES')
               lstApproverDetails =[SELECT CA_Action__c,Interested_Party_Details__c,Status__c,Ariba_Role__c,Action__c,Source_System__c  FROM Core_Approver_Details__c WHERE Approval_Header__c =: HeaderId AND Role__c = 'APP' AND (Action__c = 'APPR' OR Action__c = 'REJC' OR  Status__c ='Approved' OR Status__c='Rejected')];
           /* Clarity App : retrive approval detail starts */
           if(sourceSystem == 'Clarity')
               lstApproverDetails =[SELECT CA_Action__c,Interested_Party_Details__c,Status__c,Role__c,Ariba_Role__c,Action__c,LastModifiedDate,Comments__c,Source_System__c FROM Core_Approver_Details__c WHERE Approval_Header__c =: HeaderId AND (Role__c = 'APP' OR Role__c = 'END') AND (Action__c = 'APPR' OR Action__c = 'REJC' OR Action__c = 'REWO' OR Status__c ='Approved' OR Status__c='Rejected' OR Status__c='Rework' ) ORDER BY LastModifiedDate DESC ];
           /* Clarity App : retrive approval detail ends */
           if(sourceSystem ==  strInvoiceSystem)
               lstApproverDetails =[SELECT CA_Action__c,Interested_Party_Details__c,Status__c,Ariba_Role__c,Action__c,Source_System__c,TF_CreatedDate__c,Comments__c  FROM Core_Approver_Details__c WHERE Approval_Header__c =: HeaderId ORDER BY TF_CreatedDate__c DESC ];
           /* Clarity App : retrive approval detail ends */
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException(strMessage, ex);
       } 
       
       return lstApproverDetails; 
   }
   
   private static List<Core_Approver_Details__c> getCurrentApproverDetails(string ApproverId){
       List<Core_Approver_Details__c> lstApproverDetails = null;
       try{
               lstApproverDetails =[SELECT Status__c,Is_Active__c,Action__c FROM Core_Approver_Details__c WHERE Id =: ApproverId limit 1];
       }
       catch(Exception ex){
            throw new Core_CA_BaseServiceException(strMessage, ex);
       } 
       
       return lstApproverDetails; 
   }
}