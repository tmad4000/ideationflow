###*
# Placeprompter - Animated dynamically-updated placeholder prompts
# v1.0.2 - MIT License
# by Jack Rugile - @jackrugile
# modified by Adam Harris - @adambharris
###

@Placeprompter = (elems, prompts) ->
  'use strict'
  do ->
    lastTime = 0
    vendors = [
      'ms'
      'moz'
      'webkit'
      'o'
    ]
    x = 0
    while x < vendors.length and !window.requestAnimationFrame
      window.requestAnimationFrame = window[vendors[x] + 'RequestAnimationFrame']
      window.cancelAnimationFrame = window[vendors[x] + 'CancelAnimationFrame'] or window[vendors[x] + 'CancelRequestAnimationFrame']
      ++x
    if !window.requestAnimationFrame

      window.requestAnimationFrame = (callback, element) ->
        currTime = (new Date).getTime()
        timeToCall = Math.max(0, 16 - (currTime - lastTime))
        id = window.setTimeout((->
          callback currTime + timeToCall
          return
        ), timeToCall)
        lastTime = currTime + timeToCall
        id

    if !window.cancelAnimationFrame

      window.cancelAnimationFrame = (id) ->
        clearTimeout id
        return

    return
  P = {}
  P.customElems = [ 'password' ]
  P.defaultInputAttributeName = 'data-defaultinputtype'

  P.init = ->
    P.elems = []
    if elems and elems.length
      i = 0
      while i < elems.length
        if P.hasPlaceholder(elems[i])
          P.elems.push new (P.PlaceholdemElem)(elems[i], prompts)
        i++
    else if elems
      if P.hasPlaceholder(elems)
        P.elems.push new (P.PlaceholdemElem)(elems, prompts)
    P.prompts = prompts
    return

  P.hasPlaceholder = (elem) ->
    typeof elem.hasAttribute == 'function'
    #  and elem.hasAttribute('data-placeholder')

  P.PlaceholdemElem = (elem, prompts) ->
    PE = this
    i = 0
    len = prompts.length

    PE.init = ->
      PE.elem = elem
      PE.form = elem.form
      PE.prompts = prompts
      PE.elem.removeAttribute 'placeholder'
      PE.rAF = null
      PE.animating = 0
      PE.defaultInputType = PE.elem.getAttribute('type')
      PE.resetDefaultType()
      if !PE.elem.value
        PE.elem.value = PE.placeholder()
      PE.on PE.elem, 'focus', PE.onFocus
      PE.on PE.elem, 'blur', PE.onBlur
      PE.on PE.elem, 'keydown', PE.onKeydown
      $(elem).on 'placeprompter:nextPlaceholder', PE.nextPlaceholder
      if PE.form
        PE.on PE.form, 'reset', PE.onReset
      return

    PE.placeholder = ->
      PE.prompts[i]

    PE.on = (elem, eventType, handler) ->
      if elem.addEventListener
        elem.addEventListener eventType, handler
      else
        elem.attachEvent 'on' + eventType, handler
      return

    PE.onFocus = ->
      if PE.animating or PE.elem.value == PE.placeholder()
        PE.animating = 1
        window.cancelAnimationFrame PE.rAF
        PE.deletePlaceholder()
        PE.restoreDefaultType()
      return

    PE.onBlur = ->
      if PE.animating or PE.elem.value == ''
        PE.animating = 1
        window.cancelAnimationFrame PE.rAF
        PE.restorePlaceholder()
        PE.resetDefaultType()
      return

    PE.onKeydown = ->
      if PE.animating
        PE.animating = 0
        window.cancelAnimationFrame PE.rAF
        PE.elem.value = ''
      return

    PE.onReset = ->
      setTimeout ->
        PE.onBlur()
        return
      return

    PE.nextPlaceholder = ->
      if PE.elem.value.length > 0
        PE.elem.value = PE.elem.value.slice(0, -1)
        PE.rAF = window.requestAnimationFrame(PE.nextPlaceholder)
      else
        PE.updateIterator()
        PE.animating = 0
        PE.restorePlaceholder()
      return

    PE.updateIterator = ->
      i += 1
      if i >= len
        i = 0

    PE.deletePlaceholder = ->
      if PE.elem.value.length > 0
        PE.elem.value = PE.elem.value.slice(0, -1)
        PE.rAF = window.requestAnimationFrame(PE.deletePlaceholder)
      else
        PE.updateIterator()
        PE.animating = 0
      return

    PE.restorePlaceholder = ->
      if PE.elem.value.length < PE.placeholder().length
        PE.elem.value += PE.placeholder()[PE.elem.value.length]
        PE.rAF = window.requestAnimationFrame(PE.restorePlaceholder)
      else
        PE.animating = 0
      return

    PE.restoreDefaultType = ->
      defaultType = PE.elem.getAttribute(P.defaultInputAttributeName)
      if defaultType and P.customElems.indexOf(defaultType) != -1 and defaultType != PE.elem.getAttribute('type')
        PE.elem.setAttribute 'type', defaultType
      return

    PE.resetDefaultType = ->
      if P.customElems.indexOf(PE.defaultInputType) != -1
        PE.elem.setAttribute P.defaultInputAttributeName, PE.defaultInputType
        PE.elem.setAttribute 'type', 'text'
      return

    PE.init()
    return

  P.init()
  P