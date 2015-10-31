Template.nav.events
	'click .site-title': (e) ->
		$('#submit').val('').focus()

Template.input.onRendered ->
	$(document).keydown (e) ->
		return if e.target.nodeName.toLowerCase() == 'input'
		if 48 <= e.which <= 90 and not e.metaKey and not e.altKey and not e.ctrlKey
			$('#submit').focus()

Template.input.events
	'keydown #input': (e) ->
		if e.which is 13
			Suggestions.insert
				title: $('#submit').val()
				time: Date.now()
			$('#submit').val('').blur()

Template.output.helpers
	suggestions: ->
		suggestions = Suggestions.find({}, {sort: {time: -1}}).fetch()
		if suggestions.length is 0
			return [{title: 'Be the first to make a suggestion!'}]
		else
			return suggestions

Template.output.events
	'click .js-clearSuggestion': ->
		Meteor.call 'clearSuggestions', @

	'click .js-clearSuggestions': ->
		Meteor.call 'clearSuggestions', {}