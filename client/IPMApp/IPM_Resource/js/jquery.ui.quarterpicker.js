
( function ( $ ) {

  var quarters = {
    Q1: { month: 3, date: 31 },
    Q2: { month: 6, date: 30 },
    Q3: { month: 9, date: 30 },
    Q4: { month: 12, date: 31 }
  };

  $.widget( 'ui.quarterpicker', {
    options: {
      quarterOffset: 0,
      yearsIntoPast: 10,
      buttonImage: null
    },
    // TODO: Allow users to set options after init.
    _setOption: function ( key, value ) {
      switch ( key ) {
        case 'quarterOffset':
          //
          break;
        case 'yearsIntoPast':
          //
          break;
      }
      $.Widget.prototype._setOption.apply( this, arguments );
    },
    // Create a new quarter picker for the element.
    _create: function () {

      var now = new Date();
      var self = this,
        o = self.options,
        el = self.element,
        rand = Math.random();
      now.setMonth( now.getMonth() + ( o.quarterOffset * 3 ) );

      // Create picker UI.
      this.picker = $( '<div></div>' ).addClass( 'ui-quarterpicker ui-widget ui-widget-content ui-helper-clearfix' ).appendTo( $( 'body' ) );

      // Create quarter selector.
      this.picker.html( '' )
        .append( '<div class="ui-quarterpicker-top">\
                    <input type="radio" id="Q1_' + rand + '" name="radio_' + rand + '" value="Q1" /><label for="Q1_' + rand + '">Q1</label>\
                    <input type="radio" id="Q2_' + rand + '" name="radio_' + rand + '" value="Q2" /><label for="Q2_' + rand + '">Q2</label>\
                    <input type="radio" id="Q3_' + rand + '" name="radio_' + rand + '" value="Q3" /><label for="Q3_' + rand + '">Q3</label>\
                    <input type="radio" id="Q4_' + rand + '" name="radio_' + rand + '" value="Q4" /><label for="Q4_' + rand + '">Q4</label>\
                  </div>' )
        .find( '.ui-quarterpicker-top' ).buttonset().bind( 'change.quarterpicker', function () { self._setDate(); });

      // Create year selector.
      var nowYear = now.getFullYear(),
        yearList = '';
      this.picker.prepend( '<div><select class="year"></select></div>' );
      while (nowYear < now.getFullYear() + o.yearsIntoPast) {
        yearList += '<option value="' + nowYear + '">' + nowYear + '</option>';
        nowYear++;
      }
      this.picker.find( 'select.year' ).html(yearList).bind( 'change.quarterpicker', function () { self._setDate(); });

      // Set current date in picker. Go back a year if the prior quarter was in last year (this is the first quarter).
      if ( this.element.val() === '' ) {
        var quarter = this.getLastQuarterEnd(now);
        this.picker.find( 'input:radio[value=' + quarter + ']' ).prop( 'checked', true ).button( 'refresh' );
        if (quarter === 'Q4') {
          this.picker.find( 'select.year' ).val(now.getFullYear() - 1);
        }
      } else {
        this.refresh( this.element.val() );
      }

      // Bind events and set initial state.
      this.element.addClass( 'ui-quarterpicker-el' )
        .attr( 'readonly', true )
        .bind( 'focus.quarterpicker', function (e) { self._closeOthers(); self.open(); e.stopPropagation(); })
        .bind( 'click.quarterpicker', function (e) { e.stopPropagation(); })
        .next( 'img.ui-quarterpicker-trigger' )
        .bind( 'click.quarterpicker', function (e) { self._closeOthers(); self.open(); e.stopPropagation(); });
      this.picker.bind( 'click.quarterpicker', function (e) { e.stopPropagation(); });
      $(document).bind( 'click.quarterpicker', function () { self.close(); })
        .undelegate( 'focus.quarterpicker' )
        .delegate( 'input:not(:ui-quarterpicker)', 'focus.quarterpicker', function() { $(":ui-quarterpicker").quarterpicker("close"); });
      this._setDate(true);
      this.picker.hide();
    },
    // Set the selected quarter in the text box.
    _setDate: function (isInitialSet) {
      var initialValue = this.element.val();
      if (isInitialSet && initialValue !== '') { 
        return;
      }
      var qtr = quarters[this.picker.find('input[type=radio]:checked').val()];
      if (!qtr) {
        return;
      }
      var year = this.picker.find('select.year').val();
      if (!year) {
        return;
      }

      var month = qtr.month < 12 ? '0' + qtr.month : qtr.month.toString();
      this.element.val(this.picker.find('input[type=radio]:checked').val() + ' ' + year);
      if ( initialValue !== this.element.val() ) {
        this.element.change();
      }
    },
    // Close the quarter picker.
    _closeOthers: function () {
      $( ':ui-quarterpicker' ).not( this.element ).quarterpicker( 'close' );
    },
    // Open the quarter picker.
    open: function () {
      this.picker.css({
        top: this.element.offset().top + this.element.outerHeight(),
        left: this.element.offset().left > ($(document).width() - this.picker.outerWidth()) ? 
          $(document).width() - this.picker.outerWidth() : 
          this.element.offset().left
      }).fadeIn('fast');
    },
    // Close the quarter picker.
    close: function () {
      this.picker.fadeOut( 'fast' );
    },
    // If a date is programmatically set in the textbox, set the quarter picker UI.
    refresh: function (dateString) {
      var date = new Date(dateString || this.element.val());
      if (this.picker.find( 'select.year option[value="' + date.getFullYear() + '"]' ).length !== 0) {
        this.picker.find( 'select.year' ).val( date.getFullYear());
      }
      var qtr = { month: date.getMonth() + 1, date: date.getDate() };
      for (var key in quarters) {
        if (quarters.hasOwnProperty(key) && quarters[key].month === qtr.month && quarters[key].date === qtr.date) {
          this.picker.find( 'input:radio[value=' + key + ']' ).prop( 'checked', true ).button( 'refresh' );
        }
      }
    },
    // Utility function to get last quarter given a date.
    getLastQuarterEnd: function (date) {
      var month = date.getMonth() + 1;
      if (month <= 3) {
        return 'Q4';
      }
      if (month <= 6) {
        return 'Q1';
      }
      if (month <= 9) {
        return 'Q2';
      }
      if (month <= 12) {
        return 'Q3';
      }
    },
    // Remove all quarter picker elements and return the textbox to its initial state.
    destroy: function () {
      this.element.unbind('.quarterpicker').removeAttr('readonly')
        .next('img.ui-quarterpicker-trigger').remove();
      this.picker.remove();
      $(document).unbind('.quarterpicker');
      $.Widget.prototype.destroy.call(this);
    }
  });

})( jQuery );