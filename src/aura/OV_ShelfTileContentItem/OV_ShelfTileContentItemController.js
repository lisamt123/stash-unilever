({
    doInit: function(component, event, helper) {
        var reportItem                  = component.get('v.reportItem');
        var reportDocumentFileType      = !!reportItem.reportDocument ? reportItem.reportDocument.reportDocumentFileType : '';
        var reportDocumentFileExtension = !!reportItem.reportDocument ? reportItem.reportDocument.reportDocumentFileExtension : '';

        if (reportItem.reportIsStatic === true) {
            component.set('v.documentIcon',
                helper.getDocumentIconByType(
                    reportDocumentFileType,
                    reportDocumentFileExtension
                )
            );
        } else {
            component.set('v.documentIcon', '/resource/reportDocumentTypeIcons/link_60.png');

            var url = '/apex/OV_DynamicShell?id=' + reportItem.reportId + '&device=Desktop';
            if (reportItem.reportDocument && reportItem.reportDocument.reportDocumentPreviewUrl) {
                url = reportItem.reportDocument.reportDocumentPreviewUrl;
            }

            component.set('v.viewReportLink', url);
        }

        // if report id is specified then listen for postCreated events
        if (reportItem.reportId) {
            $A.eventService.addHandler({
                event   : 'forceChatter:postCreated',
                handler : function(event) {
                    if (event && component && component.isValid() && event.getParam('contextId') === component.get('v.reportItem.reportId')) {
                        component.set('v.reportItem.reportComments', (component.get('v.reportItem.reportComments') || 0) + 1);
                    }
                },
                globalId : component.getGlobalId()
            });
        }

        if (reportItem.reportViews) {
            reportItem.reportViews = helper.formatNumber(reportItem.reportViews);
        }
    },

    handleDestroy: function(component, event, helper) {
        $A.eventService.removeHandler({
            event    : 'forceChatter:postCreated',
            globalId : component.getGlobalId()
        });
    },

    doneRendering: function(component, event, helper) {
        var browser = $A.get('$Browser');
        if (browser.isIE10 === true || browser.isIE11 === true) {
            jQuery('.details-title', component.getElement()).dotdotdot({wrap: 'letter'});
        }
    },

    toggleFolder: function( component, event, helper ) {
        // fire the event with tile data ...
        var isExpanded = component.get('v.isExpanded') || false;
        isExpanded     = isExpanded === false ? true : false;

        // do not set this flag for tablets / mobile because we don't want to change tile color
        if (false === ($A.get('$Browser.isPhone') || $A.get('$Browser.isAndroid') || $A.get('$Browser.isIOS') )) {
            component.set('v.isExpanded', isExpanded);
        }

        $A.get('e.c:OV_ShelfTileFolderExpandEvent').setParams({
            componentId      : component.getGlobalId(),
            shelfTileId      : component.get('v.shelfTileId'),
            shelfTileShelfId : component.get('v.shelfTileShelfId'),
            headerTitle      : component.get('v.headerTitle'),
            shelfColour      : component.get('v.shelfColour'),
            shelfIcon        : component.get('v.shelfIcon'),
            reportList       : component.get('v.reportItem.folderMembers'),
            folderName       : component.get('v.reportItem.folderName'),
            shelfTitle       : component.get('v.shelfTitle'),
            shelfTileTitle   : component.get('v.shelfTileTitle'),
            isVisible        : isExpanded
        }).fire();
    },

    toggleFavourite: function( component, event, helper ) {
        // check if already running
        if(component.get('v.favInProgress') === true){
            return;
        }

        // if already fav then call remove
        if (component.get('v.reportItem.reportIsFavourite') === true) {
            component.set('v.favInProgress',true);
            component.set('v.reportItem.reportIsFavourite',false);
            var removeCallback = function(data){
                if (data.status === '0') {
                    helper.requestFavouiriteUpdate(component, component.get('v.reportItem.reportId'), false);
                    component.set('v.favInProgress',false);
                } else {
                    component.set('v.reportItem.reportIsFavourite',false);
                }
            };
            helper.deleteReportFromFavourites(component, component.get('v.reportItem.reportId'), removeCallback);
        } else {
            component.set('v.favInProgress',true);
            component.set('v.reportItem.reportIsFavourite',true);
            var addCallBack = function(data){
                if (data.status === '0') {
                    helper.requestFavouiriteUpdate(component, component.get('v.reportItem.reportId'), true);
                    component.set('v.favInProgress',false);
                } else {
                    component.set('v.reportItem.reportIsFavourite',false);
                }
            };

            helper.addReportToFavourites(component, component.get('v.reportItem.reportId'), addCallBack);
        }
    },

    logReportView: function(component, event, helper) {
        var $Browser = $A.get('$Browser');
        helper.recordView(
            component,
            'tile_view_document_details',
            $Browser.isPhone === true ? 'Mobile' : ($Browser.isIOS === true || $Browser.isAndroid === true ? 'Tablet' : 'Desktop')
        );

        // call counter increment service and if success then show content
        helper.increaseViewsCounter(component, component.get('v.reportItem.reportId'), function() {
            if (component.isValid()) {
                component.set('v.reportItem.reportViews', (component.get('v.reportItem.reportViews') || 0) + 1 );
            }
        });
    },

    showReportsDetail: function(component, event, helper) {
        // record view
        var $Browser = $A.get('$Browser');
        helper.recordView(
            component,
            'tile_view_document_details',
            $Browser.isPhone === true ? 'Mobile' : ($Browser.isIOS === true || $Browser.isAndroid === true ? 'Tablet' : 'Desktop')
        );

        if (component.get('v.actionPending') === true) {
            return;
        }

        component.set('v.actionPending', true);

        var showDetails = function(result, componentObj) {
            // update component value
            componentObj.set('v.reportItem.reportViews', ( componentObj.get('v.reportItem.reportViews') || 0 ) + 1);

            // prepare attributes object
            var attributesObj = {
                reportId    : componentObj.get('v.reportItem.reportId'),
                shelfColour : componentObj.get('v.shelfColour'),
                shelfIcon   : componentObj.get('v.shelfIcon'),
                shelfTileId : componentObj.get('v.shelfTileId')
            };

            var componentDef = '';

            if ($A.get('$Browser.formFactor') === 'PHONE') {
                componentDef = 'c:OV_Report';
            } else if ($A.get('$Browser.isIOS') || $A.get('$Browser.isAndroid')) {
                componentDef = 'c:OV_ReportTablet';
            } else {
                componentDef = 'c:OV_ReportDesktop';
            }

            $A.get('e.c:OV_NavigationEvent').setParams({
                componentDef: 'c:OV_ComponentWrapper',
                componentAttributes: {
                    renderBackArrow : true,
                    wrappedObject   : {
                        componentDef        : componentDef,
                        componentAttributes : attributesObj
                    }
                }
            }).fire();
            if (componentObj && componentObj.isValid()) {
                componentObj.set('v.actionPending', false);
            }
        };

        // call counter increment service and if success then show content
        helper.increaseViewsCounter(component, component.get('v.reportItem.reportId'), showDetails);
    },

    handleUpdateEvent: function(component, event, helper){
        if(component.get('v.reportItem.reportId') === event.getParam('reportId') && component.get('v.reportItem.reportIsFavourite') !== event.getParam('isFav')){
            component.set('v.reportItem.reportIsFavourite', event.getParam('isFav'));
        }
    },

    showReportContent: function(component, event, helper) {
        event.stopPropagation();
        event.preventDefault();

        if (component.get('v.actionPending') === true) {
            return;
        }

        component.set('v.actionPending', true);

        // record view
        var $Browser = $A.get('$Browser');
        helper.recordView(
            component,
            'tile_view_document_icon',
            $Browser.isPhone === true ? 'Mobile' : ($Browser.isIOS === true || $Browser.isAndroid === true ? 'Tablet' : 'Desktop')
        );

        var showContent = function(response, componentObj) {
            // update component value
            componentObj.set('v.reportItem.reportViews', (componentObj.get('v.reportItem.reportViews') || 0) + 1);

            // extract data
            var navigationEvent;
            var report         = componentObj.get('v.reportItem');
            var isPhone        = $Browser.isPhone || $Browser.formFactor === 'PHONE';
            var isTablet       = !isPhone && ($Browser.isAndroid || $Browser.isIOS);
            var isDesktop      = !isPhone && !isTablet;
            var reportDocument = report.reportDocument;

            if (report.reportIsStatic === true) {
                if (!!reportDocument) {
                    if (isDesktop === false) {
                        navigationEvent = $A.get('e.forceChatter:downloadFile');
                        navigationEvent.setParams({
                            'recordId'     : reportDocument.reportDocumentContentDocumentId
                        });
                    } else {
                        navigationEvent = $A.get('e.c:OV_NavigationEvent');
                        navigationEvent.setParams({
                            componentDef: 'c:OV_ComponentWrapper',
                            componentAttributes: {
                                wrappedObject: {
                                    url: reportDocument.reportDocumentPreviewLink
                                }
                            }
                        });
                    }
                    navigationEvent.fire();
                }
            } else {
                /***
                 **     Desktop only ....
                 */
                var url = '/apex/OV_DynamicShell?id=' + report.reportId + '&device=Desktop';
                if (reportDocument && reportDocument.reportDocumentPreviewUrl) {
                    url = reportDocument.reportDocumentPreviewUrl;
                }
                window.open(url, '_blank');
            }
            if (componentObj && componentObj.isValid()) {
                componentObj.set('v.actionPending', false);
            }
        };

        // call counter increment service
        helper.increaseViewsCounter(component, component.get('v.reportItem.reportId'), showContent);
    }
})