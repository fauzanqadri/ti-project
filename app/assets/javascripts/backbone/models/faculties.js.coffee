class TiProject.Models.Faculty extends Backbone.Model
	paramRoot: 'faculty'

class TiProject.Collections.FacultiesCollection extends Backbone.Collection
	model: TiProject.Models.Faculty
	url: '/get_faculties'