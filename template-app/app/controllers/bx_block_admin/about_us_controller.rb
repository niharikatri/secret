module BxBlockAdmin
  class AboutUsController < ApplicationController
  	def index
  	  unless AboutUs.exists?
  	    return render json: { message: 'About Us not found'}, status: :not_found
  	  end
  	  render json: AboutUsSerializer.new(AboutUs.all)
                       .serializable_hash, status: :ok
  	end
  end
end
