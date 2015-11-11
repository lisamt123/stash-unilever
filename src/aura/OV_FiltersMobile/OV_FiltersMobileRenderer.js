({
	afterRender: function(component, helper) {
		var res = this.superAfterRender();

        if ($A.get('$Browser').isPhone == false) {
            $A.util.removeClass(
                document.querySelector(".center.oneCenterStage"),
                'center'
            );
        }

        return res;
	}
})