/**********************************************************************
Name:  CEC_FulfilmentHelperExtension
Copyright Â© 2016  Unilever
======================================================================
=======================================================================
Purpose: This is the Helper class for cec_Fulfilment__c trigger
=======================================================================
=======================================================================
History
-------
VERSION  AUTHOR              DATE            DETAIL                        Description
1.0       mahesh konar       20th july 2016   CSC-4844                      Sonar Fixes

***********************************************************************/
public with sharing class  CEC_FulfilmentHelperExtension {
    
     /**
    This method is used to check quality and update QA flag
    @param : fulfilmentList - List of cec_Fulfilment__c objects that are to be inserted
    @return : void 
    **/
    public static void qualityCheck(List<cec_Fulfilment__c> fulfilmentList) {


        // try{
        //System.debug('~~~~In CEC_FulfilmentHelper');




        User loggedinuser = [select Quality_Check_Percentage__c, Max_Refund_Amount__c from User where id = :UserInfo.getUserId()];

        Double QualityPercent =  loggedinuser.Quality_Check_Percentage__c;

        //Double qualityMaxRefund = loggedinuser.Max_Refund_Amount__c;

        //System.debug('~~~~QualityPercent  ' + QualityPercent );
        //System.debug('~~~~loggedinuser.Quality_Check_Percentage__c ' + loggedinuser.Quality_Check_Percentage__c);

        Double randomnumber = Math.random() * 100;
        System.debug('~~~~randomnumber ' + randomnumber );

        if (Test.isRunningTest()) {
            randomnumber = 0.00;
            QualityPercent  = 1.00;
            //qualityMaxRefund = 1.00;
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

    /**
    This method is used to update Account details for DOB and Local Identifier
    @param :fulfilment List- List of new values from trigger context variable
    oldFulfilmentMap - Trigger context variable for old details
    */
    public static void updateAccountDetails(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_Fulfilment__c> oldFulfilmentMap) {
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
    This method is used to update E-Voucher value after fulfillment approval.
    @param : fulfilment List- List of new values from trigger context variable
    oldFulfilmentMap - Trigger context variable for old details
    */
    public static void updateEvoucherValue(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_Fulfilment__c> oldFulfilmentMap) {

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
    public static void updateFulfilmentApprovedDate(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_Fulfilment__c> oldFulfilmentMap) {
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

    public static void beforeInsUpdCalcEnclosure(List<cec_Fulfilment__c> fulfilmentList, Map<Id, cec_fulfilment__C> fulfilmentOldMap) {

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
    public static set<Id> getEnclosureIds(cec_Fulfilment__c fulfilmentObj) {
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
    public static void calcTotalEnclosure(set<Id> enclosureIds, List<cec_Fulfilment__c> fulfilmentList) {
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