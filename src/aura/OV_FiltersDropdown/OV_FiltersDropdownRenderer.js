({
    afterRender: function(component, helper) {
        var res = this.superAfterRender();

        // this makes the content fullscreen and drops margins on left and right hand side
        if ($A.get('$Browser').isPhone === false) {
            $A.util.removeClass(
                document.querySelector(".center.oneCenterStage"),
                'center'
            );
        }

        return res;
    }
})