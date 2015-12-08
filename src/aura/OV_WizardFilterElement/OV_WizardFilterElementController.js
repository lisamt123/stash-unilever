({
    doInit:function(component,event,helper){
        component.set('v.currentlyShownFiltersArray',component.get('v.filterItem.Items'));
        component.set('v.filterBreadcrumbs',[]);
    },
    selectFiltersLevel1: function(component, event, helper) {
        if (!component.isValid()) {
            return;
        }
        var filter1index = component.get('v.filter1Index');
        if (component.get('v.selectedFilterLevel1') === filter1index) {
            component.set('v.selectedFilterLevel1', -1);
            component.set("v.filtersExpandedLevel1", false);
        } else {
            component.set('v.selectedFilterLevel1', filter1index);
            component.set("v.filtersExpandedLevel1", true);
        }
        var KPItransactionsHeadersArray = component.get('v.KPItransactionsHeadersArray');
        var filterItem                  = component.get('v.filterItem');

        if ($A.util.isArray(KPItransactionsHeadersArray) && KPItransactionsHeadersArray.length) {
            if (KPItransactionsHeadersArray.map(function(item) {
                    return item.name;
                }).indexOf(filterItem.Name) >= 0) {
                component.set("v.filtersVisible", true);
            } else {
                component.set("v.filtersVisible", false);
            }
        } else {
            component.set("v.filtersVisible", false);
        }
    },
    afterRender: function(component, event, helper) {
        var KPItransactionsHeadersArray = component.get('v.KPItransactionsHeadersArray');
        var filterItem                  = component.get('v.filterItem');

        if ($A.util.isArray(KPItransactionsHeadersArray) && KPItransactionsHeadersArray.length) {
            if (KPItransactionsHeadersArray.map(function(item) {
                    return item.name
                }).indexOf(filterItem.Name) >= 0) {
                component.set("v.filtersVisible", true);
            } else {
                component.set("v.filtersVisible", false);
            }
        } else {
            component.set("v.filtersVisible", false);
        }
        if (component.get('v.isCodeApplied') === true && component.get('v.step') !== 2) {
            component.set('v.isCodeApplied', false);
            component.set('v.isTreeCreated', false);
        }
        if (component.get('v.isCodeApplied') === true || $A.util.isEmpty(component.get('v.filtersDefinition')) === true || component.get('v.step') !== 2) {
            return;
        }

        var filterName = component.get('v.filterItem.DisplayName');
        if (!filterName) {
            filterName = component.get('v.filterItem.Name');
            filterName = filterName.charAt(0).toUpperCase() + filterName.slice(1);
        }

        helper.initFilters(component);
        component.set('v.isCodeApplied', true);
        component.set('v.isTreeInitialized', true);
    },
    onFilterSelection: function(component, event, helper) {
        if (!component.isValid()) {
            return;
        }
        if (event.getParam('reset')) {
            component.set('v.selectedFilters', {});
            component.set('v.selectedFilter', '');
        }
    }
})