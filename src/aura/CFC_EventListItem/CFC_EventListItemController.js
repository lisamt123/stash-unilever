({
	getEventItemData : function(component, event, helper) {
        
		var imageBannerUrl=component.get("v.eventItem");
        var bannerImage = imageBannerUrl.Banner;
                
        var filterStyle = component.find("eventDescriptionId");
        $A.util.addClass(filterStyle, "fourLineEllipsis");
        
		var monthNames = [
          "Jan", "Feb", "Mar",
          "Apr", "May", "Jun", "Jul",
          "Aug", "Sep", "Oct",
          "Nov", "Dec"
        ];
        var date = new Date(imageBannerUrl.FromDate);
        var day = date.getDate();
        var monthIndex = date.getMonth();
        var year = date.getFullYear();
        component.set("v.FromDate",day+" "+monthNames[monthIndex]+" "+year);
        
        var date = new Date(imageBannerUrl.ToDate);
        var day = date.getDate();
        var monthIndex = date.getMonth();
        var year = date.getFullYear();
        component.set("v.ToDate",day+" "+monthNames[monthIndex]+" "+year);
          
        var sourceResult ="";
        if(bannerImage == null ||  typeof bannerImage === "undefined"){
          sourceResult=component.get("v.banner");
            
        }
        else{
            sourceResult=component.get("v.banner");
            var result = /<img[^>]+src="([^">]+)/g;                 
            sourceResult = result.exec(bannerImage); 
            if(sourceResult==null || typeof sourceResult === "undefined") {
                sourceResult = component.get("v.banner");
            } else { 
                bannerImage = sourceResult[1];
                sourceResult = bannerImage.replace(/amp;/g, ""); 
            }
            console.log('--------------'+imageBannerUrl.Banner__c);
            console.log('--------------'+sourceResult);            
        }
        component.set("v.eventBannerImage",sourceResult);
	},
    loadEventDetail: function(component, event, helper) {
		var eventDetail=component.get("v.eventItem");
        var selectEvent=$A.get("e.c:CFC_HandleEvent");
        selectEvent.setParams({"eventId":eventDetail.Id,"componentName":"Standard Page"}).fire();
    }
})