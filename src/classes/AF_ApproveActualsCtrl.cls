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
    private Map<String, Boolean> documentMap = new Map<String, Boolean>();
    public String message{get;set;}
    public String rjComment{get;set;}
    public static Map<String, String> docQuarterMap = new Map<String, String>{
                                                                        'Q1' => 'OOPS Q1 Backup',
                                                                        'Q2' => 'OOPS Q2 Backup',
                                                                        'Q3' => 'OOPS Q3 Backup',
                                                                        'Q4' => 'OOPS Q4 Backup'};
    private Map<String, String> userActionMap = new Map<String, String>{'ag-With Agency' => 'EnterActuals', 
                                                                        'ag-Rejected - Enter Actuals' => 'EnterActuals', 
                                                                        'ag-With Category Finance' => 'NoAction',
                                                                        'ag-Approved' => 'NoAction',
                                                                        'cf-With Agency' => 'NoAction', 
                                                                        'cf-Rejected - Enter Actuals' => 'NoAction', 
                                                                        'cf-With Category Finance' => 'ApproveReject',
                                                                        'cf-Approved' => 'NoAction'};
                                                                        
    /****************************/
    //Added on 12th sept,2014
    /****************************/
    public List<actualApproval> lstActualApprovals {get;set;}
    public AF_ApproveActualsCtrl() {

        User userObj = new User();
        isAgency = false;
        isFinance = false;
        
        quarterActualsMap = new Map<String, AF_OOPS_Actual__c>();
        quartersOrder = new List<String>();
        
        List<User> userDetails =[SELECT Profile.Name, AF_Agency_Fees_User_Type__c FROM User 
                                                      WHERE Id = :UserInfo.getUserId() ];
        for(User u : userDetails) {
            if(u.Profile.Name == 'AF - Agency Portal User') {
                isAgency = true;
            }else if(u.AF_Agency_Fees_User_Type__c == 'Category Finance'){
                isFinance = true;
            }
        }
        
        /*isAgency = true;
        isFinance=false;*/
        fiscalYear = ApexPages.currentPage().getParameters().get('fy');
        agency = ApexPages.currentPage().getParameters().get('aId');
        brand = ApexPages.currentPage().getParameters().get('bId');
                    oopsActuals = [SELECT Name, Quarter__c, AF_Status_Q1__c, AF_Status_Q2__c, AF_Status_Q3__c, AF_Status_Q4__c,
                                    AF_Q1__c, AF_Q2__c, AF_Q3__c, AF_Q4__c,AF_Q1_Backup__c,AF_Q2_Backup__c,AF_Q3_Backup__c,AF_Q4_Backup__c,
                                    AF_Q1_Rejection_Comment__c, AF_Q2_Rejection_Comment__c, AF_Q3_Rejection_Comment__c, AF_Q4_Rejection_Comment__c 
                                    FROM AF_OOPS_Actual__c 
                                    WHERE AF_Fiscal_year__c =:fiscalYear AND AF_Agency_lk__c = :agency AND AF_Brand__c = :brand LIMIT 4];
        system.debug('** brand constructor : ' + brand);
        for(AF_OOPS_Actual__c o: oopsActuals) {
            for(String eachQuarter : o.Quarter__c.split(';')) {
                quarterActualsMap.put(eachQuarter, o);
                quartersOrder.add(eachQuarter);
            }
        }
        quartersOrder.sort();
        system.debug('** oopsActuals : ' + oopsActuals);
        
         /****************************/
        //Added on 12th sept,2014
        /****************************/
        lstActualApprovals = getActualApprovals();
        
    }
    
    public Integer getTotalSum() {
        
        List<actualApproval> actList = getActualApprovals();
        actualApproval actObj = actList[4];
        return actObj.actualInput;
    }
    
    private Boolean isBackUpUploaded(String quarter) {
        
        Boolean valueToReturn = false;
        if(quarter == 'Q1') {
            valueToReturn = quarterActualsMap.get(quarter).AF_Q1_Backup__c != null ? quarterActualsMap.get(quarter).AF_Q1_Backup__c : false;
        }else if(quarter == 'Q2') {
            valueToReturn = quarterActualsMap.get(quarter).AF_Q2_Backup__c != null ? quarterActualsMap.get(quarter).AF_Q2_Backup__c : false;
        }else if(quarter == 'Q3') {
            valueToReturn = quarterActualsMap.get(quarter).AF_Q3_Backup__c != null ? quarterActualsMap.get(quarter).AF_Q3_Backup__c : false;
        }else if(quarter == 'Q4') {
            valueToReturn = quarterActualsMap.get(quarter).AF_Q4_Backup__c != null ? quarterActualsMap.get(quarter).AF_Q4_Backup__c : false;
        }
        return valueToReturn;
    }
    
    public List<actualApproval> getActualApprovals() {
        
            Integer quarterSum = 0;
            Integer actualvalue=0;
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
                                                    eachQuarter, 'NoAction', null, null);    
                }
                system.debug(eachQuarter + ' ** wrapActual : ' + wrapActual);
                                
                actualApprovalList.add(wrapActual);
            }
            actualApprovalList.add(new actualApproval(null, quarterSum, 
                                                    'Total', null, null, null));
        return actualApprovalList;
        
    }
    
    public class actualApproval {
        public AF_OOPS_Actual__c oopsActual {get; set;}
        public Integer actualInput {get;set;}
        public String quarter {get; set;}
        public String userAction {get;set;}
        public String quarterStatus {get;set;}
        public String rejectComments {get;set;}
         
        public actualApproval(AF_OOPS_Actual__c oa, Integer acInp, String qrtr, String usrAct, String qrtrSts, String rjCmt) {
            system.debug('calling constructor..');
            oopsActual = oa;
            actualInput = acInp;
            quarter = qrtr;
            userAction = usrAct;
            quarterStatus = qrtrSts; 
            rejectComments = rjCmt;
        }
    }
    
    public String getUserAction(String quarterStatus, String eachQuarter) {
        
        String valueToReturn;
        Map<String, Boolean> quarterDateMap = new Map<String, Boolean>();
        List<AF_AgencyEmailAlerts__c> agencyAccessList = AF_AgencyEmailAlerts__c.getall().values();
        for(AF_AgencyEmailAlerts__c eachSetting : agencyAccessList) {
            if(eachSetting.Q1__c <= system.today()) {
                quarterDateMap.put('Q1', true);
            }else {
                quarterDateMap.put('Q1', false);
            }
            if(eachSetting.Q2__c <= system.today()) {
                quarterDateMap.put('Q2', true);
            }else {
                quarterDateMap.put('Q2', false);
            }
            if(eachSetting.Q3__c <= system.today()) {
                quarterDateMap.put('Q3', true);
            }else {
                quarterDateMap.put('Q3', false);
            }
            if(eachSetting.Q4__c <= system.today()) {
                quarterDateMap.put('Q4', true);
            }else {
                quarterDateMap.put('Q4', false);
            }
        }  
        if(isAgency) {
            if(quarterDateMap.get(eachQuarter)) {
                valueToReturn = isBackUpUploaded(eachQuarter) && 
                                    userActionMap.get('ag-'+quarterStatus) == 'EnterActuals' ? 'submit' : userActionMap.get('ag-'+quarterStatus);
            }else {
                valueToReturn = 'NoAction';
            }
        }else if(isFinance) {
            valueToReturn = userActionMap.get('cf-'+quarterStatus);
        }
        system.debug('cf-'+quarterStatus + '** usr ACTION : ' + valueToReturn + ' :: ' + userActionMap);
        return valueToReturn;
    }
    
    private String getQuarterStatus(String quarter) {
        
        String valueToReturn;
        if(quarter == 'Q1') {
            valueToReturn = quarterActualsMap.get(quarter).AF_Status_Q1__c;
        }else if(quarter == 'Q2') {
            valueToReturn = quarterActualsMap.get(quarter).AF_Status_Q2__c;
        }else if(quarter == 'Q3') {
            valueToReturn = quarterActualsMap.get(quarter).AF_Status_Q3__c;
        }else if(quarter == 'Q4') {
            valueToReturn = quarterActualsMap.get(quarter).AF_Status_Q4__c;
        }
        system.debug('** qrtrStat : ' + valueToReturn);
        return valueToReturn;
    }
    
    private Integer getActualInputs(String quarter) {
        
        Integer valueToReturn = 0;
        if(quarter == 'Q1') {
            valueToReturn = Integer.valueOf(quarterActualsMap.get(quarter).AF_Q1__c);
        }else if(quarter == 'Q2') {
            valueToReturn = Integer.valueOf(quarterActualsMap.get(quarter).AF_Q2__c);
        }else if(quarter == 'Q3') {
            valueToReturn = Integer.valueOf(quarterActualsMap.get(quarter).AF_Q3__c);
        }else if(quarter == 'Q4') {
            valueToReturn = Integer.valueOf(quarterActualsMap.get(quarter).AF_Q4__c);
        }   
        system.debug('** ac inp : ' + valueToReturn);
        return valueToReturn;
    }
    private Boolean getActualUploadedValues(AF_OOPS_Actual__c oop, String quarter) {
        
        Boolean valueToReturn;
        if(quarter == 'Q1') {
            valueToReturn = oop.AF_Q1_Backup__c;
        }else if(quarter == 'Q2') {
            valueToReturn = oop.AF_Q2_Backup__c;
        }else if(quarter == 'Q3') {
            valueToReturn = oop.AF_Q3_Backup__c;
        }else if(quarter == 'Q4') {
            valueToReturn = oop.AF_Q4_Backup__c;
        }
        
        return valueToReturn;
    }
    
    private AF_OOPS_Actual__c saveQuarterInputs(ActualApproval oop, String quarter) {
        
        AF_OOPS_Actual__c sObjToReturn = new AF_OOPS_Actual__c();
        sObjToReturn = oop.oopsActual;
        if(quarter == 'Q1') {
            sObjToReturn.AF_Q1__c = oop.actualInput;
        }else if(quarter == 'Q2') {
            sObjToReturn.AF_Q2__c = oop.actualInput;
        }else if(quarter == 'Q3') {
            sObjToReturn.AF_Q3__c = oop.actualInput;
        }else if(quarter == 'Q4') {
            sObjToReturn.AF_Q4__c = oop.actualInput;
        }
        
        return sObjToReturn;
    }
      public void submit(){
        
        Boolean isDoc = false;
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
        Integer counter =0;
        system.debug('selectedQuarter..'+selectedQuarter);
        for(actualApproval oop:actualApprovalList){
        if(oop.quarter == selectedQuarter){
            AF_OOPS_Actual__c oopsActl = [SELECT Name, Quarter__c, AF_Status_Q1__c, AF_Status_Q2__c, AF_Status_Q3__c, AF_Status_Q4__c,
                            AF_Q1__c, AF_Q2__c, AF_Q3__c, AF_Q4__c,AF_Q1_Backup__c,AF_Q2_Backup__c,AF_Q3_Backup__c,AF_Q4_Backup__c,
                            (SELECT ContentType FROM Attachments WHERE ContentType = :docQuarterMap.get(oop.quarter)) 
                        FROM AF_OOPS_Actual__c 
                        WHERE Id = :oop.oopsActual.Id];
            if(oopsActl.Attachments.size() > 0 && !getActualUploadedValues(oopsActl, oop.quarter)) {
                isDoc = true;
            }
            system.debug('oop.quarter...'+oop.quarter);
            /*if(!isDoc){
             counter++;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please attach a file and then save ' +  oop.quarter + '  Actuals'));
            }*/
            if(counter==0){
        if(oop.quarter=='Q1'&& oop.actualInput != null && oop.actualInput !=0){
                oop.oopsActual.AF_Q1__c = oop.actualInput;
                oop.oopsActual.AF_Status_Q1__c = 'With Category Finance';
                oop.oopsActual.AF_Status__c='With Category Finance';
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
               else if(oop.quarter=='Q2' && oop.actualInput != null && oop.actualInput !=0){
                
                oop.oopsActual.AF_Q2__c = oop.actualInput;
                oop.oopsActual.AF_Status_Q2__c = 'With Category Finance';
                oop.oopsActual.AF_Status__c='With Category Finance';
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
               else if (oop.quarter=='Q3' && oop.actualInput != null && oop.actualInput !=0){
                oop.oopsActual.AF_Q3__c = oop.actualInput;
                oop.oopsActual.AF_Status_Q3__c = 'With Category Finance';
                oop.oopsActual.AF_Status__c='With Category Finance';
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
                else if(oop.quarter=='Q4'){
                system.debug('inside Q4');
                oop.oopsActual.AF_Q4__c = oop.actualInput;
                oop.actualInput = oop.actualInput;
                oop.oopsActual.AF_Status_Q4__c = 'With Category Finance';
                oop.oopsActual.AF_Status__c='With Category Finance';
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
                }
        }
        
        }
        system.debug('updateOopsActual...'+updateOopsActual);
        if(updateOopsActual.size()>0){
            update updateOopsActual;
        }
        //wrapActual.clear();
        //getActualApprovals();
    
    }
    public pagereference grApprove(){
        system.debug('selectedQuarter...'+selectedQuarter);
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
        for(actualApproval oop:actualApprovalList){
            if(oop.quarter == selectedQuarter){
                if(oop.quarter=='Q1'){
                oop.oopsActual.AF_Status_Q1__c = 'Approved';
                oop.oopsActual.AF_Status__c='Ready For PO';
                oop.oopsActual.AF_Q1_Backup__c = false;
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
                if(oop.quarter=='Q2'){
                oop.oopsActual.AF_Status_Q2__c = 'Approved';
                oop.oopsActual.AF_Status__c='Ready For PO';
                oop.oopsActual.AF_Q2_Backup__c = false;
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
                if(oop.quarter=='Q3'){
                oop.oopsActual.AF_Status_Q3__c = 'Approved';
                oop.oopsActual.AF_Status__c='Ready For PO';
                oop.oopsActual.AF_Q3_Backup__c = false;
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
                if(oop.quarter=='Q4'){
                oop.oopsActual.AF_Status_Q4__c = 'Approved';
                oop.oopsActual.AF_Status__c='Ready For PO';
                oop.oopsActual.AF_Q4_Backup__c = false;
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
        }
        if(updateOopsActual.size()>0){
            update updateOopsActual;
        }
        
    }
    //ListActualApprovals();
    return null;
    }
    
     public pagereference grReject(){
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
         for(actualApproval oop:actualApprovalList){
            if(oop.quarter == selectedQuarter){
                oop.oopsActual.AF_Rejected_Quarter__c = oop.quarter;
                if(oop.quarter=='Q1'){
                oop.oopsActual.AF_Status_Q1__c = 'Rejected - Enter Actuals';
                oop.oopsActual.AF_Status__c='With Agency';
                oop.oopsActual.AF_Q1_Backup__c = false;
                oop.oopsActual.AF_Q1_Rejection_Comment__c = oop.rejectComments;
                system.debug('** rjComment Q1 : ' +oop.rejectComments);
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
                if(oop.quarter=='Q2'){
                oop.oopsActual.AF_Status_Q2__c = 'Rejected - Enter Actuals';
                oop.oopsActual.AF_Status__c='With Agency';
                oop.oopsActual.AF_Q2_Backup__c = false;
                oop.oopsActual.AF_Q2_Rejection_Comment__c = oop.rejectComments;
                system.debug('** rjComment Q2 : ' +oop.rejectComments);
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
                if(oop.quarter=='Q3'){
                oop.oopsActual.AF_Status_Q3__c = 'Rejected - Enter Actuals';
                oop.oopsActual.AF_Status__c='With Agency';
                oop.oopsActual.AF_Q3_Backup__c = false;
                oop.oopsActual.AF_Q3_Rejection_Comment__c = oop.rejectComments;
                system.debug('** rjComment Q3 : ' +oop.rejectComments);
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
                if(oop.quarter=='Q4'){
                oop.oopsActual.AF_Status_Q4__c = 'Rejected - Enter Actuals';
                oop.oopsActual.AF_Status__c='With Agency';
                oop.oopsActual.AF_Q4_Backup__c = false;
                oop.oopsActual.AF_Q4_Rejection_Comment__c = oop.rejectComments;
                system.debug('** rjComment Q4 : ' +oop.rejectComments);
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'NoAction';
                }
                
        }
        if(updateOopsActual.size()>0){
            update updateOopsActual;
        }
    
    }
      // ListActualApprovals(); 
         return null;
    }
    
    public pagereference redo(){
        
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
         for(actualApproval oop:actualApprovalList){
            if(oop.quarter == selectedQuarter){
                oop.oopsActual.AF_Rejected_Quarter__c = oop.quarter;
                if(oop.quarter=='Q1'){
                oop.oopsActual.AF_Q1_Backup__c = false;

                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'EnterActuals';
                }
                if(oop.quarter=='Q2'){
                oop.oopsActual.AF_Q2_Backup__c = false;
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'EnterActuals';
                }
                if(oop.quarter=='Q3'){
                oop.oopsActual.AF_Q3_Backup__c = false;
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'EnterActuals';
                }
                if(oop.quarter=='Q4'){
                oop.oopsActual.AF_Q4_Backup__c = false;
                
                updateOopsActual.add(oop.oopsActual);
                oop.userAction = 'EnterActuals';
                }
                
        }
        if(updateOopsActual.size()>0){
            update updateOopsActual;
        }
    
    }
      // ListActualApprovals(); 
         return null;
    }
    /******************
    ** Added on 12th Sept, 2014 
    ** Purpose : on Clicking on save
    *****************/
    public PageReference save(){    
        
        system.debug('** selectedQuarter ::'+selectedQuarter);
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
            update updateOopsActual;
        }
        return null;
    }
}