({
    doInit: function(component, event, helper) {
        var kpielement = component.get('v.kpielement');
        var dimensions = [];
        var exclusions = ['Selected', 'timeRange', 'kpiTransactionDirection', 'kpiTransactionCurrentTimePeriod', 'kpiDirectionSentiment', 'kpiName', 'kpiWantsNotification'];
        for (var i in kpielement) {
            if (exclusions.indexOf(i) < 0 && !i.match(/Id$/gi) && !i.match(/^kpiShelf/gi) && !i.match(/^kpiTransaction/gi) && kpielement[i] !== true) {
                dimensions.push(kpielement[i]);
            }
        }
        component.set('v.dimensions', dimensions);
        if (dimensions.length <= 3) {
            component.set('v.expandVisible', false);
        }
        component.set('v.currentSuffixType', (kpielement.kpiTransactionValueSuffix && kpielement.kpiTransactionValueSuffix.indexOf('%') >= 0) ? 'percent' : '');
        component.set('v.previousSuffixType', (kpielement.kpiTransactionPreviousValueSuffix && kpielement.kpiTransactionPreviousValueSuffix.indexOf('%') >= 0) ? 'percent' : '')
        component.set('v.timeField', (!!kpielement.kpiTransactionCurrentTimePeriod ? (kpielement.kpiTransactionCurrentTimePeriod + ' ') : '') + (kpielement.timeRangeCode || kpielement.timeRange || ''));
        var displayText = '' + (kpielement.kpiTransactionValuePrefix?kpielement.kpiTransactionValuePrefix:'') + (kpielement.kpiTransactionValue?kpielement.kpiTransactionValue:'') + (kpielement.kpiTransactionValueSuffix?kpielement.kpiTransactionValueSuffix:'');

        component.set('v.isNumberCentered', displayText.length<10);
    },
    deleteMyKPIElement: function(component) {
        if (component.get('v.readOnly')) {
            return;
        }
        jQuery(component.getElement()).off('mouseleave');
        $A.get('e.c:OV_DeleteMyKPIEvent').setParams({
            KPIElementId: component.get('v.kpielement.kpiTransactionId')
        }).fire();
        component.set('v.popupShown', false);
    },
    editMyKPIElement: function(component) {
        if (component.get('v.readOnly')) {
            return;
        }
        jQuery(component.getElement()).off('mouseleave');
        $A.get('e.c:OV_WizardEditKpiEvent').setParams({
            kpiItem: component.get('v.kpielement')
        }).fire();
        component.set('v.popupShown', false);
    },
    toggleFilters: function(cmp, evt) {
        cmp.set('v.filtersExpanded', !cmp.get('v.filtersExpanded'));
    },
    togglePopup: function(component, event, helper) {
        if (component.get('v.readOnly')) {
            return;
        }
        var popupShown = component.get('v.popupShown');
        component.set('v.popupShown', !popupShown);

        if (component.get('v.popupShown') === true) {
            jQuery(component.getElement()).mouseleave(helper.mouseLeaveHandler);
        } else {
            jQuery(component.getElement()).off('mouseleave');
        }
    },
    showReportDetails: function(component, event, helper) {
        var reportId = component.get('v.kpielement.kpiTransactionReportId');
        if (!reportId || component.get('v.readOnly') === true || component.get('v.actionPending') === true) {
            return;
        }

        jQuery(component.getElement()).off('mouseleave');

        var $Browser = $A.get('$Browser');
        helper.recordView(component, 'kpi_view_details', $Browser.isPhone === true ? 'Mobile' : ($Browser.isIOS === true || $Browser.isAndroid === true ? 'Tablet' : 'Desktop'));
        component.set('v.actionPending', true);
        var showDetails = function(result, componentObj) {
            if (result.getState() === 'SUCCESS') {
                var returnValue = result.getReturnValue();
                if (returnValue.status !== '0') {
                    $console.log(returnValue.message);
                }
            }            	
            $A.get('e.c:OV_NavigationEvent').setParams({
                componentDef: 'c:OV_ComponentWrapper',
                componentAttributes: {
                    renderBackArrow: true,
                    wrappedObject: {
                        componentDef: 'c:OV_ReportDesktop',
                        componentAttributes: {
                            reportId: componentObj.get('v.kpielement.kpiTransactionReportId'),
                            shelfColour: componentObj.get('v.kpielement.kpiShelfTileColour'),
                            shelfIcon: componentObj.get('v.kpielement.kpiShelfTileIcon'),
                            shelfTileId: componentObj.get('v.kpielement.kpiShelfTileId')
                        }
                    }
                }
            }).fire();
            if (componentObj && componentObj.isValid()) {
                componentObj.set('v.actionPending', false);
            }
        };
        // call counter increment service and if success then show content
        helper.increaseViewsCounter(component, component.get('v.kpielement.kpiTransactionReportId'), showDetails);
    },
    doneRendering: function() {
        // this code doesn't appear to do anything in this context
        var i, item;
        var carouselWidth;
        var elem = document.getElementById('kpicarousel');
        var carouselArea = document.getElementsByClassName('kpiCarouselArea');
        var leftButton = document.getElementsByClassName('carouselLeftButton');
        var rightButton = document.getElementsByClassName('carouselRightButton');
        if (elem) {
            elem.style.left = 0;
        }
        if (carouselArea.length > 0) {
            carouselWidth = carouselArea[0].getBoundingClientRect().width;
        }
        if (leftButton.length > 0) {
            for (i = 0; i < leftButton.length; i++) {
                item = leftButton[i];
                item.style.display = 'none';
            }
        }
        if (window.innerWidth < carouselWidth) {
            if (rightButton.length > 0) {
                for (i = 0; i < rightButton.length; i++) {
                    item = rightButton[i];
                    item.style.display = 'block';
                }
            }
        } else {
            if (rightButton.length > 0) {
                for (i = 0; i < rightButton.length; i++) {
                    item = rightButton[i];
                    item.style.display = 'none';
                }
            }
        }
    }
});