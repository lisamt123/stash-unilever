/*
  Class Name: BEN_CategoryUserPermissionHandler
  Author : Mindtree
  Date: 15 Dec 2016
  Requirement/Project Name: SF Benchmarking
  Requirement/Description: This Class Handles assignment of Permission, Public Groups and Queues to user
**************************************************************************************************************************
*/ 
public with sharing Class BEN_CategoryUserPermissionHandler
{
    
    @future //to assign permission set to a user
    public static void setupObjecthandle(Id uid,String Permission_Name,Id Category_Master,String pkl_Category_Access)
    {   
        // calling a method to assign user to public group
        PublicGroup_UserAssignment(uid,Category_Master,pkl_Category_Access);
        if(pkl_Category_Access == BEN_ConstantsForBenchmarkingAppClasses.APPROVER)
        {   
            // calling a method to assign user to QUEUE
            Queue_UserAssignment(uid,Category_Master,pkl_Category_Access);
        }
        try{
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :Permission_Name];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = uid;
            psa.PermissionSetId = ps.Id;   
            insert psa;
        }
        catch(DmlException e) {
            System.debug('DML exception occurred: ' + e.getMessage());
        }
        catch (Exception e) {
            System.debug('General exception occurred: ' + e.getMessage());
        }
    }
    //to validate if User already exist in case of Single Category or if user is multicategory, they are Selecting existing permission for Different Category
    public static string Category_Validation(Id uid,String pkl_User_Type,String Permission_Name, Id Category_Master_Id,string Category_Access)
    {  
        string status='true';
        string CategoryName;
        try{ 
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :Permission_Name];
            List<BEN_Category_User_Permission__c>  pNames = [SELECT pkl_User_Type__c,Category_Master__r.Name,pkl_Category_Access__c  FROM BEN_Category_User_Permission__c WHERE BEN_Category_User__c = :uid AND pkl_User_Type__c Like '%Category%' AND Category_Master__c =:Category_Master_Id];
            List<BEN_Category_Master__c >  Category_Master_Name = [SELECT Name FROM BEN_Category_Master__c WHERE Id = :Category_Master_Id LIMIT 1];
            for(BEN_Category_Master__c CategoryNames:Category_Master_Name)
            { 
                CategoryName=CategoryNames.Name;
                
            }
            for(BEN_Category_User_Permission__c PermissionNames:pNames)
            {   
                // if user is of Single Category type and record alredy exist then return a error message
                if(PermissionNames.pkl_User_Type__c == BEN_ConstantsForBenchmarkingAppClasses.SINGLE_CATEGORY)
                {  
                    status=PermissionNames.pkl_User_Type__c+PermissionNames.pkl_Category_Access__c;
                }
                // if user is of multi category type then check for category, it should be different
                else if(PermissionNames.pkl_User_Type__c == pkl_User_Type && Category_Access==PermissionNames.pkl_Category_Access__c && PermissionNames.Category_Master__r.Name!=CategoryName){
                    status='true';
                }
                // if user is of multi category type and category is same in existing and new record then return an error message
                else if(PermissionNames.pkl_User_Type__c == pkl_User_Type && Category_Access==PermissionNames.pkl_Category_Access__c && PermissionNames.Category_Master__r.Name==CategoryName){
                    status=PermissionNames.pkl_User_Type__c+PermissionNames.pkl_Category_Access__c;
                }
                // if user is of multi category type and category is same in existing and new record then return an error message
                else if(PermissionNames.pkl_User_Type__c == pkl_User_Type && PermissionNames.Category_Master__r.Name==CategoryName){
                    status=PermissionNames.pkl_User_Type__c+PermissionNames.pkl_Category_Access__c;
                }
                 
            }
        }
        catch(DmlException e) {
            System.debug('DML exception occurred: ' + e.getMessage());
        }
        catch (Exception e) {
            System.debug('General exception occurred: ' + e.getMessage());
        }
        return status; 
    }
    
    public static boolean PublicGroup_UserAssignment(Id uid,Id Category_Master_Id,String pkl_Category_Access)
    {      
        try {
            List<GroupMember> GIdSet=new List<GroupMember>();
            BEN_Category_Master__c  CategoryMaster_Name=[SELECT Name FROM BEN_Category_Master__c WHERE Id = :Category_Master_Id LIMIT 1];
            //fetching records from group where group name matches and it's of type Regular
            List<Group>  RelatedGrpId=[SELECT Id,Name FROM Group WHERE Type =: BEN_ConstantsForBenchmarkingAppClasses.REGULAR];
            for(Group Grpset:RelatedGrpId){
                if(Grpset.Name.Contains(CategoryMaster_Name.Name) && Grpset.Name.Contains(pkl_Category_Access))
                {
                    GroupMember GM = new GroupMember();
                    GM.GroupId = Grpset.Id;
                    GM.UserOrGroupId = uid;
                    GIdSet.Add(GM);    
                }
                
            }
            insert GIdSet;
        }
        catch(DmlException e) {
            System.debug('DML exception occurred: ' + e.getMessage());
        }
        catch (Exception e) {
            System.debug('General exception occurred: ' + e.getMessage());
        }
        return true;
    }
    // this code will be called if user Category access is Approver 
    public static boolean Queue_UserAssignment(Id uid,Id Category_Master_Id,String pkl_Category_Access)
    {      
        try{
            List<GroupMember> GIds = new List<GroupMember>();
            BEN_Category_Master__c CategoryMaster_Name=[SELECT Name FROM BEN_Category_Master__c WHERE Id = :Category_Master_Id LIMIT 1];
            List<Group>  RelatedGrpId=[SELECT Id FROM Group WHERE Name LIKE :'%'+CategoryMaster_Name.Name+'%' AND Type =: BEN_ConstantsForBenchmarkingAppClasses.QUEUE];
            if(RelatedGrpId.size()>0 && pkl_Category_Access == BEN_ConstantsForBenchmarkingAppClasses.APPROVER)
            {   
                for(Group Relgrp:RelatedGrpId){
                    GroupMember GM = new GroupMember();
                    GM.GroupId = Relgrp.Id;
                    GM.UserOrGroupId = uid;
                    GIds.Add(GM);
                }
            }
            
            insert GIds;
        }
        catch(DmlException e) {
            System.debug('DML exception occurred: ' + e.getMessage());
        }
        catch (Exception e) {
            System.debug('General exception occurred: ' + e.getMessage());
        }
        return true;
    }
    @future // this method will be called when a record is getting deleted
    public static void DeletePermissionSet_Groups(Id uid,Id Category_Master_Id ,String pkl_Category_Access,string pkl_User_Type)
    {        
        try{
            
            List<BEN_Category_User_Permission__c> RecordList = [SELECT Id FROM BEN_Category_User_Permission__c WHERE BEN_Category_User__c =: uid];
            if(RecordList.size()<1){
                List<PermissionSet> ps = [SELECT Id FROM PermissionSet WHERE Name Like 'BEN%'];
                for(PermissionSet psName:ps)
                {
                    delete [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = : uid AND PermissionSetId = :psName.Id];
                }
            }
            
            BEN_Category_Master__c CategoryMaster_Name = [SELECT Name FROM BEN_Category_Master__c WHERE Id= :Category_Master_Id LIMIT 1];
            
            List<Group>  RelatedGrpId = [SELECT Id,Type,Name FROM Group];
            for(Group DeleteId:RelatedGrpId)
            {
                // checking if type of group is Regular
                if(DeleteId.Type == BEN_ConstantsForBenchmarkingAppClasses.REGULAR)
                {    
                    if(DeleteId.Name.Contains(pkl_Category_Access) && DeleteId.Name.Contains(CategoryMaster_Name.Name))
                    {  
                        List<GroupMember> grpList = [Select Id from GroupMember where GroupId =: DeleteId.Id and UserOrGroupId = : uid];
                        delete grpList;
                    }
                    
                }
                // checking if type of group is QUEUE
                if(DeleteId.Type == BEN_ConstantsForBenchmarkingAppClasses.QUEUE)
                { 
                    if((pkl_Category_Access == BEN_ConstantsForBenchmarkingAppClasses.APPROVER && DeleteId.Name.Contains(CategoryMaster_Name.Name)))
                    {
                        
                        List<GroupMember> grpList  = [Select Id from GroupMember where GroupId =: DeleteId.ID and UserOrGroupId = : uid];
                        delete grpList;
                        
                    } 
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
    
}