class BxBlockAdmin::PrivacyPolicy < ApplicationRecord
	self.table_name = :privacy_policies
	validates :description, presence: true
end
