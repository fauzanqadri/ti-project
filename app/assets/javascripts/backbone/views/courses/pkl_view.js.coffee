TiProject.Views.Courses ||= {}

class TiProject.Views.Courses.PklView extends Backbone.View
  template: JST["backbone/templates/courses/pkl"]

  className: "panel panel-success"

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
