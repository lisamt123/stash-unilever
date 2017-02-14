/**********************************************************************
Name:  VPM_PurchaseRequestsControllerExtension()
Copyright ? 2016  Unilever
======================================================================
======================================================================
Purpose:  Check business user role,accordingly show/hide fields,default field values,update object & save in "At a Glance" sections
1. GoldenData2
2. VPM_CordilleraGoldenData
3. VPM_SiriusGoldenData
4. VPM_FusionGoldenData
5. VPM_U2K2GoldenData
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Girish      --              INITIAL DEVELOPMENT       N/A
2.0 -    Epsita      29 June 2016    Check business user role,accordingly show/hide fields,default field values,update object & save in "At a Glance" sections
3.0 -    Ajay
4.0 -    Samrin      27 Oct 2016     IAVMD-2243                Warning Message on 'Submit' button 
5.0 -    Samrin      3 Nov 2016      IAVWD-2283                Rework Button Visibility - Bank Data User
6.0 -    Samrin      4 Nov 2016      IAVWD-2289                Update any Existing 'FLS In Country' Components
7.0 -    Samrin      28 Nov 2016     IAVMD-2722                MDM Rework Request for Fusion Region 
8.0 -    Samrin      30 Nov 2016     IAVMD-2751                Warning message on submit in rapid form for Fusion
9.0 -    Samrin      06 Jan 2017     IAVMD-2913                Rework fuctionality for MDM Ops (All Countries) 
****************************************************************************/

