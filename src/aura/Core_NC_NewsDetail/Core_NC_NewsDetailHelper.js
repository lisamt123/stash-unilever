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
    },
    
    getImage : function(component, NewsId, AttName, exact_path, exact_path1) {
        var act = component.get("c.getAttachmentDetail");
        act.setParams({
            "NewsId": NewsId
        });
        act.setCallback(this, function(response) {
            var state = response.getState();
            /*
            var count = exact_path.match((/<img src/g) || []).length;
            for(var j=0; j<count; j++)
            {
                var xyz = exact_path.replace(/""/g, j);
            }
            alert(xyz);
            */
            if (state === "SUCCESS") {
                if(response.getReturnValue()!==''){
                    var temp = exact_path1;
                    for(var i=0; i<response.getReturnValue().length; i++)
                    {
                        var abc = response.getReturnValue()[i].Id;
						var name =response.getReturnValue()[i].Name;
                        var fullFileURL = AttName + abc;
                        var img = "<img src=\" "+fullFileURL+ "\"></img>";
                       // var regExp = new RegExp('abc'+i+'','g');
                       		
                      //  var newsBody = temp.replace(''+name+'', img);   
                        var newsBody = temp.split(''+name+'').join(img);
                        temp = newsBody;
                    }
                }
            }  
            component.set("v.NewsRichText",newsBody);
          //  component.set("v.NewsRichText",exact_path1);
        });
        $A.enqueueAction(act);
        
    },
    
})