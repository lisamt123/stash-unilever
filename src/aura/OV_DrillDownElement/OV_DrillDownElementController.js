({
    doInit: function(component, event, helper) {
        var fieldName = component.get('v.fieldName');
        var selectedFilter = component.get('v.selectedFilters.' + component.get('v.fieldName'));
        //        console.log('drilldown element filtersDefinition', component.get('v.filtersDefinition'));
        component.set('v.selectedFilter', selectedFilter);
        //var as = $(component.render()[0]).find('>li>a');
    },
    getSelectedFilter: function(component, event, helper) {
        var fieldName = component.get('v.fieldName');
        var selectedFilter = component.get('v.selectedFilters.' + component.get('v.fieldName'));
        return selectedFilter;
    },
    afterRender: function(component, event, helper) {
        var fieldName = component.get('v.fieldName');
        var selectedFilter = component.get('v.selectedFilters.' + component.get('v.fieldName'));
        var currentSelectedFilter = component.get('v.selectedFilter');
        /*        var as = $(component.render()[0]).find('>li>a');
                as.each(function(i,item){
                    if(!!selectedFilter && selectedFilter.Id && $(item).data() && ($(item).data()).value == selectedFilter.Id){
                        $(item).addClass('selected');
                        debugger;
                    }else{
                        $(item).removeClass('selected');
                    }
                });     */
        if ((!!selectedFilter && !currentSelectedFilter) || (!!selectedFilter && !!currentSelectedFilter && selectedFilter.Id !== currentSelectedFilter.Id)) {
            //console.log('drilldown element filtersDefinition', component.get('v.filtersDefinition'));
            component.set('v.selectedFilter', selectedFilter);
        }
        var el = component.getElement();
        if (!component.get('v.isTreeCreated') && el && el.nodeName) {
            //debugger;
            var test = helper.creteTreeNode(el, component.get('v.fieldName'), component.get('v.filtersDefinition'), component.get('v.domId'));
            //debugger;
            component.set('v.isTreeCreated', true);
        }
    }
})