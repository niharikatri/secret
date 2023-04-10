module BxBlockAudiovideomessenger 
  class ConversationsController < ApplicationController
    def index
      @conversations = current_account.conversations
      render json: @conversations
    end
    
    def create
      @conversation = Conversation.create
      @conversation.accounts << AccountBlock::Account.find(JSON.parse(params[:account_ids]))
      render json: @conversation, status: :created
    end
    
    def show
      @conversation = Conversation.find(params[:id])
      @audios = @conversation.audios
      render json: @conversation
    end
      
    private

    def current_account
      account_id = BuilderJsonWebToken::JsonWebToken.decode(params[:token]).id
      AccountBlock::Account.find(account_id) 
    end
  end 
end
