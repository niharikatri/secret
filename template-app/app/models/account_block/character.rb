module AccountBlock
  class Character < AccountBlock::ApplicationRecord
  	self.table_name = :characters
  	has_one_attached :image
  	validates :name, presence: true, uniqueness: true
  	validates :image, attached: true, content_type: {in: ['image/png', 'image/jpeg, image/gif'], message: "Please select image or gif." }
  end
end
