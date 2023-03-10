require 'rails_helper'

RSpec.describe AccountBlock::EmailAccount, type: :model do
  
  describe 'Validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
    
end