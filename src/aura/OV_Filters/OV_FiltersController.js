({
    doInit: function(component, event, helper) {
        helper.getFilters(component);
        // init
        component.set('v.allMineSelected', 'all');
    },
    toggle : function(component, event, helper) {
		var header = event.currentTarget || event.target;
        if (header && header.parentNode) {
        	$A.util.toggleClass(header.parentNode, "collapsed");
        }
    },

    onAllMineFilterChange : function(component, event, helper) {
        var element = event.currentTarget || event.target;
        var all     = component.find('all').getElements()[0];
        var mine    = component.find('mine').getElements()[0];

        if (all === element) {
            $A.util.addClass(all, 'selected');
            $A.util.removeClass(mine, 'selected');
        } else {
            $A.util.removeClass(all, 'selected');
            $A.util.addClass(mine, 'selected');
        }

		$A.get("e.c:OV_SelectboxChange").setParams({
	        selectboxName  : 'allMine',
            selectboxValue :  all === element ? 'all' : 'mine'
		}).fire();
    },
    selectboxHandler : function(component, event, helper) {
        if(event.getParam('selectboxName').substring(0, event.getParam('selectboxName').length - 1) === 'FilterGeography') {
            var level = parseInt(event.getParam('selectboxName').substring(event.getParam('selectboxName').length -1, event.getParam('selectboxName').length));

            if (event.getParam('selectboxValue') === '0') {
                if(level === 1){
                    component.set('v.filtersgeography1Selected', '');
                    component.set('v.filtersgeography2Options', []);
                    component.set('v.filtersgeography2Selected', '');
                    component.set('v.filtersgeography3Options', []);
                    component.set('v.filtersgeography3Selected', '');
                    component.set('v.showgeographyLevel2', false);
                    component.set('v.showgeographyLevel3', false);
                }else if(level === 2){
                    component.set('v.filtersgeography2Selected', '');
                    component.set('v.filtersgeography3Options', []);
                    component.set('v.filtersgeography3Selected', '');
                    component.set('v.showgeographyLevel3', false);
                }else{
                    component.set('v.filtersgeography3Selected', '');
                }
                helper.search(component);
            } else {
                var filterValue = event.getParam('selectboxValue');
                component.set('v.filtersgeography'+level+'Selected', filterValue);
                helper.search(component);

                if(level === 1){
                    component.set('v.showgeographyLevel3', false);
                }

                if(level !== 3){
                    helper.populateFilters(component, 'geography', filterValue, level);
                }
            }
        } else if(event.getParam('selectboxName').substring(0, event.getParam('selectboxName').length - 1) === 'FilterCategory') {
            var level = parseInt(event.getParam('selectboxName').substring(event.getParam('selectboxName').length -1, event.getParam('selectboxName').length));

            if (event.getParam('selectboxValue') === '0') {
                if(level === 1){
                    component.set('v.filterscategory1Selected', '');
                    component.set('v.filterscategory2Options', []);
                    component.set('v.filterscategory2Selected', '');
                    component.set('v.showcategoryLevel2', false);
                }
                helper.search(component);
            } else {
                var filterValue = event.getParam('selectboxValue');
                component.set('v.filterscategory'+level+'Selected', filterValue);
                helper.search(component);

                if(level !== 2){
                    helper.populateFilters(component, 'category', filterValue, level);
                }
            }
        } else if(event.getParam('selectboxName') === 'FilterFunction1') {
            component.set('v.filtersfunction1Selected', event.getParam('selectboxValue'));
            helper.search(component);
        } else if (event.getParam('selectboxName') === 'allMine') {
            component.set('v.allMineSelected', event.getParam('selectboxValue'));
            helper.search(component);
        }
    }
});