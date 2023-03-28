module AccountBlock
  class VoicesController < ApplicationController
  	def index
  	  @voices = Voice.all
  	  render json: VoiceSerializer.new(@voices, serialization_options)
                       .serializable_hash, status: :ok
  	end
  	
  	private

  	def serialization_options
  		{params: {host: request.protocol + request.host_with_port} }
  	end
  end
end
