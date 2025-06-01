require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:user) }

  it { should validate_presence_of(:text) }
  it { should validate_length_of(:text).is_at_most(1000) }
end
