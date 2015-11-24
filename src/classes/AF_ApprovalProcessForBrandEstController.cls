public Class AF_ApprovalProcessForBrandEstController
{
    public String brandEstimateId {get;set;}
    public String ParentId {get;set;}
    public String brandvalue1{get;set;}
    public String catageory1{get;set;}
    public String year1{get;set;}
    public String ParentRecordType {get;set;}
    Public Boolean Controllerflag{set;get;}
    public Boolean hasProcess {get; set;}
    public List<ProcessInstance> process {get; set;}
    public list<ProcessInstance> Targetprocess{set;get;}
    public List<ProcessInstanceHistory> stepOrWorkItem{get; set;}
    public Boolean hasStep {get; set;}
    Public user LoggedinUser{set;get;}
    Public AF_Brand_Estimate__c BrandEstRecord{set;get;}
    Public list<ProcessInstanceWorkitem> workItem=new list<ProcessInstanceWorkitem>();
    Public id workItemId{set;get;}
    public id NextActorid{set;get;}
    public set<id> Actoridset=new set<id>();
    Public string StatusofBrand{set;get;}
    public list<AF_Agency_Estimate__c>lstofAgencyEst=new list<AF_Agency_Estimate__c>();
    public boolean displayPopup {get; set;}
    public boolean displayPopupRej{set;get;}
    public boolean displayPopupRejComment{set;get;}
    public string RejectComment{set;get;}
    public string ApproveComment{set;get;}
    public boolean ButtonsDisplay{set;get;}
    public boolean Controllerflag1{set;get;}
    public boolean ApprovalButton{set;get;}
    Public boolean IsCatFinanceEdited{get;set;}
    Public boolean isAgency{get;set;}
    public void RejectBrandEstComment()
    {
        displayPopupRejComment=true;
    }
    
    public pagereference RejectBrandWithComments()
    {
        pagereference ref;
        try{
        if(RejectComment==''){
        ref=null;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the comments'));
        }
        else if(Actoridset.size()>0)
            {
                
                if(Actoridset.contains(Userinfo.getuserid()))
                {
               
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setComments(RejectComment); //RejectComment
                    req.setAction('Reject');                    
                    req.setWorkitemId(workItemId);
                    // Submit the request for approval
                    Approval.ProcessResult result =  Approval.process(req);
                    //system.debug('@@@ Rejection Result='+result);
                    
                    AF_Comments__c AfC=new AF_Comments__c();
                    AfC.AF_Brand_Estimate__c=brandEstimateId;
                    AfC.AF_Comments__c=RejectComment;
                    AfC.AF_Parent_Record_Id__c=brandEstimateId;
                    AfC.AF_Public__c=true;
                    AfC.AF_Parent_Object_Type__c='AF_Brand_Estimate__c';
                    insert AfC;
                    
                    System.debug('@@@ Comments record inserted =='+AfC);
                    
                    TempConstructor();
                    displayPopupRejComment=false;
                    displayPopup=false;
                    displayPopUpRej=false;
                    Approvalpopup=false;
                    ref=new pagereference('/apex/AgencyHomePage?brandvalue='+brandvalue1+'category='+catageory1+'year='+year1);
                    ref.setRedirect(true);
                }
                else
                {
                    System.debug('@@@ Comments record not inserted ');
                    ref=null;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You are not allowed to Approve the record'));
                }
            }    
        }Catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            ref=null;
        }
        //return ref;
        
        return null;
    }
    
    public pagereference ApproveRecord()
    {
        pagereference ref;
        try{
            if(Actoridset.size()>0)
            {
                if(Actoridset.contains(Userinfo.getuserid()))
                {
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setComments(''); //ApproveComment
                    req.setAction('Approve');        
                    req.setWorkitemId(workItemId);
                    // Submit the request for approval
                    Approval.ProcessResult result =  Approval.process(req);
                    
                    /*if((LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance')) 
                    {
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Submitting request for approval automatically ');
                        req1.setObjectId(brandEstimateId);
                        Approval.ProcessResult result1 = Approval.process(req1);                     
                        
                    }*/
                    
                    TempConstructor();
                    displayPopupRejComment=false;
                    displayPopup=false;
                    displayPopUpRej=false;
                    Approvalpopup=false;
                    ref=new pagereference('/apex/AgencyHomePage?brandvalue='+brandvalue1+'category='+catageory1+'year='+year1);
                    ref.setRedirect(true);
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You are not allowed to Approve the record'));
                    ref=null;
                }
            }
           }catch(exception e)
           {
               ref=null;
           }
          //  return ref;
          return null;
    }
    
    public pagereference RejectRecord()
    {
        pagereference ref;
        try{
            if(Actoridset.size()>0)
            {
                if(Actoridset.contains(Userinfo.getuserid()))
                {
               
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setComments(''); //RejectComment
                    req.setAction('Reject');                    
                    req.setWorkitemId(workItemId);
                    // Submit the request for approval
                    Approval.ProcessResult result =  Approval.process(req);
                    //system.debug('@@@ Rejection Result='+result);
                    TempConstructor();
                    displayPopupRejComment=false;
                    displayPopup=false;
                    displayPopUpRej=false;
                    Approvalpopup=false;
                    ref=new pagereference('/apex/AgencyHomePage?brandvalue='+brandvalue1+'category='+catageory1+'year='+year1);
                    ref.setRedirect(true);
                }
                else
                {
                     ref=null;
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You are not allowed to Approve the record'));
                }
            }    
        }Catch(Exception e)
        {
            ref=null;
        }
       // return ref;
         return null;
    }
    
    Public void closePopupReject()
    {
        displayPopupRej=false;
    }
    public void closePopup() {
        displayPopup = false;
    }
    
    public void closePopupRejComment()
    {
        displayPopupRejComment=false;
    }
 
    public void showPopup() {
        displayPopup = true;
    }
    public AF_ApprovalProcessForBrandEstController() 
    {
        
        
        brandEstimateId = ApexPages.currentPage().getParameters().get('id');
        isAgency = false;
        LoggedinUser=[select id,IsActive,Username,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c  from  User  where id=:Userinfo.getuserid()   and IsActive=true  Order by CreatedDate Limit 50000];  
        TempConstructor();
         
    
    }
    
    Public Void TempConstructor()
    {
        IsCatFinanceEdited=false;
        if(brandEstimateId!=null && brandEstimateId!='')
        {    
            Targetprocess=[select Id, TargetObjectId, isDeleted, Status From ProcessInstance Where isDeleted = false and TargetObjectId =:brandEstimateId  and status='Pending' limit 1]; 
            System.debug('&&&&Targetprocess'+Targetprocess);
            BrandEstRecord=[select id,AF_Pilot_Model__c,AF_No_Bonus__c,AF_Basefee_Estimate_Initial_Quarter__c,AF_Category_Finance_Flag__c,Brand__c,AF_Fiscal_Year__c,AF_Category_Finance_Approved__c,AF_CMCO_Rejected__c,AF_Status_Base_Fees__c,AF_Agency__c,AF_Controller_Flag__c,ExceptionsComplete__c,AF_No_of_Central_Billing__c from AF_Brand_Estimate__c  where id=:brandEstimateId  limit 1 ];
           
            if(BrandEstRecord.AF_Category_Finance_Flag__c>0 && BrandEstRecord.AF_Status_Base_Fees__c=='With Agency' && LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency'){
                lstofAgencyEst=[select id,AF_Category_Finance_Flag__c from AF_Agency_Estimate__c where AF_Brand_Estimate__r.id=:brandEstimateId];
            }
            StatusofBrand=BrandEstRecord.AF_Status_Base_Fees__c;
            workItem  =[Select p.Id,P.ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: brandEstimateId  limit 50000];
            if(workItem.size()>0)
            for(ProcessInstanceWorkitem  pis:workItem)
            {
                workItemId=pis.id;
                Actoridset.add(pis.ActorId) ;
            }   
        }
        if(LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance' && BrandEstRecord.AF_Status_Base_Fees__c=='With Category Finance' &&  BrandEstRecord.AF_Category_Finance_Flag__c>0){
           IsCatFinanceEdited=true;
        }
        if(LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency'){
            isAgency = true;
        }
        if((BrandEstRecord.AF_Status_Base_Fees__c=='With Agency' && LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency') || 
           (BrandEstRecord.AF_Status_Base_Fees__c=='With CMCO' && LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO User'))
        {
            ApprovalButton=true;            
        }
        Else
        {
            ApprovalButton=false;
        }
        
        if(Actoridset.contains(LoggedinUser.id))
        {
            ButtonsDisplay=true;
        }
        Else
            ButtonsDisplay=false;
           /** list<AF_Controller_Review__c>lstreview=new list<AF_Controller_Review__c>();
            lstreview=[select id,name from AF_Controller_Review__c where Brand_Estimate__r.id=:brandEstimateId];
            system.debug('lstreview.....'+lstreview);
        if(lstreview.size()==0 && (BrandEstRecord.AF_Status_Base_Fees__c=='With CMCO' && LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO User')){
               Targetprocess=[select Id, TargetObjectId, isDeleted, Status From ProcessInstance Where isDeleted = false and TargetObjectId =:brandEstimateId  limit 1]; 
               system.debug('Targetprocess....'+Targetprocess);
               ButtonsDisplay=true;
            }**/
    }
    
    public boolean Approvalpopup{set;get;}
    
    public pagereference SubmitApprovalPopup()
    {
        /*if(BrandEstRecord.AF_Status_Base_Fees__c=='With Agency' && BrandEstRecord.ExceptionsComplete__c!=1&&BrandEstRecord.AF_No_of_Central_Billing__c >0)
        {
           // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check the country Breakdown percentage'));
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'Please indicate the country breakdown percentage within UK');
            apexpages.addmessage(msg); 
            return null;
        }
        Else*/
        // Check whether Country breakdown percentage value is exactly equal to 100, then only allow to Submit for approval else show an error message.
        /* Commented Out Martin O'connell - 12st September
        List<AF_Agency_Estimate__c> AgencyEstimates = new List<AF_Agency_Estimate__c>();
        Boolean ShowFlag = false;
        AgencyEstimates=[Select id,AF_Sum_of_Percent__c from AF_Agency_Estimate__c where AF_Brand_Estimate__r.id =:ParentId and Central_Billing__c=true];
        for(AF_Agency_Estimate__c AgncyEstms: AgencyEstimates)
        {
        
            if(AgncyEstms.AF_Sum_of_Percent__c <> 100)
            {
             ShowFlag=true;
             ApexPages.addMessage( new apexpages.message(apexpages.severity.error,'Country breakdown percentage value cannot less or more than 100 percent'));
            }
        }
        */
        AF_CountryBreakdownCheck mycheck = new AF_CountryBreakdownCheck();
        Boolean myresult = mycheck.CheckCountryBreakdown(ParentId);
        if((BrandEstRecord.AF_Status_Base_Fees__c=='With Agency' || BrandEstRecord.AF_Status_Base_Fees__c=='With Category Finance') && myresult )
        {
           // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check the country Breakdown percentage'));
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'Please indicate the country breakdown percentage within UK');
            apexpages.addmessage(msg); 
            return null;
        }
        Else
            Approvalpopup=true;
        return null;
        
        
        
        
           
        return null;
    }
     public pagereference Submit()
    {
        AF_CountryBreakdownCheck mycheck = new AF_CountryBreakdownCheck();
        Boolean myresult = mycheck.CheckCountryBreakdown(ParentId);
        if(BrandEstRecord.AF_Status_Base_Fees__c=='With Category Finance' && myresult )
        {
           // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check the country Breakdown percentage'));
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'Please indicate the country breakdown percentage within UK');
            apexpages.addmessage(msg); 
            return null;
        }
        
        AF_BonusRecordManager bonusRecordManager = new AF_BonusRecordManager();
        if(bonusRecordManager.BonusThresholdValidationCheck((BrandEstRecord))) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Bonus Thresholds are not created for all Unilever Entity Countries'));
            return null;
        }else{
         if(BrandEstRecord.AF_Category_Finance_Flag__c>0)
         {
         BrandEstRecord.AF_Status_Base_Fees__c='With Agency';
         update BrandEstRecord;
         list<AF_Controller_Review__c> ACR=new list<AF_Controller_Review__c>();
         for(AF_Controller_Review__c afc:[select id,Review_Completed__c from AF_Controller_Review__c where Brand_Estimate__c=:BrandEstRecord.id limit 50000])
         {
         afc.Review_Completed__c=false;
         ACR.add(afc);
         }
         if(ACR.size()>0)
         update ACR;
         }
         else if(BrandEstRecord.AF_Category_Finance_Flag__c==0)
         {
             BrandEstRecord.AF_Status_Base_Fees__c='With CMCO';
             update BrandEstRecord;
             Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval automatically ');
                req1.setObjectId(brandEstimateId);
                // Submit the approval request for the Brand Estimate
                System.debug('@@test'+brandEstimateId);
                Approval.ProcessResult result = Approval.process(req1);
               // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,'Submitted for approval By Yamuna just sample'));
                 TempConstructor();
                displayPopupRejComment=false;
                displayPopup=false;
                displayPopUpRej=false;
                Approvalpopup=false;
         }
        pagereference ref= new pagereference('/apex/AgencyHomePage?brandvalue='+brandvalue1+'category='+catageory1+'year='+year1);
        ref.setredirect(true);
        //return ref;
        return null;
       }
    }
    public void closeApprovalPopup()
    {
        Approvalpopup=false;
    }   
    
    Public pagereference SubitforApproval()
    {
        pagereference ref;
            if(brandEstimateId!=null && brandEstimateId!='')
            if( (LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency' && BrandEstRecord.AF_Status_Base_Fees__c=='With Agency')|| (LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance' && BrandEstRecord.AF_Status_Base_Fees__c=='With Category Finance')|| (LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' && BrandEstRecord.AF_Status_Base_Fees__c=='With CMCO')) 
            {
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval automatically ');
                req1.setObjectId(brandEstimateId);
                // Submit the approval request for the Brand Estimate
                System.debug('@@test'+brandEstimateId);
                Approval.ProcessResult result = Approval.process(req1);
                //system.debug('@@@ Submit Approval Result='+result);
                if(lstofAgencyEst.size()>0){
                    list<AF_Agency_Estimate__c>updatedlist=new list<AF_Agency_Estimate__c>();
                    for(AF_Agency_Estimate__c resetflag:lstofAgencyEst){
                    resetflag.AF_Category_Finance_Flag__c=false;
                    updatedlist.add(resetflag);
                    }
                    update updatedlist;
                }
                TempConstructor();
                displayPopupRejComment=false;
                displayPopup=false;
                displayPopUpRej=false;
                Approvalpopup=false;
                ref=new pagereference('/apex/AgencyHomePage?brandvalue='+brandvalue1+'category='+catageory1+'year='+year1);
                ref.setredirect(true);
                //return null;
            } 
            else 
            {
                ref=null;
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You Can not Submit Approval ,Beacuse your Agecy Fee user type  is Different with Brand Estimate status'));
            }
          //return ref;
         return null;
    }
    
    
    
    
    Public  void ApproveBrandEst()
    {
        System.debug('Here:');
        //reDirectHomePage=false;
        String errormsg = 'The Thresholds entered do not match the Unilever entity/entities in the Base Fees matrix. Please resolve the following mismatches by setting Bonus Threshold for Unilever entities:{';
        AF_BonusRecordManager bonusRecordManager = new AF_BonusRecordManager();
        AF_CountryBreakdownCheck mycheck = new AF_CountryBreakdownCheck();
        Boolean myresult = mycheck.CheckCountryBreakdown(ParentId);
        if(bonusRecordManager.BonusThresholdValidationCheck((BrandEstRecord))) {
        for(String countryNames:bonusRecordManager.ExceptionList){
            errormsg = errormsg+countryNames;
        }
        errormsg = errormsg+'}';
        system.debug('ExceptionList....'+bonusRecordManager.ExceptionList);
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errormsg));
            }
        else if ((BrandEstRecord.AF_Status_Base_Fees__c=='With Category Finance'||BrandEstRecord.AF_Status_Base_Fees__c=='With CMCO') && myresult)    
        {
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'Please indicate the country breakdown percentage within UK');
            apexpages.addmessage(msg); 
            
        }
        else
        {
          displayPopup = true;
        }
    }
    
    Public Void  RejectBrandEst()
    {
        displayPopupRej=true;
   
    }
    
    Public void TrueControllerFlag()
    {
         system.debug('#######CheckBox functionality');
        try{
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='Controller' &&  Targetprocess.size()==0)
            {
              
                if(Controllerflag==true)
                {
                    if(BrandEstRecord!=null)
                    {
                        BrandEstRecord.AF_Controller_Flag__c=true;
                        update BrandEstRecord;
                    }    
                }      
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot flag the record'));
                
            }
           }catch(exception e)
           {
           }
    
    }
    
    public pagereference RejectBrandestiamteFinance()
    {
      
         BrandEstRecord.AF_Status_Base_Fees__c='With Agency';
         system.debug(BrandEstRecord.AF_Status_Base_Fees__c+'BrandEstRecord.AF_Status_Base_Fees__c');
         update BrandEstRecord;
         list<AF_Controller_Review__c> ACR=new list<AF_Controller_Review__c>();
         for(AF_Controller_Review__c afc:[select id,Review_Completed__c from AF_Controller_Review__c where Brand_Estimate__c=:BrandEstRecord.id limit 50000])
         {
         afc.Review_Completed__c=false;
         ACR.add(afc);
         }
         if(ACR.size()>0)
         update ACR;
                   
          displayPopupRejComment=true;      
        pagereference ref= new pagereference('/apex/AgencyHomePage?brandvalue='+brandvalue1+'category='+catageory1+'year='+year1);
        ref.setredirect(true);
        return null;
    }
    
   
  
    
    public void changeBrandStatus()
    {
        try
        {
            /*if(StatusofBrand!='--None--')
            {
                if(BrandEstRecord!=null)
                {
                    BrandEstRecord.AF_Status_Base_Fees__c=StatusofBrand;*/
                    update BrandEstRecord;
               // }    
           // }      
        
        }
        catch(exception e)
        {
        
        }
    
    }
}