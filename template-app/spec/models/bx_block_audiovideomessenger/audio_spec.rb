require 'rails_helper'

RSpec.describe BxBlockAudiovideomessenger::Audio, type: :model do
  context "Associations" do
    it { should belong_to(:account).class_name("AccountBlock::Account") }
    it { should belong_to(:conversation).class_name("BxBlockAudiovideomessenger::Conversation") }
    it { should have_one_attached(:recording)}
  end
end

