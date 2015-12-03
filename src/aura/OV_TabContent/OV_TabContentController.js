({
    doInit : function(component, event, helper) {
    },
    doneRendering: function(component, event, helper) {
        var isPhoneOrTablet = ($A.get('$Browser.isPhone') || $A.get('$Browser.isAndroid') || $A.get('$Browser.isIOS'));
        var scroller        = document.getElementsByClassName('centerUiScroller');
        if (isPhoneOrTablet === true && scrollerFound.length > 0) {
            var dataAttributeValue = $A.util.getDataAttribute(scroller[0],'aura-rendered-by');
            if (dataAttributeValue) {
                var scrollerComponent = $A.getCmp(dataAttributeValue);
                if (scrollerComponent) {
                    scrollerComponent.getAttributeValueProvider()._scroller.resize();
                }
            }
        }
    },
    showPanel: function(cmp, e) {
        var i, item;
        var targetId = e.getParam('targetPanelId');
        // get all the panels
        var allPanels = (cmp.getElement()).getElementsByClassName('tab-pane');

        for (i = 0; i < allPanels.length; i++) {
            var panelid;
            item = allPanels[i];
            $A.util.removeClass(item, 'active');
            if (item.dataset && item.dataset.panelid) {
                panelid = item.dataset.panelid;
            } else {
                panelid = item.attributes.getNamedItem('data-panelid').nodeValue;
            }
            if (panelid === targetId) {
                $A.util.addClass(item, 'active');
            }
        }

        if (($A.get('$Browser.isPhone') || $A.get('$Browser.isAndroid') || $A.get('$Browser.isIOS')) === true ) {
            $A.getCmp($('div.centerUiScroller').data('aura-rendered-by')).$attributeValueProvider$._scroller.resize();
        }

        // not sure why it was here - probably because we needed to select correct tab on partent componenet ...
        $A.get("e.c:OV_TabClickEvent").setParams({'targetViewId': targetId}).fire();

        // refresh carousel. fix
        // this code doesn't appear to do anything in this context
        var carouselWidth;
        var elem         = document.getElementById('kpicarousel');
        var carouselArea = document.getElementsByClassName('kpiCarouselArea');
        var leftButton   = document.getElementsByClassName('carouselLeftButton');
        var rightButton  = document.getElementsByClassName('carouselRightButton');

        if (elem) {
            elem.style.left = 0;
        }

        if (carouselArea.length > 0) {
            carouselWidth = carouselArea[0].getBoundingClientRect().width;
        }

        if (leftButton.length > 0) {
            for (i = 0; i < leftButton.length; i++) {
                item               = leftButton[i];
                item.style.display = 'none';
            }
        }

        if (window.innerWidth < carouselWidth) {
            if (rightButton.length > 0) {
                for (i = 0; i < rightButton.length; i++) {
                    item               = rightButton[i];
                    item.style.display = 'block';
                }
            }
        } else {
            if (rightButton.length > 0) {
                for (i = 0; i < rightButton.length; i++) {
                    item               = rightButton[i];
                    item.style.display = 'none';
                }
            }
        }
    }
});