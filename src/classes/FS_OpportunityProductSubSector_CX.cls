public with sharing class FS_OpportunityProductSubSector_CX {
Public List<SelectOption> listSubSector_Picklist {get;set;}
    Public String selectedSubSector {get;set;}
    Public Boolean refreshPage {get;set;}
    Private opportunity opp_Record;
    Private Opportunity opp;
    Public Apexpages.StandardController stndrdController;
    //Private Set<String> listValues=new Set<String>();
    Public FS_OpportunityProductSubSector_CX(Apexpages.StandardController stdController){     
        refreshPage=false;
        stndrdController=stdController;
        opp_Record=(Opportunity)stdController.getRecord();
        opp=[select id,FS_Sub_Sector__c from Opportunity where id=:opp_Record.Id];
        selectedSubSector=opp.FS_Sub_Sector__c;
    }    
    Public pagereference autorun(){
        Schema.DescribeFieldResult picklist_Detail= Product2.SubSector__c.getDescribe();        
        listSubSector_Picklist=new List<SelectOption>();        
        For(Schema.PicklistEntry picklistEntry : picklist_Detail.getPicklistValues()){
        listSubSector_Picklist.add(new SelectOption(picklistEntry.getValue(),picklistEntry.getLabel()));        
        }       
       return null;
    }    
    Public pagereference updateSubSector(){     
      opp_Record.FS_Sub_Sector__c=selectedSubSector;
      stndrdController.save();
      refreshPage=true;
      //update opportunity record;          
      return null;
    }
}