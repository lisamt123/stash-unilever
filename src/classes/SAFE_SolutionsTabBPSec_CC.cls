/**
 * Name:        -   SAFE_SolutionsTabBPSec_CC
 * @Description -   This Solution tab will display the list of solutions related to logged in user.
 * @Author      -   Sunay Prasad from Mindtree     
 */

public with sharing class SAFE_SolutionsTabBPSec_CC{

    public Boolean displayPopup {get;set;}
    public string userid {get; set;}
    integer totalRecs = 0;//By sibatri
    integer count= 0;//By sibatri
    integer limitSize= 5;//By sibatri
    public List<User> UserTemp = new List<User>();
    public Boolean showSolutionsList{get;set;}
    public SAFE_Solutions__c solution{get;set;}
    public Boolean showSolution{get;set;}
    public Boolean viewSolution{get;set;}
    public SAFE_Solutions__c solutionRecord{get; set;}
    public String solutionId{get;set;}
    public String actionPerform{get; set;}
    
    // To load data into the table
    public SAFE_SolutionsTabBPSec_CC(ApexPages.StandardController controller){
        totalRecs = [select count() from SAFE_Solutions__c ];
        solutionRecord = new SAFE_Solutions__c();
        userid = Userinfo.getUserId();       
        showSolutionsList = false;
    } 
    
    public List<SAFE_Solutions__c> getsolutionList(){
        List<SAFE_Solutions__c> solutionList = [SELECT Name,SAFE_Solution_Status__c,SAFE_Supplier_Name__c,SAFE_Solution_Type__c,
                                                SAFE_Solution_in_Use__c,SAFE_Solution_Category__c,SAFE_Price_Per_Unit__c,SAFE_Material_Type__c,
                                                Owner.name FROM SAFE_Solutions__c LIMIT:limitsize OFFSET:count]; 
        return solutionList;
    }
    
    /*Risk Assessments List as pagination implementation*/
    public PageReference Firstbtn() {
        count=0;
        return null;
    }
    
    /*Risk Assessments List as pagination implementation*/
    public PageReference prvbtn() {
        count=count-limitsize;
        return null;
    }
    
    /*Risk Assessments List as pagination implementation*/
    public PageReference Nxtbtn() {system.debug(count);
        count=count+limitsize;system.debug('limitsize'+limitsize);
        return null;
    }
    
    /*Risk Assessments List as pagination implementation*/
    public PageReference lstbtn() {
        count= totalrecs - math.mod(totalRecs,LimitSize);
        return null;
    }

    /*Risk Assessments List as pagination implementation*/
    public Boolean getNxt() {
    if((count+ LimitSize) > totalRecs)
        return true;
        else
        return false;
    }
    
    /*Risk Assessments List as pagination implementation*/
    public Boolean getPrv() {
        if(count== 0)
        return true;
        else
        return false;
    }      
    
    public pageReference createSolution(){
        solution = new SAFE_Solutions__c();
        System.CurrentPageReference().getParameters().get('showSolution');
        showSolution=true;
        return null;
    }
    
       
    /*Code to insert a solution record*/
    public pageReference insertSolution(){
              
       if(actionPerform=='edit'){system.debug('solution='+solution);
           solutionRecord = [Select Name,SAFE_Solution_Status__c,SAFE_Solution_Category__c,SAFE_Material_Type__c,SAFE_Solution_Type__c,
                                 SAFE_Price_Per_Unit__c,SAFE_Solution_in_Use__c,Owner.Name,SAFE_Geography_Deployed__c,SAFE_Brand_Deployed_To__c,
                                 SAFE_Benefits__c,SAFE_Description__c,SAFE_Contact_Name__c,SAFE_Contact_Address__c,SAFE_Contact_Phone__c,SAFE_Contact_Email__c,
                                 SAFE_Supplier_Name__c,SAFE_Supplier_Address__c,SAFE_Supplier_Phone__c,SAFE_Supplier_Email__c from SAFE_Solutions__c where Id = :solution.Id];    
           solutionRecord.Name=solution.Name;
           solutionRecord.SAFE_Solution_Status__c=solution.SAFE_Solution_Status__c;
           solutionRecord.SAFE_Solution_Category__c=solution.SAFE_Solution_Category__c;
           solutionRecord.SAFE_Material_Type__c=solution.SAFE_Material_Type__c;
           solutionRecord.SAFE_Solution_Type__c=solution.SAFE_Solution_Type__c;
           solutionRecord.SAFE_Price_Per_Unit__c=solution.SAFE_Price_Per_Unit__c;
           solutionRecord.SAFE_Solution_in_Use__c=solution.SAFE_Solution_in_Use__c;
           solutionRecord.SAFE_Geography_Deployed__c=solution.SAFE_Geography_Deployed__c;
           solutionRecord.SAFE_Brand_Deployed_To__c=solution.SAFE_Brand_Deployed_To__c;
           solutionRecord.SAFE_Benefits__c=solution.SAFE_Benefits__c;
           solutionRecord.SAFE_Description__c=solution.SAFE_Description__c;
           solutionRecord.SAFE_Contact_Name__c=solution.SAFE_Contact_Name__c;
           solutionRecord.SAFE_Contact_Address__c=solution.SAFE_Contact_Address__c;
           solutionRecord.SAFE_Contact_Phone__c=solution.SAFE_Contact_Phone__c;
           solutionRecord.SAFE_Contact_Email__c=solution.SAFE_Contact_Email__c;
           solutionRecord.SAFE_Supplier_Name__c=solution.SAFE_Supplier_Name__c;
           solutionRecord.SAFE_Supplier_Address__c=solution.SAFE_Supplier_Address__c;
           solutionRecord.SAFE_Supplier_Phone__c=solution.SAFE_Supplier_Phone__c;
           solutionRecord.SAFE_Supplier_Email__c=solution.SAFE_Supplier_Email__c;
           
           update solutionRecord;
           viewSolution = true;
       }
       else if(actionPerform=='clone'){
           //solutionRecord = new SAFE_Solution__c();
           solution.Id = null;
           insert solution;
           solutionRecord = solution;
           viewSolution = true;    
       }
       else{
           insert solution;
           //PageReference pageRef = new PageReference('/apex/SAFE_SolutionCreation?id='+solution.Id);
           viewSolution = true;
           solutionRecord = [Select id,Name,SAFE_Solution_Status__c,SAFE_Solution_Category__c,SAFE_Material_Type__c,SAFE_Solution_Type__c,
                             SAFE_Price_Per_Unit__c,SAFE_Solution_in_Use__c,Owner.Name,SAFE_Geography_Deployed__c,SAFE_Brand_Deployed_To__c,
                             SAFE_Benefits__c,SAFE_Description__c,SAFE_Contact_Name__c,SAFE_Contact_Address__c,SAFE_Contact_Phone__c,SAFE_Contact_Email__c,
                             SAFE_Supplier_Name__c,SAFE_Supplier_Address__c,SAFE_Supplier_Phone__c,SAFE_Supplier_Email__c from SAFE_Solutions__c where Id = :solution.Id];
       }
       
       //return pageRef; 
       return null;
    }
    
    public pageReference backToSolutionsList(){
        viewSolution = false;
        showSolution = false;
        return null;
    }
    
    public PageReference editSolution(){
        solutionId = System.CurrentPageReference().getParameters().get('solutionId');
        actionPerform = system.CurrentPageReference().getParameters().get('actionPerform');
        solution = [Select id,Name,SAFE_Solution_Status__c,SAFE_Solution_Category__c,SAFE_Material_Type__c,SAFE_Solution_Type__c,
                     SAFE_Price_Per_Unit__c,SAFE_Solution_in_Use__c,Owner.Name,SAFE_Geography_Deployed__c,SAFE_Brand_Deployed_To__c,
                     SAFE_Benefits__c,SAFE_Description__c,SAFE_Contact_Name__c,SAFE_Contact_Address__c,SAFE_Contact_Phone__c,SAFE_Contact_Email__c,
                     SAFE_Supplier_Name__c,SAFE_Supplier_Address__c,SAFE_Supplier_Phone__c,SAFE_Supplier_Email__c from SAFE_Solutions__c where Id = :solutionId]; 
        showSolution = true;
        viewSolution = false;
        
        return null;
    }
    
    public PageReference cloneSolution(){
        solutionId = System.CurrentPageReference().getParameters().get('solutionId');
        actionPerform = system.CurrentPageReference().getParameters().get('actionPerform');
        solution = [Select id,Name,SAFE_Solution_Status__c,SAFE_Solution_Category__c,SAFE_Material_Type__c,SAFE_Solution_Type__c,
                     SAFE_Price_Per_Unit__c,SAFE_Solution_in_Use__c,Owner.Name,SAFE_Geography_Deployed__c,SAFE_Brand_Deployed_To__c,
                     SAFE_Benefits__c,SAFE_Description__c,SAFE_Contact_Name__c,SAFE_Contact_Address__c,SAFE_Contact_Phone__c,SAFE_Contact_Email__c,
                     SAFE_Supplier_Name__c,SAFE_Supplier_Address__c,SAFE_Supplier_Phone__c,SAFE_Supplier_Email__c from SAFE_Solutions__c where Id = :solutionId]; 
        
        showSolution = true;
        viewSolution = false;
         
        return null;
    }
    
    public void showPopup(){        
        displayPopup = true;
        solutionId = System.CurrentPageReference().getParameters().get('solutionId');
    }
    
    public void closePopup(){        
        displayPopup = false;    
    } 
      
    public void deleteSolution(){
        showSolution = false;
        viewSolution = false;
        displayPopup = false;
        solution = [Select id,Name,SAFE_Solution_Status__c,SAFE_Solution_Category__c,SAFE_Material_Type__c,SAFE_Solution_Type__c,
                     SAFE_Price_Per_Unit__c,SAFE_Solution_in_Use__c,Owner.Name,SAFE_Geography_Deployed__c,SAFE_Brand_Deployed_To__c,
                     SAFE_Benefits__c,SAFE_Description__c,SAFE_Contact_Name__c,SAFE_Contact_Address__c,SAFE_Contact_Phone__c,SAFE_Contact_Email__c,
                     SAFE_Supplier_Name__c,SAFE_Supplier_Address__c,SAFE_Supplier_Phone__c,SAFE_Supplier_Email__c from SAFE_Solutions__c where Id = :solutionId];
        delete solution; 
    }
    
    public pageReference cancelSolution(){
        showSolution = false;
        viewSolution = false;
        return null;
    }
    
    public pageReference viewSolutionRecord(){
        solutionId = System.CurrentPageReference().getParameters().get('solutionId');
        
        solutionRecord = [Select id,Name,SAFE_Solution_Status__c,SAFE_Solution_Category__c,SAFE_Material_Type__c,SAFE_Solution_Type__c,
                     SAFE_Price_Per_Unit__c,SAFE_Solution_in_Use__c,Owner.Name,SAFE_Geography_Deployed__c,SAFE_Brand_Deployed_To__c,
                     SAFE_Benefits__c,SAFE_Description__c,SAFE_Contact_Name__c,SAFE_Contact_Address__c,SAFE_Contact_Phone__c,SAFE_Contact_Email__c,
                     SAFE_Supplier_Name__c,SAFE_Supplier_Address__c,SAFE_Supplier_Phone__c,SAFE_Supplier_Email__c from SAFE_Solutions__c where Id = :solutionId];
        showSolution = true;
        viewSolution = true;
        return null;
    }
     
}