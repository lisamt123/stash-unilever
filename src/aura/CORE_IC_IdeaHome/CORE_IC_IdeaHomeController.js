({
	campaignsListDisplay : function(component, event, helper) {
        if(component.get("v.pannelType")!="campaignsListPannel"){
        	helper.updatePannelStyle(component, "campaignsListPannel");  
        }
        console.log('-------campaign---2----'+component.get("v.pannelType"));
        console.log('-------campaignsListPannel----1---'+component.get("v.campaignsListPannel"));
        console.log('-------ideasListPannel----1---'+component.get("v.ideasListPannel"));
        console.log('-------myUpdatesPannel----1---'+component.get("v.myUpdatesPannel"));
	},
    ideasListDisplay: function(component, event, helper) {
        if(component.get("v.pannelType")!="ideasListPannel"){
        	helper.updatePannelStyle(component, "ideasListPannel");  
        }
        console.log('-------idea---2----'+component.get("v.pannelType"));
        console.log('-------campaignsListPannel----1---'+component.get("v.campaignsListPannel"));
        console.log('-------ideasListPannel----1---'+component.get("v.ideasListPannel"));
        console.log('-------myUpdatesPannel----1---'+component.get("v.myUpdatesPannel"));
	},
    myUpdatesDisplay: function(component, event, helper) {    
        if(component.get("v.pannelType")!="myUpdatesPannel"){
        	helper.updatePannelStyle(component, "myUpdatesPannel");  
        }
        console.log('-------myupdats----2---'+component.get("v.pannelType"));
        console.log('-------campaignsListPannel----1---'+component.get("v.campaignsListPannel"));
        console.log('-------ideasListPannel----1---'+component.get("v.ideasListPannel"));
        console.log('-------myUpdatesPannel----1---'+component.get("v.myUpdatesPannel"));
	},
   /*navigateToFaq: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaFaqs","pannelType":component.get("v.pannelType")}).fire();
    },*/
    updatePanel : function(component, event, helper) {
        var menuStyle = component.find("campaignsListPannel");
        $A.util.addClass(menuStyle, "inactiveMenu");
        menuStyle = component.find("ideasListPannel");
        $A.util.addClass(menuStyle, "inactiveMenu");
        menuStyle = component.find("myUpdatesPannel");
        $A.util.addClass(menuStyle, "inactiveMenu");
        
        component.set("v.campaignsListPannel",false);
        component.set("v.ideasListPannel",false);
        component.set("v.myUpdatesPannel",false);  
        helper.setActivePannel(component); 
                
	},   
   
})