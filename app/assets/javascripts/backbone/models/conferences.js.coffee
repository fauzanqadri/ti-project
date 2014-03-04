class TiProject.Models.Conference extends Backbone.Model
	paramRoot: 'conference'

	url: =>
		return "/conferences/" + @id

	toFullJSON: =>
		_.clone(@attributes)

	toJSON: =>
		data = _.pick(@attributes, 'start', 'end', 'local', 'department_director_approval', 'examiners_attributes')
		return data

	toEventData: =>
		data = _.pick(@attributes, 'id', 'start', 'end', 'color')
		if typeof(@attributes) isnt 'undefinded'
			local = (if not @attributes.local? then "-" else @attributes.local)
			data["title"] = @attributes.type+" "+local
			if @attributes.start isnt null
				data["allDay"] = false
			else
				data["allDay"] = true
				
		return data

class TiProject.Models.Seminar extends TiProject.Models.Conference
	paramRoot: 'conference'

class TiProject.Models.Sidang extends TiProject.Models.Conference
	paramRoot: 'sidang'

class TiProject.Collections.ConferenceCollections extends Backbone.Collection
	model: TiProject.Models.Conference

	parse: (data) ->
		return data.aaData