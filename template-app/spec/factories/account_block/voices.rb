FactoryBot.define do
  factory :voice, class: 'AccountBlock::Voice' do
  	name {"Test"}
  	audio {Rack::Test::UploadedFile.new(Rails.root.join('app/assets/audio/test_audio.wav'))}
  end
end
