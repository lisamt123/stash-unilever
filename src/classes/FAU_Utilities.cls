/********************************************************************
 Name:  FAU_Utilities()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class handles Saves and Deletes functionality.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      18/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/

public without sharing class FAU_Utilities {
    /*******************************************************************
       Purpose:     Commit saves to the database                                                      
    ********************************************************************/
    public static void saveDatabase (String sAction, SObject[] sObjectstoSave, Boolean bDMLOption){
        System.debug('Entering FAU_Utilities.saveDatabase Size:' + sObjectstoSave.size());
        Database.SaveResult[] srObjectstoSaves = new Database.SaveResult[]{};

        if (sObjectstoSave.size() > 0 ){
            System.debug('#### Object Type: ' + sObjectstoSave[0].getSObjectType()  +' : ' + sObjectstoSave.size() + 'Records to ' + sAction);
            System.debug('#### sObjectstoSave: ' + sObjectstoSave);
            if (sAction == 'insert'){
                srObjectstoSaves = Database.insert(sObjectstoSave,bDMLOption);
            }else if(sAction == 'update'){
                srObjectstoSaves = Database.update(sObjectstoSave,bDMLOption);
            }

            for (Database.SaveResult srObject : srObjectstoSaves){
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

        System.debug('Exiting FAU_Utilities.saveDatabase');

    }

    /*******************************************************************
       Purpose:     Commit deletes to the database                                                      
    ********************************************************************/ 
    public static void deleteDatabase (SObject[] sObjectstoDelete, Boolean bDMLOption){
        System.debug('Entering FAU_Utilities.deleteDatabase Size:' + sObjectstoDelete.size());
        
        if (sObjectstoDelete.size() > 0 ){

            Database.DeleteResult[] drObjectstoDeletes= Database.delete(sObjectstoDelete, bDMLOption);
            
            for (Database.DeleteResult drObjectstoDelete : drObjectstoDeletes){
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
        System.debug('Exiting FAU_Utilities.deleteDatabase' );
    }
}