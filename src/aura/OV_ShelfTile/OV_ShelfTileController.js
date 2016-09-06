({
    doInit: function(component, event, helper) {
        // set flag if current report tile should be expanded initially
        if (component.get('v.shelfTile.shelfTileId') === component.get('v.activeShelfTileId')) {
            component.set('v.reportListShown', true);
        }
    },
    showReportsList: function(component, event, helper) {
        if ($A.get('$Browser.isPhone') || $A.get('$Browser.isAndroid') || $A.get('$Browser.isIOS') ) {
            var evt = $A.get('e.c:OV_NavigationEvent');
            evt.setParams({
                componentDef: 'c:OV_ComponentWrapper',
                componentAttributes: {
                    wrappedObject: {
                        componentDef: 'c:OV_ShelfTileContent',
                        componentAttributes: {
                            shelfId        : component.get('v.shelfTile.shelfTileId'),
                            filters        : component.get('v.filters'),
                            shelfTile      : component.get('v.shelfTile'),
                            shelfColour    : component.get('v.shelfColour'),
                            shelfIcon      : component.get('v.shelfTile.shelfTileIconName'),
                            shelfTitle     : component.get('v.shelfTitle'),
                            shelfTileTitle : component.get('v.shelfTile.shelfTileTitle')
                        }
                    }
                }
            });
            evt.fire();

        } else {
            // fire the event with tile data ...
            var isReportVisible = component.get('v.reportListShown') || false;
            isReportVisible     = isReportVisible === false ? true : false;
            component.set('v.reportListShown', isReportVisible);

            $A.get('e.c:OV_ShelfTileExpandEvent').setParams({
                shelfId          : component.get('v.shelfTile.shelfTileId'),
                shelfTileShelfId : component.get('v.shelfTileShelfId'),
                filters          : component.get('v.filters'),
                shelfTile        : component.get('v.shelfTile'),
                shelfColour      : component.get('v.shelfColour'),
                shelfIcon        : component.get('v.shelfTile.shelfTileIconName'),
                shelfTitle       : component.get('v.shelfTitle'),
                shelfTileTitle   : component.get('v.shelfTile.shelfTileTitle'),
                isVisible        : isReportVisible
            }).fire();

            $A.get('e.c:OV_ShelfToggleEvent').setParams({
                shelfTileId : component.get('v.shelfTile.shelfTileId')
            }).fire();

            // hide all folders
            $A.get('e.c:OV_ShelfTileFolderExpandEvent').setParams({
                componentId      : 'dummy',
                shelfTileId      : 'dummy',
                shelfTileShelfId : 'dummy',
                headerTitle      : 'dummy',
                shelfColour      : 'dummy',
                shelfIcon        : 'dummy',
                reportList       : 'dummy',
                folderName       : 'dummy',
                isVisible        : false
            }).fire();
        }
    },
    handleToggleEvent: function(component, event, helper) {
        // get current value
        var reportListShown = component.get('v.reportListShown');
        // change it if needed
        if (component.get('v.shelfTile.shelfTileId') !== event.getParam('shelfTileId') && reportListShown !== false) {
            component.set('v.reportListShown', false);
        }
    }
})