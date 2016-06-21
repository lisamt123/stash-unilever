({
    /**
     * Search an SObject for a match
     */
    search : function(component, event, helper) {
        helper.doSearch(component);        
    },
    
    
    /**
     * Select an SObject from a list
     */
    select: function(component, event, helper) {
        helper.handleSelection(component, event);
    },
    
    remove: function(component, event, helper) {
        var removeId=event.currentTarget.dataset.record;
      var selectedUser=component.get("v.selectedUser");
       
        for (var selected in selectedUser) {
            if (selectedUser.hasOwnProperty(selected)) {
                var obj = selectedUser[selected];
                if(obj.Id===removeId)
                {       
                    var i=selectedUser.indexOf(obj);
                    selectedUser.splice(i,1);
                    component.set("v.selectedUser",selectedUser);
                }
            }
        } 
         if(selectedUser.length === 0)
        {
            component.set("v.showTag","false");
        }
    },
    
    sendUsers:function(component,event,helper){
        
        var userList=component.get("v.selectedUser");
        console.log("Inside the send users"+userList);
        var updateEvent = component.getEvent("updateUserListEvent");
        
        // Populate the event with the selected Object Id
        updateEvent.setParams({
            "selectedUser":userList
        });
        
        // Fire the event
        updateEvent.fire();
        
    },
    
})