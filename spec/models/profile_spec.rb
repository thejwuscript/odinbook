require 'rails_helper'

RSpec.describe Profile, type: :model do
  before do
    User.skip_callback(:create, :after, :create_profile)
  end

  after do
    User.set_callback(:create, :after, :create_profile, unless: :omniauth_provider?)
  end

  context 'when an avatar is not attached' do
    it 'does not add an error message to the comment object' do
      profile = create(:profile)
      result = profile.errors.messages.empty?
      expect(result).to be true
    end
  end

  context 'when trying to attach an avatar in a non-acceptable format' do
    subject(:profile) { create(:profile) }

    before do
      file = Rails.root.join('spec/support/assets/texts.md')
      profile.avatar.attach(
        io: File.open(file),
        filename: 'texts.md',
        content_type: 'text/markdown'
      )
    end

    it 'adds an error message to the Profile instance' do
      message = profile.errors.messages_for(:avatar).first
      expect(message).to eq('Needs to be an image in .jpeg or .png format')
    end

    it 'removes the attachment' do
      expect(profile.avatar.attached?).to be false
    end
  end

  context 'when trying to attach an avatar in an acceptable format' do
    subject(:profile) { create(:profile) }

    before do
      # image from https://www.freeiconspng.com/img/23485
      file = Rails.root.join('spec/support/assets/generic_image.png')
      profile.avatar.attach(
        io: File.open(file),
        filename: 'generic_image.png',
        content_type: 'image/png'
      )
    end

    it 'completes the attachment' do
      expect(profile.avatar.attached?).to be true
    end
  end
end
