({
    doInit: function(component, event, helper) {
        // generate random tab set id
        component.set('v.jsBaseTabSet', 'tabs_' + Math.round(Math.random() * 1000000,0));

        // assign css to body area
        var browser = $A.get('$Browser');
        var classes = ['OVBS', 'bootstrap-sf1'];

        if (browser.isPhone === true) {
            classes.push('OV_phone');
        } else if (browser.isIOS === true || browser.isAndroid === true) {
            classes.push('OV_tablet');
        } else {
            classes.push('OV_desktop');
        }

        component.set('v.componentBodyClass', classes.join(' '));

        // render component
        var cmp = component.get('v.wrappedObject');
        if (cmp) {
            if (cmp.componentDef) {
                $A.createComponent(
                    cmp.componentDef,
                    cmp.componentAttributes || {},
                    function(newComponent) {
                        component.set('v.renderComponent', true);
                        component.find('renderComponentArea').set('v.body', [newComponent]);
                    }
                );
            } else if (cmp.url) {
                component.set('v.renderIframe', true);
                component.set('v.renderBackArrow', true);
                component.set('v.iframeSrc', cmp.url);
            }
        }

        // set default menu item (nothing get's selected since now)
        component.set('v.defaultMenuItem', '');
    },

    goBack : function(component, event, helper) {
        window.history.go(-1);
    },

    onTabClick: function(component, event, helper) {
        var evt = $A.get('e.c:OV_NavigationEvent');
        evt.setParams({
            componentDef: 'c:OV_Home',
            componentAttributes: {
                defaultMenuItem: event.getParam('targetViewId') || 'SUBJECTS'
            }
        });
        evt.fire();
    }
})