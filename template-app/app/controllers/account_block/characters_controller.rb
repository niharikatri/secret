module AccountBlock
  class CharactersController < ApplicationController
  	def index
  	  @characters = Character.all
  	  render json: CharacterSerializer.new(@characters)
                       .serializable_hash, status: :ok
  	end
  end
end
