({
    getTileReports : function(component, inCallback) {
        var callback = function(response, cmp) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                inCallback(returnValue);
            }
        };

        var deviceType = '';
        if ($A.get('$Browser.formFactor') === 'PHONE') {
            deviceType = 'Mobile';
        } else if ($A.get('$Browser.isIOS') || $A.get('$Browser.isAndroid')) {
            deviceType = 'Tablet';
        } else {
            deviceType = 'Desktop';
        }

        var action = component.get('c.getTileReports2');
        action.setParams({
            'geographyId'    : component.get('v.filters').reportGeography,
            'categoryId'     : component.get('v.filters').reportCategory,
            'functionId'     : component.get('v.filters').reportFunction,
            'mineOnly'       : component.get('v.filters').reportVisibleToMe,
            'recordTypeName' : component.get('v.filters').recordTypeName,
            'shelfTileId'    : component.get('v.shelfId'),
            'deviceType'     : deviceType
        });
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    }
});