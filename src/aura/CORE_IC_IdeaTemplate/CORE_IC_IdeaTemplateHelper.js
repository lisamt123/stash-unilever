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
        
        return scroller;
    },
    loadDetailPageComponent : function(component,componentName,recordDetailInfo,recordTypeInfo,parentRecord,pannelTypeInfo,articleIdInfo) {
        console.log('-------------------------'+articleIdInfo);
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("IdeasPannel");
            content.set("v.body", view);
        }, {
            componentDef: componentName,
            attributes: {
                values: {
                    recordDetail: recordDetailInfo,
                    recordType: recordTypeInfo,
                    pannelType: pannelTypeInfo,
                    articleId: articleIdInfo,
                    parentRecordDetail: parentRecord
                }
            }
        }, component);
    },
    loadNewComponent : function(component,componentName,pannelType) {
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("IdeasPannel");
            content.set("v.body", view);
        }, {
            componentDef: componentName,
            attributes: {
                values: {
                    pannelType: pannelType
                }
            }
        }, component);  
    },
    loadFeedBack : function(component,destination,pannelType){
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("IdeasPannel");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
            values: {
            Appname:component.get("v.appName"),
            Pagename:component.get("v.pageName"),
            EventName: "CORE_IC_IdeaTemplateEvent",
            tabName: pannelType,
            showTranslation: false
        }}}, component);
    }
})