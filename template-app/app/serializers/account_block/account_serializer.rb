module AccountBlock
  class AccountSerializer < BuilderBase::BaseSerializer
    attributes(:activated, :country_code, :email, :first_name, :full_phone_number, :last_name, :phone_number, :type, :created_at, :updated_at, :device_id, :unique_auth_id, :date_of_birth, :gender, :autoplay_setting, :reply_audio_setting, :is_terms_and_conditions_accepted, :equalizer_profile, :profile_pic)

    attribute :country_code do |object|
      country_code_for object
    end

    attribute :phone_number do |object|
      phone_number_for object
    end

    attribute :character do |object|
      CharacterSerializer.new(object.character).serializable_hash
    end

    attribute :voice do |object|
      VoiceSerializer.new(object.voice).serializable_hash
    end

    attribute :language do |object|
      LanguageSerializer.new(object.language).serializable_hash
    end

    attribute :Role do |object|
      BxBlockRolesPermissions::RoleSerializer.new(object.role).serializable_hash
    end
    
    attribute :profile_pic do |object, params|
      
      if object.profile_pic.present?
          Rails.application.routes.url_helpers.rails_blob_url(object.profile_pic, only_path: true)
      end    
    end


    class << self
      private

      def country_code_for(object)
        return nil unless Phonelib.valid?(object.full_phone_number)
        Phonelib.parse(object.full_phone_number).country_code
      end

      def phone_number_for(object)
        return nil unless Phonelib.valid?(object.full_phone_number)
        Phonelib.parse(object.full_phone_number).raw_national
      end
    end
  end
end
