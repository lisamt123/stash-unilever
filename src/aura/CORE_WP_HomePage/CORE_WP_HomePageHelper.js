({
	scrollToLocation : function(component) {
        var cssScrolltoTop = $(".scroller");
       // var cssScrolltoTop = component.find("scrollID").get("v.class");
        if (cssScrolltoTop) {
            var cssScrolltoTopTransform = cssScrolltoTop.css("transform");
            if (cssScrolltoTopTransform) {
                cssScrolltoTop.css("transform", "translate3d(0px, 0px, 0px)"); //set 'transform' since lighntning architecture uses css 'transfrom' property to scroll 
            }
        }
      /*  var scroller = this.getScroller(component),
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
        
    getScroller : function(component) {
        var elem = component.getElement(),
            scroller;
        
        while(elem && !elem.classList.contains("centerUiScroller")) {
            elem = elem.parentElement;
        }        
        
        scroller = $A.componentService.getRenderingComponentForElement(elem);        
        scroller = scroller && scroller.getComponentValueProvider();
		var displayErrorMessage="SCROLLER NOT FOUND. If this is broken, it's because this was a temporary workaround for something that will be fixed in 202.";
        $A.assert(scroller && scroller.isInstanceOf("ui:scroller"), displayErrorMessage);
        
        return scroller; */
    }
})