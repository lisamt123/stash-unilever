/*
 * @author Pooja Kanani
 * @date 22/12/2015
 * @description - This Class is used to perform operation on before update event of PWORFTrigger
 */
public with sharing class CPA_PWORF_TriggerUtil{
    public static boolean isSubmitted=false;
    public static Map<string, SLAConfiguration__c> SLAMap {get;set;}
    //Public static List<string> keyNames {get;set;}
/*
    * Method Name : recallApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform recall Approval process on PWORF record
    */
     public static void recallApproval(List<CPA_PWORF__c> oldPWORFList,List<CPA_PWORF__c> newPWORFList)    
    { 
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem ];
        for (Integer i = 0; i < newPWORFList.size(); i++) {
            if((oldPWORFList[i].pkl_Status__c  == 'Submitted' || oldPWORFList[i].pkl_Status__c  == 'Resubmitted') && (newPWORFList[i].pkl_Status__c == 'Cancelled' || newPWORFList[i].pkl_Status__c == 'Withhold')){
                //PWORF.isCancelled__c = true;
                for(ProcessInstanceWorkitem piwi:piwiList){
                    if(piwi.ProcessInstance.TargetObjectId == newPWORFList[i].id && !isSubmitted ){ 
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                        req.setComments('Recalling and unlocking request.');
                        req.setAction('Removed');
                        req.setWorkitemId(piwi.Id);
                        Approval.ProcessResult result =  Approval.process(req);
                        isSubmitted = true;
                    }                   
                }
            }
        }
    }  
    /*
    * Method Name : submitforApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform submit for  Approval process on PWORF record
    */
     public static void submitforApproval(List<CPA_PWORF__c> oldPWORFList,List<CPA_PWORF__c> newPWORFList)    
    {
       set<Id> setId = new Set<Id>();
      List<CPA_PWORF__c> WithholdsetId = new List<CPA_PWORF__c>();
       Approval.ProcessWorkitemRequest[] prWkItemsForApproval = New Approval.ProcessWorkItemRequest[]{};
       Approval.ProcessSubmitRequest[] reqlist = new Approval.ProcessSubmitRequest[]{};
       for (Integer i = 0; i < newPWORFList.size(); i++) {
            
        if ((oldPWORFList[i].pkl_Status__c  <> 'Submitted' &&   newPWORFList[i].pkl_Status__c == 'Submitted')|| (oldPWORFList[i].pkl_Status__c  <> 'Resubmitted' &&   newPWORFList[i].pkl_Status__c == 'Resubmitted') &&  !isSubmitted) {
             
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(newPWORFList[i].Id);
            // submit the approval request for processing
            //Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful
            reqlist.add(req);
            system.debug('req--->'+req);
            isSubmitted = true;
        }else if(oldPWORFList[i].pkl_Status__c  <> 'Auto Accepted' &&   newPWORFList[i].pkl_Status__c == 'Auto Accepted'){
                setId.add(newPWORFList[i].Id);      
        }else if(oldPWORFList[i].pkl_Status__c  <> 'Withhold' &&   newPWORFList[i].pkl_Status__c == 'Withhold'){
            WithholdsetId.add(newPWORFList[i]);
        }
 
        }
        if(!reqlist.isEmpty()){
             Approval.ProcessResult[] result = Approval.process(reqlist);
             system.debug('result --->'+result );
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
                    prWkItem.setComments('Auto Accepted');
                    prWkItem.setAction('Approve');
                    prWkItems.add(prWkItem);
                  
                }
            }          
            
            if(!prWkItems.isEmpty()){                
                Approval.ProcessResult[] appResult = Approval.process(prWkItems);                
            }
        }
        
    
    }
/*
    * Method Name : vDMNameUpdate
    * Parameter   : 
    * Return type : None
    * Description : This method is to insert the VDM_Name__c on PWORF record
    */
    /* public static void vDMNameUpdate(List<CPA_PWORF__c> newPWORFList){   
    List<CPA_VDM__c> vdms = [SELECT Id, name FROM CPA_VDM__c];   

    for (CPA_PWORF__c  pworf: newPWORFList ){
            if(vdms!=null && vdms[0]!=null){
                pworf.VDM__c = vdms[0].id;                      
                pworf.VDM_Name__c= vdms[0].name;
            }           
        }
    }*/


