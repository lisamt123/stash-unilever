@istest
public class IPM_Milestone_Test
{
public static testmethod void IPM_MilestoneTest()
{
//IPM_Task__c ita=new IPM_Task__c(IPM_Assignee__c=userinfo.getuserid(),name='test task',IPM_Due_Date__c='3/2/2015',IPM_Phase__c='Market Deployment');
//insert ita;

IPM_Project__c ipt=new IPM_Project__c(IPM_Project_Leader__c=userinfo.getuserid(),IPM_PM_Approach__c='External',name='test proj');
insert ipt;
IPM_Milestone__c IPM=new IPM_Milestone__c(IPM_Project__c=ipt.id,name='Market Ready Gate Approval',IPM_Due_Date__c=system.today(),IPM_Type_of_Milestone__c='Standard',IPM_Name__c='Market Ready Gate Approval');
insert IPM;
apexpages.currentpage().getparameters().put('projectId',ipt.id);
apexpages.currentpage().getparameters().put('taskId',IPM.id);
ApexPages.StandardController controller=new ApexPages.StandardController(IPM);
IPM_Milestone IM=new IPM_Milestone(controller);
//IM.tasks=IPM;
IM.upsertTask(IPM);
IPM_Milestone.MilestoneWrapper ic=new IPM_Milestone.MilestoneWrapper(IPM,System.today());
ic.checked=true;
IM.createMileStones();
IM.closePopup();
IM.showPopup();
//IM.updateTasksMileStones();
IM.getCategories();
IM.getduedate();
IM.doupdateTasks();
}
}