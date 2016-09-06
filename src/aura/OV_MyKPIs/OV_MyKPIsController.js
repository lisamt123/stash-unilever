({
    doInit: function(component, event, helper) {
        helper.getFavouriteKPITransactions(component);
    },
    deleteMyKPIElement: function(component, event, helper) {
        if (event.getParam('KPIElementId') !== undefined) {
            helper.deleteMyKPIElement(component, event.getParam('KPIElementId'));
        }
    },
    onWizardSubmit: function(component, event, helper) {
        helper.getFavouriteKPITransactions(component);
    },
    openWizard: function(component, event, helper) {
        $A.get('e.c:OV_WizardOpenModalEvent').fire();
    }
})