class StoriesController < ApplicationController
  include StoriesHelper

  before_action :set_story, only: [:show, :edit, :update, :destroy, :verify, :like]
  before_filter :admin_only!, only: [:edit, :update, :destroy, :unverified, :verify]

  # GET /stories
  # GET /stories.json
  def index
    page = 1
    if params['page']
      page = params['page'].to_i
    end

    @stories = Story.where(verified: true).order(created_at: :desc).limit(12).offset((page-1)*12)
    if params['ajax']
      render 'index', layout: nil
    end
  end

  def unverified
    @stories = Story.where verified: false
  end

  def verify
    @story.verified = true
    @story.save
    redirect_back_or_to @story
  end

  def like
    unless session["liked#{@story.id}"]
      @story.rating += 1
      @story.save
      session["liked#{@story.id}"] = true
    end
    render json: {story: @story.id, rating: @story.rating}
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    unless @story.verified or admin?
      restricted_redirect
    end
  end

  # GET /stories/new
  def new
    @tags = Tag.all
    @tags = @tags.sort {|a, b| Unicode::strcmp(a.full,b.full)}
    @story = Story.new
  end

  # GET /stories/1/edit
  def edit
    @tags = Tag.all
    @tags = @tags.sort {|a, b| Unicode::strcmp(a.full,b.full)}
  end

  # POST /stories
  # POST /stories.json
  def create
    mode = :html
    if params[:mode] == "json"
      mode = :json
    elsif params[:mode] == "external"
      mode = :external
    end

    unless admin?
      mode = :html
    end

    case mode
    when :html
      @story = Story.new(story_params)

      params['story']['tag'].each do |tag_short|
        tag = Tag.find_by_short(tag_short)
        unless tag.nil? 
          @story.tags << tag
        end
      end

      unless admin?
        @story.text = ERB::Util.h @story.text
      end

      @story.text.gsub! /\n+/, "</p><p>"
      @story.text = "<p>#{@story.text}</p>"
      
      @story.verified = admin?
    when :json
      json = params[:json]
      @story = parse_from_json JSON.load json
      @story.verified = true
    when :external
      numbers = params[:numbers]
      numbers = parse_external numbers
      redirect_to stories_url
      return
    end

    if @story.save
      redirect_to stories_path, notice: 'Story was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /stories/1
  # PATCH/PUT /stories/1.json
  def update
    @story.tags.destroy_all
    params['story']['tag'].each do |tag_short|
      tag = Tag.find_by_short(tag_short)
      unless tag.nil? 
        @story.tags << tag
      end
    end
    if @story.update(story_params)
      redirect_to @story, notice: 'Story was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story.destroy
    redirect_to stories_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:title, :text)
    end

end
