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
    
 //public Flow.Interview.VPM_PurchasingRequestAdvanceForm  flBatch {get;set;}
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
 string ECCType ='';
 Boolean BlockDelete =false;
 
 string URl='';
   //   System.debug('Piyush----@@@flBatch '+flBatch );
 /*if(flBatch != null) {
 try{
     reDirect = string.valueOf(flBatch.getVariableValue('vpm_redirecttolaunchvar')); 
     strTemp = string.valueOf(flBatch.getVariableValue('VPM_PurchasingRequestID'));
     VPM_PurchasingRequests__c p1 = [select VPM_CompanyCode__r.ECC__c from VPM_PurchasingRequests__c where id=:strTemp limit 1];
     ECCType =p1.VPM_CompanyCode__r.ECC__c;
    
     system.debug('@@ blockDelete' + BlockDelete);
     System.debug('Piyush---@@@reDirect-'+reDirect);
     system.debug('@@ ECC type' + ECCType);
      //BlockDelete = boolean.valueOf(flBatch.getVariableValue('VPM_BlockDeleteScreenVar')); 
     if(reDirect == 'Create')
     {
          Url='/apex/VPM_GoldenData1?ID='+ strTemp;
     }
     else if(reDirect == 'Maintain' && ECCType =='Fusion' ){
     
          Url='/apex/VPM_FusionGoldenData?ID='+strTemp;
     }
     else if(reDirect == 'Maintain' && ECCType =='Sirius' ){
     
         Url='/apex/VPM_SiriusGoldenData?ID='+strTemp;
     }
     else if(reDirect == 'Maintain' && ECCType =='Cordillera' ){
         Url='/apex/VPM_CordilleraGoldenData?ID='+strTemp;
     }
     else if(reDirect == 'Maintain' && ECCType =='U2K2'){
         Url='/apex/VPM_U2K2GoldenData?ID='+strTemp;
     }
     else
     {
          Url='/'+ strTemp;                             
     }
     }
     catch (exception ex){}
 
 }*/
 system.debug('Piyush  ---@@URL' +URL);
 return URl;
 }
 set { strOutputVariable = value; }
 }
}