module AccountBlock
  class Voice < AccountBlock::ApplicationRecord
  	self.table_name = :voices
  	has_one_attached :audio
  	validates :name, presence: true, uniqueness: true

  end
end
