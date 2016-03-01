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
     Public Integer Blendrate {get;set;}
     public Integer effortstotal {get;set;}
     public Integer costtotal {get;set;}
     public Integer expensetotal {get;set;}
     public Integer blendratetotal {get;set;}
     
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
    
    try {
    
           CPA_project_work_order__c PwoRs =  [Select Id,Name,num_Estimated_Value_of_PWO__c,num_Estimated_Man_days_of_PWO__c,num_Expense_charges_of_work_order__c From CPA_project_work_order__c Where Id=:pwoId];
          system.debug('Test'+PwoRs);
           if(PwoRs !=null) {
            PwoObjList.add(PwoRs);
            if(Integer.valueOf(PwoRs.num_Expense_charges_of_work_order__c) !=null && Integer.valueOf(PwoRs.num_Estimated_Man_days_of_PWO__c) !=null) {
                Blendrate = Integer.valueOf(PwoRs.num_Expense_charges_of_work_order__c)/Integer.valueOf(PwoRs.num_Estimated_Man_days_of_PWO__c);
            }
               if(Integer.valueOf(PwoRs.num_Estimated_Man_days_of_PWO__c) !=null){
                effortstotal += Integer.valueOf(PwoRs.num_Estimated_Man_days_of_PWO__c);
                }
              if(Integer.valueOf(PwoRs.num_Expense_charges_of_work_order__c) !=null){ 
                    costtotal += Integer.valueOf(PwoRs.num_Expense_charges_of_work_order__c);
              }
              if(Integer.valueOf(PwoRs.num_Estimated_Man_days_of_PWO__c) !=null){ 
                    expensetotal += Integer.valueOf(PwoRs.num_Estimated_Man_days_of_PWO__c);
              }
                blendratetotal+=Blendrate;
            
            List<CPA_CR__c> listCr = getCrList(pwoId);
            Integer i=1;
            for(CPA_CR__c rs:listCr) {
                 innerCrObj.add(new InnerCrList(i));
                 innerCrObj[i-1].name = rs.Name;
                 innerCrObj[i-1].efforts = Integer.valueOf(rs.num_Estimated_Man_days_of_CR__c);
                 innerCrObj[i-1].totalcost = Integer.valueOf(rs.num_Total_charge_of_CR__c);
                 innerCrObj[i-1].expense = Integer.valueOf(rs.num_Expense_charges_of_CR__c);
                    if(Integer.valueOf(rs.num_Total_charge_of_CR__c) !=null && Integer.valueOf(rs.num_Estimated_Man_days_of_CR__c) !=null) {
                         innerCrObj[i-1].BlendRate=Integer.valueOf(rs.num_Total_charge_of_CR__c)/Integer.valueOf(rs.num_Estimated_Man_days_of_CR__c);
                         blendratetotal+=innerCrObj[i-1].BlendRate;
                    }
                if(Integer.valueOf(rs.num_Estimated_Man_days_of_CR__c) !=null){    
                    effortstotal += Integer.valueOf(rs.num_Estimated_Man_days_of_CR__c);
                }
                if(Integer.valueOf(rs.num_Total_charge_of_CR__c) !=null){ 
                    costtotal += Integer.valueOf(rs.num_Total_charge_of_CR__c);
                }
                if(Integer.valueOf(rs.num_Expense_charges_of_CR__c) !=null){ 
                    expensetotal += Integer.valueOf(rs.num_Expense_charges_of_CR__c);
                }
                
              i++;   
            }
            
           }
        }catch (Exception e){
        
            system.debug('Error'+e.getMessage());
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
         try{
          crList =[Select Id,Name,num_Estimated_Man_days_of_CR__c,num_Total_charge_of_CR__c,num_Expense_charges_of_CR__c From CPA_CR__c Where CPA_Project_Work_Order__c =:Id];
          system.debug('crList'+crList);
          if(crList.size() > 0) {
           return crList;
          }
          
         }catch(Exception e) {
            system.debug('Error'+e.getMessage());
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
        public Integer efforts {get;set;}
        public Integer totalcost {get;set;}
        public Integer expense {get;set;}
        public Integer BlendRate{get;set;}
        public Integer recCount {get;set;}
        
        public InnerCrList(Integer recCount) {
            this.recCount =recCount;
        }
    }
    
}