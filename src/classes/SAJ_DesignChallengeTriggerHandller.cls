Public class SAJ_DesignChallengeTriggerHandller
    {
        public static void insertTask(Map<Id, Task> newMap)
        {
            String DCKeyPrefix = Design_Challenge__c.sObjectType.getDescribe().getKeyPrefix();
            Set<Id> idSet = new Set<Id>();
            for(Task tk : newMap.values())
            {
                if(tk.WhatId != null && String.valueOf(tk.WhatId).startsWith(DCKeyPrefix)){
                    idSet.add(tk.whatId);
                }
            }
            
            if(idSet.size()>0)
            {
                List<Design_Challenge__c> dcToUpdate = new List<Design_Challenge__c>();
                Map<Id, Design_Challenge__c> cst = new Map<Id,Design_Challenge__c>([Select Id, Open_Tasks__c, Completed_Tasks__c from Design_Challenge__c where Id IN: idSet ]); 
                if(cst != null && cst.size()>0)
                {
                    Integer count1 = 0;
                    Integer count2 = 0;
                    for( Task tsk : newMap.values())
                    {
                        if(tsk.WhatId != null && cst.containsKey(tsk.WhatId)){
                        
                           // Design_Challenge__c dc = cst.get(tsk.WhatId);
                            If (newMap.get(tsk.Id).Status !='Completed')
                            {
                               if( cst.get(newMap.get(tsk.Id).WhatId).Open_Tasks__c == null)
                                {
                                    cst.get(newMap.get(tsk.Id).WhatId).Open_Tasks__c = 0;
                                }
                                cst.get(newMap.get(tsk.Id).WhatId).Open_Tasks__c += 1;
                            }
                            else if(newMap.get(tsk.Id).Status == 'Completed')
                            {
                                if(cst.get(newMap.get(tsk.Id).WhatId).Completed_Tasks__c == null)
                                {
                                    cst.get(newMap.get(tsk.Id).WhatId).Completed_Tasks__c = 0;
                                }
                                cst.get(newMap.get(tsk.Id).WhatId).Completed_Tasks__c += 1;
                            }  
                        }
                        
                       
                        //Data Added
                       // System.debug('::::WhatId:::::'+newMap.get(tskId).WhatId); 
                     
                }
                
                update cst.values();
            }
        }
             
        }
    
        public static void updateTask(Map<Id, Task> newMap, Map<Id, Task> OldMap)
        {
            Set<Id> idSet = new Set<Id>();
            for(Task tk : newMap.values())
            {
                idSet.add(tk.whatId);
            }
            if(idSet.size()>0)
            {
            List<Design_Challenge__c> cst = [Select Id, Open_Tasks__c, Completed_Tasks__c from Design_Challenge__c where Id IN: idSet ];
            Integer count1 = 0;
            Integer count2 = 0;
            if(cst != null && cst.size()>0)
            {
                for( Id tskId : newMap.keySet())
                {
                    Task oldTask = OldMap.get(tskId);
                    if(oldTask.Status != newMap.get(tskId).Status && oldTask.Status == 'Completed')
                    {
                        count1++;
                        if(cst[0].Completed_Tasks__c > 0)
                        {
                            count2--;
                        }
                    }
                    else if(oldTask.Status != newMap.get(tskId).Status && newMap.get(tskId).Status  == 'Completed' && oldTask.Status != 'Completed')
                    {
                        if(cst[0].Open_Tasks__c > 0)
                        {
                            count1--;
                        }
                        count2++;
                    }               
               

                }
                if(cst[0].Completed_Tasks__c == null)
                {
                    cst[0].Completed_Tasks__c = 0;
                }
                cst[0].Completed_Tasks__c += count2;
                if( cst[0].Open_Tasks__c == null)
                {
                    cst[0].Open_Tasks__c = 0;
                }
                cst[0].Open_Tasks__c += count1;
                update cst;
            }
            }
        }
        
/* This method is added for Deletion trigger */
       

public static void deleteTask(Map<Id, Task> oldMap)
        {
            Set<Id> idSet = new Set<Id>();
            for(Task tk : oldMap.values())
            {
                idSet.add(tk.whatId);
            }
            if(idSet.size()>0)
            {
                List<Design_Challenge__c> cst = [Select Id, Open_Tasks__c, Completed_Tasks__c from Design_Challenge__c where Id IN: idSet ];
                //List<Task> th = Trigger.old;
                if(cst != null && cst.size()>0)
                {
                    Integer count1 = 0;
                    Integer count2 = 0;
                    for( Id tskId : oldMap.keySet())
                    {
                        If (oldMap.get(tskId).Status !='Completed')
                        {
                            count1--;
                        }
                        else if(oldMap.get(tskId).Status == 'Completed')
                        {
                            count2--;
                        }                
                
                               

                    }
                     if(cst[0].Completed_Tasks__c == null)
                    {
                        cst[0].Completed_Tasks__c = 0;
                    }
                    cst[0].Completed_Tasks__c += count2;
                    if( cst[0].Open_Tasks__c == null)
                    {
                        cst[0].Open_Tasks__c = 0;
                    }
                    cst[0].Open_Tasks__c += count1;
                    update cst;
                        
                }
            }
        }


        
    }