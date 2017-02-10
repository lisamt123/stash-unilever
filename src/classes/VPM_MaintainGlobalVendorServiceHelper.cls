/*********************************************************************************************************
Name:  VPM_MaintainGlobalVendorServiceHelper 
Copyright ? 2016  Unilever
==========================================================================================================
==========================================================================================================
Purpose:  This class has been used to do apex callout for 'maintain' & 'extend' web service and get the
their JSON response parsed. 

==========================================================================================================
==========================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Ajay       07-09-2016         maintainECCVendor         This method is used to do 'Regional maintain/extend' callout
2.0 -    Deepak     10-10-2016         maintainGlobalVendor      This method is used to do 'Global maintain/extend' callout                        
**********************************************************************************************************/
global with sharing class VPM_MaintainGlobalVendorServiceHelper {
    
    /*
       
       This is wrapper class used to fetch response from Mule.
    
    */
    global class errorMsgWrapper
    {
        public String Message {get;set;}
        public String MessageV1 {get;set;}
        public String MessageNo {get;set;}

        public String Type {get;set;}
        public String ID {get;set;}
        
    }

    global class errorMsg
    {
      List<errorMsgWrapper> SAP_Messages;
    }
    global class MaintainGlobalVendorResponse { 
        public String status {get; set;}
        public String bpmID {get; set;}
        public String message {get; set;}
        public String statusCode {set; get;}
        
    }
    
    /*
                       This Method is get called when we click on Send to SAP button for 'Global Maintain/Extend' scenario.
        Author      :  Deepak Moudekar
        Parameter   :  VPM_PurchasingRequests__c object Id.
        Description :  It's perform the apex callout 'PUT' method to send JSON payload to Mule.In response it fetch JSON response & deserialize it.
     
    */
    global static String maintainGlobalVendor(String vendorId) {
        //try
        {
        //list<errorMsgWrapper> errorList;
        System.debug('----------input parameters passed are----------' + vendorId);
        String reqBodyJson ='',responseString='' ;
        MaintainGlobalVendorResponse maintainVenResp;
        VPM_MaintainVendorFetchFieldDetails clas = new VPM_MaintainVendorFetchFieldDetails();
        reqBodyJson = clas.VPM_ConvertMaintainVendorFieldDetailsToJSON(vendorId);
        System.debug('------json body of request is-----'+reqBodyJson);
        //VPM_HttpUtil utilClass = new VPM_HttpUtil();
        HttpResponse res = VPM_HttpUtil.sendRequest('PUT',reqBodyJson,'VPM_MaintainExtendGlobalVendorBPM',vendorId);
        System.debug('-----whloe response string-----'+ res.toString());
        System.debug('------HTTP response status and status code are ------'+res.getStatus() + '  ' + res.getStatusCode());
       

       VPM_PurchasingRequests__c VendorReq = [SELECT VPM_Fieldtype__c,VPM_VendorCodeLookup__r.mdm_ecc__c,VPM_CompanyCode__r.ECC__c, RecordType.DeveloperName  FROM VPM_PurchasingRequests__c WHERE id =: vendorId];
     try{  
       maintainVenResp = (MaintainGlobalVendorResponse) System.JSON.deserialize(res.getBody(), MaintainGlobalVendorResponse.class);
      }
    Catch(Exception ex)
    {
            if(ex.getmessage().containsIgnoreCase('unquoted character'))
            {
            responseString = System.Label.VPM_UnquotedError;
            }
            VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,responseString,VPM_HttpUtil.failStatusMDM);
            return responseString;
    }  
       
        
        string msg='';
        if(maintainVenResp.status != null) {
            msg = maintainVenResp.status;
        }
        system.debug('%%%% '+maintainVenResp);
         responseString = maintainVenResp.status;
        if(res.getStatusCode() == 200) {
         if(VendorReq.VPM_Fieldtype__c != 'Both'  && VendorReq.RecordType.DeveloperName == 'VPM_VendorReqMaintain')
            {
            responseString = System.Label.VPM_SendToSAPSuccessMessage+';'+maintainVenResp.status;
            VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.successStatusReqCompleted ,msg,VPM_HttpUtil.successStatusMDM);
           }
            else if(VendorReq.VPM_VendorCodeLookup__r.mdm_ecc__c.containsIgnoreCase(VendorReq.VPM_CompanyCode__r.ECC__c))
            {
            responseString = System.Label.VPM_SendToSAPSuccessMessage+';'+maintainVenResp.status;
            responseString =responseString +';'+VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorId);
            VPM_HttpUtil.updateFieldType(vendorId);
           VPM_HttpUtil.updateVendorMDMStatus(vendorId,null,msg,VPM_HttpUtil.successStatusMDM);
           }
           else
           {
                VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.successStatus,msg,VPM_HttpUtil.successStatusMDM);
           }
           
        } else if(res.getStatusCode() == 500) {
             //if(VendorReq.VPM_Fieldtype__c != 'Both')
            VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = System.Label.VPM_ServerError;
        } else if(res.getStatusCode() == 504) {
            // if(VendorReq.VPM_Fieldtype__c != 'Both')
            VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = System.Label.VPM_ConnectionError;
        } else if(res.getStatusCode() == 400) {
            // if(VendorReq.VPM_Fieldtype__c != 'Both')
            VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            //responseString = 'Please check request data and try again.';
        } else if(res.getStatusCode() == 503) {
           //  if(VendorReq.VPM_Fieldtype__c != 'Both')
            VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = System.Label.VPM_SAPError;
        } else {
            // if(VendorReq.VPM_Fieldtype__c != 'Both')
            VPM_HttpUtil.updateVendorMDMStatus(vendorId,VPM_HttpUtil.failStatus,msg,VPM_HttpUtil.failStatusMDM);
            responseString = System.Label.VPM_SAPRequstError;
        }
        return responseString;
    }
       /* catch(exception ex){
            system.debug('ex '+ex.getMessage()+'   '+ex.getLineNumber());
            return '';
        }*/
    }
    
     /*
                       This Method is get called when we click on Send to SAP button for 'Regional Maintain/Extend' scenario.
        Author      :  Ajay Rawat               
        Parameter   :  VPM_PurchasingRequests__c object Id.
        Description :  It's perform the apex callout 'PUT' method to send JSON payload to Mule.In response it fetch JSON response & deserialize it.
     
    */
    global static String maintainECCVendor(String vendorId) 
    {
        String reqBodyJson,responseString ='' ;
        MaintainGlobalVendorResponse maintainVenResp;
        //list<errorMsgWrapper> errorList;
        errorMsg errorList111 ;
       
        VPM_ECCMaintainExtendHelper ECCManintainService =new VPM_ECCMaintainExtendHelper();
        //reqBodyJson = maintainService.VPM_ConvertMaintainVendorFieldDetailsToJSON(vendorId);
        reqBodyJson  = ECCManintainService.VPM_ConvertMaintainVendorFieldDetailsToJSON(vendorId);
        system.debug('reqBodyJson '+reqBodyJson );
         
        //VPM_HttpUtil utilClass = new VPM_HttpUtil();
        HttpResponse res = VPM_HttpUtil.sendRequest('PUT',reqBodyJson,'VPM_ECCVendorSearch',vendorId);
        system.debug('reqBodyJson '+res.getBody());
    try{
        maintainVenResp = (MaintainGlobalVendorResponse) System.JSON.deserialize(res.getBody(), MaintainGlobalVendorResponse.class);
         system.debug('%%%% '+maintainVenResp);
        }
    Catch(Exception ex)
    {
            if(ex.getmessage().containsIgnoreCase('unquoted character'))
            {
            responseString = System.Label.VPM_UnquotedError;
            }
            VPM_HttpUtil.updateVendorECCStatus(vendorId,VPM_HttpUtil.ECCfailStatus,responseString,VPM_HttpUtil.failStatusECC);
            return responseString;
    }
        //string msg= '';
        system.debug('res '+res);
        system.debug('res body '+res.getBody());
        system.debug('res code'+res.getStatusCode());
        system.debug('maintainVenResp.status'+maintainVenResp.status);
        /*if(maintainVenResp.status != null) {
            msg = maintainVenResp.status;
        }*/
        //VPM_PurchasingRequests__c VendorReq = [SELECT VPM_ECC_InsertUpdateStatusMessage__c,VPM_fieldUpdated__c  FROM VPM_PurchasingRequests__c WHERE id =: vendorId];
        try
        {
        if(res.getStatusCode() == 200) {
         
            
             system.debug('JSON List '+res.getBody());
            responseString = System.Label.VPM_SendToSAPSuccessMessage;
            
            errorList111 = (errorMsg) System.JSON.deserialize(res.getBody(), errorMsg.class);
            for(errorMsgWrapper error : errorList111.SAP_Messages)
            {
                responseString = responseString+';'+error.Message+';';
                }
            VPM_HttpUtil.updateVendorECCStatus(vendorId,VPM_HttpUtil.successStatusReqCompleted ,responseString,VPM_HttpUtil.successStatusECC);    
            
            
        }  
        else
        {
           
            
            errorList111 = (errorMsg) System.JSON.deserialize(res.getBody(), errorMsg.class);
            system.debug('Error List 11= '+errorList111.SAP_Messages);
          
           if(errorList111.SAP_Messages != null)
          {
            for(errorMsgWrapper error : errorList111.SAP_Messages)
            {
                responseString = responseString+error.Message+';';
                }
           }
           else
           {
             responseString = maintainVenResp.message;
           }
            VPM_HttpUtil.updateVendorECCStatus(vendorId,VPM_HttpUtil.ECCfailStatus,responseString,VPM_HttpUtil.failStatusECC);
        } 

       
    }
    catch (exception ex)
    {
    system.debug('error occurred');
        
    }
        return responseString;
    }
    }