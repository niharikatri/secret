module AccountBlock
  class LanguagesController < ApplicationController
  	def index
  	  @languages = Language.all
  	  render json: LanguageSerializer.new(@languages)
                       .serializable_hash, status: :ok
  	end
  end
end

