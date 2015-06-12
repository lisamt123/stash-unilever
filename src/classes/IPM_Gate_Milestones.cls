public class IPM_Gate_Milestones
{
    public ID projectId{ 
        get {
            return projectId;
        }
        set {
            projectId= value;
            showMilestones();
            
        }}
        
     public List<IPM_Milestone__c> projectMilestones{get;set;}
    
        
    public void showMilestones()
    {
    
       projectMilestones=loadMilestones();
    }
    
    private List<IPM_Milestone__c> loadMilestones() {
        
        List<IPM_Milestone__c> milestonesToReturn = new List<IPM_Milestone__c>();
        String soql  =  'SELECT IPM_Completed__c, IPM_Name__c, IPM_Due_Date__c, IPM_Completed_On__c, IPM_phase__c, IPM_Milestone__c';
               soql += ' FROM IPM_Milestone__c ';
               soql += 'WHERE IPM_Project__c = \'' + projectId + '\'';
                
        soql += ' AND recordtypeId=\'' + IPM_Utils.getMilestoneRecordType('IPM Project Milestones') + '\'';
       soql += ' order by IPM_Due_Date__c asc';
        system.debug('** soql : ' + soql);
        milestonesToReturn = Database.query(soql);
        
        return milestonesToReturn;                    
    }
        
}