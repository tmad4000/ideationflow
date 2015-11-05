Template.nav.events
	'click .site-title': ->
		FlowRouter.go '/'

Template.input.onRendered ->
	$(document).keydown (e) ->
		return if e.target.nodeName.toLowerCase() == 'input'
		if 48 <= e.which <= 90 and not e.metaKey and not e.altKey and not e.ctrlKey
			$('#submit').focus()
	Placeprompter $("#submit"), prompts

Template.input.helpers
	placeholder: ->
		Session.get 'placeholder'

Template.input.events
	'keydown #input': (e) ->
		if e.which is 13
			Suggestions.insert
				title: $('#submit').val()
				author: 'Anonymous'
				time: Date.now()
			$('#submit').val('').blur()

Template.output.onCreated ->
	@autorun ->
		FlowRouter.watchPathChange()
		selector =
			_id: FlowRouter.getParam('_id')
		Session.set 'selector', selector

Template.output.helpers
	suggestions: ->
		Suggestions.find Session.get('selector'), {sort: {time: -1}}

Template.output.events
	'click .js-openSuggestion': ->
		FlowRouter.go '/thought/:_id', {_id: @_id}

	'click .js-clearSuggestions': ->
		Meteor.call 'clearSuggestions', {}

	'click .js-nextPlaceholderPrompt': ->
		$('#submit').trigger('placeprompter:nextPlaceholder')

@prompts = [
	"there should be a way to...",
	"it'd be awesome if...",
	"we could improve...",
	"it's frustrating that...",
	"it'd be better if...",
	"it's inconvenient when...",
	"more people should...",
	"we shouldn't be..."
]
