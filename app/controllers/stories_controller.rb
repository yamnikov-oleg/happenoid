class StoriesController < ApplicationController
  include ApplicationHelper

  before_action :set_story, only: [:show, :edit, :update, :destroy]

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

    case mode
    when :html
      @story = Story.new(story_params)
    when :json
      json = params[:json]
      parse_from_json JSON.load json
    when :external

    end

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.json { render :show, status: :created, location: @story }
      else
        format.html { render :new }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stories/1
  # PATCH/PUT /stories/1.json
  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.json { render :show, status: :ok, location: @story }
      else
        format.html { render :edit }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to stories_url, notice: 'Story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:title, :rating, :text)
    end

    def parse_from_json object
      @story = Story.new

      if object.nil? 
        return
      end

      @story.title = object["title"]
      @story.rating = object["rating"]
      @story.text = object["text"]

      tags = object["tags"]

      tags.each do |tag|
        short = tag["url"]
        if short.nil?
          continue
        end
        short = short.split("/").last

        tag_model = Tag.find_by(short: short)

        if tag_model.nil? 
          tag_model = Tag.new(short: short, full: tag["name"])
          tag_model.save
        end

        @story.tags << tag_model
      end

      now = Time.new
      time = object["date"]

      if time

        time = time.split ", "
        time[0] = Unicode::downcase(time[0])

        # working with date part
        if time[0] == "сегодня"
          day = now.day
          month = now.month
          year = now.year
        elsif time[0] == "вчера"
          now -= 1.day

          day = now.day
          month = now.month
          year = now.year
        else
          date = time[0].split

          day = date[0].to_i
          month = parse_month date[1]

          if date.size > 2
            year = date[2].to_i
          else
            year = now.year
          end

        end

        # working with time part
        time = time[1].split ':'
        hour = time[0].to_i
        minute = time[1].to_i

      else # if time
        day = now.day
        month = now.month
        year = now.year

        hour = now.hour
        minute = now.min
      end

      created_at = Time.utc(year, month, day, hour, minute);
      @story.created_at = created_at

    end

end
