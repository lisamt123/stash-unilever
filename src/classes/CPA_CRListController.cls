/**********************************************************************
Name: CPA_CRListController()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This controller is used to over rid the new CR button, open the custom page and show only relevant 
Record types.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_CRListController { 
    
     public  CPA_project_work_order__c PwoObj{get;set;}
     public  List<CPA_project_work_order__c> PwoObjList{get;set;}
     public List<InnerCrList> innerCrObj {get;set;}
     Public String pwoId {get;set;}
     Public decimal Blendrate {get;set;}
     public decimal effortstotal {get;set;}
     public decimal costtotal {get;set;}
     public decimal expensetotal {get;set;}
     public decimal blendratetotal {get;set;}
     public decimal totalBlendrate {get;set;}
     public decimal Blendrate1 {get;set;}
     
    /*******************************************************************
    Purpose: This constructor will be called from VF page
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_CRListController(ApexPages.StandardController stdController) {
         this.PwoObj = (CPA_project_work_order__c)stdController.getRecord();
            pwoId = this.PwoObj.Id;
            PwoObjList = new List<CPA_project_work_order__c>();
           
            innerCrObj = new List<InnerCrList>();
            Blendrate = 0;
            effortstotal =0;
            costtotal=0;
            expensetotal=0;
            blendratetotal =0;
            totalBlendrate = 0;
            Blendrate1 = 0;
            getPwoList();
        }
    
    
    /*
     * Justification: Based on different values, we are doing commercials calculations, hence we need multiple if conditions 
     * here.
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     * Dev team will fix this in next release.
     */
    /*******************************************************************
    Purpose: This method gives the PWO list
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public  void  getPwoList() {
    
            integer countOFCR =1;
    
           CPA_project_work_order__c PwoRs =  [Select Id,Name,num_Estimated_Value_of_PWO__c,num_Expense_charges_of_work_order__c,num_Estimated_Man_days_of_PWO__c,num_Total_work_order_charge__c,num_Effort_Cost__c From CPA_project_work_order__c Where Id=:pwoId];
         
           if(PwoRs !=null) {
            PwoObjList.add(PwoRs);
            if(Integer.valueOf(PwoRs.num_Effort_Cost__c) !=null && Integer.valueOf(PwoRs.num_Estimated_Man_days_of_PWO__c) !=null && Integer.valueOf(PwoRs.num_Estimated_Man_days_of_PWO__c)>0) {
                Blendrate1 = Blendrate = Integer.valueOf(PwoRs.num_Effort_Cost__c) /Integer.valueOf(PwoRs.num_Estimated_Man_days_of_PWO__c);
            }
               if(Integer.valueOf(PwoRs.num_Estimated_Man_days_of_PWO__c) !=null){
                effortstotal += Integer.valueOf(PwoRs.num_Estimated_Man_days_of_PWO__c);
                }
              if(Integer.valueOf(PwoRs.num_Total_work_order_charge__c) !=null){ 
                    costtotal += Integer.valueOf(PwoRs.num_Total_work_order_charge__c);
              }
              if(Integer.valueOf(PwoRs.num_Expense_charges_of_work_order__c) !=null){ 
                    expensetotal += Integer.valueOf(PwoRs.num_Expense_charges_of_work_order__c);
              }
                blendratetotal+=Blendrate;
            
            List<CPA_CR__c> listCr = getCrList(pwoId);
            Integer i=1;
            
            for(CPA_CR__c rs:listCr) {
                
                 innerCrObj.add(new InnerCrList(i));
                 innerCrObj[i-1].name = rs.Name;
                 innerCrObj[i-1].efforts = Integer.valueOf(rs.num_Total_Resource_Efforts_CR__c);
                 innerCrObj[i-1].totalcost = Integer.valueOf(rs.num_Total_charge_of_CR__c);
                 innerCrObj[i-1].expense = Integer.valueOf(rs.num_Total_Expenses_of_CR__c);
                    if(Integer.valueOf(rs.num_Total_charge_of_CR__c) !=null && Integer.valueOf(rs.num_Total_Resource_Efforts_CR__c) !=null && Integer.valueOf(rs.num_Total_Resource_Efforts_CR__c)>0) {
                         Blendrate1 = innerCrObj[i-1].BlendRate=Integer.valueOf(rs.num_Effort_Cost__c)/Integer.valueOf(rs.num_Total_Resource_Efforts_CR__c);
                         blendratetotal+=innerCrObj[i-1].BlendRate;
                    }
                if(Integer.valueOf(rs.num_Total_Resource_Efforts_CR__c) !=null){    
                    effortstotal += Integer.valueOf(rs.num_Total_Resource_Efforts_CR__c);
                }
                if(Integer.valueOf(rs.num_Total_charge_of_CR__c) !=null){ 
                    costtotal += Integer.valueOf(rs.num_Total_charge_of_CR__c);
                }
                 if(Integer.valueOf(rs.num_Effort_Cost__c) !=null){ 
                    totalBlendrate += Integer.valueOf(rs.num_Effort_Cost__c);
                }
                if(Integer.valueOf(rs.num_Total_Expenses_of_CR__c) !=null){ 
                    expensetotal += Integer.valueOf(rs.num_Total_Expenses_of_CR__c);
                }
                if(rs.pkl_Status__c != CPA_ConstantsForContractingAppClasses.SAVED && rs.pkl_Status__c != CPA_ConstantsForContractingAppClasses.CANCELLED && rs.pkl_Status__c != CPA_ConstantsForContractingAppClasses.RETURNED ){
                    countOFCR = countOFCR+1;
                }
                
              i++;   
            }
            
           }
           if(effortstotal!= null && totalBlendrate !=null && totalBlendrate >0 && effortstotal>0){
           blendratetotal = blendratetotal/countOFCR;
      }
    }
    
    /*******************************************************************
    Purpose: This method gives the CR list
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public List<CPA_CR__c> getCrList(String Id) {
          List<CPA_CR__c> crList = new List<CPA_CR__c>();
      
          crList =[Select Id,Name,num_Estimated_Man_days_of_CR__c,num_Effort_Cost__c,num_Total_charge_of_CR__c,pkl_Status__c,num_Expense_charges_of_CR__c,num_Total_Resource_Efforts_CR__c,num_Total_Expenses_of_CR__c From CPA_CR__c Where CPA_Project_Work_Order__c =:Id ];
          
          if(crList.size() > 0) {
          List<CPA_CR__c >lstTemp = new List<CPA_CR__c >();
            for(CPA_CR__c objCR :crList ){
                if(objCR.pkl_Status__c == null || objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.CANCELLED || objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.RETURNED ){
                    objCR.num_Effort_Cost__c = 0;
                    objCR.num_Total_Expenses_of_CR__c = 0;
                    objCR.num_Total_Resource_Efforts_CR__c = 0;   
                    objCR.num_Total_charge_of_CR__c =0;             
                }
                lstTemp.add(objCR);
            }
           return lstTemp;
          }
          
        
        return new List<CPA_CR__c>();
    }
     
    /*******************************************************************
    Purpose: This is the inner class, wrapper for CR list
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public class InnerCrList {
    
        public String name {get;set;}
        public decimal efforts {get;set;}
        public decimal totalcost {get;set;}
        public decimal expense {get;set;}
        public decimal BlendRate{get;set;}
        public decimal recCount {get;set;}
        public decimal blendratetotal{get;set;}
        
        public InnerCrList(Integer recCount) {
            this.recCount =recCount;
        }
    }
    
}