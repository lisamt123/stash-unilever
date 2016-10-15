/* * Extension class FS_Product_Sector_Picklist_CX for Centrally Led visualforce page
*  @name FS_Product_Sector_Picklist_CX
*  @param 
*  @return 
*  @throws 
*/
public with sharing class FS_RiskProductSubSector_CX {
 Public List<SelectOption> listSubSector_Picklist {get;set;}
    Public String selectedSubSector {get;set;}
    Public Boolean refreshPage {get;set;}
    Private Risk__c risk_Record;
    Private Risk__c risk;
    Public Apexpages.StandardController stndrdController;
    //Private Set<String> listValues=new Set<String>();
    Public FS_RiskProductSubSector_CX(Apexpages.StandardController stdController){     
        refreshPage=false;
        stndrdController=stdController;
        risk_Record=(Risk__c)stdController.getRecord();
        risk=[select id,FS_Sub_Sector__c from Risk__c where id=:risk_Record.Id];
        selectedSubSector=risk.FS_Sub_Sector__c;
    }    
    Public pagereference autorun(){
        Schema.DescribeFieldResult picklist_Detail= Product2.SubSector__c.getDescribe();        
        listSubSector_Picklist=new List<SelectOption>();        
        For(Schema.PicklistEntry picklistEntry : picklist_Detail.getPicklistValues()){
        listsubSector_Picklist.add(new SelectOption(picklistEntry.getValue(),picklistEntry.getLabel()));
        //listValues.add(picklistEntry.getValue());
        }
       //system.debug(listValues);
       return null;
    }    
    Public pagereference updateSubSector(){
      //risk_Record=(Risk__c)stndrdController.getRecord();
      risk_Record.FS_Sub_Sector__c=selectedSubSector;
      stndrdController.save();
      refreshPage=true;
      //update risk_Record;          
      return null;
    }   
}