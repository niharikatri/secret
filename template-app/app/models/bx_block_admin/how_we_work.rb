class BxBlockAdmin::HowWeWork < ApplicationRecord
	self.table_name = :how_we_works
	validates :description, presence: true
end
