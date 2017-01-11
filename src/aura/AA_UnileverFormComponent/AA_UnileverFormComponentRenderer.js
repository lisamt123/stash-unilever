({
    afterRender : function(component, helper) {
        this.superAfterRender(); 
        //if( navigator.userAgent.match(/Android/i)){
        if($A.get("$Browser.isAndroid")){
            var targetEl = component.find("containerDiv").getElement();
            //var targetEl = component.find("containerDiv");
            targetEl.addEventListener("touchmove", function(e) {
                e.stopPropagation();
            }, false);     
        }
    }
})