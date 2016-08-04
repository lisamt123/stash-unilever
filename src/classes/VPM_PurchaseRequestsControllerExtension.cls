global class  VPM_PurchaseRequestsControllerExtension {
      public String vendorReqId {get; set;}
      public String usrRole {get; set;}
      public boolean RenderSAPBtn {get; set;}
      public boolean ManuallyMarkasCompletebtn  {get; set;}
      public boolean ReworkBtn  {get; set;}
      public boolean enableSendToSAPBtn {get; set;}
      public String venReqStatus {get; set;}
      public string callJavaScriptAlert{get;set;}
      public string recId{get;set;}
      //public static string recId1{get;set;}
      public boolean ManuallyMarkAsCompleteFlag {get;set;}
      public boolean SubmitRequestBtn {get; set;}
      public boolean isBR {get; set;}
      public boolean isFLS {get; set;}
      public boolean isMDM {get; set;}
      public boolean isFinance {get; set;}
      public boolean isProcure {get; set;}
      public boolean isExceptionTypeRequired {get; set;}
      public VPM_PurchasingRequests__c pr{get;set;}  
      public string userlang{get;set;}
      public string isVenderSME{get;set;}
      public string exceptionType{get;set;} 
      public string internationalVersion{get;set;}
      public boolean isRequired{get;set;}
      public string buttonValue{get;set;}
      public string approvalWorker{get;set;}
      public string approvalWorkerID{get;set;}
       public string approvalWorkerName{get;set;}
      
      ApexPages.StandardController GstdController; 
      public VPM_PurchaseRequestsControllerExtension (ApexPages.StandardController stdController) {
          try{
          GstdController =stdController;
          recId = stdController.getRecord().Id; 
         
          //errorMsg=getError();
          
          this.pr= (VPM_PurchasingRequests__c)stdController.getRecord(); 
          //recId1 = stdController.getRecord().Id; 
          // callJavaScriptAlert='<script> func(); </script>';
          
          
          checkUser();
          venReqStatus = fetchRecordStatus(recId);
          isRequired = false;
            
          list<VPM_PurchasingRequests__c> vendorDetailList =[select OwnerId, VPM_IsVendorSME__c,VPM_CompanyCode__r.ECC__c,VPM_Approval_Worker__c,VPM_Approval_Worker_ID__c, VPM_ExceptionType__c,VPM_InternationalVersion__c,VPM_Status__c from VPM_PurchasingRequests__c where id =: recId];
          
          list<QueueSobject> QueueSobjectList =[Select Queue.Name From QueueSobject where QueueId =: vendorDetailList[0].OwnerId];
          System.debug('@@@@@@@@ QueueSobjectList --------'+ QueueSobjectList );
          System.debug('-------inside constructor of extn-------'+stdController.getRecord().Id + '  ' + venReqStatus);
          if(String.isNotBlank(venReqStatus) && (venReqStatus.equalsIgnoreCase('MDM Ops Review') || 
                                                 venReqStatus.equalsIgnoreCase('MDM Ops Review - SAP BPM submit Failed'))){
                                                     enableSendToSAPBtn = true;
                                                 } else {
                                                     enableSendToSAPBtn = false;  
                                                 }
         if(vendorDetailList[0].VPM_IsVendorSME__c=='No' && (vendorDetailList[0].VPM_CompanyCode__r.ECC__c == 'Sirius' || vendorDetailList[0].VPM_CompanyCode__r.ECC__c == 'Cordillera'))  
          pr.VPM_PaymentTerms__c = 'P090_Within 90 days Due net (90NET)';
          
         changeButtonValues1(); // To set button value in Procurement at a Glance
          
          usrRole = checkLoggedInUserRole();
          EnableManuallyMarkAsCompleteBtn();   
          
          userlang = [select LanguageLocaleKey from User where Id=:UserInfo.getUserId()].LanguageLocaleKey;
                  system.debug('@@userlang=' +userlang);
                  System.debug(''+ usrRole );
                   SubmitRequestBtn = true; // Ajay : Initially true becz it should be visible to all except MDM
          if(usrRole == 'MDM') {
              RenderSAPBtn = true;
              ManuallyMarkasCompletebtn= true;
              //SubmitRequestBtn = false;
          }
          else if(usrRole ==  'FRE' && QueueSobjectList[0].Queue.Name.contains('Freight')) {
              ReworkBtn=true;
                RenderSAPBtn = true;
              //  SubmitRequestBtn = true;
          }
          else if(usrRole ==  'FIN' && QueueSobjectList[0].Queue.Name.contains('Finance')) {
              ReworkBtn=true;
                RenderSAPBtn = true;
               //SubmitRequestBtn = true;
          }
          else if(usrRole ==  'PRO' && QueueSobjectList[0].Queue.Name.contains('Procurement')) {
              ReworkBtn=true;
                RenderSAPBtn = true;
                SubmitRequestBtn = true;
          }
           else if(usrRole ==  'FLS' && QueueSobjectList[0].Queue.Name.contains('FLS')) {
              ReworkBtn=true;
                RenderSAPBtn = true;
                //SubmitRequestBtn = true;
          }
            else if(usrRole ==  'BUR') {
             
                RenderSAPBtn = false;
                //SubmitRequestBtn = true;
          }
            else if(usrRole ==  'RUS') {
             
                RenderSAPBtn = false;
                ReworkBtn=true;
                SubmitRequestBtn = true;
          }
            else if(usrRole ==  'FRE') {
             
                RenderSAPBtn = false;
                ReworkBtn=true;
               // SubmitRequestBtn = true;
          }
          if(vendorDetailList[0].VPM_Status__c.contains('Rejected'))
          {
           RenderSAPBtn = false;
           SubmitRequestBtn = false;
           ManuallyMarkasCompletebtn= false;
          }
          

          //Ajay : Repeated code
          /*if(vendorDetailList[0].VPM_Status__c.contains('Rejected'))
          {
          RenderSAPBtn = false;
          ManuallyMarkasCompletebtn= false;
           SubmitRequestBtn = false;
          }*/
          
          vendorReqId = stdController.getRecord().Id;
          System.debug('@@@@@@@@@@ SubmitRequestBtn  -------------------'+SubmitRequestBtn );
      }
      catch(exception ex){}
      }
      
      public void callSendToSAPAPI() {
          System.debug('-----id of vendor request record is-----'+vendorReqId);
          String responseString='';
          list<VPM_PurchasingRequests__c> vendorList = [SELECT RecordTypeId,VPM_Fieldtype__c from VPM_PurchasingRequests__c where id=:vendorReqId limit 1];
              list<RecordType> RecordTypeList =[SELECT Name from RecordType where id=:vendorList[0].RecordTypeId limit 1];
               system.debug('entering condition 1');
                system.debug('RecordTypeList[0].Name '+RecordTypeList[0].Name);
              if(RecordTypeList[0].Name.contains('(Create)')) {
              system.debug('condition 1');
              
                  System.debug('-----calling create vendor mule api----');
                  responseString = VPM_CreateVendorServiceHelper.createVendor(vendorReqId);
                  System.debug('-----response string from create vendor mule api----' + responseString);
                  //responseString= responseString.replace(';', '\n');
                  system.debug('@@@responseString '+responseString);
                   //callJavaScriptAlert='<script>responseString = \''+responseString+'\'.replace(";", "/\n/\"); alert(\''+responseString+'\'); PageReload();</script>';
                  // callJavaScriptAlert='<script>alert(\''+responseString+'\'); PageReload();</script>';
                   callJavaScriptAlert='<script>var msgString =\''+responseString+'\';msgString=msgString.split(\';\').join(\'\\n\');alert(msgString); PageReload();</script>';
              } else if(RecordTypeList[0].Name.contains('(Extend)')) {
               system.debug('condition 2');
                  System.debug('-----calling extend global vendor mule api----');
                  //VPM_ExtendVendorGlobalHelper.extendVendorGlobal(vendorReqId);
                  // Ajay : Testing maintain ECC
                   if(vendorList[0].VPM_Fieldtype__c == 'Global')
                  responseString = VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorReqId);
               else if(vendorList[0].VPM_Fieldtype__c == 'Regional')
                  responseString = VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorReqId);
                  system.debug(responseString);
                   //responseString= responseString.replace(';', '\n');
                   
                   
                    callJavaScriptAlert='<script>var msgString =\''+responseString+'\';msgString=msgString.split(\';\').join(\'\\n\');alert(msgString); PageReload();</script>';
              } else if(RecordTypeList[0].Name.contains('(Maintain)')) {
              
                  System.debug('-----calling extend global vendor mule api----');
                  if(vendorList[0].VPM_Fieldtype__c == 'Global')
                  responseString = VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorReqId);
              else if(vendorList[0].VPM_Fieldtype__c == 'Regional')
                   responseString = VPM_MaintainGlobalVendorServiceHelper.maintainECCVendor(vendorReqId);
                   responseString= responseString.replace(';', '\n');
                   //callJavaScriptAlert='<script>alert(\''+responseString+'\'); PageReload();</script>';
                    callJavaScriptAlert='<script>var msgString =\''+responseString+'\';msgString=msgString.split(\';\').join(\'\\n\');alert(msgString); PageReload();</script>';
              }
      }
      
      @RemoteAction
      global static map<string,string> checkForBusinessReqUser() {
          
          boolean brUser = false;
          String userRole;
          // List<PermissionSetAssignment> lstcurrentUserPerSet= new  List<PermissionSetAssignment>();
          List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.Label, AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() order by PermissionSet.Label DESC];
          //System.Debug('----list of permission sets assigned to logged in user------' + lstcurrentUserPerSet);
          
          // for (PermissionSetAssignment psa: lstcurrentUserPerSet) {
          // system.debug('---------psa.PermissionSet.Label---------' + psa.PermissionSet.Label);
          if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('FLS')) {
              brUser = false;
              userRole = 'FLS';
              //return brUser;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('MDM')) {
              brUser = false;
              userRole = 'MDM';
              // return brUser;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Finance')) {
              brUser = false;
              userRole = 'FIN';
              // return brUser;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Procurement')) {
              brUser = false;
              userRole = 'PRO';
              //return brUser;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Business Requestor')) {
              brUser = true;
              userRole = 'BUR';
              // System.debug('----is user brUser----'+brUser);
              //return brUser;
          }
          // }
          map<string,string> returnResult = new map<string,string>{'brUser'=>brUser==true?'true':'false','userRole'=>userRole};
              return returnResult;
      }
      
      
       public void checkUser() {
          List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.Label, AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() order by PermissionSet.Label DESC];
          if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('FLS')) {
              isFLS = true;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('MDM')) {
              isMDM = true;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Finance')) {
              isFinance = true;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Procurement')) {
              isProcure = true;
          } else if(lstcurrentUserPerSet[0].PermissionSet.Label.contains('Business Requestor')) {
              isBR = true;
          }
      }
      
      @RemoteAction
      global static String checkLoggedInUserRole() {
          
          String userRole;
          // List<PermissionSetAssignment> lstcurrentUserPerSet= new  List<PermissionSetAssignment>();
          List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,PermissionSet.Label, AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() order by PermissionSet.Label DESC];
          //System.Debug('----list of permission sets assigned to logged in user------' + lstcurrentUserPerSet);

          for (PermissionSetAssignment psa: lstcurrentUserPerSet) {
              system.debug('---------psa.PermissionSet.Label---------' + psa.PermissionSet.Label);
              if(psa.PermissionSet.Label.contains('FLS')) {
                  userRole = 'FLS';
                  return userRole;
              } else if(psa.PermissionSet.Label.contains('MDM')) {
                  userRole = 'MDM';
                  return userRole;
              } else if(psa.PermissionSet.Label.contains('Finance')) {
                  userRole = 'FIN';
                  return userRole;
              } else if(psa.PermissionSet.Label.contains('Procurement')) {
                  userRole = 'PRO';
                  return userRole;
              } else if(psa.PermissionSet.Label.contains('Business Requestor')) {
                  userRole = 'BUR';
                  return 'BUR';
              }
           else if(psa.PermissionSet.Label.contains('Freight')) {
                  userRole = 'FRE';
                  return userRole;
              }
              else if(psa.PermissionSet.Label.contains('Russian Tax')) {
                  userRole = 'RUS';
                  return userRole;
              }
          }
          return userRole;
      }
      
      public String fetchRecordStatus(String recId) {
          String reqStatus;
          List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c FROM VPM_PurchasingRequests__c WHERE
                                                        Id = :recId LIMIT 1];        
          if(vendorList != null && vendorList.size() >0) {
              reqStatus = vendorList.get(0).VPM_Status__c;
          }
          return reqStatus;
      }
      
      public void ManuallyMarkAsCompleteAction(){
          //PageReference congratsPage = null; 
          List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_Status__c,OwnerId, CreatedById, VPM_DeletionBlockFlag__c FROM VPM_PurchasingRequests__c WHERE
                                                        Id = :recId LIMIT 1];
          list<PermissionSetAssignment> permissionAssigned =[SELECT Assignee.Name, PermissionSet.Name ,id FROM PermissionSetAssignment
                                                             WHERE AssigneeId =:recId AND PermissionSet.Name ='VPM_MDM_Ops' limit 1];
          if(vendorList[0].VPM_Status__c.contains('Block') || vendorList[0].VPM_Status__c.contains('Unblock')
             || vendorList[0].VPM_Status__c.contains('Delete') || vendorList[0].VPM_Status__c.contains('Undelete')) {
                 vendorList[0].VPM_Status__c = 'Request Completed';
                 vendorList[0].OwnerId = vendorList[0].CreatedById;
                 vendorList[0].VPM_DeletionBlockFlag__c=null;
                 update vendorList;
                 callJavaScriptAlert='<script> PageReload(); </script>';
                 //congratsPage =  new PageReference('/' + recID);
             }
          else
              callJavaScriptAlert='<script> func(); </script>';
          
          //system.debug('@@congratsPage' + congratsPage);
          // return congratsPage;
      } 
      
      public void EnableManuallyMarkAsCompleteBtn(){
          try
          {
              list<VPM_PurchasingRequests__c> vendorList = [SELECT RecordTypeId from VPM_PurchasingRequests__c where id=:recId limit 1];
              list<RecordType> RecordTypeList =[SELECT Name from RecordType where id=:vendorList[0].RecordTypeId limit 1];
              if(RecordTypeList[0].Name.contains('(Create)'))
              {
                  ManuallyMarkAsCompleteFlag =false;
              }
              else
                  ManuallyMarkAsCompleteFlag =true;
          }
          catch(exception ex){}
      }
     
      public void ReworkAction()
       {
          try{
              list<VPM_PurchasingRequests__c> VendorDetailList =[SELECT  VPM_Status__c,VPM_RussianTaxApprovalRequired__c, VPM_RequestGroupTime__c, VPM_FreightApprovalRequired__c, VPM_RequestLastWithGroup__c, VPM_FinanceApprovalRequired__c, VPM_ProcurementApprovalRequired__c, CreatedById, OwnerId, VPM_Rework__c
                                                                 FROM VPM_PurchasingRequests__c WHERE id= : recId LIMIT 1];
                
                // Ajay : BR submitted to FLS now FLS is sending for rework
              if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor' && VendorDetailList[0].VPM_Status__c=='FLS Review') 
              { 
                  VendorDetailList[0].VPM_Status__c = 'FLS Requested Re-Work'; 
                  VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById;
                  VendorDetailList[0].VPM_Rework__c='Yes';
                  VendorDetailList[0].VPM_RequestGroupTime__c=System.now();
                  VendorDetailList[0].VPM_RequestLastWithGroup__c = 'FLS';
                  update VendorDetailList;
                 
                  
              }
              // Ajay : Adv BR submitted to Pro now Pro is sending for rework
              else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor' && VendorDetailList[0].VPM_Status__c =='Approval Pending' && VendorDetailList[0].VPM_ProcurementApprovalRequired__c ==true && VendorDetailList[0].VPM_FinanceApprovalRequired__c==false)
              {
                  VendorDetailList[0].VPM_Status__c = 'Procurement Requested Re-Work'; 
                  VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById;
                  VendorDetailList[0].VPM_Rework__c='Yes';
                  VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Procurement';
                  update VendorDetailList;
              }
              // Ajay : Adv BR submitted to FIN now FIN is sending for rework
              else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor' && VendorDetailList[0].VPM_Status__c =='Approval Pending' && VendorDetailList[0].VPM_FinanceApprovalRequired__c ==true && VendorDetailList[0].VPM_ProcurementApprovalRequired__c==false )
              {
                  system.debug('####');
                  VendorDetailList[0].VPM_Status__c = 'Finance Requested Re-Work'; 
                  VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                  VendorDetailList[0].VPM_Rework__c = 'Yes'; 
                  VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Finance'; 
                   update VendorDetailList;
              }
              // Ajay : Adv BR submitted to Pro now Pro is sending for rework
              else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor' && VendorDetailList[0].VPM_Status__c =='Approval Pending' && VendorDetailList[0].VPM_FinanceApprovalRequired__c ==true && VendorDetailList[0].VPM_ProcurementApprovalRequired__c== true )
              {
            
                  VendorDetailList[0].VPM_Status__c = 'Procurement Requested Re-Work'; 
                  VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                  VendorDetailList[0].VPM_Rework__c='Yes'; 
                  VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Procurement';
                  update VendorDetailList;
              }
              // Ajay : Adv FLS submitted to FIN now FIN is sending for rework
              else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'FLS' && VendorDetailList[0].VPM_Status__c =='Approval Pending' && VendorDetailList[0].VPM_FinanceApprovalRequired__c ==true && VendorDetailList[0].VPM_ProcurementApprovalRequired__c== false )
              {
                  list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                  if (queueList.size() == 1){ 
                      VendorDetailList[0].VPM_Status__c = 'Finance Requested Re-Work'; 
                      VendorDetailList[0].OwnerId=queueList[0].QueueId; 
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Finance'; 
                      VendorDetailList[0].VPM_Rework__c='Yes';   
                      update VendorDetailList;
                  } 
              }
             // Ajay : Adv FLS submitted to PRO now PRO is sending for rework
              else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'FLS' && VendorDetailList[0].VPM_Status__c =='Approval Pending' && VendorDetailList[0].VPM_FinanceApprovalRequired__c ==false && VendorDetailList[0].VPM_ProcurementApprovalRequired__c== true )
              {
                  list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                  if (queueList.size() == 1){ 
                      VendorDetailList[0].VPM_Status__c = 'Procurement Requested Re-Work'; 
                      VendorDetailList[0].OwnerId=queueList[0].QueueId; 
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Procurement'; 
                      VendorDetailList[0].VPM_Rework__c='Yes';  
                      update VendorDetailList;
                  } 
              }
              // Ajay : Adv FLS submitted to PRO now PRO is sending for rework
              else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'FLS' && VendorDetailList[0].VPM_Status__c =='Approval Pending' && VendorDetailList[0].VPM_FinanceApprovalRequired__c ==true && VendorDetailList[0].VPM_ProcurementApprovalRequired__c== true )
              {
                  list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                  if (queueList.size() == 1){ 
                      VendorDetailList[0].VPM_Status__c = 'Procurement Requested Re-Work'; 
                      VendorDetailList[0].OwnerId=queueList[0].QueueId; 
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Procurement'; 
                      VendorDetailList[0].VPM_Rework__c='Yes';   
                      update VendorDetailList;
                  } 
              }
              // Ajay : Adv PRO submitted to FIN now FIN is sending for rework
              else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Procurement' && VendorDetailList[0].VPM_Status__c == 'Approval Pending') 
              { 
                  list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                  if (queueList.size() == 1){                     
                      VendorDetailList[0].VPM_Status__c = 'Finance Requested Re-Work';                   
                      VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Finance'; 
                       VendorDetailList[0].OwnerId=queueList[0].QueueId; 
                      VendorDetailList[0].VPM_Rework__c='Yes';  
                      update VendorDetailList;                    
                  } 
              } 
             
             // Ajay : Adv FLS submitted to RUS now RUS is sending for rework
               else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'FLS' && VendorDetailList[0].VPM_Status__c == 'Approval Pending' && VendorDetailList[0].VPM_RussianTaxApprovalRequired__c) 
              { 
                  list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                  if (queueList.size() == 1){                     
                      VendorDetailList[0].VPM_Status__c = 'Russian Custom Tax Requested Re-Work'; 
                       VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Russian Custom Tax'; 
                      VendorDetailList[0].OwnerId=queueList[0].QueueId;
                      VendorDetailList[0].VPM_Rework__c='Yes';  
                      update VendorDetailList;                    
                  } 
              }

              // Ajay : Adv FLS submitted to FRE now FRE is sending for rework
                else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'FLS' && VendorDetailList[0].VPM_Status__c == 'Approval Pending' && VendorDetailList[0].VPM_FreightApprovalRequired__c) 
              { 
                  list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                  if (queueList.size() == 1){                     
                      VendorDetailList[0].VPM_Status__c = 'Freight Requested Re-Work'; 
                       VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Freight'; 
                      VendorDetailList[0].OwnerId=queueList[0].QueueId;
                      VendorDetailList[0].VPM_Rework__c='Yes';  
                      update VendorDetailList;                    
                  } 
              }
              // Ajay : Adv BR submitted to RUS now RUS is sending for rework
               else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor' && VendorDetailList[0].VPM_Status__c == 'Approval Pending' && VendorDetailList[0].VPM_RussianTaxApprovalRequired__c) 
              { 
                       VendorDetailList[0].VPM_Status__c = 'Russian Custom Tax Requested Re-Work'; 
                        VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Russian Custom Tax'; 
                      VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                      VendorDetailList[0].VPM_Rework__c='Yes';  
                     update VendorDetailList;                    
                  
              }
              // Ajay : Adv BR submitted to FRE now FRE is sending for rework
                else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor'  && VendorDetailList[0].VPM_Status__c == 'Approval Pending' && VendorDetailList[0].VPM_FreightApprovalRequired__c) 
              { 
                    VendorDetailList[0].VPM_Status__c = 'Freight Requested Re-Work'; 
                     VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Freight';
                     VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                      VendorDetailList[0].VPM_Rework__c='Yes';  
                    update VendorDetailList;                    
                
              }


               callJavaScriptAlert='<script> PageReload(); </script>';
             
              
          }
          catch(exception ex){
              
          }
      }
      
        public void SubmitRequestAction()
      {
         try{
               list<VPM_PurchasingRequests__c> VendorDetailList =[SELECT  VPM_Status__c, VPM_FLSInCountryReqVendor__c, VPM_BusinessRequestorSubmitted__c, VPM_Rework__c, OwnerId
                                                                 FROM VPM_PurchasingRequests__c WHERE id= : recId LIMIT 1];
                  
                  
                  // Ajay : Open Advanceform for Non FLS in country
                   if(VendorDetailList[0].VPM_FLSInCountryReqVendor__c == false) 

                  { 
                   callJavaScriptAlert='<script> openAdvanceform(); </script>';
                  } 

                  // Ajay : BR submitted to FLS
              else if(VendorDetailList[0].VPM_Status__c.contains('Draft') ) 
                  { 
                  VendorDetailList[0].VPM_BusinessRequestorSubmitted__c='Yes'; 
                  VendorDetailList[0].VPM_Rework__c='No'; 
                  update VendorDetailList;
                    callJavaScriptAlert='<script> PageReload(); </script>';
                 }

                  // Ajay : BR reworked and  submitted to FLS
              else if (VendorDetailList[0].VPM_Status__c.contains('FLS Requested Re-Work') && VendorDetailList[0].VPM_Rework__c=='Yes') 
                  { 

                  VendorDetailList[0].VPM_Status__c= 'FLS Review'; 
                  VendorDetailList[0].VPM_Rework__c='Completed'; 
                  VendorDetailList[0].VPM_RequestLastWithGroup__c='Business Requestor'; 
                  List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                   if (QueueList.size() == 1)
                      {       
                        VendorDetailList[0].OwnerId=QueueList[0].QueueId; 
                      } 
                   update VendorDetailList;
                     callJavaScriptAlert='<script> PageReload(); </script>';
                  }
                   // Ajay : FLS reworked and  submitted to PRO
                  else if (VendorDetailList[0].VPM_Status__c.contains('Procurement Requested Re-Work') && VendorDetailList[0].VPM_Rework__c=='Yes') 
                  { 
                  List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'Procurement' Limit 1];
                  if (QueueList.size() == 1)
                      { 
                      VendorDetailList[0].VPM_Status__c = 'Approval Pending'; 
                      VendorDetailList[0].VPM_AdvancedFormSubmitted__c='Yes'; 
                      VendorDetailList[0].VPM_Rework__c='Completed'; 
                      VendorDetailList[0].VPM_RequestLastWithGroup__c='FLS'; 
                     VendorDetailList[0].OwnerId=QueueList[0].QueueId;  
                      } 
                      update VendorDetailList;
                        callJavaScriptAlert='<script> PageReload(); </script>';
                  }
                  // Ajay : FLS reworked and  submitted to FIN
                  else if (VendorDetailList[0].VPM_Status__c.contains('Finance Requested Re-Work') && VendorDetailList[0].VPM_Rework__c=='Yes') 
                      { 
                      List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'Finance' Limit 1];
                      if (QueueList.size() == 1)
                          { 
                          VendorDetailList[0].VPM_Status__c = 'Approval Pending'; 
                          VendorDetailList[0].VPM_Rework__c='Completed'; 
                          VendorDetailList[0].VPM_AdvancedFormSubmitted__c='Yes'; 
                          VendorDetailList[0].VPM_RequestLastWithGroup__c='FLS'; 
                           VendorDetailList[0].OwnerId=QueueList[0].QueueId; 
                          } 
                      update VendorDetailList;
                        callJavaScriptAlert='<script> PageReload(); </script>';

                      } 
                      // Ajay : FLS reworked and  submitted to RUS
                       else if (VendorDetailList[0].VPM_Status__c.contains('Russian Custom Tax Requested Re-Work') && VendorDetailList[0].VPM_Rework__c=='Yes') 
                      { 
                      List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'Russian Custom Tax' Limit 1];
                      if (QueueList.size() == 1)
                          { 
                          VendorDetailList[0].VPM_Status__c = 'Approval Pending'; 
                          VendorDetailList[0].VPM_Rework__c='Completed'; 
                          VendorDetailList[0].VPM_AdvancedFormSubmitted__c='Yes'; 
                          VendorDetailList[0].VPM_RequestLastWithGroup__c='FLS'; 
                           VendorDetailList[0].OwnerId=QueueList[0].QueueId; 
                          } 
                      update VendorDetailList;
                        callJavaScriptAlert='<script> PageReload(); </script>';

                      } 
                      // Ajay : FLS reworked and  submitted to FRE
                       else if (VendorDetailList[0].VPM_Status__c.contains('Freight Requested Re-Work') && VendorDetailList[0].VPM_Rework__c=='Yes') 
                      { 
                      List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'Freight' Limit 1];
                      if (QueueList.size() == 1)
                          { 
                          VendorDetailList[0].VPM_Status__c = 'Approval Pending'; 
                          VendorDetailList[0].VPM_Rework__c='Completed'; 
                          VendorDetailList[0].VPM_AdvancedFormSubmitted__c='No'; 
                          VendorDetailList[0].VPM_RequestLastWithGroup__c='FLS'; 
                           VendorDetailList[0].OwnerId=QueueList[0].QueueId; 
                          } 
                      update VendorDetailList;
                        callJavaScriptAlert='<script> PageReload(); </script>';

                      } 
                    
                    

          }
          catch(exception ex){}
      } 

           public PageReference cancelFromUser(){
           return null;
       }
        public PageReference saveFromUser(){           

        GstdController.save();
        
        //if(pr.VPM_IsVendorSME__c == 'Yes' && (string.isBlank(pr.VPM_ExceptionType__c))) {
              //isRequired = true;
        //      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, 'Please select a Exception Type'));
       // }
      //  else{ 
           
           /* if(GstdController.save()!=null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Details saved!'));
            }*/
      //  }
       // 
        System.debug('----------- @@@@@@@@'+isVenderSME+'--------'+exceptionType);
        
           return null;
       }
       
       public void fetchisVenderSME() {
          List<VPM_PurchasingRequests__c> vendorList = [SELECT Id, VPM_IsVendorSME__c,VPM_ExceptionType__c,VPM_InternationalVersion__c FROM VPM_PurchasingRequests__c WHERE
                                                        Id = :recId LIMIT 1];        
          if(vendorList != null && vendorList.size() >0) {
              pr.VPM_ExceptionType__c = vendorList[0].VPM_ExceptionType__c;
              pr.VPM_IsVendorSME__c = vendorList[0].VPM_IsVendorSME__c;    
              isVenderSME= vendorList.get(0).VPM_IsVendorSME__c ;
              exceptionType= vendorList.get(0).VPM_ExceptionType__c ;
              internationalVersion = vendorList.get(0).VPM_InternationalVersion__c ; 
          }
      }     
      
       
       public void saveUserValues(){
                
        changeButtonValues();
        
         //GstdController.save();

       }
       
       public void changeButtonValues(){
            VPM_PurchasingRequests__c vendorDetailList1 =[select OwnerId, VPM_Approval_Worker__c,VPM_Approval_Worker_ID__c from VPM_PurchasingRequests__c where id =: recId];
        
        
        if(vendorDetailList1.VPM_Approval_Worker_ID__c== null || string.isBlank(vendorDetailList1.VPM_Approval_Worker_ID__c)){  //Text should change to "I am working on this"
            
             vendorDetailList1.VPM_Approval_Worker__c = UserInfo.getName(); 
            vendorDetailList1.VPM_Approval_Worker_ID__c = UserInfo.getUserId(); 
            buttonValue = system.label.VPM_No_Longer_Working; 
            approvalWorkerName=UserInfo.getName();
                 
         }
         else { 
             system.debug('Changing to '+system.label.VPM_I_am_working_on_it);
               vendorDetailList1.VPM_Approval_Worker_ID__c  = null;
             vendorDetailList1.VPM_Approval_Worker__c = null;
              approvalWorkerName=''; 
             buttonValue = system.label.VPM_I_am_working_on_it;  
              
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
            VPM_PurchasingRequests__c vendorDetailList1 =[select OwnerId, VPM_Approval_Worker__c,VPM_Approval_Worker_ID__c from VPM_PurchasingRequests__c where id =: recId];
        approvalWorkerName=vendorDetailList1.VPM_Approval_Worker__c;
          
        if(vendorDetailList1.VPM_Approval_Worker_ID__c== null || string.isBlank(vendorDetailList1.VPM_Approval_Worker_ID__c)){  //Text should change to "I am working on this"
            
          buttonValue = system.label.VPM_I_am_working_on_it;
          
               
         }//if(vendorDetailList[0].VPM_Approval_Worker_ID__c== UserInfo.getUserId()) 
         else { 
             
               buttonValue = system.label.VPM_No_Longer_Working;
         
         }
         
          }
}