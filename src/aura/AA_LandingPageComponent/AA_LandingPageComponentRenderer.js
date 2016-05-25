({
	afterRender : function(component, helper){
        this.superAfterRender();
    },
    rerender : function(component, helper){
        this.superRerender();
        //helper.getAllData(component);

    },
    unrender: function(component, helper) {
        this.superUnrender();
    }
})