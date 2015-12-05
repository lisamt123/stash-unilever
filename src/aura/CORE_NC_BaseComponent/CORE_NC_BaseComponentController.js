({

    gloablNewsActive: function(component, event, helper) {
        //alert(1);     
        var menuStyle;   
        if(component.get("v.paulsBlogPannel")==true){
            menuStyle = component.find("paulsBlog");
            $A.util.removeClass(menuStyle, "activeMenu");
            $A.util.addClass(menuStyle, "inactiveMenu");
        } else if (component.get("v.myNewsPannel")==true) {
            menuStyle = component.find("myNews");
            $A.util.removeClass(menuStyle, "activeMenu");
            $A.util.addClass(menuStyle, "inactiveMenu");  
        }
        menuStyle = component.find("globalNews");
        $A.util.removeClass(menuStyle, "inactiveMenu");
        $A.util.addClass(menuStyle, "activeMenu");
        component.set("v.gloablNewsPannel",true);
        component.set("v.paulsBlogPannel",false);
        component.set("v.myNewsPannel",false);
	},
    paulsBlogActive: function(component, event, helper) {
        //alert(2);      
        var menuStyle;   
        if(component.get("v.gloablNewsPannel")==true){
            menuStyle = component.find("globalNews");
       		$A.util.removeClass(menuStyle, "activeMenu");
        	$A.util.addClass(menuStyle, "inactiveMenu");
        } else if (component.get("v.myNewsPannel")==true) {
            menuStyle = component.find("myNews");
            $A.util.removeClass(menuStyle, "activeMenu");
            $A.util.addClass(menuStyle, "inactiveMenu");  
        }
        menuStyle = component.find("paulsBlog");
        $A.util.removeClass(menuStyle, "inactiveMenu");
        $A.util.addClass(menuStyle, "activeMenu");
        component.set("v.gloablNewsPannel",false);
        component.set("v.paulsBlogPannel",true);
        component.set("v.myNewsPannel",false);
                
	},
    myNewsActive: function(component, event, helper) {
        //alert(3);
        //
        var menuStyle;   
        if(component.get("v.gloablNewsPannel")==true){
            menuStyle = component.find("globalNews");
       		$A.util.removeClass(menuStyle, "activeMenu");
        	$A.util.addClass(menuStyle, "inactiveMenu");
        } else if(component.get("v.paulsBlogPannel")==true){
            menuStyle = component.find("paulsBlog");
            $A.util.removeClass(menuStyle, "activeMenu");
            $A.util.addClass(menuStyle, "inactiveMenu");
        }         
        menuStyle = component.find("myNews");
        $A.util.removeClass(menuStyle, "inactiveMenu");
        $A.util.addClass(menuStyle, "activeMenu");
        
        component.set("v.gloablNewsPannel",false);
        component.set("v.paulsBlogPannel",false);
        component.set("v.myNewsPannel",true);
	},
    updatePanel : function(component, event, helper) {
		// alert(1);
		// 
        //alert(component.get("v.NewsType"));
        component.set("v.display",true);
        var menuStyle = component.find("globalNews");
        $A.util.addClass(menuStyle, "inactiveMenu");
        menuStyle = component.find("paulsBlog");
        $A.util.addClass(menuStyle, "inactiveMenu");
        menuStyle = component.find("myNews");
        $A.util.addClass(menuStyle, "inactiveMenu");
        switch (component.get("v.NewsType")) {
            case "PaulsBlog":   menuStyle = component.find("paulsBlog");
        						$A.util.removeClass(menuStyle, "inactiveMenu");
        						$A.util.addClass(menuStyle, "activeMenu");
                                component.set("v.gloablNewsPannel",false);
                                component.set("v.paulsBlogPannel",true);
                                component.set("v.myNewsPannel",false);  
                				break;
            case "MyNews":  menuStyle = component.find("myNews");
                			$A.util.removeClass(menuStyle, "inactiveMenu");
        					$A.util.addClass(menuStyle, "activeMenu");
                            component.set("v.gloablNewsPannel",false);
                            component.set("v.paulsBlogPannel",false);
                            component.set("v.myNewsPannel",true);  
                			break;
            default: menuStyle = component.find("globalNews");
            		 $A.util.removeClass(menuStyle, "inactiveMenu");
        			 $A.util.addClass(menuStyle, "activeMenu");
                     component.set("v.gloablNewsPannel",true);
                     component.set("v.paulsBlogPannel",false);
                     component.set("v.myNewsPannel",false);    
        }    
	},    
    getRecentNews : function(component, event, helper) {
		var getRecNews = $A.get("e.c:updateExpenseItem");
        var tabtype="GlobalNews";
        //Set the expense data on the event and fire it
        getRecNews.setParams({ "tabType": tabtype }).fire();
	}
    
})