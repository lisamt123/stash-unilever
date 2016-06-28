({
    onCheck : function(component, event, helper) {
        var checkCmp = component.find("checkBusinessPrinciple");
        component.set("v.businessPrincipleFlag",checkCmp.get("v.value"))
    },
    submitForm : function(component, event, helper) {
        helper.updateTermAndCondition(component);
    }  
})