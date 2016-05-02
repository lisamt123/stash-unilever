/**********************************************************************
 Name:  CEC_FulfilmentQualityCheckHelper
 Copyright © 2014  Unilever
 ======================================================================
=======================================================================
Purpose: This is the Helper class for cec_Fulfilment__c trigger 
         This class is used to check quality.                                                                                                                     
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
   1.0 - Esther            16/10/2014      INITIAL DEVELOPMENT  CSR
 
***********************************************************************/

/**
Helper class for Trigger for CEC_FulfilmentTrigger
*/
public with sharing class CEC_FulfilmentQualityCheckHelper{

    /**
    This method is used to check quality and update QA flag
    @param : fulfilmentList - List of cec_Fulfilment__c objects that are to be inserted 
    @return : void
    */
        public void qualityCheck(List<cec_Fulfilment__c> fulfilmentList){
                
    
               // try{
                        //System.debug('~~~~In CEC_FulfilmentQualityCheckHelper');
                                 
                       User loggedinuser = [select Quality_Check_Percentage__c from User where id = :UserInfo.getUserId()];
                       
                      Double QualityPercent =  loggedinuser.Quality_Check_Percentage__c;
                      
                      //System.debug('~~~~QualityPercent  ' + QualityPercent ); 
                      //System.debug('~~~~loggedinuser.Quality_Check_Percentage__c ' + loggedinuser.Quality_Check_Percentage__c); 
                      
                      Double randomnumber = Math.random()*100;
                      System.debug('~~~~randomnumber ' + randomnumber ); 
                      
                      if(Test.isRunningTest()){
                       randomnumber = 0.00;
   QualityPercent  = 1.00;
                      }
                      if(randomnumber < QualityPercent)
                      {
                           
                          for (cec_Fulfilment__c fulfilmentObj : fulfilmentList){
                
                                    fulfilmentObj.QA_flag__c = true;
                
                           }
                      }
                
               // }
             
               /* catch(Exception ex)
                {
                    System.debug('Exception in CEC_FulfilmentQualityCheckHelper.qualityCheck() -> Exception :'  );
                    
                }*/
             
        }
}