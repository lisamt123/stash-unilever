  function selectOrDeselectkAllBrowse(){
    var ch;
    var a = document.querySelectorAll(".browseMembersheaderStyle input[type=checkbox]");
    for (var i = 0; i < a.length; i++){
       ch = a[i].checked;
    }
    var aa = document.querySelectorAll(".memberRow input[type=checkbox]");
    for (var i = 0; i < aa.length; i++){
       aa[i].checked = ch;
    }
  }

  function selectOrDeselectkAll(){
    var ch;
    var a = document.querySelectorAll(".approveMembersheaderStyle input[type=checkbox]");
    for (var i = 0; i < a.length; i++){
       ch = a[i].checked;
    }
    var aa = document.querySelectorAll(".memberRequestRow input[type=checkbox]");
    for (var i = 0; i < aa.length; i++){
       aa[i].checked = ch;
    }
  }