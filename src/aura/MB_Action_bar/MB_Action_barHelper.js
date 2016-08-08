({
	scrollToLocation : function(cmp, location) {
        var scroller = this.getScroller(cmp),
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
    getScroller : function(cmp) {
        var elem = cmp.getElement(),
            scroller;
        
        while(elem && !elem.classList.contains("centerUiScroller")) {
            elem = elem.parentElement;
        }        
        
        scroller = $A.componentService.getRenderingComponentForElement(elem);        
        scroller = scroller && scroller.getComponentValueProvider();

        $A.assert(scroller && scroller.isInstanceOf("ui:scroller"), 
                  "SCROLLER NOT FOUND. If this is broken, it's because this was a temporary workaround for something that will be fixed in 202.");
        
        return scroller;
    }
		
	}
})