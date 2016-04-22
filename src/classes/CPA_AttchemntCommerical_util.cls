/**********************************************************************  
Name:  CPA_AttchemntCommerical_util ()  Copyright © 2016  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------   This class is holds the  business logic for CAP [Contracting process Automation] attachment type verification.                                                         
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION  AUTHOR                        DATE              DETAIL                                                    Description    
 1.0      Shreyas Mangalvedhekar        21/12/2015      INITIAL DEVELOPMENT                                             CSR: 
 
 ***********************************************************************/

public with sharing class CPA_AttchemntCommerical_util {
    /*******************************************************************
    Purpose: This method is used to commercials data from PWO
    Parameters: obj
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_project_work_order__c CommericalDataBlankPWO(CPA_project_work_order__c obj) {
        obj.num_Expense_charges_of_work_order__c = NULL;
        obj.pec_Expense__c=NULL;
        obj.pec_Estimated_Off_shore__c=NULL;
        obj.pec_Estimated_On_shore__c=NULL;
        obj.num_Estimated_Man_days_of_PWO__c=NULL;
        obj.num_Estimated_Value_of_PWO__c=NULL;
        obj.num_Target_Blend_Rate__c=NULL;
        obj.num_Total_work_order_charge__c=NULL;
        obj.num_Authorisation_charges__c =NULL;
        obj.num_Authorisation_man_days__c =NULL;
        obj.num_Effort_Cost__c =NULL;
        obj.num_RMS_value__c = NULL;
        obj.num_Varied_Target_Blend_Rate__c = NULL;
        obj.chk_Excel_Attached__c = false;
        obj.num_Discounts__c = NULL;
        obj.num_Contingency_Charges__c = NULL;
        obj.pec_Variance__c =NULL;
        return obj;
    }
    
    /*******************************************************************
    Purpose: This method is used to delete commercials data from CR
    Parameters: obj1
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_CR__c CommericalDataBlankCR(CPA_CR__c obj1) {
        
        obj1.num_Estimated_Man_days_of_CR__c = NULL;
        obj1.num_Estimated_Man_days_of_CR__c = NULL;
        obj1.num_Estimated_Value_of_CR__c = NULL;
        obj1.num_Target_Blend_Rate__c = NULL;
        obj1.num_Total_charge_of_CR__c = NULL;
        obj1.num_Expense_charges_of_CR__c = NULL;
        obj1.pec_Expense__c = NULL;
        obj1.num_Authorisation_charges__c = NULL;
        obj1.num_Authorisation_man_days__c = NULL;
        obj1.num_RMS_value__c = NULL;
        obj1.chk_Contract_Excel_Attached__c = false;
        obj1.num_Total_Resource_Cost_CR__c =NULL;
        obj1.num_Effort_Cost__c =NULL;
        obj1.num_Delta_Efforts__c = NULL;
        obj1.num_Total_Resource_Efforts_CR__c = NULL;
        obj1.num_Total_Expenses_of_CR__c  = NULL;
        obj1.num_Varied_Target_Blend_Rate__c = NULL;
        obj1.pec_Estimated_Off_shore__c =NULL;
        obj1.pec_Estimated_On_shore__c= NULL;
        obj1.num_Discounts__c = NULL;
        obj1.num_Contingency_Charges__c = NULL;
        return obj1;
        
    }
}