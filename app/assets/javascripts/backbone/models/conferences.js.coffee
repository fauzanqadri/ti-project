class TiProject.Models.Conference extends Backbone.Model
	toFullJSON: =>
		_.clone(@attributes)

	toJSON: =>
		data = _.pick(@attributes, 'start', 'end', 'local', 'department_director_approval')
		if @attributes.type == "Sidang"
			examiner = []
			_.each @attributes.examiners_attributes, (item) ->
				examiner.push(_.pick(item, 'id', 'lecturer_id'))
				data['examiners_attributes'] = examiner
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
	model: (attr, opt)=>
		if attr.type == "Seminar"
			return new TiProject.Models.Seminar(attr, opt)
		else
			return new TiProject.Models.Sidang(attr, opt)
		
	url: "/conferences"