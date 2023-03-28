module AccountBlock
  class CharactersController < ApplicationController
  	def index
  	  @characters = Character.all
  	  render json: CharacterSerializer.new(@characters, serialization_options)
                       .serializable_hash, status: :ok
  	end

  	private

  	def serialization_options
  		{params: {host: request.protocol + request.host_with_port} }
  	end
  end
end
