({ 
        scrollToLocation : function(component, location) { 
            component.set("v.spinnercompGtes",true);
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
        	component.set("v.spinnercompGtes",false);
            scroller.getEvent("scrollTo").setParams(payload).fire(); 
        }, 
    
    //THIS IS AN ABSOLUTE HACK AND MOST LIKELY WILL BREAK IN SUMMER16! 
    getScroller : function(component) { 
        var elem = component.getElement(), 
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
})