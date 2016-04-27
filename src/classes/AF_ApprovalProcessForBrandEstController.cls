/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_ApprovalProcessForBrandEstController
@CreateDate : 29/7/2014
@Description : This is a component controller class for AF_UL_AgencyMatrix Page, 
@              this is used to for the BrandEstimate Approval Process(Includes dynamic Approval),Approval and Rejection
			   and only system administrator can Approve/Rejects the records
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public class AF_ApprovalProcessForBrandEstController
{
	public String brandEstimateId {get;set;}
	public String ParentId {get;set;}
	public String brandvalue1{get;set;}
	public String catageory1{get;set;}
	public String year1{get;set;}
	public String ParentRecordType {get;set;}
	public Boolean Controllerflag{set;get;}
	public Boolean hasProcess {get; set;}
	public List<ProcessInstance> process {get; set;}
	public list<ProcessInstance> Targetprocess{set;get;}
	public List<ProcessInstanceHistory> stepOrWorkItem{get; set;}
	public Boolean hasStep {get; set;}
	public user LoggedinUser{set;get;}
	public AF_Brand_Estimate__c BrandEstRecord{set;get;}
	public list<ProcessInstanceWorkitem> workItem=new list<ProcessInstanceWorkitem>();
	public id workItemId{set;get;}
	public id NextActorid{set;get;}
	public set<id> Actoridset=new set<id>();
	public string StatusofBrand{set;get;}
	public list<AF_Agency_Estimate__c>lstofAgencyEst=new list<AF_Agency_Estimate__c>();
	public boolean displayPopup {get; set;}
	public boolean displayPopupRej{set;get;}
	public boolean displayPopupRejComment{set;get;}
	public string RejectComment{set;get;}
	public string ApproveComment{set;get;}
	public boolean ButtonsDisplay{set;get;}
	public boolean Controllerflag1{set;get;}
	public boolean ApprovalButton{set;get;}
	public boolean IsCatFinanceEdited{get;set;}
	public boolean isAgency{get;set;}
	private static string AF_ApprovalProcessForBrandEstController = 'AF_ApprovalProcessForBrandEstController';
	private static String CATEGORY_ASSIGNMENT=  'category=';
	private static String YEAR_ASSIGNMENT=  'year=';
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
	/**********************************************************************
*  @Description: this method is used to display the Rejection popup msg
*  @name : RejectBrandEstComment
*  @param : none
*  @return: none.
**********************************************************************/ 
	public void RejectBrandEstComment()
	{
		displayPopupRejComment=true;
	}
	/**********************************************************************
*  @Description: this method is used to enter the rejection comments
*  @name : RejectBrandWithComments
*  @param : none
*  @return: pagereference.
**********************************************************************/ 
	public pagereference RejectBrandWithComments()
	{
		pagereference ref;
		try{
			if(RejectComment==''){
				ref=null;
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_Comments));
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
					AF_Comments__c AfC=new AF_Comments__c();
					AfC.AF_Brand_Estimate__c=brandEstimateId;
					AfC.AF_Comments__c=RejectComment;
					AfC.AF_Parent_Record_Id__c=brandEstimateId;
					AfC.AF_Public__c=true;
					AfC.AF_Parent_Object_Type__c=AF_Constants.SOBJECT_BRANDESTIMATE_APINAME;
					try{
					insert AfC;
					}
					catch(Exception e)
			        {
			            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'RejectBrandWithComments',e.getMessage(),e.getTypeName(),e.getStackTraceString());
			            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert)); 
			        }
					TempConstructor();
					displayPopupRejComment=false;
					displayPopup=false;
					displayPopUpRej=false;
					Approvalpopup=false;
					ref=new pagereference(AF_Constants.URL_HOMEPAGE+brandvalue1+CATEGORY_ASSIGNMENT+catageory1+YEAR_ASSIGNMENT+year1);
					ref.setRedirect(true);
				}
				else
				{
					ref=null;
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_Approve_record));
				}
			}    
		}catch(Exception e)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_ApprovalProcessForBrandEstController,'RejectBrandWithComments',e.getMessage(),e.getTypeName(),e.getStackTraceString());
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
			ref=null;
		}
		return null;
	}
	/**********************************************************************
*  @Description: this method is used to Approve the BrandEstimate records
*  @name : ApproveRecord
*  @param : none
*  @return: pagereference.
**********************************************************************/ 
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
					TempConstructor();
					displayPopupRejComment=false;
					displayPopup=false;
					displayPopUpRej=false;
					Approvalpopup=false;
					ref=new pagereference(AF_Constants.URL_HOMEPAGE+brandvalue1+CATEGORY_ASSIGNMENT+catageory1+YEAR_ASSIGNMENT+year1);
					ref.setRedirect(true);
				}
				else
				{
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_Approve_record));
					ref=null;
				}
			}
		}catch(exception ex)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_ApprovalProcessForBrandEstController,'ApproveRecord',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			ref=null;
		}
		return null;
	}
	/********************************************************************************
*  @Description: this method holds the functionality to reject a brandestimate record
*  @name : RejectRecord
*  @param : none
*  @return: pagereference.
**************************************************************************************/ 
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
					TempConstructor();
					displayPopupRejComment=false;
					displayPopup=false;
					displayPopUpRej=false;
					Approvalpopup=false;
					ref=new pagereference(AF_Constants.URL_HOMEPAGE+brandvalue1+CATEGORY_ASSIGNMENT+catageory1+YEAR_ASSIGNMENT+year1);
					ref.setRedirect(true);
				}
				else
				{
					ref=null;
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_Approve_record));
				}
			}    
		}Catch(Exception ex)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_ApprovalProcessForBrandEstController,'RejectRecord',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			ref=null;
		}
		return null;
	}
	/********************************************************************************
*  @Description: this method is used to close the rejection popup window
*  @name : closePopupReject
*  @param : none
*  @return: none.
**************************************************************************************/ 
	public void closePopupReject()
	{
		displayPopupRej=false;
	}
	public void closePopup() {
		displayPopup = false;
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
	/********************************************************************************
*  @Description: this method is used to show the popup msg on Approval
*  @name : showPopup
*  @param : none
*  @return: none.
**************************************************************************************/ 
	public void showPopup() {
		displayPopup = true;
	}
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_ApprovalProcessForBrandEstController
*  @param : none
*  @return : none
*************************************************************************/   
	public AF_ApprovalProcessForBrandEstController() 
	{
		brandEstimateId = ApexPages.currentPage().getParameters().get('id');
		isAgency = false;
		LoggedinUser=[select id,IsActive,Username,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c  from  User  where id=:Userinfo.getuserid()   and IsActive=true  Order by CreatedDate Limit 50000];  
		TempConstructor();
	}
	/***************************************************************************************
*  @Description: this method is used to query and find any pending approval process
*  @             and checks the logged in users and the user type of the record matches
*  @             then the users can able to see the button
*  @name : TempConstructor
*  @param : none
*  @return: none.
**************************************************************************************/ 
	public void TempConstructor()
	{
		IsCatFinanceEdited=false;
		if(brandEstimateId!=null && brandEstimateId!='')
		{    
			Targetprocess=[select Id, TargetObjectId, isDeleted, Status From ProcessInstance Where isDeleted = false and TargetObjectId =:brandEstimateId  and status='Pending' limit 1]; 
			BrandEstRecord=[select id,AF_Pilot_Model__c,AF_No_Bonus__c,AF_Basefee_Estimate_Initial_Quarter__c,AF_Category_Finance_Flag__c,Brand__c,AF_Fiscal_Year__c,AF_Category_Finance_Approved__c,AF_CMCO_Rejected__c,AF_Status_Base_Fees__c,AF_Agency__c,AF_Controller_Flag__c,ExceptionsComplete__c,AF_No_of_Central_Billing__c from AF_Brand_Estimate__c  where id=:brandEstimateId  limit 1 ];
			if(BrandEstRecord.AF_Category_Finance_Flag__c>0 && BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WITH_AGENCY && LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
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
		identifyLoggedUser();
		if(Actoridset.contains(LoggedinUser.id))
		{
			ButtonsDisplay=true;
		}
		else{
			ButtonsDisplay=false;
		}
	}
	/********************************************************************************
*  @Description: this method is used Identify which user is logged in
*  @name : identifyLoggedUser
*  @param : none
*  @return: none.
**************************************************************************************/ 
	public void identifyLoggedUser(){
		if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE && BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.CATEGORY_FINANCE &&  BrandEstRecord.AF_Category_Finance_Flag__c>0){
			IsCatFinanceEdited=true;
		}
		if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
			isAgency = true;
		}
		if((BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WITH_AGENCY && LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY) || 
				(BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WIHTCMCO && LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER))
		{
			ApprovalButton=true;            
		}
		else
		{
			ApprovalButton=false;
		}
	}
	public boolean Approvalpopup{set;get;}
	/********************************************************************************
*  @Description: this method is used to check the breakdown % before submitting for Approval
*  @name : SubmitApprovalPopup
*  @param : none
*  @return: pagereference.
**************************************************************************************/ 
	public pagereference SubmitApprovalPopup()
	{
		AF_CountryBreakdownCheck mycheck = new AF_CountryBreakdownCheck();
		Boolean myresult = mycheck.CheckCountryBreakdown(ParentId);
		if((BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WITH_AGENCY || BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.CATEGORY_FINANCE) && myresult )
		{
			apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,Label.AF_Country_Breakdown);
			apexpages.addmessage(msg); 
			return null;
		}
		Else
		Approvalpopup=true;
		return null;
		return null;
	}
	/************************************************************************************************
*  @Description: this method is used to submit for Approval by catfinance on rejection of CMCO Finance
*  @name : Submit
*  @param : none
*  @return: pagereference.
********************************************************************************************************/   
	public pagereference Submit()
	{
		AF_CountryBreakdownCheck mycheck = new AF_CountryBreakdownCheck();
		Boolean myresult = mycheck.CheckCountryBreakdown(ParentId);
		if(BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.CATEGORY_FINANCE && myresult )
		{
			apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,Label.AF_Country_Breakdown);
			apexpages.addmessage(msg); 
			return null;
		}
		AF_BonusRecordManager bonusRecordManager = new AF_BonusRecordManager();
		if(bonusRecordManager.BonusThresholdValidationCheck((BrandEstRecord))) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_Thershold_Entity));
			return null;
		}else{
			if(BrandEstRecord.AF_Category_Finance_Flag__c>0)
			{
				BrandEstRecord.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WITH_AGENCY;
				try{
				update BrandEstRecord;
				}
				catch(Exception e)
		        {
		            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'Submit',e.getMessage(),e.getTypeName(),e.getStackTraceString());
		            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		        }
				list<AF_Controller_Review__c> ACR=new list<AF_Controller_Review__c>();
				for(AF_Controller_Review__c afc:[select id,Review_Completed__c from AF_Controller_Review__c where Brand_Estimate__c=:BrandEstRecord.id limit 50000])
				{
					afc.Review_Completed__c=false;
					ACR.add(afc);
				}
				if(ACR.size()>0)
				try{
				update ACR;
				}
				catch(Exception e)
		        {
		            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'Submit',e.getMessage(),e.getTypeName(),e.getStackTraceString());
		            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		        }
				
			}
			else if(BrandEstRecord.AF_Category_Finance_Flag__c==0)
			{
				BrandEstRecord.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WIHTCMCO;
				try{
				update BrandEstRecord;
				}
				catch(Exception e)
		        {
		            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'Submit',e.getMessage(),e.getTypeName(),e.getStackTraceString());
		            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		        }
				Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
				req1.setComments('Submitting request for approval automatically ');
				req1.setObjectId(brandEstimateId);
				// Submit the approval request for the Brand Estimate
				Approval.ProcessResult result = Approval.process(req1);
				TempConstructor();
				displayPopupRejComment=false;
				displayPopup=false;
				displayPopUpRej=false;
				Approvalpopup=false;
			}
			pagereference ref= new pagereference(AF_Constants.URL_HOMEPAGE+brandvalue1+CATEGORY_ASSIGNMENT+catageory1+YEAR_ASSIGNMENT+year1);
			ref.setredirect(true);
			return null;
		}
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
	/************************************************************************************************
*  @Description: this method is used to submit for Approval by Agency
*  @name : SubitforApproval
*  @param : none
*  @return: pagereference.
********************************************************************************************************/      
	public pagereference SubitforApproval()
	{
		pagereference ref;
		if(brandEstimateId!=null && brandEstimateId!='')
		if( (LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY && BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WITH_AGENCY)|| (LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE && BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.CATEGORY_FINANCE)|| (LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' && BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WIHTCMCO)) 
		{
			if(lstofAgencyEst.size()>0){
				list<AF_Agency_Estimate__c>updatedlist=new list<AF_Agency_Estimate__c>();
				for(AF_Agency_Estimate__c resetflag:lstofAgencyEst){
					resetflag.AF_Category_Finance_Flag__c=false;
					updatedlist.add(resetflag);
				}
				update updatedlist;
			}
			Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
			req1.setComments('Submitting request for approval automatically ');
			req1.setObjectId(brandEstimateId);
			// Submit the approval request for the Brand Estimate
			Approval.ProcessResult result = Approval.process(req1);
			TempConstructor();
			displayPopupRejComment=false;
			displayPopup=false;
			displayPopUpRej=false;
			Approvalpopup=false;
			ref=new pagereference(AF_Constants.URL_HOMEPAGE+brandvalue1+CATEGORY_ASSIGNMENT+catageory1+YEAR_ASSIGNMENT+year1);
			ref.setredirect(true);
		} 
		else 
		{
			ref=null;
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_Brandestimate_Status));
		}
		return null;
	}
	/************************************************************************************************
*  @Description: this method is used to check the BonusThreshold validation on Q4 quarter
*  @name : ApproveBrandEst
*  @param : none
*  @return: none.
********************************************************************************************************/   
	public  void ApproveBrandEst()
	{
		String errormsg = Label.AF_Thershold_Setting;
		AF_BonusRecordManager bonusRecordManager = new AF_BonusRecordManager();
		AF_CountryBreakdownCheck mycheck = new AF_CountryBreakdownCheck();
		Boolean myresult = mycheck.CheckCountryBreakdown(ParentId);
		if(bonusRecordManager.BonusThresholdValidationCheck((BrandEstRecord))) {
			for(String countryNames:bonusRecordManager.ExceptionList){
				errormsg = errormsg+countryNames;
			}
			errormsg = errormsg+'}';
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errormsg));
		}
		else if ((BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.CATEGORY_FINANCE||BrandEstRecord.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WIHTCMCO) && myresult)    
		{
			apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,Label.AF_Country_Breakdown);
			apexpages.addmessage(msg); 
		}
		else
		{
			displayPopup = true;
		}
	}
	/************************************************************************************************
*  @Description: this method is used to show the rejection popup
*  @name : RejectBrandEst
*  @param : none
*  @return: none.
********************************************************************************************************/   
	public void  RejectBrandEst()
	{
		displayPopupRej=true;
	}
	/************************************************************************************************
*  @Description: this method is used to update the controller flag of  brandestimate
*  @name : TrueControllerFlag
*  @param : none
*  @return: none.
********************************************************************************************************/   
	public void TrueControllerFlag()
	{
		try{
			if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CONTROLLER &&  Targetprocess.size()==0)
			{
				if(Controllerflag)
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
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_Flag_Record));
			}
		}catch(exception ex)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_ApprovalProcessForBrandEstController,'TrueControllerFlag',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
		}
	}
	/************************************************************************************************
*  @Description: this method is used to on rejection by catfinance
*  @name : RejectBrandestiamteFinance
*  @param : none
*  @return: pagereference.
********************************************************************************************************/
	public pagereference RejectBrandestiamteFinance()
	{
		BrandEstRecord.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WITH_AGENCY;
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
		pagereference ref= new pagereference(AF_Constants.URL_HOMEPAGE+brandvalue1+CATEGORY_ASSIGNMENT+catageory1+YEAR_ASSIGNMENT+year1);
		ref.setredirect(true);
		return null;
	}
	/************************************************************************************************
*  @Description: this method is used to update the status of BrandEstimate by CMCOSuperuser
*  @name : changeBrandStatus
*  @param : none
*  @return: none.
********************************************************************************************************/
	public void changeBrandStatus()
	{
		try
		{
			update BrandEstRecord;
		}
		catch(exception ex)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_ApprovalProcessForBrandEstController,'changeBrandStatus',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
		}
	}
}