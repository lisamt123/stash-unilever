({
    render : function(cmp, helper) {
        helper.removeAppStyles();//work-around for the fact that the app's stylesheets are inserted while we want to use SLDS which are messed up by these std styles
        var ret = this.superRender();
        return ret;
    },
})