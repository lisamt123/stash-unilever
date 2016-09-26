/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusQuarterly
@CreateDate : 30/7/2014
@Description : This is a controller class for AF_QuarterlyBonus Page, 
@			  this is used to get the lookup values of Brand and agency as
@			  pick list values and display in the page
@			  and On click of Save it should store the record in Brand Estimates
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_BrandAgencyCombinationController 
{
	// Declaration of setters and getters
	public string financialYear{get;set;} 
	public list<selectoption> brandNames{get;set;}
	public string selectedoption{get;set;}
	public string selectedoptionAgency{get;set;}
	public list<selectoption> AgencyNames{get;set;}
	Public boolean showSuccess{get; set;}
	Public boolean showFailure{get; set;}
	public boolean finalPanel{get;set;}
	public boolean displayPopup {get; set;}
	private static string className_STR=AF_BrandAgencyCombinationController.class.getName();
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_BrandAgencyCombinationController
*  @param : none
*  @return : none
*************************************************************************/       
	public AF_BrandAgencyCombinationController()
	{
		// Calling the getBrands() and getAgencies() to get the records as a picklist values on load of the page.
		displayPopup =false;
		finalPanel=false;
		getBrands();  
		getAgencies();
		financialYear=ApexPages.currentPage().getParameters().get(AF_Constants.YEAR);
	}
	/***********************************************************************************
*  @Description: this method is used to query and get the Brand picklist values
*  @name : getBrands
*  @param : none
*  @return: List of SelectOption.
*************************************************************************************/
	public List<SelectOption> getBrands()
	{
		brandNames= new list<selectoption>();
		brandNames.add(new selectoption(AF_Constants.AF_NONE_DELIM,AF_Constants.AF_BRAND_DELIM));
		List<AF_Category_Brand__c> brands =[select id,name from AF_Category_Brand__c where RecordType.Name =:AF_Constants.RT_BRAND order by name];
		for(AF_Category_Brand__c brand:brands)
		{
			brandNames.add(new selectoption(brand.id+'::'+brand.name,brand.name));
		}
		return brandNames;
	} 
	/***********************************************************************************
*  @Description: this method is used to query and get the Agency picklist values
*  @name : getAgencies
*  @param : none
*  @return: List of SelectOption.
*************************************************************************************/      
	public List<SelectOption> getAgencies()
	{
		AgencyNames = new List<SelectOption>();
		AgencyNames.add(new selectoption(AF_Constants.AF_NONE_DELIM,AF_Constants.AF_Agency_DELIM));
		List<Account> Accounts=[select id,name from account where RecordType.Name =:AF_Constants.RT_AGENCY_FEE]; 
		for(Account acc:Accounts)
		{
			AgencyNames.add(new selectoption(acc.id+'::'+acc.name,acc.name));
		}
		return AgencyNames;
	}
	/***********************************************************************************
*  @Description: this method is used to validate and insert the BrandEstimate record
*  @name : Save
*  @param : none
*  @return: none.
*************************************************************************************/
	public void Save() 
	{
		if(selectedoption==Null ||selectedoption == AF_Constants.AF_NONE_DELIM)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,Label.AF_Select_Brand));
		}
		else if(selectedoptionAgency==Null ||selectedoptionAgency == AF_Constants.AF_NONE_DELIM )
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,Label.AF_Select_Agency));
		}
		else
		{
			List<AF_Brand_Estimate__c> b=[select AF_Agency__c, Brand__c from AF_Brand_Estimate__c where Brand__c=:selectedoption.split('::').get(0) And AF_Agency__c =:selectedoptionAgency.split('::').get(0) And AF_Fiscal_Year__c =:financialYear  ];
			if(b.size()==0)
			{
				// Database.DMLOptions dmo = new database.DMLOptions();
				AF_Brand_Estimate__c newBrand=new AF_Brand_Estimate__c();  
				newBrand.Name= selectedoption.split('::').get(1)+'-'+selectedoptionAgency.split('::').get(1)+'-Q1'+'-'+financialYear;
				newBrand.AF_Agency__c=selectedoptionAgency.split('::').get(0);    
				newBrand.Brand__c=selectedoption.split('::').get(0);
				newBrand.AF_Fiscal_Year__c=financialYear; 
				try
				{
					insert newBrand;
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,Label.AF_Agency_Brand_Created));
				}
				catch(Exception ex)
				{
					AF_ExceptionLoggingHelper.createApplicationLevelErrorLog (AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,
					'save',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
					apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert)); 
				}
			}
			else
			{  
				finalPanel=true;
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_Agency_Brand_Exists));
			} 
		}  
	}
	/***********************************************************************************
*  @Description: this method is used to close the popup window
*  @name : closePopup
*  @param : none
*  @return: none.
*************************************************************************************/
	public void closePopup() 
	{ 
		displayPopup = false;    
	} 
}