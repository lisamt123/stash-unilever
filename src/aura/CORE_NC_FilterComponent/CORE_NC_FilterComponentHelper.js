({
	scrollToLocation : function(component) {
        
        
   	  var cssScrolltoTop = $(".scroller");
        if (cssScrolltoTop) {
            var cssScrolltoTopTransform = cssScrolltoTop.css("transform");
            if (cssScrolltoTopTransform) {
                cssScrolltoTop.css("transform", "translate3d(0px, 0px, 0px)"); //set 'transform' since lighntning architecture uses css 'transfrom' property to scroll 
            }
        }
      
     /**   var scroller = this.getScroller(component),
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
        
	    scroller.getEvent("scrollTo").setParams(payload).fire();**/
	},
})