global with sharing class  VPM_PurchaseRequestsControllerExtension {
      
      public static final string STR_CONST_CORDILLERA='Cordillera';
      public static final string STR_CONST_FUSION='Fusion';
      public static final string STR_CONST_U2K2='U2K2';
      public static final string STR_CONST_SIRIUS='Sirius';
      public static final string STR_CONST_MDM='MDM';
      public static final string STR_CONST_MASTERDATA='Master';
      public static final string STR_CONST_FREIGHT='Freight';
      public static final string STR_CONST_FINANCE='Finance';
      public static final string STR_CONST_FLS='FLS';
      public static final string STR_CONST_PROCUREMENT='Procurement';
      public static final string STR_CONST_BUSREQ='Business Requestor';
      public static final string STR_CONST_CREATEREQTYPE='(Create)';
      public static final string STR_CONST_BANK='BANK';
      public static final string STR_CONST_DRAFT='Draft';
      public static final string STR_CONST_FREIGHTREWORK='Freight Requested Re-Work';
      public static final string STR_CONST_FLSREVIEW='FLS Review';
      public static final string STR_CONST_SAPBPM = 'SAP BPM Approval Rejected';
      public static final string STR_CONST_COMPLETED='Completed';
      public static final string STR_CONST_YES='Yes';
      public static final string STR_CONST_NO='No';
      public static final string STR_CONST_SWITZERLAND='Switzerland';
      public static final string STR_CONST_UK='United Kingdom';
    public static final string STR_CONST_INDIA='India';
      public static final string STR_CONST_NEPAL='Nepal';
    public static final string STR_CONST_SRILANKA='Sri Lanka';
     public static string PIVendorType = '';

      public static final string STR_CONST_EXCEPTIONDEBUGMSG='@@Exception ';
      public static final string STR_CONST_CALLJAVASCRIPTMETHOD = '<script> redirectToListView(); </script>';
      public String vendorReqId {get; set;}
      public String usrRole {get; set;}
      public boolean renderSAPBtn {get; set;}
      public boolean manuallyMarkAsCompleteBtn  {get; set;}
      public boolean reworkBtn  {get; set;}
      public boolean enableSendToSAPBtn {get; set;}
      public String venReqStatus {get; set;}
      public string callJavaScriptAlert{get;set;}
      public string AlertMsg{get;set;}
      public Boolean isDisplay {get;set;}
      public string recId{get;set;}
      public string commodityApproverId{get;set;}
      //public static string recId1{get;set;}
      public boolean manuallyMarkAsCompleteFlag {get;set;}
      public boolean showManuallyMarkAsComplete {get;set;}
      public boolean submitRequestBtn {get; set;}
      public boolean isBR {get; set;}
      public boolean isFLS {get; set;}
      public boolean isMDM {get; set;}
      public boolean isMasterMDM {get;set;}
      public boolean isFinance {get; set;}
      public boolean isProcure {get; set;}
      public boolean isRussian {get; set;}
      public boolean isFreight {get; set;}
      public boolean isBank {get; set;}
      public boolean isCordillera {get; set;}
      public boolean isIsVendorSMEVisible {get; set;}
      public boolean isGBCountry {get; set;}
      public boolean isExceptionTypeRequired {get; set;}
      public VPM_PurchasingRequests__c pr{get;set;}  
      public string userlang{get;set;}
      public string isVenderSME{get;set;}
      public string exceptionType{get;set;} 
      public string internationalVersion{get;set;}
      public boolean isRequired{get;set;}
      public string userLanguage{get;set;}
      public boolean isApprover1{get;set;}
      public boolean isApprover2{get;set;}
      public boolean isApprover3{get;set;}
      public boolean isApprover4{get;set;}
      public boolean isApprover5{get;set;}
      public boolean isApprover6{get;set;}
      public boolean isApprover7{get;set;}
      public boolean isApprover8{get;set;}
      public boolean isApprover9{get;set;}
      public boolean isApprover10{get;set;}
      
      public string buttonValue{get;set;}
      public string approvalWorker{get;set;}
      public string approvalWorkerID{get;set;}
      public string approvalWorkerName{get;set;}
      public  List<SelectOption> paymentTerms{get;set;}
      public string vendorDefaultPaymentTerm{get;set;}  
      public string vendorPaymentTerms{get;set;}
      public static final string PAYMENT_TERMS = 'Payment Terms';
      list<VPM_PurchasingRequests__c> vendorDetailList;
       VPM_PurchasingRequests__c vendor;
       List<VPM_PurchasingRequests__c> vendorDetailOrg;
       List<VPM_CommodityApprover__c> commodityApprovers;
      
      ApexPages.StandardController GstdController;
      ApexPages.StandardSetController GstdControllerSet; 
    
        public VPM_PurchaseRequestsControllerExtension (ApexPages.StandardSetController stdSet) {
        //try{
          GstdControllerSet =stdSet;
          recId = stdSet.getRecord().Id; 
          commodityApproverId = UserInfo.getUserId();
      
          
          this.pr= (VPM_PurchasingRequests__c)stdSet.getRecord(); 
          system.debug('11-------------isProcure------'+isProcure);
          isBR  = false;
          isFLS = false;
          isMDM = false;
          isMasterMDM = false;
          isFinance = false;
          isProcure = false;
          isRussian = false;
          isFreight = false;
          this.checkUser() ;
        //}
        //catch(exception ex){system.debug(STR_CONST_EXCEPTIONDEBUGMSG +  ex.getstacktracestring());}
    }
      public VPM_PurchaseRequestsControllerExtension (ApexPages.StandardController stdController) {
          try{
          GstdController =stdController;
          recId = stdController.getRecord().Id; 
          //errorMsg=getError();
          userLanguage = UserInfo.getLanguage();
          this.pr= (VPM_PurchasingRequests__c)stdController.getRecord(); 
          //recId1 = stdController.getRecord().Id; 
          
          isBR  = false;
          isFLS = false;
          isMDM = false;
          isMasterMDM = false;
          isFinance = false;
          isProcure = false;
          isRussian = false;
          isFreight = false;
          isBank = false;
          
          this.checkUser();
          venReqStatus = fetchRecordStatus(recId);
          isRequired = false;
        
          vendorDetailList =[select OwnerId,VPM_VendorType__c,VPM_GlobalAuthorisationGroup__c, VPM_IsVendorSME__c,VPM_ECC__c, VPM_PaymentTerms__c,VPM_VendorCode__c,
          VPM_PaymentTermsIfNoneSelected__c,VPM_Country__c,VPM_CompanyCode__r.VPM_CompanyCode__c, VPM_CompanyCode__r.ECC__c, VPM_isBR__c,
          VPM_ApprovalWorker__c, VPM_ApprovalWorkerID__c, VPM_ExceptionType__c, VPM_InternationalVersion__c, 
          VPM_Status__c, VPM_CountryRequestingVendor__c,VPM_FLSInCountryReqVen__c,VPM_BankKey__c,VPM_BankAccountNumber__c from VPM_PurchasingRequests__c where id =: recId];
          System.debug('%%%%vendorDetailList ===='+vendorDetailList );
          
          list<QueueSobject> QueueSobjectList =[Select Queue.Name From QueueSobject where QueueId =: vendorDetailList[0].OwnerId];
          System.debug('@@@@@@@@ QueueSobjectList --------'+ QueueSobjectList );
          System.debug('-------inside constructor of extn-------'+stdController.getRecord().Id + '  ' + venReqStatus);
          if(String.isNotBlank(venReqStatus) && (venReqStatus.equalsIgnoreCase('MDM Ops Review') ||  venReqStatus.equalsIgnoreCase('MDM Ops Review - SAP ECC submit Failed')||
                                                 venReqStatus.equalsIgnoreCase('MDM Ops Review - SAP BPM submit Failed'))){
                                                     enableSendToSAPBtn = true;
                                                 } else {
                                                     enableSendToSAPBtn = false;  
                                                 }
          vendorDetailOrg = vendorDetailList.deepClone();
          vendorPaymentTerms = vendorDetailList[0].VPM_PaymentTerms__c;
          system.debug('@@ vendorPaymentTerms' + vendorPaymentTerms);   
                
          if(string.isBlank(vendorDetailList[0].VPM_VendorCode__c)){
              vendorDetailList[0].VPM_VendorCode__c = 'Vendor Not Created';
          }
          /* Logic to get Payment terms values from custom setting */
         
       System.debug('@@@@@@@@#######-'+ paymentTerms);                                         
       System.debug('@@@@@@@@#######vendorDetailList[0].VPM_PaymentTerms__c-'+ vendorDetailList[0].VPM_PaymentTerms__c);
       //System.debug('@@@@@@@@#######vendorDefaultPaymentTerm-'+vendorDefaultPaymentTerm);
       
            
       
    /* Start Samrin Shaikh : Changes : 27 -Oct : IAVMD-2243 :  Warning Message on 'Submit' button */
       if(VendorDetailList[0].VPM_FLSInCountryReqVen__c && VendorDetailList[0].VPM_Status__c.contains(STR_CONST_DRAFT) )
       {
         if(VendorDetailList[0].VPM_CountryRequestingVendor__c.contains(STR_CONST_UK))
         {
            //AlertMsg= System.label.VPM_Record_Submit_Warning;
            AlertMsg=System.label.VPM_UKFLSEnabled;
            isDisplay=true;
         }
         else if(VendorDetailList[0].VPM_CountryRequestingVendor__c.contains(STR_CONST_SWITZERLAND) ||
                 VendorDetailList[0].VPM_CountryRequestingVendor__c.contains(STR_CONST_INDIA) ||
                 VendorDetailList[0].VPM_CountryRequestingVendor__c.contains(STR_CONST_NEPAL) ||
                 VendorDetailList[0].VPM_CountryRequestingVendor__c.contains(STR_CONST_SRILANKA)
                )
         {
            //AlertMsg=System.label.VPM_Record_Submit_Warning;
            AlertMsg=System.label.VPM_SwitzerlandFLSEnabled;
            isDisplay=true;
         }

        }
        else 
        {
            isDisplay=False;
        } 
 /*End  Samrin Shaikh : Changes : 27 -Oct : IAVMD-2243 : Warning Message on 'Submit' button */
    //Added by Epsita - IAVMD-1169
        if(vendorDetailList[0].VPM_Country__c.contains('United Kingdom') || vendorDetailList[0].VPM_Country__c.contains('Ireland')){
            isIsVendorSMEVisible = true;
        }
        else{
            isIsVendorSMEVisible = false;
        }   
        
        //Added by Epsita - IAVMD-1169 | Modified for IAVMD-1934 story
        if(vendorDetailList[0].VPM_Country__c.startsWith('GB')){
            isGBCountry = true;
        }
        else{
            isGBCountry = false;
        }   
        if(vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_CORDILLERA){
            isCordillera = true;
        }
            
        //End of IAVMD-1169
        changeButtonValues1(); // To set button value in Procurement at a Glance
           
          usrRole = checkLoggedInUserRole();
          EnableManuallyMarkAsCompleteBtn();   
          
          userlang = [select LanguageLocaleKey from User where Id=:UserInfo.getUserId()].LanguageLocaleKey;
                  system.debug('@@userlang=' +userlang);
                  System.debug(''+ usrRole );
                   submitRequestBtn = true; // Ajay : Initially true becz it should be visible to all except MDM
              
          if(usrRole == STR_CONST_MDM) {
              renderSAPBtn = true;
              showManuallyMarkAsComplete =true;
              if(vendorDetailList[0].VPM_Status__c =='Request Completed'){
              manuallyMarkAsCompleteBtn= true;
              }//SubmitRequestBtn = false;
          }
          else if(usrRole == 'FRE') { // && QueueSobjectList[0].Queue.Name.containsIgnoreCase(STR_CONST_FREIGHT)
              reworkBtn=true;
                renderSAPBtn = false;
              //  SubmitRequestBtn = true;
          }
          else if(usrRole ==  'FIN') { //&& QueueSobjectList[0].Queue.Name.containsIgnoreCase(STR_CONST_FINANCE)
              reworkBtn=true;
                renderSAPBtn = false;
               //SubmitRequestBtn = true;
          }
          else if(usrRole ==  'PRO' && QueueSobjectList[0].Queue.Name.containsIgnoreCase(STR_CONST_PROCUREMENT)) {
              reworkBtn=true;
                renderSAPBtn = false;
                submitRequestBtn = true;
          }
           else if(usrRole ==  STR_CONST_FLS ) { //&& QueueSobjectList[0].Queue.Name.containsIgnoreCase(STR_CONST_FLS)
               
              reworkBtn=true;
              renderSAPBtn = false;
               /* Changes for Bug : 277 Point 2 */
              if(String.isNotBlank(venReqStatus) && (venReqStatus.equalsIgnoreCase('FLS Approved'))){
                  reworkBtn=false;
                }//SubmitRequestBtn = true;
          }
            else if(usrRole ==  'BUR') {
             
                renderSAPBtn = false;
                reworkBtn=false;
                //SubmitRequestBtn = true;
          }
            else if(usrRole ==  'RUS') {
             
                renderSAPBtn = false;
                reworkBtn=true;
                submitRequestBtn = true;
          }
            else if(usrRole ==  'FRE') {
             
                renderSAPBtn = false;
                reworkBtn=true;
               // SubmitRequestBtn = true;
          }
          /* Start of Chanegs 490 : Bank data Validation */
          else if(usrRole ==  STR_CONST_BANK && QueueSobjectList[0].Queue.Name.containsIgnoreCase('ECC')) {
              reworkBtn=true;
              renderSAPBtn = true;
              
          }
            /* End of Chanegs 490 : Bank data Validation  */ 
          if(vendorDetailList[0].VPM_Status__c.contains('Rejected'))
          {
           renderSAPBtn = false;
           submitRequestBtn = false;
           manuallyMarkAsCompleteBtn= true;
          }
            /* Start of Changes : 595 & 277 Disable the rework & Submit button */   
          if((String.isNotBlank(venReqStatus) && venReqStatus.contains('Re-Work')) 
             || 
             (String.isNotBlank(venReqStatus) && venReqStatus.contains('SAP'))
             ||
              (String.isNotBlank(venReqStatus) && venReqStatus.contains(STR_CONST_DRAFT))
             ||
             (String.isNotBlank(venReqStatus) && venReqStatus.contains(STR_CONST_MDM))
             ||
             (String.isNotBlank(venReqStatus) && venReqStatus.contains('BPM'))
            )    
          {
              reworkBtn=false;
          }
          /* Changes on 21 Sept 2016 : 1350 Submit button visibility */
               if(
             (String.isNotBlank(venReqStatus) && venReqStatus.contains(STR_CONST_DRAFT))
)
               {
              submitRequestBtn=true;
          }
              else {
            submitRequestBtn=false;
              }
          /* End  of Changes : 595 & 277 Disable the rework & Submit button */
            /* Changes By Samrin on 28 Nov 2016 - MDM Rework Request */ 
              // if(VendorDetailList[0].VPM_Status__c.containsIgnoreCase(VPM_RecordTypeHelper.MDM_REVIEW) &&  vendorDetailList[0].VPM_ECC__c == STR_CONST_FUSION){
              /*Changes By Samrin on 6th Jan 2017 -  IAVMD-2913  Rework fuctionality for MDM Ops (All Countries) */   
               if((VendorDetailList[0].VPM_Status__c.containsIgnoreCase(VPM_RecordTypeHelper.MDM_REVIEW) || VendorDetailList[0].VPM_Status__c.containsIgnoreCase(STR_CONST_SAPBPM)) && (usrRole == STR_CONST_MDM)){
                   reworkBtn=true;    }
              
              /* End Changes By Samrin on 28 Nov 2016 - MDM Rework Request */   
              
          vendorReqId = stdController.getRecord().Id;
          setPaymentTermsDefaultValues();

          System.debug('@@@@@@@@@@ SubmitRequestBtn  -------------------'+submitRequestBtn );
              System.debug('@@@@@@@@@@ reworkBtn  -------------------'+reworkBtn );
      }
      catch(exception ex){system.debug(STR_CONST_EXCEPTIONDEBUGMSG +  ex.getstacktracestring());}
      }
    
 /******************************************************************** 
    
    Created By   : Epsita Maharana
    Created Date : 30th September 2016
    Last Modify  : 25th October 2016
    Description  : VPM - Used to set default values for payment terms field based on 'Is Vendor SME' & 'ECC'
    Return Type  : void
    ********************************************************************/ 

    public void setPaymentTermsDefaultValues(){
     system.debug('Enter 1');
        if(isProcure && isGBCountry && (vendorDetailOrg[0].VPM_IsVendorSME__c!= pr.VPM_IsVendorSME__c ) && string.isBlank(vendorDetailList[0].VPM_PaymentTermsIfNoneSelected__c)){
                if((pr.VPM_IsVendorSME__c==STR_CONST_NO || string.isBlank(pr.VPM_IsVendorSME__c)) && (vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_U2K2)){
                  vendorPaymentTerms = VPM_RecordTypeHelper.PAYMENT_TERM_S090;
                }else if((pr.VPM_IsVendorSME__c==STR_CONST_NO || string.isBlank(pr.VPM_IsVendorSME__c)) && (vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_FUSION)){
                  vendorPaymentTerms = VPM_RecordTypeHelper.PAYMENT_TERM_90DK;
                }else if((pr.VPM_IsVendorSME__c==STR_CONST_NO || string.isBlank(pr.VPM_IsVendorSME__c)) && (vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_SIRIUS || vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_CORDILLERA)){  
                  vendorPaymentTerms = VPM_RecordTypeHelper.PAYMENT_TERM_P090; 
                }else if(pr.VPM_IsVendorSME__c==STR_CONST_YES && (vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_SIRIUS || vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_CORDILLERA)){
                  vendorPaymentTerms = VPM_RecordTypeHelper.PAYMENT_TERM_P030;
                }else if(pr.VPM_IsVendorSME__c==STR_CONST_YES && vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_U2K2){
                  vendorPaymentTerms = VPM_RecordTypeHelper.PAYMENT_TERM_S030;
                }else if(pr.VPM_IsVendorSME__c==STR_CONST_YES && (vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_FUSION)){
                  vendorPaymentTerms = VPM_RecordTypeHelper.PAYMENT_TERM_30DK;
                }                
           }else if((isProcure || isMDM || isFinance || isFreight || isRussian) && (string.isBlank(vendorDetailList[0].VPM_PaymentTerms__c) && string.isBlank(vendorDetailList[0].VPM_PaymentTermsIfNoneSelected__c))){
                    if(vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_U2K2){
                      vendorPaymentTerms = VPM_RecordTypeHelper.PAYMENT_TERM_S090;
                    }else if(vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_FUSION){
                      vendorPaymentTerms = VPM_RecordTypeHelper.PAYMENT_TERM_90DK;
                    }else if(vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_SIRIUS || vendorDetailList[0].VPM_CompanyCode__r.ECC__c == STR_CONST_CORDILLERA){  
                      vendorPaymentTerms = VPM_RecordTypeHelper.PAYMENT_TERM_P090;
                    }
    
               }
           pr.VPM_PaymentTerms__c = vendorPaymentTerms;
            
            if(string.isNotBlank(vendorDetailList[0].VPM_VendorType__c) && string.isNotBlank(vendorDetailList[0].VPM_GlobalAuthorisationGroup__c)){
                 if((vendorDetailList[0].VPM_VendorType__c.equals(VPM_RecordTypeHelper.VENDOR_TYPE_PI)) || (vendorDetailList[0].VPM_VendorType__c.equals(VPM_RecordTypeHelper.VENDOR_TYPE_SCS_SUPPLY) && (vendorDetailList[0].VPM_GlobalAuthorisationGroup__c.containsIgnoreCase(VPM_RecordTypeHelper.GLOBAL_AUTH_3PM)))){
                                    PIVendorType ='PI';
                
                 } else if(!vendorDetailList[0].VPM_VendorType__c.equals(VPM_RecordTypeHelper.VENDOR_TYPE_PI) && (vendorDetailList[0].VPM_VendorType__c.equals(VPM_RecordTypeHelper.VENDOR_TYPE_SCS_SUPPLY) && !vendorDetailList[0].VPM_GlobalAuthorisationGroup__c.containsIgnoreCase(VPM_RecordTypeHelper.GLOBAL_AUTH_3PM))){
                                    
                                    PIVendorType ='Non PI';
                  
                 } else{
                                    PIVendorType ='other';
                   
                 }
                                system.debug('@@ PI Vendor Type' + PIVendorType);
           }
           paymentTerms = VPM_RecordTypeHelper.paymentTermsMetaData(vendorDetailList[0].VPM_CompanyCode__r.ECC__c,PIVendorType,vendorPaymentTerms);       
    }
   /******************************************************************** 
    
    Created By   : Ajay Rawat
    Created Date : 30th September 2016
    Last Modify  : 25th October 2016
    Description  : VPM - This method is used by MDM for creating, maintaining , extending vendor request into SAP
    Return Type  : void
    ********************************************************************/ 

      public void callSendToSAPAPI() {
          System.debug('-----id of vendor request record is-----'+vendorReqId);
          String responseString='';
          list<VPM_PurchasingRequests__c> vendorList = [SELECT RecordTypeId,VPM_Status__c,VPM_isVendorCached__c,VPM_Fieldtype__c ,VPM_VendorCodeLookup__r.mdm_ecc__c,VPM_CompanyCode__r.ECC__c from VPM_PurchasingRequests__c where id=:vendorReqId limit 1];
            VPM_PurchasingRequests__c vendor = [SELECT id,VPM_MDMOpsFirstSubmittedToSAP__c from VPM_PurchasingRequests__c where id=:vendorReqId limit 1]; 
               if(vendorList[0].VPM_Status__c =='MDM Ops Review')
                      {
                          vendor.VPM_MDMOpsFirstSubmittedToSAP__c=system.now();
                          
                      }
              
              list<RecordType> RecordTypeList =[SELECT Name from RecordType where id=:vendorList[0].RecordTypeId limit 1];
                system.debug('entering condition 1');
                system.debug('RecordTypeList[0].Name '+RecordTypeList[0].Name);
              if(RecordTypeList[0].Name.contains(STR_CONST_CREATEREQTYPE)) {
              system.debug('condition 1');
              
                 if(!vendorList[0].VPM_isVendorCached__c)
                 {
                  responseString = VPM_CreateVendorServiceHelper.createVendor(vendorReqId);
                  }
                  else
                  {
                   responseString = VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorReqId);
                  }
                  System.debug('-----response string from create vendor mule api----' + responseString);
                  //responseString= responseString.replace(';', '\n');
                  system.debug('@@@responseString '+responseString);
                   //callJavaScriptAlert='<script>responseString = \''+responseString+'\'.replace(";", "/\n/\"); alert(\''+responseString+'\'); pageReload();</script>';
                  // callJavaScriptAlert='<script>alert(\''+responseString+'\'); pageReload();</script>';
                   callJavaScriptAlert='<script>var msgString =\''+responseString+'\';msgString=msgString.split(\';\').join(\'\\n\');alert(msgString); pageReload();</script>';
              } else if(RecordTypeList[0].Name.contains('(Extend)')) {
                  if(vendorList[0].VPM_VendorCodeLookup__r.mdm_ecc__c.containsIgnoreCase(vendorList[0].VPM_CompanyCode__r.ECC__c))
                   {
                  System.debug('-----calling extend global vendor mule api----');
                 
                  if(vendorList[0].VPM_Fieldtype__c == 'Global'){
                      responseString = VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorReqId);
                   }else if(vendorList[0].VPM_Fieldtype__c == 'Regional'){
                       responseString = VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorReqId);
                   }else if(vendorList[0].VPM_Fieldtype__c == 'both')
                   {
                   system.debug('call service 1');
                   if(!vendorList[0].VPM_isVendorCached__c)
                   {
                     responseString = VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorReqId);
                   }
                   else
                   {
                      responseString = VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorReqId);
                   }  
                     system.debug('call service 2');
                    // responseString = VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorReqId);
                   }
                   else{
                   responseString = VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorReqId);
                       //responseString ='Since you haven\'t Edited/Modified any fields in the Advance Form there is no data to be maintained, Hence you cannot send the record to SAP';
                    }                   
                   }
                   else
                   {
                     responseString = VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorReqId);
                   }
                    system.debug(responseString);
                    responseString= string.isNotBlank(responseString) ? responseString.replace('\'','') : '';
                    system.debug(responseString);
                   //callJavaScriptAlert='<script>alert(\''+responseString+'\'); pageReload();</script>';
                    callJavaScriptAlert='<script>var msgString =\''+responseString+'\';msgString=msgString.split(\';\').join(\'\\n\');alert(msgString); pageReload();</script>';
              }else if(RecordTypeList[0].Name.contains('(Maintain)')) {
                  
                  System.debug('-----calling extend global vendor mule api----');
                  if(vendorList[0].VPM_Fieldtype__c == 'Global'){
                      responseString = VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorReqId);
                   }else if(vendorList[0].VPM_Fieldtype__c == 'Regional'){
                       responseString = VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorReqId);
                  }else if(vendorList[0].VPM_Fieldtype__c == 'both')
                   {
                   system.debug('call service 1');
                     if(!vendorList[0].VPM_isVendorCached__c)
                   {
                     responseString = VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorReqId);
                   }
                   else
                   {
                      responseString = VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorReqId);
                   }
                     system.debug('call service 2');
                    // responseString = VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorReqId);
                   }
                   else
                   responseString ='Since you haven\'t Edited/Modified any fields in the Advance Form there is no data to be maintained, Hence you cannot send the record to SAP';
                    system.debug(responseString);
                    
                    responseString= string.isNotBlank(responseString) ? responseString.replace('\'','') : '';
                    system.debug(responseString);
                   //callJavaScriptAlert='<script>alert(\''+responseString+'\'); pageReload();</script>';
                    callJavaScriptAlert='<script>debugger;var msgString =\''+responseString+'\';msgString=msgString.split(\';\').join(\'\\n\');alert(msgString); pageReload();</script>';
               }
              update vendor;
              
      }
      
  /******************************************************************** 
    
    Created By   : Epsita Maharana
    Created Date : 30th September 2016
    Last Modify  : 25th October 2016
    Description  : VPM - Used to set user role based on the permission sets assigned. Business Requestor is the base Permission set assigned to all users. Any permissions above BR
                   will be considered while setting the user role. i.e Permission set of highest order to be considered. 
    Return Type  : void
    ********************************************************************/      
      
      @RemoteAction
      global static map<string,string> checkForBusinessReqUser() {
          
          boolean brUser = false;
          String userRole = '';
          String strUserRole = 'userRole';
          String strBrUser = 'brUser';
          // List<PermissionSetAssignment> lstcurrentUserPerSet= new  List<PermissionSetAssignment>();
          List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.Label, AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() AND (NOT PermissionSet.Label like '%Business Requestor%') AND PermissionSet.Name LIKE 'VPM_%'  order by PermissionSet.Label DESC];
          //System.Debug('----list of permission sets assigned to logged in user------' + lstcurrentUserPerSet);
          
           for (PermissionSetAssignment psa: lstcurrentUserPerSet) {
          // system.debug('---------psa.PermissionSet.Label---------' + psa.PermissionSet.Label);
          if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_FLS)) {
              brUser = false;
              userRole = 'FLS';
              map<string,string> returnResult = new map<string,string>{strBrUser=>brUser?'true':'false',strUserRole=>userRole};
              return returnResult;
          } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_MDM)) {
              brUser = false;
              userRole = 'MDM';
               map<string,string> returnResult = new map<string,string>{strBrUser=>brUser?'true':'false',strUserRole=>userRole};
              return returnResult;
          } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_FINANCE)) {
              brUser = false;
              userRole = 'FIN';
               map<string,string> returnResult = new map<string,string>{strBrUser=>brUser?'true':'false',strUserRole=>userRole};
              return returnResult;
          } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_PROCUREMENT)) {
              brUser = false;
              userRole = 'PRO';
               map<string,string> returnResult = new map<string,string>{strBrUser=>brUser?'true':'false',strUserRole=>userRole};
              return returnResult;
          } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_BUSREQ)) 
          {
              brUser = true;
              userRole = 'BUR';
              // System.debug('----is user brUser----'+brUser);
               map<string,string> returnResult = new map<string,string>{'brUser'=>brUser?'true':'false',strUserRole =>userRole};
              return returnResult;
          }
           }
            brUser = true;
             userRole = 'BUR';
          map<string,string> returnResult = new map<string,string>{'brUser'=>brUser?'true':'false',strUserRole =>userRole};
              return returnResult;
      }

  /******************************************************************** 
    
    Created By   : Epsita Maharana
    Created Date : 30th September 2016
    Last Modify  : 25th October 2016
    Description  : VPM - Used to identify type of logged in user 
    Return Type  : void
    ********************************************************************/           
    
       public void checkUser() {
          List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.Label, AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() AND (NOT PermissionSet.Label like '%Business Requestor%') order by PermissionSet.Label DESC];
          system.debug('---------------Permission--------------'+lstcurrentUserPerSet[0].PermissionSet.Label);
          for (PermissionSetAssignment psa: lstcurrentUserPerSet ) {
          if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_FLS)) {
              isFLS = true;
              return;
          } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_MDM)) {
              isMDM = true;
              return ;
          } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_FINANCE)) {
              isFinance = true;
               return;
          } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_PROCUREMENT)) {
              isProcure = true;
               return;
          } else if(psa.PermissionSet.Label.containsIgnoreCase('Russian')) {
              isRussian = true;
               return;
          } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_FREIGHT)) {
              isFreight = true;
               return;
          } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_MASTERDATA)){
              isMAsterMDM = true;
               return;
          } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_BANK)){
              isBank = true;
              return;
          }
          }
          isBR =true;
      }
      
      @RemoteAction
      global static String checkLoggedInUserRole() {
          String userRole='';
          
          // List<PermissionSetAssignment> lstcurrentUserPerSet= new  List<PermissionSetAssignment>();
          List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.Label, AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() AND (NOT PermissionSet.Label like '%Business Requestor%') order by PermissionSet.Label DESC];
          //System.Debug('----list of permission sets assigned to logged in user------' + lstcurrentUserPerSet);

          for (PermissionSetAssignment psa: lstcurrentUserPerSet) {
              system.debug('---------psa.PermissionSet.Label---------' + psa.PermissionSet.Label);
              if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_FLS)) {
                  userRole = 'FLS';
                  return userRole;
              } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_MDM)) {
                  userRole = 'MDM';
                  return userRole;
              } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_FINANCE)) {
                  userRole = 'FIN';
                  return userRole;
              } else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_PROCUREMENT)) {
                  userRole = 'PRO';
                  return userRole;
              } 
                else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_FREIGHT)) {
                  userRole = 'FRE';
                  return userRole;
              }
              else if(psa.PermissionSet.Label.containsIgnoreCase('Russian Tax')) {
                  userRole = 'RUS';
                  return userRole;
              }
              /*  Start : Changes for 490 Bank Data Validation Approver  */
              else if(psa.PermissionSet.Label.containsIgnoreCase(STR_CONST_BANK)) {
                  userRole = 'BANK';
                  return userRole;
              }
               /* End Changes for 490 Bank Data Validation Approver */
              
          }
          userRole = 'BUR';          
          return userRole;
      }
       
      public String fetchRecordStatus(String recId) {
          String reqStatus='';
          List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c FROM VPM_PurchasingRequests__c WHERE
                                                        Id = :recId LIMIT 1];        
          if(vendorList != null && vendorList.size() >0) {
              reqStatus = vendorList.get(0).VPM_Status__c;
          }
          return reqStatus;
      }
      

  /******************************************************************** 
    
    Created By   : Ajay Rawat
    Created Date : 30th September 2016
    Last Modify  : 25th October 2016
    Description  : VPM - Used to mark request complete for block/unblock/delete/undelete request
    Return Type  : void
    ********************************************************************/     
    
      public void ManuallyMarkAsCompleteAction(){
          //PageReference congratsPage = null; 
          List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c,OwnerId, CreatedById, VPM_DeletionBlockFlag__c FROM VPM_PurchasingRequests__c WHERE
                                                        Id = :recId LIMIT 1];
          //list<PermissionSetAssignment> permissionAssigned =[SELECT Assignee.Name, PermissionSet.Name ,id FROM PermissionSetAssignment
          //                                                   WHERE AssigneeId =:recId AND PermissionSet.Name ='VPM_MDM_Ops' limit 1];
          system.debug('heheheh='+vendorList);
          if(vendorList[0].VPM_Status__c.contains('Block') || vendorList[0].VPM_Status__c.contains('Unblock')
             || vendorList[0].VPM_Status__c.contains('Delete') || vendorList[0].VPM_Status__c.contains('Undelete')) {
                 vendorList[0].VPM_Status__c = 'Request Completed';
                 vendorList[0].OwnerId = vendorList[0].CreatedById;
                 vendorList[0].VPM_DeletionBlockFlag__c=null;
                 update vendorList;
                 manuallyMarkAsCompleteFlag =false;
                 callJavaScriptAlert='<script> pageReload(); </script>';
                 //congratsPage =  new PageReference('/' + recID);
             }
          else{
              callJavaScriptAlert='<script> func(); </script>';
              }
              
      } 
 
 /******************************************************************** 
    
    Created By   : Ajay Rawat
    Created Date : 30th September 2016
    Last Modify  : 25th October 2016
    Description  : VPM - Used to enable disable button as per logged in user. Currently enabled for MDMOps User
    Return Type  : void
    ********************************************************************/         
      public void EnableManuallyMarkAsCompleteBtn(){
          try
          {
              list<VPM_PurchasingRequests__c> vendorList = [SELECT RecordTypeId from VPM_PurchasingRequests__c where id=:recId limit 1];
              list<RecordType> RecordTypeList =[SELECT Name from RecordType where id=:vendorList[0].RecordTypeId limit 1];
              if(RecordTypeList[0].Name.contains(STR_CONST_CREATEREQTYPE) )
              {
                  manuallyMarkAsCompleteFlag =false;
              }
              else{
                  manuallyMarkAsCompleteFlag =true;
               }
          }
          catch(exception ex){system.debug(STR_CONST_EXCEPTIONDEBUGMSG +  ex.getstacktracestring());}
      }

 /******************************************************************** 
    
    Created By   : Ajay Rawat
    Created Date : 30th September 2016
    Last Modify  : 25th October 2016
    Description  : VPM - Used to assign record back for rework based on last request with group. 
    Return Type  : void
    ********************************************************************/      
       public void ReworkAction()
       {
          try
          {
              
              callJavaScriptAlert='<script>redirectToListView(); </script>';
              
              list<VPM_PurchasingRequests__c> VendorDetailList =[SELECT  VPM_ApprovalWorker__c,
                                                                 VPM_ApprovalWorkerID__c,VPM_Status__c,VPM_CountryRequestingVendor__c,
                                                                 VPM_RussianTaxApprovalRequired__c,VPM_RequestFromFLSOrBR__c, 
                                                                 VPM_RequestGroupTime__c, 
                                                                 VPM_FreightApprovalRequired__c, 
                                                                 VPM_RequestLastWithGroup__c,VPM_MDMOpsReworks__c, 
                                                                 VPM_FinanceApprovalRequired__c, 
                                                                 VPM_ProcurementApprovalRequired__c, 
                                                                 CreatedById, OwnerId, VPM_Rework__c,
                                                                 VPM_BankDataValidationRequired__c,VPM_ProcurementReworks__c
                                                                 FROM VPM_PurchasingRequests__c WHERE id= : recId LIMIT 1];
                
              System.debug('@@@@@ Rework :::----'+ VendorDetailList);
              string query ='\''+'%'+VendorDetailList[0].VPM_CountryRequestingVendor__c+'\'';
              string queryString ='SELECT Id, Name  FROM Group  WHERE Type = \'Queue\' AND NAME LIKE \'%FLS%\' AND  NAME LIKE '+query+'  Limit 1';
                System.debug('@@@@@ Rework :::----'+ queryString);              
                // Ajay : BR submitted to FLS now FLS is sending for rework
              if (VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_BUSREQ && VendorDetailList[0].VPM_Status__c==STR_CONST_FLSREVIEW) 
              { 
                  VendorDetailList[0].VPM_Status__c = 'FLS Requested Re-Work'; 
                  VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById;
                  VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;
                  //VendorDetailList[0].VPM_RequestGroupTime__c=System.now();
                  VendorDetailList[0].VPM_RequestLastWithGroup__c = 'FLS';
                  VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                  VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                  update VendorDetailList;

                  
              }
              // Ajay : Adv BR submitted to Pro now Pro is sending for rework
              else if (VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_BUSREQ && 
              VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING && VendorDetailList[0].VPM_ProcurementApprovalRequired__c )
              {
                  VendorDetailList[0].VPM_Status__c = 'Procurement Requested Re-Work'; 
                  VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById;
                  VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;
                  VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Procurement';
                  VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                  VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                  VendorDetailList[0].VPM_ProcurementReworks__c = VendorDetailList[0].VPM_ProcurementReworks__c + 1;
                  update VendorDetailList;
              }
              // Ajay : Adv BR submitted to FIN now FIN is sending for rework
              else if (VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_BUSREQ && 
              VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING && 
              VendorDetailList[0].VPM_FinanceApprovalRequired__c && 
             !VendorDetailList[0].VPM_BankDataValidationRequired__c    &&    
              !VendorDetailList[0].VPM_FreightApprovalRequired__c
              && !VendorDetailList[0].VPM_ProcurementApprovalRequired__c)
              {
                  system.debug('####');
                  VendorDetailList[0].VPM_Status__c = 'Finance Requested Re-Work'; 
                  VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                  VendorDetailList[0].VPM_Rework__c = STR_CONST_YES; 
                  VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Finance'; 
                  VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                  VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                  update VendorDetailList;
              }
           
             // Ajay : Adv FLS submitted to PRO now PRO is sending for rework
              else if (VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_FLS && VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING 
              && VendorDetailList[0].VPM_ProcurementApprovalRequired__c )
              {
                //  list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name =: STR_CONST_FLS Limit 1];
                     list<Group> queueList = dataBase.query(queryString);
                  if (queueList.size() == 1){ 
                      VendorDetailList[0].VPM_Status__c = 'Procurement Requested Re-Work'; 
                      VendorDetailList[0].OwnerId=queueList[0].Id; 
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Procurement'; 
                      VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;  
                      VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                      VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                      VendorDetailList[0].VPM_ProcurementReworks__c = VendorDetailList[0].VPM_ProcurementReworks__c + 1;
                      update VendorDetailList;
                  } 
              }
              // Ajay : Adv PRO submitted to FIN now FIN is sending for rework
              else if (!VendorDetailList[0].VPM_ProcurementApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_FreightApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_RussianTaxApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_BankDataValidationRequired__c  &&
                    VendorDetailList[0].VPM_FinanceApprovalRequired__c  &&
                     VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING &&
                     VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_FLS) 
              { 
                  //list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name =: STR_CONST_FLS Limit 1];
                    list<Group> queueList = dataBase.query(queryString);
                  if (queueList.size() == 1){                     
                      VendorDetailList[0].VPM_Status__c = 'Finance Requested Re-Work';                   
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Finance'; 
                      VendorDetailList[0].OwnerId=queueList[0].Id; 
                      VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;  
                      VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                      VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                      update VendorDetailList;
                  } 
              } 
             
             // Ajay : Adv FLS submitted to RUS now RUS is sending for rework
               //else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'FLS' && VendorDetailList[0].VPM_Status__c == 'Approval Pending' && VendorDetailList[0].VPM_RussianTaxApprovalRequired__c) 
              else if (!VendorDetailList[0].VPM_ProcurementApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_FreightApprovalRequired__c  &&
                    VendorDetailList[0].VPM_RussianTaxApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_BankDataValidationRequired__c    &&
                    !VendorDetailList[0].VPM_FinanceApprovalRequired__c  &&
                     VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING &&
                     VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_FLS) 
              { 
                 // list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = : STR_CONST_FLS Limit 1];
                    list<Group> queueList = dataBase.query(queryString);
                  if (queueList.size() == 1){                     
                      VendorDetailList[0].VPM_Status__c = 'Russian Custom Tax Requested Re-Work'; 
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Russian Custom Tax'; 
                      VendorDetailList[0].OwnerId=queueList[0].Id;
                      VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;  
                      VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                      VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                      update VendorDetailList;
                  } 
              }
//Samrin Shaikh
              // Ajay : Adv FLS submitted to FRE now FRE is sending for rework
                //else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'FLS' && VendorDetailList[0].VPM_Status__c == 'Approval Pending' && VendorDetailList[0].VPM_FreightApprovalRequired__c) 
              else if (!VendorDetailList[0].VPM_ProcurementApprovalRequired__c  &&
                    VendorDetailList[0].VPM_FreightApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_RussianTaxApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_FinanceApprovalRequired__c  &&
                     VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING &&
                     VendorDetailList[0].VPM_RequestFromFLSOrBR__c==STR_CONST_FLS) 
              {                   
                 //list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = : STR_CONST_FLS Limit 1];
                  list<Group> queueList = dataBase.query(queryString);
                  if (queueList.size() == 1){                     
                      VendorDetailList[0].VPM_Status__c = STR_CONST_FREIGHTREWORK; 
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = STR_CONST_FREIGHT; 
                      VendorDetailList[0].OwnerId=queueList[0].id;
                      VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;  
                      VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                      VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                      update VendorDetailList;
                  } 
              }
              
               // Changes Start 30 Sept : Freigth & Fina 
              
               //else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'FLS' && VendorDetailList[0].VPM_Status__c == 'Approval Pending' && VendorDetailList[0].VPM_FreightApprovalRequired__c) 
              else if (!VendorDetailList[0].VPM_ProcurementApprovalRequired__c  &&
                    VendorDetailList[0].VPM_FreightApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_RussianTaxApprovalRequired__c  &&
                     VendorDetailList[0].VPM_FinanceApprovalRequired__c  &&
                     VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING &&
                     VendorDetailList[0].VPM_RequestFromFLSOrBR__c==STR_CONST_FLS) 
              { 
                 // list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = : STR_CONST_FLS Limit 1];
                  list<Group> queueList = dataBase.query(queryString);
                  if (queueList.size() == 1){                     
                      VendorDetailList[0].VPM_Status__c = STR_CONST_FREIGHTREWORK; 
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = STR_CONST_FREIGHT; 
                      VendorDetailList[0].OwnerId=queueList[0].Id;
                      VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;  
                      VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                      VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                      update VendorDetailList;
                  } 
              }
              // Ajay : Adv BR submitted to RUS now RUS is sending for rework
               //else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == STR_CONST_BUSREQ && VendorDetailList[0].VPM_Status__c == 'Approval Pending' && VendorDetailList[0].VPM_RussianTaxApprovalRequired__c) 
              else if (!VendorDetailList[0].VPM_ProcurementApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_FreightApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_BankDataValidationRequired__c    &&
                    VendorDetailList[0].VPM_RussianTaxApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_FinanceApprovalRequired__c  &&
                     VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING &&
                     VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_BUSREQ ) 
              { 
                      VendorDetailList[0].VPM_Status__c = 'Russian Custom Tax Requested Re-Work'; 
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Russian Custom Tax'; 
                      VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                      VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;  
                      VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                      VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                      update VendorDetailList;
            

              }
              
              //Samrin Shaikh 
              // Ajay : Adv BR submitted to FRE now FRE is sending for rework
               // else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == STR_CONST_BUSREQ  && VendorDetailList[0].VPM_Status__c == 'Approval Pending' && VendorDetailList[0].VPM_FreightApprovalRequired__c) 
              else if (!VendorDetailList[0].VPM_ProcurementApprovalRequired__c  &&
                    VendorDetailList[0].VPM_FreightApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_RussianTaxApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_FinanceApprovalRequired__c  &&
                     VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING &&
                     VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_BUSREQ) 
              { 
                     VendorDetailList[0].VPM_Status__c = STR_CONST_FREIGHTREWORK; 
                     VendorDetailList[0].VPM_RequestLastWithGroup__c = STR_CONST_FREIGHT;
                     VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                     VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;  
                     VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                     VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                     update VendorDetailList;
                  //
                  //AssigneeApproval(VendorDetailList[0].OwnerId,recId);
              }
              
              // Changes Start 30 Sept : Freigth & Fina 
              
              // else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == STR_CONST_BUSREQ  && VendorDetailList[0].VPM_Status__c == 'Approval Pending' && VendorDetailList[0].VPM_FreightApprovalRequired__c) 
              else if (!VendorDetailList[0].VPM_ProcurementApprovalRequired__c  &&
                    VendorDetailList[0].VPM_FreightApprovalRequired__c  &&
                    !VendorDetailList[0].VPM_RussianTaxApprovalRequired__c  &&
                    VendorDetailList[0].VPM_FinanceApprovalRequired__c  &&
                     VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING &&
                     VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_BUSREQ) 
              { 
                     VendorDetailList[0].VPM_Status__c = STR_CONST_FREIGHTREWORK; 
                     VendorDetailList[0].VPM_RequestLastWithGroup__c = STR_CONST_FREIGHT;
                     VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                     VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;  
                     VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                     VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                     update VendorDetailList;
                  //
                  //AssigneeApproval(VendorDetailList[0].OwnerId,recId);
              }
              // Bank Data Validation Rework Cases   
              // Ajay : Adv FLS submitted to FRE now FRE is sending for rework
               else if (VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_FLS && 
                        VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING
                        && VendorDetailList[0].VPM_BankDataValidationRequired__c) 
              
              { 
                 //list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'ECC' Limit 1];
                 list<Group> queueList = dataBase.query(queryString);
                  if (queueList.size() == 1){                     
                      VendorDetailList[0].VPM_Status__c = 'Bank Data Validation Requested Re-Work'; 
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Bank Data'; 
                      VendorDetailList[0].OwnerId=queueList[0].Id;
                      VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;  
                      VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                      VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                      update VendorDetailList;
                      //
                      //AssigneeApproval(VendorDetailList[0].OwnerId,recId);
                  } 
              }
              // Ajay : Adv BR submitted to FRE now FRE is sending for rework
                else if (VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_BUSREQ  && VendorDetailList[0].VPM_Status__c == VPM_RecordTypeHelper.APPROVALPENDING && VendorDetailList[0].VPM_BankDataValidationRequired__c) 
              { 
                     VendorDetailList[0].VPM_Status__c = 'Bank Data Validation Requested Re-Work'; 
                     VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Bank Data';
                     VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                     VendorDetailList[0].VPM_Rework__c=STR_CONST_YES;  
                     VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                     VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                     update VendorDetailList;
                  //
                  //AssigneeApproval(VendorDetailList[0].OwnerId,recId);
              }/* Start  changes by samrin Shaikh :  28 Nov 2016 : MDM Ops Rework request */ 
              // when BR Create Request 
                   else if (VendorDetailList[0].VPM_RequestFromFLSOrBR__c== STR_CONST_FLS  && (VendorDetailList[0].VPM_Status__c.containsIgnoreCase(VPM_RecordTypeHelper.MDM_REVIEW) || VendorDetailList[0].VPM_Status__c.containsIgnoreCase(STR_CONST_SAPBPM))) 
              { 
                    
                  System.debug('@@@@@ Inside Rework MDM');
                  list<Group> queueList = dataBase.query(queryString);
                  System.debug('@@@@@ Inside Rework MDM' + queueList);
                  if (queueList.size() == 1){ 
                     VendorDetailList[0].VPM_Status__c = VPM_RecordTypeHelper.MDM_RE_WROK; 
                     VendorDetailList[0].OwnerId = queueList[0].Id; 
                     VendorDetailList[0].VPM_Rework__c=STR_CONST_NO; 
                     VendorDetailList[0].VPM_IsLock__c=False ;
                     VendorDetailList[0].VPM_AdvancedFormSubmitted__c ='';
                     VendorDetailList[0].VPM_IsInApprovalProcess__c ='';
                     VendorDetailList[0].VPM_FinanceApprovalRequired__c= false;
                     VendorDetailList[0].VPM_ProcurementApprovalRequired__c= false;
                     VendorDetailList[0].VPM_FreightApprovalRequired__c= false;
                     VendorDetailList[0].VPM_RussianTaxApprovalRequired__c= false;
                     VendorDetailList[0].VPM_BankDataValidationRequired__c= false;
                     VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                     VendorDetailList[0].VPM_ApprovalWorker__c='';
                     VendorDetailList[0].VPM_RequestLastWithGroup__c = 'MDM Ops'; 
                     VendorDetailList[0].VPM_MDMOpsReworks__c = VendorDetailList[0].VPM_MDMOpsReworks__c +1;
                     update VendorDetailList;
                  }
              }
              // When FLS Create Request 
               else if (VendorDetailList[0].VPM_RequestFromFLSOrBR__c==  STR_CONST_BUSREQ  && (VendorDetailList[0].VPM_Status__c.containsIgnoreCase(VPM_RecordTypeHelper.MDM_REVIEW) || VendorDetailList[0].VPM_Status__c.containsIgnoreCase(STR_CONST_SAPBPM))) 
              { 
                      System.debug('@@@@@ Inside Rework MDM');
                      VendorDetailList[0].VPM_Status__c = VPM_RecordTypeHelper.MDM_RE_WROK; 
                     //VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Bank Data';
                      VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                      VendorDetailList[0].VPM_Rework__c=STR_CONST_NO; 
                      VendorDetailList[0].VPM_IsLock__c=False ;
                      VendorDetailList[0].VPM_AdvancedFormSubmitted__c ='';
                      VendorDetailList[0].VPM_IsInApprovalProcess__c ='';
                      VendorDetailList[0].VPM_FinanceApprovalRequired__c= false;
                      VendorDetailList[0].VPM_ProcurementApprovalRequired__c= false;
                      VendorDetailList[0].VPM_FreightApprovalRequired__c= false;
                      VendorDetailList[0].VPM_RussianTaxApprovalRequired__c= false;
                      VendorDetailList[0].VPM_BankDataValidationRequired__c= false;
                      VendorDetailList[0].VPM_ApprovalWorkerID__c='';
                      VendorDetailList[0].VPM_ApprovalWorker__c=''; 
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = 'MDM Ops'; 
                       VendorDetailList[0].VPM_MDMOpsReworks__c = VendorDetailList[0].VPM_MDMOpsReworks__c +1;
                     update VendorDetailList;
              }
              
               /*End changes by samrin Shaikh :  28 Nov 2016 : MDM Ops Rework request */ 
              
          }
          catch(exception ex){
          system.debug(STR_CONST_EXCEPTIONDEBUGMSG +  ex.getstacktracestring());
          }
      }
 /******************************************************************** 
    
    Created By   : Ajay Rawat
    Created Date : 30th September 2016
    Last Modify  : 25th October 2016
    Description  : VPM - Used by BR to assign request to FLS
    Return Type  : void
    ********************************************************************/         
         public void SubmitRequestAction()
      {
     //callJavaScriptAlert='<script> redirectToListView(); </script>';
      System.debug('SubmitRequestAction');
         try{
               list<VPM_PurchasingRequests__c> VendorDetailList =[SELECT  VPM_Status__c,VPM_AdvancedFormSubmitted__c , VPM_FLSInCountryReqVen__c, VPM_BusinessRequestorSubmitted__c, VPM_Rework__c, OwnerId
                                                                 FROM VPM_PurchasingRequests__c WHERE id= : recId LIMIT 1];
                  
                  System.debug('@@@@@@ VendorDetailList '+VendorDetailList);
                  // Ajay : Open Advanceform for Non FLS in country
                   if(!VendorDetailList[0].VPM_FLSInCountryReqVen__c && (VendorDetailList[0].VPM_AdvancedFormSubmitted__c == STR_CONST_NO || VendorDetailList[0].VPM_AdvancedFormSubmitted__c ==null) )
                  { 
                        callJavaScriptAlert='<script> openAdvanceform(); </script>';
                  } 

                  // Ajay : BR submitted to FLS
                    else if(VendorDetailList[0].VPM_Status__c.contains(STR_CONST_DRAFT) ) 
                  { 
                       
                       // callJSfunc='<script> Alert(); </script>';
                        VendorDetailList[0].VPM_BusinessRequestorSubmitted__c=STR_CONST_YES; 
                        VendorDetailList[0].VPM_Rework__c='No'; 
                        VendorDetailList[0].VPM_RequestLastWithGroup__c=STR_CONST_BUSREQ; 
                        VendorDetailList[0].VPM_RequestFromFLSOrBR__c=STR_CONST_BUSREQ;
                        update VendorDetailList;
                        callJavaScriptAlert='<script> pageReload(); </script>';
                 }

                  // Ajay : BR reworked and  submitted to FLS
              else if (VendorDetailList[0].VPM_Status__c.contains('FLS Requested Re-Work') && VendorDetailList[0].VPM_Rework__c==STR_CONST_YES) 
                  { 

                  VendorDetailList[0].VPM_Status__c= STR_CONST_FLSREVIEW; 
                  VendorDetailList[0].VPM_Rework__c=STR_CONST_COMPLETED; 
                  VendorDetailList[0].VPM_RequestLastWithGroup__c='Business Requestor'; 
                  List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = : STR_CONST_FLS Limit 1];
                   if (QueueList.size() == 1)
                      {       
                        VendorDetailList[0].OwnerId=QueueList[0].QueueId; 
                      } 
                   update VendorDetailList;
                      // Commented as per Bug : 277 Point 1 
                     //callJavaScriptAlert='<script> redirectToListView(); </script>';
                     callJavaScriptAlert='<script> pageReload(); </script>';
                    
                  }
                   // Ajay : FLS reworked and  submitted to PRO
                  else if (VendorDetailList[0].VPM_Status__c.contains('Procurement Requested Re-Work') && VendorDetailList[0].VPM_Rework__c==STR_CONST_YES) 
                  { 
                  List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name =: STR_CONST_PROCUREMENT Limit 1];
                  if (QueueList.size() == 1)
                      { 
                      VendorDetailList[0].VPM_Status__c = VPM_RecordTypeHelper.APPROVALPENDING; 
                      VendorDetailList[0].VPM_AdvancedFormSubmitted__c=STR_CONST_YES; 
                      VendorDetailList[0].VPM_Rework__c=STR_CONST_COMPLETED; 
                      //VendorDetailList[0].VPM_RequestLastWithGroup__c='FLS'; 
                     VendorDetailList[0].OwnerId=QueueList[0].QueueId;  
                      } 
                      update VendorDetailList;
                     callJavaScriptAlert=STR_CONST_CALLJAVASCRIPTMETHOD;
                       // Redirect();
                  }
                  // Ajay : FLS reworked and  submitted to FIN
                  else if (VendorDetailList[0].VPM_Status__c.contains('Finance Requested Re-Work') && VendorDetailList[0].VPM_Rework__c==STR_CONST_YES) 
                      { 
                      List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name =: STR_CONST_FINANCE Limit 1];
                      if (QueueList.size() == 1)
                          { 
                          VendorDetailList[0].VPM_Status__c = VPM_RecordTypeHelper.APPROVALPENDING; 
                          VendorDetailList[0].VPM_Rework__c=STR_CONST_COMPLETED; 
                          VendorDetailList[0].VPM_AdvancedFormSubmitted__c=STR_CONST_YES; 
                          //VendorDetailList[0].VPM_RequestLastWithGroup__c='FLS'; 
                           VendorDetailList[0].OwnerId=QueueList[0].QueueId; 
                          } 
                      update VendorDetailList;
                      callJavaScriptAlert=STR_CONST_CALLJAVASCRIPTMETHOD;
                     // Redirect();

                      } 
                      // Ajay : FLS reworked and  submitted to RUS
                       else if (VendorDetailList[0].VPM_Status__c.contains('Russian Custom Tax Requested Re-Work') && VendorDetailList[0].VPM_Rework__c==STR_CONST_YES) 
                      { 
                      List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'Russian Custom Tax' Limit 1];
                      if (QueueList.size() == 1)
                          { 
                          VendorDetailList[0].VPM_Status__c = VPM_RecordTypeHelper.APPROVALPENDING;
                          VendorDetailList[0].VPM_Rework__c=STR_CONST_COMPLETED; 
                          VendorDetailList[0].VPM_AdvancedFormSubmitted__c=STR_CONST_YES; 
                          //VendorDetailList[0].VPM_RequestLastWithGroup__c='FLS'; 
                           VendorDetailList[0].OwnerId=QueueList[0].QueueId; 
                          } 
                      update VendorDetailList;
                        callJavaScriptAlert=STR_CONST_CALLJAVASCRIPTMETHOD;
                      // Redirect();

                      } 
                      // Ajay : FLS reworked and  submitted to FRE
                       else if (VendorDetailList[0].VPM_Status__c.contains(STR_CONST_FREIGHTREWORK) && VendorDetailList[0].VPM_Rework__c==STR_CONST_YES) 
                      { 
                      List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name =: STR_CONST_FREIGHT Limit 1];
                      if (QueueList.size() == 1)
                          { 
                          VendorDetailList[0].VPM_Status__c = VPM_RecordTypeHelper.APPROVALPENDING; 
                          VendorDetailList[0].VPM_Rework__c=STR_CONST_COMPLETED; 
                          VendorDetailList[0].VPM_AdvancedFormSubmitted__c='No'; 
                          //VendorDetailList[0].VPM_RequestLastWithGroup__c='FLS'; 
                           VendorDetailList[0].OwnerId=QueueList[0].QueueId; 
                          } 
                      update VendorDetailList;
                       callJavaScriptAlert=STR_CONST_CALLJAVASCRIPTMETHOD;
                      // Redirect();

                      } 
             // Changes for 490 Bank Data Rework Case
          else if (VendorDetailList[0].VPM_Status__c.contains('Bank Data Validation Requested Re-Work') && VendorDetailList[0].VPM_Rework__c==STR_CONST_YES) 
                      { 
                      List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'ECC' Limit 1];
                      if (QueueList.size() == 1)
                          { 
                          VendorDetailList[0].VPM_Status__c = VPM_RecordTypeHelper.APPROVALPENDING; 
                          VendorDetailList[0].VPM_Rework__c=STR_CONST_COMPLETED; 
                          VendorDetailList[0].VPM_AdvancedFormSubmitted__c=STR_CONST_YES; 
                          //VendorDetailList[0].VPM_RequestLastWithGroup__c='FLS'; 
                           VendorDetailList[0].OwnerId=QueueList[0].QueueId; 
                          } 
                      update VendorDetailList;
                      callJavaScriptAlert=STR_CONST_CALLJAVASCRIPTMETHOD;
                      // Redirect();

                      }              
          }
          catch(exception ex){system.debug(STR_CONST_EXCEPTIONDEBUGMSG  +  ex.getstacktracestring());}
      } 

