@isTest
public class IPM_Gate_RollOuts_Controller_Test{

public static IPM_Project__c project;

static void initializeData()
{
 project=new IPM_Project__c();
 project.Name='CHECKREGIONALB_AFR';
 project.IPM_Phase__c='Feasibility';
 project.IPM_Complexity__c='Full';
 project.IPM_GateKeeping_Model__c='GCLT & RCLT'; 
 project.Sustainability_Period__c='3';
 project.IPM_Target_Launch_Dates__c=system.today();
 project.IPM_IsCompleted__c=true; 
 insert project;
}
public static testMethod void getIpm_countriesTest(){

Test.startTest();
initializeData();
IPM_Gate_RollOuts_Controller rollOutController = new IPM_Gate_RollOuts_Controller ();
//rollOutController.proId=project.Id;
rollOutController.getIpm_countries();
Test.stopTest();
}

}