TiProject.Views.Courses ||= {}

class TiProject.Views.Courses.SkripsiView extends Backbone.View
  template: JST["backbone/templates/courses/skripsi"]
  
  className: "panel panel-primary"

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
