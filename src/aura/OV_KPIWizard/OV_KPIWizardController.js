({
    doInit: function(component, event, helper) {
        helper.loadFilters(component);
        helper.loadKPIs(component);
        helper.getMyFavouritesReports(component);
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
    showWizard: function(component, event, helper) {
        component.set('v.editKpi', false);
/*        if (component.isValid() === true && component.isRendered() === false) {
            component.render();
        }*/
        if (!component.get('v.wizardDisplayed')) {
            component.set('v.wizardDisplayed', true);
        }
    },
    closeWizard: function(component, event, helper) {
        if (event.target.className.indexOf("modalBackdrop") < 0 && event.target.className.indexOf('closeModal') < 0) {
            return;
        }
        if (component.get('v.editKpi')) {
            selectedKPITransactionsArray = component.get('v.selectedKPITransactionsArray');
            if (selectedKPITransactionsArray[0]) {
                delete selectedKPITransactionsArray[0].Submitted;
            }
            component.set('v.selectedKPITransactionsArray', selectedKPITransactionsArray);
        }
        if (component.get('v.wizardDisplayed')) {
            component.set('v.step', 1);
            component.set('v.wizardDisplayed', false);
            helper.clearData(component);
            var resetEvent = $A.get('e.c:OV_WizardFilterSelectedEvent');
            resetEvent.setParams({
                reset: true
            });
            resetEvent.fire();
        }

        var favList = component.find('favList');
        if (favList) {
            if ($A.util.isArray(favList) === false) {
                favList = [favList];
            }
            for(var i = 0, len = favList.length; i < len; i++) {
                favList[i].unrender();
                favList[i].destroy(false);
            }
        }
/*        if (component.isValid() === true) {
            component.unrender();
        }*/
    },
    moveToStep1: function(component, event, helper) {
        component.set('v.step', 1);
        component.set('v.selectedKPI', {});
        helper.clearData(component);
        var resetEvent = $A.get('e.c:OV_WizardFilterSelectedEvent');
        resetEvent.setParams({
            reset: true
        });
        resetEvent.fire();
    },
    pickKPI: function(component, event, helper) {
        if (component.get('v.operationPending')) {
            return;
        }
        component.set('v.operationPending', true);

        var index                = parseInt(jQuery(event.target).closest('.KPIItem')[0].attributes.getNamedItem('data-index').value);
        var kpiNames             = component.get('v.kpiNames');
        kpiNames[index].Selected = true;
        var selectedKPI          = kpiNames[index];

        component.set('v.selectedCount', 0);
        component.set('v.kpiNames', kpiNames);
        component.set('v.selectedKPI', selectedKPI);
        component.set('v.selectedKPITransactions', {});
        setTimeout($A.getCallback(function() {
            component.set('v.step', 2);
            helper.getKPITransactions(component);
        }), 500);
    },
    moveToStep2: function(component, event, helper) {
        if (component.get('v.step') === 3) {
            component.set('v.step', 2);
        }
    },
    changePage: function(component, event, helper) {
        if (component.get('v.operationPending')) {
            return;
        }
        var pageNum = parseInt(jQuery(event.target).closest('.paginationItemWrapper')[0].attributes.getNamedItem('data-pagenum').value);
        helper.changePage(component, pageNum);
    },
    nextPage: function(component, event, helper) {
        if (component.get('v.operationPending')) {
            return;
        }
        var paginationPageNum = component.get('v.paginationPageNum');
        var lastPageNum = component.get('v.lastPageNum');
        if (paginationPageNum < lastPageNum) {
            paginationPageNum++;
            component.set('v.paginationPageNum', paginationPageNum);
            helper.changePage(component, paginationPageNum);
        }
    },
    prevPage: function(component, event, helper) {
        if (component.get('v.operationPending')) {
            return;
        }
        var paginationPageNum = component.get('v.paginationPageNum');
        if (paginationPageNum > 1) {
            paginationPageNum--;
            component.set('v.paginationPageNum', paginationPageNum);
            helper.changePage(component, paginationPageNum);
        }
    },
    selectFiltersLevel1: function(component, event, helper) {
        var filter1index = parseInt(event.target.attributes.getNamedItem('data-filter1Index').value);
        if (component.get('v.selectedFilterLevel1') === filter1index) {
            component.set('v.selectedFilterLevel1', -1);
            component.set("v.filtersExpandedLevel1", false);
        } else {
            component.set('v.selectedFilterLevel1', filter1index);
            component.set("v.filtersExpandedLevel1", true);
        }
    },
    onFilterSelection: function(component, event, helper) {
        if (event.getParam('reset')) {
            component.set('v.selectedFilters', {});
            component.set('v.selectedFilters2', {});
            component.set('v.selectedFilterArray', []);
            component.set('v.paginationArray', []);
            component.set('v.paginationPageNum', 1);
            component.set('v.lastPageNum', 0);
            component.set('v.isFirstPage', true);
            component.set('v.isLastPage', false);
            component.set('v.selectedKPITransactions', {});
            component.set('v.selectedFilterLevel1', -1);
            component.set("v.filtersExpandedLevel1", false);
        }
        if (component.get('v.step') !== 2) {
            return;
        }
        var paginationArray = [];
        component.set('v.paginationArray', paginationArray);
        component.set('v.paginationPageNum', 1);
        component.set('v.lastPageNum', 1);
        component.set('v.isFirstPage', true);
        component.set('v.isLastPage', true);
        component.set('v.selectedCount', 0);
        component.set('v.filteredKPItransactions', {});
        helper.getKPITransactions(component);
    },
    selectKPITransaction: function(component, event, helper) {
        var transactionId = jQuery(event.target).closest('tr')[0].attributes.getNamedItem('data-transactionId').value;
        var selectedKPITransactions = component.get('v.selectedKPITransactions');
        var filteredKPItransactions = component.get('v.filteredKPItransactions');
        var paginatedFilteredKPItransactions = component.get('v.paginatedFilteredKPItransactions');
        var selectedItem = null;
        var selectedKPITransactionsArray = component.get('v.selectedKPITransactionsArray');
        var getId = function(item) {
            return item.id;
        };
        for (var i in filteredKPItransactions) {
            if (filteredKPItransactions[i].id === transactionId) {
                if (filteredKPItransactions[i].Selected) {
                    delete filteredKPItransactions[i].Selected;
                    delete selectedKPITransactionsArray.splice(selectedKPITransactionsArray.map(getId).indexOf(transactionId), 1);
                } else {
                    selectedItem = filteredKPItransactions[i];
                    selectedKPITransactionsArray.push(filteredKPItransactions[i]);
                    filteredKPItransactions[i].Selected = true;
                }
            }
        }
        if (selectedKPITransactions[transactionId]) {
            delete selectedKPITransactions[transactionId];
        } else {
            selectedKPITransactions[transactionId] = selectedItem;
        }
        component.set('v.selectedKPITransactionsArray', selectedKPITransactionsArray);
        component.set('v.selectedCount', Object.keys(selectedKPITransactions).length);
        component.set('v.filteredKPItransactions', filteredKPItransactions);
        component.set('v.paginatedFilteredKPItransactions', paginatedFilteredKPItransactions);
    },
    moveToStep3: function(component, event, helper) {
        if (component.get('v.selectedKPITransactionsArray').length) {
            var body = component.find('modalBody');
            if($A.util.isArray(body.elements) && body.elements.length===1){
                body.elements[0].scrollTop =0;
            }
            component.set('v.step', 3);
        }
    },
    setNotificationForKpi: function(component, event, helper) {
        var selectedKPITransactions = component.get('v.selectedKPITransactions');
        var transactionId = jQuery(event.target).closest('.transactionItem')[0].attributes.getNamedItem('data-transactionId').value;
        var selectedKPITransactionsArray = component.get('v.selectedKPITransactionsArray');
        var index = selectedKPITransactionsArray.map(function(item) {
            return item.id
        }).indexOf(transactionId);
        if (selectedKPITransactions[transactionId].Submitted) {
            return;
        }
        if (selectedKPITransactions[transactionId].Notification) {
            delete selectedKPITransactions[transactionId].Notification;
            delete selectedKPITransactionsArray[index].Notification;
        } else {
            selectedKPITransactions[transactionId].Notification = true;
            selectedKPITransactionsArray[index].Notification = true;
        }
        component.set('v.selectedKPITransactions', selectedKPITransactions);
        component.set('v.selectedKPITransactionsArray', selectedKPITransactionsArray);
    },
    enableReportSelectionForKpiTransaction: function(component, event, helper) {
        var selectedKPITransactions = component.get('v.selectedKPITransactions');
        var transactionId = jQuery(event.target).closest('.transactionItem')[0].attributes.getNamedItem('data-transactionId').value;
        var selectedKPITransactionsArray = component.get('v.selectedKPITransactionsArray');
        var index = selectedKPITransactionsArray.map(function(item) {
            return item.id
        }).indexOf(transactionId);
        if (selectedKPITransactions[transactionId].Submitted) {
            return;
        }
        if (!selectedKPITransactions[transactionId].Report) {
            selectedKPITransactions[transactionId].Report = true;
            delete selectedKPITransactions[transactionId].ReportId;
            selectedKPITransactionsArray[index].Report = true;
            delete selectedKPITransactionsArray[index].ReportId;
        } else {
            delete selectedKPITransactions[transactionId].Report;
            delete selectedKPITransactions[transactionId].ReportId;
            delete selectedKPITransactionsArray[index].Report;
            delete selectedKPITransactionsArray[index].ReportId;
        }
        component.set('v.selectedKPITransactions', selectedKPITransactions);
        component.set('v.selectedKPITransactionsArray', selectedKPITransactionsArray);
    },
    selectReportForKpiTransaction: function(component, event, helper) {
        var selectedKPITransactions = component.get('v.selectedKPITransactions');
        var transactionId = jQuery(event.target).closest('.transactionItem')[0].attributes.getNamedItem('data-transactionId').value;
        var reportId = jQuery(event.target).closest('.favReport>div')[0].attributes.getNamedItem('data-reportId').value;
        var selectedKPITransactionsArray = component.get('v.selectedKPITransactionsArray');
        var index = selectedKPITransactionsArray.map(function(item) {
            return item.id
        }).indexOf(transactionId);
        if (selectedKPITransactions[transactionId].Submitted) {
            return;
        }
        if (!selectedKPITransactions[transactionId].ReportId || selectedKPITransactions[transactionId].ReportId !== reportId) {
            selectedKPITransactions[transactionId].ReportId = reportId;
        } else {
            delete selectedKPITransactions[transactionId].ReportId;
        }
        component.set('v.selectedKPITransactions', selectedKPITransactions);
        component.set('v.selectedKPITransactionsArray', selectedKPITransactionsArray);
        var resetEvent = $A.get('e.c:OV_WizardFavouriteReportSelectedEvent');
        resetEvent.setParams({
            reportId: reportId,
            transactionId: transactionId
        });
        resetEvent.fire();
    },
    removeKpi: function(component, event, helper) {
        var selectedKPITransactions = component.get('v.selectedKPITransactions');
        var transactionId = jQuery(event.target).closest('.transactionItem')[0].attributes.getNamedItem('data-transactionId').value;
        var selectedKPITransactionsArray = component.get('v.selectedKPITransactionsArray');
        var index = selectedKPITransactionsArray.map(function(item) {
            return item.id;
        }).indexOf(transactionId);
        if (selectedKPITransactions[transactionId].Notification) {
            delete selectedKPITransactions[transactionId].Notification;
            delete selectedKPITransactionsArray[index].Notification;
        }
        if (selectedKPITransactions[transactionId].Selected) {
            delete selectedKPITransactions[transactionId].Selected;
            delete selectedKPITransactionsArray[index].Selected;
        }
        delete selectedKPITransactions[transactionId];
        selectedKPITransactionsArray.splice(index, 1);
        component.set('v.selectedKPITransactions', selectedKPITransactions);
        component.set('v.selectedKPITransactionsArray', selectedKPITransactionsArray);
        if (!selectedKPITransactionsArray.length) {
            component.set('v.step', 2);
        }
    },
    submitKpi: function(component, event, helper) {
        var transactionId = jQuery(event.target).closest('.transactionItem')[0].attributes.getNamedItem('data-transactionId').value;
        var selectedKPITransactions = component.get('v.selectedKPITransactions');
        var transaction = selectedKPITransactions[transactionId];
        if (!transaction.Submitted && !transaction.Submitting && ((!!transaction.Report) ? (!!transaction.ReportId) : true)) {
            helper.submitKPITransaction(component, transaction);
        }
    },
    closeSubmitError: function(component, event, helper) {
        var transactionId = jQuery(event.target).closest('.transactionItem')[0].attributes.getNamedItem('data-transactionId').value;
        var selectedKPITransactions = component.get('v.selectedKPITransactions');
        var transaction = selectedKPITransactions[transactionId];
        if (transaction.Error) {
            delete transaction.Error;
        }
        component.set('v.selectedKPITransactionsArray', component.get('v.selectedKPITransactionsArray'));
    },
    openKpiEditModal: function(component, event, helper) {
        var kpiItem = event.getParam('kpiItem');
        if (kpiItem) {
            // if (component.isValid() === true && component.isRendered() === false) {
            //     component.render();
            // }
            // if (component.isValid() === true && component.getSuper().isRendered() === false) {
            //     component.getSuper().render();
            // }
            if (!kpiItem.ReportId && kpiItem.kpiReportId) {
                kpiItem.Report = true;
                kpiItem.ReportId = kpiItem.kpiReportId;
            }
            if (kpiItem.kpiWantsNotification === 'true') {
                kpiItem.Notification = true;
            }
            kpiItem.id = kpiItem.kpiTransactionId;
            helper.clearData(component);
            component.set('v.step', 3);
            component.set('v.selectedKPITransactionsArray', [kpiItem]);
            var kpisObject = {};
            kpisObject[kpiItem.id] = kpiItem;
            component.set('v.selectedKPITransactions', kpisObject);
            component.set('v.editKpi', true);
            component.set('v.wizardDisplayed', true);
        }
    },
    favUpdate: function(component, event, helper) {
        helper.getMyFavouritesReports(component);
    }
})