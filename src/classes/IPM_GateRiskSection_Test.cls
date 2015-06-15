@isTest
public class IPM_GateRiskSection_Test{


public static IPM_Questionnaire__c questionaire;
public static IPM_Project__c project;
public static ID testpos;

static testMethod void initializeData()
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
       questionaire= new  IPM_Questionnaire__c();
       questionaire.IPM_HelpText_Yes__c='Less';
       questionaire.IPM_HelpText_No__c='3';
       questionaire.IPM_HelpText_Partly__c='4';
       questionaire.IPM_Question__c='Investment Risk';
       questionaire.IPM_Project__c= project.Id;
       insert questionaire;
       
       testpos=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('POS Questionnaire').RecordTypeId;
    }

public static testMethod void rmpPlanTest(){

Test.startTest();
initializeData();
IPM_GateRiskSection.recTypeIDPOS=testpos;
IPM_GateRiskSection ipm_gaterisksection1 = new IPM_GateRiskSection();

ipm_gaterisksection1.projectId=project.id;
ipm_gaterisksection1.quesId=questionaire.id;
ipm_gaterisksection1.projDocType='Contract';
ipm_gaterisksection1.rmpPlan();
ipm_gaterisksection1.saveComment();
Test.stopTest();
}
}