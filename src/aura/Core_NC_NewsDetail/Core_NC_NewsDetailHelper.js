({
	scrollToLocation : function(component, location) {
        var scroller = this.getScroller(component),
            payload = {
                time: 300,
            };
        
        if(typeof location === "string") {
            payload.destination = location;
        } else if(location instanceof HTMLElement) {
            payload.destination = "custom";
        	payload.xcoord = location.offsetLeft;
        	payload.ycoord = -location.offsetTop;
        }
        
	    scroller.getEvent("scrollTo").setParams(payload).fire();
	},
      //THIS IS AN ABSOLUTE HACK AND MOST LIKELY WILL BREAK IN SUMMER16! 
    getScroller : function(component) {
        var elem = component.getElement(),scroller;  
        while(elem && !elem.classList.contains("centerUiScroller")) {
            elem = elem.parentElement;
        }        
        scroller = $A.componentService.getRenderingComponentForElement(elem);        
        scroller = scroller && scroller.getComponentValueProvider();
		var displayErrorMessage=$A.get("$Label.c.ErrorMessageLabel");
        $A.assert(scroller && scroller.isInstanceOf("ui:scroller"), displayErrorMessage);
        
        return scroller;
    }
})