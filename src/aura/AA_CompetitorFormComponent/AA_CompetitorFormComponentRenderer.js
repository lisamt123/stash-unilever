({
    afterRender : function(component, helper) {
        this.superAfterRender(); 
        if( navigator.userAgent.match(/Android/i)){
            var targetEl = component.find("containerDiv").getElement();
            targetEl.addEventListener("touchmove", function(e) {
                e.stopPropagation();
            }, false);     
        }
    }
})