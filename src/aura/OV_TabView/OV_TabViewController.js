({
    tabSelect: function(cmp, e) {
        e.preventDefault();

        var cmpRoot        = cmp.find('navBar');
        var cmpRootElement = cmpRoot.getElement();
        var allTabSelector = cmp.get('v.navbarUid');
        // deselect all the tabs
        var allTabs        = cmpRootElement.getElementsByClassName(allTabSelector);

        for (var i = 0; i < allTabs.length; i++) {
            $A.util.removeClass(allTabs[i], 'active');
        }
        // add the active class to the selected tab
        $A.util.addClass(e.target.parentElement, 'active');
        // fire the event
        var tabClickEvent = cmp.getEvent('tabClick');
        var eventArgs     = {};
        if (e.target.dataset && e.target.dataset.tabtarget) {
            eventArgs.targetViewId = e.target.dataset.tabtarget;
        } else {
            eventArgs.targetViewId = e.target.attributes.getNamedItem('data-tabtarget').nodeValue;
        }

        $A.OV             = $A.OV || {};
        $A.OV.selectedTab = eventArgs.targetViewId;

        tabClickEvent.setParams(eventArgs);
        tabClickEvent.fire();
    },

    goBack : function(component, event, helper) {
        window.history.go(-1);
    },

    navigateToFilters: function(component, event) {
        var evt = $A.get('e.c:OV_NavigationEvent');
        evt.setParams({
            componentDef        : 'c:OV_ComponentWrapper',
            componentAttributes : {
                renderBackArrow : true,
                wrappedObject   : {
                    componentDef: 'c:OV_FiltersDropdown',
                    componentAttributes: {}
                }
            }
        });
        evt.fire();
    }
})