require 'rails_helper'

RSpec.describe 'Log in', type: :system do
  subject(:user) { create(:user) }

  context 'when the user fills in the correct credentials' do
    it 'logs in user and redirects to homepage', :aggregate_failures do
      VCR.use_cassette "news headlines" do
        visit root_path
        fill_in "user_login", with: user.login
        fill_in "user_password", with: user.password
        click_on "Log in"
        expect(page).to have_current_path(root_path)
        expect(page).to have_content('Signed in successfully.')
      end
    end
  end

  context 'when the user fills in the wrong credentials' do
    it 'displays an error flash message on the same page', :aggregate_failures do
      visit root_path
      fill_in "user_login", with: "kiekdos"
      fill_in "user_password", with: "aaaaaaaa"
      click_on "Log in"
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content('The provided login credentials were invalid.')
    end
  end
end