trigger IPM_UpdateMilestoneOnCreation on IPM_Milestone__c (before insert,before update) 
{

Map<Id,Id> mapMilestoneWithIPMProject = new Map<Id,Id>();
Map<Id,IPM_Project__c> ipmProject = new Map<Id,IPM_Project__c>();
Map<Id,IPM_Bosscard__c> ipmBosscard = new Map<Id,IPM_Bosscard__c>();

List<IPM_Project__c> ipmProjects = new List<IPM_Project__c>();
List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();

List<IPM_Milestone__c>  updatedMilestone = new List<IPM_Milestone__c>();

    for (IPM_Milestone__c recentUpsertedMilestone : Trigger.new) 
    {
        if(recentUpsertedMilestone.IPM_Project__c != null)
        {
            
             if(!mapMilestoneWithIPMProject.containsKey(recentUpsertedMilestone.IPM_Project__c)) 
             {    
             
                ipmProjects = [SELECT Id,CreatedDate,IPM_Bosscard__c FROM IPM_Project__c WHERE id = : recentUpsertedMilestone.IPM_Project__c];
                
                for (IPM_Project__c ipmProj:ipmProjects)
                {
                    ipmProject.put(ipmProj.Id,ipmProj);
                    mapMilestoneWithIPMProject.put(ipmProj.Id,recentUpsertedMilestone.Id);
                    
                }
            }   
            
            else
            {        
                IPM_Project__c  proj= new IPM_Project__c ();   
                proj= ipmProject.get(recentUpsertedMilestone.IPM_Project__c);
                ipmProjects.add(proj);
            
            }
            
            
            
            for(IPM_Project__c ipmProje:ipmProjects)
                            {
                                recentUpsertedMilestone.IPM_Project_Started_Date__c = ipmProje.CreatedDate.date();
                                
                                if(ipmProje.IPM_Bosscard__c != null)
                                {
                                
                                
                                
                                    if(!ipmBosscard.containsKey(ipmProje.IPM_Bosscard__c)) 
                                     {    
                                     
                                        ipmBosscards= [SELECT Id, IPM_Bosscord_Approval_Date__c FROM IPM_Bosscard__c WHERE id = : ipmProje.IPM_Bosscard__c];
                                    
                                        for (IPM_Bosscard__c bosscard:ipmBosscards)
                                        {
                                            ipmBosscard.put(bosscard.Id,bosscard);
                                            
                                        }
                                    }
                                    else
                                    {           
                                        IPM_Bosscard__c bossc= new IPM_Bosscard__c();  
                                        bossc= ipmBosscard.get(ipmProje.IPM_Bosscard__c);
                                        ipmBosscards.add(bossc);
                                    
                                    }
                                
                                    
                                    for(IPM_Bosscard__c  bosscard: ipmBosscards)
                                    {
                                        if(bosscard.IPM_Bosscord_Approval_Date__c != null)
                                        {
                                            recentUpsertedMilestone.IPM_Bosscord_Approval_Date__c = bosscard.IPM_Bosscord_Approval_Date__c;
                                        }
                                    }
                                
                                }
                                
                                
                                
                                
                                updatedMilestone.add(recentUpsertedMilestone);
                            }
        }
        
    }
  
    
}