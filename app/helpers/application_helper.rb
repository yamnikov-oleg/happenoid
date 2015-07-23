module ApplicationHelper

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
		when 'авн'
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

end
