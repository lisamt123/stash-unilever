({
    getMyFavouritesReports: function(component) {
        if (!component.isValid()) {
            return;
        }
        var actionCallback = function(action, component) {
            if (action.getState() === 'SUCCESS') {
                var returnValue = action.getReturnValue();
                var data = returnValue.data;

                if (returnValue.status !== '0') {
                    this.handleError(returnValue.message);
                } else if (data) {
                    var favouriteReports = [];
                    if (data.reports) {
                        for (var i in data.reports) {
                            if ($A.util.isArray(data.reports[i])) {
                                favouriteReports = favouriteReports.concat(data.reports[i]);
                            }
                        }
                    }
                    component.set('v.favouriteReportsAvailable',favouriteReports.length>0);
                    component.set('v.favouriteReports', favouriteReports);
                }
            }
        };
        var action = component.get("c.getMyFavouritesReports");
        action.setCallback(this, actionCallback);
        $A.enqueueAction(action);
    },
    loadFilters: function(component) {
        if (!component.isValid()) {
            return;
        }
        component.set('v.operationPending', true);
        var actionCallback = function(action, component) {
            if (action.getState() === 'SUCCESS') {
                var returnValue = action.getReturnValue();
                var data = returnValue.data;
                if (returnValue.status !== '0') {
                    this.handleError(returnValue.message);
                } else if (data) {
                    var filtersDefinition = [];
                    var flattenedFiltersDef = {};
                    for (var i in data) {
                        if (data.hasOwnProperty(i)) {
                            var flattenedFilter = {};
                            var items = this.mapFilterNames(data[i]);
                            flattenedFiltersDef[i.replace('Filters', '')] = this.flattenFilters(component, items, flattenedFilter);
                            filtersDefinition.push({
                                Name: i.replace('Filters', ''),
                                DisplayName: data[i].Name,
                                Items: items,
                                Icon: data[i].Icon
                            });
                        }
                    }
                    component.set('v.flattenedFiltersDef', flattenedFiltersDef);
                    component.set('v.filtersDefinition', filtersDefinition || {});
                    component.set('v.selectedFilterArray', []);
                }
            }
            component.set('v.operationPending', false);
        };
        var action = component.get("c.getFilters");
        action.setCallback(this, actionCallback);
        $A.enqueueAction(action);
    },
    destroyBody: function(component) {
        var oldComponents = component.get('v.body');
        if (oldComponents && oldComponents.length) {
            for (var i = 0, len = oldComponents.length; i < len; i++) {
                if (oldComponents[i].isValid() === true) {
                    oldComponents[i].unrender();
                    //oldComponents[i].destroy(false);
                }
            }
        }
    },
    loadKPIs: function(component) {
        if (!component.isValid()) {
            return;
        }
        component.set('v.operationPending', true);
        var actionCallback = function(action, component) {
            if (action.getState() === 'SUCCESS') {
                var returnValue = action.getReturnValue();
                var data = returnValue.data;
                if (returnValue.status !== '0') {
                    this.handleError(returnValue.message);
                } else if (data && data.kpiNames) {
                    var kpiNames = data.kpiNames;
                    component.set('v.kpiNames', kpiNames || {});
                }
            }
            component.set('v.operationPending', false);
        };
        var action = component.get("c.getKpiNames");
        action.setCallback(this, actionCallback);
        $A.enqueueAction(action);
    },
    _extractHeaderMappings: function(headerList, verificationObject) {
        var result = [];
        for (var i in headerList) {
            if (verificationObject.hasOwnProperty(i)) {
                result.push({
                    displayName: headerList[i],
                    name: i
                });
            }
        }
        return result;
    },
    getKPITransactions: function(component) {
        if (!component.isValid()) {
            return;
        }
        component.set('v.operationPending', true);
        var actionCallback = function(action, component) {
            if (action.getState() === 'SUCCESS') {
                var returnValue = action.getReturnValue();
                var data = returnValue.data;
                if (returnValue.status !== '0') {
                    this.handleError(returnValue.message);
                } else if (data) {
                    this.processKPIList(data, component);
                }
            }
            component.set('v.operationPending', false);
        };
        var action = component.get("c.getKPITransactions");
        var filters = this.buildFiltersList(component);
        filters.kpiName = [component.get('v.selectedKPI.id')];
        action.setParams({
            dimensions: JSON.stringify(filters)
        });
        action.setCallback(this, actionCallback);
        $A.enqueueAction(action);
    },
    processKPIList: function(data, component) {
        var lastPageNum = Math.ceil(data.count / component.get('v.paginationPageSize'));
        var filteredKPItransactions = (data && data.transactions) ? data.transactions : [];
        var headerMapping = (data && data.headerMapping) ? data.headerMapping : {};
        var paginatedFilteredKPItransactions = [];
        var paginationArray = [];
        var KPItransactionsHeadersArray = this._extractHeaderMappings(headerMapping, headerMapping);
        if (filteredKPItransactions.length) {
            for (var k = 1; k <= lastPageNum; k++) {
                paginationArray.push(k);
            }
            component.set('v.isFirstPage', true);
            if (lastPageNum === 1) {
                component.set('v.isLastPage', true);
            } else {
                component.set('v.isLastPage', false);
            }
            var dataPresentForHeader = {};
            var selectedKPITransactions = component.get('v.selectedKPITransactions');
            for (var i in filteredKPItransactions) {
                if (filteredKPItransactions.hasOwnProperty(i)) {
                    for (var j in filteredKPItransactions[i]) {
                        if (filteredKPItransactions[i][j]) {
                            dataPresentForHeader[j] = true;
                        }
                    }
                    if (selectedKPITransactions.hasOwnProperty(filteredKPItransactions[i].Id)) {
                        filteredKPItransactions[i].Selected = true;
                    }
                }
            }
            KPItransactionsHeadersArray = this._extractHeaderMappings(headerMapping, dataPresentForHeader);
            KPItransactionsHeadersArray.push({
                displayName: 'KPI Value'
            });
            headerMapping['kpiTransactionActualCurrentPeriodValue'] = 'KPI Value';
            var pageSize = component.get('v.paginationPageSize');
            for (var s = 0; s < pageSize; s++) {
                if (!filteredKPItransactions[s]) {
                    break;
                }
                paginatedFilteredKPItransactions.push(filteredKPItransactions[s]);
            }
        }
        component.set('v.msg', data.msg || (filteredKPItransactions.length ? '' : 'No results.'));
        component.set('v.KPIsCount', data.count);
        component.set('v.lastPageNum', lastPageNum);
        component.set('v.showResults', (filteredKPItransactions.length ? data.showResults : false));
        component.set('v.paginationArray', paginationArray);
        if (data.count !== 0) {
            component.set('v.KPItransactionsHeaders', headerMapping);
            component.set('v.KPItransactionsHeadersArray', KPItransactionsHeadersArray);
        }
        component.set('v.paginatedFilteredKPItransactions', paginatedFilteredKPItransactions);
        component.set('v.filteredKPItransactions', filteredKPItransactions);
    },
    submitKPITransaction: function(component, transaction) {
        if (!component.isValid()) {
            return;
        }
        var isEdit = component.get('v.editKpi');
        if (isEdit) {
            var action = component.get("c.editKpiTransactionsFavorite");
            transaction.Submitting = true;
            component.set('v.selectedKPITransactionsArray', component.get('v.selectedKPITransactionsArray'));
            var actionCallback = function(action, component) {
                var data = action.getReturnValue();
                if (data.status === '0') {
                    transaction.Submitted = true;
                } else {
                    transaction.Error = data.message;
                }
                delete transaction.Submitting;
                if (transaction.ReportId) {
                    transaction.Report = true;
                    transaction.kpiReportId = transaction.ReportId;
                } else {
                    delete transaction.Report;
                    delete transaction.kpiReportId;
                    delete transaction.ReportId;
                }
                if (transaction.Notification) {
                    transaction.kpiWantsNotification === 'true'
                } else {
                    transaction.kpiWantsNotification === 'false'
                }
                component.set('v.selectedKPITransactionsArray', component.get('v.selectedKPITransactionsArray'));
                this.fireSubmitEvent();
            }
            action.setParams({
                kpiTransactionFavouriteId: transaction.kpiTransactionFavouriteId,
                wantsNotification: transaction.Notification || false,
                reportId: transaction.ReportId || null
            });
            action.setCallback(this, actionCallback);
            $A.enqueueAction(action);
        } else {
            var action = component.get("c.addKpiTransactionsToFavorite");
            transaction.Submitting = true;
            component.set('v.selectedKPITransactionsArray', component.get('v.selectedKPITransactionsArray'));
            var actionCallback = function(action, component) {
                var data = action.getReturnValue();
                if (data.status === '0') {
                    transaction.Submitted = true;
                } else {
                    transaction.Error = data.message;
                }
                delete transaction.Submitting;
                component.set('v.selectedKPITransactionsArray', component.get('v.selectedKPITransactionsArray'));
                this.fireSubmitEvent();
            }
            action.setParams({
                transactions: JSON.stringify([{
                    kpiTransactionId: transaction.id,
                    shouldBeNotified: transaction.Notification || false,
                    reportId: transaction.ReportId || null
                }])
            });
            action.setCallback(this, actionCallback);
            $A.enqueueAction(action);
        }
    },
    fireSubmitEvent: function() {
        $A.get('e.c:OV_WizardSubmitEvent').fire();
    },
    mapFilterNames: function(item) {
        if ($A.util.isArray(item)) {
            var resultArr = [];
            for (var i in item) {
                if (item.hasOwnProperty(i)) {
                    resultArr.push(this.mapFilterNames(item[i]));
                }
            }
            return resultArr;
        }
        if ($A.util.isArray(item.Items)) {
            var resultArr = [];
            for (var i in item.Items) {
                if (item.Items.hasOwnProperty(i)) {
                    resultArr.push(this.mapFilterNames(item.Items[i]));
                }
            }
            return resultArr;
        }
        var resultObj = {
            Id: item.id,
            Name: item.name,
            Children: (item.children && item.children.length ? this.mapFilterNames(item.children) : [])
        };
        return resultObj;
    },
    getIdsList: function(item, flattenedFiltersDef) {
        var result = [item.Id];
        if (item.Children && item.Children.length) {
            for (var i in item.Children) {
                if (item.Children.hasOwnProperty(i)) {
                    result = result.concat(this.getIdsList(item.Children[i], flattenedFiltersDef));
                }
            }
        }
        flattenedFiltersDef[item.Id] = result;
        return result;
    },
    flattenFilters: function(component, filters, flattenedFiltersDef) {
        if (!component.isValid()) {
            return;
        }
        for (var i in filters) {
            if (filters.hasOwnProperty(i)) {
                this.getIdsList(filters[i], flattenedFiltersDef);
            }
        }
        return flattenedFiltersDef;
    },
    buildFiltersList: function(component) {
        if (!component.isValid()) {
            return;
        }
        var flattenedFiltersDef = component.get('v.flattenedFiltersDef');
        var selectedFilters = component.get('v.selectedFilters2');
        var filtersList = {};
        for (var i in selectedFilters) {
            if (selectedFilters.hasOwnProperty(i)) {
                var value = flattenedFiltersDef[i][selectedFilters[i].Id];
            }
            filtersList[i] = value;
        }
        return filtersList;
    },
    changePage: function(component, pageNum) {
        if (!component.isValid()) {
            return;
        }
        var filteredKPItransactions = component.get('v.filteredKPItransactions');
        var pageSize = component.get('v.paginationPageSize');
        var total = component.get('v.KPIsCount');
        var paginatedFilteredKPItransactions = [];
        var start = (pageNum - 1) * pageSize;
        var lastPageNum = Math.ceil(total / pageSize);
        var end = (start + pageSize < total) ? (start + pageSize) : (total - 1);
        for (var i = start; i < end; i++) {
            paginatedFilteredKPItransactions.push(filteredKPItransactions[i]);
        }
        var isLast = false;
        var isFirst = false;
        if (pageNum === lastPageNum) {
            isLast = true;
        }
        if (pageNum === 1) {
            isFirst = true;
        }
        component.set('v.isLastPage', isLast);
        component.set('v.isFirstPage', isFirst);
        component.set('v.paginationPageNum', pageNum);
        component.set('v.paginatedFilteredKPItransactions', paginatedFilteredKPItransactions);
    },
    clearData: function(component) {
        var kpiNames = component.get('v.kpiNames');
        for (var i in kpiNames) {
            if (kpiNames.hasOwnProperty(i) && kpiNames[i].Selected) {
                delete kpiNames[i].Selected;
            }
        }
        component.set('v.kpiNames', kpiNames);
        component.set('v.KPItransactionsHeaders', {});
        component.set('v.KPItransactionsHeadersArray', []);
        component.set('v.paginatedFilteredKPItransactions', []);
        component.set('v.filteredKPItransactions', []);
        component.set('v.selectedFilters', {});
        component.set('v.selectedFilters2', {});
        component.set('v.selectedFilterArray', []);
        component.set('v.paginationArray', []);
        component.set('v.paginationPageNum', 1);
        component.set('v.lastPageNum', 0);
        component.set('v.isFirstPage', true);
        component.set('v.isLastPage', false);
        component.set('v.selectedKPITransactions', {});
        component.set('v.selectedKPITransactionsArray', []);
    },
    handleError: function(msg, e) {
        $A.error(msg, e);
    }
})