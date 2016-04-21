({
	doInit : function(component, event, helper) {
     
        var action=component.get("c.getUserActivities");
        var actvity=[];
        action.setCallback(this, function(response) {
            var state = response.getState();
            var active=[];
            var inactiveActivities=new Array();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var items=response.getReturnValue();
                 
                 for(var i=0;i<items.length;i++)
                 {
                     console.log(items[i].isActive);
                     if(items[i].isActive ===true)
                     {
                         active.push(items[i]);
                     }
                     
                     else if(items[i].isActive ===false)
                     {
                            inactiveActivities[items[i].activity_name] = items[i];
                     }
                 }
                console.log("@@"+active.length);
                
                var inactive=new Array();
                
                  for(var item in inactiveActivities)
                  {
                    //if(!completedactivityMap.has(completedActivity[i].activity_name))
                    //{
                           //alert("coming");           
                       inactive.push(inactiveActivities[item]);
                         
                    //}
                }
                
                var completedActivity=[];
                
              /* For Completed Activities */  
                for(var i=0;i<active.length;i++)
                {
                    if(active[i].invitation_status ==='Self' || active[i].invitation_status ==='Accepted')
                    {
                        
                        completedActivity.push(active[i]);
                    }
                    
                }
                
                
                
                //alert("completedinitial"+completedActivity.length);
                var completedactivityMap=new Array();
                
                for(var i=0;i<completedActivity.length;i++)
                {
                               
                        completedactivityMap[completedActivity[i].activity_name] = completedActivity[i];
                         
                                  }

                //alert(completedactivityMap.length);
                var finalActivityList= new Array();
                //finalActivityList=completedactivityMap.values();
                for(var item in completedactivityMap)
                {
                   
                    finalActivityList.push(completedactivityMap[item]);
                }
                
                 //alert("completedfinal"+finalActivityList.length);
               /* For Completed Activities */  
                
               /* For Invited  Activities */  
                var invitedActivities=[];
                 for(var i=0;i<active.length;i++)
                {
                    if(active[i].invitation_status ==='Invited')
                    {
                        
                        invitedActivities.push(active[i]);
                    }
                    
                }
                
              
              
                if(items.length>0){
                    component.set("v.acivities", response.getReturnValue());
                     component.set("v.Active_activities", finalActivityList);
                      component.set("v.invitedActivities", invitedActivities);
                     component.set("v.Inactive_acivities", inactive);
                    
                }
                else{
                    component.set("v.showmessage",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
})