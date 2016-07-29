/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_FieldHistoryCompController
@CreateDate : 24/6/2014
@Description : This is a controller class for AF_AgencyEstimate,AF_BonusEstimate,AF_OOPSEstimate Pages, 
@			  this is used to display the field history details.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_FieldHistoryCompController {
	public String ParentRecordId {get;set;}
	public String ParentObjectType {get;set;} 
	public List<AF_Agency_Estimate__History> AgencyEstimateHistoryCollection {get;set;}
	public List<AF_OOPS_Estimate__History> OOPSEstimateHistoryCollection {get;set;}
	public List<AF_Bonus_Matrix__History> BonusMatrixHistoryCollection {get;set;} 
	public List<AF_Controller_Review__History> ControllerReviewHistoryCollection {get;set;} 
	public List<WrapperHistory> wrp {get;set;}
	public String IsViewAll{get;set;}
	public Boolean IsViewAllLink{get;set;}
	public String IsViewAllValue{get;set;}
	public boolean isAgencyFlag{get;set;} //to check wether logged in user is partner user or not
	private static String  AF_FieldHistoryCompController=  'AF_FieldHistoryCompController';
	private static String AF_MethodName = 'getfieldhistorylist';
	/***********************************************************************************
*  @Description: this method is used to query and display the field History details
*  @name : getFieldHistoryList
*  @param : none
*  @return: List of WrapperHistory.
*************************************************************************************/	
	public List<WrapperHistory> getFieldHistoryList()
	{
		if(ApexPages.currentPage().getParameters().get('CHParentId') != null){ParentRecordId = ApexPages.currentPage().getParameters().get('CHParentId');}
		User userObj = new User();
		userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
		if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
			isAgencyFlag=true;
		}              
		wrp = new List<WrapperHistory>();
		Schema.SObjectType objSchema;
		Map<String, Schema.SObjectField> fieldMap;
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		String oldvaluestring;
		String newvaluestring; 
		double oldvalueno;
		double newvalueno;
		List<String> args = new String[]{'0','number','###,###,##0.00'};
		try
		{
			if(ParentObjectType == AF_Constants.SOBJECT_AGENCYESTIMATE_APINAME)
			{
				ParentObjectType = AF_Constants.SOBJECT_AGENCYESTIMATE_APINAME;  
				if(IsViewAll == 'true')
				{
					AgencyEstimateHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Agency_Estimate__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC ];
					IsViewAllLink = false;
				}
				else
				{
					AgencyEstimateHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Agency_Estimate__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC Limit 5];
					IsViewAllLink = true;
				}
				for(AF_Agency_Estimate__History afaeh : AgencyEstimateHistoryCollection)
				{
					if(afaeh.OldValue != null)
					{
						WrapperHistory wh = new WrapperHistory();
						wh.CreatedBy = afaeh.CreatedBy.Name;
						wh.CreatedDate = afaeh.CreatedDate; 
						wh.FieldName =  afaeh.Field;
						wh.OldValue =  afaeh.OldValue; 
						wh.NewValue =  afaeh.NewValue;                              
						try{oldvalueno=double.valueOf(afaeh.OldValue);oldvaluestring = String.format(oldvalueno.format(), args);wh.OldValue =oldvaluestring;                    
						}
						catch(TypeException te)
						{
							wh.OldValue =  afaeh.OldValue; 
						}
						try{newvalueno=double.valueOf(afaeh.NewValue);newvaluestring = String.format(newvalueno.format(), args);wh.NewValue =newvaluestring;}
						catch(TypeException te)
						{
							wh.NewValue =  afaeh.NewValue; 
						}                                              
						objSchema = schemaMap.get(ParentObjectType);                
						fieldMap = objSchema.getDescribe().fields.getMap();                                
						wh.FieldLabel = fieldMap.get(wh.FieldName).getDescribe().getLabel();
						wh.Description = wh.FieldLabel + ' was changed from ' + wh.OldValue + ' and changed to ' + wh.NewValue;
						wrp.add(wh);
					}
				} 
			}            
			else if(ParentObjectType == AF_Constants.SOBJECT_OOPSESTIMATE_APINAME)
			{
				if(IsViewAll == 'true')
				{
					OOPSEstimateHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_OOPS_Estimate__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC];
					IsViewAllLink = false;
				}
				else
				{
					OOPSEstimateHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_OOPS_Estimate__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC Limit 5];   
					IsViewAllLink = true;
				}
				for(AF_OOPS_Estimate__History oopseh : OOPSEstimateHistoryCollection)
				{
					if(oopseh.OldValue != null)
					{
						WrapperHistory wh = new WrapperHistory();
						wh.CreatedBy = oopseh.CreatedBy.Name;
						wh.CreatedDate = oopseh.CreatedDate;
						wh.FieldName =  oopseh.Field;
						wh.OldValue =  oopseh.OldValue; 
						wh.NewValue =  oopseh.NewValue;                             
						try{
							oldvalueno=double.valueOf(oopseh.OldValue);
							oldvaluestring = String.format(oldvalueno.format(), args);
							wh.OldValue =oldvaluestring;                    
						}
						catch(TypeException te)
						{
							wh.OldValue =  oopseh.OldValue; 
						}
						try{
							newvalueno=double.valueOf(oopseh.NewValue);
							newvaluestring = String.format(newvalueno.format(), args);
							wh.NewValue =newvaluestring;
						}
						catch(TypeException te)
						{
							wh.NewValue =  oopseh.NewValue; 
						}                                              
						objSchema = schemaMap.get(ParentObjectType);                
						fieldMap = objSchema.getDescribe().fields.getMap();                                
						wh.FieldLabel = fieldMap.get(wh.FieldName).getDescribe().getLabel();
						wh.Description = wh.FieldLabel + ' was changed from ' + wh.OldValue + ' and changed to ' + wh.NewValue;
						wrp.add(wh);
					}
				} 
			}
			else if(ParentObjectType == AF_Constants.SOBJECT_BONUS_MATRIX_APINAME)               
			{
				ParentObjectType = AF_Constants.SOBJECT_BONUS_MATRIX_APINAME;
				if(IsViewAll == 'true')
				{
					BonusMatrixHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Bonus_Matrix__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC];
					IsViewAllLink = false;
				}
				else
				{
					BonusMatrixHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Bonus_Matrix__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC Limit 5]; 
					IsViewAllLink = true;
				}
				for(AF_Bonus_Matrix__History bmh : BonusMatrixHistoryCollection)
				{
					if(bmh.OldValue != null)
					{
						WrapperHistory wh = new WrapperHistory();
						wh.CreatedBy = bmh.CreatedBy.Name;
						wh.CreatedDate = bmh.CreatedDate;
						wh.FieldName =  bmh.Field;
						wh.OldValue =  bmh.OldValue; 
						wh.NewValue =  bmh.NewValue;                                
						try{oldvalueno=double.valueOf(bmh.OldValue);oldvaluestring = String.format(oldvalueno.format(), args);wh.OldValue =oldvaluestring;                    
						}
						catch(TypeException te)
						{
							wh.OldValue =  bmh.OldValue; 
						}
						try{newvalueno=double.valueOf(bmh.NewValue);newvaluestring = String.format(newvalueno.format(), args);wh.NewValue =newvaluestring;}
						catch(TypeException te)
						{
							wh.NewValue =  bmh.NewValue; 
						}                                              
						objSchema = schemaMap.get(ParentObjectType);                
						fieldMap = objSchema.getDescribe().fields.getMap();                                
						wh.FieldLabel = fieldMap.get(wh.FieldName).getDescribe().getLabel();
						wh.Description = wh.FieldLabel + ' was changed from ' + wh.OldValue + ' and changed to ' + wh.NewValue;
						wrp.add(wh);
					}
				}                           
			} 
			else if(ParentObjectType == AF_Constants.SOBJECT_CONTROLLER_REVIEW_APINAME)               
			{
				ParentObjectType = AF_Constants.SOBJECT_CONTROLLER_REVIEW_APINAME;
				if(IsViewAll == 'true')
				{
					ControllerReviewHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Controller_Review__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC];
					IsViewAllLink = false;
				}
				else
				{
					ControllerReviewHistoryCollection = [Select a.ParentId, a.OldValue, a.NewValue, a.IsDeleted, a.Id, a.Field, a.CreatedDate, a.CreatedBy.Name From AF_Controller_Review__History a WHERE a.ParentId = :  ParentRecordId ORDER BY CreatedDate DESC Limit 5]; 
					IsViewAllLink = true;
				}
				for(AF_Controller_Review__History bmh : ControllerReviewHistoryCollection)
				{
					if(bmh.OldValue != null)
					{
						WrapperHistory wh = new WrapperHistory();
						wh.CreatedBy = bmh.CreatedBy.Name;
						wh.CreatedDate = bmh.CreatedDate;
						wh.FieldName =  bmh.Field;
						wh.OldValue =  bmh.OldValue; 
						wh.NewValue =  bmh.NewValue;                                
						try{oldvalueno=double.valueOf(bmh.OldValue);oldvaluestring = String.format(oldvalueno.format(), args);wh.OldValue =oldvaluestring;                    
						}
						catch(TypeException te)
						{
							wh.OldValue =  bmh.OldValue; 
						}
						try{newvalueno=double.valueOf(bmh.NewValue);newvaluestring = String.format(newvalueno.format(), args);wh.NewValue =newvaluestring;}
						catch(TypeException te)
						{
							wh.NewValue =  bmh.NewValue; 
						}                                              
						objSchema = schemaMap.get(ParentObjectType);                
						fieldMap = objSchema.getDescribe().fields.getMap();                                
						wh.FieldLabel = fieldMap.get(wh.FieldName).getDescribe().getLabel();
						wh.Description = wh.FieldLabel + ' was changed from ' + wh.OldValue + ' and changed to ' + wh.NewValue;
						wrp.add(wh);
					}
				}                           
			}   
		}
		catch(Exception ex)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_FieldHistoryCompController,AF_MethodName,ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
		} 
		return wrp;
	} 
	/***********************************************************************************
*  @Description: this wrapper class to display the field History details
*  @name : WrapperHistory
*  @param : none
*  @return: none.
*************************************************************************************/ 
	public class WrapperHistory
	{
		public string FieldLabel {get;set;}
		public string FieldName {get;set;}
		public string Description {get;set;}
		public Object OldValue {get;set;}
		public Object NewValue {get;set;}
		public string CreatedBy {get;set;}
		public DateTime CreatedDate {get;set;}
	}
}