({
    rerender : function(component, helper) {
        var res = this.superRerender();

        if (component.get('v.renderIframe') === true){
            var iframe = $('iframe', component.getElement());
            if (iframe.length === 1) {
                iframe.height($(component.getElement()).height() - 50);
                iframe.width($(component.getElement()).width() - 5);

                $('.scroller', '.oneContent div.centerUiScroller.uiScroller.scroller-wrapper.scroll-vertical').on('wheel DOMMouseScroll mousewheel wheel touchmove dragstart mousedown movusemove mousedown', function(e) {
                    e.stopPropagation();
                }).removeAttr('style');
            }
        }
        return res;
    },

    afterRender: function(component, helper) {
        var res = this.superAfterRender();
        jQuery(component.getElement()).height(
            jQuery('.active.oneContent').height()
        );

        if (component.get('v.renderIframe') === true) {
            component.set('v.renderIframe', false);
            // trigger rerender
            component.set('v.renderIframe', true);
        }

        return res;
    }
})