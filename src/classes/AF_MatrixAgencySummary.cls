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
    public AF_MatrixAgencySummary(ApexPages.StandardController controller) {
      
      call_constructor();
      AF_ApproveActualsCtrl actConst = new AF_ApproveActualsCtrl();
      ytgValue = actConst.getTotalSum();
        if(ytgValue > oopsActObj.AF_OOPS_Estimate__c)
      {ytgColour='red';}else{ytgColour='black';}
       
    }
    public void call_constructor(){
     OOpsActualId = ApexPages.currentPage().getParameters().get('Id');
        brandId = ApexPages.currentPage().getParameters().get('bId');
        agencyId = ApexPages.currentPage().getParameters().get('aId');
        fiscalYear = ApexPages.currentPage().getParameters().get('fy');
        system.debug('OOpsActualId..'+OOpsActualId);
        system.debug('brandId..'+brandId);
        system.debug('agencyId..'+agencyId);
        system.debug('fiscalYear..'+fiscalYear);
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
        tempOopsRecord = new AF_OOPS_Actual__c();
                                isCMCO = false;
                                isProcurement = false;
                                isController = false;
                                isFinanace = false;
        User userObj = new User();
        userObj = [Select id, AF_UserTypeText__c from User where id=:UserInfo.getUserId()];
        
        //check whether logged in User is Agency or CMCO User
        if(userObj.AF_UserTypeText__c=='Agency'){
            //if Agency User then make AgencyFlag true
            isAgencyFlag=true;
        }
        if(userObj.AF_UserTypeText__c=='CMCO Super User' || userObj.AF_UserTypeText__c=='Agency' ){
            //if Agency User then make AgencyFlag true
            ISCMCOSUAgency=true;
        }
                                
        if(userObj.AF_UserTypeText__c=='Category Finance'|| userObj.AF_UserTypeText__c=='CMCO Super User'){
            isFinanace = true;
        }
      
         system.debug('++++++'+userObj.AF_UserTypeText__c);
         system.debug('++++++'+ISCMCOSUAgency);
         
      /**  brandEstimates=new AF_Brand_Estimate__c();
        brandEstimates=[Select id,name,AF_AgencyBaseFees__c from AF_Brand_Estimate__c where Brand__c=:brandId and AF_Agency__c=:agencyId and AF_Fiscal_Year__c=:fiscalYear and AF_Active__c=true limit 1];
      **/
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
       // oopsActListObj = [SELECT  Id,AF_iS_OOPS_Percentage__c,AF_Status__c,Quarter__c,AF_Q1_Approval_Status__c,AF_Q2_Approval_Status__c,AF_Q3_Approval_Status__c,AF_Q4_Approval_Status__c,Total_Crossborder__c,Total_Base_Fee__c,AF_OOPS_Estimate__c,AF_No_Of_CrossBorder__c,Overall__c,AF_Agency_lk__r.Name,AF_Brand__c,AF_Brand__r.name,AF_Q1__c,AF_Q2__c,AF_Q3__c,AF_Q4__c FROM AF_OOPS_Actual__c WHERE id=:OOpsActualId];
        system.debug('oopsActListObj...'+oopsActListObj);
        lst_OOPS_Estimate=[Select name,AF_Status__c from AF_OOPS_Estimate__c where AF_OOPS_Actual__r.id=:OOpsActualId];
        if(lst_OOPS_Estimate[0].AF_Status__c =='Ready For PO'){
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
                system.debug('oopsActObj...'+oopsActObj);           
                }
        }
        
        
         
        for(AF_OOPS_Actual__c oops:oopsActListObj){
            String quarterValue = oops.Quarter__c;
            if(quarterValue!=null){
                if(quarterValue.contains('Q1')){
                  //  if(oops.AF_Q1__c!=null){
                    tempOopsRecord.AF_Q1__c = oops.AF_Q1__c;
                    tempOopsRecord.AF_Q1_Approval_Status__c = oops.AF_Q1_Approval_Status__c;
                   // }
                }
                if(quarterValue.contains('Q2')){
                    //if(oops.AF_Q2__c!=null){
                    tempOopsRecord.AF_Q2__c = oops.AF_Q2__c;
                    tempOopsRecord.AF_Q2_Approval_Status__c = oops.AF_Q2_Approval_Status__c;
                   // }
                }
                if(quarterValue.contains('Q3')){
                   // if(oops.AF_Q3__c!=0){
                    tempOopsRecord.AF_Q3__c = oops.AF_Q3__c;
                    tempOopsRecord.AF_Q3_Approval_Status__c=oops.AF_Q3_Approval_Status__c;
                   // }
                }
                if(quarterValue.contains('Q4')){
                  //  if(oops.AF_Q4__c!=0){
                    tempOopsRecord.AF_Q4__c = oops.AF_Q4__c;
                    tempOopsRecord.AF_Q4_Approval_Status__c = oops.AF_Q4_Approval_Status__c;
                   // }
                }
            }
        }
        
        system.debug('Q1..'+tempOopsRecord.AF_Q1__c);
        system.debug('Q1ApprovalStatus..'+tempOopsRecord.AF_Q1_Approval_Status__c);
        system.debug('Q2..'+tempOopsRecord.AF_Q2__c);
        system.debug('Q2ApprovalStatus..'+tempOopsRecord.AF_Q2_Approval_Status__c);
        system.debug('Q3..'+tempOopsRecord.AF_Q3__c);
        system.debug('Q3ApprovalStatus..'+tempOopsRecord.AF_Q3_Approval_Status__c);
        system.debug('Q4..'+tempOopsRecord.AF_Q4__c);
        system.debug('Q4ApprovalStatus..'+tempOopsRecord.AF_Q4_Approval_Status__c);
        
    
    }
    
    public pagereference backToHomePage(){
        return null;
    }
              
    public pagereference backToChatter(){
        return null;
    }
              
    //to save entered values in OOPS Actual
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
                msg = 'Successfully Refreshed';
            }else {
                msg = 'Successfully Refreshed, There are entities in the OOPS matrix that do not exist in the base fee.';
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
        }catch(DMLException dml){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.fatal,dml.getMessage()));
        }
     }
     
     //to submit data
     public pagereference submit(){
        
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
        set<String> oopsEstimateStatusUpdate = new set<String>();
        system.debug('inside submit1');
        for(AF_OOPS_Actual__c oops:oopsActListObj){
        integer i=0;
        system.debug('inside submit2');
            String quarterValue = oops.Quarter__c;
            if(quarterValue!=null){
            if(quarterValue.contains('Q1') && tempOopsRecord.AF_Q1__c!=oops.AF_Q1__c && tempOopsRecord.AF_Q1__c!=0 && tempOopsRecord.AF_Q1__c!=null){
                oops.AF_Q1__c = tempOopsRecord.AF_Q1__c ;
                oops.AF_Status__c='With Category Finance';
                oopsEstimateStatusUpdate.add(oops.Id);
                system.debug('tempOopsRecord.AF_Q1__c.....'+tempOopsRecord.AF_Q1__c);
                i++;
            }
            if(quarterValue.contains('Q2') && tempOopsRecord.AF_Q2__c!=oops.AF_Q2__c && tempOopsRecord.AF_Q2__c!=0 && tempOopsRecord.AF_Q2__c!=null){
                oops.AF_Q2__c = tempOopsRecord.AF_Q2__c ;
                oops.AF_Status__c='With Category Finance';
                oopsEstimateStatusUpdate.add(oops.Id);
                i++;
            }
            if(quarterValue.contains('Q3') && tempOopsRecord.AF_Q3__c!=oops.AF_Q3__c && tempOopsRecord.AF_Q3__c!=0 && tempOopsRecord.AF_Q3__c!=null){
                oops.AF_Q3__c = tempOopsRecord.AF_Q3__c ;
                oops.AF_Status__c='With Category Finance';
                oopsEstimateStatusUpdate.add(oops.Id);
                i++;
            }
            if(quarterValue.contains('Q4') && tempOopsRecord.AF_Q4__c!=oops.AF_Q4__c && tempOopsRecord.AF_Q4__c!=0 && tempOopsRecord.AF_Q4__c!=null){
                oops.AF_Q4__c = tempOopsRecord.AF_Q4__c ;
                oops.AF_Status__c='With Category Finance';
                oopsEstimateStatusUpdate.add(oops.Id);
                i++;
            }
            
            if(i>0){
            updateOopsActual.add(oops);
            }
            }
        }
        system.debug('updateOopsActual....'+updateOopsActual);
        system.debug('oopsEstimateStatusUpdate...'+oopsEstimateStatusUpdate);
        list<AF_OOPS_Estimate__c> submit_OOPS_Estimate = new list<AF_OOPS_Estimate__c>();
         submit_OOPS_Estimate=[Select name,AF_Status__c from AF_OOPS_Estimate__c where AF_OOPS_Actual__r.id IN :oopsEstimateStatusUpdate];
         system.debug('submit_OOPS_Estimate...'+submit_OOPS_Estimate);
            list<AF_OOPS_Estimate__c>updatedopps_est=new list<AF_OOPS_Estimate__c>();
            for(AF_OOPS_Estimate__c oops_est:submit_OOPS_Estimate){
                oops_est.AF_Status__c ='Ready for PO';
                updatedopps_est.add(oops_est);
            }
        system.debug('updateOopsActual...'+updateOopsActual);
        if(updateOopsActual.size()>0){
            try{
            update updateOopsActual;
            update updatedopps_est;
            }
            catch(Exception e){
            system.debug(e);
            }
         }
         
       
        // pagereference pf = new pagereference(Apexpages.currentpage().getUrl());
         //pf.setredirect(true);
        //return pf;
        
        return null;
    }
    
     public pagereference grApprove(){
     Boolean isAllApproved=false;
     List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
         for(AF_OOPS_Actual__c oops:oopsActListObj){
            
            String quarterValue = oops.Quarter__c;
            
            if(quarterValue!=null){
           
            if(quarterValue.contains('Q1')){
                if(q1Flag){
                    oops.AF_Q1_Approval_Status__c='Approved';
                    oops.AF_Status__c='Ready For PO';
                }
            }
            if(quarterValue.contains('Q2')){
                if(q2Flag){
                    oops.AF_Q2_Approval_Status__c='Approved';
                    oops.AF_Status__c='Ready For PO';
                }
            }
            if(quarterValue.contains('Q3')){
                if(q3Flag){
                    oops.AF_Q3_Approval_Status__c='Approved';
                    oops.AF_Status__c='Ready For PO';
                }
            }
            if(quarterValue.contains('Q4')){
                if(q4Flag){
                    oops.AF_Q4_Approval_Status__c='Approved';
                    oops.AF_Status__c='Ready For PO';
                }
            }
           
          
             
            
            updateOopsActual.add(oops);
            }
         }
         system.debug('updateOopsActual...'+updateOopsActual);
         if(updateOopsActual.size()>0){
            update updateOopsActual;
         }
        // pagereference pf = new pagereference(Apexpages.currentpage().getUrl());
        // pf.setredirect(true);
        // return pf;
          return null;
    }
    
     public pagereference grReject(){
        List<AF_OOPS_Actual__c> updateOopsActual = new List<AF_OOPS_Actual__c>();
         for(AF_OOPS_Actual__c oops:oopsActListObj){
            String quarterValue = oops.Quarter__c;
            if(quarterValue!=null){
            if(quarterValue.contains('Q1')){
                if(q1Flag){
                    oops.AF_Q1_Approval_Status__c='Rejected';
                    oops.AF_Status__c='With Agency';
                }
            }
            if(quarterValue.contains('Q2')){
                if(q2Flag){
                    oops.AF_Q2_Approval_Status__c='Rejected';
                    oops.AF_Status__c='With Agency';
                }
            }
            if(quarterValue.contains('Q3')){
                if(q3Flag){
                    oops.AF_Q3_Approval_Status__c='Rejected';
                    oops.AF_Status__c='With Agency';
                }
            }
            if(quarterValue.contains('Q4')){
                if(q4Flag){
                    oops.AF_Q4_Approval_Status__c='Rejected';
                    oops.AF_Status__c='With Agency';
                }
            }
            
            updateOopsActual.add(oops);
            }
         }
         system.debug('updateOopsActual...'+updateOopsActual);
         if(updateOopsActual.size()>0){
            update updateOopsActual;
         }
        // pagereference pf = new pagereference(Apexpages.currentpage().getUrl());
         //pf.setredirect(true);
         //return pf;
         return null;
    }
    
   public void SubmitOverall(){
         try{
            list<AF_OOPS_Estimate__c>updatedopps_est=new list<AF_OOPS_Estimate__c>();
            for(AF_OOPS_Estimate__c oops_est:lst_OOPS_Estimate){
                oops_est.AF_Status__c ='Ready For PO';
                updatedopps_est.add(oops_est);
            }
            system.debug('quarterOops....'+quarterOops);
            for(String s:quarterOops){
            if(s=='Q1'){
            oopsActObj.AF_Status_Q1__c='With Agency';
            }
            if(s=='Q2'){
            oopsActObj.AF_Status_Q2__c='With Agency';
            }
            if(s=='Q3'){
            oopsActObj.AF_Status_Q3__c='With Agency';
            }
            if(s=='Q4'){
            oopsActObj.AF_Status_Q4__c='With Agency';
            }
            }
            oopsActObj.AF_iS_OOPS_Percentage__c=True;
            oopsActObj.AF_Status__c='With Agency';
            update oopsActObj;
            update updatedopps_est;
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Records successfully submitted'));
        }catch(DMLException dml){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.fatal,dml.getMessage()));
        }
     } 
    
}