/*
    * Method Name : Project_requestorAssign
    * Parameter   : 
    * Return type : None
    * Description : This method is to assign the lkp_Project_requestor__c on PWORF record if it is empty
    */
    public static void AssignProject_requestor(List<CPA_PWORF__c> newPWORFList){   
      /*  system.debug('pworfs>>>>>>>'+newPWORFList);
         Id requestor = null;
        for (CPA_PWORF__c  pworf: newPWORFList ){
            requestor = pworf.lkp_Project_requestor__c;
            if( requestor == null){
                Id creatorId = pworf.CreatedById ;
                String strCreatedby = Id.valueOf(creatorId);
                if(strCreatedby.startsWith('005')){
                    System.debug('pworf.creatorId -> '+creatorId);
                User userObj = [select id,name from user where id = :creatorId];
                System.debug(' userObj.name-> '+userObj);
                pworf.lkp_Project_requestor__c = userObj.Id;
                }
            } 
        } */
    }
   
    
    /*
    * Method Name : updateSLAData
    * Parameter   : oldPWORFList, newPWORFList
    * Return type : None
    * Author      : Dinesh Girase    
    * Description : This method updates SLA related fields on PWORF record
    */
    public static void updateSLAData(List<CPA_PWORF__c> newPWORFList){
        //Code review comments - remove hard coded values and use constants
        //Remove debug statements
        
        String strStatus = newPWORFList[0].pkl_Status__c;
        Date dt1 = Date.today();
        if(strStatus.equalsIgnoreCase('Accepted') || strStatus.equalsIgnoreCase('Auto Accepted'))
            newPWORFList[0].dat_SLA1_Accepted_Date__c = dt1;
        else if(!strStatus.equalsIgnoreCase('Answered'))
            newPWORFList[0].dat_SLA1_Accepted_Date__c = null;
        if(strStatus.equalsIgnoreCase('Submitted')){
            
            newPWORFList[0].dat_Submitted_Date__c =dt1;
            newPWORFList[0].dat_Resubmitted_Date__c = dt1;
            Id recordTypeID = newPWORFList[0].RecordTypeID;
            List<RecordType> lstRecordType = [Select Name From RecordType where id =: recordTypeID Limit 1];
            String strRecordType = lstRecordType[0].Name;
            System.debug('strRecordType @@@@ ' + strRecordType);
            
            System.debug('newPWORFList @@@@ ' + newPWORFList);
            //CPA_PWORF__c pworfRec = [Select txt_SLA1__c, txt_SLA2__c From CPA_PWORF__c Where id =: newPWORFList[0].Id];
            
            SLAMap = SLAConfiguration__c.getAll(); 
            String strProjectScale='';
            String[] strPrjPhases;
            String strProjectPhases='';
            if(strRecordType.equalsIgnoreCase('Other')){
                
                if(newPWORFList[0].pkl_Project_Scale__c != null && newPWORFList[0].mpkl_Project_Phases__c != null ){
                    strProjectScale = newPWORFList[0].pkl_Project_Scale__c;
                    strPrjPhases = newPWORFList[0].mpkl_Project_Phases__c.split(';'); 
                    
                    for(String strPP : strPrjPhases){
                       if(strPP.equalsIgnoreCase('Plan'))
                           strProjectPhases = strProjectPhases + 'P';
                       if(strPP.equalsIgnoreCase('Analyse'))
                           strProjectPhases = strProjectPhases + 'A';
                       if(strPP.equalsIgnoreCase('Design'))
                           strProjectPhases = strProjectPhases + 'D';
                       if(strPP.equalsIgnoreCase('Build'))
                           strProjectPhases = strProjectPhases + 'B';
                       if(strPP.equalsIgnoreCase('Test'))
                           strProjectPhases = strProjectPhases + 'T';
                       if(strPP.equalsIgnoreCase('Deploy'))
                           strProjectPhases = strProjectPhases + 'D';       
                        if(strPP.equalsIgnoreCase('Other'))
                           strProjectPhases = strProjectPhases + 'Other';                                      
                    }
                    System.debug('strProjectScale @@@@ ' + strProjectScale );
                    System.debug('strProjectPhases @@@@ ' + strProjectPhases);
                    System.debug('strPrjPhases @@@@ ' + strPrjPhases);
                }
            }
            
            
            for(string SLAMapKey: SLAMap.keySet()){
                //keyNames.add(SLAMapKey);
                if(SLAMap.get(SLAMapKey).Name.equalsIgnoreCase('RA') && strRecordType.equalsIgnoreCase('Resource Augmentation')){
                    System.debug('RA_SLA1__c @@@@ ' + SLAMap.get(SLAMapKey).RA_SLA1__c);
                    System.debug('RA_SLA2__c @@@@ ' + SLAMap.get(SLAMapKey).RA_SLA2__c);
                    //pworfRec.txt_SLA1__c = SLAMap.get(SLAMapKey).RA_SLA1__c;
                    //pworfRec.txt_SLA2__c = SLAMap.get(SLAMapKey).RA_SLA2__c;
                    newPWORFList[0].txt_SLA1__c = SLAMap.get(SLAMapKey).RA_SLA1__c;
                    newPWORFList[0].txt_SLA2__c = SLAMap.get(SLAMapKey).RA_SLA2__c;
                    //pworfRec.dat_Expected_SLA1_Date__c
                    newPWORFList[0].dat_Expected_SLA2_Date__c = calculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).RA_SLA2__c));
                }

                if(strRecordType.equalsIgnoreCase('Other')){
                    if(SLAMap.get(SLAMapKey).Name.equalsIgnoreCase(strProjectScale) && strProjectPhases.equalsIgnoreCase('PA')){
                        System.debug('PA_SLA1__c @@@@ ' + SLAMap.get(SLAMapKey).PA_SLA1__c);
                        System.debug('PA_SLA2__c @@@@ ' + SLAMap.get(SLAMapKey).PA_SLA2__c);
                        //pworfRec.txt_SLA1__c = SLAMap.get(SLAMapKey).PA_SLA1__c;
                        //pworfRec.txt_SLA2__c = SLAMap.get(SLAMapKey).PA_SLA2__c;
                        newPWORFList[0].txt_SLA1__c = SLAMap.get(SLAMapKey).PA_SLA1__c;
                        newPWORFList[0].txt_SLA2__c = SLAMap.get(SLAMapKey).PA_SLA2__c;
                        newPWORFList[0].dat_Expected_SLA1_Date__c = calculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).PA_SLA1__c));
                        newPWORFList[0].dat_Expected_SLA2_Date__c = calculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).PA_SLA2__c));
                    }
                    if(SLAMap.get(SLAMapKey).Name.equalsIgnoreCase(strProjectScale) && strProjectPhases.equalsIgnoreCase('PADBTD')){
                        System.debug('PADBTD_SLA1__c @@@@ ' + SLAMap.get(SLAMapKey).PADBTD_SLA1__c);
                        System.debug('PADBTD_SLA2__c @@@@ ' + SLAMap.get(SLAMapKey).PADBTD_SLA2__c);
                        //pworfRec.txt_SLA1__c = SLAMap.get(SLAMapKey).PADBTD_SLA1__c;
                        //pworfRec.txt_SLA2__c = SLAMap.get(SLAMapKey).PADBTD_SLA2__c;
                        newPWORFList[0].txt_SLA1__c = SLAMap.get(SLAMapKey).PADBTD_SLA1__c;
                        newPWORFList[0].txt_SLA2__c = SLAMap.get(SLAMapKey).PADBTD_SLA2__c;
                        newPWORFList[0].dat_Expected_SLA1_Date__c = calculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).PADBTD_SLA1__c));
                        newPWORFList[0].dat_Expected_SLA2_Date__c = calculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).PADBTD_SLA2__c));
                    }
                    if(SLAMap.get(SLAMapKey).Name.equalsIgnoreCase(strProjectScale) && strProjectPhases.equalsIgnoreCase('DBTD')){
                        System.debug('DBTD_SLA1__c @@@@ ' + SLAMap.get(SLAMapKey).DBTD_SLA1__c);
                        System.debug('DBTD_SLA2__c @@@@ ' + SLAMap.get(SLAMapKey).DBTD_SLA2__c);
                        //pworfRec.txt_SLA1__c = SLAMap.get(SLAMapKey).DBTD_SLA1__c;
                        //pworfRec.txt_SLA2__c = SLAMap.get(SLAMapKey).DBTD_SLA2__c;
                        newPWORFList[0].txt_SLA1__c = SLAMap.get(SLAMapKey).DBTD_SLA1__c;
                        newPWORFList[0].txt_SLA2__c = SLAMap.get(SLAMapKey).DBTD_SLA2__c;
                        newPWORFList[0].dat_Expected_SLA1_Date__c = calculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).DBTD_SLA1__c));
                        newPWORFList[0].dat_Expected_SLA2_Date__c = calculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).DBTD_SLA2__c));
                    }
                    if(SLAMap.get(SLAMapKey).Name.equalsIgnoreCase(strProjectScale) && strProjectPhases.equalsIgnoreCase('Others')){
                        System.debug('Others_SLA1__c @@@@ ' + SLAMap.get(SLAMapKey).Others_SLA1__c);
                        System.debug('Others_SLA2__c @@@@ ' + SLAMap.get(SLAMapKey).Others_SLA2__c);
                        //pworfRec.txt_SLA1__c = SLAMap.get(SLAMapKey).Others_SLA1__c;
                        //pworfRec.txt_SLA2__c = SLAMap.get(SLAMapKey).Others_SLA2__c;
                        newPWORFList[0].txt_SLA1__c = SLAMap.get(SLAMapKey).Others_SLA1__c;
                        newPWORFList[0].txt_SLA2__c = SLAMap.get(SLAMapKey).Others_SLA2__c;
                        newPWORFList[0].dat_Expected_SLA1_Date__c = calculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).Others_SLA1__c));
                        newPWORFList[0].dat_Expected_SLA2_Date__c = calculationOfBusinessDaysForSLADates.addBusinessDays(dt1, Integer.valueOf(SLAMap.get(SLAMapKey).Others_SLA2__c));
                    }
                }
            }
            //update pworfRec;
        }//Submitted if condition
    }
    
