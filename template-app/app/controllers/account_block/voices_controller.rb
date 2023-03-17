module AccountBlock
  class VoicesController < ApplicationController
  	def index
  	  @voices = Voice.all
  	  render json: VoiceSerializer.new(@voices)
                       .serializable_hash, status: :ok
  	end
  end
end
