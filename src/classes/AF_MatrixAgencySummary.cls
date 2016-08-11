/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_MatrixAgencySummary
@CreateDate : 28/6/2014
@Description : This is a controller class for AF_UL_oopsMatrix Page, 
@             this is used to display the oops summary section in matrix page.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public  with sharing class AF_MatrixAgencySummary {
    /*** Variables for Summary Section ***/
    public Boolean isCMCO{get;set;}
    public Boolean isController{get;set;}
    public Boolean isProcurement{get;set;}
    public Boolean isFinanace{get;set;}
    public AF_OOPS_Actual__c oopsActObj{get;set;}
    public List<AF_OOPS_Actual__c> oopsActListObj{get;set;}
    public AF_Brand_Estimate__c brandEstimates{get;set;}
    public boolean q1Flag {get;set;}
    public boolean q2Flag {get;set;}
    public boolean q3Flag {get;set;}
    public boolean q4Flag {get;set;}
    public boolean isAgencyFlag{get;set;}
    public boolean ISCMCOSUAgency{get;set;}
    public Decimal currentOOPSPer {get;set;}
    public Integer oopsEstimate {get;set;}
    public Integer totalBaseFee {get;set;}
    public String overall{get;set;}
    public String agencyId {get;set;}
    public String fiscalYear {get;set;}
    public String brandId {get;set;}
    public Integer totalCrossBroder{get;set;}
    public Integer Q1{get;set;}
    public Integer Q2{get;set;}
    public Integer Q3{get;set;}
    public Integer Q4{get;set;}
    public String Q1ApprovalStatus{get;set;}
    public String Q2ApprovalStatus{get;set;}
    public String Q3ApprovalStatus{get;set;}
    public String Q4ApprovalStatus{get;set;}
    public AF_OOPS_Actual__c tempOopsRecord{get;set;}
    public String OOpsActualId;
    public list<AF_OOPS_Estimate__c>lst_OOPS_Estimate=new list<AF_OOPS_Estimate__c>();
    public Boolean IsCatFinance{get;set;}
    Public Boolean IsReadyforPO{get;set;}
    public List<String> quarterOops;
    public Integer ytgValue{get;set;}
    public String ytgColour{get;set;}
    set<String> oopsEstimateStatusUpdate;
    private static string className_STR=AF_MatrixAgencySummary.class.getName();
    /**********************************************************************
*  @Description: Contructor method
*  @name : AF_MatrixAgencySummary
*  @param : ApexPages.StandardController
*  @return : none
*************************************************************************/  
    public AF_MatrixAgencySummary(ApexPages.StandardController controller) {
        call_constructor();
        AF_ApproveActualsCtrl actConst = new AF_ApproveActualsCtrl();
        ytgValue = actConst.getTotalSum();
        if(ytgValue > oopsActObj.AF_OOPS_Estimate__c)
        {ytgColour=AF_Constants.YTG_RED;}else{ytgColour=AF_Constants.YTG_BLACK;}
    }
    /***********************************************************************************
*  @Description: this method is used to query and display the OOPS details to the user
*  @             and update's the status of each Quarter of the record.
*  @name : call_constructor
*  @param : none
*  @return: none.
*************************************************************************************/
    public void call_constructor(){
        OOpsActualId = ApexPages.currentPage().getParameters().get('Id');
        brandId = ApexPages.currentPage().getParameters().get('bId');
        agencyId = ApexPages.currentPage().getParameters().get('aId');
        fiscalYear = ApexPages.currentPage().getParameters().get('fy');
        q1Flag=false;
        q2Flag=false;
        q3Flag=false;
        q4Flag=false;
        IsReadyforPO=false;
        isAgencyFlag=false;
        ISCMCOSUAgency=false;
        currentOOPSPer=0.0;
        oopsEstimate=0;
        totalBaseFee=0;
        overall = '';
        totalCrossBroder=0;
        Q1=0;
        Q2=0;
        Q3=0;
        Q4=0;
        Q1ApprovalStatus='';
        Q2ApprovalStatus='';
        Q3ApprovalStatus='';
        Q4ApprovalStatus='';
        quarterOops = new List<String>();
        lst_OOPS_Estimate=new list<AF_OOPS_Estimate__c>();
        isCMCO = false;
        isProcurement = false;
        isController = false;
        isFinanace = false;
        identifyLoggedUser();
        //get OOPS Actual detail associated to this Brand and Agency
        oopsActObj = new AF_OOPS_Actual__c();
        oopsActListObj = new List<AF_OOPS_Actual__c>();
        oopsActListObj = [SELECT  AF_iS_OOPS_Percentage__c,Name,AF_Status__c,Quarter__c,AF_Status_Q1__c,
        AF_Status_Q2__c,AF_Status_Q4__c,AF_Status_Q3__c,AF_Q1_Approval_Status__c,
        AF_Q2_Approval_Status__c,AF_Q3_Approval_Status__c,AF_Q4_Approval_Status__c,
        Total_Crossborder__c,Total_Base_Fee__c,AF_OOPS_Estimate__c,AF_No_Of_CrossBorder__c,
        Overall__c,AF_Agency_lk__r.Name,AF_Brand__c,AF_Brand__r.name,AF_Q1__c,AF_Q2__c,AF_Q3__c,AF_Q4__c,
        AF_Number_of_0_or_null_OOPS_estimates__c
        FROM AF_OOPS_Actual__c 
        WHERE AF_Brand__c = :brandId AND AF_Agency_lk__c = :agencyId AND AF_Fiscal_year__c = :fiscalYear];
        lst_OOPS_Estimate=[Select name,AF_Status__c from AF_OOPS_Estimate__c where AF_OOPS_Actual__r.id=:OOpsActualId];
        if(lst_OOPS_Estimate[0].AF_Status__c ==AF_Constants.OOPS_ACTUAL_READYFORPO){
            IsReadyforPO=true;
        }
        for(AF_OOPS_Actual__c oops: oopsActListObj){
            if(oops.Id == OOpsActualId){
                if(oops.Total_Base_Fee__c!=0){
                    currentOOPSPer=((oops.AF_OOPS_Estimate__c/oops.Total_Base_Fee__c)*100);
                    currentOOPSPer=currentOOPSPer.setScale(1);
                }
                oopsActObj = oops;
                String q = oopsActObj.Quarter__c;
                quarterOops = q.split(';');
            }
        }
        oopsQuarterStatus();
    }
    /***********************************************************************************
*  @Description: this method is used to get the status of each quarter OOPS
*  @name : oopsQuarterStatus
*  @param : none
*  @return: none.
*************************************************************************************/
    public void oopsQuarterStatus(){
        tempOopsRecord = new AF_OOPS_Actual__c();
        for(AF_OOPS_Actual__c oops:oopsActListObj){
            String quarterValue = oops.Quarter__c;
            if(quarterValue!=null){
                if(quarterValue.contains(AF_Constants.QUARTER1)){
                    tempOopsRecord.AF_Q1__c = oops.AF_Q1__c;
                    tempOopsRecord.AF_Q1_Approval_Status__c = oops.AF_Q1_Approval_Status__c;
                }
                if(quarterValue.contains(AF_Constants.QUARTER2)){
                    tempOopsRecord.AF_Q2__c = oops.AF_Q2__c;
                    tempOopsRecord.AF_Q2_Approval_Status__c = oops.AF_Q2_Approval_Status__c;
                }
                if(quarterValue.contains(AF_Constants.QUARTER3)){
                    tempOopsRecord.AF_Q3__c = oops.AF_Q3__c;
                    tempOopsRecord.AF_Q3_Approval_Status__c=oops.AF_Q3_Approval_Status__c;
                }
                if(quarterValue.contains(AF_Constants.QUARTER4)){
                    tempOopsRecord.AF_Q4__c = oops.AF_Q4__c;
                    tempOopsRecord.AF_Q4_Approval_Status__c = oops.AF_Q4_Approval_Status__c;
                }
            }
        }
    }
    /***********************************************************************************
*  @Description: this method is used to identify which user has logged in
*  @name : identifyLoggedUser
*  @param : none
*  @return: none.
*************************************************************************************/
    public void identifyLoggedUser(){
        User userObj = new User();
        userObj = [Select id, AF_UserTypeText__c from User where id=:UserInfo.getUserId()];
        //check whether logged in User is Agency or CMCO User
        if(userObj.AF_UserTypeText__c==AF_Constants.UT_AGENCY){
            //if Agency User then make AgencyFlag true
            isAgencyFlag=true;
        }
        if(userObj.AF_UserTypeText__c==AF_Constants.UT_CMCP_SUPERUSER || userObj.AF_UserTypeText__c==AF_Constants.UT_AGENCY ){
            //if Agency User then make AgencyFlag true
            ISCMCOSUAgency=true;
        }
        if(userObj.AF_UserTypeText__c==AF_Constants.UT_CATEGORY_FINANCE|| userObj.AF_UserTypeText__c==AF_Constants.UT_CMCP_SUPERUSER){
            isFinanace = true;
        }
    }
    /***********************************************************************************
*  @Description: this method is used to return to Homepage
*  @name : backToHomePage
*  @param : none
*  @return: pagereference.
*************************************************************************************/
    public pagereference backToHomePage(){
        return null;
    }
    /***********************************************************************************
*  @Description: this method is used to return to chatter
*  @name : backToChatter
*  @param : none
*  @return: pagereference.
*************************************************************************************/
    public pagereference backToChatter(){
        return null;
    }
    /***********************************************************************************
*  @Description: this method is used to save the entered values in OOPSActual
*  @name : save
*  @param : none
*  @return: none.
*************************************************************************************/
    public void save(){
        try{
            String msg;
            AF_OOPSRecordManager OOPSRecordManager = new AF_OOPSRecordManager();
            OOPSRecordManager.OOPSActual = oopsActObj; 
            OOPSRecordManager.RecalculateOOPSEstimates();
            update oopsActObj;
            call_constructor();
            AF_OOPS_Actual__c oopsActObj1 = [SELECT AF_Number_of_0_or_null_OOPS_estimates__c
            FROM AF_OOPS_Actual__c 
            WHERE Id =:oopsActObj.Id];
            if(oopsActObj1.AF_Number_of_0_or_null_OOPS_estimates__c > 0) {
                msg = Label.AF_Refreshed;
            }else {
                msg = Label.AF_OOPS_Donot_Exist;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
        }catch(DMLException dml){
            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'save',dml.getMessage(),dml.getTypeName(),dml.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.fatal,dml.getMessage()));
        }
    }
    /*****************************************************************************************
*  @Description: this method is used to query and check the status of each quarter status
                and update the uer entered oops values for each quarter in OOPSActual record
*  @name : submit
*  @param : none
*  @return: pagereference.
**********************************************************************************************/
    public pagereference submit(){
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
        oopsEstimateStatusUpdate = new set<String>();
        for(AF_OOPS_Actual__c oops:oopsActListObj){
            integer i=0;
            String quarterValue = oops.Quarter__c;
            if(quarterValue!=null){
                if(quarterValue.contains(AF_Constants.QUARTER1) && tempOopsRecord.AF_Q1__c!=oops.AF_Q1__c && tempOopsRecord.AF_Q1__c!=0 && tempOopsRecord.AF_Q1__c!=null){
                    oops.AF_Q1__c = tempOopsRecord.AF_Q1__c ;
                    oops.AF_Status__c=AF_Constants.CATEGORY_FINANCE;
                    oopsEstimateStatusUpdate.add(oops.Id);
                    i++;
                }
                if(quarterValue.contains(AF_Constants.QUARTER2) && tempOopsRecord.AF_Q2__c!=oops.AF_Q2__c && tempOopsRecord.AF_Q2__c!=0 && tempOopsRecord.AF_Q2__c!=null){
                    oops.AF_Q2__c = tempOopsRecord.AF_Q2__c ;
                    oops.AF_Status__c=AF_Constants.CATEGORY_FINANCE;
                    oopsEstimateStatusUpdate.add(oops.Id);
                    i++;
                }
                if(i>0){
                    updateOopsActual.add(oops);
                }
            }
        }
        submitExt(updateOopsActual);
        return null;
    }
    /*****************************************************************************************
*  @Description: this method is used to query and check the status of each quarter status
                and update the uer entered oops values for each quarter in OOPSActual record
*  @name : submit
*  @param : none
*  @return: pagereference.
**********************************************************************************************/
    public pagereference submitrecords(){
    List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
        for(AF_OOPS_Actual__c oops:oopsActListObj){
            integer i=0;
            String quarterValue = oops.Quarter__c;
            if(quarterValue!=null){
                if(quarterValue.contains(AF_Constants.QUARTER3) && tempOopsRecord.AF_Q3__c!=oops.AF_Q3__c && tempOopsRecord.AF_Q3__c!=0 && tempOopsRecord.AF_Q3__c!=null){
                    oops.AF_Q3__c = tempOopsRecord.AF_Q3__c ;
                    oops.AF_Status__c=AF_Constants.CATEGORY_FINANCE;
                    oopsEstimateStatusUpdate.add(oops.Id);
                    i++;
                }
                if(quarterValue.contains(AF_Constants.QUARTER4) && tempOopsRecord.AF_Q4__c!=oops.AF_Q4__c && tempOopsRecord.AF_Q4__c!=0 && tempOopsRecord.AF_Q4__c!=null){
                    oops.AF_Q4__c = tempOopsRecord.AF_Q4__c ;
                    oops.AF_Status__c=AF_Constants.CATEGORY_FINANCE;
                    oopsEstimateStatusUpdate.add(oops.Id);
                    i++;
                }
                if(i>0){
                    updateOopsActual.add(oops);
                }
            }
        }
        submitExt(updateOopsActual);
        return null;
    }
    public void submitExt(List<AF_OOPS_Actual__c> updateOopsActual1){
        list<AF_OOPS_Estimate__c> submit_OOPS_Estimate = new list<AF_OOPS_Estimate__c>();
        submit_OOPS_Estimate=[Select name,AF_Status__c from AF_OOPS_Estimate__c where AF_OOPS_Actual__r.id IN :oopsEstimateStatusUpdate];
        list<AF_OOPS_Estimate__c>updatedopps_est=new list<AF_OOPS_Estimate__c>();
        for(AF_OOPS_Estimate__c oops_est:submit_OOPS_Estimate){
            oops_est.AF_Status__c =AF_Constants.OOPS_ACTUAL_READYFORPO;
            updatedopps_est.add(oops_est);
        }
        if(updateOopsActual1.size()>0){
            try{
                update updateOopsActual1;
                update updatedopps_est;
            }
            catch(Exception e){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitExt',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
            }
        }
    }
    /*****************************************************************************************
*  @Description: this method is used to Approve the OOPSActual Amounts
*  @name : grApprove
*  @param : none
*  @return: pagereference.
**********************************************************************************************/
    public pagereference grApprove(){
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
        for(AF_OOPS_Actual__c oops:oopsActListObj){
            String quarterValue = oops.Quarter__c;
            if(quarterValue!=null){
                if(quarterValue.contains(AF_Constants.QUARTER1)){
                    if(q1Flag){
                        oops.AF_Q1_Approval_Status__c=AF_Constants.STATUS_APPROVED;
                        oops.AF_Status__c=AF_Constants.OOPS_ACTUAL_READYFORPO;
                    }
                }
                if(quarterValue.contains(AF_Constants.QUARTER2)){
                    if(q2Flag){
                        oops.AF_Q2_Approval_Status__c=AF_Constants.STATUS_APPROVED;
                        oops.AF_Status__c=AF_Constants.OOPS_ACTUAL_READYFORPO;
                    }
                }
                if(quarterValue.contains(AF_Constants.QUARTER3)){
                    if(q3Flag){
                        oops.AF_Q3_Approval_Status__c=AF_Constants.STATUS_APPROVED;
                        oops.AF_Status__c=AF_Constants.OOPS_ACTUAL_READYFORPO;
                    }
                }
                if(quarterValue.contains(AF_Constants.QUARTER4)){
                    if(q4Flag){
                        oops.AF_Q4_Approval_Status__c=AF_Constants.STATUS_APPROVED;
                        oops.AF_Status__c=AF_Constants.OOPS_ACTUAL_READYFORPO;
                    }
                }
                updateOopsActual.add(oops);
            }
        }
        if(updateOopsActual.size()>0){
            try{
                update updateOopsActual;
            }
            catch(Exception e){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'grApprove',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
            }
        }
        return null;
    }
    /*****************************************************************************************
*  @Description: this method is used to Reject the OOPSActual Amounts
*  @name : grReject
*  @param : none
*  @return: pagereference.
**********************************************************************************************/
    public pagereference grReject(){
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
        for(AF_OOPS_Actual__c oops:oopsActListObj){
            String quarterValue = oops.Quarter__c;
            if(quarterValue!=null){
                if(quarterValue.contains(AF_Constants.QUARTER1)){
                    if(q1Flag){
                        oops.AF_Q1_Approval_Status__c=AF_Constants.STATUS_REJECTED;
                        oops.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                    }
                }
                if(quarterValue.contains(AF_Constants.QUARTER2)){
                    if(q2Flag){
                        oops.AF_Q2_Approval_Status__c=AF_Constants.STATUS_REJECTED;
                        oops.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                    }
                }
                if(quarterValue.contains(AF_Constants.QUARTER3)){
                    if(q3Flag){
                        oops.AF_Q3_Approval_Status__c=AF_Constants.STATUS_REJECTED;
                        oops.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                    }
                }
                if(quarterValue.contains(AF_Constants.QUARTER4)){
                    if(q4Flag){
                        oops.AF_Q4_Approval_Status__c=AF_Constants.STATUS_REJECTED;
                        oops.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                    }
                }
                updateOopsActual.add(oops);
            }
        }
        if(updateOopsActual.size()>0){
            try{
                update updateOopsActual;
            }
            catch(Exception e){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'grReject',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
            }
        }
        return null;
    }
    /*****************************************************************************************
*  @Description: this method is used to change the status of OOPSActual and OOPSEstimate
*  @name : SubmitOverall
*  @param : none
*  @return: pagereference.
**********************************************************************************************/
    public void SubmitOverall(){
        try{
            list<AF_OOPS_Estimate__c>updatedopps_est=new list<AF_OOPS_Estimate__c>();
            for(AF_OOPS_Estimate__c oops_est:lst_OOPS_Estimate){
                oops_est.AF_Status__c =AF_Constants.OOPS_ACTUAL_READYFORPO;
                updatedopps_est.add(oops_est);
            }
            for(String s:quarterOops){
                if(s==AF_Constants.QUARTER1){
                    oopsActObj.AF_Status_Q1__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                }
                if(s==AF_Constants.QUARTER2){
                    oopsActObj.AF_Status_Q2__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                }
                if(s==AF_Constants.QUARTER3){
                    oopsActObj.AF_Status_Q3__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                }
                if(s==AF_Constants.QUARTER4){
                    oopsActObj.AF_Status_Q4__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                }
            }
            oopsActObj.AF_iS_OOPS_Percentage__c=True;
            oopsActObj.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
            update oopsActObj;
            update updatedopps_est;
        }catch(DMLException dml){
            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'SubmitOverall',dml.getMessage(),dml.getTypeName(),dml.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.fatal,dml.getMessage()));
        }
    } 
}