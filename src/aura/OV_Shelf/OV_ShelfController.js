({
    doInit: function(component, event, helper) {
        var activeShelfTileId = component.get('v.activeShelfTileId');
        if (activeShelfTileId) {
            var tiles = component.get('v.shelfItem.shelfTiles');
            for (var i = 0, len = tiles.length; i < len; i++) {
                if (tiles[i].shelfTileId === activeShelfTileId) {
                    $A.get('e.c:OV_ShelfTileExpandEvent').setParams({
                        shelfId          : tiles[i].shelfTileId,
                        shelfTileShelfId : tiles[i].shelfTileShelfId,
                        filters          : component.get('v.filters'),
                        shelfTile        : tiles[i],
                        shelfColour      : component.get('v.shelfItem.shelfColour'),
                        shelfIcon        : tiles[i].shelfTileIconName,
                        shelfTitle       : component.get('v.shelfItem.shelfTitle'),
                        shelfTileTitle   : tiles[i].shelfTileTitle,
                        isVisible        : true
                    }).fire();

                    $A.get('e.c:OV_ShelfToggleEvent').setParams({
                        shelfTileId : activeShelfTileId
                    }).fire();

                    component.set('v.activeShelfTileId', null);
                    break;
                }
            }
        }
    },
    doExpand: function(component, event, helper) {
        var isVisible      = event.getParam('isVisible') || false;
        var shelfId        = event.getParam('shelfId');
        var isCurrentShelf = component.get('v.shelfItem').shelfId === event.getParam('shelfTile').shelfTileShelfId;

        component.set('v.reportListVisible', isCurrentShelf && isVisible);

        if (component.get('v.reportListVisible') === true) {
            var filters          = event.getParam('filters');
            var shelfTile        = event.getParam('shelfTile');
            var shelfColour      = event.getParam('shelfColour');
            var shelfIcon        = event.getParam('shelfIcon');
            var shelfTileShelfId = event.getParam('shelfIcon');
            var lastLoadedTile   = component.get('v.lastLoadedTile');

            // check if reload needed - it is if last loaded tile is different then given one
            if (lastLoadedTile !== shelfId) {
                $A.createComponent(
                    'c:OV_ShelfTileContent', {
                        shelfId            : shelfId,
                        filters            : filters,
                        shelfTile          : shelfTile,
                        shelfColour        : shelfColour,
                        shelfIcon          : shelfIcon,
                        shelfTileShelfId   : shelfTileShelfId,
                        activeFolderTileId : component.get('v.activeFolderTileId'),
                        activeFolderName   : component.get('v.activeFolderName')
                    },
                    function(newComponent) {
                        if (component.isValid() === true) {
                            // add report tiles to component body
                            component.set('v.body', [newComponent]);

                            // remeber that tile was already loaded so we do not repeat the request
                            component.set('v.lastLoadedTile', shelfId);

                            // expand folder ?
                            helper.expandFolder(component, newComponent);

                            component.set('v.activeShelfTileId', null);
                            component.set('v.activeFolderTileId', null);
                            component.set('v.activeFolderName', null);
                        }
                    }
                );
            }
        } else {
            // add report tiles to component body
            component.set('v.body', []);
            component.set('v.lastLoadedTile', null);
        }
    }
})