class TiProject.Models.Department extends Backbone.Model
	paramRoot: 'department'

class TiProject.Collections.DepartmentsCollection extends Backbone.Collection
	model: TiProject.Models.Department