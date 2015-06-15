public class IPM_ProjectUtility{
        
    public static void cloneMileStones(List<IPM_Project__c> lstProjects){
        
        system.debug('** lstProjects : ' + lstProjects);
        Map<Id,Set<Id>> mpProjects = new Map<Id,Set<Id>>();
        Set<Id> projectIds = new Set<Id>();
        for(IPM_Project__c  proj: lstProjects){
            if((proj.IPMProject_Span__c == 'Regional' || proj.IPMProject_Span__c == 'Local') && proj.IPM_Parent_Project__c != null){
                system.debug('** proj.IPMProject_Span__c  : ' + proj.IPMProject_Span__c );
                if(!mpProjects.containsKey(proj.IPM_Parent_Project__c)) {
                    Set<Id> tmpSet = new Set<Id>();
                    tmpSet.add(proj.Id);
                    mpProjects.put(proj.IPM_Parent_Project__c, tmpSet);
                }else {
                    mpProjects.get(proj.IPM_Parent_Project__c).add(proj.Id);
                }
                projectIds.add(proj.IPM_Parent_Project__c);
            }
        }
        
        Map<Id,IPM_Project__c> mapipmProject=new Map<Id,IPM_Project__c>([Select Id, IPM_Project_Leader__c from IPM_Project__c Where Id IN : mpProjects.keySet()]);
        system.debug('** mpProjects : ' + mpProjects);
        if(projectIds.size()>0){
            string query = IPM_ProjectUtility.getCreatableFieldsSOQL('IPM_Milestone__c','IPM_Project__c in: projectIds');
            List<IPM_Milestone__c> lstMilestones = database.query(query);
            List<IPM_Milestone__c> MileStonesToInsert = new List<IPM_Milestone__c>();
            for(Id eachParentProject : mpProjects.keySet()) {
                for(Id eachRegionalProject : mpProjects.get(eachParentProject)) {
                    for(IPM_Milestone__c mstone : lstMilestones){
                        IPM_Milestone__c newMileStone = mstone.clone();
                        newMileStone.Clone_Record_Id__c = mStone.Id;
                        if(mapipmProject.containsKey(eachRegionalProject)){
                            newMileStone.ownerId = mapipmProject.get(eachRegionalProject).IPM_Project_Leader__c;
                        }
                        newMileStone.IPM_Project__c = eachRegionalProject;
                        MileStonesToInsert.add(newMileStone);
                    }
                }
            }
            
            system.debug('** MileStonesToInsert : ' + MileStonesToInsert);
            if(!MileStonesToInsert.isEmpty())
                insert MileStonesToInsert;
                
            Map<Id,Id> mpInsertedMiles = new Map<Id,Id>();
            for(IPM_Milestone__c mStone : MileStonesToInsert){
                mpInsertedMiles.put(mStone.Clone_Record_Id__c,mStone.Id);
            }
                
            List<IPM_Milestone__c> MileStonesToUpdate = new List<IPM_Milestone__c>();
            for(IPM_Milestone__c mStone : MileStonesToInsert){
                if(mStone.IPM_Milestone__c != null){
                    if(mpInsertedMiles.containsKey(mStone.IPM_Milestone__c)){
                        mStone.IPM_Milestone__c = mpInsertedMiles.get(mStone.IPM_Milestone__c);
                        MileStonesToUpdate.add(mStone);
                    }
                }
            }
            
            if(!MileStonesToUpdate.isEmpty())
                update MileStonesToUpdate;
        }
    }
    
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
         
        String selects = '';
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                if(s != 'ExternalField__c')
                    selects += s + ',';
            }
            if (selects.endsWith(',')){
                selects = selects.substring(0,selects.lastIndexOf(','));
            }
             
        }
         
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
         
    }
    
    public static void MarkMileStonesComplete(Map<Id,String> mpPhases){
    
        List<IPM_Milestone__c> lstMileStones = [Select id,IPM_Project__c,IPM_Completed__c from IPM_Milestone__c 
                                                    where IPM_Phase__c in: mpPhases.values() and IPM_Project__c in:mpPhases.keyset()];
                                                    
        for(IPM_Milestone__c ipm: lstMileStones){
            if(ipm.IPM_Completed__c == false)
            ipm.IPM_Completed__c = true;
        }
        
        update lstMileStones;
        
    }

}