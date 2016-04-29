/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_ApproveActualsCtrl
   @CreateDate : 25/8/2014
   @Description : This is a controller class for AF_ApproveActuals component, 
   @              this is used to OOPS Approval Process.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public with sharing class AF_ApproveActualsCtrl {
    public List<AF_OOPS_Actual__c> oopsActuals{get;set;}
    public String fiscalYear{get;set;}
    public String agency{get;set;}
    public String brand{get;set;}
    public List<actualApproval> actualApprovalList {get; set;}
    public  Boolean isAgency;
    public Boolean isFinance;
    private Map<String, AF_OOPS_Actual__c> quarterActualsMap;
    private List<String> quartersOrder;
    public String selectedQuarter{get;set;}
    public String message{get;set;}
    public String rjComment{get;set;}
    private static string NoAction = 'NoAction';
    private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
    public static Map<String, String> docQuarterMap = new Map<String, String>{
        'Q1' => 'OOPS Q1 Backup',
        'Q2' => 'OOPS Q2 Backup',
        'Q3' => 'OOPS Q3 Backup',
        'Q4' => 'OOPS Q4 Backup'};
    private Map<String, String> userActionMap = new Map<String, String>{'ag-With Agency' => 'EnterActuals', 
        'ag-Rejected - Enter Actuals' => 'EnterActuals', 
        'ag-With Category Finance' => NoAction,
        'ag-Approved' => NoAction,
        'cf-With Agency' => NoAction, 
        'cf-Rejected - Enter Actuals' => NoAction, 
        'cf-With Category Finance' => 'ApproveReject',
        'cf-Approved' => NoAction};
    /****************************/
    //Added on 12th sept,2014
    /****************************/
    public List<actualApproval> lstActualApprovals {get;set;}
    /**********************************************************************
*  @Description: Contructor method
*  @name : AF_ApproveActualsCtrl
*  @param : none
*  @return : none
*************************************************************************/  
    public AF_ApproveActualsCtrl() {
        isAgency = false;
        isFinance = false;
        quarterActualsMap = new Map<String, AF_OOPS_Actual__c>();
        quartersOrder = new List<String>();
        List<User> userDetails =[SELECT Profile.Name, AF_Agency_Fees_User_Type__c FROM User 
        WHERE Id = :UserInfo.getUserId() ];
        for(User u : userDetails) {
            if(u.Profile.Name == AF_Constants.USERPROFILE_AF_AGENCYPORTALUSER) {
                isAgency = true;
            }else if(u.AF_Agency_Fees_User_Type__c == AF_Constants.UT_CATEGORY_FINANCE){
                isFinance = true;
            }
        }
        fiscalYear = ApexPages.currentPage().getParameters().get('fy');
        agency = ApexPages.currentPage().getParameters().get('aId');
        brand = ApexPages.currentPage().getParameters().get('bId');
        oopsActuals = [SELECT Name, Quarter__c, AF_Status_Q1__c, AF_Status_Q2__c, AF_Status_Q3__c, AF_Status_Q4__c,
        AF_Q1__c, AF_Q2__c, AF_Q3__c, AF_Q4__c,AF_Q1_Backup__c,AF_Q2_Backup__c,AF_Q3_Backup__c,AF_Q4_Backup__c,
        AF_Q1_Rejection_Comment__c, AF_Q2_Rejection_Comment__c, AF_Q3_Rejection_Comment__c, AF_Q4_Rejection_Comment__c 
        FROM AF_OOPS_Actual__c 
        WHERE AF_Fiscal_year__c =:fiscalYear AND AF_Agency_lk__c = :agency AND AF_Brand__c = :brand LIMIT 4];
        for(AF_OOPS_Actual__c o: oopsActuals) {
            for(String eachQuarter : o.Quarter__c.split(';')) {
                quarterActualsMap.put(eachQuarter, o);
                quartersOrder.add(eachQuarter);
            }
        }
        quartersOrder.sort();
        /****************************/
        //Added on 12th sept,2014
        /****************************/
        lstActualApprovals = getActualApprovals();
    }
    /**********************************************************************
*  @Description: this method is calculate the sum of all quarter oops amounts
*  @name : getTotalSum
*  @param : none
*  @return: Integer.
**********************************************************************/
    public Integer getTotalSum() {
        List<actualApproval> actList = getActualApprovals();
        actualApproval actObj = actList[4];
        return actObj.actualInput;
    }
    /**********************************************************************
*  @Description: this method is calculate the sum of all quarter oops amounts
*  @name : getTotalSum
*  @param : none
*  @return: Integer.
**********************************************************************/
    private Boolean isBackUpUploaded(String quarter) {
        Boolean valueToReturn = false;
        if(quarter == AF_Constants.QUARTER1) {
            valueToReturn = quarterActualsMap.get(quarter).AF_Q1_Backup__c != null ? quarterActualsMap.get(quarter).AF_Q1_Backup__c : false;
        }else if(quarter == AF_Constants.QUARTER2) {
            valueToReturn = quarterActualsMap.get(quarter).AF_Q2_Backup__c != null ? quarterActualsMap.get(quarter).AF_Q2_Backup__c : false;
        }else if(quarter == AF_Constants.QUARTER3) {
            valueToReturn = quarterActualsMap.get(quarter).AF_Q3_Backup__c != null ? quarterActualsMap.get(quarter).AF_Q3_Backup__c : false;
        }else if(quarter == AF_Constants.QUARTER4) {
            valueToReturn = quarterActualsMap.get(quarter).AF_Q4_Backup__c != null ? quarterActualsMap.get(quarter).AF_Q4_Backup__c : false;
        }
        return valueToReturn;
    }
    /**********************************************************************
*  @Description: this method is used to set the values for OOPS action,
   @                 Status,each quarter amount.
*  @name : getActualApprovals
*  @param : none
*  @return: List<actualApproval>.
**********************************************************************/
    public List<actualApproval> getActualApprovals() {
        Integer quarterSum = 0;
        actualApprovalList = new List<actualApproval>();
        actualApproval wrapActual;
        for(String eachQuarter : docQuarterMap.keySet()) {
            if(quarterActualsMap.get(eachQuarter) != null) {
                String quarterStatus = getQuarterStatus(eachQuarter);
                String usrAct = getUserAction(quarterStatus, eachQuarter);
                wrapActual = new actualApproval(quarterActualsMap.get(eachQuarter), getActualInputs(eachQuarter), 
                eachQuarter, usrAct, quarterStatus, null);
                quarterSum = getActualInputs(eachQuarter) != null ? quarterSum + getActualInputs(eachQuarter) : quarterSum;
            }else {
                wrapActual = new actualApproval(null, null, 
                eachQuarter, AF_Constants.NOACTION, null, null);    
            }
            actualApprovalList.add(wrapActual);
        }
        actualApprovalList.add(new actualApproval(null, quarterSum, 
        'Total', null, null, null));
        return actualApprovalList;
    }
    /**********************************************************************
*  @Description: this inner wrapper class used to set the values for OOPS action,
   @                 Status,each quarter amount.
*  @name : actualApproval
*  @param : none
*  @return: none.
**********************************************************************/
    public class actualApproval {
        public AF_OOPS_Actual__c oopsActual {get; set;}
        public Integer actualInput {get;set;}
        public String quarter {get; set;}
        public String userAction {get;set;}
        public String quarterStatus {get;set;}
        public String rejectComments {get;set;}
        public actualApproval(AF_OOPS_Actual__c oa, Integer acInp, String qrtr, String usrAct, String qrtrSts, String rjCmt) {
            oopsActual = oa;
            actualInput = acInp;
            quarter = qrtr;
            userAction = usrAct;
            quarterStatus = qrtrSts; 
            rejectComments = rjCmt;
        }
    }
    /**********************************************************************
*  @Description: this method used to capture the quarter and status of OOPS
*  @name : getUserAction
*  @param : none
*  @return: String.
**********************************************************************/
    public String getUserAction(String quarterStatus, String eachQuarter) {
        String valueToReturn='';
        Map<String, Boolean> quarterDateMap = new Map<String, Boolean>();
        List<AF_AgencyEmailAlerts__c> agencyAccessList = AF_AgencyEmailAlerts__c.getall().values();
        for(AF_AgencyEmailAlerts__c eachSetting : agencyAccessList) {
            if(eachSetting.Q1__c <= system.today()) {
                quarterDateMap.put(AF_Constants.QUARTER1, true);
            }else {
                quarterDateMap.put(AF_Constants.QUARTER1, false);
            }
            if(eachSetting.Q2__c <= system.today()) {
                quarterDateMap.put(AF_Constants.QUARTER2, true);
            }else {
                quarterDateMap.put(AF_Constants.QUARTER2, false);
            }
            if(eachSetting.Q3__c <= system.today()) {
                quarterDateMap.put(AF_Constants.QUARTER3, true);
            }else {
                quarterDateMap.put(AF_Constants.QUARTER3, false);
            }
            if(eachSetting.Q4__c <= system.today()) {
                quarterDateMap.put(AF_Constants.QUARTER4, true);
            }else {
                quarterDateMap.put(AF_Constants.QUARTER4, false);
            }
        }  
        if(isAgency) {
            if(quarterDateMap.get(eachQuarter)) {
                valueToReturn = isBackUpUploaded(eachQuarter) && 
                userActionMap.get('ag-'+quarterStatus) == AF_Constants.ENTERACTUALS ? 'submit' : userActionMap.get('ag-'+quarterStatus);
            }else {
                valueToReturn = AF_Constants.NOACTION;
            }
        }else if(isFinance) {
            valueToReturn = userActionMap.get('cf-'+quarterStatus);
        }
        return valueToReturn;
    }
    /**********************************************************************
*  @Description: this method used to capture status of OOPS
*  @name : getQuarterStatus
*  @param : none
*  @return: String.
**********************************************************************/
    private String getQuarterStatus(String quarter) {
        String valueToReturn='';
        if(quarter == AF_Constants.QUARTER1) {
            valueToReturn = quarterActualsMap.get(quarter).AF_Status_Q1__c;
        }else if(quarter == AF_Constants.QUARTER2) {
            valueToReturn = quarterActualsMap.get(quarter).AF_Status_Q2__c;
        }else if(quarter == AF_Constants.QUARTER3) {
            valueToReturn = quarterActualsMap.get(quarter).AF_Status_Q3__c;
        }else if(quarter == AF_Constants.QUARTER4) {
            valueToReturn = quarterActualsMap.get(quarter).AF_Status_Q4__c;
        }
        return valueToReturn;
    }
    /**********************************************************************
*  @Description: this method used to capture input amounts of OOPS
*  @name : getActualInputs
*  @param : none
*  @return: Integer.
**********************************************************************/
    private Integer getActualInputs(String quarter) {
        Integer valueToReturn = 0;
        if(quarter == AF_Constants.QUARTER1) {
            valueToReturn = Integer.valueOf(quarterActualsMap.get(quarter).AF_Q1__c);
        }else if(quarter == AF_Constants.QUARTER2) {
            valueToReturn = Integer.valueOf(quarterActualsMap.get(quarter).AF_Q2__c);
        }else if(quarter == AF_Constants.QUARTER3) {
            valueToReturn = Integer.valueOf(quarterActualsMap.get(quarter).AF_Q3__c);
        }else if(quarter == AF_Constants.QUARTER4) {
            valueToReturn = Integer.valueOf(quarterActualsMap.get(quarter).AF_Q4__c);
        }   
        return valueToReturn;
    }
    /**********************************************************************
*  @Description: this method used to check whether document is uploaded
*  @name : getActualUploadedValues
*  @param : none
*  @return: Boolean.
**********************************************************************/
    /*private Boolean getActualUploadedValues(AF_OOPS_Actual__c oop, String quarter) {
        Boolean valueToReturn=false;
        if(quarter == AF_Constants.QUARTER1) {
            valueToReturn = oop.AF_Q1_Backup__c;
        }else if(quarter == AF_Constants.QUARTER2) {
            valueToReturn = oop.AF_Q2_Backup__c;
        }else if(quarter == AF_Constants.QUARTER3) {
            valueToReturn = oop.AF_Q3_Backup__c;
        }else if(quarter == AF_Constants.QUARTER4) {
            valueToReturn = oop.AF_Q4_Backup__c;
        }
        return valueToReturn;
    }*/
    /**********************************************************************
*  @Description: this method used to update the OOPS each quarter input amounts
*  @name : saveQuarterInputs
*  @param : ActualApproval,quarter
*  @return: AF_OOPS_Actual__c.
**********************************************************************/
    private AF_OOPS_Actual__c saveQuarterInputs(ActualApproval oop, String quarter) {
        AF_OOPS_Actual__c sObjToReturn = new AF_OOPS_Actual__c();
        sObjToReturn = oop.oopsActual;
        if(quarter == AF_Constants.QUARTER1) {
            sObjToReturn.AF_Q1__c = oop.actualInput;
        }else if(quarter == AF_Constants.QUARTER2) {
            sObjToReturn.AF_Q2__c = oop.actualInput;
        }else if(quarter == AF_Constants.QUARTER3) {
            sObjToReturn.AF_Q3__c = oop.actualInput;
        }else if(quarter == AF_Constants.QUARTER4) {
            sObjToReturn.AF_Q4__c = oop.actualInput;
        }
        return sObjToReturn;
    }
    /**********************************************************************
*  @Description: this method used to submit the OOPS
*  @name : submit
*  @param : none
*  @return: none.
**********************************************************************/
    public void submit(){
        //Boolean isDoc = false;
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
        Integer counter =0;
        for(actualApproval oop:actualApprovalList){
            if(oop.quarter == selectedQuarter){      
                if(counter==0){
                    if(oop.quarter==AF_Constants.QUARTER1&& oop.actualInput != null && oop.actualInput !=0){
                        oop.oopsActual.AF_Q1__c = oop.actualInput;
                        oop.oopsActual.AF_Status_Q1__c = AF_Constants.CATEGORY_FINANCE;
                        oop.oopsActual.AF_Status__c=AF_Constants.CATEGORY_FINANCE;
                        updateOopsActual.add(oop.oopsActual);
                        oop.userAction = AF_Constants.NOACTION;
                    }
                    else if(oop.quarter==AF_Constants.QUARTER2 && oop.actualInput != null && oop.actualInput !=0){
                        oop.oopsActual.AF_Q2__c = oop.actualInput;
                        oop.oopsActual.AF_Status_Q2__c = AF_Constants.CATEGORY_FINANCE;
                        oop.oopsActual.AF_Status__c=AF_Constants.CATEGORY_FINANCE;
                        updateOopsActual.add(oop.oopsActual);
                        oop.userAction = AF_Constants.NOACTION;
                    }
                    else if (oop.quarter==AF_Constants.QUARTER3 && oop.actualInput != null && oop.actualInput !=0){
                        oop.oopsActual.AF_Q3__c = oop.actualInput;
                        oop.oopsActual.AF_Status_Q3__c = AF_Constants.CATEGORY_FINANCE;
                        oop.oopsActual.AF_Status__c=AF_Constants.CATEGORY_FINANCE;
                        updateOopsActual.add(oop.oopsActual);
                        oop.userAction = AF_Constants.NOACTION;
                    }
                    else if(oop.quarter==AF_Constants.QUARTER4){
                        oop.oopsActual.AF_Q4__c = oop.actualInput;
                        //oop.actualInput = oop.actualInput;
                        oop.oopsActual.AF_Status_Q4__c = AF_Constants.CATEGORY_FINANCE;
                        oop.oopsActual.AF_Status__c=AF_Constants.CATEGORY_FINANCE;
                        updateOopsActual.add(oop.oopsActual);
                        oop.userAction = AF_Constants.NOACTION;
                    }
                }
            }
        }
        if(updateOopsActual.size()>0){
        	try{
				update updateOopsActual;
			}
			catch(Exception e)
			{
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submit',e.getMessage(),e.getTypeName(),e.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
			}	  
        }
    }
    /**********************************************************************
*  @Description: this method used to Approve the OOPS
*  @name : grApprove
*  @param : none
*  @return: pagereference.
**********************************************************************/
    public pagereference grApprove(){
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
        for(actualApproval oop:actualApprovalList){
            if(oop.quarter == selectedQuarter){
                if(oop.quarter==AF_Constants.QUARTER1){
                    oop.oopsActual.AF_Status_Q1__c = AF_Constants.STATUS_APPROVED;
                    oop.oopsActual.AF_Status__c=AF_Constants.OOPS_ACTUAL_READYFORPO;
                    oop.oopsActual.AF_Q1_Backup__c = false;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.NOACTION;
                }
                if(oop.quarter==AF_Constants.QUARTER2){
                    oop.oopsActual.AF_Status_Q2__c = AF_Constants.STATUS_APPROVED;
                    oop.oopsActual.AF_Status__c=AF_Constants.OOPS_ACTUAL_READYFORPO;
                    oop.oopsActual.AF_Q2_Backup__c = false;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.NOACTION;
                }
                if(oop.quarter==AF_Constants.QUARTER3){
                    oop.oopsActual.AF_Status_Q3__c = AF_Constants.STATUS_APPROVED;
                    oop.oopsActual.AF_Status__c=AF_Constants.OOPS_ACTUAL_READYFORPO;
                    oop.oopsActual.AF_Q3_Backup__c = false;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.NOACTION;
                }
                if(oop.quarter==AF_Constants.QUARTER4){
                    oop.oopsActual.AF_Status_Q4__c = AF_Constants.STATUS_APPROVED;
                    oop.oopsActual.AF_Status__c=AF_Constants.OOPS_ACTUAL_READYFORPO;
                    oop.oopsActual.AF_Q4_Backup__c = false;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.NOACTION;
                }
            }
        }
        if(updateOopsActual.size()>0){
		try{
			update updateOopsActual;
		}
		catch(Exception e)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'grApprove',e.getMessage(),e.getTypeName(),e.getStackTraceString());
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		}
	}
	return null;
}
    /**********************************************************************
*  @Description: this method used to Reject the OOPS
*  @name : grReject
*  @param : none
*  @return: pagereference.
**********************************************************************/
    public pagereference grReject(){
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
        for(actualApproval oop:actualApprovalList){
            if(oop.quarter == selectedQuarter){
                oop.oopsActual.AF_Rejected_Quarter__c = oop.quarter;
                if(oop.quarter==AF_Constants.QUARTER1){
                    oop.oopsActual.AF_Status_Q1__c = AF_Constants.REJECTED_ENTER_ACTUALS;
                    oop.oopsActual.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                    oop.oopsActual.AF_Q1_Backup__c = false;
                    oop.oopsActual.AF_Q1_Rejection_Comment__c = oop.rejectComments;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.NOACTION;
                }
                if(oop.quarter==AF_Constants.QUARTER2){
                    oop.oopsActual.AF_Status_Q2__c = AF_Constants.REJECTED_ENTER_ACTUALS;
                    oop.oopsActual.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                    oop.oopsActual.AF_Q2_Backup__c = false;
                    oop.oopsActual.AF_Q2_Rejection_Comment__c = oop.rejectComments;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.NOACTION;
                }
                if(oop.quarter==AF_Constants.QUARTER3){
                    oop.oopsActual.AF_Status_Q3__c = AF_Constants.REJECTED_ENTER_ACTUALS;
                    oop.oopsActual.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                    oop.oopsActual.AF_Q3_Backup__c = false;
                    oop.oopsActual.AF_Q3_Rejection_Comment__c = oop.rejectComments;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.NOACTION;
                }
                if(oop.quarter==AF_Constants.QUARTER4){
                    oop.oopsActual.AF_Status_Q4__c = AF_Constants.REJECTED_ENTER_ACTUALS;
                    oop.oopsActual.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                    oop.oopsActual.AF_Q4_Backup__c = false;
                    oop.oopsActual.AF_Q4_Rejection_Comment__c = oop.rejectComments;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.NOACTION;
                }
            }
        }
        if(updateOopsActual.size()>0){
		try{
			update updateOopsActual;
		}
		catch(Exception e)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'grReject',e.getMessage(),e.getTypeName(),e.getStackTraceString());
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 	
		}	
	}
	return null;
}
    /**********************************************************************
*  @Description: this method used to Redo the OOPS amounts or documents
*  @name : redo
*  @param : none
*  @return: pagereference.
**********************************************************************/
    public pagereference redo(){
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
        for(actualApproval oop:actualApprovalList){
            if(oop.quarter == selectedQuarter){
                oop.oopsActual.AF_Rejected_Quarter__c = oop.quarter;
                if(oop.quarter==AF_Constants.QUARTER1){
                    oop.oopsActual.AF_Q1_Backup__c = false;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.ENTERACTUALS;
                }
                if(oop.quarter==AF_Constants.QUARTER2){
                    oop.oopsActual.AF_Q2_Backup__c = false;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.ENTERACTUALS;
                }
                if(oop.quarter==AF_Constants.QUARTER3){
                    oop.oopsActual.AF_Q3_Backup__c = false;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.ENTERACTUALS;
                }
                if(oop.quarter==AF_Constants.QUARTER4){
                    oop.oopsActual.AF_Q4_Backup__c = false;
                    updateOopsActual.add(oop.oopsActual);
                    oop.userAction = AF_Constants.ENTERACTUALS;
                }
            }
        }
        if(updateOopsActual.size()>0){
		try{
			update updateOopsActual;
		}
		catch(Exception e)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'redo',e.getMessage(),e.getTypeName(),e.getStackTraceString());
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 	
		}	
	}
	return null;
}

    /**********************************************************************
*  @Description: this method used to save the OOPS amounts or documents
*  @name : save
*  @param : none
*  @return: pagereference.
**********************************************************************/
    public PageReference save(){    
        Integer quarterSum = 0;
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();    
        for(ActualApproval ap :lstActualApprovals){
            if(ap.quarter == selectedQuarter){
                ap.userAction = 'UploadBackup';
                updateOopsActual.add(saveQuarterInputs(ap, ap.quarter));
                selectedQuarter = ap.quarter;
            }
            if(ap.quarter == 'Total') {
                ap.actualInput = quarterSum;
            }else {
                quarterSum = ap.actualInput != null ? quarterSum + ap.actualInput : quarterSum;
            }
        }
        if(updateOopsActual.size()>0){
		try{
			update updateOopsActual;
		}
		catch(Exception e)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'save',e.getMessage(),e.getTypeName(),e.getStackTraceString());
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 	
		}	
	}
	return null;
 }
}