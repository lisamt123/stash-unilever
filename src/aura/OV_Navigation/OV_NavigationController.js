({
    doInit: function(component, event, helper) {
        var Browser = $A.get('$Browser');

        if (Browser.isPhone === false && Browser.isTablet === false) {
            // welcome to the house of fun ...
            helper.redirect(component);
        }
    },

    swapInComponent: function(component, event, helper) {
        if (component.isValid() === true) {
            helper.loadComponent(
                component,
                event.getParam('componentDef'),
                event.getParam('componentAttributes')
            );
        }
    },

    handleDestroy: function(component, event, helper) {
        // destroy inner component first
    },

    onLocationChange: function(component, event, helper) {
        // destroy inner component first
        if (helper.isLocationChanged(event.getParams()) === true) {
            // clear body of this component
            helper.destroyBody(component);
            if (component.isValid() === true) {
                // unrender current component
                component.unrender();
                // call destroy on parent aura:container
                component.getSuper().destroy(false);
            }
        }
    },

    // need to have it to save filters as they do not receive event because home component is not loaded
    applyFilters: function(component, event, helper) {
        var subjectTabConfig = {
            'reportCategory'    : event.getParam('categoryId') || '',
            'reportGeography'   : event.getParam('geographyId') || '',
            'reportFunction'    : event.getParam('functionId') || '',
            'reportVisibleToMe' : event.getParam('reportVisibleToMe') || false,
            'recordTypeName'    : 'Subject'
        };

        helper.storeFilterSettings(component, subjectTabConfig);
    },

    tabViewClicked : function(component, event, helper) {
        helper.replaceHistoryEntry(component, event.getParam('targetViewId'));
    },

    handleTileClick: function(component, event, helper) {
        var activeShelfTile      = event.getParam('isVisible') === true ? event.getParam('shelfId') : null;

        component.set('v.activeShelfTile', activeShelfTile);
        component.set('v.activeShelfFolderTile', null);
        component.set('v.activeFolderName', null);

        helper.replaceShelfHistoryEntry(component, activeShelfTile);
    },

    handleFolderClick: function(component, event, helper) {
        var activeShelfFolderTile = event.getParam('isVisible') === true ? event.getParam('shelfTileId') : null;
        var activeFolderName      = event.getParam('isVisible') === true ? event.getParam('folderName') : null;

        component.set('v.activeShelfFolderTile', activeShelfFolderTile);
        component.set('v.activeFolderName', activeFolderName);

        helper.replaceShelfFolderHistoryEntry(component, activeShelfFolderTile, activeFolderName);
    }
})