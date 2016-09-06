({
    setup: function(cmp) {
        var container = cmp.find('scroller').getElement();
        var self = this;

        container.addEventListener('mousedown', function(e) {
            console.warn('mousedown');
            e.preventDefault();
            e.stopPropagation();
            self.mouseDown(cmp, e);
        }, false);
        container.addEventListener('mousemove', function(e) {
            e.preventDefault();
            e.stopPropagation();
            self.mouseMove(cmp, e);
        }, false);
        container.addEventListener('mouseup', function(e) {
            console.warn('mouseup');
            e.preventDefault();
            e.stopPropagation();
            self.mouseUp(cmp, e);
        }, false);

        container.addEventListener('touchstart', function(e) {
            e.preventDefault();
            e.stopPropagation();
            self.touchStart(cmp, e);
        }, false);
        container.addEventListener('touchmove', function(e) {
            e.preventDefault();
            e.stopPropagation();
            self.touchMove(cmp, e);
        }, false);
        container.addEventListener('touchend', function(e) {
            e.preventDefault();
            e.stopPropagation();
            self.touchEnd(cmp, e);
        }, false);
        container.addEventListener('touchcancel', function(e) {
            e.preventDefault();
            e.stopPropagation();
            self.touchEnd(cmp, e);
        }, false);
    },

    mouseDown: function(cmp, e) {
        try {
            cmp.set('v.startX', e.clientX);
            cmp.set('v.isDragging', true);
        } catch (err) {
            console.warn(err);
        }
    },

    mouseMove: function(cmp, e) {
        try {
            var container = cmp.find('scroller').getElement();
            if (cmp.get('v.isDragging')) {
                var startLoc = cmp.get('v.startX');
                var delta = e.clientX - startLoc;
                cmp.set('v.offset', delta);
                $(container).css('transform', 'translateX(' + delta + 'px)');
            }
        } catch (err) {
            console.warn(err);
        }
    },

    mouseUp: function(cmp) {
        try {
            cmp.set('v.isDragging', false);
        } catch (err) {
            console.warn(err);
        }
    },

    touchStart: function(cmp, evt) {
        try {
            console.log('touching');
            console.log(evt);
            var e = evt.targetTouches[0];
            cmp.set('v.startX', e.clientX);
            cmp.set('v.isDragging', true);
        } catch (err) {
            console.warn(err);
        }
    },

    touchMove: function(cmp, evt) {
        try {
            var e = evt.targetTouches[0];
            var container = cmp.find('scroller').getElement();
            if (cmp.get('v.isDragging')) {
                var startLoc = cmp.get('v.startX');
                var delta = e.clientX - startLoc;
                cmp.set('v.offset', delta);
                $(container).css('transform', 'translateX(' + delta + 'px)');
            }
        } catch (err) {
            console.warn(err);
        }
    },

    touchEnd: function(cmp) {
        try {
            cmp.set('v.isDragging', false);
        } catch (err) {
            console.warn(err);
        }
    }
});