/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_UpdateBrandEstimateCatApproverValues
@CreateDate : 30/7/2014
@Description : This is a controller class for BrandEstimate Trigger, 
@              this is used to populate the CATfinance Approvers and Agency Users.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_UpdateBrandEstimateCatApproverValues
{
	Static String DummyUserid;
	/**************************************************************************************
*  @Description: this method is used to query the cateogry finance users and populate them
*  @             in cat finance approvers fields in the brandestimate
*  @name : UpdateBrandingEstimates
*  @param : BrandRecords
*  @return: none.
*******************************************************************************************/
	public Static void UpdateBrandingEstimates(List<AF_Brand_Estimate__c> BrandRecords)
	{
		List<string> BrandStrings=new list<String>();
		list<id> userids=new list<id>();
		DummyUserid='';
		set<id> brandids=new set<id>();
		Map<id,string> brandMap=new Map<id,String>();
		List<AF_Category_Brand__c> CatBrands=new  List<AF_Category_Brand__c>();
		DummyUser__c Dummy = DummyUser__c.getOrgDefaults();
		DummyUserid=Dummy.User_id__c;
		if(BrandRecords.size()>0)
		for(AF_Brand_Estimate__c br:BrandRecords)
		{
			if(br.Brand__c!=null)
			brandids.add(br.Brand__c); 
		}
		CatBrands=[select id,Name From AF_Category_Brand__c  where id IN:brandids ];
		if(CatBrands.size()>0)
		for(AF_Category_Brand__c cb:CatBrands)
		{
			brandMap.put(cb.id,cb.Name);
		}
		List<User> users=[select id,IsActive,Username,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c  from  User  where  AF_UserTypeText__c=:AF_Constants.UT_CATEGORY_FINANCE  and IsActive=true  Order by CreatedDate Limit 50000];
		if(BrandRecords.size()>0)
		for( AF_Brand_Estimate__c Brandest:BrandRecords)
		{  
			userids=new list<id>();
			String Brandname;
			if(Brandest.Brand__c!=null)
			{
				Brandname=brandMap.get(Brandest.Brand__c);
			}
			if(users.size()>0)
			for(user u:users)
			{  
				BrandStrings=new list<String>();
				if(u.AF_Brand__c!=null && u.AF_Brand__c!='' )
				{
					String Brandvalue=u.AF_Brand__c;
					BrandStrings=Brandvalue.split(';');          
				}
				if(BrandStrings.size()>0)
				For(String s:BrandStrings)
				{
					if(s==Brandname)
					{
						userids.add(u.id);
					}
				}    
			} 
			processBrandEst(userids,Brandest);
		}
	}
	public static void processBrandEst(List<id> userids,AF_Brand_Estimate__c Brandest){
		if(userids.size()==1)
			{
				Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
				Brandest.AF_Cat_Finance_Approver_2__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_3__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_4__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_5__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_6__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_7__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_8__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_9__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_10__c=DummyUserid;
			}
			else if(userids.size()==2)
			{
				Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
				Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
				Brandest.AF_Cat_Finance_Approver_3__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_4__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_5__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_6__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_7__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_8__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_9__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_10__c=DummyUserid;
			}
			else if(userids.size()==3)
			{
				Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
				Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
				Brandest.AF_Cat_Finance_Approver_3__c=userids[2];
				Brandest.AF_Cat_Finance_Approver_4__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_5__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_6__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_7__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_8__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_9__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_10__c=DummyUserid;
			}
			else if(userids.size()==4)
			{
				Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
				Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
				Brandest.AF_Cat_Finance_Approver_3__c=userids[2];
				Brandest.AF_Cat_Finance_Approver_4__c=userids[3];
				Brandest.AF_Cat_Finance_Approver_5__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_6__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_7__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_8__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_9__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_10__c=DummyUserid;
			}
			else if(userids.size()==5)
			{
				Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
				Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
				Brandest.AF_Cat_Finance_Approver_3__c=userids[2];
				Brandest.AF_Cat_Finance_Approver_4__c=userids[3];
				Brandest.AF_Cat_Finance_Approver_5__c=userids[4];
				Brandest.AF_Cat_Finance_Approver_6__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_7__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_8__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_9__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_10__c=DummyUserid;
			}
			else if(userids.size()==6)
			{
				Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
				Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
				Brandest.AF_Cat_Finance_Approver_3__c=userids[2];
				Brandest.AF_Cat_Finance_Approver_4__c=userids[3];
				Brandest.AF_Cat_Finance_Approver_5__c=userids[4];
				Brandest.AF_Cat_Finance_Approver_6__c=userids[5];
				Brandest.AF_Cat_Finance_Approver_7__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_8__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_9__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_10__c=DummyUserid;
			}
			else if(userids.size()==7)
			{
				Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
				Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
				Brandest.AF_Cat_Finance_Approver_3__c=userids[2];
				Brandest.AF_Cat_Finance_Approver_4__c=userids[3];
				Brandest.AF_Cat_Finance_Approver_5__c=userids[4];
				Brandest.AF_Cat_Finance_Approver_6__c=userids[5];
				Brandest.AF_Cat_Finance_Approver_7__c=userids[6];
				Brandest.AF_Cat_Finance_Approver_8__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_9__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_10__c=DummyUserid;
			}
			else if(userids.size()==8)
			{
				Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
				Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
				Brandest.AF_Cat_Finance_Approver_3__c=userids[2];
				Brandest.AF_Cat_Finance_Approver_4__c=userids[3];
				Brandest.AF_Cat_Finance_Approver_5__c=userids[4];
				Brandest.AF_Cat_Finance_Approver_6__c=userids[5];
				Brandest.AF_Cat_Finance_Approver_7__c=userids[6];
				Brandest.AF_Cat_Finance_Approver_8__c=userids[7];
				Brandest.AF_Cat_Finance_Approver_9__c=DummyUserid;
				Brandest.AF_Cat_Finance_Approver_10__c=DummyUserid;
			}
			else if(userids.size()==9)
			{
				Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
				Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
				Brandest.AF_Cat_Finance_Approver_3__c=userids[2];
				Brandest.AF_Cat_Finance_Approver_4__c=userids[3];
				Brandest.AF_Cat_Finance_Approver_5__c=userids[4];
				Brandest.AF_Cat_Finance_Approver_6__c=userids[5];
				Brandest.AF_Cat_Finance_Approver_7__c=userids[6];
				Brandest.AF_Cat_Finance_Approver_8__c=userids[7];
				Brandest.AF_Cat_Finance_Approver_9__c=userids[8];
				Brandest.AF_Cat_Finance_Approver_10__c=DummyUserid;
			}
			else if(userids.size()>=10)
			{
				Brandest.AF_Cat_Finance_Approver_1__c=userids[0];
				Brandest.AF_Cat_Finance_Approver_2__c=userids[1];
				Brandest.AF_Cat_Finance_Approver_3__c=userids[2];
				Brandest.AF_Cat_Finance_Approver_4__c=userids[3];
				Brandest.AF_Cat_Finance_Approver_5__c=userids[4];
				Brandest.AF_Cat_Finance_Approver_6__c=userids[5];
				Brandest.AF_Cat_Finance_Approver_7__c=userids[6];
				Brandest.AF_Cat_Finance_Approver_8__c=userids[7];
				Brandest.AF_Cat_Finance_Approver_9__c=userids[8];
				Brandest.AF_Cat_Finance_Approver_10__c=userids[9];
			}
	}
	/**************************************************************************************
*  @Description: this method is used to query the brandestimate and agency users 
*  @             
*  @name : UpdateOopsagencyBulk
*  @param : BrandRecords
*  @return: none.
*******************************************************************************************/
	public static void UpdateOopsagencyBulk(List<AF_Brand_Estimate__c> BrandRecords){
		Map<Id,List<AF_Brand_Estimate__c>> accountToBrandRecordList = new Map<Id,List<AF_Brand_Estimate__c>>();
		for(AF_Brand_Estimate__c brandRecord : BrandRecords){
			if(brandRecord.AF_Agency__c != null){
				List<AF_Brand_Estimate__c> associatedBrandRecordList = new List<AF_Brand_Estimate__c>(); 
				if(accountToBrandRecordList.containsKey(brandRecord.AF_Agency__c)){
					associatedBrandRecordList = accountToBrandRecordList.get(brandRecord.AF_Agency__c);
				}
				associatedBrandRecordList.add(brandRecord);
				accountToBrandRecordList.put(brandRecord.AF_Agency__c,associatedBrandRecordList);
			}
		}
		if(!accountToBrandRecordList.isempty()){
			for(Account lAccount : [SELECT Id,(SELECT id,name,email,AccountId FROM Contacts WHERE AF_Send_Email_Notification__c =: true)  FROM Account WHERE Id in :accountToBrandRecordList.keySet() LIMIT 50000]){
				List<Contact> contactsList =  lAccount.contacts;    
				if(accountToBrandRecordList.containsKey(lAccount.Id)){
					List<AF_Brand_Estimate__c> associatedBrandList = accountToBrandRecordList.get(lAccount.Id);
					for(AF_Brand_Estimate__c brand : associatedBrandList){
						processContact(contactsList,brand);
					}
				}                                   
			}
		}
	}
	/***********************************************************************************************
*  @Description: this method is used to assign the agency users email to the field in brandestimate
*  @             
*  @name : processContact
*  @param : BrandRecords
*  @return: none.
*******************************************************************************************/
	public  static void processContact(List<Contact> cList,AF_Brand_Estimate__c ao)
	{
		if(!clist.isEmpty() && clist.size()==1){
			if(clist[0].email != null && clist[0].email != '')
			ao.AF_AgencyUsers1__c = clist[0].email;
		}
		if(!clist.isEmpty() && clist.size()==2){
			if(clist[0].email != null && clist[0].email != '')
			ao.AF_AgencyUsers1__c = clist[0].email;
			if(clist[1].email != null && clist[1].email != '')
			ao.AF_AgencyUsers2__c = clist[1].email;
		}
		if(!clist.isEmpty() && clist.size()==3){
			if(clist[0].email != null && clist[0].email != '')
			ao.AF_AgencyUsers1__c = clist[0].email;
			if(clist[1].email != null && clist[1].email != '')
			ao.AF_AgencyUsers2__c = clist[1].email;
			if(clist[2].email != null && clist[2].email != '')
			ao.AF_AgencyUsers3__c = clist[2].email;
		}
		if(clist.size() > 0 && clist.size()==4)
		{
			if(clist[0].email != null && clist[0].email != '')
			ao.AF_AgencyUsers1__c = clist[0].email;
			if(clist[1].email != null && clist[1].email != '')
			ao.AF_AgencyUsers2__c = clist[1].email;
			if(clist[2].email != null && clist[2].email != '')
			ao.AF_AgencyUsers3__c = clist[2].email;
			if(clist[3].email != null && clist[3].email != '')
			ao.AF_AgencyUsers4__c = clist[3].email;
		}
		if(clist.size() > 0 && clist.size()==5)
		{
			if(clist[0].email != null && clist[0].email != '')
			ao.AF_AgencyUsers1__c = clist[0].email;
			if(clist[1].email != null && clist[1].email != '')
			ao.AF_AgencyUsers2__c = clist[1].email;
			if(clist[2].email != null && clist[2].email != '')
			ao.AF_AgencyUsers3__c = clist[2].email;
			if(clist[3].email != null && clist[3].email != '')
			ao.AF_AgencyUsers4__c = clist[3].email;
			if(clist[4].email != null && clist[4].email != '')
			ao.AF_AgencyUsers5__c = clist[4].email;
		}
		if(clist.size() > 0 && clist.size()==6)
		{
			if(clist[0].email != null && clist[0].email != '')
			ao.AF_AgencyUsers1__c = clist[0].email;
			if(clist[1].email != null && clist[1].email != '')
			ao.AF_AgencyUsers2__c = clist[1].email;
			if(clist[2].email != null && clist[2].email != '')
			ao.AF_AgencyUsers3__c = clist[2].email;
			if(clist[3].email != null && clist[3].email != '')
			ao.AF_AgencyUsers4__c = clist[3].email;
			if(clist[4].email != null && clist[4].email != '')
			ao.AF_AgencyUsers5__c = clist[4].email;
			if(clist[5].email != null && clist[5].email != '')
			ao.AF_AgencyUsers6__c = clist[5].email;
		}
		if(clist.size() > 0 && clist.size()==7)
		{
			if(clist[0].email != null && clist[0].email != '')
			ao.AF_AgencyUsers1__c = clist[0].email;
			if(clist[1].email != null && clist[1].email != '')
			ao.AF_AgencyUsers2__c = clist[1].email;
			if(clist[2].email != null && clist[2].email != '')
			ao.AF_AgencyUsers3__c = clist[2].email;
			if(clist[3].email != null && clist[3].email != '')
			ao.AF_AgencyUsers4__c = clist[3].email;
			if(clist[4].email != null && clist[4].email != '')
			ao.AF_AgencyUsers5__c = clist[4].email;
			if(clist[5].email != null && clist[5].email != '')
			ao.AF_AgencyUsers6__c = clist[5].email;
			if(clist[6].email != null && clist[6].email != '')
			ao.AF_AgencyUsers7__c = clist[6].email;
		}
		if(clist.size() > 0 && clist.size()==8)
		{
			if(clist[0].email != null && clist[0].email != '')
			ao.AF_AgencyUsers1__c = clist[0].email;
			if(clist[1].email != null && clist[1].email != '')
			ao.AF_AgencyUsers2__c = clist[1].email;
			if(clist[2].email != null && clist[2].email != '')
			ao.AF_AgencyUsers3__c = clist[2].email;
			if(clist[3].email != null && clist[3].email != '')
			ao.AF_AgencyUsers4__c = clist[3].email;
			if(clist[4].email != null && clist[4].email != '')
			ao.AF_AgencyUsers5__c = clist[4].email;
			if(clist[5].email != null && clist[5].email != '')
			ao.AF_AgencyUsers6__c = clist[5].email;
			if(clist[6].email != null && clist[6].email != '')
			ao.AF_AgencyUsers7__c = clist[6].email;
			if(clist[7].email != null && clist[7].email != '')
			ao.AF_AgencyUsers8__c = clist[7].email;         
		}
		if(clist.size() > 0 && clist.size()==9)
		{
			if(clist[0].email != null && clist[0].email != '')
			ao.AF_AgencyUsers1__c = clist[0].email;
			if(clist[1].email != null && clist[1].email != '')
			ao.AF_AgencyUsers2__c = clist[1].email;
			if(clist[2].email != null && clist[2].email != '')
			ao.AF_AgencyUsers3__c = clist[2].email;
			if(clist[3].email != null && clist[3].email != '')
			ao.AF_AgencyUsers4__c = clist[3].email;
			if(clist[4].email != null && clist[4].email != '')
			ao.AF_AgencyUsers5__c = clist[4].email;
			if(clist[5].email != null && clist[5].email != '')
			ao.AF_AgencyUsers6__c = clist[5].email;
			if(clist[6].email != null && clist[6].email != '')
			ao.AF_AgencyUsers7__c = clist[6].email;
			if(clist[7].email != null && clist[7].email != '')
			ao.AF_AgencyUsers8__c = clist[7].email;
			if(clist[8].email != null && clist[8].email != '')
			ao.AF_AgencyUsers9__c = clist[8].email;
		}
		if(clist.size() > 0 && clist.size()>=10)
		{
			if(clist[0].email != null && clist[0].email != '')
			ao.AF_AgencyUsers1__c = clist[0].email;
			if(clist[1].email != null && clist[1].email != '')
			ao.AF_AgencyUsers2__c = clist[1].email;
			if(clist[2].email != null && clist[2].email != '')
			ao.AF_AgencyUsers3__c = clist[2].email;
			if(clist[3].email != null && clist[3].email != '')
			ao.AF_AgencyUsers4__c = clist[3].email;
			if(clist[4].email != null && clist[4].email != '')
			ao.AF_AgencyUsers5__c = clist[4].email;
			if(clist[5].email != null && clist[5].email != '')
			ao.AF_AgencyUsers6__c = clist[5].email;
			if(clist[6].email != null && clist[6].email != '')
			ao.AF_AgencyUsers7__c = clist[6].email;
			if(clist[7].email != null && clist[7].email != '')
			ao.AF_AgencyUsers8__c = clist[7].email;
			if(clist[8].email != null && clist[8].email != '')
			ao.AF_AgencyUsers9__c = clist[8].email;
			if(clist[9].email != null && clist[9].email != '')
			ao.AF_AgencyUsers10__c = clist[9].email;
		}
	}
}