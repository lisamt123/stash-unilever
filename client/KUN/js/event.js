$(function () {	
	RefreshTickers();
});
	
	function  RefreshTickers()
	{
		 var eventval = [];
        var eventDates ={};
        
        eventval = $("#testid").children('input').each(function(){
            //alert(this.value);
        });
        var n= eventval.length;
        //alert(n);
        for(var i=0;i<n;i++)
        {
            //alert(eventval[i].value);
            var datevalue = eventval[i].value; 
            var d = new Date(datevalue);
            var str = $.datepicker.formatDate('mm/dd/yy', d);
            eventDates[ new Date( str )] = new Date( str );
        }   
           
        $('#my-calendar').datepicker({
            
            beforeShowDay: function( date ) {
                var highlight = eventDates[date];
                if( highlight ) {
                     return [true, "event", highlight];
                } else {
                     return [true, '', ''];
                } 
             },
             onSelect: function(dateText, inst) {               
                 var date = $(this).val();            
                 RefreshEvents(date ,date );
              },
              onChangeMonthYear: function( year, month, inst ){                              
                var firstDay = new Date(year, month, 1);
                var lastDay = new Date(year, month + 1, 0);
                firstDay =(firstDay .getMonth()) + '/' + firstDay .getDate() + '/' +  firstDay .getFullYear();
                lastDay =(lastDay .getMonth() ) + '/' + lastDay .getDate() + '/' +  lastDay .getFullYear();
                RefreshEvents(firstDay ,lastDay );                            
              } 
        });

		$(".panel-footer").empty();

		$("#demo3").bootstrapNews({
            newsPerPage: 5,
            autoplay: false
        });
		$("#demo4").bootstrapNews({
            newsPerPage: 1,
            autoplay: false
        });
		
		$("#demo5").bootstrapNews({
            newsPerPage: 1,
            autoplay: false        
        });
		
		$("#divActions").bootstrapNews({
            newsPerPage: 5,
            autoplay: false
        });
		
	}
	
	 function validateform() {
          
          var ctldropProcess = document.getElementById("Home:AskTheExpert:dropProcess");
          var ctldropSubProcess = document.getElementById("Home:AskTheExpert:dropSubProcess");
          var ctltxtQuestion     = document.getElementById("Home:AskTheExpert:txtQuestion");
          
            if(ctldropProcess.value == null )
           {
               alert("Process Name is mandatory, Please select the appropriate process name from list.");
               return false;
           }
         
           if(trim(ctldropProcess.value) == "" )
           {
               alert("Process Name is mandatory, Please select the appropriate process name from list.");
               return false;
           }
           if(trim(ctldropSubProcess.value) == "" )
           {
               alert("Sub Process Name is mandatory, Please select the appropriate process name from list.");
               return false;
           }
         
           if(trim(ctltxtQuestion.value) == "")
           {
               alert("Question is mandatory, Cannot be left blank.");
               return false;
           }
           else
                return true;
         
           }          