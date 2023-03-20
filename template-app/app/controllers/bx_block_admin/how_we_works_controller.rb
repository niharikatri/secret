module BxBlockAdmin
  class HowWeWorksController < ApplicationController
  	def index
  	  unless HowWeWork.exists?
  	    return render json: { message: 'How We Work not found'}, status: :not_found
  	  end
  	  render json: HowWeWorkSerializer.new(HowWeWork.all)
                       .serializable_hash, status: :ok
  	end
  end
end
