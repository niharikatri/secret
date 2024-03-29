module AccountBlock
  class Character < AccountBlock::ApplicationRecord
  	self.table_name = :characters
  	has_one_attached :image
  	validates :name, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }, presence: true, uniqueness: true, length: {maximum: 40}
  	validates :image, attached: true, content_type: {in: ['image/png', 'image/jpeg, image/gif', 'gif'], message: "Please select image or gif." }
  end
end
