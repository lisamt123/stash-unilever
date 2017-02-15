Public with sharing class SAJ_BusinessSolutionTriggerHandller
    {
        
//------------------------------------------------------------Insert Task Method-------------------------------------------------------------------------
        public static void insertTask(Map<Id, Task> newMap)
        {
            String Cmp = 'Completed';
            String DCKeyPrefix = Business_Solution__c.sObjectType.getDescribe().getKeyPrefix();
            Set<Id> idSet = new Set<Id>();
            for(Task tk : newMap.values())
            {
                if(tk.WhatId != null && String.valueOf(tk.WhatId).startsWith(DCKeyPrefix)){
                    idSet.add(tk.whatId);
                }
            }
            
            if(idSet.size()>0)
            {
                //List<Business_Solution__c> dcToUpdate = new List<Business_Solution__c>();
                Map<Id, Business_Solution__c> cst = new Map<Id,Business_Solution__c>([Select Id, Open_Tasks__c, Completed_Tasks__c from Business_Solution__c where Id IN: idSet ]); 
                if(cst != null && cst.size()>0)
                {
                    //Integer count1 = 0;
                    //Integer count2 = 0;
                    for( Task tsk : newMap.values())
                    {
                        if(tsk.WhatId != null && cst.containsKey(tsk.WhatId)){
                            If (newMap.get(tsk.Id).Status != Cmp)
                            {
                               if( cst.get(newMap.get(tsk.Id).WhatId).Open_Tasks__c == null)
                                {
                                    cst.get(newMap.get(tsk.Id).WhatId).Open_Tasks__c = 0;
                                }
                                cst.get(newMap.get(tsk.Id).WhatId).Open_Tasks__c += 1;
                            }
                            else if(newMap.get(tsk.Id).Status == Cmp)
                            {
                                if(cst.get(newMap.get(tsk.Id).WhatId).Completed_Tasks__c == null)
                                {
                                    cst.get(newMap.get(tsk.Id).WhatId).Completed_Tasks__c = 0;
                                }
                                cst.get(newMap.get(tsk.Id).WhatId).Completed_Tasks__c += 1;
                            }  
                        }

                }
                
                update cst.values();
            }
        }
             
        }
//-----------------------------------------------------Update Task Method------------------------------------------------------------------------------------------   
        public static void updateTask(Map<Id, Task> newMap, Map<Id, Task> OldMap)
        {
            String Cmp = 'Completed';
           String DCKeyPrefix = Business_Solution__c.sObjectType.getDescribe().getKeyPrefix();
            Set<Id> idSet = new Set<Id>();
            for(Task tk : newMap.values())
            {
                if(tk.WhatId != null && String.valueOf(tk.WhatId).startsWith(DCKeyPrefix)){
                    idSet.add(tk.whatId);
                }
            }
            if(idSet.size()>0)
            {
            Map<Id, Business_Solution__c> cst = new Map<Id,Business_Solution__c>([Select Id, Open_Tasks__c, Completed_Tasks__c from Business_Solution__c where Id IN: idSet ]); 
            Integer count1 = 0;
            Integer count2 = 0;
            if(cst != null && cst.size()>0)
            {
                for( Id tskId : newMap.keySet())
                {
                    Task oldTask = OldMap.get(tskId);
                    if(oldTask.Status != newMap.get(tskId).Status && oldTask.Status == Cmp)
                    {
                        count1++;
                        if(cst.get(newMap.get(tskId).WhatId).Completed_Tasks__c > 0)
                        {
                            count2--;
                        }
                    }
                    else if(oldTask.Status != newMap.get(tskId).Status && newMap.get(tskId).Status  == Cmp && oldTask.Status != Cmp)
                    {
                        if(cst.get(newMap.get(tskId).WhatId).Open_Tasks__c > 0)
                        {
                            count1--;
                        }
                        count2++;
                                  
               

                }
                if(cst.get(newMap.get(tskId).WhatId).Completed_Tasks__c == null)
                {
                    cst.get(newMap.get(tskId).WhatId).Completed_Tasks__c = 0;
                }
                cst.get(newMap.get(tskId).WhatId).Completed_Tasks__c += count2;
                if( cst.get(newMap.get(tskId).WhatId).Open_Tasks__c == null)
                {
                    cst.get(newMap.get(tskId).WhatId).Open_Tasks__c = 0;
                }
                cst.get(newMap.get(tskId).WhatId).Open_Tasks__c += count1;
                }
                update cst.Values();
            }
            }
        }

//-------------------------------Delete Task Method----------------------------------------------------------------------------

    public static void deleteTask(Map<Id, Task> oldMap)
    {
            String Cmp = 'Completed';
            String DCKeyPrefix = Business_Solution__c.sObjectType.getDescribe().getKeyPrefix();
            Set<Id> idSet = new Set<Id>();
            for(Task tk : oldMap.values())
            {
               // if(tk.WhatId != null && String.valueOf(tk.WhatId).startsWith(DCKeyPrefix))
               // {
                    idSet.add(tk.whatId);
               // }
            }
            if(idSet.size()>0)
                {
                    //List<Business_Solution__c> dcToUpdate = new List<Business_Solution__c>();
                    Map<Id, Business_Solution__c> cst = new Map<Id,Business_Solution__c>([Select Id, Open_Tasks__c, Completed_Tasks__c from Business_Solution__c where Id IN: idSet ]); 
                    if(cst != null && cst.size()>0)
                    {
                        //Integer count1 = 0;
                        //Integer count2 = 0;
                        for( Task tsk : oldMap.values())
                        {
                            if(tsk.WhatId != null && cst.containsKey(tsk.WhatId))
                            {
                                If (oldMap.get(tsk.Id).Status != Cmp)
                                {
                                    if( cst.get(oldMap.get(tsk.Id).WhatId).Open_Tasks__c == null)
                                    {
                                        cst.get(oldMap.get(tsk.Id).WhatId).Open_Tasks__c = 0;
                                    }
                                    cst.get(oldMap.get(tsk.Id).WhatId).Open_Tasks__c -= 1;
                                }
                                else if(oldMap.get(tsk.Id).Status == Cmp)
                                {
                                    if(cst.get(oldMap.get(tsk.Id).WhatId).Completed_Tasks__c == null)
                                    {
                                        cst.get(oldMap.get(tsk.Id).WhatId).Completed_Tasks__c = 0;
                                    }
                                    cst.get(oldMap.get(tsk.Id).WhatId).Completed_Tasks__c -= 1;
                                }  
                            } 
                    }
                
                    update cst.values();
                }
            }
    }
}