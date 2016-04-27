public with sharing class AA_Follow_Unfollow_class {
public static void ExecuteFollowUnFollow(List<aa_Agent_App_User_Preference__c> UserSet){
        
        List<aa_Cluster__c> ClusterIdName= [SELECT Id,Name FROM aa_Cluster__c]; 
        Map<String,ID> clusterNameIdMap=new  Map<String,ID>(); 
        Set<ID> clustIdSet=new Set<ID>();
        //create cluser name & id map
        for(aa_Cluster__c clustone:ClusterIdName)
        {
            clusterNameIdMap.put(clustone.Name,clustone.Id);
            clustIdSet.add(clustone.Id);
        }
 
        Set<Id> userIds = new Set<Id>();
        for(aa_Agent_App_User_Preference__c obj:UserSet){
         userIds.add(obj.UserId__c);
        }
        
        List<aa_Country__c> CountryIds= [SELECT Id,Cluster_Id__c  FROM aa_Country__c];
        Map<Id,Id> ClusterId= new Map<Id,Id>();
        for(aa_Country__c obj:CountryIds){
           ClusterId.put(obj.Id,obj.Cluster_Id__c);
        }
                    
        List<EntitySubscription> lstEntitySub= [SELECT CreatedById,CreatedDate,Id,IsDeleted,NetworkId,ParentId,SubscriberId FROM EntitySubscription where SubscriberId in:UserIds and ParentId In:CountryIds ];
        List<EntitySubscription> lstUpsertSub= new List<EntitySubscription>();
        
        Map<ID,string> globaluserid=new Map<ID, String>();
        
        for(EntitySubscription obj:lstEntitySub){
        
         for(EntitySubscription addlist:lstUpsertSub)
         {  
             if(addlist.SubscriberId!=obj.SubscriberId && addlist.ParentId!=ClusterId.get(obj.ParentId))
             {
             EntitySubscription objTemp = new EntitySubscription();
             objTemp.SubscriberId = obj.SubscriberId;
             objTemp.ParentId = ClusterId.get(obj.ParentId);
             lstUpsertSub.add(objTemp);
             } 
         }
             //collect userid to be set for global cluster follow
             if (!globaluserid.containskey(obj.SubscriberId))
             {
                globaluserid.put(obj.SubscriberId,'Global');
             }  
        }
        //get global cluster id 
        aa_Cluster__c GlobalclusterID = [SELECT Id FROM aa_Cluster__c where name='Global' Limit 1];
        System.debug('GlobalClusterid===>'+GlobalclusterID.Id);
        
        for(ID userIDforclust:globaluserid.keyset())
        {
         //clustUserMap.add(userIDforclust,GlobalclusterID.Id);
         EntitySubscription objTemp = new EntitySubscription();
         objTemp.SubscriberId = userIDforclust;
         objTemp.ParentId = GlobalclusterID.Id;
         lstUpsertSub.add(objTemp); 
        }
             
        List<EntitySubscription> lstEntitySubCluster= [SELECT CreatedById,CreatedDate,Id,IsDeleted,NetworkId,ParentId,SubscriberId FROM EntitySubscription where SubscriberId in:UserIds and ParentId  In:clustIdSet ];
        
        for(EntitySubscription singleclust:lstEntitySubCluster)
        {
            //for(EntitySubscription insertlist :lstUpsertSub)
            if(lstUpsertSub.size()>0){
            for (Integer  i=0; i<lstUpsertSub.size(); i++)
            {  
                if(singleClust.ParentId==lstUpsertSub[i].ParentID && singleClust.SubscriberId==lstUpsertSub[i].SubscriberId)
                {
                    lstUpsertSub.remove(i);
                }
            }
            }
        }
              
        if(lstUpsertSub.size()>0 || lstUpsertSub!=null){
        insert lstUpsertSub;
        }
      
        //Unfollow starts here
        
        Map<ID,String> AfricaCountryMap=new Map<ID,String>();
        Map<ID,String> EuropeCountryMap=new Map<ID,String>();
        Map<ID,String> LatinAmericaCountryMap=new Map<ID,String>();
        Map<ID,String> NAMETRUBCountryMap=new Map<ID,String>();
        Map<ID,String> NorthAmericaCountryMap=new Map<ID,String>();
        Map<ID,String> SouthAsiaCountryMap=new Map<ID,String>();
        Map<ID,String> NorthAsiaCountryMap=new Map<ID,String>();
        Map<ID,String> SEAACountryMap=new Map<ID,String>();
        
        
          
        List<aa_Country__c> CountryIds1= [SELECT Id,Cluster_Id__c,Cluster_Id__r.Name,Name FROM aa_Country__c];
        List<EntitySubscription> UnfollowList = new List<EntitySubscription>();
        
               
        
        for(aa_Country__c country: CountryIds1)
        {
            if(country.Cluster_Id__r.name=='Africa')
            {
                AfricaCountryMap.put(country.Id,country.Name);
            }
            if(country.Cluster_Id__r.name=='Europe')
            {
                EuropeCountryMap.put(country.Id,country.Name);
            }
            if(country.Cluster_Id__r.name=='Latin America')
            {
                LatinAmericaCountryMap.put(country.Id,country.Name);
            }
            if(country.Cluster_Id__r.name=='NAMET & RUB')
            {
                NAMETRUBCountryMap.put(country.Id,country.Name);
            }
            if(country.Cluster_Id__r.name=='North America')
            {
                NorthAmericaCountryMap.put(country.Id,country.Name);
            }
            if(country.Cluster_Id__r.name=='South Asia')
            {
                SouthAsiaCountryMap.put(country.Id,country.Name);
            }
            if(country.Cluster_Id__r.name=='North Asia')
            {
                NorthAsiaCountryMap.put(country.Id,country.Name);
            }
            if(country.Cluster_Id__r.name=='SEAA')
            {
                SEAACountryMap.put(country.Id,country.Name);
            }
            
        }       

       
        for(aa_Agent_App_User_Preference__c userid:UserSet)
        {
            Boolean AfricaFlag=false;
            Boolean EuropeFlag=false;
            Boolean LatinAmericaFlag=false;
            Boolean NAMETRUBFlag=false;
            Boolean NorthAmericaFlag=false;
            Boolean SouthAsiaFlag=false;
            Boolean NorthAsiaFlag=false;
            Boolean SEAAFlag=false;
            
          for(EntitySubscription entity :lstEntitySub)
          {
            if(entity.SubscriberId==userid.UserId__c)
             {
                
                if(AfricaCountryMap.containsKey(entity.ParentId)) {  AfricaFlag=true; }
               
                if(EuropeCountryMap.containsKey(entity.ParentId)) {  EuropeFlag=true; }
                                     
                if(LatinAmericaCountryMap.containsKey(entity.ParentId)){ LatinAmericaFlag=true; }
                                
                if(NAMETRUBCountryMap.containsKey(entity.ParentId)){ NAMETRUBFlag=true; }
                              
                if(NorthAmericaCountryMap.containsKey(entity.ParentId)){ NorthAmericaFlag=true; }
                
                if(SouthAsiaCountryMap.containsKey(entity.ParentId)){ SouthAsiaFlag=true; }
                
                if(NorthAsiaCountryMap.containsKey(entity.ParentId)){ NorthAsiaFlag=true; }
                                                
                if(SEAACountryMap.containsKey(entity.ParentId)) { SEAAFlag=true; }               
             }// end if
           }// end for
                    
            if(AfricaFlag==false)
            {
                   EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('Africa');
                   UnfollowList.add(objTemp);
                    
            }
            if(EuropeFlag==false)
            {     
                   EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('Europe');
                   UnfollowList.add(objTemp);
            }
            if(LatinAmericaFlag==false)
            {
                   EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('Latin America');
                   UnfollowList.add(objTemp);
            }
            if(NAMETRUBFlag==false){
                   EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('NAMET & RUB');
                   UnfollowList.add(objTemp);
            } 
            if(NorthAmericaFlag==false)
            {
                   EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('North America');
                   UnfollowList.add(objTemp);
             } 
             if(SouthAsiaFlag==false){
                   EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('South Asia');
                   UnfollowList.add(objTemp);
             }
             if(NorthAsiaFlag==false){
                   EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('North Asia');
                   UnfollowList.add(objTemp);
             }   
             if(SEAAFlag==false)
             {
                   EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('SEAA');
                   UnfollowList.add(objTemp);
             }              
            
                      
        }//end outer for 
    //for global Unfollow
    
    
    List<EntitySubscription> lstEntitySubCluster1= [SELECT CreatedById,CreatedDate,Id,IsDeleted,NetworkId,ParentId,SubscriberId FROM EntitySubscription where SubscriberId in:UserIds and ParentId In:clustIdSet];
     
     for(aa_Agent_App_User_Preference__c userid:UserSet)
     { 
         Boolean AllClusterFlag=false;
      for(EntitySubscription entity1 :lstEntitySubCluster1)
      {
             //system.debug('===>user condi global'+entity1.SubscriberId+'=='+userid.UserId__c);
             if(entity1.SubscriberId==userid.UserId__c)
             {
                
                if(clustIdSet.contains(entity1.ParentId) && entity1.ParentId!=clusterNameIdMap.get('Global') )
                {
                   system.debug('in global cluster flag true partenID='+entity1.ParentId+' User id '+entity1.SubscriberId);
                   AllClusterFlag=true;

                }
               
             }
          }
           if(AllClusterFlag==false)
             {
                   EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('Global');
                   UnfollowList.add(objTemp);
                    
                }
        }
   
        //delete UnFollowList
        String wherecondi= ' Where ';
        for(EntitySubscription unfollow:UnFollowList)
        {
            whereCondi=wherecondi+'( SubscriberId =\''+unfollow.SubscriberId+'\' and ParentId=\''+unfollow.ParentId+'\' )OR';
            
        }
        whereCondi=whereCondi.substringBeforeLast('OR');
        String Unfollowquery='Select ID from EntitySubscription'+whereCondi;
        system.debug('Final query unfollow =============>'+Unfollowquery);
        List<EntitySubscription> finaldeleteList=Database.query(Unfollowquery);
        system.debug('Delete object list'+Unfollowquery);
        delete finaldeleteList;
        
       
        
        }
         
      
}