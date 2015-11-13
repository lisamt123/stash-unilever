({
     doInit : function(component, event, helper) {
        $A.logger.subscribe('INFO',     helper.logCustom);
        $A.logger.subscribe('WARNING',  helper.logCustom);
        $A.logger.subscribe('ASSERT',   helper.logCustom);
        $A.logger.subscribe('ERROR',    helper.logCustom);
        $A.log('Logging configured and listening: ', component.getGlobalId());
    },

    handleDestroy: function(component, event, helper) {
        $A.log('Logging disabled: ', component.getGlobalId());
        $A.logger.unsubscribe('INFO',     helper.logCustom);
        $A.logger.unsubscribe('WARNING',  helper.logCustom);
        $A.logger.unsubscribe('ASSERT',   helper.logCustom);
        $A.logger.unsubscribe('ERROR',    helper.logCustom);
    }
})