require 'rails_helper'

RSpec.describe AccountBlock::Voice, type: :model do
	it {is_expected.to have_one_attached(:audio)}
end
