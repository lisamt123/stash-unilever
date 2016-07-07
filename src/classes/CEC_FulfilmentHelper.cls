/**********************************************************************
Name:  CEC_FulfilmentHelper
Copyright Â© 2014  Unilever
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
3.0       mahesh konar       2nd june 2016   CSC-4518                      To calculate Total Enclosure Value
                                                                           added method beforeInsUpdCalcEnclosure,
																		   getEnclosureIds and calcTotalEnclosure

***********************************************************************/

/**
Helper class for Trigger for CEC_FulfilmentTrigger
*/
public with sharing class CEC_FulfilmentHelper {

    final String resultSuccess = 'Success';

    /**
    This method is used to check quality and update QA flag
    @param : fulfilmentList - List of cec_Fulfilment__c objects that are to be inserted
    @return : void
    **/
    public void qualityCheck(List<cec_Fulfilment__c> fulfilmentList) {


        // try{
        //System.debug('~~~~In CEC_FulfilmentHelper');




        User loggedinuser = [select Quality_Check_Percentage__c, Max_Refund_Amount__c from User where id = :UserInfo.getUserId()];

        Double QualityPercent =  loggedinuser.Quality_Check_Percentage__c;

        Double qualityMaxRefund = loggedinuser.Max_Refund_Amount__c;

        //System.debug('~~~~QualityPercent  ' + QualityPercent );
        //System.debug('~~~~loggedinuser.Quality_Check_Percentage__c ' + loggedinuser.Quality_Check_Percentage__c);

        Double randomnumber = Math.random() * 100;
        System.debug('~~~~randomnumber ' + randomnumber );

        if (Test.isRunningTest()) {
            randomnumber = 0.00;
            QualityPercent  = 1.00;
            qualityMaxRefund = 1.00;
        }

        for (cec_Fulfilment__c fulfilmentObj : fulfilmentList) {



            if (randomnumber < QualityPercent) {

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

    Public CEC_AlertFulfilmentEnclosureHelper.AlertFulfilmentEnclosureHelperWrapperResponse populateEnclosureDetails(string CaseId, string CountryName) {

        CEC_AlertFulfilmentEnclosureHelper.AlertFulfilmentEnclosureHelperWrapperResponse result = new  CEC_AlertFulfilmentEnclosureHelper.AlertFulfilmentEnclosureHelperWrapperResponse();
        List<String> alertRuleList = new List<String>();
        List <cec_Alert_Tracker_Item__c> alertTrackerItemLst = new List<cec_Alert_Tracker_Item__c>();
        List<cec_Alert_Action__c> alertAction = new List<cec_Alert_Action__c>();
        String E1, E2, E3, E4, E5 = '';

        try {
            // Query for all the records present in alert tracker item where alert tracker Item: Case Id = Case Id.
            alertTrackerItemLst = [ SELECT  Alert_Rule_Id__c, Name FROM cec_Alert_Tracker_Item__c WHERE Active__c = TRUE AND Case_Id__c = :CaseId];

            if (alertTrackerItemLst.size() > 0) {
                for (cec_Alert_Tracker_Item__c aTrackerItem : alertTrackerItemLst)
                    alertRuleList.add(aTrackerItem.Alert_Rule_Id__c);
            }

            // With the list of alert rule Id query for all the alert action of type Fulfilment sort by lastmodified
            alertAction = [Select Enclosure1__c, Enclosure2__c, Enclosure3__c, Enclosure4__c, Enclosure5__c From cec_Alert_Action__c where Type__c = 'Fulfilment' AND Country_Name__c = :CountryName AND Alert_Rule_Id__c IN :alertRuleList order by LASTMODIFIEDDATE];

            if (alertAction.size() > 0) {
                for (cec_Alert_Action__c aAction : alertAction) {
                    if (aAction.Enclosure1__c != null)
                        E1 = aAction.Enclosure1__c ;
                    if (aAction.Enclosure2__c != null)
                        E2 = aAction.Enclosure2__c;
                    if (aAction.Enclosure3__c != null)
                        E3 = aAction.Enclosure3__c;
                    if (aAction.Enclosure4__c != null)
                        E4 = aAction.Enclosure4__c;
                    if (aAction.Enclosure5__c != null)
                        E5 = aAction.Enclosure5__c;

                }
                result.status = 'S';
                result.message = resultSuccess;
                if (result.enclosuresList.isEmpty()) {
                    result.enclosuresList.Add(E1);
                    result.enclosuresList.Add(E2);
                    result.enclosuresList.Add(E3);
                    result.enclosuresList.Add(E4);
                    result.enclosuresList.Add(E5);
                }

            }

        } catch (Exception e) {
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
    public CEC_ChequeProcess.chequeProcessWrapperResponse getChequeNumber(string fulfilmentId) {
        CEC_ChequeProcess.chequeProcessWrapperResponse  result =  new CEC_ChequeProcess.chequeProcessWrapperResponse();
        try {
            cec_Fulfilment__c    fulfilment      = [Select Id, CaseBrand__c, Country__c, Cheque_Number__c, Refund_Currency__c, Case_Product_Category__c
                                                    From cec_Fulfilment__c
                                                    Where id = :fulfilmentId limit 1 ];

            list<CEC_ChequeBook_Detail__c> chequeBookQuery = [Select Id, Cheque_Book__c, Increment_Number__c, Last_Cheque_Number__c, Max_Cheque_Number__c, Currency__c
                    From CEC_ChequeBook_Detail__c
                    Where Brand__c           = :fulfilment.CaseBrand__c and
                                               Country_Name__c          = :fulfilment.Country__c and
                                                       Product_Category_Name__c = :fulfilment.Case_Product_Category__c and
                                                               Active__c                = true limit 1
                                                                       FOR UPDATE ];

            if (chequeBookQuery.size() == 0 ) {
                result.status = 'E';
                result.message = Label.CEC_ChequeBook_DetailsMissing;// No record in ChequeBook for given combination of Brand and Country
                //System.debug('@@@@ chequeBookQuery @@@@' + fulfilment );

            } else if ((chequeBookQuery[0].Max_Cheque_Number__c != null ) && (chequeBookQuery[0].Max_Cheque_Number__c <= (chequeBookQuery[0].Last_Cheque_Number__c + chequeBookQuery[0].Increment_Number__c))) {
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
                result.message = resultSuccess;
            }
            system.debug('  my result' + result);
            //return result;
        } catch (Exception e) {
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
    public void insertFulfilmentEnclosure(List<cec_Fulfilment__c> fulfilmentList) {
        system.debug(' In insertfulfillmentEnclosure Method');

        if (!fulfilmentList.isEmpty()) {
            try {

                List<CEC_Fulfilment_Enclosure__c> fulfillmentEnclosureList = new list<CEC_Fulfilment_Enclosure__c>();

                for (cec_Fulfilment__c fulfilmentObj : fulfilmentList) {
                    if (fulfilmentObj.Enclosure1__c != null && fulfilmentObj.Enclosure1_Quantity__c != null) {
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();

                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure1__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure1_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id + '_1_' + fulfilmentObj.Enclosure1__c;

                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure2__c != null && fulfilmentObj.Enclosure2_Quantity__c != null) {
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();

                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure2__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure2_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id + '_2_' + fulfilmentObj.Enclosure2__c;

                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure3__c != null && fulfilmentObj.Enclosure3_Quantity__c != null) {
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();

                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure3__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure3_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id + '_3_' + fulfilmentObj.Enclosure3__c;

                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure4__c != null && fulfilmentObj.Enclosure4_Quantity__c != null) {
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();

                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure4__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure4_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id + '_4_' + fulfilmentObj.Enclosure4__c;

                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }
                    if (fulfilmentObj.Enclosure5__c != null && fulfilmentObj.Enclosure5_Quantity__c != null) {
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();

                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure5__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure5_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id + '_5_' + fulfilmentObj.Enclosure5__c;

                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }

                }

                system.debug(' fulfillmentEnclosureList : ' + fulfillmentEnclosureList);
                if (fulfillmentEnclosureList.size() > 0) {
                    insert fulfillmentEnclosureList;
                }


            } catch (Exception e) {
                System.debug(e.getMessage());
                throw e;
            }


        }


    }


    /**
    This method is used to upsert records in FulfillmentEnclosure object based on Enclosure details selected on Fulfillment Object.
    */
    public void upsertFulfilmentEnclosure(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_fulfilment__C> fulfilmentOldMap) {
        system.debug(' In upsertFulfilmentEnclosure Method');

        if (!fulfilmentList.isEmpty()) {
            try {

                List<CEC_Fulfilment_Enclosure__c> fulfillmentEnclosureList = new list<CEC_Fulfilment_Enclosure__c>();

                for (cec_Fulfilment__c fulfilmentObj : fulfilmentList) {
                    // If new Enclosure & Enclosure Quantity is updated then add it to fulfillmentEnclosureList for Upsert.
                    if (fulfilmentObj.Enclosure1__c != null  && fulfilmentObj.Enclosure1_Quantity__c != null && ((fulfilmentObj.Enclosure1__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure1__c) || (fulfilmentObj.Enclosure1_Quantity__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure1_Quantity__c))) {
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        // set enclosure fields
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure1__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure1_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id + '_1_' + fulfilmentObj.Enclosure1__c;
                        // add enclosure to upsert list
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }// If new Enclosure & Enclosure Quantity is updated then add it to fulfillmentEnclosureList for Upsert.
                    if (fulfilmentObj.Enclosure2__c != null  && fulfilmentObj.Enclosure2_Quantity__c != null && ((fulfilmentObj.Enclosure2__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure2__c) || (fulfilmentObj.Enclosure2_Quantity__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure2_Quantity__c))) {
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        // set enclosure fields
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure2__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure2_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id + '_2_' + fulfilmentObj.Enclosure2__c;
                        // add enclosure to upsert list
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }// If new Enclosure & Enclosure Quantity is updated then add it to fulfillmentEnclosureList for Upsert.
                    if (fulfilmentObj.Enclosure3__c != null  && fulfilmentObj.Enclosure3_Quantity__c != null && ((fulfilmentObj.Enclosure3__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure3__c) || (fulfilmentObj.Enclosure3_Quantity__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure3_Quantity__c))) {
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        // set enclosure fields
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure3__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure3_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id + '_3_' + fulfilmentObj.Enclosure3__c;
                        // add enclosure to upsert list
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }// If new Enclosure & Enclosure Quantity is updated then add it to fulfillmentEnclosureList for Upsert.
                    if (fulfilmentObj.Enclosure4__c != null   && fulfilmentObj.Enclosure4_Quantity__c != null && ((fulfilmentObj.Enclosure4__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure4__c) || (fulfilmentObj.Enclosure4_Quantity__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure4_Quantity__c))) {
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        // set enclosure fields
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure4__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure4_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id + '_4_' + fulfilmentObj.Enclosure4__c;
                        // add enclosure to upsert list
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }// If new Enclosure & Enclosure Quantity is updated then add it to fulfillmentEnclosureList for Upsert.
                    if (fulfilmentObj.Enclosure5__c != null   && fulfilmentObj.Enclosure5_Quantity__c != null && ((fulfilmentObj.Enclosure5__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure5__c) || (fulfilmentObj.Enclosure5_Quantity__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure5_Quantity__c))) {
                        CEC_Fulfilment_Enclosure__c fulfillmentEnclosure = new CEC_Fulfilment_Enclosure__c();
                        // set enclosure fields
                        fulfillmentEnclosure.Fulfilment_Id__c = fulfilmentObj.Id;
                        fulfillmentEnclosure.Enclosure_Id__c = fulfilmentObj.Enclosure5__c;
                        fulfillmentEnclosure.Quantity__c = integer.valueof(fulfilmentObj.Enclosure5_Quantity__c);
                        fulfillmentEnclosure.FulfilmentEnclosure_Id__c = fulfilmentObj.Id + '_5_' + fulfilmentObj.Enclosure5__c;
                        // add enclosure to upsert list
                        fulfillmentEnclosureList.add(fulfillmentEnclosure);
                    }

                }
                // upsert enclosuresList
                system.debug(' fulfillmentEnclosureList : ' + fulfillmentEnclosureList);
                if (fulfillmentEnclosureList.size() > 0) {
                    upsert fulfillmentEnclosureList FulfilmentEnclosure_Id__c;
                }
            } catch (Exception e) {
                System.debug(e.getMessage());
                throw e;
            }
        }
    }



    /**
    This method is used to delete records in FulfillmentEnclosure object based on Enclosure details deleted on Fulfillment Object.
    */
    public void deleteFulfilmentEnclosure(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_fulfilment__C> fulfilmentOldMap) {
        system.debug(' In deleteFulfilmentEnclosure Method');

        if (!fulfilmentList.isEmpty()) {
            try {

                List<CEC_Fulfilment_Enclosure__c> fulfillmentEnclosureList = new list<CEC_Fulfilment_Enclosure__c>();
                list<string> FulfilmentEnclosureIdList = new list<string>();

                string FulfilmentEnclosureId = null;
                for (CEC_Fulfilment__C ff : fulfilmentList) {
                    If(ff.Enclosure1__c != fulfilmentOldMap.get(ff.Id).Enclosure1__c) {
                        FulfilmentEnclosureId = ff.id + '_1_' + fulfilmentOldMap.get(ff.Id).Enclosure1__c;
                        FulfilmentEnclosureIdList.add(FulfilmentEnclosureId);
                    }
                    If(ff.Enclosure2__c != fulfilmentOldMap.get(ff.Id).Enclosure2__c) {
                        FulfilmentEnclosureId = ff.id + '_2_' + fulfilmentOldMap.get(ff.Id).Enclosure2__c;
                        FulfilmentEnclosureIdList.add(FulfilmentEnclosureId);
                    }
                    If(ff.Enclosure3__c != fulfilmentOldMap.get(ff.Id).Enclosure3__c) {
                        FulfilmentEnclosureId = ff.id + '_3_' + fulfilmentOldMap.get(ff.Id).Enclosure3__c;
                        FulfilmentEnclosureIdList.add(FulfilmentEnclosureId);
                    }
                    If(ff.Enclosure4__c != fulfilmentOldMap.get(ff.Id).Enclosure4__c) {
                        FulfilmentEnclosureId = ff.id + '_4_' + fulfilmentOldMap.get(ff.Id).Enclosure4__c;
                        FulfilmentEnclosureIdList.add(FulfilmentEnclosureId);
                    }
                    If(ff.Enclosure5__c != fulfilmentOldMap.get(ff.Id).Enclosure5__c) {
                        FulfilmentEnclosureId = ff.id + '_5_' + fulfilmentOldMap.get(ff.Id).Enclosure5__c;
                        FulfilmentEnclosureIdList.add(FulfilmentEnclosureId);
                    }
                }

                system.debug(' FulfilmentEnclosureIdList : ' + FulfilmentEnclosureIdList);

                if (FulfilmentEnclosureIdList.size() > 0) {
                    fulfillmentEnclosureList = [select id from CEC_Fulfilment_Enclosure__c where FulfilmentEnclosure_Id__c IN : FulfilmentEnclosureIdList ];
                    system.debug(' fulfillmentEnclosureList : ' + fulfillmentEnclosureList);

                    delete fulfillmentEnclosureList;
                }
            } catch (Exception e) {
                System.debug(e.getMessage());
                throw e;
            }

        }

    }

    /**
    This method is used to convert Refund Value on Fulfilment Object  in words.
    */
    public void convertRefundValueToWords(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_fulfilment__C> fulfilmentOldMap) {
        system.debug(' In convertRefundValueToWords Method');

        if (!fulfilmentList.isEmpty()) {
            try {
                for (cec_Fulfilment__c fulfilmentObj : fulfilmentList) {
                    if ((fulfilmentObj.Refund_Value__c != fulfilmentOldMap.get(fulfilmentObj.Id).Refund_Value__c) ||
                            (fulfilmentObj.ChequeBook__c   != fulfilmentOldMap.get(fulfilmentObj.Id).ChequeBook__c) ) {
                        if (fulfilmentObj.Refund_Value__c == null || fulfilmentObj.ChequeBook__c == null) {
                            fulfilmentObj.Refund_Value_in_Words__c = '';
                        } else {
                            string result = CEC_Util.convertAllDigitsToWord(fulfilmentObj.Refund_Value__c, fulfilmentObj.Currency_Text__c, fulfilmentObj.Currency_Decimal_Text__c, fulfilmentObj.Cheque_Decimals__c);
                            System.debug('Final result is  ' + result );
                            fulfilmentObj.Refund_Value_in_Words__c = result;
                        }
                    }
                }
            } catch (Exception e) {
                System.debug(e.getMessage());
                throw e;
            }
        }


    }


    /**
    This method is used to get the latest cheque number based on Brand , Country & Product Category from ChequeBook_Detail__c.
    This method is being called from CEC_ChequeProcess class which is called from "Add Cheque Details" button on Fulfillment object.
    @param : fulfilmentId -
    @return : Wrapper  class which will have status and message as o/p.
    */

    public CEC_DebitCardProcess.debitProcessWrapperResponse updateDebitCardDetails(string fulfilmentId) {
        CEC_DebitCardProcess.debitProcessWrapperResponse  result =  new CEC_DebitCardProcess.debitProcessWrapperResponse();
        try {
            cec_Fulfilment__c    fulfilment      = [Select Id, Debit_Card_Number__c, Date_of_Birth__c, case__r.Accountid, Country__c, case__r.Country__r.name, Local_Identifier__c, Mailing_Address__c, Account_Card_Number__c, Issue_Card__c
                                                    From cec_Fulfilment__c
                                                    Where id = :fulfilmentId limit 1 FOR Update];


            system.debug('fulfilment @@@+ ' + fulfilment);
            system.debug('case__r.Accountid @@@+ ' + fulfilment.case__r.Accountid);

            if (fulfilment.Account_Card_Number__c != null && fulfilment.Issue_Card__c) {
                List<CEC_Debit_Card_Detail__c> debitCardQuery = [Select Id, Status__c, Cancelled_Date__c
                        From CEC_Debit_Card_Detail__c
                        Where Name   = :fulfilment.Account_Card_Number__c  and
                                       Account_Id__c          = :fulfilment.case__r.Accountid       and
                                               Active__c              = true limit 1 ];



                if (debitCardQuery.size() > 0 ) {
                    debitCardQuery[0].Status__c = CEC_Constants.CANCELLED;
                    debitCardQuery[0].Active__c = false;
                    debitCardQuery[0].Cancelled_Date__c = System.now();
                    update debitCardQuery;

                }
            }

            List<CEC_Debit_Card_Detail__c> debitCardQuery1 = [Select Id, Name, Status__c, Expiry_Date__c
                    From CEC_Debit_Card_Detail__c
                    Where Status__c       in (:CEC_Constants.ISSUED , :CEC_Constants.REACTIVATED) and
                    Account_Id__c   = :fulfilment.case__r.Accountid and
                                      Country_Name__c = :fulfilment.Country__c    and
                                              Active__c       = true
                                                      limit 1 ];

            system.debug('debitCardQuery1 @@@ ' + debitCardQuery1);
            system.debug('fulfilment.case__r.Country__c @@@ ' + fulfilment.Country__c);
            system.debug('fulfilment.Country__c @@@ ' + fulfilment.Country__c);
            system.debug('fulfilment.Country__c  @@@ ' + fulfilment.Country__c );
            system.debug('fulfilment.Account_Id__c @@@ ' + fulfilment.case__r.Accountid);


            if (debitCardQuery1.size() > 0) {
                cec_Org_Settings__c OrgSetting    = cec_Org_Settings__c.getOrgDefaults();
                debitCardQuery1[0].Expiry_Date__c = DateTime.Now().addDays(integer.valueof(OrgSetting.Debit_Card_Expiry_Days__c));
                debitCardQuery1[0].Status__c      = CEC_Constants.REACTIVATED;
                update debitCardQuery1;

                fulfilment.Debit_Card_Number__c =   debitCardQuery1[0].id;
                update fulfilment;

                result.status = 'S';
                result.message = resultSuccess;

            } else {

                List<CEC_Debit_Card_Detail__c> debitCardQuery2 = [Select Id, Name, Status__c, Expiry_Date__c, Issued_Date__c, Account_Id__c
                        From CEC_Debit_Card_Detail__c
                        Where Status__c        = :CEC_Constants.STATUS_NEW  and
                                                 Country_Name__c = :fulfilment.Country__c    and
                                                         Active__c       = true
                                                                 order by Issued_Date__c desc
                                                                 limit 1 ];

                system.debug('debitCardQuery2 @@@ ' + debitCardQuery2);

                if (debitCardQuery2.size() > 0) {
                    cec_Org_Settings__c OrgSetting = cec_Org_Settings__c.getOrgDefaults();
                    debitCardQuery2[0].Expiry_Date__c = DateTime.Now().addDays(integer.valueof(OrgSetting.Debit_Card_Expiry_Days__c));
                    debitCardQuery2[0].Issued_Date__c = DateTime.Now();
                    debitCardQuery2[0].Status__c      = CEC_Constants.Issued;
                    debitCardQuery2[0].Account_Id__c  = fulfilment.case__r.Accountid;
                    update debitCardQuery2;
                    system.debug('debitCardQuery2 @#@# ' + debitCardQuery2);

                    //fulfilment.Debit_Card_Id__c     =   debitCardQuery2[0].id;
                    fulfilment.Debit_Card_Number__c =   debitCardQuery2[0].id;
                    update fulfilment;
                    system.debug('fulfilment @#@# ' + fulfilment);
                    system.debug('fulfilment.Debit_Card_Number__c @#@# ' + fulfilment.Debit_Card_Number__c);

                    Account acctQuery = [select Id,     Debit_Card_Number__c  from account where id = :fulfilment.case__r.Accountid LIMIT 1];
                    acctQuery.Debit_Card_Number__c = fulfilment.Debit_Card_Number__C ;
                    update AcctQuery;
                    system.debug('AcctQuery @#@# ' + AcctQuery);

                    result.status = 'S';
                    result.message = resultSuccess;

                } else {
                    result.status = 'E';
                    result.message = Label.CEC_DebitCardDetails_No_Active_DebitCard_For_Country;// there is no Active debit card present for this country

                }
            }
            system.debug('  my result' + result);
        } catch (Exception e) {
            System.debug('Exception in CEC_FulfilmentHelper.updateDebitCardDetails method ' + e.getMessage());
            result.status = 'E';
            result.message = e.getMessage();
        }
        System.debug('@@@@ result@@@@' + result);
        return result;
    }

    /**
    This method is used to update debit card value after fulfillment approval.
    @param : fulfilment List- List of new values from trigger context variable
    oldFulfilmentMap - Trigger context variable for old details
    */
    public void updateDebitCardValue(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_Fulfilment__c> oldFulfilmentMap) {
        system.debug(' In updateDebitCardValue Method : fulfilmentList = ' + fulfilmentList);
        system.debug(' In updateDebitCardValue Method : oldFulfilmentMap = ' + oldFulfilmentMap);

        List<CEC_Debit_Card_Detail__c> debitCardListToUpdate = new List<CEC_Debit_Card_Detail__c>();
        CEC_Debit_Card_Detail__c debitCardDetailObj = new CEC_Debit_Card_Detail__c();
        for (cec_Fulfilment__c fulfilment : fulfilmentList) {
            if (fulfilment.isApproved__c &&
                    oldFulfilmentMap.get(fulfilment.Id).isApproved__c != fulfilment.isApproved__c &&
                    fulfilment.Debit_Card_Number__c != null &&
                    fulfilment.Debit_Card_Value__c != null) {
                debitCardDetailObj = new CEC_Debit_Card_Detail__c(  Id = fulfilment.Debit_Card_Number__c ,
                        Card_Value__c = fulfilment.Debit_Card_Detail_Card_Value__c +
                                        fulfilment.Debit_Card_Value__c);
                System.debug('@@@debitCardDetailObj ' + debitCardDetailObj);
                debitCardListToUpdate.add(debitCardDetailObj);
            }
        }
        System.debug('@@debitCardListToUpdate size' + debitCardListToUpdate.size());
        if (!debitCardListToUpdate.isEmpty()) {
            update debitCardListToUpdate;
        }
    }

    /**
    This method is used to update Account details for DOB and Local Identifier
    @param :fulfilment List- List of new values from trigger context variable
    oldFulfilmentMap - Trigger context variable for old details
    */
    public void updateAccountDetails(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_Fulfilment__c> oldFulfilmentMap) {
        system.debug(' In updateDebitCardValue Method : fulfilmentList = ' + fulfilmentList);
        system.debug(' In updateDebitCardValue Method : oldFulfilmentMap = ' + oldFulfilmentMap);
        try {
            List<Account> accountList = new List<Account>();
            for (cec_Fulfilment__c fulfilment : fulfilmentList) {
                if ((fulfilment.Date_of_Birth__c != null &&
                        oldFulfilmentMap.get(fulfilment.Id).Date_of_Birth__c != fulfilment.Date_of_Birth__c) ||
                        (String.isNotBlank(fulfilment.Local_Identifier__c) &&
                         oldFulfilmentMap.get(fulfilment.Id).Local_Identifier__c != fulfilment.Local_Identifier__c) ||
                        (String.isNotBlank(fulfilment.PersonEmail__c) &&
                         oldFulfilmentMap.get(fulfilment.Id).PersonEmail__c != fulfilment.PersonEmail__c)) {

                    Account accountObj = new Account(   Id = fulfilment.Account_Id__c,
                                                        PersonBirthdate = fulfilment.Date_of_Birth__c,
                                                        Local_Identifier__c = fulfilment.Local_Identifier__c,
                                                        PersonEmail = fulfilment.PersonEmail__c);
                    accountList.add(accountObj);
                }
            }
            if (!accountList.isEmpty())
                update accountList;
        } catch (DmlException e) {
            for (cec_Fulfilment__c fulfilment : fulfilmentList) {
                if (e.getMessage().contains(CEC_Constants.LOCALIDENTIFIER_CPF)) {
                    fulfilment.addError(e.getDMLMessage(0));
                } else {
                    fulfilment.addError(e.getMessage());
                }
            }
        } catch (Exception e) {
            //throw e;
            System.debug('Exception in CEC_FulfilmentHelper.updateAccountDetails method ' + e.getMessage());
        }
    }


    /**
    This method is used to get the e voucher number from ChequeBook_Detail__c.
    This method is being called from CEC_EvoucherProcess class which is called from "Add E-Voucher Details" button on Fulfillment object.
    @param : fulfilmentId -
    @return : Wrapper  class which will have status and message as o/p.
    */

    public CEC_EvoucherProcess.eVoucherProcessWrapperResponse updateEvoucherDetails(string fulfilmentId) {
        CEC_EvoucherProcess.eVoucherProcessWrapperResponse  result =  new CEC_EvoucherProcess.eVoucherProcessWrapperResponse();
        Savepoint sp = Database.setSavepoint();
        try {
            cec_Fulfilment__c    fulfilment      = [Select Id, E_Voucher_Number__c, Date_of_Birth__c, case__r.Accountid, Country__c, case__r.Country__r.name, Local_Identifier__c, Mailing_Address__c
                                                    From cec_Fulfilment__c
                                                    Where id = :fulfilmentId limit 1 FOR Update];


            system.debug('fulfilment @@@+ ' + fulfilment);
            system.debug('fulfilment.Country__c @@@+ ' + fulfilment.Country__c);
            system.debug('case__r.Accountid @@@+ ' + fulfilment.case__r.Accountid);



            List<CEC_E_Voucher_Details__c> eVoucherQuery = [Select Id, Name, Status__c, Expiry_Date__c, Issued_Date__c, Account_Id__c
                    From CEC_E_Voucher_Details__c
                    Where Status__c        = :CEC_Constants.STATUS_NEW  and
                                             Country_Name__c = :fulfilment.Country__c    and
                                                     Active__c       = true
                                                             order by CreatedDate
                                                             limit 1 ];

            system.debug('eVoucherQuery @@@ ' + eVoucherQuery);

            if (eVoucherQuery.size() > 0) {

                cec_Org_Settings__c OrgSetting = cec_Org_Settings__c.getOrgDefaults();
                eVoucherQuery[0].Expiry_Date__c = DateTime.Now().addDays(integer.valueof(OrgSetting.E_Voucher_Expiry_Days__c));
                eVoucherQuery[0].Issued_Date__c = DateTime.Now();
                eVoucherQuery[0].Status__c      = CEC_Constants.Issued;
                eVoucherQuery[0].Account_Id__c  = fulfilment.case__r.Accountid;
                system.debug('eVoucherQuery Before Update ' + eVoucherQuery);
                update eVoucherQuery;
                system.debug('eVoucherQuery @#@# ' + eVoucherQuery);

                fulfilment.E_Voucher_Number__c =   eVoucherQuery[0].id;
                update fulfilment;
                system.debug('fulfilment @#@# ' + fulfilment);
                system.debug('fulfilment.E_Voucher_Number__c @#@# ' + fulfilment.E_Voucher_Number__c);


                result.status = 'S';
                result.message = resultSuccess;

            } else {
                result.status = 'E';
                result.message = Label.CEC_EvoucherDetails_No_Active_EVoucher_For_Country;// there is no Active E Voucher present for this country

            }

            system.debug('  my result' + result);
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug('Exception in CEC_FulfilmentHelper.updateEvoucherDetails method ' + e.getMessage());
            result.status = 'E';
            result.message = e.getMessage();
        }
        System.debug('@@@@ result@@@@' + result);
        return result;
    }

    /**
    This method is used to update E-Voucher value after fulfillment approval.
    @param : fulfilment List- List of new values from trigger context variable
    oldFulfilmentMap - Trigger context variable for old details
    */
    public void updateEvoucherValue(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_Fulfilment__c> oldFulfilmentMap) {

        system.debug(' In updateEvoucherValue Method : fulfilmentList = ' + fulfilmentList);
        system.debug(' In updateEvoucherValue Method : oldFulfilmentMap = ' + oldFulfilmentMap);

        List<CEC_E_Voucher_Details__c> eVoucherDetailToUpdate = new List<CEC_E_Voucher_Details__c>();
        CEC_E_Voucher_Details__c eVoucherDetailObj = new CEC_E_Voucher_Details__c();
        for (cec_Fulfilment__c fulfilment : fulfilmentList) {
            if (fulfilment.isApproved__c &&
                    oldFulfilmentMap.get(fulfilment.Id).isApproved__c != fulfilment.isApproved__c &&
                    fulfilment.E_Voucher_Number__c != null &&
                    fulfilment.E_Voucher_Value__c != null) {

                System.debug('@@@fulfilment.E_Voucher_Value__c ' + fulfilment.E_Voucher_Value__c);
                eVoucherDetailObj = new CEC_E_Voucher_Details__c(  Id = fulfilment.E_Voucher_Number__c ,
                        Voucher_Value__c =  fulfilment.E_Voucher_Value__c);
                System.debug('@@@eVoucherDetailObj ' + eVoucherDetailObj);
                eVoucherDetailToUpdate.add(eVoucherDetailObj);
            }
        }
        System.debug('@@eVoucherDetailToUpdate size' + eVoucherDetailToUpdate.size());
        if (!eVoucherDetailToUpdate.isEmpty()) {
            update eVoucherDetailToUpdate;
        }
    }
    /**
    This method is used to update Date Approved field on fulfilment object
    @param :fulfilment List- List of new values from trigger context variable
    oldFulfilmentMap - Trigger context variable for old details
    */
    public void updateFulfilmentApprovedDate(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_Fulfilment__c> oldFulfilmentMap) {
        try {
            for (cec_Fulfilment__c fulfilment : fulfilmentList) {
                if (fulfilment.isApproved__c &&
                        oldFulfilmentMap.get(fulfilment.Id).isApproved__c != fulfilment.isApproved__c) {
                    fulfilment.Date_Approved__c = System.now();
                }
            }
        } catch (Exception e) {
            System.debug('Exception in CEC_FulfilmentHelper.updateFulfilmentApprovedDate method ' + e.getMessage());
        }
    }

    /*******************************************************************
    Purpose: To calculate Total Enclosure Value.
    Param: fulfilmentList
    ********************************************************************/

    public void beforeInsUpdCalcEnclosure(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_fulfilment__C> fulfilmentOldMap) {

        //2nd june 2016 - mahesh - To calculate Total Enclosure Value
        Set<Id> enclosureIds = new Set<Id>();

        for (cec_Fulfilment__c fulfilmentObj : fulfilmentList) {

            if (fulfilmentOldMap != null && (  fulfilmentObj.Enclosure1__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure1__c
                                               || fulfilmentObj.Enclosure2__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure2__c
                                               || fulfilmentObj.Enclosure3__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure3__c
                                               || fulfilmentObj.Enclosure4__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure4__c
                                               || fulfilmentObj.Enclosure5__c != fulfilmentOldMap.get(fulfilmentObj.Id).Enclosure5__c)) {

                enclosureIds.addAll(getEnclosureIds(fulfilmentObj));
            } else {

                enclosureIds.addAll(getEnclosureIds(fulfilmentObj));
            }

        }

        if (!enclosureIds.isEmpty()) {
            calcTotalEnclosure(enclosureIds, fulfilmentList);
        }
    }
	/*******************************************************************
    Purpose: To get all the enclosure Id on fulfillment.
    Param: fulfilmentObj
    Return: set<Id>
    ********************************************************************/
    public set<Id> getEnclosureIds(cec_Fulfilment__c fulfilmentObj) {
		 //2nd june 2016 - mahesh - To calculate Total Enclosure Value
		 
        set<Id> enclosureIds = new set<Id>();
        if (fulfilmentObj.Enclosure1__c != null)
            enclosureIds.add(fulfilmentObj.Enclosure1__c);
        if (fulfilmentObj.Enclosure2__c != null)
            enclosureIds.add(fulfilmentObj.Enclosure2__c);
        if (fulfilmentObj.Enclosure3__c != null)
            enclosureIds.add(fulfilmentObj.Enclosure3__c);
        if (fulfilmentObj.Enclosure4__c != null)
            enclosureIds.add(fulfilmentObj.Enclosure4__c);
        if (fulfilmentObj.Enclosure5__c != null)
            enclosureIds.add(fulfilmentObj.Enclosure5__c);

        return enclosureIds;
    }
    
	/*******************************************************************
    Purpose: To calculate Total Enclosure Value.
    Param: fulfilmentList
    Param: enclosureIds
    ********************************************************************/
    public void calcTotalEnclosure(set<Id> enclosureIds, List<cec_Fulfilment__c> fulfilmentList) {
		 //2nd june 2016 - mahesh - To calculate Total Enclosure Value
		 
        Map<Id, cec_Enclosure__c> enclosureById = new Map<Id, cec_Enclosure__c>([SELECT Id, ItemValue__c FROM cec_Enclosure__c WHERE Id IN:enclosureIds ]);

        System.debug('*********enclosureIds************' + enclosureIds);
        System.debug('*********enclosureById ************' + enclosureById );

        for (cec_Fulfilment__c fulfilmentObj : fulfilmentList) {

            fulfilmentObj.TotalEnclosureValue__c = 0;

            if (fulfilmentObj.Enclosure1__c != null && enclosureById.get(fulfilmentObj.Enclosure1__c).ItemValue__c != null
                    && String.isNotBlank(fulfilmentObj.Enclosure1_Quantity__c)) {
                fulfilmentObj.TotalEnclosureValue__c = enclosureById.get(fulfilmentObj.Enclosure1__c).ItemValue__c * Integer.valueOf(fulfilmentObj.Enclosure1_Quantity__c);

                System.debug('*********enclose1************' + fulfilmentObj.TotalEnclosureValue__c);
            } if (fulfilmentObj.Enclosure2__c != null && enclosureById.get(fulfilmentObj.Enclosure2__c).ItemValue__c != null
                    && String.isNotBlank(fulfilmentObj.Enclosure2_Quantity__c)) {
                fulfilmentObj.TotalEnclosureValue__c += enclosureById.get(fulfilmentObj.Enclosure2__c).ItemValue__c * Integer.valueOf(fulfilmentObj.Enclosure2_Quantity__c);

                System.debug('*********enclose2************' + fulfilmentObj.TotalEnclosureValue__c);
            } if (fulfilmentObj.Enclosure3__c != null && enclosureById.get(fulfilmentObj.Enclosure3__c).ItemValue__c != null
                    && String.isNotBlank(fulfilmentObj.Enclosure3_Quantity__c)) {
                fulfilmentObj.TotalEnclosureValue__c += enclosureById.get(fulfilmentObj.Enclosure3__c).ItemValue__c * Integer.valueOf(fulfilmentObj.Enclosure3_Quantity__c);

                System.debug('*********enclose3************' + fulfilmentObj.TotalEnclosureValue__c);
            } if (fulfilmentObj.Enclosure4__c != null && enclosureById.get(fulfilmentObj.Enclosure4__c).ItemValue__c != null
                    && String.isNotBlank(fulfilmentObj.Enclosure4_Quantity__c)) {
                fulfilmentObj.TotalEnclosureValue__c += enclosureById.get(fulfilmentObj.Enclosure4__c).ItemValue__c * Integer.valueOf(fulfilmentObj.Enclosure4_Quantity__c);

                System.debug('*********enclose4************' + fulfilmentObj.TotalEnclosureValue__c);
            } if (fulfilmentObj.Enclosure5__c != null && enclosureById.get(fulfilmentObj.Enclosure5__c).ItemValue__c != null
                    && String.isNotBlank(fulfilmentObj.Enclosure5_Quantity__c)) {
                fulfilmentObj.TotalEnclosureValue__c += enclosureById.get(fulfilmentObj.Enclosure5__c).ItemValue__c * Integer.valueOf(fulfilmentObj.Enclosure5_Quantity__c);

                System.debug('*********enclose5************' + fulfilmentObj.TotalEnclosureValue__c);
            }

        }
    }
}