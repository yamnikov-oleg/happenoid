class Story < ActiveRecord::Base
	has_and_belongs_to_many :tags

	validates :title, presence: true
	validates :text, presence: true
	validates :tags, presence: true
end
