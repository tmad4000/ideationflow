Meteor.methods
	'clearSuggestions': (selector) ->
		Suggestions.remove(selector)
