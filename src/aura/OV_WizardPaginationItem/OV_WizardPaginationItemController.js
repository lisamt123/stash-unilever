({
    doInit: function(component, event, helper) {
        if (!component.isValid()) {
            return;
        }
        var paginationPageNum = component.get('v.paginationPageNum');
        var pageNum = component.get('v.pageNum');
        component.set('v.itemClass', (paginationPageNum === pageNum ? ' active' : ''));
    },
    pageChange: function(component, event, helper) {
        if (!component.isValid()) {
            return;
        }
        var paginationPageNum = component.get('v.paginationPageNum');
        var pageNum = component.get('v.pageNum');
        component.set('v.itemClass', (paginationPageNum === pageNum ? ' active' : ''));
    }
})