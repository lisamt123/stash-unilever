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
VERSION  AUTHOR              DATE            DETAIL                        Description
1.0 -     Esther             16/10/2014      INITIAL DEVELOPMENT            CSR
2.0       samrin Shaikh      15/12/2015      CSC - 2765                    US-009 Letter/Enclosure auto population

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
    // Commented for CSC - 3135 
    /* public void refundApprovalCheck(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_fulfilment__C> fulfilmentOldMap){

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
} */
    
    /* Start Changes for : CSC - 2765 - US-009 Letter/Enclosure auto population */    
    /**
This Method is used to Auto Populates the Enclosure details on fulfilment based on Country , Product & Reason Code 
I/P  Parameter :  string productL0, string ProductL2,string CountryName ,string reasonCode 
O/P Parameter  :  @return : Wrapper  class which will have status, message  and  Enclosure List as o/p 

*/ 
    
    Public CEC_AlertFulfilmentEnclosureHelper.AlertFulfilmentEnclosureHelperWrapperResponse populateEnclosureDetails(string CaseId,string CountryName)
    {
        
        CEC_AlertFulfilmentEnclosureHelper.AlertFulfilmentEnclosureHelperWrapperResponse result =new  CEC_AlertFulfilmentEnclosureHelper.AlertFulfilmentEnclosureHelperWrapperResponse();
        List<String> alertRuleList = new List<String>();
        List <cec_Alert_Tracker_Item__c> alertTrackerItemLst = new List<cec_Alert_Tracker_Item__c>();
        List<cec_Alert_Action__c> alertAction = new List<cec_Alert_Action__c>();
        String E1,E2,E3,E4,E5='';
        
        try
        {            
            // Query for all the records present in alert tracker item where alert tracker Item: Case Id = Case Id. 
            alertTrackerItemLst = [ SELECT  Alert_Rule_Id__c,Name FROM cec_Alert_Tracker_Item__c WHERE Active__c = TRUE AND Case_Id__c= :CaseId];
            
            if(alertTrackerItemLst.size()>0){
                for(cec_Alert_Tracker_Item__c aTrackerItem: alertTrackerItemLst)
                    alertRuleList.add(aTrackerItem.Alert_Rule_Id__c);
            }
            
            // With the list of alert rule Id query for all the alert action of type Fulfilment sort by lastmodified
            alertAction =[Select Enclosure1__c,Enclosure2__c,Enclosure3__c,Enclosure4__c,Enclosure5__c From cec_Alert_Action__c where Type__c='Fulfilment' AND Country_Name__c=:CountryName AND Alert_Rule_Id__c IN :alertRuleList order by LASTMODIFIEDDATE];
            
            if(alertAction.size()> 0){
                for(cec_Alert_Action__c aAction: alertAction)
                {
                    if(aAction.Enclosure1__c != null)
                        E1= aAction.Enclosure1__c ;
                    if(aAction.Enclosure2__c != null)
                        E2= aAction.Enclosure2__c;
                    if(aAction.Enclosure3__c != null)
                        E3=aAction.Enclosure3__c;
                    if(aAction.Enclosure4__c != null)
                        E4 =aAction.Enclosure4__c;
                    if(aAction.Enclosure5__c != null)
                        E5= aAction.Enclosure5__c;
                    
                } 
                result.status = 'S';
                result.message = 'Success';
                if(result.enclosuresList.isEmpty())
                {
                    result.enclosuresList.Add(E1);
                    result.enclosuresList.Add(E2);
                    result.enclosuresList.Add(E3);
                    result.enclosuresList.Add(E4);
                    result.enclosuresList.Add(E5);
                }          
                
            }            
            
        }
        catch(Exception e){               
            System.debug('Exception in CEC_FulfilmentHelper.getEnclosuresAutoPopulates  method ' + e.getMessage());
            result.status = 'E';
            result.message = e.getMessage();  
        }
        return result;  
    }
    
    /* End  Changes for : CSC - 2765 - US-009 Letter/Enclosure auto population */     
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
                
            } else if ((chequeBookQuery[0].Max_Cheque_Number__c != null ) && (chequeBookQuery[0].Max_Cheque_Number__c <= (chequeBookQuery[0].Last_Cheque_Number__c + chequeBookQuery[0].Increment_Number__c))){
                result.status = 'E';
                result.message = Label.CEC_ChequeBook_MaxLimt_reached;//  ChequeBook Max Limit reached for given combination of Brand and Country
            } else {
                //integer newChequeNumber = Integer.valueOf(chequeBookQuery[0].Last_Cheque_Number__c )+ Integer.valueOf(chequeBookQuery[0].Increment_Number__c);
                chequeBookQuery[0].Last_Cheque_Number__c = chequeBookQuery[0].Last_Cheque_Number__c + chequeBookQuery[0].Increment_Number__c;
                update chequeBookQuery;                
                fulfilment.Cheque_Number__c   = string.valueof(chequeBookQuery[0].Last_Cheque_Number__c); 
                fulfilment.Refund_Currency__c = chequeBookQuery[0].Currency__c;
                fulfilment.ChequeBook__c = chequeBookQuery[0].id;
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
    
    /**
This method is used to insert records in FulfilmentEnclosure object based on Enclosure details selected on Fulfillment Object.
*/
    public void insertFulfilmentEnclosure(List<cec_Fulfilment__c> fulfilmentList){
        system.debug(' In insertfulfillmentEnclosure Method');
        
        if (!fulfilmentList.isEmpty()){
            try{
                
                List<CEC_Fulfilment_Enclosure__c> fulfillmentEnclosureList = new list<CEC_Fulfilment_Enclosure__c>();
                
                for (cec_Fulfilment__c fulfilmentObj : fulfilmentList){
                    if (fulfilmentObj.Enclosure1__c != null && fulfilmentObj.Enclosure1_Quantity__c != null){
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure1__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure1_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id +'_1_'+ fulfilmentObj.Enclosure1__c;
                        
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure2__c != null && fulfilmentObj.Enclosure2_Quantity__c != null){
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure2__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure2_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id +'_2_'+ fulfilmentObj.Enclosure2__c;
                        
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure3__c != null && fulfilmentObj.Enclosure3_Quantity__c != null){
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure3__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure3_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id +'_3_'+ fulfilmentObj.Enclosure3__c;
                        
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure4__c != null && fulfilmentObj.Enclosure4_Quantity__c != null){
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure4__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure4_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id +'_4_'+ fulfilmentObj.Enclosure4__c;
                        
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure5__c != null && fulfilmentObj.Enclosure5_Quantity__c != null){
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure5__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure5_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id +'_5_'+ fulfilmentObj.Enclosure5__c;
                        
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    
                }
                
                system.debug(' fulfillmentEnclosureList : ' +fulfillmentEnclosureList);
                if (fulfillmentEnclosureList.size() >0){
                    insert fulfillmentEnclosureList;
                }
                
                
            } catch(Exception e) {
                System.debug(e.getMessage());
                throw e;
            }       
            
            
        }
        
        
    }   
    
    
    /**
This method is used to upsert records in FulfillmentEnclosure object based on Enclosure details selected on Fulfillment Object.
*/
    public void upsertFulfilmentEnclosure(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_fulfilment__C> fulfilmentOldMap){
        system.debug(' In upsertFulfilmentEnclosure Method');
        
        if (!fulfilmentList.isEmpty()){
            try{
                
                List<CEC_Fulfilment_Enclosure__c> fulfillmentEnclosureList = new list<CEC_Fulfilment_Enclosure__c>();
                
                for (cec_Fulfilment__c fulfilmentObj : fulfilmentList){
                    // If new Enclosure & Enclosure Quantity is updated then add it to fulfillmentEnclosureList for Upsert.
                    if (fulfilmentObj.Enclosure1__c != null  && fulfilmentObj.Enclosure1_Quantity__c != null && ((fulfilmentObj.Enclosure1__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure1__c) || (fulfilmentObj.Enclosure1_Quantity__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure1_Quantity__c))){
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure1__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure1_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id +'_1_'+ fulfilmentObj.Enclosure1__c;
                        
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure2__c != null  && fulfilmentObj.Enclosure2_Quantity__c != null && ((fulfilmentObj.Enclosure2__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure2__c) || (fulfilmentObj.Enclosure2_Quantity__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure2_Quantity__c))){
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure2__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure2_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id +'_2_'+ fulfilmentObj.Enclosure2__c;
                        
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure3__c != null  && fulfilmentObj.Enclosure3_Quantity__c != null && ((fulfilmentObj.Enclosure3__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure3__c) || (fulfilmentObj.Enclosure3_Quantity__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure3_Quantity__c))){
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure3__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure3_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id +'_3_'+ fulfilmentObj.Enclosure3__c;
                        
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure4__c != null   && fulfilmentObj.Enclosure4_Quantity__c != null && ((fulfilmentObj.Enclosure4__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure4__c) || (fulfilmentObj.Enclosure4_Quantity__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure4_Quantity__c))){
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure4__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure4_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id +'_4_'+ fulfilmentObj.Enclosure4__c;
                        
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure5__c != null   && fulfilmentObj.Enclosure5_Quantity__c != null && ((fulfilmentObj.Enclosure5__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure5__c) || (fulfilmentObj.Enclosure5_Quantity__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure5_Quantity__c))){
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure5__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure5_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id +'_5_'+ fulfilmentObj.Enclosure5__c;
                        
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    
                }
                
                system.debug(' fulfillmentEnclosureList : ' +fulfillmentEnclosureList);
                if (fulfillmentEnclosureList.size() >0) {
                    upsert fulfillmentEnclosureList FulfilmentEnclosure_Id__c;
                }
            } catch(Exception e) {
                System.debug(e.getMessage());
                throw e;
            }           
        }
    }        
    
    
    
    /**
This method is used to delete records in FulfillmentEnclosure object based on Enclosure details deleted on Fulfillment Object.
*/
    public void deleteFulfilmentEnclosure(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_fulfilment__C> fulfilmentOldMap){
        system.debug(' In deleteFulfilmentEnclosure Method');
        
        if (!fulfilmentList.isEmpty()){
            try{
                
                List<CEC_Fulfilment_Enclosure__c> fulfillmentEnclosureList = new list<CEC_Fulfilment_Enclosure__c>();
                list<string> FulfilmentEnclosureIdList = new list<string>(); 
                
                string FulfilmentEnclosureId = null;
                for(CEC_Fulfilment__C ff: fulfilmentList){
                    If(ff.Enclosure1__c != fulfilmentOldMap.get(ff.Id).Enclosure1__c){
                        FulfilmentEnclosureId = ff.id + '_1_' +fulfilmentOldMap.get(ff.Id).Enclosure1__c;
                        FulfilmentEnclosureIdList.add(FulfilmentEnclosureId);  
                    }
                    If(ff.Enclosure2__c != fulfilmentOldMap.get(ff.Id).Enclosure2__c){
                        FulfilmentEnclosureId = ff.id + '_2_' +fulfilmentOldMap.get(ff.Id).Enclosure2__c;
                        FulfilmentEnclosureIdList.add(FulfilmentEnclosureId);  
                    }   
                    If(ff.Enclosure3__c != fulfilmentOldMap.get(ff.Id).Enclosure3__c){
                        FulfilmentEnclosureId = ff.id + '_3_' +fulfilmentOldMap.get(ff.Id).Enclosure3__c;
                        FulfilmentEnclosureIdList.add(FulfilmentEnclosureId);  
                    }  
                    If(ff.Enclosure4__c != fulfilmentOldMap.get(ff.Id).Enclosure4__c){
                        FulfilmentEnclosureId = ff.id + '_4_' +fulfilmentOldMap.get(ff.Id).Enclosure4__c;
                        FulfilmentEnclosureIdList.add(FulfilmentEnclosureId); 
                    }  
                    If(ff.Enclosure5__c != fulfilmentOldMap.get(ff.Id).Enclosure5__c){
                        FulfilmentEnclosureId = ff.id + '_5_' +fulfilmentOldMap.get(ff.Id).Enclosure5__c;
                        FulfilmentEnclosureIdList.add(FulfilmentEnclosureId);  
                    }       
                }
                
                system.debug(' FulfilmentEnclosureIdList : ' +FulfilmentEnclosureIdList);
                
                if (FulfilmentEnclosureIdList.size() > 0){
                    fulfillmentEnclosureList = [select id from CEC_Fulfilment_Enclosure__c where FulfilmentEnclosure_Id__c IN : FulfilmentEnclosureIdList ];
                    system.debug(' fulfillmentEnclosureList : ' +fulfillmentEnclosureList);
                    
                    delete fulfillmentEnclosureList;
                }
            } catch(Exception e) {
                System.debug(e.getMessage());
                throw e;
            }           
            
        }  
        
    }                    

    /**
This method is used to convert Refund Value on Fulfilment Object  in words.
*/
    public void convertRefundValueToWords(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_fulfilment__C> fulfilmentOldMap){
        system.debug(' In convertRefundValueToWords Method');

        if (!fulfilmentList.isEmpty()){
            try{
                for (cec_Fulfilment__c fulfilmentObj : fulfilmentList){
                    if ((fulfilmentObj.Refund_Value__c != fulfilmentOldMap.get(fulfilmentObj.Id).Refund_Value__c) || 
                        (fulfilmentObj.ChequeBook__c   != fulfilmentOldMap.get(fulfilmentObj.Id).ChequeBook__c) ){
                            if (fulfilmentObj.Refund_Value__c == null || fulfilmentObj.ChequeBook__c == null){
                                fulfilmentObj.Refund_Value_in_Words__c = '';
                            }
                            else {
                                string result=CEC_Util.convertAllDigitsToWord(fulfilmentObj.Refund_Value__c,fulfilmentObj.Currency_Text__c,fulfilmentObj.Currency_Decimal_Text__c);
                                System.debug('Final result is  ' + result );
                                fulfilmentObj.Refund_Value_in_Words__c = result;                        
                            }
                    }
                }
            } catch(Exception e) {
                System.debug(e.getMessage()); 
                throw e;
            }           
        }
            

    } 
    
}