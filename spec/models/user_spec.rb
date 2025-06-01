RSpec.describe User, type: :model do
  subject { create(:user) }

  it { should have_many(:messages).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(3).is_at_most(255) }

  it { should validate_presence_of(:username) }
  it { should validate_length_of(:username).is_at_least(5).is_at_most(50) }
  it { should validate_uniqueness_of(:username) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  it do
    should validate_length_of(:password).is_at_least(20).is_at_most(100).on(:create)
  end
end
