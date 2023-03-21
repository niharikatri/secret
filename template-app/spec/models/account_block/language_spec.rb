require 'rails_helper'

RSpec.describe AccountBlock::Language, type: :model do
	it { should validate_presence_of(:code) }
	it { should validate_presence_of(:name) }
end
