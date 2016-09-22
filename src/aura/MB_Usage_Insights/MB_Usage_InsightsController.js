({
    doinit : function(component, event, helper) {
          setTimeout(function() {
            $A.run(function() {
                $('.Insights').slick({            
                    dots: true,
                    arrows: false,
                    infinite: false,
                });
            }); 
        });  
     /*code for horizontal graphs*/
     helper.helperMethod(component);
    }
})