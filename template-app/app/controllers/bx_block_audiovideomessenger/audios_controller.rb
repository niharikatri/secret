module BxBlockAudiovideomessenger
  class AudiosController < ApplicationController
    def create
      @conversation = Conversation.find(params[:conversation_id])
      @audio = @conversation.audios.build(audio_params)
      @audio.account = current_account
      @audio.recording.attach(params[:recording]) 
      @audio.save
      render json: @audio, status: :created
    end
      
    private
      
    def audio_params
      params.permit(:recording)
    end   

    def current_account
      account_id = BuilderJsonWebToken::JsonWebToken.decode(params[:token]).id
      AccountBlock::Account.find(account_id) 
    end    
  end
end
  