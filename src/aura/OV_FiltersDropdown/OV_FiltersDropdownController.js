({
    doInit: function(component, event, helper) {
        // load filters
        helper.loadFilters(component);

        var selectedFilters = $A.OV && $A.OV.selectedFilters ? $A.OV.selectedFilters : {};
        component.set('v.selectedFilters', selectedFilters);
    },

    doInitFiltersCode: function(component, event, helper) {
        if (component.get('v.isCodeApplied') === true || $A.util.isEmpty(component.get('v.filtersDefinition')) === true) {
            return;
        }

        helper.initFilters(component);

        var selectedFilters = component.get('v.selectedFilters');

        component.set('v.isCodeApplied', true);
    }
})