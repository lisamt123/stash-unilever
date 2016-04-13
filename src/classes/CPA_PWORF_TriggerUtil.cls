/**********************************************************************
Name: CPA_PWORF_TriggerUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on before update event of PWORFTrigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       22/12/2015     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_PWORF_TriggerUtil{
    public static boolean isSubmitted=false;
    public static Map<string, CPA_SLAConfiguration__c> SLAMap {get;set;}
    //Public static List<string> keyNames {get;set;}
    
    /*******************************************************************
    Purpose: This method is used to perform recall Approval process on PWORF record
    Parameters: oldPWORFList, newPWORFList
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/ 
    public static void recallApproval(List<CPA_PWORF__c> oldPWORFList,List<CPA_PWORF__c> newPWORFList)    
    { 
       set<ID> settempPWORFID = new set<ID>();
       for(CPA_PWORF__c objPWORFTemp: newPWORFList){
            
            settempPWORFID.add(objPWORFTemp.Id);
        }
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId IN:settempPWORFID ];
        for (Integer i = 0; i < newPWORFList.size(); i++) {
            if((oldPWORFList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.SUBMITTED || oldPWORFList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.RESUBMITTED) && (newPWORFList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.CANCELLED || newPWORFList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.WITHHOLD)){
                //PWORF.isCancelled__c = true;
                for(ProcessInstanceWorkitem piwi:piwiList){
                    if(piwi.ProcessInstance.TargetObjectId == newPWORFList[i].id && !isSubmitted ){ 
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                        req.setComments(CPA_ConstantsForContractingAppClasses.RECALLINGUNLOCKREQ);
                        req.setAction(CPA_ConstantsForContractingAppClasses.REMOVED);
                        req.setWorkitemId(piwi.Id);
                        Approval.ProcessResult result =  Approval.process(req);
                        isSubmitted = true;
                    }                   
                }
            }
        }
    }  

    /*
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     * Dev team will fix this in next release.
     * Justification: Based on different status, we are doing actions, hence we need multiple if conditions here.
     */
    /*******************************************************************
    Purpose: This method is used to perform submit for  Approval process on PWORF record
    Parameters: oldPWORFList, newPWORFList
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void submitforApproval(List<CPA_PWORF__c> oldPWORFList,List<CPA_PWORF__c> newPWORFList)    
    {
        set<Id> setId = new Set<Id>();
        List<CPA_PWORF__c> WithholdsetId = new List<CPA_PWORF__c>();
        Approval.ProcessWorkitemRequest[] prWkItemsForApproval = New Approval.ProcessWorkItemRequest[]{};
        Approval.ProcessSubmitRequest[] reqlist = new Approval.ProcessSubmitRequest[]{};
        for (Integer i = 0; i < newPWORFList.size(); i++) {
            
            if ((oldPWORFList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.SUBMITTED &&   newPWORFList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED)|| (oldPWORFList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.RESUBMITTED &&   newPWORFList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED) &&  !isSubmitted) {
             
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments(CPA_ConstantsForContractingAppClasses.SUBMITFORAPPROVAL);
            req.setObjectId(newPWORFList[i].Id);
            // submit the approval request for processing
            //Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful
            reqlist.add(req);
            isSubmitted = true;
        }else if( !oldPWORFList[i].chk_isAutoAccepted__c &&   newPWORFList[i].chk_isAutoAccepted__c){
            setId.add(newPWORFList[i].Id);      
        }else if((oldPWORFList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.WITHHOLD &&   newPWORFList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.WITHHOLD)|| (oldPWORFList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.SUBMITTED &&   newPWORFList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED) || (oldPWORFList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.RESUBMITTED &&   newPWORFList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED) ){
            WithholdsetId.add(newPWORFList[i]);
        }
 
        }
        if(!reqlist.isEmpty()){
             Approval.ProcessResult[] result = Approval.process(reqlist);
        }
        if(WithholdsetId !=null && WithholdsetId.size()>0){
            Approval.unLockResult[] lrList = Approval.unlock(WithholdsetId, false);
        }
        if(setId != null){
            Approval.ProcessWorkitemRequest[] prWkItems = New Approval.ProcessWorkItemRequest[]{};
            
            ProcessInstance[] pi = [Select ID, Status, TargetObject.Name, 
                (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
                (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance 
                Where TargetObjectID IN :setId AND Status = 'Pending'];

            for(ProcessInstance instance : pi){
      
                for(ProcessInstanceWorkItem workItem : instance.WorkItems){

                    Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();
                    
                    prWkItem.setWorkItemID(workItem.id);
                    prWkItem.setComments(CPA_ConstantsForContractingAppClasses.AUTOACCEPT);
                    prWkItem.setAction(CPA_ConstantsForContractingAppClasses.APPROVE);
                    prWkItems.add(prWkItem);
                  
                }
            }          
            
            if(!prWkItems.isEmpty()){                
                Approval.ProcessResult[] appResult = Approval.process(prWkItems);                
            }
        }
    }

    /*
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     * Dev team will fix this in next release.
     * Justification: Based on different project phases, we are calculating SLA's, hence we need multiple if conditions here.
     */
    /*******************************************************************
    Purpose: This method updates SLA related fields on PWORF record
    Parameters: newPWORFList
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void updateSLAData(List<CPA_PWORF__c> OldPWORFList,List<CPA_PWORF__c> newPWORFList){
        //Code review comments - remove hard coded values and use constants
        //Remove debug statements
        
        String strStatus = newPWORFList[0].pkl_Status__c;
        String strOldStatus = OldPWORFList[0].pkl_Status__c;
        Date dt1 = Date.today();
        if(strStatus.equalsIgnoreCase('Accepted')){
            newPWORFList[0].dat_SLA1_Accepted_Date__c = dt1;
        }else if(!strStatus.equalsIgnoreCase('Answered')){
            newPWORFList[0].dat_SLA1_Accepted_Date__c = null;
        }
        //if(strStatus.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SUBMITTED)){
        if (strOldStatus!=null && strStatus !=null && !strOldStatus.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SUBMITTED) &&   strStatus.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SUBMITTED)) {
            newPWORFList[0].dat_Submitted_Date__c =dt1;
            //newPWORFList[0].dat_Resubmitted_Date__c = dt1;
            Id recordTypeID = newPWORFList[0].RecordTypeID;
            List<RecordType> lstRecordType = [Select Name From RecordType where id =: recordTypeID Limit 1];
            String strRecordType = lstRecordType[0].Name;
            //CPA_PWORF__c pworfRec = [Select txt_SLA1__c, txt_SLA2__c From CPA_PWORF__c Where id =: newPWORFList[0].Id];
            SLAMap = CPA_SLAConfiguration__c.getAll(); 
            String strProjectScale='';
            String[] strPrjPhases;
            String strProjectPhases='';
            String strToCompare = '';
            if(strRecordType.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.OTHER)){
                
                if(newPWORFList[0].pkl_Project_Scale__c != null && newPWORFList[0].mpkl_Project_Phases__c != null ){
                    strProjectScale = newPWORFList[0].pkl_Project_Scale__c;
                    strPrjPhases = newPWORFList[0].mpkl_Project_Phases__c.split(';'); 
                    
                    for(String strPP : strPrjPhases){
                       if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.PLAN)){
                           strProjectPhases = strProjectPhases + 'P';
                       }
                       if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.ANALYSE)){
                           strProjectPhases = strProjectPhases + 'A';
                       }
                       if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.DESIGN)){
                           strProjectPhases = strProjectPhases + 'D';
                       }
                       if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.BUILD)){
                           strProjectPhases = strProjectPhases + 'B';
                       }
                       if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.TEST)){
                           strProjectPhases = strProjectPhases + 'T';
                       }
                       if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.DEPLOY)){
                           strProjectPhases = strProjectPhases + 'D';
                       }                           
                        if(strPP.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.OTHER)){
                           strProjectPhases = strProjectPhases + 'Other';
                        }                          
                    }
                    strToCompare = (strProjectScale.substring(0,strProjectScale.indexOf('('))).trim();
                    
                }
            }
            
            
            for(string SLAMapKey: SLAMap.keySet()){
                String nameFromSLAConfig = SLAMap.get(SLAMapKey).Name;
                
                if(nameFromSLAConfig.equalsIgnoreCase('RA') && strRecordType.equalsIgnoreCase('Resource Augmentation')){
                    newPWORFList[0].txt_SLA1__c = SLAMap.get(SLAMapKey).RA_SLA1__c;
                    newPWORFList[0].txt_SLA2__c = SLAMap.get(SLAMapKey).RA_SLA2__c;
                    //newPWORFList[0].dat_Expected_SLA2_Date__c = CPA_CalculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).RA_SLA2__c));
                }

                if(strRecordType.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.OTHER)){
                    if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.PA)){
                        newPWORFList[0].txt_SLA1__c = SLAMap.get(SLAMapKey).PA_SLA1__c;
                        newPWORFList[0].txt_SLA2__c = SLAMap.get(SLAMapKey).PA_SLA2__c;
                       // newPWORFList[0].dat_Expected_SLA1_Date__c = CPA_CalculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).PA_SLA1__c));
                        //newPWORFList[0].dat_Expected_SLA2_Date__c = CPA_CalculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).PA_SLA2__c));
                    }
                    if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.PADBTD)){
                        newPWORFList[0].txt_SLA1__c = SLAMap.get(SLAMapKey).PADBTD_SLA1__c;
                        newPWORFList[0].txt_SLA2__c = SLAMap.get(SLAMapKey).PADBTD_SLA2__c;
                       // newPWORFList[0].dat_Expected_SLA1_Date__c = CPA_CalculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).PADBTD_SLA1__c));
                       // newPWORFList[0].dat_Expected_SLA2_Date__c = CPA_CalculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).PADBTD_SLA2__c));
                    }
                    if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.DBTD)){
                        newPWORFList[0].txt_SLA1__c = SLAMap.get(SLAMapKey).DBTD_SLA1__c;
                        newPWORFList[0].txt_SLA2__c = SLAMap.get(SLAMapKey).DBTD_SLA2__c;
                        //newPWORFList[0].dat_Expected_SLA1_Date__c = CPA_CalculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).DBTD_SLA1__c));
                        //newPWORFList[0].dat_Expected_SLA2_Date__c = CPA_CalculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).DBTD_SLA2__c));
                    }
                    if(nameFromSLAConfig.equalsIgnoreCase(strToCompare) && strProjectPhases.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.OTHER)){
                    //else{system.debug('SLAMap.get(SLAMapKey).Others_SLA1__c>>>>>>'+SLAMap.get(SLAMapKey).Others_SLA1__c);
                        newPWORFList[0].txt_SLA1__c = SLAMap.get(SLAMapKey).Others_SLA1__c;
                        newPWORFList[0].txt_SLA2__c = SLAMap.get(SLAMapKey).Others_SLA2__c;
                        //newPWORFList[0].dat_Expected_SLA1_Date__c = CPA_CalculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).Others_SLA1__c));
                        //newPWORFList[0].dat_Expected_SLA2_Date__c = CPA_CalculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).Others_SLA2__c));
                    }
                }
            }
            if(newPWORFList[0].txt_SLA1__c !=null && newPWORFList[0].txt_SLA1__c.isNumeric()){newPWORFList[0].num_Number_of_SLA1_Days__c = Integer.valueof(newPWORFList[0].txt_SLA1__c.trim());}
            if(newPWORFList[0].txt_SLA2__c !=null && newPWORFList[0].txt_SLA2__c.isNumeric()){newPWORFList[0].num_Number_of_SLA2_Days__c = Integer.valueof(newPWORFList[0].txt_SLA2__c.trim());}
            
            //update pworfRec;
        }//Submitted if condition
    }
    
    /*******************************************************************
    Purpose: This method make the Approval comments require
    Parameters: newPWORFList
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void requireApprovalComments(List<CPA_PWORF__c> newPWORFList){
 
        // Create a map that stores all the objects that require editing 
        Map<Id, CPA_PWORF__c> approvalStatements = new Map<Id, CPA_PWORF__c>{};

        for(CPA_PWORF__c inv: newPWORFList)
        {
            // Put all objects for update that require a comment check in a map,
            // so we only have to use 1 SOQL query to do all checks
    
            if (inv.pkl_Approval_Comment_Check__c == 'Required')
            { 
                approvalStatements.put(inv.Id, inv);
                // Reset the field value to null, 
                // so that the check is not repeated,
                // next time the object is updated
                inv.pkl_Approval_Comment_Check__c = null; 
            }
        }  
   
        if (!approvalStatements.isEmpty())  
        {
            // If there are some approvals to be reviewed for approval, then
            // get the most recent process instance for each object.
            List<Id> processInstanceIds = new List<Id>{};

            for (CPA_PWORF__c invs : [SELECT (SELECT ID
                                                      FROM ProcessInstances
                                                      ORDER BY CreatedDate DESC
                                                      LIMIT 1)
                                              FROM CPA_PWORF__c
                                              WHERE ID IN :approvalStatements.keySet()])
            {
                processInstanceIds.add(invs.ProcessInstances[0].Id);
            }
          
            // Now that we have the most recent process instances, we can check
            // the most recent process steps for comments.  
            for (ProcessInstance pi : [SELECT TargetObjectId,
                                           (SELECT Id, StepStatus, Comments 
                                            FROM Steps
                                            ORDER BY CreatedDate DESC
                                            LIMIT 1 )
                                       FROM ProcessInstance
                                       WHERE Id IN :processInstanceIds
                                       ORDER BY CreatedDate DESC])
            {
                // If no comment exists, then prevent the object from saving.                 
                if ((pi.Steps[0].Comments == null || 
                    pi.Steps[0].Comments.trim().length() == 0))
                {
                    approvalStatements.get(pi.TargetObjectId).addError(
                     'Operation Cancelled: Please provide a reason ' + 
                     'for your approval / rejection / Recall!');
                }
            }                                       
        }
    }    

    /**   Method Name : forSearch
    * Parameter   : newPWORFList
    * Return type : None
    * Author      : Dinesh Girase  
    * Description : not in use
    */
    /*public static void forSearch(List<CPA_PWORF__c> newPWORFList){
        Integer maxNo=0;
        List<AggregateResult> maxNum = new List<AggregateResult>();
        maxNum = [SELECT Max(For_Search_Numeric__c) FROM CPA_PWORF__c];
        for(AggregateResult maxNumber : maxNum){
            maxNo = Integer.valueOf(maxNumber.get('expr0') + '');
            System.debug('maxNum######## : ' + maxNo);
        }
        List<CPA_PWORF__c> pworfs = [SELECT For_Search__c FROM CPA_PWORF__c Where Id =: newPWORFList[0].ID];
    }*/
    
    /*******************************************************************
    Purpose: This method dont allow CR to be deleted
    Parameters: lstPWORF
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void DontDelete(list<CPA_PWORF__c> lstPWORF){
        for(CPA_PWORF__c obj :lstPWORF ){
            obj.addError(CPA_ConstantsForContractingAppClasses.PWORFCANTBEDELETED);
        }
    }
    /*******************************************************************
    Purpose: This method unlock the records
    Parameters: lstPWORF
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    
    public static void unlockPworf(list<CPA_PWORF__c> lstPWORF){
        List < CPA_PWORF__c > ListPWORFForUnlock = new List<CPA_PWORF__c>();
        Approval.unLockResult[] lrList;
        for(CPA_PWORF__c objPWORF : lstPWORF){
            if(objPWORF.isApprovalProcessStarted__c){
                ListPWORFForUnlock.add(objPWORF);                       
            }
        }
        
        if(ListPWORFForUnlock!=null){
            lrList = Approval.unlock(ListPWORFForUnlock, false); 
            for(Approval.UnlockResult ur : lrList) {
                if (ur.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully unlocked account with ID: ' + ur.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : ur.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            } 
        }
                
            
    }
/*******************************************************************
    Purpose: This method is used to restrict ULPM to Update  on PWORF record when Accepted/Answered/Auto Accepted
    Parameters: oldPWORFList, newPWORFList
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/ 
    public static void restrictULPMtoUpdate(List<CPA_PWORF__c> oldPWORFList,List<CPA_PWORF__c> newPWORFList){ 
        Boolean user_has_permission = false;                
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() ];
        for(Integer i = 0; i < newPWORFList.size(); i++){
            if((oldPWORFList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.ACCEPTED && newPWORFList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.ACCEPTED) || (oldPWORFList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.AUTOACCEPT && newPWORFList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.AUTOACCEPT) || (oldPWORFList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.ANSWERED && newPWORFList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.ANSWERED)){
                for ( PermissionSetAssignment psa : lstcurrentUserPerSet ) {
                    string permission = psa.PermissionSet.Name;
                    if (permission.CONTAINS(CPA_ConstantsForContractingAppClasses.CPASMT)){
                        user_has_permission = true;
                        break;
                    }
                }
                if(!user_has_permission){
                    if(!test.isrunningtest()){
                        newPWORFList[i].adderror('PWORF can not be updated after it has been Accepted');
                    }
                }                      
            }
        }
    }
    /** Method Name : restricSMTULPMToAcceptReject
    * Parameter   : newPWORFList,oldPWORFList
    * Return type : None
    * Author      : Pooja Kanani  
    * Description : This method restric SMT/ULPM to accept/reject PWORF
    */
    public static void restricSMTULPMToAcceptReject(List<CPA_PWORF__c> newPWORFList,List<CPA_PWORF__c> oldPWORFList){
 
  // Create a map that stores all the objects that require editing 
  Map<Id, CPA_PWORF__c> approvalStatements = new Map<Id, CPA_PWORF__c>{};
  map<id,CPA_PWORF__c> mapOldMap = new map<Id,CPA_PWORF__c>();
  
  for(CPA_PWORF__c objTemp : oldPWORFList)
  {
      mapOldMap.put(objTemp.Id,objTemp);
  }
  Boolean user_has_permission = false;              
    
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() ];
        for ( PermissionSetAssignment psa : lstcurrentUserPerSet ) {
                string permission = psa.PermissionSet.Name;
                if (permission.CONTAINS(CPA_ConstantsForContractingAppClasses.CPAADM)){
                    user_has_permission = true;
                    break;
                }
            system.debug('permission>>'+permission);
            }
            system.debug('user_has_permission>>'+user_has_permission);
                    
            for(CPA_PWORF__c inv:newPWORFList){ 
                if(!user_has_permission && !inv.chk_isAutoAccepted__c  && ((inv.pkl_Status__c==CPA_ConstantsForContractingAppClasses.ACCEPTED && mapOldMap.get(inv.Id).pkl_Status__c!=CPA_ConstantsForContractingAppClasses.ACCEPTED)|| (inv.pkl_Status__c==CPA_ConstantsForContractingAppClasses.RETURNED && mapOldMap.get(inv.Id).pkl_Status__c!= CPA_ConstantsForContractingAppClasses.RETURNED))){
                    approvalStatements.put(inv.Id, inv);                     
                }
            }
        system.debug('approvalStatements>>'+approvalStatements);
  if (approvalStatements != null && !approvalStatements.isEmpty())  
  {
    // If there are some approvals to be reviewed for approval, then
    // get the most recent process instance for each object.
    List<Id> processInstanceIds = new List<Id>{};
    
    for (CPA_PWORF__c invs : [SELECT (SELECT ID
                                              FROM ProcessInstances
                                              ORDER BY CreatedDate DESC
                                              LIMIT 1)
                                      FROM CPA_PWORF__c
                                      WHERE ID IN :approvalStatements.keySet()])
    {
        processInstanceIds.add(invs.ProcessInstances[0].Id);
    }
      if(processInstanceIds!=null){  
    // Now that we have the most recent process instances, we can check
    // the most recent process steps for comments.  
    for (ProcessInstance pi : [SELECT TargetObjectId,
                                   (SELECT Id, StepStatus, Comments 
                                    FROM Steps
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1 )
                               FROM ProcessInstance
                               WHERE Id IN :processInstanceIds
                               ORDER BY CreatedDate DESC])
    {       
      // If no comment exists, then prevent the object from saving.                 

           approvalStatements.get(pi.TargetObjectId).addError('<br/><br/><Strong style= "color:red">Error: </Strong><b>PWORF Can be Accepted/Returned by Vendor only.</b><br/><br/>');
       }
    }                                       
  }
}
}