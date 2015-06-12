@IsTest(SeeAllData=true)
public class IPM_CreateIPMMilestones_Test
{
public static testmethod void CreateIPMMilestonesTest()
{
//IPM_Project__c ipt=new IPM_Project__c(IPM_Project_Leader__c=userinfo.getuserid(),IPM_PM_Approach__c='External',IPM_Market_Type__c='Developing',IPM_Fast_Track_Project__c=false,name='test proj',Is_Archieved__c=false,IPM_Target_Launch_Dates__c=system.today().adddays(2));
IPM_Project__c ipt=new IPM_Project__c();
        //projects.Name='test'+Math.random();
        ipt.IPM_Project_Name__c='test'+Math.random();
        ipt.IPM_PM_Approach__c='External';
        ipt.IPM_IsCompleted__c=true;
        ipt.IPM_Fast_Track_Project__c=false;
        ipt.IPM_Phase__c='Ideas';
        ipt.IPM_Market_Type__c='Developing';
        ipt.IPM_Complexity__c='Lite';
        ipt.IPM_Target_Launch_Dates__c=System.today()+10;
        ipt.IPM_Project_Leader__c=UserInfo.getUserId();
try{insert ipt;}catch(exception e){}
Id mileMRecordType=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Milestones').getRecordTypeId();
IPM_Milestone__c IPM=new IPM_Milestone__c(IPM_Project__c=ipt.id,name='sample mile',IPM_No_Of_Days_for_Developing__c='2',IPM_Due_Date__c=system.today(),IPM_Type_of_Milestone__c='Standard',IPM_Name__c='Market Ready Gate Approval',recordtypeid=mileMRecordType);
insert IPM;
IPM_CreateIPMMilestones  Cim=new IPM_CreateIPMMilestones();
list<IPM_Project__c> iplist=new list<IPM_Project__c>();
system.assert(ipt.Id != null);
IPM_Project__c ipt1=[select id,createddate,IPM_Project_Leader__c,IPM_Category_Text__c,IPM_PM_Approach__c,IPM_Market_Type__c,IPM_Fast_Track_Project__c,Is_Archieved__c,name,IPM_Category_Group__c,IPM_Target_Launch_Dates__c from IPM_Project__c where id=:ipt.id limit 1];
iplist.add(ipt1);
IPM_CreateIPMMilestones.createMileStonesTargetLaunchDate(iplist);
IPM_CreateIPMMilestones.createMilestones(iplist);
}
}