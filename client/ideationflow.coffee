Template.input.onRendered ->
	setEndOfContenteditable(document.getElementById('input'))

Template.input.events
	'keydown #input': (e) ->
		if e.which is 13
			console.log 'submit!'


@setEndOfContenteditable = (contentEditableElement) ->
  range = undefined
  selection = undefined
  if document.createRange
    range = document.createRange()
    #Create a range (a range is a like the selection but invisible)
    range.selectNodeContents contentEditableElement
    #Select the entire contents of the element with the range
    range.collapse false
    #collapse the range to the end point. false means collapse to end rather than the start
    selection = window.getSelection()
    #get the selection object (allows you to change selection)
    selection.removeAllRanges()
    #remove any selections already made
    selection.addRange range
    #make the range you have just created the visible selection
  else if document.selection
    range = document.body.createTextRange()
    #Create a range (a range is a like the selection but invisible)
    range.moveToElementText contentEditableElement
    #Select the entire contents of the element with the range
    range.collapse false
    #collapse the range to the end point. false means collapse to end rather than the start
    range.select()
    #Select the range (make it the visible selection