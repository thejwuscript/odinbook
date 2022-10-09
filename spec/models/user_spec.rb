require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject(:user) { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_confirmation_of(:password) }

    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.to validate_uniqueness_of(:username) }

    it { is_expected.to validate_length_of(:email).is_at_most(50) }
    it { is_expected.to validate_length_of(:username).is_at_most(50) }
    it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(128) }
  end
end
