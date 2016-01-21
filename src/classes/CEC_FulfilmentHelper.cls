/**********************************************************************
Name:  CEC_FulfilmentHelper
Copyright © 2014  Unilever
======================================================================
=======================================================================
Purpose: This is the Helper class for cec_Fulfilment__c trigger 
This class is used to check quality.                                                                                                                     
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
1.0 - Esther            16/10/2014      INITIAL DEVELOPMENT  CSR

***********************************************************************/

/**
Helper class for Trigger for CEC_FulfilmentTrigger
*/
public with sharing class CEC_FulfilmentHelper{
    
    /**
This method is used to check quality and update QA flag
@param : fulfilmentList - List of cec_Fulfilment__c objects that are to be inserted 
@return : void
*/
    public void qualityCheck(List<cec_Fulfilment__c> fulfilmentList){
        
        
        // try{
        //System.debug('~~~~In CEC_FulfilmentHelper');
        
        User loggedinuser = [select Quality_Check_Percentage__c, Max_Refund_Amount__c from User where id = :UserInfo.getUserId()];
        
        Double QualityPercent =  loggedinuser.Quality_Check_Percentage__c;
        
        Double qualityMaxRefund = loggedinuser.Max_Refund_Amount__c;
        
        //System.debug('~~~~QualityPercent  ' + QualityPercent ); 
        //System.debug('~~~~loggedinuser.Quality_Check_Percentage__c ' + loggedinuser.Quality_Check_Percentage__c); 
        
        Double randomnumber = Math.random()*100;
        System.debug('~~~~randomnumber ' + randomnumber ); 
        
        if(Test.isRunningTest()){
            randomnumber = 0.00;
            QualityPercent  = 1.00;
            qualityMaxRefund = 1.00;
        }
        
        for (cec_Fulfilment__c fulfilmentObj : fulfilmentList){
            
            
            
            if(randomnumber < QualityPercent){
                
                fulfilmentObj.QA_flag__c = true;
                
            }
        }
        
        
        
        // }
        
        /* catch(Exception ex)
{
System.debug('Exception in CEC_FulfilmentHelper.qualityCheck() -> Exception :'  );

}*/
        
    }
    public void refundApprovalCheck(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_fulfilment__C> fulfilmentOldMap){
        
        User loggedinuser = [select Max_Refund_Amount__c from User where id = :UserInfo.getUserId()];
        Double qualityMaxRefund = loggedinuser.Max_Refund_Amount__c;
        
        for (cec_Fulfilment__c fulfilmentObj : fulfilmentList){
        Double oldRefundVal = fulfilmentOldMap.get(fulfilmentObj.Id).Refund_Value__c;
        if(fulfilmentObj.Refund_Value__c != oldRefundVal ){
            if((fulfilmentObj.Refund_Value__c!= null && fulfilmentObj.Refund_Value__c > qualityMaxRefund) || (fulfilmentObj.Refund_Value__c!= null && qualityMaxRefund == null)){
                fulfilmentObj.QA_flag__c = true;
            }
            }
        } 
    }
    /**
This method is used to get the latest cheque number based on Brand , Country & Product Category from ChequeBook_Detail__c. 
This method is being called from CEC_ChequeProcess class which is called from "Add Cheque Details" button on Fulfillment object.
@param : fulfilmentId - 
@return : Wrapper  class which will have status and message as o/p.
*/        
    public CEC_ChequeProcess.chequeProcessWrapperResponse getChequeNumber(string fulfilmentId){
        CEC_ChequeProcess.chequeProcessWrapperResponse  result =  new CEC_ChequeProcess.chequeProcessWrapperResponse();
        try{
            cec_Fulfilment__c    fulfilment      = [Select Id,CaseBrand__c,Country__c, Cheque_Number__c, Refund_Currency__c,Case_Product_Category__c 
                                                    From cec_Fulfilment__c 
                                                    Where id = :fulfilmentId limit 1 ];
            
            list<CEC_ChequeBook_Detail__c> chequeBookQuery = [Select Id,Cheque_Book__c,Increment_Number__c,Last_Cheque_Number__c,Max_Cheque_Number__c,Currency__c 
                                                          From CEC_ChequeBook_Detail__c 
                                                          Where Brand__c           = :fulfilment.CaseBrand__c and
                                                          Country_Name__c          = :fulfilment.Country__c and 
                                                          Product_Category_Name__c = :fulfilment.Case_Product_Category__c and 
                                                          Active__c                = true limit 1
                                                          FOR UPDATE ];
            
            if (chequeBookQuery.size() == 0 ){
                result.status = 'E';
                result.message = Label.CEC_ChequeBook_DetailsMissing;// No record in ChequeBook for given combination of Brand and Country
                //System.debug('@@@@ chequeBookQuery @@@@' + fulfilment );
                
            } else if ((chequeBookQuery[0].Max_Cheque_Number__c != null ) && (Integer.valueOf(chequeBookQuery[0].Max_Cheque_Number__c) <= (Integer.valueOf(chequeBookQuery[0].Last_Cheque_Number__c) +Integer.valueOf(chequeBookQuery[0].Increment_Number__c)))){
                result.status = 'E';
                result.message = Label.CEC_ChequeBook_MaxLimt_reached;//  ChequeBook Max Limit reached for given combination of Brand and Country
            } else {
                integer newChequeNumber = Integer.valueOf(chequeBookQuery[0].Last_Cheque_Number__c )+ Integer.valueOf(chequeBookQuery[0].Increment_Number__c);
                chequeBookQuery[0].Last_Cheque_Number__c = newChequeNumber;
                update chequeBookQuery;                
                fulfilment.Cheque_Number__c   = string.valueof(newChequeNumber); 
                fulfilment.Refund_Currency__c = chequeBookQuery[0].Currency__c;
                update fulfilment;                
                result.status = 'S';
                result.message = 'Success';                
            }
            system.debug('  my result' + result);
            //return result;  
        }catch(Exception e){               
            System.debug('Exception in CEC_FulfilmentHelper.getChequeNumber method ' + e.getMessage());
            result.status = 'E';
            result.message = e.getMessage();  
        }
        System.debug('@@@@ result@@@@' + result);
        return result;  
    }
}