class Tag < ActiveRecord::Base
	has_and_belongs_to_many :stories

	validates :short, uniqueness: true
	validates :full, uniqueness: true

	def to_param
		short
	end
end
