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

/* -- SONAR Issue explanation -- 
       This Wrapper class is Used to send the the data to the UI.For the entire App single wrapper is been used and 
       and multiple fields are declared. Thats leading to the Sonar issues.  
*/
    
global with sharing class Core_CA_WrapperUtility { 
    /**** wrapper classes for MyApproval Home page starts ****/
    
    /*************************************************************************
    * Wrapper class for MyApprovalsData
    **************************************************************************/
    
    global class MyApprovalsDataResponse extends Core_CA_BaseApplicationWrapper{
        @AuraEnabled
        public PendingApprovals PendingApprovals ;
        @AuraEnabled
        public ClosedApprovals ClosedApprovals;
        @AuraEnabled
        public String UpdateFunctionType;
        @AuraEnabled
        public list<string> FilterLabels;
    }
    
    global class MyApprovalsDataRequest{
        @AuraEnabled
        public String ExpenseStatus;
        @AuraEnabled
        public Integer RecordsShownCount;
        @AuraEnabled
        public String ExpenseTypeSelected;
        
    }
    
    public class PendingApprovals{
        @AuraEnabled
        public string ExpenseTypeSelected;
        @AuraEnabled
        public List<ExpenseData> ExpenseData;
    }
    
    public class ClosedApprovals{
        @AuraEnabled
        public string ExpenseTypeSelected;
        @AuraEnabled
        public List<ExpenseData> ExpenseData;
    }
          
    public class ExpenseData{
        @AuraEnabled
        public String ExpenseName;
        @AuraEnabled
        public String ExpenseType;
        @AuraEnabled
        public String Dates;
        @AuraEnabled
        public String ExpenseID;
        @AuraEnabled
        public String RequestedBy;
        @AuraEnabled
        public Decimal Amount;
        @AuraEnabled
        public String Currencies;
        @AuraEnabled
        public String Status;
        @AuraEnabled
        public String ApproverId;
        @AuraEnabled
        public String RequestId;
        @AuraEnabled
        public String Action;
        @AuraEnabled
        public string ProjectBug;
        @AuraEnabled
        public string Req_Status;
    }
    /**** wrapper classes for MyApproval Home page ends **** /
    
    
    /**** wrapper classes for Request detail page starts ****/
    
    /*************************************************************************
    * Wrapper class for GetExpenseDataResponseJSON-GTESARIBA
    **************************************************************************/ 
    global class RequestDetailResponseAribaGTES extends Core_CA_BaseApplicationWrapper{
        @AuraEnabled
        public Boolean accessStatus;
        @AuraEnabled 
        public String RequestId;
        @AuraEnabled
        public String ApproverId;
        @AuraEnabled
        public String RequestName;
        @AuraEnabled
        public string RequestType;
        @AuraEnabled
        public string url;
        @AuraEnabled
        public Decimal TotalAmount;
        @AuraEnabled
        public String Currencies;
        @AuraEnabled
        public String Description;
        @AuraEnabled
        public String RequestStatus;
        @AuraEnabled
        public String RequestedBy;
        @AuraEnabled       
        public String PreparedBy;
        @AuraEnabled
        public String CompanyName;
        @AuraEnabled
        public String CreatedOn;
        @AuraEnabled
        public String ReportName;
        @AuraEnabled        
        public Decimal AdvanceAmount;
        @AuraEnabled
        public Decimal NetAmount;
        @AuraEnabled
        public Decimal NonReimbursable;
        @AuraEnabled
        public Decimal Days;
        @AuraEnabled
        public String ChargeTo;
        @AuraEnabled
        public String Purpose;
        @AuraEnabled
        public String Reason;
        @AuraEnabled
        public String ClaimExceptions; 
        @AuraEnabled
        public String IsActive;
        @AuraEnabled
        public String ApproverStatus;
        @AuraEnabled
        public string ApproverAction;
        @AuraEnabled
        public PreTripDetails PreTripDetails;
        @AuraEnabled
        public List<LineItems> LineItems;//= new List<LineItems>() 
        @AuraEnabled
        public String Comments;
        @AuraEnabled
        public List<ApprovalHistory> ApprovalHistory;//= new List<ApprovalHistory>()
        @AuraEnabled
        public Boolean isRecalled;
        @AuraEnabled 
        public Boolean hasPermSet;
        //public Boolean isinvalid; 
        //Clarity wrapper data 
        @AuraEnabled
        public string ApprovalType;
        @AuraEnabled       
        public string StrategicInt;
        @AuraEnabled
        public String Capex;
        @AuraEnabled
        public String AmountToCompany;
        @AuraEnabled
        public string Currentyear1;
        @AuraEnabled
        public string Toatl2;
        @AuraEnabled
        public string ProjectBug;
        @AuraEnabled
        public String Cop;
        @AuraEnabled
        public String Metric;
        @AuraEnabled
        public String RequestedByLang;
        @AuraEnabled
        public Decimal ApproverCnt;
        @AuraEnabled
        public Decimal EndorserCnt;
        @AuraEnabled
        public String ProjectName;
        @AuraEnabled 
        public String YearAllOther;
        @AuraEnabled
        public String AppType;
        //Invoice wrapper data 
        @AuraEnabled     
        public String InvoiceType; 
        @AuraEnabled
        public String CompanyCode;
    } 
    
    global class ExpenseDetailsDataRequest{
        @AuraEnabled
        public String RequestId;
        @AuraEnabled        
        public String ApproverId;
        
    }
     
     public class LineItems{
        @AuraEnabled
        public String ItemName;
        @AuraEnabled
        public Decimal Amount;
        @AuraEnabled
        public string LineItemId;
        @AuraEnabled
        public string Currencies;
        @AuraEnabled
        public string NetAmount;
    }
    
    public class ApprovalHistory{
        @AuraEnabled
        public String ApproverName;
        @AuraEnabled
        public String ApproverAction;
        @AuraEnabled
        public String AribaRole;
        @AuraEnabled
        Public String ApprovedDate; 
        @AuraEnabled   
        Public String Comment;
        @AuraEnabled
        Public String Role;
    }
    
    public class PreTripDetails{
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String PassengerInfo;
        @AuraEnabled
        public String LocationDetails;
    } 
    
    /**** wrapper classes for Request detail page ends **** /
    
    
    /**** wrapper classes for Line Item detail page starts ****/
    
    /*************************************************************************
    * Wrapper class for LineItemDetail Response for Ariba
    **************************************************************************/
    global class LineItemDetailResponseAriba extends Core_CA_BaseApplicationWrapper {
        @AuraEnabled
        public string RequestId;
        @AuraEnabled
        public String ProductDesc;
        @AuraEnabled  
        public PricingSuplierDetails PricingSuplierDetails ;
        @AuraEnabled
        public string SplitAccountingDetails;
        @AuraEnabled
        public string Comments;     
    }
    
    /*************************************************************************
    * Wrapper class for LineItemDetail Response for GTES
    **************************************************************************/
    global class LineItemDetailResponseGTES extends Core_CA_BaseApplicationWrapper{
        @AuraEnabled
        public string RequestId;
        @AuraEnabled
        public ExpenseDetails ExpenseDetails;
        @AuraEnabled
        public String Purpose;
        @AuraEnabled
        public String Reason;
        @AuraEnabled
        public String ExpenseDescription;
        @AuraEnabled
        public TravelDetails TravelDetails;
        @AuraEnabled
        public Decimal PerDiemAmount;
        @AuraEnabled
        public String PerDiemDetails;
        @AuraEnabled
        public String PolicyExceptions;
        @AuraEnabled
        public String Comments;
        @AuraEnabled
        public String Attendees;
        @AuraEnabled
        public Boolean IsPerDiem;
    }
    
    /*************************************************************************
    * Wrapper class for LineItemDetail Response for Invoice
    **************************************************************************/
    global class LineItemDetailResponseInvoice extends Core_CA_BaseApplicationWrapper{
        @AuraEnabled
        public string RequestName;
        @AuraEnabled
        public string IntOrder;
        @AuraEnabled
        public string GLAccount;
        @AuraEnabled
        public string NetAmnt;
        @AuraEnabled
        public string CstCntr;
        @AuraEnabled
        public string ProfitCntr;
        @AuraEnabled
        public string Description;
        @AuraEnabled
        public string Currencies;
    }
    
    public class PricingSuplierDetails{
        @AuraEnabled
        public Integer Quantity;
        @AuraEnabled
        public String OrderUnit;
        @AuraEnabled
        public Decimal Price;
        @AuraEnabled
        public String Currencies;
        @AuraEnabled
        public Decimal Amount;
        @AuraEnabled
        public String Commodity;
        @AuraEnabled
        public String SupplierName;
        @AuraEnabled
        public String SupplierERPId;
        @AuraEnabled
        public String TaxCodeRate;
        @AuraEnabled
        public String SAPMaterialNumber;
    }
    
    public class ExpenseDetails{
        @AuraEnabled
        public String ExpenseType;
        @AuraEnabled
        public Decimal Amount;
        @AuraEnabled
        public String Currencies;
        @AuraEnabled
        public String ChargeTo;
        @AuraEnabled
        public String PaymentType;
        @AuraEnabled
        public String City;
        @AuraEnabled
        public String Country;
        @AuraEnabled
        public String ExpenseDate;
        @AuraEnabled
        public String EndDate;
        @AuraEnabled
        public String Reimbursable;
        @AuraEnabled
        public String Receipt;
    }
    
    public class TravelDetails{
        @AuraEnabled
        public String CarDetails;
        @AuraEnabled
        public String FlightDetails;
        @AuraEnabled
        public String RoomDetails;
    }
    
    /*************************************************************************
    * Wrapper class for LineItemDetail Request for Ariba/GTES
    **************************************************************************/
    global class LineItemDetailRequest {
        @AuraEnabled
        public string RequestType;
        @AuraEnabled
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
        @AuraEnabled
        public string UpdateFunctionType;
        @AuraEnabled
        public string CommentDesc;
        @AuraEnabled
        public string CommentVisibleToUser;
        @AuraEnabled
        public string ApproverId;
    }
    
    /*************************************************************************
    * Wrapper class for MyApprovalPostResponse
    **************************************************************************/
    global class MyApprovalPostResponse extends Core_CA_BaseApplicationWrapper{
        @AuraEnabled
        public String UpdatedBy;
        @AuraEnabled
        public String UpdateFunctionType;
        //public MyApprovalsDataResponse MyApprovalsDataResponse;
    }
       
    public class Comments{
        @AuraEnabled
        public String CommentsBy;
        @AuraEnabled
        public String Dates;
        @AuraEnabled
        public String Comments;
        @AuraEnabled
        public string CommentsUserId;
    }
    
       
    /*
    public class SplitAccountingDetails{
        public Integer SplitNumber;
        public Integer TotalCost;
        public String Currencies;
    }*/
    
   
}