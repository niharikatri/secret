module AccountBlock
  class Character < AccountBlock::ApplicationRecord
  	self.table_name = :characters
  	has_one_attached :image
  	validates :name, presence: true, uniqueness: true

  end
end
