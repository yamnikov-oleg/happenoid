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
				continue
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

end
