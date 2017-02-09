({
    search : function(component, event, helper) {
        helper.doSearch(component, event, helper);        
    },
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
        var updateEvent = component.getEvent("updateUserListEvent");
        // Populate the event with the selected Object Id
        updateEvent.setParams({
            "selectedUser":userList
        });
        // Fire the event
        updateEvent.fire();
    },
    
    handleAdmin:function(component,event,helper){
          var userList=component.get("v.selectedUser");
        alert(component.get("v.Participant_Event"));
        
        var actionParticipantList=component.get("c.getParticipantListWrapper");
         actionParticipantList.setParams({
              "eventId"    :  component.get("v.Participant_Event"),
             "participantList": component.get("v.selectedUser"),
             "Role" : component.get("v.Participant_Role"),
             "Status":component.get("v.Participant_Status")
               
            });
        
            actionParticipantList.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                       var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "The Particiapant has been added successfully."
                        });
                        toastEvent.fire();
               
            }
        });
        $A.enqueueAction(actionParticipantList);
   
    },
})