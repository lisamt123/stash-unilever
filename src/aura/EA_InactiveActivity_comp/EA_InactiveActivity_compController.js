({
	myAction : function(component, event, helper) {
        var act=component.get("v.activity");
        console.log("###"+act.theme_name);
        component.set("v.showLoading",false);
		
	}
})