/******************************************************************** 
    
    Created By   : Epsita Maharana
    Created Date : 30th September 2016
    Last Modify  : 25th October 2016
    Description  : VPM - Used to return to record detail page on click of 'Cancel' button
    Return Type  : PageReference 
    ********************************************************************/ 
      public PageReference cancelFromUser(){
           return null;
       }
       
/******************************************************************** 
    
    Created By   : Epsita Maharana
    Created Date : 30th September 2016
    Last Modify  : 25th October 2016
    Description  : VPM - Used to check if 'Payment Terms' is set to none,save/update purchasing request object & return to detail page
    Return Type  : PageReference 
    ********************************************************************/       
        public PageReference saveFromUser(){           
         try{
          if(!isBR && !isFLS && !isBank && string.isBlank(vendorPaymentTerms) && string.isBlank(pr.VPM_PaymentTermsIfNoneSelected__c)){
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,System.label.VPM_PaymentTermsIfNoneSelected));
           }  
           /*if(string.isBlank(pr.VPM_BankAccountNumber__c)){
              ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Bank Key mandatory'));
           }  */        
           else {
                
                    pr.VPM_PaymentTerms__c = vendorPaymentTerms;
                    update pr;
                    PageReference save = GstdController.save();
                    if(save != null){
                        callJavaScriptAlert='<script> pageReload(); </script>';  
                    }  
              }
           }
           catch(Exception e){
              ApexPages.addMessages(e);
          }   
          return null;                      
       }
      
       public void saveUserValues(){
                
        changeButtonValues();
       }

