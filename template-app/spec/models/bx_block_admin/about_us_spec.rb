require 'rails_helper'

RSpec.describe BxBlockAdmin::AboutUs, type: :model do
	describe 'validates' do
	  it { should validate_presence_of(:description) }
	end
end
