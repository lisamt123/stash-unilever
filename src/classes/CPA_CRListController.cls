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
VERSION     AUTHOR        DATE            DETAIL Description
1.0         Name          01/01/2016     INITIAL DEVELOPMENT CSR:
1.1         Shreyas M     20/03/2016     Changes for Blend Rate
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
           decimal TotalCosetBlendrate = 0; 
           decimal TotalResourse = 0;
           CPA_project_work_order__c PwoRs =  [Select Id,Name,num_Estimated_Value_of_PWO__c,num_Expense_charges_of_work_order__c,num_Estimated_Man_days_of_PWO__c,num_Total_work_order_charge__c,num_Effort_Cost__c From CPA_project_work_order__c Where Id=:pwoId];
         
           if(PwoRs !=null) {
            PwoObjList.add(PwoRs);
            
                
            if( PwoRs.num_Effort_Cost__c !=null &&  PwoRs.num_Estimated_Man_days_of_PWO__c !=null &&  PwoRs.num_Estimated_Man_days_of_PWO__c>0) {
                Blendrate1 = Blendrate =  PwoRs.num_Effort_Cost__c / PwoRs.num_Estimated_Man_days_of_PWO__c;
                TotalCosetBlendrate = TotalCosetBlendrate + (PwoRs.num_Estimated_Man_days_of_PWO__c * Blendrate);
                TotalResourse = TotalResourse + PwoRs.num_Estimated_Man_days_of_PWO__c;
            }
               if( PwoRs.num_Estimated_Man_days_of_PWO__c !=null){
                effortstotal +=  PwoRs.num_Estimated_Man_days_of_PWO__c;
                }
              if( PwoRs.num_Estimated_Value_of_PWO__c !=null){ 
                    costtotal +=  PwoRs.num_Estimated_Value_of_PWO__c;
              }
              if( PwoRs.num_Expense_charges_of_work_order__c !=null){ 
                    expensetotal +=  PwoRs.num_Expense_charges_of_work_order__c;
              }
                blendratetotal+=Blendrate;
            
            List<CPA_CR__c> listCr = getCrList(pwoId);
            Integer i=1;
            
            for(CPA_CR__c rs:listCr) {
                
                 innerCrObj.add(new InnerCrList(i));
                 innerCrObj[i-1].name = rs.Name;
                 innerCrObj[i-1].efforts =  rs.num_Total_Resource_Efforts_CR__c;
                 innerCrObj[i-1].totalcost =  rs.num_Total_charge_of_CR__c;
                 innerCrObj[i-1].expense =  rs.num_Total_Expenses_of_CR__c;
                    if( rs.num_Total_charge_of_CR__c !=null &&  rs.num_Total_Resource_Efforts_CR__c !=null &&  rs.num_Total_Resource_Efforts_CR__c>0) {
                        // Blendrate1 = innerCrObj[i-1].BlendRate= rs.num_Varied_Target_Blend_Rate__c;
                        Blendrate1 = innerCrObj[i-1].BlendRate=rs.num_Effort_Cost__c / rs.num_Total_Resource_Efforts_CR__c;
                         blendratetotal+=innerCrObj[i-1].BlendRate;
                         TotalCosetBlendrate = TotalCosetBlendrate + (innerCrObj[i-1].BlendRate *rs.num_Total_Resource_Efforts_CR__c);
                    }
                if( rs.num_Total_Resource_Efforts_CR__c !=null){    
                    effortstotal +=  rs.num_Total_Resource_Efforts_CR__c;
                    TotalResourse = TotalResourse + rs.num_Total_Resource_Efforts_CR__c;
                }
                if( rs.num_Total_charge_of_CR__c !=null){ 
                    costtotal +=  rs.num_Total_charge_of_CR__c;
                }
                 if( rs.num_Effort_Cost__c !=null){ 
                    totalBlendrate +=  rs.num_Effort_Cost__c;
                    
                }
                if( rs.num_Total_Expenses_of_CR__c !=null){ 
                    expensetotal +=  rs.num_Total_Expenses_of_CR__c;
                }
                if(rs.pkl_Status__c != CPA_ConstantsForContractingAppClasses.SAVED && rs.pkl_Status__c != CPA_ConstantsForContractingAppClasses.CANCELLED && rs.pkl_Status__c != CPA_ConstantsForContractingAppClasses.RETURNED ){
                    countOFCR = countOFCR+1;
                }
                
              i++;   
            }
            
           }
           if(blendratetotal!= null && TotalCosetBlendrate !=null && TotalCosetBlendrate >0 && blendratetotal>0){
           blendratetotal = TotalCosetBlendrate/TotalResourse;
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
      
          crList =[Select Id,Name,num_Estimated_Man_days_of_CR__c,num_Effort_Cost__c,num_Total_charge_of_CR__c,pkl_Status__c,num_Expense_charges_of_CR__c,num_Total_Resource_Efforts_CR__c,num_Total_Expenses_of_CR__c,num_Varied_Target_Blend_Rate__c From CPA_CR__c Where CPA_Project_Work_Order__c =:Id ];
          
          if(crList.size() > 0) {
          List<CPA_CR__c >lstTemp = new List<CPA_CR__c >();
            for(CPA_CR__c objCR :crList ){
                if(objCR.pkl_Status__c == null || objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.CANCELLED || objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.RETURNED ){
                    objCR.num_Effort_Cost__c = 0;
                    objCR.num_Total_Expenses_of_CR__c = 0;
                    objCR.num_Total_Resource_Efforts_CR__c = 0;   
                    objCR.num_Total_charge_of_CR__c =0; 
                    objCR.num_Varied_Target_Blend_Rate__c =0;
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