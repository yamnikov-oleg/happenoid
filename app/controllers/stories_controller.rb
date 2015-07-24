class StoriesController < ApplicationController
  include StoriesHelper

  before_action :set_story, only: [:show, :edit, :update, :destroy]
  before_filter :admin_only!, only: [:edit, :update, :destroy]

  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.all
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
  end

  # GET /stories/new
  def new
    @story = Story.new
  end

  # GET /stories/1/edit
  def edit
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
    when :json
      json = params[:json]
      @story = parse_from_json JSON.load json
    when :external
      numbers = params[:numbers]
      numbers = parse_external numbers
      redirect_to stories_url
      return
    end

    if @story.save
      redirect_to @story, notice: 'Story was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /stories/1
  # PATCH/PUT /stories/1.json
  def update
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
