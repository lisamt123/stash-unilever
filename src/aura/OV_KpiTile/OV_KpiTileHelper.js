({
    recordView: function(component, operationType, deviceType) {
        var action   = component.get('c.saveUsageEntry');
        action.setParams({
            'reportId'          : component.get('v.kpielement.kpiTransactionReportId'),
            'shelfTileId'       : 'My View',
            'operationType'     : operationType,
            'deviceType'        : deviceType
        });

        $A.enqueueAction(action);
    },
    increaseViewsCounter: function(component, reportId, callback) {
        // this is fire and forget type because we don't need to wait for response - jsut assume it worked
        var action  = component.get('c.increaseViewsCounter');
        action.setParams({
            'reportId'   : reportId
        });

        if ($A.util.isFunction(callback) === true) {
            action.setCallback(this, callback);
        }

        $A.enqueueAction(action);
    },
    mouseLeaveHandler: function(mouseLeaveEvent) {
        var target  = mouseLeaveEvent.currentTarget;
        var cmp     = $A.componentService.getRenderingComponentForElement(target);
        if (cmp && cmp.isValid() === true) {
            cmp.getAttributeValueProvider().set('v.popupShown', false);
        }
        jQuery(target).off('mouseleave');
    }
})