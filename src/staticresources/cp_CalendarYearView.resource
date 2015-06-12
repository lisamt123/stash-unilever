
    function setCustomFunction() {
      setAdvancedFilters(null, null, null, null, null, null, null, null, null);
    } 

    $('#btn-clear-filter').click(function(e){
      setCustomFunction();
    });

    $('#btn-filter-apply').click(function(e) {
        $('#filter-dialog').dialog('close');
        $('#btn-clear-filter').show();

        var FieldName1 = $('#filter-set-1').find('.filter-field-name').val();
        var Operator1 = $('#filter-set-1').find('.filter-operator-type').val();
        var FieldValueDate1 = $('#filter-set-1').find('.real-date-value').val();
        var FieldValue1 = null;
        var FieldName2 = null;
        var Operator2 = null;
        var FieldValue2 = null;
        var FieldValueDate2 = null;
        var andOr = null;

        if($('#filter-set-1').find('.filter-field-value').css('display') != 'none') {
          FieldValue1 = $('#filter-set-1').find('.filter-field-value').val();
        }
        else if($('#filter-set-1').find('.select-filter-field-value').css('display') != 'none') {
          FieldValue1 = $('#filter-set-1').find('.select-filter-field-value').val();
        }

        if($('#filter-set-2').css('display') != 'none') {
          FieldName2 = $('#filter-set-2').find('.filter-field-name').val();
          Operator2 = $('#filter-set-2').find('.filter-operator-type').val();
          
          if($('#filter-set-2').find('.filter-field-value').css('display') != 'none') {
            FieldValue2 = $('#filter-set-2').find('.filter-field-value').val();
          }
          else if($('#filter-set-2').find('.select-filter-field-value').css('display') != 'none') {
            FieldValue2 = $('#filter-set-2').find('.select-filter-field-value').val();
          }

          if($('#and-or').find('label').attr('for') == 'option-and' && $('#and-or').find('label').attr('aria-pressed') == 'true')
            andOr = ' AND ';
          else
            andOr = ' OR ';

          FieldValueDate2 = $('#filter-set-1').find('.real-date-value').val();
        }

        var temp = "";
        if(Operator1 == 'includes' || Operator1 == 'excludes'){
          for(var i=0; i<FieldValue1.length; i++) {
            temp+=FieldValue1[i]+ ",";
          }
          FieldValue1 = temp;
        }
        
        setAdvancedFilters(FieldName1, Operator1, FieldValue1, FieldValueDate1, andOr, FieldName2, Operator2, FieldValue2, FieldValueDate2);
        
    });

    function bindCheckbox() {
      $('.filterCheckbox').click(function(e){
         setMarkets(this.getAttribute('data-type'), this.getAttribute('value'), this.checked);
      });
    }

    function StartEvent() {
        $('input').each(function(e) {
          $(this).attr('disabled', 'disabled');
        });
        $('select').each(function(e) {
          $(this).attr('disabled', 'disabled');
        });
    }
    function StopEvent() {
        $('input').each(function(e) {
          $(this).removeAttr('disabled');
        });
        $('select').each(function(e) {
          $(this).removeAttr('disabled');
        });
    }
    function runSearch(e) {
        if (e.keyCode == 13) {
            searchValue();
            return false;
        }
    }
