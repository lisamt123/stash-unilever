({
    
    submitDetail : function (component, event, helper) {
        
        var trainerName=component.get("v.externalName");
        var trainerTitle = component.get("v.externalTitle");
        var trainerEmail = component.get("v.externalEmail");
        var trainerPhone = component.get("v.externalContact");
        var trainerProfile = component.get("v.externalProfile");
        var action= component.get("c.saveTrainerDetail");
        
        action.setParams({
            "role":"Trainer",
            "EventId":"aDjV00000004ConKAE",
            "externalName": trainerName,
            "externalTitle": trainerTitle,
            "externalContact":trainerPhone,
            "externalEmail":trainerEmail,
            "externalProfile":trainerProfile
        });
        $A.enqueueAction(action);
        
    },
    
})