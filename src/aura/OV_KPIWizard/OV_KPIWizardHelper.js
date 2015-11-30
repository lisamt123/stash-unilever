({
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
            icon_class         : 'glyphicon glyphicon-chevron-right pull-right', //'fa fa-chevron-right pull-right dd-icon',
            link_type          : 'breadcrumb', //'backlink', //'breadcrumb', //breadcrumb , link, backlink
            reset_text         : 'All', //'<span class="fa fa-folder-open"></span>', // All
            default_text       : 'Select',
            show_end_nodes     : true, // drill to final empty nodes
            hide_empty         : true, // hide empty menu when menu_height is set, header no effected
            menu_height        : false, //'200px', // '200px' , false for auto height
            show_header        : false,
            header_tag         : 'div',// h3
            header_tag_class   : 'list-group-item active' // hidden list-group-item active
        };

        var filters = {
            'chooseOptions' : {'default_text': 'All'},
            'f1' : {'default_text': 'Accounting Unit'},
            'f2' : {'default_text': 'Brand'},
            'f3' : {'default_text': 'Business Unit'},
            'f4' : {'default_text': 'Channel'},
            'f5' : {'default_text': 'Customer'},
            'f6' : {'default_text': 'Geography'},
            'f7' : {'default_text': 'Category'},
            'f8' : {'default_text': 'Function'},
        };

        var that = this;

        for (var itemId in filters) {
            var el = $('#' + itemId, component.getElement());

            var configCopy      = config;
            config.default_text = filters[itemId].default_text;
            config.itemType     = filters[itemId].itemId;

            el.drilldown(configCopy);

            el.on('drilldown.linklclick', function(e) {
                that.handleNodeClick(e.target, $(this).attr('id'));
                e.preventDefault();
            });
        }

        // make sure scrollers are visible
        $('div.drilldown', component.getElement()).on('wheel DOMMouseScroll mousewheel wheel touchmove', function(e) {
            e.stopPropagation()
        });
    },

    handleNodeClick: function(node, typeId)
    {
        debugger;
    }
})