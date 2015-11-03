/** 
    About
    -----
    Description: Class Oblix_Ctrl04Bis_OverrideOtherItemsNews
    Created for: Oblix Unilever Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : Used as a  class to Override New/Edit of Other Items
                        
            Functionnalities : 
                    
    Update History
    --------------    
*/   
public with sharing class Oblix_Ctrl04Bis_OverrideOtherItemsNews {
    private List<Oblix_Calculator__c> lstCalculatorRate = new List<Oblix_Calculator__c>();
    public Marketing_Basics__c OItem {get;set;}
    public String fYear {get;set;}
    public String agency {get;set;}
    public String rtResourceId {get;set;}
    public String rtActivityId {get;set;}
    
    public String selectedAgencyDepartment{get;set;}
    public String selectedRoleTitle{get;set;}

    
    private Marketing_SOW__c parentSow = new Marketing_SOW__c();
    public set<String> setAgencyDept {get;set;}
    public set<String> setRoleTitle {get;set;}
    public Boolean isroledisabled {get;set;}
    public Boolean isAgencydisabled {get;set;}
     
    public Oblix_Ctrl04Bis_OverrideOtherItemsNews(ApexPAges.StandardController controller){
         if(!System.Test.isRunningTest()){
             controller.addFields(new List<String>{'OblixCountry__c','Activities__c','RecordType.Name','Oblix_SOWMarketing__c','Description__c', 'FTE__c', 'No_of_Hours_Required__c', 'Name', 'Id', 'RecordTypeId'});
         }
         rtResourceId = Oblix_Utils.MapRecordType('Marketing_Basics__c').get('Resource');
         rtActivityId = Oblix_Utils.MapRecordType('Marketing_Basics__c').get('Activity');
         setAgencyDept = new set<String>();
         setRoleTitle = new set<String>();
         isAgencydisabled = true;
         isroledisabled = true;
          
        this.OItem = (Marketing_Basics__c) controller.getRecord();
        
        if(OItem.Id == null){
            rtResourceId = rtResourceId.substring(0, 15);
            rtActivityId = rtActivityId.substring(0, 15);
        }
        
        System.debug('###OItem : '+OItem);
        System.debug('###rtResourceId : '+rtResourceId);
        System.debug('###rtActivityId : '+rtActivityId);//Discipline__c
        
        if(OItem.Oblix_SOWMarketing__c != null){
             parentSow = [Select Id, Name, Financial_Year__c, Marketing_Agency__c, Oblix_AgencyEstimate__r.Name, Oblix_AgencyEstimate__c from Marketing_SOW__c where id =:OItem.Oblix_SOWMarketing__c];
            System.debug('###parentSow : '+parentSow);
            fYear = parentSow.Financial_Year__c;
            agency = parentSow.Oblix_AgencyEstimate__r.Name;
        }
        
        /*
        lstCalculatorRate = [Select Id, Name, RecordTypeId, Role_Daily_Rate_EUR__c, Agency_Department__c,  OblixCountry__r.Name, Oblix_Agency__c,
                    Role_Title__c, FTE__c, OblixCountry__c from Oblix_Calculator__c where Financial_Year__c=: fYear and 
                RecordTypeId =: Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Role_Rate') and Oblix_Agency__c =: parentSow.Oblix_AgencyEstimate__c Limit 1];
        System.debug('###lstCalculatorRate : '+lstCalculatorRate);
        */
    }
     
     public void reRenderSOW(){
         parentSow = [Select Id, Name, Financial_Year__c, Marketing_Agency__c, Oblix_AgencyEstimate__r.Name, Oblix_AgencyEstimate__c from Marketing_SOW__c where id =:OItem.Oblix_SOWMarketing__c];
            System.debug('###parentSow : '+parentSow);
            fYear = parentSow.Financial_Year__c;
            agency = parentSow.Oblix_AgencyEstimate__r.Name;
     }
     
     public void reRenderAgencyDepartments(){
            lstCalculatorRate = [Select Id, Name, RecordTypeId, Role_Daily_Rate_EUR__c, Agency_Department__c,  OblixCountry__r.Name, Oblix_Agency__c,
                    Role_Title__c, FTE__c, OblixCountry__c from Oblix_Calculator__c where Financial_Year__c=: fYear and OblixCountry__c =: OItem.OblixCountry__c and
                RecordTypeId =: Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Role_Rate') and Oblix_Agency__c =: parentSow.Oblix_AgencyEstimate__c ];
                setAgencyDept = new set<String>();
                if(!lstCalculatorRate.isEmpty()){
                    for(Oblix_Calculator__c calc : lstCalculatorRate){
                        setAgencyDept.add(calc.Agency_Department__c);
                    }
                }
                isAgencydisabled = false;
                getAgencyDepartment();  
     }
     
     public void reRenderRoleTitle(){
            lstCalculatorRate = [Select Id, Name, RecordTypeId, Role_Daily_Rate_EUR__c, Agency_Department__c,  OblixCountry__r.Name, Oblix_Agency__c,
                    Role_Title__c, FTE__c, OblixCountry__c from Oblix_Calculator__c where Financial_Year__c=: fYear and OblixCountry__c =: OItem.OblixCountry__c and
                RecordTypeId =: Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Role_Rate') and Oblix_Agency__c =: parentSow.Oblix_AgencyEstimate__c and Agency_Department__c =:selectedAgencyDepartment];
            setRoleTitle = new set<String>();       
            if(!lstCalculatorRate.isEmpty()){
                    for(Oblix_Calculator__c calc : lstCalculatorRate){
                        setRoleTitle.add(calc.Role_Title__c);
                    }
                }
            isroledisabled = false;                         
            getRoleTitle(); 
     }
     
     
     public List<SelectOption> getAgencyDepartment(){
        
         List<SelectOption> options= new List<SelectOption>();
           options.add(new SelectOption('', 'None'));
            if(setAgencyDept != null && !setAgencyDept.isEmpty()){
                for(String roleRate : setAgencyDept){
                    if(roleRate != null){
                        options.add(new SelectOption(roleRate, roleRate));  
                    }
                }
            }
                
           if(options.size()>1) { isroledisabled = false;  }
            return options;
     }
     
     public List<SelectOption> getRoleTitle(){
        
         List<SelectOption> options= new List<SelectOption>();
          options.add(new SelectOption('', 'None'));
            if(setRoleTitle != null && !setRoleTitle.isEmpty()){
                for(String role : setRoleTitle){
                     if(role != null){
                        options.add(new SelectOption(role, role));
                    }
                }
            }
            return options;
     }
     
    public PageReference save(){
        try{
            if(OItem.RecordTypeId == Oblix_Utils.MapRecordType('Marketing_Basics__c').get('Resource') && !lstCalculatorRate.IsEmpty() && lstCalculatorRate.size()>0 && OItem.FTE__c != null && OItem.FTE__c > 0){
                OItem.OblixOtherItemFee__c = lstCalculatorRate[0].FTE__c/OItem.FTE__c; 
            }else{
                OItem.OblixOtherItemFee__c = lstCalculatorRate[0].FTE__c;
            }
            if(OItem.RecordTypeId == Oblix_Utils.MapRecordType('Marketing_Basics__c').get('Activity') && !lstCalculatorRate.IsEmpty() && lstCalculatorRate.size()>0 && OItem.No_of_Hours_Required__c != null && lstCalculatorRate[0].Role_Daily_Rate_EUR__c != null){
                OItem.OblixOtherItemFee__c = lstCalculatorRate[0].Role_Daily_Rate_EUR__c * OItem.No_of_Hours_Required__c;
            }else{
                OItem.OblixOtherItemFee__c = 0;
            }
            //OItem.Discipline__c = selectedDiscipline;
            OItem.Agency_Department__c = selectedAgencyDepartment;
            OItem.Role_Title__c = selectedRoleTitle;
            
            if(OItem.Id != null){
                update OItem;
            }else{
                insert OItem;
            }
            return new PageReference('/'+OItem.Id);
            
        }catch(DmlException e){
            System.debug('###Exception Occured :'+e.getMessage());  
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error Occured during save please review data entry'));
        }
        return null;
    }
}