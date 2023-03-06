module BxBlockTermsandconditions
	class TermsAndConditionsController < ApplicationController
    skip_before_action :validate_json_web_token, only: %i[index], raise: false
    def index
      unless BxBlockTermsandconditions::TermsAndCondition.exists?
        return render json: { message: 'Terms and Conditions not found'}, status: :not_found
      end
      serializer = TermsAndConditionsSerializer.new(TermsAndCondition.all)
      render json: serializer.serializable_hash,
             status: :ok
    end
	end
end
