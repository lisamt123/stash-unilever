public class Core_CA_ApprovalsController {

    @AuraEnabled
    public static Core_CA_WrapperUtility.MyApprovalsDataResponse getApprovalHomeScreenData() {
                  
        Core_CA_WrapperUtility.MyApprovalsDataRequest wrapperHomeScreen = new Core_CA_WrapperUtility.MyApprovalsDataRequest();
        wrapperHomeScreen.ExpenseStatus = 'All';
        wrapperHomeScreen.RecordsShownCount =10 ;
        wrapperHomeScreen.ExpenseTypeSelected = 'All'; 
        
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();
        appWrapperObj.myApprovalsDataRequest = wrapperHomeScreen;
        system.debug('@@@@@@@@@data3'+Core_CA_MyApprovalData.getMyApprovalsData(appWrapperObj));
        return Core_CA_MyApprovalData.getMyApprovalsData(appWrapperObj);
    } 
    
    @AuraEnabled
    public static Core_CA_WrapperUtility.RequestDetailResponseAribaGTES getApprovalDetailPageData(String RequestId,String ApproverId) {
                  
        Core_CA_WrapperUtility.ExpenseDetailsDataRequest wrapperDetailScreen= new Core_CA_WrapperUtility.ExpenseDetailsDataRequest();
        wrapperDetailScreen.RequestId = RequestId;
        wrapperDetailScreen.ApproverId = ApproverId;
        
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();
        appWrapperObj.expenseDetailRequest = wrapperDetailScreen;
        
        System.debug('@@@@@@ values'+Core_CA_RequestDetail.getRequestDetail(appWrapperObj));
        return Core_CA_RequestDetail.getRequestDetail(appWrapperObj);
    }
    
    @AuraEnabled
    public static Core_CA_WrapperUtility.LineItemDetailResponseAriba getAribaLineItemDetailPageData(String LineItemID) {
                  
        Core_CA_WrapperUtility.LineItemDetailRequest wrapperLineItem = new Core_CA_WrapperUtility.LineItemDetailRequest ();
        wrapperLineItem.LineItemID= LineItemID;
              
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();
        appWrapperObj.lineItemDetailRequest = wrapperLineItem ;
        
        //System.debug('@@@@@@ values'+Core_CA_RequestDetail.getRequestDetail(appWrapperObj));
        return Core_CA_LineItemDetail.getLineItemDetailAriba(appWrapperObj);
    }
    
    @AuraEnabled
    public static Core_CA_WrapperUtility.LineItemDetailResponseGTES getGTESLineItemDetailPageData(String LineItemID) {
                  
        Core_CA_WrapperUtility.LineItemDetailRequest wrapperLineItem = new Core_CA_WrapperUtility.LineItemDetailRequest ();
        wrapperLineItem.LineItemID= LineItemID;
        
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();
        appWrapperObj.lineItemDetailRequest = wrapperLineItem ;
        
        //System.debug('@@@@@@ values'+Core_CA_RequestDetail.getRequestDetail(appWrapperObj));
        return Core_CA_LineItemDetail.getLineItemDetailGTES(appWrapperObj);
    }
    
    @AuraEnabled
    public static Core_CA_WrapperUtility.LineItemDetailResponseInvoice getInvoiceLineItemDetail(String LineItemID) {
                  
        Core_CA_WrapperUtility.LineItemDetailRequest wrapperLineItem = new Core_CA_WrapperUtility.LineItemDetailRequest ();
        wrapperLineItem.LineItemID= LineItemID;
        
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();
        appWrapperObj.lineItemDetailRequest = wrapperLineItem ;
        
        //System.debug('@@@@@@ values'+Core_CA_RequestDetail.getRequestDetail(appWrapperObj));
        return Core_CA_LineItemDetail.getLineItemDetailInvoice(appWrapperObj);
    }
    
    @AuraEnabled
    public static Boolean updateApprovalAction (String action,String comment,String isVisibletoSupplier,String ApproverId) {
        Boolean success= true;          
        Core_CA_WrapperUtility.MyApprovalPostRequest wrapperPostReq = new Core_CA_WrapperUtility.MyApprovalPostRequest();
        wrapperPostReq.UpdateFunctionType = action;
        wrapperPostReq.CommentDesc = comment;
        wrapperPostReq.CommentVisibleToUser = isVisibletoSupplier ;
        wrapperPostReq.ApproverId = ApproverId;
        
        Core_CA_ApplicationWrapper appWrapperObj = new Core_CA_ApplicationWrapper();
        appWrapperObj.MyApprovalPostRequest = wrapperPostReq ;
        
        Core_CA_WrapperUtility.MyApprovalPostResponse objResponse = Core_CA_ApproveRejectAction.postApproveRejectAction(appWrapperObj);
        return success; 
    }
    
    @AuraEnabled
    public static String getUserLanguage() {
    return userinfo.getLanguage();
    }
    
    @AuraEnabled
    public static boolean findFeedbacks(String appName) {
        return CORE_FB_Feedback_App_Controller.findFeedbacks(appName);
    }
    
    @AuraEnabled
    public static boolean insertFeedback(String appName,Integer rating,String comment) {
        return CORE_FB_Feedback_App_Controller.insertFeedback(appName,rating,comment);
    }
    
   @AuraEnabled
    public static string getGAID(){      
        string strgaid = CORE_CA_ApprovalReporting__c.getinstance('GA_ID').Text_Value__c;
        return strgaid;      
    }
    
    
    @AuraEnabled
    public static String getUIThemeDescription() {
        String themedesc = 'Salesforce1 Mobile';
        String theme = UserInfo.getUiThemeDisplayed();
        if(theme=='Theme3' || theme=='Theme2'){
            themedesc='Salesforce Classic';
        }else if(theme=='Theme4d'){
            themedesc='Lightning Experience';
        }else if(theme=='Theme4t'){
            themedesc='Salesforce1 Mobile';
        }
        return themedesc;   
   }
   
}