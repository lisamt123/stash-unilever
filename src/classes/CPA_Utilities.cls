/********************************************************************
 Name:  CPA_Utilities()
 Copyright © 2015  Unilever
 ======================================================
======================================================
Purpose:  This class handles Saves and Deletes functionality.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE              DETAIL                 Description
   1.0   Shreyas Mangalvedhekar      03/04/2015        INITIAL DEVELOPMENT           
***********************************************************************/

//public without sharing class CPA_Utilities {
public with sharing class CPA_Utilities {
    
    /*******************************************************************
    Purpose: This method is used to Commit saves to the database
    Parameters: sAction, sObjectstoSave, bDMLOption
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void saveDatabase (String sAction, SObject[] sObjectstoSave, Boolean bDMLOption){
        Database.SaveResult[] srObjectstoSaves = new Database.SaveResult[]{};

        if (sObjectstoSave.size() > 0 ){
            if (sAction == CPA_ConstantsForContractingAppClasses.INSERTCONSTANT){
                srObjectstoSaves = Database.insert(sObjectstoSave,bDMLOption);
            }else if(sAction == CPA_ConstantsForContractingAppClasses.UPDATECONSTANT){
                srObjectstoSaves = Database.update(sObjectstoSave,bDMLOption);
            }

            for (Database.SaveResult srObject : srObjectstoSaves){
                //Commented below line to fix SonarQube issue - Avoid unnecessary comparisons in boolean expressions
                //if(srObject.isSuccess() == false){
                if(!srObject.isSuccess()){
                    for(Database.Error err : srObject.getErrors()) {                 
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Particpant Share fields that affected this error: ' + err.getFields());
                            sObjectstoSave[0].addError(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
        }else{
            System.debug('#### No Records to insert/update.');
        }
    }

    /*******************************************************************
    Purpose: This method is used to Commit deletes to the database
    Parameters: sObjectstoDelete, bDMLOption
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/ 
   /* public static void deleteDatabase (SObject[] sObjectstoDelete, Boolean bDMLOption){
        
        if (sObjectstoDelete.size() > 0 ){

            Database.DeleteResult[] drObjectstoDeletes= Database.delete(sObjectstoDelete, bDMLOption);
            
            for (Database.DeleteResult drObjectstoDelete : drObjectstoDeletes){
                //Commented below line to fix SonarQube issue - Avoid unnecessary comparisons in boolean expressions
                //if(drObjectstoDelete.isSuccess() == false){
                if(!drObjectstoDelete.isSuccess()){
                    for(Database.Error err : drObjectstoDelete.getErrors()) {                
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Particpant Share fields that affected this error: ' + err.getFields());
                            sObjectstoDelete[0].addError(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
        }else{
            System.debug('#### No Records to delete.');
        }
    }*/
}