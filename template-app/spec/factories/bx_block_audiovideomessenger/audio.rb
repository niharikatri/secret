FactoryBot.define do
  factory :audio, class: BxBlockAudiovideomessenger::Audio do
    conversation_id {"1"}
    recording {Rack::Test::UploadedFile.new(Rails.root.join('app/assets/audio/test_audio.wav'))}
  end
end