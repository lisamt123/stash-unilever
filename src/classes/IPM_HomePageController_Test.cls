@istest(seealldata=true)
public class IPM_HomePageController_Test
{
public static testmethod void IPM_HomePageControllerTest()
{
Id recordtypeid=Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
IPM_Project__c ipt=new IPM_Project__c(IPM_Project_Leader__c=userinfo.getuserid(),IPM_PM_Approach__c='External',name='test proj',Is_Archieved__c=false);
insert ipt;
IPM_HomePageController Ihp=new IPM_HomePageController();
Ihp.project();
Ihp.bosscard();

}
}