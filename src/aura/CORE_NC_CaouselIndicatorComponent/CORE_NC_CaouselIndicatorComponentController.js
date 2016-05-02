({
	sendCarouselIndex : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_NC_CaouselIndicatorEvent");
        selectEvent.setParams({"selectedCarousel": component.get("v.carouselIndex")}).fire();
	}
})