({
	gotoIdeas : function(component) {
        console.log("coming in loop"+component.get("v.tabName")+"--"+component.get("v.recordId"));
        var backEvent=$A.get("e.c:"+component.get("v.EventName"));
        backEvent.setParams({"Pagename":component.get("v.Pagename"),"pannelType":component.get("v.tabName"),"recordId":component.get("v.recordId")});
        backEvent.fire();
	},
    
    gotoTEM:function(component) {
        var backEvent=$A.get("e.c:"+component.get("v.EventName"));
        backEvent.setParams({"Pagename":component.get("v.Pagename"),"selectedMonth":component.get("v.selectedMonth")});
        backEvent.fire();
    },
    gotoApproval:function(component) { 
        var backEvent=$A.get("e.c:"+component.get("v.EventName"));
        backEvent.setParams({"Pagename": "Detail"});
        /*if(component.get("v.Pagename") === "Pending" )
            backEvent.setParams({"Pagename": "Pending"});
        if(component.get("v.Pagename") === "Closed" )
            backEvent.setParams({"Pagename": "Closed"});
        if(component.get("v.Pagename") === undefined ){
            backEvent.setParams({"Pagename": "Home"});
            backEvent.setParams({"Pagename": "Detail"});
        }   */ 
        backEvent.fire();
    },
    gotoApp:function(component) {
        console.log(component.get("v.EventName")+"-->"+component.get("v.Pagename"));
        var backEvent=$A.get("e.c:"+component.get("v.EventName"));
        backEvent.setParams({"Pagename":component.get("v.Pagename")});
        backEvent.fire();
    }
})