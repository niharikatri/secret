module BxBlockAdmin
  class PrivacyPoliciesController < ApplicationController
  	def index
  	  unless PrivacyPolicy.exists?
  	    return render json: { message: 'Privacy Policies not found'}, status: :not_found
  	  end
  	  render json: PrivacyPolicySerializer.new(PrivacyPolicy.all)
                       .serializable_hash, status: :ok
  	end
  end
end
