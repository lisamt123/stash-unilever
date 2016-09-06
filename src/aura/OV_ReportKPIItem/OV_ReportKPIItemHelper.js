({
    recordView: function(component, operationType, deviceType) {
        var action   = component.get('c.saveUsageEntry');
        action.setParams({
            'reportId'          : component.get('v.kpielement.kpiElementReportId'),
            'shelfTileId'       : 'My View',
            'operationType'     : operationType,
            'deviceType'        : deviceType
        });
        $A.enqueueAction(action);
    }
})