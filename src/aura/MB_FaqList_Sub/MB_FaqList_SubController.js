({
    showDiv : function(component, event, helper) {
        var toggleText = component.find("text");
        component.set("v.showDiv",true); 
        $A.util.toggleClass(toggleText, "toggle");
        var img=component.find("myimg");
        $A.util.toggleClass(img, "toggle");
        var img2=component.find("myimg2");
        $A.util.toggleClass(img2, "upFaq");
    },
    
    
})