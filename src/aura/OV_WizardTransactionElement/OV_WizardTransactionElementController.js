({
    doInit: function(component, event, helper) {
        var KPITransactionItem = component.get('v.KPITransactionItem');
        var KPItransactionsHeaders = component.get('v.KPItransactionsHeaders');
        var KPItransactionsHeadersArray = component.get('v.KPItransactionsHeadersArray');
        var KPITransactionItemMapped = {};
        for (var i in KPItransactionsHeaders) {
            KPITransactionItemMapped[KPItransactionsHeaders[i]] = KPITransactionItem[i];
        }
        var fields = [];
        for (var i in KPItransactionsHeadersArray) {
            if (KPItransactionsHeadersArray.hasOwnProperty(i)) {
                var floatVal = parseFloat(KPITransactionItemMapped[KPItransactionsHeadersArray[i]['displayName']]);
                var fieldVal = {
                    Name: KPItransactionsHeadersArray[i],
                    Value: KPITransactionItemMapped[KPItransactionsHeadersArray[i]['displayName']]
                }
                if (KPItransactionsHeadersArray[i]['displayName'].match(/value/gi)) {
                    fieldVal.Class = KPITransactionItem.kpiTransactionDirection + (KPITransactionItem.kpiTransactionDirection !== 'NO CHANGE' ? ((KPITransactionItem.kpiDirectionSentiment === 'UP_GOOD' && KPITransactionItem.kpiTransactionDirection === "DOWN") ? ' bad' : ' good') : '') + ' ' + ((KPITransactionItem.kpiTransactionDirection === "UP") ? 'arrowUp s1utility s1utility-up' : ((KPITransactionItem.kpiTransactionDirection === "DOWN") ? 'arrowDown s1utility s1utility-down' : 'arrowFlat s1utility s1utility-right'));
                    fieldVal.Value = ''+(KPITransactionItem.kpiTransactionValuePrefix?KPITransactionItem.kpiTransactionValuePrefix:'') +''+ (KPITransactionItem.kpiTransactionValue?KPITransactionItem.kpiTransactionValue:'') +''+ (KPITransactionItem.kpiTransactionValueSuffix?KPITransactionItem.kpiTransactionValueSuffix:'');
                }
                fields.push(fieldVal);
            }
        }
        component.set('v.itemFields', fields);
    }
})