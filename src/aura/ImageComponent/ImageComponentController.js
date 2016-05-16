({
    getUsersPics : function(component, event, helper) {
         var photos=component.get("v.recentUsers");
               
               if(photos.length !== undefined && photos.length !== 0)
                {
                    component.set("v.showrecentUsers",true);
                }
              else if(photos.length ===undefined || photos.length === 0){
                component.set("v.showmessage",true);
              }
        },
})