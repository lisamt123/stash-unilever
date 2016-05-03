({
	getFilters : function(component) {
        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue.status === '0') {
                    component.set('v.filtersStore', returnValue);
                    this.populateFiltersClean(component, returnValue);
                }
            } else {
                    //@TODO show error
            }
        };

        var action = component.get("c.getFilters");
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    populateFilters : function(component, type, filterValue, level) {
        var filtersList = component.get('v.filters'+type+level+'Objects');
        var filterElement;
        for(var i=0;i<filtersList.length;i++){
        	if(filterValue === filtersList[i][type+'Id']){
            	filterElement = filtersList[i];
                break;
            }
        }

        level = level + 1;
        if(filterElement !== undefined && filterElement[type+'Childs'] !== undefined && filterElement[type+'Childs'].length > 0){
            var filterList = filterElement[type+'Childs'];
            var ops = [];
        	ops.push({ 'label' : 'Select '+type, 'value' : '0' });
        	for(var i=0; i<filterList.length;i++){
            	ops.push({ 'label' : filterList[i][type+'Name'], 'value' : filterList[i][type+'Id'] });
        	}
        	component.set('v.filters'+type+level+'Options', ops);
        	component.set('v.filters'+type+level+'Objects', filterList);
            component.set('v.show'+type+'Level'+level, true);
        }else if(filterElement !== undefined){
            component.set('v.show'+type+'Level'+level, false);
        }
    },
    populateFiltersClean : function(component, store){
        var returnValue = store;
        var ops = [];
        ops.push({ 'label' : 'Select Category', 'value' : '0' });
        for(var i=0; i<returnValue.data.categoryFilters.length;i++){
            ops.push({ 'label' : returnValue.data.categoryFilters[i].categoryName, 'value' : returnValue.data.categoryFilters[i].categoryId });
        }
        component.set('v.filterscategory1Options', ops);
        component.set('v.filterscategory1Objects', returnValue.data.categoryFilters);

        ops = [];
        ops.push({ 'label' : 'Select Geography', 'value' : '0' });

        for(var i=0; i<returnValue.data.geographyFilters.length;i++){
            ops.push({ 'label' : returnValue.data.geographyFilters[i].geographyName, 'value' : returnValue.data.geographyFilters[i].geographyId });
        }
        component.set('v.filtersgeography1Options', ops);
        component.set('v.filtersgeography1Objects', returnValue.data.geographyFilters);

        ops = [];
        ops.push({ 'label' : 'Select Function', 'value' : '0' });
        for(var i=0; i<returnValue.data.functionFilters.length;i++){
            ops.push({ 'label' : returnValue.data.functionFilters[i].functionName, 'value' : returnValue.data.functionFilters[i].functionId });
        }
        component.set('v.filtersfunction1Options', ops);
        component.set('v.filtersfunction1Objects', returnValue.data.functionFilters);
    },
    search : function(component) {
        var functionId 		  = (component.get('v.filtersfunction1Selected') !== '0') ? component.get('v.filtersfunction1Selected') : undefined;
        var category1Id 	  = (component.get('v.filterscategory1Selected') !== '0') ? component.get('v.filterscategory1Selected') : undefined;
        var category2Id 	  = (component.get('v.filterscategory2Selected') !== '0') ? component.get('v.filterscategory2Selected') : undefined;
        var geography1Id 	  = (component.get('v.filtersgeography1Selected') !== '0') ? component.get('v.filtersgeography1Selected') : undefined;
        var geography2Id 	  = (component.get('v.filtersgeography2Selected') !== '0') ? component.get('v.filtersgeography2Selected') : undefined;
        var geography3Id 	  = (component.get('v.filtersgeography3Selected') !== '0') ? component.get('v.filtersgeography3Selected') : undefined;
        var reportVisibleToMe = component.get('v.allMineSelected') === 'mine' ? true : false;

        var geographyId;
        if (geography3Id !== undefined && geography3Id !== '') {
            geographyId = geography3Id;
        } else if (geography2Id !== undefined && geography2Id !== '') {
            geographyId = geography2Id;
        } else if (geography1Id !== undefined && geography1Id !== '') {
        	geographyId = geography1Id;
        }

        var categoryId;
        if (category2Id !== undefined && category2Id !== '') {
            categoryId = category2Id;
        } else if (category1Id !== undefined && category1Id !== '') {
            categoryId = category1Id;
        }

        // fire the event with data ...
        var eventObj = $A.get('e.c:OV_FiltersEvent');
        eventObj.setParams({
            functionId        : functionId,
            geographyId       : geographyId,
            categoryId        : categoryId,
            reportVisibleToMe : reportVisibleToMe
        });
        eventObj.fire();
    }
})