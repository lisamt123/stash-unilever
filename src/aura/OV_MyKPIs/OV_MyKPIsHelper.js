({
    loadData: function(component, filters) {
        this.getMyKPIElements(component, filters || {});
    },
    getFavouriteKPITransactions: function(component) {
        var actionCallback = function(action, component) {
            if (action.getState() === 'SUCCESS') {
                var returnValue = action.getReturnValue();
                if (returnValue.status !== '0') {
                    this.handleError(returnValue.message);
                }else{
                    component.set('v.mykpiElements', returnValue.data.kpis);
                }
            }
        };
        var action = component.get("c.getFavouriteKPITransactions");
        action.setCallback(this, actionCallback);
        $A.enqueueAction(action);
    },
    deleteMyKPIElement : function(component, kpiNameId, inCallback) {
        var action = component.get('c.deleteKpiTransactionFromFavorite');

        action.setParams({
            'transactionId' : kpiNameId
        });

        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = action.getReturnValue();
                var data = returnValue.data;
                if (returnValue.status !== '0') {
                    this.handleError(returnValue.message);
                }else{
                    this.getFavouriteKPITransactions(component);
                }
            }
        };

        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    handleError: function(msg, e) {
        $A.error(msg, e);
    }
})