/******************************************************************** 
    
    Created By   : Epsita Maharana
    Created Date : 30th September 2016
    Last Modify  : 25th October 2016
    Description  : VPM - Used to indicate that a record is being worked upon by a user by setting the user's details
                   in the approval worker fields.Button text toggle logic based on the user action.
    Return Type  : void 
    ********************************************************************/         
       public void changeButtonValues(){
        VPM_PurchasingRequests__c vendorDetailList1 =[select OwnerId, VPM_ApprovalWorker__c,VPM_ApprovalWorkerID__c from VPM_PurchasingRequests__c where id =: recId];
                
        if(vendorDetailList1.VPM_ApprovalWorkerID__c== null || string.isBlank(vendorDetailList1.VPM_ApprovalWorkerID__c)){  //Text should change to "I am working on this"
            
             vendorDetailList1.VPM_ApprovalWorker__c = UserInfo.getName(); 
            vendorDetailList1.VPM_ApprovalWorkerID__c = UserInfo.getUserId(); 
            buttonValue = system.label.VPM_NoLongerWorkingOnIt; 
            approvalWorkerName=UserInfo.getName();
                 
         }
         else { 
             system.debug('Changing to '+system.label.VPM_IAmWorkingOnIt);
               vendorDetailList1.VPM_ApprovalWorkerID__c  = null;
             vendorDetailList1.VPM_ApprovalWorker__c = null;
              approvalWorkerName=''; 
             buttonValue = system.label.VPM_IAmWorkingOnIt;  
              
         }
           update vendorDetailList1;
          }
         
        
           /******************************************************************** 
            Created By   : Vaishali Nagar
            Created Date : 26th July 2016
            Last Modify  :
            Description  : DML commented on constructor
            Return Type  : void
            ********************************************************************/
         
     public void changeButtonValues1(){
        VPM_PurchasingRequests__c vendorDetailList1 =[select OwnerId, VPM_ApprovalWorker__c,VPM_ApprovalWorkerID__c from VPM_PurchasingRequests__c where id =: recId];
        approvalWorkerName=vendorDetailList1.VPM_ApprovalWorker__c;
          
        if(vendorDetailList1.VPM_ApprovalWorkerID__c== null || string.isBlank(vendorDetailList1.VPM_ApprovalWorkerID__c)){  //Text should change to "I am working on this"
           buttonValue = system.label.VPM_IAmWorkingOnIt;    
         } 
         else { 
               buttonValue = system.label.VPM_NoLongerWorkingOnIt;
              }
         
     }
    
    public void brStatusMethod() {
        VPM_PurchasingRequests__c brpr =[select id , vpm_isBr__c from VPM_PurchasingRequests__c where id =: recid];
         system.debug('@@vpm_isBr__c' + brpr.vpm_isBr__c);
        if(isBR) {
          brpr.VPM_isBR__c = true;
          update brPr;
        }
    }
}