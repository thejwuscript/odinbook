require 'rails_helper'

RSpec.describe 'Sign up', type: :system do
  let(:headline1) { create(:headline) }
  let(:headline2) { create(:headline) }
  let(:headline3) { create(:headline) }

  before do
    allow(Headline).to receive(:create).and_return(headline1, headline2, headline3)
    stub_request(:get, /newsapi.org/).to_return(status: 200,
                                                body: File.read(Rails.root.join('spec/support/assets/response.json')))
  end

  context 'when the user enters and submits valid credentials' do
    before do
      visit root_path
      click_on 'Create new account'
      fill_in 'user_username', with: 'test_user'
      fill_in 'user_email', with: 'test_user@example.com'
      fill_in 'user_password', with: '123456'
      fill_in 'user_password_confirmation', with: '123456'
      click_on 'Sign up'
    end

    it 'signs up successfully and redirects to homepage', :aggregate_failures do
      expect(page).to have_current_path(root_path)
      expect(page).to have_content('Welcome! You have signed up successfully.')
    end
  end

  context 'when the user enter an invalid email format' do
    before do
      visit root_path
      click_on 'Create new account'
      fill_in 'user_username', with: 'test_user'
      fill_in 'user_email', with: 's'
      fill_in 'user_password', with: '123456'
      fill_in 'user_password_confirmation', with: '123456'
      click_on 'Sign up'
    end

    it 'shows a warning pop up message' do
      message = page.find('#user_email').native.attribute('validationMessage')
      expect(message).to include("Please include an '@' in the email address.")
    end
  end

  context 'when the user does not fill in username and password fields' do
    before do
      visit root_path
      click_on 'Create new account'
      fill_in 'user_email', with: 'test_user@example.com'
      click_on 'Sign up'
    end

    it 'shows error messages corresponding to the invalid fields', :aggregate_failures do
      expect(page).to have_content("Username can't be blank")
      expect(page).to have_content("Password can't be blank")
    end

    it 'revalidates and updates error messages accordingly', :aggregate_failures do
      fill_in 'user_password', with: '123'
      click_on 'Sign up'
      expect(page).to have_content('Password is too short')
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end
