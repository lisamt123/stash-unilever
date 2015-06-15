@isTest
public class IPM_Gate_Milestones_Test{

public static IPM_Gate_Milestones gateMilestones;
public static IPM_Project__c project;
public static IPM_Milestone mileStone;
//ApexPages.StandardController controller { get; set; }
//public ID recordtypeId;

static testMethod void initializeData()
{

 project=new IPM_Project__c();
 project.Name='CHECKREGIONALB_AFR';
 project.IPM_Phase__c='Ideas';
 project.IPM_Complexity__c='Full';
 project.IPM_GateKeeping_Model__c='RCLT'; 
 project.Sustainability_Period__c='3';
 project.IPM_Target_Launch_Dates__c=system.today();
 project.IPM_IsCompleted__c=true; 
 insert project;
 
 //controller= new ApexPages.StandardController();
 /*mileStone=new IPM_Milestone(controller );
 mileStone.IPM_Name__c='Charter Gate Approval';
 mileStone.IPM_Completed__c='true';
 mileStone.IPM_Due_Date__c=date.newInstance(2019, 5, 31);
 mileStone.IPM_Completed_On__c=system.today();
 mileStone.IPM_phase__c='Ideas';
 mileStone.IPM_Project__c =project.id;
 insert mileStone;*/
 
 //recordtypeId=IPM_Utils.getMilestoneRecordType('IPM Project Milestones') ;

} 

public static testMethod void showMilestonesTest(){
Test.startTest();
try{
gateMilestones= new IPM_Gate_Milestones();
//gateMilestones.projectId=project.id;
gateMilestones.showMilestones();
}catch(Exception e){
}
Test.stopTest();
}

}