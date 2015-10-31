Meteor.methods
	'clearSuggestions': (filter) ->
		Suggestions.remove(filter)