/**   Method Name : requireApprovalComments
    * Parameter   : newPWORFList
    * Return type : None
    * Author      : Pooja Kanani  
    * Description : This method make the Approval comments require
    */
    public static void requireApprovalComments(List<CPA_PWORF__c> newPWORFList){
 
  // Create a map that stores all the objects that require editing 
  Map<Id, CPA_PWORF__c> approvalStatements = new Map<Id, CPA_PWORF__c>{};

  for(CPA_PWORF__c inv: newPWORFList)
  {
    // Put all objects for update that require a comment check in a map,
    // so we only have to use 1 SOQL query to do all checks
    
    if (inv.Approval_Comment_Check__c == 'Required')
    { 
      approvalStatements.put(inv.Id, inv);
      // Reset the field value to null, 
      // so that the check is not repeated,
      // next time the object is updated
      inv.Approval_Comment_Check__c = null; 
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

    /**   Method Name : requireApprovalComments
    * Parameter   : newPWORFList
    * Return type : None
    * Author      : Dinesh Girase  
    * Description : This method make the Approval comments require
    */
    public static void forSearch(List<CPA_PWORF__c> newPWORFList){
        Integer maxNo=0;
        List<AggregateResult> maxNum = new List<AggregateResult>();
        maxNum = [SELECT Max(For_Search_Numeric__c) FROM CPA_PWORF__c];
        for(AggregateResult maxNumber : maxNum){
            maxNo = Integer.valueOf(maxNumber.get('expr0') + '');
            System.debug('maxNum######## : ' + maxNo);
        }
        List<CPA_PWORF__c> pworfs = [SELECT For_Search__c FROM CPA_PWORF__c Where Id =: newPWORFList[0].ID];
    }
   
    
}