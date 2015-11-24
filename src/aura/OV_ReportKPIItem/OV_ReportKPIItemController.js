({
    deleteMyKPIElement : function(component) {
        $A.get('e.c:OV_DeleteMyKPIEvent').setParams({
            KPIElementId: component.get('v.kpielement.kpiElementId')
        }).fire();
    },
    toggleFilters: function(cmp, evt) {
        var filterButton = cmp.find('kpi-filterButton').getElement();
        var filtersNode  = cmp.find('kpi-filters').getElement();
        if (filterButton.classList.contains('s1utility-up')) {
            $A.util.removeClass(filterButton, 's1utility-up');
            $A.util.addClass(filterButton, 's1utility-down');
            $A.util.removeClass(filtersNode, 'expanded');
        } else {
            $A.util.removeClass(filterButton, 's1utility-down');
            $A.util.addClass(filterButton, 's1utility-up');
            $A.util.addClass(filtersNode, 'expanded');
        }
    },
    showReportDetails: function(component, event, helper) {
        // record view
        var $Browser = $A.get('$Browser');
        helper.recordView(
            component,
            'kpi_view_details',
            $Browser.isPhone === true ? 'Mobile' : ($Browser.isIOS === true || $Browser.isAndroid === true ? 'Tablet' : 'Desktop')
        );

        var evt;
        if ($A.get('$Browser.formFactor') === 'PHONE') {
            evt = $A.get('e.c:OV_NavigationEvent');
            evt.setParams({
                componentDef: 'c:OV_ComponentWrapper',
                componentAttributes: {
                    wrappedObject: {
                        componentDef: 'c:OV_Report',
                        componentAttributes: {
                            reportId    : component.get('v.kpielement.kpiElementReportId'),
                            shelfColour : component.get('v.shelfColour'),
                            shelfIcon   : component.get('v.shelfIcon')
                        }
                    }
                }
            });
            evt.fire();
        } else if ($A.get('$Browser.isIOS') || $A.get('$Browser.isAndroid')) {
            evt = $A.get('e.c:OV_NavigationEvent');
            evt.setParams({
                componentDef: 'c:OV_ComponentWrapper',
                componentAttributes: {
                    renderBackArrow : true,
                    wrappedObject   : {
                        componentDef        : 'c:OV_ReportTablet',
                        componentAttributes : {
                            reportId    : component.get('v.kpielement.kpiElementReportId'),
                            shelfColour : component.get('v.shelfColour'),
                            shelfIcon   : component.get('v.shelfIcon')
                        }
                    }
                }
            });
            evt.fire();
        } else {
            evt = $A.get('e.c:OV_NavigationEvent');
            evt.setParams({
                componentDef: 'c:OV_ComponentWrapper',
                componentAttributes: {
                    renderBackArrow : true,
                    wrappedObject   : {
                        componentDef        : 'c:OV_ReportDesktop',
                        componentAttributes : {
                            reportId    : component.get('v.kpielement.kpiElementReportId'),
                            shelfColour : component.get('v.shelfColour'),
                            shelfIcon   : component.get('v.shelfIcon')
                        }
                    }
                }
            });
            evt.fire();
        }
    },
    doneRendering: function() {
        // this code doesn't appear to do anything in this context
        var i, item;
        var carouselWidth;
        var elem         = document.getElementById('kpicarousel');
        var carouselArea = document.getElementsByClassName('kpiCarouselArea');
        var leftButton   = document.getElementsByClassName('carouselLeftButton');
        var rightButton  = document.getElementsByClassName('carouselRightButton');

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