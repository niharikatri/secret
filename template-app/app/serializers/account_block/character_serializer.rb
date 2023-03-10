module AccountBlock
  class CharacterSerializer < BuilderBase::BaseSerializer
    attributes(:name)

    attribute :image do |object, params|
    	if object.image.present?
    	    Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true)
    	end    
    end

  end
end
