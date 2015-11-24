<!-- Created by Asmae ESSBAI For the ViewProject page -->

   $(document).ready(function(){
         
        $('tr.data, tr.btt').show().find('td').wrapInner('<div />');
        $('tr.data, tr.btt').find('td > div').hide();

        $('table tr.Oblix_heading').click(function(){
            var data = $(this).next('tr');
            var btt = data.next('tr');
            data.find('td > div').slideToggle('slow');
            btt.find('td > div').slideToggle('slow');
            $(this).toggleClass('show');
        });

         $('table tr.Oblix_recordTypeth.styleTH2').click(function(){
            var data = $(this).next('tr');
            var that = this;
            $('table tr.Oblix_recordTypeth.styleTH2').each(function(){
              if($(this).hasClass('show') && that !== this){
                $(this).next('tr').find('td > div').slideToggle('slow');
                $(this).toggleClass('show');
              }
            })
            data.find('td > div').slideToggle('slow');
            $(this).toggleClass('show');
        });

         
         $('table tr.Oblix_recordTypeth.styleTH1').click(function(){
            var data = $(this).next('tr');
            var that = this;
            $('table tr.Oblix_recordTypeth.styleTH1').each(function(){
              if($(this).hasClass('show') && that !== this){
                $(this).next('tr').find('td > div').slideToggle('slow');
                $(this).toggleClass('show');
              }
            })
            data.find('td > div').slideToggle('slow');
            $(this).toggleClass('show');
            $(this).next('tr').find('.styleTH2').next('tr').find('td > div').slideUp(0);
        });
        
   });
   
    function Popup(){
             $("#dialog").dialog({
             width: 600,
             modal:true,
             close: function(event,ui){
                 $("pop").dialog('destroy');          
                    }
             }); 
            
     }