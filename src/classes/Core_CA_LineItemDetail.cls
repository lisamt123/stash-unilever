/*
  Class Name: Core_CA_LineItemDetail
  Author : Mindtree
  Date: 11 May 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: This service class retrives the the Line item detail and and the send the
                           Response as following wrapper
                           for Ariba - Core_CA_WrapperUtility.LineItemDetailResponseAriba
                               GTES  - Core_CA_WrapperUtility.LineItemDetailResponseGTES.     
*/

global with sharing class Core_CA_LineItemDetail {
    
    /*******************************************************************************************************
    * @description This method get LineItem detail for Ariba and convert it into wrapper format.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_CA_WrapperUtility.LineItemDetailResponseAriba wrapper
    */ 
    global static Core_CA_WrapperUtility.LineItemDetailResponseAriba getLineItemDetailAriba(Core_CA_ApplicationWrapper appWrapperObj) {
        
        Core_CA_WrapperUtility.LineItemDetailResponseAriba objLineItemDetailResponseAriba = new Core_CA_WrapperUtility.LineItemDetailResponseAriba();
        try{
            string LineItemId = string.valueof(appWrapperObj.lineItemDetailRequest.LineItemID);
            //system.debug('######'+LineItemId);
            Core_Approval_Details__c objApprovalDetails = getLineItemdetail(LineItemID);
            //system.debug('@@@@@@@'+objApprovalDetails);          
            Core_Approval_Header__c objApprovalHeader = [SELECT External_System_Id__c FROM Core_Approval_Header__c WHERE Id =: objApprovalDetails.Approval_Header__c ];
            
            // PricingSuplierDetails details
            Core_CA_WrapperUtility.PricingSuplierDetails objPricingSuplierDetails = new Core_CA_WrapperUtility.PricingSuplierDetails();            
            if(objApprovalDetails.Quantity__c != null)
                objPricingSuplierDetails.Quantity = Integer.valueof(objApprovalDetails.Quantity__c);
            objPricingSuplierDetails.OrderUnit = objApprovalDetails.Unit_of_Measure__c;
            objPricingSuplierDetails.Price =  objApprovalDetails.Price__c;
            objPricingSuplierDetails.Currencies = objApprovalDetails.Currency__c;
            objPricingSuplierDetails.Amount = objApprovalDetails.Amount__c;
            objPricingSuplierDetails.Commodity = objApprovalDetails.Commodity_Code__c;
            objPricingSuplierDetails.SupplierName = objApprovalDetails.Supplier_Name__c;
            objPricingSuplierDetails.SupplierERPId = objApprovalDetails.Supplier_ERP_ID__c;
            objPricingSuplierDetails.TaxCodeRate = objApprovalDetails.Tax_Code__c; 
            objPricingSuplierDetails.SAPMaterialNumber = objApprovalDetails.SAPMaterialMaster__c;
                    
            //processing LineItemDetailResponseAriba wrapper 
            objLineItemDetailResponseAriba.StatusCode = Core_CA_AppConstants.RESPONSE_SUCCESS_CODE ;
            objLineItemDetailResponseAriba.Message = Core_CA_AppConstants.RESPONSE_SUCCESS_MSG;
            objLineItemDetailResponseAriba.RequestId = objApprovalHeader.External_System_Id__c;
            objLineItemDetailResponseAriba.ProductDesc = objApprovalDetails.Description__c; 
            objLineItemDetailResponseAriba.PricingSuplierDetails = objPricingSuplierDetails;
            objLineItemDetailResponseAriba.SplitAccountingDetails = objApprovalDetails.Split_Accounting_Details__c;
            objLineItemDetailResponseAriba.Comments = objApprovalDetails.Expense_Comments__c ;                         
        }
        /*catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
        }*/
        catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_CA_LineItemDetail : getLineItemDetailAriba method ', ex);
        }     
     
        return objLineItemDetailResponseAriba;
    }
    
    
    /*******************************************************************************************************
    * @description This method get LineItem detail for GTES and convert it into wrapper format.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_CA_WrapperUtility.LineItemDetailResponseGTES wrapper
    */
    global static Core_CA_WrapperUtility.LineItemDetailResponseGTES getLineItemDetailGTES(Core_CA_ApplicationWrapper appWrapperObj) {
        Core_CA_WrapperUtility.LineItemDetailResponseGTES objLineItemDetailResponseGTES = new Core_CA_WrapperUtility.LineItemDetailResponseGTES();
        try{ 
            
            //system.debug('@@@@@hdsjfhdkjsahfkjdsa'+appWrapperObj); 
            string LineItemId = appWrapperObj.lineItemDetailRequest.LineItemID;
            //system.debug('@@@@@hdsjfhdkjsahfkjdsa'+LineItemId);
            Core_Approval_Details__c objApprovalDetails = getLineItemdetail(LineItemID); 
            Core_Approval_Header__c objApprovalHeader = [SELECT External_System_Id__c FROM Core_Approval_Header__c WHERE Id =: objApprovalDetails.Approval_Header__c ];
            
            //ExpenseDetails details
            Core_CA_WrapperUtility.ExpenseDetails objExpenseDetails = new Core_CA_WrapperUtility.ExpenseDetails ();
            objExpenseDetails.ExpenseType = objApprovalDetails.Name; 
            objExpenseDetails.Amount = objApprovalDetails.Amount__c; 
            objExpenseDetails.Currencies = objApprovalDetails.Currency__c; 
            objExpenseDetails.ChargeTo = objApprovalDetails.Charge_To__c; 
            objExpenseDetails.PaymentType = objApprovalDetails.CA_Payment_Type__c; 
            objExpenseDetails.City = objApprovalDetails.City__c; 
            objExpenseDetails.Country = objApprovalDetails.Expense_Country__c ;
            if(objApprovalDetails.Expense_Date__c != null){
                objExpenseDetails.ExpenseDate=objApprovalDetails.Expense_Date__c.format('dd-MM-yyyy');
            } 
            if(objApprovalDetails.End_Date__c != null){
                objExpenseDetails.EndDate =objApprovalDetails.End_Date__c.format('dd-MM-yyyy');
            }    
           
            if(objApprovalDetails.Reimbursable__c)
                objExpenseDetails.Reimbursable = 'Yes';
            else
                objExpenseDetails.Reimbursable = 'No';
            if(objApprovalDetails.Receipt__c)
                objExpenseDetails.Receipt = 'Yes';
            else
                objExpenseDetails.Receipt = 'No';   
                        
            //TravelDetails details
            Core_CA_WrapperUtility.TravelDetails objTravelDetails = new Core_CA_WrapperUtility.TravelDetails ();
            objTravelDetails.CarDetails = objApprovalDetails.Car_Details__c; 
            objTravelDetails.FlightDetails = objApprovalDetails.Air_Fare_Details__c; 
            objTravelDetails.RoomDetails = objApprovalDetails.Room_Details__c; 
             
            //processing LineItemDetailResponseGTES wrapper  
            objLineItemDetailResponseGTES.StatusCode = Core_CA_AppConstants.RESPONSE_SUCCESS_CODE;
            objLineItemDetailResponseGTES.Message = Core_CA_AppConstants.RESPONSE_SUCCESS_MSG;
            objLineItemDetailResponseGTES.Purpose = objApprovalDetails.Purpose__c;
            objLineItemDetailResponseGTES.Reason = objApprovalDetails.Reason__c ;
            objLineItemDetailResponseGTES.ExpenseDescription = objApprovalDetails.Description__c;
            objLineItemDetailResponseGTES.PerDiemAmount = objApprovalDetails.Per_Diem_Amount__c;
            objLineItemDetailResponseGTES.PerDiemDetails = objApprovalDetails.Per_Diem_Details__c;
            objLineItemDetailResponseGTES.RequestId = objApprovalHeader.External_System_Id__c;
            objLineItemDetailResponseGTES.PolicyExceptions = objApprovalDetails.Policy_Exceptions__c;
            objLineItemDetailResponseGTES.ExpenseDetails = objExpenseDetails;
            objLineItemDetailResponseGTES.TravelDetails = objTravelDetails;
            objLineItemDetailResponseGTES.Comments = objApprovalDetails.Expense_Comments__c;
            objLineItemDetailResponseGTES.Attendees= objApprovalDetails.Attendees_Details__c; 
            
            objLineItemDetailResponseGTES.IsPerDiem = false;
            if(objApprovalDetails.Expense_Code__c == 'PDX' || objApprovalDetails.Expense_Code__c == 'PDX2' || objApprovalDetails.Expense_Code__c == 'PDAZ' || 
               objApprovalDetails.Expense_Code__c == 'PDXNO5' || objApprovalDetails.Expense_Code__c == 'PDXNO4' || objApprovalDetails.Expense_Code__c == 'PDXNO3' ||
               objApprovalDetails.Expense_Code__c == 'PDXNO2' || objApprovalDetails.Expense_Code__c == 'PDXNO1' || objApprovalDetails.Expense_Code__c == 'PDXDOM' ||
               objApprovalDetails.Expense_Code__c == 'PDXINT'){
                   objLineItemDetailResponseGTES.IsPerDiem = true; 
            }
            
        }
        /*catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
        }*/
        catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_CA_LineItemDetail : getLineItemDetailGTES method ', ex);
        }     
             
        return objLineItemDetailResponseGTES;
    }
      
    /*******************************************************************************************************
    * @description This method get LineItem detail for Invoice and convert it into wrapper format.
    * @param Core_CA_ApplicationWrapper wrapper 
    * @return Core_CA_WrapperUtility.LineItemDetailResponseInvoice  wrapper
    */
    global static Core_CA_WrapperUtility.LineItemDetailResponseInvoice  getLineItemDetailInvoice(Core_CA_ApplicationWrapper appWrapperObj) {
        Core_CA_WrapperUtility.LineItemDetailResponseInvoice objLineItemDetailResponseInvoice = new Core_CA_WrapperUtility.LineItemDetailResponseInvoice();
        try{ 
            string LineItemId = appWrapperObj.lineItemDetailRequest.LineItemID;
            Core_Approval_Details__c objApprovalDetails = getLineItemdetail(LineItemID); 
            Core_Approval_Header__c objApprovalHeader = [SELECT External_System_Id__c FROM Core_Approval_Header__c WHERE Id =: objApprovalDetails.Approval_Header__c ];
               
            objLineItemDetailResponseInvoice.RequestName =objApprovalHeader.External_System_Id__c;
            objLineItemDetailResponseInvoice.IntOrder =objApprovalDetails.Air_Fare_Details__c;
            objLineItemDetailResponseInvoice.GLAccount =objApprovalDetails.Allowance_Details__c;
            objLineItemDetailResponseInvoice.NetAmnt =objApprovalDetails.Amount__c;
            objLineItemDetailResponseInvoice.CstCntr =objApprovalDetails.Attachment__c;
            objLineItemDetailResponseInvoice.ProfitCntr =objApprovalDetails.Attendees_Details__c;
            objLineItemDetailResponseInvoice.Description =objApprovalDetails.Description__c;
            objLineItemDetailResponseInvoice.Currencies =objApprovalDetails.Currency__c;         
        }
        /*catch(Core_CA_BaseServiceException baseServEx){ 
            throw new Core_CA_BaseServiceException(baseServEx);
        }*/
        catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_CA_LineItemDetail : getLineItemDetailGTES method ', ex);
        }     
             
        return objLineItemDetailResponseInvoice;
    }
     
    /*******************************************************************************************************
    * @description retrive required Line Item detail for the id passed in parameter.
    * @param Core_Approval_Details__c.id
    * @return Core_Approval_Details__c
    */
    private static Core_Approval_Details__c getLineItemdetail(String LineItemId) {
     
        Core_Approval_Details__c objApprovalDetails = new Core_Approval_Details__c();
        try{
        objApprovalDetails = [SELECT Name,Approval_Header__c,Amount__c,Commodity_Code__c,Currency__c,Charge_To__c,CA_Payment_Type__c,City__c,Description__c,Price__c, Quantity__c,SAPMaterialMaster__c,
                             Expense_Country__c,Split_Accounting_Details__c,Supplier_ERP_ID__c,Supplier_Name__c,Tax_Code__c,Unit_of_Measure__c,Allowance_Details__c,Attachment__c,
                             Air_Fare_Details__c,Attendees_Details__c,Car_Details__c,End_Date__c,Expense_Date__c,Expense_Comments__c,Per_Diem_Amount__c,
                             Per_Diem_Details__c,Policy_Exceptions__c,Purpose__c,Reason__c,Receipt__c,Reimbursable__c,Room_Details__c,Expense_Code__c  
                             FROM Core_Approval_Details__c WHERE Id =: LineItemId ];
        //System.debug('@@@@@@@'+objApprovalDetails);   
        }
        catch(Exception ex){
            throw new Core_CA_BaseServiceException('Exception occured: Core_CA_LineItemDetail : getLineItemdetail method', ex);
        }
        
        return objApprovalDetails;     
    }    
}