global with sharing class Core_CA_ApproveRejectAction {
    
    global static Core_CA_WrapperUtility.MyApprovalPostResponse postApproveRejectAction(Core_CA_ApplicationWrapper appWrapperObj) {
        Core_CA_WrapperUtility.MyApprovalPostResponse objPostResponse=new Core_CA_WrapperUtility.MyApprovalPostResponse();
        Boolean Success;
        try{
            Success = UpdateApproveRejectAction(appWrapperObj);
            objPostResponse=processResponseApproveRejectAction(appWrapperObj);
           // system.debug('%%%%'+appWrapperObj);
        }
        catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
        }
        catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_CA_ApproveRejectAction : postApproveRejectAction method ', ex);
        }
        return objPostResponse;
    }
    
    /*global static Core_CA_WrapperUtility.approveRejectValidtaion validateApproveRejectAction (Id approverId){
        Core_CA_WrapperUtility.approveRejectValidtaion objapproveRejectValidtaion = new Core_CA_WrapperUtility.approveRejectValidtaion();
        try{
            Core_Approver_Details__c objApprover = [SELECT Interested_Party__c,Id,Approval_Header__c,Status__c,Source_System__c,Role__c,Is_Active__c,Action__c  FROM Core_Approver_Details__c where id=: approverId];   
            system.debug('entered method'+approverId);
            if(objApprover.Source_System__c == 'Ariba'){
                if(objApprover.Is_Active__c == false)
                    objapproveRejectValidtaion.Message = CORE_Chatter_Approval__c.getinstance('AppRejAribaMessage').Text_Value__c;
                if(objApprover.Status__c == 'Approved')
                    objapproveRejectValidtaion.Message = CORE_Chatter_Approval__c.getinstance('AppRejAlreadyStatus').Text_Value__c;
            }
            else
            if(objApprover.Source_System__c == 'GTES'){
                if(objApprover.Status__c == 'Approved' || objApprover.Status__c == 'Rejected')
                    objapproveRejectValidtaion.Message = CORE_Chatter_Approval__c.getinstance('AppRejAlreadyStatus').Text_Value__c;
            }       
        }
        catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
        }
        catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_CA_ApproveRejectAction : validateApproveRejectAction method ', ex);
        }
        return objapproveRejectValidtaion;
    }*/
    
    global static Boolean UpdateApproveRejectAction(Core_CA_ApplicationWrapper appWrapperObj){
        Boolean Success;
        try{
            Core_Approver_Details__c approver=[SELECT Action__c,Comments__c,Interested_Party__c,Role__c,Source_System__c,Status__c,Visible_to_Supplier__c FROM Core_Approver_Details__c WHERE Id=: appWrapperObj.myApprovalPostRequest.ApproverId];
            if(appWrapperObj.myApprovalPostRequest.UpdateFunctionType=='Approve'){
                approver.Status__c='Approved';
                approver.Comments__c=appWrapperObj.myApprovalPostRequest.CommentDesc;
                approver.Send_to_Source_System__c = 'Yes';
                if(approver.Source_System__c=='Ariba') approver.Visible_to_Supplier__c = Boolean.valueof(appWrapperObj.myApprovalPostRequest.CommentVisibleToUser);
                    update approver;
            }
            else if(appWrapperObj.myApprovalPostRequest.UpdateFunctionType=='Reject'){ 
                approver.Status__c='Rejected';
                approver.Comments__c=appWrapperObj.myApprovalPostRequest.CommentDesc;
                approver.Send_to_Source_System__c = 'Yes';
                update approver;
            }
            Success=True;
        }
        catch(DmlException  ex){
           // system.debug('^^^^'+ex);
            throw new Core_CA_BaseServiceException('Prashanth...',ex);
        }
        catch(Exception ex){
            //system.debug('$$$$'+ex);
            throw new Core_CA_BaseServiceException('Exception occured: Core_CA_ApproveRejectAction : UpdateApproveRejectAction method ', ex);
        }
        return Success;
    }
    
    
    global static Core_CA_WrapperUtility.MyApprovalPostResponse processResponseApproveRejectAction(Core_CA_ApplicationWrapper appWrapperObj){
        Core_CA_WrapperUtility.MyApprovalPostResponse objPostResponse=new Core_CA_WrapperUtility.MyApprovalPostResponse();
        try{
            Core_CA_ApplicationWrapper objAppWrapper=new Core_CA_ApplicationWrapper();
        
            Core_CA_WrapperUtility.MyApprovalsDataRequest objMyApprovalsDataRequest = new Core_CA_WrapperUtility.MyApprovalsDataRequest ();
            objMyApprovalsDataRequest.ExpenseStatus = Core_CA_AppConstants.Expense_Status_Type;
            objMyApprovalsDataRequest.ExpenseTypeSelected = Core_CA_AppConstants.Expense_Status_Type;
            objMyApprovalsDataRequest.RecordsShownCount = Core_CA_AppConstants.RecordsShownCount; 
            
            objAppWrapper.myApprovalsDataRequest=objMyApprovalsDataRequest;
            
            objPostResponse.message=Core_CA_AppConstants.RESPONSE_SUCCESS_MSG;
            objPostResponse.statusCode=Core_CA_AppConstants.RESPONSE_SUCCESS_CODE;
            //objPostResponse.MyApprovalsDataResponse=Core_CA_MyApprovalData.getMyApprovalsData(objAppWrapper);
            objPostResponse.UpdateFunctionType=appWrapperObj.myApprovalPostRequest.UpdateFunctionType;
            objPostResponse.UpdatedBy=Userinfo.getuserId();//appWrapperObj.myApprovalPostRequest.UpdatedBy; 
        }
        catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
        }
        catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_CA_ApproveRejectAction : processResponseApproveRejectAction method ', ex);
        }
        return objPostResponse;
    } 
}