({
    showPanel: function(cmp, e) {
        var targetId  = e.getParam('targetPanelId');
        // get all the panels
        var allPanels = (cmp.getElement()).getElementsByClassName('tab-pane');

        for (var i = 0; i < allPanels.length; i++) {
            var panelid;
            var item = allPanels[i];
            $A.util.removeClass(item, 'active');
            if (item.dataset && item.dataset.panelid) {
                panelid = item.dataset.panelid;
            } else {
                panelid = item.attributes.getNamedItem('data-panelid').nodeValue;
            }
            if (panelid === targetId) {
                $A.util.addClass(item, 'active');
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