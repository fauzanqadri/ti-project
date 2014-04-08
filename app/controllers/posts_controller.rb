class PostsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:create]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :publish]

  # GET /posts
  # GET /posts.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: PostsDatatable.new(view_context) }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = current_user.userable.posts.build
    respond_to do |format|
      format.js
    end
  end

  # GET /posts/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.userable.posts.build(post_params)

    respond_to do |format|
      if @post.save
        flash[:notice] = "Record berita berhasil dibuat, #{undo_link(@post)}"
        format.js
      else
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        flash[:notice] = "Record berita berhasil diubah, #{undo_link(@post)}"
        format.js
      else
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      flash[:notice] = "Record berita berhasil dihapus, #{undo_link(@post)}"
      format.html { redirect_to posts_url }
    end
  end

  def publish
    if @post.set_publish_status
      redirect_to :back, :notice => "Setatus berita berhasil di ubah, #{undo_link(@post)}"
    else
      redirect_to :back, :alert => "Hmmmh,, Somethings not right here, contact developer"
    end
  end

  def news
    respond_to do |format|
      format.html
      format.json {render json: NewsDatatable.new(view_context)}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :content, :boundable_type, :boundable_id)
  end
end
