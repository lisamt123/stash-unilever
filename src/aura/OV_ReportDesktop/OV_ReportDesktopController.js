({
    doInit: function(component, event, helper) {
        var inCallback = function(data) {
            if (data.status === '0') {
                var reportData     = data.data.report;
                var reportDocument = reportData.reportDocument || {};

                component.set('v.reportIsFavourite',        reportData.reportIsFavourite);
                component.set('v.reportContentVersions',    reportData.reportContentVersions || []);
                component.set('v.reportPreviewLink',        reportDocument.reportDocumentPreviewLink ? reportDocument.reportDocumentPreviewLink : '');
                component.set('v.latestVersionId',          reportDocument.reportDocumentContentDocumentId ? reportDocument.reportDocumentContentDocumentId : '');
                component.set('v.currentlyViewedVersionId', component.get('v.latestVersionId'));

                if (reportData.reportIsStatic === true) {
                    console.log(reportData.reportDocument.reportDocumentFileType);
                    console.warn(reportData);
                    component.set('v.documentIcon', helper.getDocumentIconByType(
                            reportData.reportDocument.reportDocumentFileType,
                            reportData.reportDocument.reportDocumentFileExtension
                        )
                    );

                    reportData = helper.formatContentVersionDates(reportData);
                } else {
                    component.set('v.documentIcon', '/resource/reportDocumentTypeIcons/link_60.png');

                    var url = '/apex/OV_DynamicShell?id=' + reportData.reportId + '&device=Desktop';
                    if (reportData.reportDocument !== undefined && reportData.reportDocument.reportDocumentPreviewUrl !== undefined && reportData.reportDocument.reportDocumentPreviewUrl !== '') {
                        url = reportData.reportDocument.reportDocumentPreviewUrl;
                    }
                    component.set('v.viewReportLink', url);
                }

                if (reportData.reportViews) {
                    reportData.reportViews = helper.formatNumber(reportData.reportViews);
                }

                // if report id is specified then listen for postCreated events
                if (reportData.reportId) {
                    $A.eventService.addHandler({
                        event   : 'forceChatter:postCreated',
                        handler : function(event) {
                            if (event && component && component.isValid() && event.getParam('contextId') === component.get('v.reportData.reportId')) {
                                component.set('v.reportData.reportComments', (component.get('v.reportData.reportComments') || 0) + 1);
                            }
                        },
                        globalId : component.getGlobalId()
                    });
                }

                component.set('v.reportData', reportData);
                helper.renderIframe(component);
            } else {
                //@TODO show error
            }
        };

        var reportId    = component.get('v.reportId');
        var shelfTileId = component.get('v.shelfTileId');
        component.set('v.historyCounter', -1);
        component.set('v.downloadInProgress', false);
        helper.getReport(component, reportId, shelfTileId, inCallback);
    },

    handleDestroy: function(component, event, helper) {
        $A.eventService.removeHandler({
            event    : 'forceChatter:postCreated',
            globalId : component.getGlobalId()
        });
    },

    onSelectChange: function(component, event, helper) {
        var selectCmp = component.find('selectboxElement');
        var value     = selectCmp.get('v.value');
        var link      = component.get('v.reportData.reportDocument.reportDocumentPreviewLink') || '';

        component.set('v.currentlyViewedVersionId', value);

        // record view
        helper.recordView(
            component,
            'detail_view_version_change',
            'Desktop',
            value
        );

        component.set(
            'v.reportPreviewLink',
            link + '&contentDocumentVersionId=' + value
        );

        component.set('v.historyCounter', component.get('v.historyCounter')-1);
        helper.renderIframe(component);
    },

    doneRendering: function(component, event, helper) {
        helper.renderIframe(component);
    },

    showContent: function(component, event, helper) {
        var navigationEvent, id;
        event.stopPropagation();
        event.preventDefault();

        // record view
        helper.recordView(
            component,
            'detail_view_document_link',
            'Desktop'
        );

        var reportData = component.get('v.reportData');

        if (reportData.reportIsStatic === true) {
            // this if block will never happen since we do not allow to do "view report" for static reports anymore

            if (reportData.reportDocument.reportDocumentIsPreview !== true){
                window.open(reportData.reportDocument.reportDocumentDownloadLink, '_blank');
            } else {
                navigationEvent = $A.get('e.force:navigateToURL');
                navigationEvent.setParams({
                    'url' : reportData.reportDocument.reportDocumentPreviewLink + '?shelfTileId=' + (component.get('v.shelfTileId') || null) + '&reportId=' + component.get('v.reportId')
                });
                navigationEvent.fire();
            }
        } else {
            var url = '/apex/OV_DynamicShell?id=' + reportData.reportId + '&device=Desktop';
            if (reportData.reportDocument !== undefined
                && reportData.reportDocument.reportDocumentPreviewUrl !== undefined
                && reportData.reportDocument.reportDocumentPreviewUrl !== '') {
                url = reportData.reportDocument.reportDocumentPreviewUrl;
            }
            window.open(url, '_blank');
        }
    },
    addToFavourite: function(component, event, helper) {
        if (component.get('v.favInProgress') === true){
            return;
        }

        component.set('v.favInProgress',true);
        component.set('v.reportIsFavourite', true);

        var callBack = function(data){
            if (data.status === '0') {
                helper.requestFavouiriteUpdate(component, component.get('v.reportData.reportId'), true);
                component.set('v.reportIsFavourite', true);
            } else {
                component.set('v.reportIsFavourite', false);
            }
            component.set('v.favInProgress',false);
        };

        helper.addReportToFavourites(component, component.get('v.reportData.reportId'), callBack);
    },
    download: function(component, event, helper) {
        var report         = component.get('v.reportData');
        var reportDocument = report.reportDocument;

        if (report.reportIsStatic === true && !!reportDocument) {
            // record view
            helper.recordView(
                component,
                'detail_download_document_icon',
                'Desktop',
                component.get('v.currentlyViewedVersionId')
            );

            var iframe = document.getElementById('previewIframe');

            var handleResponse = function(e){
                if(window.lastLink !== e.data){
                    window.lastLink = e.data;
                    var result = window.open('/sfc/servlet.shepherd/version/download/'+e.data, '_blank');
                    // added timeout to prevent downloading same document multiple times in very short time period, we cant use
                    // flag because not always handleResponse is called (when iframe is not loaded)
                    setTimeout(function(){
                        window.lastLink = '';
                    }, 1000);
                    if (result === undefined) {
                        if (window.safari) {
                            iframe.src = '/sfc/servlet.shepherd/version/download/' + e.data;
                            return;
                        }
                        throw new Error('Please disable popup blocker');
                    }
                    window.removeEventListener('message', handleResponse, false);
                }
            };

            window.addEventListener('message', handleResponse, false);

            /**
             * Comment for SONAR exception
             *
             * There is now way to get adderes of APEX VF pages host from within JavaScript (like it used to be in VisualForce via global variables)
             * and therefore to avoid updating code / custom settings after each deployment the '*' is used instead of a specific URL
             *
             * It's save to use '*'' here because:
             * - user has no way to specify src of the iframe element, it's always set up from the code
             * - we have full control over the code in loaded iframe
             * - eval is never called on received response, there is no risk of executing dangerous code.
             * - reponse is always a string (record id) which is appended to another string
             */
            iframe.contentWindow.postMessage(' ', '*');
        }
    },
    removeFromFavourite: function(component, event, helper) {
        if(component.get('v.favInProgress') === true){
            return;
        }
        component.set('v.favInProgress',true);

        var callBack = function(data){
            if (data.status === '0') {
                helper.requestFavouiriteUpdate(component, component.get('v.reportData.reportId'), false);
                component.set('v.reportIsFavourite', false);
            } else {
                component.set('v.reportIsFavourite',true);
            }
            component.set('v.favInProgress',false);
        };

        helper.deleteReportFromFavourites(component, component.get('v.reportData.reportId'), callBack);
    },
    goBack : function(component, event, helper) {
        window.history.go(component.get('v.historyCounter'));
    }
})