({
	doInit : function(component, event, helper) {
        
        var isTablet = $A.get("$Browser.isTablet");
        var isPhone = $A.get("$Browser.isPhone");
        var isIOS = $A.get("$Browser.isIOS");
        var isAndroid = $A.get("$Browser.isAndroid");
        var isDesktop = ( $A.get("$Browser.formFactor") == "DESKTOP" );
        
        console.log("isTablet" + isTablet);
        console.log("isPhone" + isPhone);
        console.log("isIOS" + isIOS);
        console.log("isAndroid" + isAndroid);
        
        // Note: From W16 we should no longer need to make this check since
        // we are no longer using SF1 experience for desktop
        // we should now just be able to use the aura check for desktop
        
        //if( !isPhone && !isIOS && !isAndroid )
        if( isDesktop == true )
        {
            component.set("v.deviceType", "Desktop");
            component.set("v.isDesktop", true);
            console.log("host is desktop");
        }
        else if( isTablet == true )
        {
            component.set("v.deviceType", "Tablet");
            component.set("v.isTablet", true);
            console.log("host is tablet");
        }
        else if( isPhone == true )
        {
            component.set("v.deviceType", "Phone");
            component.set("v.isPhone", true);
            console.log("host is mobile");
        }
        else
        {
            component.set("v.deviceType", "Desktop");
            component.set("v.isDesktop", true);
            console.log("host unknown, defaulting to desktop");
        }
        
        console.log("component.deviceType:" + component.get("v.deviceType"));

	}
})