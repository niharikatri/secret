require 'rails_helper'

RSpec.describe BxBlockRolesPermissions::Role, type: :model do
  describe 'validates' do
    it { should validate_presence_of(:name) }
  end
end
