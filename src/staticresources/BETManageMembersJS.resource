function updateRoleOnMember(memId, role, idx){
    var idid = 'memberpage:form:repeater:'+idx+':role';
    document.getElementById(idid).innerHTML = 'Processing ...';
    Visualforce.remoting.Manager.invokeAction(
      '{!$RemoteAction.BET_ManageMembersController.updateMemberRole}',
      memId,
      role,
      function(result, event){
        if (event.status) {
          document.getElementById(idid).innerHTML = role;
        }
      },
      {escape: true}
    );
  }

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