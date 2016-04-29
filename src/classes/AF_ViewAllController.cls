/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_ViewAllController
@CreateDate : 10/7/2014
@Description : This is a controller class for AF_ViewAll Page, 
@			  this is used to display all the comments,Documents and field history more than 5 records
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_ViewAllController 
{
	public string DParentId {get;set;}
	public string CParentId {get;set;}
	public string CHParentId {get;set;}
	public Boolean ViewComments {get;set;}
	public Boolean ViewDocuments{get;set;}
	public Boolean ViewChangeHistory{get;set;}  
	public Boolean agencyEstimate{get;set;}
	public Boolean oopEstimate{get;set;}
	public Boolean bonusEstimate{get;set;}
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_ViewAllController
*  @param : none
*  @return : none
*************************************************************************/
	public AF_ViewAllController()
	{
		if(ApexPages.currentPage().getParameters().get('DParentId') != null){DParentId = ApexPages.currentPage().getParameters().get('DParentId');ViewDocuments = true;}
		if(ApexPages.currentPage().getParameters().get('CParentId') != null){CParentId = ApexPages.currentPage().getParameters().get('CParentId');ViewComments=true;}
		if(ApexPages.currentPage().getParameters().get('CHParentId') != null){CHParentId = ApexPages.currentPage().getParameters().get('CHParentId');ViewChangeHistory=true;}                
		if(CHParentId != null){
			if(CHParentId.startsWith(System.Label.AF_ViewAllHistory_AgencyEstimates)){
				agencyEstimate = true;
			}
			else if(CHParentId.startsWith(System.Label.AF_ViewAllHistory_oopEstimate)){
				oopEstimate = true;
			}
			else if(CHParentId.startsWith(System.Label.AF_ViewAllHistory_BonusEstimate)){
				bonusEstimate = true;
			}
		}
	}   
}