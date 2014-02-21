class TiProject.Models.Post extends Backbone.Model
  paramRoot: 'post'

  defaults:
    title: null
    content: null

class TiProject.Collections.PostsCollection extends Backbone.Collection
  model: TiProject.Models.Post
  url: '/posts'
