({
    getDefaultTab: function(){
        return $A && $A.OV && $A.OV.selectedTab ? $A.OV.selectedTab : 'SUBJECTS';
    },

    getShelfsTilesAndReports : function(component, filters, inCallback) {
        var deviceType = '';
        if ($A.get('$Browser.formFactor') === 'PHONE') {
            deviceType = 'Mobile';
        } else if ($A.get('$Browser.isIOS') || $A.get('$Browser.isAndroid')) {
            deviceType = 'Tablet';
        } else {
            deviceType = 'Desktop';
        }

        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue && returnValue.data && returnValue.data.filters) {
                    $A.OV = $A.OV || {};
                    $A.OV.selectedFilters = returnValue.data.filters;
                    var tabConfig = {
                        'reportCategory'    : ($A.OV.selectedFilters.categoryId ? $A.OV.selectedFilters.categoryId  : ''),
                        'reportGeography'   : ($A.OV.selectedFilters.geographyId? $A.OV.selectedFilters.geographyId : ''),
                        'reportFunction'    : ($A.OV.selectedFilters.functionId ? $A.OV.selectedFilters.functionId  : ''),
                        'reportVisibleToMe' : ($A.OV.selectedFilters.mineOnly   ? $A.OV.selectedFilters.mineOnly    : false),
                        'recordTypeName'    : filters.recordTypeName
                    };
                    if (filters.recordTypeName === 'Subject') {
                        component.set('v.filters1', tabConfig);
                    } else if(filters.recordTypeName === 'Moment') {
                        component.set('v.filters2', tabConfig);
                    }
                }
                inCallback(returnValue);
            }
            // check if filters are applied
            this.checkIfFiltersApplied(component);
        };

        var action = component.get('c.search');
        action.setParams({
            'geographyId'      : filters.reportGeography,
            'categoryId'       : filters.reportCategory,
            'functionId'       : filters.reportFunction,
            'mineOnly'         : filters.reportVisibleToMe,
            'recordTypeName'   : filters.recordTypeName,
            'deviceType'       : deviceType,
            'filtersFromCache' : component.get('v.filtersFromCache')
        });

        action.setCallback(this, callback);

        //dh
        action.setExclusive();

        $A.enqueueAction(action);
    },

    loadData: function(component, subjectTabConfig, momentTabConfig) {
        // Subjects
        var inCallback = function(data) {
            if (data.status === '0') {
                component.set('v.subjectData', data.data.shelfs);
            } else {
                $A.error('Failed to load SUBJECTS data');
            }
        };

        component.set('v.filters1', subjectTabConfig);
        this.getShelfsTilesAndReports(component, subjectTabConfig, inCallback);

        // Moments
        var inCallback2 = function(data) {
            if (data.status === '0') {
                component.set('v.momentData', data.data.shelfs);
            } else {
                $A.error('Failed to load MOMENTS data');
            }
        };
        component.set('v.filters2', momentTabConfig);
        this.getShelfsTilesAndReports(component, momentTabConfig, inCallback2);
    },

    checkIfFiltersApplied: function(component) {
        var filters1       = component.get('v.filters1');
        var filters2       = component.get('v.filters2');

        // keys to check
        var keys           = ['geographyId', 'categoryId', 'functionId', 'reportCategory', 'reportFunction', 'reportGeography'];
        // function checks if filter is not empty for given set of keys
        function isFilterApplied(keysToCheck, filtersObject) {
            var result = false;
            if ($A.util.isObject(filtersObject) === false) {
                return result;
            }
            if ($A.util.isEmpty(filtersObject) === true) {
                return result;
            }
            for (var i = 0, len = keysToCheck.length; i < len; i++) {
                if ( $A.util.isEmpty(filtersObject[keysToCheck[i]]) === false ) {
                    result = true;
                    break;
                }
            }
            return result;
        }

        component.set('v.filtersApplied', isFilterApplied(keys, filters1) || isFilterApplied(keys, filters2));
    }
});