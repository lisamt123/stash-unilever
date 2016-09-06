({
    scrollLeft: function(cmp) {
        var leftButton            = cmp.find('kpiCarouselLeft').getElement();
        var rightButton           = cmp.find('kpiCarouselRight').getElement();
        var kpiCarouselArea       = cmp.find('kpiCarouselArea').getElement();
        var startValue            = kpiCarouselArea.offsetLeft;
        var test                  = startValue + 150;

        rightButton.style.display = 'block';

        if (test > 0){
            leftButton.style.display = 'none';
            test = 0;
        }
        var elemWidth = kpiCarouselArea.getBoundingClientRect().width - kpiCarouselArea.parentElement.getBoundingClientRect().width;
        if (test < -elemWidth) {
            test = -elemWidth;
        }

        kpiCarouselArea.style.left = test + 'px';
    },
    scrollRight: function(cmp) {
        var leftButton      = cmp.find('kpiCarouselLeft').getElement();
        var rightButton     = cmp.find('kpiCarouselRight').getElement();
        var kpiCarouselArea = cmp.find('kpiCarouselArea').getElement();
        var startValue      = kpiCarouselArea.offsetLeft;
        var test            = startValue - 150;

        leftButton.style.display = 'block';
        if (test > 0) {
            test = 0;
        }

        var elemWidth = kpiCarouselArea.getBoundingClientRect().width - kpiCarouselArea.parentElement.getBoundingClientRect().width;
        if (test < -elemWidth){
            rightButton.style.display = 'none';
            test = -elemWidth - 20;
        }

        kpiCarouselArea.style.left = test + 'px';
    }
})