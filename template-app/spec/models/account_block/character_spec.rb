require 'rails_helper'

RSpec.describe AccountBlock::Character, type: :model do
	it {is_expected.to have_one_attached(:image)}
end
