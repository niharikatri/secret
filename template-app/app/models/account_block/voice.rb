module AccountBlock
  class Voice < AccountBlock::ApplicationRecord
  	self.table_name = :voices
  	has_one_attached :audio
  	validates :name, presence: true, uniqueness: true
  	validates :audio, attached: true, content_type: { in: [ 'audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio', 'audio/wav' ], message: "Please select audio file." }
  end
end
