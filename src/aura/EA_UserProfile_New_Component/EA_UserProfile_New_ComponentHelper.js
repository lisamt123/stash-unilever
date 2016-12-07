({
    helperMethod : function(component , CP ,NewBee,Gold) {
        var result=((CP*100)/Gold);
        var result1= result +2;
        //alert(CP+'----'+NewBee+'---'+Gold);
        $('.progressbar').width(result1+'%');
        $('.Profile_Pic_Pints').width(result1+'%'); 
        if (result<5){
            $(".Profile_Pic_Pints").addClass("position");
            $('.progressbar').width('2%');
        }
        else{
            $(".Profile_Pic_Pints").removeClass("position");
            //document.getElementById("currentpoints").style.right = "0px";
        }
        if(result==0){
            $('.progressbar').width('0%');
        }
    }
    
})