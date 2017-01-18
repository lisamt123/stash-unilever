/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusMatrixSummary
@CreateDate : 27/7/2014
@Description : This is a controller class for AF_BonusEstimate Page, 
@             which is used to display the Bonus Summary section of Bonus Matrix page.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_BonusMatrixSummary {
    public  List<AF_Bonus_Summary__c> bonusSummaries{get;set;}
    public AF_Bonus_Results__c bonusResultObj{get;set;}
    public AF_Bonus_Summary__c bonusSummaryObj{get;set;}
    public Integer bonus {get;set;}//To get bonus 
    public Decimal bonusableFee{get;set;}//To get bonusableFee
    public Integer totalfee{get;set;}//To get totalfee
    public Integer overallbonusPer{get;set;}//To display overallbonusPer
    public Integer qualPer{get;set;}//To display Qualitative bonus
    public Integer quantPer{get;set;}//To display Quantitative bonus
    public String BrandId {get;set;}//To get selected Brand
    public String AgencyId{get;set;}//To get selected Agency
    public Decimal remainingAllowances{get;set;}
    public Decimal BonusTarget{get;set;}
    public Decimal qualValue{get;set;}
    public  Decimal quant{get;set;}
    public Integer totalquant_qual{get;set;}
    public Boolean IsReadyForPO{get;set;}
    public Boolean IsWithBonusApprover{get;set;}
    public Boolean IsWithCatfin{get;set;}
    public Boolean IsWithCMCO {get;set;}
    public Boolean isCatFinance{get;set;}
    public Boolean isBonusApprover{get;set;}
    public Boolean isAgencyFlag{get;set;}
    public Boolean isCMCO{get;set;}
    public String ButtonValue {get;set;}
    public Boolean Approvalpopup{get;set;}
    public Boolean displayPopUp {get;set;}
    public Boolean displayPopupRejComment {get;set;}
    public string RejectComment{set;get;}
    private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
    public List<AF_Sub_Result__c> Bonus_SubResult_List = new List<AF_Sub_Result__c>();
    public String year;
    public integer bonusablefees{get;set;}
    private List<AF_Comments__c>lstComments;
    public User userObj; 
    public Boolean isRedirect{get;set;}
    /**********************************************************************
*  @Description: Contructor method
*  @name : AF_BonusMatrixSummary
*  @param : none
*  @return : none
*************************************************************************/ 
    public AF_BonusMatrixSummary(ApexPages.StandardController stdController){
        String BonusSummaryId = ApexPages.currentPage().getParameters().get('Id');
        IsReadyForPO=false;
        Approvalpopup=false;
        displayPopUp = false;
        isRedirect= false;
        displayPopupRejComment = false;
        IsWithBonusApprover = false;
        IsWithCatfin = false;
        IsWithCMCO = false;
        BonusTarget=0;
        totalquant_qual=0;
        bonusSummaryObj= new AF_Bonus_Summary__c();
        lstComments = new List<AF_Comments__c>();
        Decimal overallBonus=0;
        qualValue=0;
        quant=0;
        bonusableFee=0;
        bonusablefees=0;
        totalfee=0;
        overallbonusPer=0;
        qualPer=0;
        quantPer=0;
        remainingAllowances=0;
        isCatFinance=false;
        isBonusApprover = false;
        isCMCO = false;
        isAgencyFlag=false;
        ButtonValue = '';
        userObj = new User();
        userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
        if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE){
            isCatFinance=true;
        }
        if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
            isAgencyFlag=true;
        }
        if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_BONUS_APPROVER ){
            isBonusApprover = true;
        }
        if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER ){
            isCMCO = true;
        }
        bonusSummaryObj=[SELECT AF_Status__c,AF_Agency__c,AF_Agency__r.Name,AF_Brand__c,AF_Brand__r.Name,AF_Fiscal_Year__c,AF_Bonus_Matrix_Value__c,AF_Is_Pilot_Model__c,
        (SELECT AF_Bonus_Results__r.AF_Total_Remuneration__c,AF_Bonus_Results__r.AF_Status__c,AF_Bonus_Results__r.AF_Bonus_Value_Bm__c, AF_Bonus_Results__r.AF_Total_Bonus_Value__c 
        From Bonus_Matrix__r)
        FROM AF_Bonus_Summary__c 
        WHERE id=:BonusSummaryId];
        BrandId=bonusSummaryObj.AF_Brand__c;
        AgencyId=bonusSummaryObj.AF_Agency__c;
        year=bonusSummaryObj.AF_Fiscal_Year__c;
        list<AF_Brand_Estimate__c> brandlist=new list<AF_Brand_Estimate__c>();
        brandlist=[select id,name,Brand__c,AF_Agency__c,AF_AgencyBaseFees__c from AF_Brand_Estimate__c where Brand__c=:BrandId and AF_Agency__c=:AgencyId and AF_Fiscal_Year__c=:year and AF_Active__c=true  limit 1];
        if(brandlist.size()>0){
        bonusablefees=integer.valueof(brandlist.get(0).AF_AgencyBaseFees__c);
        }
        
        if(bonusSummaryObj.AF_Status__c==AF_Constants.BONUS_SUMMARY_READYFORPO){
            IsReadyForPO=true;
        }
        if(bonusSummaryObj.AF_Status__c==AF_Constants.BONUS_SUMMARY_WITHBONUSAPPROVER){
            IsWithBonusApprover=true;
        }
        if(bonusSummaryObj.AF_Status__c==AF_Constants.BONUS_SUMMARY_WITHCMCO){
            IsWithCMCO=true;
        }
        if(bonusSummaryObj.AF_Status__c==AF_Constants.CATEGORY_FINANCE_Bonus_Quarterly){
            IsWithCatfin=true;
        }
        decimal BonusTarget1=0;
        //to store unique Threshold Ids
        Set<ID> ids = new Set<ID>();
        for(AF_Bonus_Threshold__c bonusThObj : [SELECT Id FROM AF_Bonus_Threshold__c Where Agency_Name__c=:AgencyId AND Brand_Name__c=:BrandId AND Year__c=:year]){
            ids.add(bonusThObj.Id);
        }
        //Query all Results related to Bonus Thresholds
        for(AF_Bonus_Results__c bonusResultObj :[SELECT AF_Total_Bonus_Value__c,AF_Total_Remuneration__c,
        AF_Bonus_Value_Bm__c,AF_Bonusable_Fees__c,AF_Total_bonus_fees__c,
        AF_Total_Bonus__c,AF_Quant_Bonus_Value__c,AF_Qual_Bonus_Value__c
        FROM AF_Bonus_Results__c 
        WHERE AF_Bonus_Thresholds__c IN:ids AND recordType.Name=:AF_Constants.ANNUAL_BONUS_REC_TYPE]){
            if(bonusResultObj.AF_Total_Bonus_Value__c==null)
            bonusResultObj.AF_Total_Bonus_Value__c=0;
            overallBonus+=bonusResultObj.AF_Total_Bonus_Value__c;
            BonusTarget1=BonusTarget1+(bonusResultObj.AF_Total_Bonus_Value__c);
            if(bonusResultObj.AF_Qual_Bonus_Value__c==null)
            bonusResultObj.AF_Qual_Bonus_Value__c=0;
            qualValue+=bonusResultObj.AF_Qual_Bonus_Value__c;
            if(bonusResultObj.AF_Quant_Bonus_Value__c==null)
            bonusResultObj.AF_Quant_Bonus_Value__c=0;
            quant+=bonusResultObj.AF_Quant_Bonus_Value__c;
            if(bonusResultObj.AF_Bonusable_Fees__c==null)
            bonusResultObj.AF_Bonusable_Fees__c=0;
            bonusableFee+=bonusResultObj.AF_Bonusable_Fees__c;
            bonusablefees=integer.valueof(brandlist.get(0).AF_AgencyBaseFees__c);
            if(bonusResultObj.AF_Total_bonus_fees__c==null)
            bonusResultObj.AF_Total_bonus_fees__c=0;
            totalfee+=Integer.valueOf(bonusResultObj.AF_Total_bonus_fees__c);
        }
        BonusTarget=math.round(BonusTarget1);
        totalquant_qual=math.round(quant+qualValue);
        if(bonusSummaryObj.AF_Is_Pilot_Model__c) {
            if(bonusSummaryObj.Bonus_Matrix__r.size() > 0) {
                if(bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Total_Remuneration__c != null &&
                        bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Bonus_Value_Bm__c != null) {
                    remainingAllowances = (bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Total_Remuneration__c - 
                    bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Bonus_Value_Bm__c);
                    if(remainingAllowances<1){
                        remainingAllowances=0;
                    }
                }
            }
        }else {
            remainingAllowances = (BonusTarget - bonusSummaryObj.AF_Bonus_Matrix_Value__c);
            if(remainingAllowances<1){
                remainingAllowances=0;
            }
        }
        //Calculate Overall bonus Percentage,Quatitative Bonus,Qualitative Bonus
        if(bonusablefees!=0){  
            qualPer=Math.round((qualValue*100)/bonusablefees);
            quantPer=Math.round((quant*100)/bonusablefees);
            if(bonusSummaryObj.AF_Is_Pilot_Model__c) 
            {
                overallbonusPer=Math.round((overallBonus*100)/bonusablefees);
            }
            else
            {
                overallbonusPer=qualPer+quantPer;
            }
        }
    }
    
    /**********************************************************************
    *  @Description: this method is used to submit the Bonus finally.
    *  @name : SubmitforStatus
    *  @param : none
    *  @return: pagereference
    **********************************************************************/
    public pagereference SubmitforStatus(){
        string Submit_for_status='SubmitforStatus';
        List<AF_Bonus_Matrix__c> bonusMatrixList = new List<AF_Bonus_Matrix__c>();
        pagereference pageRef;
        Boolean hasError=false;
        isRedirect=false;
        
        /** To disallow Cat finance to submit for approval when annual bonus is not entered **/
        Bonus_SubResult_List = [SELECT AF_Qual_Per__c,AF_Bonus_Target__c,AF_Comment__c,AF_Quant__c,AF_Status__c,AF_Total_Bonus__c,AF_Qual__c,AF_Country__r.AF_Country__c,AF_Country__r.name,Bonus_Measure__c,AF_Locked__c,AF_country__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Year__c,AF_Digital__c,AF_Traditional__c,AF_Adaptation__c,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,
        AF_Unique_Thresholds__c,AF_Quant_Bonus_Value__c,AF_Total_Bonus_Value__c,AF_Bonusable_Fees__c,AF_Quant_Bonus__c from AF_Sub_Result__c 
        where AF_Bonus_Threshold__r.Brand_Name__c=:BrandId and AF_Bonus_Threshold__r.Agency_Name__c=:AgencyId and AF_Bonus_Threshold__r.Year__c=:year AND
        AF_Period__c=:null];
        
        if(Bonus_SubResult_List.size() > 0)
        {
            for(AF_Sub_Result__c objsub :Bonus_SubResult_List)
            {
               if(objsub.AF_Locked__c  == false && userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE)
               {
                    apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Annual_Bonus));
                    hasError=true;
               }
            }
        }
        /** To disallow Cat finance to submit for approval when annual bonus is not entered**/

        
        if(bonusablefees==0){
            apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Annual_Bonus));
        }
        else if(remainingAllowances==0 && !hasError)
        {
            bonusSummaryObj.AF_Status__c=AF_Constants.BONUS_SUMMARY_WITHBONUSAPPROVER;
            try{
            update bonusSummaryObj;
            
            }
            catch(Exception e)
            {
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,Submit_for_status,e.getMessage(),e.getTypeName(),e.getStackTraceString());
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
            }
            for(AF_Bonus_Matrix__c BM:bonusSummaryObj.Bonus_Matrix__r){
                BM.AF_Status__c = AF_Constants.BONUS_SUMMARY_WITHBONUSAPPROVER;
                bonusMatrixList.add(BM);
            }
            if(bonusMatrixList.size()>0){
                try{
                update bonusMatrixList;
                IsWithBonusApprover=true;
                }
                catch(Exception e)
                {
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,Submit_for_status,e.getMessage(),e.getTypeName(),e.getStackTraceString());
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
                }
            }
            IsWithBonusApprover=true;
            IsWithCatfin = false;
            isRedirect=true;
            
        }
        Approvalpopup=false;
        return null;
    }
    
    
    /***********************************************************************
    *  @Description: this method is used to Approve/Reject the Bonus finally from Bonus approver
    *  @name : ApproveRejectStatus
    *  @param : none
    *  @return: pagereference
    **********************************************************************/
    public pagereference ApproveRejectStatus(){
        string Submit_for_status='ApproveRejectStatus';
        List<AF_Bonus_Matrix__c> bonusMatrixList = new List<AF_Bonus_Matrix__c>();
        List<AF_Sub_Result__c>lstSubresultUpdate = new List<AF_Sub_Result__c>();
        
        Bonus_SubResult_List = [SELECT AF_Qual_Per__c,AF_Bonus_Target__c,AF_Comment__c,AF_Quant__c,AF_Total_Bonus__c,AF_Qual__c,AF_Country__r.AF_Country__c,AF_Country__r.name,Bonus_Measure__c,AF_Locked__c,AF_country__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Brand_Name__c,AF_Bonus_Threshold__r.Agency_Name__c,AF_Bonus_Threshold__r.Year__c,AF_Digital__c,AF_Traditional__c,AF_Adaptation__c,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Unique_Thresholds__c,AF_Quant_Bonus_Value__c,AF_Total_Bonus_Value__c,AF_Bonusable_Fees__c,AF_Quant_Bonus__c from AF_Sub_Result__c where AF_Bonus_Threshold__r.Brand_Name__c=:BrandId and AF_Bonus_Threshold__r.Agency_Name__c=:AgencyId and AF_Bonus_Threshold__r.Year__c=:year and AF_Period__c=null and AF_Locked__c=:true];
        
        if(bonusablefees==0){
            apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Annual_Bonus));
        }
        else if(remainingAllowances==0){
            if(ButtonValue == 'Approve'){
                system.debug('---approve--');
                bonusSummaryObj.AF_Status__c=AF_Constants.BONUS_SUMMARY_WITHCMCO;
                bonusSummaryObj.AF_StatusFromApprover__c = 'Approved';
                system.debug('---bonusSummaryObj--'+bonusSummaryObj);
                IsWithCMCO=true;
            }
            else if(ButtonValue == 'Reject'){
                 pagereference ref;
                if(RejectComment=='')
                {
                    ref=null;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_Comments));
                }
                else
                {
                    bonusSummaryObj.AF_Status__c = AF_Constants.CATEGORY_FINANCE_Bonus_Quarterly;
                    bonusSummaryObj.AF_StatusFromApprover__c = 'Rejected';
                    bonusSummaryObj.AF_RejectReason__c =RejectComment;
                    IsWithCatfin = true;
                    if(Bonus_SubResult_List.size() > 0)
                    {
                       for(AF_Sub_Result__c objsub :Bonus_SubResult_List){
                           objsub.AF_Locked__c = false;
                           lstSubresultUpdate.add(objsub);
                       }
                    }
                    
                    // To Capture rejection comments to show in comments section on bonus matrix page
                    AF_Comments__c AfC=new AF_Comments__c();
                    AfC.AF_Bonus_Summary__c=bonusSummaryObj.id;
                    AfC.AF_Comments__c=RejectComment;
                    AfC.AF_Parent_Record_Id__c=String.valueOf(bonusSummaryObj.id).substring(0,15);
                    AfC.AF_Public__c=true;
                    AfC.AF_Parent_Object_Type__c=AF_Constants.SOBJECT_BONUS_SUMMARY_APINAME;
                    lstComments.add(AfC);
                }   
            }
            else if(ButtonValue == 'Submit'){
                system.debug('---reject--');
                bonusSummaryObj.AF_Status__c = AF_Constants.BONUS_SUMMARY_READYFORPO;
                IsReadyForPO = true;
                
            }
            try{
            update bonusSummaryObj;
            update lstSubresultUpdate;
            insert lstComments;
            system.debug('---lstSubresultUpdate--'+lstSubresultUpdate);
            }
             catch(Exception e)
                {
                   // AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,Submit_for_status,e.getMessage(),e.getTypeName(),e.getStackTraceString());
                    //apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
                }
            for(AF_Bonus_Matrix__c BM:bonusSummaryObj.Bonus_Matrix__r){
                if(ButtonValue == 'Approve'){
                    BM.AF_Status__c = AF_Constants.BONUS_SUMMARY_WITHCMCO;
                    
                    IsWithCMCO=true;
                }
                else if(ButtonValue == 'Reject'){
                    BM.AF_Status__c = AF_Constants.CATEGORY_FINANCE;
                    IsWithCatfin = true;
                }
                else if(ButtonValue == 'Submit'){
                    BM.AF_Status__c = AF_Constants.BONUS_SUMMARY_READYFORPO;
                    IsReadyForPO=true;
                }
                bonusMatrixList.add(BM);
            }
            if(bonusMatrixList.size()>0){
                try{
                update bonusMatrixList;
                }
                catch(Exception e)
                {
                    //AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,Submit_for_status,e.getMessage(),e.getTypeName(),e.getStackTraceString());
                    //apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
                }
            }
            
        }
        return null;
    }
    
    /************************************************************************************************
    *  @Description: this method is used to close the Approval popup
    *  @name : closeApprovalPopup
    *  @param : none
    *  @return: none.
    ********************************************************************************************************/
    public void closeApprovalPopup()
    {
        Approvalpopup=false;
    }
    
    public void closePopup() {
        displayPopup = false;
    }
      
    /********************************************************************************
    *  @Description: this method is used to call before submitting for Approval
    *  @name : SubmitApprovalPopup
    *  @param : none
    *  @return: pagereference.
    **************************************************************************************/ 
    public pagereference SubmitApprovalPopup()
    {
        Approvalpopup=true;
        return null ;
    }
    
    /************************************************************************************************
    *  @Description: this method is used to call on approval by approver
    *  @name : ApprovePopup
    *  @param : none
    *  @return: none.
    ********************************************************************************************************/   
    public void ApprovePopup()
    {
       displayPopup = true; 
    }
        /************************************************************************************************
*  @Description: this method is used to call on rejection by Approver
*  @name : RejectPopup
*  @param : none
*  @return: pagereference.
********************************************************************************************************/
    public pagereference RejectPopup()
    {  
        displayPopupRejComment=true;      
        return null;
    }
    
    /********************************************************************************
    *  @Description: this method is used to close the rejection comment popup window
    *  @name : closePopupRejComment
    *  @param : none
    *  @return: none.
    **************************************************************************************/ 
    public void closePopupRejComment()
    {
        displayPopupRejComment=false;
    }
}
