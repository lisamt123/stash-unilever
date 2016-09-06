({
    loadFilters: function(component) {
        var actionCallback = function(action, component) {
            if (action.getState() === 'SUCCESS') {
                debugger;
                component.set('v.filtersDefinition', action.getReturnValue().data || {});
            }
        };

        var action = component.get("c.getFilters");
        action.setCallback(this, actionCallback);
        $A.enqueueAction(action);
    },

    initFilters: function(component) {
        var config = {
            wrapper_class      : 'drilldown panel panel-success',
            menu_class         : 'drilldown-menu',
            submenu_class      : 'nav ',
            parent_class       : 'dd-parent',
            parent_class_link  : 'dd-parent-a',
            active_class       : 'active',
            header_class_list  : 'breadcrumb',
            header_class       : 'breadcrumbwrapper',
            class_selected     : 'selected',
            event_type         : 'click',
            hover_delay        : 300,
            speed              : 'fast',
            save_state         : false,
            show_count         : false,
            count_class        : 'dd-count',
            icon_class         : 'glyphicon glyphicon-chevron-right pull-right',
            //breadcrumb , link, backlink
            link_type          : 'breadcrumb',
            //'<span class="fa fa-folder-open"></span>', // All
            reset_text         : 'All',
            default_text       : 'Select Geography',
            show_end_nodes     : true,
            hide_empty         : true,
            // '200px' , false for auto height
            menu_height        : '200px',
            show_header        : false,
            // h3
            header_tag         : 'div',
            // hidden list-group-item active
            header_tag_class   : 'list-group-item active'
        };

        var filters = {
            'geography' : {'default_text': 'Select Geography'},
            'category'  : {'default_text': 'Select Category'},
            'function'  : {'default_text': 'Select Function'}
        };

        var that = this;

        var handleNodeClickAnonymous = function(e, data) {
            that.handleNodeClick(e.target, $(this).attr('id'), data);
            e.preventDefault();
        };
        for (var itemId in filters) {
            if (filters.hasOwnProperty(itemId) === true) {
                var el = $('#' + itemId, component.getElements()[1]);

                var configCopy      = config;
                config.default_text = filters[itemId].default_text;
                config.itemType     = filters[itemId].itemId;

                el.drilldown(configCopy);
                el.on('drilldown.linklclick', handleNodeClickAnonymous);
            }
        }
        // make sure scrollers are visible
        $('div.drilldown', component.getElements()[1]).on('wheel DOMMouseScroll mousewheel wheel touchmove', function(e) {
            e.stopPropagation();
        });

        /**
         * Code responsible for resizing filters when menu is collapsed or expanded
         * since we cannot bind to one.appNav event
         */
        var appToggle   = document.getElementsByClassName('oneAppNavToggle');
        if (appToggle.length > 0) {
            var classes     = appToggle[0].className;
            var timeoutId   = null;
            var intervalId  = setInterval(function() {
                var appToggleBtn = document.getElementsByClassName('oneAppNavToggle');
                // if classes changed
                if (appToggle.length > 0 && appToggle[0].className !== classes) {
                    classes = appToggle[0].className;
                    // check if timeout was created, if so delete it
                    if (timeoutId !== null) {
                        clearTimeout(timeoutId);
                        timeoutId = null;
                    }
                    // and create new one and wait to make sure menu is completly hidden / visible and
                    // width of main container is set
                    timeoutId = setTimeout(function() {
                        $(window).trigger('resize');
                    }, 250);
                }
                // if user navigated away from the page then clear timeout and interval
                if (document.getElementsByClassName('drilldown').length === 0) {
                    if (timeoutId !== null) {
                        clearTimeout(timeoutId);
                        timeoutId = null;
                    }
                    clearInterval(intervalId);
                    intervalId = null;
                }
            }, 500);
        }
    },

    handleNodeClick: function(node, typeId, data)
    {
        if (!node) {
            return;
        }
        data = data || {};

        var type   = data.type;
        var value  = data.value;

        // when resetting the node we
        if (!value || !type) {
            // check for selected elements
            var selected = $('.selected', this);
            if (selected.length) {
                return this.handleNodeClick(selected[0], typeId, data);
            }
            // nothing selected so reset filter
            type = typeId;
        }

        // update global filter info
        $A.OV                 = $A.OV || {};
        $A.OV.selectedFilters = $A.OV.selectedFilters || {};

        $A.OV.selectedFilters[type + 'Id'] = value;

        this.search($A.OV.selectedFilters);
    },

    search: function(configObj) {
        var config = configObj || {};

        // fire the event with data ...
        var eventObj = $A.get('e.c:OV_FiltersEvent');
        eventObj.setParams({
            functionId        : config.functionId,
            geographyId       : config.geographyId,
            categoryId        : config.categoryId,
            reportVisibleToMe : false
        });
        eventObj.fire();
    }
})