require 'rails_helper'

RSpec.describe Profile, type: :model do
  before do
    User.skip_callback(:create, :after, :create_profile)
  end

  after do
    User.set_callback(:create, :after, :create_profile, unless: :facebook_provider?)
  end

  context 'when an avatar is not attached' do

    it 'does not add an error message to the comment object' do
      profile = create(:profile)
      result = profile.errors.messages.empty?
      expect(result).to be true
    end
  end

  # context 'when an avatar is attached but not in the accepted format' do
  #   subject(:profile) { create(:profile) }

  #   it 'adds an error message' do
  #     file = double('image_file', size: 0.2.megabytes, content_type: :pdf, original_filename: "some_file")
  #     allow(profile).to receive(:avatar).and_return(file)
  #     expect(profile.errors.messages).to be true
  #   end
  # end
end
