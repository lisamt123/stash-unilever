({
	rerender: function(component, helper) {
        //console.log('in ....');
		var res = this.superRerender();
        //debugger;
        //helper.renderIframe(component);
        return res;
	}
})