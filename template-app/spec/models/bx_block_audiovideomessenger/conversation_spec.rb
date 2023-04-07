require 'rails_helper'

RSpec.describe BxBlockAudiovideomessenger::Conversation, type: :model do
  context "Associations" do
    it { should have_many(:accounts).class_name("AccountBlock::Account") }
    it { should have_many(:audios).class_name("BxBlockAudiovideomessenger::Audio") }
  end
end