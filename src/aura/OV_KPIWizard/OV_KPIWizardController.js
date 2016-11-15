({
	doInit: function(component, event, helper) {
        // mock data
        var mockOptions = [
            {
                optionId: '1',
                optionName: 'Brand Equality'
            },
            {
                optionId: '2',
                optionName: 'CCFOT'
            },
            {
                optionId: '3',
                optionName: 'Core Operating Margin'
            },
            {
                optionId: '4',
                optionName: 'Diversity'
            },
            {
                optionId: '5',
                optionName: 'Enhanced Livelihoods'
            },
            {
                optionId: '6',
                optionName: 'Free Cashflow'
            },
            {
                optionId: '7',
                optionName: 'Global People Survey'
            },
            {
                optionId: '8',
                optionName: 'Gross Margin'
            },
            {
                optionId: '9',
                optionName: 'Improve Health and Wellbeing'
            },
            {
                optionId: '10',
                optionName: 'Innovation Turnover'
            },
            {
                optionId: '11',
                optionName: 'Market Share'
            },
            {
                optionId: '12',
                optionName: 'Overheads'
            },
        ];

        for (var i = 0, len = mockOptions.length; i < len; i++) {
            mockOptions[i].childNodes = [
                {
                    optionId: Math.round(Math.random(0, 1000) * 10000,1),
                    optionName: 'Nested Option 1'
                },
                {
                    optionId: Math.round(Math.random(0, 1000) * 10000,1),
                    optionName: 'Nested Option 2'
                },
                {
                    optionId: Math.round(Math.random(0, 1000) * 10000,1),
                    optionName: 'Nested Option 3'
                }
            ];
        }

        component.set('v.chooseOptions', mockOptions);


        // mock data
        var mockFilters = [
            {
                filterId: '1',
                filterName: 'Accounting Unit'
            },
            {
                filterId: '2',
                filterName: 'Brand'
            },
            {
                filterId: '3',
                filterName: 'Business Unit'
            },
            {
                filterId: '4',
                filterName: 'Channel'
            },
            {
                filterId: '5',
                filterName: 'Customer'
            },
            {
                filterId: '6',
                filterName: 'Geography'
            },
            {
                filterId: '7',
                filterName: 'Category'
            },
            {
                filterId: '8',
                filterName: 'Function'
            }
        ];

        for (var i = 0, len = mockFilters.length; i < len; i++) {
            mockFilters[i].childNodes = [
                {
                    filterId: Math.round(Math.random(0, 1000) * 10000,1),
                    filterName: 'Nested Filter 1',
                    childNodes: [{
                        filterId: Math.round(Math.random(0, 1000) * 10000,1),
                        filterName: 'Nested Filter 1.1'
                    }, {
                        filterId: Math.round(Math.random(0, 1000) * 10000,1),
                        filterName: 'Nested Filter 1.2'
                    }]
                },
                {
                    optionId: Math.round(Math.random(0, 1000) * 10000,1),
                    optionName: 'Nested Filter 2',
                    childNodes: [{
                        filterId: Math.round(Math.random(0, 1000) * 10000,1),
                        filterName: 'Nested Filter 2.1'
                    }, {
                        filterId: Math.round(Math.random(0, 1000) * 10000,1),
                        filterName: 'Nested Filter 2.2'
                    }]
                },
                {
                    optionId: Math.round(Math.random(0, 1000) * 10000,1),
                    optionName: 'Nested Filter 3',
                    childNodes: [{
                        filterId: Math.round(Math.random(0, 1000) * 10000,1),
                        filterName: 'Nested Filter 3.1'
                    }, {
                        filterId: Math.round(Math.random(0, 1000) * 10000,1),
                        filterName: 'Nested Filter 3.2'
                    }]
                }
            ];
        }

        component.set('v.filters', mockFilters);
	},

    onTabClick: function(component, event, helper) {
        var targetViewId = event.getParam('targetViewId');

        component.find('chooseOptions').getElement().style.display = 'none';
        component.find('filters').getElement().style.display = 'none';
        component.find('linking').getElement().style.display = 'none';

        if (targetViewId == 'Choose KPI') {
            component.find('chooseOptions').getElement().style.display = '';
        } else if (targetViewId == 'Filtering') {
            component.find('filters').getElement().style.display = '';
        } else {
            component.find('linking').getElement().style.display = '';
        }
    },

    doInitFiltersCode: function(component, event, helper) {
        if (component.get('v.isCodeApplied') === true || $A.util.isEmpty(component.get('v.chooseOptions')) == true) {
            return;
        }

        helper.initFilters(component);

        var selectedFilters = component.get('v.selectedFilters');

        component.set('v.isCodeApplied', true);
    }
})