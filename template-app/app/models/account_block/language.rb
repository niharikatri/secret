module AccountBlock
	class Language < AccountBlock::ApplicationRecord
		self.table_name = :languages
		validates :code, :name, presence: true
		validates :name, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }, length: {maximum: 30}
		validates :code, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
	end
end
