/*********************************************************************************
Name:  flowController 
Copyright ? 2016  Unilever
==================================================================================
==================================================================================
Purpose:  For Dynamically setting the Finish loaction  for Golden data Screen 
-------                                                             
===================================================================================
===================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
1.0 -   Samrin Shaikh       12/05/2016       INITIAL DEVELOPMENT     Dynamically setting finish loaction for Golden data Screen  

***********************************************************************************/


public class flowController{
// Instanciate the Flow for use by the Controller - linked by VF "interview" attribute
 
     //variable to check if record is create/ maintain
     // public Boolean isCreate {get;set;}
    
    public flowController(ApexPages.StandardController stdController) {
    }
    
 public Flow.Interview.VPM_PurchasingRequestAdvanceForm  flBatch {get;set;}
 // Factor your PageReference as a full GET/SET
 public PageReference prFinishLocation {
 get {
 PageReference prRef = new PageReference(strOutputVariable);
 prRef.setRedirect(true);
 return prRef;
 }
 set { prFinishLocation = value; }
 }
 // Factor your Flow output variable pull as a full GET / SET
 public String strOutputVariable {
 get {
 String strTemp = '';
 String reDirect = ''; 
 string LaunchAction ='';
 string Action ='';
 
 string URl='';    
 if(flBatch != null) {
     reDirect = string.valueOf(flBatch.getVariableValue('vpm_redirecttolaunchvar')); 
     strTemp = string.valueOf(flBatch.getVariableValue('VPM_PurchasingRequestID'));
     System.debug('Alsana ----'+reDirect);
     if(reDirect == 'Create')
     {
          Url='/apex/VPM_GoldenData1?ID='+ strTemp;
     }
     else
     {
          Url='/'+ strTemp;                             
     }
 
 }
 return URl;
 }
 set { strOutputVariable = value; }
 }
}