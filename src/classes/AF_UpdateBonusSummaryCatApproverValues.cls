/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_UpdateBonusSummaryCatApproverValues
@CreateDate : 24/11/2016
@Description : This is a controller class for BonusSummary Trigger, 
@              this is used to populate the CATfinance,Agency,CMCO and bonus approver Users.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_UpdateBonusSummaryCatApproverValues
{
  Static String DummyUserid;
  /**************************************************************************************
*  @Description: this method is used to query the cateogry finance users and populate them
*  @             in cat finance approvers fields in the bonussummary
*  @name : UpdateBonusSummary
*  @param : SummmaryRecords
*  @return: none.
*******************************************************************************************/
  public Static void UpdateBonusSummary(List<AF_Bonus_Summary__c> SummmaryRecords)
  {
    List<string> BrandStrings=new list<String>();
    list<id> userids=new list<id>();
    list<id> useridsApprover = new list<id>();
    list<id> useridsCMCO = new list<id>();
    
    DummyUserid='';
    set<id> brandids=new set<id>();
    Map<id,string> brandMap=new Map<id,String>();
    List<AF_Category_Brand__c> CatBrands=new  List<AF_Category_Brand__c>();
    DummyUser__c Dummy = DummyUser__c.getOrgDefaults();
    DummyUserid=Dummy.User_id__c;
    if(SummmaryRecords.size()>0)
    for(AF_Bonus_Summary__c br:SummmaryRecords)
    {
      if(br.AF_Brand__c!=null)
      brandids.add(br.AF_Brand__c); 
    }
    CatBrands=[select id,Name From AF_Category_Brand__c  where id IN:brandids ];
    if(CatBrands.size()>0)
    for(AF_Category_Brand__c cb:CatBrands)
    {
      brandMap.put(cb.id,cb.Name);
    }
    List<User> users=[select id,IsActive,Username,AF_UserTypeText__c ,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c  from  User  
    where (AF_UserTypeText__c=:AF_Constants.UT_CATEGORY_FINANCE OR AF_UserTypeText__c=:AF_Constants.UT_CMCP_SUPERUSER OR 
    AF_UserTypeText__c=:AF_Constants.UT_BONUS_APPROVER)
    AND IsActive=true  Order by CreatedDate Limit 50000];
    
    
    
    if(SummmaryRecords.size()>0)
    for( AF_Bonus_Summary__c summaryRec:SummmaryRecords)
    {  
      userids=new list<id>();
      useridsApprover =new list<id>();
      useridsCMCO = new list<id>();
      String Brandname;
      if(summaryRec.AF_Brand__c!=null)
      {
        Brandname=brandMap.get(summaryRec.AF_Brand__c);
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
                // Cat finance users
                if(u.AF_UserTypeText__c==AF_Constants.UT_CATEGORY_FINANCE) { 
                    userids.add(u.id);
                }
                // CMCO users
                if(u.AF_UserTypeText__c==AF_Constants.UT_CMCP_SUPERUSER){
                    useridsCMCO.add(u.id);
                }
                // Bonus approver
                if(u.AF_UserTypeText__c==AF_Constants.UT_BONUS_APPROVER){
                    useridsApprover.add(u.id);
                }
            }
        }    
      } 
      
      if(!userids.isEmpty()){
        processSummary(userids,summaryRec);
      }
      if(!useridsApprover.isEmpty()){
        processSummaryApprover(useridsApprover,summaryRec);
      }
      if(!useridsCMCO.isEmpty()){
        processSummaryCMCO(useridsCMCO,summaryRec);
      }
    }
  }
  
  
  
    public static void processSummary(List<id> userids,AF_Bonus_Summary__c summaryRec){
      if(userids.size()==1)
      {
        summaryRec.AF_Cat_Finance_1__c=userids[0];
        summaryRec.AF_Cat_Finance_2__c=DummyUserid;
        summaryRec.AF_Cat_Finance_3__c=DummyUserid;
        summaryRec.AF_Cat_Finance_4__c=DummyUserid;
        summaryRec.AF_Cat_Finance_5__c=DummyUserid;
        summaryRec.AF_Cat_Finance_6__c=DummyUserid;
        summaryRec.AF_Cat_Finance_7__c=DummyUserid;
        summaryRec.AF_Cat_Finance_8__c=DummyUserid;
        summaryRec.AF_Cat_Finance_9__c=DummyUserid;
        summaryRec.AF_Cat_Finance_10__c=DummyUserid;
      }
      else if(userids.size()==2)
      {
        summaryRec.AF_Cat_Finance_1__c=userids[0];
        summaryRec.AF_Cat_Finance_2__c=userids[1];
        summaryRec.AF_Cat_Finance_3__c=DummyUserid;
        summaryRec.AF_Cat_Finance_4__c=DummyUserid;
        summaryRec.AF_Cat_Finance_5__c=DummyUserid;
        summaryRec.AF_Cat_Finance_6__c=DummyUserid;
        summaryRec.AF_Cat_Finance_7__c=DummyUserid;
        summaryRec.AF_Cat_Finance_8__c=DummyUserid;
        summaryRec.AF_Cat_Finance_9__c=DummyUserid;
        summaryRec.AF_Cat_Finance_10__c=DummyUserid;
      }
      else if(userids.size()==3)
      {
        summaryRec.AF_Cat_Finance_1__c=userids[0];
        summaryRec.AF_Cat_Finance_2__c=userids[1];
        summaryRec.AF_Cat_Finance_3__c=userids[2];
        summaryRec.AF_Cat_Finance_4__c=DummyUserid;
        summaryRec.AF_Cat_Finance_5__c=DummyUserid;
        summaryRec.AF_Cat_Finance_6__c=DummyUserid;
        summaryRec.AF_Cat_Finance_7__c=DummyUserid;
        summaryRec.AF_Cat_Finance_8__c=DummyUserid;
        summaryRec.AF_Cat_Finance_9__c=DummyUserid;
        summaryRec.AF_Cat_Finance_10__c=DummyUserid;
      }
      else if(userids.size()==4)
      {
        summaryRec.AF_Cat_Finance_1__c=userids[0];
        summaryRec.AF_Cat_Finance_2__c=userids[1];
        summaryRec.AF_Cat_Finance_3__c=userids[2];
        summaryRec.AF_Cat_Finance_4__c=userids[3];
        summaryRec.AF_Cat_Finance_5__c=DummyUserid;
        summaryRec.AF_Cat_Finance_6__c=DummyUserid;
        summaryRec.AF_Cat_Finance_7__c=DummyUserid;
        summaryRec.AF_Cat_Finance_8__c=DummyUserid;
        summaryRec.AF_Cat_Finance_9__c=DummyUserid;
        summaryRec.AF_Cat_Finance_10__c=DummyUserid;
      }
      else if(userids.size()==5)
      {
        summaryRec.AF_Cat_Finance_1__c=userids[0];
        summaryRec.AF_Cat_Finance_2__c=userids[1];
        summaryRec.AF_Cat_Finance_3__c=userids[2];
        summaryRec.AF_Cat_Finance_4__c=userids[3];
        summaryRec.AF_Cat_Finance_5__c=userids[4];
        summaryRec.AF_Cat_Finance_6__c=DummyUserid;
        summaryRec.AF_Cat_Finance_7__c=DummyUserid;
        summaryRec.AF_Cat_Finance_8__c=DummyUserid;
        summaryRec.AF_Cat_Finance_9__c=DummyUserid;
        summaryRec.AF_Cat_Finance_10__c=DummyUserid;
      }
      else if(userids.size()==6)
      {
        summaryRec.AF_Cat_Finance_1__c=userids[0];
        summaryRec.AF_Cat_Finance_2__c=userids[1];
        summaryRec.AF_Cat_Finance_3__c=userids[2];
        summaryRec.AF_Cat_Finance_4__c=userids[3];
        summaryRec.AF_Cat_Finance_5__c=userids[4];
        summaryRec.AF_Cat_Finance_6__c=userids[5];
        summaryRec.AF_Cat_Finance_7__c=DummyUserid;
        summaryRec.AF_Cat_Finance_8__c=DummyUserid;
        summaryRec.AF_Cat_Finance_9__c=DummyUserid;
        summaryRec.AF_Cat_Finance_10__c=DummyUserid;
      }
      else if(userids.size()==7)
      {
        summaryRec.AF_Cat_Finance_1__c=userids[0];
        summaryRec.AF_Cat_Finance_2__c=userids[1];
        summaryRec.AF_Cat_Finance_3__c=userids[2];
        summaryRec.AF_Cat_Finance_4__c=userids[3];
        summaryRec.AF_Cat_Finance_5__c=userids[4];
        summaryRec.AF_Cat_Finance_6__c=userids[5];
        summaryRec.AF_Cat_Finance_7__c=userids[6];
        summaryRec.AF_Cat_Finance_8__c=DummyUserid;
        summaryRec.AF_Cat_Finance_9__c=DummyUserid;
        summaryRec.AF_Cat_Finance_10__c=DummyUserid;
      }
      else if(userids.size()==8)
      {
        summaryRec.AF_Cat_Finance_1__c=userids[0];
        summaryRec.AF_Cat_Finance_2__c=userids[1];
        summaryRec.AF_Cat_Finance_3__c=userids[2];
        summaryRec.AF_Cat_Finance_4__c=userids[3];
        summaryRec.AF_Cat_Finance_5__c=userids[4];
        summaryRec.AF_Cat_Finance_6__c=userids[5];
        summaryRec.AF_Cat_Finance_7__c=userids[6];
        summaryRec.AF_Cat_Finance_8__c=userids[7];
        summaryRec.AF_Cat_Finance_9__c=DummyUserid;
        summaryRec.AF_Cat_Finance_10__c=DummyUserid;
      }
      else if(userids.size()==9)
      {
        summaryRec.AF_Cat_Finance_1__c=userids[0];
        summaryRec.AF_Cat_Finance_2__c=userids[1];
        summaryRec.AF_Cat_Finance_3__c=userids[2];
        summaryRec.AF_Cat_Finance_4__c=userids[3];
        summaryRec.AF_Cat_Finance_5__c=userids[4];
        summaryRec.AF_Cat_Finance_6__c=userids[5];
        summaryRec.AF_Cat_Finance_7__c=userids[6];
        summaryRec.AF_Cat_Finance_8__c=userids[7];
        summaryRec.AF_Cat_Finance_9__c=userids[8];
        summaryRec.AF_Cat_Finance_10__c=DummyUserid;
      }
      else if(userids.size()>=10)
      {
        summaryRec.AF_Cat_Finance_1__c=userids[0];
        summaryRec.AF_Cat_Finance_2__c=userids[1];
        summaryRec.AF_Cat_Finance_3__c=userids[2];
        summaryRec.AF_Cat_Finance_4__c=userids[3];
        summaryRec.AF_Cat_Finance_5__c=userids[4];
        summaryRec.AF_Cat_Finance_6__c=userids[5];
        summaryRec.AF_Cat_Finance_7__c=userids[6];
        summaryRec.AF_Cat_Finance_8__c=userids[7];
        summaryRec.AF_Cat_Finance_9__c=userids[8];
        summaryRec.AF_Cat_Finance_10__c=userids[9];
      }
  }
  
    /**************************************************************************************
    *  @Description: this method is used to populate approver users  
    *  @             
    *  @name : processSummaryApprover
    *  @param : SummmaryRecords
    *  @return: none.
    *******************************************************************************************/

    public static void processSummaryApprover(List<id> userids,AF_Bonus_Summary__c summaryRec){
        if(userids.size()==1)
        {
            summaryRec.AF_Approver1__c=userids[0];
        }
          
    }  
    
    /**************************************************************************************
    *  @Description: this method is used to populate CMCO users         
    *  @name : processSummaryCMCO
    *  @param : SummmaryRecords
    *  @return: none.
    *******************************************************************************************/
    
    public static void processSummaryCMCO(List<id> userids,AF_Bonus_Summary__c summaryRec){
        if(userids.size()==1)
        {
            summaryRec.AF_CMCO1__c=userids[0];
            summaryRec.AF_CMCO2__c=DummyUserid;
            summaryRec.AF_CMCO3__c=DummyUserid;
            summaryRec.AF_CMCO4__c=DummyUserid;
            summaryRec.AF_CMCO5__c=DummyUserid;
        }
        else if(userids.size()==2)
        {
            summaryRec.AF_CMCO1__c=userids[0];
            summaryRec.AF_CMCO2__c=userids[1];
            summaryRec.AF_CMCO3__c=DummyUserid;
            summaryRec.AF_CMCO4__c=DummyUserid;
            summaryRec.AF_CMCO5__c=DummyUserid;
        }
        else if(userids.size()==3)
        {
            summaryRec.AF_CMCO1__c=userids[0];
            summaryRec.AF_CMCO2__c=userids[1];
            summaryRec.AF_CMCO3__c=userids[2];
            summaryRec.AF_CMCO4__c=DummyUserid;
            summaryRec.AF_CMCO5__c=DummyUserid;
        }
        else if(userids.size()==4)
        {
            summaryRec.AF_CMCO1__c=userids[0];
            summaryRec.AF_CMCO2__c=userids[1];
            summaryRec.AF_CMCO3__c=userids[2];
            summaryRec.AF_CMCO4__c=userids[3];
            summaryRec.AF_CMCO5__c=DummyUserid;
        }
        else if(userids.size()==5)
        {
            summaryRec.AF_CMCO1__c=userids[0];
            summaryRec.AF_CMCO2__c=userids[1];
            summaryRec.AF_CMCO3__c=userids[2];
            summaryRec.AF_CMCO4__c=userids[3];
            summaryRec.AF_CMCO5__c=userids[4];
        }
    }
      
  /**************************************************************************************
*  @Description: this method is used to query the bonussummary and agency users 
*  @             
*  @name : UpdateOopsagencyBulk
*  @param : SummmaryRecords
*  @return: none.
*******************************************************************************************/
  public static void UpdateOopsagencyBulk(List<AF_Bonus_Summary__c> SummmaryRecords){
    Map<Id,List<AF_Bonus_Summary__c>> accountToSummaryRecordList = new Map<Id,List<AF_Bonus_Summary__c>>();
    for(AF_Bonus_Summary__c summaryRecord : SummmaryRecords){
      if(summaryRecord.AF_Agency__c != null){
        List<AF_Bonus_Summary__c> associatedSummaryRecordList = new List<AF_Bonus_Summary__c>(); 
        if(accountToSummaryRecordList.containsKey(summaryRecord.AF_Agency__c)){
          associatedSummaryRecordList = accountToSummaryRecordList.get(summaryRecord.AF_Agency__c);
        }
        associatedSummaryRecordList.add(summaryRecord);
        accountToSummaryRecordList.put(summaryRecord.AF_Agency__c,associatedSummaryRecordList);
      }
    }
    if(!accountToSummaryRecordList.isempty()){
      for(Account lAccount : [SELECT Id,(SELECT id,name,email,AccountId FROM Contacts WHERE AF_Send_Email_Notification__c =: true)  FROM Account WHERE Id in :accountToSummaryRecordList.keySet() LIMIT 50000]){
        List<Contact> contactsList =  lAccount.contacts;    
        if(accountToSummaryRecordList.containsKey(lAccount.Id)){
          List<AF_Bonus_Summary__c> associatedSummaryList = accountToSummaryRecordList.get(lAccount.Id);
          for(AF_Bonus_Summary__c summary : associatedSummaryList){
            processContact(contactsList,summary);
          }
        }                                   
      }
    }
  }
  /***********************************************************************************************
*  @Description: this method is used to assign the agency users email to the field in bonussummary
*  @             
*  @name : processContact
*  @param : SummmaryRecords
*  @return: none.
*******************************************************************************************/
  public  static void processContact(List<Contact> cList,AF_Bonus_Summary__c ao)
  {
    if(!clist.isEmpty() && clist.size()==1){
      if(clist[0].email != null && clist[0].email != '')
      ao.AF_AgencyUser1__c = clist[0].email;
    }
    if(!clist.isEmpty() && clist.size()==2){
      if(clist[0].email != null && clist[0].email != '')
      ao.AF_AgencyUser1__c = clist[0].email;
      if(clist[1].email != null && clist[1].email != '')
      ao.AF_AgencyUser2__c = clist[1].email;
    }
    if(!clist.isEmpty() && clist.size()==3){
      if(clist[0].email != null && clist[0].email != '')
      ao.AF_AgencyUser1__c = clist[0].email;
      if(clist[1].email != null && clist[1].email != '')
      ao.AF_AgencyUser3__c = clist[1].email;
      if(clist[2].email != null && clist[2].email != '')
      ao.AF_AgencyUser3__c = clist[2].email;
    }
    if(clist.size() > 0 && clist.size()==4)
    {
      if(clist[0].email != null && clist[0].email != '')
      ao.AF_AgencyUser1__c = clist[0].email;
      if(clist[1].email != null && clist[1].email != '')
      ao.AF_AgencyUser2__c = clist[1].email;
      if(clist[2].email != null && clist[2].email != '')
      ao.AF_AgencyUser3__c = clist[2].email;
      if(clist[3].email != null && clist[3].email != '')
      ao.AF_AgencyUser4__c = clist[3].email;
    }
    if(clist.size() > 0 && clist.size()==5)
    {
      if(clist[0].email != null && clist[0].email != '')
      ao.AF_AgencyUser1__c = clist[0].email;
      if(clist[1].email != null && clist[1].email != '')
      ao.AF_AgencyUser2__c = clist[1].email;
      if(clist[2].email != null && clist[2].email != '')
      ao.AF_AgencyUser3__c = clist[2].email;
      if(clist[3].email != null && clist[3].email != '')
      ao.AF_AgencyUser4__c = clist[3].email;
      if(clist[4].email != null && clist[4].email != '')
      ao.AF_AgencyUser5__c = clist[4].email;
    }
   
  }
}