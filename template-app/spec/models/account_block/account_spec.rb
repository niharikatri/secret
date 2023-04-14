require 'rails_helper'

RSpec.describe AccountBlock::Account, type: :model do
    context "Associations" do
        it { should have_many(:audios).class_name("BxBlockAudiovideomessenger::Audio") }
        it { should have_many(:conversations).class_name("BxBlockAudiovideomessenger::Conversation") }
      end
end
