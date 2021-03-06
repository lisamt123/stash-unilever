({
    doInit: function(component, event, helper) {
        var inCallback = function(data) {
            if (data.status === '0') {
                component.set('v.reportData',           data.data.report);
                component.set('v.reportIsFavourite',    data.data.report.reportIsFavourite);

                if (data.data.report.reportIsStatic === true) {
                    component.set('v.documentIcon', helper.getDocumentIconByType(data.data.report.reportDocument.reportDocumentFileType));
                } else {
                    component.set('v.documentIcon', '/resource/reportDocumentTypeIcons/link_60.png');
                }

            } else {
                //@TODO show error
            }
        };

        var reportId = component.get('v.reportId');
        var shelfTileId = component.get('v.shelfTileId');
        helper.getReport(component, reportId, shelfTileId, inCallback);
    },
    changeViews: function(cmp, evt) {
        var targetViewId   = evt.getParam('targetViewId');

        // fire an event to the view component
        var myContent      = cmp.find('reportTabContent');
        var myContentEvent = myContent.getEvent('showPanel');
        myContentEvent.setParams({'targetPanelId': targetViewId});
        myContentEvent.fire();
    },
    showContent: function(component, event, helper) {
        event.stopPropagation();
        event.preventDefault();

        // record view
        helper.recordView(
            component,
            'detail_view_document_icon',
            'Mobile'
        );

        var navigationEvent, id;
        var reportData = component.get('v.reportData');

        if (reportData.reportIsStatic === true) {
            navigationEvent = $A.get('e.force:navigateToSObject');
            id              = reportData.reportDocument.reportDocumentContentDocumentId;
            navigationEvent.setParams({
               'recordId'     : id,
               'slideDevName' : 'detail'
            });
            navigationEvent.fire();
        } else {
            navigationEvent = $A.get('e.force:navigateToURL');
            navigationEvent.setParams({
                'url'        : '/apex/OV_DynamicShell?id=' + reportData.reportId + '&device=Mobile',
                'isredirect' : 'true'
            });
            navigationEvent.fire();
        }
    },
    addToFavourite: function(component, event, helper) {
        if (component.get('v.favInProgress') === true) {
            return;
        }
        component.set('v.favInProgress',true);
        component.set('v.reportIsFavourite', true);

        var callBack = function(data){
            if (data.status === '0') {
                helper.requestFavouiriteUpdate(component, component.get('v.reportData.reportId'), true);
                component.set('v.reportIsFavourite',true);
            } else {
                component.set('v.reportIsFavourite',false);
            }
            component.set('v.favInProgress', false);
        };

        helper.addReportToFavourites(component, component.get('v.reportData.reportId'), callBack);
    },
    removeFromFavourite: function(component, event, helper) {
        if(component.get('v.favInProgress')){
            return;
        }
        component.set('v.favInProgress', true);

        var callBack = function(data){
            if (data.status === '0') {
                helper.requestFavouiriteUpdate(component, component.get('v.reportData.reportId'), false);
                component.set('v.favInProgress',false);
                component.set('v.reportIsFavourite', false);
            } else {
                component.set('v.reportIsFavourite',true);
            }
            component.set('v.favInProgress', false);
        };

        helper.deleteReportFromFavourites(component, component.get('v.reportData.reportId'), callBack);
    }
});