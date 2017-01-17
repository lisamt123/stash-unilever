/**
 * Name:        -   SAFE_SolutionsTabBPSec_Test
 * @description -   This is the test class for SAFE_SolutionsTabBPSec_CC Controller to verify the code  while Viewing Risk assessment list and submitting Questions. 
 * @Author      -   Sunay Prasad, Mindtree Ltd     
 */
@isTest
public with sharing class SAFE_SolutionsTabBPSec_Test{
    
    public static SAFE_Solutions__c solution = new SAFE_Solutions__c();
    public static ApexPages.StandardController sc = new ApexPages.StandardController(solution);
    public static SAFE_SolutionsTabBPSec_CC solutionCC = new SAFE_SolutionsTabBPSec_CC(sc);
    
    public static testmethod void methodone(){
        solutionCC.getsolutionList();
        solutionCC.Firstbtn();
        solutionCC.prvbtn();
        solutionCC.Nxtbtn();
        solutionCC.lstbtn();
        solutionCC.getNxt();
        solutionCC.getPrv();
        solutionCC.createSolution();
        solutionCC.insertSolution();
        solutionCC.actionPerform = 'edit';
        solutionCC.insertSolution();
        solutionCC.actionPerform = 'clone';
        solutionCC.insertSolution();
        solutionCC.backToSolutionsList();
        
        solution = new SAFE_Solutions__c(Name='Sample Solution');
        insert solution;
        //solutionCC.solutionId = solution.Id;
        ApexPages.currentPage().getParameters().put('solutionId',solution.Id);
        solutionCC.actionPerform = 'edit';
        solutionCC.editSolution();
        solutionCC.cloneSolution();
        solutionCC.showPopup();
        solutionCC.closePopup();
        solutionCC.deleteSolution();
        solutionCC.cancelSolution();
        solution = new SAFE_Solutions__c(Name='Sample Solution1');
        insert solution;
        ApexPages.currentPage().getParameters().put('solutionId',solution.Id);
        solutionCC.viewSolutionRecord();
    }
}