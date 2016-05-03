({
    doneRendering: function(cmp) {
        var rootElement = cmp.getElement();
        var images, targetImage;
        if (rootElement) {
            images = rootElement.getElementsByClassName('myImg');
        }
        if (images && images.length > 0) {
            targetImage = images[0];
            if (targetImage.loadHandlerAdded !== 'yes') {
                var handler = function() {
                    $A.util.removeClass(targetImage, 'hide');
                };
                targetImage.loadHandlerAdded = 'yes';
                targetImage.addEventListener('load', handler);
                if (targetImage.complete === true) {
                    handler();
                }
            }
        }
    },
    showContent: function(component, event, helper) {
        var navigationEvent;

        if(!($A.get('$Browser.isPhone') || $A.get('$Browser.isAndroid') || $A.get('$Browser.isIOS') )){
            navigationEvent = $A.get('e.force:navigateToURL');
            navigationEvent.setParams({
                'url'        : component.get('v.reportData').reportDocument.reportDocumentPreviewLink,
                'isredirect' : 'true'
            });
        } else {
            navigationEvent = $A.get('e.force:navigateToSObject');
            navigationEvent.setParams({
                'recordId': component.get('v.reportData').reportDocument.reportDocumentContentDocumentId
            });
        }

        navigationEvent.fire();
    }
})