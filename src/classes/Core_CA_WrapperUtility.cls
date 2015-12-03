/*
  Class Name: Core_CA_WrapperUtility
  Author : Mindtree
  Date: 11 May 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Wrapper class for classes
                           1.Core_CA_LineItemDetail
                           2.
                           3. 
*/


global with sharing class Core_CA_WrapperUtility { 
    /**** wrapper classes for MyApproval Home page starts ****/
    
    /*************************************************************************
    * Wrapper class for MyApprovalsData
    **************************************************************************/
    
    global class MyApprovalsDataResponse extends Core_CA_BaseApplicationWrapper{
        public PendingApprovals PendingApprovals ;
        public ClosedApprovals ClosedApprovals;
        public String UpdateFunctionType;
        public list<string> FilterLabels;
    }
    
    global class MyApprovalsDataRequest{
        public String ExpenseStatus;
        public Integer RecordsShownCount;
        public String ExpenseTypeSelected;
        
    }
    
    public class PendingApprovals{
        public string ExpenseTypeSelected;
        public List<ExpenseData> ExpenseData;
    }
    
    public class ClosedApprovals{
        public string ExpenseTypeSelected;
        public List<ExpenseData> ExpenseData;
    }
          
    public class ExpenseData{
        public String ExpenseName;
        public String ExpenseType;
        public String Dates;
        public String ExpenseID;
        public String RequestedBy;
        public Decimal Amount;
        public String Currencies;
        public String Status;
        public String ApproverId;
        public String RequestId;
        public String Action;
    }
    /**** wrapper classes for MyApproval Home page ends **** /
    
    
    /**** wrapper classes for Request detail page starts ****/
    
    /*************************************************************************
    * Wrapper class for GetExpenseDataResponseJSON-GTESARIBA
    **************************************************************************/ 
    global class RequestDetailResponseAribaGTES extends Core_CA_BaseApplicationWrapper{
        public Boolean accessStatus; 
        public String RequestId;
        public String ApproverId;
        public String RequestName;
        public string RequestType;
        public string url;
        public Decimal TotalAmount;
        public String Currencies;
        public String Description;
        public String RequestStatus;
        public String RequestedBy;       
        public String PreparedBy;
        public String CompanyName;
        public String CreatedOn;
        public String ReportName;        
        public Decimal AdvanceAmount;
        public Decimal NetAmount;
        public Decimal NonReimbursable;
        public Decimal Days;
        public String ChargeTo;
        public String Purpose;
        public String Reason;
        public String ClaimExceptions; 
        public String IsActive;
        public String ApproverStatus;
        public string ApproverAction;
        public PreTripDetails PreTripDetails;
        public List<LineItems> LineItems;//= new List<LineItems>() 
        public String Comments;
        public List<ApprovalHistory> ApprovalHistory;//= new List<ApprovalHistory>()
        public Boolean isRecalled; 
        public Boolean hasPermSet;
        //public Boolean isinvalid; 
        
    } 
    
    global class ExpenseDetailsDataRequest{
        public String RequestId;        
        public String ApproverId;
        
    }
     
     public class LineItems{
        public String ItemName;
        public Decimal Amount;
        public string LineItemId;
        public string Currencies;
    }
    
    public class ApprovalHistory{
        public String ApproverName;
        public String ApproverAction;
        public String AribaRole;
    }
    
    public class PreTripDetails{
        public String Id;
        public String PassengerInfo;
        public String LocationDetails;
    }
    /**** wrapper classes for Request detail page ends **** /
    
    
    /**** wrapper classes for Line Item detail page starts ****/
    
    /*************************************************************************
    * Wrapper class for LineItemDetail Response for Ariba
    **************************************************************************/
    global class LineItemDetailResponseAriba extends Core_CA_BaseApplicationWrapper {
        public string RequestId;
        public String ProductDesc;  
        public PricingSuplierDetails PricingSuplierDetails ;
        public string SplitAccountingDetails;
        public string Comments;     
    }
    
    /*************************************************************************
    * Wrapper class for LineItemDetail Response for GTES
    **************************************************************************/
    global class LineItemDetailResponseGTES extends Core_CA_BaseApplicationWrapper{
        public string RequestId;
        public ExpenseDetails ExpenseDetails;
        public String Purpose;
        public String Reason;
        public String ExpenseDescription;
        public TravelDetails TravelDetails;
        public Decimal PerDiemAmount;
        public String PerDiemDetails;
        public String PolicyExceptions;
        public String Comments;
        public String Attendees;
        public Boolean IsPerDiem;
    }
    
    public class PricingSuplierDetails{
        public Integer Quantity;
        public String OrderUnit;
        public Decimal Price;
        public String Currencies;
        public Decimal Amount;
        public String Commodity;
        public String SupplierName;
        public String SupplierERPId;
        public String TaxCodeRate;
        public String SAPMaterialNumber;
    }
    
    public class ExpenseDetails{
        public String ExpenseType;
        public Decimal Amount;
        public String Currencies;
        public String ChargeTo;
        public String PaymentType;
        public String City;
        public String Country;
        public String ExpenseDate;
        public String EndDate;
        public String Reimbursable;
        public String Receipt;
    }
    
    public class TravelDetails{
        public String CarDetails;
        public String FlightDetails;
        public String RoomDetails;
    }
    
    /*************************************************************************
    * Wrapper class for LineItemDetail Request for Ariba/GTES
    **************************************************************************/
    global class LineItemDetailRequest {
        public string RequestType;
        public String LineItemID;
     }
    
    /**** wrapper classes for Line Item detail page ends **** /
    
   
   /**** wrapper classes for Approve/Reject action validation page strats *****/
   /*global class approveRejectValidtaion extends Core_CA_BaseApplicationWrapper{
        public string Message;
        public Boolean gdah;
   }*/
   
   
  /**** wrapper classes for Approve/Reject action validation page strats **** /
     
    
    /*************************************************************************
    * Wrapper class for MyApprovalPostRequest
    **************************************************************************/ 
    global class MyApprovalPostRequest{
        /*public string ExpenseType;
        public string ExpenseRequestId;
        public string ExpenseRecordId;
        public string UpdatedBy;*/
        public string UpdateFunctionType;
        public string CommentDesc;
        public string CommentVisibleToUser;
        public string ApproverId;
    }
    
    /*************************************************************************
    * Wrapper class for MyApprovalPostResponse
    **************************************************************************/
    global class MyApprovalPostResponse extends Core_CA_BaseApplicationWrapper{
        public String UpdatedBy;
        public String UpdateFunctionType;
        //public MyApprovalsDataResponse MyApprovalsDataResponse;
    }
       
    public class Comments{
        public String CommentsBy;
        public String Dates;
        public String Comments;
        public string CommentsUserId;
    }
    
       
    /*
    public class SplitAccountingDetails{
        public Integer SplitNumber;
        public Integer TotalCost;
        public String Currencies;
    }*/
    
   
}