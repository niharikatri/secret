module BxBlockAudiovideomessenger
  class Conversation < ApplicationRecord
    has_many :audios, class_name: "BxBlockAudiovideomessenger::Audio"
    has_many :accounts, through: :audios, class_name: "AccountBlock::Account"
  end
end
