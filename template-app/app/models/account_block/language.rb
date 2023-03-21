module AccountBlock
	class Language < AccountBlock::ApplicationRecord
		self.table_name = :languages
		validates :code, :name, presence: true
	end
end
