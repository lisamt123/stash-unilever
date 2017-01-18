({
    scrollToLocation : function(component, location) {
        var cssScrolltoTop = $(".scroller"); // css class to find scroll position
       // var cssScrolltoTop = component.find("scrollID").get("v.class");
        if (cssScrolltoTop) {
            var cssScrolltoTopTransform = cssScrolltoTop.css("transform");
            if (cssScrolltoTopTransform) {
                cssScrolltoTop.css("transform", "translate3d(0px, 0px, 0px)"); //set 'transform' since lighntning architecture uses css 'transfrom' property to scroll 
            }
        }
      /*var scroller = this.getScroller(component),
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
        var elem = component.getElement(),
            scroller;
        while(elem && !elem.classList.contains("centerUiScroller")) {
            elem = elem.parentElement;
        }  
        scroller = $A.componentService.getRenderingComponentForElement(elem);        
        scroller = scroller && scroller.getComponentValueProvider();
        $A.assert(scroller && scroller.isInstanceOf("ui:scroller"), 
                  "SCROLLER NOT FOUND. If this is broken, it's because this was a temporary workaround for something that will be fixed in 202.");
        return scroller;*/
    },
    checkMobileBrowser : function(component){
        if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
            return true;	
        }else{
            return false;
        }
    },
    getUsersString : function(component, location) {
        var selectedUsers=component.get("v.selectedUsers");
        var userIdString="";
        for(var sel in selectedUsers){
            if(selectedUsers.hasOwnProperty(sel)){
                var ob=selectedUsers[sel];
                if(userIdString.length === 0){
                    userIdString = ob.Id;
                }
                else{
                    userIdString=userIdString+","+ob.Id;
                }
            }
        }
        return userIdString;
    },
})