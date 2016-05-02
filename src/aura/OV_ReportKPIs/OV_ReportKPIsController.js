({
    doInit : function(component, event, helper) {
        if (($A && $A.OV && $A.OV.selectedTab === 'MY VIEW') || component.get('v.active') === true) {
            // this is required to reset the flag if my view is default tab or when we leave the app and return to it
            $A.OV               = $A.OV || {};
            var filters         = $A.OV.selectedFilters || {};

            $A.OV.kpiDataLoaded = false;

            filters = {
                'reportCategory'    : filters.categoryId || '',
                'reportGeography'   : filters.geographyId || '',
                'reportFunction'    : filters.functionId || '',
                'reportVisibleToMe' : filters.reportVisibleToMe || false
            };

            $A.appliedFilters = filters;
            helper.loadData(component, filters);
        }
    },
    loadData: function(component, event, helper) {
        var targetViewId = event.getParam('targetViewId');
        if (targetViewId === 'MY VIEW') {
            $A.OV       = $A.OV || {};
            var filters = $A.OV.selectedFilters || {};
            filters     = {
                'reportCategory'    : filters.categoryId || '',
                'reportGeography'   : filters.geographyId || '',
                'reportFunction'    : filters.functionId || '',
                'reportVisibleToMe' : filters.reportVisibleToMe || false
            };

            $A.appliedFilters = filters;
            helper.loadData(component, filters);
        }
    },
    doneRendering: function(component, event, helper) {

    },
    showPanel:  function(component, event, helper) {

    },
    applyFilters: function(component, event, helper) {
        var filters = {
            'reportCategory'    : event.getParam('categoryId') || '',
            'reportGeography'   : event.getParam('geographyId') || '',
            'reportFunction'    : event.getParam('functionId') || '',
            'reportVisibleToMe' : event.getParam('reportVisibleToMe') || false
        };

        $A.OV = $A.OV || {};
        $A.OV.selectedFilters = {
            categoryId        : event.getParam('categoryId') || '',
            geographyId       : event.getParam('geographyId') || '',
            functionId        : event.getParam('functionId') || '',
            reportVisibleToMe : event.getParam('reportVisibleToMe') || false,
        };

        $A.appliedFilters = filters;

        helper.loadData(component, filters);
    },
    toggleNewKPIDialog: function(component, e, helper) {
        if (component.get('v.dialogStoresLoaded') === false) {
            component.set('v.dialogStoresLoaded', true);
            helper.getFilters(component);
        }
        helper.toggleNewKPIDialog(component);
    },
    selectboxHandler : function(component, event, helper) {
        var level, filterValue = event.getParam('selectboxValue'), selectboxName = event.getParam('selectboxName');
        component.set('v.isKpiFoundElement', false);

        if (selectboxName === 'KPIName') {
            if (filterValue === '0') {
                component.set('v.selectedKpiName', '');
                component.set('v.kpiReportOptions', []);
                component.set('v.kpiElements',  []);
                component.set('v.showReports', false);
                component.set('v.showFilters', false);
            } else {
                component.set('v.selectedKpiName', filterValue);
                helper.getKPIReports(component, filterValue);
            }
        } else if(selectboxName === 'KPIReport') {
            if (filterValue === '0') {
                component.set('v.kpiElements', []);
                component.set('v.showFilters', false);
            } else {
                component.set('v.selectedKpiReport', filterValue);
                helper.findKPI(component);
                helper.getKPIElements(component, component.get('v.selectedKpiName'), filterValue);
                component.set('v.showFilters', true);
            }
        } else if(selectboxName.substring(0, selectboxName.length - 1) === 'KPIFilterGeography') {
            level = parseInt(selectboxName.substring(selectboxName.length -1, selectboxName.length));

            helper.resetGeographyFilterByLevel(component, level, filterValue);
        } else if(selectboxName.substring(0, selectboxName.length - 1) === 'KPIFilterCategory') {
            level = parseInt(selectboxName.substring(selectboxName.length -1, selectboxName.length));

            if (filterValue === '0') {
                if(level === 1){
                    component.set('v.filterscategory1Selected', '');
                    component.set('v.filterscategory2Options', []);
                    component.set('v.filterscategory2Selected', '');
                    component.set('v.showcategoryLevel2', false);
                }
            } else {
                component.set('v.filterscategory'+level+'Selected', filterValue);

                if(level !== 2){
                    helper.populateFilters(component, 'category', filterValue, level);
                }
            }
            helper.findKPI(component);
        }else if(selectboxName.substring(0, selectboxName.length - 1) === 'KPIFilterCustomer') {
            level = parseInt(selectboxName.substring(selectboxName.length -1, selectboxName.length));

            if (filterValue === '0') {
                if(level === 1){
                    component.set('v.filterscustomer1Selected', '');
                    component.set('v.filterscustomer2Options', []);
                    component.set('v.filterscustomer2Selected', '');
                    component.set('v.showcustomerLevel2', false);
                }
            } else {
                component.set('v.filterscustomer'+level+'Selected', filterValue);

                if(level !== 2){
                    helper.populateFilters(component, 'customer', filterValue, level);
                }
            }
            helper.findKPI(component);
        } else if(selectboxName === 'KPIFilterBrand') {
            component.set('v.filtersbrandSelected', filterValue);
            helper.findKPI(component);
        } else if(selectboxName === 'KPIFilterComparator') {
            component.set('v.filterscomparatorSelected', filterValue);
            helper.findKPI(component);
        } else if(selectboxName === 'KPIFilterFunction1') {
            component.set('v.filtersfunction1Selected', filterValue);
            helper.findKPI(component);
        } else if(selectboxName === 'KPIFilterChannel') {
            component.set('v.filterschannelSelected', filterValue);
            helper.findKPI(component);
        } else if(selectboxName === 'KPIFilterTimespan') {
            component.set('v.filterstimespanSelected', filterValue);
            helper.findKPI(component);
        }
    },
    submitNewKPIDialog: function(component, event, helper) {
        var cmpRoot = (component.find('matchingKPIs')).getElement();

        if (component.get('v.addKPIInProgress')) {
            return;
        }
        component.set('v.addKPIInProgress', true);

        var checkboxes = cmpRoot.querySelectorAll('.kpiCheckbox:checked');
        var ids = [];
        for(var i = 0; i < checkboxes.length; i++) {
            ids.push(checkboxes[i].id);
        }
        var stringIds = ids.join(',');

        if (stringIds.length === 0) {
            return;
        }

        var doneCallback = function(){
            component.set('v.addKPIInProgress', false);

            component.set('v.selectedKpiName', '0');
            component.set('v.showReports', false);
            component.set('v.showFilters', false);
            component.set('v.showcustomerLevel1', false);
            component.set('v.showcategoryLevel1', false);
            component.set('v.showgeographyLevel2', false);
            component.set('v.showgeographyLevel3', false);
            component.set('v.selectedKpiName', '0');
            component.set('v.selectedKpiReport', '0');
            component.set('v.filterstimespanSelected', '0');
            component.set('v.filterschannelSelected', '0');
            component.set('v.filtersbrandSelected', '0');
            component.set('v.filterscomparatorSelected', '0');
            component.set('v.filtersfunction1Selected', '0');
            component.set('v.filterscategory1Selected', '0');
            component.set('v.filterscategory2Selected', '0');
            component.set('v.filterscustomer1Selected', '0');
            component.set('v.filterscustomer2Selected', '0');
            component.set('v.filtersgeography1Selected', '0');
            component.set('v.filtersgeography2Selected', '0');
            component.set('v.filtersgeography3Selected', '0');
            component.set('v.isKpiFoundElement', false);
            helper.reloadFilters(component);
            helper.reloadKPINames(component);
        };
        helper.addKPIElementToMyKPIs(component, stringIds, doneCallback, $A.appliedFilters || {});
    },
    deleteMyKPIElement: function(component, event, helper){
        if (event.getParam('KPIElementId') !== undefined) {
            helper.deleteMyKPIElement(component, event.getParam('KPIElementId'));
        }
    },
    favUpdate : function(component, event, helper){
        helper.getMyFavouritesReports(component, $A.appliedFilters || {});
    }
})