/***************************************************************
    Name: UL_AddNewCustomer()
    Copyright © 2015 Salesforce
    ======================================================
    Purpose:
    Utility methods to retrieve and calculate KPIs.
    ======================================================
    History
    -------
    VERSION     AUTHOR               DATE              DETAIL            Description
    1.0         Chandrababu Naidu    10/12/2016        INITIAL DEV       
    ***************************************************************/
    public without sharing class UL_ThresholdEngine {
    public static boolean enableThresholdPopup{get;set;}
    public static Map<String,String> processAPIName;
    public static list<ThresholdCheckResult> thresholdcheck{get;set;}
    
    static final String CONTENT_TYPE = 'Content-Type';
    static final String PROMOTION_ID = 'promotionid';
    static final String MEASURE_CODES = 'measurecodes';
    static final String TRANSACTION_ID = 'txId';
    static Integer MAX_ROWS = 0;
    
    /*******************************************************************
    Purpose: Represent action results
    Version: 1.0
    Parameters: N/A
    Returns: N/A
    Throws N/A
    ********************************************************************/
    private enum RESULT{
        pass,
        fail,
        result
    }
    
    /*******************************************************************
    Purpose: Parameterized constructor to access current record.
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
    public UL_ThresholdEngine(ApexPages.StandardController ctr){
        enableThresholdPopup = UL_Utility.BOOLEAN_FALSE;
        thresholdcheck = new list<ThresholdCheckResult>();
        processAPIName = new Map<String,String>();
        ACCL__Promotion__c promoObj = (ACCL__Promotion__c)ctr.getrecord();
        MAX_ROWS = LIMITS.getLimitQueryRows()-LIMITS.getQueryRows();
        list<ACCL__Promotion__c> promoThreshold = [select UL_Threshold_Window_Result__c ,UL_Threshold_Result__c from ACCL__Promotion__c where id=:promoObj.id LIMIT:MAX_ROWS];
        
        if(promoThreshold[0].UL_Threshold_Window_Result__c!=null && promoThreshold[0].UL_Threshold_Window_Result__c.contains(RESULT.result.Name())){  
           thresholdcheck = (list<ThresholdCheckResult>)JSON.deserialize(promoThreshold[0].UL_Threshold_Window_Result__c,list<ThresholdCheckResult>.class);
           enableThresholdPopup = true;
        }
    }

    /*******************************************************************
    Purpose: Default constructor
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
    public UL_ThresholdEngine(){
        //Default constructor to avail object creation
    }
    
    /*******************************************************************
    Purpose: Call heroku webservise to retrieve KPIs
    Version: 1.0
    Parameters: String transaction id, Promotion id, Promotion mode
    Returns: String
    Throws N/A
    ********************************************************************/
    public static String getThresholdKPI(String txid, id promId, String mode){
        
        List<KpiValueDescriptor> result = new List<KpiValueDescriptor>();
        Map<String,Object> postParameters = new Map<String,Object>();
        postParameters.put(PROMOTION_ID, promId);
        postParameters.put(MEASURE_CODES, UL_Utility.KPI_REQUEST);

        HttpRequest req = new HttpRequest();
        String body = JSON.serialize(postParameters);

        req.setEndpoint(UL_Utility.END_POINT);
        req.setTimeout(UL_Utility.SERVICE_TIMEOUT );
        req.setHeader(UL_Utility.CONTENT_TYPE_TEXT, UL_Utility.CONTENT_TYPE );
        req.setMethod(UL_Utility.REQUEST_TYPE);
        req.setHeader(TRANSACTION_ID, txid);
        req.setBody(body);
        req.setCompressed(UL_Utility.BOOLEAN_TRUE);
        
        Integer jwtValidPeriod= 30;//Integer.valueOf(SystemSettingUtil.getSystemSetting(Constants.SYSTEM_SETTING_JWT_EXPIRATION_TIME, txId, Constants.DEFAULT_JWT_EXPIRATION_TIME));
        
        req = JWT.addJwtTokenToHttpHeader(req,UL_Utility.TOKEN_URL, jwtValidPeriod  ); 
        HttpResponse res;
        try {
            Http http = new Http();
            res = http.send(req);
            String responseResult = res.getBody();
            
            List<Object> result2 = (List<Object>)JSON.deserializeUntyped(responseResult);
            For(Object o : result2) {
                Map<String,Object> temp = (Map<String,Object>) o;
                KpiValueDescriptor kpi = new KpiValueDescriptor((Id)temp.get('id'), String.valueOf(temp.get('kpiId')), String.valueOf(temp.get('level')), Double.valueOf(temp.get('value')));
                result.add(kpi);
                
            }
            
        } catch(System.CalloutException e) {
            UL_Utility.logError(e, UserInfo.getUserId());
        }
        
        return calculateThresholdViolate(result,promid,mode);
    }
    
    /*******************************************************************
    Purpose: Validates promotion KPIs
    Version: 1.0
    Parameters: List of KPIs, Promotion id, Promotion mode
    Returns: String
    Throws N/A
    ********************************************************************/
    public static string calculateThresholdViolate(List<KpiValueDescriptor> herokuPromKPI, id promId, String mode){
        id apprFuncRet = null;
        String thresholdStatus = UL_Utility.EMPTY_STRING;
        thresholdcheck = new list<ThresholdCheckResult>();
        enableThresholdPopup = UL_Utility.BOOLEAN_FALSE;
        boolean thresholdPass;
        boolean thresholdviolate = UL_Utility.BOOLEAN_FALSE;
        
        String approvalProcess=UL_Utility.EMPTY_STRING;
        Map<String, Double> promoKPIValueMap = new Map<String, Double>();
        MAX_ROWS = LIMITS.getLimitQueryRows()-LIMITS.getQueryRows();
        list<ACCL__Promotion__c> promotionList = [select id,UL_Account__c,ACCL__Promotion_Template__c from ACCL__Promotion__c where id=:promId LIMIT :MAX_ROWS];
        set<id> workflowThreIds = new set<id>();
        
        MAX_ROWS = LIMITS.getLimitQueryRows()-LIMITS.getQueryRows();
        for(UL_Workflow_Threshold__c WTids : [select id,UL_ApprovalProcess__c from UL_Workflow_Threshold__c where UL_Promotion_Template__c=:promotionList[0].ACCL__Promotion_Template__c and UL_Workflow_Threshold_Template__c in (select id from UL_Workflow_Threshold_Template__c where UL_Active__c=true) LIMIT:MAX_ROWS]){
           approvalProcess = WTids.UL_ApprovalProcess__c;
           workflowThreIds.add(WTids.id); 
        }
        
        if(!herokuPromKPI.isEmpty()){
            for(KpiValueDescriptor promoKPI : herokuPromKPI){
               promoKPIValueMap.put(promoKPI.kpiId, promoKPI.value);
            }
        }
        
        MAX_ROWS = LIMITS.getLimitQueryRows()-LIMITS.getQueryRows();
        if(!workflowThreIds.isEmpty() && !promoKPIValueMap.keySet().isempty()){
            for(UL_Comparator__c compRec : [select id,UL_Compare_Value__c, UL_Comparison_Type__c,UL_Threshold_Parameter__c,UL_Threshold_KPI__c,UL_User_Role__c,UL_Workflow_Threshold__c,UL_Workflow_Threshold_Template__c from UL_Comparator__c where UL_Workflow_Threshold__c in :workflowThreIds LIMIT :MAX_ROWS]){
                if(promoKPIValueMap.containsKey(compRec.UL_Threshold_Parameter__c)){
                    ThresholdCheckResult threcheck = new ThresholdCheckResult();
                    String thresholdResult=UL_Utility.EMPTY_STRING;
                    if(compRec.UL_Comparison_Type__c.equalsIgnoreCase(UL_Utility.COMPARE_LESS_THEN)){
                       if(promoKPIValueMap.get(compRec.UL_Threshold_Parameter__c) == UL_Utility.NULL_DOUBLE){
                        promoKPIValueMap.put(compRec.UL_Threshold_Parameter__c,0);
                       }
                      thresholdPass =  promoKPIValueMap.get(compRec.UL_Threshold_Parameter__c) < compRec.UL_Compare_Value__c;
                        thresholdResult = (thresholdPass)? RESULT.pass.Name() : RESULT.fail.Name() ;
                    }
                    if(compRec.UL_Comparison_Type__c.equalsIgnoreCase(UL_Utility.COMPARE_GREATER_THEN)){
                      if(promoKPIValueMap.get(compRec.UL_Threshold_Parameter__c)==UL_Utility.NULL_DOUBLE){
                        promoKPIValueMap.put(compRec.UL_Threshold_Parameter__c,0);
                       }
                       thresholdPass =  promoKPIValueMap.get(compRec.UL_Threshold_Parameter__c) > compRec.UL_Compare_Value__c;
                        thresholdResult = (thresholdPass)? RESULT.pass.Name() : RESULT.fail.Name();
                    }
                    if(compRec.UL_Comparison_Type__c.equalsIgnoreCase(UL_Utility.COMPARE_NOT_EQUAL )){
                       if(promoKPIValueMap.get(compRec.UL_Threshold_Parameter__c)==UL_Utility.NULL_DOUBLE){
                        promoKPIValueMap.put(compRec.UL_Threshold_Parameter__c,0);
                       }
                       thresholdPass =  promoKPIValueMap.get(compRec.UL_Threshold_Parameter__c) <> compRec.UL_Compare_Value__c;
                        thresholdResult = (thresholdPass)? RESULT.pass.Name() : RESULT.fail.Name() ;
                    }
                    if(compRec.UL_Comparison_Type__c.equalsIgnoreCase(UL_Utility.COMPARE_EQUALS)){
                        if(promoKPIValueMap.get(compRec.UL_Threshold_Parameter__c)==UL_Utility.NULL_DOUBLE){
                        promoKPIValueMap.put(compRec.UL_Threshold_Parameter__c,0);
                       }
                        thresholdPass =  promoKPIValueMap.get(compRec.UL_Threshold_Parameter__c) == compRec.UL_Compare_Value__c;
                        thresholdResult = (thresholdPass)? RESULT.pass.Name() : RESULT.fail.Name();
                    }
                    threcheck.result = thresholdResult;
                    threcheck.userRole = compRec.UL_User_Role__c;
                    threcheck.thresholdKPI = compRec.UL_Threshold_Parameter__c;
                    threcheck.compareValue = compRec.UL_Compare_Value__c;
                    threcheck.compareType = compRec.UL_Comparison_Type__c;
                    threcheck.promotionValue = promoKPIValueMap.get(compRec.UL_Threshold_Parameter__c);
                    thresholdcheck.add(threcheck);
                }
            }    
        }
        if(!thresholdcheck.isEmpty()){
        String thresholdRes = UL_Utility.EMPTY_STRING;
            for(ThresholdCheckResult res : thresholdcheck){
                thresholdRes+= JSON.serialize(res)+ UL_Utility.NEWLINE_CHAR;
                if(res.result==RESULT.fail.Name()){
                
                   thresholdviolate = true;
                    break;
                }
            }
            if(mode.equalsIgnoreCase(UL_Utility.STATUS_SUBMIT.tolowerCase())){
                ACCL__Promotion__c promobj = new ACCL__Promotion__c();
                promobj.id = promId;
                promobj.UL_Threshold_Result__c = thresholdRes;
                promobj.UL_Threshold_Window_Result__c = JSON.serialize(thresholdcheck);
                
               try{
                    Database.update(promobj);
                }
                catch(Exception ex){
                  throw new UL_CustomException('Error while promotion save-'+ex.getmessage());
                  UL_Utility.logError(ex, UserInfo.getUserId());
                } 
            }
        }
        
        if(thresholdviolate && !workflowThreIds.isEmpty() && !promoKPIValueMap.keySet().isempty() && mode.equalsIgnoreCase(UL_Utility.STATUS_SUBMIT.toUpperCase())){
        //call for only submittion
            submitForApproval(promId,approvalProcess );
            thresholdStatus = UL_Utility.STATUS_SUBMITED.toLowerCase();
        }
        else if(!thresholdviolate && !workflowThreIds.isEmpty() && !promoKPIValueMap.keySet().isempty() && mode.equalsIgnoreCase(UL_Utility.STATUS_SUBMIT.toUpperCase())){
        //call for submittion and approve automatically
            submitForApproval(promId,approvalProcess );
            do{ 
               // apprFuncRet = UL_PromotionWorkflowService.approveWorkflow(promId,'threshold') ; 
                thresholdStatus = UL_Utility.STATUS_APPROVED;
              } while(apprFuncRet != null);
        }
        
      
       return thresholdStatus; 
    }
    
    /***************************************************************
    Name: ThresholdCheckResult
    Copyright © 2016 Accnture
    ======================================================
    Purpose:
    Wrapper class
    ======================================================
    History
    -------
    VERSION     AUTHOR               DATE              DETAIL            Description
    1.0         Chandrababu Naidu    10/12/2016        INITIAL DEV       
    ***************************************************************/
    public without sharing class ThresholdCheckResult{
        public String result{get;set;}
        public String thresholdKPI{get;set;}
        public Double compareValue{get;set;}
        public String compareType{get;set;}
        public Double promotionValue{get;set;}
        public String userRole{get;set;}
    }
    
    /*******************************************************************
    Purpose: Handles Ok button on threshold popup window
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
    public void okButton(){
        try{
            enableThresholdPopup = UL_Utility.BOOLEAN_FALSE;
        }catch(Exception Ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
    
    /*******************************************************************
    Purpose: Default constructor
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
    public void checkPopuptest(){
        
        //return enableThresholdPopup1;
    }
    
    /*******************************************************************
    Purpose: Handles approval process submit event
    Version: 1.0
    Parameters: Promotion Id, Approval process name
    Returns: Void
    Throws N/A
    ********************************************************************/
    public static void submitForApproval(id promid, String approvalProcess){
        processAPIName = new map<String,String>();
        
        MAX_ROWS = LIMITS.getLimitQueryRows()-LIMITS.getQueryRows();
        for(processDefinition PD : [SELECT Name,DeveloperName FROM ProcessDefinition where state=:UL_Utility.STATUS_ACTIVE and TableEnumOrId= :UL_Utility.MANAGEDPACKAGE_NAMESPACE + 'Promotion__c' LIMIT :MAX_ROWS]){
            processAPIName.put(PD.Name,PD.DeveloperName);
        }

        // Create an approval request for the account
        Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
        submitRequest.setComments('Submitting request for approval.');
        submitRequest.setObjectId(promid);              
        // Submit on behalf of a specific submitter
        submitRequest.setSubmitterId(UserInfo.getUserId());              
        // Submit the record to specific process and skip the criteria evaluation
        submitRequest.setProcessDefinitionNameOrId(processAPIName.get(approvalProcess));
                
         try{
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(submitRequest);  
            //UL_PromotionWorkflowService.unlockPromotion( promId) ;
            // Verify the result
            System.assert(result.isSuccess());
         }
        catch(Exception ex){
            throw new UL_CustomException(System.Label.UL_PROMOTION_LOCKEDOUT);
            UL_Utility.logError(ex, UserInfo.getUserId());
        } 
    }
}