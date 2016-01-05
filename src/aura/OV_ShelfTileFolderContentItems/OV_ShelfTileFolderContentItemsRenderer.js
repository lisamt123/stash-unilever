({
    render: function(component, helper) {
        return this.superRender();
    },
    afterRender: function (cmp, helper) {
        var afterRend = this.superAfterRender();

        if (($A.get('$Browser.isPhone') || $A.get('$Browser.isAndroid') || $A.get('$Browser.isIOS')) === false ) {
            var sourceComponentGlobalId = cmp.get('v.componentId');
            // get source component ...
            var sourceComponent         = $A.getComponent(sourceComponentGlobalId);
            // ... check it's position ...
            var sourceOffsetTop         = sourceComponent.getElement().offsetTop;
            // .. and find last child element in the row that is of the same type
            var keepGoing               = true;
            var lastNode                = sourceComponent.getElement();

            while (keepGoing) {
                if (lastNode.nextElementSibling && lastNode.nextElementSibling.offsetTop === sourceOffsetTop) {
                    lastNode = lastNode.nextElementSibling;
                } else {
                    keepGoing = false;
                }
            }

            // move component dom node
            var insertAfter = function(newElement, targetElement) {
                //target is what you want it to go after. Look for this elements parent.
                var parent = targetElement.parentNode;
                //if the parents lastchild is the targetElement...
                if (parent.lastchild === targetElement) {
                    //add the newElement after the target element.
                    parent.appendChild(newElement);
                } else {
                    // else the target has siblings, insert the new element between the target and it's next sibling.
                    parent.insertBefore(newElement, targetElement.nextSibling);
                }
            };

            insertAfter(cmp.getElement(), lastNode);

            // position the arrow
            var folderTile         = $A.getCmp(cmp.get('v.componentId')).getElement();
            var innerContainer     = cmp.getElement().firstChild.firstChild;

            var leftFolderCorner   = folderTile.getBoundingClientRect().left;
            var rightFolderCorner  = folderTile.getBoundingClientRect().right;

            var leftContentCorner  = innerContainer.getBoundingClientRect().left;
            var rightContentCorner = innerContainer.getBoundingClientRect().right;

            var leftPosition       = 0;

            if (leftFolderCorner < leftContentCorner) {
                // folder starts before folder content
                leftPosition = (rightFolderCorner - leftContentCorner) / 2 + (leftContentCorner - leftFolderCorner);
            } else if (leftFolderCorner >= leftContentCorner && rightFolderCorner <= rightContentCorner) {
                // folder fits within bounds
                leftPosition = (rightFolderCorner - leftFolderCorner) + (leftFolderCorner - leftContentCorner);
            } else {
                // folder is outside on the right
                leftPosition = (rightContentCorner - leftFolderCorner) + (leftFolderCorner - leftContentCorner);
            }

            if (document.styleSheets[0].addRule) {
                document.styleSheets[0].addRule('.folderItemsContent:before','left: ' + leftPosition + 'px !important;border-color:' + cmp.get('v.shelfColour') + ' transparent !important;');
                document.styleSheets[0].addRule('.folderItemsContent:after','left: ' + ( leftPosition + 1 ) + 'px !important;');
            } else {
                document.styleSheets[0].insertRule('.folderItemsContent:before {left: ' + leftPosition + 'px !important;border-color:' + cmp.get('v.shelfColour') + ' transparent !important;}', document.styleSheets[0].cssRules.length);
                document.styleSheets[0].insertRule('.folderItemsContent:after {left: ' + ( leftPosition + 1 ) + 'px !important;}', document.styleSheets[0].cssRules.length);
            }

        }

        return afterRend;
    }
})