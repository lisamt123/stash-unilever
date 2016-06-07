global class VPM_PurchaseRequestsControllerExtension {
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
    public VPM_PurchasingRequests__c pr{get;set;}  
   
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
        list<VPM_PurchasingRequests__c> vendorDetailList =[select OwnerId, VPM_Status__c from VPM_PurchasingRequests__c where id =: recId];
        list<QueueSobject> QueueSobjectList =[Select Queue.Name From QueueSobject where QueueId =: vendorDetailList[0].OwnerId];
        System.debug('-------inside constructor of extn-------'+stdController.getRecord().Id + '  ' + venReqStatus);
        if(String.isNotBlank(venReqStatus) && (venReqStatus.equalsIgnoreCase('MDM Ops Review') || 
                                               venReqStatus.equalsIgnoreCase('MDM Ops Review - SAP BPM submit Failed'))){
                                                   enableSendToSAPBtn = true;
                                               } else {
                                                   enableSendToSAPBtn = false;  
                                               }
        
        usrRole = checkLoggedInUserRole();
        EnableManuallyMarkAsCompleteBtn();
        
        if(usrRole == 'MDM') {
            RenderSAPBtn = true;
            ManuallyMarkasCompletebtn= true;
        }
        else if(usrRole ==  'FRE' && QueueSobjectList[0].Queue.Name.contains('Freight')) {
            ReworkBtn=true;
              RenderSAPBtn = true;
              SubmitRequestBtn = true;
        }
        else if(usrRole ==  'FIN' && QueueSobjectList[0].Queue.Name.contains('Finance')) {
            ReworkBtn=true;
              RenderSAPBtn = true;
              SubmitRequestBtn = true;
        }
        else if(usrRole ==  'PRO' && QueueSobjectList[0].Queue.Name.contains('Procurement')) {
            ReworkBtn=true;
              RenderSAPBtn = true;
              SubmitRequestBtn = true;
        }
         else if(usrRole ==  'FLS' && QueueSobjectList[0].Queue.Name.contains('FLS')) {
            ReworkBtn=true;
              RenderSAPBtn = true;
              SubmitRequestBtn = true;
        }
          else if(usrRole ==  'BUR') {
           
              RenderSAPBtn = false;
              SubmitRequestBtn = true;
        }
        if(vendorDetailList[0].VPM_Status__c.contains('Rejected'))
        {
         RenderSAPBtn = false;
         SubmitRequestBtn = false;
         ManuallyMarkasCompletebtn= false;
        }
        if(vendorDetailList[0].VPM_Status__c.contains('Rejected'))
        {
        RenderSAPBtn = false;
        ManuallyMarkasCompletebtn= false;
         SubmitRequestBtn = false;
        }
        vendorReqId = stdController.getRecord().Id;
    }
    catch(exception ex){}
    }
    
    public void callSendToSAPAPI() {
        System.debug('-----id of vendor request record is-----'+vendorReqId);
        String responseString;
        list<VPM_PurchasingRequests__c> vendorList = [SELECT RecordTypeId from VPM_PurchasingRequests__c where id=:vendorReqId limit 1];
            list<RecordType> RecordTypeList =[SELECT Name from RecordType where id=:vendorList[0].RecordTypeId limit 1];
            if(RecordTypeList[0].Name.contains('(Create)')) {
                System.debug('-----calling create vendor mule api----');
                responseString = VPM_CreateVendorServiceHelper.createVendor(vendorReqId);
                System.debug('-----response string from create vendor mule api----' + responseString);
                callJavaScriptAlert='<script>PageReload(); localStorage.setItem("msg","'+responseString+'"); </script>';
            } else if(RecordTypeList[0].Name.contains('(Extend)')) {
                System.debug('-----calling extend global vendor mule api----');
                //VPM_ExtendVendorGlobalHelper.extendVendorGlobal(vendorReqId);
                VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorReqId);
                callJavaScriptAlert='<script> PageReload(); </script>';
            } else if(RecordTypeList[0].Name.contains('(Maintain)')) {
                System.debug('-----calling extend global vendor mule api----');
                VPM_MaintainGlobalVendorServiceHelper.maintainGlobalVendor(vendorReqId);
                callJavaScriptAlert='<script> PageReload(); </script>';
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
         system.debug('@@@@');
           
            list<VPM_PurchasingRequests__c> VendorDetailList =[SELECT  VPM_Status__c, VPM_RequestGroupTime__c, VPM_FreightApprovalRequired__c, VPM_RequestLastWithGroup__c, VPM_FinanceApprovalRequired__c, VPM_ProcurementApprovalRequired__c, CreatedById, OwnerId, VPM_Rework__c
                                                               FROM VPM_PurchasingRequests__c WHERE id= : recId LIMIT 1];
              
              system.debug('@@@@'+VendorDetailList[0].VPM_RequestLastWithGroup__c);
              system.debug('@@'+VendorDetailList[0].VPM_Status__c);
              system.debug('@@@'+VendorDetailList[0].VPM_ProcurementApprovalRequired__c);
              system.debug('@@@@'+VendorDetailList[0].VPM_FinanceApprovalRequired__c);
              system.debug('##'+ (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'FLS' && VendorDetailList[0].VPM_Status__c =='Approval Pending' && VendorDetailList[0].VPM_FinanceApprovalRequired__c ==true && VendorDetailList[0].VPM_ProcurementApprovalRequired__c== true ));
              
              
              
               if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'FLS' && VendorDetailList[0].VPM_Status__c=='Approval Pending' && VendorDetailList[0].VPM_FreightApprovalRequired__c ==true )
            { 
                list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                if (queueList.size() == 1){ 
                    VendorDetailList[0].VPM_Status__c = 'Freight Requested Re-Work'; 
                    VendorDetailList[0].OwnerId=queueList[0].QueueId; 
                    VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Freight'; 
                    VendorDetailList[0].VPM_Rework__c='Yes';  
                    update VendorDetailList;
                } 
               
                
            }
              if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor' && VendorDetailList[0].VPM_Status__c=='Approval Pending' && VendorDetailList[0].VPM_FreightApprovalRequired__c ==true )
            { 

                     VendorDetailList[0].VPM_Status__c = 'Freight Requested Re-Work'; 
                   VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                     VendorDetailList[0].VPM_Rework__c='Yes';  
                      VendorDetailList[0].VPM_RequestGroupTime__c=System.now();
                    VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Freight'; 
                  
                    update VendorDetailList;
                
            }
                           if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'FLS' && VendorDetailList[0].VPM_Status__c=='Approval Pending' && VendorDetailList[0].VPM_RussianTaxApprovalRequired__c ==true )
            { 
                list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                if (queueList.size() == 1){ 
                    VendorDetailList[0].VPM_Status__c = 'Russian Custom Tax Requested Re-Work'; 
                    VendorDetailList[0].OwnerId=queueList[0].QueueId; 
                    VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Russian Tax User'; 
                    VendorDetailList[0].VPM_Rework__c='Yes';  
                    update VendorDetailList;
                } 
               
                
            }
              if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor' && VendorDetailList[0].VPM_Status__c=='Approval Pending' && VendorDetailList[0].VPM_RussianTaxApprovalRequired__c ==true )
            { 

                     VendorDetailList[0].VPM_Status__c = 'Russian Custom Tax Requested Re-Work'; 
                   VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                     VendorDetailList[0].VPM_Rework__c='Yes';  
                      VendorDetailList[0].VPM_RequestGroupTime__c=System.now();
                    VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Russian Tax User'; 
                  
                    update VendorDetailList;
                
            }
               if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor' && VendorDetailList[0].VPM_Status__c=='FLS Review') 
            { 
                VendorDetailList[0].VPM_Status__c = 'FLS Requested Re-Work'; 
                VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById;
                VendorDetailList[0].VPM_Rework__c='Yes';
                VendorDetailList[0].VPM_RequestGroupTime__c=System.now();
                VendorDetailList[0].VPM_RequestLastWithGroup__c = 'FLS';
                update VendorDetailList;
               
                
            }
            else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor' && VendorDetailList[0].VPM_Status__c =='Approval Pending' && VendorDetailList[0].VPM_ProcurementApprovalRequired__c ==true && VendorDetailList[0].VPM_FinanceApprovalRequired__c==false)
            {
                VendorDetailList[0].VPM_Status__c = 'Procurement Requested Re-Work'; 
                VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById;
                VendorDetailList[0].VPM_Rework__c='Yes';
                VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Procurement';
                update VendorDetailList;
            }
            else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor' && VendorDetailList[0].VPM_Status__c =='Approval Pending' && VendorDetailList[0].VPM_FinanceApprovalRequired__c ==true && VendorDetailList[0].VPM_ProcurementApprovalRequired__c==false )
            {
                system.debug('####');
                VendorDetailList[0].VPM_Status__c = 'Finance Requested Re-Work'; 
                VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                VendorDetailList[0].VPM_Rework__c = 'Yes'; 
                VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Finance'; 
                 update VendorDetailList;
            }
            else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Business Requestor' && VendorDetailList[0].VPM_Status__c =='Approval Pending' && VendorDetailList[0].VPM_FinanceApprovalRequired__c ==true && VendorDetailList[0].VPM_ProcurementApprovalRequired__c== true )
            {
          
                VendorDetailList[0].VPM_Status__c = 'Procurement Requested Re-Work'; 
                VendorDetailList[0].OwnerId = VendorDetailList[0].CreatedById; 
                VendorDetailList[0].VPM_Rework__c='Yes'; 
                VendorDetailList[0].VPM_RequestLastWithGroup__c = 'Procurement';
                update VendorDetailList;
            }
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
             else if (VendorDetailList[0].VPM_RequestLastWithGroup__c == 'Finance' && VendorDetailList[0].VPM_Status__c == 'Approval Pending') 
            { 
                list<QueueSobject> queueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                if (queueList.size() == 1){                     
                    VendorDetailList[0].VPM_Status__c = 'Requested Re-Work'; 
                    VendorDetailList[0].OwnerId=queueList[0].QueueId;
                    VendorDetailList[0].VPM_Rework__c='Yes';  
update VendorDetailList;                    
                } 
            }
             callJavaScriptAlert='<script> PageReload(); </script>';
           
            
        }
        catch(exception ex){
            
        }
    }
    public void SubmitRequestAction()
    {
    system.debug('@@@@');
        try{
             list<VPM_PurchasingRequests__c> VendorDetailList =[SELECT  VPM_Status__c, VPM_FLSInCountryReqVendor__c, VPM_BusinessRequestorSubmitted__c, VPM_Rework__c, OwnerId
                                                               FROM VPM_PurchasingRequests__c WHERE id= : recId LIMIT 1];
                
                system.debug('@@'+VendorDetailList[0].VPM_FLSInCountryReqVendor__c);//true
                system.debug('@@'+VendorDetailList[0].VPM_Status__c);//FLS Requested Re-Work
                system.debug('@@'+VendorDetailList[0].VPM_Rework__c);// Yes
                if(VendorDetailList[0].VPM_FLSInCountryReqVendor__c == false) 

                { 
                 callJavaScriptAlert='<script> openAdvanceform(); </script>';
                } 
            else if(VendorDetailList[0].VPM_Status__c.contains('Draft') ) 
                { 
                VendorDetailList[0].VPM_BusinessRequestorSubmitted__c='Yes'; 
                VendorDetailList[0].VPM_Rework__c='No'; 
                update VendorDetailList;
                  callJavaScriptAlert='<script> PageReload(); </script>';
               }
            else if (VendorDetailList[0].VPM_Status__c.contains('FLS Requested Re-Work') && VendorDetailList[0].VPM_Rework__c=='Yes') 
                { 

                VendorDetailList[0].VPM_Status__c= 'FLS Review'; 
                VendorDetailList[0].VPM_Rework__c='Completed'; 
                VendorDetailList[0].VPM_RequestLastWithGroup__c='Business Requestor'; 
                List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                 system.debug('@@ Condition one'+QueueList.size());// Yes
                if (QueueList.size() == 1)
                    {           

                    VendorDetailList[0].OwnerId=QueueList[0].QueueId; 
                    } 
                 update VendorDetailList;
                   callJavaScriptAlert='<script> PageReload(); </script>';
                } 
                else if (VendorDetailList[0].VPM_Status__c.contains('Procurement Requested Re-Work') && VendorDetailList[0].VPM_Rework__c=='Yes') 
                { 
                List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'Procurement' Limit 1];
                if (QueueList.size() == 1)
                    { 
                    VendorDetailList[0].VPM_Status__c = 'Approval Pending'; 
                    VendorDetailList[0].VPM_AdvancedFormSubmitted__c='No'; 
                    VendorDetailList[0].VPM_Rework__c='Completed'; 
                    VendorDetailList[0].VPM_RequestLastWithGroup__c='FLS'; 
                   VendorDetailList[0].OwnerId=QueueList[0].QueueId;  
                    } 
                    update VendorDetailList;
                      callJavaScriptAlert='<script> PageReload(); </script>';
                }
                else if (VendorDetailList[0].VPM_Status__c.contains('Finance Requested Re-Work') && VendorDetailList[0].VPM_Rework__c=='Yes') 
                    { 
                    List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'Finance' Limit 1];
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
                    else if (VendorDetailList[0].VPM_Status__c.contains('FLS Review')) 
                    { 
                    system.debug('@@ FLS Review');
                    List<QueueSobject> QueueList = [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'FLS' Limit 1];
                   if (QueueList.size() == 1)
                        { 
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
         return null;
     }
    
}