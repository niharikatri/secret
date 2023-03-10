module AccountBlock
  class VoiceSerializer < BuilderBase::BaseSerializer
    attributes(:name)

    attribute :audio do |object, params|
    	if object.audio.present?
    	    Rails.application.routes.url_helpers.rails_blob_url(object.audio, only_path: true)
    	end    
    end

  end
end
