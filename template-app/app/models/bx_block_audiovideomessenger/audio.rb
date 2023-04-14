module BxBlockAudiovideomessenger
  class Audio < ApplicationRecord
    has_one_attached :recording
    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :conversation, class_name: "BxBlockAudiovideomessenger::Conversation"
  end      
end