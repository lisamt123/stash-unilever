/*
  Class Name: BEN_CategoryUserPermissionTrigger 
  Author : Mindtree
  Date: 15 Dec 2016
  Requirement/Project Name: SF Benchmarking
  Requirement/Description: This Trigger Calls Handler Class to assign Permission, Public Groups and Queues to user
**************************************************************************************************************************
*/ 
trigger BEN_CategoryUserPermissionTrigger on BEN_Category_User_Permission__c(before insert,before update,after delete) {
    
    try{ 
        //Record is getting inserted or updated 
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            for (BEN_Category_User_Permission__c CatUserPerm: Trigger.new) {
                
                //to validate if User already exist in case of Single Category or if user is multicategory, they are Selecting existing permission for Different Category 
                string ValidationStatus=BEN_CategoryUserPermissionHandler.Category_Validation(CatUserPerm.BEN_Category_User__c,CatUserPerm.pkl_User_Type__c,'BEN_Benchmarking_Single_Category_Viewer',CatUserPerm.Category_Master__c,CatUserPerm.pkl_Category_Access__c);
                if(ValidationStatus=='true')
                {   
                    if(CatUserPerm.pkl_Category_Access__c == BEN_ConstantsForBenchmarkingAppClasses.VIEWER )
                    {
                        if(CatUserPerm.pkl_User_Type__c == BEN_ConstantsForBenchmarkingAppClasses.SINGLE_CATEGORY)
                        {    
                            BEN_CategoryUserPermissionHandler.setupObjecthandle(CatUserPerm.BEN_Category_User__c,'BEN_Benchmarking_Single_Category_Viewer',CatUserPerm.Category_Master__c,CatUserPerm.pkl_Category_Access__c);    
                        }
                        
                        else if(CatUserPerm.pkl_User_Type__c == BEN_ConstantsForBenchmarkingAppClasses.MULTI_CATEGORY_RESTRICTED_ACCESS)
                        {     
                            BEN_CategoryUserPermissionHandler.setupObjecthandle(CatUserPerm.BEN_Category_User__c,'BEN_Benchmarking_Multi_Category_Restricted_Viewer',CatUserPerm.Category_Master__c,CatUserPerm.pkl_Category_Access__c);  
                        }
                    }
                    else if(CatUserPerm.pkl_Category_Access__c == BEN_ConstantsForBenchmarkingAppClasses.EDITOR)
                    { 
                        if(CatUserPerm.pkl_User_Type__c == BEN_ConstantsForBenchmarkingAppClasses.SINGLE_CATEGORY)
                        {    
                            BEN_CategoryUserPermissionHandler.setupObjecthandle(CatUserPerm.BEN_Category_User__c,'BEN_Benchmarking_Single_Category_Editor',CatUserPerm.Category_Master__c,CatUserPerm.pkl_Category_Access__c); 
                        }
                        else if(CatUserPerm.pkl_User_Type__c == BEN_ConstantsForBenchmarkingAppClasses.MULTI_CATEGORY_RESTRICTED_ACCESS)
                        {      
                            BEN_CategoryUserPermissionHandler.setupObjecthandle(CatUserPerm.BEN_Category_User__c,'BEN_Benchmarking_Multi_Category_Restricted_Editor',CatUserPerm.Category_Master__c,CatUserPerm.pkl_Category_Access__c);    
                        }   
                    }
                    else if(CatUserPerm.pkl_Category_Access__c == BEN_ConstantsForBenchmarkingAppClasses.APPROVER)
                    { 
                        if(CatUserPerm.pkl_User_Type__c == BEN_ConstantsForBenchmarkingAppClasses.SINGLE_CATEGORY)
                        {    
                            BEN_CategoryUserPermissionHandler.setupObjecthandle(CatUserPerm.BEN_Category_User__c,'BEN_Benchmarking_Single_Category_Approver',CatUserPerm.Category_Master__c,CatUserPerm.pkl_Category_Access__c); 
                        }
                        else if(CatUserPerm.pkl_User_Type__c == BEN_ConstantsForBenchmarkingAppClasses.MULTI_CATEGORY_RESTRICTED_ACCESS)
                        {      
                            BEN_CategoryUserPermissionHandler.setupObjecthandle(CatUserPerm.BEN_Category_User__c,'BEN_Benchmarking_Multi_Category_Restricted_Approver',CatUserPerm.Category_Master__c,CatUserPerm.pkl_Category_Access__c);    
                        }   
                    }
                    
                }
                else{
                    CatUserPerm.addError('User Already Exist with different permission set :'+ValidationStatus);
                }
            }
        }
        // in case of deleting a record below code will get fired
        else if(Trigger.isDelete){
            for (BEN_Category_User_Permission__c CatUserPermDelete: Trigger.old) {
                BEN_CategoryUserPermissionHandler.DeletePermissionSet_Groups(CatUserPermDelete.BEN_Category_User__c,CatUserPermDelete.Category_Master__c,CatUserPermDelete.pkl_Category_Access__c,CatUserPermDelete.pkl_User_Type__c);
            }
        }
    }
    catch(DmlException e) {
        System.debug('DML exception occurred: ' + e.getMessage());
    }
    catch (Exception e) {
        System.debug('General exception occurred: ' + e.getMessage());
    }
    
}