({
	doinit:function(component, event, helper) {
       
        var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var today = new Date();
        var d;
        var month;
        var list=[];
        for(var i = 6; i > 0; i -= 1) {
            /*this code will get current date and go back to last month date after subtracting i from current month*/
            d = new Date(today.getFullYear(), today.getMonth() - i, 1);
            /*this code is to get month from date*/
            month = monthNames[d.getMonth()];
            list[i-1]=month;  
             
         }
      component.set("v.months",list);
      component.set("v.CurrentMonth",list[0]);
      /*this code is to get last month or current billing month for very first time*/
         },
    
    //Method to change the month
    changeMonth:function(component, event, helper) {
        var x = document.getElementById("select-01").selectedIndex;
        var currentMonths=document.getElementsByTagName("option")[x].value;
        /* Following code sets year based on selected month */
        var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        var selectedindex=monthNames.indexOf(currentMonths);
        var currentindex=monthNames.indexOf(component.get("v.CurrentMonth"));
        document.getElementById(currentMonths).selected ="true";
        var selectedMonth=" ";
        var d = new Date();
        if(currentindex > selectedindex)
         {
            var year=d.getFullYear();
            selectedMonth=currentMonths+" "+year;
         }
         if(currentindex < selectedindex)
         {
            var year=d.getFullYear()-1;
            selectedMonth=currentMonths+" "+year;
         }
        var detailpage_event=$A.get("e.c:MB_ChangeMonth_Event");  
        detailpage_event.setParams({"month":selectedMonth,"pagename":component.get("v.pagename"),"selectedMonth":currentMonths}).fire();
        
    }
})