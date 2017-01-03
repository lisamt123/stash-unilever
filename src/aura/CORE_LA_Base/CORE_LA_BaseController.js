({
    homePageLoad: function(component, event, helper) {
        var content = component.find("content");
        $A.createComponent("c:CORE_LA_Feedback", {},
            function(cmp) {
                content.set("v.body", [cmp]);
            });
    },

    navigateWithinComponent: function(component, event, helper) {
        var content = component.find("content");
        $A.createComponent(event.getParam("componentName"), {},
            function(cmp) {
                content.set("v.body", [cmp]);
            });

    },
})