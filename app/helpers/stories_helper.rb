require 'open-uri'

module StoriesHelper

	def parse_month month_string
		case month_string[0..2]
		when 'янв'
			return 1
		when 'фев'
			return 2
		when 'мар'
			return 3
		when 'апр'
			return 4
		when 'май'
			return 5
		when 'мая'
			return 5
		when 'июн'
			return 6
		when 'июл'
			return 7
		when 'авг'
			return 8
		when 'сен'
			return 9
		when 'окт'
			return 10
		when 'ноя'
			return 11
		when 'дек'
			return 12
		else
			return -1
		end
	end

	def parse_json_tags tags_array

		tags = []

		tags_array.each do |tag|
			short = tag["url"]
			if short.nil?
				next
			end
			short = short.split("/").last

			tag_model = Tag.find_by(short: short)

			if tag_model.nil? 
				tag_model = Tag.new(short: short, full: tag["name"])
				unless tag_model.save
					tag_model = nil
				end
			end

			unless tag_model.nil?
				tags << tag_model
			end

		end

		return tags

	end

	def parse_time time 

		now = Time.new

		if time.nil?
			return now
		end

		time = time.split ", "

		time[0] = Unicode::downcase time[0] 

    # working with date part
    if time[0] == "сегодня"
    	time_hash[:day] = now.day
    	time_hash[:month] = now.month
    	time_hash[:year] = now.year
    elsif time[0] == "вчера"
    	now -= 1.day

    	time_hash[:day] = now.day
    	time_hash[:month] = now.month
    	time_hash[:year] = now.year
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

    created_at = Time.utc(year, month, day, hour, minute);

  end

  def parse_from_json object

  	story = Story.new

  	if object.nil? 
  		return story
  	end

  	story.title = object["title"]
  	story.rating = object["rating"]
  	story.text = object["text"]
  	story.tags = parse_json_tags object["tags"]
		story.created_at = parse_time object["date"]

  	return story

  end

  def build_number_collection numbers
  	collection = []
  	numbers = numbers.split ','
  	numbers.each do |number|
  		if number.include? '-'
  			range = number.split '-'
  			first = range[0].to_i
  			last = range[1].to_i

  			first.upto last do |x|
  				if x > 0 and !(collection.include? x)
  					collection << x
  				end
  			end
  		else
  			x = number.to_i
  			if x > 0 and !(collection.include? x)
  				collection << x
  			end
  		end
  	end

  	return collection
  end

  def parse_external_story id
  	page_url = "http://ithappens.me/story/#{id}"
    document = Nokogiri::HTML(open(page_url))
    element = document.css('.story')

    story = Story.new

    story.title = element.css('h1').text.strip
    story.created_at = parse_time element.css('.date-time').text.strip
    story.rating = element.css('.rating').text.to_i

    tags = element.css('.tags a')
    tags_hash = []
    tags.each do |tag|
        tags_hash.push({"name" => tag.text.strip, "url" => tag[:href].split("/").last })
    end
    story.tags = parse_json_tags tags_hash

    story.text = element.css('.text').text.strip
    story.save

    return story
end

  def parse_external numbers
  	numbers = build_number_collection numbers

  	numbers.each do |num|
  		parse_external_story num
  	end

  	return numbers
  end

end
