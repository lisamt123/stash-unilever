/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusMatrix_BonusApproverController
@CreateDate : 20/10/2016
@Description : This class allows Bonus Approver to approve/reject multiple Bonus Matrix records
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_BonusMatrix_BonusApproverController
{
     public List<BonusMatrixWrapper> lstBonusMatrixWrapper{get;set;}
     public List<AF_Sub_Result__c> Bonus_SubResult_List;
     public List<AF_Bonus_Matrix__c> bonusMatrixList ;
     public set<id> approveBonusRecords;
     public set<id> rejectBonusRecords;
     public boolean checkHeaderA {get;set;}
     public boolean checkHeaderR {get;set;}
     public boolean isError{get;set;}
     private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
     public List<AF_Sub_Result__c>lstSubresultUpdate;
     public Boolean popup{get;set;}
     private List<AF_Comments__c>lstComments;
     
    /*****************************************************
    *  @Description: Contructor method
    *  @name : AF_BonusMatrixSummary
    *  @param : none
    *  @return : none
    *******************************************************/ 
    public AF_BonusMatrix_BonusApproverController()
    {
        
        lstBonusMatrixWrapper = new List<BonusMatrixWrapper>();
        lstSubresultUpdate = new List<AF_Sub_Result__c>();
        Bonus_SubResult_List = new List<AF_Sub_Result__c>();
        bonusMatrixList = new List<AF_Bonus_Matrix__c>();
        lstComments = new List<AF_Comments__c>();
        approveBonusRecords = new set<id>();
        rejectBonusRecords = new set<id>();
        checkHeaderA = false;
        checkHeaderR = false;
        isError = false;
        popup=false;
        
        for(AF_Bonus_Summary__c bonusSummaryObj:
        [SELECT id,Name,AF_Status__c,AF_Agency__c,AF_Agency__r.Name,AF_Brand__c,AF_Brand__r.Name,AF_Fiscal_Year__c,AF_Bonus_Matrix_Value__c,
        AF_Is_Pilot_Model__c,Agency_Name__c,Brand_Name__c,
        (SELECT AF_Bonus_Results__r.AF_Total_Remuneration__c,AF_Bonus_Results__r.AF_Status__c,AF_Bonus_Results__r.AF_Bonus_Value_Bm__c, 
        AF_Bonus_Results__r.AF_Total_Bonus_Value__c 
        From Bonus_Matrix__r) FROM AF_Bonus_Summary__c
            where AF_Status__c =: AF_Constants.BONUS_SUMMARY_WITHBONUSAPPROVER])
            {
                lstBonusMatrixWrapper.add(new BonusMatrixWrapper(bonusSummaryObj));
            }
         
    }
    
    
    /*****************************************************
    *  @Description: Check entire column on Header Approve checkbox
    *  @name : checkAllApprove
    *  @param : none
    *  @return : none
    *******************************************************/
    public void checkAllApprove()
    {
        if(checkHeaderA)
        {
            for(BonusMatrixWrapper checkSummary: lstBonusMatrixWrapper)
            {
                checkSummary.checkedA = true; 
            }
        }    
        else if(!checkHeaderA)  
        {
            for(BonusMatrixWrapper checkSummary: lstBonusMatrixWrapper)
            {
                checkSummary.checkedA = false; 
            }
        }
    }
    
    /*****************************************************
    *  @Description: Check entire column on Header Reject checkbox
    *  @name : checkAllReject
    *  @param : none
    *  @return : none
    *******************************************************/
    public void checkAllReject()
    {
        if(checkHeaderR)
        {
            for(BonusMatrixWrapper checkSummary: lstBonusMatrixWrapper)
            {
                checkSummary.checkedR = true; 
            }
        }    
        else if(!checkHeaderR)  
        {
            for(BonusMatrixWrapper checkSummary: lstBonusMatrixWrapper)
            {
                checkSummary.checkedR = false; 
            }
        }
    }
    
    /*****************************************************
    *  @Description: Updated Bonus Summary status based on Approval/Rejection from Bonus Approver
    *  @name : saveApprovals
    *  @param : none
    *  @return : none
    *******************************************************/ 
    public pagereference saveApprovals()
    {
        isError = false;
        system.debug('----save-approvals---'+lstBonusMatrixWrapper);
        bonusMatrixList = new List<AF_Bonus_Matrix__c>();
        set<Id> setSummaryRecords = new set<Id>();
        set<String> setUniqueKey = new set<String>();
        map<id,String> mapIdToRejectreason = new map <id,String>();
        
        ApexPages.Message myMsg ;
        for (BonusMatrixWrapper wr: lstBonusMatrixWrapper) 
        {
            system.debug(wr.checkedR+'----wrapper checkbox----'+wr.RejectReason);
            // Validation when the user checks both approve and reject checkbox
            if (wr.checkedA && wr.checkedR) 
            {
                 myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Multiple check found.You can either approve/reject a matrix entry');
                 ApexPages.addMessage(myMsg);
                 isError = true;
                 
                 
            }
            else if(wr.checkedA)
            {
               approveBonusRecords.add(wr.objSummary.id);
               system.debug('-a-'+approveBonusRecords);
               
            }
            else if(wr.checkedR)
            {
                if(wr.RejectReason!= Null && wr.RejectReason!= '')
                {
                    rejectBonusRecords.add(wr.objSummary.id);
                    if(!mapIdToRejectreason.containskey(wr.objSummary.id))
                    {
                        mapIdToRejectreason.put(wr.objSummary.id,wr.RejectReason);
                    }
                    system.debug('-r-'+rejectBonusRecords);
                }
                else{
                   
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_Comments));
                    
                    isError = true;
                    
                }
                
            }
        }
        
        // On Approval the status moves to CMCO
        if(approveBonusRecords.size() > 0)
        {
            for(Id ids : approveBonusRecords)
            {
                AF_Bonus_Summary__c objsummary = new AF_Bonus_Summary__c(id=ids);
                objsummary.AF_Status__c = AF_Constants.BONUS_SUMMARY_WITHCMCO;  // With CMCO
                objsummary.AF_StatusFromApprover__c = 'Approved';
                update objsummary;
                
            }
            
            for(AF_Bonus_Matrix__c BM: [select id from AF_Bonus_Matrix__c where AF_Bonus_Summary__c IN:approveBonusRecords])
            {
                BM.AF_Status__c = AF_Constants.BONUS_SUMMARY_READYFORPO;  // Ready For PO
                
                bonusMatrixList.add(BM);
            }
        }
        
        // On Rejection the status moves to Category Finance with Rejection reason
        if(!rejectBonusRecords.isEmpty())
        {
            for(Id ids : rejectBonusRecords)
            {
                AF_Bonus_Summary__c objsummary = new AF_Bonus_Summary__c(id=ids);
                objsummary.AF_Status__c = AF_Constants.CATEGORY_FINANCE_Bonus_Quarterly; //'W/Cat Finance
                objsummary.AF_StatusFromApprover__c = 'Rejected';
                objsummary.AF_RejectReason__c = mapIdToRejectreason.get(ids);
                setSummaryRecords.add(ids);
                update objsummary;
                
                // To Capture rejection comments to show in comments section on bonus matrix page
                AF_Comments__c AfC=new AF_Comments__c();
                AfC.AF_Bonus_Summary__c=ids;
                AfC.AF_Comments__c=mapIdToRejectreason.get(ids);
                AfC.AF_Parent_Record_Id__c=String.valueOf(ids).substring(0,15);
                AfC.AF_Public__c=true;
                AfC.AF_Parent_Object_Type__c=AF_Constants.SOBJECT_BONUS_SUMMARY_APINAME;
                lstComments.add(AfC);
                
            }
            if(lstComments.size() > 0)
            {
                try{
                    insert lstComments;
                }
                catch(Exception e)
                {
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'RejectBrandWithComments',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert)); 
                }
            }
                
            if(!setSummaryRecords.isEmpty())
            {
                // Query Unique key from BonusSummary 
                for(AF_Bonus_Summary__c bonusSumObj:[SELECT AF_Brand_Agency_Uq_Combination__c from AF_Bonus_Summary__c where id IN:setSummaryRecords])
                {
                    setUniqueKey.add(bonusSumObj.AF_Brand_Agency_Uq_Combination__c);
                }
            }
            
            if(!setUniqueKey.isEmpty()){
                Bonus_SubResult_List = [SELECT Brand_Agency_Uq_Combination__c,id from AF_Sub_Result__c 
                where Brand_Agency_Uq_Combination__c IN :setUniqueKey and AF_Locked__c=:true];   
            }
            
            if(Bonus_SubResult_List.size() > 0)
            {
               for(AF_Sub_Result__c objsub :Bonus_SubResult_List){
                   objsub.AF_Locked__c = false;
                   lstSubresultUpdate.add(objsub);
               }
            }
            
            
            for(AF_Bonus_Matrix__c BM: [select id from AF_Bonus_Matrix__c where AF_Bonus_Summary__c IN : rejectBonusRecords])
            {
                BM.AF_Status__c = AF_Constants.CATEGORY_FINANCE_Bonus_Quarterly; //'W/Cat Finance
                bonusMatrixList.add(BM);
            }
        }
        
        //Update status on Bonus Matrix
        if(bonusMatrixList.size()>0)
        {
                try{
                    update bonusMatrixList;
                    update lstSubresultUpdate;
                }
                catch(Exception e)
                {
                    AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'SubmitforStatus',e.getMessage(),e.getTypeName(),e.getStackTraceString());
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
                }
         }
        
        // Error when the user checks both approve and reject checkbox
        if(!isError) 
        {
            PageReference AgencyFeePage = new PageReference('/apex/AF_AgencyHomePage?sfdc.tabName=01rE00000001wh9');
            AgencyFeePage.setRedirect(true);
            return AgencyFeePage;
        }
        else
        {
        return null;
        } 
    }
    
    /********************************************************************************
    *  @Description: this method is used to call before submitting for Approval
    *  @name : SubmitApprovalPopup
    *  @param : none
    *  @return: pagereference.
    **************************************************************************************/ 
    public pagereference SubmitPopup()
    {
        popup=true;
        return null ;
    }
   
    /************************************************************************************************
    *  @Description: this method is used to close the Approval popup
    *  @name : closeApprovalPopup
    *  @param : none
    *  @return: none.
    ********************************************************************************************************/
    public void closePopup()
    {
        popup=false;
    }
    /*****************************************************
    *  @Description: Wrapper class to capture approve and reject rows
    *  @name : BonusMatrixWrapper
    *  @param : none
    *  @return : none
    *******************************************************/ 
    public class BonusMatrixWrapper
    {
        public AF_Bonus_Summary__c objSummary {get;set;}
        public boolean checkedA {get;set;}
        public boolean checkedR {get;set;}
        public String RejectReason {get;set;}
       
       public BonusMatrixWrapper(AF_Bonus_Summary__c objSummary)
       {
          this.objSummary = objSummary;
          checkedA = false;
          checkedR = false;
          RejectReason = '';
        }
    }
    
}