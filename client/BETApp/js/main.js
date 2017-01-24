/*!
 * Bootstrap v3.3.1 (http://getbootstrap.com)
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 */

/*!
 * Generated using the Bootstrap Customizer (http://getbootstrap.com/customize/?id=6f47536177f4af36ce5b)
 * Config saved to config.json and https://gist.github.com/6f47536177f4af36ce5b
 */
if (typeof jQuery === 'undefined') {
  throw new Error('Bootstrap\'s JavaScript requires jQuery')
}
+function ($) {
  var version = $.fn.jquery.split(' ')[0].split('.')
  if ((version[0] < 2 && version[1] < 9) || (version[0] == 1 && version[1] == 9 && version[2] < 1)) {
    throw new Error('Bootstrap\'s JavaScript requires jQuery version 1.9.1 or higher')
  }
}(jQuery);

/* ========================================================================
 * Bootstrap: alert.js v3.3.1
 * http://getbootstrap.com/javascript/#alerts
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // ALERT CLASS DEFINITION
  // ======================

  var dismiss = '[data-dismiss="alert"]'
  var Alert   = function (el) {
    $(el).on('click', dismiss, this.close)
  }

  Alert.VERSION = '3.3.1'

  Alert.TRANSITION_DURATION = 150

  Alert.prototype.close = function (e) {
    var $this    = $(this)
    var selector = $this.attr('data-target')

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') // strip for ie7
    }

    var $parent = $(selector)

    if (e) e.preventDefault()

    if (!$parent.length) {
      $parent = $this.closest('.alert')
    }

    $parent.trigger(e = $.Event('close.bs.alert'))

    if (e.isDefaultPrevented()) return

    $parent.removeClass('in')

    function removeElement() {
      // detach from parent, fire event then clean up data
      $parent.detach().trigger('closed.bs.alert').remove()
    }

    $.support.transition && $parent.hasClass('fade') ?
      $parent
        .one('bsTransitionEnd', removeElement)
        .emulateTransitionEnd(Alert.TRANSITION_DURATION) :
      removeElement()
  }


  // ALERT PLUGIN DEFINITION
  // =======================

  function Plugin(option) {
    return this.each(function () {
      var $this = $(this)
      var data  = $this.data('bs.alert')

      if (!data) $this.data('bs.alert', (data = new Alert(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

  var old = $.fn.alert

  $.fn.alert             = Plugin
  $.fn.alert.Constructor = Alert


  // ALERT NO CONFLICT
  // =================

  $.fn.alert.noConflict = function () {
    $.fn.alert = old
    return this
  }


  // ALERT DATA-API
  // ==============

  $(document).on('click.bs.alert.data-api', dismiss, Alert.prototype.close)

}(jQuery);

/* ========================================================================
 * Bootstrap: button.js v3.3.1
 * http://getbootstrap.com/javascript/#buttons
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // BUTTON PUBLIC CLASS DEFINITION
  // ==============================

  var Button = function (element, options) {
    this.$element  = $(element)
    this.options   = $.extend({}, Button.DEFAULTS, options)
    this.isLoading = false
  }

  Button.VERSION  = '3.3.1'

  Button.DEFAULTS = {
    loadingText: 'loading...'
  }

  Button.prototype.setState = function (state) {
    var d    = 'disabled'
    var $el  = this.$element
    var val  = $el.is('input') ? 'val' : 'html'
    var data = $el.data()

    state = state + 'Text'

    if (data.resetText == null) $el.data('resetText', $el[val]())

    // push to event loop to allow forms to submit
    setTimeout($.proxy(function () {
      $el[val](data[state] == null ? this.options[state] : data[state])

      if (state == 'loadingText') {
        this.isLoading = true
        $el.addClass(d).attr(d, d)
      } else if (this.isLoading) {
        this.isLoading = false
        $el.removeClass(d).removeAttr(d)
      }
    }, this), 0)
  }

  Button.prototype.toggle = function () {
    var changed = true
    var $parent = this.$element.closest('[data-toggle="buttons"]')

    if ($parent.length) {
      var $input = this.$element.find('input')
      if ($input.prop('type') == 'radio') {
        if ($input.prop('checked') && this.$element.hasClass('active')) changed = false
        else $parent.find('.active').removeClass('active')
      }
      if (changed) $input.prop('checked', !this.$element.hasClass('active')).trigger('change')
    } else {
      this.$element.attr('aria-pressed', !this.$element.hasClass('active'))
    }

    if (changed) this.$element.toggleClass('active')
  }


  // BUTTON PLUGIN DEFINITION
  // ========================

  function Plugin(option) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.button')
      var options = typeof option == 'object' && option

      if (!data) $this.data('bs.button', (data = new Button(this, options)))

      if (option == 'toggle') data.toggle()
      else if (option) data.setState(option)
    })
  }

  var old = $.fn.button

  $.fn.button             = Plugin
  $.fn.button.Constructor = Button


  // BUTTON NO CONFLICT
  // ==================

  $.fn.button.noConflict = function () {
    $.fn.button = old
    return this
  }


  // BUTTON DATA-API
  // ===============

  $(document)
    .on('click.bs.button.data-api', '[data-toggle^="button"]', function (e) {
      var $btn = $(e.target)
      if (!$btn.hasClass('btn')) $btn = $btn.closest('.btn')
      Plugin.call($btn, 'toggle')
      e.preventDefault()
    })
    .on('focus.bs.button.data-api blur.bs.button.data-api', '[data-toggle^="button"]', function (e) {
      $(e.target).closest('.btn').toggleClass('focus', /^focus(in)?$/.test(e.type))
    })

}(jQuery);

/* ========================================================================
 * Bootstrap: carousel.js v3.3.1
 * http://getbootstrap.com/javascript/#carousel
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // CAROUSEL CLASS DEFINITION
  // =========================

  var Carousel = function (element, options) {
    this.$element    = $(element)
    this.$indicators = this.$element.find('.carousel-indicators')
    this.options     = options
    this.paused      =
    this.sliding     =
    this.interval    =
    this.$active     =
    this.$items      = null

    this.options.keyboard && this.$element.on('keydown.bs.carousel', $.proxy(this.keydown, this))

    this.options.pause == 'hover' && !('ontouchstart' in document.documentElement) && this.$element
      .on('mouseenter.bs.carousel', $.proxy(this.pause, this))
      .on('mouseleave.bs.carousel', $.proxy(this.cycle, this))
  }

  Carousel.VERSION  = '3.3.1'

  Carousel.TRANSITION_DURATION = 600

  Carousel.DEFAULTS = {
    interval: 5000,
    pause: 'hover',
    wrap: true,
    keyboard: true
  }

  Carousel.prototype.keydown = function (e) {
    if (/input|textarea/i.test(e.target.tagName)) return
    switch (e.which) {
      case 37: this.prev(); break
      case 39: this.next(); break
      default: return
    }

    e.preventDefault()
  }

  Carousel.prototype.cycle = function (e) {
    e || (this.paused = false)

    this.interval && clearInterval(this.interval)

    this.options.interval
      && !this.paused
      && (this.interval = setInterval($.proxy(this.next, this), this.options.interval))

    return this
  }

  Carousel.prototype.getItemIndex = function (item) {
    this.$items = item.parent().children('.item')
    return this.$items.index(item || this.$active)
  }

  Carousel.prototype.getItemForDirection = function (direction, active) {
    var delta = direction == 'prev' ? -1 : 1
    var activeIndex = this.getItemIndex(active)
    var itemIndex = (activeIndex + delta) % this.$items.length
    return this.$items.eq(itemIndex)
  }

  Carousel.prototype.to = function (pos) {
    var that        = this
    var activeIndex = this.getItemIndex(this.$active = this.$element.find('.item.active'))

    if (pos > (this.$items.length - 1) || pos < 0) return

    if (this.sliding)       return this.$element.one('slid.bs.carousel', function () { that.to(pos) }) // yes, "slid"
    if (activeIndex == pos) return this.pause().cycle()

    return this.slide(pos > activeIndex ? 'next' : 'prev', this.$items.eq(pos))
  }

  Carousel.prototype.pause = function (e) {
    e || (this.paused = true)

    if (this.$element.find('.next, .prev').length && $.support.transition) {
      this.$element.trigger($.support.transition.end)
      this.cycle(true)
    }

    this.interval = clearInterval(this.interval)

    return this
  }

  Carousel.prototype.next = function () {
    if (this.sliding) return
    return this.slide('next')
  }

  Carousel.prototype.prev = function () {
    if (this.sliding) return
    return this.slide('prev')
  }

  Carousel.prototype.slide = function (type, next) {
    var $active   = this.$element.find('.item.active')
    var $next     = next || this.getItemForDirection(type, $active)
    var isCycling = this.interval
    var direction = type == 'next' ? 'left' : 'right'
    var fallback  = type == 'next' ? 'first' : 'last'
    var that      = this

    if (!$next.length) {
      if (!this.options.wrap) return
      $next = this.$element.find('.item')[fallback]()
    }

    if ($next.hasClass('active')) return (this.sliding = false)

    var relatedTarget = $next[0]
    var slideEvent = $.Event('slide.bs.carousel', {
      relatedTarget: relatedTarget,
      direction: direction
    })
    this.$element.trigger(slideEvent)
    if (slideEvent.isDefaultPrevented()) return

    this.sliding = true

    isCycling && this.pause()

    if (this.$indicators.length) {
      this.$indicators.find('.active').removeClass('active')
      var $nextIndicator = $(this.$indicators.children()[this.getItemIndex($next)])
      $nextIndicator && $nextIndicator.addClass('active')
    }

    var slidEvent = $.Event('slid.bs.carousel', { relatedTarget: relatedTarget, direction: direction }) // yes, "slid"
    if ($.support.transition && this.$element.hasClass('slide')) {
      $next.addClass(type)
      $next[0].offsetWidth // force reflow
      $active.addClass(direction)
      $next.addClass(direction)
      $active
        .one('bsTransitionEnd', function () {
          $next.removeClass([type, direction].join(' ')).addClass('active')
          $active.removeClass(['active', direction].join(' '))
          that.sliding = false
          setTimeout(function () {
            that.$element.trigger(slidEvent)
          }, 0)
        })
        .emulateTransitionEnd(Carousel.TRANSITION_DURATION)
    } else {
      $active.removeClass('active')
      $next.addClass('active')
      this.sliding = false
      this.$element.trigger(slidEvent)
    }

    isCycling && this.cycle()

    return this
  }


  // CAROUSEL PLUGIN DEFINITION
  // ==========================

  function Plugin(option) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.carousel')
      var options = $.extend({}, Carousel.DEFAULTS, $this.data(), typeof option == 'object' && option)
      var action  = typeof option == 'string' ? option : options.slide

      if (!data) $this.data('bs.carousel', (data = new Carousel(this, options)))
      if (typeof option == 'number') data.to(option)
      else if (action) data[action]()
      else if (options.interval) data.pause().cycle()
    })
  }

  var old = $.fn.carousel

  $.fn.carousel             = Plugin
  $.fn.carousel.Constructor = Carousel


  // CAROUSEL NO CONFLICT
  // ====================

  $.fn.carousel.noConflict = function () {
    $.fn.carousel = old
    return this
  }


  // CAROUSEL DATA-API
  // =================

  var clickHandler = function (e) {
    var href
    var $this   = $(this)
    var $target = $($this.attr('data-target') || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')) // strip for ie7
    if (!$target.hasClass('carousel')) return
    var options = $.extend({}, $target.data(), $this.data())
    var slideIndex = $this.attr('data-slide-to')
    if (slideIndex) options.interval = false

    Plugin.call($target, options)

    if (slideIndex) {
      $target.data('bs.carousel').to(slideIndex)
    }

    e.preventDefault()
  }

  $(document)
    .on('click.bs.carousel.data-api', '[data-slide]', clickHandler)
    .on('click.bs.carousel.data-api', '[data-slide-to]', clickHandler)

  $(window).on('load', function () {
    $('[data-ride="carousel"]').each(function () {
      var $carousel = $(this)
      Plugin.call($carousel, $carousel.data())
    })
  })

}(jQuery);

/* ========================================================================
 * Bootstrap: dropdown.js v3.3.1
 * http://getbootstrap.com/javascript/#dropdowns
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // DROPDOWN CLASS DEFINITION
  // =========================

  var backdrop = '.dropdown-backdrop'
  var toggle   = '[data-toggle="dropdown"]'
  var Dropdown = function (element) {
    $(element).on('click.bs.dropdown', this.toggle)
  }

  Dropdown.VERSION = '3.3.1'

  Dropdown.prototype.toggle = function (e) {
    var $this = $(this)

    if ($this.is('.disabled, :disabled')) return

    var $parent  = getParent($this)
    var isActive = $parent.hasClass('open')

    clearMenus()

    if (!isActive) {
      if ('ontouchstart' in document.documentElement && !$parent.closest('.navbar-nav').length) {
        // if mobile we use a backdrop because click events don't delegate
        $('<div class="dropdown-backdrop"/>').insertAfter($(this)).on('click', clearMenus)
      }

      var relatedTarget = { relatedTarget: this }
      $parent.trigger(e = $.Event('show.bs.dropdown', relatedTarget))

      if (e.isDefaultPrevented()) return

      $this
        .trigger('focus')
        .attr('aria-expanded', 'true')

      $parent
        .toggleClass('open')
        .trigger('shown.bs.dropdown', relatedTarget)
    }

    return false
  }

  Dropdown.prototype.keydown = function (e) {
    if (!/(38|40|27|32)/.test(e.which) || /input|textarea/i.test(e.target.tagName)) return

    var $this = $(this)

    e.preventDefault()
    e.stopPropagation()

    if ($this.is('.disabled, :disabled')) return

    var $parent  = getParent($this)
    var isActive = $parent.hasClass('open')

    if ((!isActive && e.which != 27) || (isActive && e.which == 27)) {
      if (e.which == 27) $parent.find(toggle).trigger('focus')
      return $this.trigger('click')
    }

    var desc = ' li:not(.divider):visible a'
    var $items = $parent.find('[role="menu"]' + desc + ', [role="listbox"]' + desc)

    if (!$items.length) return

    var index = $items.index(e.target)

    if (e.which == 38 && index > 0)                 index--                        // up
    if (e.which == 40 && index < $items.length - 1) index++                        // down
    if (!~index)                                      index = 0

    $items.eq(index).trigger('focus')
  }

  function clearMenus(e) {
    if (e && e.which === 3) return
    $(backdrop).remove()
    $(toggle).each(function () {
      var $this         = $(this)
      var $parent       = getParent($this)
      var relatedTarget = { relatedTarget: this }

      if (!$parent.hasClass('open')) return

      $parent.trigger(e = $.Event('hide.bs.dropdown', relatedTarget))

      if (e.isDefaultPrevented()) return

      $this.attr('aria-expanded', 'false')
      $parent.removeClass('open').trigger('hidden.bs.dropdown', relatedTarget)
    })
  }

  function getParent($this) {
    var selector = $this.attr('data-target')

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && /#[A-Za-z]/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, '') // strip for ie7
    }

    var $parent = selector && $(selector)

    return $parent && $parent.length ? $parent : $this.parent()
  }


  // DROPDOWN PLUGIN DEFINITION
  // ==========================

  function Plugin(option) {
    return this.each(function () {
      var $this = $(this)
      var data  = $this.data('bs.dropdown')

      if (!data) $this.data('bs.dropdown', (data = new Dropdown(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

  var old = $.fn.dropdown

  $.fn.dropdown             = Plugin
  $.fn.dropdown.Constructor = Dropdown


  // DROPDOWN NO CONFLICT
  // ====================

  $.fn.dropdown.noConflict = function () {
    $.fn.dropdown = old
    return this
  }


  // APPLY TO STANDARD DROPDOWN ELEMENTS
  // ===================================

  $(document)
    .on('click.bs.dropdown.data-api', clearMenus)
    .on('click.bs.dropdown.data-api', '.dropdown form', function (e) { e.stopPropagation() })
    .on('click.bs.dropdown.data-api', toggle, Dropdown.prototype.toggle)
    .on('keydown.bs.dropdown.data-api', toggle, Dropdown.prototype.keydown)
    .on('keydown.bs.dropdown.data-api', '[role="menu"]', Dropdown.prototype.keydown)
    .on('keydown.bs.dropdown.data-api', '[role="listbox"]', Dropdown.prototype.keydown)

}(jQuery);

/* ========================================================================
 * Bootstrap: modal.js v3.3.1
 * http://getbootstrap.com/javascript/#modals
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // MODAL CLASS DEFINITION
  // ======================

  var Modal = function (element, options) {
    this.options        = options
    this.$body          = $(document.body)
    this.$element       = $(element)
    this.$backdrop      =
    this.isShown        = null
    this.scrollbarWidth = 0

    if (this.options.remote) {
      this.$element
        .find('.modal-content')
        .load(this.options.remote, $.proxy(function () {
          this.$element.trigger('loaded.bs.modal')
        }, this))
    }
  }

  Modal.VERSION  = '3.3.1'

  Modal.TRANSITION_DURATION = 300
  Modal.BACKDROP_TRANSITION_DURATION = 150

  Modal.DEFAULTS = {
    backdrop: true,
    keyboard: true,
    show: true
  }

  Modal.prototype.toggle = function (_relatedTarget) {
    return this.isShown ? this.hide() : this.show(_relatedTarget)
  }

  Modal.prototype.show = function (_relatedTarget) {
    var that = this
    var e    = $.Event('show.bs.modal', { relatedTarget: _relatedTarget })

    this.$element.trigger(e)

    if (this.isShown || e.isDefaultPrevented()) return

    this.isShown = true

    this.checkScrollbar()
    this.setScrollbar()
    this.$body.addClass('modal-open')

    this.escape()
    this.resize()

    this.$element.on('click.dismiss.bs.modal', '[data-dismiss="modal"]', $.proxy(this.hide, this))

    this.backdrop(function () {
      var transition = $.support.transition && that.$element.hasClass('fade')

      if (!that.$element.parent().length) {
        that.$element.appendTo(that.$body) // don't move modals dom position
      }

      that.$element
        .show()
        .scrollTop(0)

      if (that.options.backdrop) that.adjustBackdrop()
      that.adjustDialog()

      if (transition) {
        that.$element[0].offsetWidth // force reflow
      }

      that.$element
        .addClass('in')
        .attr('aria-hidden', false)

      that.enforceFocus()

      var e = $.Event('shown.bs.modal', { relatedTarget: _relatedTarget })

      transition ?
        that.$element.find('.modal-dialog') // wait for modal to slide in
          .one('bsTransitionEnd', function () {
            that.$element.trigger('focus').trigger(e)
          })
          .emulateTransitionEnd(Modal.TRANSITION_DURATION) :
        that.$element.trigger('focus').trigger(e)
    })
  }

  Modal.prototype.hide = function (e) {
    if (e) e.preventDefault()

    e = $.Event('hide.bs.modal')

    this.$element.trigger(e)

    if (!this.isShown || e.isDefaultPrevented()) return

    this.isShown = false

    this.escape()
    this.resize()

    $(document).off('focusin.bs.modal')

    this.$element
      .removeClass('in')
      .attr('aria-hidden', true)
      .off('click.dismiss.bs.modal')

    $.support.transition && this.$element.hasClass('fade') ?
      this.$element
        .one('bsTransitionEnd', $.proxy(this.hideModal, this))
        .emulateTransitionEnd(Modal.TRANSITION_DURATION) :
      this.hideModal()
  }

  Modal.prototype.enforceFocus = function () {
    $(document)
      .off('focusin.bs.modal') // guard against infinite focus loop
      .on('focusin.bs.modal', $.proxy(function (e) {
        if (this.$element[0] !== e.target && !this.$element.has(e.target).length) {
          this.$element.trigger('focus')
        }
      }, this))
  }

  Modal.prototype.escape = function () {
    if (this.isShown && this.options.keyboard) {
      this.$element.on('keydown.dismiss.bs.modal', $.proxy(function (e) {
        e.which == 27 && this.hide()
      }, this))
    } else if (!this.isShown) {
      this.$element.off('keydown.dismiss.bs.modal')
    }
  }

  Modal.prototype.resize = function () {
    if (this.isShown) {
      $(window).on('resize.bs.modal', $.proxy(this.handleUpdate, this))
    } else {
      $(window).off('resize.bs.modal')
    }
  }

  Modal.prototype.hideModal = function () {
    var that = this
    this.$element.hide()
    this.backdrop(function () {
      that.$body.removeClass('modal-open')
      that.resetAdjustments()
      that.resetScrollbar()
      that.$element.trigger('hidden.bs.modal')
    })
  }

  Modal.prototype.removeBackdrop = function () {
    this.$backdrop && this.$backdrop.remove()
    this.$backdrop = null
  }

  Modal.prototype.backdrop = function (callback) {
    var that = this
    var animate = this.$element.hasClass('fade') ? 'fade' : ''

    if (this.isShown && this.options.backdrop) {
      var doAnimate = $.support.transition && animate

      this.$backdrop = $('<div class="modal-backdrop ' + animate + '" />')
        .prependTo(this.$element)
        .on('click.dismiss.bs.modal', $.proxy(function (e) {
          if (e.target !== e.currentTarget) return
          this.options.backdrop == 'static'
            ? this.$element[0].focus.call(this.$element[0])
            : this.hide.call(this)
        }, this))

      if (doAnimate) this.$backdrop[0].offsetWidth // force reflow

      this.$backdrop.addClass('in')

      if (!callback) return

      doAnimate ?
        this.$backdrop
          .one('bsTransitionEnd', callback)
          .emulateTransitionEnd(Modal.BACKDROP_TRANSITION_DURATION) :
        callback()

    } else if (!this.isShown && this.$backdrop) {
      this.$backdrop.removeClass('in')

      var callbackRemove = function () {
        that.removeBackdrop()
        callback && callback()
      }
      $.support.transition && this.$element.hasClass('fade') ?
        this.$backdrop
          .one('bsTransitionEnd', callbackRemove)
          .emulateTransitionEnd(Modal.BACKDROP_TRANSITION_DURATION) :
        callbackRemove()

    } else if (callback) {
      callback()
    }
  }

  // these following methods are used to handle overflowing modals

  Modal.prototype.handleUpdate = function () {
    if (this.options.backdrop) this.adjustBackdrop()
    this.adjustDialog()
  }

  Modal.prototype.adjustBackdrop = function () {
    this.$backdrop
      .css('height', 0)
      .css('height', this.$element[0].scrollHeight)
  }

  Modal.prototype.adjustDialog = function () {
    var modalIsOverflowing = this.$element[0].scrollHeight > document.documentElement.clientHeight

    this.$element.css({
      paddingLeft:  !this.bodyIsOverflowing && modalIsOverflowing ? this.scrollbarWidth : '',
      paddingRight: this.bodyIsOverflowing && !modalIsOverflowing ? this.scrollbarWidth : ''
    })
  }

  Modal.prototype.resetAdjustments = function () {
    this.$element.css({
      paddingLeft: '',
      paddingRight: ''
    })
  }

  Modal.prototype.checkScrollbar = function () {
    this.bodyIsOverflowing = document.body.scrollHeight > document.documentElement.clientHeight
    this.scrollbarWidth = this.measureScrollbar()
  }

  Modal.prototype.setScrollbar = function () {
    var bodyPad = parseInt((this.$body.css('padding-right') || 0), 10)
    if (this.bodyIsOverflowing) this.$body.css('padding-right', bodyPad + this.scrollbarWidth)
  }

  Modal.prototype.resetScrollbar = function () {
    this.$body.css('padding-right', '')
  }

  Modal.prototype.measureScrollbar = function () { // thx walsh
    var scrollDiv = document.createElement('div')
    scrollDiv.className = 'modal-scrollbar-measure'
    this.$body.append(scrollDiv)
    var scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth
    this.$body[0].removeChild(scrollDiv)
    return scrollbarWidth
  }


  // MODAL PLUGIN DEFINITION
  // =======================

  function Plugin(option, _relatedTarget) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.modal')
      var options = $.extend({}, Modal.DEFAULTS, $this.data(), typeof option == 'object' && option)

      if (!data) $this.data('bs.modal', (data = new Modal(this, options)))
      if (typeof option == 'string') data[option](_relatedTarget)
      else if (options.show) data.show(_relatedTarget)
    })
  }

  var old = $.fn.modal

  $.fn.modal             = Plugin
  $.fn.modal.Constructor = Modal


  // MODAL NO CONFLICT
  // =================

  $.fn.modal.noConflict = function () {
    $.fn.modal = old
    return this
  }


  // MODAL DATA-API
  // ==============

  $(document).on('click.bs.modal.data-api', '[data-toggle="modal"]', function (e) {
    var $this   = $(this)
    var href    = $this.attr('href')
    var $target = $($this.attr('data-target') || (href && href.replace(/.*(?=#[^\s]+$)/, ''))) // strip for ie7
    var option  = $target.data('bs.modal') ? 'toggle' : $.extend({ remote: !/#/.test(href) && href }, $target.data(), $this.data())

    if ($this.is('a')) e.preventDefault()

    $target.one('show.bs.modal', function (showEvent) {
      if (showEvent.isDefaultPrevented()) return // only register focus restorer if modal will actually get shown
      $target.one('hidden.bs.modal', function () {
        $this.is(':visible') && $this.trigger('focus')
      })
    })
    Plugin.call($target, option, this)
  })

}(jQuery);

/* ========================================================================
 * Bootstrap: tooltip.js v3.3.1
 * http://getbootstrap.com/javascript/#tooltip
 * Inspired by the original jQuery.tipsy by Jason Frame
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // TOOLTIP PUBLIC CLASS DEFINITION
  // ===============================

  var Tooltip = function (element, options) {
    this.type       =
    this.options    =
    this.enabled    =
    this.timeout    =
    this.hoverState =
    this.$element   = null

    this.init('tooltip', element, options)
  }

  Tooltip.VERSION  = '3.3.1'

  Tooltip.TRANSITION_DURATION = 150

  Tooltip.DEFAULTS = {
    animation: true,
    placement: 'top',
    selector: false,
    template: '<div class="tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',
    trigger: 'hover focus',
    title: '',
    delay: 0,
    html: false,
    container: false,
    viewport: {
      selector: 'body',
      padding: 0
    }
  }

  Tooltip.prototype.init = function (type, element, options) {
    this.enabled   = true
    this.type      = type
    this.$element  = $(element)
    this.options   = this.getOptions(options)
    this.$viewport = this.options.viewport && $(this.options.viewport.selector || this.options.viewport)

    var triggers = this.options.trigger.split(' ')

    for (var i = triggers.length; i--;) {
      var trigger = triggers[i]

      if (trigger == 'click') {
        this.$element.on('click.' + this.type, this.options.selector, $.proxy(this.toggle, this))
      } else if (trigger != 'manual') {
        var eventIn  = trigger == 'hover' ? 'mouseenter' : 'focusin'
        var eventOut = trigger == 'hover' ? 'mouseleave' : 'focusout'

        this.$element.on(eventIn  + '.' + this.type, this.options.selector, $.proxy(this.enter, this))
        this.$element.on(eventOut + '.' + this.type, this.options.selector, $.proxy(this.leave, this))
      }
    }

    this.options.selector ?
      (this._options = $.extend({}, this.options, { trigger: 'manual', selector: '' })) :
      this.fixTitle()
  }

  Tooltip.prototype.getDefaults = function () {
    return Tooltip.DEFAULTS
  }

  Tooltip.prototype.getOptions = function (options) {
    options = $.extend({}, this.getDefaults(), this.$element.data(), options)

    if (options.delay && typeof options.delay == 'number') {
      options.delay = {
        show: options.delay,
        hide: options.delay
      }
    }

    return options
  }

  Tooltip.prototype.getDelegateOptions = function () {
    var options  = {}
    var defaults = this.getDefaults()

    this._options && $.each(this._options, function (key, value) {
      if (defaults[key] != value) options[key] = value
    })

    return options
  }

  Tooltip.prototype.enter = function (obj) {
    var self = obj instanceof this.constructor ?
      obj : $(obj.currentTarget).data('bs.' + this.type)

    if (self && self.$tip && self.$tip.is(':visible')) {
      self.hoverState = 'in'
      return
    }

    if (!self) {
      self = new this.constructor(obj.currentTarget, this.getDelegateOptions())
      $(obj.currentTarget).data('bs.' + this.type, self)
    }

    clearTimeout(self.timeout)

    self.hoverState = 'in'

    if (!self.options.delay || !self.options.delay.show) return self.show()

    self.timeout = setTimeout(function () {
      if (self.hoverState == 'in') self.show()
    }, self.options.delay.show)
  }

  Tooltip.prototype.leave = function (obj) {
    var self = obj instanceof this.constructor ?
      obj : $(obj.currentTarget).data('bs.' + this.type)

    if (!self) {
      self = new this.constructor(obj.currentTarget, this.getDelegateOptions())
      $(obj.currentTarget).data('bs.' + this.type, self)
    }

    clearTimeout(self.timeout)

    self.hoverState = 'out'

    if (!self.options.delay || !self.options.delay.hide) return self.hide()

    self.timeout = setTimeout(function () {
      if (self.hoverState == 'out') self.hide()
    }, self.options.delay.hide)
  }

  Tooltip.prototype.show = function () {
    var e = $.Event('show.bs.' + this.type)

    if (this.hasContent() && this.enabled) {
      this.$element.trigger(e)

      var inDom = $.contains(this.$element[0].ownerDocument.documentElement, this.$element[0])
      if (e.isDefaultPrevented() || !inDom) return
      var that = this

      var $tip = this.tip()

      var tipId = this.getUID(this.type)

      this.setContent()
      $tip.attr('id', tipId)
      this.$element.attr('aria-describedby', tipId)

      if (this.options.animation) $tip.addClass('fade')

      var placement = typeof this.options.placement == 'function' ?
        this.options.placement.call(this, $tip[0], this.$element[0]) :
        this.options.placement

      var autoToken = /\s?auto?\s?/i
      var autoPlace = autoToken.test(placement)
      if (autoPlace) placement = placement.replace(autoToken, '') || 'top'

      $tip
        .detach()
        .css({ top: 0, left: 0, display: 'block' })
        .addClass(placement)
        .data('bs.' + this.type, this)

      this.options.container ? $tip.appendTo(this.options.container) : $tip.insertAfter(this.$element)

      var pos          = this.getPosition()
      var actualWidth  = $tip[0].offsetWidth
      var actualHeight = $tip[0].offsetHeight

      if (autoPlace) {
        var orgPlacement = placement
        var $container   = this.options.container ? $(this.options.container) : this.$element.parent()
        var containerDim = this.getPosition($container)

        placement = placement == 'bottom' && pos.bottom + actualHeight > containerDim.bottom ? 'top'    :
                    placement == 'top'    && pos.top    - actualHeight < containerDim.top    ? 'bottom' :
                    placement == 'right'  && pos.right  + actualWidth  > containerDim.width  ? 'left'   :
                    placement == 'left'   && pos.left   - actualWidth  < containerDim.left   ? 'right'  :
                    placement

        $tip
          .removeClass(orgPlacement)
          .addClass(placement)
      }

      var calculatedOffset = this.getCalculatedOffset(placement, pos, actualWidth, actualHeight)

      this.applyPlacement(calculatedOffset, placement)

      var complete = function () {
        var prevHoverState = that.hoverState
        that.$element.trigger('shown.bs.' + that.type)
        that.hoverState = null

        if (prevHoverState == 'out') that.leave(that)
      }

      $.support.transition && this.$tip.hasClass('fade') ?
        $tip
          .one('bsTransitionEnd', complete)
          .emulateTransitionEnd(Tooltip.TRANSITION_DURATION) :
        complete()
    }
  }

  Tooltip.prototype.applyPlacement = function (offset, placement) {
    var $tip   = this.tip()
    var width  = $tip[0].offsetWidth
    var height = $tip[0].offsetHeight

    // manually read margins because getBoundingClientRect includes difference
    var marginTop = parseInt($tip.css('margin-top'), 10)
    var marginLeft = parseInt($tip.css('margin-left'), 10)

    // we must check for NaN for ie 8/9
    if (isNaN(marginTop))  marginTop  = 0
    if (isNaN(marginLeft)) marginLeft = 0

    offset.top  = offset.top  + marginTop
    offset.left = offset.left + marginLeft

    // $.fn.offset doesn't round pixel values
    // so we use setOffset directly with our own function B-0
    $.offset.setOffset($tip[0], $.extend({
      using: function (props) {
        $tip.css({
          top: Math.round(props.top),
          left: Math.round(props.left)
        })
      }
    }, offset), 0)

    $tip.addClass('in')

    // check to see if placing tip in new offset caused the tip to resize itself
    var actualWidth  = $tip[0].offsetWidth
    var actualHeight = $tip[0].offsetHeight

    if (placement == 'top' && actualHeight != height) {
      offset.top = offset.top + height - actualHeight
    }

    var delta = this.getViewportAdjustedDelta(placement, offset, actualWidth, actualHeight)

    if (delta.left) offset.left += delta.left
    else offset.top += delta.top

    var isVertical          = /top|bottom/.test(placement)
    var arrowDelta          = isVertical ? delta.left * 2 - width + actualWidth : delta.top * 2 - height + actualHeight
    var arrowOffsetPosition = isVertical ? 'offsetWidth' : 'offsetHeight'

    $tip.offset(offset)
    this.replaceArrow(arrowDelta, $tip[0][arrowOffsetPosition], isVertical)
  }

  Tooltip.prototype.replaceArrow = function (delta, dimension, isHorizontal) {
    this.arrow()
      .css(isHorizontal ? 'left' : 'top', 50 * (1 - delta / dimension) + '%')
      .css(isHorizontal ? 'top' : 'left', '')
  }

  Tooltip.prototype.setContent = function () {
    var $tip  = this.tip()
    var title = this.getTitle()

    $tip.find('.tooltip-inner')[this.options.html ? 'html' : 'text'](title)
    $tip.removeClass('fade in top bottom left right')
  }

  Tooltip.prototype.hide = function (callback) {
    var that = this
    var $tip = this.tip()
    var e    = $.Event('hide.bs.' + this.type)

    function complete() {
      if (that.hoverState != 'in') $tip.detach()
      that.$element
        .removeAttr('aria-describedby')
        .trigger('hidden.bs.' + that.type)
      callback && callback()
    }

    this.$element.trigger(e)

    if (e.isDefaultPrevented()) return

    $tip.removeClass('in')

    $.support.transition && this.$tip.hasClass('fade') ?
      $tip
        .one('bsTransitionEnd', complete)
        .emulateTransitionEnd(Tooltip.TRANSITION_DURATION) :
      complete()

    this.hoverState = null

    return this
  }

  Tooltip.prototype.fixTitle = function () {
    var $e = this.$element
    if ($e.attr('title') || typeof ($e.attr('data-original-title')) != 'string') {
      $e.attr('data-original-title', $e.attr('title') || '').attr('title', '')
    }
  }

  Tooltip.prototype.hasContent = function () {
    return this.getTitle()
  }

  Tooltip.prototype.getPosition = function ($element) {
    $element   = $element || this.$element

    var el     = $element[0]
    var isBody = el.tagName == 'BODY'

    var elRect    = el.getBoundingClientRect()
    if (elRect.width == null) {
      // width and height are missing in IE8, so compute them manually; see https://github.com/twbs/bootstrap/issues/14093
      elRect = $.extend({}, elRect, { width: elRect.right - elRect.left, height: elRect.bottom - elRect.top })
    }
    var elOffset  = isBody ? { top: 0, left: 0 } : $element.offset()
    var scroll    = { scroll: isBody ? document.documentElement.scrollTop || document.body.scrollTop : $element.scrollTop() }
    var outerDims = isBody ? { width: $(window).width(), height: $(window).height() } : null

    return $.extend({}, elRect, scroll, outerDims, elOffset)
  }

  Tooltip.prototype.getCalculatedOffset = function (placement, pos, actualWidth, actualHeight) {
    return placement == 'bottom' ? { top: pos.top + pos.height,   left: pos.left + pos.width / 2 - actualWidth / 2  } :
           placement == 'top'    ? { top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2  } :
           placement == 'left'   ? { top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth } :
        /* placement == 'right' */ { top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width   }

  }

  Tooltip.prototype.getViewportAdjustedDelta = function (placement, pos, actualWidth, actualHeight) {
    var delta = { top: 0, left: 0 }
    if (!this.$viewport) return delta

    var viewportPadding = this.options.viewport && this.options.viewport.padding || 0
    var viewportDimensions = this.getPosition(this.$viewport)

    if (/right|left/.test(placement)) {
      var topEdgeOffset    = pos.top - viewportPadding - viewportDimensions.scroll
      var bottomEdgeOffset = pos.top + viewportPadding - viewportDimensions.scroll + actualHeight
      if (topEdgeOffset < viewportDimensions.top) { // top overflow
        delta.top = viewportDimensions.top - topEdgeOffset
      } else if (bottomEdgeOffset > viewportDimensions.top + viewportDimensions.height) { // bottom overflow
        delta.top = viewportDimensions.top + viewportDimensions.height - bottomEdgeOffset
      }
    } else {
      var leftEdgeOffset  = pos.left - viewportPadding
      var rightEdgeOffset = pos.left + viewportPadding + actualWidth
      if (leftEdgeOffset < viewportDimensions.left) { // left overflow
        delta.left = viewportDimensions.left - leftEdgeOffset
      } else if (rightEdgeOffset > viewportDimensions.width) { // right overflow
        delta.left = viewportDimensions.left + viewportDimensions.width - rightEdgeOffset
      }
    }

    return delta
  }

  Tooltip.prototype.getTitle = function () {
    var title
    var $e = this.$element
    var o  = this.options

    title = $e.attr('data-original-title')
      || (typeof o.title == 'function' ? o.title.call($e[0]) :  o.title)

    return title
  }

  Tooltip.prototype.getUID = function (prefix) {
    do prefix += ~~(Math.random() * 1000000)
    while (document.getElementById(prefix))
    return prefix
  }

  Tooltip.prototype.tip = function () {
    return (this.$tip = this.$tip || $(this.options.template))
  }

  Tooltip.prototype.arrow = function () {
    return (this.$arrow = this.$arrow || this.tip().find('.tooltip-arrow'))
  }

  Tooltip.prototype.enable = function () {
    this.enabled = true
  }

  Tooltip.prototype.disable = function () {
    this.enabled = false
  }

  Tooltip.prototype.toggleEnabled = function () {
    this.enabled = !this.enabled
  }

  Tooltip.prototype.toggle = function (e) {
    var self = this
    if (e) {
      self = $(e.currentTarget).data('bs.' + this.type)
      if (!self) {
        self = new this.constructor(e.currentTarget, this.getDelegateOptions())
        $(e.currentTarget).data('bs.' + this.type, self)
      }
    }

    self.tip().hasClass('in') ? self.leave(self) : self.enter(self)
  }

  Tooltip.prototype.destroy = function () {
    var that = this
    clearTimeout(this.timeout)
    this.hide(function () {
      that.$element.off('.' + that.type).removeData('bs.' + that.type)
    })
  }


  // TOOLTIP PLUGIN DEFINITION
  // =========================

  function Plugin(option) {
    return this.each(function () {
      var $this    = $(this)
      var data     = $this.data('bs.tooltip')
      var options  = typeof option == 'object' && option
      var selector = options && options.selector

      if (!data && option == 'destroy') return
      if (selector) {
        if (!data) $this.data('bs.tooltip', (data = {}))
        if (!data[selector]) data[selector] = new Tooltip(this, options)
      } else {
        if (!data) $this.data('bs.tooltip', (data = new Tooltip(this, options)))
      }
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.tooltip

  $.fn.tooltip             = Plugin
  $.fn.tooltip.Constructor = Tooltip


  // TOOLTIP NO CONFLICT
  // ===================

  $.fn.tooltip.noConflict = function () {
    $.fn.tooltip = old
    return this
  }

}(jQuery);

/* ========================================================================
 * Bootstrap: popover.js v3.3.1
 * http://getbootstrap.com/javascript/#popovers
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // POPOVER PUBLIC CLASS DEFINITION
  // ===============================

  var Popover = function (element, options) {
    this.init('popover', element, options)
  }

  if (!$.fn.tooltip) throw new Error('Popover requires tooltip.js')

  Popover.VERSION  = '3.3.1'

  Popover.DEFAULTS = $.extend({}, $.fn.tooltip.Constructor.DEFAULTS, {
    placement: 'right',
    trigger: 'click',
    content: '',
    template: '<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
  })


  // NOTE: POPOVER EXTENDS tooltip.js
  // ================================

  Popover.prototype = $.extend({}, $.fn.tooltip.Constructor.prototype)

  Popover.prototype.constructor = Popover

  Popover.prototype.getDefaults = function () {
    return Popover.DEFAULTS
  }

  Popover.prototype.setContent = function () {
    var $tip    = this.tip()
    var title   = this.getTitle()
    var content = this.getContent()

    $tip.find('.popover-title')[this.options.html ? 'html' : 'text'](title)
    $tip.find('.popover-content').children().detach().end()[ // we use append for html objects to maintain js events
      this.options.html ? (typeof content == 'string' ? 'html' : 'append') : 'text'
    ](content)

    $tip.removeClass('fade top bottom left right in')

    // IE8 doesn't accept hiding via the `:empty` pseudo selector, we have to do
    // this manually by checking the contents.
    if (!$tip.find('.popover-title').html()) $tip.find('.popover-title').hide()
  }

  Popover.prototype.hasContent = function () {
    return this.getTitle() || this.getContent()
  }

  Popover.prototype.getContent = function () {
    var $e = this.$element
    var o  = this.options

    return $e.attr('data-content')
      || (typeof o.content == 'function' ?
            o.content.call($e[0]) :
            o.content)
  }

  Popover.prototype.arrow = function () {
    return (this.$arrow = this.$arrow || this.tip().find('.arrow'))
  }

  Popover.prototype.tip = function () {
    if (!this.$tip) this.$tip = $(this.options.template)
    return this.$tip
  }


  // POPOVER PLUGIN DEFINITION
  // =========================

  function Plugin(option) {
    return this.each(function () {
      var $this    = $(this)
      var data     = $this.data('bs.popover')
      var options  = typeof option == 'object' && option
      var selector = options && options.selector

      if (!data && option == 'destroy') return
      if (selector) {
        if (!data) $this.data('bs.popover', (data = {}))
        if (!data[selector]) data[selector] = new Popover(this, options)
      } else {
        if (!data) $this.data('bs.popover', (data = new Popover(this, options)))
      }
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.popover

  $.fn.popover             = Plugin
  $.fn.popover.Constructor = Popover


  // POPOVER NO CONFLICT
  // ===================

  $.fn.popover.noConflict = function () {
    $.fn.popover = old
    return this
  }

}(jQuery);

/* ========================================================================
 * Bootstrap: tab.js v3.3.1
 * http://getbootstrap.com/javascript/#tabs
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // TAB CLASS DEFINITION
  // ====================

  var Tab = function (element) {
    this.element = $(element)
  }

  Tab.VERSION = '3.3.1'

  Tab.TRANSITION_DURATION = 150

  Tab.prototype.show = function () {
    var $this    = this.element
    var $ul      = $this.closest('ul:not(.dropdown-menu)')
    var selector = $this.data('target')

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') // strip for ie7
    }

    if ($this.parent('li').hasClass('active')) return

    var $previous = $ul.find('.active:last a')
    var hideEvent = $.Event('hide.bs.tab', {
      relatedTarget: $this[0]
    })
    var showEvent = $.Event('show.bs.tab', {
      relatedTarget: $previous[0]
    })

    $previous.trigger(hideEvent)
    $this.trigger(showEvent)

    if (showEvent.isDefaultPrevented() || hideEvent.isDefaultPrevented()) return

    var $target = $(selector)

    this.activate($this.closest('li'), $ul)
    this.activate($target, $target.parent(), function () {
      $previous.trigger({
        type: 'hidden.bs.tab',
        relatedTarget: $this[0]
      })
      $this.trigger({
        type: 'shown.bs.tab',
        relatedTarget: $previous[0]
      })
    })
  }

  Tab.prototype.activate = function (element, container, callback) {
    var $active    = container.find('> .active')
    var transition = callback
      && $.support.transition
      && (($active.length && $active.hasClass('fade')) || !!container.find('> .fade').length)

    function next() {
      $active
        .removeClass('active')
        .find('> .dropdown-menu > .active')
          .removeClass('active')
        .end()
        .find('[data-toggle="tab"]')
          .attr('aria-expanded', false)

      element
        .addClass('active')
        .find('[data-toggle="tab"]')
          .attr('aria-expanded', true)

      if (transition) {
        element[0].offsetWidth // reflow for transition
        element.addClass('in')
      } else {
        element.removeClass('fade')
      }

      if (element.parent('.dropdown-menu')) {
        element
          .closest('li.dropdown')
            .addClass('active')
          .end()
          .find('[data-toggle="tab"]')
            .attr('aria-expanded', true)
      }

      callback && callback()
    }

    $active.length && transition ?
      $active
        .one('bsTransitionEnd', next)
        .emulateTransitionEnd(Tab.TRANSITION_DURATION) :
      next()

    $active.removeClass('in')
  }


  // TAB PLUGIN DEFINITION
  // =====================

  function Plugin(option) {
    return this.each(function () {
      var $this = $(this)
      var data  = $this.data('bs.tab')

      if (!data) $this.data('bs.tab', (data = new Tab(this)))
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.tab

  $.fn.tab             = Plugin
  $.fn.tab.Constructor = Tab


  // TAB NO CONFLICT
  // ===============

  $.fn.tab.noConflict = function () {
    $.fn.tab = old
    return this
  }


  // TAB DATA-API
  // ============

  var clickHandler = function (e) {
    e.preventDefault()
    Plugin.call($(this), 'show')
  }

  $(document)
    .on('click.bs.tab.data-api', '[data-toggle="tab"]', clickHandler)
    .on('click.bs.tab.data-api', '[data-toggle="pill"]', clickHandler)

}(jQuery);

/* ========================================================================
 * Bootstrap: affix.js v3.3.1
 * http://getbootstrap.com/javascript/#affix
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // AFFIX CLASS DEFINITION
  // ======================

  var Affix = function (element, options) {
    this.options = $.extend({}, Affix.DEFAULTS, options)

    this.$target = $(this.options.target)
      .on('scroll.bs.affix.data-api', $.proxy(this.checkPosition, this))
      .on('click.bs.affix.data-api',  $.proxy(this.checkPositionWithEventLoop, this))

    this.$element     = $(element)
    this.affixed      =
    this.unpin        =
    this.pinnedOffset = null

    this.checkPosition()
  }

  Affix.VERSION  = '3.3.1'

  Affix.RESET    = 'affix affix-top affix-bottom'

  Affix.DEFAULTS = {
    offset: 0,
    target: window
  }

  Affix.prototype.getState = function (scrollHeight, height, offsetTop, offsetBottom) {
    var scrollTop    = this.$target.scrollTop()
    var position     = this.$element.offset()
    var targetHeight = this.$target.height()

    if (offsetTop != null && this.affixed == 'top') return scrollTop < offsetTop ? 'top' : false

    if (this.affixed == 'bottom') {
      if (offsetTop != null) return (scrollTop + this.unpin <= position.top) ? false : 'bottom'
      return (scrollTop + targetHeight <= scrollHeight - offsetBottom) ? false : 'bottom'
    }

    var initializing   = this.affixed == null
    var colliderTop    = initializing ? scrollTop : position.top
    var colliderHeight = initializing ? targetHeight : height

    if (offsetTop != null && colliderTop <= offsetTop) return 'top'
    if (offsetBottom != null && (colliderTop + colliderHeight >= scrollHeight - offsetBottom)) return 'bottom'

    return false
  }

  Affix.prototype.getPinnedOffset = function () {
    if (this.pinnedOffset) return this.pinnedOffset
    this.$element.removeClass(Affix.RESET).addClass('affix')
    var scrollTop = this.$target.scrollTop()
    var position  = this.$element.offset()
    return (this.pinnedOffset = position.top - scrollTop)
  }

  Affix.prototype.checkPositionWithEventLoop = function () {
    setTimeout($.proxy(this.checkPosition, this), 1)
  }

  Affix.prototype.checkPosition = function () {
    if (!this.$element.is(':visible')) return

    var height       = this.$element.height()
    var offset       = this.options.offset
    var offsetTop    = offset.top
    var offsetBottom = offset.bottom
    var scrollHeight = $('body').height()

    if (typeof offset != 'object')         offsetBottom = offsetTop = offset
    if (typeof offsetTop == 'function')    offsetTop    = offset.top(this.$element)
    if (typeof offsetBottom == 'function') offsetBottom = offset.bottom(this.$element)

    var affix = this.getState(scrollHeight, height, offsetTop, offsetBottom)

    if (this.affixed != affix) {
      if (this.unpin != null) this.$element.css('top', '')

      var affixType = 'affix' + (affix ? '-' + affix : '')
      var e         = $.Event(affixType + '.bs.affix')

      this.$element.trigger(e)

      if (e.isDefaultPrevented()) return

      this.affixed = affix
      this.unpin = affix == 'bottom' ? this.getPinnedOffset() : null

      this.$element
        .removeClass(Affix.RESET)
        .addClass(affixType)
        .trigger(affixType.replace('affix', 'affixed') + '.bs.affix')
    }

    if (affix == 'bottom') {
      this.$element.offset({
        top: scrollHeight - height - offsetBottom
      })
    }
  }


  // AFFIX PLUGIN DEFINITION
  // =======================

  function Plugin(option) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.affix')
      var options = typeof option == 'object' && option

      if (!data) $this.data('bs.affix', (data = new Affix(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.affix

  $.fn.affix             = Plugin
  $.fn.affix.Constructor = Affix


  // AFFIX NO CONFLICT
  // =================

  $.fn.affix.noConflict = function () {
    $.fn.affix = old
    return this
  }


  // AFFIX DATA-API
  // ==============

  $(window).on('load', function () {
    $('[data-spy="affix"]').each(function () {
      var $spy = $(this)
      var data = $spy.data()

      data.offset = data.offset || {}

      if (data.offsetBottom != null) data.offset.bottom = data.offsetBottom
      if (data.offsetTop    != null) data.offset.top    = data.offsetTop

      Plugin.call($spy, data)
    })
  })

}(jQuery);

/* ========================================================================
 * Bootstrap: collapse.js v3.3.1
 * http://getbootstrap.com/javascript/#collapse
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // COLLAPSE PUBLIC CLASS DEFINITION
  // ================================

  var Collapse = function (element, options) {
    this.$element      = $(element)
    this.options       = $.extend({}, Collapse.DEFAULTS, options)
    this.$trigger      = $(this.options.trigger).filter('[href="#' + element.id + '"], [data-target="#' + element.id + '"]')
    this.transitioning = null

    if (this.options.parent) {
      this.$parent = this.getParent()
    } else {
      this.addAriaAndCollapsedClass(this.$element, this.$trigger)
    }

    if (this.options.toggle) this.toggle()
  }

  Collapse.VERSION  = '3.3.1'

  Collapse.TRANSITION_DURATION = 350

  Collapse.DEFAULTS = {
    toggle: true,
    trigger: '[data-toggle="collapse"]'
  }

  Collapse.prototype.dimension = function () {
    var hasWidth = this.$element.hasClass('width')
    return hasWidth ? 'width' : 'height'
  }

  Collapse.prototype.show = function () {
    if (this.transitioning || this.$element.hasClass('in')) return

    var activesData
    var actives = this.$parent && this.$parent.find('> .panel').children('.in, .collapsing')

    if (actives && actives.length) {
      activesData = actives.data('bs.collapse')
      if (activesData && activesData.transitioning) return
    }

    var startEvent = $.Event('show.bs.collapse')
    this.$element.trigger(startEvent)
    if (startEvent.isDefaultPrevented()) return

    if (actives && actives.length) {
      Plugin.call(actives, 'hide')
      activesData || actives.data('bs.collapse', null)
    }

    var dimension = this.dimension()

    this.$element
      .removeClass('collapse')
      .addClass('collapsing')[dimension](0)
      .attr('aria-expanded', true)

    this.$trigger
      .removeClass('collapsed')
      .attr('aria-expanded', true)

    this.transitioning = 1

    var complete = function () {
      this.$element
        .removeClass('collapsing')
        .addClass('collapse in')[dimension]('')
      this.transitioning = 0
      this.$element
        .trigger('shown.bs.collapse')
    }

    if (!$.support.transition) return complete.call(this)

    var scrollSize = $.camelCase(['scroll', dimension].join('-'))

    this.$element
      .one('bsTransitionEnd', $.proxy(complete, this))
      .emulateTransitionEnd(Collapse.TRANSITION_DURATION)[dimension](this.$element[0][scrollSize])
  }

  Collapse.prototype.hide = function () {
    if (this.transitioning || !this.$element.hasClass('in')) return

    var startEvent = $.Event('hide.bs.collapse')
    this.$element.trigger(startEvent)
    if (startEvent.isDefaultPrevented()) return

    var dimension = this.dimension()

    this.$element[dimension](this.$element[dimension]())[0].offsetHeight

    this.$element
      .addClass('collapsing')
      .removeClass('collapse in')
      .attr('aria-expanded', false)

    this.$trigger
      .addClass('collapsed')
      .attr('aria-expanded', false)

    this.transitioning = 1

    var complete = function () {
      this.transitioning = 0
      this.$element
        .removeClass('collapsing')
        .addClass('collapse')
        .trigger('hidden.bs.collapse')
    }

    if (!$.support.transition) return complete.call(this)

    this.$element
      [dimension](0)
      .one('bsTransitionEnd', $.proxy(complete, this))
      .emulateTransitionEnd(Collapse.TRANSITION_DURATION)
  }

  Collapse.prototype.toggle = function () {
    this[this.$element.hasClass('in') ? 'hide' : 'show']()
  }

  Collapse.prototype.getParent = function () {
    return $(this.options.parent)
      .find('[data-toggle="collapse"][data-parent="' + this.options.parent + '"]')
      .each($.proxy(function (i, element) {
        var $element = $(element)
        this.addAriaAndCollapsedClass(getTargetFromTrigger($element), $element)
      }, this))
      .end()
  }

  Collapse.prototype.addAriaAndCollapsedClass = function ($element, $trigger) {
    var isOpen = $element.hasClass('in')

    $element.attr('aria-expanded', isOpen)
    $trigger
      .toggleClass('collapsed', !isOpen)
      .attr('aria-expanded', isOpen)
  }

  function getTargetFromTrigger($trigger) {
    var href
    var target = $trigger.attr('data-target')
      || (href = $trigger.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '') // strip for ie7

    return $(target)
  }


  // COLLAPSE PLUGIN DEFINITION
  // ==========================

  function Plugin(option) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.collapse')
      var options = $.extend({}, Collapse.DEFAULTS, $this.data(), typeof option == 'object' && option)

      if (!data && options.toggle && option == 'show') options.toggle = false
      if (!data) $this.data('bs.collapse', (data = new Collapse(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.collapse

  $.fn.collapse             = Plugin
  $.fn.collapse.Constructor = Collapse


  // COLLAPSE NO CONFLICT
  // ====================

  $.fn.collapse.noConflict = function () {
    $.fn.collapse = old
    return this
  }


  // COLLAPSE DATA-API
  // =================

  $(document).on('click.bs.collapse.data-api', '[data-toggle="collapse"]', function (e) {
    var $this   = $(this)

    if (!$this.attr('data-target')) e.preventDefault()

    var $target = getTargetFromTrigger($this)
    var data    = $target.data('bs.collapse')
    var option  = data ? 'toggle' : $.extend({}, $this.data(), { trigger: this })

    Plugin.call($target, option)
  })

}(jQuery);

/* ========================================================================
 * Bootstrap: scrollspy.js v3.3.1
 * http://getbootstrap.com/javascript/#scrollspy
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // SCROLLSPY CLASS DEFINITION
  // ==========================

  function ScrollSpy(element, options) {
    var process  = $.proxy(this.process, this)

    this.$body          = $('body')
    this.$scrollElement = $(element).is('body') ? $(window) : $(element)
    this.options        = $.extend({}, ScrollSpy.DEFAULTS, options)
    this.selector       = (this.options.target || '') + ' .nav li > a'
    this.offsets        = []
    this.targets        = []
    this.activeTarget   = null
    this.scrollHeight   = 0

    this.$scrollElement.on('scroll.bs.scrollspy', process)
    this.refresh()
    this.process()
  }

  ScrollSpy.VERSION  = '3.3.1'

  ScrollSpy.DEFAULTS = {
    offset: 10
  }

  ScrollSpy.prototype.getScrollHeight = function () {
    return this.$scrollElement[0].scrollHeight || Math.max(this.$body[0].scrollHeight, document.documentElement.scrollHeight)
  }

  ScrollSpy.prototype.refresh = function () {
    var offsetMethod = 'offset'
    var offsetBase   = 0

    if (!$.isWindow(this.$scrollElement[0])) {
      offsetMethod = 'position'
      offsetBase   = this.$scrollElement.scrollTop()
    }

    this.offsets = []
    this.targets = []
    this.scrollHeight = this.getScrollHeight()

    var self     = this

    this.$body
      .find(this.selector)
      .map(function () {
        var $el   = $(this)
        var href  = $el.data('target') || $el.attr('href')
        var $href = /^#./.test(href) && $(href)

        return ($href
          && $href.length
          && $href.is(':visible')
          && [[$href[offsetMethod]().top + offsetBase, href]]) || null
      })
      .sort(function (a, b) { return a[0] - b[0] })
      .each(function () {
        self.offsets.push(this[0])
        self.targets.push(this[1])
      })
  }

  ScrollSpy.prototype.process = function () {
    var scrollTop    = this.$scrollElement.scrollTop() + this.options.offset
    var scrollHeight = this.getScrollHeight()
    var maxScroll    = this.options.offset + scrollHeight - this.$scrollElement.height()
    var offsets      = this.offsets
    var targets      = this.targets
    var activeTarget = this.activeTarget
    var i

    if (this.scrollHeight != scrollHeight) {
      this.refresh()
    }

    if (scrollTop >= maxScroll) {
      return activeTarget != (i = targets[targets.length - 1]) && this.activate(i)
    }

    if (activeTarget && scrollTop < offsets[0]) {
      this.activeTarget = null
      return this.clear()
    }

    for (i = offsets.length; i--;) {
      activeTarget != targets[i]
        && scrollTop >= offsets[i]
        && (!offsets[i + 1] || scrollTop <= offsets[i + 1])
        && this.activate(targets[i])
    }
  }

  ScrollSpy.prototype.activate = function (target) {
    this.activeTarget = target

    this.clear()

    var selector = this.selector +
        '[data-target="' + target + '"],' +
        this.selector + '[href="' + target + '"]'

    var active = $(selector)
      .parents('li')
      .addClass('active')

    if (active.parent('.dropdown-menu').length) {
      active = active
        .closest('li.dropdown')
        .addClass('active')
    }

    active.trigger('activate.bs.scrollspy')
  }

  ScrollSpy.prototype.clear = function () {
    $(this.selector)
      .parentsUntil(this.options.target, '.active')
      .removeClass('active')
  }


  // SCROLLSPY PLUGIN DEFINITION
  // ===========================

  function Plugin(option) {
    return this.each(function () {
      var $this   = $(this)
      var data    = $this.data('bs.scrollspy')
      var options = typeof option == 'object' && option

      if (!data) $this.data('bs.scrollspy', (data = new ScrollSpy(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  var old = $.fn.scrollspy

  $.fn.scrollspy             = Plugin
  $.fn.scrollspy.Constructor = ScrollSpy


  // SCROLLSPY NO CONFLICT
  // =====================

  $.fn.scrollspy.noConflict = function () {
    $.fn.scrollspy = old
    return this
  }


  // SCROLLSPY DATA-API
  // ==================

  $(window).on('load.bs.scrollspy.data-api', function () {
    $('[data-spy="scroll"]').each(function () {
      var $spy = $(this)
      Plugin.call($spy, $spy.data())
    })
  })

}(jQuery);

/* ========================================================================
 * Bootstrap: transition.js v3.3.1
 * http://getbootstrap.com/javascript/#transitions
 * ========================================================================
 * Copyright 2011-2014 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)
 * ======================================================================== */


+function ($) {
  'use strict';

  // CSS TRANSITION SUPPORT (Shoutout: http://www.modernizr.com/)
  // ============================================================

  function transitionEnd() {
    var el = document.createElement('bootstrap')

    var transEndEventNames = {
      WebkitTransition : 'webkitTransitionEnd',
      MozTransition    : 'transitionend',
      OTransition      : 'oTransitionEnd otransitionend',
      transition       : 'transitionend'
    }

    for (var name in transEndEventNames) {
      if (el.style[name] !== undefined) {
        return { end: transEndEventNames[name] }
      }
    }

    return false // explicit for ie8 (  ._.)
  }

  // http://blog.alexmaccaw.com/css-transitions
  $.fn.emulateTransitionEnd = function (duration) {
    var called = false
    var $el = this
    $(this).one('bsTransitionEnd', function () { called = true })
    var callback = function () { if (!called) $($el).trigger($.support.transition.end) }
    setTimeout(callback, duration)
    return this
  }

  $(function () {
    $.support.transition = transitionEnd()

    if (!$.support.transition) return

    $.event.special.bsTransitionEnd = {
      bindType: $.support.transition.end,
      delegateType: $.support.transition.end,
      handle: function (e) {
        if ($(e.target).is(this)) return e.handleObj.handler.apply(this, arguments)
      }
    }
  })

}(jQuery);

'use strict';
jQuery(document).ready(function() {
   jQuery(document).on('mouseenter', '#menu-brand', 
       function() {
            jQuery('.main-nav').show();
       }
   ).on('mouseleave', '#menu-brand', 
       function() {
           jQuery('.main-nav').hide();
       }
    );

    /* show tooltip icon next to BET Name*/
    jQuery(document).on('mouseenter', '.question-icon[data-tooltip!=""]', function() {
        var $t = jQuery(this);
        if (!$t.qtip('api')) {
            $t.qtip({
                content: {
                    button: true,
                    attr: 'data-tooltip'
                },
                hide: {
                    event: 'unfocus'
                },
                style: {
                    classes: 'qtip-bet',
                    def: false
                },
                show: {
                    ready: true,
                    solo: true
                }
            });
        }
    });
    
});

var VisualforceRemotingManager = angular.module('VisualforceRemotingManager', ['appConfig']);

VisualforceRemotingManager.service('VisualforceRemoting', ['$http', 'sfConfig',
    function($http, sfConfig) {


        function fakeUrl(data, mockBase) {

            var url = mockBase;

            // for (var i = 0; i < data.length; i++) {

            //     var separtor = '_';
            //     var value = data[i];
            //     if (data[i] === '' || data[i] === undefined) {
            //         value = null;
            //     }

            //     url += separtor + value;
            // }

            url += '.json';
            return url;
        }

        //set map for file URL generation
        this.invokeAction = function() {

            //clone
            var args = Array.prototype.slice.call(arguments, 0);
            var actionName = args.shift();
            var callback = args.pop();
            var callback = args.pop();
            var mockBase = sfConfig.resourceBasePath + 'mocks/' + actionName;
            var url = fakeUrl(args, mockBase);

            $http.get(url).success(function(data) {
                callback(data.result, data);
            }).error(function() {
                $http.get(mockBase + '.json').success(function(data) {
                    callback(data.result, data);
                }).error(function(message, code) {
                    var event = {
                        "transaction": {
                            "args": {},
                            "action": "uw_BETRemoteController",
                            "method": "actionName",
                            "data": {},
                            "tid": 4,
                            "retryCount": 0,
                            "ctx": {
                                "csrf": "xxx",
                                "vid": "yyy",
                                "ns": "",
                                "ver": 29
                            }
                        },
                        "code": "xhr",
                        "message": message,
                        "xhr": {
                            "tId": 2,
                            "status": 0,
                            "statusText": "communication failure",
                            "isAbort": false
                        },
                        "result": null,
                        "status": false,
                        "statusCode": code
                    };
                    callback(null, event);
                })
            });
        };
    }
]);

VisualforceRemotingManager.factory('VisualforceRemotingManager', ['$injector', 'sfConfig',
    function($injector, sfConfig) {

        if ('SF' === sfConfig.environment) {
            return Visualforce.remoting.Manager;

        }
        return $injector.get('VisualforceRemoting');
    }
]);
'use strict';
/**
 * @ngdoc overview
 * @name unileverApp
 * @description
 * #unileverApp
 *
 * Main module of the application.
 */
var unileverApp =
    angular
    .module('unileverApp', [
        'ngAnimate',
        'ngCookies',
        'ngResource',
        'ngRoute',
        'ngSanitize',
        'ui.router',
        'appConfig',
        'infinite-scroll',
        'VisualforceRemotingManager'
    ]);

unileverApp.config(function($stateProvider, $urlRouterProvider, sfConfig) {

    $urlRouterProvider.otherwise('/home');

    $stateProvider.state('home', {
        url: '/home',
        templateUrl: sfConfig.resourceBasePath + 'views/home.html',
        controller: 'HomeCtrl'
    }).state('search', {
        url: '/search',
        templateUrl: sfConfig.resourceBasePath + 'views/search.html',
        controller: 'SearchCtrl'
    }).state('searchKeyword', {
        url: '/search/:keyword',
        templateUrl: sfConfig.resourceBasePath + 'views/search.html',
        controller: 'SearchCtrl'
    }).state('detail', {
        url: '/detail/:betId',
        templateUrl: sfConfig.resourceBasePath + 'views/detail.html',
        controller: 'DetailCtrl'
    });

}).run(function($rootScope, StateService, sfConfig, $state) {
    if (sfConfig.newBetId) {
        window.location.hash = 'detail/' + sfConfig.newBetId;
    }
    //observe state changes manipulate fiters
    $rootScope.$on('$stateChangeStart', StateService.onStateChangeStartHandler);
});

'use strict';

/**
 * @ngdoc function
 * @name unileverApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the unileverApp
 */
angular.module('unileverApp')
  .controller('MainCtrl', ['$scope', '$state', 'sfConfig',
    function($scope, $state, sfConfig) {
        $scope.sfConfig = sfConfig;
        
        $scope.search = function(keyword) {
            $state.go('searchKeyword', {'keyword': keyword});
        };

        $scope.go = function(path, params) {
            $state.go(path, params);
        };

        $scope.showLoader = false;
        $scope.$on('showLoader', function() {
            $scope.showLoader = true;
        });
        $scope.$on('hideLoader', function() {
            $scope.showLoader = false;
        });
        $scope.$on('showDialogLoader', function() {
            jQuery('.modal-backdrop:visible').css('z-index', 2);
        });
        $scope.$on('hideDialogLoader', function() {
            jQuery('.modal-backdrop:visible').css('z-index', 0);
        });

    }
  ]);

'use strict';

/**
 * @ngdoc function
 * @name unileverApp.controller:HomeCtrl
 * @description
 * # HomeCtrl
 * Controller of the unileverApp
 */
angular.module('unileverApp')
    .controller('HomeCtrl', ['$scope', '$rootScope', '$stateParams', 'SearchService', '$state', 'StateService', 'UtilService',
        function($scope, $rootScope, $stateParams, SearchService, $state, StateService, UtilService) {
            var parseData = function(result) {
				
                var res = {
                    betsIamMemberOf: [],
					betsIamMemberOfArchived: [],
                    betsIamOwnerOf: [],
                    betsIamOwnerOfArchived: []
                };
				
                for (var i = 0; i < result.data.betsIamOwnerOf.length; i++) {
                    if (result.data.betsIamOwnerOf[i].betActive === true) {
                        res.betsIamOwnerOf.push(result.data.betsIamOwnerOf[i]);
                    } else {
                        res.betsIamOwnerOfArchived.push(result.data.betsIamOwnerOf[i]);
                    }
                }
				
				for (var i = 0; i < result.data.betsIamMemberOf.length; i++) {
                    if (result.data.betsIamMemberOf[i].betActive === true) {
                        res.betsIamMemberOf.push(result.data.betsIamMemberOf[i]);
                    } else {
                        res.betsIamMemberOfArchived.push(result.data.betsIamMemberOf[i]);
                    }
                }
				
				
                $scope.myBETs = res;
				
				$scope.BETsIamMemberOf = $scope.getMyBETs();
                $scope.BETsIOwn = $scope.getBETsIOwn();
				
                $scope.$emit('hideLoader');                
            };

            $scope.getBETsIOwn = function() {
                return $scope.state.activeSelected ? $scope.myBETs.betsIamOwnerOf.slice(0) : $scope.myBETs.betsIamOwnerOfArchived.slice(0);
            };
			
			$scope.getMyBETs = function() {
                return $scope.state.activeMemberSelected ? $scope.myBETs.betsIamMemberOf.slice(0) : $scope.myBETs.betsIamMemberOfArchived.slice(0);
            };

            $scope.setActive = function(active) {
                if ($scope.state.activeSelected !== active) {
                    $scope.state.activeSelected = active;
					$scope.state.activeMemberSelected = active;
                    $scope.BETsIOwn = $scope.getBETsIOwn();
					$scope.BETsIamMemberOf = $scope.getMyBETs();
                }
            };
			
			$scope.setActiveBetsIamMemberOf = function(active){
				if ($scope.state.activeMemberSelected !== active) {
                    $scope.state.activeMemberSelected = active;
					$scope.state.activeSelected = active;
                    $scope.BETsIamMemberOf = $scope.getMyBETs();
					$scope.BETsIOwn = $scope.getBETsIOwn();
                }
			}

            $scope.changeSort = function(listName, field) {
                if ($scope.state[listName]) {
                    if ($scope.state[listName].field === field) {
                        $scope.state[listName].reverse = !$scope.state[listName].reverse;
                    } else {
                        $scope.state[listName].field = field;
                        $scope.state[listName].reverse = false;
                    }
                } else {
                    console.warn('Invalid list name');
                }
            };
            /**
             * Handler for rejected promises.
             *
             * Should display dialog with error message
             *
             * @param {String} message
             * @returns {void}
             */
            function handleError(message) {
                console.warn(message);
            }

            function init() {
                console.log('HOME - INIT');
                $scope.$emit('showLoader');
                UtilService.fixedHeader($scope);

                //init data sets
                $scope.myBETs = {
                    betsIamMemberOf: [],
					betsIamMemberOfArchived : [],
                    betsIamOwnerOf: [],
                    betsIamOwnerOfArchived: []
                };
                $scope.BETsIOwn = [];
                $scope.state = StateService.getHomeState();
				$scope.searchstate = StateService.getSearchState();
                $scope.keyWord = null;
                $scope.getMyBets();
            }

            $scope.getMyBets = function() {
                SearchService.getMyBets().then(parseData, handleError);
            };


            // angular.element($window).bind('resize', function() {
            //     if ($scope.pageSize !== psSearch.calculatePageSize()) {
            //         $scope.search($scope);
            //     }
            // });

            init();
        }
    ]);
'use strict';

/**
 * @ngdoc function
 * @name unileverApp.controller:SearchCtrl
 * @description
 * # SearchCtrl
 * Controller of the unileverApp
 */
angular.module('unileverApp')
    .controller('SearchCtrl', ['$scope', '$rootScope', '$window', '$stateParams', 'SearchService', 'BETAccessService',
        '$state', 'StateService', 'UtilService',
        function($scope, $rootScope, $window, $stateParams, SearchService, BETAccessService, $state, StateService, UtilService) {

            /**
             * Handler for rejected promises.
             *
             * Should display dialog with error message
             *
             * @param {String} message
             * @returns {void}
             */
            var handleError = function(message) {
                $scope.infiniteBusy = false;
                console.warn(message);
                $scope.$emit('hideLoader');
            };

            var parseData = function(result) {
				console.log('in parseData : ' + result.data.bets);
				
                //var items = result.data.bets || [];
				
				var itemsActive = result.data.betsActive || [];
				var itemsArchived = result.data.betsArchived || [];

                if ($scope.infinitePage === 1) {
                    //$scope.bets = items;
					$scope.bets = itemsActive;
                    setSubCategoryTitle();
                    setBrandTitle();
                    if ($scope.reloadFilters !== null) {
                        for (var i = 0; i < result.data.filters.length; i++) {
                            var filter = result.data.filters[i];
                            if ($scope.reloadFilters === filter.filterName) {
                                $scope.filters[filter.filterName] = filter;
                            }
                        }
                    }
                    $scope.reloadFilters = null;
                } 
				
				//else {
                    /*for (var j = 0; j < items.length; j++) {
                        $scope.bets.push(items[j]);
                    }*/
					//for (var j = 0; j < itemsActive.length; j++) {
                    //    $scope.bets.push(itemsActive[j]);
                    //}
                //}
					
				for(var i = 0; i < itemsActive.length; i++){
					$scope.res.betsActive.push(itemsActive[i]);
				}
				
				for(var i = 0; i < itemsArchived.length; i++){
					$scope.res.betsArchived.push(itemsArchived[i]);
				}
					
				/*for (var i = 0; i < items.length; i++) {
                    if (items[i].betActive === true) {
                        $scope.res.betsActive.push(items[i]);
                    } else {
                        $scope.res.betsArchived.push(items[i]);
                    }
                }*/
				
				$scope.allBETs = $scope.res;
				$scope.bets = $scope.getBets();
			
				console.log('$scope.bets.length ' + $scope.bets.length);
				console.log('$scope.pageSize ' + $scope.pageSize);
			
				if ($scope.bets.length >= $scope.pageSize) {
                    $scope.scrollDisabled = false;
                } else {
                    $scope.scrollDisabled = true;
                }
				
                $scope.infiniteBusy = false;
                $scope.$emit('hideLoader');
            };

			$scope.getBets = function() {
				console.log('in getBets : ' + $scope.searchState.activeSelected);
                return $scope.searchState.activeSelected ? $scope.allBETs.betsActive.slice(0) : $scope.allBETs.betsArchived.slice(0);
            };
			
			$scope.setSearchActive = function(active) {
				console.log('in setSearchActive : ' + active);
                if ($scope.searchState.activeSelected !== active) {
                    $scope.searchState.activeSelected = active;
                    $scope.bets = $scope.getBets();
					
					if ($scope.bets.length >= $scope.pageSize) {
						$scope.scrollDisabled = false;
					} else {
						$scope.scrollDisabled = true;
					}
					console.log('in setSearchActive : ' + $scope.bets.length);
                }
            };

            var setTitle = function() {
                if ($scope.keyword !== null && $scope.keyword !== '' && $scope.keyword !== undefined) {
                    $scope.searchResultTitle = 'Search results for "' + $scope.keyword + '".';
                } else {
                    $scope.searchResultTitle = 'Browse all';
                }
            };

            var setSubCategoryTitle = function() {
                if ($scope.selectedCategory.value !== '') {
                    $scope.subCategoryTitle = 'Filter by: ' + $scope.selectedCategory.label;
                } else {
                    $scope.subCategoryTitle = 'Filter by category';
                }
            };
            var setBrandTitle = function() {
                if ($scope.selectedBrand.value !== '') {
                    $scope.brandTitle = 'Filter by: ' + $scope.selectedBrand.label;
                } else {
                    $scope.brandTitle = 'Filter by brand';
                }
            };

            var setMessage = function(message) {
                $scope.message = message;
            };

            var init = function() {
				console.log('SEARCH - INIT');
                $scope.$emit('showLoader');
                $scope.message = '';
                if ($stateParams.keyword) {
                    $scope.keyword = $stateParams.keyword;
                } else {
                    $scope.keyword = null;
                }

				$scope.res = {
                    betsActive: [],
                    betsArchived: []
                };
				
                $scope.showCategory = false;
                $scope.showBrand = false;
                $scope.selectedCategory = {
                    value: ''
                };
                $scope.selectedBrand = {
                    value: ''
                };
                $scope.reloadFilters = 'Categories';
                $scope.state = {
                    field: 'betLastUpdated',
                    reverse: true
                };
                $scope.pageSize = SearchService.calculatePageSize();
                $scope.infinitePage = 1;
                $scope.filters = {
                    Categories: {
                        filterValues: []
                    },
                    Brands: {
                        filterValues: []
                    }
                };

                $scope.infiniteBusy = false;
                $scope.scrollDisabled = true;
                $scope.searchKeyword = $scope.keyword;
				$scope.searchState = StateService.getSearchState();

                setTitle();
                setSubCategoryTitle($scope.selectedCategory);
                setBrandTitle($scope.selectedBrand);
                searchBets($scope.searchKeyword, true, true);

                var dialogInfo = jQuery('#dialogInfo');
                dialogInfo.on('hidden.bs.modal', function (e) {
                    $scope.message = '';
                });
                $scope.$watch('message', function(newValue, oldValue) {
                    if (newValue !== '' && newValue !== undefined && newValue !== null) {
                        dialogInfo.modal('show');
                    }
                });
            };

            var searchBets = function(keyword, withFilters, resetPageNumber) {
				
				console.log('in searchBets : ' + keyword + ','+withFilters + ','+resetPageNumber);
				
                if ($scope.infiniteBusy) {
                    return;
                }
                $scope.infiniteBusy = true;
                $scope.$emit('showLoader');
                $scope.searchKeyword = keyword;
                if (resetPageNumber) {
                    $scope.infinitePage = 1;
                } else {
                    $scope.infinitePage++;
                }
				
				console.log('SearchService.searchBets : ' + keyword + ','+$scope.selectedBrand.value + ','+$scope.selectedCategory.value);
				
                SearchService.searchBets($scope.selectedBrand.value, $scope.selectedCategory.value, keyword, $scope.pageSize, $scope.infinitePage, withFilters, !$scope.state.reverse, $scope.state.field).then(parseData, handleError);
            };

            $scope.nextPage = function() {
                if ($scope.infiniteBusy) {
                    return;
                }
                searchBets($scope.searchKeyword, false, false);
            };

            $scope.changeSort = function(field) {
                if ($scope.infiniteBusy) {
                    return;
                }
                if ($scope.state.field === field) {
                    $scope.state.reverse = !$scope.state.reverse;
                } else {
                    $scope.state.field = field;
                    $scope.state.reverse = false;
                }
				
				// filtering fix : reset actual results
					$scope.res = {
						betsActive: [],
						betsArchived: []
					};
				//
				
                searchBets($scope.searchKeyword, false, true);
            };

            $scope.selectCategory = function(value) {
                if ($scope.selectedCategory !== value) {
                    $scope.selectedCategory = value;
                    $scope.selectedBrand = {
                        value: ''
                    };
                    $scope.reloadFilters = 'Brands';
					// filtering fix : reset actual results
					$scope.res = {
						betsActive: [],
						betsArchived: []
					};
					//
                    searchBets($scope.searchKeyword, true, true);
                }
                $scope.showCategory = false;
                $scope.showBrand = false;
            };

            $scope.selectBrand = function(value) {
                if ($scope.selectedBrand !== value) {
                    $scope.selectedBrand = value;
					// filtering fix : reset actual results
					$scope.res = {
						betsActive: [],
						betsArchived: []
					};
					//
                    searchBets($scope.searchKeyword, false, true);
                }
                $scope.showCategory = false;
                $scope.showBrand = false;
            };

            var pendingRequests = {};
            $scope.requestAccess = function(betId, idx) {
                if (pendingRequests[betId]) {
                    return false;
                }
                setMessage('Pending request');
                pendingRequests[betId] = true;
                var handleResponse = function(result) {
                    $scope.bets[idx].betHasAccessPending = true;
                    delete(pendingRequests[betId]);
                    setMessage('Your request to access this toolkit has been submitted and is currently pending approval from the Toolkit owner. The Toolkit will appear on your homepage when accepted.');
                };
                BETAccessService.requestAccess(betId).then(handleResponse, handleError);
            };
            init();
        }
    ]);
'use strict';

/**
 * @ngdoc function
 * @name unileverApp.controller:DetailsCtrl
 * @description
 * # DetailsCtrl
 * Controller of the unileverApp
 */
angular.module('unileverApp')
  .controller('DetailCtrl', ['$scope', '$rootScope', '$window', '$stateParams', 'BETService', 'BETAccessService',
        '$state', 'StateService', 'UtilService', '$http', '$timeout', '$sce',
        function($scope, $rootScope, $window, $stateParams, BETService, BETAccessService, $state, StateService, UtilService, $http, $timeout, $sce) {
            console.warn('detail');
            var PDFpreviewLoaded = false;
            var refreshChatter = function(doNotResetPostSection) {
                jQuery('.feedfilters .zen-checked a').click();
                if (!doNotResetPostSection) {
                    jQuery('#publisherAttachTextPost').click();
                }
            };

            var handleError = function(obj) {
                console.warn(obj.message);
                console.warn(obj.data.message);
                pendingRequest = false;
                $scope.$emit('hideLoader');
                $scope.$emit('hideDialogLoader');
                if (obj.event.method === 'getBETDetails') {
                  $scope.go('home');                  
                }
            };
            var hidePDFPreview = function() {
                $scope.presentationCheckStatus = 'Presentation is not available';
                $scope.downloadPresentationButton = 'Click here for BET templates';
                $scope.downloadPresentationButtonLink = $scope.sfConfig.BETTemplateLink;
                $scope.showPDF = false;
            };

            var parseData = function(result) {
                console.warn(result);
                $scope.bet = result.data.bet;
				
				if($scope.bet.assetPrioritySet){
					$scope.state.field = 'displayOrder';
					$scope.state.reverse = false;
				}

                if (!$scope.betRefresh) {
                    //init chatter
                    if ($scope.bet && $scope.bet.betChatterGroupId) {
                        console.log('chatter init');
                        var chatterLink = $scope.sfConfig.environment === 'SF' ? '/apex/BET_Chatter?gid=' + $scope.bet.betChatterGroupId : 'views/chatter.html';
                        var chatterBoxId = '#chatterFeed';
                        var chatterCallback = function() {
                            jQuery('#chatter-box').css({display: 'block'});
                            jQuery('#chatter-loading').css({display: 'none'});
                        };
                        var chatterErrorCallback = function() {
                            jQuery('#chatter-box').css({display: 'none'});
                            jQuery('#chatter-loading').css({display: 'block'}).html('<h4>ERROR: Please contact with system administrator</h4>');
                        };
                        var fixScript = function(str) {
                            return str.replace('if (tmp_bodyOnLoad', 'if (tmp_bodyOnLoad && tmp_bodyOnLoad.toString().indexOf("tmp_bodyOnLoad")===-1');
                        };
                        UtilService.loadHTML(chatterBoxId, chatterLink, chatterCallback, fixScript, chatterErrorCallback);
                    }
                    // init presentation
                    if ($scope.bet && $scope.bet.betPresentationId) {
                        _initPresentation();
                    } else {
                        $scope.presentationCheckStatus = 'Presentation is not available';
                        $scope.downloadPresentationButton = 'Click here for BET templates';
                        $scope.downloadPresentationButtonLink = $scope.sfConfig.BETTemplateLink;
                    }
                }
                //reload presentation
                if ($scope.reloadPresentation) {
                    $scope.state.activeTab = 'info';
                    _initPresentation();
                }
                $scope.memberRole = '';
                if (result.data && result.data.members && result.data.members.memberRole) {
                    $scope.memberRole = result.data.members.memberRole;
                } else {
                    $scope.memberRole = '';
                }

                if ($scope.bet) {
                    checkPrivileges();
                }
				
				if ($scope.bet) {
					calculateProgressBar();
				}
				
                $scope.betRefresh = false;
                $scope.reloadPresentation = false;
                $scope.$emit('hideLoader');
            };
			
			var calculateProgressBar = function() {
				console.log('In calculateProgressBar ' + $scope.bet.totalActualAssets + ' / ' + $scope.bet.totalExpectedAssets);
				var value = 0;
				if($scope.bet.totalExpectedAssets != 0){
					value = parseInt(($scope.bet.totalActualAssets * 100)/$scope.bet.totalExpectedAssets);
				}
				if(value > 100) {
					value = 100;
				}
				$scope.dynamic = value;
			};

            var checkPrivileges = function() {
                $scope.hideRemoveMe = !$scope.memberRole || $scope.bet.betOwner;
                $scope.assetModify = ($scope.sfConfig.modifyAll || $scope.bet.betOwner || $scope.memberRole === 'Manager') && !$scope.sfConfig.betOperationAdmin;
                $scope.canUploadAsset = ($scope.sfConfig.modifyAll || $scope.bet.betOwner || $scope.memberRole) && !$scope.bet.archived && !$scope.sfConfig.betOperationAdmin;
                //check tab
                if ($scope.canUploadAsset && !$scope.assetModify) {
                    if ($scope.state.activeTab === 'draft' || $scope.state.activeTab === 'approved') {
                        $scope.canUploadAsset = false;
                    }
                }
                $scope.canCreateAssetFromChatter = $scope.canUploadAsset && $scope.state.activeTab === 'draft' && !$scope.sfConfig.betOperationAdmin;
                $scope.hideSettings = !$scope.sfConfig.modifyAll && !$scope.bet.betOwner && $scope.memberRole !== 'Manager';
				
				console.log('betOperationAdmin : ' + $scope.sfConfig.betOperationAdmin);
				console.log('$scope.assetModify : ' + $scope.assetModify);
				console.log('$scope.canUploadAsset : ' + $scope.canUploadAsset);
            };

            var checkFileStatus = function(url) {
                var req = {
                    method: 'GET',
                    url: url,
                    headers: {
                        Authorization: 'Bearer ' + ApiSessionId
                    }
                };
                $http(req).success(function(result, b, c, d) {
                    $scope.downloadPresentationButton = 'Download BET Presentation';
                    $scope.downloadPresentationButtonLink = result.downloadUrl;
                    if (result.pdfRenditionStatus === 'Na' && result.fileType.toLowerCase() === 'pdf') {
                        $scope.showPDF = true;
                        DEFAULT_URL = url + '/content';
                        if (PDFpreviewLoaded) {
                            webViewerInitialized();
                        } else {
                            webViewerLoad();
                            PDFpreviewLoaded = true;
                        }
                    } else if (result.pdfRenditionStatus === 'Processing') {
                        $scope.presentationCheckStatus = 'Processing File <br/> You can continue working. Your file preview will display here when it\s ready.';
                        $timeout(function() {
                            console.log('checkOnceAgain');
                            checkFileStatus(url);
                        }, 30000);
                    } else if (result.pdfRenditionStatus === 'Success') {
                        $scope.showPDF = true;
                        DEFAULT_URL = url + '/rendition?type=PDF';
                        if (PDFpreviewLoaded) {
                            webViewerInitialized();
                        } else {
                            webViewerLoad();
                            PDFpreviewLoaded = true;
                        }
                    } else {
                        $scope.presentationCheckStatus = 'Presentation preview is not available';
                    }
                }).error(function(result, b, c, d) {
                    $scope.presentationCheckStatus = 'Cannot check presentation state';
                    console.error(result);
                });
            };

            var _initPresentation = function() {
                $scope.showPDF = false;
                if ($scope.sfConfig.environment === 'SF') {
                    if (!$scope.bet || !$scope.bet.betPresentationId) {
                        hidePDFPreview();
                    } else {
                        var url = '/services/data/v32.0/chatter/files/' + $scope.bet.betPresentationId;
                        checkFileStatus(url);
                    }
                } else {
                    $scope.downloadPresentationButton = 'Download BET Presentation';
                    $scope.downloadPresentationButtonLink = '#2';
                    $timeout(function() {
                        $scope.showPDF = true;
                        console.info('PDF - webViewerLoad');
                        if (PDFpreviewLoaded) {
                            webViewerInitialized();
                        } else {
                            webViewerLoad();
                            PDFpreviewLoaded = true;
                        }
                    }, 5000);
                }
            };

            $scope.setActive = function(tabName) {
                if ($scope.state.activeTab !== tabName) {
                    console.log(tabName);
                    $scope.assetListHead = '';
                    $scope.state.activeTab = tabName;
                    if (tabName !== 'info') {
                        //clear list
                        $scope.assets = [];
                        $scope.infinitePage = 1;
                        $scope.infiniteBusy = false;
                        $scope.scrollDisabled = true;
                        switch (tabName) {
                            case 'approved':
                                $scope.assetListHead = $sce.trustAsHtml('Assets provided and approved by Brand Development for use in the market. Please check with the BET owner if there is any doubt as to which assets to use for your market.');
								$scope.selectedAssetTab = 'approved';
                                break;
                            case 'sharing':
                                $scope.assetListHead = $sce.trustAsHtml('Activation examples from the markets. These files are for information and inspiration only and have not been approved by BD for use in other markets. Please contact the BET owner for further clarification.');
								$scope.selectedAssetTab = 'sharing';
                                break;
                            case 'draft':
                                $scope.assetListHead = $sce.trustAsHtml('Work in Progress and draft files, NOT suitable for use in market. Please contact the BET owner for further clarification.<br/><br/>Any files uploaded which have not been labelled can be found using the “Show Unlabelled Files” button.' + (!$scope.assetModify?' Please contact BET owner.':''));
								$scope.selectedAssetTab = 'draft';
                                break;
                            default: 
                                $scope.assetListHead = '';
                        }
                        checkPrivileges();
        //                setSubCategoryTitle($scope.selectedCategory);
        //                setBrandTitle($scope.selectedBrand);
                        searchAssets(true, true);
                    } else {
                        $scope.infiniteBusy = true;
                    }
                }
            };


            var init = function() {
                $scope.hideRemoveMe = true;
                $scope.canUploadAsset = false;
                $scope.$emit('showLoader');
                $scope.showPDF = false;
                $scope.assetModify = false;
                $scope.presentationCheckStatus = 'Checking Presentation status';
                $scope.downloadPresentationButton = '';
                $scope.downloadPresentationButtonLink = $scope.sfConfig.BETTemplateLink;
                $scope.assetListHead = '';      
				$scope.selectedAssetTab = '';
                $scope.memberUrl = '';
                $scope.settingsUrl = '';
                $scope.uploadAssetUrl = '';
				$scope.expectedAssetsUrl = '';
				$scope.reorderAssetsUrl = '';
                $scope.editAssetUrl = '';
                $scope.betMessage = '';
                $scope.showCategory = false;
                $scope.showBrand = false;
                $scope.selectedCategory = {
                    value: ''
                };
                $scope.selectedBrand = {
                    value: ''
                };
                $scope.infiniteBusy = true;
                $scope.chatterInfiniteBusy = true;                
                $scope.pageSize = 10;//SearchService.calculatePageSize();
                $scope.filters = {
                    'Media Types': {
                        filterValues: []
                    },
                    'Countries': {
                        filterValues: []
                    }
                };
			
				$scope.state = {
					activeTab: 'info',
					field: 'assetLastModifiedDate',
					reverse: true
				};
				
                $scope.chatterState = {
                    field: 'draftCreatedDate',
                    reverse: true
                };
                if ($stateParams.betId) {
                    $scope.betId = $stateParams.betId;
                } else {
                    console.warn('Missing Bet Id');
                    $scope.go('home');
                    return;
                }

                UtilService.listenForMessage($scope, _receiveMessage);
                getBETDetails($scope.betId);
                jQuery('#uploadAsset').on('hidden.bs.modal', function (e) {
                    $scope.clearUploadAssetUrl();
                    $scope.$apply();
                });
				jQuery('#setExpectedAssets').on('hidden.bs.modal', function (e) {
                    $scope.clearExpectedAssetUrl();
                    $scope.$apply();
                });
                $scope.$on(
                    '$destroy',
                    function() {
                        if (PDFpreviewLoaded) {
                           PDFView.initialized = false;
                       }
                    });
                $scope.uwChatterFileContainer = jQuery('#uwChatterFileContainer');
                $scope.chatterScrollDistance = 1;
            };

            var getBETDetails = function() {
                $scope.$emit('showLoader');
                BETService.getBETDetails($scope.betId).then(parseData, handleError);
            };

            var _receiveMessage = function(evt) {
                console.info('message received');
                console.log(evt);
                if (evt.data) {
                    switch (evt.data.action) {
                        case 'checkPrivileges':
                            _refreshBet();
                            break;
                        case 'saveBetPreferences':
                            //hide modal window
                            jQuery('.modal-bet').modal('hide');
                            $scope.clearSettingsUrl();
                            if(evt.data.moveHome) {
                                $scope.go('home');
                            } else {
								refreshChatter();
                                _refreshBet();
                            }
                            break;
                        case 'saveAsset':
                            //hide modal window
                            //jQuery('.modal-bet').modal('hide');
							jQuery('#uploadAsset').modal('hide');
                            //refresh chatter
                            refreshChatter();
                            if (evt.data.presentation || evt.data.msg) {
                                _refreshBet(true);
                            } else {
								_refreshBet(true);
                                //searchAssets(true, true);
                            }
                            if (evt.data.msg) {
                                $scope.betMessage = evt.data.msg;
                                $scope.$apply();
                                jQuery('#betMessage').modal('show');
                            }
                            break;
						case 'editAsset':
							jQuery('#editasset').modal('hide');
                            refreshChatter();
                            if (evt.data.presentation || evt.data.msg) {
                                _refreshBet(true);
                            } else {
								_refreshBet(true);
                            }
                            if (evt.data.msg) {
                                $scope.betMessage = evt.data.msg;
                                $scope.$apply();
                                jQuery('#betMessage').modal('show');
                            }
                            break;
                        case 'saveAssets':
                            //hide modal window
                            //jQuery('.modal-bet').modal('hide');
							jQuery('#uploadAsset').modal('hide');
                            //refresh chatter
                            refreshChatter();
                            _refreshBet(true);
							if (evt.data.msg) {
                                $scope.betMessage = evt.data.msg;
                                $scope.$apply();
                                jQuery('#betMessage').modal('show');
                            }
                            break;
            			case 'saveExpectedAssets':
							//jQuery('#setExpectedAssets').hide();
							jQuery('.modal-bet').modal('hide');
                            //refresh chatter
                            refreshChatter();
                            _refreshBet(true);
                            break;
						case 'saveAssetsOrder':
							//jQuery('#reorderAssets').hide();
							jQuery('.modal-bet').modal('hide');
                            //refresh chatter
                            refreshChatter();
                            _refreshBet(true);
                            break;
                        default:
                    }
                }
            };

            var _refreshBet = function(reloadPresentation) {
                $scope.betRefresh = true;
                $scope.reloadPresentation = reloadPresentation;
                getBETDetails();
            };

            var parseAssetData = function(result) {
                var items = result.data.assets || [];

                if ($scope.infinitePage === 1) {
                    $scope.assets = items;
//                    setSubCategoryTitle();
//                    setBrandTitle();
                    for (var i = 0; i < result.data.filters.length; i++) {
                        var filter = result.data.filters[i];
                        $scope.filters[filter.filterName] = filter;
                    }
                } else {
                    for (var j = 0; j < items.length; j++) {
                        $scope.assets.push(items[j]);
                    }
                }
                if (items.length >= $scope.pageSize) {
                    $scope.scrollDisabled = false;
                } else {
                    $scope.scrollDisabled = true;
                }
                $scope.infiniteBusy = false;
                $scope.$emit('hideLoader');
            };

            // var setSubCategoryTitle = function() {
            //     if ($scope.selectedCategory.value !== '') {
            //         $scope.subCategoryTitle = 'Filter by: ' + $scope.selectedCategory.label;
            //     } else {
            //         $scope.subCategoryTitle = 'Filter by sub-category';
            //     }
            // };
            // var setBrandTitle = function() {
            //     if ($scope.selectedBrand.value !== '') {
            //         $scope.brandTitle = 'Filter by: ' + $scope.selectedBrand.label;
            //     } else {
            //         $scope.brandTitle = 'Filter by brand';
            //     }
            // };

            var searchAssets = function(withFilters, resetPageNumber) {
                if ($scope.infiniteBusy) {
                    return;
                }
                $scope.infiniteBusy = true;
                $scope.$emit('showLoader');
                if (resetPageNumber) {
                    $scope.infinitePage = 1;
                } else {
                    $scope.infinitePage++;
                }

                if ($scope.state.activeTab === 'approved') {
                    BETService.getBETBDAssets($scope.bet.betId, $scope.selectedCategory.value, $scope.selectedBrand.value, $scope.pageSize, $scope.infinitePage, withFilters, !$scope.state.reverse, $scope.state.field).then(parseAssetData, handleError);
                } else if ($scope.state.activeTab === 'sharing') {
                    BETService.getBETBBAssets($scope.bet.betId, $scope.selectedCategory.value, $scope.selectedBrand.value, $scope.pageSize, $scope.infinitePage, withFilters, !$scope.state.reverse, $scope.state.field).then(parseAssetData, handleError);
                } else if ($scope.state.activeTab === 'draft') {
                    BETService.getBETDraftAssets($scope.bet.betId, $scope.selectedCategory.value, $scope.selectedBrand.value, $scope.pageSize, $scope.infinitePage, withFilters, !$scope.state.reverse, $scope.state.field).then(parseAssetData, handleError);
                }
            };

            $scope.nextPage = function() {
                if ($scope.infiniteBusy) {
                    return;
                }
                searchAssets(false, false);
            };

            $scope.changeSort = function(field) {
                if ($scope.infiniteBusy) {
                    return;
                }
                if ($scope.state.field === field) {
                    $scope.state.reverse = !$scope.state.reverse;
                } else {
                    $scope.state.field = field;
                    $scope.state.reverse = false;
                }
                searchAssets(false, true);
            };

            $scope.selectCategory = function(value) {
                if ($scope.selectedCategory !== value) {
                    $scope.selectedCategory = value;
                    searchAssets(true, true);
                }
                $scope.showCategory = false;
                $scope.showBrand = false;
            };

            $scope.selectBrand = function(value) {
                if ($scope.selectedBrand !== value) {
                    $scope.selectedBrand = value;
                    searchAssets(true, true);
                }
                $scope.showCategory = false;
                $scope.showBrand = false;
            };

            var pendingRequest = false;
            $scope.removeMe = function() {
                if (pendingRequest) {
                    return false;
                }
                pendingRequest = true;
                $scope.$emit('showLoader');
                var handleResponse = function(result) {
                    pendingRequest = false;
                    console.log(result);
                    $scope.go('home');
                };
                BETAccessService.removeMe($scope.bet.betId).then(handleResponse, handleError);
            };

            var assetToRemove = null;
            $scope.setAssetToRemove = function(idx) {
                console.log(idx);
                assetToRemove = idx;
            };

            $scope.deleteBETAsset = function() {
                if (pendingRequest) {
                    return false;
                }
                var asset = $scope.assets[assetToRemove];
                if (!asset) {
                    return false;
                }
                pendingRequest = true;
                $scope.$emit('showLoader');
                var handleResponse = function(result) {
                    if (result.data && result.data.refreshPresentation) {
                        hidePDFPreview();
                        refreshChatter(true);
                    }
                    $scope.assets.splice(assetToRemove, 1);
                    assetToRemove = null;
                    pendingRequest = false;
                    $scope.$emit('hideLoader');
                };
                BETService.deleteBETAsset($scope.bet.betId, asset.assetId).then(handleResponse, handleError);
            };

            $scope.setEditAsset = function(assetId) {
                $scope.editAssetUrl = '/apex/Bet_EditAsset?id=' + assetId;
            };

            $scope.setUploadAssetUrl = function() {
                $scope.uploadAssetUrl = '/apex/uw_CustomAssetUpload?id=' + $scope.bet.betChatterGroupId+'&assetTab='+$scope.selectedAssetTab;
            };

            $scope.clearUploadAssetUrl = function() {
                $scope.uploadAssetUrl = '';
            };
			
			$scope.setExpectedAssetsUrl = function() {
				$scope.expectedAssetsUrl = '/apex/BET_UpdateExpectedAssets?id=' + $scope.bet.betId;
			}
			
			$scope.clearExpectedAssetUrl = function() {
				$scope.expectedAssetsUrl = '';
			};
			
			$scope.setReorderAssetsUrl = function() {
				$scope.reorderAssetsUrl = '/apex/BET_AssetsOrder?betId=' + $scope.bet.betId;
			}
			
			$scope.clearReorderAssetUrl = function() {
				$scope.reorderAssetsUrl = '';
			};

            $scope.setMemberUrl = function() {
                $scope.memberUrl = '/apex/bet_managemembers?bet=' + $scope.bet.betId;
            };

            $scope.clearMemberUrl = function() {
                $scope.memberUrl = '';
            };
            $scope.setSettingsUrl = function() {
                $scope.settingsUrl = '/apex/uw_BetEdit?id=' + $scope.bet.betId;
            };

            $scope.clearSettingsUrl = function() {
                $scope.settingsUrl = '';
            };
//
// chatter assets
//
            var parseChatterAssetData = function(result) {
                var items = result.data.drafts || [];

                if ($scope.chatterInfinitePage === 1) {
                    $scope.chatterAssets = items;
                } else {
                    for (var i = 0; i < items.length; i++) {
                        $scope.chatterAssets.push(items[i]);
                    }
                }
                if (items.length >= $scope.pageSize) {
                    $scope.chatterScrollDisabled = false;
                } else {
                    $scope.chatterScrollDisabled = true;
                }
                $scope.chatterInfiniteBusy = false;
                $scope.$emit('hideDialogLoader');
            };

            var searchChatterAssets = function(resetPageNumber) {
                if ($scope.chatterInfiniteBusy) {
                    return;
                }
                $scope.chatterInfiniteBusy = true;
                $scope.$emit('showDialogLoader');
                if (resetPageNumber) {
                    $scope.chatterAssets = [];
                    $scope.chatterInfinitePage = 1;
                } else {
                    $scope.chatterInfinitePage++;
                }

                BETService.getChatterAssets($scope.bet.betId, $scope.pageSize, $scope.chatterInfinitePage, !$scope.chatterState.reverse, $scope.chatterState.field).then(parseChatterAssetData, handleError);
            };

            $scope.chatterNextPage = function() {
                if ($scope.chatterInfiniteBusy) {
                    return;
                }
                searchChatterAssets(false);
            };

            $scope.changeChatterSort = function(field) {
                if ($scope.chatterInfiniteBusy) {
                    return;
                }
                if ($scope.chatterState.field === field) {
                    $scope.chatterState.reverse = !$scope.chatterState.reverse;
                } else {
                    $scope.chatterState.field = field;
                    $scope.chatterState.reverse = false;
                }
                searchChatterAssets(true);
            };

            $scope.createAssetFromChatterFile = function(chatterAssetId) {
                if (pendingRequest) {
                    return false;
                }
                pendingRequest = true;
                $scope.$emit('showDialogLoader');
                var handleResponse = function(result) {
                    $scope.$emit('hideDialogLoader');
                    pendingRequest = false;
                    
                    //hide modal dialog
                    jQuery('.modal-bet').modal('hide');
                    //refresh draft list and order it by last updated date
                    $scope.state.field = 'assetLastModifiedDate';
                    $scope.state.reverse = true;
                    searchAssets(true, true);
                    //open edit asset dialog
                    $scope.setEditAsset(result.data.draftAssetId);
                    jQuery('#editasset').modal('show');
                };
                BETService.chatterFileToDraftAsset($scope.bet.betId, chatterAssetId).then(handleResponse, handleError);
            };

            $scope.showChatterAssets = function() {
                jQuery('#chatterassets').modal('show');                
                $scope.chatterInfiniteBusy = false;
                searchChatterAssets(true);
            };
            init();
        }]);

'use strict';

/**
 * @ngdoc directive
 * @description
 * # uwTooltip
 */
angular.module('unileverApp')
    .directive('uwTooltip', ['$timeout', function($timeout) {
        var checkEllipsis = function(el, text) {
            var e = el[0];
            text = text || el.text();
            if (e.offsetWidth < e.scrollWidth) {
                el.addClass('uw-ellipsis').qtip({
                    content: text,
                    style: {
                        classes: 'qtip-bet'
                    },
                    position: {
                        my: 'bottom center', // Position my top left...
                        at: 'top center', // at the bottom right of...
                        target: el // my target
                    }
                });
            }
        };

        return {
            restrict: 'A',
            link: function(scope, element, attrs) {
                $timeout(function() {
                    checkEllipsis(element, attrs.uwTooltipText);
                }, 1);
            }
        };
    }]);

'use strict';

/**
 * @ngdoc directive
 * @description
 * # uwTooltip
 */
angular.module('unileverApp')
    .directive('uwCountryTooltip', ['$timeout', function($timeout) {
        var checkEllipsis = function(el, text) {
            var e = el[0];
            text = text || el.text();
            if (e.offsetWidth < e.scrollWidth || text.indexOf(';') !== -1) {
                el.addClass('uw-ellipsis').qtip({
                    content: text.replace(';', ', '),
                    style: {
                        classes: 'qtip-bet'
                    },
                    position: {
                        my: 'bottom center', // Position my top left...
                        at: 'top center', // at the bottom right of...
                        target: el // my target
                    }
                });
            }
        };

        return {
            restrict: 'A',
            transclude: true,
            link: function(scope, element, attrs) {
                if (attrs.uwCountryTooltip && attrs.uwCountryTooltip.indexOf(';') !== -1) {
                    element.html('Multi');
                } else {
                    element.html(attrs.uwCountryTooltip);
                }
                $timeout(function() {
                    checkEllipsis(element, attrs.uwCountryTooltip);
                }, 1);
            }
        };
    }]);

'use strict';

/**
 * @ngdoc directive
 * @description
 * # uwBrandIcon
 */
angular.module('unileverApp')
    .directive('uwBrandIcon', [function() {
/*

uw-brand-icon uw-brand-icon-bet="{{bet.betIconLocation}}"

 */

        return {
            restrict: 'A',
            link: function(scope, element, attrs) {
                if (attrs.uwBrandIcon) {
                    attrs.$set('style', 'background-image: url(/servlet/servlet.FileDownload?file=' + attrs.uwBrandIcon + ')');
                } else {
                    attrs.$addClass('def-icon');
                }
            }
        };
    }]);

'use strict';

/**
 * @ngdoc directive
 * @description
 * # uwBrandBanner
 */
angular.module('unileverApp')
    .directive('uwBrandBanner', [function() {
/*

uw-brand-icon uw-brand-icon-bet="{{bet.betIconLocation}}"

 */

        return {
            restrict: 'A',
            link: function(scope, element, attrs) {
                attrs.$observe('uwBrandBanner', function(text) {
                    if (text) {
                        attrs.$set('style', 'background-image: url(/servlet/servlet.FileDownload?file=' + text + ');background-size:100% 100%;background-position: 0 0;');
                    } else {
                        attrs.$set('style', '');
                    }
                });
            }
        };
    }]);

'use strict';

/**
 * @ngdoc directive
 * @description
 * # uwTooltip
 */
angular.module('unileverApp')
    .directive('uwShowOnHoverParent', [function() {
        return {
            link: function(scope, element, attrs) {
                var parent = element.parents('.data-row');
                if (parent && parent.length > 0) {
                    element.css({display: 'none'});
                    parent.bind('mouseenter', function() {
                        element.show();
                    });
                    parent.bind('mouseleave', function() {
                        element.hide();
                    });
                }
            }
        };
    }]);

'use strict';

/**
 * @ngdoc filter
 * @name unileverApp.filter:uwUserName
 * @description
 * # uwUserName
 */
angular.module('unileverApp')
  .filter('uwUserName', function() {
    return function(text) {
      return String(text).replace('(Non Employee)', '');
    };
});

'use strict';

/**
 * @ngdoc service
 * @name unileverApp.BETAccessService
 * @description
 * # BETAccessService
 * Service in the unileverApp.
 */
angular.module('unileverApp')
    .service('BETAccessService', [
        'UtilService',
        function BETAccessService(UtilService) {
            /*
             * REMOTE ACTIONS
             */
            this.requestAccess = function(betId) {
                var source = 'uw_BETRemoteController.requestBETAccess';
                return UtilService.runRequest(source, arguments);
            };
            this.removeMe = function(betId) {
                var source = 'uw_BETRemoteController.removeMeFromBET';
                return UtilService.runRequest(source, arguments);
            };
        }
    ]);

'use strict';

/**
 * @ngdoc service
 * @name unileverApp.SearchService
 * @description
 * # SearchService
 * Service in the unileverApp.
 */
angular.module('unileverApp')
    .service('BETService', [
        'UtilService',
        function BETService(UtilService) {

            /*
             * REMOTE ACTIONS
             */
            this.getBETDetails = function(betId) {
                var source = 'uw_BETRemoteController.getBETDetails';
                return UtilService.runRequest(source, arguments);
            };

            this.getBETBBAssets = function(betId, mediaType, countryName, pageSize, pageNumber, withFilters, sortAsc, sortField) {
                var source = 'uw_BETRemoteController.getBETBBAssets';
                return UtilService.runRequest(source, arguments);
            };

            this.getBETBDAssets = function(betId, mediaType, countryName, pageSize, pageNumber, withFilters, sortAsc, sortField) {
                var source = 'uw_BETRemoteController.getBETBDAssets';
                return UtilService.runRequest(source, arguments);
            };

            this.getBETDraftAssets = function(betId, mediaType, countryName, pageSize, pageNumber, withFilters, sortAsc, sortField) {
                var source = 'uw_BETRemoteController.getBETDraftAssets';
                return UtilService.runRequest(source, arguments);
            };

            this.deleteBETAsset = function(betId, assetId) {
                var source = 'uw_BETRemoteController.deleteBETAsset';
                return UtilService.runRequest(source, arguments);
            };

            this.getChatterAssets = function(betId, pageSize, pageNumber, sortAsc, sortField) {
                var source = 'uw_BETRemoteController.getBETChatterFiles';
                return UtilService.runRequest(source, arguments);
            };
            this.chatterFileToDraftAsset = function(betId, feedItemId) {
                var source = 'uw_BETRemoteController.chatterFileToDraftAsset';
                return UtilService.runRequest(source, arguments);
            };
        }
    ]);

'use strict';

/**
 * @ngdoc service
 * @name unileverApp.StateService
 * @description
 * # StateService
 * Service in the unileverApp.
 */
angular.module('unileverApp')
        .service('StateService', [
            function StateService() {
                
                /**
                 * Handler called when there is transition form one state to another.
                 *                 * 
                 *
                 * @param  {Object} event     [description]
                 * @param  {Object} toState   [description]
                 * @param  {Object} toParams  [description]
                 * @param  {Object} fromState [description]
                 * @return {Bool}             [description]
                 */
                var _onStateChangeStartHandler = function(event, toState, toParams, fromState) {
                    var url = toState.url;
                    for (var i in toParams) {
                        url=url.replace(':'+i,toParams[i]);
                    }
                    url = '/apex/BET' + url;
                    if (window.ga) {
                        window.ga('send', 'pageview', {'page': url});
                    }
                    if (window._gaq) {
                        window._gaq.push(['_trackPageview', url]);
                    }
                    return true;
                };

                var _getHomeState = function() {
                    return {
                        betsIamMemberOf: {
                            field: 'betLastUpdated',
                            reverse: true
                        },
                        betsIamOwnerOf: {
                            field: 'betLastUpdated',
                            reverse: true
                        },
                        activeSelected: true,
						activeMemberSelected: true
                    };
                };
				
				var _getSearchState = function() {
                    return {
                        activeSelected: true
                    };
                };

                return {
                    onStateChangeStartHandler: _onStateChangeStartHandler,
                    getHomeState: _getHomeState,
					getSearchState: _getSearchState
                };
            }
        ]);
'use strict';
/**
 * @ngdoc service
 * @name unileverApp.SearchService
 * @description
 * # SearchService
 * Service in the unileverApp.
 */
angular.module('unileverApp')
    .service('SearchService', [
        'UtilService',
        function SearchService(UtilService) {

            /*
             * REMOTE ACTIONS
             */
            this.getMyBets = function() {
                var source = 'uw_BETRemoteController.getMyBETs';
                return UtilService.runRequest(source, arguments);
            };

            this.searchBets = function(brand, category, keyword, pageSize, pageNumber, withFilters, asc, field) {
                //var source = 'uw_BETRemoteController.search';
				var source = 'uw_BETRemoteController.searchActiveAndArchived';
                return UtilService.runRequest(source, arguments);
            };

            /*
             * Helper functions
             */
            this.calculatePageSize = function() {
                if (!angular.element.find('.elements').length) {
                    return 20;
                }

                var unileverAppContainer = jQuery('#unileverApp');
                var offsetTop = unileverAppContainer.offset().top;
                var windowHeight = jQuery(window).height();
                var footerHeight = jQuery('.bPageFooter.noTableFooter').outerHeight();
                var containerPadding = parseInt(jQuery('table.outerNoSidebar').css('padding-bottom'), 10);
                var height = windowHeight - offsetTop - footerHeight - containerPadding;
                var unileverMainContent = jQuery('#unileverApp .main-content');
                if (unileverMainContent.length) {
                    height -= unileverMainContent[0].offsetTop;
                }
                var unileverElements = jQuery('#unileverApp .elements');
                if (unileverElements.length) {
                    height -= unileverElements[0].offsetTop;
                }

                var elementHeight = 47;
                var pageSize = parseInt(height / elementHeight);
                if (pageSize < 0) {
                    pageSize = 0;
                }
                //add more rows to have right scroll if there is enough number of elements
                //display at least 5 rows
                pageSize = pageSize + 5;
                return pageSize;
            };

        }
    ]);
'use strict';
/**
 * @ngdoc service
 * @name unileverApp.UtilService
 * @description
 * # UtilService
 * Service in the unileverApp.
 */
angular.module('unileverApp')
    .service('UtilService', [
        '$window', 'VisualforceRemotingManager', '$q',
        function UtilService($window, VisualforceRemotingManager, $q) {
            var _runRequest = function(source, parameters) {
                var deferred = $q.defer();
                var args = [source];
                for (var i = 0; i < parameters.length; i++) {
                    args.push(parameters[i]);
                }
                args.push(function(data, event) {
                    if (200 !== parseInt(event.statusCode)) {
                        deferred.reject({message: 'Code different than 200', data: data, event: event});
                        return;
                    }

                    if (parseInt(data.status) !== 0) {
                        deferred.reject({message: 'Status is ' + data.status, data: data, event: event});
                    }
                    deferred.resolve(data);
                });
                args.push({
                    escape: false
                });

                VisualforceRemotingManager.invokeAction.apply(VisualforceRemotingManager, args);

                return deferred.promise;
            };

            var _adjustContent = function() {
                var unileverAppContainer = jQuery('#unileverApp');
                var offsetTop = unileverAppContainer.offset().top;
                var windowHeight = jQuery(window).height();
                var footerHeight = jQuery('.bPageFooter.noTableFooter').outerHeight();
                var containerPadding = parseInt(jQuery('table.outerNoSidebar').css('padding-bottom'), 10);
                var height = windowHeight - offsetTop - footerHeight - containerPadding;
                unileverAppContainer.height(height);
                var unileverMainContent = jQuery('#unileverApp .main-content');
                if (unileverMainContent.length) {
                    unileverMainContent.height(height - unileverMainContent[0].offsetTop);
                }
            };

            var _fixedHeader = function($scope) {
                _adjustContent();
                angular.element($window).bind('resize', _adjustContent);
                $scope.$on(
                    '$destroy',
                    function handleDestroyEvent() {
                        angular.element($window).unbind('resize', _adjustContent);
                        var unileverAppContainer = jQuery('#unileverApp');
                        unileverAppContainer.height('auto');
                        var unileverMainContent = jQuery('#unileverApp .main-content');
                        if (unileverMainContent.length) {
                            unileverMainContent.height('auto');
                        }
                    });
            };

            var _listenForMessage = function($scope, callback) {
                var _receiveMessage = function(jEvent) {
                    var event = jEvent.originalEvent;
                    console.warn('document.domain: ' + document.domain);
                    console.warn('event.origin: ' + event.origin);

                    if ($scope.sfConfig.environment === 'SF' && event.origin !== document.location.protocol + '//' + document.domain) {
                        return;
                    }
                    callback(event);
                };

                angular.element($window).bind('message', _receiveMessage);
                $scope.$on(
                    '$destroy',
                    function handleDestroyEvent() {
                        angular.element($window).unbind('message', _receiveMessage);
                    });
            };

            /**
             * LOADING HTML WITH JS AND CSS
             */
            var _loadHTML = function(chatterBoxId, chatterLink, afterLoadCallback, fixScript, errorHandler) {
                var htmlcontent = jQuery(chatterBoxId);
                if (!htmlcontent) {
                    console.log('Error: Cannot load "' + chatterLink + '". Missing element: "' + chatterBoxId + '"');
                    return false;
                }
                var successHandler = function(html) {
                    //load HTML into element
                    htmlcontent[0].innerHTML = html;
                    //get all CSS and Script tags
                    var scriptsCode = [];
                    var cssLinks = {};
                    var scriptLinks = {};
                    var i;
                    for (i = 0; i < document.styleSheets.length; i++) {
                        if (document.styleSheets[i].href) {
                            cssLinks[document.styleSheets[i].href.substring(document.styleSheets[i].href.indexOf(window.location.host)).replace(window.location.hostname, '')] = true;
                        }
                    }
                    for (i = 0; i < document.scripts.length; i++) {
                        if (document.scripts[i].hasAttribute('src')) {
                            scriptLinks[document.scripts[i].hasAttribute('src')] = true;
                        }
                    }
                    //load css from the LINK tag                    
                    htmlcontent.find('link').each(function(idx, el) {
                        //load css only for link tag with href attribute
                        if (el.hasAttribute('href')) {
                            //load CSS file only if it has not been loaded yet
                            if (!cssLinks[el.getAttribute('href')]) {
                                //replace existing link element. It forces browser to load CSS
                                var l = document.createElement('link');
                                l.setAttribute('type', el.getAttribute('type'));
                                l.setAttribute('class', el.getAttribute('class'));
                                l.setAttribute('href', el.getAttribute('href'));
                                l.setAttribute('rel', el.getAttribute('rel'));
                                el.parentNode.insertBefore(l, el);
                                el.parentNode.removeChild(el);
                            }
                        }
                    });
                    //
                    //load scripts
                    //It is complex logic. we support IE >=9 and google chrome
                    //We have to preserve loading order. We download all scripts using ajax request and eval them in global context
                    //If we cannot download script (external domain), we load it using tag script
                    //
                    var scriptCounter = 0;
                    var allScriptCounter = 0;
                    var scriptLoadHandler = function() {
                        scriptCounter--;
                        if (scriptCounter <= 0) {
                            afterLoadCallback();
                            loadInlineScripts();
                        }
                    };
                    var reloadScript = function(el, onload) {
                        var s = document.createElement('script');
                        s.setAttribute('type', 'text/javascript');
                        s.setAttribute('src', el.src);
                        s.async = false;
                        s.defer = false;
                        if (onload) {
                            s.onload = onload;
                        }
                        el.parentNode.insertBefore(s, el);
                        el.parentNode.removeChild(el);
                    };

                    var loadInlineScriptsOnload = function(idx) { 
                        return function() {
                            console.log('load(' + idx + ')');
                            loadInlineScripts(idx + 1);//continue loading scripts
                        };
                    };

                    var loadInlineScripts = function(start) {
                        start = start || 0;
                        if (scriptsCode.length) {
                            console.error('start here');
                            for (var i = start; i < scriptsCode.length; i++) {
                                if (scriptsCode[i]) {
                                    try {
                                        if (scriptsCode[i].src) {
                                            reloadScript(scriptsCode[i], loadInlineScriptsOnload(i));
                                            break;
                                        } else {
                                            jQuery.globalEval(scriptsCode[i].trim());
                                            console.log('load(' + i + ')');
                                        }
                                    } catch (e) {
                                        console.error('globalEval');
                                        console.error(e);
                                    }
                                }
                            }
                        }
                    };

                    var getScriptCallback = function(idx, error) {
                        return function(responseText) {
                            if (error) {
                                //there 99% chance, that we cannot load script, 
                                //because of the same origin policy (AJAX request).
                                //in this case we load it using script tag
                                var s = document.createElement('script');
                                s.setAttribute('type', 'text/javascript');
                                s.setAttribute('src', this.url);
                                s.async = true;
                                s.defer = false;
                                s.onload = scriptLoadHandler;
                                scriptsCode[idx - 1] = s;
                                htmlcontent[0].appendChild(s);

                            } else {
                                scriptsCode[idx - 1] = responseText;
                                scriptLoadHandler();
                            }
                        };
                    };

                    htmlcontent.find('script').each(function(idx, el) {
                        if (el.hasAttribute('src')) {
                            //try to load scripts with src attribute and store its content in array
                            var url = el.getAttribute('src');
                            if (!scriptLinks[url]) {
                                allScriptCounter++;
                                scriptCounter++;
                                jQuery.ajax({
                                    url: url,
                                    type: 'GET',
                                    dataType: 'text',
                                    success: getScriptCallback(allScriptCounter),
                                    error: getScriptCallback(allScriptCounter, true)
                                });
                            }
                        } else {
                            //store inline scripts content in array
                            allScriptCounter++;
                            if (fixScript) {
                                scriptsCode[allScriptCounter - 1] = fixScript(el.innerText || el.textContent || el.text);
                            } else {
                                scriptsCode[allScriptCounter - 1] = el.innerText || el.textContent || el.text;
                            }
                        }
                    });
                    if (scriptsCode.length > 0 && scriptCounter === 0) {
                        afterLoadCallback();
                        loadInlineScripts();
                    }
                };
                jQuery.ajax({
                    url: chatterLink,
                    type: 'GET',
                    success: successHandler,
                    error: errorHandler
                });
            };
            /**
             * END OF LOADING HTML WITH JS AND CSS
             */

            return {
                fixedHeader: _fixedHeader,
                runRequest: _runRequest,
                listenForMessage: _listenForMessage,
                loadHTML: _loadHTML
            };
        }
    ]);
