({
	scrollToLocation : function(cmp, location) {
       var cssScrolltoTop = $(".scroller");
        //var cssScrolltoTop = component.find("scrollID").get("v.class");
        if (cssScrolltoTop) {
            var cssScrolltoTopTransform = cssScrolltoTop.css("transform");
            if (cssScrolltoTopTransform) {
                cssScrolltoTop.css("transform", "translate3d(0px, 0px, 0px)"); //set 'transform' since lighntning architecture uses css 'transfrom' property to scroll 
            }
        }

		
	}
})