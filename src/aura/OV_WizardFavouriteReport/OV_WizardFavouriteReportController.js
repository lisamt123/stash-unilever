({
    doInit: function(component, event, helper) {
        component.set('v.cssClass', 'indicator' + (component.get('v.report.reportId') == component.get('v.kpiTransaction.ReportId') ? ' s1utility s1utility-check' : ''));
    },
    onFavChange: function(component, event, helper) {
        var params = event.getParams();
        var kpiTransaction = component.get('v.kpiTransaction');
        var transactionId;
        if(kpiTransaction.kpiTransactionId){
        	transactionId = kpiTransaction.kpiTransactionId;
        }else{
        	transactionId = kpiTransaction.id;
        }
        if (params.transactionId === transactionId) {
            if (params.reportId === component.get('v.report.reportId')) {
                if (component.get('v.cssClass') === 'indicator s1utility s1utility-check') {
                    component.set('v.cssClass', 'indicator');
                } else {
                    component.set('v.cssClass', 'indicator s1utility s1utility-check');
                }
            } else {
                component.set('v.cssClass', 'indicator');
            }
        }
    }
})