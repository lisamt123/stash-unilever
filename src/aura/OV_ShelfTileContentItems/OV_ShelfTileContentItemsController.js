({
    doInit : function(component, event, helper) {
        component.set(
            'v.reportList',
            component.get('v.headingList')[
                component.get('v.headerTitle')
            ]
        );
    },

    doneRendering: function(component, event, helper) {
        // if (component.get('v.folderChecked') !== true) {
        //     var activeFolderTileId = component.get('v.activeFolderTileId');
        //     var shelfTileId        = component.get('v.shelfTileId');
        //     if (activeFolderTileId === shelfTileId) {
        //         var tiles       = component.get('v.reportList');
        //         for (var i = 0, len = tiles.length; i < len; i++) {
        //             // find folder
        //             if (!tiles[i].folderMembers) {
        //                 continue;
        //             }
        //             if (tiles[i].folderName !== 'Hair Care') {
        //                 continue;
        //             }

        //             $A.createComponent(
        //                 'c:OV_ShelfTileFolderContentItems', {
        //                     shelfTileId       : component.get('v.shelfTileId'),
        //                     shelfTileShelfId  : component.get('v.shelfTileShelfId'),
        //                     shelfColour       : component.get('v.shelfColour'),
        //                     shelfIcon         : component.get('v.shelfIcon'),
        //                     reportList        : tiles[i].folderMembers,
        //                     folderName        : tiles[i].folderName,
        //                     headerTitle       : component.get('v.headerTitle'),
        //                     componentId       : component.getGlobalId(),
        //                     shelfTitle        : component.get('v.shelfTitle'),
        //                     shelfTileTitle    : component.get('v.shelfTileTitle'),
        //                     reportListVisible : true
        //                 },
        //                 function(newComponent) {
        //                     if (component.isValid() === true) {
        //                         // add report tiles to component body
        //                         component.set('v.body', [newComponent]);
        //                     }
        //                 }
        //             );

        //             // component.set('v.lastComponentId', event.getParam('componentId'));
        //             break;
        //         }
        //     }
        //     component.set('v.folderChecked', true);
        // }
    },

    doExpandFolder: function(component, event, helper) {
        var isVisible       = event.getParam('isVisible') || false;
        var isCurrentHeader = component.get('v.headerTitle') === event.getParam('headerTitle');
        var isCurrentShelf  = component.get('v.shelfTileShelfId') === event.getParam('shelfTileShelfId');

        component.set('v.reportListVisible', isCurrentHeader && isVisible && isCurrentShelf);

        if ($A.get('$Browser.isPhone') || $A.get('$Browser.isAndroid') || $A.get('$Browser.isIOS') ) {
            var evt = $A.get('e.c:OV_NavigationEvent');
            evt.setParams({
                componentDef: 'c:OV_ComponentWrapper',
                componentAttributes: {
                    wrappedObject: {
                        componentDef: 'c:OV_ShelfTileFolderContentItems',
                        componentAttributes: {
                            shelfTileId    : event.getParam('shelfTileId'),
                            shelfColour    : event.getParam('shelfColour'),
                            shelfIcon      : event.getParam('shelfIcon'),
                            reportList     : event.getParam('reportList'),
                            folderName     : event.getParam('folderName'),
                            headerTitle    : event.getParam('headerTitle'),
                            componentId    : event.getParam('componentId'),
                            shelfTitle     : event.getParam('shelfTitle'),
                            shelfTileTitle : event.getParam('shelfTileTitle')
                        }
                    }
                }
            });
            evt.fire();

            return;
        }

        if (!!component.get('v.lastComponentId') && component.get('v.lastComponentId') !== event.getParam('componentId')) {
            var cmp = $A.getComponent(component.get('v.lastComponentId'));
            cmp.set('v.isExpanded', false);
        }

        if (component.get('v.reportListVisible') === true) {
            $A.createComponent(
                'c:OV_ShelfTileFolderContentItems', {
                    shelfTileId       : event.getParam('shelfTileId'),
                    shelfTileShelfId  : event.getParam('shelfTileShelfId'),
                    shelfColour       : event.getParam('shelfColour'),
                    shelfIcon         : event.getParam('shelfIcon'),
                    reportList        : event.getParam('reportList'),
                    folderName        : event.getParam('folderName'),
                    headerTitle       : event.getParam('headerTitle'),
                    componentId       : event.getParam('componentId'),
                    shelfTitle        : event.getParam('shelfTitle'),
                    shelfTileTitle    : event.getParam('shelfTileTitle'),
                    reportListVisible : true
                },
                function(newComponent) {
                    if (component.isValid() === true) {
                        // add report tiles to component body
                        component.set('v.body', [newComponent]);
                    }
                }
            );

            component.set('v.lastComponentId', event.getParam('componentId'));
        } else {
            component.set('v.body', []);
        }
    }
})