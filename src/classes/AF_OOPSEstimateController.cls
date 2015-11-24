public with sharing class AF_OOPSEstimateController {
    
    public String oopsEstimateId;
    public AF_OOPS_Estimate__c oopsEstimate {get;set;}
    public user loggedinuser{set;get;}
    public boolean Buttondisplay{set;get;}
    Public Boolean IsReadyforPO{get;set;}
    public decimal EsLocal{get;set;}
    public boolean isPOEditable{get;set;}
    public Boolean IsReadonlyPO{get;set;}
    public Boolean IsShowPOTab{get;set;}
    public boolean isOopsEditable{get;set;}
    public AF_OOPS_Estimate__c polist{get;set;}
    public Boolean bConfirmBox{get;set;}
    public decimal overrideEstimate{get;set;}
    public String overridePONumber{get;set;}
    public Boolean isCMCOSuperUser{get;set;}
    Public String oopsQuarter;
    public Boolean POOverrideDisplay1{get;set;}
     public String OppsEstimatesValue{     
        get{String result = '';if(oopsEstimate.AF_Estimate__c!= null){if(oopsEstimate.AF_Estimate__c > 0) {result = oopsEstimate.AF_Estimate__c.format();}else{result ='';}}return result;}
        set{/*System.debug('TraditionalDisplay: ' + value);*/value = CommaFilter(value);System.debug('oopsEstimate.AF_Estimate__c: ' + value);if(value != ''){oopsEstimate.AF_Estimate__c = Decimal.valueOf(value);}else{oopsEstimate.AF_Estimate__c = 0.00;}}
    }
    
    public AF_OOPSEstimateController(){
        IsReadyforPO=false;
        isPOEditable=false;
        IsShowPOTab=false;
        IsReadonlyPO=false;
        Buttondisplay=false;
        bConfirmBox = false;
        isCMCOSuperUser = false;
        POOverrideDisplay1 = false;
        oopsQuarter='';
        oopsEstimateId = System.currentPageReference().getParameters().get('id');
        system.debug('oopsEstimateId...'+oopsEstimateId);
        oopsEstimate = [Select a.AF_PO_Number__c,a.AF_OOPS_Actual__r.Quarter__c,a.AF_OOPS_Matrix_Currency_Code__c, a.Name, a.AF_isComment__c,AF_EstimateLocal__c,AF_OOPS_Actual__r.AF_Status__c, a.Unilever_Entity_Name__c,a.AF_Unilever_Entity__c, a.AF_Unilever_Entity_Column_Name__c, a.AF_Status__c, a.AF_Rate_Type__c, a.AF_Rate_Currency__c, a.AF_Quarter__c, a.AF_Overall_OOPS__c, a.AF_OOPS_Actual__c, a.AF_Locked__c, a.AF_Is_Crossborder_Wk__c, a.AF_IsCrossBorder__c, a.AF_Fiscal_Year__c, a.AF_Estimate__c, a.AF_Estimate_Local__c, a.AF_Brand_Estimate__c, a.AF_Archived__c, a.AF_Agreed_Base_Fees__c, a.AF_Agency_Spot_Rate__c, a.AF_Agency_Exchange_Rate__c, a.AF_Agency_Entity__c, a.AF_Agency_Entity_Column_Name__c, a.AF_Agency_Account__c,a.Agency_Entity_Name__c,AF_Ready_For_PO_Exchange_Rate__c From AF_OOPS_Estimate__c a  where Id=: oopsEstimateId];        
        //oopsAgencyEntity = oopsEstimate.AF_Agency_Entity__c; 
       
        polist=[Select o.id,o.name,o.AF_PO_Number__c,AF_Override_Estimate_Local__c from AF_OOPS_Estimate__c o where Id=: oopsEstimateId];
        if(polist!=null){
        overrideEstimate = polist.AF_Override_Estimate_Local__c;
        overridePONumber= polist.AF_PO_Number__c;
        }
        LoggedinUser=[select id,IsActive,Username,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c,profile.name  from  User  where id=:Userinfo.getuserid()   and IsActive=true  Order by CreatedDate Limit 50000];             
        if(LoggedinUser.AF_Agency_Fees_User_Type__c!=null){
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Controller' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Regional Category Finance'){
                isPOEditable=true;
            }
             if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance' ){
                isOopsEditable=true;
            }
           if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Procurement'  || LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency'){
            IsReadonlyPO=true;
               }
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance'|| LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Procurement' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Controller' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Regional Category Finance' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency' ){
            IsShowPOTab=true;
               }  
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User'){
                isCMCOSuperUser = true;
            }
        }
        if(oopsEstimate.AF_Estimate__c != null){oopsEstimate.AF_Estimate__c = oopsEstimate.AF_Estimate__c;oopsEstimate.AF_Estimate__c = oopsEstimate.AF_Estimate__c.setscale(2);}      
        EsLocal= oopsEstimate.AF_EstimateLocal__c;
        if(oopsEstimate.AF_OOPS_Actual__r.AF_Status__c=='with agency' && LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance')
        {
            Buttondisplay=true;
        }
        Else if(oopsEstimate.AF_OOPS_Actual__r.AF_Status__c=='with category finance' && LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency')
        {
            Buttondisplay=true;
        }
        Else
        {
            Buttondisplay=false;
        }
        if(oopsEstimate.AF_Status__c=='Ready for PO'){
          IsReadyforPO=true;
        }
        system.debug('oopsEstimate.AF_OOPS_Actual__r.Quarter__c...'+oopsEstimate.AF_OOPS_Actual__r.Quarter__c);
        if(oopsEstimate.AF_OOPS_Actual__r.Quarter__c!=null){
                    oopsQuarter = oopsEstimate.AF_OOPS_Actual__r.Quarter__c;
                    system.debug('oopsQuarter...'+oopsQuarter);
                    if(!oopsQuarter.contains('Q4')){
                        POOverrideDisplay1 = true;
                        system.debug('POOverrideDisplay1...'+POOverrideDisplay1);
                    }
                }
        
    }
  
    public PageReference Save()
    {        
        PageReference pageRef;                         
        try
        {
    
            if(oopsEstimate.AF_Estimate__c != null){
             OppsEstimatesValue=OppsEstimatesValue.Remove(',');
           // oopsEstimate.AF_Estimate__c =OppsEstimatesValue.Remove(',');
           // oopsEstimate.AF_Estimate__c=decimal.valueof(OppsEstimatesValue);
            oopsEstimate.AF_Estimate__c = oopsEstimate.AF_Estimate__c;
            oopsEstimate.AF_Estimate__c = oopsEstimate.AF_Estimate__c.setscale(2);}
            
            system.debug('Saving record...');
            system.debug('oopsEstimateValue: ' + oopsEstimate.AF_Estimate__c);          
            AF_RecursiveTriggerHelper.setAlreadyModified();
            oopsEstimate.IsUpdate__c = true;   
            //oopsEstimate.AF_EstimateLocal__c=String.valueof(EsLocal);                     
            update oopsEstimate;
            CalculateLocalC();
            apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved'));  
            system.debug('Saved record...');           
           // pageRef = new PageReference('/apex/AF_CloseAndRefresh?IsError=false');  
           // pageRef.setRedirect(true); 
        }
        catch(DMLException ex)
        {
            System.debug('Exception: ' + ex);
            //ApexPages.addMessages(ex);
           // pageRef = new PageReference('/apex/AF_CloseAndRefresh?IsError=true');
           // pageRef.setRedirect(true);             
        }
        
       // return pageRef;
       return null;
    }
    private string CommaFilter(string value)
    {
        if(value.contains(',') == true){value = value.replaceAll(',','');}
        return value;       
    } 
    
    public void CalculateLocalC(){
        try{
        String oopsvalue=OppsEstimatesValue.Remove(',');
        EsLocal=Decimal.valueof(oopsvalue)*oopsEstimate.AF_Agency_Exchange_Rate__c;
        }
        Catch(exception e){
         if(OppsEstimatesValue==''){
         EsLocal=null;
         }
        }
       
       // oopsEstimate.AF_EstimateLocal__c=String.valueof(EsLocal);
        
    } 
    
   Public void SavePO(){
       if(polist.AF_PO_Number__c != null){
       system.debug('overrideEstimate...'+overrideEstimate);
       system.debug('polist.AF_Override_Estimate_Local__c...'+polist.AF_Override_Estimate_Local__c);
        if(overrideEstimate != polist.AF_Override_Estimate_Local__c)
             polist.AF_Override_Estimate_Local__c = overrideEstimate;
       update polist;
       system.debug('polist...');
       overridePONumber = polist.AF_PO_Number__c;
       apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved')); 
        }      
   } 
   public void confirmBox(){
    bConfirmBox = true;
    }
    public void closePopupReject(){
    bConfirmBox = false;
    }
   public void OverridePO(){
    bConfirmBox = false;
    if(overridePONumber != polist.AF_PO_Number__c)
        polist.AF_PO_Number__c = overridePONumber;
    if(polist.AF_Override_Estimate_Local__c > EsLocal){
        apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'You cannot enter amount greater than local value')); 
    }
    else{
    update polist;
    overrideEstimate = polist.AF_Override_Estimate_Local__c;
    apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved'));
    }   
   }
}