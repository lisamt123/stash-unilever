function blockme() {
            $.blockUI({ message: '<h1><img src="{!URLFOR($Resource.AjaxLoaderGif)}" /> Proceed In progress...</h1>', css: {
                border: 'none',
                padding: '15px',
                backgroundColor: '#222',
                '-webkit-border-radius': '100px',
                '-moz-border-radius': '10px',
                opacity: .5,
                color: '#fff'
                } } );   
        }
        function dialogMessage(recordId){
            $(function() {
                            $( "#dialog-message" ).dialog({
                              modal: true,
                              buttons: {
                                Ok: function() {
                                  $( this ).dialog( "close" );
                                  blockme();
                                  window.location.href = '/'+recordId;
                                }
                              }
                            });
            });
        }

        function dialogConfirm(recordId){
            $(function() {
                $( "#dialog-confirm" ).dialog({
                                  modal: true,
                                  buttons: {
                                    "Copy Items": function() {
                                      $( this ).dialog( "close" );
                                       blockme();
                                       CloneSOWParent();
                                    },
                                    Cancel: function() {
                                      $( this ).dialog( "close" );
                                      window.location.href = '/'+recordId;
                                    }
                                  }
                                });
            });
        }

        function dialogNonCopy(recordId){
            $(function() {
                $( "#dialog-message-NoClone" ).dialog({
                    modal: true,
                    buttons: {
                    Ok: function() {
                        $( this ).dialog( "close" );
                        blockme();
                        window.location.href = '/'+recordId;
                    }
                    }
                });
            });
        }
