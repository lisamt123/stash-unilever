@istest(seealldata=true)
public class IPM_MyProjects_Test
{
public static testmethod void IPM_MyProjectsTest()
{
IPM_Project__c ipt=new IPM_Project__c(IPM_Project_Leader__c=userinfo.getuserid(),IPM_PM_Approach__c='External',IPM_Market_Type__c='Developing',IPM_Fast_Track_Project__c=false,name='test proj',Is_Archieved__c=false,IPM_Target_Launch_Dates__c=system.today().adddays(2));
insert ipt;
Id mileMRecordType=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
IPM_Milestone__c IPM=new IPM_Milestone__c(IPM_Project__c=ipt.id,name='sample mile',IPM_No_Of_Days_for_Developing__c='2',IPM_Due_Date__c=system.today(),IPM_Type_of_Milestone__c='Standard',IPM_Name__c='Market Ready Gate Approval',recordtypeid=mileMRecordType);
insert IPM;
IPM_Project_Document__c IPD=new IPM_Project_Document__c(IPM_Project__c=ipt.id,name='test doc');
insert IPD;

    IPM_MyProjects ipmp=new IPM_MyProjects();
    IPM_MyProjects ipmp1=new IPM_MyProjects(new IPM_HomePageController());
    
    ipmp.getProjects();
    ApexPages.StandardController sc = new ApexPages.StandardController(IPD);
}
}