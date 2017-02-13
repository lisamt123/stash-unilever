Public class SAJ_BusinessSolutionTriggerHandller
    {
        public static void insertTask(Map<Id, Task> newMap)
        {
            Set<Id> idSet = new Set<Id>();
            for(Task tk : newMap.values())
            {
                idSet.add(tk.whatId);
            }
            if(idSet.size()>0)
            {
                List<Business_Solution__c> cst = [Select Id, Open_Tasks__c, Completed_Tasks__c from Business_Solution__c where Id IN: idSet ];
                List<Task> th = Trigger.new;
                if(cst != null && cst.size()>0)
                {
                    Integer count1 = 0;
                    Integer count2 = 0;
                    for( Id tskId : newMap.keySet())
                    {
                        If (newMap.get(tskId).Status !='Completed')
                        {
                            count1++;
                        }
                            else if(newMap.get(tskId).Status == 'Completed')
                            {
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
    
        public static void updateTask(Map<Id, Task> newMap, Map<Id, Task> OldMap)
        {
            Set<Id> idSet = new Set<Id>();
            for(Task tk : newMap.values())
            {
                idSet.add(tk.whatId);
            }
            if(idSet.size()>0)
            {
            List<Business_Solution__c> cst = [Select Id, Open_Tasks__c, Completed_Tasks__c from Business_Solution__c where Id IN: idSet ];
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
                List<Business_Solution__c> cst = [Select Id, Open_Tasks__c, Completed_Tasks__c from Business_Solution__c where Id IN: idSet ];
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