({
    doInit : function(component, event, helper) {
        $A.OV                 = $A.OV || {};
        $A.OV.homeCmpGlobalId = component.getGlobalId();
        $A.OV.homeCmpToken    = $A.historyService.get().token;

        // set to true on init
        component.set('v.filtersFromCache', true);

        // set default tab
        $A.OV.selectedTab = component.get('v.defaultMenuItem');

        var areFiltersSelected = $A.OV && $A.OV.selectedFilters && $A.util.isObject($A.OV.selectedFilters);

        var subjectTabConfig = {
            'reportCategory'    : (areFiltersSelected && $A.OV.selectedFilters.categoryId  ? $A.OV.selectedFilters.categoryId  : ''),
            'reportGeography'   : (areFiltersSelected && $A.OV.selectedFilters.geographyId ? $A.OV.selectedFilters.geographyId : ''),
            'reportFunction'    : (areFiltersSelected && $A.OV.selectedFilters.functionId  ? $A.OV.selectedFilters.functionId  : ''),
            'reportVisibleToMe' : (areFiltersSelected && $A.OV.selectedFilters.mineOnly    ? $A.OV.selectedFilters.mineOnly    : false),
            'recordTypeName'    : 'Subject'
        };

        var momentTabConfig = {
            'reportCategory'    : (areFiltersSelected && $A.OV.selectedFilters.categoryId  ? $A.OV.selectedFilters.categoryId  : ''),
            'reportGeography'   : (areFiltersSelected && $A.OV.selectedFilters.geographyId ? $A.OV.selectedFilters.geographyId : ''),
            'reportFunction'    : (areFiltersSelected && $A.OV.selectedFilters.functionId  ? $A.OV.selectedFilters.functionId  : ''),
            'reportVisibleToMe' : (areFiltersSelected && $A.OV.selectedFilters.mineOnly    ? $A.OV.selectedFilters.mineOnly    : false),
            'recordTypeName'    : 'Moment'
        };

        helper.loadData(component, subjectTabConfig, momentTabConfig);

        component.set('v.filters2', momentTabConfig);
        component.set('v.filters1', subjectTabConfig);

        // reset after first data load
        component.set('v.filtersFromCache', false);

        // reset KPI data loaded flag so we can reload data if user quits app and returns to it
        $A.OV               = $A.OV || {};
        $A.OV.kpiDataLoaded = false;

        if (($A.get('$Browser.isPhone') || $A.get('$Browser.isAndroid') || $A.get('$Browser.isIOS')) === false) {
            // disable scroller and scroll to top in case user moved the screen before the scroll lock was enabled
            $('.scroller', '.oneContent div.centerUiScroller.uiScroller.scroller-wrapper.scroll-vertical').on('wheel DOMMouseScroll mousewheel wheel touchmove dragstart mousedown movusemove mousedown', function(e) {
                e.stopPropagation();
            }).removeAttr('style');
        }
    },

    applyFilters: function(component, event, helper) {
        var subjectTabConfig = {
            'reportCategory'    : event.getParam('categoryId') || '',
            'reportGeography'   : event.getParam('geographyId') || '',
            'reportFunction'    : event.getParam('functionId') || '',
            'reportVisibleToMe' : event.getParam('reportVisibleToMe') || false,
            'recordTypeName'    : 'Subject'
        };

        var momentTabConfig = {
            'reportCategory'    : event.getParam('categoryId') || '',
            'reportGeography'   : event.getParam('geographyId') || '',
            'reportFunction'    : event.getParam('functionId') || '',
            'reportVisibleToMe' : event.getParam('reportVisibleToMe') || false,
            'recordTypeName'    : 'Moment'
        };

        component.set('v.filtersFromCache', false);

        helper.loadData(component, subjectTabConfig, momentTabConfig);
        component.set('v.filters2', momentTabConfig);
        component.set('v.filters1', subjectTabConfig);
    },

    changeViews: function(cmp, evt) {
        var targetViewId   = evt.getParam('targetViewId');
        var myContent      = cmp.find('tabContent');
        var myContentEvent = myContent.getEvent('showPanel');
        myContentEvent.setParams({'targetPanelId': targetViewId});
        myContentEvent.fire();
    },

    handleDestroy: function(component, event, helper) {
        // nothing to do here ...
    }

});