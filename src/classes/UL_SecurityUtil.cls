/** 
 * This utility class is used for checking object/fls permissions before DML operations
 * @author  subhajit.a.ghosh@accenture.com 
 * @version  2015-11-25  subhajit.a.ghosh@accenture.com@accenture.com  creation 
 * @Updated By Soumyodeep.guha@accenture.com 
 * @Updated so to use for the custom class written for Unilever
 */
Public with sharing Class UL_SecurityUtil
{
    public abstract class SecurityUtilException extends Exception {}
    public class SecurityUtilObjectException extends SecurityUtilException {}
    public class SecurityUtilFieldException extends SecurityUtilException {}

    /**
     *  method to check object access permission
     *
     *  @param sObjectAPIName    api name of the sOBject 
     *  @return                  TRUE if permission available, otherwise FALSE
     */
    public Boolean checkObjectIsAccessible(String sObjectAPIName)
    {
        try
        {
            return Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().isAccessible();
        }
        catch(Exception e)
        {
            return false;
        }
    }
     /**
     *  method to check object create permission
     *
     *  @param sObjectAPIName    api name of the sOBject 
     *  @return                  TRUE if permission available, otherwise FALSE
     */
    public Boolean checkObjectIsInsertable(String sObjectAPIName)
    {
        try
        {
            return Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().isCreateable();
        }
        catch(Exception e)
        {
            return false;
        }
    }
    /**
     *  method to check object update permission
     *
     *  @param sObjectAPIName    api name of the sOBject 
     *  @return                  TRUE if permission available, otherwise FALSE
     */
    public Boolean checkObjectIsUpdateable(String sObjectAPIName)
    {
        try
        {
            return Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().isUpdateable();
        }
        catch(Exception e)
        {
            return false;
        }
    }
    /**
     *  method to check object delete permission
     *
     *  @param sObjectAPIName    api name of the sOBject 
     *  @return                  TRUE if permission available, otherwise FALSE
     */
    public Boolean checkObjectIsDeletable(String sObjectAPIName)
    {
        try
        {
            return Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().isDeletable();
        }
        catch(Exception e)
        {
            return false;
        }
    }
    
    /**
     *  method for check field creation permission
     *
     *  @author                     adam.bobor@accenture.com
     *  @param sObjectAPIName       api name of the sOBject 
     *  @param fieldAPINameList     new calls' start/end date set. used for search existing recrds
     *  @param operation            create, edit  
     *  @return                     string about errors, otherwise NULL  
     */
    public string checkFLSPermission(string sObjectAPIName, List<string> fieldAPINameList, string operation)
    {
        string returnMessage;
        
        returnMessage = '';
        
        try
        {
            SObjectType objectType = Schema.getGlobalDescribe().get(sObjectAPIName);
            Map<String, Schema.SObjectField> sObjectFieldApiNameMap = objectType.getDescribe().fields.getMap();
            
            if(operation != NULL)
            {
                for(string tempString : fieldAPINameList)
                {
                    if(sObjectFieldApiNameMap.containsKey(tempString))
                    {
                        if(operation.equalsIgnoreCase('view'))
                        {
                            if(!sObjectFieldApiNameMap.get(tempString).getDescribe().isAccessible())
                            {
                                returnMessage += Label.ACCL.ERROR_MISSING_VIEW_PERMISSION + ': ' + tempString + ' ' + Label.ACCL.FIELD +  ', ';
                            }
                        }
                        else if(operation.equalsIgnoreCase('create'))
                        {
                            if(!sObjectFieldApiNameMap.get(tempString).getDescribe().isCreateable())
                            {
                                returnMessage += Label.ACCL.ERROR_MISSING_CREATE_PERMISSION + ': ' + tempString + ' ' + Label.ACCL.FIELD +  ', ';
                            }
                        }
                        else if(operation.equalsIgnoreCase('update'))
                        {
                            if(!sObjectFieldApiNameMap.get(tempString).getDescribe().isUpdateable())
                            {
                                returnMessage += Label.ACCL.ERROR_MISSING_EDIT_PERMISSION + ': ' + tempString + ' ' + Label.ACCL.FIELD +  ', ';
                            }
                        }
                        else 
                        {
                            returnMessage = Label.ACCL.ERROR_INVALID_OPERATION;
                            
                            return returnMessage;
                        }
                    }
                    else
                    {
                        returnMessage += Label.ACCL.ERROR_INVALID_FIELD + ': ' + tempString + ', ';
                    }
                }
            }
            else 
            {
                returnMessage = Label.ACCL.ERROR_INVALID_OPERATION;
                
                return returnMessage;
            }
            
            if(returnMessage == NULL || returnMessage == '')
            {
                return NULL;
            }
            else
            {
                returnMessage = returnMessage.removeEnd(', ');
            }
        }
        catch(exception e)
        {
            returnMessage = e.getMessage();
        }
        
        return returnMessage;
    }
   
   
    /**
     *  method for check field creation permission and return the List of fields
     *
     *  @author                     g.prajapat@accenture.com
     *  @param sObjectAPIName       api name of the sOBject 
     *  @param fieldAPINameList     field names for which the accessibility should be checked
     *  @param operation            create, update, view 
     */ 
   public static List<string> getFieldListBasedonFLSPermission(string sObjectAPIName, List<string> fieldAPINameList, string operation)
    {
        List<string> fieldAPINameListNew = new  List<string>();
        
        String returnMessage = '';
            SObjectType objectType = Schema.getGlobalDescribe().get(sObjectAPIName);
            Map<String, Schema.SObjectField> sObjectFieldApiNameMap = objectType.getDescribe().fields.getMap();
            
            if(operation != NULL)
            {
                for(string tempString : fieldAPINameList)
                {
                    if(sObjectFieldApiNameMap.containsKey(tempString)) 
                    {
                        if(operation.equalsIgnoreCase('view'))
                        {
                            if(sObjectFieldApiNameMap.get(tempString).getDescribe().isAccessible())
                            {
                            fieldAPINameListNew.add(sObjectFieldApiNameMap.get(tempString).getDescribe().getName());
                            }
                        }
                        else if(operation.equalsIgnoreCase('create'))
                        {
                            if(sObjectFieldApiNameMap.get(tempString).getDescribe().isCreateable())
                            {
                                fieldAPINameListNew.add(sObjectFieldApiNameMap.get(tempString).getDescribe().getName());
                            }
                        }
                        else if(operation.equalsIgnoreCase('update'))
                        {
                            if(sObjectFieldApiNameMap.get(tempString).getDescribe().isUpdateable()|| sObjectFieldApiNameMap.get(tempString).getDescribe().getType() == Schema.DisplayType.ID )
                            {
                               fieldAPINameListNew.add(sObjectFieldApiNameMap.get(tempString).getDescribe().getName());
                            }
                        }
                        else 
                        {
                           
                            returnMessage = Label.ACCL.ERROR_INVALID_OPERATION;
                        }
                    }
                    else
                    {
                         returnMessage += Label.ACCL.ERROR_INVALID_FIELD + ': ' + tempString + '. On Object: '+ sObjectAPIName+', ';
                    }
                }
            }
            else {
                
                returnMessage = Label.ACCL.ERROR_INVALID_OPERATION + '. On Object: '+ sObjectAPIName+  ', ';
            }
            
            /*if(String.isNotBlank(returnMessage))
            {   
                System.debug(LoggingLevel.ERROR, 'ret MEss:'+ returnMessage);
                returnMessage = returnMessage.removeEnd(', ');
                System.debug(LoggingLevel.ERROR, returnMessage);
                throw new SecurityUtilFieldException(returnMessage);
            }*/
            
        return fieldAPINameListNew;
    }
    
    
    /**
     *  method to check object access permission
     *
     *  @param sObjectAPIName    api name of the sOBject 
     *  @throw SecurityUtilObjectException
     */
    public static void checkObjectIsAccessibleOrThrowError(String sObjectAPIName)
    {
             if(! Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().isAccessible()){
                throw new SecurityUtilObjectException( Label.ACCL.ERROR_MISSING_VIEW_PERMISSION + ' ' + sObjectAPIName);
             }
    
    }
    
    /**
     *  method to check object create permission
     *
     *  @param sObjectAPIName    api name of the sOBject 
     *  @throw SecurityUtilObjectException
     */
    public static void checkObjectIsCreateableOrThrowError(String sObjectAPIName)
    {
        if(!Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().isCreateable())
        {
            throw new SecurityUtilObjectException(Label.ACCL.ERROR_MISSING_CREATE_PERMISSION + ' ' + sObjectAPIName);
        }
    }
    
    /**
     *  method to check object create permission
     *
     *  @param sObjectAPIName    api name of the sOBject 
     *  @throw SecurityUtilObjectException
     */
    public static void checkObjectIsUpdateableOrThrowError(String sObjectAPIName)
    {
        if(!Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().isUpdateable())
        {
            throw new SecurityUtilObjectException(Label.ACCL.ERROR_MISSING_EDIT_PERMISSION + ' ' + sObjectAPIName);
        }
    }

    public static void checkObjectIsDeletableOrThrowError(String sObjectAPIName)
    {
        if(!Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().isDeletable())
        {
            throw new SecurityUtilObjectException(Label.ACCL.ERROR_MISSING_DELETE_PERMISSION + ' ' + sObjectAPIName);
        }
    }


    /**
     *  method for check field creation permission
     *
     *  @author                     adam.bobor@accenture.com
     *  @param sObjectAPIName       api name of the sOBject 
     *  @param fieldAPINameList     field names for which the accessibility should be checked
     *  @param operation            create, update, view 
     */
    public static void checkFLSPermissionOrThrowError(String sObjectAPIName, List<String> fieldAPINameList, String operation)
    {
        String returnMessage;
        
        returnMessage = '';
        
            SObjectType objectType = Schema.getGlobalDescribe().get(sObjectAPIName);
            Map<String, Schema.SObjectField> sObjectFieldApiNameMap = objectType.getDescribe().fields.getMap();
            
            if(operation != NULL)
            {
                for(String tempString : fieldAPINameList)
                {
                    if(sObjectFieldApiNameMap.containsKey(tempString))
                    {
                        if(operation.equalsIgnoreCase('view'))
                        {
                            if(!sObjectFieldApiNameMap.get(tempString).getDescribe().isAccessible())
                            {

                                returnMessage += Label.ACCL.ERROR_MISSING_VIEW_PERMISSION + ': ' + tempString + ' ' + Label.ACCL.FIELD + '. On Object: '+ sObjectAPIName+', ';
                                System.debug('not accessible' + returnMessage);
                            }
                        }
                        else if(operation.equalsIgnoreCase('create'))
                        {
                            if(!sObjectFieldApiNameMap.get(tempString).getDescribe().isCreateable())
                            {
                                returnMessage += Label.ACCL.ERROR_MISSING_CREATE_PERMISSION + ': ' + tempString + ' ' + Label.ACCL.FIELD + '. On Object: '+ sObjectAPIName+  ', ';
                            }
                        }
                        else if(operation.equalsIgnoreCase('update'))
                        {// isCalculated means that the field is a Formula so it cannot be editable, these fields will be omitted!
                            // Type of field is checked also, if it is an Id than it is editable by default so it's also omitted!
                            if(!sObjectFieldApiNameMap.get(tempString).getDescribe().isUpdateable() && !sObjectFieldApiNameMap.get(tempString).getDescribe().isCalculated() && sObjectFieldApiNameMap.get(tempString).getDescribe().getType() != Schema.DisplayType.ID && sObjectFieldApiNameMap.get(tempString).getDescribe().isPermissionable() )
                            {
                                returnMessage += Label.ACCL.ERROR_MISSING_EDIT_PERMISSION + ': ' + tempString + ' ' + Label.ACCL.FIELD + '. On Object: '+ sObjectAPIName+  ', ';
                            }
                        }
                        else 
                        {
                            returnMessage = Label.ACCL.ERROR_INVALID_OPERATION;
                            
                        }
                    }
                    else
                    {
                        returnMessage += Label.ACCL.ERROR_INVALID_FIELD + ': ' + tempString + '. On Object: '+ sObjectAPIName+', ';
                    }
                }
            } else {
                returnMessage = Label.ACCL.ERROR_INVALID_OPERATION + '. On Object: '+ sObjectAPIName+  ', ';
            }
            
            if(String.isNotBlank(returnMessage))
            {   
                System.debug(LoggingLevel.ERROR, 'ret MEss:'+ returnMessage);
                returnMessage = returnMessage.removeEnd(', ');
                System.debug(LoggingLevel.ERROR, returnMessage);
                throw new SecurityUtilFieldException(returnMessage);
            }
            
    }
    
}