({
	expandFolder: function(component, newComponent) {
        var activeFolderTileId = component.get('v.activeFolderTileId');
        var shelfTileId        = component.get('v.shelfTileId');
        window.a = component;
        window.b = newComponent;
        console.log(a);
        console.log(b);
        // if (activeFolderTileId === shelfTileId) {
        //     var tiles       = component.get('v.reportList');
        //     for (var i = 0, len = tiles.length; i < len; i++) {
        //         // find folder
        //         if (!tiles[i].folderMembers) {
        //             continue;
        //         }
        //         if (tiles[i].folderName !== 'Hair Care') {
        //             continue;
        //         }

        //         $A.createComponent(
        //             'c:OV_ShelfTileFolderContentItems', {
        //                 shelfTileId       : component.get('v.shelfTileId'),
        //                 shelfTileShelfId  : component.get('v.shelfTileShelfId'),
        //                 shelfColour       : component.get('v.shelfColour'),
        //                 shelfIcon         : component.get('v.shelfIcon'),
        //                 reportList        : component.get('v.reportList'),
        //                 folderName        : component.get('v.folderName'),
        //                 headerTitle       : component.get('v.headerTitle'),
        //                 //componentId       : component.get('componentId'),
        //                 shelfTitle        : component.get('v.shelfTitle'),
        //                 shelfTileTitle    : component.get('v.shelfTileTitle'),
        //                 reportListVisible : true
        //             },
        //             function(newComponent) {
        //                 if (component.isValid() === true) {
        //                     // add report tiles to component body
        //                     component.set('v.body', [newComponent]);
        //                 }
        //             }
        //         );

        //         //component.set('v.lastComponentId', event.getParam('componentId'));

        //         break;
        //     }
        // }
	}
})