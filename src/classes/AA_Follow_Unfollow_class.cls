public with sharing class AA_Follow_Unfollow_class {

public static void ExecuteFollow(List<aa_Agent_App_User_Preference__c> UserSet){

	    Map<string,aa_agent_app_custom_setting__c> BatchUserIDList = aa_agent_app_custom_setting__c.getAll();
	    String lastbatchtime = BatchUserIDList.get('Follow Batch Last Run Time').Value__c;
	    String BatchUserID = BatchUserIDList.get('Follow Batch User ID').Value__c; 
 
        List<aa_Cluster__c> ClusterIdName= [SELECT Id,Name FROM aa_Cluster__c limit 1000]; 
        Map<String,ID> clusterNameIdMap=new  Map<String,ID>(); 
        Set<ID> clustIdSet=new Set<ID>();
        Id GlobalclusterID;
        
        //create cluser name & id map
        for(aa_Cluster__c clustone:ClusterIdName)
        {   clusterNameIdMap.put(clustone.Name,clustone.Id);
            clustIdSet.add(clustone.Id);
            if(clustone.Name==AA_Constants.GlobalString){  GlobalclusterID =clustone.Id;}
        }        
        // Create userId set
        Set<Id> userIds = new Set<Id>();
        for(aa_Agent_App_User_Preference__c obj:UserSet){  userIds.add(obj.UserId__c); }        
        //Creat map of cluster id & name
        List<aa_Country__c> CountryIds= [SELECT Id,Cluster_Id__c  FROM aa_Country__c limit 1000];
        Map<Id,Id> ClusterId= new Map<Id,Id>();
        for(aa_Country__c obj:CountryIds){  ClusterId.put(obj.Id,obj.Cluster_Id__c); }                    
        //fetch entires from entity subscribtion table for Agent User & countries & createdate >= lastjobRun              
        List<EntitySubscription> lstEntitySub= [SELECT CreatedById,CreatedDate,Id,IsDeleted,NetworkId,ParentId,SubscriberId FROM EntitySubscription where SubscriberId in:UserIds and ParentId In:CountryIds and CreatedDate >=:
        datetime.valueOf(lastbatchtime) ];        
        List<EntitySubscription> lstUpsertSub= new List<EntitySubscription>();        
        Map<ID,string> globaluserid=new Map<ID, String>();
        
        for(EntitySubscription obj:lstEntitySub){        
            EntitySubscription objTemp = new EntitySubscription();
	        objTemp.SubscriberId = obj.SubscriberId;
	        objTemp.ParentId = ClusterId.get(obj.ParentId);
	        lstUpsertSub.add(objTemp);        
            //collect userid to be set for global cluster follow
            if (!globaluserid.containskey(obj.SubscriberId))
            {  globaluserid.put(obj.SubscriberId,AA_Constants.GlobalString); }  
        }       
        List<EntitySubscription> lstEntitySubCluster= [SELECT CreatedById,CreatedDate,Id,IsDeleted,NetworkId,ParentId,SubscriberId FROM EntitySubscription where SubscriberId in:UserIds and ParentId  In:clustIdSet ];
         
         //if user is following any cluster it should follow global
         for(EntitySubscription oneclust:lstEntitySubCluster)
         {  for(aa_Agent_App_User_Preference__c userid1:UserSet)
           {  if(oneclust.SubscriberId==userid1.UserId__c && oneclust.ParentId!= GlobalclusterID)
              { globaluserid.put(oneclust.SubscriberId,'Global');}
           }        
         }        
        //add global id & user id to final follow objectlist 
        for(ID userIDforclust:globaluserid.keyset())
        {   EntitySubscription objTemp = new EntitySubscription();
            objTemp.SubscriberId = userIDforclust;
            objTemp.ParentId = GlobalclusterID;
            lstUpsertSub.add(objTemp); 
        }              
        List<EntitySubscription> lstUpsertSubCopy = lstUpsertSub;        
        //remove duplicate from the insert list
        for (Integer  i=0; i<lstUpsertSub.size(); i++)
        {  	Integer flag =0;
            for (Integer  j=0; j<lstUpsertSubCopy.size(); j++)
            {   if(lstUpsertSub[j].ParentId==lstUpsertSub[i].ParentID && lstUpsertSub[j].SubscriberId==lstUpsertSub[i].SubscriberId)
                { 	flag++; }                
            } if (flag>1){lstUpsertSub.remove(i);}
        }              
        //remove objects if already present in the database 
        for(EntitySubscription singleclust:lstEntitySubCluster)
        {  for (Integer  k=0; k<lstUpsertSub.size(); k++)
           {  
             if(singleClust.ParentId==lstUpsertSub[k].ParentID && singleClust.SubscriberId==lstUpsertSub[k].SubscriberId)
             { lstUpsertSub.remove(k); }
           }
        }              
        if(lstUpsertSub.size()>0){ insert lstUpsertSub;}
       
        //Unfollow starts here
        Map<ID,String> AfricaCountryMap=new Map<ID,String>();
        Map<ID,String> EuropeCountryMap=new Map<ID,String>();
        Map<ID,String> LatinAmericaCountryMap=new Map<ID,String>();
        Map<ID,String> NAMETRUBCountryMap=new Map<ID,String>();
        Map<ID,String> NorthAmericaCountryMap=new Map<ID,String>();
        Map<ID,String> SouthAsiaCountryMap=new Map<ID,String>();
        Map<ID,String> NorthAsiaCountryMap=new Map<ID,String>();
        Map<ID,String> SEAACountryMap=new Map<ID,String>();         
          
        List<aa_Country__c> CountryIds1= [SELECT Id,Cluster_Id__c,Cluster_Id__r.Name,Name FROM aa_Country__c limit 1000];
        List<EntitySubscription> UnfollowList = new List<EntitySubscription>();              
        for(aa_Country__c country: CountryIds1)
        {  if(country.Cluster_Id__r.name=='Africa')
           { AfricaCountryMap.put(country.Id,country.Name);}
           if(country.Cluster_Id__r.name=='Europe')
           { EuropeCountryMap.put(country.Id,country.Name);}
           if(country.Cluster_Id__r.name=='Latin America')
           { LatinAmericaCountryMap.put(country.Id,country.Name);}
           if(country.Cluster_Id__r.name=='NAMET & RUB')
           { NAMETRUBCountryMap.put(country.Id,country.Name); }
           if(country.Cluster_Id__r.name=='North America')
           { NorthAmericaCountryMap.put(country.Id,country.Name);}
           if(country.Cluster_Id__r.name=='South Asia')
           { SouthAsiaCountryMap.put(country.Id,country.Name); }
           if(country.Cluster_Id__r.name=='North Asia')
           {  NorthAsiaCountryMap.put(country.Id,country.Name); }
           if(country.Cluster_Id__r.name=='SEAA')
           { SEAACountryMap.put(country.Id,country.Name);}            
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
                               
            if(!AfricaFlag)
            {      EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('Africa');
                   UnfollowList.add(objTemp);                    
            }
            if(!EuropeFlag)
            {      EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('Europe');
                   UnfollowList.add(objTemp);
            }
            if(!LatinAmericaFlag)
            {      EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('Latin America');
                   UnfollowList.add(objTemp);
            }
            if(!NAMETRUBFlag)
            {      EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('NAMET & RUB');
                   UnfollowList.add(objTemp);
            } 
            if(!NorthAmericaFlag)
            {      EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('North America');
                   UnfollowList.add(objTemp);
             } 
             if(!SouthAsiaFlag){
                   EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('South Asia');
                   UnfollowList.add(objTemp);
             }
             if(!NorthAsiaFlag){
                   EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('North Asia');
                   UnfollowList.add(objTemp);
             }   
             if(!SEAAFlag)
             {      EntitySubscription objTemp = new EntitySubscription();
                   objTemp.SubscriberId = userid.UserId__c;
                   objTemp.ParentId = clusterNameIdMap.get('SEAA');
                   UnfollowList.add(objTemp);
             }                      
        }//end outer for    
    //delete UnFollowList for clusters
        String wherecondi= ' Where ';
        for(EntitySubscription unfollow:UnFollowList)
        {
        	whereCondi=wherecondi+'( SubscriberId =\''+unfollow.SubscriberId+'\' and ParentId=\''+unfollow.ParentId+'\' and CreatedById =\''+BatchUserID+'\' ) OR';            
        }
        whereCondi=whereCondi.substringBeforeLast('OR');
        String Unfollowquery='Select ID from EntitySubscription'+whereCondi;            
        List<EntitySubscription> finaldeleteList=Database.query(Unfollowquery);     
        delete finaldeleteList;        
     // global unfollow    
    List<EntitySubscription> GlobalUnfollowList = new List<EntitySubscription>();
    List<EntitySubscription> lstEntitySubCluster1= [SELECT CreatedById,CreatedDate,Id,IsDeleted,NetworkId,ParentId,SubscriberId FROM EntitySubscription where SubscriberId in:UserIds and ParentId In:clustIdSet and ParentId !=:clusterNameIdMap.get(AA_Constants.GlobalString)];
     
     for(aa_Agent_App_User_Preference__c userid:UserSet)
     { Boolean AllClusterFlag=false;
       for(EntitySubscription entity1 :lstEntitySubCluster1)
       {  if(entity1.SubscriberId==userid.UserId__c)
          { AllClusterFlag=true;  }
       }
          if(!AllClusterFlag)
          {   EntitySubscription objTemp = new EntitySubscription();
              objTemp.SubscriberId = userid.UserId__c;
              objTemp.ParentId = clusterNameIdMap.get(AA_Constants.GlobalString);
              GlobalUnfollowList.add(objTemp);                           
          }
      }
        //delete UnFollowList for global 
        String Globalwherecondi= ' Where ';
        for(EntitySubscription unfollow:GlobalUnfollowList)
        {
            Globalwherecondi=Globalwherecondi+'( SubscriberId =\''+unfollow.SubscriberId+'\' and ParentId=\''+unfollow.ParentId+'\' and CreatedById =\''+BatchUserID+'\' ) OR';
        }
        Globalwherecondi=Globalwherecondi.substringBeforeLast('OR');
        String GlobalUnfollowquery='Select ID from EntitySubscription'+Globalwherecondi;            
        List<EntitySubscription> GlobalfinaldeleteList=Database.query(GlobalUnfollowquery);
        delete GlobalfinaldeleteList;        
      }         
}