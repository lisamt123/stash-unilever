({
    loadData: function(component, filters) {
        if ((!$A || !$A.OV || $A.OV.kpiDataLoaded !== true)) {
            // remember that data were already loaded
            $A.OV = $A.OV || {};
            $A.OV.kpiDataLoaded = true;

            this.getMyKPIElements(component, filters || {});
            this.getKPINames(component);
            this.getMyFavouritesReports(component, filters || {});
        }
    },
    getKPINames : function(component) {
        var action   = component.get('c.getKPINames');
        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue.status === '0') {
                    component.set('v.kpiNamesStore', returnValue);
                    this.populateKPINames(component, returnValue);
                } else {
                    $A.error('An error occured while loading KPI names');
                }
            }
        };

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    populateKPINames : function(component, store){
        var returnValue = store;
        var ops         = [];
        ops.push({ 'label' : 'Select KPI Name', 'value' : '0' });
        for(var i = 0; i < returnValue.data.kpiNames.length;i++){
            ops.push({ 'label' : returnValue.data.kpiNames[i].kpiNameName, 'value' : returnValue.data.kpiNames[i].kpiNameId });
        }
        component.set('v.kpiNameOptions', ops);
    },
    reloadKPINames : function(component){
        this.populateKPINames(component, component.get('v.kpiNamesStore'));
    },
    getKPIReports : function(component, kpiNameId) {
        var action = component.get('c.getKPIReports');
        action.setParams({
            'kpiNameId' : kpiNameId
        });

        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue.status === '0') {
                    var ops = [];
                    ops.push({ 'label' : 'Select Report', 'value' : '0' });
                    for(var i=0; i<returnValue.data.kpiReports.length;i++){
                        ops.push({ 'label' : returnValue.data.kpiReports[i].reportTitle, 'value' : returnValue.data.kpiReports[i].reportId });
                    }
                    component.set('v.kpiReportOptions', ops);
                    component.set('v.showReports', true);
                } else {
                    //@TODO show error
                }
            }
        };

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    getKPIElements : function(component, kpiNameId, reportId) {
        var action = component.get('c.getKPIElements');

        action.setParams({
            'kpiNameId'   : kpiNameId,
            'reportId'    : reportId
        });

        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue.status === '0') {
                    component.set('v.kpiElements', returnValue.data.kpiElements);
                    this.findKPI(component);
                }
            } else {
                    //@TODO show error
            }
        };

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    populateFiltersClean : function(component, store)
    {
        // check incoming data
        var dataList = $A.util.isEmpty(store) === false && $A.util.isEmpty(store.data) === false ? store.data : {};

        component.set('v.filtersbrandOptions', this.extractFilters(
                dataList.brandFilters,
                'brandName',
                'brandId',
                'Select Brand'
            )
        );

        component.set('v.filterscomparatorOptions', this.extractFilters(
                dataList.comparatorFilters,
                'comparatorName',
                'comparatorId',
                'Select Comparator'
            )
        );

        component.set('v.filterschannelOptions', this.extractFilters(
                dataList.channelFilters,
                'channelName',
                'channelName',
                'Select Channel'
            )
        );

        component.set('v.filterstimespanOptions', this.extractFilters(
                dataList.timespanFilters,
                'timespanName',
                'timespanName',
                'Select Time Span'
            )
        );

        component.set('v.filterscustomer1Options', this.extractFilters(
                dataList.customerFilters,
                'customerName',
                'customerId',
                'Select Customer'
            )
        );

        component.set('v.filterscategory1Options', this.extractFilters(
                dataList.categoryFilters,
                'categoryName',
                'categoryId',
                'Select Category'
            )
        );

        component.set('v.filtersgeography1Options', this.extractFilters(
                dataList.geographyFilters,
                'geographyName',
                'geographyId',
                'Select Geography'
            )
        );

        component.set('v.filtersfunction1Options', this.extractFilters(
                dataList.functionFilters,
                'functionName',
                'functionId',
                'Select Function'
            )
        );

        component.set('v.filterscustomer1Objects', dataList.customerFilters     || []);
        component.set('v.filterscategory1Objects', dataList.categoryFilters     || []);
        component.set('v.filtersgeography1Objects', dataList.geographyFilters   || []);
        component.set('v.filtersfunction1Objects', dataList.functionFilters     || []);
    },

    extractFilters: function(filtersList, filterLabelKey, filterValueKey, filterLabel) {
        // initialize object
        var result = [{
            label : filterLabel,
            value : '0'
        }];

        // check if we have filter data
        if (filtersList && filtersList.length > 0) {
            // extract data into result array
            for (var i = 0, len = filtersList.length; i < len; i++) {
                result.push({
                    label : filtersList[i][filterLabelKey],
                    value : filtersList[i][filterValueKey]
                });
            }
        }

        return result;
    },
    reloadFilters : function(component){
        this.populateFiltersClean(component, component.get('v.filtersStore'));
    },
    getFilters : function(component) {
        var action = component.get('c.getFilters');

        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue.status === '0') {
                    component.set('v.filtersStore', returnValue);
                    this.populateFiltersClean(component, returnValue);
                }
            } else {
                // @TODO show error
            }
        };

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
            for (var j = 0; j<filterList.length; j++) {
                ops.push({ 'label' : filterList[j][type+'Name'], 'value' : filterList[j][type+'Id'] });
            }
            component.set('v.filters'+type+level+'Options', ops);
            component.set('v.filters'+type+level+'Objects', filterList);
            component.set('v.show'+type+'Level'+level, true);
        }else if(filterElement !== undefined){
            component.set('v.show'+type+'Level'+level, false);
        }
    },

    getFilterValue: function(component, valueField) {
        var value = component.get('v.' + valueField);
        return value !== '0' && value !== '' ? value : undefined;
    },

    findKPI : function(component) {
        var kpiNameId    = getFilterValue(component, 'selectedKpiName');
        var reportId     = getFilterValue(component, 'selectedKpiReport');

        var kpiElements  = component.get('v.kpiElements');
        var foundKPIs    = [];

        component.set('v.kpiFoundElement', {});
        component.set('v.isKpiFoundElement', false);

        if( !!kpiNameId && !!reportId ) {
            var category1Id  = getFilterValue(component, 'filterscategory1Selected');
            var category2Id  = getFilterValue(component, 'filterscategory2Selected');
            var geography1Id = getFilterValue(component, 'filtersgeography1Selected');
            var geography2Id = getFilterValue(component, 'filtersgeography2Selected');
            var geography3Id = getFilterValue(component, 'filtersgeography3Selected');

            var geographyId  = geography3Id || geography2Id || geography1Id;
            var categoryId   = category2Id || category1Id;

            var filterMap    = {
                kpiElementGeographyId       : geographyId,
                kpiElementCategoryId        : categoryId,
                kpiElementFunctionId        : getFilterValue(component, 'filtersfunction1Selected'),
                kpiElementBrandId           : getFilterValue(component, 'filtersbrandSelected'),
                kpiElementBrandComparatorId : getFilterValue(component, 'filterscomparatorSelected'),
                kpiElementChannel           : getFilterValue(component, 'filterschannelSelected'),
                kpiElementTimeSpan          : getFilterValue(component, 'filterstimespanSelected'),
                kpiElementCustomer          : getFilterValue(component, 'filterscustomerSelected')
            };

            for (var i = 0, len = kpiElements.length; i < len; i++) {
                for (var filterField in filterMap) {
                    if (filterMap.hasOwnProperty(filterField) === true && kpiElements[i].hasOwnProperty(filterField) === true && !!filterMap[filterField] === true && kpiElements[i][filterField] === filterMap[filterField]) {
                        foundKPIs.push(kpiElements[i]);
                        // why is it here ????
                        component.set('v.kpiFoundElement', kpiElements[i]);
                        // stop loop
                        break;
                    }
                }
            }
        }
        component.set('v.isKpiFoundElement', foundKPIs.length > 0);
        component.set('v.foundKPIs', foundKPIs);
    },
    addKPIElementToMyKPIs : function(component, stringIds, doneCallback, filters) {
        var action = component.get('c.addKPIElementToMyKPIs');
        action.setParams({
            'kpiElementIds'    : stringIds,
            'shouldBeNotified' : component.get('v.shouldBeNotified')
        });

        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue.status === '0') {
                    this.toggleNewKPIDialog(component);
                    this.getMyKPIElements(component, filters || {});
                    if(doneCallback && typeof(doneCallback) === 'function'){
                        doneCallback();
                    }
                } else {
                    //@TODO show error
                }
                component.set('v.addKPIInProgress', false);
            }
        };

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    getMyKPIElements : function(component, filters) {
        var action = component.get('c.getMyKPIElements');
        filters    = filters || {};

        var params = {
            'geographyId' : filters.reportGeography    || '',
            'categoryId'  : filters.reportCategory     || '',
            'functionId'  : filters.reportFunction     || '',
            'mineOnly'    : filters.reportVisibleToMe  || false
        };

        action.setParams(params);

        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue.status === '0') {
                    component.set('v.mykpiElements', returnValue.data.kpiElements);
                }
            } else {
                    //@TODO show error
            }
        };

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    toggleNewKPIDialog: function(component) {
        var newKPIDialog        = component.find('newKPIDialog').getElement();
        var KPIFavouriteReports = component.find('KPIFavouriteReports').getElement();
        var KPIContent          = component.find('KPIContent').getElement();
        var isShowing           = component.get('v.dialogIsShowing');
        if (isShowing) {
            component.set('v.showReports', false);
            component.set('v.showFilters', false);
            component.set('v.showcustomerLevel1', false);
            component.set('v.showcategoryLevel1', false);
            component.set('v.showgeographyLevel2', false);
            component.set('v.showgeographyLevel3', false);
            component.set('v.selectedKpiName', '0');
            component.set('v.selectedKpiReport', '0');
            component.set('v.filterstimespanSelected', '0');
            component.set('v.filterschannelSelected', '0');
            component.set('v.filtersbrandSelected', '0');
            component.set('v.filterscomparatorSelected', '0');
            component.set('v.filtersfunction1Selected', '0');
            component.set('v.filterscategory1Selected', '0');
            component.set('v.filterscategory2Selected', '0');
            component.set('v.filterscustomer1Selected', '0');
            component.set('v.filterscustomer2Selected', '0');
            component.set('v.filtersgeography1Selected', '0');
            component.set('v.filtersgeography2Selected', '0');
            component.set('v.filtersgeography3Selected', '0');
            component.set('v.isKpiFoundElement', false);
            this.reloadFilters(component);
            this.reloadKPINames(component);

            // hide it
            component.set('v.dialogIsShowing', false);
            // This is ugly but will do for now
            newKPIDialog.style.display        = 'none';
            KPIFavouriteReports.style.display = 'block';
            KPIContent.style.display          = 'block';
        } else {
            // show it
            component.set('v.dialogIsShowing', true);
            newKPIDialog.style.display        = 'block';
            KPIFavouriteReports.style.display = 'none';
            KPIContent.style.display          = 'none';
        }
    },
    deleteMyKPIElement : function(component, kpiNameId, inCallback) {
        var action = component.get('c.deleteMyKPI');

        action.setParams({
            'kpiElementId' : kpiNameId
        });

        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue.status === '0') {
                    this.getMyKPIElements(component);
                }
            } else {
                    //@TODO show error
            }
        };

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    getMyFavouritesReports : function(component, filters) {
        var action = component.get('c.getMyFavouritesReports');
        filters    = filters || {};
        var params = {
            'geographyId' : filters.reportGeography    || '',
            'categoryId'  : filters.reportCategory     || '',
            'functionId'  : filters.reportFunction     || '',
            'mineOnly'    : filters.reportVisibleToMe  || false
        };

        action.setParams(params);

        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue.status === '0') {
                    component.set('v.myFavouritereportsSubjects', returnValue.data.reports.Subjects);
                    component.set('v.myFavouritereportsMoments', returnValue.data.reports.Moments);

                }
            } else {
                    //@TODO show error
            }
        };

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },

    resetGeographyFilterByLevel: function(component, level, filterValue)
    {
        if ($A.util.isEmpty(filterValue) || filterValue === '0') {
            if(level === 1){
                component.set('v.filtersgeography1Selected',    '');
                component.set('v.filtersgeography2Options',     []);
                component.set('v.filtersgeography2Selected',    '');
                component.set('v.filtersgeography3Options',     []);
                component.set('v.filtersgeography3Selected',    '');
                component.set('v.showgeographyLevel2',          false);
                component.set('v.showgeographyLevel3',          false);
            }else if(level === 2){
                component.set('v.filtersgeography2Selected',    '');
                component.set('v.filtersgeography3Options',     []);
                component.set('v.filtersgeography3Selected',    '');
                component.set('v.showgeographyLevel3',          false);
            }else{
                component.set('v.filtersgeography3Selected',    '');
            }
            this.findKPI(component);
        } else {
            component.set('v.filtersgeography'+level+'Selected', filterValue);
            this.findKPI(component);

            if(level === 1){
                component.set('v.showgeographyLevel3', false);
            }

            if(level !== 3){
                this.populateFilters(component, 'geography', filterValue, level);
            }
        }
    }
})