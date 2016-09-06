({
    initFilters2: function(component, config) {
        var config = component.get('v.drilldownConfig') || config;
        filters = component.get('v.filtersDefinition2');
        var that = this;
        var el = $('#' + component.get('v.filterItem').Name, component.getElement());
        var configCopy = config;
        var fieldName = component.get('v.filterItem.Name');
        var selectedFilter = component.get('v.selectedFilters.' + fieldName);
        var currentSelectedFilter = component.get('v.selectedFilter');
        var as = el.find('a');
        as.each(function(i, item) {
            var $item = $(item);
            if (!!selectedFilter && selectedFilter.Id && $item.data() && ($item.data()).value === selectedFilter.Id) {
                $item.addClass('selected');
            } else {
                $item.removeClass('selected');
            }
        });
        if ((!!selectedFilter && !currentSelectedFilter) || (!!selectedFilter && !!currentSelectedFilter && selectedFilter.Id !== currentSelectedFilter.Id)) {
            component.set('v.selectedFilter', selectedFilter);
        }
        el.drilldown(configCopy);
        el.on('drilldown.linklclick', function(e, data) {
            that.handleNodeClick(component, e.target, $(this).attr('id'), data);
            e.preventDefault();
        });
        // make sure scrollers are visible
        $('div.drilldown', component.getElement()).on('wheel DOMMouseScroll mousewheel wheel touchmove', function(e) {
            e.stopPropagation();
        });
    },
    updateSelectedFilters: function(component, filterId) {
        var filterBreadcrumbs = component.get('v.filterBreadcrumbs');
        var currentlyShownFiltersArray = component.get('v.currentlyShownFiltersArray');
        var filterItems = component.get('v.filterItem.Items');
        if (filterId) {
            var breadcrumbsIndex = filterBreadcrumbs.map(function(item) {
                return item.Id
            }).indexOf(filterId);
            if (breadcrumbsIndex < 0) {
                var index = currentlyShownFiltersArray.map(function(item) {
                    return item.Id
                }).indexOf(filterId);
                filterBreadcrumbs.push(currentlyShownFiltersArray[index]);
                currentlyShownFiltersArray = currentlyShownFiltersArray[index].Children || [];
            } else {
                filterBreadcrumbs.splice(breadcrumbsIndex+1);
                currentlyShownFiltersArray = filterBreadcrumbs[filterBreadcrumbs.length - 1].Children || [];
            }
        } else {
            filterBreadcrumbs = [];
            currentlyShownFiltersArray = filterItems;
        }
        component.set('v.filterBreadcrumbs', filterBreadcrumbs);
        component.set('v.currentlyShownFiltersArray', currentlyShownFiltersArray);
        this.constructList(component);
        this.constructBreadcrumbs(component);
    },
    handleNodeClick: function(component, node, data) {
        if (!node) {
            return;
        }

        var li = $(node).closest('li');
        var data = li.data();
        var filterId = data.value;
        var name = data.name;
        var type = component.get('v.filterItem.Name');
        this.updateSelectedFilters(component, filterId);
        var selectedFilters = component.get('v.selectedFilters');
        selectedFilters[type] = {
            Id: filterId,
            Name: name
        };
        component.set('v.selectedFilters', selectedFilters);
        component.set('v.selectedFilter', {
            Id: filterId,
            Name: name
        });
        $A.get('e.c:OV_WizardFilterSelectedEvent').fire();
    },
    initFilters: function(component) {
        var myNode = component.find('listNode').getElement();
        if (!myNode) {
            return;
        }
        $('div.drilldown', component.getElement()).on('wheel DOMMouseScroll mousewheel wheel touchmove', function(e) {
            e.stopPropagation();
        });
        this.constructList(component);
    },
    constructList: function(component) {
        var _this = this;
        var myNode = component.find('listNode').getElement();
        var nodeId = component.get('v.filterItem.Name');
        if (!nodeId) {
            return;
        }
        if (!myNode) {
            return;
        }
        $(myNode).off('click');
        $(myNode).on('click', function(e, data) {
            _this.handleNodeClick(component, e.target, data);
            e.preventDefault();
        });
        while (myNode.firstChild) {
            myNode.removeChild(myNode.firstChild);
        }
        var filters = component.get('v.currentlyShownFiltersArray');
        for (var i in filters) {
            if (filters.hasOwnProperty(i)) {
                var item = filters[i];
                var a = document.createElement('a')
                var li = document.createElement('li');
                a.innerHTML = item.Name + (item.Children.length ? '<span class="glyphicon glyphicon-chevron-right pull-right"></span>' : '');
                li.setAttribute('data-value', item.Id);
                li.setAttribute('data-name', item.Name);
                li.setAttribute('class', 'clickable');
                li.appendChild(a);
                myNode.appendChild(li);
            }
        }
    },
    constructBreadcrumbs: function(component) {
        var _this = this;
        var myNode = component.find('breadcrumbs').getElement();
        if (!myNode) {
            return;
        }
        $(myNode).off('click');
        $(myNode).on('click', function(e, data) {
            _this.handleBreadcrumbClick(component, e.target, data);
            e.preventDefault();
        });

        while (myNode.firstChild) {
            myNode.removeChild(myNode.firstChild);
        }

        var filterBreadcrumbs = component.get('v.filterBreadcrumbs');
        var li = document.createElement('li');
        var a = document.createElement('a')
        a.innerHTML = component.get('v.filterItem.DisplayName');
        li.setAttribute('class', 'first breadcrumbLink clickable');
        li.setAttribute('data-value', '');
        li.setAttribute('data-name', '');
        li.appendChild(a);
        myNode.appendChild(li);
        for (var i in filterBreadcrumbs) {
            if (filterBreadcrumbs.hasOwnProperty(i)) {
                var item = filterBreadcrumbs[i];
                var li = document.createElement('li');
                if (i < filterBreadcrumbs.length - 1) {
                    var a = document.createElement('a')
                    a.innerHTML = item.Name;
                    li.setAttribute('data-value', item.Id);
                    li.setAttribute('data-name', item.Name);
                    li.setAttribute('class', 'clickable breadcrumbLink');
                    li.appendChild(a);
                } else {
                    li.setAttribute('class', 'active');
                    li.innerHTML = item.Name;
                }
                myNode.appendChild(li);
            }
        }
    },
    handleBreadcrumbClick: function(component, node, data) {
        if (!node) {
            return;
        }

        var li = $(node).closest('li.breadcrumbLink');
        if (li.length === 0) {
            return;
        }
        var data = li.data();
        var filterId = data.value || null;
        var name = data.name;
        var type = component.get('v.filterItem.Name');
        this.updateSelectedFilters(component, filterId);
        var selectedFilters = component.get('v.selectedFilters');
        var selectedFilter = null;
        if (name && filterId) {
            selectedFilter = {
                Id: filterId,
                Name: name
            }
            selectedFilters[type] = selectedFilter;
        }else{
            delete selectedFilters[type];
        }
        component.set('v.selectedFilters', selectedFilters);
        component.set('v.selectedFilter', selectedFilter);
        $A.get('e.c:OV_WizardFilterSelectedEvent').fire();
    }
})